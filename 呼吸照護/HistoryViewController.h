//
//  HistoryViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/5/28.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController

@property (strong, nonatomic) NSString *MedicalId;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
