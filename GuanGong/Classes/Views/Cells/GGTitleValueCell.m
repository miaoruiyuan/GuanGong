//
//  GGTitleValueCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTitleValueCell.h"
#import "GGBank.h"
#import "GGBankAddress.h"
#import "GGBankProvince.h"

@interface GGTitleValueCell ()

@property (nonatomic,strong)UILabel *valueLabel;

@end

NSString *const kCellIdentifierTitleValue = @"kGGTitleValueCell";

@implementation GGTitleValueCell

- (void)setupView{
    [super setupView];
    @weakify(self);
    [self.contentView addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.arrowView.mas_left).with.offset(-4);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(20);
        make.left.equalTo(self.titleLabel.mas_right);
    }];
}

- (UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc]init];
        _valueLabel.font = [UIFont systemFontOfSize:15];
        _valueLabel.textColor = textLightColor;
        _valueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _valueLabel;
}

- (void)configItem:(GGFormItem *)item
{
    [super configItem:item];
    _valueLabel.text = @"";
    if (item.pageType == GGPageTypeRealNameAuth) {
        _valueLabel.text = [self getRealNameAuthStatus:item.obj];
    } else if (item.pageType == GGPageTypeRealCompanyAuth){
        GGCompanyModel *company = [GGLogin shareUser].company;
        
        if (company && company.companyName) {
            _valueLabel.text = [self getRealCompanyAuthStatus:item.obj];
        }else{
            _valueLabel.text = @"未认证";
        }
        
    } else if (item.pageType == GGPageTypeBanksList){
        GGBank *bank = (GGBank *)item.obj;
        if (bank && bank.bankName) {
            _valueLabel.text = bank.bankName;
        }
    } else if (item.pageType == GGPageTypeBanksAddress){
        GGBankAddress *bankAddress = (GGBankAddress *)item.obj;
        _valueLabel.text = bankAddress.bankName;
    } else {
        if ([item.obj isKindOfClass:[NSString class]]) {
            _valueLabel.text = item.obj;
        } else if ([item isKindOfClass:[NSNumber class]]){
            _valueLabel.text = [item.obj stringValue];
        } else {
            _valueLabel.text = [item.obj description];
        }
        DLog(@"GGTitleValueCell :\n%@",[item modelDescription]);
    }
}

- (NSString *)getRealNameAuthStatus:(NSNumber *)status
{
    //1.通过 2.未过 3.审核中 4.未提交
    if ([status isEqualToNumber:@1]) {
        return @"已认证";
    } else if ([status isEqualToNumber:@2]){
        return @"未通过";
    } else if ([status isEqualToNumber:@3]){
        return @"审核中";
    }
    return @"未认证";
}

- (NSString *)getRealCompanyAuthStatus:(NSNumber *)status
{
    //0-未提交 1-待审核, 2-审核通过, 3-审核失败
    if ([status isEqualToNumber:@2]) {
        return @"已认证";
    } else if ([status isEqualToNumber:@3]){
        return @"未通过";
    } else if ([status isEqualToNumber:@1]){
        return @"审核中";
    }
    return @"未认证";

}

@end
