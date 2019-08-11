//
//  GGVehicleList.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGVehicleList : NSObject

@property(nonatomic,copy)NSString *carPhotoUrl;
@property(nonatomic,copy)NSString *km;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *firstRegDate;
@property(nonatomic,copy)NSString *auditUserId;
@property(nonatomic,copy)NSString *auditUserName;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *reservePrice;
@property(nonatomic,copy)NSString *cityStr;

@property(nonatomic,copy)NSString *titleM;

@property(nonatomic,assign)NSInteger status;
@property(nonatomic,copy)NSString *statusName;

@property(nonatomic,copy)NSString *vin;
@property(nonatomic,strong)NSNumber *carId;

@end







/*
 {
 auditUserId = "<null>";
 auditUserName = "<null>";
 brandId = 62;
 carPhotoUrl = "http://photo.csiautos.cn/carupload/photo/2016/1113/13/20161113133016968842.jpg";
 cityId = 828;
 cityStr = "\U5317\U4eac";
 createTime = "2016-11-13 13:30:19";
 emissionsId = 5;
 firstRegDate = "<null>";
 id = 23;
 km = 12;
 modelSimpleId = 91172;
 price = 124234234234234;
 provinceId = 1;
 provinceStr = "\U5317\U4eac";
 releaseTime = "<null>";
 reservePrice = 12321312;
 seriesId = 621;
 status = 2;
 title = "\U5965\U8feaA4L-2.0T-CVT/MT-TFSI\U8fd0\U52a8\U578b(\U56fd\U2163)";
 updateTime = "2016-11-13 13:30:19";
 userId = 144;
 vin = JTEGS54M18A005003;
 },

 */
