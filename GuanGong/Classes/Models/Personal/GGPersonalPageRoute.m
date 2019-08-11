//
//  GGPersonalPageRoute.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/29.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPersonalPageRoute.h"
#import "GGBaseViewController.h"
#import "GGMineQrCodeViewController.h"
#import "GGInputViewController.h"
#import "GGLocationViewController.h"
#import "GGManagerAddressViewController.h"
#import "GGAttestationViewController.h"
#import "GGBanksViewController.h"
#import "GGBankCountrywideViewController.h"
#import "GGBankAddressViewController.h"
#import "MJPhotoBrowser.h"
#import "GGAttestationCompanyController.h"
#import "GGPrivateFileUploadViewModel.h"
#import "GGMinePhoneViewController.h"
#import "GGManagerAddressViewController.h"

@implementation GGPersonalPageRoute

+(void)pushWithItem:(GGFormItem *)item nav:(UINavigationController *)nav callBack:(void(^)(id x))callBack{
    
    GGBaseViewController *viewController = nil;
    
    if (!item.canEdit) {
        return;
    }
 
    //    --------------个人信息页面--------------

    //输入框 （昵称）
    if (item.pageType == GGPageTypeInput) {
        viewController = [[GGInputViewController alloc] initWithItem:item];
        if ([@"昵称" isEqualToString:item.title]) {
            [MobClick event:@"petname"];
        }
    }
    //所在地
    if (item.pageType == GGPageTypeCityList) {
        viewController = [[GGLocationViewController alloc] initWithItem:item];
        [MobClick event:@"city"];
    }
    
    //我的地址
    if (item.pageType == GGPageTypeManagerAddress) {
        viewController = [[GGManagerAddressViewController alloc] initWithItem:item];
        [MobClick event:@"company"];
    }
    
    //实名认证
    if (item.pageType == GGPageTypeRealNameAuth) {
        viewController = [[GGAttestationViewController alloc]init];
        [MobClick event:@"certification"];
    }
    //企业认证
    if (item.pageType == GGPageTypeRealCompanyAuth) {
        viewController = [[GGAttestationCompanyController alloc] init];
//        [MobClick event:@"certification"];
    }
    //二维码
    if (item.pageType == GGPageTypeUserQrCode) {
        viewController = [[GGMineQrCodeViewController alloc]init];
        [MobClick event:@"myqrcode"];
    }
    
//    --------------添加银行卡--------------
    //开户行
    if (item.pageType == GGPageTypeBanksList) {
        viewController = [[GGBanksViewController alloc]initWithFormItem:item];
    }

    //开户地址
    if (item.pageType == GGPageTypeBanksAddress) {
        viewController = [[GGBankCountrywideViewController alloc] initWithItem:item];
    }
    
    //收货地址
    if (item.pageType == GGPageTypeAddressManager) {
        viewController = [[GGManagerAddressViewController alloc] initWithItem:item];
    }
    //更改手机号
    if (item.pageType == GGPageTypeChangePhone) {
        viewController = [[GGMinePhoneViewController alloc] initWithItem:item];
    }
    
    viewController.popHandler = callBack;
    [nav pushViewController:viewController animated:YES];
}


