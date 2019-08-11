//
//  GGAttestationViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAttestationViewController.h"
#import "GGMineInfoViewController.h"
#import "GGPersonalPageRoute.h"
#import "GGAttestionPhotoUploadCell.h"
#import "GGTopMessageView.h"
#import "GGAttestationViewModel.h"
#import "GGUserInfoViewModel.h"
#import "GGAttestationInfoCell.h"
#import "GGAttestationChooseCityCell.h"
#import "GGFooterView.h"

#import "GGAttestationCheckingView.h"
#import "GGAttestationAudingPassView.h"
#import "GGAttestationChceckFailView.h"
#import "GGPrivateFileUploadViewModel.h"
#import "GGAttestationNoCheckedView.h"

@interface GGAttestationViewController (){
    NSDictionary *_identifiers;
}

@property(nonatomic,strong)GGAttestationViewModel *attestationVM;
@property(nonatomic,strong)GGUserInfoViewModel *userInfoVM;
//@property(nonatomic,strong)GGFooterView *tableFooterView;


@property(nonatomic,strong)GGAttestationCheckingView *checkingView;
@property(nonatomic,strong)GGAttestationAudingPassView *audingPassView;
@property(nonatomic,strong)GGAttestationNoCheckedView *noCheckedView;
@property(nonatomic,strong)GGAttestationChceckFailView *checkedFailView;


@end

@implementation GGAttestationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (BOOL)navigationShouldPopOnBackButton
{
    if (([GGLogin shareUser].user.auditingType == AuditingTypeNoSubmit && !self.showNoCheckTipView) || [GGLogin shareUser].user.auditingType == AuditingTypeInvaild) {
        [UIAlertController alertInController:self title:nil message:@"实名认证暂未完成，退出将无法使用关二爷支付功能。确定退出吗?" confrimBtn:@"退出" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
            [self pop];
        } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
        return NO;
    }
    return YES;
}

- (GGAttestationViewModel *)attestationVM{
    if (!_attestationVM) {
        _attestationVM = [[GGAttestationViewModel alloc]init];
    }
    return _attestationVM;
}

- (GGUserInfoViewModel *)userInfoVM{
    if (!_userInfoVM) {
        _userInfoVM = [[GGUserInfoViewModel alloc] init];
    }
    return _userInfoVM;
}

- (void)bindViewModel
{
    @weakify(self);

    [[RACObserve(self.userInfoVM,dataSource) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [self showAuditingResultView];
    }];
    
    [RACObserve(self.attestationVM,dataSource) subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
    
//    self.tableFooterView.footerButton.rac_command = [[RACCommand alloc] initWithEnabled:self.attestationVM.enableSubmit signalBlock:^RACSignal *(id input) {
//            [MBProgressHUD showMessage:@"请稍后" toView:self.view];
//        
//            [[self.attestationVM.attestationCommand execute:0] subscribeError:^(NSError *error) {
//                [MBProgressHUD hideHUDForView:self.view];
//            } completed:^{
//                [MBProgressHUD hideHUDForView:self.view];
//                [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
//                [self bk_performBlock:^(GGAttestationViewController *obj) {
//                    [obj.navigationController popToRootViewControllerAnimated:YES];
//                    [obj dismissViewControllerAnimated:YES completion:nil];
//                } afterDelay:1.1];
//            }];
//        return [RACSignal empty];
//    }];
    
    [[GGPrivateFileUploadViewModel sharedClient] refreshPrivateToken];
}

- (void)setupView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"实名认证";
    self.style = UITableViewStylePlain;
    self.view.backgroundColor = self.baseTableView.backgroundColor = [UIColor whiteColor];
    
    [self.baseTableView registerClass:[GGAttestationInfoCell class] forCellReuseIdentifier:kGGAttestationInfoCellID];
    
    [self.baseTableView registerClass:[GGAttestationChooseCityCell class] forCellReuseIdentifier:kGGAttestationChooseCityCellID];

    [self.baseTableView registerClass:[GGAttestionPhotoUploadCell class] forCellReuseIdentifier:kGGAttestionPhotoUploadCellID];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _identifiers = @{@(GGFormCellTypeNormal):kGGAttestationInfoCellID,
                     @(GGFormCellTypeIDCardPhoto):kGGAttestionPhotoUploadCellID,
                     @(GGFormCellTypeCarLocation):kGGAttestationChooseCityCellID};
    
//    [self.baseTableView setTableFooterView:self.tableFooterView];
    self.baseTableView.hidden = YES;
}

- (void)setRightBarItem
{
    AuditingType type = [GGLogin shareUser].user.auditingType;
    if (type == AuditingTypeNoSubmit || type == AuditingTypeInvaild) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]bk_initWithTitle:@"提交" style:UIBarButtonItemStylePlain handler:^(id sender) {
      
            if (![self checkSubmitInfo]) {
                return;
            }
            
            [MBProgressHUD showMessage:@"请稍后" toView:self.view];
            [[self.attestationVM.attestationCommand execute:0] subscribeError:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
            } completed:^{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
                [self bk_performBlock:^(GGAttestationViewController *obj) {
                    [obj.navigationController popToRootViewControllerAnimated:YES];
                    [obj dismissViewControllerAnimated:YES completion:nil];
                } afterDelay:1.1];
            }];
        }];
        RAC(self.navigationItem.rightBarButtonItem,enabled) = self.attestationVM.enableSubmit;
    }
}

