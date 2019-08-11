//
//  GGRefundDescribeCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRefundDescribeCell.h"
#import "MJPhotoBrowser.h"

@interface GGRefundDescribeCell ()

@property(nonatomic,strong)UIImageView *bubbleView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *remarkLabel;
@property(nonatomic,strong)UILabel *amountLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIView *lineView;

@end

NSString * const kCellIdentifierRefundDescribe = @"kGGRefundDescribeCell";

@implementation GGRefundDescribeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(140);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
        }];
        
        [self.contentView addSubview:self.bubbleView];
        [self.bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(34, 12, 5, 12));
        }];
        
        [self.bubbleView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleView.mas_left).offset(12);
            make.top.equalTo(self.bubbleView.mas_top).offset(10);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = sectionColor;
        [self.bubbleView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.bubbleView.mas_left).offset(12);
            make.right.equalTo(self.bubbleView.mas_right).offset(-12);
            make.height.mas_equalTo(0.5f);
        }];
        
        
        //退款类型
        [self.bubbleView addSubview:self.typeLabel];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(16);
        }];
        
        //退款金额
        [self.bubbleView addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeLabel);
            make.top.equalTo(self.typeLabel.mas_bottom).offset(6);
        }];
        
        //退款原因
        [self.bubbleView addSubview:self.remarkLabel];
        [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountLabel);
            make.top.equalTo(self.amountLabel.mas_bottom).offset(6);
            make.bottom.equalTo(self.bubbleView.mas_bottom).with.offset(-6);
        }];
    
    }
    return self;
}

- (void)setRecords:(GGOrderRecords *)records{
   
    _records = records;
        
    UIImage *image;
    if ([_records.operType isEqualToNumber:@1]) {
        image = [UIImage imageNamed:@"bubble_gray"];
        self.nameLabel.textColor = textNormalColor;
        self.typeLabel.textColor = textLightColor;
        self.amountLabel.textColor = textLightColor;
        self.remarkLabel.textColor = textLightColor;
        self.lineView.backgroundColor = textLightColor;
        self.amountLabel.text = [NSString stringWithFormat:@"退款金额：%@元",_records.price];
        
        if ([_records.operType isEqualToNumber:@1]) {
            self.typeLabel.text = [NSString stringWithFormat:@"退款类型：%@",_records.statusName];
        }else{
            self.typeLabel.text = @"";
        }
        
        self.remarkLabel.text = _records.remark.length > 0 ? [NSString stringWithFormat:@"退款原因：%@",_records.remark] : nil;
    } else if ([_records.operType isEqualToNumber:@2]){
        image = [UIImage imageNamed:@"bubble_blue"];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.remarkLabel.textColor = [UIColor whiteColor];
        self.amountLabel.text = nil;
        self.typeLabel.text = nil;
        self.lineView.backgroundColor = sectionColor;
        self.remarkLabel.text = _records.remark.length > 0 ? [NSString stringWithFormat:@"拒绝原因：%@",_records.remark] : nil;
    } else {
        self.nameLabel.textColor = [UIColor whiteColor];
        image = [UIImage imageNamed:@"bubble_red"];
        self.remarkLabel.textColor = [UIColor whiteColor];
        self.amountLabel.text = nil;
        self.typeLabel.text = nil;
        self.lineView.backgroundColor = sectionColor;
        self.remarkLabel.text = _records.remark.length > 0 ? [NSString stringWithFormat:@"退款原因：%@",_records.remark] : nil;
    }

    [self.bubbleView setImage:[image stretchableImageWithLeftCapWidth:8 topCapHeight:14]];
    //时间
    self.timeLabel.text = [NSDate dateWithTimeIntreval:_records.createTime];
    
    [self setNameLabelText];

    NSMutableArray *pics = [[_records.orderPics componentsSeparatedByString:@","] mutableCopy];
    [pics removeLastObject];

    if (pics.count > 0) {
        [self addImageRemarkImages:pics];
    } else {
        
        for (UIView *view in [self.bubbleView subviews]) {
            if ([view isKindOfClass:[GGTapImageView class]]) {
                [view removeFromSuperview];
            }
        }
        
        [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.amountLabel);
            make.top.equalTo(self.amountLabel.mas_bottom).offset(6);
            make.bottom.equalTo(self.bubbleView.mas_bottom).with.offset(-6);
        }];
    }
}

- (void)setNameLabelText
{
    switch (_records.statusId) {
        case OrderStatusTypeSQTK:
            self.nameLabel.text = @"买家发起退款申请";
            break;
            
        case OrderStatusTypeTKCG:
            self.nameLabel.text = @"退款关闭";
            break;
            
        case OrderStatusTypeTKSB:
            self.nameLabel.text = @"退款失败";
            break;
            
        case OrderStatusTypeJJTK:
            self.nameLabel.text = @"卖家拒绝退款";
            break;
            
        case OrderStatusTypeTYTK:
            self.nameLabel.text = @"卖家同意退款";
            break;
            
        case OrderStatusTypeZDJJTK:
            self.nameLabel.text = @"72小时自动拒绝退款";
            break;
            
        case OrderStatusTypeTHTK:
            self.nameLabel.text = @"买家发起退款申请";
            break;
            
        case OrderStatusTypeTYTHTK:
            self.nameLabel.text = @"卖家同意退货退款";
            break;
            
        case OrderStatusTypeJJTHTK:
            self.nameLabel.text = @"卖家拒绝退货退款";
            break;
            
        case OrderStatusTypeMJYTH:
            self.nameLabel.text = @"买家已退货";
            break;
            
        case OrderStatusTypeMJSHTK:
            self.nameLabel.text = @"退款成功";
            break;
            
        case OrderStatusTypeSHSB:
            self.nameLabel.text = @"卖家收货退款失败";
            break;
            
        case OrderStatusTypeMJQRSH:
            self.nameLabel.text = @"卖家确认收货";
            break;
            
        default:
            break;
    }

}

