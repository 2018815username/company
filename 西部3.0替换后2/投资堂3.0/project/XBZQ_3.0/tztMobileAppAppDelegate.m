//
//  tztMobileAppAppDelegate.m
//  tztMobileApp
//
//  Created by yangdl on 12-11-30.
//  Copyright 2012 投资堂. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import <tztMobileBase/tztMobileBase.h>
#import <tztMobileBase/TZTReachability.h>

#import "tztMobileAppAppDelegate.h"
#import "TztViewController.h"
#import "TZTInitViewController.h"
#import "tztHomePageViewController_iphone.h"
#import "tztUIHQHoriViewController_iphone.h"
#import "tztPushDataObj.h"

extern NSString* g_nsdeviceToken;

@interface tztMobileAppAppDelegate()
{
    NSURL                           *_nsTztURL;
    NSString                        *_nsBackSchem;
    BOOL                            _bRunByURL;
    int          _nFlag;
}
@property(nonatomic, retain)NSString *nsBackSchem;
@end

@implementation tztMobileAppAppDelegate

@synthesize window;
@synthesize rootTabBarController;
@synthesize pushOptions = _pushOptions;
@synthesize nav = _nav;
@synthesize nsBackSchem = _nsBackSchem;
#ifdef  tzt_Share
@synthesize wbapi, wbtoken;
#endif

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
#ifdef tzt_Share
    //向微信注册
    [WXApi registerApp:kWechatID];
    
    //向新浪微博注册
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    // 向腾讯微博注册
    wbapi = [TZTShareObject wbapiWithApppKey:WiressSDKDemoAppKey andAppSecret:WiressSDKDemoAppSecret];
#endif
    
    _nFlag = 1;
#ifdef DEBUG
    g_Http_MAX_AGE = 0;
#endif
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024 diskCapacity:32*1024*1024 diskPath:nil];
    [NSURLCache setSharedURLCache:cache];
    if (launchOptions)
    {
        //纪录当前的启动信息，等程序加载完成后进行展示。
        NSDictionary* pushinfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if(pushinfo && [pushinfo objectForKey:@"aps"])
            self.pushOptions = pushinfo;
        else
            self.pushOptions = launchOptions;
        
        NSURL *handleOfURL = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
        NSInteger nLen = [[handleOfURL absoluteString] length];
        if (handleOfURL && nLen > 0)
        {
            //记录标识
            _bRunByURL = TRUE;
#ifdef tztRunSchemesURL
            NSString* strBundleID = tztRunSchemesURL;// [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            if ([[handleOfURL scheme] isEqualToString:strBundleID])
            {
                NSString* strURL = [handleOfURL absoluteString];
                NSArray* ay = [strURL componentsSeparatedByString:@"://"];
                if([ay count] > 1)
                {
                    NSString* str = [ay objectAtIndex:1];
                    NSMutableDictionary *pDict = [str tztNSMutableDictionarySeparatedByString:@"&" decodeurl:FALSE];
                    if (pDict && [pDict count] > 0)
                    {
#ifdef Support_GJKHHTTPData
#if defined(__GNUC__) && !TARGET_IPHONE_SIMULATOR && ( defined(__APPLE_CPP__) || defined(__APPLE_CC__) || defined(__MACOS_CLASSIC__) )
                        NSString* strUI = [pDict tztObjectForKey:@"ui"];
                        [[tztkhApp getShareInstance] SetUISign:[strUI intValue]];
                        
                        NSString* strTerm = [pDict tztObjectForKey:@"terminal"];
                        if (strTerm.length <= 0)
                            strTerm = @"ZAI";
                        [[tztkhApp getShareInstance] SetTerminal:strTerm];
#endif
#endif
                        NSString* strSchem = [pDict tztObjectForKey:@"callid"];
                        if (strSchem && strSchem.length > 0)
                            self.nsBackSchem = [NSString stringWithFormat:@"%@", strSchem];
                    }
                }
            }
#endif
        }
    }
