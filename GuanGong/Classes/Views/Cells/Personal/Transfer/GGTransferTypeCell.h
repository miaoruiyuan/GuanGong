//
//  GGTransferTypeCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kCellIdentifierTransferType;

@interface GGTransferTypeCell : UITableViewCell

@property(nonatomic,strong)UISegmentedControl *segment;;

+ (CGFloat)cellHeight;

@end
