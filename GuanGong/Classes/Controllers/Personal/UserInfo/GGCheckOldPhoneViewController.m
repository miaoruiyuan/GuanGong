//
//  GGCheckOldPhoneViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/7/19.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCheckOldPhoneViewController.h"

#import "GGTextFieldButtonCell.h"
#import "GGFooterView.h"

@interface GGCheckOldPhoneViewController ()

@property(nonatomic,strong)GGFooterView *footView;
@property(nonatomic,copy)NSString *smsCode;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,assign)BOOL sendSMSCodeSuccess;

@end

@implementation GGCheckOldPhoneViewController

- (instancetype)initWithNewPhone:(NSString *)phone
{
    self = [super init];
    _phone = phone;
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

- (void)bindViewModel{
    
    @weakify(self);

    RAC(self.footView.footerButton,enabled) = [RACSignal combineLatest:@[RACObserve(self, smsCode)] reduce:^id(NSString *number){
        @strongify(self);

        return @(number.length >= 4 && self.sendSMSCodeSuccess);
    }];
    
    [[self.footView.footerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
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
    }];
}

- (void)setupView
{
    self.navigationItem.title = @"校验原手机";
    
    [self.baseTableView registerClass:[GGTextFieldButtonCell class] forCellReuseIdentifier:kCellIdentifierTextFieldButton];
    self.baseTableView.tableFooterView = self.footView;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGTextFieldButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTextFieldButton forIndexPath:indexPath];
    RAC(self, smsCode) = [cell.textField.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
    cell.textField.placeholder = @"输入短信验证码";
    
    @weakify(self);
    [[[cell.sendbutton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        @strongify(self);
        [self sendSMSAction:x];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:20];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        view.backgroundColor = tableBgColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width - 20, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = textLightColor;
        
        NSString *mobile = [GGLogin shareUser].user.mobile;
        if (mobile.length > 4) {
            NSString *text = [NSString stringWithFormat:@"请输入尾号%@收到的验证码",[mobile substringFromIndex:mobile.length - 4]];
            label.text = text;
        }
     
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return 30;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.01;
}
- (GGFooterView *)footView{
    if (!_footView) {
        _footView = [[GGFooterView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100) andFootButtonTitle:@"完成"];
    }
    return _footView;
}

- (void)sendSMSAction:(UIButton *)sender
{
    [[[self sendSMSCommand] execute:0] subscribeNext:^(id x) {
        [sender startCountDown];
    } error:^(NSError *error) {
        [sender endTimer];
    }];
}

- (RACCommand *)sendSMSCommand
{
    @weakify(self);
    RACCommand *sendSMSCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *dic = @{@"modifiedType":@"1",
                              @"newMobile":self.phone
                              };
        return [[GGApiManager request_ChangePhoneSendSMS:dic] map:^id(NSString *value) {
            @strongify(self);
            self.sendSMSCodeSuccess = YES;
            return [RACSignal empty];
        }];
    }];
    return sendSMSCommand;
}

- (RACCommand *)checkSMSCommand
{
    @weakify(self);
    RACCommand *chekcSMSCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSDictionary *dic = @{@"messageCode":self.smsCode,
                              @"modifiedType":@"1"};
        return [[GGApiManager request_ChangePhoneVerify:dic] map:^id(NSString *value) {
            return [RACSignal empty];
        }];
    }];
    return chekcSMSCommand;
}

@end
