//
//  GGPaymentDetailView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPaymentDetailView.h"

@interface GGPaymentDetailView ()

@end

@implementation GGPaymentDetailView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.unityPayButton.layer.borderWidth = 2;
    self.unityPayButton.layer.borderColor = [UIColor colorWithRed:0.227  green:0.533  blue:0.827 alpha:1].CGColor;
    [self.unityPayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.unityPayButton setTitleColor:[UIColor colorWithRed:0.227  green:0.533  blue:0.827 alpha:1] forState:UIControlStateSelected];
    
    self.balanceButton.layer.borderWidth = 1;
    self.balanceButton.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:0.5].CGColor;
    [self.balanceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.balanceButton setTitleColor:[UIColor colorWithRed:0.227  green:0.533  blue:0.827 alpha:1] forState:UIControlStateSelected];
}

- (IBAction)didTappedCloseButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didTappedDetailViewCloseButton)]) {
        [self.delegate didTappedDetailViewCloseButton];
    }
}

- (IBAction)didSelectUnionPayButton:(UIButton *)sender {
    
    self.balanceButton.selected = NO;
    self.unityPayButton.selected = YES;
    
    self.unityPayButton.layer.borderWidth = 2;
    self.unityPayButton.layer.borderColor = [UIColor colorWithRed:0.227  green:0.533  blue:0.827 alpha:1].CGColor;
    
    self.balanceButton.layer.borderWidth = 1;
    self.balanceButton.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:0.5].CGColor;

}
- (IBAction)didSelectBalancePayButton:(UIButton *)sender {
    
    self.unityPayButton.selected = NO;
    self.balanceButton.selected = YES;
    
    self.unityPayButton.layer.borderWidth = 1;
    self.unityPayButton.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:0.5].CGColor;
    
    self.balanceButton.layer.borderWidth = 2;
    self.balanceButton.layer.borderColor = [UIColor colorWithRed:0.227  green:0.533  blue:0.827 alpha:1].CGColor;

}
- (IBAction)didTappedConfirmButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didTappedDetailViewConfirmButtonWithPaymentMethod:)]) {
        [self.delegate didTappedDetailViewConfirmButtonWithPaymentMethod:self.balanceButton.selected];
    }
}



@end
