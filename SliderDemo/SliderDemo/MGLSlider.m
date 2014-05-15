//
//  MGLSlider.m
//  CHYSliderDemo
//
//  Created by kaxiaoer on 14-5-5.
//  Copyright (c) 2014年 ciderstudios.com. All rights reserved.
//

#import "MGLSlider.h"

#define Raduis 18

@interface MGLSlider ()
@property (assign, nonatomic) float width,unitLength;
@property (assign, nonatomic) float centerY;
@property (assign, nonatomic) BOOL thumbOn;
@property (weak, nonatomic) UIImageView *thumbImageV;
@property (weak, nonatomic) UIImageView *endImageV;
@property (weak, nonatomic) UIImageView *startImageV;
@property (weak, nonatomic) UILabel *currentValue;
@property (weak, nonatomic) UILabel *startValue,*endValue;
@end

@implementation MGLSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _width = CGRectGetWidth(self.bounds)-Raduis*2;
        _centerY = CGRectGetHeight(self.bounds)/2.0;
        [self initStatus];
        _unitLength = _width*_stepValue/(_maximumValue - _minimumValue);
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _width = CGRectGetWidth(self.bounds)-Raduis*2;
        _centerY = CGRectGetHeight(self.bounds)/2.0;
        [self initStatus];
        _unitLength = _width*_stepValue/(_maximumValue - _minimumValue);
    }
    return self;
}
- (void)setMinimumValue:(float)minimumValue{
    _minimumValue = minimumValue;
    _startValue.text = [NSString stringWithFormat:@"%.0f",_minimumValue];
    [_startValue sizeToFit];
}
- (void)setMaximumValue:(float)maximumValue{
    _maximumValue = maximumValue;
    _endValue.text = [NSString stringWithFormat:@"%.f",_maximumValue];
}
- (void)setValue:(float)value{
    _value = value;
    if (_value>_maximumValue) {
        _value = _maximumValue;
    }else if (_value<_minimumValue){
        _value = _minimumValue;
    }
    _thumbImageV.center = [self thumbCenter];
    [self updateTrackHighlight];
}
- (void)setStepValue:(float)stepValue{
    _stepValue = stepValue;
    _unitLength = _width*_stepValue/(_maximumValue - _minimumValue);
}
- (void)setUnit:(NSString *)unit{
    _unit = nil;
    _unit = [unit copy];
    [self showCurrentValue];
}
- (CGPoint)thumbCenter{
    float x = (_value-_minimumValue)*_width/(_maximumValue - _minimumValue)+Raduis;
    return CGPointMake(x, _centerY);
}

- (void)nearestPoint:(CGPoint)point{
    float value = point.x/_unitLength;
    float intValue = floorf(value);
    _value = intValue*_stepValue+_minimumValue;
    if (_value>_maximumValue) {
        _value = _maximumValue;
    }else if (_value<_minimumValue){
        _value = _minimumValue;
    }else{
        _thumbImageV.center = [self thumbCenter];
    }
}

