//
//  GGAttestationCheckedSuccessView.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/5.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGAttestationAudingPassView : UIView

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *iDCard;


- (void)showInAttestationController;

- (void)showInCompanyController;

@end
