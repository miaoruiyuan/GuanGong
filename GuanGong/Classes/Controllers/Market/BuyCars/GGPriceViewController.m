//
//  GGPriceViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPriceViewController.h"
#import "YZPullDownMenu.h"

@interface GGPriceViewController ()

@property(nonatomic,strong)NSArray *priceData;
@property(nonatomic,strong)NSArray *priceParameter;

@end

@implementation GGPriceViewController

- (void)bindViewModel{
//    _priceData = @[@{@"不限":@"不限"},@{@"3万以下":@"3"},@{@"3-5":@"不限"},@{@"不限":@"不限"},@{@"不限":@"不限"},@{@"不限":@"不限"},@{@"不限":@"不限"},@{@"不限":@"不限"},@{@"不限":@"不限"},@{@"不限":@"不限"},@{@"不限":@"不限"}];
    
    _priceData = @[@"不限",@"3万以下",@"3-5万",@"5-8万",@"8-10万",@"10-15万",@"15-20万",@"20-30万",@"30-50万",@"50万以上"];
    _priceParameter =  @[@[@"",@""],@[@0,@3],@[@3,@5],@[@5,@8],@[@8,@10],@[@10,@15],@[@15,@20],@[@20,@30],@[@30,@50],@[@50,@1000]];
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
    return _priceData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"priceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"000000"];
    }
    
    cell.textLabel.text = _priceData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:14 hasSectionLine:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = _priceParameter[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:GGCarsListParameterNotification
                                                        object:self
                                                      userInfo:@{@"priceMin":array[0],@"priceMax":array[1]}];

    NSString *menuTitle = _priceData[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":menuTitle}];
    
}

@end
