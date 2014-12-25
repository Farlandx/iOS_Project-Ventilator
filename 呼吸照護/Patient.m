//
//  Patient.m
//  呼吸照護
//
//  Created by Farland on 2014/6/3.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "Patient.h"

@implementation Patient

@synthesize PatientIdString, IdentifierId, MedicalId, RFID, BarCode, Name, BedNo, Gender;

- (id)init {
    if (self = [super init]) {
        PatientIdString = @"";
        IdentifierId = @"";
        MedicalId = @"";
        RFID = @"";
        BarCode = @"";
        Name = @"";
        BedNo = @"";
        Gender = @"";
    }
    return self;
}

@end
