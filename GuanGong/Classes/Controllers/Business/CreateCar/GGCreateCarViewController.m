//
//  GGCreateCarViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCreateCarViewController.h"
#import "GGCreatCarNormalCell.h"
#import "GGCreatCarRemarkCell.h"
#import "GGCreatCarPhotosCell.h"
#import "GGCreatCarLocationCell.h"
#import "GGCreateCarModelNameCell.h"

#import "GGCreateCarViewModel.h"
#import "GGCreateCarPageRoute.h"
#import "GGPhotoBroswerTransitionAnimator.h"
#import "GGPhotoBroswerViewController.h"
#import "PYPhotosPreviewController.h"

#import "MJPhotoBrowser.h"

@interface GGCreateCarViewController ()<QBImagePickerControllerDelegate,UIViewControllerTransitioningDelegate>

@property(nonatomic,strong)UIButton *releaseButton;
@property(nonatomic,strong)GGCreateCarViewModel *createVM;

@end

@implementation GGCreateCarViewController{
    NSDictionary *_identifiers;
}

- (id)initWithObject:(GGCar *)car{
    if (self = [super init]) {
        _createVM = [[GGCreateCarViewModel alloc] initWithEditCar:car];
    }
    return self;
}

- (void)bindViewModel{
   
    @weakify(self);
    [RACObserve(self.createVM, dataSource)subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseTableView reloadData];
        });
    }];
    
    //Vin
    [[RACObserve(self.createVM.car, vin) skip:1] subscribeNext:^(NSString *x) {
        @strongify(self);
        [self.createVM.vinCommand execute:x];
    }];
    
    //监听Vin
    [[[self.createVM.vinCommand.executing skip:1] deliverOnMainThread] subscribeNext:^(NSNumber *x) {
        if (x.boolValue) {
            [MBProgressHUD showMessage:@"查找中..." toView:self.view];
        } else {
            [MBProgressHUD hideHUDForView:self.view];
            if (self.createVM.car.vinUsed) {
                [self bk_performBlock:^(id obj) {
                    [MBProgressHUD showError:@"VIN已使用" toView:self.view];
                } afterDelay:0.3f];
            }
            if (self.createVM.modelList.count == 0) {
                [self bk_performBlock:^(id obj) {
                    [MBProgressHUD showError:@"暂无此VIN车型信息" toView:self.view];
                } afterDelay:0.3f];
            }
        }
    }];
}

- (void)setupView{
    
    if (self.createVM.isEditCar) {
        self.navigationItem.title = @"发布";
    }else{
        self.navigationItem.title = @"编辑";
    }
    
    [self.baseTableView registerClass:[GGCreatCarNormalCell class] forCellReuseIdentifier:kCellIdentifierCreateCarNormal];
    
    [self.baseTableView registerClass:[GGCreateCarModelNameCell class] forCellReuseIdentifier:kGGCreateCarModelNameCellID];
    
    [self.baseTableView registerClass:[GGCreatCarRemarkCell class] forCellReuseIdentifier:kCellIdentifierCreateCarRemark];
    [self.baseTableView registerClass:[GGCreatCarPhotosCell class] forCellReuseIdentifier:kCellIdentifierCreateCarPhotos];
    [self.baseTableView registerClass:[GGCreatCarLocationCell class] forCellReuseIdentifier:kCellIdentifierCreateCarLocation];
    self.baseTableView.estimatedRowHeight = 46;
    
    _identifiers = @{@(GGFormCellTypeNormal):kCellIdentifierCreateCarNormal,
                     @(GGFormCellTypeTextView):kCellIdentifierCreateCarRemark,
                     @(GGFormCellTypeCollection):kCellIdentifierCreateCarPhotos,
                     @(GGFormCellTypeCarModelName):kGGCreateCarModelNameCellID,
                     @(GGFormCellTypeCarLocation):kCellIdentifierCreateCarLocation};
    
    
    @weakify(self);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"close_x"] style:UIBarButtonItemStylePlain handler:^(UIBarButtonItem *sender) {
        @strongify(self);
        [self.view endEditing:YES];
        if (![self.createVM checkCompare]) {
            [UIAlertController alertInController:self title:@"是否保存草稿?" message:@"部分信息未填完" confrimBtn:@"保存" confrimStyle:UIAlertActionStyleDefault confrimAction:^{
                [self.createVM saveSendData];
                [self dismiss];
            } cancelBtn:@"不保存" cancelStyle:UIAlertActionStyleCancel cancelAction:^{
                [self.createVM deleteSendDataWithEndBlock:^(BOOL error) {
                    [self dismiss];
                }];
            }];
            return ;
        }
        
        [self dismiss];
    }];
    
    [self.view addSubview:self.releaseButton];
    [self.releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(48);
    }];
    
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.releaseButton.mas_top);
    }];
    
    //发布
    RAC(self.releaseButton,enabled) = self.createVM.enableReleaseSignal;
    [[self.releaseButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        @strongify(self);
        [self.view endEditing:YES];
        if ([self.createVM canSend]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [[self.createVM.upLoadPhotosCommand execute:nil]subscribeCompleted:^{
                    [self.createVM.releaseCommand execute:nil];
                }];
                
                if (!self.createVM.car.carId) {
                    [self.createVM saveSendData];
                }
            }];
            
        }
    }];
    
}


