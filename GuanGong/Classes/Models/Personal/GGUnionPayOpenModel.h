//
//  GGUnionPayOpenModel.h
//  GuanGong
//
//  Created by CodingTom on 2017/7/21.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGUnionPayOpenModel : NSObject

@property(nonatomic,copy)NSString *orig;
@property(nonatomic,copy)NSString *sign;
@property(nonatomic,copy)NSString *returnurl;
@property(nonatomic,copy)NSString *notifyurl;
@property(nonatomic,copy)NSString *unionUrl;

@end
