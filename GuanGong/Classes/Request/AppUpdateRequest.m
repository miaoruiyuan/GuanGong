//
//  AppUpdateRequest.m
//  GuanGong
//
//  Created by CodingTom on 2017/3/8.
//  Copyright © 2017年 iautos. All rights reserved.
//

#import "AppUpdateRequest.h"
#import "GGCheckUpdateModel.h"

static GGCheckUpdateModel *updateModel;

@implementation AppUpdateRequest

+ (void)checkAppUpdateAuto
{
    [AppUpdateRequest checkAppUpdate:^(GGCheckUpdateModel *model){
        [AppUpdateRequest showAlert:updateModel];
    }];
}

+ (void)RefreshAppUpdateData:(void(^)(BOOL show))block
{
    updateModel = nil;
    [AppUpdateRequest checkAppUpdate:^(GGCheckUpdateModel *model){
        [AppUpdateRequest showAlert:updateModel];
        if (model && [model showUpdate]) {
            block(YES);
        }
        block(NO);
    }];
}

+ (void)showAlert:(GGCheckUpdateModel *) model
{
    if (model && [model showUpdate]) {
        [UIAlertView bk_showAlertViewWithTitle:@"升级提醒"
                                       message:model.remark
                             cancelButtonTitle:@"更新"
                             otherButtonTitles:nil
                                       handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
                                       }];
    }
}

+ (void)checkAppUpdate:(void(^)(GGCheckUpdateModel *model))block
{
    if (updateModel) {
        block(updateModel);
        return;
    }
    
    NSString *requestURL = @"http://api.99haoche.com/99haoche-api/appVersionCheck";
    
//    requestURL = @"http://192.168.1.250:6300/99haoche-api/appVersionCheck";
    
    NSString *version = [[UIApplication sharedApplication] appVersion];
//    version = @"1.2";

    NSDictionary *dic = @{@"name":GGAppName,
                          @"system":@"ios",
                          @"version":version,
                          @"channel":@"0"
                          };
    GGHttpSessionManager *manager = [GGHttpSessionManager sharedClient];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [manager GET:requestURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            DLog(@"AppUpdate\n%@",responseObject);
            if ([responseObject[@"responseCode"] isKindOfClass:[NSNumber class]]) {
                if ([(NSNumber *)responseObject[@"responseCode"] isEqualToNumber:@100000]) {
                    GGCheckUpdateModel *model = [GGCheckUpdateModel modelWithJSON:responseObject[@"data"]];
                    updateModel = model;
                    block(updateModel);
                    return;
                }
            }
        }
        block(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(nil);
    }];
}

@end
