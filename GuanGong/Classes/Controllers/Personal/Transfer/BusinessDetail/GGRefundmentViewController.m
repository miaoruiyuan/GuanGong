//
//  GGRefundmentViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRefundmentViewController.h"
#import "GGTitleDisclosureCell.h"
#import "GGInputOnlyTextPlainCell.h"
#import "GGRemarkCell.h"
#import "GGUploadImageCell.h"
#import "GGRefundViewModel.h"

@interface GGRefundmentViewController ()<QBImagePickerControllerDelegate>

@property(nonatomic,strong)GGRefundViewModel *refundVM;
//@property(nonatomic,strong)UIButton *submitButton;

@end

@implementation GGRefundmentViewController

- (id)initWithObject:(GGOrderDetails *)orderDetail{
    if (self = [super init]) {
        self.refundVM.orderDetail = orderDetail;
    }
    return self;
}
- (id)initWithCarOrderObject:(GGCarOrderDetail *)carOrderDetail{
    if (self = [super init]) {
        self.refundVM.carOrderDetail = carOrderDetail;
    }
    return self;
}

- (void)bindViewModel{
    [RACObserve(self.refundVM, photos)subscribeNext:^(id x) {
        [self.baseTableView reloadData];
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(0, 0, 50, 44);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:textLightColor forState:UIControlStateDisabled];

    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
    
    RAC(submitBtn,enabled) = self.refundVM.enableSubmit;
    
    @weakify(self);
    [[submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [MobClick event:@"submitrefund"];
        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        
        if (self.refundVM.orderDetail.transOrderRecords.count) {
            [[self.refundVM.reviseCommand execute:nil]subscribeError:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
            } completed:^{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showSuccess:@"申请已提交" toView:self.view];
                [self bk_performBlock:^(GGRefundmentViewController *obj) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:GGRefreshBuyerListNotification object:nil];
                    [obj dismissViewControllerAnimated:YES completion:^{
                        if (self.popHandler) {
                            self.popHandler(@1);
                        }
                    }];
                } afterDelay:1];
            }];
            
        }else{
            
            [[self.refundVM.submitCommand execute:nil] subscribeError:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
            } completed:^{
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showSuccess:@"申请已提交" toView:self.view];
                [self bk_performBlock:^(GGRefundmentViewController *obj) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:GGRefreshBuyerListNotification object:nil];
                    [obj dismissViewControllerAnimated:YES completion:^{
                        if (self.popHandler) {
                            self.popHandler(@1);
                        }
                    }];
                } afterDelay:1];
            }];
        }
        
    }];

}

- (void)setupView{
    self.navigationItem.title = @"退款申请";
   

    
    [self.baseTableView registerClass:[GGTitleDisclosureCell class] forCellReuseIdentifier:kCellIdentifierTitleDisclosure];
    [self.baseTableView registerClass:[GGInputOnlyTextPlainCell class] forCellReuseIdentifier:kCellIdentifierInputOnlyTextPlain];
    [self.baseTableView registerClass:[GGRemarkCell class] forCellReuseIdentifier:kCellIdentifierRemarkCell];
    [self.baseTableView registerClass:[GGUploadImageCell class] forCellReuseIdentifier:kCellIdentifierUploadImage];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}

