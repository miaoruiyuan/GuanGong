//
//  GGApiManager.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/2.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGHttpSessionManager.h"
#import "GGIautosSessionManager.h"

#import "GGLogin.h"
#import "GGAccount.h"
#import "GGTrade.h"
#import "GGBindCard.h"
#import "GGDrawCash.h"


@interface GGApiManager : NSObject

+ (instancetype)sharedManager;


#pragma mark - 用户信息 登录注册
/**
 *  发送验证码短信
 *
 *  @param params params description
 *  @param block  block description
 */
+ (RACSignal *)request_IdentifyingCode_WithMobliePhone:(NSString *)mobile;


+ (RACSignal *)request_ChangePhoneSendSMS:(NSDictionary *)requestDic;

+ (RACSignal *)request_ChangePhoneVerify:(NSDictionary *)requestDic;

+ (RACSignal *)request_NewPhoneSendSMS:(NSDictionary *)requestDic;

+ (RACSignal *)request_NewPhoneVerify:(NSDictionary *)requestDic;

/**
 *  注册
 *
 *  @param obj   obj description
 *  @param block block description
 */
+ (RACSignal *)request_Register_WithParames:(NSDictionary *)parames;
/**
 *  登录
 *
 *  @param obj   obj description
 *  @param block block description
 */
+ (RACSignal *)request_Login_WithParames:(NSDictionary *)parames;
/**
 *  补全用户信息
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_EditUserInfoWithParames:(NSDictionary *)parames;
/**
 *  实名认证
 *
 *  @param obj   obj description
 *  @param block block description
 */
+ (RACSignal *)request_CompleteInfomationWithParames:(NSDictionary *)parames;
/**
 *  企业认证
 *
 *  @param obj   obj description
 *  @param block block description
 */
+ (RACSignal *)request_ApplyCompanyWithParames:(NSDictionary *)parames;

/**
 *  修改用户密码
 *
 *  @param nPassword nPassword description
 *  @param block     block description
 */
+ (RACSignal *)request_RevisePassword_WithResetPassword:(NSString *)resetPass oldPassword:(NSString *)oldPass;
/**
 *  找回密码
 *
 *  @param resetPass 新密码
 *  @param vCode     手机验证码
 *
 *  @return return value description
 */
+ (RACSignal *)request_FindPassword_WithParames:(NSDictionary *)parames;

#pragma mark - 用户支付转账

/**
 *  判断是否是否设置了支付密码
 *
 *  @return return value description
 */
+ (RACSignal *)request_hasSetPayPassword;

/**
 *  设置支付密码
 *
 *  @param nPassword 支付密码
 *  @param icode     手机收到的验证码
 *  @param block     block description
 */
+ (RACSignal *)request_ResetPayPassword_WithPayPassword:(NSString *)password andIdentifyCode:(NSString *)icode;

/**
 *  修改支付密码
 *
 *  @param nPassword nPassword description
 *  @param block     block description
 */
+ (RACSignal *)request_RevisePaymentPassword_WithResetPassword:(NSString *)resetPass oldPassword:(NSString *)oldPass;
/**
 *  转账 获取账户信息
 *
 *  @param mobile 根据转账
 *  @param block  block description
 */
+ (RACSignal *)request_SearchUserInfo_WithMobile:(NSString *)mobile;
/**
 *  支付前先获取动态码
 *
 *  @param block block description
 */
+ (RACSignal *)request_GetDynamicCode;

/**
 *  转账
 *
 *  @param amount
 *  @param block
 */
+ (RACSignal *)request_TransferAccountsWithParames:(NSDictionary *)parames;

/**
 *  获取绑定的银行卡列表
 *
 *  @param block block description
 */
+ (RACSignal *)request_MineBankLists;
/**
 *  解绑银行卡
 *
 *  @param number 卡号
 *  @param block  block description
 */
+ (RACSignal *)request_unBingingBankCardWithParames:(NSDictionary *)parmas;

/**
 *  获取帐号信息
 *
 *  @param block block description
 */
+ (RACSignal *)request_AccountInfo;

/**
 *  获取用户信息
 *
 *  @param block block description
 */
+ (RACSignal *)request_getUserBaseInfo;
/**
 *  获取开户行网点
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_getBankAddressWithParames:(NSDictionary *)parames;

/**
 *  绑卡前先收到一个验证码
 *
 *  @param bind  bind description
 *  @param block block description
 */
+ (RACSignal *)request_getMessageCodeBeforeBindBankCardWithParames:(NSDictionary *)parames;
/**
 *  确认绑卡
 *
 *  @param bind  bind description
 *  @param block block description
 */
+ (RACSignal *)request_BindBankCardCaptchaVerifyParames:(NSDictionary *)parames;
/**
 *  提现前获取订单号
 *
 *  @param parmas 参数
 *  @param block  block description
 */
