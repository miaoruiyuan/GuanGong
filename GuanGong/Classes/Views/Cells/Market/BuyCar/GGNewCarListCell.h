//
//  GGNewCarListCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/9.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGTableViewCell.h"
#import "GGNewCarListModel.h"

UIKIT_EXTERN NSString *const kGGNewCarListCellID;

@interface GGNewCarListCell : GGTableViewCell

- (void)updateUIWithModel:(GGNewCarListModel *)model;

@end
