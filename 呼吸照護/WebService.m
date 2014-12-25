//
//  WebService.m
//  CommandLineTest
//
//  Created by Farland on 2014/4/17.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#include <ifaddrs.h>
#include <arpa/inet.h>
#import "WebService.h"
#import "XMLReader.h"
#import "VentilationData.h"
#import "DeviceStatus.h"

#ifndef ___webservice
#define ___webservice

#define WS_GET_CUR_RT_CARD_LIST @"api/user"
#define WS_GET_PATIENT_LIST @"api/patient"
#define WS_REQUEST_TIMEOUT_INTERVAL 10 //Second

#endif

@implementation WebService

- (void)dealloc {
    _delegate = nil;
}

@synthesize ServerPath;

#pragma mark - Private Method
/*- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}*/

- (NSString *)getSOAPDateStringByNSString:(NSString *) dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    // get NSDate from old string format
    NSDate *date = [dateFormatter dateFromString:dateString ];
    
    // get string in new date format
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

- (NSURLRequest *) getURLRequestByWSString:(NSString *) swString {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", ServerPath, swString];
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSURLRequest requestWithURL:url];
}

- (NSMutableURLRequest *) getMutableURLRequestByWSString:(NSString *) swString {
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", ServerPath, swString];
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSMutableURLRequest requestWithURL:url];
}

- (NSMutableURLRequest *) getSOAPRequestByWSString:(NSString *) swString soapMessage:(NSString *)soapMessage {
    NSURL *url = [NSURL URLWithString:ServerPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:WS_REQUEST_TIMEOUT_INTERVAL];
    NSString *msgLength = [NSString stringWithFormat:@"%ld", [soapMessage length]];
    
    [request addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: swString forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - WebService Method
- (void)getUserList {
    NSString *soapMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
    "<soap12:Body>"
    "<GetCurRtCardList xmlns=\"http://cgmh.org.tw/g27/\" />"
    "</soap12:Body>"
    "</soap12:Envelope>";
    
    NSMutableURLRequest *request = [self getSOAPRequestByWSString: WS_GET_CUR_RT_CARD_LIST soapMessage:soapMessage];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            for (NSDictionary *card in [xmlDictionary valueForKeyPath:@"Envelope.Body.GetCurRtCardListResponse.GetCurRtCardListResult.DtoRtCard"]) {
                [result addObject:[card valueForKeyPath:@"CardNo.text"]];
            }
            
            [_delegate wsResponseCurRtCardList:result];
        }
        else if (connectionError) {
            [_delegate wsConnectionError:connectionError];
        }
    }];
}

- (void)getPatientList {
    NSString *soapMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
    "<soap12:Body>"
    "<GetPatientList xmlns=\"http://cgmh.org.tw/g27/\" />"
    "</soap12:Body>"
    "</soap12:Envelope>";
    
    NSURLRequest *request = [self getSOAPRequestByWSString:WS_GET_PATIENT_LIST soapMessage:soapMessage];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data.length > 0 && connectionError == nil) {
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSError *error = nil;
            NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:data
                                                                  options:XMLReaderOptionsProcessNamespaces
                                                                    error:&error];
            for (NSDictionary *card in [xmlDictionary valueForKeyPath:@"Envelope.Body.GetPatientListResponse.GetPatientListResult.DtoVentExchangeGetPatient"]) {
                [result addObject:card];
            }
            
            [_delegate wsResponsePatientList:result];
        }
        else if (connectionError) {
            [_delegate wsConnectionError:connectionError];
        }
    }];
}

@end
