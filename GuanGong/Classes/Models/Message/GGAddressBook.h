//
//  GGAddressBook.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/5.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGAddressBook : NSObject

@property(nonatomic,copy)NSString *lastname;
@property(nonatomic,copy)NSString *firstname;
@property(nonatomic,copy)NSString *fullname;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *email;


- (NSString *)getUserNamePinYin;

@end
