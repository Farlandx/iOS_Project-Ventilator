//
//  WebAPI.m
//  呼吸照護
//
//  Created by Farland on 2014/5/30.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "WebAPI.h"
#import "User.h"
#import "Patient.h"
#import "HistoryRoomData.h"
#import "VentilationData.h"
#import "RespiratoryRecord.h"

#ifndef ___webapi
#define ___webapi

#define API_GET_USERS @"api/user"
#define API_GET_PATIENTS @"api/patient"
#define API_GET_HISTORY @"api/ward/%@/patient?startdate=%@&enddate=%@" //病房, startdate=2011/1/1, enddate=2015/1/1
#define API_UPLOAD @"api/respiratory/"
#define API_GET_RESPIRATORY_BY_PATIENTS @"api/respiratory/%@?startdate=%@&enddate=%@" //patientId, startdate=2011/1/1, enddate=2015/1/1
#define API_REQUEST_TIMEOUT_INTERVAL 10. //Second

#define HISTORY_DAY -3

#endif

@implementation WebAPI
static NSString *_serverPath;

- (id)initWithServerPath:(NSString *)serverPath {
    _serverPath = serverPath;
    return [self init];
}

- (void)dealloc {
    _delegate = nil;
}

+ (void)setServerPath:(NSString *)serverPath {
    _serverPath = serverPath;
}

- (NSString *)getValue:(id)value {
    if (value != [NSNull null] && value != nil) {
        return value;
    }
    return @"";
}

#pragma mark - Upload
- (void)uploadVentData:(NSData *)jsonData patientId:(NSString *)patientId measureId:(NSInteger)measureId{
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", jsonString);
    NSURL *url = [NSURL URLWithString:[[_serverPath stringByAppendingString:API_UPLOAD] stringByAppendingString:patientId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:API_REQUEST_TIMEOUT_INTERVAL];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", [jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if ([httpResponse statusCode] == 200) {
            [_delegate uploadDone:measureId];
        }
        else {
            [_delegate uploadError:measureId];
        }
    }];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData length:%ld", data.length);
}

#pragma mark - User
- (void)getUserList {
    NSURL *url = [NSURL URLWithString:[_serverPath stringByAppendingString:API_GET_USERS]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:API_REQUEST_TIMEOUT_INTERVAL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        if (data.length > 0 && connectionError == nil) {
            NSError *error = nil;
            @try {
                for (NSDictionary *dict in [[NSJSONSerialization JSONObjectWithData:data options:0 error:&error] valueForKey:@"Items"]) {
                    User *u = [[User alloc] init];
                    u.UserIdString = [dict valueForKey:@"Id"];
                    u.EmployeeId = [dict valueForKey:@"EmployeeId"] == [NSNull null] ? @"" : [dict valueForKey:@"EmployeeId"];
                    u.RFID = [dict valueForKey:@"RFID"] == [NSNull null] ? @"" : [dict valueForKey:@"RFID"];
                    u.BarCode = [dict valueForKey:@"BarCode"] == [NSNull null] ? @"" : [dict valueForKey:@"BarCode"];
                    u.Name = [dict valueForKeyPath:@"Name"] == [NSNull null] ? @"" : [dict valueForKeyPath:@"Name"];
                    
                    [result addObject:u];
                }
            }
            @catch(NSException *exception) {
                NSLog(@"Exception %s: %@", __func__, exception);
            }
        }
        else if (connectionError) {
            //            [_delegate wsConnectionError:connectionError];
        }
        [_delegate userListDelegate:result];
    }];
}

#pragma mark - Patient
- (void)getPatientList {
    NSURL *url = [NSURL URLWithString:[_serverPath stringByAppendingString:API_GET_PATIENTS]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:API_REQUEST_TIMEOUT_INTERVAL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        if (data.length > 0 && connectionError == nil) {
            NSError *error = nil;
            
            @try {
                for (NSDictionary *dict in [[NSJSONSerialization JSONObjectWithData:data options:0 error:&error] valueForKey:@"Items"]) {
                    Patient *p = [[Patient alloc] init];
                    p.PatientIdString = [dict valueForKey:@"Id"];
                    p.IdentifierId = [dict valueForKey:@"IdentifierId"] == [NSNull null] ? @"" : [dict valueForKey:@"IdentifierId"];
                    p.MedicalId = [dict valueForKey:@"MedicalId"] == [NSNull null] ? @"" : [dict valueForKey:@"MedicalId"];
                    p.RFID = [dict valueForKey:@"RFID"] == [NSNull null] ? @"" : [dict valueForKey:@"RFID"];
                    p.BarCode = [dict valueForKey:@"BarCode"] == [NSNull null] ? @"" : [dict valueForKey:@"BarCode"];
                    p.Name = [dict valueForKeyPath:@"Name"] == [NSNull null] ? @"" : [dict valueForKeyPath:@"Name"];
                    p.BedNo = [dict valueForKey:@"BedNo"] == [NSNull null] ? @"" : [dict valueForKey:@"BedNo"];
                    p.Gender = [dict valueForKey:@"Gender"] == [NSNull null] ? @"" : [dict valueForKey:@"Gender"];
                    
                    [result addObject:p];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Exception %s: %@", __func__, exception);
            }
            
        }
        else if (connectionError) {
            //            [_delegate wsConnectionError:connectionError];
        }
        [_delegate patientListDelegate:result];
    }];
}

