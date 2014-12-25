//
//  SERVOi.m
//  BLE
//
//  Created by Farland on 2014/4/10.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "SERVOi.h"

@implementation SERVOi {
    SERVOI_READ_STEP step;
    NSMutableData *mData;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        step = SERVOI_INIT;
        mData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
}

- (void)resetMData {
    if ([mData length] > 0) {
        //[_mData replaceBytesInRange:NSMakeRange(0, [_mData length]) withBytes:nil length:0];
        [mData setLength:0];
        NSLog(@"mData reset");
    }
}

- (NSString *)getVentilationMode:(NSString *)mode {
    switch ([mode intValue]) {
        case 1:
            return @"Value not used";
        case 2:
            return @"Pressure Control";
        case 3:
            return @"Volume Control";
        case 4:
            return @"Pressure Reg. Volume Control";
        case 5:
            return @"Volume Support";
        case 6:
            return @"SIMV + Pressure Support";
        case 7:
            return @"SIMV + Pressure Support";
        case 8:
            return @"Pressure Support / CPAP";
        case 9:
            return @"Ventilation mode not supported by CIE";
        case 10:
            return @"SIMV + Pressure Support";
        case 11:
            return @"Bivent";
        case 12:
            return @"Pressure Control in NIV";
        case 13:
            return @"Pressure Support in NIV";
        case 14:
            return @"Nasal CPAP";
        case 15:
            return @"NAVA";
        case 16:
            return @"Value not used";
        case 17:
            return @"NIV NAVA";
        case 18:
            return @"Pressure Control";
        case 19:
            return @"Volume Control";
        case 20:
            return @"Pressure Reg";
        case 21:
            return @"Pressure Support";
        case 22:
            return @"Volume Support";
        case 23:
            return @"Volume Support";
        default:
            return @"";
    }
}

