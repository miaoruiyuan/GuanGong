//
//  GGModifyPriceViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/12/2.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGModifyPriceViewController.h"

@interface GGModifyPriceViewController ()

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *originalPriceTitleLabel;
@property(nonatomic,strong)UILabel *originalPriceValueLabel;

@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)UILabel *modifyPriceTitleLabel;
@property(nonatomic,strong)UILabel *modifyPriceValueLabel;
@property(nonatomic,strong)UITextField *modifyField;


@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *dealPrice;

@property(nonatomic,strong)RACCommand *modifyCommand;

@end

@implementation GGModifyPriceViewController

- (void)bindViewModel{
    
}
- (void)setupView{
    self.view.backgroundColor = tableBgColor;
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(82);
        make.height.mas_equalTo(90);
    }];
    
    [self.bgView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(12);
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right);
        make.height.mas_equalTo(.7);
    }];
    

    [self.bgView addSubview:self.originalPriceTitleLabel];
    [self.originalPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.top.equalTo(self.bgView.mas_top).offset(12);
        make.height.mas_equalTo(16);
    }];
    
    [self.bgView addSubview:self.originalPriceValueLabel];
    [self.originalPriceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-12);
        make.height.centerY.equalTo(self.originalPriceTitleLabel);
    }];
    
    [self.bgView addSubview:self.modifyPriceTitleLabel];
    [self.modifyPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line);
        make.top.equalTo(self.line.mas_bottom).offset(12);
        make.height.mas_equalTo(16);
    }];
    
    [self.bgView addSubview:self.modifyPriceValueLabel];
    [self.modifyPriceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.originalPriceValueLabel);
        make.centerY.equalTo(self.modifyPriceTitleLabel);
        make.size.mas_equalTo(CGSizeMake(50, 18));
    }];
    
    [self.bgView addSubview:self.modifyField];
    [self.modifyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.modifyPriceValueLabel);
        make.right.equalTo(self.modifyPriceValueLabel.mas_left).offset(-2);
        make.left.equalTo(self.modifyPriceTitleLabel.mas_right).offset(30);
        make.height.mas_equalTo(18);
    }];
    
    
    RACTupleUnpack(NSString *dealPrice,NSString *orderNo) = self.value;
    self.orderNo = orderNo;
    self.dealPrice = dealPrice;
    self.originalPriceValueLabel.text = [NSString stringWithFormat:@"%.2f万元",[self.dealPrice floatValue]/10000];
    
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        if (self.modifyField.text.length == 0) {
            [MBProgressHUD showError:@"请输入价格" toView:self.view];
            return ;
        }
        
        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        [[self.modifyCommand execute:nil]subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
        } completed:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
            [self bk_performBlock:^(GGModifyPriceViewController *obj) {
                if (self.popHandler) {
                    self.popHandler(@1);
                }
                [self pop];
            } afterDelay:1.1];
        }];
        
    }];
    
    
}




- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = sectionColor;
    }
    return _line;
}


- (UILabel *)originalPriceTitleLabel{
    if (!_originalPriceTitleLabel) {
        _originalPriceTitleLabel  =[[UILabel alloc]init];
        _originalPriceTitleLabel.text = @"现售价";
        _originalPriceTitleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _originalPriceTitleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    }
    return _originalPriceTitleLabel;
}

- (UILabel *)originalPriceValueLabel{
    if (!_originalPriceValueLabel) {
        _originalPriceValueLabel  =[[UILabel alloc]init];
        _originalPriceValueLabel.textColor = textLightColor;
        _originalPriceValueLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
        _originalPriceValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _originalPriceValueLabel;
}

- (UILabel *)modifyPriceTitleLabel{
    if (!_modifyPriceTitleLabel) {
        _modifyPriceTitleLabel  =[[UILabel alloc]init];
        _modifyPriceTitleLabel.text = @"成交价";
        _modifyPriceTitleLabel.textColor = [UIColor colorWithHexString:@"000000"];
        _modifyPriceTitleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    }
    return _modifyPriceTitleLabel;
}

- (UILabel *)modifyPriceValueLabel{
    if (!_modifyPriceValueLabel) {
        _modifyPriceValueLabel = [[UILabel alloc] init];
        _modifyPriceValueLabel.text =  @"万元";
        _modifyPriceValueLabel.textColor = textLightColor;
        _modifyPriceValueLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
        _modifyPriceValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _modifyPriceValueLabel;
}

- (UITextField *)modifyField{
    if (!_modifyField) {
        _modifyField = [[UITextField alloc] init];
        _modifyField.textColor = textLightColor;
        _modifyField.font = [UIFont systemFontOfSize:15];
        _modifyField.keyboardType =  UIKeyboardTypeDecimalPad;
        _modifyField.textAlignment = NSTextAlignmentRight;
        _modifyField.tintColor = textLightColor;
    }
    return _modifyField;
}


- (RACCommand *)modifyCommand{
    if (!_modifyCommand) {
        _modifyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSDictionary *dic = @{@"dealPrice":@([self.modifyField.text floatValue]*10000),@"orderNo":self.orderNo};
            return [[GGApiManager request_modifyCarDealPriceWithParameter:dic] map:^id(NSDictionary *value) {
                
                
                return [RACSignal empty];
            }];
        }];
    }
    return _modifyCommand;
}






@end
