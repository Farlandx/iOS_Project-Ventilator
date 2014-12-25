//
//  BreathSoundTableViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/3/14.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BreathSoundTableViewDelegate <NSObject>

@optional
- (void)breathSoundTableViewDismissWithStringData:(NSString *)sound;

@end

@interface BreathSoundTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic)id<BreathSoundTableViewDelegate> delegate;

@end
