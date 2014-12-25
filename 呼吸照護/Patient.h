//
//  Patient.h
//  呼吸照護
//
//  Created by Farland on 2014/6/3.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Patient : NSObject

@property (strong, nonatomic) NSString *PatientIdString;
@property (strong, nonatomic) NSString *IdentifierId;
@property (strong, nonatomic) NSString *MedicalId;
@property (strong, nonatomic) NSString *RFID;
@property (strong, nonatomic) NSString *BarCode;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSString *BedNo;
@property (strong, nonatomic) NSString *Gender;

@end
