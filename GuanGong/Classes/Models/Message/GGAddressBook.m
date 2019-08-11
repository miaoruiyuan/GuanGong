//
//  GGAddressBook.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGAddressBook.h"
#import "pinyin.h"

@implementation GGAddressBook

- (NSString *)getUserNamePinYin
{
    if (_fullname) {
        NSString *pingyinName = [_fullname stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(pingyinName.length >= 1){
            if ([[pingyinName substringToIndex:1] canBeConvertedToEncoding:NSASCIIStringEncoding] ){
                return [pingyinName substringToIndex:1];
            }else{
                 return [NSString stringWithFormat:@"%c",pinyinFirstLetter([pingyinName characterAtIndex:0])] ;
            }
        }else{
            return @"#";
        }
    }else{
         return @"#";
    }
}
@end
