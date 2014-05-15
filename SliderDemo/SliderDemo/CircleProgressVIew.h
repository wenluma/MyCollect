//
//  CircleProgressVIew.h
//  SliderDemo
//
//  Created by kaxiaoer on 14-5-7.
//  Copyright (c) 2014年 miaogaoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressVIew : UIView
@property (assign, nonatomic) float lineWidth;
@property (assign, nonatomic) float maxValue;
@property (assign, nonatomic) float currentValue;
@property (assign, nonatomic) BOOL clockwise;
@property (strong, nonatomic) UIColor *topLineColor;
@property (strong, nonatomic) UIColor *bottomLineColor;
@property (assign, nonatomic) CGFloat startPosition;

- (void)startAnimation;
@end
