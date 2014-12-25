//
//  HistoryViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/5/28.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "HistoryViewController.h"
#import "MainViewController.h"

#define PRINT_TABLE_URL @"%@Service/RespiratoryPrintTable?id=%@&startdate=%@&enddate=%@"
#define HISTORY_DAY -3

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnPrint;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDateComponents *dateComponets = [[NSDateComponents alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *endDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]];
    
    [dateComponets setDay:HISTORY_DAY];
    NSString *startDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponets toDate:[NSDate date] options:0]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:PRINT_TABLE_URL,
                                       ((MainViewController *)self.parentViewController.parentViewController).serverPath,
                                       self.MedicalId,
                                       startDate,
                                       endDate]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AirPrint
- (IBAction)printView:(id)sender {
    UIPrintInfo *pi = [UIPrintInfo printInfo];
    pi.outputType = UIPrintInfoOutputGeneral;
    pi.jobName = self.webView.request.URL.absoluteString;
    pi.orientation = UIPrintInfoOrientationPortrait;
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.printInfo = pi;
    pic.showsPageRange= YES;
    UIPrintPageRenderer *renderer = [[UIPrintPageRenderer alloc] init];
    self.webView.viewPrintFormatter.printPageRenderer.headerHeight = 30.0f;
    self.webView.viewPrintFormatter.printPageRenderer.footerHeight = 30.0f;
    self.webView.viewPrintFormatter.contentInsets = UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f);
    self.webView.viewPrintFormatter.startPage = 0;
    [renderer addPrintFormatter:self.webView.viewPrintFormatter startingAtPageAtIndex:0];
    pic.printPageRenderer = renderer;
    
    
    [pic presentFromBarButtonItem:self.btnPrint animated:YES completionHandler:^(UIPrintInteractionController *pic2, BOOL completed, NSError *error) {
        // indicate done or error
    }];
}

@end