#pragma mark -UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        NSArray *rows = 0;
        
        if (self.refundVM.orderDetail) {
           rows =  self.refundVM.orderDetail.transOrderRecords.count ? self.refundVM.orderDetail.transOrderRecords : self.refundVM.orderDetail.orderRecords;
        }else{
             rows =  self.refundVM.carOrderDetail.backOrderRecords.count ? self.refundVM.carOrderDetail.backOrderRecords : self.refundVM.carOrderDetail.payOrderRecords;
        }
        
        return rows.count;
    }else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGTitleDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierTitleDisclosure];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell setTitleStr:@"仅退款"];
            if ([self.refundVM.returnType isEqualToNumber:@9]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        
        }else{
            [cell setTitleStr:@"退货退款"];
            if ([self.refundVM.returnType isEqualToNumber:@24]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }

        }

        return cell;
    }else if (indexPath.section == 1){
        GGInputOnlyTextPlainCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierInputOnlyTextPlain];
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        if (indexPath.row == 0) {
            [cell configWithPlaceholder:@"输入退款金额" valueStr:self.refundVM.returnPrice secureTextEntry:NO];
            cell.textValueChangedBlock = ^(NSString *price){
                self.refundVM.returnPrice = price;
            };
        }else{
            [cell configWithPlaceholder:@"输入退尾款金额" valueStr:self.refundVM.returnFinalPrice secureTextEntry:NO];
            cell.textValueChangedBlock = ^(NSString *price){
                self.refundVM.returnFinalPrice = price;
            };
        }
        return cell;
        
    }else if (indexPath.section == 2){
    
        GGRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierRemarkCell];
        RAC(self.refundVM,refundRemark) = [cell.remarkTextView.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
    }else{
        GGUploadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierUploadImage];
        cell.imageArray = [self.refundVM.photos mutableCopy];
        cell.addPicturesBlock = ^(){
            [self showActionForPhoto];
        };
        cell.deleteTweetImageBlock = ^(GGImageItem *toDelete){
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.refundVM.photos];
            [array removeObject:toDelete];
            self.refundVM.photos = array;
        };
        return cell;
    }
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.refundVM footerTipAtSection:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        return [GGUploadImageCell cellHeightWithArray:[self.refundVM.photos mutableCopy]];
    }else if (indexPath.section == 3){
        return 110;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        self.refundVM.returnType = @9;
    }else{
        self.refundVM.returnType = @24;
    }
    [tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ActionSheet
- (void)showActionForPhoto{
    
    [UIAlertController actionSheetInController:self
                                         title:nil
                                       message:nil
                                    confrimBtn:@[@"拍照上传",@"从相册选择"]
                                  confrimStyle:UIAlertActionStyleDefault
                                 confrimAction:^(UIAlertAction *action, NSInteger index) {
                                     
                                     
                                     if (index == 0) {
                                         //拍照
                                         if (![Helper checkCameraAuthorizationStatus]) {
                                             return;
                                         }
                                         UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                         [self presentViewController:picker animated:YES completion:nil];
                                         [picker.rac_imageSelectedSignal subscribeNext:^(NSDictionary *info) {
                                             UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
                                             [picker dismissViewControllerAnimated:YES completion:^{
                                                 GGImageItem *imageItem = [GGImageItem imageWithImage:originalImage];
                                                 [self uploadImageWithItem:imageItem];
                                             }];
                                         }];
                                         
                                         [[picker.rac_delegateProxy signalForSelector:@selector(imagePickerControllerDidCancel:)] subscribeNext:^(id x) {
                                             [picker dismissViewControllerAnimated:YES completion:nil];
                                         }];

                                     }else if (index == 1){
                                         [self openPhotoAlbum];
                                     }
                                 }
                                     cancelBtn:@"取消"
                                   cancelStyle:UIAlertActionStyleCancel
                                  cancelAction:nil];
    
}

- (void)openPhotoAlbum{
    if (![Helper checkPhotoLibraryAuthorizationStatus]) {
        return;
    }
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 4 - self.refundVM.photos.count;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark -QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        for (PHAsset *asset in assets) {
            GGImageItem *imageItem = [GGImageItem imageWithPHAsset:asset];
            [self uploadImageWithItem:imageItem];
        }
    }];
}

- (void)uploadImageWithItem:(GGImageItem *)imageItem
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        hud.labelText = @"上传中";
        hud.removeFromSuperViewOnHide = YES;
        @weakify(self);
        [[GGHttpSessionManager sharedClient] uploadImage:[UIImage imageWithData:imageItem.imageData]
                                               imageType:UpLoadNormalImage
                                           progerssBlock:^(CGFloat progressValue) {
                                               hud.progress = progressValue;
                                           }
                                                andBlock:^(id data, NSError *error) {
                                                    @strongify(self);
                                                    [hud hide:YES];
                                                    NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:self.refundVM.photos];
                                                    imageItem.photoUrl = data[@"url"];
                                                    [itemsArray addObject:imageItem];
                                                    self.refundVM.photos = itemsArray;
                                                }];
        
    });
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

//
//- (UIButton *)submitButton{
//    if (!_submitButton) {
//        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _submitButton.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
//        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
//        [_submitButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
//        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [self.view addSubview:_submitButton];
//        
//    }
//    return _submitButton;
//}


- (GGRefundViewModel *)refundVM{
    if (!_refundVM) {
        _refundVM = [[GGRefundViewModel alloc] init];
    }
    return _refundVM;
}

@end
