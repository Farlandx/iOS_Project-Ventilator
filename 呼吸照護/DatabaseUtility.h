//
//  DatabaseUtility.h
//  呼吸照護
//
//  Created by Farland on 2014/2/18.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "VentilationData.h"
#import "DtoVentExchangeUploadBatch.h"
#import "User.h"
#import "Patient.h"

@interface DatabaseUtility : NSObject {
    sqlite3 *sqliteDb;
}

@property (strong, nonatomic) NSString *databasePath;

- (void) initDatabase;

#pragma mark - MeasureData
- (BOOL) saveMeasure:(VentilationData *)measureData;
- (BOOL) deleteMeasure:(VentilationData *)measureData;
//取得尚未上傳的量測資料
- (NSMutableArray *) getMeasures;
- (VentilationData *) getMeasureDataById:(NSInteger)measureId;

#pragma mark - UploadData
- (BOOL) saveUploadData:(DtoVentExchangeUploadBatch *)uploadData;
- (NSMutableArray *) getUploadHistories;

#pragma mark - UserList
- (void) saveUserList:(NSArray *)data;
- (User *) getUserById:(NSString *)userId;

#pragma mark - PatientList
- (void) savePatientList:(NSArray *)data;
- (Patient *) getPatientById:(NSString *)patientId;

#pragma mark - ServerPath
- (BOOL) saveServerPath:(NSString *)serverPath;
- (NSString *) getServerPath;

#pragma mark - LastDevice
- (BOOL) saveLastDevice:(NSString *)device medicalId:(NSString *)medicalId;
- (NSString *) getLastDeviceByMedicalId:(NSString *)medicalId;

@end
