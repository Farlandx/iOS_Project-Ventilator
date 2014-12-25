//
//  HistoryCollectionViewController.h
//  呼吸照護
//
//  Created by Farland on 2014/5/20.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DtoVentExchangeUploadBatch.h"

#define HEADER_HEIGHT 25
#define HEADER_WIDTH 200
#define ARRAY_TITLE @[@"Mode", @"T.V set/total", @"Rate set/total", @"Flow", @"M.V set/total", @"Insp. T / I:E", @"FiO2", @"Peak/Plateau", @"Mean/PEEP", @"P.S/P.C", @"PH", @"PaCO2", @"PaO2", @"HCO3/B.E", @"SaO2/SpO2", @"PA-aO2/Shunt", @"RR", @"T.V/M.V", @"Pimax", @"E.T siz/mark", @"Cuff Pressure", @"Breathing Sound", @"HR", @"BP", @"I/O", @"Conscious Level", @"Hb/Sugar", @"Na/K", @"Ca/Mg", @"BUN/Cr", @"Albumin/CI"]

@interface HistoryCollectionViewController : UIViewController

@property (strong, nonatomic) NSString *MedicalId;

@end
