//
//  RespiratoryRecord.m
//  呼吸照護
//
//  Created by Farland on 2014/5/31.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "RespiratoryRecord.h"

@implementation RespiratoryRecord

@synthesize RespiratoryIdString, PatientId, PatientName, CreatedUserId, UserName, IPAddress, CreatedDatetime, SourceType, VentNo, Ventilation;

- (id)init {
    if (self = [super init]) {
        SourceType = @"iOS";
    }
    return self;
}

- (NSString *)getStringWithoutNil:(NSString *)string {
    return string == nil ? @"" : string;
}

- (NSDictionary *)toDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self getStringWithoutNil:RespiratoryIdString], @"RespiratoryIdString",
            [self getStringWithoutNil:PatientId], @"PatientId",
            [self getStringWithoutNil:PatientName], @"PatientName",
            [self getStringWithoutNil:CreatedUserId], @"CreatedUserId",
            [self getStringWithoutNil:UserName], @"UserName",
            [self getStringWithoutNil:IPAddress], @"IPAddress",
            [self getStringWithoutNil:CreatedDatetime], @"CreatedDatetime",
            [self getStringWithoutNil:SourceType], @"SourceType",
            [self getStringWithoutNil:VentNo], @"VentNo",
            Ventilation.toDictionary, @"Ventilation", nil];
}

@end
