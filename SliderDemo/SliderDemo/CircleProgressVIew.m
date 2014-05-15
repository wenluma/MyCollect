//
//  CircleProgressVIew.m
//  SliderDemo
//
//  Created by kaxiaoer on 14-5-7.
//  Copyright (c) 2014年 miaogaoliang. All rights reserved.
//

#import "CircleProgressVIew.h"

static NSString *cirleProgressKey = @"CircleProgressVIew";

@interface CircleProgressVIew ()
@property (assign, nonatomic) CGFloat startAngle,endAgnle;
@property (weak, nonatomic) CAShapeLayer *circleLayer;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) UILabel *label;
@property (assign, nonatomic) CGFloat process;
@end

@implementation CircleProgressVIew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initStatus];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initStatus];
    }
    return self;
}
-  (void)attributedString{
    NSString *str = [NSString stringWithFormat:@"%.f天",_process];
    NSMutableAttributedString *attr= [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21]} range:NSMakeRange(0, str.length-1)];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange( str.length-1,1)];
    _label.attributedText = attr;
    [_label sizeToFit];
}
- (void)updateLabel{
    _process--;
    if (_process > _currentValue-1) {
        [self attributedString];

    }else{
        [_timer setFireDate:[NSDate distantFuture]];
    }
    NSLog(@"timer..");
}
- (void)initTimer{
    _process = _maxValue;
    float interval = 0.3/(_maxValue - _currentValue);
    CircleProgressVIew * __weak weakSelf = self;
    NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:interval target:weakSelf selector:@selector(updateLabel) userInfo:nil repeats:YES];
    _timer = timer;
}
- (CGPathRef)pathOfCircle{
    _startAngle = 0;
    CGFloat rotationAngle = (_maxValue-_currentValue)*M_PI*2/_maxValue;
    CGFloat endAngle = rotationAngle;
    _endAgnle = endAngle;

//    CGAffineTransform form = CGAffineTransformInvert(CGAffineTransformIdentity);
//    CGAffineTransform roate = CGAffineTransformRotate(form, _startPosition);
    CGFloat width = self.frame.size.width;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), width/2-_lineWidth/2, _startAngle, _endAgnle, _clockwise);

    return path;
}
- (void)startAnimation{
    _process = _maxValue;
    [self attributedString];
    self.transform = CGAffineTransformRotate(self.transform, -_startPosition);
    [self initTimer];
    CGPathRef path = [self pathOfCircle];
    _circleLayer.path = path;
    _circleLayer.strokeColor = [_topLineColor CGColor];
    _circleLayer.fillColor = [[UIColor clearColor] CGColor];
    _circleLayer.strokeStart = _startAngle;
    _circleLayer.strokeEnd = _endAgnle;
    _circleLayer.lineWidth = _lineWidth;


    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1;
    animation.fromValue = @(_startAngle);
    animation.toValue = @(_endAgnle);
    [_circleLayer addAnimation:animation forKey:cirleProgressKey];
        CGPathRelease(path);
}

- (void)initStatus{
    self.backgroundColor = [UIColor whiteColor];
    _lineWidth = 5;
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.backgroundColor = [[UIColor clearColor] CGColor];
    circleLayer.frame = self.bounds;
    [self.layer addSublayer:circleLayer];
    _circleLayer = circleLayer;
//    _circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:label];
    _label = label;
    
    label.frame = self.bounds;
    label.transform = CGAffineTransformMakeRotation(M_PI_2);
}
///*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
    // Drawing code
    CGColorRef color = [_bottomLineColor CGColor];
    //    [[UIColor colorWithRed:210/255. green:212/255. blue:216/255. alpha:1.] CGColor] ;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextStrokeEllipseInRect(context, CGRectInset(rect, _lineWidth/2, _lineWidth/2));
    [super drawRect:rect];

//    _startAngle = 0;
//    _endAgnle = M_PI;
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddArc(path, NULL, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), 20, _startAngle, _endAgnle, _clockwise);
//    CGContextAddPath(context, path);
//    CGContextSetLineWidth(context, _lineWidth);
//    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
//    CGContextStrokePath(context);
}
//*/

@end
