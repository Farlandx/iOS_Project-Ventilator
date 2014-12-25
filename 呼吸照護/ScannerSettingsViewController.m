//
//  ScannerSettingsViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/7/11.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "ScannerSettingsViewController.h"
#import "WSCoachMarksView.h"

#define __PADDING 30.0f

@interface ScannerSettingsViewController ()

@end

@implementation ScannerSettingsViewController {
    WSCoachMarksView *coachMarksView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds];
    coachMarksView.enableSkipButton = YES;
    coachMarksView.enableContinueLabel = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)startMarksView {
    NSMutableArray *coachMarks = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.imgsCollection.count; i++) {
        UIImageView *img = self.imgsCollection[i];
        CGRect rect = CGRectMake(img.frame.origin.x - __PADDING / 2, img.frame.origin.y, img.frame.size.width + __PADDING, img.frame.size.height);
        if (i < self.imgsCollection.count - 1) {
            [coachMarks addObject:@{
                                    @"rect": [NSValue valueWithCGRect:rect],
                                    @"caption": @"點擊畫面選取下一個條碼"
                                    }];
        }
        else {
            [coachMarks addObject:@{
                                    @"rect": [NSValue valueWithCGRect:rect],
                                    @"caption": @""
                                    }];
        }
    }
    
    coachMarksView.coachMarks = coachMarks;
    [self.view addSubview:coachMarksView];
    
    [coachMarksView start];
}

- (IBAction)scanHelper:(id)sender {
    [self startMarksView];
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
