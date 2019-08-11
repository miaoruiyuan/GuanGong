//
//  GGCheckCardIDViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCheckCardIDViewModel.h"
#import "GGFormItem.h"

@interface GGCheckCardIDViewModel()
{

}

@end

@implementation GGCheckCardIDViewModel

- (void)initialize
{
    [self initDataSource];
}

- (void)initDataSource
{
    NSMutableArray *totalArray = [NSMutableArray array];

    GGFormItem *item0 = [[GGFormItem alloc] init];
    item0.title = @"真实姓名";
    item0.obj = [GGLogin shareUser].user.realName;
    item0.cellType = GGFormCellTypeNormal;
    
    GGFormItem *item1 = [[GGFormItem alloc] init];
    item1.title = @"身份证号";
    item1.cellType = GGFormCellTypeTitleAndTextField;
    
    [totalArray addObject:@[item0,item1]];
    
    self.dataSource = totalArray;
}

- (RACCommand *)submitCardInfoCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *value) {
        @strongify(self);
        return [GGApiManager request_CheckCardIDWithParameter:@{@"identification":self.cardID}];
    }];
}


- (RACSignal *)submitBtnEnableSinal
{
    return [RACSignal combineLatest:@[RACObserve(self, cardID)]
                            reduce:^id(NSString *value){
                                return @(value.length == 18);
                            }];

}
@end
