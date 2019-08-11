//
//  GGTransferAccountCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/3.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kCellIdentifierTransferAccount;

@interface GGTransferAccountCell : UITableViewCell

@property(nonatomic,strong)UITextField *amountField;
@property(nonatomic,strong)UITextField *remarkField;

- (void)updataUIByType:(BOOL)isTransfer;

@end
