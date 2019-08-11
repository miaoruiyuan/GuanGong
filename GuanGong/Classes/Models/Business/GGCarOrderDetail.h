//
//  GGCarOrderDetail.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGCar.h"

@class GGCarOrderRecords;

/**
 车辆订单状态

 - CarOrderStatusCJDD: 创建订单,买家:待支付订金 卖家:待支付订金
 - CarOrderStatusZFDJ: 支付订金,买家:待支付尾款 卖家:待支付尾款
 - CarOrderStatusZFWK: 支付尾款,买家:待发货 卖家:待发货
 - CarOrderStatusYFH:  已发货,买家:待确认收货 卖家:买家待确认收货
 - CarOrderStatusJYWC: 交易完成,买家:交易完成 卖家:交易完成
 - CarOrderStatusFKGMJ: 付款给卖家,买家:担保款项放款 卖家:收到担保款项
 - CarOrderStatusSQTK: 申请退款,买家:卖家处理中 卖家:买家申请退款
 - CarOrderStatusSQTH: 申请退货,买家:卖家处理中 卖家:买家申请退货
 - CarOrderStatusJJTK: 拒绝退款,买家:卖家拒绝退款 卖家:已拒绝退款
 - CarOrderStatusJJTH: 拒绝退货,买家:卖家拒绝退款 卖家:已拒绝退货
 - CarOrderStatusTYTK: 同意退款,买家:已退款 卖家:已退款
 - CarOrderStatusTYTH: 同意退货,买家:请退货 卖家:买家处理中
 - CarOrderStatusTKGMJ: 退款给买家-中间状态,买家:收到担保款项退款 卖家:担保款项退款
 - CarOrderStatusYTH: 已退货,买家:卖家待确认收货 卖家:待确认收货
 */
typedef NS_ENUM(NSInteger,CarOrderStatus) {
    CarOrderStatusCJDD = 1,
    CarOrderStatusZFDJ,
    CarOrderStatusZFWK,
    CarOrderStatusYFH,
    CarOrderStatusJYWC,
    CarOrderStatusFKGMJ,
    CarOrderStatusSQTK,
    CarOrderStatusSQTH,
    CarOrderStatusJJTK,
    CarOrderStatusJJTH,
    CarOrderStatusTYTK,
    CarOrderStatusTYTH,
    CarOrderStatusTKGMJ,
    CarOrderStatusYTH,
    CarOrderStatusDDGB
};

@interface GGCarOrderDetail : NSObject

@property(nonatomic,strong)GGCar *car;

@property(nonatomic,copy)NSString *createTimeStr;
@property(nonatomic,copy)NSString *dealPrice;
@property(nonatomic,copy)NSString *finalPrice;
@property(nonatomic,copy)NSString *reservePrice;

//买家
@property(nonatomic,strong)NSNumber *buyerId;
@property(nonatomic,copy)NSString *buyerName;
@property(nonatomic,copy)NSString *buyerIcon;

//卖家
@property(nonatomic,copy)NSString *saleIcon;
@property(nonatomic,copy)NSString *saleName;
@property(nonatomic,strong)NSNumber *saleId;
//订单状态
@property(nonatomic,assign)CarOrderStatus status;
//订单状态名字
@property(nonatomic,copy)NSString *statusName;


@property(nonatomic,assign)NSInteger carQuantity;

@property(nonatomic,assign)BOOL hasApplyReturn;
@property(nonatomic,assign)BOOL hasPayAnother;
@property(nonatomic,assign)BOOL hasReward;

@property(nonatomic,strong)NSNumber *carOrderId;
@property(nonatomic,strong)NSNumber *logisticsOrderId;
@property(nonatomic,assign)NSInteger logisticsType;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *payAnotherId;
@property(nonatomic,assign)BOOL payOver;
//支付记录
@property(nonatomic,strong)NSArray *payOrderRecords;
//退款记录
@property(nonatomic,strong)NSArray *backOrderRecords;


@property(nonatomic,strong)NSString *reservePriceDate;
@property(nonatomic,strong)NSString *finalPriceDate;
@property(nonatomic,strong)NSString *tranEndDate;

@property(nonatomic,assign)NSInteger xinCarGuaranteeDaysCountDown;

@property(nonatomic,assign)NSInteger carAutoSureReceiveCountDown;


@end


@interface GGCarOrderRecords : NSObject

