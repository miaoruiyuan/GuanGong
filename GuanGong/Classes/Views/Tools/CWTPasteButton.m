//
//  CWTPasteButton.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/3/31.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTPasteButton.h"

@implementation CWTPasteButton
- (void)layoutSubviews{
    [super layoutSubviews];
    
    UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self becomeFirstResponder];
    
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:CGRectMake(self.origin.x - 30, self.origin.y, 100, 26) inView:self.superview];
        UIMenuItem *vinItem = [[UIMenuItem alloc] initWithTitle:@"粘贴VIN" action:@selector(pasteVin:)];
        menuController.menuItems = @[vinItem];
        menuController.menuVisible = YES;
    }];
    
    [self addGestureRecognizer:longPress];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(pasteVin:)) {
        return YES;
    }
    return NO;
}

- (void)pasteVin:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    NSString *vinStr = [pboard.string removeSpaces];

    if (vinStr.length == 17) {
        if (self.pasteVinBlock) {
            self.pasteVinBlock(pboard.string);
        }
    }else{
        [MBProgressHUD showError:@"无效Vin"];
    }
    
   
}


@end
