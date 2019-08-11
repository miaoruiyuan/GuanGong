//
//  GGOrderRecordsCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGOrderDetails.h"


UIKIT_EXTERN NSString * const kCellIdentifierOrderRecord;
@interface GGOrderRecordsCell : UITableViewCell

@property(nonatomic,strong)GGOrderRecords *orderRecords;


@end
