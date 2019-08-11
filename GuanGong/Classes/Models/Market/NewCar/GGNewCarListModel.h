//
//  GGNewCarListModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGNewCarWareStockModel.h"

@interface GGNewCarListModel : NSObject

@property(nonatomic,copy)NSString *carId;

@property(nonatomic,copy)NSString *carPhotoUrl;
@property(nonatomic,copy)NSString *price;

@property(nonatomic,copy)NSString *tagName;
@property(nonatomic,copy)NSString *colorRGB;

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *titleL;

@property(nonatomic,copy)NSString *provinceStr;
@property(nonatomic,copy)NSString *cityStr;

@property(nonatomic,assign)NSInteger logisticsType;//物流信息 1-自取 2-包物流

@property(nonatomic,strong)GGNewCarWareStockModel *wareStockResponse;



//
//@property(nonatomic,copy)NSString *updateTime;
//@property(nonatomic,copy)NSString *reservePrice;
//@property(nonatomic,assign)NSInteger status;
//@property(nonatomic,copy)NSString *statusName;
//@property(nonatomic,copy)NSString *vin;
//@property(nonatomic,strong)NSNumber *carId;

@end


//brandId = 62;
//carPhotoUrl = "http://testqimg.iautos.cn/source/carupload/photo/2017/0213/10/20170213104309211304.png-mudiumpic";
//cityId = 828;
//cityStr = "\U5317\U4eac";
//colorRGB = "#5B5B5B";
//createTime = "2017-02-13 10:47:30";
//emissionsId = "<null>";
//id = 7;
//modelSimpleId = "<null>";
//price = "30.00";
//provinceId = 1;
//provinceStr = "\U5317\U4eac";
//releaseTime = "<null>";
//reservePrice = "2000.00";
//saleStatus = 3;
//seriesId = 269;
//statusName = "<null>";
//tagName = "\U4ee5\U65e7\U6362\U65b0";
//title = "\U5965\U8feaA6L\U5168\U65b09\U6298\U62a2\U8d2d\Uff01";
//titleL = "\U5965\U8feaA6L-3.0-CVT/MT\U6807\U51c6\U578b(\U56fd\U2161)";
//titleM = "<null>";
//titleS = "<null>";
//updateTime = "2017-05-09 14:53:48";
//userId = 149;
//vin = "<null>";
//wareStockResponse =                 {
//    goodsId = 7;
//    goodsType = 8;
//    stock = 47;
//    wareId = 1;
//};
