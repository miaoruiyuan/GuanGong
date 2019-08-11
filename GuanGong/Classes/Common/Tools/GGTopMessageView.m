//
//  GGTopMessageView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTopMessageView.h"

@interface GGTopMessageView ()

@property(nonatomic,strong)UILabel *label;


@end

@implementation GGTopMessageView


+ (instancetype)initWithMessage:(NSString *)message{
    return [[self alloc]initWithMessage:message];
}

- (instancetype)initWithMessage:(NSString *)message{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f35a5a"];
        CGRect rect = [message boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :self.label.font} context:nil] ;

        self.label.frame = CGRectMake(12, 9, rect.size.width, rect.size.height);
        self.label.text = message;
        
        self.frame = CGRectMake(0, 0, rect.size.width + 24, rect.size.height + 18);
        [self addSubview:self.label];
    
    }
    return self;
}


- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
        _label.numberOfLines = 0;
    }
    return _label;
}



@end
