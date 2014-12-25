//
//  VentilationData.h.m
//  BLE
//
//  Created by Farland on 2014/3/3.
//  Copyright (c) 2014年 Yuekang. All rights reserved.
//

#import "VentilationData.h"

@implementation VentilationData


#pragma -mark Property
@synthesize MeasureId;
@synthesize ChtNo;
@synthesize RecordTime;
@synthesize RecordIp;
@synthesize RecordOper;
@synthesize RecordDevice;
@synthesize RecordClientVersion;
@synthesize VentNo;
@synthesize RawData;

@synthesize VentilationMode;
@synthesize TidalVolumeSet;
@synthesize VolumeTarget;
@synthesize TidalVolumeMeasured;
@synthesize VentilationRateSet;
@synthesize SIMVRateSet;
@synthesize VentilationRateTotal;
@synthesize InspTime;
@synthesize THigh;
//I:E Ratio
@synthesize IERatio;
@synthesize Tlow;
@synthesize AutoFlow;
@synthesize FlowSetting;
@synthesize FlowMeasured;
@synthesize Pattern;
//Minute Volume Set
@synthesize MVSet;
@synthesize PercentMinVolSet;
@synthesize MVTotal;
@synthesize PeakPressure;
@synthesize PlateauPressure;
@synthesize MeanPressure;
@synthesize PEEP;
@synthesize Plow;
@synthesize PressureSupport;
@synthesize PressureControl;
@synthesize PHigh;
@synthesize FiO2Set;
@synthesize FiO2Measured;
@synthesize Resistance;
@synthesize Compliance;
@synthesize BaseFlow;
@synthesize FlowSensitivity;
@synthesize LowerMV;
@synthesize HighPressureAlarm;
@synthesize Temperature;
@synthesize ReliefPressure;
@synthesize PetCo2;
@synthesize SpO2;
@synthesize RR;
@synthesize TV;
@synthesize MV;
@synthesize MaxPi;
@synthesize Mvv;
@synthesize Rsbi;
@synthesize EtSize;
@synthesize Mark;
@synthesize CuffPressure;
@synthesize BreathSounds;
@synthesize Pr;
@synthesize Cvp;
@synthesize BpS;
@synthesize BpD;
@synthesize Memo;
@synthesize AutoPEEP;
@synthesize PlateauTimeSetting;

@synthesize HR;
@synthesize PH;
@synthesize PaCO2;
@synthesize PaO2;
@synthesize SaO2;
@synthesize HCO3;
@synthesize BE;
@synthesize PAaDO2;
@synthesize Shunt;
@synthesize EndTidalCO2;
@synthesize CI;

//以下參數顯示用,不須上傳
@synthesize RecordOperName;
@synthesize VentilatorModel;
@synthesize BedNo;
@synthesize ErrorMsg;
@synthesize checked;

- (id)init {
    self = [super init];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}

- (NSString *)modeToString:(VENTILATION_MODE)mode {
    switch (mode) {
        case AC:
            return @"A/C";
            
        case CPPV:
            return @"CPPV";
            
        case SIMV:
            return @"SIMV";
            
        case SIMVPS:
            return @"SIMV+PS";
            
        case PS:
            return @"PS";
            
        case CPAP:
            return @"CPAP";
            
        case PCV:
            return @"PCV";
            
        case PLV:
            return @"PLV";
            
        case VS:
            return @"VS";
            
        case PRVC:
            return @"PRVC";
            
        case PAC:
            return @"P A/C";
            
        case PSIMV:
            return @"PSIMV";
            
        case APVC:
            return @"APVc";
            
        case APVS:
            return @"APVs";
            
        case ASV:
            return @"ASV";
            
        case APRV:
            return @"APRV";
            
        case BIPAP:
            return @"BiPAP";
            
        case _NIV:
            return @"NIV";
    }
    return @"";
}

