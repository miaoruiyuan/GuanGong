//
//  GGSwichCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/24.
//  Copyright © 2016年 iautos. All rights reserved.
//


#import "GGTableViewCell.h"


typedef void(^SwichBlock)(UISwitch *swich);



UIKIT_EXTERN NSString * const kCellIdentifierSwich;
@interface GGSwichCell : GGTableViewCell

@property(nonatomic,strong)UISwitch *swich;

@property(nonatomic,copy)SwichBlock swichBlock;


@end
