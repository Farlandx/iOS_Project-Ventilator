//
//  FirstViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/3/5.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "FirstViewController.h"
#import "DragerLibrary_Commands.h"
#import "MeasureTabBarViewController.h"
#import "VentilatorDataViewController.h"
#import "OtherDataViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController {
    VentilationData *myMeasureData;
    
    BOOL isStartListeningThread, isFocusOnRecordOper, isFocusOnVentNo;
}

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
    [_RecordOper addTarget:self action:@selector(recordOperTextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_ChtNo addTarget:self action:@selector(chtNoTextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_VentNo addTarget:self action:@selector(ventNoTextFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _RecordOper.delegate = self;
    _VentNo.delegate = self;
    
    bleStep = 0;
    _data = [[NSData alloc] init];
    _mData = [[NSMutableData alloc] init];
    myMeasureData = [[VentilationData alloc] init];
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    isStartListeningThread = NO;
    isFocusOnRecordOper = NO;
    isFocusOnVentNo = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (_peripheral.state == CBPeripheralStateConnected || _peripheral.state == CBPeripheralStateConnecting) {
        [_centralManager cancelPeripheralConnection:_peripheral];
    }
}

- (void)showBluetoothNotOpenMsg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"藍牙尚未開啟" message:@"請至系統設定中開啟藍牙" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)btnStart:(id)sender {
    _peripheral = [self getPeripheralByCode:@"12909999-021A-21EB-3ED7-A49829039048"];
    [_centralManager connectPeripheral:_peripheral options:nil];
}

- (void)recordOperTextFieldDone:(UITextField*)textField {
    [textField resignFirstResponder];
    [_ChtNo becomeFirstResponder];
}

- (void)chtNoTextFieldDone:(UITextField*)textField {
    [textField resignFirstResponder];
    [_VentNo becomeFirstResponder];
}

- (void)ventNoTextFieldDone:(UITextField*)textField {
    [textField resignFirstResponder];
    
    [self btnStart:_btnReadData];
}

#pragma mark - NFC Dongle
- (BOOL)isHeadsetPluggedIn
{
    NSArray *availableOutputs = [[AVAudioSession sharedInstance] currentRoute].outputs;
    for (AVAudioSessionPortDescription *portDescription in availableOutputs) {
        if ([portDescription.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
    }
    return NO;
}

- (void) hexStringToData:(NSString *)str
                    Data: (void *) data
{
    int len = (int)[str length] / 2;    // Target length
    
    unsigned char *whole_byte = data;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < len; i++)
    {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
}

- (NSString *) hexDataToString:(UInt8 *)data
                        Length:(int)len
{
    NSString *tmp = @"";
    NSString *str = @"";
    for(int i = 0; i < len; ++i)
    {
        tmp = [NSString stringWithFormat:@"%02X",data[i]];
        str = [str stringByAppendingString:tmp];
    }
    return str;
}

- (NSString *) sectorHexDataToString:(UInt8 *)data
                              Length:(int)len
{
    NSData *nData = [NSData dataWithBytes:data length:len];
    NSString *str = [[NSString alloc] initWithData:nData encoding:NSUTF8StringEncoding];
    return str;
}

- (void)listeningRecordOper {
    [self initAudioPlayer];
    if([mNfcA1Device readerGetTagUID] == NO) {
        NSLog(@"readerGetTagUID false");
    }
}

- (void)listeningVentNo {
    [self initAudioPlayer];
    if([mNfcA1Device readerReadTagSectorData:3] == NO) {
        NSLog(@"readerReadTagSectorData false");
    }
}

- (void) initAudioPlayer {
    if(!mNfcA1Device)
        mNfcA1Device = [[NfcA1Device alloc] init];
    mNfcA1Device.delegate = self;
}

- (void)receivedMessage:(SInt32)type Result:(Boolean)result Data:(void *)data {
    switch (type) {
        case MESSAGE_READER_GET_TAG_UID:
            if (result)
            {
                MSG_INFORM_DATA *infrom_data = data;
                
                NSString *tagUID =
                [self hexDataToString: infrom_data->data Length: 7];
                memcpy(gTagUID,infrom_data->data,sizeof(gTagUID));
                
                _RecordOper.text = [tagUID substringWithRange:NSMakeRange(0, 8)];
                
                NSString *strStatus =[NSString stringWithFormat:@"%02X",infrom_data->status];
                
                NSLog(@"tagUID:%@", [NSString stringWithFormat:@"Tag UID:%@,%@",tagUID,strStatus]);
                
                isStartListeningThread = NO;
                isFocusOnRecordOper = NO;
                [self indicatorROStop];
                [_RecordOper resignFirstResponder];
            }
            break;
            
        case MESSAGE_READER_READ_TAG_SECTOR_DATA:
            if (result) {
                MSG_INFORM_DATA *infrom_data = data;
                
                NSString *blockData =
                [self sectorHexDataToString: infrom_data->data Length: 48];
                
                _VentNo.text = blockData;
                
                NSString *strStatus =[NSString stringWithFormat:@"%02X",infrom_data->status];
                
                NSLog(@"SectorData:%@", [NSString stringWithFormat:@"Read Tag Sector Data:\n%@,%@",blockData,strStatus]);
                
                isStartListeningThread = NO;
                isFocusOnVentNo = NO;
                [self indicatorVNOStop];
                [_VentNo resignFirstResponder];
            }
            break;
            
        default:
            break;
    }
    
    //持續listening直到讀到資料為止
    if (isStartListeningThread) {
        if (isFocusOnRecordOper) {
            NSLog(@"FocusOnRecordOper");
            if([mNfcA1Device readerGetTagUID] == YES) {
                
            }
            else {
                NSLog(@"readerGetTagUID false");
            }
        }
        else if (isFocusOnVentNo) {
            NSLog(@"FocusOnVentNo");
            if([mNfcA1Device readerReadTagSectorData:3] == YES) {
                
            }
            else {
                NSLog(@"readerReadTagSectorData false");
            }
        }
        else {
            NSLog(@"stop listening.");
            isStartListeningThread = NO;
        }
    }
}

- (void)indicatorROStart {
    [_RecordOper setPlaceholder:@"讀取中......"];
    [_indicatorRO startAnimating];
}

- (void)indicatorROStop {
    [_RecordOper setPlaceholder:@"點選開始掃瞄治療師卡號"];
    [_indicatorRO stopAnimating];
}

- (void)indicatorVNOStart {
    [_VentNo setPlaceholder:@"讀取中......"];
    [_indicatorVNO startAnimating];
}

- (void)indicatorVNOStop {
    [_VentNo setPlaceholder:@"點選開始掃瞄儀器ID"];
    [_indicatorVNO stopAnimating];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (![self isHeadsetPluggedIn]) {
        isStartListeningThread = NO;
        isFocusOnRecordOper = NO;
        isFocusOnVentNo = NO;
        return;
    }
    
    if (!isStartListeningThread) {
        if (textField == _RecordOper && !isFocusOnRecordOper) {
            NSLog(@"RecordOper");
            isStartListeningThread = YES;
            isFocusOnRecordOper = YES;
            isFocusOnVentNo = NO;
            [self indicatorROStart];
            [self listeningRecordOper];
        }
        else if(textField == _VentNo && !isFocusOnVentNo) {
            NSLog(@"VentNo");
            isStartListeningThread = YES;
            isFocusOnRecordOper = NO;
            isFocusOnVentNo = YES;
            [self indicatorVNOStart];
            [self listeningVentNo];
        }
    }
    else {
        if (textField == _RecordOper && !isFocusOnRecordOper) {
            isStartListeningThread = YES;
            isFocusOnRecordOper = YES;
            isFocusOnVentNo = NO;
            [self indicatorROStart];
        }
        else if(textField == _VentNo && !isFocusOnVentNo) {
            isStartListeningThread = YES;
            isFocusOnRecordOper = NO;
            isFocusOnVentNo = YES;
            [self indicatorVNOStart];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _RecordOper) {
        isFocusOnRecordOper = NO;
        [self indicatorROStop];
        NSLog(@"RecordOper leave");
    }
    else if(textField == _VentNo) {
        NSLog(@"VentNo leave");
        [self indicatorVNOStop];
        isFocusOnVentNo = NO;
    }
}

#pragma mark - BLE
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@ connected.", peripheral.name);
    
    if(_peripheral != nil) {
        //NSLog(@"Connect To Peripheral with name: %@\nwith UUID:%@\n",peripheral.name,CFUUIDCreateString(nil, peripheral.UUID));
        
        peripheral.delegate = self;
        
        //執行"discoverService"功能去尋找可用的Service
        [peripheral discoverServices:@[[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]]];//藍牙棒Service UUID
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        return;
    }
    
    for (CBService *service in peripheral.services) {
        if (service.characteristics) {
            [self peripheral:peripheral didDiscoverCharacteristicsForService:service error:nil]; //already discovered characteristic before, DO NOT do it again
        }
        else {
            [peripheral discoverCharacteristics:nil forService:service]; //need to discover characteristics
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            _notifyCharacteristic = characteristic;
            NSLog(@"[notify]didDiscoverCharacteristicsForService");
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-8841-43F4-A8D4-ECBE34729BB3"]]) {
            [peripheral setNotifyValue:NO forCharacteristic:characteristic];
            _writeCharacteristic = characteristic;
            NSLog(@"[write]didDiscoverCharacteristicsForService");
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    if (_notifyCharacteristic != nil && _writeCharacteristic != nil) {
        if (_peripheral.state != CBPeripheralStateDisconnected) {
            //MeasureData *measureData = [self readData];
            bleStep = 1;
            [self sendCmdStep];
            VentilationData *measureData = nil;
            if (measureData != nil) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                NSString *stringDateTime = [dateFormatter stringFromDate:[NSDate date]];
                measureData.RecordTime = stringDateTime;
                _RecordTime.text = stringDateTime;
                ((MeasureTabBarViewController *)self.tabBarController).measureData = measureData;
                //中斷連線
                //[self disconnect];
                [((MeasureTabBarViewController *)self.tabBarController) setSelectedIndex:1];
            }
        }

    }
}

- (BOOL)dataCheck:(NSData *)data header:(int)header command:(int)cmd {
    NSUInteger len = [data length];
    const char *buffer = [data bytes];
    BOOL headerFound = NO, cmdFound = NO;
    if (len > 2) {
        for(int i = 0; i < len; i++) {
            if(!headerFound && buffer[i] == header) {
                headerFound = YES;
                continue;
            }
            else if(headerFound && !cmdFound && buffer[i] == cmd) {
                cmdFound = YES;
                continue;
            }
            else if(headerFound && cmdFound && buffer[i] == CR) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)resetMData {
    if ([_mData length] > 0) {
        //[_mData replaceBytesInRange:NSMakeRange(0, [_mData length]) withBytes:nil length:0];
        [_mData setLength:0];
        NSLog(@"mData reset");
    }
}

//收到的notification
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error");
        return;
    }
    
    if (characteristic.value != nil) {
        const char *buffer = [characteristic.value bytes];
        if (bleStep == 0 && [characteristic.value length] > 5 && buffer[0] == ESC && buffer[1] == ICC && buffer[2] == 0x36 && buffer[3] == 0x43 && buffer[4] == CR) {
            return;
        }
        [_mData appendData:characteristic.value];
    }
    
    if ([_mData length] > 0) {
        //NSLog(@"%@", [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
        NSLog(@"bleStep:%02ld %@", bleStep, [[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding]);
        
        const char *bytes = [_mData bytes];
        NSUInteger dataLen = [_mData length];
        if (dataLen > 5) {
            //尾碼是Q6C就斷線
            if (bytes[dataLen - 5] == ESC && bytes[dataLen - 4] == ICC && bytes[dataLen - 3] == 0x36 && bytes[dataLen - 2] == 0x43 && bytes[dataLen - 1] == CR) {
                bleStep = 0;
                [self resetMData];
                [self disconnect];
                return;
            }
        }
        
        if ([self dataCheck:_mData header:SOH command:ICC]) {
            NSLog(@"ICC OK");
            bleStep = 2;
            [self resetMData];
            //取得模式
            [self  sendConfigDataCommandWithoutResponse:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_CURRENT_TEXT_MESSAGES dataCode:@"010206070E2D2E2F30311A0C0D32330A0B11350F1047203A2148491E222324"];
        }
        else if (bleStep == 2) {
            if ([self dataCheck:_mData header:SOH command:CONFIGURE_DATA_RESPONSE_COMMAND]) {
                bleStep = 3;
                [self resetMData];
                [self sendBasicCommandWithoutResponse:ESC cmdCode:REQUEST_CURRENT_TEXT_MESSAGES];
                }
        }
        else if (bleStep == 3) {
            if ([self dataCheck:_mData header:SOH command:REQUEST_CURRENT_TEXT_MESSAGES]) {
                NSString *strMode = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
                int index = (int)[strMode rangeOfString:@"*"].location + 1;
                myMeasureData.VentilationMode = [strMode substringWithRange:NSMakeRange(index, 2)];
                if (![myMeasureData.VentilationMode caseInsensitiveCompare:@"2E"]
                    || ![myMeasureData.VentilationMode caseInsensitiveCompare:@"2F"]
                    || ![myMeasureData.VentilationMode caseInsensitiveCompare:@"30"]
                    || ![myMeasureData.VentilationMode caseInsensitiveCompare:@"31"]
                    || ![myMeasureData.VentilationMode caseInsensitiveCompare:@"32"]
                    || ![myMeasureData.VentilationMode caseInsensitiveCompare:@"33"]) {
                    myMeasureData.AutoFlow = @"Yes";
                }
                else {
                    myMeasureData.AutoFlow = @"No";
                }
                myMeasureData.VentilationMode = [self getMode:myMeasureData.VentilationMode];
                NSLog(@"取得模式 pass.");
                
                bleStep = 4;
                [self resetMData];
                
                //取得設定值
                [self sendConfigDataCommandWithoutResponse:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_CURRENT_DEVICE_SETTING dataCode:@"010204050708090B0D0E0F1011121316292E3C3D4E"];
            }
        }
        else if (bleStep == 4) {
            if ([self dataCheck:_mData header:SOH command:CONFIGURE_DATA_RESPONSE_COMMAND]) {
                bleStep = 5;
                [self resetMData];
                
                [self sendBasicCommandWithoutResponse:ESC cmdCode:REQUEST_CURRENT_DEVICE_SETTING];
            }
        }
        else if (bleStep == 5) {
            if ([self dataCheck:_mData header:SOH command:REQUEST_CURRENT_DEVICE_SETTING]) {
                NSString *resultSetting = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
                [self parseSet:resultSetting MeasureData:myMeasureData];
                
                if (![myMeasureData.TidalVolumeSet isEqualToString:@""] && ![myMeasureData.VentilationRateSet isEqualToString:@""]) {
                    myMeasureData.MVSet = [NSString stringWithFormat:@"%.1lf", [myMeasureData.TidalVolumeSet floatValue] * [myMeasureData.VentilationRateSet floatValue] / 1000];
                }
                else
                {
                    NSLog(@"mvset missed");
                }
                
                if (myMeasureData.PressureSupport != nil && ![myMeasureData.PressureSupport isEqualToString:@""] && myMeasureData.PEEP != nil && ![myMeasureData.PEEP isEqualToString:@""]) {
                    //PressureSupport = PressureSupport - PEEP
                    myMeasureData.PressureSupport = [NSString stringWithFormat:@"%f", [myMeasureData.PressureSupport floatValue] - [myMeasureData.PEEP floatValue]];
                }
            }
            
            bleStep = 6;
            [self resetMData];
            
            //取得量測值
            NSLog(@"取得量測值");
            [self sendConfigDataCommandWithoutResponse:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_CURRENT_MEASURED_DATA_PAGE1 dataCode:@"060B73747D88B9D6F0"];
        }
        else if (bleStep == 6) {
            if ([self dataCheck:_mData header:SOH command:CONFIGURE_DATA_RESPONSE_COMMAND]) {
                bleStep = 7;
                [self resetMData];
                [self sendBasicCommandWithoutResponse:ESC cmdCode:REQUEST_CURRENT_MEASURED_DATA_PAGE1];
            }
            
        }
        else if (bleStep == 7) {
            if ([self dataCheck:_mData header:SOH command:REQUEST_CURRENT_MEASURED_DATA_PAGE1]) {
                NSString *values = [[NSString alloc] initWithString:[[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding]];
                [self parseMeadused:values MeasureData:myMeasureData];
                bleStep = 8;
                [self resetMData];
                //LowerMV
                NSLog(@"LowerMV");
                [self sendConfigDataCommandWithoutResponse:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_LOW_ALARM_LIMITS_PAGE1 dataCode:@"B9"];
            }
        }
        else if (bleStep == 8) {
            if ([self dataCheck:_mData header:SOH command:CONFIGURE_DATA_RESPONSE_COMMAND]) {
                bleStep = 9;
                [self resetMData];
                [self sendBasicCommandWithoutResponse:ESC cmdCode:REQUEST_LOW_ALARM_LIMITS_PAGE1];
            }
            
        }
        else if (bleStep == 9) {
            if ([self dataCheck:_mData header:SOH command:REQUEST_LOW_ALARM_LIMITS_PAGE1]) {
                NSString *values = [[NSString alloc] initWithString:[[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding]];
                NSString *strMeasure = [values substringWithRange:NSMakeRange(2, [values length] - 2)];
                if ([strMeasure isEqualToString:@""]) {
                    return;
                }
                myMeasureData.LowerMV = [[strMeasure substringWithRange:NSMakeRange(2, 4)] stringByReplacingOccurrencesOfString:@" " withString:@""];
                bleStep = 10;
                [self resetMData];
                
                //HightPerssureAlarm
                NSLog(@"HightPerssureAlarm");
                [self sendConfigDataCommandWithoutResponse:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_HIGHT_ALARM_LIMITS_PAGE1 dataCode:@"7D"];
            }
        }
        else if (bleStep == 10) {
            if ([self dataCheck:_mData header:SOH command:CONFIGURE_DATA_RESPONSE_COMMAND]) {
                bleStep = 11;
                [self resetMData];
                [self sendBasicCommandWithoutResponse:ESC cmdCode:REQUEST_HIGHT_ALARM_LIMITS_PAGE1];
            }
            
        }
        else if (bleStep == 11) {
            if ([self dataCheck:_mData header:SOH command:REQUEST_HIGHT_ALARM_LIMITS_PAGE1]) {
                NSString *values = [[NSString alloc] initWithString:[[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding]];
                NSString *strMeasure = [values substringWithRange:NSMakeRange(2, [values length] - 2)];
                myMeasureData.HighPressureAlarm = [[strMeasure substringWithRange:NSMakeRange(2, 4)] stringByReplacingOccurrencesOfString:@" " withString:@""];
                bleStep = 12;
                [self resetMData];
                [self sendBasicCommandWithoutResponse:ESC cmdCode:STOP];
            }
        }
        else if (bleStep == 12) {
            VentilationData *measureData = myMeasureData;
            if (measureData != nil) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
                NSString *stringDateTime = [dateFormatter stringFromDate:[NSDate date]];
                measureData.RecordTime = stringDateTime;
                _RecordTime.text = stringDateTime;
                ((MeasureTabBarViewController *)self.tabBarController).measureData = measureData;
                //中斷連線
                [self disconnect];
                [((MeasureTabBarViewController *)self.tabBarController) setSelectedIndex:1];
                bleStep = 0;
                [self resetMData];
            }
        }
    }
}

#pragma mark - Methods
- (IBAction)btnSaveClick:(id)sender {
    for (UIViewController *child in self.childViewControllers) {
        if ([child isKindOfClass:[MeasureTabBarViewController class]]) {
            for (UIViewController *v in ((MeasureTabBarViewController *)child).viewControllers) {
                if ([v isKindOfClass:[VentilatorDataViewController class]]) {
                    if ([v isViewLoaded]) {
                        VentilatorDataViewController *vc = (VentilatorDataViewController *)v;
                        [vc getMeasureData:_measureData];
                    }
                }
                else if ([v isKindOfClass:[OtherDataViewController class]]) {
                    if ([v isViewLoaded]) {
                        OtherDataViewController *vc = (OtherDataViewController *)v;
                        [vc getMeasureData:_measureData];
                    }
                }
            }

        }
    }
}

- (IBAction)btnCancleClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)disconnect {
    [_centralManager cancelPeripheralConnection:_peripheral];
    _notifyCharacteristic = nil;
    _writeCharacteristic = nil;
    NSLog(@"Disconnect.");
}

//CHECKSUM Least significant 8-bit sum of all preceding bytes beginning with "ESC" in ASCII HEX format
- (const char *)getChkSum:(int)sum {
    NSString *sumString = [NSString stringWithFormat:@"%02X", sum];
    sumString = [sumString substringWithRange:NSMakeRange([sumString length] - 2, 2)];
    return [sumString UTF8String];
    
}

- (CBPeripheral *)getPeripheralByCode:(NSString *)code {
    NSString *uuidString = [code rangeOfString:@"**"].location == NSNotFound ? code : [[code componentsSeparatedByString:@"**"] objectAtIndex:0];
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    
    NSArray *ary = [_centralManager retrievePeripheralsWithIdentifiers:@[uuid]];
    CBPeripheral *p = [ary objectAtIndex:0];
    
    return p;
}

- (void)connectToPeripheral:(CBPeripheral *)peripheral {
    if(_centralManager != nil && _peripheral != nil && _peripheral.state != CBPeripheralStateConnected) {
        [_centralManager connectPeripheral:_peripheral options:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"裝置連接失敗" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)readValue {
    [_peripheral readValueForCharacteristic:_notifyCharacteristic];
}

- (void)sendData:(NSData *)mData {
    @try {
        int count = (int)[mData length];
        NSLog(@"SendData:%d", count);
        [_peripheral writeValue:mData forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
    @catch (NSException *exception) {
        NSLog(@"SendData Exception: %@", exception);
    }
}

#pragma mark - Drager Command 
- (void)sendICC {
    int esc = ESC, icc = ICC, cr = CR;
    const char *chkSum = [self getChkSum:(esc + icc)];
    unsigned char cmd[5] = {esc, icc, chkSum[0], chkSum[1], cr};
    NSData *dataCmd = [NSData dataWithBytes:cmd length:sizeof(cmd)];
    
    [self sendData:dataCmd];
    NSLog(@"ICC Send");
}

- (void)sendCmdStep {
    if (bleStep == 1) {
        //ICC
        [self sendICC];
    }
    else {
        bleStep = 0;
    }
}

#pragma mark - Drager
- (NSData *)getData {
    NSData *data = [[NSData alloc] init];
    while (YES) {
        if (_data != nil && [_data length] > 0) {
            NSLog(@"_data");
            data = [NSData dataWithData:_data];
            break;
        }
        
        if (_mData != nil && [_mData length] > 0) {
            NSLog(@"_mData");
            data = [NSData dataWithData:_mData];
            break;
        }
        //NSLog(@"sleep");
        usleep(300000);
    }
    return data;
}

- (NSData *)readByCR {
    NSMutableData *result = [[NSMutableData alloc] init];
    
    int nilCount = 0;
    while (YES) {
        if (_data != nil) {
            nilCount = 0;
            [result appendData:[self getData]];
            
            const char *bytes = [result bytes];
            if (bytes[sizeof(bytes) - 1] == CR) {
                break;
            }
        }
        else {
            if (++nilCount == 30) {
                [NSException raise:@"sendConfigDataCommand timeout." format:@"Error", nil];
            }
        }
        
        
        usleep(10000);
    }
    
    return result;
}

- (NSData *)basicCommand:(int)header cmdCode:(int)cmdCode {
    unsigned char result[5];
    result[0] = header;
    result[1] = cmdCode;
    
    const char *chkSum = [self getChkSum:(header + cmdCode)];
    result[2] = chkSum[0];
    result[3] = chkSum[1];
    result[4] = CR;
    
    return [[NSData alloc]initWithBytes:result length:sizeof(result)];
}

- (NSData *)sendBasicCommand:(int)header cmdCode:(int)cmdCode {
    NSData *cmd = [self basicCommand:header cmdCode:cmdCode];
    [self sendData:cmd];
    
    NSData *result = [self getData];
    return  result;
}

- (void)sendBasicCommandWithoutResponse:(int)header cmdCode:(int)cmdCode {
    NSData *cmd = [self basicCommand:header cmdCode:cmdCode];
    [self sendData:cmd];
}

- (NSData *)configDataCommand:(int)cmdCode dataType:(int)dataType dataCode:(NSString *)dataCode {
    NSData *data = [dataCode dataUsingEncoding:NSUTF8StringEncoding];
    int i, sum = 0, size = 6 + (int)[data length];
    unsigned char buffer[size];
    buffer[0] = ESC;
    buffer[1] = cmdCode;
    buffer[2] = dataType;
    
    const char *bytes = [data bytes];
    for (i = 0; i < [data length]; i++) {
        buffer[i + 3] = bytes[i];
    }
    for (i = 0; i < sizeof(buffer) - 3; i++) {
        sum += buffer[i];
    }
    
    const char *chkSum = [self getChkSum:sum];
    buffer[size - 3] = chkSum[0];
    buffer[size - 2] = chkSum[1];
    buffer[size - 1] = CR;
    
    return [[NSData alloc] initWithBytes:buffer length:sizeof(buffer)];
}

- (NSData *)sendConfigDataCommand:(int)cmdCode dataType:(int)dataType dataCode:(NSString *)dataCode {
    NSData *cmd = [self configDataCommand:cmdCode dataType:dataType dataCode:dataCode];
    [self sendData:cmd];
    
    NSData *result = [self getData];
    return  result;
}

- (void)sendConfigDataCommandWithoutResponse:(int)cmdCode dataType:(int)dataType dataCode:(NSString *)dataCode {
    NSData *cmd = [self configDataCommand:cmdCode dataType:dataType dataCode:dataCode];
    [self sendData:cmd];
}

//尾碼是CR的時候回傳
- (NSData *)getDataTillCR:(NSString *)callBy {
    int iCR = CR;
    NSMutableData *data = [[NSMutableData alloc] init];
    int nilCount = 0;
    while (YES) {
        if (_data != nil) {
            nilCount = 0;
            [data appendData:[self getData]];
            const char *buffer = [data bytes];
            
            int len = (int)[data length] - 1;
            if (buffer[len] == iCR) {
                return data;
            }
        }
        else {
            if(++nilCount == 9) {
                [NSException raise:@"_data nil 10 times" format:callBy, nil];
                return nil;
            }
        }
        usleep(100000);
    }
}

- (BOOL)_ICC {
    int esc = ESC, icc = ICC, soh = SOH, cr = CR;
    const char *chkSum = [self getChkSum:(esc + icc)];
    unsigned char cmd[5] = {esc, icc, chkSum[0], chkSum[1], cr};
    NSData *dataCmd = [NSData dataWithBytes:cmd length:sizeof(cmd)];
    
    [self sendData:dataCmd];
    NSLog(@"ICC Send");
    chkSum = [self getChkSum:(soh + icc)];
    unsigned char res[5] = {soh, icc, chkSum[0], chkSum[1], cr};
    NSData *data = [self getData];
    if ([data length] > 0 && [data isEqualToData: [NSData dataWithBytes:res length:sizeof(res)]]) {
        return YES;
    }
    return NO;
}

- (NSString *)getMode:(NSString *)code {
    code = [code stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (![code caseInsensitiveCompare:@"01"]) {
        return @"IPPV";
    } else if (![code caseInsensitiveCompare:@"02"]) {
        return @"IPPV/ASSIST";
    } else if (![code caseInsensitiveCompare:@"06"]) {
        return @"SIMV";
    } else if (![code caseInsensitiveCompare:@"07"]) {
        return @"SIMV/ASB";
    } else if (![code caseInsensitiveCompare:@"0E"]) {
        return @"BiPAP";
    } else if (![code caseInsensitiveCompare:@"2D"]) {
        return @"BIPAP/ASB";
    } else if (![code caseInsensitiveCompare:@"2E"]) {
        return @"SIMV/AutoFlow";
    } else if (![code caseInsensitiveCompare:@"2F"]) {
        return @"SIMV/ASB/AutoFlow";
    } else if (![code caseInsensitiveCompare:@"30"]) {
        return @"IPPV/ASSIST/AutoFlow";
    } else if (![code caseInsensitiveCompare:@"31"]) {
        return @"IPPV/ASSIST/AutoFlow";
    } else if (![code caseInsensitiveCompare:@"1A"]) {
        return @"APRV";
    } else if (![code caseInsensitiveCompare:@"0C"]) {
        return @"MMV";
    } else if (![code caseInsensitiveCompare:@"0D"]) {
        return @"MMV/ASB";
    } else if (![code caseInsensitiveCompare:@"32"]) {
        return @"MMV/AutoFlow";
    } else if (![code caseInsensitiveCompare:@"33"]) {
        return @"MMV/ASB/AutoFlow";
    } else if (![code caseInsensitiveCompare:@"0A"]) {
        return @"CPAP";
    } else if (![code caseInsensitiveCompare:@"0B"]) {
        return @"CPAP/ASB";
    } else if (![code caseInsensitiveCompare:@"11"]) {
        return @"APNEA VENTILATION";
    } else if (![code caseInsensitiveCompare:@"35"]) {
        return @"CPAP/PPS";
    } else if (![code caseInsensitiveCompare:@"0F"]) {
        return @"SYNCHRON MASTER";
    } else if (![code caseInsensitiveCompare:@"10"]) {
        return @"SYNCHRON SLAVE";
    } else if (![code caseInsensitiveCompare:@"47"]) {
        return @"BIPAP/ASSIST";
    } else if (![code caseInsensitiveCompare:@"20"]) {
        return @"Adults";
    } else if (![code caseInsensitiveCompare:@"3A"]) {
        return @"Pediatrics";
    } else if (![code caseInsensitiveCompare:@"21"]) {
        return @"Neonates";
    } else if (![code caseInsensitiveCompare:@"48"]) {
        return @"IV";
    } else if (![code caseInsensitiveCompare:@"49"]) {
        return @"NIV";
    } else if (![code caseInsensitiveCompare:@"1E"]) {
        return @"STANDBY";
    } else if (![code caseInsensitiveCompare:@"22"]) {
        return @"mmHg";
    } else if (![code caseInsensitiveCompare:@"23"]) {
        return @"kPa";
    } else if (![code caseInsensitiveCompare:@"24"]) {
        return @"%";
    }
    
    return code;
}

- (void)parseSet:(NSString *)values MeasureData:(VentilationData *)refData {
    NSString *strSetting = [values substringWithRange:NSMakeRange(2, [values length] - 2)];
    NSInteger size = [strSetting length] / 7;
    NSString *code, *value;
    
    for (int i = 0; i < size; i++) {
        code = [strSetting substringWithRange:NSMakeRange((i * 2) + (i * 5), 2)];
        value = [[strSetting substringWithRange:NSMakeRange((i * 2) + (i * 5) + 2, 5)] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (![code caseInsensitiveCompare:@"01"]) {
            // _XXX_
            refData.FiO2Set = value;
        } else if (![code caseInsensitiveCompare:@"02"]) {
            // XXX.X
            refData.FlowSetting = value;
        } else if (![code caseInsensitiveCompare:@"04"]) {
            // X.XXX
            refData.TidalVolumeSet = [NSString stringWithFormat:@"%.2lf", [value floatValue] * 1000];
        } else if (![code caseInsensitiveCompare:@"05"]) {
            // XX.XX
            refData.InspTime = value;
        } else if (![code caseInsensitiveCompare:@"07"]) {
            // XXX.X
            refData.IERatio = value;
        } else if (![code caseInsensitiveCompare:@"08"]) {
            refData.IERatio = [@"1:" stringByAppendingString:value];
        } else if (![code caseInsensitiveCompare:@"09"]) {
            // XXX.X
            refData.VentilationRateSet = value;
        } else if (![code caseInsensitiveCompare:@"0A"]) {
            
        } else if (![code caseInsensitiveCompare:@"0B"]) {
            // _XX.X
            refData.PEEP = value;
        } else if (![code caseInsensitiveCompare:@"0C"]) {
            
        } else if (![code caseInsensitiveCompare:@"0D"]) {
            // __XX_
            refData.Plow = value;
        } else if (![code caseInsensitiveCompare:@"0E"]) {
            // __XX_
            refData.PHigh = value;
        } else if (![code caseInsensitiveCompare:@"0F"]) {
            // _XX.X
            refData.Tlow = value;
        } else if (![code caseInsensitiveCompare:@"10"]) {
            // _XX.X
            refData.THigh = value;
        } else if (![code caseInsensitiveCompare:@"11"]) {
            
        } else if (![code caseInsensitiveCompare:@"12"]) {
            // _XX.X
            refData.PressureSupport = value;
        } else if (![code caseInsensitiveCompare:@"13"]) {
            // XXX.X
            refData.PressureControl = value;
        } else if (![code caseInsensitiveCompare:@"15"]) {
            
        } else if (![code caseInsensitiveCompare:@"16"]) {
            
        } else if (![code caseInsensitiveCompare:@"17"]) {
            
        } else if (![code caseInsensitiveCompare:@"29"]) {
            
        } else if (![code caseInsensitiveCompare:@"2E"]) {
            
        } else if (![code caseInsensitiveCompare:@"3C"]) {
            // XXXXX
            refData.FlowSensitivity = [NSString stringWithFormat:@"%f", [value floatValue] / 10];
        } else if (![code caseInsensitiveCompare:@"3D"]) {
            // XXXXX
            refData.BaseFlow = [NSString stringWithFormat:@"%f", [value floatValue] / 10];
        } else if (![code caseInsensitiveCompare:@"4E"]) {
            
        }
    }
}

- (void)parseMeadused:(NSString *)values MeasureData:(VentilationData *)refData {
    NSString *strMeasure = [values substringWithRange:NSMakeRange(2, [values length] - 2)];
    int size = (int)[strMeasure length] / 6;
    NSString *code, *value;
    for (int i = 0; i < size; i++) {
        code = [strMeasure substringWithRange:NSMakeRange((i * 2) + (i * 4), 2)];
        value = [[strMeasure substringWithRange:NSMakeRange((i * 2) + (i * 4) + 2, 4)] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (![code caseInsensitiveCompare:@"06"]) {
            // XX.X
            refData.Compliance = value;
        } else if (![code caseInsensitiveCompare:@"07"]) {
            
        } else if (![code caseInsensitiveCompare:@"0B"]) {
            // XX.X
            refData.Resistance = value;
        } else if (![code caseInsensitiveCompare:@"08"]) {
            
        } else if (![code caseInsensitiveCompare:@"71"]) {
            
        } else if (![code caseInsensitiveCompare:@"72"]) {
            
        } else if (![code caseInsensitiveCompare:@"73"]) {
            // XXX_
            refData.MeanPressure = value;
        } else if (![code caseInsensitiveCompare:@"74"]) {
            // XXX_
            refData.PlateauPressure = value;
        } else if (![code caseInsensitiveCompare:@"78"]) {
            
        } else if (![code caseInsensitiveCompare:@"79"]) {
            
        } else if (![code caseInsensitiveCompare:@"7D"]) {
            // XXX_
            refData.PeakPressure = value;
        } else if (![code caseInsensitiveCompare:@"81"]) {
            
        } else if (![code caseInsensitiveCompare:@"82"]) {
            
        } else if (![code caseInsensitiveCompare:@"88"]) {
            // _XXX
            refData.TidalVolumeMeasured = value;
        } else if (![code caseInsensitiveCompare:@"B5"]) {
            
        } else if (![code caseInsensitiveCompare:@"B7"]) {
            
        } else if (![code caseInsensitiveCompare:@"7A"]) {
            
        } else if (![code caseInsensitiveCompare:@"B8"]) {
            
        } else if (![code caseInsensitiveCompare:@"B9"]) {
            // XX.X
            refData.MVTotal = value;
        } else if (![code caseInsensitiveCompare:@"C1"]) {
            
        } else if (![code caseInsensitiveCompare:@"D6"]) {
            // XXX_
            refData.VentilationRateTotal = value;
        } else if (![code caseInsensitiveCompare:@"8B"]) {
            
        } else if (![code caseInsensitiveCompare:@"8D"]) {
            
        } else if (![code caseInsensitiveCompare:@"C9"]) {
            
        } else if (![code caseInsensitiveCompare:@"09"]) {
            
        } else if (![code caseInsensitiveCompare:@"89"]) {
            
        } else if (![code caseInsensitiveCompare:@"8A"]) {
            
        } else if (![code caseInsensitiveCompare:@"DB"]) {
            
        } else if (![code caseInsensitiveCompare:@"E3"]) {
            
        } else if (![code caseInsensitiveCompare:@"E6"]) {
            
        } else if (![code caseInsensitiveCompare:@"F0"]) {
            // XXX_
            refData.FiO2Measured = value;
        } else if (![code caseInsensitiveCompare:@"E1"]) {
            
        } else if (![code caseInsensitiveCompare:@"EB"]) {
            
        }
    }
}

/*- (VentilationData *)readData {
    VentilationData *measureData = [[VentilationData alloc] init];
    
    @try {
        //初始化Drager
        if (![self _ICC]) {
            [NSException raise:@"ICC fail." format:@"Error", nil];
        }
        NSLog(@"ICC pass.");
        //取得模式
        NSLog(@"a取得模式");
        NSData *setMode = [self  sendConfigDataCommand:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_CURRENT_TEXT_MESSAGES dataCode:@"010206070E2D2E2F30311A0C0D32330A0B11350F1047203A2148491E222324"];
        
        NSLog(@"取得模式");
        NSData *mode = [self sendBasicCommand:ESC cmdCode:REQUEST_CURRENT_TEXT_MESSAGES];
        if ([mode length] > 0) {
            NSString *strMode = [[NSString alloc] initWithData:mode encoding:NSUTF8StringEncoding];
            NSUInteger *index = [strMode rangeOfString:@"*"].location + 1;
            measureData.VentilationMode = [strMode substringWithRange:NSMakeRange(index, index + 2)];
            if ([measureData.VentilationMode caseInsensitiveCompare:@"2E"]
                || [measureData.VentilationMode caseInsensitiveCompare:@"2F"]
                || [measureData.VentilationMode caseInsensitiveCompare:@"30"]
                || [measureData.VentilationMode caseInsensitiveCompare:@"31"]
                || [measureData.VentilationMode caseInsensitiveCompare:@"32"]
                || [measureData.VentilationMode caseInsensitiveCompare:@"33"]) {
                measureData.AutoFlow = @"Yes";
            }
            measureData.VentilationMode = [self getMode:measureData.VentilationMode];
            NSLog(@"取得模式 pass.");
        }
        return measureData;
        
        //取得設定值
        NSData *setSetting = [self sendConfigDataCommand:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_CURRENT_DEVICE_SETTING dataCode:@"010204050708090B0D0E0F1011121316292E3C3D4E"];
        NSData *setting = [self sendBasicCommand:ESC cmdCode:REQUEST_CURRENT_DEVICE_SETTING];
        
        if ([setting length] > 5) {
            NSString *resultSetting = [[NSString alloc] initWithData:setting encoding:NSUTF8StringEncoding];
            [self parseSet:resultSetting MeasureData:measureData];

            if (![measureData.TidalVolumeSet isEqualToString:@""] && [measureData.VentilationRateSet isEqualToString:@""]) {
                measureData.MVSet = [NSString stringWithFormat:@"%f", [measureData.TidalVolumeSet floatValue] * [measureData.VentilationRateSet floatValue] / 1000];
            }
            
            if (measureData.PressureSupport != nil && ![measureData.PressureSupport isEqualToString:@""] && measureData.PEEP != nil && ![measureData.PEEP isEqualToString:@""]) {
                //PressureSupport = PressureSupport - PEEP
                measureData.PressureSupport = [NSString stringWithFormat:@"%f", [measureData.PressureSupport floatValue] - [measureData.PEEP floatValue]];
            }
        }
        NSLog(@"取得設定值 pass.");
        
        //取得量測值
        NSLog(@"取得量測值");
        NSData *setMeasure = [self sendConfigDataCommand:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_CURRENT_MEASURED_DATA_PAGE1 dataCode:@"060B73747D88B9D6F0"];
        NSData *measure = [self sendBasicCommand:ESC cmdCode:REQUEST_CURRENT_MEASURED_DATA_PAGE1];
        
        if ([measure length] > 5) {
            NSString *values = [[NSString alloc] initWithString:measure];
            [self parseMeadused:values MeasureData:measureData];
        }
        
        //LowerMV
        NSLog(@"LowerMV");
        NSData *setLowerMV = [self sendConfigDataCommand:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_LOW_ALARM_LIMITS_PAGE1 dataCode:@"B9"];
        NSData *LowerMV = [self sendBasicCommand:ESC cmdCode:REQUEST_LOW_ALARM_LIMITS_PAGE1];
        if ([LowerMV length] > 5) {
            NSString *values = [[NSString alloc] initWithString:LowerMV];
            NSString *strMeasure = [values substringWithRange:NSMakeRange(2, [values length] - 2)];
            measureData.LowerMV = [[strMeasure substringWithRange:NSMakeRange(2, 6)] stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        //HightPerssureAlarm
        NSLog(@"HightPerssureAlarm");
        NSData *setHightPerssureAlarm = [self sendConfigDataCommand:CONFIGURE_DATA_RESPONSE_COMMAND dataType:REQUEST_HIGHT_ALARM_LIMITS_PAGE1 dataCode:@"7D"];
        NSData *hightPerssureAlarm = [self sendBasicCommand:ESC cmdCode:REQUEST_HIGHT_ALARM_LIMITS_PAGE1];
        
        if ([hightPerssureAlarm length] > 5) {
            NSString *values = [[NSString alloc] initWithString:hightPerssureAlarm];
            NSString *strMeasure = [values substringWithRange:NSMakeRange(2, [values length] - 2)];
            measureData.HighPressureAlarm = [[strMeasure substringWithRange:NSMakeRange(2, 6)] stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        //[self sendBasicCommand:ESC cmdCode:STOP];
    }
    @catch (NSException *exception) {
        //[self sendBasicCommand:ESC cmdCode:STOP];
        NSLog(@"Read Data Exception: %@", exception);
    }
    return measureData;
}*/

@end
