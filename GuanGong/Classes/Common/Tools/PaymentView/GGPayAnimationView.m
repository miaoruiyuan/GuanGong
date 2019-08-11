
//
//  GGProgressView.m
//  PayPassword
//
//  Created by 苗芮源 on 16/8/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GGPayAnimationView.h"

@interface GGPayAnimationView ()

/**
 *  圆圈
 */
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
/**
 *  对勾
 */
@property(nonatomic,strong)CAShapeLayer *shapeLayerGou;
/**
 *  文字
 */
@property(nonatomic,strong)CATextLayer *textLayer;
@property(nonatomic,strong)CAShapeLayer *arcLayer;

@property(nonatomic,strong)CABasicAnimation *rotateAnimation;
@property(nonatomic,strong)CABasicAnimation *strokeAnimatinStart;
@property(nonatomic,strong)CABasicAnimation *strokeAnimatinEnd;
@property(nonatomic,strong)CAAnimationGroup *animationGroup;


@property(nonatomic,assign)CGFloat radius;
@property(nonatomic,assign)CGFloat view_w;
@property(nonatomic,assign)CGPoint centers;

@end

static const CFTimeInterval DURATION = 2;
@implementation GGPayAnimationView

- (instancetype)init{
    if (self = [super init]) {
        self.frame=CGRectMake(0, 0, 200,200);
        
        //圆圈路径
        self.centers = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);//圆心
        self.radius = 30;//半径
    
        [self.layer addSublayer:self.shapeLayer];
        [self.layer addSublayer:self.textLayer];
        
    }
    return self;
}


- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        UIBezierPath *bPath  = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50)
                                                              radius:self.radius
                                                          startAngle:M_PI/2
                                                            endAngle:-M_PI/2
                                                           clockwise:YES];
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.path = bPath.CGPath;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        _shapeLayer.strokeStart = 0;
        _shapeLayer.strokeEnd = 0;
        _shapeLayer.lineWidth = 4;
        _shapeLayer.bounds = CGRectMake(0, 0, 100, 100);
        _shapeLayer.position = self.centers;
        
        
    }
    return _shapeLayer;
}

- (CAShapeLayer *)shapeLayerGou{
    if (!_shapeLayerGou) {
        CGFloat offset = self.radius/2;

        UIBezierPath *linePath = [UIBezierPath bezierPath];
        linePath.lineCapStyle = kCGLineCapRound; //线条拐角
        linePath.lineJoinStyle = kCGLineCapRound; //终点处理
        [linePath moveToPoint:CGPointMake(self.centers.x - self.radius+4, self.centers.y - 1)];
        [linePath addLineToPoint:CGPointMake(self.centers.x-offset/2, self.centers.y + (offset - 1))];
        [linePath addLineToPoint:CGPointMake(self.centers.x + offset, self.centers.y - offset/2)];
        
        _shapeLayerGou = [CAShapeLayer layer];
        _shapeLayerGou.strokeColor = [UIColor orangeColor].CGColor;//线条颜色
        _shapeLayerGou.fillColor = [UIColor clearColor].CGColor;//填充颜色
        _shapeLayerGou.lineWidth = 4.0;
        _shapeLayerGou.path = linePath.CGPath;
        _shapeLayerGou.strokeStart = 0.17;
        _shapeLayerGou.strokeEnd = 0.0;
        _shapeLayerGou.frame = CGRectMake(5,0, self.radius, self.radius);
    }
    return _shapeLayerGou;
}

- (CATextLayer *)textLayer{
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
        _textLayer.string = @"加载中...";
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.position = CGPointMake(self.centers.x, self.centers.y + self.radius/2 + 40);
        _textLayer.bounds = CGRectMake(0, 0, 120, 40);
        _textLayer.fontSize = 14;
        _textLayer.alignmentMode = kCAAlignmentCenter;
        _textLayer.foregroundColor = [UIColor redColor].CGColor;
    }
    return _textLayer;
}

- (CAShapeLayer *)arcLayer{
    if (!_arcLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.centers
                                                            radius:self.radius
                                                        startAngle:-M_PI/2
                                                          endAngle:3*M_PI/2
                                                         clockwise:YES];
        _arcLayer = [CAShapeLayer layer];
        _arcLayer.path = path.CGPath;
        _arcLayer.fillColor = [UIColor clearColor].CGColor;
        _arcLayer.strokeColor = [UIColor orangeColor].CGColor;
        _arcLayer.lineWidth = 4;
    }
    return _arcLayer;
}


