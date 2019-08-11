//
//  GGFriendsList.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/4.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,FriendAuditStatus) {
    FriendAuditPass = 1,
    FriendAuditInvalid,
    FriendAuditAuditing,
    FriendAuditNoSubmit
};

@interface GGFriendsList : NSObject

@property(nonatomic,copy)NSString *iconUrl;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userNamePinYin;
@property(nonatomic,strong)NSNumber *contactId;
@property(nonatomic,strong)NSNumber *statusId;
@property(nonatomic,assign)FriendAuditStatus auditingType;


@end


/*
 contactId = 123;
 iconUrl = "http://photo.iautos.cn/carinfo/sphoto/297/1937704.JPG";
 mobile = 13781819191;
 realName = cba;
 remark = bingo;
 userName = abc;
 userNamePinYin = G;

 */

