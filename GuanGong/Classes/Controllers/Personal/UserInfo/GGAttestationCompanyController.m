//
//  GGAttestationCompanyController.m
//  GuanGong
//
//  Created by CodingTom on 2017/4/6.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGAttestationCompanyController.h"
#import "GGAttestationCompanyViewModel.h"
#import "GGTopMessageView.h"
#import "GGFooterView.h"
#import "GGPersonalPageRoute.h"
#import "GGUserInfoViewModel.h"
#import "ActionSheetStringPicker.h"

#import "GGAttestationInfoCell.h"
#import "GGAttestionPhotoUploadCell.h"
#import "GGCompanyCodeCell.h"

#import "GGAttestationNoCheckedView.h"
#import "GGAttestationCheckingView.h"
#import "GGAttestationAudingPassView.h"
#import "GGPrivateFileUploadViewModel.h"

@interface GGAttestationCompanyController ()

@property(nonatomic,strong)GGUserInfoViewModel *userInfoVM;
@property(nonatomic,strong)GGAttestationCompanyViewModel *companyVM;

//@property(nonatomic,strong)GGFooterView *tableFooterView;


@property(nonatomic,strong)GGAttestationNoCheckedView *noCheckedView;

@property(nonatomic,strong)GGAttestationCheckingView *checkingView;
@property(nonatomic,strong)GGAttestationAudingPassView *audingPassView;


@end

@implementation GGAttestationCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GGUserInfoViewModel *)userInfoVM{
    if (!_userInfoVM) {
        _userInfoVM = [[GGUserInfoViewModel alloc] init];
    }
    return _userInfoVM;
}

- (GGAttestationCompanyViewModel *)companyVM
{
    if (!_companyVM) {
        _companyVM = [[GGAttestationCompanyViewModel alloc] init];
    }
    return _companyVM;
}

- (void)setupView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"企业认证";
    self.style = UITableViewStylePlain;
    self.view.backgroundColor = self.baseTableView.backgroundColor = [UIColor whiteColor];
    
    [self.baseTableView registerClass:[GGAttestationInfoCell class] forCellReuseIdentifier:kGGAttestationInfoCellID];
    [self.baseTableView registerClass:[GGCompanyCodeCell class] forCellReuseIdentifier:kGGCompanyCodeCellID];
    
    [self.baseTableView registerClass:[GGAttestionPhotoUploadCell class] forCellReuseIdentifier:kGGAttestionPhotoUploadCellID];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [self.baseTableView setTableFooterView:self.tableFooterView];
    self.baseTableView.hidden = YES;
}

- (void)bindViewModel
{
    @weakify(self);
    [RACObserve(self.companyVM,dataSource) subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
        DLog(@"%@",[self.companyVM.dataSource modelDescription]);
    }];
    
    [[RACObserve(self.userInfoVM,dataSource) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [self showAuditingResultView];
    }];
    
//    self.tableFooterView.footerButton.rac_command = [[RACCommand alloc] initWithEnabled:self.companyVM.enableSubmit signalBlock:^RACSignal *(id input) {
//        
//        if (self.companyVM.isSocialCreditCode && self.companyVM.attestationCompany.socialCreditCode.length < 18) {
//            [UIAlertController alertInController:self title:nil message:@"您输入的统一社会代码未满18位,如填写的是营业执照,请点击切换" confrimBtn:@"切换" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
//                self.companyVM.isSocialCreditCode = NO;
//                self.companyVM.attestationCompany.businessLicenceCode = self.companyVM.attestationCompany.socialCreditCode;
//                self.companyVM.attestationCompany.socialCreditCode = nil;
//                [self.companyVM.reloadData execute:nil];
//            } cancelBtn:@"返回修改" cancelStyle:UIAlertActionStyleCancel cancelAction:^{
//                
//            }];
//            return [RACSignal empty];
//        }else{
//            if (self.companyVM.attestationCompany.businessLicenceCode.length > 15) {
//                [UIAlertController alertInController:self title:nil message:@"您输入的营业执照超过15位,如填写的是统一社会代码,请点击切换" confrimBtn:@"切换" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
//                    self.companyVM.isSocialCreditCode = YES;
//                    self.companyVM.attestationCompany.socialCreditCode = self.companyVM.attestationCompany.businessLicenceCode;
//                    self.companyVM.attestationCompany.businessLicenceCode = nil;
//                    [self.companyVM.reloadData execute:nil];
//                } cancelBtn:@"返回修改" cancelStyle:UIAlertActionStyleCancel cancelAction:^{
//                    
//                }];
//                return [RACSignal empty];
//            }
//        }
//        
//        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
//        
//        [[self.companyVM.attestationCommand execute:0] subscribeError:^(NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view];
//        } completed:^{
//            [MBProgressHUD hideHUDForView:self.view];
//            [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
//            [self bk_performBlock:^(GGAttestationCompanyController *obj) {
//                [obj.navigationController popToRootViewControllerAnimated:YES];
//                [obj dismissViewControllerAnimated:YES completion:nil];
//            } afterDelay:1.1];
//        }];
//        return [RACSignal empty];
//    }];
    
    [[GGPrivateFileUploadViewModel sharedClient] refreshPrivateToken];
}

