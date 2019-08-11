//
//  UITableView+Common.h
//  GuanGong
//
//  Created by 苗芮源 on 16/5/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Common)

- (void)addRadiusforCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)addLineforPlainCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withLeftSpace:(CGFloat)leftSpace;
- (void)addLineforPlainCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withLeftSpaceAndSectionLine:(CGFloat)leftSpace;
- (void)addLineforPlainCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withLeftSpace:(CGFloat)leftSpace hasSectionLine:(BOOL)hasSectionLine;


@end
