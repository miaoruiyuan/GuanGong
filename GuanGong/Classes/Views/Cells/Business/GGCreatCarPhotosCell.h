//
//  GGCreatCarPhotosCell.h
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGFormBaseCell.h"
#import "GGCreateCarViewModel.h"

typedef void(^OpenPhotoAlbum)();
typedef void(^OpenPhotoBroswer)(NSInteger index);
typedef void(^DeleteImageItem)(GGImageItem *delItem);

UIKIT_EXTERN NSString *const kCellIdentifierCreateCarPhotos;
@interface GGCreatCarPhotosCell : GGFormBaseCell

@property(nonatomic,strong)GGCreateCarViewModel *creatVM;
@property(nonatomic,copy)OpenPhotoAlbum openAlbum;
@property(nonatomic,copy)OpenPhotoBroswer openBroswer;
@property(nonatomic,copy)DeleteImageItem deleteItem;

+ (CGFloat)cellHeightWithObj:(id)obj;

@end
