//
//  GGHomeTopView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/5/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGWallet.h"

typedef void(^ButtonClick)(NSInteger tag);

@interface GGHomeTopView : UIView

@property(nonatomic,strong)ButtonClick click;

//@property(nonatomic,strong)GGWallet *wallet;

@end
