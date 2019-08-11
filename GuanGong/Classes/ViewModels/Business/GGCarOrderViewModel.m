//
//  GGCarOrderViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCarOrderViewModel.h"

@interface GGCarOrderViewModel ()

@property(nonatomic,copy)NSString *dynamicCode;

@end

@implementation GGCarOrderViewModel

- (void)initialize{
    
    @weakify(self);
    
    self.loadData = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
  
        @strongify(self);

        NSNumber *page = self.willLoadMore ? [NSNumber numberWithInteger:self.pageIndex + 1] : @1;
        
        NSDictionary *staticDic = @{@"page":page,
                                    @"pageSize":@15,
                                    @"userType":self.isSeller ? @2 : @1};
        
        NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:staticDic];
        
        switch (self.orderListType) {
            case CarsOrderListTypeAll:
                
                break;
                
            case CarsOrderListTypeDFK:
                [requestDic setObject:@"1,2" forKey:@"status"];
                break;
                
            case CarsOrderListTypeDSH:
                [requestDic setObject:@"4" forKey:@"status"];
                break;
                
            case CarsOrderListTypeYWC:
                [requestDic setObject:@"5" forKey:@"status"];
                break;
                
            case CarsOrderListTypeTKZ:
                [requestDic setObject:@"7,8,9,10,11,12" forKey:@"status"];
                break;
                
            default:
                break;
        }
        
        return [[GGApiManager request_carsOrderListWithParameter:requestDic] map:^id(NSDictionary *value) {
            @strongify(self);

            if (!self.willLoadMore) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:[NSArray modelArrayWithClass:[GGCarOrderDetail class] json:value[@"result"]]];
            self.totalCount = value[@"totalRecord"];
            self.canLoadMore = self.dataSource.count < self.totalCount.integerValue;
            
            self.pageIndex = [value[@"pageNo"] integerValue];
            return [RACSignal empty];
        }];
    }];
    
    
    //订单详情
    _orderDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[GGApiManager request_carsOrderDetailWithOrderNo:self.orderDetail.orderNo] map:^id(NSDictionary *value) {
            @strongify(self);
            self.orderDetail = [GGCarOrderDetail modelWithDictionary:value];
            return [RACSignal empty];
        }];
    }];
    
    //确认收货
    _confirmGoodsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *password) {
        return [[[GGApiManager request_GetDynamicCode] map:^id(NSString *value) {
            @strongify(self);
            self.dynamicCode = value;
            return [RACSignal empty];
        }]then:^RACSignal *{
            @strongify(self);
            NSArray *array = @[self.orderDetail.orderNo,
                               [GGLogin shareUser].token,
                               self.dynamicCode,
                               password];
            
            NSString *payPassword = [[GGHttpSessionManager sharedClient].rsaSecurity
                                     rsaEncryptString:[array componentsJoinedByString:@""]];
            
            return [[GGApiManager request_BuyerConfirmGoodsWithParames:@{@"orderNo":self.orderDetail.orderNo,@"payPassword":payPassword}] map:^id(id value) {
                return [RACSignal empty];
            }];

            
        }];
    }];
    
    
    //卖家收到退货(收到买家的退货)
    _sellerConfirmGoodsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *password) {
        
        @strongify(self);
        
        NSArray *array = @[self.orderDetail.orderNo,[GGLogin shareUser].token,password];
       
        NSString *payPassword = [[GGHttpSessionManager sharedClient].rsaSecurity
                                 rsaEncryptString:[array componentsJoinedByString:@""]];
        
        NSDictionary *dic = @{@"orderNo":self.orderDetail.orderNo,
                              @"payPassword":payPassword};
        
        return [[GGApiManager request_SealerConfirmGoodsWithParames:dic] map:^id(id value) {
            return [RACSignal empty];
        }];
    }];

}

//#pragma mark - 拒绝退款
//- (RACCommand *)submitRefuseCommand{
//    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *orderNo) {
//        
//        NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:self.photos.count];;
//        for (GGImageItem *image in self.photos) {
//            [urlArray addObject:image.photoUrl];
//        }
//        
//        NSDictionary *parames;
//        
//        if (self.isAgree) {
//            NSString *payPassword = [@[orderNo,[GGLogin shareUser].token,_password]componentsJoinedByString:@""];
//            parames = @{@"orderNo":orderNo,
//                        @"isAgree":@(self.isAgree),
//                        @"payPassword":[[GGHttpSessionManager sharedClient].rsaSecurity rsaEncryptString:payPassword],
//                        @"pics":[urlArray componentsJoinedByString:@","]};
//            
//        }else{
//            parames = @{@"orderNo":orderNo,
//                        @"isAgree":@(self.isAgree),
//                        @"description":self.remark,
//                        @"pics":[urlArray componentsJoinedByString:@","]};
//        }
//        
//        
//        return [[GGApiManager request_RefusedRefundWithParames:parames]map:^id(id value) {
//            
//            return [RACSignal empty];
//        }];
//    }];
//    
//}
//
//


@end
