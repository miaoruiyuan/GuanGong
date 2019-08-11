//
//  GGDataBaseManager.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/31.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGDataBaseManager.h"
#import "YTKKeyValueStore.h"

@interface GGDataBaseManager ()
@property(nonatomic,strong)YTKKeyValueStore *store;

@end

NSString *const MyFriendsTable = @"MyFriendsTable";
NSString *const AddressBookTable = @"AddressBookTable";

@implementation GGDataBaseManager
+(GGDataBaseManager *)shareDB{
    static dispatch_once_t onceToken;
    static GGDataBaseManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[GGDataBaseManager alloc] init];
    });
    return manager;

}

- (id)init{
    if (self = [super init]) {
        [self initDB];
    }
    return self;
}


- (void)initDB{
    [self.store createTableWithName:MyFriendsTable];
    [self.store createTableWithName:AddressBookTable];
}



#pragma mark - 存储我的好友
- (void)putMyFriendsListWithData:(id)value{
    [self.store putObject:value withId:@"myFriends" intoTable:MyFriendsTable];
}

#pragma mark - 获取好友数据
- (id)getMyFriendsLists{
    return [self.store getObjectById:@"myFriends" fromTable:MyFriendsTable];
}

#pragma mark - 存储通讯录数据
- (void)putAddressBookListWithData:(id)value{
    [self.store putObject:value withId:@"addressBook" intoTable:AddressBookTable];
}

- (id)getAddressBookLists{
    return [self.store getObjectById:@"addressBook" fromTable:AddressBookTable];
}



- (YTKKeyValueStore *)store{
    if (!_store) {
        _store = [[YTKKeyValueStore alloc] initDBWithName:@"DB.sqlite"];
    }
    return _store;
}


@end
