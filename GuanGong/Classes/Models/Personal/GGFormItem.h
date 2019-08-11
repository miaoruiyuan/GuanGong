//
//  GGFormItem.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGPersonalInput.h"

typedef NS_ENUM(NSUInteger,GGFormCellType) {
    GGFormCellTypeFaceView = 0,
    GGFormCellTypeNormal = 1,
    GGFormCellTypeIDCardPhoto = 2,
    GGFormCellTypeOnlyTextField = 4,
    GGFormCellTypeIdentifyingCode = 5,
    GGFormCellTypeQrCode = 6,
    GGFormCellTypeTextView = 7,
    GGFormCellTypeCollection = 8,
    GGFormCellTypeCarLocation = 9,
    GGFormCellTypeTitleAndTextField = 10,
    GGFormCellTypeTextFieldAndButton = 11,
    GGFormCellTypeShowPicker = 12,
    GGFormCellTypeCarModelName = 13
};

typedef NS_ENUM(NSUInteger,GGPageType) {
    //输入
    GGPageTypeInput = 0,
    //地区
    GGPageTypeCityList = 1,
    //实名认证
    GGPageTypeRealNameAuth = 2,
    //相册/相机
    GGPageTypeImagePicker = 3,
    //银行卡类型列表
    GGPageTypeBanksList = 4,
    //二维码
    GGPageTypeUserQrCode = 5,
    //开户行地区列表
//    GGPageTypeBanksArea = 6,
    //开户行地址
    GGPageTypeBanksAddress = 7,
    //车型
    GGPageTypeCarModel = 8,
    //质检地区
    GGPageTypeCheckCarCity = 9,
    //日期选择
    GGPageTypePickerDate = 10,
    //我的地址
    GGPageTypeManagerAddress = 11,
    //Vin识别
    GGPageTypeVinRecognition = 12,
    //公司认证
    GGPageTypeRealCompanyAuth = 13,
    //收货地址管理
    GGPageTypeAddressManager = 14,
    //更改用户手机号
    GGPageTypeChangePhone = 15
};


@interface GGFormItem : NSObject

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *propertyName;
@property(nonatomic,copy)NSString *showText;

/**
 *  value
 */
@property(nonatomic,strong)id obj;

/**
 *  cellType
 */
@property(nonatomic,assign)GGFormCellType cellType;
/**
 *  二级页Type
 */
@property(nonatomic,assign)GGPageType pageType;
/**
 *  是否可以编辑
 */
@property(nonatomic,assign)BOOL canEdit;
/**
 *  二级页数据
 */
@property(nonatomic,strong)id pageContent;

/**
 *  是否是picker
 */
-(BOOL)isPicker;


@end