@property(nonatomic,copy)NSString *createTimeStr;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,strong)NSNumber *payResult;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *statusName;
@property(nonatomic,copy)NSString *subOrderNo;
@property(nonatomic,strong)NSNumber *operType;
@property(nonatomic,assign)CarOrderStatus status;
@property(nonatomic,strong)NSNumber *recordId;
@property(nonatomic,copy)NSString *remark;//description


@end


/*
 {
 car =     {
 address = "<null>";
 auditUserId = 4;
 auditUserName = "\U8d85\U7ea7\U7ba1\U7406\U5458";
 brandId = 47;
 carPhotoUrl = "http://testqimg.iautos.cn/source/carupload/photo/2016/1124/17/20161124170616539797.jpg-gg.carinfo.mudiumpic";
 checkOrderId = 95;
 checkOrderUrl = "<null>";
 checkShowFlag = 0;
 cityId = 264;
 cityProperId = "<null>";
 cityStr = "\U5eca\U574a";
 color = "<null>";
 createTime = "2016-11-24 17:06:30";
 dealPrice = "0.00";
 dealRemark = "<null>";
 dealTime = "<null>";
 drivingLicense = "<null>";
 emissionsId = 5;
 emissionsLocalId = "<null>";
 expiryDate = "<null>";
 expiryDays = "<null>";
 firstRegDate = "2012-11";
 fuelType = 11;
 hasApplyCheckOrder = 1;
 hasCheckOrder = "<null>";
 id = 65;
 interiorId = "<null>";
 invoice = "<null>";
 isReg = "<null>";
 km = "3.00";
 licenseNumber = "<null>";
 mfrsId = 133;
 modelId = 97888;
 modelSimpleId = 60272;
 operationType = "<null>";
 photosList =         (
 );
 price = "350000.00";
 priceRemark = "<null>";
 provinceId = 5;
 provinceStr = "\U6cb3\U5317";
 refreshTime = "<null>";
 registration = "<null>";
 releaseTime = "<null>";
 remark = "\U8f66\U8f86\U597d\U554a";
 reservePrice = "5000.00";
 seriesId = 532;
 status = 5;
 statusName = "\U5728\U552e";
 title = "\U5954\U9a70E\U7ea7 1.8T \U624b\U81ea\U4e00\U4f53 E260\U4f18\U96c5\U578b";
 titleL = "\U5954\U9a70E\U7ea7 E260 1.8T \U81ea\U52a8 \U4f18\U96c5\U578b 2010\U6b3e (\U56fd\U2163)";
 titleM = "\U5954\U9a70E\U7ea7 E260 1.8T \U81ea\U52a8 \U4f18\U96c5\U578b";
 titleS = "\U5954\U9a70E\U7ea7 E260 \U4f18\U96c5\U578b";
 transmissionTypeId = 12;
 updateTime = "2016-11-24 17:06:53";
 user =         {
 auditingDescription = "";
 auditingTime = 1479975779000;
 auditingType = 1;
 cityId = 264;
 companyName = "\U7231\U8f66\U79d1\U6280\U8f66\U7f51";
 email = "<null>";
 headPic = "http://photo.csiautos.cn/carupload/photo/2016/1123/16/20161123163533478652.jpg";
 id = 159;
 isdel = 0;
 location = "<null>";
 mobile = 18101356408;
 provinceId = 5;
 qrCodeUri = "https://gg.iautos.cn:16343/finance-gg/ggApi/user/getQrcode?params=22BDE86B2FC848876A702E1244C74E9D";
 realName = "\U674e\U73cd";
 status = 1;
 updateTime = 1480043555000;
 userName = "\U674e\U73cd";
 zipCode = "\U6cb3\U5317 \U5eca\U574a";
 };
 vin = LE4GG8BB0EL285869;
 };
 createTime = 1480402229833;
 createTimeStr = "2016-11-29 14:50:29";
 dealPrice = 350000;
 description = "<null>";
 finalPrice = 345000;
 hasApplyReturn = 0;
 hasPayAnother = 0;
 hasReward = 0;
 id = 16;
 logisticsOrderId = "<null>";
 logisticsType = 1;
 orderNo = 1611290148689024;
 payAnotherId = "<null>";
 payOver = 0;
 reservePrice = 5000;
 saleIcon = "http://photo.csiautos.cn/carupload/photo/2016/1123/16/20161123163533478652.jpg";
 saleId = 159;
 saleName = "\U674e\U73cd";
 status = 1;
 statusName = "<null>";
 updateTime = 1480402229833;
 updateTimeStr = "2016-11-29 14:50:29";
 }

 */
