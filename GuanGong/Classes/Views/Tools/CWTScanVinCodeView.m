//
//  CWTScanVinCodeView.m
//  CheWangTong
//
//  Created by 苗芮源 on 2017/3/31.
//  Copyright © 2017年 ios_miaoruiyuan. All rights reserved.
//

#import "CWTScanVinCodeView.h"
#import <AVFoundation/AVFoundation.h>

@interface CWTScanVinCodeView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BOOL isScaning;
}
@property(nonatomic,strong)UIImageView *scanImageView;
@property(nonatomic,strong)UIImageView *scanLineView;
@property(nonatomic,strong)ScanBGView *coverView;

@property(nonatomic,strong)UIButton *takeButton;
@property(nonatomic,strong)UIButton *cancelButton;

@property(nonatomic,strong)UILabel *remarkLabel;

@end

@implementation CWTScanVinCodeView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.scanImageView];
        [self.scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.top.equalTo(self.mas_top).offset(90);
            make.height.mas_equalTo(220);
        }];
        
        [self addSubview:self.remarkLabel];
        [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scanImageView);
            make.top.equalTo(self.scanImageView.mas_bottom).offset(20);
        }];
        
        [self addSubview:self.takeButton];
        [self.takeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-80);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        [self addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.bottom.equalTo(self.mas_bottom).offset(-44);
            make.size.mas_equalTo(CGSizeMake(40, 24));
        }];
        
    }
    return self;
}


- (UIImageView *)scanImageView{
    if (!_scanImageView) {
        _scanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_vin_photo"]];
    }
    return _scanImageView;
}

- (UIImageView *)scanLineView{
    if (!_scanLineView) {
        _scanLineView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor orangeColor]]];
    }
    return _scanLineView;
}


- (ScanBGView *)coverView{
    if (!_coverView) {
        _coverView = [[ScanBGView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    }
    return _coverView;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.text = @"注意:将带有车辆识别代号（VIN码）的行驶证页面放入框内，点击拍照按钮开始拍照识别";
        _remarkLabel.textColor = [UIColor whiteColor];
        _remarkLabel.font = [UIFont systemFontOfSize:12];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.preferredMaxLayoutWidth = kScreenWidth - 40;
    }
    return _remarkLabel;
}



- (UIButton *)takeButton{
    if (!_takeButton) {
        _takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takeButton setBackgroundImage:[UIImage imageNamed:@"scan_camera_take"] forState:UIControlStateNormal];
        [[_takeButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
            [self.picker takePicture];
        }];
    }
    return _takeButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [[_cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            [self.picker dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
    }
    return _cancelButton;
}

- (UIImagePickerController *)picker{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.sourceType = _sourceType;
        _picker.allowsEditing = YES;
        if (_sourceType == UIImagePickerControllerSourceTypeCamera) {
            _picker.showsCameraControls = NO;
            _picker.cameraOverlayView = self;
        }
    
        [_picker.rac_imageSelectedSignal subscribeNext:^(NSDictionary *info) {
            UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
            CGSize size = originalImage.size;
            //压缩
            originalImage = [UIImage imageWithImage:originalImage scaledToSize:CGSizeMake(kScreenWidth * 2, size.height *kScreenWidth * 2/size.height)];
            float scale = originalImage.size.width/kScreenWidth;
            //要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
            CGRect rect = CGRectMake(self.scanImageView.origin.x *scale, self.scanImageView.origin.y * scale, self.scanImageView.frame.size.width *scale, self.scanImageView.frame.size.height * scale);
            CGImageRef cgimg = CGImageCreateWithImageInRect([originalImage CGImage], rect);
            originalImage = [UIImage imageWithCGImage:cgimg];
            CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
            
            [_picker dismissViewControllerAnimated:YES completion:^{
                if (self.takePhotoBlock) {
                    self.takePhotoBlock(originalImage);
                }
            }];
        }];
        
        
        [[_picker.rac_delegateProxy signalForSelector:@selector(imagePickerControllerDidCancel:)]subscribeNext:^(id x) {
            [_picker dismissViewControllerAnimated:YES completion:nil];
        }];
        

    }
    return _picker;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.coverView.scanRect = self.scanImageView.frame;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end




@implementation ScanBGView

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    super.backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (void)setScanRect:(CGRect)scanRect{
    _scanRect = scanRect;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    [[UIColor clearColor] setFill];
    CGContextFillRect(context, rect);
    
    [self.backgroundColor setFill];
    CGRect topRect = CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetMinY(_scanRect));
    CGRect bottomRect = CGRectMake(0, CGRectGetMaxY(_scanRect), CGRectGetWidth(bounds), CGRectGetHeight(bounds) - CGRectGetMaxY(_scanRect));
    CGRect leftRect = CGRectMake(0, CGRectGetMinY(_scanRect), CGRectGetMinX(_scanRect), CGRectGetHeight(_scanRect));
    CGRect rightRect = CGRectMake(CGRectGetMaxX(_scanRect), CGRectGetMinY(_scanRect), CGRectGetWidth(bounds) - CGRectGetMaxX(_scanRect), CGRectGetHeight(_scanRect));
    
    CGContextAddRect(context, topRect);
    CGContextAddRect(context, bottomRect);
    CGContextAddRect(context, leftRect);
    CGContextAddRect(context, rightRect);
    
    CGContextFillPath(context);
}


@end


