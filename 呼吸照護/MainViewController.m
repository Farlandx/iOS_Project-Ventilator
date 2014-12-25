//
//  MainViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/5/12.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "MainViewController.h"
#import "DatabaseUtility.h"

@interface MainViewController ()

@end

@implementation MainViewController {
    DatabaseUtility *db;
}

static bool _demoMode = NO;

@synthesize serverPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    db = [[DatabaseUtility alloc] init];
    [db initDatabase];
    
    serverPath = [db getServerPath];
    
    self.historyList = [db getUploadHistories];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (BOOL)IsDemoMode {
    return _demoMode;
}

+ (void)SetDemoMode:(BOOL)value {
    _demoMode = value;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
