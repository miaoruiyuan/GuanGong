//
//  GGTransferViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTransferViewController.h"
#import "GGSetPayPasswordViewController.h"
#import "GGMessageViewController.h"
#import "GGMarketViewController.h"
#import "GGTransferDetailViewController.h"
#import "GGWalletViewController.h"
#import "GGTransferAccountCell.h"
#import "GGTransferTypeCell.h"
#import "GGAccountView.h"
#import "GGFooterView.h"

#import "GGFriendBillListViewController.h"

@interface GGTransferViewController ()

@property(nonatomic,strong)GGAccountView *headerView;
@property(nonatomic,strong)GGFooterView *nextView;

@end

@implementation GGTransferViewController

- (instancetype)initWithItem:(GGAccount *)account{
    if (self = [super init]) {
        self.transferVM.account = account;
    }
    return self;
}

- (GGTransferAccountViewModel *)transferVM{
    if (!_transferVM) {
        _transferVM = [[GGTransferAccountViewModel alloc] init];
    }
    return _transferVM;
}

- (void)bindViewModel{
    RAC(self.nextView.footerButton,enabled) = [RACSignal combineLatest:@[RACObserve(self.transferVM.trade, tranAmount)] reduce:^id(NSString *tranAmount){
        return @(tranAmount.floatValue > 0);
    }];
}

- (void)setupView
{
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 146;

    if (self.transferVM.isTransfer) {
        self.navigationItem.title = @"转账";
    }else{
        self.navigationItem.title = @"担保支付";
        //默认支付全款
        if (!self.transferVM.isFinalPay) {
            self.transferVM.payType = PaymentTypeFQK;
        }
    }
    
    [self.view addSubview:self.nextView];
    
    self.headerView.account = self.transferVM.account;

    self.baseTableView.tableHeaderView = self.headerView;
    self.baseTableView.tableFooterView = self.nextView;
    [self.baseTableView registerClass:[GGTransferAccountCell class] forCellReuseIdentifier:kCellIdentifierTransferAccount];
    [self.baseTableView registerClass:[GGTransferTypeCell class] forCellReuseIdentifier:kCellIdentifierTransferType];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              bk_initWithTitle:@"交易记录"
                                              style:UIBarButtonItemStylePlain
                                              handler:^(id sender) {
                                                  @strongify(self);
                                                  GGFriendBillListViewController *billVC =
                                                  [[GGFriendBillListViewController alloc] init];
                                                  billVC.otherUserID = [self.transferVM.account.userId stringValue];
                                                  [self pushTo:billVC];
                                              }];
    //下一步
    [[self.nextView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        GGTransferDetailViewController *transferDetailVC = [[GGTransferDetailViewController alloc] initWithObject:self.transferVM];
        [self pushTo:transferDetailVC];
        
        if (!self.transferVM.isTransfer) {
            if (self.transferVM.payType == PaymentTypeFDJ){
                [MobClick event:@"paydepositfs"];
            }else if(self.transferVM.payType == PaymentTypeFQK){
                [MobClick event:@"payfull"];
            }
        }
    }];

    //判断是否设置了支付密码
    if (![GGLogin shareUser].haveSetPayPassword) {
        [UIAlertController alertInController:self
                                       title:@"使用此功能之前需要设置支付密码哦"
                                     message:nil
                                  confrimBtn:@"去设置"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:^{
                                   GGSetPayPasswordViewController *setPVC = [[GGSetPayPasswordViewController alloc] init];
                                   [GGMarketViewController presentVC:setPVC];
                               }
                                   cancelBtn:@"取消"
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:^{
                                    [self pop];
                                }];
        return;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.transferVM.isFinalPay ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        GGTransferAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTransferAccount forIndexPath:indexPath];
        [cell updataUIByType:self.transferVM.isTransfer];
        
        RAC(self.transferVM.trade,tranAmount) = [cell.amountField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        [cell.amountField becomeFirstResponder];

        RACSignal *textSignal = [cell.remarkField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        @weakify(self);
        [textSignal subscribeNext:^(NSString *remarkText) {
            @strongify(self);

            UITextField *textField = cell.remarkField;
            
            NSString *toBeString = textField.text;
            NSString *lang = [[textField textInputMode] primaryLanguage]; // 键盘输入模式
            if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
                UITextRange *selectedRange = [textField markedTextRange];
                UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
                if(!position) {
                    if(toBeString.length > 15) {
                        textField.text = [toBeString substringToIndex:15];
                    }
                }
            } else {
                if(toBeString.length > 15) {
                    textField.text = [toBeString substringToIndex:15];
                }
            }
            self.transferVM.trade.reserve = cell.remarkField.text;
        }];
        return cell;
    } else {
        GGTransferTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTransferType forIndexPath:indexPath];
        if (self.transferVM.isFinalPay) {
            [cell.segment removeAllSegments];
            [cell.segment insertSegmentWithTitle:@"尾款" atIndex:0 animated:YES];
            cell.segment.selectedSegmentIndex = 0;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 136;
    }else{
        return [GGTransferTypeCell cellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (GGAccountView *)headerView{
    if (!_headerView) {
        _headerView = [[GGAccountView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 170)];
    }
    return _headerView;
}

- (GGFooterView *)nextView{
    if (!_nextView) {
        _nextView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 70) andFootButtonTitle:@"下一步"];
    }
    return _nextView;
}

@end
