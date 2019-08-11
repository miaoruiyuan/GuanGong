//
//  GGLocationViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGLocationViewController.h"
#import "MultiTablesView.h"
#import "YZPullDownMenu.h"
#import "GGProvince.h"

@interface GGLocationViewController ()<MultiTablesViewDataSource,MultiTablesViewDelegate>{
    NSIndexPath *provinceIndex;
}

@property(nonatomic,strong)GGFormItem *item;

@property(nonatomic,strong)MultiTablesView *tableView;

@property(nonatomic,strong)NSMutableArray *proviceArray;
@property(nonatomic,strong)NSArray *cityArray;

@end

@implementation GGLocationViewController


- (instancetype)initWithItem:(GGFormItem *)item{
    if (self = [super init]) {
        self.item = item;
        _isCarsList = NO;
    }
    return self;
}


- (void)setupView{
    self.navigationItem.title = @"所在地";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initAreaData];
    
    _tableView = ({
        MultiTablesView *view = [[MultiTablesView alloc]init];
        view.delegate = self;
        view.dataSource = self;
        view.nextTableViewHorizontalGap = 100;
        [self.view addSubview:view];
        view;
    });
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark- 初始化地区数据
- (void)initAreaData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *path =  [[NSBundle mainBundle]pathForResource:@"Location" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        //根据json文件获取城市信息
        self.proviceArray = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[GGProvince class] json:data]];
        
        if (_isCarsList) {
            GGProvince *province = [[GGProvince alloc] init];
            province.areaName = @"全国";
            [self.proviceArray insertObject:province atIndex:0];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

#pragma mark - MultiTablesViewDataSource
#pragma mark Levels
- (NSInteger)numberOfLevelsInMultiTablesView:(MultiTablesView *)multiTablesView {
    return 2;
}
#pragma mark Sections
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView numberOfSectionsAtLevel:(NSInteger)level {
    return 1;
}

#pragma mark Rows
- (NSInteger)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level numberOfRowsInSection:(NSInteger)section {
    
    switch (level) {
        case 0:
            return self.proviceArray.count;
            break;
            
        default:
            return self.cityArray.count;
            break;
    }
    
}
- (UITableViewCell *)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (level == 0) {
        UITableViewCell *provinceCell = [multiTablesView dequeueReusableCellForLevel:level withIdentifier:@"province"];
        if (!provinceCell) {
            provinceCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"province"];
            provinceCell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        GGProvince *province = self.proviceArray[indexPath.row];
        provinceCell.textLabel.text = province.areaName;
        return provinceCell;
    }else{
        
        UITableViewCell *cityCell = [multiTablesView dequeueReusableCellForLevel:level withIdentifier:@"city"];
        if (!cityCell) {
            cityCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"city"];
            cityCell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
        GGCity *city = self.cityArray[indexPath.row];
        cityCell.textLabel.text = city.areaName;
        return cityCell;
    }
    
}

#pragma mark - MultiTablesViewDelegate

- (void)multiTablesView:(MultiTablesView *)multiTablesView levelDidChange:(NSInteger)level {

}


#pragma mark Rows
- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)multiTablesView:(MultiTablesView *)multiTablesView fixedTableHeaderViewAtLevel:(NSInteger)level{
    
    return nil;
}


- (void)multiTablesView:(MultiTablesView *)multiTablesView level:(NSInteger)level didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (level == 0) {
        provinceIndex = indexPath;
        self.cityArray = nil;
        GGProvince *province = self.proviceArray[indexPath.row];
    
        if (_isCarsList) {
            if (indexPath.row == 0) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:GGCarsListParameterNotification object:self userInfo:@{}];
                [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":province.areaName}];
                return;
            }
            multiTablesView.automaticPush = YES;
            if (province.cityList.count != 1) {
                static NSString *allCity = @"全部";
                GGCity *firstCity = province.cityList[0];
                if (![firstCity.areaName isEqualToString:allCity]) {
                    GGCity *city = [[GGCity alloc] init];
                    city.areaName = allCity;
                    [province.cityList insertObject:city atIndex:0];
                }
            }
        }
        self.cityArray = province.cityList;
    } else {
        GGProvince *province = self.proviceArray[provinceIndex.row];
        GGCity *city = province.cityList[indexPath.row];
        
        //车源筛选
        if (_isCarsList) {
            if (province.cityList.count != 1) {
                if (indexPath.row == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:GGCarsListParameterNotification
                                                                        object:self
                                                                      userInfo:@{@"provinceId":province.proId}];
                    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote
                                                                        object:self
                                                                      userInfo:@{@"title":province.areaName}];
                    return;
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:GGCarsListParameterNotification
                                                                object:self
                                                              userInfo:@{@"cityId":city.cityId}];
            [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote object:self userInfo:@{@"title":city.areaName}];
            return;
        }
        
    
        if (self.item.pageType == GGPageTypeCheckCarCity) {
            NSDictionary *value = @{@"carProvince":province.proId,@"carCity":city.cityId,@"city":city.areaName};
            self.item.obj = value;
            
        }else{
            NSString *area = [province.areaName isEqualToString:city.areaName] ? city.areaName : [NSString stringWithFormat:@"%@ %@",province.areaName,city.areaName];
            
            NSDictionary *value = @{@"provinceId":province.proId,
                                    @"cityId":city.cityId,
                                    @"location":area};
            self.item.obj = value;

        }
        
        if (self.popHandler) {
            self.popHandler(self.item);
        }
        [self pop];
    }
    
}

- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

@end
