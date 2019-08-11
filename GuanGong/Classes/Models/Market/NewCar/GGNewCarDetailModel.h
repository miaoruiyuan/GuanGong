//
//  GGNewCarDetailModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGUser.h"
#import "GGNewCarWareStockModel.h"

@interface GGNewCarDetailModel : NSObject

@property(nonatomic,copy)NSString *carId;

@property(nonatomic,copy)NSString *carPhotoUrl;

@property(nonatomic,copy)NSString *tagName;

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *titleS;
@property(nonatomic,copy)NSString *titleL;

@property(nonatomic,copy)NSString *provinceStr;
@property(nonatomic,copy)NSString *cityStr;

@property(nonatomic,strong)NSArray *photosList;//大图
@property(nonatomic,strong)NSArray *mediumUrlList;//中图

@property(nonatomic,copy)NSString *colorName;

@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *reservePrice;
@property(nonatomic,copy)NSString *finalPrice;
@property(nonatomic,copy)NSString *dealPrice;


@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *remark;


@property(nonatomic,copy)NSString *contactsName;
@property(nonatomic,copy)NSString *contactsPhone;
@property(nonatomic,copy)NSString *contactsAdds;

@property(nonatomic,strong)NSArray *serviceTags;

@property(nonatomic,assign)NSInteger logisticsType;//物流信息 1-自取 2-包物流
@property(nonatomic,assign)NSInteger minQuantity;//最低购买数量

@property(nonatomic,assign)NSInteger status;//0审核中 1 审核未过 2 审核通过 3 在售 4 下架
@property(nonatomic,assign)NSInteger guaranteeTimes;

@property(nonatomic,assign)NSInteger isCreateOrder;//['0-不可下单 1-允许下单']: 是否允许下单
@property(nonatomic,copy)NSString *unCreateOrderRemark;

//@property(nonatomic,copy)NSString *statusName;

@property(nonatomic,strong)GGUser *user;
@property(nonatomic,strong)GGNewCarWareStockModel *wareStockResponse;

@end