#pragma mark - Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.createVM sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.createVM itemCountAtSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.createVM itemForIndexPath:indexPath];
    GGFormBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifiers[@(item.cellType)]];
    
    if (item.cellType == GGFormCellTypeCollection) {
        GGCreatCarPhotosCell *photosCell = (GGCreatCarPhotosCell *)cell;
        RAC(photosCell,creatVM) = [RACObserve(self, createVM)takeUntil:photosCell.rac_prepareForReuseSignal];
        photosCell.openAlbum = ^(){
            [self openPhotoAlnum];
        };
        
        photosCell.openBroswer = ^(NSInteger index){
            [self openPhotoBroswerWithIndex:index];
        };
        
        photosCell.deleteItem = ^(GGImageItem *carImg){
            [self.createVM deleteCarImage:carImg];
            [self.baseTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
        };
        
    }
    
    if (item.cellType == GGFormCellTypeTextView) {
        GGCreatCarRemarkCell *remarkCell = (GGCreatCarRemarkCell *)cell;
        remarkCell.item = item;
        [remarkCell setEditEndBlock:^(GGFormItem *item) {
            [self.createVM.reloadData execute:item];
        }];
    }
    
    [cell configItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:14]; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGFormItem *item = [self.createVM itemForIndexPath:indexPath];
    if (item.cellType == GGFormCellTypeTextView) {
        return 144;
    }
    
    if (item.cellType == GGFormCellTypeCollection) {
        return [GGCreatCarPhotosCell cellHeightWithObj:self.createVM];
    }
    
    if (item.cellType == GGFormCellTypeCarLocation) {
        return UITableViewAutomaticDimension;
    }
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GGFormItem *item = [self.createVM itemForIndexPath:indexPath];
    
    if (item.cellType != GGFormCellTypeTextView && item.cellType != GGFormCellTypeCollection){
        @weakify(self);
        [GGCreateCarPageRoute pushWithItem:item nav:self.navigationController callBack:^(GGFormItem *item) {
            @strongify(self);
            [self.createVM.reloadData execute:item];
        }];
    }
}

- (void)openPhotoAlnum{
    [UIAlertController actionSheetInController:self title:nil message:nil confrimBtn:@[@"相册",@"相机"] confrimStyle:UIAlertActionStyleDefault confrimAction:^(UIAlertAction *action, NSInteger index) {
        
        if (index == 0) {
            if (![Helper checkPhotoLibraryAuthorizationStatus]) {
                return;
            }
            QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
            imagePickerController.mediaType = QBImagePickerMediaTypeImage;
            [imagePickerController.selectedAssets removeAllObjects];
            [imagePickerController.selectedAssets addObjectsFromArray:self.createVM.assetArray];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.maximumNumberOfSelection = 12;
            [self presentViewController:imagePickerController animated:YES completion:NULL];
        }else{
            [self takeAnPhotoWithCamera];
        }
    } cancelBtn:@"取消" cancelStyle:UIAlertActionStyleCancel cancelAction:nil];
}

#pragma mark - 拍照/相册

- (void)takeAnPhotoWithCamera{
    if (![Helper checkCameraAuthorizationStatus]) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
    
    [picker.rac_imageSelectedSignal subscribeNext:^(NSDictionary *info) {
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        
        __block NSString *assetUrl = nil;
        NSError *error = nil;
        // 保存原图片到相册中
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            assetUrl = [PHAssetChangeRequest creationRequestForAssetFromImage:originalImage].placeholderForCreatedAsset.localIdentifier;
        } error:&error];
        
        if (!error) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetUrl] options:nil];
            PHAsset *asset = fetchResult.firstObject;
            [self.createVM addAnPHAsset:asset];
            [self.baseTableView reloadData];
        } else {
            [MBProgressHUD showError:@"保存到相册失败" toView:self.view];
        }
        
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }];
    
    [[picker.rac_delegateProxy signalForSelector:@selector(imagePickerControllerDidCancel:)]subscribeNext:^(id x) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - QBImage

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets{
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.createVM.assetArray = [assets mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self bk_performBlock:^(GGCreateCarViewController *obj) {
                [obj.baseTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
            } afterDelay:.2];
        });
    });
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 打开相册浏览
- (void)openPhotoBroswerWithIndex:(NSInteger)index{
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.createVM.imageItems.count];
    for (int i = 0; i < self.createVM.imageItems.count; i ++) {
        GGImageItem *item  = self.createVM.imageItems[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:item.photoUrl];
        photo.image = [UIImage imageWithData:item.imageData];
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.showSaveBtn = NO;
    browser.currentPhotoIndex = index;
    browser.photos = photos;
    [browser show];

//    GGPhotoBroswerViewController *vc = [[GGPhotoBroswerViewController alloc] init];
//    vc.items = self.createVM.imageItems;
//    vc.index = index;
//    vc.transitioningDelegate = self;
//    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [self generateAnimatorWithPresenting:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [self generateAnimatorWithPresenting:NO];
}


- (GGPhotoBroswerTransitionAnimator *)generateAnimatorWithPresenting:(BOOL)presenting {
    GGPhotoBroswerTransitionAnimator *animator = [[GGPhotoBroswerTransitionAnimator alloc] init];
    animator.presenting = presenting;
    return animator;
}

- (GGCreateCarViewModel *)createVM{
    if (!_createVM) {
        _createVM = [[GGCreateCarViewModel alloc] init];
    }
    return _createVM;
}

- (UIButton *)releaseButton{
    if (!_releaseButton) {
        _releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_releaseButton setTitle:@"确认发布" forState:UIControlStateNormal];
        [_releaseButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
        [_releaseButton setBackgroundImage:[UIImage imageWithColor:themeColor] forState:UIControlStateNormal];
        [_releaseButton setBackgroundImage:[UIImage imageWithColor:textLightColor] forState:UIControlStateDisabled];
        [_releaseButton.layer setBorderWidth:4];
        [_releaseButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return _releaseButton;
}

@end
