//
//  DtoUploadVentDataResult.m
//  呼吸照護
//
//  Created by Farland on 2014/4/23.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "DtoUploadVentDataResult.h"

@implementation DtoUploadVentDataResult

- (id)init {
    self = [super init];
    if (self) {
        _ChtNo = @"";
        _RecordTime = @"";
        _Message = @"";
        _RecordOperName = @"";
        _UploadOperName = @"";
        _VentilatorModel = @"";
        _BedNo = @"";
    }
    return self;
}

@end
