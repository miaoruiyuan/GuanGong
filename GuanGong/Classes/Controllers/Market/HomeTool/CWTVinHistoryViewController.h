//
//  CWTVinHistoryViewController.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/21.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGCarHistoryServiceCompany.h"

@interface CWTVinHistoryViewController : GGTableViewController

@property(nonatomic,assign)BOOL isMaintain;

@property(nonatomic,strong)GGCarHistoryServiceCompany *serviceCompany;

@end
