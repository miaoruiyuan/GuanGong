//
//  CWTVinView.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/20.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "CWTRecognitionVin.h"

@interface CWTVinView : UIView

@property (nonatomic, copy) void(^inputValueBlock)(NSString *vin);

@property(nonatomic,assign)NSInteger count;

- (void)clearInputText;
/**
 显示剩余次数
 */
@property(nonatomic,strong)TTTAttributedLabel *countLabel;

/**
 显示区域经理按钮
 */
@property(nonatomic,strong)UIButton *buyBtn;

@end
