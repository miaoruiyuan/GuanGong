//
//  GGMessageCodeViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"

#import "GGWithdrawViewModel.h"
#import "GGBindCardViewModel.h"
#import "GGBankRechargeViewModel.h"

@interface GGMessageCodeViewController : GGBaseViewController

//提现
@property(nonatomic,strong)GGWithdrawViewModel *withDrawVM;

//绑卡
@property(nonatomic,strong)GGBindCardViewModel *bindCardVM;

//充值
@property(nonatomic,strong)GGBankRechargeViewModel *rechargeVM;

@end
