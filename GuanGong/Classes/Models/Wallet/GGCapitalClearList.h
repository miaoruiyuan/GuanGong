//
//  GGCapitalClearList.h
//  GuanGong
//
//  Created by 苗芮源 on 16/8/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGCapitalClearList : NSObject

@property(nonatomic,copy)NSString *accountNo;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *bankName;
@property(nonatomic,copy)NSString *createTimeStr;
@property(nonatomic,copy)NSString *pic1;
@property(nonatomic,copy)NSString *pic2;
@property(nonatomic,copy)NSString *pic3;
@property(nonatomic,copy)NSString *pic4;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,copy)NSString *statusStr;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *updateTimeStr;
@property(nonatomic,strong)NSNumber *applyId;
@property(nonatomic,copy)NSString *auditRemark;

@end



/*
 {
 accountNo = "<null>";
 amount = "258999.00";
 applyUserName = "<null>";
 auditRemark = "<null>";
 auditTime = "<null>";
 auditTimeStr = "<null>";
 bankName = "<null>";
 createTime = 1472196849000;
 createTimeStr = "2016-08-26 15:34:09";
 frontLogNo = "<null>";
 id = 6;
 operUserName = "<null>";
 pic1 = "<null>";
 pic2 = "<null>";
 pic3 = "<null>";
 pic4 = "<null>";
 status = 0;
 statusStr = "\U7b49\U5f85\U5904\U7406";
 title = "Gffffffccccc(5555)";
 updateTime = 1472196849000;
 updateTimeStr = "2016-08-26 15:34:09";
 }

 */

