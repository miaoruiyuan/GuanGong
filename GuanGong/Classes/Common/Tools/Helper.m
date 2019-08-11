//
//  Helper.m
//  Coding_iOS
//
//  Created by Elf Sundae on 14-12-22.
//  Copyright (c) 2014年 Coding. All rights reserved.
//
#define lineViewTag 778825

#import "Helper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation Helper

+ (BOOL)checkPhotoLibraryAuthorizationStatus{
    ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
    if (ALAuthorizationStatusDenied == authStatus ||
        ALAuthorizationStatusRestricted == authStatus) {
        [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkCameraAuthorizationStatus{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [MBProgressHUD showError:@"该设备不支持拍照" toView:nil];
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
            return NO;
        }
    }
    
    return YES;
}

+ (void)showSettingAlertStr:(NSString *)tipStr{
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"提示" message:tipStr];
        [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
        [alertView bk_addButtonWithTitle:@"设置" handler:nil];
        [alertView bk_setDidDismissBlock:^(UIAlertView *alert, NSInteger index) {
            if (index == 1) {
                UIApplication *app = [UIApplication sharedApplication];
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([app canOpenURL:settingsURL]) {
                    [app openURL:settingsURL];
                }
            }
        }];
        [alertView show];
    }else{
        
    }
}

#pragma mark ===
#pragma mark === 给目标View 画线
+ (void)addDashedLineInView:(UIView *)view andFrame:(CGRect)frame andIfRealDiagram:(BOOL)realDiagram andLineColor:(NSString *)lineColor;
{
    if (realDiagram) {
        UIView *lineView = [[UIView alloc]initWithFrame:frame];
        lineView.backgroundColor = [UIColor colorWithHexString:lineColor];
        lineView.tag = lineViewTag;
        [view addSubview:lineView];
    }else{
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        //    [shapeLayer setBounds:frame];
        //    [shapeLayer setPosition:view.center];
        [shapeLayer setFrame:frame];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        
        // 设置虚线颜色
        [shapeLayer setStrokeColor:[[UIColor colorWithHexString:lineColor] CGColor]];
        
        // 3.0f设置虚线的宽度
        [shapeLayer setLineWidth:1.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        
        // 3=线的宽度 1=每条线的间距
        [shapeLayer setLineDashPattern:
         [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
          [NSNumber numberWithInt:1],nil]];
        
        //设置倾斜度
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, kScreenWidth,0);
        
        [shapeLayer setPath:path];
        CGPathRelease(path);
        
        [[view layer] addSublayer:shapeLayer];
        
    }
    
    
}

@end
