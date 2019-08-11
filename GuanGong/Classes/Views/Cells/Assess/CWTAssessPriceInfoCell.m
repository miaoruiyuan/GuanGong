//
//  CWTAssessPriceInfoCell.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTAssessPriceInfoCell.h"
#import "TTTAttributedLabel.h"

@interface CWTAssessPriceInfoCell ()

@property(nonatomic,strong)UISegmentedControl *segmentControl;
@property(nonatomic,strong)UIView *pathwayView;
@property(nonatomic,strong)UIView *selectedView;

@property(nonatomic,strong)UILabel *buyPriceTitleLabel;
@property(nonatomic,strong)UILabel *sellPriceTitleLabel;
@property(nonatomic,strong)TTTAttributedLabel *buyPriceLabel;
@property(nonatomic,strong)TTTAttributedLabel *sellPriceLabel;
@property(nonatomic,strong)UIView  *bottomLine;
@property(nonatomic,strong)UILabel *describeLabel;

@end

NSString *const kCellIdentifierAssessPriceInfo = @"kCWTAssessPriceInfoCell";
@implementation CWTAssessPriceInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.segmentControl];
        [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(40);
        }];
        
        [self.contentView addSubview:self.pathwayView];
        [self.pathwayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(3);
            make.top.equalTo(self.segmentControl.mas_bottom);
        }];
        
        [self.pathwayView addSubview:self.selectedView];
        [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.pathwayView);
            make.width.mas_equalTo(kScreenWidth/3);
            make.centerX.equalTo(self.pathwayView.mas_centerX);
        }];

        [self.contentView addSubview:self.buyPriceTitleLabel];
        [self.buyPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset((kScreenWidth/2 - 60)/2);
            make.centerX.equalTo(self.contentView.mas_centerX).offset(-kScreenWidth /4);
            make.top.equalTo(self.pathwayView.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(58, 22));
        }];
        
        [self.contentView addSubview:self.sellPriceTitleLabel];
        [self.sellPriceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(self.buyPriceTitleLabel);
            make.centerX.equalTo(self.contentView.mas_centerX).offset(kScreenWidth /4);
        }];
        

        [self.contentView addSubview:self.buyPriceLabel];
        [self.buyPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.buyPriceTitleLabel.mas_centerX);
            make.top.equalTo(self.buyPriceTitleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(40);
        }];

        [self.contentView addSubview:self.sellPriceLabel];
        [self.sellPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.sellPriceTitleLabel.mas_centerX);
            make.top.equalTo(self.sellPriceTitleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(40);
        }];
        
        [self.contentView addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(12);
            make.top.equalTo(self.sellPriceLabel.mas_bottom).offset(25);
            make.right.equalTo(self.mas_right).offset(-12);
            make.height.mas_equalTo(.6);
        }];
        
        [self.contentView addSubview:self.describeLabel];
        [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bottomLine);
            make.top.equalTo(self.bottomLine.mas_bottom).offset(15);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
        }];
        
    }
    return self;
}

- (void)setResult:(CWTAssessResult *)result{
    _result = result;
    
//    Chexingku *cxk = [[Chexingku alloc] init];
//    
//    if (self.segmentControl.selectedSegmentIndex == 0) {
//        cxk = _result.chexingku[3];
//    }else if (self.segmentControl.selectedSegmentIndex == 1){
//        cxk = _result.chexingku[2];
//    
//    }else if (self.segmentControl.selectedSegmentIndex == 2){
//        cxk = _result.chexingku[1];
//        
//    }
    
    Chexingku *cxk = _result.chexingku[3-self.segmentControl.selectedSegmentIndex];


    [self.buyPriceLabel setText:[NSString stringWithFormat:@"%.2f万",[cxk.buyprice floatValue]] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange markRange = [[mutableAttributedString string] rangeOfString:@"万" options:NSCaseInsensitiveSearch];
        [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"fe0000"],NSFontAttributeName : [UIFont systemFontOfSize:10]} range:markRange];
        return mutableAttributedString;
        
    }];
    

    [self.sellPriceLabel setText:[NSString stringWithFormat:@"%.2f万",[cxk.sellprice floatValue]] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange markRange = [[mutableAttributedString string] rangeOfString:@"万" options:NSCaseInsensitiveSearch];
        [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"ff8700"],NSFontAttributeName : [UIFont systemFontOfSize:10]} range:markRange];
        return mutableAttributedString;
    }];
    
    self.describeLabel.text = [cxk.desc componentsJoinedByString:@","];
    
