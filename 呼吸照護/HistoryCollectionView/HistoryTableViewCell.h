//
//  HistoryTableViewCell.h
//  呼吸照護
//
//  Created by Farland on 2014/11/24.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *MedicalId;

@property (strong, nonatomic) IBOutlet UILabel *PatientName;
@property (strong, nonatomic) IBOutlet UILabel *BedNo;
@property (strong, nonatomic) IBOutlet UILabel *LastDateTime;

@end
