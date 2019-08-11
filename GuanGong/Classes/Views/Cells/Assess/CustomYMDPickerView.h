//
//  CustomYMDPickerView.h
//  iautosCar
//
//  Created by three on 2016/11/28.
//  Copyright © 2016年 iautos_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomYMDPickerBlock)(NSString *dateStr);

@interface CustomYMDPickerView : UIView

@property (nonatomic, copy) CustomYMDPickerBlock customYMDPickerBlock;

-(instancetype)initWithMinYear:(NSInteger)minYear;

-(void)show;
-(void)hide;

@end
