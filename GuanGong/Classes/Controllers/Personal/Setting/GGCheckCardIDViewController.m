//
//  GGChecCardIDViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCheckCardIDViewController.h"
#import "GGFooterView.h"
#import "GGCheckCardIDViewModel.h"
#import "GGTitleValueCell.h"
#import "GGAddBankCardItemCell.h"

#import "GGBingNewPhoneViewController.h"
#import "GGSetPayPasswordViewController.h"
#import "GGCheckBankCardViewController.h"

@interface GGCheckCardIDViewController ()
{
    NSDictionary *_identifier;
}

@property (nonatomic,strong)GGCheckCardIDViewModel *viewModel;
@property (nonatomic,strong)GGFooterView *footView;

@end

@implementation GGCheckCardIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel
{
    self.viewModel = [[GGCheckCardIDViewModel alloc] init];
    
    @weakify(self);

    self.footView.footerButton.rac_command = [[RACCommand alloc] initWithEnabled:self.viewModel.submitBtnEnableSinal signalBlock:^RACSignal *(UIButton *button) {
        @strongify(self);
        [self.view endEditing:YES];
        [MBProgressHUD showMessage:@"请稍后..."];
        [[self.viewModel.submitCardInfoCommand execute:nil] subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUD];
        } completed:^{
            @strongify(self);
            [self gotoSuccessView];
            [MBProgressHUD showSuccess:@"身份校验成功" toView:self.view];
        }];
        return [RACSignal empty];
    }];
}

- (void)gotoSuccessView
{
    if (self.isChangePhone) {
        if (self.checkBankCard) {
            [self bk_performBlock:^(GGCheckCardIDViewController *viewController) {
                [MBProgressHUD hideHUDForView:self.view];
                GGCheckBankCardViewController *bankCardVC = [[GGCheckBankCardViewController alloc] init];
                [viewController.navigationController pushViewController:bankCardVC animated:YES];
            } afterDelay:0.6f];
        }else{
            [self bk_performBlock:^(GGCheckCardIDViewController *viewController) {
                [MBProgressHUD hideHUDForView:self.view];
                GGBingNewPhoneViewController *phoneVC = [[GGBingNewPhoneViewController alloc] init];
                [viewController.navigationController pushViewController:phoneVC animated:YES];
            } afterDelay:0.6f];

        }
    } else {
        [self bk_performBlock:^(GGCheckCardIDViewController *viewController) {
            [MBProgressHUD hideHUDForView:self.view];
            GGSetPayPasswordViewController *setPayPwdVC = [[GGSetPayPasswordViewController alloc] init];
            [viewController.navigationController pushViewController:setPayPwdVC animated:YES];
        } afterDelay:0.6f];
    }
}

- (void)setupView
{
    self.navigationItem.title = @"身份校验";
    [self.baseTableView registerClass:[GGTitleValueCell class] forCellReuseIdentifier:kCellIdentifierTitleValue];
    [self.baseTableView registerClass:[GGAddBankCardItemCell class] forCellReuseIdentifier:kGGAddBankCardItemCellID];
    
    _identifier = @{@(GGFormCellTypeNormal):kCellIdentifierTitleValue,
                    @(GGFormCellTypeTitleAndTextField):kGGAddBankCardItemCellID
                    };
    
    self.baseTableView.tableFooterView = self.footView;
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.viewModel itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGFormItem *item = [self.viewModel itemForIndexPath:indexPath];
    GGFormBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier[@(item.cellType)]];
    
    [cell configItem:item];
    
    if (indexPath.row == 1) {
        GGAddBankCardItemCell *inputCell = (GGAddBankCardItemCell *)cell;
        inputCell.inputTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [[[inputCell.inputTextField rac_textSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *inputText) {
            item.obj = self.viewModel.cardID = inputText;
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:20];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        view.backgroundColor = tableBgColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width - 20, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = textLightColor;
        label.text = @"填写证件号完成身份验证";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (GGFooterView *)footView
{
    if (!_footView) {
        _footView = [[GGFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100) andFootButtonTitle:@"下一步"];
    }
    return _footView;
}

@end
