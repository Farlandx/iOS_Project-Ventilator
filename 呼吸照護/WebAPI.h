//
//  WebAPI.h
//  呼吸照護
//
//  Created by Farland on 2014/5/30.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebAPIDelegate <NSObject>

@optional
- (void)uploadDone:(NSInteger)measureId;
- (void)uploadError:(NSInteger)measureId;
- (void)userListDelegate:(NSArray *)userList;
- (void)patientListDelegate:(NSArray *)patientList;
- (void)historyListDelegate:(NSArray *)historyList;

@end

@interface WebAPI : NSObject <NSURLConnectionDataDelegate>

@property (assign, nonatomic) id<WebAPIDelegate> delegate;

- (id)initWithServerPath:(NSString *)serverPath;
+ (void)setServerPath:(NSString *)serverPath;

- (void)uploadVentData:(NSData *)jsonData patientId:(NSString *)patientId measureId:(NSInteger)measureId;
- (void)getUserList;
- (void)getPatientList;

- (void)getHistoryByRoomNo:(NSString *)RoomNo;
- (void)getRespiratoryByMedicalId:(NSString *)MedicalId;

@end
