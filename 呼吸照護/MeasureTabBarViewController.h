//
//  MeasureTabBarViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/2/21.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VentilationData.h"

@interface MeasureTabBarViewController : UITabBarController

@property (strong, nonatomic) VentilationData *measureData;



#pragma mark - Methods
- (void)setMeasureData:(VentilationData *)measureData;

#pragma mark - Bar Button Item
- (IBAction)btnSaveClick:(id)sender;
- (IBAction)btnCancleClick:(id)sender;

@end
