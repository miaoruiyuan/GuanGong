//
//  GGNotificationManager.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/13.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGNotificationManager.h"
#include <arpa/inet.h>
#import "GGCarHistoryReportDetailModel.h"

#import "FCUUID.h"

#import "GGMineInfoViewController.h"
#import "GGBillListViewController.h"
#import "GGPaymentOrderRootViewController.h"
#import "GGNewFriendsViewController.h"
#import "GGOtherPayDetailViewController.h"
#import "GGCheckOrderDetailViewController.h"

#import "GGBillingDetailsViewController.h"
#import "GGCClearDetailViewController.h"
#import "GGAttestationViewController.h"
#import "GGUserInfoViewModel.h"
#import "GGAttestationCompanyController.h"
#import "GGCarHistroyDetailWebController.h"
#import "GGApiManager+Vin.h"
#import "GGNewCarDetailViewController.h"

@implementation GGNotificationManager

#pragma mark - PushNotiication To ViewController

+ (void)updateUserInfo:(NSDictionary *)pushInfo;
{
    NSInteger msgID = [GGNotificationManager getPushMessagID:pushInfo];
    if (msgID == 11101 || msgID == 11102 || msgID == 11123 || msgID == 11124) {
        [[[[GGUserInfoViewModel alloc] init].getBaseUserInfoCommand executing] subscribeNext:^(id x) {
            DLog(@"update userInfo");
        }];
    }
}

+ (NSInteger)getPushMessagID:(NSDictionary *)pushInfo
{
    NSDictionary *dataDic = pushInfo[@"data"];
    NSInteger msgid = [dataDic[@"msgid"] integerValue];
    return msgid;
}