- (void)setDefaultValue {
    MeasureId = 0;
    ChtNo = @"";
    RecordTime = @"";
    RecordIp = @"";
    RecordOper = @"";
    RecordDevice = @"";
    RecordClientVersion = @"";
    VentNo = @"";
    RawData = @"";
    VentilationMode = @"";
    TidalVolumeSet = @"";
    VolumeTarget = @"";
    TidalVolumeMeasured = @"";
    VentilationRateSet = @"";
    SIMVRateSet = @"";
    VentilationRateTotal = @"";
    InspTime = @"";
    THigh = @"";
    IERatio = @"";
    Tlow = @"";
    AutoFlow = @"";
    FlowSetting = @"";
    FlowMeasured = @"";
    Pattern = @"";
    MVSet = @"";
    PercentMinVolSet = @"";
    MVTotal = @"";
    PeakPressure = @"";
    PlateauPressure = @"";
    MeanPressure = @"";
    PEEP = @"";
    Plow = @"";
    PressureSupport = @"";
    PressureControl = @"";
    PHigh = @"";
    FiO2Set = @"";
    FiO2Measured = @"";
    Resistance = @"";
    Compliance = @"";
    BaseFlow = @"";
    FlowSensitivity = @"";
    LowerMV = @"";
    HighPressureAlarm = @"";
    Temperature = @"";
    ReliefPressure = @"";
    PetCo2 = @"";
    SpO2 = @"";
    RR = @"";
    TV = @"";
    MV = @"";
    MaxPi = @"";
    Mvv = @"";
    Rsbi = @"";
    EtSize = @"";
    Mark = @"";
    CuffPressure = @"";
    BreathSounds = @"";
    Pr = @"";
    Cvp = @"";
    BpS = @"";
    BpD = @"";
    Memo = @"";
    AutoPEEP = @"";
    PlateauTimeSetting = @"";
    HR = @"";
    PH = @"";
    PaCO2 = @"";
    PaO2 = @"";
    SaO2 = @"";
    HCO3 = @"";
    BE = @"";
    PAaDO2 = @"";
    Shunt = @"";
    EndTidalCO2 = @"";
    RecordOperName = @"";
    VentilatorModel = @"";
    BedNo = @"";
    ErrorMsg = @"";
    CI = @"";
    checked = NO;
}

- (NSString *)getStringWithoutNil:(NSString *)string {
    return string == nil ? @"" : string;
}

