//
//  GGBanksViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBanksViewController.h"
#import "GGBankInfoCell.h"


@interface GGBanksViewController ()
@property(nonatomic,copy)NSArray *banks;

@property(nonatomic,strong)GGFormItem *item;


@end

@implementation GGBanksViewController

- (instancetype)initWithFormItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
    }
    return self;
    
}

- (void)setupView{
    self.navigationItem.title = @"开户行";
    
    [self.baseTableView registerClass:[GGBankInfoCell class] forCellReuseIdentifier:kCellIdentifierBankInfo];
    self.baseTableView.rowHeight = 48;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (void)bindViewModel{
    
    @weakify(self);
    [RACObserve(self, banks)subscribeNext:^(id x) {
        @strongify(self);
        [self.baseTableView reloadData];
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bankCode" ofType:@"json"];
    self.banks = [NSArray modelArrayWithClass:[GGBank class] json:[NSData dataWithContentsOfFile:path]];
}



#pragma mark TableM
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.banks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GGBankInfoCell *bankCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierBankInfo forIndexPath:indexPath];
    bankCell.bank = self.banks[indexPath.row];
    return bankCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGBank *bank = self.banks[indexPath.row];
    self.item.obj = bank;
    if (self.popHandler) {
        self.popHandler(self.item);
    }
    
    [self pop];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:64 hasSectionLine:kLeftPadding];
}


@end
