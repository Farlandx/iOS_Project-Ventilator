//
//  HistoryCollectionViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/5/20.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "HistoryCollectionViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "CollectionViewHeader.h"

#import "ContentScrollView.h"
#import "TitleView.h"
#import "ContentCollectionView.h"
#import "VentilationData.h"
#import "WebAPI.h"
#import "MainViewController.h"
#import "HistoryViewController.h"
#import "ProgressHUD.h"

@interface HistoryCollectionViewController () <CollectionViewHeaderProtocol, ContentCollectionViewProtocol, WebAPIDelegate>

@end

@implementation HistoryCollectionViewController {
    CollectionViewHeader *collectionViewHeader;
    ContentCollectionView *contentCollectionView;
    UITextField *userText;
    UIAlertView *alertView;
    WebAPI *api;
}

@synthesize MedicalId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //左上角加入一塊填充的UIView
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, HEADER_WIDTH, HEADER_HEIGHT)];
    [view setBackgroundColor:[UIColor whiteColor]];
    CALayer *bottomBorder = [CALayer layer];
    
    //bottom border
    bottomBorder.frame = CGRectMake(0, HEADER_HEIGHT - 1.0f, HEADER_WIDTH, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    [view.layer addSublayer:bottomBorder];
    
    //right border
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(HEADER_WIDTH - 1.0f, 0, 1.0f, HEADER_HEIGHT);
    rightBorder.backgroundColor = [UIColor grayColor].CGColor;
    [view.layer addSublayer:rightBorder];
    
//    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    aiView.textInputContextIdentifier
//    UILabel *labelTitle = [[UILabel alloc] init];
//    labelTitle.text = @"讀取中...";
//    self.navigationItem.titleView
    
    [self.view addSubview:view];
    
    api = [[WebAPI alloc] initWithServerPath:((MainViewController *)self.parentViewController.parentViewController).serverPath];
    api.delegate = self;
    [ProgressHUD show:@"資料讀取中..."];
    [api getRespiratoryByMedicalId:MedicalId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HistoryViewController *vc = (HistoryViewController *)segue.destinationViewController;
    vc.MedicalId = MedicalId;
}

//取得ContentCollection用的Data
- (NSArray *)getContentCollectionData:(VentilationData *)data {
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    
    //Mode
    [ary addObject:data.VentilationMode];
    //T.V set/total
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.TidalVolumeSet, data.TidalVolumeMeasured]];
    //Rate set/total
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.VentilationRateSet, data.VentilationRateTotal]];
    //Flow
    //Flow Set > Auto > Measured
    [ary addObject:(![data.FlowSetting isEqualToString:@""] ? data.FlowSetting :
                    (![data.AutoFlow isEqualToString:@""] ? data.AutoFlow :
                     (![data.FlowMeasured isEqualToString:@""] ? data.FlowMeasured : @"")))];
    //M.V set/total
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.MVSet, data.MVTotal]];
    //Insp. T / I:E
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.InspTime, data.IERatio]];
    //FiO2
    [ary addObject:data.FiO2Measured];
    //Peak/Plateau
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.PeakPressure, data.PlateauPressure]];
    //Mean/PEEP
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.MeanPressure, data.PEEP]];
    //P.S/P.C
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.PressureSupport, data.PressureControl]];
    //PH
    [ary addObject:data.PH];
    //PaCO2
    [ary addObject:data.PaCO2];
    //PaO2
    [ary addObject:data.PaO2];
    //HCO3/B.E
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.HCO3, data.BE]];
    //SaO2/SpO2
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.SaO2, data.SpO2]];
    //PA-aO2/Shunt
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.PAaO2, data.Shunt]];
    //RR
    [ary addObject:data.RR];
    //T.V/M.V
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.TV, data.MV]];
    //Pimax
    [ary addObject:data.MaxPi];
    //E.T siz/mark
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.EtSize, data.Mark]];
    //Cuff Pressure
    [ary addObject:data.CuffPressure];
    //Breathing Sound
    [ary addObject:data.BreathSounds];
    //HR
    [ary addObject:data.HR];
    //BP
    [ary addObject:data.BP];
    //I/O
    [ary addObject:data.IO];
    //Conscious Level
    [ary addObject:data.ConsciousLevel];
    //Hb/Sugar
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.Hb, data.Sugar]];
    //Na/K
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.Na, data.K]];
    //Ca/Mg
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.Ca, data.Mg]];
    //BUN/Cr
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.BUN, data.Cr]];
    //Albumin/CI
    [ary addObject:[NSString stringWithFormat:@"%@ / %@", data.Albumin, data.CI]];
    
    return ary;
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

#pragma mark - ScrollingProtocol
- (void)headerDidScroll {
    CGPoint offset = contentCollectionView.contentOffset;
    
    offset.x = collectionViewHeader.contentOffset.x;
    [contentCollectionView setContentOffset:offset];
}

- (void)collectionViewDidScroll {
    CGPoint offset = collectionViewHeader.contentOffset;
    
    offset.x = contentCollectionView.contentOffset.x;
    [collectionViewHeader setContentOffset:offset];
}

#pragma mark - WebAPIDelegate
- (void)historyListDelegate:(NSArray *)historyList {
    //調整subview裡面的內容
    ContentScrollView *scrollView;
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[CollectionViewHeader class]]) {
            collectionViewHeader = (CollectionViewHeader *)v;
        }
        else if ([v isKindOfClass:[ContentScrollView class]]) {
            scrollView = (ContentScrollView *)v;
        }
    }
    
    if (collectionViewHeader != nil && scrollView != nil) {
        TitleView *titleView;
        
        for (UIView *v in scrollView.subviews) {
            if ([v isKindOfClass:[TitleView class]]) {
                titleView = (TitleView *)v;
            }
            else if ([v isKindOfClass:[ContentCollectionView class]]) {
                contentCollectionView = (ContentCollectionView *)v;
            }
            
        }
        
        if (contentCollectionView != nil) {
            collectionViewHeader.protocol = self;
            contentCollectionView.protocol = self;
            
            [contentCollectionView setFrame:CGRectMake(HEADER_WIDTH, 0.0f, contentCollectionView.frame.size.width, titleView.totalHeight)];
        }
        
        [scrollView setContentSize:CGSizeMake(scrollView.frame.origin.x, titleView.totalHeight)];
        
        //將資料放進subview裡面
        if (historyList.count > 0) {
            NSMutableArray *timeArray = [[NSMutableArray alloc] init];
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
            [displayFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [displayFormatter setTimeZone:[NSTimeZone localTimeZone]];
            
            for (VentilationData *data in historyList) {
                //CollectionViewHeader
                //不這樣轉會出現尾巴有+0000奇怪的格式
                NSDate *d = [dateFormatter dateFromString:data.RecordTime];
                if (d) {
                    [timeArray addObject:[displayFormatter stringFromDate:d]];
                }
                
                //ContentCollectionView
                [dataArray addObject:[self getContentCollectionData:data]];
            }
            
            if (timeArray.count > 0) {
                collectionViewHeader.timeArray = [timeArray mutableCopy];
                [timeArray removeAllObjects];
                [collectionViewHeader reloadData];
            }
            
            if (dataArray.count > 0) {
//                contentCollectionView.dataArray = [dataArray mutableCopy];
                [contentCollectionView setDataArray:[dataArray mutableCopy]];
                [dataArray removeAllObjects];
            }
            
            [dateFormatter stringFromDate:[NSDate date]];
        }
    }
    
    [ProgressHUD dismiss];
}

@end
