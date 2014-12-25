//
//  DeviceStatus.h
//  呼吸照護
//
//  Created by Farland on 2014/4/23.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceStatus : NSObject

+ (NSString *)getCurrentIPAddress;
+ (NSString *)getDeviceVendorUUID;
+ (NSString *)getSystemTime;

@end
