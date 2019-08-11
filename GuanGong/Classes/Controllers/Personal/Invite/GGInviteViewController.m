//
//  GGInviteViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/15.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGInviteViewController.h"
#import "GGInvitationRecordViewController.h"
#import "GGShareView.h"
#import "UIImage+Common.h"
#import "UIAlertController+Common.h"

@interface GGInviteViewController ()

@property(nonatomic,strong)UIImageView *appNameImageView;
@property(nonatomic,copy)UIView *qrContentView;
@property(nonatomic,strong)UIButton *inviteButton;
@property(nonatomic,strong)GGShareView *shareView;

@end

@implementation GGInviteViewController

- (void)setupView{
    self.navigationItem.title = @"邀请好友";
    
    [self.view addSubview:self.appNameImageView];
    [self.appNameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(100);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(97, 33));
    }];

    
    [self.view addSubview:self.qrContentView];
    [self.qrContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appNameImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(290, 320));
    }];
    
    [self.view addSubview:self.inviteButton];
    [self.inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kScreenWidth == 320) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
        }else{
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-50);
        }
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    
    [[self.inviteButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        self.shareView.shareTitle = NSLocalizedString(@"关二爷-二手车人的支付宝贝", nil);
        self.shareView.shareText = NSLocalizedString(@"转账也能担保啦,支付有保障,交易更放心!快来下载体验吧", nil);
        
        NSString *mobile = [[[GGLogin shareUser].user.qrCodeUri componentsSeparatedByString:@"params="] lastObject];
        
        self.shareView.shareUrl =  [NSString stringWithFormat:@"https://guangong.iautos.cn/m/invitation/getInvitationPage?params=%@&sourceId=2",mobile];
        
        [self.view addSubview:self.shareView];
        
        [UIView animateWithDuration:.35 animations:^{
            self.shareView.alpha = 1.0;
        }];
        [MobClick event:@"invite"];
    }];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"我的邀请" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        GGInvitationRecordViewController *invitationVC = [[GGInvitationRecordViewController alloc] init];
        [self pushTo:invitationVC];
        [MobClick event:@"myinvitation"];
    }];
}

- (void)bindViewModel
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(qrViewLongTapAction:)];
    [self.qrContentView addGestureRecognizer:longPress];
}

- (void)qrViewLongTapAction:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [UIAlertController actionSheetInController:self title:@"保存二维码到相册" message:nil confrimBtn:@[@"保存"] confrimStyle:UIAlertActionStyleDefault confrimAction:^(UIAlertAction *action, NSInteger index) {
            if (index == 0){
                UIImage *image = [self snapsHotView:self.qrContentView];
                [self saveImageToPhotos:image];
            }
        } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
    }
}

- (UIImage *)createQRImage
{
    return [UIImage qrImageForString:[self getGGQRShareURL] imageSize:230 logoImageSize:56];
}

- (NSString *)getGGQRShareURL
{
    NSString *mobile = [[[GGLogin shareUser].user.qrCodeUri componentsSeparatedByString:@"params="]lastObject];
    return [NSString stringWithFormat:@"https://guangong.iautos.cn/m/invitation/getInvitationPage?params=%@&sourceId=8",mobile];
}

- (UIImage *)snapsHotView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)saveImageToPhotos:(UIImage *)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存二维码失败" ;
    } else {
        msg = @"保存二维码成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark -  init View

- (UIImageView *)appNameImageView
{
    if (!_appNameImageView) {
        _appNameImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guanerye_logo"]];
    }
    return _appNameImageView;
}


- (UIView *)qrContentView{
    if (!_qrContentView) {
        _qrContentView = [[UIView alloc] init];
        _qrContentView.backgroundColor = [UIColor whiteColor];
        _qrContentView.layer.borderColor = sectionColor.CGColor;
        _qrContentView.layer.borderWidth = 0.5f;
        _qrContentView.layer.shadowColor = textLightColor.CGColor;
        _qrContentView.layer.shadowOffset = CGSizeMake(4,4);
        _qrContentView.layer.shadowOpacity = 0.4;
        _qrContentView.layer.shadowRadius = 4;
    
        UIImageView *qrImageView = [[UIImageView alloc] init];
        qrImageView.image = [self createQRImage];
        [_qrContentView addSubview:qrImageView];
    
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = @"扫描二维码接受邀请";
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = textNormalColor;
        [_qrContentView addSubview:textLabel];
        
        [qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_qrContentView);
            make.centerY.equalTo(_qrContentView).offset(-12);
            make.size.mas_equalTo(CGSizeMake(230, 230));
        }];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_qrContentView).offset(-20);
            make.left.right.equalTo(_qrContentView);
            make.height.mas_equalTo(16);
        }];
    }
    return _qrContentView;
}


- (UIButton *)inviteButton{
    if (!_inviteButton) {
        _inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteButton.layer.masksToBounds =  YES;
        _inviteButton.layer.cornerRadius = 20;
        _inviteButton.layer.borderWidth = 1.2;
        _inviteButton.layer.borderColor = themeColor.CGColor;
        [_inviteButton setTitle:@"邀请好友" forState:UIControlStateNormal];
        [_inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_inviteButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateHighlighted];
        [_inviteButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_inviteButton setTitleColor:themeColor forState:UIControlStateNormal];
    }
    return _inviteButton;
}


- (GGShareView *)shareView{
    if (!_shareView) {
        _shareView = [[GGShareView alloc]initWithFrame:self.view.bounds];
        _shareView.alpha = 0.0;
    }
    return _shareView;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.shareView = nil;
    [self.shareView removeFromSuperview];
}



@end
