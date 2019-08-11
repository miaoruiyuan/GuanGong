//
//  UILabel+Common.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/30.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "UILabel+Common.h"
#import <CoreText/CoreText.h>

@interface UILabel (Commen)

@property (nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end


@implementation UILabel (Common)


#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return self.copyingEnabled;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    // Only return YES for the copy: action AND the copyingEnabled property is YES.
    return (action == @selector(copy:) && self.copyingEnabled);
}

- (void)copy:(id)sender
{
    if(self.copyingEnabled)
    {
        // Copy the label text
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.text];
    }
}

#pragma mark - UI Actions

- (void) longPressGestureRecognized:(UIGestureRecognizer *) gestureRecognizer
{
    if (gestureRecognizer == self.longPressGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            [self becomeFirstResponder];
            
            UIMenuController *copyMenu = [UIMenuController sharedMenuController];
            [copyMenu setTargetRect:self.bounds inView:self];
            copyMenu.arrowDirection = UIMenuControllerArrowDefault;
            [copyMenu setMenuVisible:YES animated:YES];
        }
    }
}

#pragma mark - Properties

- (BOOL)copyingEnabled
{
    return [objc_getAssociatedObject(self, @selector(copyingEnabled)) boolValue];
}

- (void)setCopyingEnabled:(BOOL)copyingEnabled
{
    if(self.copyingEnabled != copyingEnabled)
    {
        objc_setAssociatedObject(self, @selector(copyingEnabled), @(copyingEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self setupGestureRecognizers];
    }
}

- (UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    return objc_getAssociatedObject(self, @selector(longPressGestureRecognizer));
}

- (void)setLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer
{
    objc_setAssociatedObject(self, @selector(longPressGestureRecognizer), longPressGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldUseLongPressGestureRecognizer
{
    NSNumber *value = objc_getAssociatedObject(self, @selector(shouldUseLongPressGestureRecognizer));
    if(value == nil) {
        // Set the default value
        value = @YES;
        objc_setAssociatedObject(self, @selector(shouldUseLongPressGestureRecognizer), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return [value boolValue];
}

- (void)setShouldUseLongPressGestureRecognizer:(BOOL)useGestureRecognizer
{
    if(self.shouldUseLongPressGestureRecognizer != useGestureRecognizer)
    {
        objc_setAssociatedObject(self, @selector(shouldUseLongPressGestureRecognizer), @(useGestureRecognizer), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self setupGestureRecognizers];
    }
}

#pragma mark - Private Methods

- (void) setupGestureRecognizers
{
    // Remove gesture recognizer
    if(self.longPressGestureRecognizer) {
        [self removeGestureRecognizer:self.longPressGestureRecognizer];
        self.longPressGestureRecognizer = nil;
    }
    
    if(self.shouldUseLongPressGestureRecognizer && self.copyingEnabled) {
        self.userInteractionEnabled = YES;
        // Enable gesture recognizer
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
}

- (void)changeAlignmentRightAndLeft{
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName : self.font}
                                              context:nil].size;
    
    
    CGFloat margin = (self.frame.size.width - textSize.width) / (self.text.length - 1);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:(id)kCTKernAttributeName value:[NSNumber numberWithFloat:margin] range:NSMakeRange(0, self.text.length - 1) ];
    
    self.attributedText = attributedString;
}



+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

@end
