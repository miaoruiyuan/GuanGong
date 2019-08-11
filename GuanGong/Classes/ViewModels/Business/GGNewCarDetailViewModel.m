//
//  GGNewCarDetailViewModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGNewCarDetailViewModel.h"
#import "GGApiManager+Vin.h"

@implementation GGNewCarDetailViewModel

- (void)initialize
{
    //车辆详情
    @weakify(self);
    _carDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *carId) {
        NSDictionary *dic = @{@"id":carId};
        return [[GGApiManager request_GetNewCarDetailWithParameter:dic] map:^id(NSDictionary *value) {
            @strongify(self);
            self.carDetailModel = [GGNewCarDetailModel modelWithDictionary:value];
            
            NSInteger imageCount = self.carDetailModel.photosList.count;

            NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:imageCount];
            NSMutableArray *mediumUrlArray = [NSMutableArray arrayWithCapacity:imageCount];
            
            for (NSDictionary *imageDic in self.carDetailModel.photosList) {
                if ([imageDic objectForKey:@"url"]) {
                    NSString *url = [imageDic objectForKey:@"url"];
                    NSString *mediumUrl = [imageDic objectForKey:@"mediumUrl"];
                    [urlArray addObject:url];
                    [mediumUrlArray addObject:mediumUrl];
                }
            }
            
            self.carDetailModel.photosList = urlArray;
            self.carDetailModel.mediumUrlList = mediumUrlArray;
        
            return [RACSignal empty];
        }];
    }];
}

@end