- (void)addImageRemarkImages:(NSArray *)pics
{
    if (pics.count > 0) {
        for (int i = 0; i < pics.count; i ++) {
            GGTapImageView *imageView = [[GGTapImageView alloc] init];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.tag = i + 10;
            [self.bubbleView addSubview:imageView];
            [imageView setImageWithUrl:[NSURL URLWithString:pics[i]] placeholderImage:[UIImage imageNamed:@"car_detail_image_failed"] tapBlock:^(GGTapImageView *obj) {
                NSInteger row = 0;
                NSMutableArray *photoArray = [NSMutableArray array];
                MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
                for (NSString *imageURL in pics) {
                    MJPhoto *photo = ({
                        MJPhoto *photo = [[MJPhoto alloc] init];
                        photo.url = [NSURL URLWithString:imageURL];
                        photo.srcImageView = obj;
                        photo;
                    });
                    row++;
                    [photoArray addObject:photo];
                }
                photoBrowser.photos = photoArray;
                photoBrowser.currentPhotoIndex = i;
                [photoBrowser show];
            }];
            
            CGFloat imageWidth = (kScreenWidth - 94.0) / 4.0;
            
            [self.remarkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.amountLabel);
                make.top.equalTo(self.amountLabel.mas_bottom).offset(6);
                make.right.equalTo(self.bubbleView.mas_right).with.offset(-6);
            }];
            
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.remarkLabel.mas_left).with.offset(i*(imageWidth + 12));
                make.top.equalTo(self.remarkLabel.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
                make.bottom.equalTo(self.bubbleView.mas_bottom).offset(-12).priority(710);
            }];
        }
    }
}

- (void)setCarRecords:(GGCarOrderRecords *)carRecords
{
    _carRecords = carRecords;
    
    [self.bubbleView setImage:[[UIImage imageNamed:@"bubble_blue"] stretchableImageWithLeftCapWidth:8 topCapHeight:14]];
    
    //时间
    self.timeLabel.text = _carRecords.createTimeStr;
    switch (_carRecords.status) {
        case CarOrderStatusSQTK:
            self.nameLabel.text = @"买家发起退款申请";
            break;
            
        case CarOrderStatusSQTH:
            self.nameLabel.text = @"买家发起退款申货";
            break;
            
        case CarOrderStatusJJTK:
            self.nameLabel.text = @"卖家拒绝退款";
            break;
            
        case CarOrderStatusJJTH:
            self.nameLabel.text = @"卖家拒绝退货";
            break;
            
        case CarOrderStatusTYTK:
            self.nameLabel.text = @"卖家同意退款";
            break;
            
        case CarOrderStatusTYTH:
            self.nameLabel.text = @"卖家同意退货";
            break;
            
        case CarOrderStatusYTH:
            self.nameLabel.text = @"已退货";
            break;
            
        default:
            break;
    }

    
    
    self.typeLabel.text = [NSString stringWithFormat:@"退款类型：%@",_carRecords.statusName];
    self.amountLabel.text = [NSString stringWithFormat:@"退款金额：%@元",_carRecords.price];
    self.remarkLabel.text = _carRecords.remark.length > 0 ? [NSString stringWithFormat:@"退款原因：%@",_carRecords.remark]:nil;
    [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bubbleView.mas_bottom).offset(-12).priority(710);
    }];
}

- (UIImageView *)bubbleView{
    if (!_bubbleView) {
        _bubbleView = [[UIImageView alloc]init];
        _bubbleView.userInteractionEnabled  = YES;
    }
    return _bubbleView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16.2];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc]init];
        _amountLabel.font = [UIFont systemFontOfSize:13];
        _amountLabel.textColor = [UIColor whiteColor];
    }
    return _amountLabel;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.font = [UIFont systemFontOfSize:13];
        _typeLabel.textColor = [UIColor whiteColor];
    }
    return _typeLabel;
}


- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc]init];
        _remarkLabel.font = [UIFont systemFontOfSize:13];
        _remarkLabel.textColor = [UIColor whiteColor];
        _remarkLabel.numberOfLines = 0;
    }
    return _remarkLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.backgroundColor = tableBgColor;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 4.0;
        _timeLabel.layer.borderWidth = .5 ;
        _timeLabel.layer.borderColor = sectionColor.CGColor;
        _timeLabel.font = [UIFont systemFontOfSize:12.2];
        _timeLabel.textColor = textLightColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}


@end
