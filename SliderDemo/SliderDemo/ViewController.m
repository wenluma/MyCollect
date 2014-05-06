//
//  ViewController.m
//  SliderDemo
//
//  Created by kaxiaoer on 14-5-6.
//  Copyright (c) 2014年 miaogaoliang. All rights reserved.
//

#import "ViewController.h"
#import "MGLSlider.h"

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
//    slider.backgroundColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
