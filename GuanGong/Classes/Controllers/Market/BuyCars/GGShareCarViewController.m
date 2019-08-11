//
//  GGShareCarViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/24.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGShareCarViewController.h"
#import "UINavigationBar+GGAwesome.h"
#import "GGShareCarUtil.h"

@interface GGShareCarViewController ()

@property (nonatomic,strong) GGNewCarDetailModel *carModel;

@property(nonatomic,strong)UIView *contentView;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UIImageView *reservePriceBg;
@property(nonatomic,strong)UILabel *reservePriceLabel;

@property(nonatomic,strong)UIImageView *carImageView;

@property(nonatomic,strong)UILabel *otherInfoLabel;
@property(nonatomic,strong)UILabel *carCountLalbel;
@property(nonatomic,strong)UILabel *remarkLabel;
@property(nonatomic,strong)UIView *line;

@property (nonatomic,strong) UIButton *wxPersonBtn;
@property (nonatomic,strong) UIButton *wxSessionBtn;

@property(nonatomic,strong)UIImageView *appNameImageView;
@property(nonatomic,strong)UIImageView *qrCodeImageView;
@property(nonatomic,strong)UILabel *downloadDesLabel;

@end

@implementation GGShareCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithNewCarDetailModel:(GGNewCarDetailModel *)carModel
{
    self = [super init];
    if (self) {
        _carModel = carModel;
    }
    return self;
}

- (void)setupView
{
    self.navigationItem.title = @"分享";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar lt_setBackgroundColor:tableBgColor];
    self.view.backgroundColor = tableBgColor;
    [self initCarInfoView];
    [self initShareBtn];
}

- (void)bindViewModel
{
    [self setViewValue];
    
    @weakify(self);
    [[self.wxPersonBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        self.contentView.layer.cornerRadius = 0;
        [self.contentView layoutIfNeeded];
        [NSObject bk_performBlock:^{
            UIImage *image = [[self class] snapsHotView:self.contentView];
            [[GGShareCarUtil sharedInstance] shareToWeixinSession:image];
            self.contentView.layer.cornerRadius = 6;
        } afterDelay:0.1f];
    }];

    [[self.wxSessionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        self.contentView.layer.cornerRadius = 0;
        [self.contentView layoutIfNeeded];
        [NSObject bk_performBlock:^{
            UIImage *image = [[self class] snapsHotView:self.contentView];
            [[GGShareCarUtil sharedInstance] shareToWeixinTimeline:image];
            self.contentView.layer.cornerRadius = 6;
        } afterDelay:0.1f];
    }];
}

- (void)setViewValue
{
    self.nameLabel.text = self.carModel.title;
    [self.carImageView setImageWithURL:[NSURL URLWithString:self.carModel.carPhotoUrl] placeholder:[UIImage imageNamed:@"car_detail_image_failed"]];
    
    NSString *priceStr =
    [NSString stringWithFormat:@"%.2f万元",[self.carModel.price floatValue]/10000];
    self.priceLabel.text = priceStr;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange markRange = [priceStr rangeOfString:@"万元" options:NSCaseInsensitiveSearch];
    
    [attributedString setAttributes:@{NSForegroundColorAttributeName: themeColor,NSFontAttributeName : [UIFont systemFontOfSize:14 weight:UIFontWeightRegular]} range:markRange];
    
    [self.priceLabel setAttributedText:attributedString];
    self.reservePriceLabel.text = [NSString stringWithFormat:@"订金%@元",self.carModel.reservePrice];
    
    self.otherInfoLabel.text = [NSString stringWithFormat:@"%@ %@ | %@",self.carModel.provinceStr,self.carModel.cityStr,self.carModel.colorName];
    
    self.carCountLalbel.text = [NSString stringWithFormat:@"库存:%ld辆",(long)self.carModel.wareStockResponse.stock];
    self.remarkLabel.attributedText = [self.carModel.remark attributedStringWithLineSpace:5];
    
    [self initGuaranteeViewWithTagArray:self.carModel.serviceTags];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)initCarInfoView
{
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(20);
    }];
    
    
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.reservePriceBg];
    [self.reservePriceBg addSubview:self.reservePriceLabel];
    [self.reservePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.reservePriceBg).insets(UIEdgeInsetsMake(0, 8, 0, 4));
        make.height.mas_offset(14);
    }];
    
    [self.reservePriceBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(5);
        make.centerY.equalTo(self.priceLabel).offset(2);
        make.bottom.equalTo(self.reservePriceLabel.mas_bottom);
        make.right.equalTo(self.reservePriceLabel.mas_right).offset(4);
    }];
    
    [self.contentView addSubview:self.carImageView];
    [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(20);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo((kScreenWidth - 90) * 0.5);
    }];

    
    [self.contentView addSubview:self.otherInfoLabel];
    [self.otherInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.carImageView);
        make.top.equalTo(self.carImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
    }];
    
    [self.contentView addSubview:self.carCountLalbel];
    [self.carCountLalbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).mas_offset(-20);
        make.top.equalTo(self.carImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(16);
    }];
    
    [self.contentView addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherInfoLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(20);
    }];
    
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkLabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)initShareBtn
{
    [self.view addSubview:self.wxPersonBtn];
    [self.wxPersonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.bottom.equalTo(self.view).offset(-25);
        make.size.mas_offset(CGSizeMake(45, 45));
    }];
    
    [self.view addSubview:self.wxSessionBtn];
    [self.wxSessionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wxPersonBtn.mas_right).offset(20);
        make.size.mas_offset(CGSizeMake(45, 45));
        make.bottom.equalTo(self.view).offset(-25);
    }];
}

