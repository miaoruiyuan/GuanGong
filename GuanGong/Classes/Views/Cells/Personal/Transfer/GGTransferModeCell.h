//
//  GGTransferModeCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/21.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kCellIdentifierTransferMode;

@interface GGTransferModeCell : UITableViewCell

- (void)updateUIWithModeName:(NSString *)modelName modeImageName:(NSString *)modeImageName;

@end
