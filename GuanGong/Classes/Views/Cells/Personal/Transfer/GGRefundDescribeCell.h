//
//  GGRefundDescribeCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/12.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGOrderDetails.h"
#import "GGCarOrderDetail.h"

UIKIT_EXTERN NSString * const kCellIdentifierRefundDescribe;

@interface GGRefundDescribeCell : UITableViewCell

//退款金额
//@property(nonatomic,assign)CGFloat returnPrice;

@property(nonatomic,strong)GGOrderRecords *records;

@property(nonatomic,strong)GGCarOrderRecords *carRecords;

@end
