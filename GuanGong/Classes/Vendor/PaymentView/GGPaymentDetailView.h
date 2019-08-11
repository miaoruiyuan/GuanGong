//
//  GGPaymentDetailView.h
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  GGPaymentDetailViewDelegate<NSObject>

- (void)didTappedDetailViewConfirmButtonWithPaymentMethod:(GGPaymentMethod )paymentMethod;
- (void)didTappedDetailViewCloseButton;

@end


@interface GGPaymentDetailView : UIView

@property (weak, nonatomic) IBOutlet UIButton *unityPayButton;
@property (weak, nonatomic) IBOutlet UIButton *balanceButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (nonatomic, weak) id<GGPaymentDetailViewDelegate> delegate;

- (IBAction)didSelectUnionPayButton:(UIButton *)sender;
- (IBAction)didSelectBalancePayButton:(UIButton *)sender;

@end
