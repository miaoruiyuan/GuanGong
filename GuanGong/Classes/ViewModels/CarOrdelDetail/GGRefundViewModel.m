//
//  GGRefundViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRefundViewModel.h"

@interface GGRefundViewModel ()

@property(nonatomic,strong)NSMutableArray *ids;

@property(nonatomic,copy)NSString *priceFooterTip;

@end

@implementation GGRefundViewModel


- (NSArray *)photos{
    if (!_photos) {
        _photos = [[NSArray alloc]init];
    }
    return _photos;
}


- (void)initialize{
    self.returnType = @9; //默认仅退款
    
    @weakify(self);
    _enableSubmit = [RACSignal combineLatest:@[RACObserve(self, returnPrice),
                                               RACObserve(self, returnFinalPrice),
                                               RACObserve(self, refundRemark),
                                               RACObserve(self, returnType)] reduce:^(NSString *rPrice,NSString *fPrice,NSString *remark,NSNumber *type){
                                                   @strongify(self);
                                                   return @(rPrice.floatValue <= self.allowReturnPrice.floatValue && fPrice.floatValue <= self.allowReturnFinalPrice.floatValue && remark.length > 0 && type);
                                               }];
    
    [RACObserve(self,orderDetail)subscribeNext:^(GGOrderDetails *x) {
        @strongify(self);
        if (x.transOrderRecords.count > 0) {
            self.ids = [NSMutableArray arrayWithCapacity:x.transOrderRecords.count];
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:x.transOrderRecords.count];
            for (GGOrderRecords *record in x.transOrderRecords) {
                [self.ids addObject:record.recordId];
                
                if (record.statusId == OrderStatusTypeFDJ || record.statusId == OrderStatusTypeQKZF ) {
                    self.allowReturnPrice = record.price;
                }
                
                if (record.statusId == OrderStatusTypeFWK) {
                    self.allowReturnFinalPrice = record.price;
                }
                
                NSString *tipStr = [NSString stringWithFormat:@"%@可退%@元",record.statusName,record.price];
                [mArray addObject:tipStr];
            }
            

            NSString *str = [mArray componentsJoinedByString:@" "];
            self.footerTips = @[@"选择退款类型",str,@"填写退款原因",@"上传退款凭证"];
        }else{
            self.ids = [NSMutableArray arrayWithCapacity:x.orderRecords.count];
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:x.orderRecords.count];
            for (GGOrderRecords *record in x.orderRecords) {
                [self.ids addObject:record.recordId];
                
                if (record.statusId == OrderStatusTypeFDJ || record.statusId == OrderStatusTypeQKZF ) {
                    self.allowReturnPrice = record.price;
                }
                
                if (record.statusId == OrderStatusTypeFWK) {
                    self.allowReturnFinalPrice = record.price;
                }
                
                NSString *tipStr = [NSString stringWithFormat:@"%@可退%@元",record.statusName,record.price];
                [mArray addObject:tipStr];
            }
            
            NSString *str = [mArray componentsJoinedByString:@" "];
            self.footerTips = @[@"选择退款类型",str,@"填写退款原因",@"上传退款凭证"];
        }
        
    }];
    
    
    [RACObserve(self, carOrderDetail)subscribeNext:^(GGCarOrderDetail *x) {
        @strongify(self);
        if (x.payOrderRecords.count > 0) {
            self.ids = [NSMutableArray arrayWithCapacity:x.payOrderRecords.count];
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:x.payOrderRecords.count];
            for (GGCarOrderRecords *record in x.payOrderRecords) {
                [self.ids addObject:record.recordId];
                
                //车辆订单
                if (record.status == CarOrderStatusZFDJ) {
                    self.allowReturnPrice = record.price;
                }
                if (record.status == CarOrderStatusZFWK) {
                    self.allowReturnFinalPrice = record.price;
                }
                
                
                NSString *tipStr = [NSString stringWithFormat:@"%@可退%@元",record.statusName,record.price];
                [mArray addObject:tipStr];
            }
            
            
            NSString *str = [mArray componentsJoinedByString:@" "];
            self.footerTips = @[@"选择退款类型",str,@"上传退款凭证",@"填写退款原因"];
        }else{
            self.ids = [NSMutableArray arrayWithCapacity:x.backOrderRecords.count];
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:x.backOrderRecords.count];
            for (GGCarOrderRecords *record in x.backOrderRecords) {
                [self.ids addObject:record.recordId];
                
                //车辆订单
                if (record.status == CarOrderStatusZFDJ) {
                    self.allowReturnPrice = record.price;
                }
                if (record.status == CarOrderStatusZFWK) {
                    self.allowReturnFinalPrice = record.price;
                }

                NSString *tipStr = [NSString stringWithFormat:@"%@可退%@元",record.statusName,record.price];
                [mArray addObject:tipStr];
            }
            
            NSString *str = [mArray componentsJoinedByString:@" "];
            self.footerTips = @[@"选择退款类型",str,@"上传退款凭证",@"填写退款原因"];
        }

    }];
    
}

