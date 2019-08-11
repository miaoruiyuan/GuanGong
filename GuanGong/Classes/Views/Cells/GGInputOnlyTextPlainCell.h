//
//  GGInputOnlyTextPlainCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/20.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kCellIdentifierInputOnlyTextPlain;

@interface GGInputOnlyTextPlainCell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString*);

- (void)configWithPlaceholder:(NSString *)phStr valueStr:(NSString *)valueStr secureTextEntry:(BOOL)isSecure;

@end
