//
//  VentilationData.h
//  BLE
//
//  Created by Farland on 2014/3/3.
//  Copyright (c) 2014年 Yuekang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VentilationData : NSObject

typedef NS_ENUM(NSInteger, VENTILATION_MODE) {
    AC,
    CPPV,
    SIMV,
    SIMVPS,
    PS,
    CPAP,
    PCV,
    PLV,
    VS,
    PRVC,
    PAC,
    PSIMV,
    APVC,
    APVS,
    ASV,
    APRV,
    BIPAP,
    _NIV
};

@property (nonatomic) NSInteger MeasureId;

#pragma mark - 量測者、量測裝置等資料
//病歷號
@property (strong, nonatomic) NSString *ChtNo;
//紀錄時間
@property (strong, nonatomic) NSString *RecordTime;
//裝置IP
@property (strong, nonatomic) NSString *RecordIp;
//治療師ID
@property (strong, nonatomic) NSString *RecordOper;
//裝置序號
@property (strong, nonatomic) NSString *RecordDevice;
//APP 版本
@property (strong, nonatomic) NSString *RecordClientVersion;
//呼吸器代號 (XXXXXXXXXXXX**YYYYY)
@property (strong, nonatomic) NSString *VentNo;
//原始資料,目前先填空白
@property (strong, nonatomic) NSString *RawData;

#pragma mark - 呼吸器量測資料
@property (strong, nonatomic) NSString *VentilationMode;
@property (strong, nonatomic) NSString *TidalVolumeSet;
@property (strong, nonatomic) NSString *VolumeTarget;
@property (strong, nonatomic) NSString *TidalVolumeMeasured;
@property (strong, nonatomic) NSString *VentilationRateSet;
@property (strong, nonatomic) NSString *SIMVRateSet;
@property (strong, nonatomic) NSString *VentilationRateTotal;
@property (strong, nonatomic) NSString *InspTime;
@property (strong, nonatomic) NSString *THigh;
//I:E Ratio
@property (strong, nonatomic) NSString *IERatio;
@property (strong, nonatomic) NSString *Tlow;
@property (strong, nonatomic) NSString *AutoFlow;
@property (strong, nonatomic) NSString *FlowSetting;
@property (strong, nonatomic) NSString *FlowMeasured;
@property (strong, nonatomic) NSString *Pattern;
//Minute Volume Set
@property (strong, nonatomic) NSString *MVSet;
@property (strong, nonatomic) NSString *PercentMinVolSet;
@property (strong, nonatomic) NSString *MVTotal;
@property (strong, nonatomic) NSString *PeakPressure;
@property (strong, nonatomic) NSString *PlateauPressure;
@property (strong, nonatomic) NSString *MeanPressure;
@property (strong, nonatomic) NSString *PEEP;
@property (strong, nonatomic) NSString *Plow;
@property (strong, nonatomic) NSString *PressureSupport;
@property (strong, nonatomic) NSString *PressureControl;
@property (strong, nonatomic) NSString *PHigh;
@property (strong, nonatomic) NSString *FiO2Set;
@property (strong, nonatomic) NSString *FiO2Measured;
@property (strong, nonatomic) NSString *Resistance;
@property (strong, nonatomic) NSString *Compliance;
@property (strong, nonatomic) NSString *BaseFlow;
@property (strong, nonatomic) NSString *FlowSensitivity;
@property (strong, nonatomic) NSString *LowerMV;
@property (strong, nonatomic) NSString *HighPressureAlarm;
@property (strong, nonatomic) NSString *Temperature;
@property (strong, nonatomic) NSString *ReliefPressure;
@property (strong, nonatomic) NSString *PetCo2;
@property (strong, nonatomic) NSString *SpO2;
@property (strong, nonatomic) NSString *RR;
@property (strong, nonatomic) NSString *TV;
@property (strong, nonatomic) NSString *MV;
@property (strong, nonatomic) NSString *MaxPi;
@property (strong, nonatomic) NSString *Mvv;
@property (strong, nonatomic) NSString *Rsbi;
@property (strong, nonatomic) NSString *EtSize;
@property (strong, nonatomic) NSString *Mark;
@property (strong, nonatomic) NSString *CuffPressure;
@property (strong, nonatomic) NSString *BreathSounds;
@property (strong, nonatomic) NSString *Pr;
@property (strong, nonatomic) NSString *Cvp;
@property (strong, nonatomic) NSString *BpS;
@property (strong, nonatomic) NSString *BpD;
@property (strong, nonatomic) NSString *Memo;
@property (strong, nonatomic) NSString *AutoPEEP;
@property (strong, nonatomic) NSString *PlateauTimeSetting;

@property (strong, nonatomic) NSString *HR;
@property (strong, nonatomic) NSString *PH;
@property (strong, nonatomic) NSString *PaCO2;
@property (strong, nonatomic) NSString *PaO2;
@property (strong, nonatomic) NSString *SaO2;
@property (strong, nonatomic) NSString *HCO3;
@property (strong, nonatomic) NSString *BE;
@property (strong, nonatomic) NSString *PAaDO2;
@property (strong, nonatomic) NSString *Shunt;
@property (strong, nonatomic) NSString *EndTidalCO2;

@property (strong, nonatomic) NSString *PAaO2;
@property (strong, nonatomic) NSString *BP;
@property (strong, nonatomic) NSString *IO;
@property (strong, nonatomic) NSString *ConsciousLevel;
@property (strong, nonatomic) NSString *Hb;
@property (strong, nonatomic) NSString *Sugar;
@property (strong, nonatomic) NSString *Na;
@property (strong, nonatomic) NSString *K;
@property (strong, nonatomic) NSString *Ca;
@property (strong, nonatomic) NSString *Mg;
@property (strong, nonatomic) NSString *BUN;
@property (strong, nonatomic) NSString *Cr;
@property (strong, nonatomic) NSString *Albumin;
@property (strong, nonatomic) NSString *CI;

#pragma mark - 以下參數顯示用,不須上傳
//治療師姓名
@property (strong, nonatomic) NSString *RecordOperName;
//VentilatorModel
@property (strong, nonatomic) NSString *VentilatorModel;
//床號
@property (strong, nonatomic) NSString *BedNo;
//錯誤訊息
@property (strong, nonatomic) NSString *ErrorMsg;
//Checkbox用
@property (nonatomic) BOOL checked;

#pragma mark - -methods
- (NSString *) modeToString:(VENTILATION_MODE)mode;
- (void) setDefaultValue;
- (NSDictionary *)toDictionary;

@end
