//
//  CWTVinResultViewController.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/2/20.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "GGTableViewController.h"
#import "GGVinInfoViewModel.h"

@interface CWTVinResultViewController : GGTableViewController

@property (nonatomic,strong)GGVinInfoViewModel *vinInfoVM;

@property(nonatomic,assign)BOOL isEmission;

@end