+ (RACSignal *)request_BeforeDrawCashGetOrderNoWithParameter:(NSDictionary *)parame;
/**
 *  提现
 *
 *  @param drawCash drawCash description
 *  @param block    block description
 */
+ (RACSignal *)request_WithDrawCashWithParames:(NSDictionary *)parsmes;
/**
 *  账单列表
 *
 *  @param parmas 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_BillLists_WithParmas:(NSDictionary *)parmas;
/**
 *  账单详情
 *
 *  @param number 账单号
 *  @param block  block description
 */
+ (RACSignal *)request_BillDetail_WithPayId:(NSString *)number;
/**
 *  根据条件筛选联系人
 *
 *  @param kw 关键词
 *
 *  @return return value description
 */
+ (RACSignal *)request_MyFriensList_WithKw:(NSString *)kw;
/**
 *  联系人列表
 *
 *  @return return value description
 */
+ (RACSignal *)request_MyFriensList;
/**
 *  新的好友
 *
 *  @return return value description
 */
+ (RACSignal *)request_MyNewFriensList;
/**
 *  添加朋友
 *
 *  @param mobile 手机号
 *  @param type   来源
 *
 *  @return return value description
 */
+ (RACSignal *)request_AddAnFriend_WithMobile:(NSString *)mobile formType:(GGAddAnFriendSource )type;
/**
 *  查看联系人详细信息
 *
 *  @param contactId 联系人ID
 *
 *  @return return value description
 */
+ (RACSignal *)request_CheckFriendInfo_WithContactId:(NSNumber *)contactId;
/**
 *  查看联系人信息
 *
 *  @param mobile 手机号
 *
 *  @return return value description
 */
+ (RACSignal *)request_CheckFriendInfo_WithMobile:(NSString *)mobile;
/**
 *  删除一个好友
 *
 *  @param contactId 好友ID
 *
 *  @return return value description
 */
+ (RACSignal *)request_DeleteAnFriend_WithContactId:(NSNumber *)contactId;
/**
 *  更改备注
 *
 *  @param contactId 联系人ID
 *  @param remark    备注信息
 *
 *  @return return value description
 */
+ (RACSignal *)request_EditFriendInfo_WithContactId:(NSNumber *)contactId remark:(NSString *)remark;
/**
 *  获取订单列表
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_PaymentOrderListWithParames:(NSDictionary *)parames;
/**
 *  订单详情
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_PaymentOrderDetailsWithParames:(NSDictionary *)parames;
/**
 *  上传交易信息
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_SubmitDealInfoWithParames:(NSDictionary *)parames;
/**
 *  申请退款
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_ApplicationForRefundWithParames:(NSDictionary *)parames;
/**
 *  修改退款申请
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_ReviseRefundWithParames:(NSDictionary *)parames;
/**
 *  拒绝退款退货
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_RefusedRefundWithParames:(NSDictionary *)parames;
/**
 *  买家确认收货
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_BuyerConfirmGoodsWithParames:(NSDictionary *)parames;
/**
 *  卖家确认收货
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_SealerConfirmGoodsWithParames:(NSDictionary *)parames;
/**
 *  获取最近的联系人
 *
 *  @return return value description
 */
+ (RACSignal *)request_LastContacts;
/**
 *  获取邀请记录
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_InvitationRecordsWithParames:(NSDictionary *)parames;
/**
 *  获取打赏信息
 *
 *  @return return value description
 */
+ (RACSignal *)request_RewardInfo;
/**
 *  打赏
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_RewardWithParames:(NSDictionary *)parames;

/**
 *  申请代付
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_ApplyPaymentWithParames:(NSDictionary *)parames;
/**
 *  申请代付列表
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_ApplyListWithParames:(NSDictionary *)parames;
/**
 *  申请代付详情
 *
 *  @param applyId 代付ID
 *
 *  @return return value description
 */
+ (RACSignal *)request_ApplyDetailWithApplyId:(NSNumber *)applyId;
/**
 *  拒绝或取消代付
 *
 *  @param applyId 代付申请ID
 *
 *  @return return value description
 */
+ (RACSignal *)request_CancelApplyWithApplyId:(NSNumber *)applyId;
/**
 *  同意代付
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_AgreeApplyWithParames:(NSDictionary *)parames;
/**
 *  提交清分申请
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_SubmitCapitalClearApplyWithParames:(NSDictionary *)parames;
/**
 *  清分申请列表
 *
 *  @param page 页码,从1开始
 *
 *  @return return value description
 */
+ (RACSignal *)request_CapitalClearApplyListWithPage:(NSNumber *)page;

/**
 *  清分申请详情
 *
 *  @param applyId 申请ID
 *
 *  @return return value description
 */
