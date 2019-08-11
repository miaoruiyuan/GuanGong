//
//  GGOnlyLabelCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/23.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kCellIdentifierOnlyLabel;

@interface GGOnlyLabelCell : UITableViewCell

@property(nonatomic,strong)UILabel  *label;


- (void)updateHelpListTitle:(NSString *)title;

@end
