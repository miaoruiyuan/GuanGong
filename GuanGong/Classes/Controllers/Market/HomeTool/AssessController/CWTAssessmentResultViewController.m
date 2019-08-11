//
//  CWTAssessmentResultViewController.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/5/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTAssessmentResultViewController.h"
#import "CWTAssessBaseInfoCell.h"
#import "CWTAssessPriceInfoCell.h"
#import "AskPriceView.h"
#import "AssessSuccessAlertView.h"

@interface CWTAssessmentResultViewController ()

@property(nonatomic,strong) AskPriceView *askPriceView;
@property(nonatomic,strong) CWTAssessResult *result;

@end

@implementation CWTAssessmentResultViewController{
    NSInteger sectionCount;
}

- (id)initWithObject:(CWTAssessResult *)result{
    if (self = [super init]) {
        self.result = result;
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self bindViewModel];
}

- (void)setupView{
    self.navigationItem.title = @"估值结果";
    [self.baseTableView registerClass:[CWTAssessBaseInfoCell class] forCellReuseIdentifier:kCellIdentifierAssessBaseInfo];
    [self.baseTableView registerClass:[CWTAssessPriceInfoCell class] forCellReuseIdentifier:kCellIdentifierAssessPriceInfo];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)setupBottomView{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.15];
    [self.view insertSubview:line aboveSubview:self.baseTableView];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
        make.height.equalTo(@0.5);
    }];
    
    UIButton *saleCarButton = [[UIButton alloc] init];
    saleCarButton.backgroundColor = [UIColor whiteColor];
    [saleCarButton setTitle:@"我要卖车" forState:UIControlStateNormal];
    [saleCarButton setTitleColor:themeColor forState:UIControlStateNormal];
    saleCarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view insertSubview:saleCarButton aboveSubview:self.baseTableView];
    [saleCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.equalTo(@49);
    }];
    [[saleCarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [self bugOrSaleCar:1];
    }];
    
    
    UIButton *buyCarButton = [[UIButton alloc] init];
    buyCarButton.backgroundColor = themeColor;
    [buyCarButton setTitle:@"我要买车" forState:UIControlStateNormal];
    [buyCarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyCarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view insertSubview:buyCarButton aboveSubview:self.baseTableView];
    [buyCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.equalTo(@49);
    }];
    [[buyCarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [self bugOrSaleCar:0];
    }];

}

- (void)bindViewModel{
    sectionCount = 2;
    [self.baseTableView reloadData];
    
    
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CWTAssessBaseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierAssessBaseInfo];
        cell.result = self.result;
        return cell;
    }else{
        CWTAssessPriceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierAssessPriceInfo];
        cell.result = self.result;
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 74;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 74)];
        
        
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 54)];
        footerLabel.text = @"* 由于政策、市场和车况等因素的影响,价格会有所波动。\n\n* 根据实际车况,价格有差异,车商收购价会偏低,但成交速度更快";
        footerLabel.font = [UIFont systemFontOfSize:10];
        footerLabel.textColor = [UIColor colorWithHexString:@"777777"];
        footerLabel.numberOfLines = 0;
        [footerView addSubview:footerLabel];
        [footerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerView.mas_left).offset(12);
            make.top.equalTo(footerView.mas_top).offset(15);
            make.right.equalTo(footerView.mas_right).offset(-12);
        }];
        
        return footerView;
//        return @"* 由于政策、市场和车况等因素的影响,价格会有所波动。\n* 根据实际车况,价格有差异,车商收购价会偏低,但成交速度更快";
    }
    return nil;
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:kCellIdentifierAssessBaseInfo configuration:^(CWTAssessBaseInfoCell *cell) {
            cell.result = self.result;
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:kCellIdentifierAssessPriceInfo configuration:^(CWTAssessPriceInfoCell *cell) {
            cell.result = self.result;
        }];
    }
    
}


@end
