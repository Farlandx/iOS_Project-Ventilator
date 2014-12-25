//
//  MeasureDataViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/2/19.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasureDataViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)NSMutableArray *measureDataList;
- (IBAction)uploadClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgSelectAll;

@end
