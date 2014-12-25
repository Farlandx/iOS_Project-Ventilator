//
//  DtoUploadVentDataResult.h
//  呼吸照護
//
//  Created by Farland on 2014/4/23.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DtoUploadVentDataResult : NSObject

@property (strong, nonatomic) NSString *ChtNo;
@property (strong, nonatomic) NSString *RecordTime;
@property (nonatomic) BOOL Success;
@property (strong, nonatomic) NSString *Message;
@property (strong, nonatomic) NSString *RecordOperName;
@property (strong, nonatomic) NSString *UploadOperName;
@property (strong, nonatomic) NSString *VentilatorModel;
@property (strong, nonatomic) NSString *BedNo;

@end
