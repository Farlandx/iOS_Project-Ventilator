//
//  JsonParser.h
//  呼吸照護
//
//  Created by Farland on 2014/5/30.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject

+ (NSString *)parseJsonToString:(NSArray *)jsonArray;

@end
