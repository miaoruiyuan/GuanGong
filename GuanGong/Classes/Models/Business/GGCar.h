//
//  GGCar.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGUser.h"
#import "GGAddressViewModel.h"

@interface GGCar : NSObject<NSCoding>

@property(nonatomic,copy)NSString *vin;
@property(nonatomic,strong)NSNumber *brandId;
@property(nonatomic,strong)NSNumber *seriesId;
@property(nonatomic,strong)NSNumber *modelId;
@property(nonatomic,strong)NSNumber *modelSimpleId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *firstRegDate;
@property(nonatomic,assign)NSInteger emissionsId;
@property(nonatomic,copy)NSString *km;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *reservePrice;
@property(nonatomic,copy)NSMutableDictionary *carPhotoDict;
@property(nonatomic,copy)NSString *remark;


@property(nonatomic,copy)NSString *carPhotoUrl;
@property(nonatomic,strong)NSNumber *carId;
@property(nonatomic,strong)NSNumber *xinCarId;


@property(nonatomic,strong)NSArray *photosList;
@property(nonatomic,strong)NSArray *mediumUrlList;

@property(nonatomic,copy)NSString *titleL;
@property(nonatomic,copy)NSString *titleM;
@property(nonatomic,copy)NSString *titleS;

@property(nonatomic,copy)NSString *cityStr;
@property(nonatomic,copy)NSString *provinceStr;

@property(nonatomic,copy)NSString *cityId;
@property(nonatomic,copy)NSString *provinceId;

@property(nonatomic,copy)NSString *updateTime;



@property(nonatomic,strong)GGUser *user;
@property(nonatomic,strong)GGAddress *address;


@property(nonatomic,copy)NSString *checkOrderId;

@property(nonatomic,assign)BOOL checkShowFlag;// ['0-私有' or ' 1-公开']: 质检报告展示标示,

@property(nonatomic,assign)BOOL hasApplyCheckOrder;//是否有质检报告,

@property(nonatomic,assign)BOOL hasCheckOrder;//是否申请过质检报告,

@property(nonatomic,assign)NSInteger status;
@property(nonatomic,copy)NSString *statusName;
@property(nonatomic,copy)NSString *auditDescription;

@property(nonatomic,assign)NSInteger carType; //['0-二手车 1-新车']: 车类型,


/**
 vin是否已使用
 */
@property(nonatomic,assign)BOOL vinUsed;

@end



 /*
 addressId = 19;
 auditUserId = 4;
 auditUserName = "\U8d85\U7ea7\U7ba1\U7406\U5458";
 brandId = 55;
 carPhotoUrl = "http://photo.csiautos.cn/carupload/photo/2016/1111/14/20161111142735054837.jpg";
 checkOrderId = "<null>";
 checkShowFlag = 0;
 cityId = 828;
 cityProperId = "<null>";
 cityStr = "\U5317\U4eac";
 color = "<null>";
 createTime = 1478845656000;
 dealPrice = "<null>";
 dealRemark = "<null>";
 dealTime = "<null>";
 drivingLicense = "<null>";
 emissionsId = 5;
 emissionsLocalId = "<null>";
 expiryDate = "<null>";
 expiryDays = "<null>";
 firstRegDate = "2014-06";
 fuelType = "<null>";
 id = 19;
 interiorId = "<null>";
 invoice = "<null>";
 isReg = "<null>";
 km = 123;
 licenseNumber = "<null>";
 mfrsId = "<null>";
 modelId = "<null>";
 modelSimpleId = 12076;
 operationType = "<null>";
 photosList =     (
 {
 remark = "<null>";
 serialNo = 1;
 url = "http://photo.csiautos.cn/carupload/photo/2016/1111/14/20161111142735054837.jpg";
 },
 {
 remark = "<null>";
 serialNo = 2;
 url = "http://photo.csiautos.cn/carupload/photo/2016/1111/14/20161111142735423823.jpg";
 },
 {
 remark = "<null>";
 serialNo = 3;
 url = "http://photo.csiautos.cn/carupload/photo/2016/1111/14/20161111142735344963.jpg";
 },
 {
 remark = "<null>";
 serialNo = 4;
 url = "http://photo.csiautos.cn/carupload/photo/2016/1111/14/20161111142735311387.jpg";
 }
 );
 price = 12;
 priceRemark = "<null>";
 provinceId = 1;
 provinceStr = "\U5317\U4eac";
 refreshTime = "<null>";
 registration = "<null>";
 releaseTime = "<null>";
 remark = Asddsadasdasdasdasdasd;
 reservePrice = 211;
 seriesId = 294;
 status = 5;
 title = "\U9014\U80dc2.0-GL-A/MT\U8212\U9002\U5929\U7a97\U578b\U524d\U9a71(\U56fd\U2163)";
 titleL = "<null>";
 titleM = "<null>";
 titleS = "<null>";
 transmissionTypeId = "<null>";
 updateTime = 1479025044000;
 userId = 144;
 vin = LBEJMBKB9BX272489;
 
 */