+ (void)ShowActionSheet:(GGFormItem *)item formViewController:(UIViewController *)controller callBack:(void(^)(id x))callBack{
    
    [UIAlertController actionSheetInController:controller
                                         title:@"设置头像"
                                       message:nil
                                    confrimBtn:@[@"查看大图",@"拍照上传",@"从相册选择"]
                                  confrimStyle:UIAlertActionStyleDefault
                                 confrimAction:^(UIAlertAction *action, NSInteger index) {
                                     
                                     if (index == 0){
                                         MJPhoto *photo = [[MJPhoto alloc] init];
                                         photo.url = [NSURL URLWithString:[GGLogin shareUser].user.headPic];
                                         MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                                         browser.showSaveBtn = NO;
                                         browser.photos = [NSArray arrayWithObject:photo];
                                         [browser show];
                                         return;
                                     }
                                     
                                     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                     picker.allowsEditing = YES;
                                     
                                     if (index == 1) {
                                         //拍照
                                         if (![Helper checkCameraAuthorizationStatus]) {
                                             return;
                                         }
                                         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     }else if (index == 2){
                                         //相册
                                         if (![Helper checkPhotoLibraryAuthorizationStatus]) {
                                             return;
                                         }
                                         picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                         
                                     }
                                     
                                     [controller presentViewController:picker animated:YES completion:nil];
                                     
                                     [picker.rac_imageSelectedSignal subscribeNext:^(NSDictionary *info) {
                                         UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
                                         // 保存原图片到相册中
                                         if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                                             UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
                                         }
                                         
                                         [picker dismissViewControllerAnimated:YES completion:^{
                                             
                                             [MBProgressHUD showMessage:@"上传中..."];
                                             [[GGHttpSessionManager sharedClient] uploadImage:originalImage
                                                                                    imageType:UpLoadNormalImage
                                                                                progerssBlock:^(CGFloat progressValue) {
                                                                                    
                                                                                }
                                                                                     andBlock:^(NSDictionary *data, NSError *error) {
                                                                                         [MBProgressHUD showSuccess:@"上传成功" toView:controller.view];
                                                                                         item.obj = data[@"url"];
                                                                                         callBack(item);
                                                                                     }];
                                             
                                         }];
                                     }];
                                     
                                     [[picker.rac_delegateProxy signalForSelector:@selector(imagePickerControllerDidCancel:)]subscribeNext:^(id x) {
                                         
                                         [picker dismissViewControllerAnimated:YES completion:nil];
                                     }];
                                     
                                     
                                 }
                                     cancelBtn:@"取消"
                                   cancelStyle:UIAlertActionStyleCancel
                                  cancelAction:nil];
}


+ (void)presentImagePickerControllerWith:(GGFormItem *)item formViewController:(UIViewController *)controller callBack:(void(^)(id x))callBack{

    [UIAlertController actionSheetInController:controller
                                         title:nil
                                       message:nil
                                    confrimBtn:@[@"拍照上传",@"从相册选择"]
                                  confrimStyle:UIAlertActionStyleDefault
                                 confrimAction:^(UIAlertAction *action, NSInteger index) {
                                     
                                     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                     
                                     if (index == 0) {
                                         //拍照
                                         if (![Helper checkCameraAuthorizationStatus]) {
                                             return;
                                         }
                                         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     }else if (index == 1){
                                         //相册
                                         if (![Helper checkPhotoLibraryAuthorizationStatus]) {
                                             return;
                                         }
                                         picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                         
                                     }
                                     
                                     [controller presentViewController:picker animated:YES completion:nil];
                                     
                                     [picker.rac_imageSelectedSignal subscribeNext:^(NSDictionary *info) {
                                         UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
                                         // 保存原图片到相册中
                                         if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                                             UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
                                         }
                                       
                                         [picker dismissViewControllerAnimated:YES completion:^{
                                             
                                             [MBProgressHUD showMessage:@"上传中..."];
                                            
                                             [[GGPrivateFileUploadViewModel sharedClient] uploadQNPrivateImage:originalImage imageMaxSize:1080 imageMaxKb:500 progerssBlock:^(CGFloat progressValue) {
                                                 
                                             } andBlock:^(id data, NSError *error) {
                                                 [MBProgressHUD hideHUD];
                                                 if (!error) {
                                                     [MBProgressHUD showSuccess:@"上传成功" toView:controller.view];
                                                     item.obj = data;
                                                     callBack(item);
                                                 }else{
                                                     [MBProgressHUD showSuccess:@"上传失败请重试！" toView:controller.view];
                                                 }
                                             }];
                                         }];
                                     }];
                                     
                                     [[picker.rac_delegateProxy signalForSelector:@selector(imagePickerControllerDidCancel:)]subscribeNext:^(id x) {
                                         
                                         [picker dismissViewControllerAnimated:YES completion:nil];
                                     }];

                                 }
                                     cancelBtn:@"取消"
                                   cancelStyle:UIAlertActionStyleCancel
                                  cancelAction:nil];
}

@end
