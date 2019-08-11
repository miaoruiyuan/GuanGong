//
//  GGCheckUpdateModel.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/8.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "GGCheckUpdateModel.h"

@implementation GGCheckUpdateModel

- (BOOL)showUpdate
{
    if (self.version && self.url) {
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        return [self canShowUpdate:appVersion onlineVersion:self.version];
    }
    return NO;
}

- (BOOL)canShowUpdate:(NSString *)localVersion onlineVersion:(NSString *)onlineVersion
{
    if (![localVersion isEqualToString:onlineVersion]) {
 
        NSArray *localArray = [localVersion componentsSeparatedByString:@"."];
        NSArray *onlineArray = [onlineVersion componentsSeparatedByString:@"."];
        
        NSUInteger length = localArray.count < onlineArray.count ? localArray.count : onlineArray.count;
        
        for (NSUInteger index = 0 ; index < length; index++) {
            if ([onlineArray[index] integerValue] > [localArray[index] integerValue] ) {
                if(index >= 1){
                    if ([onlineArray[index - 1] integerValue] >= [localArray[index - 1] integerValue]) {
                        return YES;
                    }
                } else {
                    return YES;
                }
            }
        }
        
        if (onlineArray.count > localArray.count) {
            return YES;
        }
    }
    return NO;
}

@end
