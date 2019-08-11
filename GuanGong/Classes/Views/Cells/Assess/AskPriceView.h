//
//  AskPriceView.h
//  iautosCar
//
//  Created by 赵三 on 2017/1/3.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitButtonBlock)(NSString *phone);

@interface AskPriceView : UIView

@property (nonatomic, copy) SubmitButtonBlock submitButtonBlock;

-(void)show;
-(void)hide;

@end
