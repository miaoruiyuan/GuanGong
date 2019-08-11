//
//  NSString+Common.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/16.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

#pragma mark - String行间距
- (NSMutableAttributedString *)attributedStringWithLineSpace:(CGFloat )space{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}


#pragma mark - 金额格式化
+ (NSString *)positiveFormat:(NSString *)text{
    if(!text || [text floatValue] == 0){
        return @"0.00";
    }else{
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@",##0.00;"];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
    }
    return @"";
}


-(NSString *)removeSpaces{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(BOOL)checkStringWithRegular:(NSString *)regular{
    if (!regular || [regular isEqualToString:@""]) {
        return [self length] ? YES : NO;
    }
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regular
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    if (!error) {
        NSRange range = NSMakeRange(0, self.length);
        NSTextCheckingResult *match = [regex firstMatchInString:self
                                                        options:NSMatchingReportProgress
                                                          range:range];
        
        if (match) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}


//判断是否是身份证
- (BOOL)validateIdentityCard: (NSString *)regular{
    BOOL flag;
    if (regular.length <= 0) {
        flag = NO;
        return flag;
    }
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    return [identityCardPredicate evaluateWithObject:self];
}


//判断是否是手机号码
- (BOOL)isPhoneNo{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

#pragma mark - 验证密码
- (BOOL)validatePassword{
    NSString *passwordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [phoneTest evaluateWithObject:self];
}


- (BOOL)isSixNumberPassword{
    NSString *phoneRegex = @"^\\d{6}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (CGSize )stringSizeWithFont:(UIFont *)font Size:(CGSize)size{
    
    //段落样式
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    //字体大小，换行模式
    NSDictionary *attributes = @{NSFontAttributeName : font , NSParagraphStyleAttributeName : style};
    CGSize resultSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    return resultSize;
}




+ (NSDictionary *)errorDic{
    
    static NSDictionary *errorDic = nil;
    
    if (!errorDic) {
         errorDic = @{@100001:@"签名错误",
                     @100002:@"参数错误",
                     @100003:@"token过期",
                     @100004:@"服务器异常",
                     @100005:@"银行操作异常",
                     @100006:@"手机号已被注册",
                     @100007:@"请重新获取验证码",
                     @100008:@"手机号错误",
                     @100009:@"验证码获取次数过多",
                     @100010:@"手机号不存在",
                     @100011:@"密码错误",
                     @100012:@"账户不存在",
                     @100013:@"动态码过期",
                     @100021:@"该账号异常，禁止登录。\n如有问题请联系客服：400-822-0063",
                     @101008:@"不是关二爷用户",
                     @101301:@"查询联系人异常",
                     @101401:@"查询联系人列表异常",
                     @100016:@"支付密码错误",
                     @100018:@"支付密码错误",
                     @100020:@"密码被锁定,请稍后再试",
                     @103001:@"获取好友信息失败",
                     @103002:@"此用户尚未注册关二爷账户",
                    };
    }
    
    
    
    return errorDic;
}

+ (NSString *)errorDescription:(NSInteger )errorCode{
    
    NSDictionary *errdic = [self errorDic];
    NSString *errorMessage = [errdic objectForKey:[NSNumber numberWithInteger:errorCode]];
    
    if (errorMessage) {
        return errorMessage;
    }else{
        return @"未知的错误";
    }
   
}


+ (NSString *)lr_stringDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

#pragma mark - 转换成数组
- (NSArray *)convertToArray{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i < self.length; i++) {
        NSString *tmp_str = [self substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:[tmp_str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return arr;
}



@end