- (NSDictionary *)toDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%ld", MeasureId], @"MeasureId",
            [self getStringWithoutNil:ChtNo], @"ChtNo",
            [self getStringWithoutNil:RecordTime], @"RecordTime",
            [self getStringWithoutNil:RecordIp], @"RecordIp",
            [self getStringWithoutNil:RecordOper], @"RecordOper",
            [self getStringWithoutNil:RecordDevice], @"RecordDevice",
            [self getStringWithoutNil:RecordClientVersion], @"RecordClientVersion",
            [self getStringWithoutNil:VentNo], @"VentNo",
            [self getStringWithoutNil:RawData], @"RawData",
            [self getStringWithoutNil:VentilationMode], @"VentilationMode",
            [self getStringWithoutNil:TidalVolumeSet], @"TidalVolumeSet",
            [self getStringWithoutNil:VolumeTarget], @"VolumeTarget",
            [self getStringWithoutNil:TidalVolumeMeasured], @"TidalVolumeMeasured",
            [self getStringWithoutNil:VentilationRateSet], @"VentilationRateSet",
            [self getStringWithoutNil:SIMVRateSet], @"SIMVRateSet",
            [self getStringWithoutNil:VentilationRateTotal], @"VentilationRateTotal",
            [self getStringWithoutNil:InspTime], @"InspTime",
            [self getStringWithoutNil:THigh], @"THigh",
            [self getStringWithoutNil:IERatio], @"IERatio",
            [self getStringWithoutNil:Tlow], @"Tlow",
            [self getStringWithoutNil:AutoFlow], @"AutoFlow",
            [self getStringWithoutNil:FlowSetting], @"FlowSetting",
            [self getStringWithoutNil:FlowMeasured], @"FlowMeasured",
            [self getStringWithoutNil:Pattern], @"Pattern",
            [self getStringWithoutNil:MVSet], @"MVSet",
            [self getStringWithoutNil:PercentMinVolSet], @"PercentMinVolSet",
            [self getStringWithoutNil:MVTotal], @"MVTotal",
            [self getStringWithoutNil:PeakPressure], @"PeakPressure",
            [self getStringWithoutNil:PlateauPressure], @"PlateauPressure",
            [self getStringWithoutNil:MeanPressure], @"MeanPressure",
            [self getStringWithoutNil:PEEP], @"PEEP",
            [self getStringWithoutNil:Plow], @"Plow",
            [self getStringWithoutNil:PressureSupport], @"PressureSupport",
            [self getStringWithoutNil:PressureControl], @"PressureControl",
            [self getStringWithoutNil:PHigh], @"PHigh",
            [self getStringWithoutNil:FiO2Set], @"FiO2Set",
            [self getStringWithoutNil:FiO2Measured], @"FiO2Measured",
            [self getStringWithoutNil:Resistance], @"Resistance",
            [self getStringWithoutNil:Compliance], @"Compliance",
            [self getStringWithoutNil:BaseFlow], @"BaseFlow",
            [self getStringWithoutNil:FlowSensitivity], @"FlowSensitivity",
            [self getStringWithoutNil:LowerMV], @"LowerMV",
            [self getStringWithoutNil:HighPressureAlarm], @"HighPressureAlarm",
            [self getStringWithoutNil:Temperature], @"Temperature",
            [self getStringWithoutNil:ReliefPressure], @"ReliefPressure",
            [self getStringWithoutNil:PetCo2], @"PetCo2",
            [self getStringWithoutNil:SpO2], @"SpO2",
            [self getStringWithoutNil:RR], @"RR",
            [self getStringWithoutNil:TV], @"TV",
            [self getStringWithoutNil:MV], @"MV",
            [self getStringWithoutNil:MaxPi], @"MaxPi",
            [self getStringWithoutNil:Mvv], @"Mvv",
            [self getStringWithoutNil:Rsbi], @"Rsbi",
            [self getStringWithoutNil:EtSize], @"EtSize",
            [self getStringWithoutNil:Mark], @"Mark",
            [self getStringWithoutNil:CuffPressure], @"CuffPressure",
            [self getStringWithoutNil:BreathSounds], @"BreathSounds",
            [self getStringWithoutNil:Pr], @"Pr",
            [self getStringWithoutNil:Cvp], @"Cvp",
            [self getStringWithoutNil:BpS], @"BpS",
            [self getStringWithoutNil:BpD], @"BpD",
            [self getStringWithoutNil:Memo], @"Memo",
            [self getStringWithoutNil:AutoPEEP], @"AutoPEEP",
            [self getStringWithoutNil:PlateauTimeSetting], @"PlateauTimeSetting",
            [self getStringWithoutNil:HR], @"HR",
            [self getStringWithoutNil:PH], @"PH",
            [self getStringWithoutNil:PaCO2], @"PaCO2",
            [self getStringWithoutNil:PaO2], @"PaO2",
            [self getStringWithoutNil:SaO2], @"SaO2",
            [self getStringWithoutNil:HCO3], @"HCO3",
            [self getStringWithoutNil:BE], @"BE",
            [self getStringWithoutNil:PAaDO2], @"PAaDO2",
            [self getStringWithoutNil:Shunt], @"Shunt",
            [self getStringWithoutNil:EndTidalCO2], @"EndTidalCO2",
            [self getStringWithoutNil:EndTidalCO2], @"RecordOperName",
            [self getStringWithoutNil:EndTidalCO2], @"VentilatorModel",
            [self getStringWithoutNil:EndTidalCO2], @"BedNo",
            [self getStringWithoutNil:EndTidalCO2], @"ErrorMsg", nil];
}

@end
