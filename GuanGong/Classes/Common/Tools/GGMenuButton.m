//
//  GGMenuButton.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/24.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGMenuButton.h"

@implementation GGMenuButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.imageView.left < self.titleLabel.left) {
        self.titleLabel.left = self.imageView.left;
        self.imageView.left = self.titleLabel.right + 10;
    }
    
}

@end
