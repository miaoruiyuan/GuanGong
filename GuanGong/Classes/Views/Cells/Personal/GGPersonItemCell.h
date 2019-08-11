//
//  GGPersonItemCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/2/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGFormItem.h"

UIKIT_EXTERN NSString * const kCellIdentifierPersonItem;

@interface GGPersonItemCell : UITableViewCell

-(void)setupView;

-(void)configItem:(GGFormItem *)item;

@end
