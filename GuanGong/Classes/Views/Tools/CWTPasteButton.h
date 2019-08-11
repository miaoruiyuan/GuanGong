//
//  CWTPasteButton.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/3/31.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWTPasteButton : UIButton
@property (nonatomic, copy) void(^pasteVinBlock)(NSString *vin);
@end
