//
//  NSObject+Common.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#define kPath_ImageCache @"ImageCache"
#define kPath_ResponseCache @"ResponseCache"

#import "NSObject+Common.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import "GGSystemUpdateController.h"


@implementation NSObject (Common)

#pragma mark - Show Request Error Message

+ (BOOL)showError:(NSError *)error{
    NSString *tipStr = [NSObject tipFromError:error];
    if ([tipStr isEqualToString:@"TOKEN已过期"]) {
        tipStr = @"登录信息已过期，请重新登录";
    }
    
    [UIAlertView bk_showAlertViewWithTitle:@"" message:[NSString stringWithFormat:@"%@",tipStr] cancelButtonTitle:@"确定" otherButtonTitles:@[] handler:nil];
    return YES;
}

+ (BOOL)showError:(NSError *)error andTitle:(NSString *)title{
    NSString *tipStr = [NSObject tipFromError:error];
    [UIAlertView bk_showAlertViewWithTitle:title message:[NSString stringWithFormat:@"%@",tipStr] cancelButtonTitle:@"确定" otherButtonTitles:@[] handler:nil];
    return YES;
}

#pragma mark - Tip Or Alert Message
+ (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = nil;
        if (error.userInfo[@"responseMessage"]) {
            tipStr = error.userInfo[@"responseMessage"];
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}

+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && ![tipStr isKindOfClass:[NSNull class]] && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    }
}


+ (void)showStatusBarQueryStr:(NSString *)tipStr{
    [JDStatusBarNotification showWithStatus:tipStr styleName:JDStatusBarStyleSuccess];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
}
+ (void)showStatusBarSuccessStr:(NSString *)tipStr{
    if ([JDStatusBarNotification isVisible]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
            [JDStatusBarNotification showWithStatus:tipStr dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
        });
    }else{
        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
        [JDStatusBarNotification showWithStatus:tipStr dismissAfter:1.0 styleName:JDStatusBarStyleSuccess];
    }
}
+ (void)showStatusBarErrorStr:(NSString *)errorStr{
    if ([JDStatusBarNotification isVisible]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
            [JDStatusBarNotification setDefaultStyle:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                style.barColor = themeColor;
                style.textColor = [UIColor whiteColor];
                return style;
            }];
            [JDStatusBarNotification showWithStatus:errorStr dismissAfter:1.5 styleName:JDStatusBarStyleDefault];
        });
    }else{
        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
        [JDStatusBarNotification setDefaultStyle:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = themeColor;
            style.textColor = [UIColor whiteColor];
            return style;
        }];
        [JDStatusBarNotification showWithStatus:errorStr dismissAfter:1.5 styleName:JDStatusBarStyleDefault];
    }
}

+ (void)showStatusBarError:(NSError *)error{
    NSString *errorStr = [NSObject tipFromError:error];
    [NSObject showStatusBarErrorStr:errorStr];
}




#pragma mark - File Path Util
//获取fileName的完整地址
+ (NSString* )pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}
//创建缓存文件夹
+ (BOOL)createDirInCache:(NSString *)dirName{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}


// 图片缓存到本地
+ (BOOL) saveImage:(UIImage *)image imageName:(NSString *)imageName inFolder:(NSString *)folderName{
    if (!image) {
        return NO;
    }
    if (!folderName) {
        folderName = kPath_ImageCache;
    }
    if ([self createDirInCache:folderName]) {
        NSString * directoryPath = [self pathInCacheDirectory:folderName];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
        bool isSaved = false;
        if ( isDir == YES && existed == YES ){
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:imageName] options:NSAtomicWrite error:nil];
        }
        return isSaved;
    }else{
        return NO;
    }
}

