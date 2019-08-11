//
//  GGUploadImageCell.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGImageItem.h"

UIKIT_EXTERN NSString * const kCellIdentifierUploadImage;

@interface GGUploadImageCell : UITableViewCell

@property (copy, nonatomic) void(^addPicturesBlock)();
@property (copy, nonatomic) void (^deleteTweetImageBlock)(GGImageItem *toDelete);

@property(nonatomic,strong)NSMutableArray *imageArray;

- (void)setTitle:(NSString *)title andMaxPhotoCount:(NSInteger)maxPhotoCount;

+ (CGFloat)cellHeightWithArray:(NSMutableArray *)array;
+ (CGFloat)cellHaveTitleHeightWithArray:(NSMutableArray *)array;

@end



UIKIT_EXTERN NSString * const kCellIdentifierImageCell;

@interface GGImageCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) GGImageItem *curImage;
@property (copy, nonatomic) void (^deleteTweetImageBlock)(GGImageItem *toDelete);
+(CGSize)ccellSize;

@end
