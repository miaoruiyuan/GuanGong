//
//  GGAddAddressViewModel.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGTableViewModel.h"

@class GGAddress;

@interface GGAddressViewModel : GGTableViewModel

@property(nonatomic,strong)GGAddress *address;

@property(nonatomic,strong)NSMutableArray *addressList;

@property(nonatomic,strong)RACCommand *defultAdressCommand;

@property(nonatomic,strong)RACCommand *deleteCommand;

@property(nonatomic,strong)GGAddress *defaultSelectedAddress;

@end

@interface GGAddress : NSObject<NSCoding>

@property(nonatomic,copy)NSString *contactName;
@property(nonatomic,copy)NSString *contactTel;
@property(nonatomic,copy)NSString *location;
@property(nonatomic,strong)NSNumber *provinceId;
@property(nonatomic,copy)NSString *provinceStr;
@property(nonatomic,strong)NSNumber *cityId;
@property(nonatomic,copy)NSString *cityStr;
@property(nonatomic,copy)NSString *contactAddress;

@property(nonatomic,strong)NSNumber *addressId;

@property(nonatomic,assign)BOOL isDefault;
@property(nonatomic,assign)BOOL isListSelected;

@end

/*
 {
 cityId = 269;
 cityStr = "<null>";
 contactAddress = Qweqweqwedsadasdasdsad;
 contactName = ddddd;
 contactTel = 13333500022;
 contactZip = "<null>";
 createTime = 1477881708000;
 createTimeStr = "2016-10-31 10:41:48";
 id = 11;
 isDefault = 0;
 latitude = "<null>";
 longitude = "<null>";
 provinceId = 5;
 provinceStr = "<null>";
 updateTime = 1477881708000;
 updateTimeStr = "2016-10-31 10:41:48";
 },
 {
 */