- (CABasicAnimation *)rotateAnimation {
    if (!_rotateAnimation) {
        _rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _rotateAnimation.fromValue = @0;
        _rotateAnimation.toValue = @(2*M_PI);
        _rotateAnimation.duration = DURATION/2;
        _rotateAnimation.repeatCount = HUGE;
        _rotateAnimation.removedOnCompletion = NO;
        _rotateAnimation.delegate=self;
        [_rotateAnimation setValue:@"step1" forKey:@"Circle"];
    }
    return _rotateAnimation;
}

- (CABasicAnimation *)strokeAnimatinStart {
    if (!_strokeAnimatinStart) {
        _strokeAnimatinStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        _strokeAnimatinStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _strokeAnimatinStart.duration = DURATION/2;
        _strokeAnimatinStart.fromValue = @0;
        _strokeAnimatinStart.toValue = @1;
        _strokeAnimatinStart.beginTime = DURATION/2;
        _strokeAnimatinStart.removedOnCompletion = NO;
        _strokeAnimatinStart.fillMode = kCAFillModeForwards;
        _strokeAnimatinStart.repeatCount = HUGE;
        _strokeAnimatinStart.delegate=self;
    }
    return _strokeAnimatinStart;
}

- (CABasicAnimation *)strokeAnimatinEnd {
    if (!_strokeAnimatinEnd) {
        _strokeAnimatinEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeAnimatinEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _strokeAnimatinEnd.duration = DURATION;
        _strokeAnimatinEnd.fromValue = @0;
        _strokeAnimatinEnd.toValue = @1;
        _strokeAnimatinEnd.removedOnCompletion = NO;
        _strokeAnimatinEnd.fillMode = kCAFillModeForwards;
        
        
        _strokeAnimatinEnd.repeatCount = HUGE;
    }
    return _strokeAnimatinEnd;
}

- (CAAnimationGroup *)animationGroup {
    if (!_animationGroup) {
        _animationGroup = [CAAnimationGroup animation];
        _animationGroup.animations = @[self.strokeAnimatinStart, self.strokeAnimatinEnd];
        _animationGroup.repeatCount = HUGE;
        
        _animationGroup.duration = DURATION;
    }
    return _animationGroup;
}

#pragma  mark  ************************ 开始对勾动画 **************************
- (void)startGouAnimation{
    [self startCircleHideAnimation];
    [self.shapeLayer removeFromSuperlayer];
    
    if (_shapeLayerGou) {
        _shapeLayerGou.hidden = NO;
    }else{
        [self.layer addSublayer:self.shapeLayerGou];
        [self.layer addSublayer:self.arcLayer];
    }
    
    CABasicAnimation *animGou = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animGou.fromValue = @0.0;
    animGou.toValue = @1.0;
    animGou.duration = 0.6;
    animGou.beginTime = 0.0;
    animGou.removedOnCompletion = NO;
    animGou.fillMode = kCAFillModeForwards;
    
    [self.shapeLayerGou addAnimation:animGou forKey:@"gou"];
    [self.arcLayer addAnimation:animGou forKey:@"arc"];


}



/**
 *  圆弧隐藏动画
 */
- (void)startCircleHideAnimation{
    CABasicAnimation *animHide = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [animHide setFromValue:@1.0];
    [animHide setToValue:@0.0];
    [animHide setDuration:1];
    animHide.beginTime = 0.0;
    animHide.removedOnCompletion = NO;
    animHide.fillMode = kCAFillModeForwards;//当动画结束后,layer会一直保持着动画最后的状态
    animHide.delegate = self;
    [self.shapeLayer addAnimation:animHide forKey:@"CircleHide"];
}


-(void)showSuccess:(NSString *)infoStr{
    [self startGouAnimation];
    self.textLayer.string = infoStr?infoStr:@"支付成功";
    
}


- (void)showProgressView:(NSString *)infoStr stopAnimation:(AnimationStopBlock)stopBlock{
    self.stopBlock = stopBlock;
   [self startProgressAnimating];
    
    self.textLayer.string = infoStr;
    
}

- (void)startProgressAnimating {
    [self.shapeLayer addAnimation:self.animationGroup forKey:@"group"];
    [self.shapeLayer addAnimation:self.rotateAnimation forKey:@"rotate"];
}


#pragma -mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.stopBlock) {
        [self performSelector:@selector(removeAnimation) withObject:self afterDelay:1.5];
        [self performSelector:@selector(backAnimationStop) withObject:self afterDelay:1.5];
    }
    
}

-(void)backAnimationStop{
    self.stopBlock(YES);
}


/**
 *  移除动画
 */
- (void)removeAnimation{
    if (_shapeLayerGou) {
        _shapeLayerGou.hidden = YES;
        [self.shapeLayer removeAllAnimations];
    }
    [self.layer removeAllAnimations];
}





@end
