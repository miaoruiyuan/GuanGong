//
//  GGWalletToolsCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WalletToolsBarDelegate <NSObject>

- (void)selectWalletToolBarButtonIndex:(NSInteger)index;

@end

UIKIT_EXTERN NSString * _Nullable const kCellIdentifierWalletTools;

@interface GGWalletToolsCell : UITableViewCell


@property(nonatomic,weak,nullable)id <WalletToolsBarDelegate> delegate;

@end
