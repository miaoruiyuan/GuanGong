//
//  GGCheckOrderListCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/9/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCheckOrderListCell.h"
#import "TTTAttributedLabel.h"

@interface GGCheckOrderListCell ()

@property(nonatomic,strong)TTTAttributedLabel *nameLabel;
@property(nonatomic,strong)UILabel *contactsLabel;
@property(nonatomic,strong)UILabel *stateLabel;



@end

NSString *const kCellIdentifierCheckOrder = @"kGGCheckOrderListCell";

@implementation GGCheckOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.right.equalTo(self.contentView).offset(-60);
            make.top.equalTo(self.contentView.mas_top).offset(15);
        }];
        
        [self.contentView addSubview:self.contactsLabel];
        [self.contactsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
            make.left.equalTo(self.nameLabel);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
            make.height.mas_equalTo(15);
        }];
        
        [self.contentView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
        }];
        
    }
    return self;
}

- (void)setOrderList:(GGCheckOrderList *)orderList
{
    if (_orderList != orderList) {
        _orderList = orderList;
        
        
        [self.nameLabel setText:[NSString stringWithFormat:@"%@  好车伯乐",_orderList.title] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            NSRange markRangeName = [[mutableAttributedString string] rangeOfString:@"好车伯乐" options:NSCaseInsensitiveSearch];
            [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"14b2e6"],
                                                     NSFontAttributeName : [UIFont systemFontOfSize:10 weight:UIFontWeightLight]}
                                             range:markRangeName];
            return mutableAttributedString;
        }];
        
        self.contactsLabel.text = [NSString stringWithFormat:@"%@:  %@",_orderList.saleName,_orderList.saleTel];
        
        static NSString *state = nil;
        switch (_orderList.orderStatus) {
            case CheckOrderStatusBeContinued:
                state = @"待确认";
                break;
                
            case CheckOrderStatusBePayment:
                state = @"待支付";
                break;

            case CheckOrderStatusBeCheck:
                state = @"待检测";
                break;

            case CheckOrderStatusDone:
                state = @"已完成";
                break;

            case CheckOrderStatusClosed:
                state = @"已关闭";
                break;
                
            default:
                break;
        }
        
        self.stateLabel.text = state;
        
        
    }
}



- (TTTAttributedLabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [TTTAttributedLabel new];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _nameLabel.textColor = textNormalColor;
    }
    return _nameLabel;
}


- (UILabel *)contactsLabel{
    if (!_contactsLabel) {
        _contactsLabel = [[UILabel alloc] init];
        _contactsLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _contactsLabel.textColor = textLightColor;
    }
    return _contactsLabel;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = [UIColor redColor];
        _stateLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
    }
    return _stateLabel;
}

@end
