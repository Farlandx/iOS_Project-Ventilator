//
//  User.m
//  呼吸照護
//
//  Created by Farland on 2014/6/3.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize UserIdString, EmployeeId, RFID, BarCode, Name;

- (id)init {
    if (self = [super init]) {
        UserIdString = @"";
        EmployeeId = @"";
        RFID = @"";
        BarCode = @"";
        Name = @"";
    }
    return self;
}

@end
