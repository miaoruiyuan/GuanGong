//
//  GGModelListViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGModelListViewController.h"
#import "GGCarModelCell.h"

@interface GGModelListViewController ()
@property(nonatomic,strong)GGFormItem *item;
@property(nonatomic,strong)NSArray *data;
@end

@implementation GGModelListViewController

-(instancetype)initWithItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
        
    }
    return self;
}

- (void)bindViewModel{
    self.data = self.item.pageContent;
    [RACObserve(self, data)subscribeNext:^(id x) {
        [self.baseTableView reloadData];
    }];

}

- (void)setupView{
    self.navigationItem.title = @"车型选择";
    self.style = UITableViewStylePlain;
    [self.baseTableView registerClass:[GGCarModelCell class] forCellReuseIdentifier:kCellIdentifierCreateCarModel];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - TB
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGCarModelCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCreateCarModel];
    cell.model = self.data[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0 hasSectionLine:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:kCellIdentifierCreateCarModel cacheByIndexPath:indexPath configuration:^(GGCarModelCell *cell) {
         cell.model = self.data[indexPath.row];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGModelList *model = self.data[indexPath.row];
    self.item.obj = [@{@"title":model.full_name,
                      @"modelSimpleId":model.modelId,
                      @"brandId":model.brand_id,
                      @"purchaseYear":model.version_year,
                      @"seriesId":model.series_id} mutableCopy];
    
    if (self.popHandler) {
        self.popHandler(self.item);
    }
    
    [self dismiss];
}



- (NSString *)customNameWithModel:(GGModelList *)model{
    
    NSString *modelName = nil;
    
    if (model.emissions_name) {
         modelName = [NSString stringWithFormat:@"%@%@ %@%@%@(%@)",model.displacement,model.is_turbo ? @"T":@"L",model.transmission_type_name,model.sub_name,model.model_name,model.emissions_name];
    }else{
         modelName = [NSString stringWithFormat:@"%@%@ %@%@%@",model.displacement,model.is_turbo ? @"T":@"L",model.transmission_type_name,model.sub_name,model.model_name];
    }
   
    return modelName;
}







@end
