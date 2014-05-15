//
//  AlertBackgroundWindow.h
//  SliderDemo
//
//  Created by kaxiaoer on 14-5-14.
//  Copyright (c) 2014年 miaogaoliang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^MYAction)(id);

typedef NS_ENUM(NSUInteger, UIAlertViewButtonType) {
    UIAlertViewButtonTypeDefault,
    UIAlertViewButtonTypeGray,
};

@interface AlertBackgroundWindow : UIWindow

@end

@interface UIAlertViewCustom : UIView

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                      message:(NSString *)message;

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                  containView:(UIView *)view;

- (void)addButtonTitle:(NSString *)title type:(UIAlertViewButtonType)type action:(MYAction)action;
- (void)show;
- (void)dismiss;
@end