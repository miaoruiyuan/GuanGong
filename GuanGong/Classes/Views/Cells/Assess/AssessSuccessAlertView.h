//
//  AssessSuccessAlertView.h
//  bluebook
//
//  Created by three on 2017/5/31.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CloseButtonBlock)();
typedef void(^SureButtonBlock)();

@interface AssessSuccessAlertView : UIView

@property (nonatomic, copy) CloseButtonBlock closeBlock;
@property (nonatomic, copy) SureButtonBlock sureButtonBlock;

-(void)setImage:(NSString*)imageSring andTitle:(NSString *)titleString andButtonTitle:(NSString *)buttonTitle;

-(void)show;
-(void)hide;

@end
