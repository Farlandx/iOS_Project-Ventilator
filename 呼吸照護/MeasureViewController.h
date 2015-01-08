//
//  MeasureViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/4/1.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NfcA1Device.h"
#import "VentilationData.h"
#import "DeviceInfo.h"
#import "BLE.h"
#import "NameTextField.h"

@protocol MeasureViewControllerDelegate <NSObject>

- (void)measureViewControllerDismissed:(VentilationData *)measureData;

@end

@interface MeasureViewController : UIViewController<UITextFieldDelegate, NfcA1ProtocolDelegate, BleDelegate> {
    NfcA1Device* mNfcA1Device;
    UInt8 gBlockData[16];
    UInt8 gNo;
    UInt8 gTagUID[7];
    
    BLE *ble;
}

#pragma mark - Bar Button Item
- (IBAction)btnSaveClick:(id)sender;
- (IBAction)btnCancleClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnDemo;
@property (strong, nonatomic) IBOutlet UIButton *btnTest;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorRO;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorVNO;

@property (strong, nonatomic) VentilationData *myMeasureData;
@property (nonatomic) BOOL viewMode;
@property (nonatomic) BOOL editMode;
@property (nonatomic) BOOL demoMode;
@property (assign, nonatomic) id<MeasureViewControllerDelegate> delegate;

//儲存按鈕
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSave;
//紀錄時間
@property (strong, nonatomic) IBOutlet UITextField *RecordTime;
//治療師ID
@property (strong, nonatomic) IBOutlet NameTextField *RecordOper;
//病歷號
@property (strong, nonatomic) IBOutlet NameTextField *ChtNo;
//呼吸器代號 (XXXXXXXXXXXX**YYYYY)
@property (strong, nonatomic) IBOutlet UITextField *VentNo;

- (void)setViewMode;
- (void)setEditMode;

@end