#ifdef DEBUG
    g_tztLogLevel = TZTLOG_LEVEL_INFO;
#else
    g_tztLogLevel = TZTLOG_LEVEL_ERROR;
#endif
    
    UINavigationController* pNav = [[UINavigationController alloc] init];
    NSString* pKey = @"3400";
    NSArray* pArry = [NSArray arrayWithObjects:window,pNav,self,pKey,nil];
    NSArray* pArryBlackTitle = [NSArray arrayWithObjects:@"1",nil];
    NSDictionary * params = Nil;
    if (self.pushOptions)
        params = [NSDictionary dictionaryWithObjectsAndKeys:pArry,@"APP",pArryBlackTitle,@"BlackTitle",self.pushOptions, @"tztPushInfo", nil];
    else
        params = [NSDictionary dictionaryWithObjectsAndKeys:pArry,@"APP",pArryBlackTitle,@"BlackTitle",nil];

//    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:pArry,@"APP",pArryBlackTitle,@"BlackTitle",nil];
    [[TZTAppObj getShareInstance] callService:(NSDictionary *)params withDelegate:self];
    [pNav release];
    [cache release]; // Avoid potential leak.  byDBQ20131031
    
#ifdef TZT_PUSH
    //注册启用 push
    if(!IS_TZTSimulator)
    {
        [[tztPushDataObj getShareInstance] tztRegistPush];
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    }
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CheckUserLoginState:)
                                                 name:TZTNotifi_CheckUserLoginFail
                                               object:nil];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = NO;
#ifdef  tzt_Share
     isSuc = ([WXApi handleOpenURL:url delegate:self]) || ([WeiboSDK handleOpenURL:url delegate:self]) || ([wbapi handleOpenURL:url])  /**/||([TencentOAuth HandleOpenURL:url] || [[TZTAppObj getShareInstance] tztHandleOpenURL:url]);
#else
    isSuc = [[TZTAppObj getShareInstance] tztHandleOpenURL:url];
#endif
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    //断开网络
    TZTNSLog(@"%@",@"当前切换到断网模式");

    [tztlocalHTTPServer stopShareInstance];
    [tztMoblieStockComm freeAllInstanceSocket];
    _nFlag = 1;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    CheckNetStatus();
    [tztlocalHTTPServer stopShareInstance];
    [tztlocalHTTPServer starShareInstance];
