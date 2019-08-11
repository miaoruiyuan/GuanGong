//
//  GGRegisterView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/5/25.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "TTTAttributedLabel.h"

@interface GGRegisterView : UIView


@property(nonatomic,strong)UITextField *userNameFileld;
@property(nonatomic,strong)UITextField *identifyCodeFileld;
@property(nonatomic,strong)UITextField *passwordFileld;

@property(nonatomic,strong)UIButton *registerButtton;
@property(nonatomic,strong)UIButton *timerButtton;

@property(nonatomic,strong)TTTAttributedLabel *protocolLabel;


@end
