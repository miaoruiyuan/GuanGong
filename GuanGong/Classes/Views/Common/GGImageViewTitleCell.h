//
//  GGImageViewTitleCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/28.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kCellIdentifierImageViewTitle;

@interface GGImageViewTitleCell : UITableViewCell

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titleLabel;


@end