//    [tztlocalHTTPServerKH stopShareInstance];
//    [tztlocalHTTPServerKH starShareInstance];
    [tztMoblieStockComm getAllInstance];
    
    if (g_tztreachability)
        [[NSNotificationCenter defaultCenter] postNotificationName: kTZTReachabilityChangedNotification object:g_tztreachability];
    _bOpenPush = TRUE;
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"tztCheckLogVolume" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"tztGetPushMessage" object:nil];
    //
    UIViewController* pCurrnetVC = [TZTAppObj getTopViewController];
    [pCurrnetVC viewWillAppear:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    if (_nFlag == 1)
    {
        _bOpenPush = FALSE;
        _nFlag = 0;
    }
    else
        _bOpenPush = TRUE;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

//通讯状态回调
- (void)reachabilityChanged:(NSNotification *)note
{
	TZTReachability* curReach = [note object];
    static TZTNetworkStatus prestatus = TZTNotReachable;
	NSParameterAssert([curReach isKindOfClass: [TZTReachability class]]);
	TZTNetworkStatus status = [curReach currentReachabilityStatus];
//	BOOL bReConn = (status != prestatus);
	if (status == TZTNotReachable || prestatus != TZTNotReachable )
	{
        TZTNSLog(@"%@",@"TZTNotReachable");
//        [tztlocalHTTPServer stopShareInstance];
        [tztMoblieStockComm freeAllInstanceSocket];
	}

    prestatus = status;
	if(status != TZTNotReachable)
	{
        TZTNSLog(@"%@",@"AllReconnect");
//        [tztlocalHTTPServer starShareInstance];
        [tztMoblieStockComm getAllInstance];
	}
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
    if (pVC)
    {
        [pVC.view removeFromSuperview];
//        [pVC release];
        pVC = NULL;
    }
    
    if(testVC)
    {
        [testVC.view removeFromSuperview];
        [testVC release];
        testVC = NULL;
    }
    
    [TZTServerListDeal freeShareClass];
    [tztlocalHTTPServer freeShareInstance];
    [tztMoblieStockComm freeAllCommInstance];
    if(g_navigationController)
    {
        [g_navigationController release];
        g_navigationController = nil;
    }
	[super dealloc];
}

//
-(void)CheckUserLoginState:(NSNotification*)notification
{
    if (notification && [notification.name compare:TZTNotifi_CheckUserLoginFail] == NSOrderedSame)
    {
        if (!_bShowAlert)
        {
            NSString* strErrMsg = (NSString*)notification.object;
            UIAlertView *pAlert = [[UIAlertView alloc] initWithTitle:@"西部信天游"
                                                             message:strErrMsg
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil,
                                                                    nil];
            pAlert.tag = 0x5678;
            [pAlert show];
            [pAlert release];
            _bShowAlert = TRUE;
        }
        //设置系统登录标志,强制登出其他所有
        [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:TestTrade_Log];
        [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:Systerm_Log];
        [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllServer_Log];
        
        [g_navigationController popToRootViewControllerAnimated:UseAnimated];
    }
    
}

-(void)CallAppViewControl
{
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(Test)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)Test
{
    if (pVC)
    {
        [pVC.view removeFromSuperview];
        //        [pVC release];
        pVC = NULL;
    }
    
    if (g_navigationController)
    {
        [g_navigationController.view removeFromSuperview];
        [g_navigationController release];
        g_navigationController = NULL;
    }
    
    if (IS_TZTIPAD)//iPad版本
    {
        NSMutableArray *pAy = [TZTAppObj makeTabBarViewController];
        rootTabBarController.viewControllers = pAy;
        if (rootTabBarController != NULL)
        {
            //去掉编辑界面
            NSMutableArray *controllers = [NSMutableArray arrayWithArray:rootTabBarController.customizableViewControllers];
            [controllers removeAllObjects];
            rootTabBarController.customizableViewControllers = controllers;
        }
        rootTabBarController.delegate = self;
        [rootTabBarController didSelectItemAtIndex:0 options_:NULL];
        rootTabBarController.nDefaultIndex = 0;
        [self.window setRootViewController:rootTabBarController];
        [self.window makeKeyAndVisible];
    }
    else
    {
#ifdef tzt_NewVersion
        NSMutableArray *pAy = [TZTAppObj makeTabBarViewController];
        rootTabBarController.viewControllers = pAy;
        if (rootTabBarController != NULL)
        {
            //去掉编辑界面
            NSMutableArray *controllers = [NSMutableArray arrayWithArray:rootTabBarController.customizableViewControllers];
            [controllers removeAllObjects];
            rootTabBarController.customizableViewControllers = controllers;
        }
        rootTabBarController.delegate = self;
        [rootTabBarController didSelectItemAtIndex:0 options_:NULL];
        rootTabBarController.nDefaultIndex = 0;
        [self.window setRootViewController:rootTabBarController];
        [self.window makeKeyAndVisible];
        
//        [self didSelectItemByIndex:0 options_:NULL];
        
#else
        rootTabBarController.hidesBottomBarWhenPushed = YES;
        tztHomePageViewController_iphone *pHomeVC = [[tztHomePageViewController_iphone alloc] init];
        
        g_navigationController = [[UINavigationController alloc] initWithRootViewController:pHomeVC];
        g_navigationController.delegate = self;
        g_navigationController.navigationBarHidden = YES;
        [self.window setRootViewController:g_navigationController];
        [self.window makeKeyAndVisible];
        [pHomeVC release];
#endif
        
        //通过消息推送启动
#ifdef TZT_PUSH
        [self openPushInfo];
#endif
      
    }
#ifdef tzt_RequestUrl
    //公告信息
    [self ShowWebInfo];
#endif
}

-(void)ShowWebInfo
{
    //读取配置文件
    NSMutableDictionary* pDataDict =  GetDictByListName(@"tztInfoTest");
    if (pDataDict)
    {
        NSString* nsCrc = [pDataDict objectForKey:@"crc"];
        if (nsCrc && [nsCrc compare:@"0"] != NSOrderedSame)
        {
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Url wParam:(NSUInteger)pDataDict lParam:0];
        }
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    viewController.view.alpha = 0.2f;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:1.0];
    viewController.view.alpha = 1.0f;
    [UIView commitAnimations];
}


