//
//  GGSystemUpdateController.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/13.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGSystemUpdateController.h"
#import "TTTAttributedLabel.h"
#import "AppUpdateRequest.h"


@interface GGSystemUpdateController ()

@property(nonatomic,strong)UIImageView *tipImageView;
@property(nonatomic,strong)TTTAttributedLabel *tipLabel;
@property(nonatomic,strong)UIButton *refreshBtn;

@end

@implementation GGSystemUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    [self.view addSubview:self.tipImageView];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(44);
        make.left.right.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.tipImageView.mas_bottom).offset(20);
    }];
    
    [self.view addSubview:self.refreshBtn];
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
        make.size.mas_equalTo(CGSizeMake(168, 40));
    }];
}

- (void)bindViewModel
{
    [[self.refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [sender startQueryAnimate];
        [AppUpdateRequest RefreshAppUpdateData:^(BOOL show) {
            if (!show) {
                [[GGApiManager request_getUserBaseInfo] subscribeNext:^(id value) {
                    GGUser *user = [GGUser modelWithDictionary:value[@"user"]];
                    [[GGLogin shareUser] updateUser:user];
                    [self dismissViewControllerAnimated:YES completion:nil];
                } error:^(NSError *error) {
                    [sender stopQueryAnimate];
                }];
            }
        }];
    }];
    
    self.tipLabel.text = self.tipMessage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImageView *)tipImageView
{
    if(!_tipImageView){
        _tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"system_update_tip_bg"]];
    }
    return _tipImageView;
}

- (TTTAttributedLabel *)tipLabel
{
    if(!_tipLabel){
        _tipLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _tipLabel.numberOfLines = 0;
        _tipLabel.preferredMaxLayoutWidth = kScreenWidth - 60;
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = [UIColor colorWithHexString:@"4b4b4b"];
        _tipLabel.lineSpacing = 10;
    }
    
    return _tipLabel;
}

- (UIButton *)refreshBtn
{
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.layer.masksToBounds = YES;
        _refreshBtn.layer.cornerRadius = 3;
        _refreshBtn.layer.borderColor = themeColor.CGColor;
        _refreshBtn.layer.borderWidth = 1;
        [_refreshBtn setTitleColor:themeColor forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    }
    return _refreshBtn;
}


+(UIViewController *)getVisibleViewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    UIViewController *rootViewController = [keyWindow rootViewController];
    return [[self class] getTopVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getTopVisibleViewControllerFrom:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getTopVisibleViewControllerFrom:[((UINavigationController *)vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getTopVisibleViewControllerFrom:[((UITabBarController *)vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getTopVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end
