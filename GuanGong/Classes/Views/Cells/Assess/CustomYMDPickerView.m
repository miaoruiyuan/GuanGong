//
//  CustomYMDPickerView.m
//  iautosCar
//
//  Created by three on 2016/11/28.
//  Copyright © 2016年 iautos_miaoruiyuan. All rights reserved.
//

#import "CustomYMDPickerView.h"

@interface CustomYMDPickerView ()
@property (nonatomic, strong) UIView *backview;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *sureButton;


@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation CustomYMDPickerView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithMinYear:(NSInteger)minYear{
    
    self = [super init];
    
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        _backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:_backview];
        
        if (!_contentView) {
            _contentView = [[UIView alloc] init];
            CGFloat width = kScreenWidth - 8 * 2;
            CGFloat height = 250;
            CGFloat y = _backview.height - 8 - height;
            _contentView.frame = CGRectMake(8, y, width, height);
            _contentView.backgroundColor = [UIColor whiteColor];
            _contentView.layer.cornerRadius = 10.0;
            _contentView.layer.masksToBounds = YES;
            [_backview addSubview:_contentView];
        }
        
        if (!_closeButton) {
            _closeButton = [[UIButton alloc] init];
            [_closeButton setTitle:@"取消" forState:UIControlStateNormal];
            [_closeButton setTitleColor:[UIColor colorWithHexString:@"737373"] forState:UIControlStateNormal];
            _closeButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [_contentView addSubview:_closeButton];
            [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_contentView.mas_left).offset(20);
                make.top.equalTo(_contentView.mas_top).offset(20);
                make.height.width.equalTo(@30);
            }];
        }
        [[_closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self hide];
        }];
        
        if (!_sureButton) {
            _sureButton = [[UIButton alloc] init];
            [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
            [_sureButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
            _sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [_contentView addSubview:_sureButton];
            [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_contentView.mas_right).offset(-20);
                make.top.equalTo(_contentView.mas_top).offset(20);
            }];
            [[_sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *strDate = [dateFormatter stringFromDate:_datePicker.date];
                if (self.customYMDPickerBlock) {
                    self.customYMDPickerBlock(strDate);
                }
                [self hide];
            }];
        }
        
        if (!_datePicker) {
            _datePicker = [[UIDatePicker alloc] init];
            _datePicker.tintColor = [UIColor colorWithHexString:@"ff8500"];
            _datePicker.datePickerMode = UIDatePickerModeDate;
            _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_ch"];
            _datePicker.maximumDate = [NSDate date];
            _datePicker.minimumDate = [NSDate dateWithString:@"2005-1-1" format:@"yyyy-MM-dd"];
            _datePicker.date = [NSDate date];
            
            NSString *minYearStr = [NSString stringWithFormat:@"%ld-1-1",(minYear - 1)];
            _datePicker.minimumDate = [NSDate dateWithString:minYearStr format:@"yyyy-MM-dd"];
            _datePicker.date = [NSDate dateWithString:minYearStr format:@"yyyy-MM-dd"];
            [_contentView addSubview:_datePicker];
            [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_closeButton.mas_bottom).offset(25);
                make.left.right.bottom.equalTo(_contentView);
            }];
        }
    }
    
    return self;
}

-(void)show{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    
    _contentView.top = kScreenHeight;
    [UIView animateWithDuration:0.3f animations:^{
        _contentView.top = _backview.height - 8 - 250;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hide
{
    [UIView animateWithDuration:0.3f animations:^{
        _contentView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
