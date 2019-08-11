//
//  GGFriendInfoViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFriendInfoViewController.h"
#import "GGFriendMoreSetViewController.h"
#import "GGTransferViewController.h"
#import "GGFriendInfoView.h"
#import "GGFriendInfoCell.h"

#import "GGInvitationRecordViewController.h"

@interface GGFriendInfoViewController ()

@property(nonatomic,strong)GGFriendInfoView *headerView;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)GGButton *assurePayButton;
@property(nonatomic,strong)GGButton *transferButton;

@end

@implementation GGFriendInfoViewController

- (void)bindViewModel
{
    @weakify(self);
    
    [RACObserve(self, friendInfo) subscribeNext:^(GGFriendInfo *frendInfo) {
        @strongify(self);
        if (frendInfo){
            self.headerView.friendInfo = frendInfo;
            
            if (frendInfo.isFriend) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain handler:^(id sender) {
                    @strongify(self);
                    GGFriendMoreSetViewController *moreVC = [[GGFriendMoreSetViewController alloc]init];
                    moreVC.friendInfo = self.friendInfo;
                    [self pushTo:moreVC];
                }];
            } else {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"添加好友" style:UIBarButtonItemStylePlain handler:^(id sender) {
                    @strongify(self);
                    [self addFriendRequest];
                }];
            }
            [self.baseTableView reloadData];
        }
    }];
    
    //修改用户信息通知
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:GGAddFriendSuccessNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        [self getFriendInfoRequest];
    }];
    
    [self getFriendInfoRequest];
    
    
    //担保支付
    [[self.assurePayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        if (self.friendInfo.auditingType != FriendAuditPass) {
            kTipAlert(@"未认证好友暂时不能担保支付");
            return;
        }
        [self pushToTransferViewController:sender];
    }];
    
    //转账
    [[self.transferButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        if (self.friendInfo.auditingType != FriendAuditPass) {
            kTipAlert(@"未认证好友暂时不能转账");
            return;
        }
        [self pushToTransferViewController:sender];
    }];
}

- (void)getFriendInfoRequest
{
    @weakify(self);
    if (self.dealerId) {
        if (!self.friendInfo) {
            self.baseTableView.hidden = YES;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        
        [[GGApiManager request_CheckFriendInfo_WithContactId:self.dealerId] subscribeNext:^(id x) {
            @strongify(self);
            self.friendInfo = [GGFriendInfo modelWithDictionary:x];
            if (self.friendListInfo) {
                self.friendListInfo.iconUrl = self.friendInfo.iconUrl;
            }
            self.baseTableView.hidden = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } error:^(NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (void)addFriendRequest
{
    @weakify(self);
    [MBProgressHUD showMessage:@"请稍后" toView:self.view];
    [[GGApiManager request_AddAnFriend_WithMobile:self.friendInfo.mobile formType:AddAnFriendFromSearch] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"添加成功" toView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:GGAddFriendSuccessNotification object:nil];
        [self bk_performBlock:^(GGFriendInfoViewController *obj) {
            [obj backToViewController];
        } afterDelay:1.0];
        
    } error:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)backToViewController
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GGInvitationRecordViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupView
{
    self.navigationItem.title = @"详细资料";
    self.baseTableView.tableHeaderView = self.headerView;
    
    self.view.backgroundColor = self.baseTableView.backgroundColor = [UIColor whiteColor];
    [self.baseTableView registerClass:[GGFriendInfoCell class] forCellReuseIdentifier:kCellIdentifierFeiendInfo];
    
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];

    [self.footerView addSubview:self.assurePayButton];
    [self.assurePayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView).offset(4);
        make.left.equalTo(self.footerView).offset(14);
        make.right.equalTo(self.footerView.mas_centerX).offset(-7);
        make.height.mas_equalTo(40);
    }];

    [self.footerView addSubview:self.transferButton];
    [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView).offset(4);
        make.left.equalTo(self.footerView.mas_centerX).offset(7);
        make.right.equalTo(self.footerView.mas_right).offset(-14);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFriendInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierFeiendInfo];
    switch (indexPath.row) {
        case 0:
            
            if (self.friendInfo.auditingType == FriendAuditPass) {
                [cell updateUIWithTitle:@"真实姓名" value:self.friendInfo.realName];
            }else{
                [cell updateUIWithTitle:@"真实姓名" value:@"未认证"];
            }
            
            break;
            
        case 1:
            [cell updateUIWithTitle:@"联系方式" value:self.friendInfo.mobile];
            break;
            
        case 2:
            if (self.friendInfo.company.auditStatus == CompanyAuditingTypePass) {
                [cell updateUIWithTitle:@"所属公司" value:self.friendInfo.company.companyName];
            }else{
                [cell updateUIWithTitle:@"所属公司" value:@"未认证"];
            }
            
            break;
            
        default:
            if (self.friendInfo.provinceName) {
                NSString *address = [NSString stringWithFormat:@"%@ %@",self.friendInfo.provinceName,self.friendInfo.cityName];
                [cell updateUIWithTitle:@"所在地区" value:address];
            }else{
                [cell updateUIWithTitle:@"所在地区" value:@"未设置"];
            }
            break;
    }
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0.5f)];
    view.backgroundColor = tableBgColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0.5f)];
    view.backgroundColor = tableBgColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        if (self.friendInfo.mobile){
            NSInteger webTag = 400;
            NSString *str = [[NSString alloc] initWithFormat:@"tel:%@",self.friendInfo.mobile];
            UIWebView *callWebview = (UIWebView *)[self.view viewWithTag:webTag];
            if (!callWebview) {
                callWebview = [[UIWebView alloc] initWithFrame:CGRectZero];
                callWebview.tag = webTag;
                [self.view addSubview:callWebview];
            }
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        }
    }
}

- (void)pushToTransferViewController:(UIButton *)sender{
    
    GGAccount *account = [[GGAccount alloc]init];
    account.realName = self.friendInfo.realName;
    account.mobile = self.friendInfo.mobile;
    account.userId = self.friendInfo.contactId;
    account.icon  = self.friendInfo.iconUrl;
    
    GGTransferViewController *transferVC = [[GGTransferViewController alloc]initWithItem:account];
    transferVC.transferVM.isTransfer = sender.tag;
    transferVC.transferVM.isFinalPay = NO;
    [self pushTo:transferVC];
}


#pragma mark - init view

- (GGFriendInfoView *)headerView
{
    if (!_headerView) {
        _headerView = [[GGFriendInfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
    }
    return _headerView;
}

- (GGButton *)assurePayButton
{
    if (!_assurePayButton) {
        _assurePayButton = [[GGButton alloc]initWithButtonTitle:@"担保支付" style:GGButtonStyleSolid size:14];
        _assurePayButton.tag = 0;
    }
    return _assurePayButton;
}

- (GGButton *)transferButton{
    if (!_transferButton) {
        _transferButton = [[GGButton alloc]initWithButtonTitle:@"转账" style:GGButtonStyleHollow size:14];
        _transferButton.tag = 1;
    }
    return _transferButton;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    }
    return _footerView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
