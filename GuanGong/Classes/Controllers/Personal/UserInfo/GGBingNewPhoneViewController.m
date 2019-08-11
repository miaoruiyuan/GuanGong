//
//  GGBingNewPhoneViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/19.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGBingNewPhoneViewController.h"
#import "GGFooterView.h"
#import "GGTextFieldButtonCell.h"
#import "GGTextFileldCell.h"

#import "GGCheckOldPhoneViewController.h"

@interface GGBingNewPhoneViewController ()

@property(nonatomic,strong)GGFooterView *footView;

@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *smsCode;

@property(nonatomic,copy)NSString *bankCardID;
@property(nonatomic,assign)BOOL checkBankCard;

@end

@implementation GGBingNewPhoneViewController

- (instancetype)initWithBankCard:(NSString *)bankCard
{
    if (self = [super init]) {
        if (bankCard) {
            _bankCardID = bankCard;
            _checkBankCard = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel
{
    RAC(self.footView.footerButton,enabled) = [RACSignal combineLatest:@[RACObserve(self, smsCode),
                                                                         RACObserve(self, phone)]
                                                                reduce:^id(NSString *number,NSString *phone){
        return @(number.length >= 6 && phone.length == 11);
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"绑定新手机";
    [self.baseTableView registerClass:[GGTextFileldCell class] forCellReuseIdentifier:kCellIdentifierTextField];
    [self.baseTableView registerClass:[GGTextFieldButtonCell class] forCellReuseIdentifier:kCellIdentifierTextFieldButton];
    self.baseTableView.tableFooterView = self.footView;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    [[self.footView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        if (self.checkBankCard) {
            [[[self checkSMSCommand] execute:0] subscribeNext:^(id x) {
                @strongify(self);
                [UIAlertController alertInController:self
                                               title:nil
                                             message:@"修改手机号成功，您需要重新登录哦～"
                                          confrimBtn:@"知道了"
                                        confrimStyle:UIAlertActionStyleDefault
                                       confrimAction:^{
                                           [[GGLogin shareUser] logOut];
                                       }
                                           cancelBtn:nil
                                         cancelStyle:UIAlertActionStyleCancel
                                        cancelAction:nil];
            } error:^(NSError *error) {

            }];
        }else{
            [[[self checkSMSCommand] execute:0] subscribeNext:^(id x) {
                @strongify(self);
                GGCheckOldPhoneViewController *oldPhoneVC = [[GGCheckOldPhoneViewController alloc] initWithNewPhone:self.phone];
                [self pushTo:oldPhoneVC];
            } error:^(NSError *error) {
            
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        GGTextFileldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTextField forIndexPath:indexPath];
        cell.textField.placeholder = @"绑定新手机号";
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
        RAC(self,phone) = [cell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
    } else {
        GGTextFieldButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTextFieldButton forIndexPath:indexPath];
        
        cell.textField.placeholder = @"输入短信验证码";
        RAC(self,smsCode) = [cell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        RAC(cell.sendbutton,enabled) = [[RACSignal combineLatest:@[RACObserve(self, phone)] reduce:^id(NSString *phone){
            return @(phone.length == 11);
        }] takeUntil:cell.rac_prepareForReuseSignal];
        
        @weakify(self);
        [[[cell.sendbutton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *sender) {
            @strongify(self);
            [self sendSMSAction:sender];
        }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:20];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (GGFooterView *)footView{
    if (!_footView) {
        if (self.checkBankCard) {
            _footView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 88) andFootButtonTitle:@"完成"];
        }else{
            _footView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 88) andFootButtonTitle:@"下一步"];
        }
    }
    return _footView;
}
#pragma mark - 发送验证码

- (void)sendSMSAction:(UIButton *)sender
{
    @weakify(sender);
    [[[self sendSMSCommand] execute:0] subscribeNext:^(id x) {
        @strongify(sender);
        [sender startCountDown];
    } error:^(NSError *error) {
        @strongify(sender);
        [sender endTimer];
    }];
}

- (RACCommand *)sendSMSCommand
{
    @weakify(self);
    if (self.checkBankCard) {
        RACCommand *sendSMSCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            NSDictionary *dic = @{@"newMobile":self.phone,
                                  @"modifiedType":@"2",
                                  @"acctId":self.bankCardID};
            return [[GGApiManager request_ChangePhoneSendSMS:dic] map:^id(NSString *value) {
                return [RACSignal empty];
            }];
        }];
        return sendSMSCommand;
    }else{
        RACCommand *sendSMSCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            NSDictionary *dic = @{@"mobile":self.phone};
            return [[GGApiManager request_NewPhoneSendSMS:dic] map:^id(NSString *value) {
                return [RACSignal empty];
            }];
        }];
        return sendSMSCommand;
    }
}

- (RACCommand *)checkSMSCommand
{
    @weakify(self);
    if (self.checkBankCard) {
        RACCommand *chekcSMSCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            NSDictionary *dic = @{@"messageCode":self.smsCode,
                                  @"modifiedType":@"2"};
            return [[GGApiManager request_ChangePhoneVerify:dic] map:^id(NSString *value) {
                return [RACSignal empty];
            }];
        }];
        return chekcSMSCommand;
    } else {
        RACCommand *chekcSMSCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            NSDictionary *dic = @{@"messageCode":self.smsCode,
                                  @"mobile":self.phone};
            return [[GGApiManager request_NewPhoneVerify:dic] map:^id(NSString *value) {
                return [RACSignal empty];
            }];
        }];
        return chekcSMSCommand;
    }
}

@end
