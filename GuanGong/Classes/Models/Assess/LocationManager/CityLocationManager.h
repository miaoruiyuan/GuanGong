//
//  CityLocationManager.h
//  iautosCar
//
//  Created by 苗芮源 on 15/10/28.
//  Copyright © 2015年 iautos_miaoruiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Singleton.h"

typedef void(^ResultBlock)(CLLocation *location, CLPlacemark *pl, NSString *error);

@interface CityLocationManager : NSObject

single_interface(CityLocationManager);

- (void)getCurrentLocation:(ResultBlock)block;

@end