#ifdef TZT_PUSH
//iPhone 从APNs服务器获取deviceToken后激活该方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	
    [[tztPushDataObj getShareInstance] tztRegistPushSucc:deviceToken];
//	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//	NSString *results = [NSString stringWithFormat:@"Badge: %@, Alert:%@, Sound: %@",
//						 (rntypes & UIRemoteNotificationTypeBadge) ? @"Yes" : @"No", 
//						 (rntypes & UIRemoteNotificationTypeAlert) ? @"Yes" : @"No",
//						 (rntypes & UIRemoteNotificationTypeSound) ? @"Yes" : @"No"];
//	TZTNSLog(@"results: %@", results);
//	NSString* strToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//	
//	g_nsdeviceToken = [strToken retain];
//	TZTLogInfo(@"deviceToken: %@", g_nsdeviceToken); 
//    NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_GetDeviceToken object:self];
//    [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
}

//注册push功能失败 后 返回错误信息，执行相应的处理
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	TZTLogError(@"Error in registration. Error: %@", error); 
}

// Handle an actual notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[tztPushDataObj getShareInstance] tztDidRecivePushData:userInfo];
//    self.pushOptions = userInfo;
//	NSString* nsalert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    NSString* nsbadge = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
//    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [nsbadge intValue];
//    
//    NSLog(@"%@", userInfo);
//    
//    if (_bOpenPush)
//    {
//        [[TZTAppObj getShareInstance] tztGetPushDetailInfo:[[userInfo objectForKey:@"aps"] objectForKey:@"att"]];
//    }
//    else
//    {
//        [tztStatusBar tztShowMessageInStatusBar:nsalert
//                                       bgColor_:[UIColor colorWithTztRGBStr:@"67,148,255"]
//                                      txtColor_:[UIColor whiteColor]
//                                      fTimeOut_:-1.0f
//                                      delegate_:self
//                                     nPosition_:1];
//    }
//    _bOpenPush = FALSE;
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName: @"tztGetPushMessage" object:nil];
//    //    [tztStatusBar tztShowMessageInStatus:nsalert];
//    
//    
//    CFShow([userInfo description]);
//    //
//	//接收到push  打开程序以后设置badge的值
//    
//	//接收到push  打开程序以后会震动
//	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    //    [[TZTAppObj getShareInstance] tztGetPushDetailInfo:[[userInfo objectForKey:@"aps"] objectForKey:@"att"]];
}

//-(void)tztStatusBarClicked:(tztStatusBar*)statusBar
//{
//    //    [[TZTAppObj getShareInstance] tztGetPushDetailInfo:@"12035069|HT"];
//    if (self.pushOptions)
//        [[TZTAppObj getShareInstance] tztGetPushDetailInfo:[[self.pushOptions objectForKey:@"aps"] objectForKey:@"att"]];
//}

