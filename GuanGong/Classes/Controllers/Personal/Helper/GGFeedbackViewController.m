//
//  GGFeedbackViewController.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/23.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGFeedbackViewController.h"
#import "GGOneLineTextHeaderView.h"
#import "GGHelpQuestionViewModel.h"
#import "GGRemarkCell.h"
#import "GGFooterView.h"
#import "GGHelpQuestionTypesCell.h"

@interface GGFeedbackViewController ()

@property (nonatomic,strong)GGHelpQuestionViewModel *questionVM;
@property (nonatomic,strong)UIView *tableFooterView;

@end

@implementation GGFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView
{
    self.navigationItem.title = @"意见反馈";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"提交" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [self submitFeedback];
    }];
    
    
    self.style = UITableViewStylePlain;
    
    [self.baseTableView registerClass:[GGRemarkCell class] forCellReuseIdentifier:kCellIdentifierRemarkCell];
    [self.baseTableView registerClass:[GGHelpQuestionTypesCell class] forCellReuseIdentifier:kGGHelpQuestionTypesCellID];
    [self.baseTableView registerClass:[GGOneLineTextHeaderView class] forHeaderFooterViewReuseIdentifier:kGGOneLineTextHeaderViewID];

    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.baseTableView setTableFooterView:self.tableFooterView];
}

- (void)bindViewModel
{
    self.questionVM = [[GGHelpQuestionViewModel alloc] init];
    
    @weakify(self);
    
    [[self.questionVM.getHelpTypesCommand execute:nil] subscribeError:^(NSError *error) {
        
    } completed:^{
        @strongify(self);
        [self.baseTableView reloadData];
    }];
}


- (void)submitFeedback
{
    if (![self checkInput]) {
        return;
    }
    @weakify(self);
    [[self.questionVM.feedbackCommand execute:nil] subscribeError:^(NSError *error) {
        
    } completed:^{
        @strongify(self);
        [MBProgressHUD showSuccess:@"反馈成功"];
        [NSObject bk_performBlock:^{
            [self pop];
        } afterDelay:1.0f];
    }];
}


- (BOOL)checkInput
{
    if (self.questionVM.feedbackModel.content.length < 1) {
        [MBProgressHUD showError:@"请输入您要反馈的内容" toView:self.view];
        return NO;
    }
    
    if (self.questionVM.feedbackModel.questionTypeId == 0) {
        [MBProgressHUD showError:@"请选择问题类型" toView:self.view];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GGRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierRemarkCell forIndexPath:indexPath];
        [cell updateUIWithFeedbackModel:self.questionVM.feedbackModel];
        [[[cell.remarkTextView rac_textSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *text) {
            self.questionVM.feedbackModel.content = text;
        }];
        return cell;
    }else if (indexPath.section == 1){
        GGHelpQuestionTypesCell *cell = [tableView dequeueReusableCellWithIdentifier:kGGHelpQuestionTypesCellID forIndexPath:indexPath];
        [cell showWithTypeArray:self.questionVM.dataSource];
        
        @weakify(self);
        [cell typeSelectedBlock:^(NSInteger index) {
            @strongify(self);
            GGHelpQuestionTypeModel *model = self.questionVM.dataSource[index];
            self.questionVM.feedbackModel.questionTypeId = model.questionTypeId;
        }];
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 180;
    }else if (indexPath.section == 1) {
        return [GGHelpQuestionTypesCell getCellHight:self.questionVM.dataSource];
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 32;
    }else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GGOneLineTextHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kGGOneLineTextHeaderViewID];
    if (section == 0) {
        [headerView showTitle:[self.questionVM getFeedbackHeaderTitle]];
    }else{
        [headerView showTitle:nil];
    }
    return headerView;
}

#pragma mark - tableFooterView

- (UIView *)tableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 72)];
        
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@" 客服电话 400-822-0063"];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b7b7b7"]  range:NSMakeRange(1,5)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"737373"]  range:NSMakeRange(6,12)];
        [attributedStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(6,12)];
        
        [phoneBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [phoneBtn setTitleColor:[UIColor colorWithHexString:@"737373"] forState:UIControlStateNormal];
        
        [phoneBtn setImage:[UIImage imageNamed:@"feedback_phone_icon"] forState:UIControlStateNormal];
        [_tableFooterView addSubview:phoneBtn];
        
        [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_tableFooterView);
        }];
        
        @weakify(self);
        [[phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            NSString *str = [[NSString alloc] initWithFormat:@"tel:%@",@"400-822-0063"];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }];
    }
    return _tableFooterView;
}

@end