+ (RACSignal *)request_CapitalClearDetailWithApplyId:(NSNumber *)applyId;
/**
 *  车品牌列表
 *
 *  @return 车牌
 */
+ (RACSignal *)request_CarBrandsList;
/**
 *  获取某品牌对应的车系
 *
 *  @return return value description
 */
+ (RACSignal *)request_CarSeriesListWithBrandId:(NSNumber *)bId;

/**
 获取车系对应的年份

 @param sId 车系地
 @return return value description
 */
+ (RACSignal *)request_CarYearsListWithSeriesId:(NSNumber *)sId;

/**
 获取车型

 @param sId 车系地
 @param year 年份
 @return return value description
 */
+ (RACSignal *)request_CarModelsListWithSeriesId:(NSNumber *)sId purYear:(NSString *)year;
/**
 *  预约检车
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_appointmentCheckCarWithParames:(NSDictionary *)parames;
/**
 *  检测订单列表
 *
 *  @param parames 参数
 *
 *  @return return value description
 */
+ (RACSignal *)request_checkCarOrderWithParames:(NSDictionary *)parames;
/**
 *  检测订单详情
 *
 *  @param orderId 订单号
 *
 *  @return return value description
 */
+ (RACSignal *)request_checkCarOrderDetailWithOrderId:(NSNumber *)orderId;
/**
 *  根据vin识别车型
 *
 *  @param vin vin description
 *
 *  @return return value description
 */
+ (RACSignal *)request_autoDiscriminateCarWithVin:(NSString *)vin;

/**
 根据Vin获取车型

 @param vin vin description
 @param exist exist description
 @return return value description
 */
+ (RACSignal *)request_getCarModelWithVin:(NSString *)vin checkVinExist:(BOOL)exist;

/**
 添加我的地址

 @param parames 参数

 @return return value description
 */
+ (RACSignal *)request_addNewAddressWithParames:(NSDictionary *)parames;

/**
 地址列表

 @return return value description
 */
+ (RACSignal *)request_getAddressList;

/**
 设置默认地址

 @param addressId 地址ID

 @return return value description
 */
+ (RACSignal *)request_setDefultAddressWithAddressId:(NSNumber *)addressId;

/**
 编辑当前地址

 @param parames 参数

 @return return value description
 */
+ (RACSignal *)request_editAddressWithParames:(NSDictionary *)parames;


/**
 删除一个地址

 @param addressId 地址ID

 @return return value description
 */
+ (RACSignal *)request_deleteAnAddressWithAddressId:(NSNumber *)addressId;

/**
 发布或者编辑一辆车

 @param parameter 参数
 @return return value description
 */
+ (RACSignal *)request_releaseAnCarWithParameter:(NSDictionary *)parameter;

/**
 车源管理列表

 @param parameter 参数
 @return return value description
 */
+ (RACSignal *)request_vehicleManagerListWithParameter:(NSDictionary *)parameter;

/**
 获取车辆详情

 @param carId 车辆ID
 @return return value description
 */
+ (RACSignal *)request_carDetailsWithCarId:(NSNumber *)carId;

/**
 删除一辆车

 @param carId ID
 @return return value description
 */
+ (RACSignal *)request_deleteCarByCarId:(NSNumber *)carId;

/**
 车辆下单

 @param parameter 参数
 @return return value description
 */
+ (RACSignal *)request_placeAnCarOrderWithParameter:(NSDictionary *)parameter;
/**
 车辆订单列表

 @param parameter 参数
 @return return value description
 */
+ (RACSignal *)request_carsOrderListWithParameter:(NSDictionary *)parameter;

/**
 订单详情

 @param orderNo 订单号
 @return return value description
 */
+ (RACSignal *)request_carsOrderDetailWithOrderNo:(NSString *)orderNo;

/**
 修改交易价格

 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_modifyCarDealPriceWithParameter:(NSDictionary *)parameter;


/**
 生意首页数据
 
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_getBusinessDataWithParameter:(NSDictionary *)parameter;



/**
 用户退出登录
 
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_userLogoutWithParameter:(NSDictionary *)parameter;


/**
 提现 收费 说明
 
 @param parameter parameter description
 @return return value description
 */

+ (RACSignal *)request_CalculationFeeWithParameter:(NSDictionary *)parameter;

/**
 验证身份证是否正确
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_CheckCardIDWithParameter:(NSDictionary *)parameter;



#pragma mark -  新车抢购
/**
 新车抢购列表
 @param parameter parameter description
 @return return value description
 */

+ (RACSignal *)request_GetNewCarListWithParameter:(NSDictionary *)parameter;

/**
 抢购新车详情
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetNewCarDetailWithParameter:(NSDictionary *)parameter;
/**
 抢购新车下订单
 @param parameter parameter description
 @return return value description
 */
+ (RACSignal *)request_GetNewCarOrderWithParameter:(NSDictionary *)parameter;


@end