- (void)initStatus{
    
    _unit = @"元";
    _minimumValue = 0;
    _maximumValue = 8000;
    _value = 0;
    
    _stepValue = 100;
    _stepped = YES;
    
    _startColor = UIColorFromRGB(0x73ba5d);
    _endColor = UIColorFromRGB(0x9a9da3);
    _startLineWidth = 2;
    _endLineWidth = 1;
    
    _thumbColor = UIColorFromRGB(0x73ba5d);
    
    UIImageView *endImageV = [[UIImageView alloc] initWithFrame:CGRectMake(Raduis, 0, _width, _endLineWidth)];
    endImageV.backgroundColor = _endColor;
    [self addSubview:endImageV];
    endImageV.center = CGPointMake(_width/2+Raduis, _centerY);
    
    UIImageView *startImageV = [[UIImageView alloc] initWithFrame:CGRectMake(Raduis, 0, _width, _startLineWidth)];
    startImageV.backgroundColor = _startColor;
    [self addSubview:startImageV];
    _startImageV = startImageV;
    startImageV.center = CGPointMake(self.center.x, _centerY);
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _thumbImageV = imgv;
    [self addSubview:imgv];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = CGRectMake(0, 0, Raduis, Raduis);
    shapeLayer.backgroundColor = [UIColorFromRGB(0x73ba5d) CGColor];
    ;
    shapeLayer.cornerRadius = Raduis/2;
    shapeLayer.position = imgv.center;
    [imgv.layer addSublayer:shapeLayer];
    shapeLayer.masksToBounds = YES;
    
    
    imgv.center = [self thumbCenter];
    
    [self updateTrackHighlight];
    
    UILabel *startValue = [[UILabel alloc] initWithFrame:CGRectMake(Raduis, 0, 100, 10)];
    [self addSubview:startValue];
    _startValue = startValue;
    _startValue.text = [NSString stringWithFormat:@"%.0f",_minimumValue];
    startValue.frame = CGRectMake(Raduis, _centerY+18, 10, 10);
    [startValue sizeToFit];
    
    
    UILabel *endValue = [[UILabel alloc] initWithFrame:CGRectMake(Raduis, 0, 100, 15)];
    [self addSubview:endValue];
    _endValue = endValue;
    _endValue.text = [NSString stringWithFormat:@"%.0f",_maximumValue];
        endValue.frame = CGRectMake(self.width+Raduis-100, _centerY+18, 100, 15);
    endValue.textAlignment = NSTextAlignmentRight;

    endValue.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    
    
    UILabel *currentValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 14)];
    [self addSubview:currentValue];
    _currentValue = currentValue;
    
    [self showCurrentValue];
    
    
}
- (void)showCurrentValue{
    
    NSString *str = [[NSString alloc] initWithFormat:@"%.f%@",_value,_unit];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, str.length-1)];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(str.length-1, 1)];
    _currentValue.attributedText = attr;
    [_currentValue sizeToFit];
    _currentValue.center = CGPointMake(_thumbImageV.center.x, _centerY-25);
}
- (void)updateTrackHighlight
{
    CGFloat thumbMidXInHighlightTrack = CGRectGetMidX([self convertRect:_thumbImageV.frame toView:self]);
    CGRect maskRect = CGRectMake(Raduis, _centerY - _startLineWidth/2, thumbMidXInHighlightTrack-Raduis, _startLineWidth);
    _startImageV.frame = maskRect;

    [self showCurrentValue];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Touch events handling
-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    CGRect rect = CGRectInset(_thumbImageV.frame, (30-Raduis)/2, (30-Raduis)/2);
    if(CGRectContainsPoint(rect, touchPoint)){
        _thumbOn = YES;
    }else {
        _thumbOn = NO;
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_thumbOn) {
        CGPoint touchPoint = [touch locationInView:self];
        [self nearestPoint:touchPoint];
        [self updateTrackHighlight];
//        if (_stepped) {
//            _thumbImageView.center = CGPointMake( [self stepMarkerXCloseToX:[touch locationInView:self].x], _thumbImageView.center.y);
//            [self setNeedsDisplay];
//        }
//        _value = [self valueForX:_thumbImageView.center.x];
//        _labelOnThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
//        _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    _thumbOn = NO;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_thumbOn) return YES;
    
    CGPoint touchPoint = [touch locationInView:self];
//    CGRect rect = CGRectInset(_thumbImageV.frame, (30-Raduis)/2, (30-Raduis)/2);
//    if(CGRectContainsPoint(rect, touchPoint)){
        [self nearestPoint:touchPoint];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self updateTrackHighlight];
//    }
//    
//    _thumbImageV.center =
//    CGPointMake( MIN( MAX( [self xForValue:_minimumValue], touchPoint.x), [self xForValue:_maximumValue]), _thumbImageView.center.y);
    
//    if (_continuous && !_stepped) {
//        _value = [self valueForX:_thumbImageView.center.x];
//        _labelOnThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
//        _labelAboveThumb.text = [NSString stringWithFormat:[self valueStringFormat], _value];
//        [self sendActionsForControlEvents:UIControlEventValueChanged];
//    }
    
//    [self setNeedsDisplay];
    return YES;
}

@end