#pragma mark - 申请退货
- (RACCommand *)submitCommand{
    
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:self.photos.count];;
        for (GGImageItem *image in self.photos) {
            [urlArray addObject:image.photoUrl];
        }
        
        NSDictionary *dic = @{@"orderNo":self.orderDetail ? self.orderDetail.orderNo : self.carOrderDetail.orderNo,
                              @"description":self.refundRemark,
                              @"returnType":self.returnType,
                              @"applyReturnPics":[urlArray componentsJoinedByString:@","]};

        
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        for (int i = 0 ; i < self.ids.count; i ++) {
            [mDic setObject:self.ids[i] forKey:[NSString stringWithFormat:@"records[%d].id",i]];
            [mDic setObject:@"0" forKey:[NSString stringWithFormat:@"records[%d].tranAmount",i]];
            if (i == 0 && self.returnPrice.floatValue > 0) {
                [mDic setObject:self.returnPrice forKey:[NSString stringWithFormat:@"records[%d].tranAmount",i]];
            }
            if (i == 1 && self.returnFinalPrice.floatValue > 0) {
                [mDic setObject:self.returnFinalPrice forKey:[NSString stringWithFormat:@"records[%d].tranAmount",i]];
            }
        }
        
        return [[GGApiManager request_ApplicationForRefundWithParames:mDic] map:^id(id value) {
            
            return [RACSignal empty];
        }];
    }];
    
    
}

#pragma mark - 修改申请退货
- (RACCommand *)reviseCommand{
    
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *orderNo) {
        @strongify(self);
        NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:self.photos.count];;
        for (GGImageItem *image in self.photos) {
            [urlArray addObject:image.photoUrl];
        }
    
        NSDictionary *dic = @{@"orderNo":self.orderDetail.orderNo,
                              @"description":self.refundRemark,
                              @"returnType":self.returnType,
                              @"applyReturnPics":[urlArray componentsJoinedByString:@","]};
        
        
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        for (int i = 0 ; i < self.ids.count; i ++) {
            [mDic setObject:self.ids[i] forKey:[NSString stringWithFormat:@"records[%d].id",i]];
            [mDic setObject:@"0" forKey:[NSString stringWithFormat:@"records[%d].tranAmount",i]];
            if (i == 0 && self.returnPrice.floatValue > 0) {
                [mDic setObject:self.returnPrice forKey:[NSString stringWithFormat:@"records[%d].tranAmount",i]];
            }
            if (i == 1 && self.returnFinalPrice.floatValue > 0) {
                [mDic setObject:self.returnFinalPrice forKey:[NSString stringWithFormat:@"records[%d].tranAmount",i]];
            }
        }

        return [[GGApiManager request_ReviseRefundWithParames:mDic]map:^id(id value) {
            
            return [RACSignal empty];
        }];
    }];

}


@end
