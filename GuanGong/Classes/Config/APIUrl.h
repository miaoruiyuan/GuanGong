//
//  APIUrl.h
//  GuanGong
//
//  Created by 苗芮源 on 16/4/11.
//  Copyright © 2016年 iautos. All rights reserved.
//

#ifndef APIUrl_h


#if DEVELOPMENT

#define BaseUrl @"https://gg.iautos.cn:16343/finance-gg/ggApi/"
#define BaseIautosUrl @"http://api.csiautos.cn/"


#else

#define BaseUrl @"https://guangong.iautos.cn/ggApi/"
#define BaseIautosUrl @"http://api.iautos.cn/"

#endif


/*
 
 1.切换BaseURL
 2.切换证书https 加密,签名,设置不允许访问无效证书
 3.切换APPkey
 4.plist更改域名
 
 */

#endif /* APIUrl_h */
