//
//  GGBusinessItemView.h
//  GuanGong
//
//  Created by CodingTom on 2017/2/15.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemButtonClick)(NSInteger tag);

@interface GGBusinessItemView : UIView

@property(nonatomic,copy)ItemButtonClick click;

@end
