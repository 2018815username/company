//
//  tztMobileAppAppDelegate.h
//  tztMobileApp
//
//  Created by yangdl on 12-11-30.
//  Copyright 2012 投资堂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZTInitViewController.h"
#import "TZTUIBaseTabBarViewController.h"
#import "TztViewController.h"

//#define tzt_Share
#ifdef tzt_Share
#import "WeiboApi.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#endif

#ifdef tzt_Share
@interface tztMobileAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate, UINavigationControllerDelegate,tztSocketDataDelegate, WXApiDelegate, WeiboSDKDelegate, tztStatusBarDelegate>
#else
@interface tztMobileAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate, UINavigationControllerDelegate,tztSocketDataDelegate, tztStatusBarDelegate>
#endif
{    
    UIWindow *window;
    TZTUIBaseTabBarViewController  *rootTabBarController;
    TZTInitViewController* pVC;
    TztViewController* testVC;
    
    NSDictionary *_pushOptions;
    
    BOOL         _bShowAlert;
    BOOL         _bOpenPush;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet TZTUIBaseTabBarViewController    *rootTabBarController;
@property (nonatomic, retain) NSDictionary *pushOptions;
@property (strong, nonatomic) tztUINavigationController *nav;
@property (strong, nonatomic) NSString *wbtoken;
#ifdef tzt_Share
@property (strong, nonatomic) WeiboApi                *wbapi;
#endif
//@property (nonatomic, retain) TZTInitViewController* vc;
-(void)CallAppViewControl;
-(void)OnReturnBack;
-(void)didSelectItemByPageType:(int)nType options_:(NSDictionary*)options;
-(void)didSelectItemByIndex:(int)nIndex options_:(NSDictionary*)options;

@end

