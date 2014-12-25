//
//  MeasureTabBarViewController.m
//  呼吸照護
//
//  Created by Farland on 2014/2/21.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "MeasureTabBarViewController.h"
#import "VentilatorDataViewController.h"
#import "OtherDataViewController.h"

@interface MeasureTabBarViewController ()

@end

@implementation MeasureTabBarViewController

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
    _measureData = [[VentilationData alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (IBAction)btnSaveClick:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
//    [self setMeasureData:[[MeasureData alloc] init]];
    
    for (UIViewController *v in self.viewControllers) {
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

- (IBAction)btnCancleClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{    UITouch *touch = [touches anyObject];
    if(touch.phase==UITouchPhaseBegan){
        //find first response view
        for (UIView *view in [self.view subviews]) {
            if ([view isFirstResponder]) {
                [view resignFirstResponder];
                break;
            }
        }
    }
}

@end
