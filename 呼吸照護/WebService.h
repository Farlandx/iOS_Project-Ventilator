//
//  WebService.h
//  CommandLineTest
//
//  Created by Farland on 2014/4/17.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DtoVentExchangeUploadBatch.h"
#import "DtoUploadVentDataResult.h"

@protocol WebServiceDelegate <NSObject>

- (void)wsAppLogin:(NSString *)sessionId;
- (void)wsUploadVentDataSuccess:(NSMutableArray *)uploadSuccessResult uploadFailed:(NSMutableArray *)uploadFailed DtoVentExchangeUploadBatch:(DtoVentExchangeUploadBatch *)batch;
- (void)wsResponseCurRtCardList:(NSMutableArray *)data;
- (void)wsResponseCurRtCardListVerId:(int)verId;
- (void)wsResponsePatientList:(NSMutableArray *)data;
- (void)wsConnectionError:(NSError *)error;

@end

@interface WebService : NSObject

@property (strong, nonatomic) NSString *ServerPath;
@property (assign, nonatomic) id<WebServiceDelegate> delegate;

- (void)getUserList;
- (void)getPatientList;

@end
