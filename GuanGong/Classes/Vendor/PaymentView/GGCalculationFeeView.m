//
//  GGCalculationFeeView.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/2.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCalculationFeeView.h"

@interface GGCalculationFeeView ()
{
    
}

@property (nonatomic,strong)UIView *bgView;

@property (nonatomic,strong)UIView *tipView;
@property (nonatomic,strong)UILabel *totalMoneyTitleLabel;
@property (nonatomic,strong)UILabel *calculationTitleLabel;
@property (nonatomic,strong)UILabel *totalMoneyLabel;
@property (nonatomic,strong)UILabel *calculationLabel;
@property (nonatomic,strong)UILabel *desLabel;
@property (nonatomic,strong)UIButton *nextBtn;

@property (nonatomic,copy) void(^nextBlock)();

@end

@implementation GGCalculationFeeView

- (void)showWithModel:(GGcalculationFee *)model andNextBlock:(void(^)())nextBlock;
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.frame = [[UIScreen mainScreen] bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    
    if (nextBlock) {
        self.nextBlock = nextBlock;
    }
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 330)];
    
    [self.bgView addSubview:self.tipView];
    [self setLabeText:model];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];

    // 动画弹出详情视图
    [UIView animateWithDuration:.25 animations:^{
        self.bgView.top = kScreenHeight - 330;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showRechargeWithModel:(GGcalculationFee *)model andNextBlock:(void(^)())nextBlock;
{
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.frame = [[UIScreen mainScreen] bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    if (nextBlock) {
        self.nextBlock = nextBlock;
    }
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 330)];
    
    [self.bgView addSubview:self.tipView];
    [self setRechargeLabeText:model];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    
    // 动画弹出详情视图
    [UIView animateWithDuration:.25 animations:^{
        self.bgView.top = kScreenHeight - 330;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.transform = CGAffineTransformTranslate(self.bgView.transform, 0, self.bgView.height);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (UIView *)tipView
{
    if (!_tipView) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 330)];
        _tipView.backgroundColor = [UIColor whiteColor];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"close_x"] forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(0, 0, 44, 44);

        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self dismiss];
        }];
        
        [_tipView addSubview:closeBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"收费提示";
        [_tipView addSubview:titleLabel];
        
        UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(12, 44, kScreenWidth, 0.5f)];
        line1View.backgroundColor = sectionColor;
        [_tipView addSubview:line1View];
        
        
        [_tipView addSubview:self.totalMoneyTitleLabel];
        [_tipView addSubview:self.totalMoneyLabel];
        [_tipView addSubview:self.calculationTitleLabel];
        [_tipView addSubview:self.calculationLabel];
        [_tipView addSubview:self.desLabel];
        [_tipView addSubview:self.nextBtn];
    
        UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(12, 130, kScreenWidth, 0.5f)];
        line2View.backgroundColor = sectionColor;
        [_tipView addSubview:line2View];
    }
    return _tipView;
}

- (void)setLabeText:(GGcalculationFee *)feeModel
{
    self.totalMoneyTitleLabel.text = @"提现金额";
    self.calculationTitleLabel.text = @"手续费";
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%@元",[NSString positiveFormat:feeModel.amount]];
    self.calculationLabel.text = [NSString stringWithFormat:@"%@元",[NSString positiveFormat:feeModel.fee]];

    NSString *text = [NSString stringWithFormat:@"提现手续费收取说明:\n%@",feeModel.remark];
    self.desLabel.text = text;
    
    self.desLabel.attributedText = [text attributedStringWithLineSpace:8];
    [self.nextBtn setTitle:@"继续提现" forState:UIControlStateNormal];

}

- (void)setRechargeLabeText:(GGcalculationFee *)feeModel
{
    self.totalMoneyTitleLabel.text = @"充值金额";
    self.calculationTitleLabel.text = @"手续费";
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%@元",[NSString positiveFormat:feeModel.amount]];
    self.calculationLabel.text = [NSString stringWithFormat:@"%@元",[NSString positiveFormat:feeModel.fee]];
    
    NSString *text = [NSString stringWithFormat:@"充值手续费收取说明:\n%@",feeModel.remark];
    self.desLabel.text = text;
    
    self.desLabel.attributedText = [text attributedStringWithLineSpace:8];
    [self.nextBtn setTitle:@"继续充值" forState:UIControlStateNormal];

}


#pragma mark - init views

- (UILabel *)totalMoneyTitleLabel
{
    if (!_totalMoneyTitleLabel) {
        _totalMoneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 64, 80, 15)];
        _totalMoneyTitleLabel.font = [UIFont systemFontOfSize:14];
        _totalMoneyTitleLabel.textColor = [UIColor blackColor];
    }
    return _totalMoneyTitleLabel;
}


- (UILabel *)calculationTitleLabel
{
    if (!_calculationTitleLabel) {
        _calculationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 99, 80, 15)];
        _calculationTitleLabel.font = [UIFont systemFontOfSize:14];
        _calculationTitleLabel.textColor = [UIColor blackColor];
    }
    return _calculationTitleLabel;
}


- (UILabel *)totalMoneyLabel
{
    if (!_totalMoneyLabel) {
        _totalMoneyLabel =[[UILabel alloc] initWithFrame:CGRectMake(90, 64, kScreenWidth - 100, 15)];
        _totalMoneyLabel.font = [UIFont boldSystemFontOfSize:14];
        _totalMoneyLabel.textColor = [UIColor blackColor];
        _totalMoneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalMoneyLabel;
}


- (UILabel *)calculationLabel
{
    if (!_calculationLabel) {
        _calculationLabel =  [[UILabel alloc] initWithFrame:CGRectMake(90, 99, kScreenWidth - 100, 15)];
        _calculationLabel.font = [UIFont boldSystemFontOfSize:14];
        _calculationLabel.textColor = [UIColor blackColor];
        _calculationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _calculationLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 150, kScreenWidth - 24, 100)];
        _desLabel.font = [UIFont systemFontOfSize:13];
        _desLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(12, 270, kScreenWidth - 24, 45);
//        [_nextBtn setTitle:@"继续提现" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _nextBtn.backgroundColor = themeColor;
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 4;
        
        [[_nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.nextBlock) {
                self.nextBlock();
            }
            [self dismiss];
        }];
    }
    return _nextBtn;
}


@end
