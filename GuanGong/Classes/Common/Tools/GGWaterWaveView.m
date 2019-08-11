//
//  GGWaterWaveView.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGWaterWaveView.h"

@interface GGWaterWaveView ()
@property(nonatomic,strong)CADisplayLink *timer;
@property(nonatomic, strong)CAShapeLayer  *firstWaveLayer;
@property(nonatomic, strong)CAShapeLayer  *secondWaveLayer;
@property(nonatomic, strong)CAShapeLayer  *thirdWaveLayer;

@end

@implementation GGWaterWaveView{
    CGFloat waveAmplitude;  // 波纹振幅
    CGFloat waveCycle;      // 波纹周期
    CGFloat waveSpeed;      // 波纹速度
    CGFloat waveGrowth;     // 波纹上升速度
    
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;           // 波浪x位移
    CGFloat currentWavePointY; // 当前波浪上升高度Y（高度从大到小 坐标系向下增长）
    
    float variable;     //可变参数 更加真实 模拟波纹
    BOOL increase;      // 增减变化
    GGWaterWaveAnimateType _animateType;//展现时先上升，隐藏时先下降
}

- (id)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    waterWaveHeight = self.frame.size.height/2;
    waterWaveWidth  = self.frame.size.width;
    if (waterWaveWidth > 0) {
        waveCycle =  1.29 * M_PI / waterWaveWidth;
    }
    
    if (currentWavePointY <= 0) {
        currentWavePointY = self.frame.size.height;
    }
    
}


- (void)setUp{
    waterWaveHeight = self.frame.size.height/2;
    waterWaveWidth  = self.frame.size.width;
    _firstWaveColor = [UIColor colorWithRed:223/255.0 green:83/255.0 blue:64/255.0 alpha:1];
    _secondWaveColor = [UIColor colorWithRed:236/255.0f green:90/255.0f blue:66/255.0f alpha:1];
    
    waveGrowth = 1.85;
    waveSpeed = 0.15/M_PI;
    
    [self resetProperty];
}

- (void)resetProperty{
    currentWavePointY = self.frame.size.height;
    variable = 1.6;
    increase = NO;
    offsetX = 0;
}


- (void)setFirstWaveColor:(UIColor *)firstWaveColor{
    _firstWaveColor = firstWaveColor;
    _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
}

- (void)setSecondWaveColor:(UIColor *)secondWaveColor{
    _secondWaveColor = secondWaveColor;
    _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
}

- (void)setThirdWaveColor:(UIColor *)thirdWaveColor{
    _thirdWaveColor = thirdWaveColor;
    _thirdWaveLayer.fillColor = _thirdWaveColor.CGColor;
}


- (void)setPercent:(CGFloat)percent{
    _percent = percent;
    [self resetProperty];
}

- (void)startWave{
    
    _animateType = GGWaterWaveAnimateTypeShow;
    [self resetProperty];
    
    if (!_firstWaveLayer) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
        [self.layer addSublayer:_firstWaveLayer];
    }
    
    if (!_secondWaveLayer) {
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
        [self.layer addSublayer:_secondWaveLayer];
    }
    
    if (!_thirdWaveLayer) {
        _thirdWaveLayer = [CAShapeLayer layer];
        _thirdWaveLayer.fillColor = _thirdWaveColor.CGColor;
        [self.layer addSublayer:_thirdWaveLayer];
    }

    
    if (_timer) {
        [self stopWave];
    }
    
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    
}

- (void)stopWave{
    _animateType = GGWaterWaveAnimateTypeHide;
}

- (void)reset{
    [_timer invalidate];
    _timer = nil;
    [self resetProperty];
    
    [_firstWaveLayer removeFromSuperlayer];
    _firstWaveLayer = nil;
    [_secondWaveLayer removeFromSuperlayer];
    _secondWaveLayer = nil;
    
    [_thirdWaveLayer removeFromSuperlayer];
    _thirdWaveLayer = nil;
}

- (void)animateWave{
    if (increase) {
        variable += 0.01;
    }else{
        variable -= 0.01;
    }
    
    if (variable<=1) {
        increase = YES;
    }
    
    if (variable>=1.6) {
        increase = NO;
    }
    
    waveAmplitude = variable*6;
}


-(void)getCurrentWave:(CADisplayLink *)displayLink{
    [self animateWave];
    switch (_animateType) {
        case GGWaterWaveAnimateTypeShow:{
            if (currentWavePointY > 2 * waterWaveHeight * (1- _percent)) {
                // 波浪高度未到指定高度 继续上涨
                currentWavePointY -= waveGrowth;
            }
        }
            break;
            
        case GGWaterWaveAnimateTypeHide:{
            if (currentWavePointY < 2 *waterWaveHeight) {
                 currentWavePointY += waveGrowth;
            }
            
            if (currentWavePointY == 2 * waterWaveHeight) {
                [_timer invalidate];
                _timer = nil;
                [self removeFromParentView];
            }
            
        }
            break;
        default:
            break;
    }
    
    // 波浪位移
    offsetX += waveSpeed;

    [self setCurrentFirstWaveLayerPath];
    [self setCurrentSecondWaveLayerPath];
    [self setCurrentThirdWaveLayerPath];

}

- (void)setCurrentFirstWaveLayerPath{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 正弦波浪公式
        y = waveAmplitude * sin(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _firstWaveLayer.path = path;
    CGPathRelease(path);
}

-(void)setCurrentSecondWaveLayerPath{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 余弦波浪公式
        y = waveAmplitude * cos(waveCycle * x + offsetX) + currentWavePointY + 12;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _secondWaveLayer.path = path;
    CGPathRelease(path);
}

-(void)setCurrentThirdWaveLayerPath{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 余弦波浪公式
        y = waveAmplitude * cos(waveCycle * x + offsetX -10) + currentWavePointY + 18;
        CGPathAddLineToPoint(path, nil, x, y);
    
    }
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _thirdWaveLayer.path = path;
    CGPathRelease(path);
}



- (void)dealloc{
    [self reset];
}

- (void)removeFromParentView{
    [self reset];
    [self removeFromSuperview];
}

@end
