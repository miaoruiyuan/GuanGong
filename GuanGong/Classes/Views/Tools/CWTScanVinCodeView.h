//
//  CWTScanVinCodeView.h
//  CheWangTong
//
//  Created by 苗芮源 on 2017/3/31.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScanBGView;

@interface CWTScanVinCodeView : UIView
@property(nonatomic,assign)UIImagePickerControllerSourceType sourceType;
@property(nonatomic,strong)UIImagePickerController *picker;
@property (nonatomic, copy) void(^takePhotoBlock)(UIImage *image);
//@property (nonatomic, copy) void(^cancelBlock)();

@end


@interface ScanBGView : UIView
@property (assign, nonatomic) CGRect scanRect;
@end