#pragma mark - History
- (void)getHistoryByRoomNo:(NSString *)RoomNo {
    if ([RoomNo isEqualToString:@""]) {
        RoomNo = @"all";
    }
    
    NSDateComponents *dateComponets = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *endDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]];
    
    [dateComponets setDay:HISTORY_DAY];
    NSString *startDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]];
    
    NSURL *url = [NSURL URLWithString:[_serverPath stringByAppendingString:[NSString stringWithFormat:API_GET_HISTORY, RoomNo, startDate, endDate]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:API_REQUEST_TIMEOUT_INTERVAL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        if (data.length > 0 && connectionError == nil) {
            NSError *error = nil;
            NSDateFormatter *originDateFormatter = [[NSDateFormatter alloc] init];
            [originDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            [originDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            
            for (NSDictionary *dict in [NSJSONSerialization JSONObjectWithData:data options:0 error:&error]) {
                HistoryRoomData *h = [[HistoryRoomData alloc] init];
                h.BedNo = [self getValue:[dict valueForKey:@"BedNo"]];
                h.MedicalId = [self getValue:[dict valueForKey:@"MedicalId"]];
                h.Name = [self getValue:[dict valueForKey:@"Name"]];
                NSString *t = [self getValue:[dict valueForKey:@"LastRespiratoryTime"]];
                if (![t isEqualToString:@""]) {
                    NSDate *d = [originDateFormatter dateFromString:t];
                    t = [dateFormatter stringFromDate:d];
                }
                h.LastRespiratoryTime = t;
                
                [result addObject:h];
            }
        }
        else if (connectionError) {
            //            [_delegate wsConnectionError:connectionError];
        }
        [_delegate historyListDelegate:result];
    }];
}

- (void)getRespiratoryByMedicalId:(NSString *)MedicalId {
    NSDateComponents *dateComponets = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *endDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]];
    
    [dateComponets setDay:HISTORY_DAY];
    NSString *startDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]];
    
    NSURL *url = [NSURL URLWithString:[_serverPath stringByAppendingString:[NSString stringWithFormat:API_GET_RESPIRATORY_BY_PATIENTS, MedicalId, startDate, endDate]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:API_REQUEST_TIMEOUT_INTERVAL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        if (data.length > 0 && connectionError == nil) {
            NSError *error = nil;
            
            @try {
                for (NSDictionary *dict in [NSJSONSerialization JSONObjectWithData:data options:0 error:&error]) {
                    
                    VentilationData *v = [[VentilationData alloc] init];
                    v.ChtNo = [self getValue:[dict valueForKeyPath:@"Ventilation.ChtNo"]];
                    v.RecordTime = [self getValue:[dict valueForKeyPath:@"Ventilation.RecordTime"]];
                    v.RecordIp = [self getValue:[dict valueForKeyPath:@"Ventilation.RecordIp"]];
                    v.RecordOper = [self getValue:[dict valueForKeyPath:@"Ventilation.RecordOper"]];
                    v.RecordDevice = [self getValue:[dict valueForKeyPath:@"Ventilation.RecordDevice"]];
                    v.RecordClientVersion = [self getValue:[dict valueForKeyPath:@"RecordClientVersion"]];
                    v.VentNo = [self getValue:[dict valueForKeyPath:@"Ventilation.VentNo"]];
                    v.RawData = [self getValue:[dict valueForKeyPath:@"Ventilation.RawData"]];
                    
                    v.VentilationMode = [self getValue:[dict valueForKeyPath:@"Ventilation.VentilationMode"]];
                    v.TidalVolumeSet = [self getValue:[dict valueForKeyPath:@"Ventilation.TidalVolumeSet"]];
                    v.VolumeTarget = [self getValue:[dict valueForKeyPath:@"Ventilation.VolumeTarget"]];
                    v.TidalVolumeMeasured = [self getValue:[dict valueForKeyPath:@"Ventilation.TidalVolumeMeasured"]];
                    v.VentilationRateSet = [self getValue:[dict valueForKeyPath:@"Ventilation.VentilationRateSet"]];
                    v.SIMVRateSet = [self getValue:[dict valueForKeyPath:@"Ventilation.SIMVRateSet"]];
                    v.VentilationRateTotal = [self getValue:[dict valueForKeyPath:@"Ventilation.VentilationRateTotal"]];
                    v.InspTime = [self getValue:[dict valueForKeyPath:@"Ventilation.InspTime"]];
                    v.THigh = [self getValue:[dict valueForKeyPath:@"Ventilation.THigh"]];
                    
                    v.IERatio = [self getValue:[dict valueForKeyPath:@"Ventilation.IERatio"]];
                    v.Tlow = [self getValue:[dict valueForKeyPath:@"Ventilation.Tlow"]];
                    v.AutoFlow = [self getValue:[dict valueForKeyPath:@"Ventilation.AutoFlow"]];
                    v.FlowSetting = [self getValue:[dict valueForKeyPath:@"Ventilation.FlowSetting"]];
                    v.FlowMeasured = [self getValue:[dict valueForKeyPath:@"Ventilation.FlowMeasured"]];
                    v.Pattern = [self getValue:[dict valueForKeyPath:@"Ventilation.Pattern"]];
                    
                    v.MVSet = [self getValue:[dict valueForKeyPath:@"Ventilation.MVSet"]];
                    v.PercentMinVolSet = [self getValue:[dict valueForKeyPath:@"Ventilation.PercentMinVolSet"]];
                    v.MVTotal = [self getValue:[dict valueForKeyPath:@"Ventilation.MVTotal"]];
                    v.PeakPressure = [self getValue:[dict valueForKeyPath:@"Ventilation.PeakPressure"]];
                    v.PlateauPressure = [self getValue:[dict valueForKeyPath:@"Ventilation.PlateauPressure"]];
                    v.MeanPressure = [self getValue:[dict valueForKeyPath:@"Ventilation.MeanPressure"]];
                    v.PEEP = [self getValue:[dict valueForKeyPath:@"Ventilation.PEEP"]];
                    v.Plow = [self getValue:[dict valueForKeyPath:@"Ventilation.Plow"]];
                    v.PressureSupport = [self getValue:[dict valueForKeyPath:@"Ventilation.PressureSupport"]];
                    v.PressureControl = [self getValue:[dict valueForKeyPath:@"Ventilation.PressureControl"]];
                    v.PHigh = [self getValue:[dict valueForKeyPath:@"Ventilation.PHigh"]];
                    v.FiO2Set = [self getValue:[dict valueForKeyPath:@"Ventilation.FiO2Set"]];
                    v.FiO2Measured = [self getValue:[dict valueForKeyPath:@"Ventilation.FiO2Measured"]];
                    v.Resistance = [self getValue:[dict valueForKeyPath:@"Ventilation.Resistance"]];
                    v.Compliance = [self getValue:[dict valueForKeyPath:@"Ventilation.Compliance"]];
                    v.BaseFlow = [self getValue:[dict valueForKeyPath:@"Ventilation.BaseFlow"]];
                    v.FlowSensitivity = [self getValue:[dict valueForKeyPath:@"Ventilation.FlowSensitivity"]];
                    v.LowerMV = [self getValue:[dict valueForKeyPath:@"Ventilation.LowerMV"]];
                    v.HighPressureAlarm = [self getValue:[dict valueForKeyPath:@"Ventilation.HighPressureAlarm"]];
                    v.Temperature = [self getValue:[dict valueForKeyPath:@"Ventilation.Temperature"]];
                    v.ReliefPressure = [self getValue:[dict valueForKeyPath:@"Ventilation.ReliefPressure"]];
                    v.PetCo2 = [self getValue:[dict valueForKeyPath:@"Ventilation.PetCo2"]];
                    v.SpO2 = [self getValue:[dict valueForKeyPath:@"Ventilation.SpO2"]];
                    v.RR = [self getValue:[dict valueForKeyPath:@"Ventilation.RR"]];
                    v.TV = [self getValue:[dict valueForKeyPath:@"Ventilation.TV"]];
                    v.MV = [self getValue:[dict valueForKeyPath:@"Ventilation.MV"]];
                    v.MaxPi = [self getValue:[dict valueForKeyPath:@"Ventilation.MaxPi"]];
                    v.Mvv = [self getValue:[dict valueForKeyPath:@"Ventilation.Mvv"]];
                    v.Rsbi = [self getValue:[dict valueForKeyPath:@"Ventilation.Rsbi"]];
                    v.EtSize = [self getValue:[dict valueForKeyPath:@"Ventilation.EtSize"]];
                    v.Mark = [self getValue:[dict valueForKeyPath:@"Ventilation.Mark"]];
                    v.CuffPressure = [self getValue:[dict valueForKeyPath:@"Ventilation.CuffPressure"]];
                    v.BreathSounds = [self getValue:[dict valueForKeyPath:@"Ventilation.BreathSounds"]];
                    v.Pr = [self getValue:[dict valueForKeyPath:@"Ventilation.Pr"]];
                    v.Cvp = [self getValue:[dict valueForKeyPath:@"Ventilation.Cvp"]];
                    v.BpS = [self getValue:[dict valueForKeyPath:@"Ventilation.BpS"]];
                    v.BpD = [self getValue:[dict valueForKeyPath:@"Ventilation.BpD"]];
                    v.Memo = [self getValue:[dict valueForKeyPath:@"Ventilation.Memo"]];
                    v.AutoPEEP = [self getValue:[dict valueForKeyPath:@"Ventilation.AutoPEEP"]];
                    v.PlateauTimeSetting = [self getValue:[dict valueForKeyPath:@"Ventilation.PlateauTimeSetting"]];
                    
                    v.HR = [self getValue:[dict valueForKeyPath:@"Ventilation.HR"]];
                    v.PH = [self getValue:[dict valueForKeyPath:@"Ventilation.PH"]];
                    v.PaCO2 = [self getValue:[dict valueForKeyPath:@"Ventilation.PaCO2"]];
                    v.PaO2 = [self getValue:[dict valueForKeyPath:@"Ventilation.PaO2"]];
                    v.SaO2 = [self getValue:[dict valueForKeyPath:@"Ventilation.SaO2"]];
                    v.HCO3 = [self getValue:[dict valueForKeyPath:@"Ventilation.HCO3"]];
                    v.BE = [self getValue:[dict valueForKeyPath:@"Ventilation.BE"]];
                    v.PAaDO2 = [self getValue:[dict valueForKeyPath:@"Ventilation.PAaDO2"]];
                    v.Shunt = [self getValue:[dict valueForKeyPath:@"Ventilation.Shunt"]];
                    v.EndTidalCO2 = [self getValue:[dict valueForKeyPath:@"Ventilation.EndTidalCO2"]];
                    
                    v.PAaO2 = [self getValue:[dict valueForKeyPath:@"Ventilation.PAaO2"]];
                    v.BP = [self getValue:[dict valueForKeyPath:@"Ventilation.BP"]];
                    v.IO = [self getValue:[dict valueForKeyPath:@"Ventilation.IO"]];
                    v.ConsciousLevel = [self getValue:[dict valueForKeyPath:@"Ventilation.ConsciousLevel"]];
                    v.Hb = [self getValue:[dict valueForKeyPath:@"Ventilation.Hb"]];
                    v.Sugar = [self getValue:[dict valueForKeyPath:@"Ventilation.Sugar"]];
                    v.Na = [self getValue:[dict valueForKeyPath:@"Ventilation.Na"]];
                    v.K = [self getValue:[dict valueForKeyPath:@"Ventilation.K"]];
                    v.Ca = [self getValue:[dict valueForKeyPath:@"Ventilation.Ca"]];
                    v.Mg = [self getValue:[dict valueForKeyPath:@"Ventilation.Mg"]];
                    v.BUN = [self getValue:[dict valueForKeyPath:@"Ventilation.BUN"]];
                    v.Cr = [self getValue:[dict valueForKeyPath:@"Ventilation.Cr"]];
                    v.Albumin = [self getValue:[dict valueForKeyPath:@"Ventilation.Albumin"]];
                    v.CI = [self getValue:[dict valueForKeyPath:@"Ventilation.CI"]];
                    
                    [result addObject:v];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Exception %s: %@", __func__, exception);
            }
        }
        else if (connectionError) {
            //            [_delegate wsConnectionError:connectionError];
        }
        [_delegate historyListDelegate:result];
    }];
}

@end
