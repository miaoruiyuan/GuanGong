//
//  GGSearvicePriceListModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/4/13.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGSearvicePriceListModel : NSObject

@property (nonatomic , copy) NSString              *priceId;
@property (nonatomic , copy) NSString              *des;

@property (nonatomic , strong) NSNumber            *originalPrice;
@property (nonatomic , strong) NSNumber            *num;
@property (nonatomic , strong) NSNumber            *price;

@end
