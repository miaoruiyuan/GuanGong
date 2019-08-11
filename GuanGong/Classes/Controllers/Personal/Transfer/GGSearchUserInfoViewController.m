//
//  GGTransferAccountsViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSearchUserInfoViewController.h"
#import "GGTransferViewController.h"
#import "GGTitleTextFieldCell.h"
#import "GGFooterView.h"

#import "GGAccount.h"

@interface GGSearchUserInfoViewController ()

@property(nonatomic,strong)GGFooterView *nextView;

@property(nonatomic,strong,readonly)RACCommand *searchCommand;

@property(nonatomic,copy)NSString *mobile;

@end

@implementation GGSearchUserInfoViewController

- (void)bindViewModel{
    RACSignal *signal = [RACSignal combineLatest:@[RACObserve(self, mobile)] reduce:^(NSString *text){
        return @(text.length == 11);
    }];
    
    RAC(self.nextView.footerButton,enabled) = signal;
}

- (void)setupView{
    self.navigationItem.title = @"查找账户";

    if (!self.isTransfer) {
        [self explainView];
    }
    
    [self.baseTableView registerClass:[GGTitleTextFieldCell class] forCellReuseIdentifier:kCellIdentifierTitleTextField];
    self.baseTableView.tableFooterView = self.nextView;

    @weakify(self);
    [[self.nextView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        @strongify(self);
        NSString *inputText = [self.mobile removeSpaces];
        if ([inputText isEqualToString:[GGLogin shareUser].user.mobile]) {
            [MBProgressHUD showError:@"不能给自己转账哦" toView:self.view];
            return ;
        }
        
        [self.nextView.footerButton showIndicator];
        [[self.searchCommand execute:inputText] subscribeError:^(NSError *error) {
             [self.nextView.footerButton hideIndicator];
         } completed:^{
             [self.nextView.footerButton hideIndicator];
         }];
    }];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGTitleTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTitleTextField];
    RAC(self,mobile) = [cell.inputFiled.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
    cell.titleLabel.text  = @"对方帐号";
    cell.inputFiled.placeholder = @"手机号码";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

- (GGFooterView *)nextView{
    if (!_nextView) {
        _nextView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100) andFootButtonTitle:@"下一步"];
    }
    return _nextView;
}

#pragma mark - 搜索用户

- (RACCommand *)searchCommand{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
        
        return [[GGApiManager request_SearchUserInfo_WithMobile:input] map:^id(NSDictionary *value) {
            @strongify(self);
            GGAccount *account = [GGAccount modelWithDictionary:value];
            GGTransferViewController *transferVC = [[GGTransferViewController alloc]initWithItem:account];
            transferVC.transferVM.isTransfer = self.isTransfer;
            transferVC.transferVM.isFinalPay = NO;
            [self pushTo:transferVC];
            return [RACSignal empty];
        }];
    }];
}

- (void)explainView{

    @weakify(self);
    UIBarButtonItem *rightItem =  [[UIBarButtonItem alloc]bk_initWithImage:[[UIImage imageNamed:@"explain"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        
        [UIAlertController alertInController:self
                                       title:@"担保支付说明"
                                     message:@"使用担保支付,资金会先转到关二爷的担保账户,交易完成双方无争议后打款给卖家.\n资金有保证,交易更放心!"
                                  confrimBtn:@"知道了"
                                confrimStyle:UIAlertActionStyleDefault
                               confrimAction:nil
                                   cancelBtn:nil
                                 cancelStyle:UIAlertActionStyleCancel
                                cancelAction:nil];
    }];
    
    self.navigationItem.rightBarButtonItem = self.isTransfer ? nil : rightItem;
}

@end
