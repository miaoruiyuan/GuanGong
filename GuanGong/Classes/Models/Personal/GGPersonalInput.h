//
//  GGPersonalInput.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGPersonalInput : NSObject

//占位文字
@property(nonatomic,copy)NSString *placeholder;
//正则
@property(nonatomic,copy)NSString *regular;
//不符合规则的提示
@property(nonatomic,copy)NSString *tip;
//头提示
@property(nonatomic,copy)NSString *headerTip;
//脚提示
@property(nonatomic,copy)NSString *footerTip;
//键盘类型
@property(nonatomic,assign)UIKeyboardType keyBoardType;
//键盘大写
@property(nonatomic,assign)UITextAutocapitalizationType autoCapitalType;

@end
