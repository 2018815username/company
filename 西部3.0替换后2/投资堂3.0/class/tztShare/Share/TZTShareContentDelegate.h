//
//  TZTShareContentDelegate.h
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 5/7/14.
//
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import "WXApi.h"
#import "TZTShareView.h"

@protocol tztHTTPWebViewDelegate;
@interface TZTShareContentDelegate : UIViewController<tztHTTPWebViewDelegate, TencentSessionDelegate, WXApiDelegate, shareDelegate>

@property (nonatomic , retain) WeiboApi                    *wbapi;
@property (nonatomic , retain) TencentOAuth                *tencentOAuth;

+(TZTShareContentDelegate*)shareDelegate;

@end
