//
//  GGUploadDealInfoViewModel.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/9.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGUploadDealInfoViewModel.h"
#import "GGImageItem.h"

@implementation GGUploadDealInfoViewModel

- (NSArray *)photos{
    if (!_photos) {
        _photos = [[NSArray alloc]init];
    }
    return _photos;
}


- (void)initialize{

    
}


- (RACSignal *)enableSubmit{
    return [RACSignal combineLatest:@[RACObserve(self, title),
                                      RACObserve(self, remark),
                                      RACObserve(self, photos)] reduce:^id(NSString *title,NSString *remark ,NSArray *photos){
                                          
                                          return @(title.length > 0 && remark.length > 0);
                                      }];
}


- (RACSignal *)enableRefuseSubmit{
    return [RACSignal combineLatest:@[RACObserve(self, remark),
                                      RACObserve(self, photos)] reduce:^id(NSString *remark ,NSArray *photos){
                                          
                                          return @(remark.length > 0||photos.count > 1);
                                      }];

}




- (RACCommand *)submitCommand{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *orderNo) {
        
        NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:self.photos.count];;
        for (GGImageItem *image in self.photos) {
            [urlArray addObject:image.photoUrl];
        }
        
        NSDictionary *dic = @{@"orderNo":orderNo,
                              @"title":self.title,
                              @"description":self.remark,
                              @"pics":[urlArray componentsJoinedByString:@","]};
        
        return [[GGApiManager request_SubmitDealInfoWithParames:dic]map:^id(id value) {
            
            return [RACSignal empty];
        }];
    }];
    
    
}



#pragma mark - 拒绝退款
- (RACCommand *)submitRefuseCommand{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *orderNo) {

        @strongify(self);
        NSMutableArray *urlArray = [NSMutableArray arrayWithCapacity:self.photos.count];;
        for (GGImageItem *image in self.photos) {
            [urlArray addObject:image.photoUrl];
        }
        
        NSDictionary *parames;
        
        if (self.isAgree) {
            NSString *payPassword = [@[orderNo,[GGLogin shareUser].token,_password]componentsJoinedByString:@""];
            parames = @{@"orderNo":orderNo,
                        @"isAgree":@(self.isAgree),
                        @"payPassword":[[GGHttpSessionManager sharedClient].rsaSecurity rsaEncryptString:payPassword],
                        @"pics":[urlArray componentsJoinedByString:@","]};

        }else{
            parames = @{@"orderNo":orderNo,
                        @"isAgree":@(self.isAgree),
                        @"description":self.remark,
                        @"pics":[urlArray componentsJoinedByString:@","]};
        }
        
    
        return [[GGApiManager request_RefusedRefundWithParames:parames] map:^id(id value) {
            
            return [RACSignal empty];
        }];
    }];

}




@end
