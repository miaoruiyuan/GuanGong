//
//  GGActionSheet.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGActionSheetDelegate;

typedef void(^GGActionSheetBlock)(NSInteger buttonIndex);
@interface GGActionSheet : UIView


/**
 *  type delegate
 *
 *  @param title                  title            (可以为空)
 *  @param delegate               delegate
 *  @param cancelButtonTitle      "取消"按钮         (默认有)
 *  @param destructiveButtonTitle "警示性"(红字)按钮  (可以为空)
 *  @param otherButtonTitles      otherButtonTitles
 */
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<GGActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  type block
 *
 *  @param title                  title            (可以为空)
 *  @param delegate               delegate
 *  @param cancelButtonTitle      "取消"按钮         (默认有)
 *  @param destructiveButtonTitle "警示性"(红字)按钮  (可以为空)
 *  @param otherButtonTitles      otherButtonTitles
 */
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
             actionSheetBlock:(GGActionSheetBlock) actionSheetBlock;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id<GGActionSheetDelegate> delegate;

- (void)show;


@end



#pragma mark - GGActionSheet delegate
@protocol GGActionSheetDelegate <NSObject>

@optional

- (void)actionSheet:(GGActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end
