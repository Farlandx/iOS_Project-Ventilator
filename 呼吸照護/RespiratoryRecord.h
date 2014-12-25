//
//  RespiratoryRecord.h
//  呼吸照護
//
//  Created by Farland on 2014/5/31.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VentilationData.h"

@interface RespiratoryRecord : NSObject

@property (strong, nonatomic) NSString *RespiratoryIdString;
@property (strong, nonatomic) NSString *PatientId;
@property (strong, nonatomic) NSString *PatientName;
@property (strong, nonatomic) NSString *CreatedUserId;
@property (strong, nonatomic) NSString *UserName;
@property (strong, nonatomic) NSString *IPAddress;
@property (strong, nonatomic) NSString *CreatedDatetime;
@property (strong, nonatomic) NSString *SourceType;
@property (strong, nonatomic) NSString *VentNo;
@property (strong, nonatomic) VentilationData *Ventilation;

- (NSDictionary *)toDictionary;

@end
