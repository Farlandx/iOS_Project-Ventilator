//
//  DisplayView.h
//  呼吸照護
//
//  Created by Farland on 2014/3/18.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DisplayView;
@protocol DisplayViewDelegate <NSObject>

@required
- (void)displayViewTouchesBeganDone;

@end

@interface DisplayView : UIView

@property (assign, nonatomic) id delegate;

@end