#pragma mark - init View
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.shadowColor = [UIColor lightTextColor].CGColor;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
        _nameLabel.preferredMaxLayoutWidth = kScreenWidth - 90;
        _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _nameLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
        _priceLabel.textColor = themeColor;
    }
    return _priceLabel;
}

- (UIImageView *)reservePriceBg{
    if (!_reservePriceBg) {
        _reservePriceBg = [[UIImageView alloc] init];
        _reservePriceBg.image = [UIImage imageNamed:@"dinjin_bg"];
        _reservePriceBg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _reservePriceBg;
}

- (UILabel *)reservePriceLabel{
    if (!_reservePriceLabel) {
        _reservePriceLabel = [[UILabel alloc] init];
        _reservePriceLabel.textColor = themeColor;
        _reservePriceLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    }
    return _reservePriceLabel;
}

- (UIImageView *)carImageView
{
    if (!_carImageView) {
        _carImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _carImageView.contentMode = UIViewContentModeScaleAspectFill;
        _carImageView.clipsToBounds = YES;
    }
    return _carImageView;
}

- (UILabel *)otherInfoLabel{
    if (!_otherInfoLabel) {
        _otherInfoLabel = [[UILabel alloc] init];
        _otherInfoLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _otherInfoLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    }
    return _otherInfoLabel;
}

- (UILabel *)carCountLalbel
{
    if (!_carCountLalbel) {
        _carCountLalbel = [[UILabel alloc] init];
        _carCountLalbel.textColor = [UIColor colorWithHexString:@"737373"];
        _carCountLalbel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
        _carCountLalbel.textAlignment = NSTextAlignmentRight;
    }
    
    return _carCountLalbel;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _remarkLabel.numberOfLines = 6;
        _remarkLabel.preferredMaxLayoutWidth = kScreenWidth - 90;
        _remarkLabel.font = [UIFont systemFontOfSize:12];
    }
    return _remarkLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = sectionColor;
    }
    return _line;
}

- (void)initGuaranteeViewWithTagArray:(NSArray<NSString*> *)tagArray
{
    UIView *guaranteeView = [[UIView alloc] init];
    
    CGFloat beginX = 0;
    CGFloat beginY = 0;
    for (NSString *tagTitle in tagArray) {
        UIButton *button = [self createGuaranteeBtn];
        [button setTitle:[NSString stringWithFormat:@" %@",tagTitle] forState:UIControlStateNormal];
        [button sizeToFit];
        
        if (button.width + beginX + 20 > (kScreenWidth - 90)) {
            beginY += 28;
            beginX = 0;
        }
        button.frame = CGRectMake(beginX, beginY, button.width, 20);
        beginX = beginX + button.width + 8;
        [guaranteeView addSubview:button];
    }
    
    [self.contentView addSubview:guaranteeView];
    [guaranteeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 50, beginY + 28));
    }];
    
    [self.contentView addSubview:self.appNameImageView];
    [self.appNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-32);
        make.left.equalTo(self.contentView).offset(20);
        make.size.mas_equalTo(CGSizeMake(50,18));
    }];

    [self.contentView addSubview:self.qrCodeImageView];
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.appNameImageView);
        make.right.equalTo(self.contentView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];
    
    [self.contentView addSubview:self.downloadDesLabel];
    [self.downloadDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.appNameImageView.mas_right);
        make.centerY.equalTo(self.appNameImageView);
        make.right.equalTo(self.qrCodeImageView.mas_left).offset(-10);
    }];
}

- (UIButton *)createGuaranteeBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"buy_new_car_wuliu_icon"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    return button;
}

- (UIImageView *)appNameImageView
{
    if (!_appNameImageView) {
        _appNameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guanerye_logo"]];
    }
    return _appNameImageView;
}

- (UILabel *)downloadDesLabel{
    if (!_downloadDesLabel) {
        _downloadDesLabel = [[UILabel alloc] init];
        _downloadDesLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _downloadDesLabel.numberOfLines = 2;
        _downloadDesLabel.textAlignment = NSTextAlignmentRight;
        _downloadDesLabel.preferredMaxLayoutWidth = 100;
        _downloadDesLabel.font = [UIFont systemFontOfSize:12];
        _downloadDesLabel.text = @"下载关二爷APP\n立即抢好车";
    }
    return _downloadDesLabel;
}

- (UIImageView *)qrCodeImageView
{
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_share_app_qrcode"]];
    }
    return _qrCodeImageView;
}

- (UIButton *)wxPersonBtn
{
    if (!_wxPersonBtn) {
        _wxPersonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxPersonBtn setImage:[UIImage imageNamed:@"share_btn_weichat_persion"] forState:UIControlStateNormal];
    }
    return _wxPersonBtn;
}

- (UIButton *)wxSessionBtn
{
    if (!_wxSessionBtn) {
        _wxSessionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxSessionBtn setImage:[UIImage imageNamed:@"share_btn_weichat_friend"] forState:UIControlStateNormal];
    }
    return _wxSessionBtn;
}

+ (UIImage *)snapsHotView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
