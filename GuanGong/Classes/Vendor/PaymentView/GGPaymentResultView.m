//
//  GGPaymentResultView.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPaymentResultView.h"


@interface GGPaymentResultView ()



@end

@implementation GGPaymentResultView



- (IBAction)didTappedBackButton:(UIButton *)sender {
    [self.delegate didTappedResultViewBackButton];
}

- (IBAction)didTappedConfimButton:(UIButton *)sender {
    [self.delegate didTappedResultViewConfirmButton];
}


@end
