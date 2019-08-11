//
//  GGPublishButton.m
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPublishButton.h"
#import "GGHeader.h"

@interface GGPublishButton (){
    CGFloat _buttonImageHeight;
}

@end

@implementation GGPublishButton

+ (void)load
{
    [super registerSubclass];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (instancetype)plusButton
{
    GGPublishButton *button = [GGPublishButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 40, 40);
    return button;
}




@end
