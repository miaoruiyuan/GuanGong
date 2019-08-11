//
//  GGNewCarGuaranteeCell.h
//  GuanGong
//
//  Created by CodingTom on 2017/5/10.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGTableViewCell.h"

UIKIT_EXTERN NSString *const kGGNewCarGuaranteeCellID;

@interface GGNewCarGuaranteeCell : GGTableViewCell

- (void)showWithTagArray:(NSArray<NSString*> *)tagArray;

+ (CGFloat)getCellHight:(NSArray<NSString*> *)tagArray;

@end