- (void)setRightBarItem
{
    CompanyAuditingType type = [GGLogin shareUser].company.auditStatus;
    if (type == CompanyAuditingTypeNoSubmit || type == CompanyAuditingTypeInvaild) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]bk_initWithTitle:@"提交" style:UIBarButtonItemStylePlain handler:^(id sender) {
            
            if (self.companyVM.isSocialCreditCode && self.companyVM.attestationCompany.socialCreditCode.length < 18) {
                [UIAlertController alertInController:self title:nil message:@"您输入的统一社会代码未满18位,如填写的是营业执照,请点击切换" confrimBtn:@"切换" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                    self.companyVM.isSocialCreditCode = NO;
                    self.companyVM.attestationCompany.businessLicenceCode = self.companyVM.attestationCompany.socialCreditCode;
                    self.companyVM.attestationCompany.socialCreditCode = nil;
                    [self.companyVM.reloadData execute:nil];
                } cancelBtn:@"返回修改" cancelStyle:UIAlertActionStyleCancel cancelAction:^{
                    
                }];
                return;
            }else{
                if (self.companyVM.attestationCompany.businessLicenceCode.length > 15) {
                    [UIAlertController alertInController:self title:nil message:@"您输入的营业执照超过15位,如填写的是统一社会代码,请点击切换" confrimBtn:@"切换" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                        self.companyVM.isSocialCreditCode = YES;
                        self.companyVM.attestationCompany.socialCreditCode = self.companyVM.attestationCompany.businessLicenceCode;
                        self.companyVM.attestationCompany.businessLicenceCode = nil;
                        [self.companyVM.reloadData execute:nil];
                    } cancelBtn:@"返回修改" cancelStyle:UIAlertActionStyleCancel cancelAction:^{
                        
                    }];
                    return;
                }
            }
            
            [MBProgressHUD showMessage:@"请稍后" toView:self.view];
            
            [[self.companyVM.attestationCommand execute:0] subscribeError:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
            } completed:^{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
                [self bk_performBlock:^(GGAttestationCompanyController *obj) {
                    [obj.navigationController popToRootViewControllerAnimated:YES];
                    [obj dismissViewControllerAnimated:YES completion:nil];
                } afterDelay:1.1];
            }];
        }];
        RAC(self.navigationItem.rightBarButtonItem,enabled) = self.companyVM.enableSubmit;
    }
}

#pragma mark - 审核结果页面