- (NSString *) getValue:(int)position value:(NSString *)value {
    position = position - 1;
    NSString *res;
    @try {
        res = [[value substringWithRange:NSMakeRange(position * 4, 4)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if ([res isEqualToString:@"9999"]) {
            res = @"";
        }
    }
    @catch (NSException *exception) {
        res = @"";
    }
    return res;
}

- (NSString *)getCalculateValue:(NSString *)value scale:(float) scale {
    if ([value isEqualToString:@""]) {
        return @"";
    }
    else {
        float cal = (float)(([value floatValue] - 2048) * 4.8883 / scale);
        return [NSString stringWithFormat:@"%.1lf", cal];
    }
}

- (const char *)getChkStr:(int)sum {
    NSString *sumString = [NSString stringWithFormat:@"%02X", sum];
    sumString = [sumString substringWithRange:NSMakeRange([sumString length] - 2, 2)];
    return [sumString UTF8String];
    
}

- (NSData *)getBasicCommand:(NSString *)cmd {
    NSData *data = [cmd dataUsingEncoding:NSUTF8StringEncoding];
    int size = (int)[data length] + 1;
    unsigned char buffer[size];
    
    const char *bytes = [data bytes];
    for (int i = 0; i < [data length]; i++) {
        buffer[i] = bytes[i];
    }
    buffer[size - 1] = 0x04;
    NSData *result = [[NSData alloc] initWithBytes:buffer length:sizeof(buffer)];
    return result;
}

- (NSData *)getExtendCommand:(NSString *)cmd {
    NSData *data = [cmd dataUsingEncoding:NSUTF8StringEncoding];
    int size = (int)[data length] + 3;
    unsigned char buffer[size];
    
    const char *bytes = [data bytes];
    unsigned char chk = 0x00;
    for (int i = 0; i < [data length]; i++) {
        buffer[i] = bytes[i];
        chk = (unsigned)(chk ^ bytes[i]);
    }
    
    const char *chkStr = [self getChkStr:chk];
    buffer[size - 3] = chkStr[0];
    buffer[size - 2] = chkStr[1];
    buffer[size - 1] = 4;
    
    return [NSData dataWithBytes:buffer length:size];
}

- (NSData *)getInitCommand {
    return [self getBasicCommand:@"HO"];
}

- (void)resetStep {
    step = SERVOI_INIT;
}

- (NSString *)stringZeroFilter:(NSString *)value {
    if ([value isEqualToString:@"0.0"] || [value isEqualToString:@"0"]) {
        return @"";
    }
    return  value;
}

- (BOOL)chkStopByte:(NSData *)data {
    if (data != nil) {
        const char* bytes = [data bytes];
        for (int i = 0; i < [data length]; i++) {
            if (bytes[i] == STOP_BYTE) {
                return YES;
            }
        }
    }
    return NO;
}

- (SERVOI_READ_STEP)run:(NSData *)data VentilationData:(VentilationData *)ventilation {
    [mData appendData:data];
    NSLog(@"data:%@", [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding]);
    if (![self chkStopByte:mData]) {
        return SERVOI_WAITING;
    }
    switch (step) {
        case SERVOI_INIT:
            //            if ([[[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding] rangeOfString:@"900PCI"].location > -1) {
            NSLog(@"SERVOI_INIT");
            step = SERVOI_RESISTANCE_DB31;
            [self resetMData];
            [_delegate nextCommand:[self getBasicCommand:@"DB31"]];
            //            }
            
            break;
            
        case SERVOI_RESISTANCE_DB31:
            NSLog(@"SERVOI_RESISTANCE_DB31");
            step = SERVOI_RESISTANCE_RB;
            [self resetMData];
            [_delegate nextCommand:[self getBasicCommand:@"RB"]];
            break;
            
        case SERVOI_RESISTANCE_RB: {
            NSString *basicResult = [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
            NSString *val = [self getValue:1 value:basicResult];
            
            if (![val isEqualToString:@""]) {
                ventilation.Resistance = [self getCalculateValue:val scale:20.0f];
            }
            
            step = SERVOI_RCTY;
            [self resetMData];
            [_delegate nextCommand:[self getExtendCommand:@"RCTY"]];
            break;
        }
            
        case SERVOI_RCTY:
            /*
             * 設定要讀取的數值(Setting)1: 310 (VentilationMode)2: 334 (TidalVolumeSet)
             * 3: 300 (VentilationRateSet)4: 343 (InspT)5: 348 (FlowSetting)6:
             * 305 (MVSet)7: 306 (PressureControl)8: 307 (PressureSupport)9: 323
             * (FiO2Set)10: 314 (LowerMV)11: 315 (HighPressureAlarm)12: 308
             * (PEEP) (Plow when mode=11)13: 303 (SIMVRateSet)14: 333 (I:E Ratio
             * Set)15: 339 (THight when mode=11)16: 340 (Tlow when mode=11)17:
             * 338 (PHigh when mode=11)18: 341 (PressureSupport when mode=11)
             */
            step = SERVOI_SDADS;
            [self resetMData];
            [_delegate nextCommand:[self getExtendCommand:@"SDADS310334300343348305306307323314315308303333339340338341"]];
            
            break;
            
        case SERVOI_SDADS:
            step = SERVOI_RADAS;
            [self resetMData];
            [_delegate nextCommand:[self getExtendCommand:@"RADAS"]];
            
            break;
            
        case SERVOI_RADAS: {
            NSString *settings = [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
            
            // VentilationMode(310)
            ventilation.VentilationMode = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:1 value:settings] intValue]]];
            
            // TidalVolumeSet(334)
            ventilation.TidalVolumeSet = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:2 value:settings] intValue]]];
            
            // VentilationRateSet(300)
            ventilation.VentilationRateSet = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:3 value:settings] intValue]]];
            if (![ventilation.VentilationRateSet isEqualToString:@""]) {
                ventilation.VentilationRateSet = [self stringZeroFilter:[NSString stringWithFormat:@"%.0f", [ventilation.VentilationRateSet floatValue] / 10.0f]];
                
            }
            
            // InspT(343)
            ventilation.InspTime = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:4 value:settings] intValue]]];
            if (![ventilation.InspTime isEqualToString:@""]) {
                ventilation.InspTime = [self stringZeroFilter:[NSString stringWithFormat:@"%.2lf", [ventilation.InspTime floatValue] / 100.0f]];
            }
            
            // FlowSetting(348)
            //            ventilation.FlowSetting = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:5 value:settings] intValue]]];
            //            ventilation.FlowSetting = [self stringZeroFilter:[NSString stringWithFormat:@"%.2lf", [[self getValue:3 value:settings] floatValue]]];
            
            // MVSet(305)
            ventilation.MVSet = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:6 value:settings] intValue]]];
            if (![ventilation.MVSet isEqualToString:@""]) {
                ventilation.MVSet = [self stringZeroFilter:[NSString stringWithFormat:@"%.1lf", [ventilation.MVSet floatValue] / 100.0f]];
            }
            
            // PressureControl(306)
            ventilation.PressureControl = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:7 value:settings] intValue]]];
            if (![ventilation.PressureControl isEqualToString:@""]) {
                ventilation.PressureControl = [self stringZeroFilter:[NSString stringWithFormat:@"%.0f", [ventilation.PressureControl floatValue] / 10.0f]];
            }
            
            // FiO2Set(323)
            ventilation.FiO2Set = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:9 value:settings] intValue]]];
            if (![ventilation.FiO2Set isEqualToString:@""]) {
                ventilation.FiO2Set = [self stringZeroFilter:[NSString stringWithFormat:@"%.1lf", [ventilation.FiO2Set floatValue] / 10.0f]];
            }
            
            // LowerMV(314)
            ventilation.LowerMV = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:10 value:settings] intValue]]];
            if (![ventilation.LowerMV isEqualToString:@""]) {
                ventilation.LowerMV = [self stringZeroFilter:[NSString stringWithFormat:@"%.1lf", [ventilation.LowerMV floatValue] / 10.0f]];
            }
            
            // HighPressureAlarm Set(315)
            ventilation.HighPressureAlarm = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:11 value:settings] intValue]]];
            
            // PEEP Set(308)
            ventilation.PEEP = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:12 value:settings] intValue]]];
            if (![ventilation.PEEP isEqualToString:@""]) {
                ventilation.PEEP = [self stringZeroFilter:[NSString stringWithFormat:@"%.0f", [ventilation.PEEP floatValue] / 10.0f]];
            }
            
            // SIMVRateSet(303)
            ventilation.SIMVRateSet = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:13 value:settings] intValue]]];
            if (![ventilation.SIMVRateSet isEqualToString:@""]) {
                ventilation.SIMVRateSet = [self stringZeroFilter:[NSString stringWithFormat:@"%.0f", [ventilation.SIMVRateSet floatValue] / 10.0f]];
            }
            
            // I:E Ratio Set(333)
            ventilation.IERatio = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:14 value:settings] intValue]]];
            if (![ventilation.IERatio isEqualToString:@""]) {
                ventilation.IERatio = [self stringZeroFilter:[NSString stringWithFormat:@"%.1lf", [ventilation.IERatio floatValue] / 100.0f]];
                float tmp = [ventilation.IERatio floatValue];
                
                if (tmp >= 1.0f) {
                    ventilation.IERatio = [ventilation.IERatio stringByAppendingString:@":1"];
                }
                else {
                    ventilation.IERatio = [@"1:" stringByAppendingString:[NSString stringWithFormat:@"%.1f", 1 / tmp]];
                }
            }
            
            // 依模式不同取值
            if (![ventilation.VentilationMode caseInsensitiveCompare:@"11"]) {
                // THigh(339)
                ventilation.THigh = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:15 value:settings] intValue]]];
                if (![ventilation.THigh isEqualToString:@""]) {
                    ventilation.THigh = [self stringZeroFilter:[NSString stringWithFormat:@"%.1lf", [ventilation.THigh floatValue] / 100.0f]];
                }
                // Tlow(340)
                ventilation.Tlow = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:16 value:settings] intValue]]];
                if (![ventilation.Tlow isEqualToString:@""]) {
                    ventilation.Tlow = [self stringZeroFilter:[NSString stringWithFormat:@"%.1lf", [ventilation.Tlow floatValue] / 100.0f]];
                }
                // Plow(308)
                ventilation.Plow = ventilation.PEEP;
                
                // PHigh(338)
                ventilation.PHigh = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:17 value:settings] intValue]]];
                if (![ventilation.PHigh isEqualToString:@""]) {
                    ventilation.PHigh = [self stringZeroFilter:[NSString stringWithFormat:@"%.1lf", [ventilation.PHigh floatValue] / 10.0f]];
                }
                
                // PressureSupport(341)
                ventilation.PressureSupport = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:18 value:settings] intValue]]];
            }
            else {
                // PressureSupport(307)
                ventilation.PressureSupport = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:8 value:settings] intValue]]];
            }
            
            if (![ventilation.PressureSupport isEqualToString:@""]) {
                ventilation.PressureSupport = [self stringZeroFilter:[NSString stringWithFormat:@"%.1lf", [ventilation.PressureSupport floatValue] / 10.0f]];
            }
            
            /*
             * 設定要讀取的數值(Measured) 1: 201 (TidalVolumeMeasured) 2: 200
             * (VentilationRateTotal) 3: 204 (MVTotal) 4: 205 (PeakPressure) 5:
             * 207 (PlateauPressure) 6: 206 (MeanPressure) 7: 209 (FiO2Measured)
             * 8: 241 (Compliance) 9: 233 (FlowMeasured)
             */
            step = SERVOI_SDADB;
            [self resetMData];
            [_delegate nextCommand:[self getExtendCommand:@"SDADB201200204205207206209241233"]];
            
            break;
        }
            
        case SERVOI_SDADB:
            step = SERVOI_RADAB;
            [self resetMData];
            [_delegate nextCommand:[self getExtendCommand:@"RADAB"]];
            break;
            
        case SERVOI_RADAB: {
            NSString *measureds = [[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding];
            
            // TidalVolumeMeasured(201)
            ventilation.TidalVolumeMeasured = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:1 value:measureds] intValue]]];
            
            // Measured breath frequency(200)
            ventilation.VentilationRateTotal = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:2 value:measureds] intValue]]];
            if (![ventilation.VentilationRateTotal isEqualToString:@""]) {
                ventilation.VentilationRateTotal = [self stringZeroFilter:[NSString stringWithFormat:@"%.0f", [ventilation.VentilationRateTotal floatValue] / 10.0f]];
            }
            
            // MVTotal(204)
            ventilation.MVTotal = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:3 value:measureds] intValue]]];
            if (![ventilation.MVTotal isEqualToString:@""]) {
                ventilation.MVTotal = [self stringZeroFilter:[NSString stringWithFormat:@"%.1lf", [ventilation.MVTotal floatValue] / 10.0f]];
            }
            
            // Peak pressure(205)
            ventilation.PeakPressure = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:4 value:measureds] intValue]]];
            if (![ventilation.PeakPressure isEqualToString:@""]) {
                ventilation.PeakPressure = [self stringZeroFilter:[NSString stringWithFormat:@"%.0f", [ventilation.PeakPressure floatValue] / 10.0f]];
            }
            
            // PlateauPressure(207)
            ventilation.PlateauPressure = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:5 value:measureds] intValue]]];
            if (![ventilation.PlateauPressure isEqualToString:@""]) {
                ventilation.PlateauPressure = [self stringZeroFilter:[NSString stringWithFormat:@"%.0f", [ventilation.PlateauPressure floatValue] / 10.0f]];
            }
            
            // MeanPressure(206)
            ventilation.MeanPressure = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:6 value:measureds] intValue]]];
            if (![ventilation.MeanPressure isEqualToString:@""]) {
                ventilation.MeanPressure = [self stringZeroFilter:[NSString stringWithFormat:@"%.0f", [ventilation.MeanPressure floatValue] / 10.0f]];
            }
            
            // FiO2Measured(209)
            ventilation.FiO2Measured = [self stringZeroFilter:[NSString stringWithFormat:@"%d", [[self getValue:7 value:measureds] intValue]]];
            
            // Static Compliance(241)
            //ventilation.Compliance = [self getValue:8 value:measureds];
            
            // FlowMeasured(233)
            //ventilation.FlowMeasured = [NSString stringWithFormat:@"%d", [[self getValue:9 value:measureds] intValue]];
            
            ventilation.VentilationMode = [self getVentilationMode:ventilation.VentilationMode];
            
            step = SERVOI_DONE;
            [self resetMData];
            break;
        }
            
        default:
            step = SERVOI_ERROR;
            [self resetMData];
            break;
    }
    return step;
}

@end
