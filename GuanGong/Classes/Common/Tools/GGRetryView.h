//
//  GGRetryView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,YYQRetryViewType) {
    GGRetryViewTypeNormal,
    GGRetryViewTypeWithBtn,
};

@interface GGRetryView : NSObject
@property(nonatomic,copy)void (^touchRetry)(void);
@property(nonatomic,copy)void (^clickRoute)(void);
/**
 *  触摸重试
 *
 *  @param inView  在哪个view
 *  @param ico     图标
 *  @param title   标题
 *  @param size    标题fontsize
 *  @param offsetY 在inview上的offsetY偏移量
 *
 *  @return view
 */
-(instancetype)initRetryInView:(UIView *)inView ico:(NSString *)ico title:(NSString *)title size:(CGFloat)size offsetY:(CGFloat)offsetY;
-(instancetype)initRouteInView:(UIView *)inView title:(NSString *)title desc:(NSString *)desc btnTitle:(NSString *)btnTitle offsetY:(CGFloat)offsetY;
-(void)show;
-(void)dismiss;


@end
