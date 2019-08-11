
//
//  GGCapitalClearStateCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCapitalClearStateCell.h"

@interface GGCapitalClearStateCell ()

@property(nonatomic,strong)UIImageView *stateView;
@property(nonatomic,strong)UILabel *stateLabel;

@end

NSString * const kCellIdentifierClearState = @"kGGCapitalClearStateCell";
@implementation GGCapitalClearStateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.stateView];
        [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(kLeftPadding);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        [self.contentView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.stateView.mas_right).offset(10);
            make.centerY.equalTo(self.stateView);
            make.height.mas_equalTo(18);
        }];

    }
    return self;
}


- (void)setState:(NSInteger)state{
    
    _state = state;
    
    switch (_state) {
        case 0:
            self.stateView.image = [UIImage imageNamed:@"paymentDetail_wait"];
            self.stateLabel.text = @"待处理";
            break;
            
        case 1:
            self.stateView.image = [UIImage imageNamed:@"paymentDetail_success"];
            self.stateLabel.text = @"清分成功";
            break;
            
        case 2:
            self.stateView.image = [UIImage imageNamed:@"paymentDetail_refuse"];
            self.stateLabel.text = @"拒绝申请";
            break;
            
        default:
            break;
    }

}



- (UIImageView *)stateView{
    if (!_stateView) {
        _stateView = [[UIImageView alloc] init];
    }
    return _stateView;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _stateLabel.textColor = textNormalColor;
        
    }
    return _stateLabel;
}


@end
