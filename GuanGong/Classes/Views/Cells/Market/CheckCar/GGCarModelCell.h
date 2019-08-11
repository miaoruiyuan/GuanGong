//
//  GGCarModelCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCarBrand.h"
UIKIT_EXTERN NSString *const kCellIdentifierCreateCarModel;

@interface GGCarModelCell : UITableViewCell

@property(nonatomic,strong)GGModelList *model;

@end
