//
//  CWTSearchOffenceViewController.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/1/3.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTSearchOffenceViewController.h"

@interface CWTSearchOffenceViewController ()

@end

@implementation CWTSearchOffenceViewController

- (void)setupView{
    self.url = @"http://weizhang.58.com/m/view?channelid=23&appsource=23&platform=1";
    [super setupView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"违章查询";
}


@end
