//
//  ViewController.m
//  SliderDemo
//
//  Created by kaxiaoer on 14-5-6.
//  Copyright (c) 2014年 miaogaoliang. All rights reserved.
//

#import "ViewController.h"
#import "MGLSlider.h"
#import "MRCircularProgressView.h"
#import "CircleProgressVIew.h"
#import "UIAlertViewCustom.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MGLSlider *slider = [[MGLSlider alloc] initWithFrame:CGRectMake(50, 80, 200, 50)];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.value = 10;
    slider.stepValue = 2;
    slider.unit = @"天";
    
    [self.view addSubview:slider];
    slider.backgroundColor = [UIColor yellowColor];
    
    MRCircularProgressView *proview = [[MRCircularProgressView alloc] initWithFrame:CGRectMake(50, 200, 80, 80)];
    [self.view addSubview:proview];
    proview.animationDuration = 1;
    [proview setProgress:0.53 animated:YES];
    
    CircleProgressVIew *view = [[CircleProgressVIew alloc] initWithFrame:CGRectMake(50, 300, 75, 75)];
    view.maxValue = 30.0;
    view.currentValue = 20;
    view.startPosition = M_PI_2;
    view.clockwise = NO;
    view.bottomLineColor = [UIColor colorWithRed:115/255. green:186/255. blue:93/255. alpha:1];
    view.topLineColor = [UIColor colorWithRed:210/255. green:212/255. blue:216/255. alpha:1];
    [view startAnimation];
    [self.view addSubview:view];
}
- (IBAction)showAlertView:(id)sender {
//    UIAlertViewCustom *alert = [[UIAlertViewCustom alloc] initWithTitle:@"MEsgaehello" image:nil message:@"中国新闻网是知名的中文新闻门户网站，也是全球互联网中文新闻资讯最重要的原创内容供应商之一。依托中新社遍布全球的采编网络,每天24小时面向广大网民和"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    view.backgroundColor = [UIColor purpleColor];
    
    UIImage *img = [UIImage imageNamed:@"info"];
    
    UIAlertViewCustom *alert = [[UIAlertViewCustom alloc] initWithTitle:@"网中文新闻资讯" image:img containView:view];
    
    [alert addButtonTitle:@"取消" type:0 action:^(UIAlertViewCustom *alert) {
        [alert dismiss];
    }];
    [alert addButtonTitle:@"确定" type:0 action:^(UIAlertViewCustom *alert) {
        [alert dismiss];
    }];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
