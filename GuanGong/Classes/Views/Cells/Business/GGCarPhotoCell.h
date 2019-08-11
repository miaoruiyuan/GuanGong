//
//  GGCarPhotoCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/27.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGImageItem.h"
@interface GGCarPhotoCell : UICollectionViewCell
@property(nonatomic,strong)GGImageItem *carImg;
@property (copy, nonatomic)void (^deleteCarImage)(GGImageItem *toDelete);

+ (CGSize)ccellSize;

@end
