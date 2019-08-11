//
//  GGCardListViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/1.
//  Copyright © 2016年 iautos. All rights reserved.
//


#import "GGTableViewController.h"

#import "GGBankCard.h"

typedef void(^BankCardInfo)(GGBankCard *bankCard);

@interface GGMineCardsListViewController : GGTableViewController

@property(nonatomic,strong)BankCardInfo cardInfo;

@end
