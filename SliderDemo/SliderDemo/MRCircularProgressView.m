//
//  MRCircularProgressView.m
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MRCircularProgressView.h"
//#import "MRStopButton.h"


NSString *const MRCircularProgressViewProgressAnimationKey = @"MRCircularProgressViewProgressAnimationKey";


@interface MRCircularProgressView ()

@property (nonatomic, strong, readwrite) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong, readwrite) NSTimer *valueLabelUpdateTimer;

@property (nonatomic, weak, readwrite) UILabel *valueLabel;
@property (weak, nonatomic) CAShapeLayer *shapeLayer;
//@property (nonatomic, weak, readwrite) MRStopButton *stopButton;

@end


@implementation MRCircularProgressView {
    int _valueLabelProgressPercentDifference;
}

@synthesize stopButton = _stopButton;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

//+ (Class)layerClass {
//    return CAShapeLayer.class;
//}

//- (CAShapeLayer *)shapeLayer {
//    CAShapeLayer *shaper = [CAShapeLayer layer];
////    shaper.bounds = self.layer.bounds;
//    shaper.frame = self.bounds;
//    shaper.backgroundColor = [[UIColor redColor] CGColor];
//    [self.layer addSublayer:shaper];
//    return shaper;
////    (CAShapeLayer *)self.layer;
//}

- (void)commonInit {
    _animationDuration = 0.3;
    self.progress = 0;
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    self.numberFormatter = numberFormatter;
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    numberFormatter.locale = NSLocale.currentLocale;
    
//    self.layer.borderWidth = 5.0f;
    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.frame = self.bounds;
//    [self.layer addSublayer:shapeLayer];
//    self.layer.mask = shapeLayer;
//    _shapeLayer = shapeLayer;
    
//    self.shapeLayer.lineWidth = 5.0f;
//    self.shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    
    UILabel *valueLabel = [UILabel new];
    self.valueLabel = valueLabel;
//    valueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    valueLabel.textColor = UIColor.blackColor;
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:valueLabel];
    
//    MRStopButton *stopButton = [MRStopButton new];
//    [self addSubview:stopButton];
//    self.stopButton = stopButton;
    
    self.mayStop = NO;
    
//    [self tintColorDidChange];
}


#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat offset = 4;
    CGRect valueLabelRect = self.bounds;
    valueLabelRect.origin.x += offset;
    valueLabelRect.size.width -= offset;
    self.valueLabel.frame = valueLabelRect;
    
//    self.layer.cornerRadius = self.frame.size.width / 2.0f;
//    self.layer.
//    self.shapeLayer.path = [self layoutPath].CGPath;
    
//    self.stopButton.frame = [self.stopButton frameThatFits:self.bounds];
}

- (UIBezierPath *)layoutPath {
    const double TWO_M_PI = 2.0 * M_PI;
    const double startAngle = 0.75 * TWO_M_PI;
    const double endAngle = startAngle + TWO_M_PI;
    
    CGFloat width = self.frame.size.width;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
                                          radius:width/2.0f - 5
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
}


#pragma mark - Hook tintColor

- (void)tintColorDidChange {
//    [super tintColorDidChange];
//    UIColor *tintColor = self.tintColor;
//    self.shapeLayer.strokeColor =[[UIColor colorWithRed:117/255. green:185/255. blue:97/255. alpha:1.] CGColor] ;
//    tintColor.CGColor;
//    self.layer.borderColor = [[UIColor colorWithRed:210/255. green:212/255. blue:216/255. alpha:1.] CGColor] ;
//    tintColor.CGColor;
    self.valueLabel.textColor = [UIColor colorWithRed:117/255. green:185/255. blue:97/255. alpha:1.];
    self.stopButton.backgroundColor =[UIColor colorWithRed:117/255. green:185/255. blue:97/255. alpha:1.];
    NSLog(NSStringFromCGRect(self.frame),nil);
}


#pragma mark - MRStopableView's implementation

- (void)setMayStop:(BOOL)mayStop {
    self.stopButton.hidden = !mayStop;
    self.valueLabel.hidden = mayStop;
}

- (BOOL)mayStop {
    return !self.stopButton.hidden;
}


#pragma mark - Control progress

- (void)setProgress:(float)progress {
    NSParameterAssert(progress >= 0 && progress <= 1);
    
    [self stopAnimation];
    
    _progress = progress;
    
    [self updateProgress];
}

- (void)updateProgress {
    [self updatePath];
    [self updateLabel:self.progress];
}

- (void)updatePath {
    self.shapeLayer.strokeEnd = self.progress;
}

- (void)updateLabel:(float)progress {
    self.valueLabel.text = [self.numberFormatter stringFromNumber:@(progress)];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (animated) {
        if (self.progress == progress) {
            return;
        }
        
        [self animateToProgress:progress];
    } else {
        self.progress = progress;
    }
}

- (void)setAnimationDuration:(CFTimeInterval)animationDuration {
    NSParameterAssert(animationDuration > 0);
    _animationDuration = animationDuration;
}

- (void)animateToProgress:(float)progress {
    [self stopAnimation];
    
    // Add shape animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = self.animationDuration;
    animation.fromValue = @(self.progress);
    animation.toValue = @(progress);
    animation.delegate = self;
    [self.shapeLayer addAnimation:animation forKey:MRCircularProgressViewProgressAnimationKey];
    
    // Add timer to update valueLabel
    _valueLabelProgressPercentDifference = (progress - self.progress) * 100;
    CFTimeInterval timerInterval =  self.animationDuration / ABS(_valueLabelProgressPercentDifference);
    self.valueLabelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                                                  target:self
                                                                selector:@selector(onValueLabelUpdateTimer:)
                                                                userInfo:nil
                                                                 repeats:YES];
    
    
    _progress = progress;
}

- (void)stopAnimation {
    // Stop running animation
    [self.layer removeAnimationForKey:MRCircularProgressViewProgressAnimationKey];
    
    // Stop timer
    [self.valueLabelUpdateTimer invalidate];
    self.valueLabelUpdateTimer = nil;
}

- (void)onValueLabelUpdateTimer:(NSTimer *)timer {
    if (_valueLabelProgressPercentDifference > 0) {
        _valueLabelProgressPercentDifference--;
    } else {
        _valueLabelProgressPercentDifference++;
    }
    
    [self updateLabel:self.progress - (_valueLabelProgressPercentDifference / 100.0f)];
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self updateProgress];
    [self.valueLabelUpdateTimer invalidate];
    self.valueLabelUpdateTimer = nil;
}
- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
    CGColorRef color = [[UIColor redColor] CGColor];
//    [[UIColor colorWithRed:210/255. green:212/255. blue:216/255. alpha:1.] CGColor] ;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 5);
    CGContextStrokeEllipseInRect(context, rect);
//    CGContextStrokeRectWithWidth(context, rect, 5);
}
@end
