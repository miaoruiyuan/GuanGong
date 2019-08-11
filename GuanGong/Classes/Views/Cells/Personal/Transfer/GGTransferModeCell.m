
//
//  GGTransferModeCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTransferModeCell.h"

@interface GGTransferModeCell ()

@property(nonatomic,strong)UIImageView *selectImageView;
@property(nonatomic,strong)UIImageView *modeIconImageView;
@property(nonatomic,strong)UILabel *modeLabel;

@end

NSString * const kCellIdentifierTransferMode = @"kGGTransferModeCell";

@implementation GGTransferModeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
                
        self.selectedBackgroundView = [UIView new];
        
        [self.contentView addSubview:self.modeIconImageView];
        [self.modeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(25, 20));
        }];
        
        [self.contentView addSubview:self.modeLabel];
        [self.modeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.modeIconImageView.mas_right).offset(15);
            make.centerY.equalTo(self.modeIconImageView);
            make.size.mas_equalTo(CGSizeMake(100, 16));
        }];
        
        self.accessoryView = self.selectImageView;
    }
    return self;
}

- (void)updateUIWithModeName:(NSString *)modelName modeImageName:(NSString *)modeImageName
{
    self.modeIconImageView.image = [UIImage imageNamed:modeImageName];
    self.modeLabel.text = modelName;
}

#pragma mark - init View

- (UIImageView *)modeIconImageView{
    if (!_modeIconImageView) {
        _modeIconImageView = [[UIImageView alloc]init];
    }
    return _modeIconImageView;
}

- (UILabel *)modeLabel{
    if (!_modeLabel) {
        _modeLabel = [[UILabel alloc] init];
        _modeLabel.textColor = textNormalColor;
        _modeLabel.font =  [UIFont systemFontOfSize:14];
    }
    return _modeLabel;
}

- (UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payMode_unSelected"] highlightedImage:[UIImage imageNamed:@"payMode_selected"]];
        _selectImageView.frame =  CGRectMake(0, 0, 22, 22);
    }
    return _selectImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}


@end
