//
//  GGCapitalClearApplyViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/8/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCapitalClearApplyViewController.h"
#import "GGCapitalClearListViewController.h"
#import "GGInputOnlyTextPlainCell.h"
#import "GGUploadImageCell.h"
#import "GGCapitalClearViewModel.h"

@interface GGCapitalClearApplyViewController ()<QBImagePickerControllerDelegate>

@property(nonatomic,strong)GGCapitalClearViewModel *capitalClearVM;
@property(nonatomic,strong)UIButton *submitButton;


@end

@implementation GGCapitalClearApplyViewController

- (void)bindViewModel{
    
    [[RACObserve(self.capitalClearVM, photos) skip:1]subscribeNext:^(id x) {
        [self.baseTableView reloadRow:3 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    
    RAC(self.submitButton,enabled) = self.capitalClearVM.enableSubmitSignal;
    
}

- (void)setupView
{
    self.navigationItem.title = @"清分申请";
    [self.baseTableView registerClass:[GGInputOnlyTextPlainCell class] forCellReuseIdentifier:kCellIdentifierInputOnlyTextPlain];
    [self.baseTableView registerClass:[GGUploadImageCell class] forCellReuseIdentifier:kCellIdentifierUploadImage];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    [self.baseTableView setTableFooterView:[self tableFooterView]];
    //提交申请
    @weakify(self);
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showMessage:@"请稍后" toView:self.view];
        [MobClick event:@"submitapplication"];
        [[self.capitalClearVM.submitCommand execute:nil] subscribeError:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
        } completed:^{
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"申请成功" toView:self.view];
            [self bk_performBlock:^(GGCapitalClearApplyViewController *obj) {
                [obj dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:GGCapitalClearApplySuccessNotification object:nil];
            } afterDelay:1.1];
        }];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"申请记录" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self);
        [self pushCapitalList];
        [MobClick event:@"applicationrecord"];
    }];
    
}

#pragma marl - Tb
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 3) {
        GGInputOnlyTextPlainCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierInputOnlyTextPlain];
        
        switch (indexPath.row) {
            case 0:{
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                [cell configWithPlaceholder:@"输入充值金额" valueStr:self.capitalClearVM.amount secureTextEntry:NO];
                cell.textValueChangedBlock = ^(NSString *text){
                    self.capitalClearVM.amount = text;
                };
            }
                break;
                
            case 1:{
                [cell configWithPlaceholder:@"输入银行名称" valueStr:self.capitalClearVM.bankName secureTextEntry:NO];
                cell.textValueChangedBlock = ^(NSString *text){
                    self.capitalClearVM.bankName = text;
                };
            }
                break;

            default:{
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                [cell configWithPlaceholder:@"输入银行卡卡号" valueStr:self.capitalClearVM.accountNo secureTextEntry:NO];
                cell.textValueChangedBlock = ^(NSString *text){
                    self.capitalClearVM.accountNo = text;
                };
            }
                break;
        }
        
        
        return cell;
    }else{
        GGUploadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierUploadImage];
        cell.imageArray = [self.capitalClearVM.photos mutableCopy];
        cell.addPicturesBlock = ^(){
            [self openPhotoAlbum];
        };
        [cell setTitle:@"充值凭证" andMaxPhotoCount:3];
        cell.deleteTweetImageBlock = ^(GGImageItem *toDelete){
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.capitalClearVM.photos];
            [array removeObject:toDelete];
            self.capitalClearVM.photos = array;
        };
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kLeftPadding hasSectionLine:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return [GGUploadImageCell cellHaveTitleHeightWithArray:[self.capitalClearVM.photos mutableCopy]];
    }
    return 46;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.width - 40, 40)];
        label.numberOfLines = 0;
        label.textColor = textLightColor;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"为了审核更快,请尽量提供充值凭证.如:充值记录凭证等.";
        
        [view addSubview:label];
        
        
        return view;
    }else{
        return nil;
    }
   
}

- (void)openPhotoAlbum{
    
    if (![Helper checkPhotoLibraryAuthorizationStatus]) {
        return;
    }
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 3 - self.capitalClearVM.photos.count;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark -QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    
    [imagePickerController dismissViewControllerAnimated:YES completion:^{

        for (PHAsset *asset in assets) {
            GGImageItem *imageItem = [[GGImageItem alloc] init];
            
            [asset fetchThumbnailImage:^(UIImage *image) {
                imageItem.thumbnailImage = image;
            }];
            
            [asset fetchImage:GGFetchImageTypeOrigin synchronous:YES resultBlock:^(UIImage *image) {
                [self uploadImage:image andImageItem:imageItem];
            }];
        }
    }];
}

- (void)uploadImage:(UIImage *)image andImageItem:(GGImageItem *)imageItem
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        hud.labelText = @"上传中";
        hud.removeFromSuperViewOnHide = YES;
        
        @weakify(self);
        [[GGHttpSessionManager sharedClient] uploadImage:image
                                               imageType:UpLoadNormalImage
                                           progerssBlock:^(CGFloat progressValue) {
                                               hud.progress = progressValue;
                                           }
                                                andBlock:^(id data, NSError *error) {
                                                    @strongify(self);
                                                    [hud hide:YES];
                                                    NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:self.capitalClearVM.photos];
                                                    imageItem.photoUrl = data[@"url"];
                                                    [itemsArray addObject:imageItem];
                                                    self.capitalClearVM.photos = itemsArray;
                                                }];
        
    });
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}


- (void)pushCapitalList{
    GGCapitalClearListViewController *listVC = [[GGCapitalClearListViewController alloc] init];
    [self pushTo:listVC];
}




- (UIView *)tableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    [view addSubview:self.submitButton];
    return view;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(20, 18, kScreenWidth - 40, 44);
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 3;
        [_submitButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _submitButton;
}


- (GGCapitalClearViewModel *)capitalClearVM{
    if (!_capitalClearVM) {
        _capitalClearVM = [[GGCapitalClearViewModel alloc] init];
    }
    return _capitalClearVM;
}

@end