- (void)openPushInfo
{
    if(_pushOptions && [_pushOptions count] > 0)
    {
        TZTLogInfo(@"%@",[_pushOptions description]);
        NSString* nsiud = [[_pushOptions objectForKey:@"aps"] objectForKey:@"att"];
        if (nsiud)
        {
            CFShow(nsiud);
            NSString* strAtt = [[NSString alloc] initWithString:nsiud];
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_TztPushInfo wParam:(NSUInteger)strAtt lParam:[strAtt length]];
            [strAtt release];
        }
    }
}

- (UIRemoteNotificationType)enabledRemoteNotificationTypes
{
    return UIRemoteNotificationTypeNone;// UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound;
}

#endif

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1234:
            {
                g_CurUserData.nMZTKFlag = 1;
                [TZTUserInfoDeal SaveAndLoadLogin:FALSE nFlag_:0];
                if (pVC && [pVC isKindOfClass:[TZTInitViewController class]])
                {
                    [pVC OpenInit:TRUE];
                }
            }
                break;
            case 0x5678:
            {
                _bShowAlert = FALSE;
                g_nLogVolume = -1;//小于0，则不发送
            }
                break;
            default:
            {
                [self openPushInfo];
//                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                
            }
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString* strBundleID = tztRunSchemesURL;// [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if ([[url scheme] isEqualToString:strBundleID])
    {
        NSString* strURL = [url absoluteString];
        //com.yjb.kh://ui=2&terminal=ZAI&callid=xxxx
        NSArray* ay = [strURL componentsSeparatedByString:@"://"];
        if([ay count] > 1)
        {
            NSString* str = [ay objectAtIndex:1];
            NSMutableDictionary *pDict = [str tztNSMutableDictionarySeparatedByString:@"&" decodeurl:FALSE];
            _bRunByURL = TRUE;
            if (pDict && [pDict count] > 0)
            {
                NSString* strUI = [pDict tztObjectForKey:@"skinType"];
                // 主题色
                NSDictionary *dict = @{@"BgColorIndex":strUI};
                SetDictByListName(dict, @"BackgroundColorSet");
                
            }
        }
        
        return YES;
    }
#ifdef tzt_Share
    else if ([WXApi handleOpenURL:url delegate:self])
        return YES;
#endif
    return [[TZTAppObj getShareInstance] tztHandleOpenURL:url];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(IS_TZTIPAD)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        if(g_navigationController && [g_navigationController topViewController])
            return [[g_navigationController topViewController] supportedInterfaceOrientations];
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(IS_TZTIPAD)
        return;
    if ([viewController isKindOfClass:[tztUIHQHoriViewController_iphone class]])
    {
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
//        {
//            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:UIDeviceOrientationLandscapeLeft];
//        }
    }
    else
    {
        if(UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation))
        {
            if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
            {
                [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIInterfaceOrientationPortrait];
            }
        }
    }
}

-(void)OnReturnBack
{
    if (rootTabBarController)
    {
//        [rootTabBarController OnReturnPreSelect];
    }
}

-(void)didSelectItemByPageType:(int)nType options_:(NSDictionary*)options
{
    if (rootTabBarController)
    {
        [rootTabBarController didSelectItemByPageType:nType options_:options];
    }
}

-(void)didSelectItemByIndex:(int)nIndex options_:(NSDictionary*)options
{
    if (rootTabBarController)
    {
        [rootTabBarController didSelectItemByIndex:nIndex options_:options];
    }
}

#ifdef tzt_Share
#pragma mark - wbDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = nil;
        if (response.statusCode == 0) {
            message = @"发送成功";
        }
        else
        {
            message = @"发送失败";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        NSLog(@"%@",[NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo]);
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = @"认证结果";
        NSString *message = nil;
        if (response.statusCode == 0) {
            message = @"认证成功";
        }
        else
        {
            message = @"认证失败";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        
        [alert show];
        [alert release];
        NSLog(@"%@",[NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo]);
    }
}
#endif

@end

