//
//  DtoVentExchangeUploadBatch.m
//  WebService
//
//  Created by Farland on 2014/4/21.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "DtoVentExchangeUploadBatch.h"

@implementation DtoVentExchangeUploadBatch

- (id)init {
    self = [super init];
    if (self) {
        _UploadOper = @"";
        _UploadIp = @"";
        _UploadTime = @"";
        _Device = @"";
        _ClientVersion = @"";
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DtoVentExchangeUploadBatch *batch = [[DtoVentExchangeUploadBatch alloc] init];
    batch.VentRecList = [_VentRecList copyWithZone:zone];
    
    return batch;
}

@end