- (void)showAuditingResultView
{
    if ([GGLogin shareUser].user.auditingType != AuditingTypePass) {
        [self.noCheckedView showInCompanyController];
        [[self.noCheckedView.checkBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
            [self.navigationController popViewControllerAnimated:NO];
            if (self.popHandler) {
                self.popHandler(nil);
            }
        }];
        return;
    }
    
    GGCompanyModel *company = [GGLogin shareUser].company;
    if (company && company.companyName.length > 0) {
        CompanyAuditingType audingType = company.auditStatus;
        if (audingType == CompanyAuditingTypeWait) {
            [self.checkingView showInCompanyController];
            [[self.checkingView.phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
                NSString *str = [[NSString alloc] initWithFormat:@"tel:%@",sender.currentTitle];
                UIWebView *callWebview = [[UIWebView alloc] initWithFrame:CGRectZero];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }];
            self.baseTableView.hidden = YES;
        }else if (audingType == CompanyAuditingTypePass){
            self.audingPassView.name = [GGLogin shareUser].company.companyName;
            [self.audingPassView showInCompanyController];
            self.baseTableView.hidden = YES;
        } else if (audingType== CompanyAuditingTypeInvaild) {
            NSString *errorMessage = [NSString stringWithFormat:@"未过原因：%@",company.auditDescription];
            self.baseTableView.tableHeaderView  = [GGTopMessageView initWithMessage:errorMessage];
            [self.companyVM setAttestationDefaultData];
            self.baseTableView.hidden = NO;
            [self setRightBarItem];
        }else if (audingType== CompanyAuditingTypeNoSubmit){
            self.baseTableView.hidden = NO;
            [self setRightBarItem];
        }
    } else {
        self.baseTableView.hidden = NO;
        [self setRightBarItem];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.companyVM sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.companyVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.companyVM itemForIndexPath:indexPath];
    if (item.cellType == GGFormCellTypeNormal) {
        GGAttestationInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGAttestationInfoCellID];
        [cell configItem:item];
        [[[cell.inputTextField rac_textSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *text) {
            item.obj = text;
            [self.companyVM.attestationCompany setValue:item.obj forKey:item.propertyName];
        }];
        return cell;
        
    } else if (item.cellType == GGFormCellTypeIDCardPhoto){
        GGAttestionPhotoUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGAttestionPhotoUploadCellID];
        [cell configCompanyItem:item];
        return cell;
        
    } else if (item.cellType == GGFormCellTypeShowPicker) {
        GGCompanyCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGCompanyCodeCellID];
        [cell configItem:item];
        [[[cell.titleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *sender) {
            [self showCodePicker:item];
        }];
        
        [[[cell.inputTextField rac_textSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *text) {
            item.obj = text;
            [self.companyVM.attestationCompany setValue:item.obj forKey:item.propertyName];
        }];
        
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGFormItem *item = [self.companyVM itemForIndexPath:indexPath];
    if (item.cellType == GGFormCellTypeIDCardPhoto) {
        if (indexPath.row == 4) {
            return 142;
        }if (indexPath.row == 6) {
            return 207;
        }
        return 182;
    }
    
    if (item.cellType == GGFormCellTypeNormal ) {
        return 78;
    }
    if (item.cellType == GGFormCellTypeShowPicker) {
        return 78;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGFormItem *item = [self.companyVM itemForIndexPath:indexPath];
    if (!item.canEdit) {
        return;
    }
    
    if (item.pageType == GGPageTypeImagePicker) {
        [GGPersonalPageRoute presentImagePickerControllerWith:item
                                           formViewController:self
                                                     callBack:^(id x) {
                                                         [self.companyVM.reloadData execute:x];
                                                     }];
    }else{
        [GGPersonalPageRoute pushWithItem:item
                                      nav:self.navigationController
                                 callBack:^(id x) {
                                     [self.companyVM.reloadData execute:x];
                                 }];
    }
    
}

- (void)showCodePicker:(GGFormItem *)item
{
    NSArray *rowArray = @[@"统一社会信用代码",@"营业执照号"];
    NSInteger defaultIndex = 1;
    if (self.companyVM.isSocialCreditCode) {
        defaultIndex = 0;
    }
    [ActionSheetStringPicker showPickerWithTitle:@""
                                            rows:rowArray
                                initialSelection:defaultIndex
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           if (defaultIndex != selectedIndex ) {
                                               item.obj = @"";
                                           }
                                           self.companyVM.isSocialCreditCode = selectedIndex == 1 ? NO : YES;
                                           [self.companyVM.reloadData execute:item];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         picker = nil;
                                     } origin:self.view];
}

#pragma mark - init View

//- (GGFooterView *)tableFooterView
//{
//    if (!_tableFooterView) {
//        _tableFooterView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 80) andFootButtonTitle:@"提交认证"];
//    }
//    return _tableFooterView;
//}

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


@end
