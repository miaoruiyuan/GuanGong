//
//  UIButton+Common.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "UIButton+Common.h"

static char kTimer;

static NSString *const kIndicatorViewKey = @"indicatorView";
static NSString *const kButtonTextObjectKey = @"buttonTextObject";

@implementation UIButton (Common)


- (void)centerImageUnderTitle:(CGFloat )spacing{
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
}

- (void)centerImageAndTitle:(float)spacing{
    
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
}

- (void)centerImageAndTitle{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}


- (void)putImageOnTheRightSideOfTitle{
    self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
}





#pragma mark -
//开始请求时，UIActivityIndicatorView 提示
static char EAActivityIndicatorKey;
- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator{
    objc_setAssociatedObject(self, &EAActivityIndicatorKey, activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (UIActivityIndicatorView *)activityIndicator{
    return objc_getAssociatedObject(self, &EAActivityIndicatorKey);
}

- (void)startQueryAnimate{
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.hidesWhenStopped = YES;
        [self addSubview:self.activityIndicator];
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    [self.activityIndicator startAnimating];
    self.enabled = NO;
}
- (void)stopQueryAnimate{
    [self.activityIndicator stopAnimating];
    self.enabled = YES;
}


-(void)startCountDown{
    NSString *title = self.titleLabel.text;
    int time_ = 60;
    __block int _timeout = time_;
    @weakify(self);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    objc_setAssociatedObject(self, &kTimer, _timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        if(_timeout <= 0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:title forState:UIControlStateNormal];
                self.enabled = YES;
            });
        }else{
            int seconds = (_timeout) % (time_ + 1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:[NSString stringWithFormat:@"%.2ds后重试", seconds] forState:UIControlStateNormal];
                self.enabled = NO;
            });
            _timeout --;
        }
    });
    dispatch_resume(_timer);
}
-(void)endTimer{
    dispatch_source_t _timer = objc_getAssociatedObject(self, &kTimer);
    if (_timer) {
        self.enabled = YES;
        dispatch_source_cancel(_timer);
    }
}



#pragma mark - 显示菊花
- (void)showIndicator{
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentButtonText = self.titleLabel.text;
    
    objc_setAssociatedObject(self, &kButtonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTitle:@"" forState:UIControlStateNormal];
    self.enabled = NO;
    [self addSubview:indicator];
}

- (void)hideIndicator{
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &kButtonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &kIndicatorViewKey);
    
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
    self.enabled = YES;

}





@end
