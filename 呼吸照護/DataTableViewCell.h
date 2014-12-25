//
//  DataTableViewCell.h
//  呼吸照護
//
//  Created by Farland on 2014/2/21.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgCheckbox;
@property (strong, nonatomic) IBOutlet UILabel *labelChtNo;
@property (strong, nonatomic) IBOutlet UILabel *labelRecordOper;
@property (strong, nonatomic) IBOutlet UILabel *labelRecordTime;
@property (strong, nonatomic) IBOutlet UILabel *labelVentilationMode;

@end
