//
//  JsonParser.m
//  呼吸照護
//
//  Created by Farland on 2014/5/30.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "JsonParser.h"

@implementation JsonParser

+ (NSString *)parseJsonToString:(NSArray *)jsonArray {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
