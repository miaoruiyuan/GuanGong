//
//  GGRefuseRefundViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/14.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGRefuseRefundViewController.h"
#import "GGRemarkCell.h"
#import "GGUploadImageCell.h"
#import "GGUploadDealInfoViewModel.h"

@interface GGRefuseRefundViewController ()<QBImagePickerControllerDelegate>
@property(nonatomic,strong)UIButton *submitButton;

@property(nonatomic,strong)GGUploadDealInfoViewModel *dealInfoVM;


@end

@implementation GGRefuseRefundViewController

- (void)bindViewModel{
    self.dealInfoVM.isAgree  = NO;
    
    [RACObserve(self.dealInfoVM, photos)subscribeNext:^(id x) {
        [self.baseTableView reloadData];
    }];
    
    RAC(self.submitButton,enabled) = self.dealInfoVM.enableRefuseSubmit;
}
- (void)setupView{
    self.navigationItem.title = @"拒绝退款";
    [self.baseTableView registerClass:[GGRemarkCell class] forCellReuseIdentifier:kCellIdentifierRemarkCell];
    [self.baseTableView registerClass:[GGUploadImageCell class] forCellReuseIdentifier:kCellIdentifierUploadImage];
    
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.submitButton.mas_top);
    }];
    
    
    @weakify(self);
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        @strongify(self);
        
        [[self.dealInfoVM.submitRefuseCommand execute:self.orderNo]subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
        } completed:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
            [self bk_performBlock:^(GGRefuseRefundViewController *obj) {
                if (obj.popHandler) {
                    obj.popHandler(@1);
                }
                [obj dismiss];
            } afterDelay:1];
        }];

    }];
}




#pragma mark -UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GGRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierRemarkCell];
        RAC(self.dealInfoVM,remark) = [cell.remarkTextView.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal];
        return cell;
        
    }else{
     
        GGUploadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierUploadImage];
        cell.imageArray = [self.dealInfoVM.photos mutableCopy];
        cell.addPicturesBlock = ^(){
            [self showActionForPhoto];
        };
        cell.deleteTweetImageBlock = ^(GGImageItem *toDelete){
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.dealInfoVM.photos];
            [array removeObject:toDelete];
            self.dealInfoVM.photos = array;
            
            
        };
        return cell;

    }
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"填写拒绝退款原因";
            break;
            
        default:
            return @"上传凭证,最多可为4张";
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }else{
        return [GGUploadImageCell cellHeightWithArray:[self.dealInfoVM.photos mutableCopy]];
    }
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
    imagePickerController.maximumNumberOfSelection = 4 - self.dealInfoVM.photos.count;
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

        [[GGHttpSessionManager sharedClient]uploadImage:[UIImage imageWithData:imageItem.imageData]
                                              imageType:UpLoadNormalImage
                                          progerssBlock:^(CGFloat progressValue) {
                                              hud.progress = progressValue;
                                              
                                          } andBlock:^(NSDictionary *data, NSError *error) {
                                              [hud hide:YES];
                                              @strongify(self);
                                              NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:self.dealInfoVM.photos];

                                              imageItem.photoUrl = data[@"url"];
            
                                              [itemsArray addObject:imageItem];
                                              self.dealInfoVM.photos = itemsArray;
                                              
                                          }];

        
    });
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}


- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(0, self.view.height - 44, self.view.width, 44);
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.view addSubview:_submitButton];
        
    }
    return _submitButton;
}



- (GGUploadDealInfoViewModel *)dealInfoVM{
    if (!_dealInfoVM) {
        _dealInfoVM = [[GGUploadDealInfoViewModel alloc] init];
    }
    return _dealInfoVM;
}



@end
