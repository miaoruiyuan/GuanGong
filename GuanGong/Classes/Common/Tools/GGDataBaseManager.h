//
//  GGDataBaseManager.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const MyFriendsTable;
UIKIT_EXTERN NSString *const AddressBookTable;

@interface GGDataBaseManager : NSObject

+(GGDataBaseManager *)shareDB;

//好友
- (void)putMyFriendsListWithData:(id)value;
- (id)getMyFriendsLists;

//通讯录数据
- (void)putAddressBookListWithData:(id)value;
- (id)getAddressBookLists;

@end
