//
//  GGPasscodeView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CodeViewType) {
    CodeViewTypeCustom,//普通样式
    CodeViewTypeSecret//密码风格
};

@interface GGPasscodeView : UIView

//样式
@property (nonatomic, assign) CodeViewType codeType;
//是否需要分隔符
@property (nonatomic, assign) BOOL hasSpaceLine;
//是否有下标线
@property (nonatomic, assign) BOOL hasUnderLine;
//输入完成回调
@property (nonatomic, copy) void(^EndEditBlcok)(NSString *text,GGPasscodeView *view);


- (instancetype)initWithFrame:(CGRect)frame
                          num:(NSInteger)num
                    lineColor:(UIColor *)lColor
                     textFont:(CGFloat)font;

- (void)beginEdit;
- (void)endEdit;

@end
