//
//  NSString+Common.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/16.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)
/**
 *  行间距
 *
 *  @param space 间距
 *
 *  @return return value description
 */
- (NSMutableAttributedString *)attributedStringWithLineSpace:(CGFloat )space;

/**
 *  金额千分位显示，保留小数点后两位
 *
 *  @param text 金额
 *
 *  @return return value description
 */
+ (NSString *)positiveFormat:(NSString *)text;
/**
 *  移除字符串包含的空格
 *
 *  @return return value description
 */
-(NSString *)removeSpaces;
/**
 *  正则匹配
 *
 *  @param regular 正则表达式
 *
 *  @return bool
 */
-(BOOL)checkStringWithRegular:(NSString *)regular;
/**
 *  验证身份证
 *
 *  @param identityCard 正则
 *
 *  @return return value description
 */
- (BOOL)validateIdentityCard:(NSString *)regular;
/**
 *  判断是不是手机号
 *
 *  @return return value description
 */
- (BOOL)isPhoneNo;
/**
 *  验证密码,数字或者字母,不少于6位
 *
 *  @return return value description
 */
- (BOOL)validatePassword;

/**
 *  判断是不是6位数字密码
 *
 *  @return return value description
 */
- (BOOL)isSixNumberPassword;


/**
 *  解析错误码
 *
 *  @param errorCode 错误码
 *
 *  @return return value description
 */
+ (NSString *)errorDescription:(NSInteger )errorCode;

- (CGSize)stringSizeWithFont:(UIFont *)font Size:(CGSize)size;


//时间
+ (NSString *)lr_stringDate;

- (NSArray *)convertToArray;

@end
