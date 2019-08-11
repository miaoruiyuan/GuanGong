
//
//  GGOtherPayDetailViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGOtherPayDetailViewController.h"
#import "GGFriendInfoViewController.h"
#import "GGOtherPayDetailViewModel.h"
#import "GGOtherPayDetailPriceCell.h"
#import "GGOtherPayDetailPayerCell.h"
#import "GGOtherPayDetailInfoCell.h"
#import "GGOtherPayDetailDateCell.h"
#import "GGPaymentCodeView.h"
#import "GGDetailBottomView.h"
#import "GGCheckCardIDViewController.h"

@interface GGOtherPayDetailViewController ()<GGPaymentCodeDelegate>

@property(nonatomic,strong)GGOtherPayDetailViewModel *payDetailVM;

@property(nonatomic,strong)GGDetailBottomView *bView;

@property(nonatomic,strong)GGPaymentCodeView *codeView;
@property(nonatomic,assign)NSInteger sectionCount;

@end

@implementation GGOtherPayDetailViewController{
}

- (void)bindViewModel{
    [self.payDetailVM.applyDetailCommand execute:self.applyId];
    @weakify(self);
    [[self.payDetailVM.applyDetailCommand.executing skip:1]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x isEqualToNumber:@YES]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
    }];
    
    [[RACObserve(self.payDetailVM, otherPayDetail)skip:1] subscribeNext:^(GGOtherPayDetail *x) {
       @strongify(self);
        if (x.status == OtherPayStatusDCL) {
            NSArray *array = nil;
            if (self.isMineApply) {
                array  = @[@"取消代付"];
            }else{
                array  = @[@"拒绝代付",@"立即代付"];
            }
            
            self.bView = [[GGDetailBottomView alloc] initWithButtonTitles:array buttonAction:^(UIButton *sender, NSInteger index) {
                
                if (index == 0) {
                    if (self.isMineApply) {
                        [MobClick event:@"cancelpayforanther"];
                    }else{
                        [MobClick event:@"refusepay"];
                    }
                    [UIAlertController alertInController:self title:[NSString stringWithFormat:@"确定%@?",array[index]] message:nil confrimBtn:@"确认" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                        
                        [[self.payDetailVM.cancelApplyCommand execute:self.applyId] subscribeCompleted:^{
                            [MBProgressHUD showSuccess:@"操作成功" toView:self.view];
                            
                            [[NSNotificationCenter defaultCenter]postNotificationName:GGOtherPayListNotification object:nil];
                            [self bk_performBlock:^(GGOtherPayDetailViewController *obj) {
                                [obj pop];
                            } afterDelay:1.1];
                        }];
                        
                    } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
                }else{
                    [MobClick event:@"paynow"];
                    [UIAlertController alertInController:self title:@"请务必先核实申请人的身份后再付款,代付商品不归你所有" message:@"代付成功将从钱包中扣除相应金额" confrimBtn:@"确认" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                        [self.codeView show];
                    } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
                }
            }];
            
            [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
            }];
            
            [self.view addSubview:self.bView];
            [self.bView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.bottom.equalTo(self.view);
                make.height.mas_equalTo(44);
            }];
            
        }

        self.sectionCount = 3;
        [self.baseTableView reloadData];
    }];
    
    
}


- (void)setupView{
    self.navigationItem.title = @"代付详情";
    
    self.baseTableView.sectionFooterHeight = 12;
    self.baseTableView.sectionHeaderHeight = 0.01;
    [self.baseTableView registerClass:[GGOtherPayDetailPriceCell class] forCellReuseIdentifier:kCellIdentifierOtherPayDetailPrice];
    [self.baseTableView registerClass:[GGOtherPayDetailPayerCell class] forCellReuseIdentifier:kCellIdentifierOtherPayDetailPayer];
    [self.baseTableView registerClass:[GGOtherPayDetailInfoCell class] forCellReuseIdentifier:kCellIdentifierOtherPayDetailInfo];
    [self.baseTableView registerClass:[GGOtherPayDetailDateCell class] forCellReuseIdentifier:kCellIdentifierOtherPayDetailDate];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


#pragma mark - Tb
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                GGOtherPayDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOtherPayDetailPrice];
                cell.payDetail = self.payDetailVM.otherPayDetail;
                return cell;
            }else{
                GGOtherPayDetailPayerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOtherPayDetailPayer];
                cell.payDetail = self.payDetailVM.otherPayDetail;
                return cell;
            }
        }
            break;
            
        case 1:{
            GGOtherPayDetailInfoCell *cell  = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOtherPayDetailInfo];
            cell.isMineApply = self.isMineApply;
            cell.payDetail = self.payDetailVM.otherPayDetail;
            return cell;
        }
            
            break;
            
        default:{
            GGOtherPayDetailDateCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierOtherPayDetailDate];
            cell.payDetail = self.payDetailVM.otherPayDetail;
            return cell;
        }
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
                    return 100;
                    break;
                    
                default:
                    return 52;
                    break;
            }
        }
            break;
            
        case 1:
            return [tableView fd_heightForCellWithIdentifier:kCellIdentifierOtherPayDetailInfo cacheByIndexPath:indexPath configuration:^(GGOtherPayDetailInfoCell *cell) {
                cell.isMineApply = self.isMineApply;
                cell.payDetail = self.payDetailVM.otherPayDetail;
                
            }];
            break;

            
        default:
            return [tableView fd_heightForCellWithIdentifier:kCellIdentifierOtherPayDetailDate cacheByIndexPath:indexPath configuration:^(GGOtherPayDetailDateCell *cell) {
                cell.payDetail = self.payDetailVM.otherPayDetail;

            }];
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (self.payDetailVM.otherPayDetail.salerIsUser == 1) {
            GGFriendInfoViewController *friendInfoVC = [[GGFriendInfoViewController alloc] init];
            friendInfoVC.dealerId = self.payDetailVM.otherPayDetail.saler.salerId;
            [self pushTo:friendInfoVC];
        }
    }
}

- (void)didTappedConfirmButtonWithpaymentPassword:(NSString *)paymentPassword{
    [self.codeView dismiss];
    @weakify(self);
    [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    [[self.payDetailVM.agreeApplyCommand execute:RACTuplePack(self.applyId,paymentPassword)] subscribeError:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        [self.payDetailVM.applyDetailCommand execute:self.applyId];
    } completed:^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"代付成功" toView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:GGTransferSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:GGOtherPayListNotification object:nil];
        [self bk_performBlock:^(GGOtherPayDetailViewController *obj) {
            [obj pop];
        } afterDelay:1.1];
    }];
}

- (void)didTappedColseButton{
}

- (void)didTappedForgetPasswordButton{
    GGCheckCardIDViewController *setPayPassVC = [[GGCheckCardIDViewController alloc] init];
    [[self class] presentVC:setPayPassVC];
}

- (GGPaymentCodeView *)codeView{
    if (!_codeView) {
        _codeView = [[GGPaymentCodeView alloc] init];
        _codeView.delegate = self;
    }
    return _codeView;
}

- (GGOtherPayDetailViewModel *)payDetailVM{
    if (!_payDetailVM) {
        _payDetailVM = [[GGOtherPayDetailViewModel alloc] init];
    }
    return _payDetailVM;
}


@end