+ (void)handleNotificationInfo:(NSDictionary *)pushInfo
{
    NSDictionary *dataDic = pushInfo[@"data"];
    NSInteger msgid = [dataDic[@"msgid"] integerValue];
    NSDictionary *vcDic = dataDic[@"data"];
    
    // 创建对象
    id viewController = nil;
    
    switch (msgid) {
        case 11101:{//审核未通过
            viewController = [[GGAttestationViewController alloc] init];
        }
            break;
            
        case 11102:{//审核通过
            viewController = [[GGAttestationViewController alloc] init];
        }
            break;
            
        case 11103:{//充值
            viewController = [[GGBillingDetailsViewController alloc] init];
            BillItem *item = [[BillItem alloc] init];
            item.payId = vcDic[@"payId"];
            [viewController setItem:item];
        }
            break;
            
        case 11104:{//转账
            viewController = [[GGBillingDetailsViewController alloc] init];
            BillItem *item = [[BillItem alloc] init];
            item.payId = vcDic[@"payId"];
            [viewController setItem:item];
        }
            break;
            
        case 11105:{//收到订金/尾款/全款
            viewController = [[GGPaymentOrderRootViewController alloc] init];
            [viewController setShowSeller:YES];
        }
            break;
            
        case 11106:{//买家提交退款申请
            viewController = [[GGPaymentOrderRootViewController alloc] init];
            [viewController setShowSeller:YES];
        }
            break;
            
        case 11107:{//买家确认收货
            viewController = [[GGPaymentOrderRootViewController alloc] init];
            [viewController setShowSeller:YES];
        }
            break;
      
        case 11108:{//担保支付资金到账
            viewController = [[GGBillingDetailsViewController alloc] init];
            BillItem *item = [[BillItem alloc] init];
            item.payId = vcDic[@"payId"];
            [viewController setItem:item];
        }
            break;

        case 11109:{//卖家拒绝退款
            viewController = [[GGPaymentOrderRootViewController alloc] init];
        }
            break;

        case 11110:{//卖家同意退款
            viewController = [[GGPaymentOrderRootViewController alloc] init];
        }
            break;
            
        case 11111:{//卖家同意退货
            viewController = [[GGPaymentOrderRootViewController alloc] init];
        }
            break;
            
        case 11112:{//卖家确认收货
            viewController = [[GGPaymentOrderRootViewController alloc] init];
        }
            break;
            
        case 11113:{//收到退款
            viewController = [[GGBillingDetailsViewController alloc] init];
            BillItem *item = [[BillItem alloc] init];
            item.payId = vcDic[@"payId"];
            [viewController setItem:item];
        }
            break;
        case 11114:{//清分成功
            GGCapitalClearList *list = [[GGCapitalClearList alloc] init];
            list.applyId = vcDic[@"applyId"];
            viewController = [[GGCClearDetailViewController alloc] initWithObject:list];
        }
            break;
        case 11115:{//清分失败
            GGCapitalClearList *list = [[GGCapitalClearList alloc] init];
            list.applyId = vcDic[@"applyId"];
            viewController = [[GGCClearDetailViewController alloc] initWithObject:list];
        }
            
            break;
        case 11116:{//收到代付申请
            viewController = [[GGOtherPayDetailViewController alloc] init];
            [viewController setIsMineApply:NO];
            [viewController setApplyId:vcDic[@"payAnotherId"]];
        }
            break;
        case 11117:{//朋友代付成功
            viewController = [[GGOtherPayDetailViewController alloc] init];
            [viewController setIsMineApply:YES];
            [viewController setApplyId:vcDic[@"payAnotherId"]];
        }
            break;
        case 11118:{//添加好友通知
            viewController = [[GGNewFriendsViewController alloc] init];
        }
            break;
    
        case 11119:{//质检订单已确认
            viewController = [[GGCheckOrderDetailViewController alloc] init];
            [viewController setOrderId:vcDic[@"checkOrderId"]];
        }
            break;
        case 11120:{//质检订单已完成
            viewController = [[GGCheckOrderDetailViewController alloc] init];
            [viewController setOrderId:vcDic[@"checkOrderId"]];
        }
            break;
        case 11121:{//拒绝代付
            viewController = [[GGOtherPayDetailViewController alloc] init];
            [viewController setIsMineApply:NO];
            [viewController setApplyId:vcDic[@"payAnotherId"]];
        }
            break;
        case 11122:{//车史报告结果
            [MBProgressHUD showMessage:@"请稍等..."];
            NSString *reportID = vcDic[@"reportId"];
            NSDictionary *dic = @{@"reportId":reportID};
            [[GGApiManager request_CarHistoryDetailWithParameter:dic] subscribeNext:^(id value) {
                [MBProgressHUD hideHUD];
                GGCarHistoryReportDetailModel *reportDetailModel = [GGCarHistoryReportDetailModel modelWithJSON:value];
                GGCarHistroyDetailWebController *webVC = [[GGCarHistroyDetailWebController alloc] initWithDetailModel:reportDetailModel];
                [[self class] pushToController:webVC];
            } error:^(NSError *error) {
                [MBProgressHUD hideHUD];
            }];
        }
            break;
        case 11123:{//企业审核未通过
            viewController = [[GGAttestationCompanyController alloc] init];
        }
            break;
        case 11124:{//企业审核通过
            viewController = [[GGAttestationCompanyController alloc] init];
        }
            break;
        case 11128:{//好车抢购 - 好车详情页
            GGNewCarListModel *listModel = [[GGNewCarListModel alloc] init];
            listModel.carId = vcDic[@"newCarId"];
            viewController = [[GGNewCarDetailViewController alloc] initWithListModel:listModel];
        }
            break;
        default:
            
            break;
    }

    if (viewController) {
        [[self class] pushToController:viewController];
    }
}


+ (void)pushToController:(UIViewController *)viewController{
//    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    UITabBarController *tabVC = (UITabBarController *)delegate.window.rootViewController;
//    
//    UINavigationController *navVC = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
//    
//    // 跳转到对应的控制器
//    [navVC pushViewController:viewController animated:YES];

}

+ (NSString *)getStringValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return value;
}

#pragma mark - deviceToken 上传和本地保存

+ (void)uploadDeviceToken:(NSData *)deviceToken{
    if (![deviceToken isKindOfClass:[NSData class]]) return;

    NSString *deviceTokenString = nil;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0.0")) {
        const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
        deviceTokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                             ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                             ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                             ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        
    }else{
        deviceTokenString = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString: @"<" withString: @""]
                              stringByReplacingOccurrencesOfString: @">" withString: @""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    }
    
    if (deviceTokenString.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([GGLogin shareUser].isLogin && deviceTokenString.length > 0) {
        NSString *uuid = [FCUUID uuidForDevice];
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        NSDictionary *parameter = @{
                                    @"systemVersion":systemVersion,
                                    @"deviceToken":deviceTokenString,
                                    @"machineCode":uuid,
                                    @"tokenServiceType":@"1"
                                    };
        [[GGHttpSessionManager sharedClient] postJsonDataWithPath:@"device/add"
                                                       withParams:parameter
                                                         andBlock:^(id data, NSError *error) {
                                                             
                                                         }];
    }

}


@end
