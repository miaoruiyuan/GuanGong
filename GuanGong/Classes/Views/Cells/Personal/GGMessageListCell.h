//
//  GGMessageListCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/6/14.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewCell.h"

UIKIT_EXTERN NSString * const kGGMessageListCellID;

@interface GGMessageListCell : GGTableViewCell

- (void)showUIWithModel:(NSObject *)model;

@end
