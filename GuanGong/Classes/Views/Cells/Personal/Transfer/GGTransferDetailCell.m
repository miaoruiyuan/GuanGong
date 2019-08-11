//
//  GGTransferDetailCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTransferDetailCell.h"
#import "TTTAttributedLabel.h"
#import "FDStackView.h"



@interface GGTransferDetailCell ()

@property(nonatomic,strong)FDStackView *stackView;

@property(nonatomic,strong)UILabel *accountLabel;
@property(nonatomic,strong)UILabel *payTypeLabel;
@property(nonatomic,strong)TTTAttributedLabel *priceLabel;


@end

NSString * const kCellIdentifierTransferDetails = @"kGGTransferDetailCell";

@implementation GGTransferDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.contentView addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(15, 15, 15, 15));
        }];
    }
    return self;
}


- (void)setAccountVM:(GGTransferAccountViewModel *)accountVM{
    if (_accountVM != accountVM) {
        _accountVM = accountVM;
        
        
        if (_accountVM.goodsType == GoodsTypeCarHistory || _accountVM.goodsType == GoodsTypeCheckCar) {
            self.accountLabel.text = [NSString stringWithFormat:@"对方账户: %@",_accountVM.account.realName];
        }else{
            if (_accountVM.account.mobile && _accountVM.account.mobile.length > 0) {
                self.accountLabel.text = [NSString stringWithFormat:@"对方账户: %@(%@)",_accountVM.account.realName,_accountVM.account.mobile];

            } else {
                self.accountLabel.text = [NSString stringWithFormat:@"对方账户: %@",_accountVM.account.realName];
            }
        }
        
        switch (_accountVM.payType) {
            case PaymentTypeFDJ:
                self.payTypeLabel.text = @"支付类型: 付订金";
                break;
                
            case PaymentTypeFQK:{
//                self.payTypeLabel.text = @"支付类型: 付全款";
                self.payTypeLabel.text = @"支付类型: 担保支付";
            }
                
                break;
                
            case PaymentTypeFWK:
                self.payTypeLabel.text = @"支付类型: 付尾款";
                break;
                
            case PaymentTypeZZ:
                self.payTypeLabel.text = @"支付类型: 转账";
                break;
                
            default:
                break;
        }

        
        CGFloat price = [_accountVM.trade.tranAmount floatValue];
        
        [self.priceLabel setText:[NSString stringWithFormat:@"支付金额: ¥%.2f",price] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange markRange = [[mutableAttributedString string] rangeOfString:[NSString stringWithFormat:@"¥%.2f",price] options:NSCaseInsensitiveSearch];
            [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: themeColor,NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightLight]} range:markRange];
            return mutableAttributedString;

            
        }];
        
        
    }
}



- (FDStackView *)stackView{
    if (!_stackView) {
        _stackView = [[FDStackView alloc] initWithArrangedSubviews:@[self.accountLabel,self.payTypeLabel,self.priceLabel]];
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.spacing = 10;
    }
    return _stackView;
}

- (UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        _accountLabel.font = [UIFont systemFontOfSize:14];
        _accountLabel.textColor = textNormalColor;
    }
    return _accountLabel;
}

- (UILabel *)payTypeLabel{
    if (!_payTypeLabel) {
        _payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.accountLabel.width, self.accountLabel.height)];
        _payTypeLabel.font = self.accountLabel.font;
        _payTypeLabel.textColor = self.accountLabel.textColor;
    }
    return _payTypeLabel;
}

- (TTTAttributedLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel =  [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0,0, self.payTypeLabel.width, self.payTypeLabel.height)];
        _priceLabel.font = self.payTypeLabel.font;
    }
    return _priceLabel;
}



@end
