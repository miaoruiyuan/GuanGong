//
//  CWTVinResultCell.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/20.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTVinResultCell.h"
#import "TTTAttributedLabel.h"

#define SMAS(x) [self.labelConstraints addObject:x]

@interface CWTVinResultCell ()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *yearLabel;
@property(nonatomic,strong)TTTAttributedLabel *priceLabel;
@property(nonatomic,strong)UIView *line;

@property(nonatomic,strong)MASConstraint *bottomConstraint;

@property(nonatomic,strong)NSMutableArray *labels;
@property(nonatomic,strong)NSMutableArray *labelConstraints;;

@end

NSString *const kCellIdentifierVinResultCell = @"kCWTVinResultCell";
@implementation CWTVinResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.yearLabel];
        [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(20);
            self.bottomConstraint = make.bottom.equalTo(self.contentView.mas_bottom).offset(-15).priority(710);
        }];
        
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.yearLabel.mas_right).offset(15);
            make.top.height.equalTo(self.yearLabel);
        }];
        
    
        
        self.labels = [NSMutableArray arrayWithCapacity:20];
        self.labelConstraints = [NSMutableArray arrayWithCapacity:20];
        for (NSInteger i = 0; i < 20; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithHexString:@"999999"];
            label.font = [UIFont systemFontOfSize:13];
            label.hidden = YES;
            label.numberOfLines = 0;
            label.preferredMaxLayoutWidth = kScreenWidth - 30;
            [self.labels addObject:label];
            [self.contentView addSubview:label];
        }
        
        
        
    }
    return self;
}


- (void)setVinResult:(CWTVinResult *)vinResult{
    _vinResult = vinResult;
    
    self.titleLabel.text = _vinResult.trimName;
    
    self.yearLabel.text = [NSString stringWithFormat:@"年款: %@",_vinResult.version];
    
    [self.priceLabel setText:[NSString stringWithFormat:@"指导价: %@万元",_vinResult.price] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange markRange = [[mutableAttributedString string] rangeOfString:@"指导价:" options:NSCaseInsensitiveSearch];
        [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"666666"],NSFontAttributeName : [UIFont systemFontOfSize:14]} range:markRange];
        
        return mutableAttributedString;
    }];
    
    for (MASConstraint *constraint in self.labelConstraints) {
        [constraint uninstall];
    }
    [self.labelConstraints removeAllObjects];
    
    for (UILabel *label in self.labels) {
        label.hidden = YES;
    }
    
    if (_vinResult.config.count > 0) {

        [self.bottomConstraint uninstall];
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.yearLabel.mas_left);
            make.top.equalTo(self.yearLabel.mas_bottom).offset(15);
            make.right.equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(.5);
        }];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"tag_icon"];
        
        __block UILabel *lastLabel = nil;
        for (NSInteger i = 0; i < _vinResult.config.count; i++) {
            
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
            
            NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
            [myString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",_vinResult.config[i]]]];
            
            
            UILabel *lightspotLabel = self.labels[i];
            lightspotLabel.hidden = NO;
            lightspotLabel.attributedText = myString;
            
            [lightspotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
                if (lastLabel) {
                    SMAS(make.top.equalTo(lastLabel.mas_bottom).offset(15));
                    SMAS(make.left.equalTo(lastLabel.mas_left));
                }else{
                    SMAS(make.left.equalTo(self.line.mas_left));
                    SMAS(make.top.equalTo(self.line.mas_bottom).offset(15));
                }
                
                SMAS(make.right.equalTo(self.contentView.mas_right).offset(-15));
                
                if (i == _vinResult.config.count - 1) {
                    SMAS(self.bottomConstraint =  make.bottom.equalTo(self.contentView.mas_bottom).offset(-15).priority(710));
                }
            }];
            
            lastLabel = lightspotLabel;
        }

    }else{
        [self.bottomConstraint uninstall];
        [self.yearLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            SMAS(self.bottomConstraint = make.bottom.equalTo(self.contentView.mas_bottom).offset(-15).priority(710));
        }];
    }

    
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = kScreenWidth-30;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _yearLabel.font = [UIFont systemFontOfSize:14];
    }
    return _yearLabel;
}

- (TTTAttributedLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel =  [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _priceLabel.textColor = themeColor;
    }
    return _priceLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    }
    return _line;
}



@end
