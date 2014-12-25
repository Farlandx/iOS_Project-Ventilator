//
//  User.h
//  呼吸照護
//
//  Created by Farland on 2014/6/3.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *UserIdString;
@property (strong, nonatomic) NSString *EmployeeId;
@property (strong, nonatomic) NSString *RFID;
@property (strong, nonatomic) NSString *BarCode;
@property (strong, nonatomic) NSString *Name;

@end
