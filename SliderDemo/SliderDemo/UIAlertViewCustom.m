//
//  AlertBackgroundWindow.m
//  SliderDemo
//
//  Created by kaxiaoer on 14-5-14.
//  Copyright (c) 2014年 miaogaoliang. All rights reserved.
//

#import "UIAlertViewCustom.h"

#define PaddingTopTitle 15
#define PaddingTopMessage 55
#define PaddingButtonTop 15

const UIWindowLevel UIWindowLevelSIAlertBackground = 1985.0; // below the alert window
static AlertBackgroundWindow *alertBackgroundWindow;

@implementation AlertBackgroundWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (id)initView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.opaque = NO;
        self.windowLevel = UIWindowLevelSIAlertBackground;
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

@interface UIAlertViewCustom ()
@property (weak, nonatomic) UILabel *titleLab,*messageLab;
@property (weak, nonatomic) UIImageView *imgView;
@property (weak, nonatomic) UIView *containView;
@property (weak, nonatomic) UIView *line,*lineV;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSMutableArray *buttonsArray;

@property (strong, nonatomic) UIFont *titleFont,*messageFont,*buttonFont;
@property (strong, nonatomic) UIColor *titleColor,*messageColor;

@end

@implementation UIAlertViewCustom
//@property (strong, nonatomic) UIFont *titleFont,*messageFont,*buttonFont;
//@property (strong, nonatomic) UIColor *titleColor,*messageColor;
//- (void)addButtonTitle:(NSString *)title type:(UIAlertViewButtonType)type action:(MYAction)action;

- (void)addButtonTitle:(NSString *)title type:(UIAlertViewButtonType)type action:(MYAction)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 40);
    [button addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonsArray addObject:action];
    button.tag = _buttonsArray.count;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:button];
//    button.backgroundColor = [UIColor yellowColor];
}
- (void)doAction:(UIButton *)button{
    MYAction action = _buttonsArray[button.tag-1];
    if (action) {
        action(self);
    }
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initStatus];
    }
    return self;
}

- (void)initStatus{
    _height = 0;
    self.backgroundColor = [UIColor whiteColor];
    _titleFont = [UIFont systemFontOfSize:15];
    _messageFont =[UIFont systemFontOfSize:12];
    _buttonFont = [UIFont systemFontOfSize:15];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.bounds)-40, 0)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:titleLab];
    [self addSubview:messageLab];
    [self addSubview:imgView];
    [self addSubview:line];
    [self addSubview:lineV];
    
    
    _titleLab = titleLab;
    _imgView = imgView;
    _messageLab = messageLab;
    _line = line;
    _lineV = lineV;
    
    _titleLab.font = _titleFont;
    _messageLab.font = _messageFont;
    
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] initWithCapacity:1];
    _buttonsArray = buttonsArray;
}

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                      message:(NSString *)message{
    CGRect frame = CGRectMake(0, 0, 280, 0);
    self = [self initWithFrame:frame];
    if (self) {
        _titleLab.text = title;
        _imgView.image = image;
        _messageLab.text = message;
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                  containView:(UIView *)view{
    CGRect frame = CGRectMake(0, 0, 280, 0);
    self = [self initWithFrame:frame];
    if (self) {
        _titleLab.text = title;
        _imgView.image = image;
        _containView = view;
        [self addSubview:view];
    }
    return self;
}
- (void)layoutSubviews{
    NSLog(NSStringFromCGRect(self.frame),nil);
    float x_title = 0;
    UIImage *img = _imgView.image;
    x_title = img.size.width;
    [_titleLab sizeToFit];
    CGRect frame = [_titleLab frame];
    x_title += CGRectGetWidth(frame);
    if (img) {
        x_title += 10;
        
        CGRect frame = CGRectMake(0, PaddingTopTitle, img.size.width, img.size.height);
        frame.origin.x = CGRectGetMidX(self.bounds) -x_title/2;
        _imgView.frame = frame;
    }
    if (_titleLab.text) {
        frame.origin.y = PaddingTopTitle;
        float x = CGRectGetMidX(self.bounds) - x_title/2;
        frame.origin.x = CGRectGetWidth(_imgView.frame) ? (CGRectGetMaxX(_imgView.frame)+10):x;
        _titleLab.frame = frame;
        _height = PaddingTopTitle+ _titleFont.pointSize;
    }
    if (_messageLab.text) {
        NSMutableParagraphStyle *graph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        graph.lineSpacing = 6;
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:_messageLab.text attributes:@{NSParagraphStyleAttributeName:graph}];
        _messageLab.numberOfLines = 0;
        _messageLab.attributedText = attr;
        [_messageLab sizeToFit];
        _height +=15;
        CGRect messageFrame = _messageLab.frame;
        messageFrame.origin.y = _height;
        _messageLab.frame = messageFrame;

        _height += CGRectGetHeight(_messageLab.frame);
    }
    if (_containView) {
        _height += 25;
        CGRect containframe = _containView.frame;
        containframe.origin.y = _height;
        containframe.origin.x = CGRectGetMidX(self.bounds) - CGRectGetMidX(_containView.bounds);
        _containView.frame = containframe;
        _height += CGRectGetHeight(containframe);
    }
    _height += 15;
    CGRect lineFrame = _line.frame;
    lineFrame.origin.y = _height;
    _line.frame = lineFrame;
    
    if (_buttonsArray.count == 2) {
        
        CGRect vframe = _lineV.frame;
        vframe.origin.x = CGRectGetMidX(self.bounds);
        vframe.size.width = 1;
        vframe.origin.y = _height;
        _lineV.frame = vframe;
        
        UIButton *button = (UIButton *)[self viewWithTag:1];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        CGRect buttonFrame = button.frame;
        buttonFrame.origin.y = _height;
        buttonFrame.size.width = CGRectGetWidth(self.bounds)/2;
        button.frame = buttonFrame;
        
        UIButton *button2 = (UIButton *)[self viewWithTag:2];
        button2.titleLabel.font = [UIFont systemFontOfSize:14];
        buttonFrame.origin.x = CGRectGetWidth(self.bounds)/2;
        buttonFrame.origin.y = _height;
        buttonFrame.size.width = CGRectGetWidth(self.bounds)/2;
        button2.frame = buttonFrame;
        _height += CGRectGetHeight(buttonFrame);
        

        
    }else if(_buttonsArray.count == 1){
        UIButton *button = (UIButton *)[self viewWithTag:1];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        CGRect buttonFrame = button.frame;
        buttonFrame.origin.y = _height;
        button.frame = buttonFrame;
        _height += CGRectGetHeight(buttonFrame);
    }
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height = _height;
    self.frame = selfFrame;
    self.center = alertBackgroundWindow.center;
}

+ (void)showBackground{
    if (!alertBackgroundWindow) {
        alertBackgroundWindow = [[AlertBackgroundWindow alloc] initView];
        [alertBackgroundWindow makeKeyAndVisible];
        alertBackgroundWindow.alpha = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             alertBackgroundWindow.alpha = 1;
                         }];
    }
}

- (void)show{
    [UIAlertViewCustom showBackground];
    [alertBackgroundWindow addSubview:self];
}
- (void)dismiss{
    [_buttonsArray removeAllObjects];
    [self removeFromSuperview];
    alertBackgroundWindow = nil;
}
@end