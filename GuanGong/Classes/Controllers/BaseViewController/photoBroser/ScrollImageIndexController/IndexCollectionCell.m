//
//  IndexCollectionCell.m
//  BigImageShow
//
//  Created by liuyan on 16/8/10.
//  Copyright © 2016年 liuyan. All rights reserved.
//

#import "IndexCollectionCell.h"

@implementation IndexCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected
{
    if (selected) {
        DLog(@"yes");
        self.imageView.layer.borderWidth = 2.0;
        self.imageView.layer.borderColor = themeColor.CGColor;
        self.layer.masksToBounds = YES;
    }else{
        self.imageView.layer.borderWidth = 0.0;
        self.imageView.layer.borderColor = themeColor.CGColor;
        self.layer.masksToBounds = YES;
        DLog(@"no");
    }
}

@end
