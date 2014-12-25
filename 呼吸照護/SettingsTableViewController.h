//
//  SettingsTableViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/5/29.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *cellServer;
@property (strong, nonatomic) IBOutlet UITextField *textServer;

@property (strong, nonatomic) IBOutlet UISwitch *switchDemoMode;


@property (strong, nonatomic) IBOutlet UILabel *labelVersion;

@end
