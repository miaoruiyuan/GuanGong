//
//  GGCodeView.m
//  PayPassword
//
//  Created by 苗芮源 on 16/8/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GGPasswordView.h"

@interface GGPasswordView ()

@property(nonatomic,strong)NSMutableArray *numbers;


@end

static NSInteger INPUT_VIEW_COUNT = 6;

@implementation GGPasswordView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 删除通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCode) name:GGKeyboardDeleteButtonClick object:nil];
        
        // 数字输入通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputCode:) name:GGlenKeyboardNumberButtonClick object:nil];
    }
    return self;
}


- (void)deleteCode{
    [self.numbers removeLastObject];
    [self setNeedsDisplay];
}


// 数字
- (void)inputCode:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *number = userInfo[GGlenKeyboardNumberKey];
        
    if (number.length > INPUT_VIEW_COUNT) {
        return;
    }
    
    [self.numbers addObject:number];
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect{
    
    // 画图
    UIImage *fieldBg = [UIImage imageNamed:@"trade.bundle/password_in"];
    
    
    CGFloat x = 20;
    CGFloat y = 5;
    CGFloat w = CGRectGetWidth(self.frame)-40;
    CGFloat h = 45;
    [fieldBg drawInRect:CGRectMake(x, y, w, h)];
    
    // 画点
    CGFloat fieldWidth=w/INPUT_VIEW_COUNT;
    UIImage *pointImage = [UIImage imageNamed:@"trade.bundle/yuan"];
    CGFloat pointW = CGRectGetWidth(self.frame) * 0.04;
    CGFloat pointH = pointW;
    CGFloat pointY = h/2+y-pointH/2;
    CGFloat pointX;
    
    
    for (int i = 0; i < self.numbers.count; i++) {
        pointX = x+fieldWidth/2-pointW/2+i*fieldWidth;
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    
}




- (NSMutableArray *)numbers{
    if (!_numbers) {
        _numbers = [[NSMutableArray alloc] init];
    }
    return _numbers;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