//    self.describeLabel.text = @"哇哈哈都好好的哈哈对哈哈对还得和还得和好的好的好的好的好的好的哈哈对海岛大亨还得对还得和还得和好的好的好的好的好的好的哈哈对对还得和还得和好的好的好的好的好的好的哈哈对对还得和还得和好的好的好的好的好的好的哈哈对和";
    
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //[self drawBezierLine];
}


- (void)drawBezierLine{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor colorWithHexString:@"fa8a4b"] set];
    path.lineWidth     = 4.f;
    path.lineCapStyle  = kCGLineCapButt;
    path.lineJoinStyle = kCGLineCapRound;
    
    CGFloat width = kScreenWidth / 3;
    
    [path moveToPoint:CGPointMake(0, 200)];
    // 给定终点和两个控制点绘制贝塞尔曲线
    [path addCurveToPoint:CGPointMake(width, 130) controlPoint1:CGPointMake(width/2, 200) controlPoint2:CGPointMake(width/2, 130)];
    
    
    
    // 创建圆形路径对象
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width + 3, 125, 10, 10)];
    circlePath.lineWidth     = 2.f;
    circlePath.lineCapStyle  = kCGLineCapRound;
    circlePath.lineJoinStyle = kCGLineCapRound;
    [circlePath stroke];
    
    [path moveToPoint:CGPointMake(width + 16 , 130)];
    [path addCurveToPoint:CGPointMake(width * 2, 200) controlPoint1:CGPointMake(width + width/2, 130) controlPoint2:CGPointMake(width + width/2, 200)];
    [path addCurveToPoint:CGPointMake(width * 3, 140) controlPoint1:CGPointMake(width*2 + width/2, 200) controlPoint2:CGPointMake(width*2 + width/2, 130)];
    
    [path stroke];
    
    
    
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [[UIColor colorWithHexString:@"3988d0"] set];
    path2.lineWidth     = 4.f;
    path2.lineCapStyle  = kCGLineCapButt;
    path2.lineJoinStyle = kCGLineCapRound;
    
    [path2 moveToPoint:CGPointMake(0, 150)];
    // 给定终点和两个控制点绘制贝塞尔曲线
    //[path2 addCurveToPoint:CGPointMake(width + 20, 220) controlPoint1:CGPointMake(width/2 - 40, 150) controlPoint2:CGPointMake(width/2, 220)];
    [path2 addCurveToPoint:CGPointMake(width*3 - 60, 202) controlPoint1:CGPointMake((width*3 - 80)/2 + 40, 360) controlPoint2:CGPointMake((width*3 - 80)/2 , 60)];
    
    // 创建圆形路径对象
    UIBezierPath *circlePath2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width*3 - 59, 201, 10, 10)];
    circlePath2.lineWidth     = 2.f;
    circlePath2.lineCapStyle  = kCGLineCapRound;
    circlePath2.lineJoinStyle = kCGLineCapRound;
    [circlePath2 stroke];
    
    [path2 moveToPoint:CGPointMake(width*3 - 59 + 11, 210)];
    [path2 addQuadCurveToPoint:CGPointMake(kScreenWidth, 209) controlPoint:CGPointMake(kScreenWidth - 20, 220)];
    
    [path2 stroke];
    
    
//    [self.contentView addSubview:self.hintBuyPriceLabel];
//    self.hintBuyPriceLabel.frame = CGRectMake(width - 40, 142, 100, 12);
//    
//    
//    [self.contentView addSubview:self.hintSellPriceLabel];
//    self.hintSellPriceLabel.frame = CGRectMake(width*3 - 99, 224, 100, 12);
    
    
    UIBezierPath *line = [UIBezierPath bezierPath];
     [[UIColor colorWithHexString:@"f0f0f0"] set];
    line.lineWidth  = .6f;
    [line moveToPoint:CGPointMake(12, 250)];
    [line addLineToPoint:CGPointMake(kScreenWidth, 250)];
    [line stroke];
    
    
    
}


- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"车况较差",@"车况正常",@"车况优秀"]];
        _segmentControl.tintColor = [UIColor clearColor];
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"bbbbbb"]} forState:UIControlStateNormal];
        [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"005caf"]} forState:UIControlStateSelected];
        _segmentControl.selectedSegmentIndex = 1;
        
        [[_segmentControl rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(UISegmentedControl *x) {
            [UIView animateWithDuration:.25 animations:^{
                [self.selectedView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo((x.selectedSegmentIndex -1)*(x.width /3));
                }];
            }];
            
            Chexingku *cxk = _result.chexingku[3-x.selectedSegmentIndex];
    
            [self.buyPriceLabel setText:[NSString stringWithFormat:@"%.2f万",[cxk.buyprice floatValue]] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange markRange = [[mutableAttributedString string] rangeOfString:@"万" options:NSCaseInsensitiveSearch];
                [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"fe0000"],NSFontAttributeName : [UIFont systemFontOfSize:10]} range:markRange];
                return mutableAttributedString;
                
            }];
            
            
            [self.sellPriceLabel setText:[NSString stringWithFormat:@"%.2f万",[cxk.sellprice floatValue]] afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                NSRange markRange = [[mutableAttributedString string] rangeOfString:@"万" options:NSCaseInsensitiveSearch];
                [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"ff8700"],NSFontAttributeName : [UIFont systemFontOfSize:10]} range:markRange];
                return mutableAttributedString;
            }];

            self.describeLabel.text = [cxk.desc componentsJoinedByString:@","];
        }];
        
    }
    return _segmentControl;
}

- (UIView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[UIView alloc] init];
        _selectedView.backgroundColor = [UIColor colorWithHexString:@"005caf"];
    }
    return _selectedView;
}

- (UIView *)pathwayView{
    if (!_pathwayView) {
        _pathwayView = [[UIView alloc] init];
        _pathwayView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    }
    return _pathwayView;
}

- (UILabel *)buyPriceTitleLabel{
    if (!_buyPriceTitleLabel) {
        _buyPriceTitleLabel = [[UILabel alloc] init];
        _buyPriceTitleLabel.text = @"收购价";
        _buyPriceTitleLabel.font = [UIFont systemFontOfSize:12];
        _buyPriceTitleLabel.textAlignment = NSTextAlignmentCenter;
        _buyPriceTitleLabel.textColor = [UIColor colorWithHexString:@"fe0000"];
//        [_buyPriceTitleLabel doBorderWidth:.6 color:[UIColor colorWithHexString:@"fe0000"] cornerRadius:3];
        
        
        _buyPriceTitleLabel.layer.masksToBounds = YES;
        _buyPriceTitleLabel.layer.borderWidth = 0.6;
        _buyPriceTitleLabel.layer.borderColor = [UIColor colorWithHexString:@"fe0000"].CGColor;
        _buyPriceTitleLabel.layer.cornerRadius = 3;
    }
    return _buyPriceTitleLabel;
}

- (UILabel *)sellPriceTitleLabel{
    if (!_sellPriceTitleLabel) {
        _sellPriceTitleLabel = [[UILabel alloc] init];
        _sellPriceTitleLabel.text = @"零售价";
        _sellPriceTitleLabel.font = [UIFont systemFontOfSize:12];
        _sellPriceTitleLabel.textAlignment = NSTextAlignmentCenter;
        _sellPriceTitleLabel.textColor = [UIColor colorWithHexString:@"ff8700"];
//        [_sellPriceTitleLabel doBorderWidth:.6 color:[UIColor colorWithHexString:@"ff8700"] cornerRadius:3];
        
        _sellPriceTitleLabel.layer.masksToBounds = YES;
        _sellPriceTitleLabel.layer.borderWidth = 0.6;
        _sellPriceTitleLabel.layer.borderColor = [UIColor colorWithHexString:@"ff8700"].CGColor;
        _sellPriceTitleLabel.layer.cornerRadius = 3;
    }
    return _sellPriceTitleLabel;
}

- (UILabel *)buyPriceLabel{
    if (!_buyPriceLabel) {
        _buyPriceLabel = [TTTAttributedLabel new];
        _buyPriceLabel.textColor = [UIColor colorWithHexString:@"fe0000"];

        _buyPriceLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:36];
        _buyPriceLabel.textAlignment = NSTextAlignmentCenter;
        _buyPriceLabel.textInsets = UIEdgeInsetsMake(8, 0, 0, 0);
    }
    return _buyPriceLabel;
}


- (UILabel *)sellPriceLabel{
    if (!_sellPriceLabel) {
        _sellPriceLabel = [TTTAttributedLabel new];
        _sellPriceLabel.textColor = [UIColor colorWithHexString:@"ff8700"];
        _sellPriceLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:36];
        _sellPriceLabel.textAlignment = NSTextAlignmentCenter;
        _sellPriceLabel.textInsets = UIEdgeInsetsMake(8, 0, 0, 0);
        
    }
    return _sellPriceLabel;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    }
    return _bottomLine;
}

- (UILabel *)describeLabel{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = [UIFont systemFontOfSize:11];
        _describeLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _describeLabel.numberOfLines = 0;
        _describeLabel.preferredMaxLayoutWidth = kScreenWidth  - 24;
    }
    return _describeLabel;
}

@end
