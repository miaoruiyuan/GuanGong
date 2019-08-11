//
//  CWTVinResultViewController.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/20.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTVinResultViewController.h"
#import "CWTVinResultCell.h"
#import "GGWebViewController.h"
#import "CWTVinEmissionViewController.h"
#import "CWTNetClient.h"

@interface CWTVinResultViewController ()

@property(nonatomic,strong)NSArray *vinArray;

@end

@implementation CWTVinResultViewController

- (void)setupView{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"匹配车型";
    self.emptyDataMessage  = @"无此VIN匹配车型";
    self.emptyDataDisplay = YES;
    
    [self.baseTableView registerClass:[CWTVinResultCell class] forCellReuseIdentifier:kCellIdentifierVinResultCell];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)bindViewModel{
    if ([self.value isKindOfClass:[NSArray class]]) {
        self.vinArray = self.value;
        [self.baseTableView reloadData];
    }
}

#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.vinArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CWTVinResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierVinResultCell];
    cell.vinResult = self.vinArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:kCellIdentifierVinResultCell
                                    cacheByIndexPath:indexPath
                                       configuration:^(CWTVinResultCell *cell) {
                                           cell.vinResult = self.vinArray[indexPath.section];
                                       }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CWTVinResult *vinResult = self.vinArray[indexPath.section];
    [self getVinInfoDetail:vinResult];
}

- (void)getVinInfoDetail:(CWTVinResult *)vinResult
{
    if (self.vinArray.count > 1) {
        vinResult.moreChoose = YES;
    }
    @weakify(self);
    [[self.vinInfoVM.buyVinInfoCommand execute:vinResult] subscribeError:^(NSError *error) {
        
    } completed:^{
        @strongify(self);
        if (self.popHandler) {
            self.popHandler(nil);
        }
        [self dismiss];
    }];
}

@end