// 获取缓存图片
+ (NSData *)loadImageDataWithName:( NSString *)imageName inFolder:(NSString *)folderName{
    if (!folderName) {
        folderName = kPath_ImageCache;
    }
    NSString * directoryPath = [self pathInCacheDirectory:folderName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( isDir == YES && dirExisted == YES ){
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@", directoryPath, imageName];
        BOOL fileExisted = [fileManager fileExistsAtPath:abslutePath];
        if (!fileExisted) {
            return NULL;
        }
        NSData *imageData = [NSData dataWithContentsOfFile : abslutePath];
        return imageData;
    }else{
        return NULL;
    }
}

// 删除图片缓存
+ (BOOL)deleteImageCacheInFolder:(NSString *)folderName{
    if (!folderName) {
        folderName = kPath_ImageCache;
    }
    return [self deleteCacheWithPath:folderName];
}

+ (BOOL)deleteCacheWithPath:(NSString *)cachePath{
    NSString *dirPath = [self pathInCacheDirectory:cachePath];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES ){
        isDeleted = [fileManager removeItemAtPath:dirPath error:nil];
    }
    return isDeleted;
}

#pragma mark - 检查实名认证是否通过
- (BOOL)checkRealNameAuthentication{
    if ([GGLogin shareUser].user.auditingType == AuditingTypePass) {
        return YES;
    }else{
        return NO;
    }
}

- (void)showAlertToRealNameAuthentionAction:(void (^)(void))confrimAction inViewController:(UIViewController *)controller{
    
    NSString *str = nil;
    NSString *buttonTitle = nil;
    
    if ([GGLogin shareUser].user.auditingType == AuditingTypeInvaild) {
        str =  @"审核未通过,请修改信息后重新提交";
        buttonTitle = @"去修改";
    }else if ([GGLogin shareUser].user.auditingType == AuditingTypeWillAudit){
        str =  @"实名认证审核中。如需加急处理,请联系客服:400-822-0063";
        buttonTitle = @"联系客服";
    }else {
        str =  @"为保证账户安全,需实名认证后才可进行交易";
        buttonTitle = @"去认证";
    }
    
    [UIAlertController alertInController:controller
                                   title:@"提示"
                                 message:str
                              confrimBtn:buttonTitle
                            confrimStyle:UIAlertActionStyleDestructive
                           confrimAction:^{
                               
                               if ([buttonTitle isEqualToString:@"联系客服"]) {
                                   NSString *str = [[NSString alloc] initWithFormat:@"tel:%@",@"4008220063"];
                                   UIWebView *callWebview = [[UIWebView alloc] init];
                                   [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                                   [controller.view addSubview:callWebview];
                                   return ;
                               }
                               
                               if (confrimAction) {
                                   confrimAction();
                               }
                           }
                               cancelBtn:@"取消"
                             cancelStyle:UIAlertActionStyleCancel
                            cancelAction:nil];
    

}

#pragma mark - NetError Handle

- (id)handleResponse:(id)responseJSON{
    return [self handleResponse:responseJSON autoShowError:YES];
}

#pragma mark - 处理responseCode
- (id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError{
    NSError *error = nil;
    //responseCode为非100000值时，表示有错
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"responseCode"];
    
    if (![resultCode isEqual:[NSNull null]] && resultCode.intValue != 100000) {
        error = [NSError errorWithDomain:BaseUrl code:resultCode.intValue userInfo:responseJSON];
        //登录超时或者token过期
        if (resultCode.intValue == 100003) {
            
            if ([GGLogin shareUser].isLogin) {
                [NSObject showError:error];
            }
            [[GGLogin shareUser] logOut];
            
            return error;
            
        }else if (resultCode.intValue == 888888){
            if ([GGLogin shareUser].isLogin) {
                [self showSystemUpdateViewController:error.userInfo[@"data"]];
            }
            return error;
        }
        [NSObject showError:error];
    }
    return error;
}

- (void)showSystemUpdateViewController:(NSString *)tipMessage
{
    if (![self isSystemUpdateStatus]) {
        UIViewController *viewController = [GGSystemUpdateController getVisibleViewController];
        GGSystemUpdateController *updateVC = [[GGSystemUpdateController alloc] init];
        updateVC.tipMessage = tipMessage;
        [viewController presentViewController:updateVC animated:YES completion:nil];
    }
}

- (BOOL)isSystemUpdateStatus
{
    UIViewController *viewController = [GGSystemUpdateController getVisibleViewController];
    if ([viewController isKindOfClass:[GGSystemUpdateController class]]) {
        return YES;
    }
    return NO;
}

@end
