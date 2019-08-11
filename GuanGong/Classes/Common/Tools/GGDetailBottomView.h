//
//  GGDetailBottomView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/23.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGDetailBottomView : UIView


- (id)initWithButtonTitles:(NSArray *)titles buttonAction:(void (^)(UIButton *sender, NSInteger index))buttonAction;
+ (id)initWithButtonTitles:(NSArray *)titles buttonAction:(void (^)(UIButton *sender, NSInteger index))buttonAction;
@end
