//
//  GGScanCodeViewController.h
//  GuanGong
//
//  Created by 苗芮源 on 16/7/6.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface GGScanCodeViewController : GGBaseViewController

@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
- (BOOL)isScaning;
- (void)startScan;
- (void)stopScan;

@property (copy, nonatomic) void(^scanResultBlock)(GGScanCodeViewController *vc, NSString *resultStr);

@end



@interface ScanBgView : UIView
@property (assign, nonatomic) CGRect scanRect;

@end