- (BOOL)checkSubmitInfo
{
    if (self.attestationVM.attestation.identification.length != 18) {
        [MBProgressHUD showSuccess:@"您输入的身份证号位数不对!" toView:self.view];
        return NO;
    }
    
    return YES;
}
#pragma mark - 审核结果页面
- (void)showAuditingResultView
{
    if (self.showNoCheckTipView) {
        AuditingType type = [GGLogin shareUser].user.auditingType;
        if (type == AuditingTypeNoSubmit) {
            [self.noCheckedView showInCompanyController];
            [[self.noCheckedView.checkBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^
             (UIButton *sender){
                 self.noCheckedView.hidden = YES;
                 [self.noCheckedView removeFromSuperview];
                 self.noCheckedView = nil;
                 
                 [self setRightBarItem];
             }];
             self.baseTableView.hidden = NO;
        }else if (type == AuditingTypeInvaild){
            [self.checkedFailView showInAttestationController];
            [[self.checkedFailView.editBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^
             (UIButton *sender){
                 self.checkedFailView.hidden = YES;
                 [self.checkedFailView removeFromSuperview];
                 self.checkedFailView = nil;
                 [self setRightBarItem];
             }];
             self.baseTableView.hidden = NO;
        }
    } else {
        [self setRightBarItem];
    }

    AuditingType audingType = [GGLogin shareUser].user.auditingType;
    
    if (audingType == AuditingTypeWillAudit) {
        [self.checkingView showInAttestationController];
        [[self.checkingView.phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
            NSString *str = [[NSString alloc] initWithFormat:@"tel:%@",sender.currentTitle];
            UIWebView *callWebview = [[UIWebView alloc] initWithFrame:CGRectZero];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }];
        self.baseTableView.hidden = YES;
    }else if (audingType == AuditingTypePass){
        self.audingPassView.name = [GGLogin shareUser].user.realName;
        self.audingPassView.iDCard = [GGLogin shareUser].user.identification;
        [self.audingPassView showInAttestationController];
        self.baseTableView.hidden = YES;
    } else if (audingType == AuditingTypeInvaild) {
        NSString *errorMessage = [NSString stringWithFormat:@"未过原因：%@",[GGLogin shareUser].user.auditingDescription];
        self.baseTableView.tableHeaderView  = [GGTopMessageView initWithMessage:errorMessage];
        [self.attestationVM setAttestationDefaultData];
        self.baseTableView.hidden = NO;
    }else if (audingType == AuditingTypeNoSubmit){
        self.baseTableView.hidden = NO;
    }
}

#pragma mark - Table
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.attestationVM sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.attestationVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.attestationVM itemForIndexPath:indexPath];
    GGFormBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifiers[@(item.cellType)]];
    if (item.cellType == GGFormCellTypeNormal) {
        GGAttestationInfoCell *infoCell = (GGAttestationInfoCell *)cell;
        [cell configItem:item];
        [[[infoCell.inputTextField rac_textSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *text) {
            item.obj = text;
            [self.attestationVM.attestation setValue:item.obj forKey:item.propertyName];
        }];
    }else{
        [cell configItem:item];
    }
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGFormItem *item = [self.attestationVM itemForIndexPath:indexPath];
    if (item.cellType == GGFormCellTypeIDCardPhoto) {
        return 170;
    }
    
    if (item.cellType == GGFormCellTypeNormal) {
        return 78;
    }
    
    if (item.cellType == GGFormCellTypeCarLocation) {
        return 96;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GGFormItem *item = [self.attestationVM itemForIndexPath:indexPath];
    if (!item.canEdit) {
        return;
    }
    
    if (item.pageType == GGPageTypeImagePicker) {
        [GGPersonalPageRoute presentImagePickerControllerWith:item
                                           formViewController:self
                                                     callBack:^(id x) {
                                                         [self.attestationVM.reloadData execute:x];
                                                     }];
    }else{
        [GGPersonalPageRoute pushWithItem:item
                                      nav:self.navigationController
                                 callBack:^(id x) {
                                     [self.attestationVM.reloadData execute:x];
                                 }];
    }
    
}

#pragma mark - init View

//- (GGFooterView *)tableFooterView
//{
//    if (!_tableFooterView) {
//        _tableFooterView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 80) andFootButtonTitle:@"提交认证"];
//    }
//    return _tableFooterView;
//}

- (GGAttestationCheckingView *)checkingView
{
    if (!_checkingView) {
        _checkingView = [[GGAttestationCheckingView alloc] init];
        [self.view addSubview:_checkingView];
        [_checkingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _checkingView.hidden = YES;
    }
    return _checkingView;
}

- (GGAttestationAudingPassView *)audingPassView
{
    if (!_audingPassView) {
        _audingPassView = [[GGAttestationAudingPassView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_audingPassView];
        [_audingPassView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _audingPassView.hidden = YES;
    }
    return _audingPassView;
}


- (GGAttestationNoCheckedView *)noCheckedView
{
    if (!_noCheckedView) {
        _noCheckedView = [[GGAttestationNoCheckedView alloc] init];
        [self.view addSubview:_noCheckedView];
        [_noCheckedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _noCheckedView.hidden = YES;
    }
    return _noCheckedView;
}

- (GGAttestationChceckFailView *)checkedFailView
{
    if (!_checkedFailView) {
        _checkedFailView = [[GGAttestationChceckFailView alloc] init];
        [self.view addSubview:_checkedFailView];
        [_checkedFailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _checkedFailView.hidden = YES;
    }
    return _checkedFailView;
}

@end
