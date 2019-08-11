//
//  GGTransferAccountViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGViewModel.h"
#import "GGTrade.h"
#import "GGAccount.h"

typedef NS_ENUM(NSInteger,PaymentType) {
    PaymentTypeFDJ = 2, //付定金
    PaymentTypeFWK = 5,  //付尾款
    PaymentTypeFQK = 18, //付全款
    PaymentTypeZZ = 12, //转账
    PaymentTypeDS = 40 //打赏
};

typedef NS_ENUM(NSInteger,GoodsType) {
    GoodsTypeCar = 1,
    GoodsTypeSafePay = 2,
    GoodsTypeCheckCar = 4,
    GoodsTypeCarHistory = 10,
    GoodsTypeVinInfo = 11,
};

@interface GGTransferAccountViewModel : GGViewModel

@property(nonatomic,strong)GGTrade *trade;

@property(nonatomic,strong)GGAccount *account;

/** 判断是不是转账 */
@property(nonatomic,assign)BOOL isTransfer;

/** 判断是不是要付尾款 */
@property(nonatomic,assign)BOOL isFinalPay;

/** 是否代付 */
@property(nonatomic,assign)BOOL isOtherPay;

/**商品类型 */
@property(nonatomic,assign)GoodsType goodsType;

/**支付类型*/
@property(nonatomic,assign)PaymentType payType;

@property(nonatomic,strong,readonly)RACSignal *enabelSureSignal;

@property(nonatomic,strong,readonly)RACCommand *transferCommand;

@end
