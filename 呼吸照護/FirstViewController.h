//
//  FirstViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/3/5.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "VentilationData.h"
#import "NfcA1Device.h"
#import "NameTextField.h"

@interface FirstViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate, UITextFieldDelegate, NfcA1ProtocolDelegate> {
    NSString *deviceUUID;
    NSInteger bleStep;
    
    NfcA1Device* mNfcA1Device;
    UInt8 gBlockData[16];
    UInt8 gNo;
    UInt8 gTagUID[7];
}
@property (strong, nonatomic) VentilationData *measureData;

#pragma mark - Bar Button Item
- (IBAction)btnSaveClick:(id)sender;
- (IBAction)btnCancleClick:(id)sender;

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSMutableData *mData;

@property (strong, nonatomic) IBOutlet UIButton *btnReadData;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorRO;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorVNO;

//紀錄時間
@property (strong, nonatomic) IBOutlet UITextField *RecordTime;
//治療師ID
@property (strong, nonatomic) IBOutlet UITextField *RecordOper;
//病歷號
@property (strong, nonatomic) IBOutlet NameTextField *ChtNo;
//呼吸器代號 (XXXXXXXXXXXX**YYYYY)
@property (strong, nonatomic) IBOutlet UITextField *VentNo;


@end
