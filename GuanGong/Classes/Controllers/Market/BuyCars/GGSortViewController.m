//
//  GGSortViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGSortViewController.h"
#import "YZPullDownMenu.h"

@interface GGSortViewController ()

@property(nonatomic,strong)NSArray *sortData;
@property(nonatomic,strong)NSArray *sortParameter;

@end

@implementation GGSortViewController

- (void)bindViewModel{
    _sortData = @[@"默认",@"最新发布",@"价格最低",@"价格最高",@"里程最少",@"车龄最短"];
    _sortParameter = @[@0,@1,@2,@3,@4,@6];
    
    [self.baseTableView reloadData];
}

- (void)setupView{
    self.style = UITableViewStylePlain;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sortData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"sortCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"000000"];
    }
    
    cell.textLabel.text = _sortData[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:14 hasSectionLine:NO];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GGCarsListParameterNotification
                                                        object:self
                                                      userInfo:@{@"sort":_sortParameter[indexPath.row]}];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":_sortData[indexPath.row]}];
    
}



@end
