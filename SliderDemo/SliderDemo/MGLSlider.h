//
//  MGLSlider.h
//  CHYSliderDemo
//
//  Created by kaxiaoer on 14-5-5.
//  Copyright (c) 2014年 ciderstudios.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGLSlider : UIControl
@property (assign, nonatomic) float minimumValue,maximumValue;
@property (assign, nonatomic) float value;
@property (assign, nonatomic) float stepValue;
@property (copy, nonatomic) NSString *unit;
@property (assign, nonatomic) BOOL stepped;

@property (assign, nonatomic) float endLineWidth;
@property (assign, nonatomic) float startLineWidth;
@property (strong, nonatomic) UIColor *startColor;
@property (strong, nonatomic) UIColor *endColor;

@property (strong, nonatomic) UIImage *thumbImage;
@property (strong, nonatomic) UIColor *thumbColor;

@end
