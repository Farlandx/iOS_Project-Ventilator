//
//  DtoVentExchangeUploadBatch.h
//  WebService
//
//  Created by Farland on 2014/4/21.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DtoVentExchangeUploadBatch : NSObject

@property (nonatomic) NSInteger UploadId;
@property (strong, nonatomic) NSString *UploadOper;
@property (strong, nonatomic) NSString *UploadIp;
@property (strong, nonatomic) NSString *UploadTime;
@property (strong, nonatomic) NSString *Device;
@property (strong, nonatomic) NSString *ClientVersion;
@property (strong, nonatomic) NSMutableArray *VentRecList;

@end
