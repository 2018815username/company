/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#ifndef __TZTAPPOBJ_M__
#define __TZTAPPOBJ_M__
#import "TZTAppObj.h"
#import <tztMobileBase/TZTReachability.h>
#import "tztMainViewController.h"
//
#import "tztCommRequestView.h"
#import "TZTInitReportMarketMenu.h"
#import "TZTUIReportViewController.h"
#import "tztZXCenterViewController.h"
#import "tztUIServiceCenterViewController_iPad.h"
#import "tztUITradeViewController_iPad.h"
#import "tztHomePageViewController_iphone.h"
#import "tztMenuViewController_iphone.h"
#import "tztZXCenterViewController_iphone.h"
#import "tztNineCellViewController.h"
#import "tztUIReportViewController_iphone.h"
#import "tztUIFuctionListViewController.h"
#import "tztUITradeLogindViewController.h"
#import "tztUIServiceCenterViewController.h"
#import "tztUIBaseVCOtherMsg.h"
#import "tztWebViewController.h"
#import "tztUIHQHoriViewController_iphone.h"
#import "tztUIFenShiViewController_iphone.h"
#import "tztUIDocumentViewController.h"

#ifndef Support_EXE_VERSION
#import "tztInterface.h"
#import "tztInitObject.h"
#endif

#ifdef tzt_LocalStock
#import "tztInitStockCode.h"
#endif

#ifdef Support_HomePage
#import "tztUIHomePageViewController.h"
#endif

#ifdef Support_TBFW
#import "tztUIWebTZProtectVC.h"
#endif

#import "PPRevealSideViewController.h"

#import "TZTInitViewController.h"
#import "tztUIQuoteViewController.h"


extern TZTCSystermConfig* g_pSystermConfig;//配置文件

NSTimer	*g_pJYLockTimer = NULL;

@implementation TZTUIWindow

////重载系统相应函数，记录点击事件，判断是否要对交易进行锁屏操作
//-(void)sendEvent:(UIEvent *)event
//{
//	//
//	[super sendEvent:event];
//	[TZTUIBaseVCMsg SetLock];
//}

@end

//体验天数
#define TESTOFDAYS       15

TZTAppObj *g_pTZTAppObj = NULL;
id        g_pTZTDelegate = NULL;
UIViewController *g_pTZTTopVC = NULL;
@implementation TZTAppObj
@synthesize rootTabBarController = _rootTabBarController;
@synthesize window = _window;
@synthesize dictCallParam = _dictCallParam;
@synthesize nsOrder_nsJyAccount = _nsOrder_nsJyAccount;
@synthesize initObj = _initObj;
@synthesize pMenuBarView = _pMenuBarView;
@synthesize bInit = _bInit;
@synthesize pCommRequest = _pCommRequest;
@synthesize pDocumentVC = _pDocumentVC;
@synthesize nsFilePath = _nsFilePath;
@synthesize bInitApplication = _bInitApplication;
@synthesize nsTztURL = _nsTztURL;
@synthesize rootNav = _rootNav;
@synthesize revealSideViewController = _revealSideViewController;

-(BOOL)tztHandleOpenURL:(NSURL*)url
{
    NSString* strBundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
#ifdef tztRunSchemesURL
    strBundleID = tztRunSchemesURL;
#endif
    if ([[url scheme] isEqualToString:strBundleID])
    {
        if (self.bInitApplication)
        {
            NSString* strURL = [url absoluteString];
            NSArray* ay = [strURL componentsSeparatedByString:@"://"];
            if([ay count] > 1)
            {
                NSString* str = [ay objectAtIndex:1];
                //此处解析下需要显示的主题
                //先查找/?
                NSString* strValue = str;
                NSString* strPath = strValue;
                NSString* strParam = @"";
                NSRange pathRang = [strValue rangeOfString:@"?"];
                if(pathRang.location == NSNotFound) //不带参数
                {
                    strParam = strValue;
                }
                else
                {
                    strPath = [strValue substringToIndex:pathRang.location-1];
                    strParam = [strValue substringFromIndex:pathRang.location+pathRang.length];
                }
                
                NSMutableDictionary* pDict = nil;
                if(strParam && [strParam length] > 0)
                {
                    pDict = (NSMutableDictionary*)[strParam tztNSMutableDictionarySeparatedByString:@"&&"];
                    if (pDict == NULL || [pDict count] < 1)
                    {
                        pDict = (NSMutableDictionary*)[strParam tztNSMutableDictionarySeparatedByString:@"&"];
                    }
                }
                
                if (pDict && [pDict count] > 0)
                {
                    NSString* strUI = [pDict tztObjectForKey:@"skinType"];
                    if (!ISNSStringValid(strUI))
                        strUI = [pDict tztObjectForKey:@"ui"];
                    if (ISNSStringValid(strUI))
                    {
                        // 主题色
                        NSDictionary *dict = @{@"BgColorIndex":strUI};
                        SetDictByListName(dict, @"BackgroundColorSet");
                        
                        int colorIndex = [strUI intValue];
                        if (colorIndex == 1)
                        {
                            g_nThemeColor = 1;
                            g_nSkinType = 1;
                            g_nJYBackBlackColor = 0;
                            g_nHQBackBlackColor = 0;
                        }
                        else if (colorIndex == 0)
                        {
                            g_nThemeColor = 0;
                            g_nSkinType = 0;
                            g_nJYBackBlackColor = 1;
                            g_nHQBackBlackColor = 1;
                        }
                        
                        
                        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_ChangeTheme object:str];
                        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
                    }
                }
                [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:0];
            }
        }
        else
        {
            self.nsTztURL = url;
        }
    }
    return YES;
}

+(TZTAppObj*)getShareInstance
{
    if (g_pTZTAppObj == NULL)
    {
        g_pTZTAppObj = NewObject(TZTAppObj);
        [g_pTZTAppObj tztMainInit];
    }
    return g_pTZTAppObj;
}

+(void)freeShareInstance
{
    DelObject(g_pTZTAppObj);
}

//拷贝ajax数据到指定目录下
+(void)tztCopyAjaxDataFromBundle:(NSString*)bundleName floder_:(NSString*)nsFloder
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"]];
    if (bundle == nil)
        return;
    
    NSString* strPath = [bundle resourcePath];
    if (strPath.length <= 0)
        return;
    
    strPath = [NSString stringWithFormat:@"%@/%@/", strPath, nsFloder];
    NSError *error = nil;
    
    NSString* strToPath = [NSString stringWithFormat:@"%@", nsFloder];
    strToPath = [strToPath tztHttpfilepath];
    
    //已经存在
    if ([strToPath FileExists])
        return;
    
    //创建文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString* strFile = [strToPath stringByDeletingLastPathComponent];
    [fileManager createDirectoryAtPath:strFile withIntermediateDirectories:YES attributes:nil error:&error];
    [fileManager copyItemAtPath:strPath toPath:strToPath error:&error];
    
    if (error)
    {
        TZTLogInfo(@"%@",[error description]);
    }
    else
    {
        NSString* strCrc = [NSString tzthttpcrcPath];
        NSMutableDictionary *ayCRC =  NewObjectAutoD(NSMutableDictionary);
        NSDictionary* crcdict = [NSDictionary dictionaryWithContentsOfFile:strCrc];
        if(crcdict)
            [ayCRC setDictionary:crcdict];
        else
        {
            NSString* strPath = [strCrc stringByDeletingLastPathComponent];
            NSError* error = nil;
            [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        [TZTAppObj tztGetAjaxFileCrc:nsFloder ayFileCrc_:ayCRC];
        [ayCRC writeToFile:strCrc atomically:YES];
        TZTLogInfo(@"%@", ayCRC);
        
        BOOL bDel = [strPath tztfiledelete];
        if (!bDel)
            TZTLogWarn(@"%@",@"\r\n==================文件删除失败================");
    }
}

//遍历文件，获取crc，存入文件
+(void)tztGetAjaxFileCrc:(NSString*)strPath ayFileCrc_:(NSMutableDictionary*)ayFileCrc
{
    if (strPath == NULL || strPath.length < 1)
        return;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* strToPath = [strPath tztHttpfilepath];
    
    NSError *error = nil;
    NSArray *ayFileList = [fileManager contentsOfDirectoryAtPath:strToPath error:&error];
    if (error)
    {
        return;
    }
    
    for (int i = 0; i < [ayFileList count]; i++)
    {
        TZTLogInfo(@"%@", [ayFileList objectAtIndex:i]);
        NSString* strSubPath = [NSString stringWithFormat:@"%@/%@", strPath, [ayFileList objectAtIndex:i]];
        NSString* str = [strSubPath tztHttpfilepath];
        BOOL bDir = FALSE;
        [fileManager fileExistsAtPath:str isDirectory:&bDir];
        if (bDir)
        {
            [TZTAppObj tztGetAjaxFileCrc:strSubPath ayFileCrc_:ayFileCrc];
        }
        else
        {
            /*获取文件crc*/
            NSData* data = [fileManager contentsAtPath:str];
            NSInteger nLen = [data length];
            int filecrc = 0;
            char* pChar = (char *)[data bytes];
            pChar+= (nLen - 4);
            filecrc = *(int *)pChar;
            
            NSString* strKey = [NSString stringWithFormat:@"/%@/%@", strPath, [ayFileList objectAtIndex:i]];
            [ayFileCrc setValue:[NSString stringWithFormat:@"%d",filecrc] forKey:strKey];
        }
    }
    
}

+(void)tztCopyDataBaseFromBundle:(NSString*)bundleName nsFileName:(NSString*)nsFileName
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"]];
    if (bundle == nil)
        return;
    
    NSString* strPath = [bundle resourcePath];
    if (strPath.length <= 0)
        return;
    
    strPath = [NSString stringWithFormat:@"%@/%@", strPath, nsFileName];
    NSError *error = nil;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *strToPath = [documents stringByAppendingPathComponent:nsFileName];
    
    //已经存在
    if ([strToPath FileExists])
        return;
    
    //创建文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString* strFile = [strToPath stringByDeletingLastPathComponent];
    [fileManager createDirectoryAtPath:strFile withIntermediateDirectories:YES attributes:nil error:&error];
    [fileManager copyItemAtPath:strPath toPath:strToPath error:&error];
    
    if (error)
    {
        TZTLogWarn(@"%@",[error description]);
    }
    else
    {   
        BOOL bDel = [strPath tztfiledelete];
        if (!bDel)
            TZTLogInfo(@"%@",@"\r\n==================文件删除失败================");
    }
}

-(void)setInitFlag:(BOOL)bFlag
{
    _bInit = bFlag;
}

-(BOOL)getInitFlag
{
    return _bInit;
}

-(id)init
{
    self = [super init];
    _bInit = TRUE;
    _nStartType = tztvckind_Main;
    _pCommRequest = [[tztCommRequestView alloc] init];
    if (self)
    {  
        [TZTAppObj tztCopyAjaxDataFromBundle:tzt_bundlename floder_:@"service"];
        [TZTAppObj tztCopyAjaxDataFromBundle:tzt_bundlename floder_:@"pub"];
        [TZTAppObj tztCopyDataBaseFromBundle:tzt_bundlename nsFileName:@"tztInitStockInfo.db"];
        [TZTAppObj tztCopyAjaxDataFromBundle:tzt_bundlename floder_:@"xbzqajax"];
        [TZTAppObj tztCopyAjaxDataFromBundle:tzt_bundlename floder_:@"zlcftajax"];
        [TZTAppObj tztCopyAjaxDataFromBundle:tzt_bundlename floder_:@"sjkh"];
        
        NSLog(@"%@",@"---------------------tztUserStock getshareClass-------------");
        [tztUserStock getShareClass];
        NSLog(@"%@",@"---------------------tztUserStock getshareClass Succ-------------");
        tztSetBasedef();
        NSLog(@"%@",@"---------------------tztSetBasedef Succ-------------");
        CheckNetStatus();//初始判断。
        NSLog(@"%@",@"---------------------CheckNetStatus-------------");
        //设置网络状态变化是的通知函数
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kTZTReachabilityChangedNotification
                                                   object:nil];
        if(g_tztreachability == NULL)
        {
            g_tztreachability = [[TZTReachability reachabilityWithHostName:@"www.baidu.com"] retain];
            [g_tztreachability startNotifer];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tztLoginStateChanged:)
                                                     name:TZTNotifi_ChangeLoginState
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(OnOpenDocument:)
                                                     name: TZTNotifi_OpenDocument
                                                   object: nil];
        
        NSLog(@"%@",@"---------------------before [TZTAppObj InitData]-------------");
        [TZTAppObj InitData];
        NSLog(@"%@",@"---------------------[TZTAppObj InitData] Succ-------------");
        if (_rootTabBarController == NULL)
            _rootTabBarController = [[TZTUIBaseTabBarViewController alloc] init];
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES]; //防止休眠
    }
    return self;
}

+(TZTUIBaseViewController*)getTopViewController
{
    if (g_pTZTAppObj == NULL)
    {
        g_pTZTAppObj = NewObject(TZTAppObj);
    }
    return (TZTUIBaseViewController*)[g_pTZTAppObj.rootTabBarController GetTopViewController];
}

#pragma mark -
#pragma mark Application lifecycle
- (NSInteger)callService:(NSDictionary*)params withDelegate:(id)delegate
{
    TZTNSLog(@"callService: withDelegate:");
    //zxl 20131111 接口整理
#ifndef Support_EXE_VERSION
     self.dictCallParam = [[tztInterface getShareInterface] GetChangeParams:params];
#else
    self.dictCallParam = params;
#endif
    g_pTZTDelegate = delegate;
    
	return [self InitWithApp:self.dictCallParam withDelegate:delegate];
}

- (NSInteger)InitWithApp:(NSDictionary*)params withDelegate:(id)delegate
{
    if (params == NULL)
        return 0;
//    BOOL    bIsTestUser = NO;           //体验用户
    NSArray* pArrayJyAccount = NULL;    //交易账号
	NSArray* pArrayApp = NULL;          //app
	NSArray* pArrayCode = NULL;         //代码
	NSArray* pArrayStockCode = NULL;    //股票代码
	NSArray* pArrayTestDays = NULL;     //体验天数
	NSArray* pArrayZJAccount = NULL;    //资金账号
    NSArray* pArrayLogAccount = NULL;   //交易登录账号
    
//    int nDays = -1;
    int nStockNum = 20;
    DelObject(g_pDictLoginInfo);
    //解析数据
    self.pMenuBarView = NULL;
    if (params)
	{
		NSArray* pArrayKey = [params allKeys];
//        NSLog(@"%@,%@",params,pArrayKey);
		for(int i = 0 ; i < [pArrayKey count]; i++)
		{
			NSString* nsKey = [pArrayKey objectAtIndex:i];
			if( [nsKey compare:@"APP"] == NSOrderedSame )
			{
				pArrayApp = [params objectForKey:nsKey];
				if([pArrayApp count] != 4)
				{
					TZTNSLog(@"%@",@"APP params count != 4");
					return 0;
				}
			}
			if([nsKey compare:@"FundCode"] == NSOrderedSame)
			{
				pArrayCode = [params objectForKey:nsKey];
				TZTNSLog(@"FundCode Exist %lu",(unsigned long)[pArrayCode count]);
			}
            
			
            if ([nsKey compare:@"TEST"] == NSOrderedSame)
            {
                //bIsTestUser = FALSE;
                pArrayTestDays = [params objectForKey:nsKey];
                if (pArrayTestDays && [pArrayTestDays count] > 0)
                {
                    NSString* nsDays = [pArrayTestDays objectAtIndex:0];
                    if (nsDays && [nsDays intValue] < TESTOFDAYS && [nsDays intValue] >= 0)
                    {
//                        bIsTestUser = TRUE;
//                        nDays = [nsDays intValue];
                    }
                }
				TZTNSLog(@"%@",@"TEST Exist");
            }
			
			if ([nsKey compare:@"BlackTitle"] == NSOrderedSame)
            {
				NSArray* pArray = [params objectForKey:nsKey];
				TZTNSLog(@"BlackTitle Exist %lu",(unsigned long)[pArray count]);
				g_nJYBackBlackColor = 1;
				if(pArray && [pArray count] > 0 )
				{
					g_nJYBackBlackColor = [[pArray objectAtIndex:0] intValue];
				}
            }
            
            NSDictionary * dict = GetDictByListName(@"BackgroundColorSet");
            NSString* strTheme = [dict objectForKey:@"BgColorIndex"];
            if (strTheme.length < 1)
            {
                if (!ISNSStringValid(g_pSystermConfig.themeColor))
                {
                    g_pSystermConfig.themeColor = @"0";
                }
                
                if (g_pSystermConfig.themeColor.length > 0) {
                    NSString* strUI = g_pSystermConfig.themeColor;
                    // 主题色
                    NSDictionary *dict = @{@"BgColorIndex":strUI};
                    SetDictByListName(dict, @"BackgroundColorSet");
                }
                
            }
            
            dict = GetDictByListName(@"BackgroundColorSet");
            int colorIndex = [dict[@"BgColorIndex"] intValue];
            
#ifdef XBZQ_3
            colorIndex = 1;
#endif
            if (colorIndex == 1)
            {
                g_nSkinType = 1;
                g_nJYBackBlackColor = 0;
                g_nThemeColor = 1;
                g_nHQBackBlackColor = 0;
            }
            else if (colorIndex == 0)
            {
                g_nSkinType = 0;
                g_nJYBackBlackColor = 1;
                g_nHQBackBlackColor = 1;
                g_nThemeColor = 0;
            }
            

			
			if([nsKey compare:@"JYACCOUNT"] == NSOrderedSame )
			{
				pArrayJyAccount = [params objectForKey:nsKey];
				TZTNSLog(@"JYACCOUNT Exist %lu",(unsigned long)[pArrayJyAccount count]);
			}
			
            if ([nsKey compare:@"LOGINACCOUNT"] == NSOrderedSame)
            {
                pArrayLogAccount = [params objectForKey:nsKey];
                TZTNSLog(@"LOGINACCOUNT Exist %lu", (unsigned long)[pArrayLogAccount count]);
                NSString* strAccount = @"";
                NSString* strPWD = @"";
                NSString* strComPWD = @"";
                NSString* strDtPWD = @"";
                
                DelObject(g_pDictLoginInfo);
                g_pDictLoginInfo = NewObject(NSMutableDictionary);
                if ([pArrayLogAccount count] > 0)
                    strAccount = [pArrayLogAccount objectAtIndex:0];
                if ([pArrayLogAccount count] > 1)
                    strPWD = [pArrayLogAccount objectAtIndex:1];
                if ([pArrayLogAccount count] > 2)
                    strComPWD = [pArrayLogAccount objectAtIndex:2];
                if ([pArrayLogAccount count] > 3)
                    strDtPWD = [pArrayLogAccount objectAtIndex:3];
                
                if (ISNSStringValid(strAccount))
                    [g_pDictLoginInfo setTztObject:strAccount forKey:@"tztLogAccount"];
                if (ISNSStringValid(strPWD))
                    [g_pDictLoginInfo setTztObject:strPWD forKey:@"tztLogPWD"];
                if (ISNSStringValid(strComPWD))
                    [g_pDictLoginInfo setTztObject:strComPWD forKey:@"tztLogComPWD"];
                if (ISNSStringValid(strDtPWD))
                    [g_pDictLoginInfo setTztObject:strDtPWD forKey:@"tztLogDtPWD"];
                
            }
            if([nsKey compare:@"ZJACCOUNT"] == NSOrderedSame )
			{
				if (pArrayJyAccount && [pArrayJyAccount count] > 0)
				{
					pArrayJyAccount = NULL;
                    DelObject(g_pDictLoginInfo);
				}
				
				pArrayZJAccount = [params objectForKey:nsKey];
				TZTNSLog(@"ZJACCOUNT Exist %lu",(unsigned long)[pArrayZJAccount count]);
			}
            
			if([nsKey compare:@"StockInfo"] == NSOrderedSame)
			{
				pArrayStockCode = [params objectForKey:nsKey];
				TZTNSLog(@"StockInfo Exist %lu",(unsigned long)[pArrayStockCode count]);
			}
			
			if( [nsKey compare:@"USERSTOCK"] == NSOrderedSame )
			{
				nStockNum = [[params objectForKey:nsKey] intValue];
			}
            
			if( [nsKey compare:@"PhoneNum"] == NSOrderedSame )
			{
//                NSString *PhoneNum = [[NSString alloc]initWithString:[params objectForKey:nsKey]];
//                [TZTServerListDeal SetRegisterPhoneNum:PhoneNum];
			}
            if ([nsKey compare:@"JYLoginHasDtPassword"] == NSOrderedSame)
            {
                NSArray *pAy = [params objectForKey:nsKey];
                if (pAy)
                {
                    if ([pAy count] > 0)
                    {
                        g_nHaveDtPassword = [[pAy objectAtIndex:0] intValue];
                    }
                }
            }
            if ([nsKey compare:@"menuBarView"] == NSOrderedSame)
            {
                NSArray *pAy = [params objectForKey:nsKey];
                if (pAy && [pAy count] > 0)
                {
                    self.pMenuBarView = [pAy objectAtIndex:0];
                }
            }
		}
	}
    
	if (pArrayApp == NULL)
	{
		TZTNSLog(@"%@",@"APP not Find");
		return 0;
	}
	self.window = (TZTUIWindow *)[pArrayApp objectAtIndex:0];
    self.window.backgroundColor = [UIColor blackColor]; // 改变底层背景避免白屏出现 byDBQ20130828
	if (self.window == NULL)
	{
		TZTNSLog(@"%@",@"window == NULL");
		return 0;
	}
	tztUINavigationController* navigationController = (tztUINavigationController *)[pArrayApp objectAtIndex:1];
	if (navigationController == NULL)
	{
		TZTNSLog(@"%@",@"navigationController == NULL");
		return 0;
	}
    g_CallNavigationController = navigationController;
//    g_navigationController = navigationController;
	
	id app = [pArrayApp objectAtIndex:2];
	if (app == NULL)
	{
		TZTNSLog(@"%@",@"app == NULL");
		return 0;
	}
    
    if (pArrayJyAccount && [pArrayJyAccount count] > 0)
    {
        NSString* nsJYAccount = [pArrayJyAccount objectAtIndex:0];
        if (nsJYAccount && [nsJYAccount length] > 0)
        {
            if ([_nsOrder_nsJyAccount caseInsensitiveCompare:nsJYAccount] != NSOrderedSame)
            {
                [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
            }
            
            self.nsOrder_nsJyAccount = [NSString stringWithFormat:@"%@", nsJYAccount];
            DelObject(g_pDictLoginInfo);
            g_pDictLoginInfo = NewObject(NSMutableDictionary);
            [g_pDictLoginInfo setTztObject:nsJYAccount forKey:@"tztLogAccount"];
        }
    }
    
    /*华泰紫金理财传入的客户身份证号*/
    if (pArrayZJAccount && [pArrayZJAccount count] > 2)
    {
        NSString* nsType = [pArrayZJAccount objectAtIndex:2];
#ifdef Support_EXE_VERSION
        if (nsType && [nsType compare:@"Card"] == NSOrderedSame)
#else
        if (nsType && ([nsType compare:@"Card"] == NSOrderedSame || [nsType compare:@"TA"] == NSOrderedSame))
#endif
        {
            NSString *nsUserCardID = [pArrayZJAccount objectAtIndex:0];
            if (nsUserCardID && nsUserCardID.length > 0)
            {
                g_nsUserCardID = [[NSString alloc] initWithFormat:@"%@", nsUserCardID];
            }
            
            NSString* nsInquirePW = [pArrayZJAccount objectAtIndex:1];
            if (nsInquirePW && nsInquirePW.length > 0)
            {
                g_nsUserInquiryPW = [[NSString alloc] initWithFormat:@"%@", nsInquirePW];
            }
        }
    }
    
    //初始化，均衡
    if ([[TZTAppObj getShareInstance] getInitFlag])
    {
        Class vcClass = [[NSBundle mainBundle] classNamed:@"TZTInitViewController"];
        if (vcClass != NULL)
        {
#ifdef Support_EXE_VERSION
            //zxl 20130930 initviewcontroller 加入g_navigationController 没有什么去掉
            TZTInitViewController *pVC = [[TZTInitViewController alloc] init];
            [self.window setRootViewController:pVC];
            [self.window makeKeyAndVisible];
            [pVC OpenInit:TRUE];
            [pVC release];
            [[TZTAppObj getShareInstance] setInitFlag:FALSE];
            return 1;
            
#else
            [self tztMainInit];
            [[TZTAppObj getShareInstance] setInitFlag:FALSE];
            return 1;
#endif
        }
    }
    
    NSString* nsNib = [pArrayApp objectAtIndex:3];
    if (nsNib == NULL || nsNib.length < 1)
    {
        return 0;
    }
    int nib = [nsNib intValue];
    
#ifndef Support_EXE_VERSION
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (nib != 3594     //3594取自选股行情
        && nib != 9000  //9000设置动态口令
        && nib != 3201  //3201用户登录
        && nib != 3600  //3600
        && nib != 3802  //3802交易登出
        && nib != 3814  //已经不使用
        && nib != 3463  //
        )
    {
//        g_CallNavigationController.navigationBar.hidden = YES;
    }
    
    if (self.pMenuBarView)
    {
        [self setMenuBarHidden:YES animated:YES];
    }
#endif
    //系统启动
#ifdef Support_EXE_VERSION
    if (g_navigationController)
    {
        [g_navigationController.view removeFromSuperview];
        [g_navigationController release];
        g_navigationController = NULL;
    }
#else
    if (g_navigationController && [g_navigationController.topViewController isKindOfClass:[TZTInitViewController class]])
        [g_navigationController popViewControllerAnimated:NO];
    
    if (g_CallNavigationController && [g_CallNavigationController.topViewController isKindOfClass:[TZTInitViewController class]])
        [g_CallNavigationController popViewControllerAnimated:NO];
#endif
    //华泰体验用户
    
    
  //zxl 20130930  外部接口调用功能放下面的话就重复了_rootTabBarController的设置步骤
    if (nib == 3400)
    {
        g_navigationController = NULL;
        [self tztAppObjStart:navigationController];
#ifndef Support_EXE_VERSION
        g_pTZTTopVC = navigationController.topViewController;
#endif
        return 1;
    }
    
#ifdef tzt_NewVersion
    if (_rootTabBarController && [_rootTabBarController.viewControllers count] <= 0)
    {
        NSMutableArray *pAy = [tztMainViewController makeTabBarViewController];
        _rootTabBarController.viewControllers = pAy;
        if (_rootTabBarController != NULL)
        {
            NSMutableArray *controllers = [NSMutableArray arrayWithArray:_rootTabBarController.customizableViewControllers];
            [controllers removeAllObjects];
            _rootTabBarController.customizableViewControllers = controllers;
        }
        
        int nDefault = 0;
        if (g_pSystermConfig && g_pSystermConfig.nDefaultIndex > -1)
        {
            nDefault = g_pSystermConfig.nDefaultIndex;
        }
        _rootTabBarController.delegate = self;
        [_rootTabBarController didSelectItemByIndex:nDefault options_:NULL];
        _rootTabBarController.nDefaultIndex = nDefault;
    }
#endif
    
    g_navigationController = navigationController;
    
#ifndef Support_EXE_VERSION
    g_pTZTTopVC = navigationController.topViewController;
#endif
    switch (nib)
    {
        case 9000:
        {
            
        }
            break;
        case 3401:
        {
            if (pArrayStockCode && [pArrayStockCode count] > 1)
            {
                tztStockInfo *pStock = NewObject(tztStockInfo);
                NSString* strCode = [NSString stringWithFormat:@"%@", [pArrayStockCode objectAtIndex:1]];
                NSArray *ay = [strCode componentsSeparatedByString:@"|"];
                if ([ay count] > 0)
                    pStock.stockCode = [ay objectAtIndex:0];
                if ([ay count] > 1)
                    pStock.stockName = [ay objectAtIndex:1];
                if ([ay count] > 2)
                    pStock.stockType = [[ay objectAtIndex:2] intValue];
                [self tztSearchStockInfo:pStock withList_:(NSMutableArray*)pArrayStockCode];
                DelObject(pStock);
            }
        }
            break;
        case 3404:
        {
            [self tztOpenMyStock];
        }
            break;
        case 3408:
        {
            [self tztSearchCode];
        }
            break;
        case 3410:
        {
            [self tztOpenIndexTrend];
        }
            break;
        case 3411:
        {
            [self tztOpenZHPM];
        }
            break;
        case 3430:
        {
            [self tztHqSetting];
        }
            break;
        case 3431:
        {
            [self tztSetServer];
        }
            break;
        case 3453:
        {
            [self tztOpenOutFund];
        }
            break;
        case 3429://系统配置
        {
            [self tztOpenSysConfig];
        }
            break;
        case 3436:
        {
            [self tztSoftVersion];
        }
            break;
        case 3464:
        {
            [self tztInfoCenter];
        }
            break;
        case 3594:
        {
            [self tztGetUserStockData:nStockNum];
        }
            break;
        case 3701:
        {
            [self tztOpenTrade];
        }
            break;
        case 3603:
        {
            NSString *strAccount = @"";
            if (pArrayLogAccount && [pArrayLogAccount count] > 0)
                strAccount = [pArrayLogAccount objectAtIndex:0];
            [self tztResetComPass:strAccount];
        }
            break;
        case 3702:
        {
            [self tztBankCard];
        }
            break;
        case 3703:
        {
            [self tztOpenZJLC];
        }
            break;
        case 3709:
        {
            [self tztTTF];
        }
            break;
        case 3801:
        {
            [self tztTradeLogin];
        }
            break;
        case 3802:
        {
            [self tztTradeLogOut];
        }
            break;
        case 3822:
        {
            [self tztQueryCC];
        }
            break;
        case 3831:
        {
            [self tztChangPW];
        }
            break;
        case 3834:
        {
            [self tztUserInfoModify];
        }
            break;
        case 3829:
        {
            [self tztQueryJG];
        }
            break;
        case 4018:
        {
            [self tztAccount_ZJLC];
        }
            break;
        case 4019:
        {
            [self tztFundChangeFindPWD];
        }
            break;
        case 4065:
        {
            [self tztFHSet_ZJLC];
        }
            break;
        case 4011:
        {
            [self tztFundQuery];
        }
            break;
        case 4013:
        {
            [self tztFundOpenAccount];
        }
            break;
        case 4014://
        {
        }
            break;
        case 4015:
        {
            [self tztFenHongSet];
        }
            break;
        case 4051:
        {
            [self tztFundRG_ZJLC];
        }
            break;
        case 4052:
        {
            [self tztFundSG_ZJLC];
        }
            break;
        case 4053:
        {
            [self tztFundSH_ZJLC];
        }
            break;
            //zxl 20131111 接口整理
        default:
        {
            [TZTUIBaseVCMsg OnMsg:nib wParam:(NSUInteger)pArrayStockCode lParam:(NSUInteger)1];
#ifndef Support_EXE_VERSION
            [[tztInterface getShareInterface] OnDealNib:nib ArryApp:pArrayApp];
#endif
        }
            break;
    }
    
    return 1;
}


#pragma 外部接口调用功能
/*3400-系统启动*/
-(void)tztAppObjStart:(tztUINavigationController*)navigationController
{   
    //
    BOOL bShowStart = FALSE;
#ifdef tzt_StartPage
//    /增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        NSString* strSystemVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//        [[NSUserDefaults standardUserDefaults] setObject:strSystemVer forKey:@"lanuchedVersion"];
        bShowStart = TRUE;
    }
    else
    {
    }
#endif
    if (IS_TZTIPAD)
    {
        NSMutableArray *pAy = [TZTAppObj makeTabBarViewController];
        _rootTabBarController.viewControllers = pAy;
        if (_rootTabBarController != NULL)
        {
            //去掉编辑界面
            NSMutableArray *controllers = [NSMutableArray arrayWithArray:_rootTabBarController.customizableViewControllers];
            [controllers removeAllObjects];
            _rootTabBarController.customizableViewControllers = controllers;
        }
        _rootTabBarController.delegate = self;
        
        int nDefault = 0;
        if (g_pSystermConfig && g_pSystermConfig.nDefaultIndex > -1)
        {
            nDefault = g_pSystermConfig.nDefaultIndex;
        }
        [_rootTabBarController didSelectItemAtIndex:nDefault options_:NULL];
        _rootTabBarController.nDefaultIndex = nDefault;
        [self.window setRootViewController:_rootTabBarController];
        _rootTabBarController.view.hidden = bShowStart;
        [self.window makeKeyAndVisible];
    }
    else
    {
#ifdef tzt_NewVersion
        static BOOL bInitRoot = FALSE;
        
        if (!bInitRoot)
        {
            NSMutableArray *pAy = [tztMainViewController makeTabBarViewController];
            _rootTabBarController.viewControllers = pAy;
            if (_rootTabBarController != NULL)
            {
                NSMutableArray *controllers = [NSMutableArray arrayWithArray:_rootTabBarController.customizableViewControllers];
                [controllers removeAllObjects];
                _rootTabBarController.customizableViewControllers = controllers;
            }
            
            int nDefault = 0;
            if (g_pSystermConfig && g_pSystermConfig.nDefaultIndex > -1)
            {
                nDefault = g_pSystermConfig.nDefaultIndex;
            }
            _rootTabBarController.delegate = self;
            [_rootTabBarController didSelectItemByIndex:nDefault options_:NULL];
            _rootTabBarController.nDefaultIndex = nDefault;
            _rootTabBarController.view.hidden = bShowStart;
            bInitRoot = TRUE;
            
            if (g_nSupportLeftSide || g_nSupportRightSide)//支持左右侧滑
            {
                [_rootTabBarController initSideViewController];
                self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:_rootTabBarController];
                self.revealSideViewController.delegate = _rootTabBarController;
                [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
                [self.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNavigationBar];
            }
            
        }
#ifdef Support_EXE_VERSION

        if (g_nSupportLeftSide || g_nSupportRightSide)
        {
            [self.window setRootViewController:self.revealSideViewController];
        }
        else
            [self.window setRootViewController:_rootTabBarController];
        [self.window makeKeyAndVisible];
#else
        [self ShowMain];
#endif
        
#else
        _rootTabBarController.hidesBottomBarWhenPushed = YES;
        tztHomePageViewController_iphone *pVC = [[tztHomePageViewController_iphone alloc] init];
        
#ifdef Support_EXE_VERSION
        g_navigationController = [[tztUINavigationController alloc] initWithRootViewController:pVC];
        g_navigationController.delegate = self;
        g_navigationController.navigationBarHidden = YES;
        [self.window setRootViewController:g_navigationController];
        [self.window makeKeyAndVisible];
#else
        g_navigationController = navigationController;
        [g_navigationController pushViewController:pVC animated:UseAnimated];
#endif
        [pVC release];
        
#endif
    }
    
    
#ifdef tzt_StartPage
    NSString* strSystemVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString* strLanucnedVer = [[NSUserDefaults standardUserDefaults] stringForKey:@"lanuchedVersion"];
    if (strLanucnedVer == NULL|| strLanucnedVer.length < 1
        || (strLanucnedVer && [strLanucnedVer caseInsensitiveCompare:strSystemVer] != NSOrderedSame))
    {
        [WZGuideViewController showWithcompletion_:^{
            
            _rootTabBarController.view.hidden = NO;
            [self tztGetPushDetailInfo:nil];
            
            UIViewController *pVC = g_navigationController.topViewController;
            if (pVC && [pVC isKindOfClass:[TZTUIBaseViewController class]])
            {
                [((TZTUIBaseViewController*)pVC) ShowHelperImageView];
            }
        }];
    }
#endif
    
#ifdef tzt_RequestUrl //修改东莞公告  modify by xyt 20130925
    if (IS_TZTIPAD)
    {
        static BOOL bShowWebInfo = TRUE;
        if (!bShowWebInfo)
            return;
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(ShowWebInfo)
                                       userInfo:nil
                                        repeats:NO];
        bShowWebInfo = FALSE;
    }
    else
    {
        //公告信息
        [self ShowWebInfo];
    }
#endif
//    
//#ifdef tzt_FenshiGlobal
//    
//#ifdef Support_HTSC
//    BOOL bPush = FALSE;
//    g_pFenShiViewController = (tztUITrendViewController *)gettztHaveViewContrller([tztUITrendViewController class], tztvckind_HQ, [NSString stringWithFormat:@"%d", tztVcShowTypeSame], &bPush,TRUE);
//    g_pFenShiViewController.view;
//#else
//    BOOL bPush = FALSE;
//    g_pFenShiViewController = (tztUIFenShiViewController_iphone *)gettztHaveViewContrller([tztUIFenShiViewController_iphone class], tztvckind_HQ, [NSString stringWithFormat:@"%d", tztVcShowTypeSame], &bPush,TRUE);
//    g_pFenShiViewController.view;
//#endif
//#endif
    
#ifdef tzt_ZFXF_LOGIN   //中方信富 打开软件后调用用户登录
    [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:0 wParam:0 lParam:0];
#endif
    
    /*华泰启动的时候，若是开市时间，则默认选中行情，若是闭市时间，默认选中首页热点*/
#ifdef Support_HTSC
    int nDefault = [TZTAppObj getDefaultStartIndex];
    if (nDefault >= 0)
    {
        if (nDefault == 1)
            _nStartType = tztvckind_Main;
        else
            _nStartType = tztvckind_HQ;
        
        [tztMainViewController didSelectNavController:_nStartType options_:NULL];
    }
    else
    {
        [tztMainViewController didSelectNavController:tztvckind_Main options_:NULL];
    }


#else 
    //XINLAN 将一创的开始设为行情
 #ifdef XBZQ_3
    _nStartType = tztvckind_HQ;
#else
    [tztMainViewController didSelectNavController:_nStartType options_:NULL];

#endif
//    [tztMainViewController didSelectNavController:_nStartType options_:NULL];
// #else
    [tztMainViewController didSelectNavController:_nStartType options_:NULL];
//    tztUINavigationController* pNav = [tztMainViewController getNavController:tztvckind_HQ];
    UIViewController* pVC = g_navigationController.topViewController;
    if ([pVC isKindOfClass:[tztUIQuoteViewController class]])
    {
        [pVC view];
        [pVC tztperformSelector:@"RequestUserStockData"];
    }

#endif
    
    if (!bShowStart)//不显示引导页的情况下，直接去请求推送信息详情，否则在引导页消失后去请求
    {
        [self tztGetPushDetailInfo:nil];
    }
    
    if (IS_TZTIOS(8))
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

//请求推送详情
-(void)tztGetPushDetailInfo:(NSString*)strData
{
    if (strData == nil || strData.length < 1)
    {
        if (self.dictCallParam == NULL)
            return;
        
        NSDictionary *pDict = [self.dictCallParam objectForKey:@"tztPushInfo"];
        if (pDict == NULL)
            return;
        
        NSDictionary *pSubDict = [pDict objectForKey:@"aps"];
        if (pSubDict == NULL)
            return;
        
        NSString* nsPushInfo = [pSubDict objectForKey:@"att"];
        strData = [NSString stringWithFormat:@"%@", nsPushInfo];
    }
    if (strData == NULL || strData.length < 1)
        return;
    
    NSArray* ayPush = [strData componentsSeparatedByString:@"|"];
    if (ayPush.count < 2)
        return;
    
#ifdef TZT_PUSH
    //根据nsSocId和nsType来获取详细信息
    [[tztPushDataObj getShareInstance] tztRequestDetailOfPushInfo:strData];
//    if (g_pReportMarket)
//    {
//        [g_pReportMarket RequestDetailOfPushInfo:strData];
//    }
#endif
    
}

-(void)showvc
{
    _rootTabBarController.view.hidden = NO;
    [self tztGetPushDetailInfo:nil];
    
    UIViewController *pVC = g_navigationController.topViewController;
    if (pVC && [pVC isKindOfClass:[TZTUIBaseViewController class]])
    {
        [((TZTUIBaseViewController*)pVC) ShowHelperImageView];
    }
}

- (void)setMenuBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (self.pMenuBarView == NULL)
        return;
	CGRect menuBarFrame = self.pMenuBarView.frame;
	
	CGFloat height = self.window.frame.size.height;
	
	int to;
	if( hidden )
	{
		to = height;
	}
	else
	{
		to = height - menuBarFrame.size.height;
	}
	if (menuBarFrame.origin.y != to) {
		if (animated) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveLinear];
			[UIView setAnimationDuration:0.2];
		}
		menuBarFrame.origin.y = to;
		self.pMenuBarView.frame = menuBarFrame;
		if (animated) {
			[UIView commitAnimations];
		}
	}
}


-(void)ShowMain
{
    [g_CallNavigationController pushViewController:_rootTabBarController animated:UseAnimated];
}
//zxl 20131111 接口整理
-(void)ShowStockQueryVC:(UIViewController*)pPopVC  Rect:(CGRect)rect
{
#ifndef Support_EXE_VERSION
    [[tztInterface getShareInterface] ShowStockQueryVC:pPopVC Rect:rect];
#endif
}
/*3410-大盘指数*/
-(void)tztOpenIndexTrend
{
#ifdef tzt_NewVersion
    [g_CallNavigationController pushViewController:_rootTabBarController animated:UseAnimated];
#endif
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_IndexTrend wParam:0 lParam:0];
}

/*3453 - 场外基金*/
-(void)tztOpenOutFund
{
#ifdef tzt_NewVersion
    [g_CallNavigationController pushViewController:_rootTabBarController animated:UseAnimated];
#endif
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_OutFund wParam:0 lParam:0];
}

/*3701-委托交易*/
-(void)tztOpenTrade
{
#ifdef tzt_NewVersion
    [self tztAppObj:nil didSelectItemByPageType:tztTradePage options_:NULL];
    [g_CallNavigationController pushViewController:_rootTabBarController animated:UseAnimated];
    [g_navigationController popToRootViewControllerAnimated:NO];
#else
    [TZTUIBaseVCMsg OnMsg:TZT_MENU_JY_LIST wParam:0 lParam:0];
#endif
    
}

/*3404-我的自选*/
-(void)tztOpenMyStock
{
#ifdef tzt_NewVersion
    [g_CallNavigationController pushViewController:_rootTabBarController animated:UseAnimated];
#endif
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_UserStock wParam:0 lParam:0];
}

/*3703 － 紫金理财*/
-(void)tztOpenZJLC
{
#ifdef tzt_NewVersion
    [g_CallNavigationController pushViewController:_rootTabBarController animated:UseAnimated];
#endif
    [TZTUIBaseVCMsg OnMsg:MENU_QS_HTSC_ZJLC_List wParam:0 lParam:0];
}

/*3411 - 综合排名*/
-(void)tztOpenZHPM
{
#ifdef tzt_NewVersion
    [g_CallNavigationController pushViewController:_rootTabBarController animated:UseAnimated];
#endif
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_HSMarket wParam:0 lParam:0];
}

/*3201 - 用户登录*/
-(void)tztOpenUserLogin
{
    
}

/*3408 － 个股查询*/
-(void)tztSearchCode
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_SearchStock wParam:0 lParam:0];
}

/*3702 － 银证转账*/
-(void)tztBankCard
{
    [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_CardBank wParam:0 lParam:0];
}

/*3430 － 行情设置*/
-(void)tztHqSetting
{
    [TZTUIBaseVCMsg OnMsg:Sys_Menu_SystemSetting wParam:0 lParam:0];
}

/*3431 － 服务器设置*/
-(void)tztSetServer
{
    [TZTUIBaseVCMsg OnMsg:Sys_Menu_SetServer wParam:0 lParam:0];
}

/*3401 - 查询股票信息*/
-(void)tztSearchStockInfo:(tztStockInfo*)pStock withList_:(NSMutableArray *)ayList
{
#ifdef tzt_NewVersion
    [g_CallNavigationController pushViewController:_rootTabBarController animated:UseAnimated];
#endif
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    NSMutableArray *ayStock = NewObject(NSMutableArray);
    for (int i = 1; i < [ayList count]; i++)
    {
        NSString* strCode = [ayList objectAtIndex:i];
        NSArray *ay = [strCode componentsSeparatedByString:@"|"];
        if ([ay count] < 1)
            continue;
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", [ay objectAtIndex:0]];
        if ([ay count] > 1)
            pStock.stockName = [NSString stringWithFormat:@"%@", [ay objectAtIndex:1]];
        if ([ay count] > 2)
            pStock.stockType = [[ay objectAtIndex:2] intValue];
        [ayStock addObject:pStock];
        [pStock release];
    }
    [pDict setTztObject:ayStock forKey:@"View"];
    
#ifdef tzt_XCSCFramework
    [TZTUIBaseVCMsg OnMsg:0x98789 wParam:(NSUInteger)pStock lParam:(NSUInteger)pDict];
#else
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)pDict];
#endif
    [pDict release];
    [ayStock release];
}

-(void)tztResetComPass:(NSString*)nsAccount
{
    [TZTUIBaseVCMsg OnMsg:WT_HTSC_ResetComPass wParam:(NSUInteger)nsAccount lParam:(NSUInteger)self];
}

/*3831 - 修改密码*/
-(void)tztChangPW
{
    [TZTUIBaseVCMsg OnMsg:WT_PWD wParam:0 lParam:0];
}

/*3834 - 个人信息修改*/
-(void)tztUserInfoModify
{
    [TZTUIBaseVCMsg OnMsg:WT_ModifySelfInfo wParam:0 lParam:0];
}

-(void)tztQueryCC
{
    [TZTUIBaseVCMsg OnMsg:WT_QUERYGP wParam:0 lParam:0];
}

/*3829 - 交割单业务*/
-(void)tztQueryJG
{
    [TZTUIBaseVCMsg OnMsg:WT_QUERYJG wParam:0 lParam:0];
}

/*4018 - 紫金账号查询*/
-(void)tztAccount_ZJLC
{
    [TZTUIBaseVCMsg OnMsg:MENU_QS_HTSC_ZJLC_QueryAccount wParam:0 lParam:0];
}

/*4019 － 紫金理财查询密码修改*/
-(void)tztFundChangeFindPWD
{
    [TZTUIBaseVCMsg OnMsg:MENU_QS_HTSC_ZJLC_ChangeFindPW wParam:0 lParam:0];
}

/*4065 － 紫金理财分红方式修改*/
-(void)tztFHSet_ZJLC
{
    [TZTUIBaseVCMsg OnMsg:MENU_QS_HTSC_ZJLC_FenHongSet wParam:0 lParam:0];
}

/*4017 － 紫金理财净值短信订阅*/
-(void)tztMessage_ZJLC
{
}

/*4013 － 场外基金开户*/
-(void)tztFundOpenAccount
{
    [TZTUIBaseVCMsg OnMsg:WT_JJINZHUCEACCOUNTEx wParam:0 lParam:0];
}

/*4014 － 场外基金登记*/


/*4015 － 基金分红方式修改*/
-(void)tztFenHongSet
{
    [TZTUIBaseVCMsg OnMsg:WT_JJFHTypeChange wParam:0 lParam:0];
}

/*4011 － 基金资产查询，持仓基金*/
-(void)tztFundQuery
{
    [TZTUIBaseVCMsg OnMsg:WT_JJINQUIREGUFEN wParam:0 lParam:0];
}

/*3801 － 交易登录*/
-(void)tztTradeLogin
{
    if (![TZTUIBaseVCMsg SystermLogin:MENU_SYS_JYLogin wParam:0 lParam:0])
    {
        [TZTUIBaseVCMsg OnMsg:MENU_SYS_JYLogin wParam:0 lParam:0];
    }
    return;
}

/*3802 － 交易登出*/
-(void)tztTradeLogOut
{
    [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
    [tztJYLoginInfo SetLoginAllOut];
}

//系统配置
-(void)tztOpenSysConfig
{
    [TZTUIBaseVCMsg OnMsg:Sys_Menu_ServiceCenter wParam:0 lParam:0];
}

//版本信息
-(void)tztSoftVersion
{
    [TZTUIBaseVCMsg OnMsg:Sys_Menu_SoftVersion wParam:0 lParam:0];
}

//资讯中心
-(void)tztInfoCenter
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Center wParam:0 lParam:0];
}

//紫金理财认购
-(void)tztFundRG_ZJLC
{
    [TZTUIBaseVCMsg OnMsg:MENU_QS_HTSC_ZJLC_RenGou wParam:0 lParam:0];
}

//紫金理财申购
-(void)tztFundSG_ZJLC
{
    [TZTUIBaseVCMsg OnMsg:MENU_QS_HTSC_ZJLC_ShenGou wParam:0 lParam:0];
}

//
-(void)tztFundSH_ZJLC
{
    [TZTUIBaseVCMsg OnMsg:MENU_QS_HTSC_ZJLC_ShuHui wParam:0 lParam:0];
}

-(void)tztTTF
{
    [TZTUIBaseVCMsg OnMsg:WT_XJLC_List wParam:0 lParam:0];
}

-(void)tztGetUserStockData:(int)nStockNum
{
    if (g_pReportMarket == NULL)
        g_pReportMarket = NewObject(TZTInitReportMarketMenu);
    
    [g_pReportMarket RequestUserBlockStock:nStockNum];
}
/**/

#pragma 初始化操作，framework专用，暂时放在此处
/*初始化操作*/
-(void)tztMainInit
{
#ifndef Support_EXE_VERSION
    if (_initObj == NULL)
        _initObj = NewObject(tztInitObject);
    
    [_initObj OpenInit:TRUE];
#endif
}

//通讯状态回调
- (void)reachabilityChanged:(NSNotification *)note
{
    TZTNSLog(@"----------------TZTAppObj reachabilityChanged");
	TZTReachability* curReach = [note object];
    static TZTNetworkStatus prestatus = TZTNotReachable;
	NSParameterAssert([curReach isKindOfClass: [TZTReachability class]]);
	TZTNetworkStatus status = [curReach currentReachabilityStatus];
	BOOL bReConn = (status != prestatus);
    //modify by yinjp 此处修改，在当前网络不可用，并且上次状态是可用的时候才释放
//    if (status == TZTNotReachable || prestatus != TZTNotReachable )
	if (status == TZTNotReachable && prestatus != TZTNotReachable )
	{
        TZTNSLog(@"%@",@"TZTNotReachable");
        [tztMoblieStockComm freeAllInstanceSocket];
	}
    
    //状态变更的时候才记录
    if (status != TZTNotReachable)
        prestatus = status;
    
	if(bReConn)
	{
        TZTNSLog(@"%@",@"AllReconnect");
//        [tztMoblieStockComm freeAllInstanceSocket];//先清空，再重连
        [tztMoblieStockComm getAllInstance];
	}
    
    
    [[tztUIBaseVCOtherMsg getShareInstance] tztperformSelector:@"tztNetWorkChanged:" withObject:(status != TZTNotReachable) ? @"1" : @"0"];
}
//基金选择判断登录状态
- (void)tztLoginStateChanged:(NSNotification*)note
{
#ifdef Support_HXSC
    return;
#endif
    NSString* strType = (NSString*)note.object;
    NSArray *ay = [strType componentsSeparatedByString:@"|"];
    if ([ay count] <= 0)
        return;
    
    [[tztUIBaseVCOtherMsg getShareInstance] tztperformSelector:@"tztLoginStateChanged:" withObject:note];
    
    
    long lType = [[ay objectAtIndex:0] intValue];
    BOOL IsLogin = TRUE;
    if ([ay count] > 1)
    {
        IsLogin = [[ay objectAtIndex:1] boolValue];
    }
    
//    BOOL bIsTradeLogin = [TZTUserInfoDeal IsHaveTradeLogin:lType];
//    if(bIsTradeLogin)
    {
        //该处注释，请到各自工程中进行相应处理
        if(!IsLogin && (StockTrade_Log & lType) == StockTrade_Log)//普通交易登出
        {
            tztUINavigationController* pNav = [tztMainViewController getNavController:tztvckind_JY];
            if (pNav && pNav.nPageID == tztvckind_JY)
            {
                [pNav popToRootViewControllerAnimated:NO];
            }
        }
        NSString* strOption = @"1";
        if (IsLogin)
        {
            strOption = [NSString stringWithFormat:@"1|1|%ld",lType];// @"1|1";
        }
        [[tztUIBaseVCOtherMsg getShareInstance] tztperformSelector:@"tztNetWorkChanged:" withObject:strOption];
        if (g_nSupportLeftSide || g_nSupportRightSide)
        {
            if (_rootTabBarController && _rootTabBarController.leftVC)
            {
                if(!IsLogin)
                {
                    [_rootTabBarController.leftVC tztTradeLogOut];
                }
                else if([TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])
                {
                    [_rootTabBarController.leftVC tztTradeLogIn];
                }
            }
        }
    }
}

- (void)deleteTztObj
{
    [TZTCSystermConfig freeShareClass];
    [tztUserData freeShareClass];
}

- (void)dealloc
{
	[self deleteTztObj];
	[super dealloc];
}

//初始化系统配置信息
+ (void)InitData
{
	static BOOL bRead = FALSE;
	if(bRead)
		return;
    bRead = TRUE;
    NSLog(@"%@",@"---------------------[TZTAppObj InitData] begin-------------");
    [TZTCSystermConfig initShareClass];
    NSLog(@"%@",@"---------------------[TZTCSystermConfig initShareClass] Succ-------------");
    [tztTechSetting getInstance];
    NSLog(@"%@",@"---------------------[tztTechSetting getInstance] Succ-------------");
    [tztTechSetting getInstance].backgroundColor = [UIColor colorWithRGBULong:0x202020];
    [TZTServerListDeal initShareClass];
    NSLog(@"%@",@"---------------------[TZTServerListDeal initShareClass] Succ-------------");
    return;
}

// 初始化通讯控制
+ (void)InitConnData
{
    [tztMoblieStockComm getSharezxInstance];
    [tztMoblieStockComm getSharehqInstance];
    [tztMoblieStockComm getShareInstance];
#ifdef TZT_OPENSSL
    [[tztMoblieStockComm getShareInstance] setOpenSSL:FALSE];
    [[tztMoblieStockComm getSharehqInstance] setOpenSSL:FALSE];
    [[tztMoblieStockComm getSharezxInstance] setOpenSSL:FALSE];
#endif
    [tztMoblieStockComm getAllInstance];
    [TZTAppObj InitServerList];
}

//初始化服务器信息
+ (void)InitServerList
{
#ifdef Support_HXSC
    [tztMoblieStockComm getAllInstance];
    NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
    [[tztMoblieStockComm getSharezxInstance] onSendDataAction:@"46" withDictValue:pDict];
#endif
    //初始化统一市场列表
    if (g_pReportMarket == NULL)
        g_pReportMarket = NewObject(TZTInitReportMarketMenu);
    
#ifdef tzt_LocalStock
    if (g_pInitStockCode == NULL)
        g_pInitStockCode = NewObject(tztInitStockCode);
#endif
    
    //加载tabBar
    if (g_pTZTTabBarProfile == NULL)
    {
        g_pTZTTabBarProfile = NewObject(TZTTabBarProfile);
        [g_pTZTTabBarProfile LoadTabBarItem];
    }
    
	[TZTUserInfoDeal SaveAndLoadLogin:TRUE nFlag_:0];//读取保存的用户信息
	[TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllServer_Log];
    [tztlocalHTTPServer getShareInstance];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        NSDate *now= [NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:100];//10秒后通知
        notification.repeatInterval=1;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        notification.alertBody=@"通知内容";//提示信息 弹出提示框
        notification.alertAction = @"打开";  //提示框按钮
        //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        //notification.userInfo = infoDict; //添加额外的信息
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [now release];
    }
    [notification release];
}



//判断是否需要显示沪深行情视图
#pragma mark  UINavigationControllerDelegate
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



//创建viewController
+(NSMutableArray*)makeTabBarViewController
{
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    [controllers removeAllObjects];
    
    UIViewController *pVC = NULL;
    int nIndex = 0;
    if (g_pTZTTabBarProfile && [g_pTZTTabBarProfile HaveTabBarItem])
    {
        NSMutableArray *ayTabBarItem = g_pTZTTabBarProfile.ayTabBarItem;
        NSInteger nCount = [ayTabBarItem count];
        
        for (NSInteger i = 0; i < nCount; i++)
        {
            TZTPageInfoItem* pItem = [ayTabBarItem objectAtIndex:i];
            if (pItem == NULL)
                continue;
            
            pVC = [TZTAppObj GetTabBarViewController:0 wParam_:(NSUInteger)pItem lParam_:1];
            if (pVC == NULL)
                continue;
            [controllers addObject:pVC];
            nIndex++;
        }
    }
    
    return [controllers autorelease];
}

+(UIViewController*) GetTabBarViewController:(NSInteger)nType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0 || lParam != 1)
        return  NULL;
    
    TZTPageInfoItem *pItem = (TZTPageInfoItem*)wParam;
    if (![pItem isKindOfClass:[TZTPageInfoItem class]])
        return NULL;
    
    UIViewController *pViewController = [tztUIBaseVCOtherMsg GetTabBarViewController:pItem.nPageID wParam_:wParam lParam_:lParam];
    
    if (pViewController)
        return pViewController;
    
    
    
#if 1
    switch (pItem.nPageID)
    {
        case ReportHomePage://首页
        {
#ifdef Support_HomePage
            tztUIHomePageViewController *vc = NULL;
            vc = [[[tztUIHomePageViewController alloc] init] autorelease];
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
#endif
            break;
        }
        case ReportUserStPage://自选界面
        case ReportDPIndexPage://大盘指数
        {
            TZTUIReportViewController *vc = NULL;
            vc = [[[TZTUIReportViewController alloc] init] autorelease];
            vc.nTransType = TZTUIReportDetailType;
            
            vc.nPageType = pItem.nPageID;
            [vc setTitle:pItem.nsPageName];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case ReportGPMarketPage://股票市场
        {
            TZTUIReportViewController *vc = NULL;
            vc = [[[TZTUIReportViewController alloc] init] autorelease];
            vc.nTransType = TZTUIReportViewType;
            
            vc.nPageType = pItem.nPageID;
            [vc setTitle:pItem.nsPageName];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];  
        }
            break;
        case ReportNewInfoPage://资讯中心
        {
            tztZXCenterViewController *vc = NULL;
            vc = [[[tztZXCenterViewController alloc] init] autorelease];
            [vc setTitle:pItem.nsPageName];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case ReportGPTradePage://委托交易
        {
            NSLog(@"委托交易");
            tztUITradeViewController_iPad *vc = NULL;
            vc = [[[tztUITradeViewController_iPad alloc] init] autorelease];
            [vc setTitle:pItem.nsPageName];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case ReportServicePage://服务中心
        {
            tztUIServiceCenterViewController_iPad* vc = NULL;
            vc = [[[tztUIServiceCenterViewController_iPad alloc] init] autorelease];
            [vc setTitle:pItem.nsPageName];
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case ReportTZTMessage: // 投资快递
        case ReportTZTChaoGen: // 我的炒跟 byDBQ20130725
        case ReportETHeper:
        case ReportWSTInfoPage:
        {
            TZTUIBaseViewController *vc = NULL;
            vc = [[[TZTUIBaseViewController alloc] init] autorelease];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case ReportWebInfo://投保服务
        {
#ifdef Support_TBFW
            tztUIWebTZProtectVC* vc = NULL;
            vc = [[[tztUIWebTZProtectVC alloc] init] autorelease];
            vc.nHasToolbar = 0;
            [vc setWebURL:@"http://wap.dgzq.com.cn/cgi-bin/wap/ProtectAction"];
            [vc setTitle:pItem.nsPageName];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            
            pViewController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
#endif
        }
            break;
            
            /*ajax测试*/
//        case tztNewForAjax1:
//        case tztNewForAjax2:
//        case tztNewForAjax3:
//        case tztNewForAjax4:
//        case tztNewForAjax5:
//        {
//            tztWebViewController *vc = NULL;
//            vc = [[[tztWebViewController alloc] init] autorelease];
//            vc.nHasToolbar = NO;
//            NSString* strFile = @"/htzllcajax/index.htm";
//            NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];
//            [vc setLocalWebURL:strUrl];
//            
//            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
//            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
//            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
//            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
//            
//        }
//            break;
   
            /*iphone版本底部显示*/
        case tztHomePage:
        {
            tztHomePageViewController_iphone *vc = NULL;
            vc = [[[tztHomePageViewController_iphone alloc] init] autorelease];
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztMarketPage:  //行情
        {
            tztMenuViewController_iphone *vc = NULL;
            vc = [[[tztMenuViewController_iphone alloc] init] autorelease];
            
            [vc setTitle:@"综合排名"];
            vc.nsHiddenMenuID = @"1|12|5|10|13";//此处根据各个版本区分，或者改成配置
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztInfoPage:  //咨询
        {
            tztZXCenterViewController_iphone *vc = NULL;
            vc = [[[tztZXCenterViewController_iphone alloc] init] autorelease];
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztTradePage:  //交易
        {
            tztNineCellViewController *vc = NULL;
            vc = [[[tztNineCellViewController alloc] init] autorelease];
            vc.fCellSize = 60;
            NSArray *pAyCell = [g_pSystermConfig.pDict objectForKey:@"TZTTradeGrid"];
            if (pAyCell && [pAyCell count] > 0)
            {
                NSInteger nCol = [[g_pSystermConfig.pDict objectForKey:@"tztNineCol"] intValue];
                if (nCol <= 0)
                    nCol = 3;
                
                NSInteger nPerRow = [[g_pSystermConfig.pDict objectForKey:@"tztNineRow"] intValue];
                if (nPerRow <= 0)
                    nPerRow = 4;
                NSInteger nRow = [pAyCell count] / nCol;
                if ([pAyCell count] % nCol != 0)
                    nRow++;
                if (nRow < nPerRow)
                    nRow = nPerRow;
                
                vc.nCol = nCol;
                vc.nRow = nRow;
                vc.nsTitle = @"委托交易";
                vc.pAyNineCell = pAyCell;
            }
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztMorePage:  //更多
        {
            
        }
            break;
        case tztServicePage://服务
        {
            tztUIServiceCenterViewController *vc = NULL;
            vc = [[[tztUIServiceCenterViewController alloc] init] autorelease];
            vc.nsProfileName = [NSString stringWithFormat:@"%@", @"tztTableSystemSetting"];
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            vc.nMsgType = Sys_Menu_ServiceCenter;
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        //添加东莞功能 add by xyt 20130925    
        case ReportCFT://财富通
        {
            Class vcClass = [[NSBundle mainBundle] classNamed:@"tztUICFTViewController"];
            if (vcClass != NULL)
            {
                UIViewController* vc = [[[vcClass alloc] init] autorelease];
                [vc setTitle:pItem.nsPageName];
                [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
                pViewController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
                [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
                pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
            }
        }
            break;
        case ReportTQ://TQ
        {
            Class vcClass = [[NSBundle mainBundle] classNamed:@"tztUITQViewController"];
            if (vcClass != NULL)
            {
                UIViewController* vc = [[[vcClass alloc] init] autorelease];
                [vc setTitle:pItem.nsPageName];
                [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
                pViewController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
                [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
                pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
            }
        }
            break;
        //添加齐鲁功能add by xyt 20130930
        case ReportTSInfoPage://财富泰山 
        {            
            Class vcClass = [[NSBundle mainBundle] classNamed:@"tztUICFTSWebVC"];
            if (vcClass != NULL)
            {
                UIViewController *vc = [[[vcClass alloc] init] autorelease];
                [vc setTitle:pItem.nsPageName];
                pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
                [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
                pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
            }
        }
            break;
        case ReportRZRQTradePage://融资融券
        {
            Class vcClass = [[NSBundle mainBundle] classNamed:@"tztUIRZRQTradeViewController_iPad"];
            if (vcClass != NULL)
            {
                UIViewController *vc = [[[vcClass alloc] init] autorelease];
                [vc setTitle:pItem.nsPageName];
                pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
                [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
                pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
            }
        }
            break;
            
        case ZXKFPage: // 在线客服
        {
            Class vcClass = [[NSBundle mainBundle] classNamed:@"TZTZXKFViewController_iPad"];
            if (vcClass != NULL)
            {
                UIViewController *vc = [[[vcClass alloc] init] autorelease];
                [vc setTitle:pItem.nsPageName];
                pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
                [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
                pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
            }
        }
            break;
        default:
            break;
    }
#endif
    return pViewController;
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    viewController.view.alpha = 0.2f;
//    [UIView beginAnimations:@"fadeIn" context:nil];
//    [UIView setAnimationDuration:1.0];
//    viewController.view.alpha = 1.0f;
//    [UIView commitAnimations];
}


#pragma tztAppobjDelegate
-(void)tztAppObjCallAppViewControl
{
    [[TZTAppObj getShareInstance] setInitFlag:FALSE];
    static BOOL bFirst = TRUE;
    if(bFirst)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.3f
                                         target:self
                                   selector:@selector(Test)
                                   userInfo:nil
                                    repeats:NO];
        bFirst = FALSE;
    }
}

-(void)Test
{
    static BOOL bShow = TRUE;
    if (!bShow)//确保整个函数只调用一次/*没有网络时候，打开程序，均衡没有返回，但初始化超时直接进入程序，然后打开网络，均衡返回，又执行到这里，会把最上层的vc给remove掉，导致出现黑屏显示*/
        return;
    [self InitWithApp:self.dictCallParam withDelegate:g_pTZTDelegate];
    
    if (self.nsTztURL && !_bInitApplication)
    {
//        _bInitApplication = TRUE;
        [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] handleOpenURL:self.nsTztURL];
    }
    _bInitApplication = TRUE;
    
    if (bShow)
    {
        bShow = FALSE;
        /*显示免责条款*/
        [TZTUserInfoDeal SaveAndLoadLogin:TRUE nFlag_:0];
#ifdef Support_EXE_VERSION//独立版本显示免责条款
        NSMutableDictionary * dictFlag = GetDictByListName(@"MZTKFlag");
        BOOL needNoMZTK = [[dictFlag objectForKey:@"NeedMZTKFlag"] boolValue];
        if (!needNoMZTK)
        {
            NSError *error;
            NSString* strPath = [[NSBundle mainBundle] pathForResource:@"MZTK" ofType:@"txt"];
            NSString* strData = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:&error];
            
            if (strData && [strData length] > 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"免责条款"
                                                                message:strData
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                alert.tag = 0x1234;
                [alert show];
                [alert release];
            }
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:@"1" forKey:@"NeedMZTKFlag"];
            SetDictByListName(pDict, @"MZTKFlag");
            [pDict release];
        }
#endif
    }
    
    if (g_pTztUpdate)
        [g_pTztUpdate CheckUpdate];
    
    if (g_pReportMarket)
    {
        [g_pReportMarket RequestLocation];
    }
    return;
}


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
            }
                break;
            default:
            {
            }
                break;
        }
    }
}

-(void)tztAppObjOnReturnBack
{
    if (_rootTabBarController)
    {
        [_rootTabBarController OnReturnPreSelect];
    }
}

-(void)tztAppObj:(id)sender didSelectItemByIndex:(int)nIndex options_:(NSMutableDictionary *)options
{
    if (_rootTabBarController)
    {
        [_rootTabBarController didSelectItemByIndex:nIndex options_:options];
    }
}

-(void)tztAppObj:(id)sender didSelectItemByPageType:(int)nType options_:(NSMutableDictionary *)options
{
    if (_rootTabBarController)
    {
        [_rootTabBarController didSelectItemByPageType:nType options_:options];
        NSString* strPopToRoot = [options tztObjectForKey:@"tztPopToRoot"];
        if ([strPopToRoot intValue] == 1 || nType == tztHomePage)
        {
            [g_navigationController popToRootViewControllerAnimated:NO];
        }
    }
    
}
//zxl 20131012 添加了ipad 交易退出特殊处理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 0x1111:
        {
            [TZTUIBaseVCMsg OnMsg:WT_OUT wParam:0 lParam:0];
            [g_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
            if (buttonIndex == 0)//注销账号
            {
                tztAfxMessageBox(@"账号退出成功!");
            }
            else//切换账号
            {
                [g_pToolBarView OnDealToolBarAtIndex:[g_pToolBarView GetTabItemIndexByID:0x00000100] options_:nil]; // 根据ID定位比索引靠谱 byDBQ20131023
            }
        }
            break;
        default:
            break;
    }
}
- (void)TZTUIMessageBox:(TZTUIMessageBox *)pMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (pMessageBox.tag)
    {
        case 0x1111:
        {
            
            if (buttonIndex == 0)//注销账号
            {
                [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
                [tztJYLoginInfo SetLoginAllOut];
                tztAfxMessageBox(@"账号退出成功!");
                return;
            }
            else//切换账号
            {
#ifdef Support_EXE_VERSION
                [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
                [tztJYLoginInfo SetLoginAllOut];
                int n = [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:0 wParam:0 lParam:0];
                TZTLogInfo(@"%@", n ? @"已登录" : @"未登录" );
#endif
            }
        }
            break;
            
        default:
            break;
    }
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

#pragma 10054下载文件
-(void)tztDownloadFile:(NSString*)strParam
{
    if (_pCommRequest == NULL)
        _pCommRequest = NewObject(tztCommRequestView);
    
    [_pCommRequest DownloadFile:strParam];
}

#pragma --打开文档
-(void)OnOpenDocument:(NSNotification*)notification
{
    [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:[tztUIDocumentViewController getShareInstance]];
    [[tztUIDocumentViewController getShareInstance] OpenDocument:notification];
    
    return;
    if (notification && [notification.name compare:TZTNotifi_OpenDocument] == NSOrderedSame)
    {
        NSString* str = (NSString*)notification.object;
        self.nsFilePath = [NSString stringWithFormat:@"%@", str];
        if (_pDocumentVC == NULL)
        {
            self.pDocumentVC = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:str]];
            self.pDocumentVC.delegate = self;
            BOOL bOpenSucc = [self.pDocumentVC presentPreviewAnimated:YES];//
            if (!bOpenSucc)
            {
                NSArray *pAy = [str componentsSeparatedByString:@"/"];
                if (pAy && [pAy count] > 0)
                {
                    str = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:[pAy count] - 1]];
                }
                NSString* strMsg = [NSString stringWithFormat:@"打开文件失败,文件类型：%@", str];
                tztAfxMessageBox(strMsg);
                self.pDocumentVC = nil;
                [self DeleteSavedFile:self.nsFilePath];
                return;
            }
            //            self.pDocumentVC.name = @"华彩人生";
        }
        else
            self.pDocumentVC.name = [NSString stringWithFormat:@"%@", str];
        _bRefresh = TRUE;
    }
}

- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
{
    UIViewController *pVC = nil;// g_navigationController.topViewController;
    if (IS_TZTIOS(5))
    {
        pVC = g_navigationController.topViewController.presentedViewController;
    }
    else
        pVC = g_navigationController.topViewController.modalViewController;
    
    if (pVC == NULL)
        return g_navigationController.topViewController;
    else
        return pVC;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    UIView *pView = nil;//g_navigationController.topViewController.view;
    if (IS_TZTIOS(5))
    {
        pView = g_navigationController.topViewController.presentedViewController.view;
    }
    else
        pView = g_navigationController.topViewController.modalViewController.view;
    
    if (pView == NULL)
        return g_navigationController.topViewController.view;
    else
        return pView;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return g_navigationController.topViewController.view.frame;
}
// 点击预览窗口的“Done”(完成)按钮时调用

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)_controller
{
    self.pDocumentVC = nil;
    [self DeleteSavedFile:self.nsFilePath];
}

-(void)DeleteSavedFile:(NSString*)strFileName
{
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    
    NSError *error = NULL;
    /*BOOL bSucc = */[defaultManager removeItemAtPath:strFileName error:&error];
    
    //    NSLog(@"%@", [error description]);
}


+(int)getDefaultStartIndex
{
    int nDefault = -1;
    //获取当前系统时间
    //获得系统时间
    NSMutableDictionary* pDict = GetDictByListName(@"tztstartpageset");
//    //0-默认 1-热点，2-自选，3-市场
    if (pDict == NULL || [[pDict tztObjectForKey:@"tztstartpage"] intValue] == 0)
    {
//        NSDate *  senddate=[NSDate date];
//        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"HH:mm"];
//        NSString *  locationString = [dateformatter stringFromDate:senddate];
//        NSArray *ay = [locationString componentsSeparatedByString:@":"];
//        if ([ay count] == 2)
//        {
//            int nHour = [[ay objectAtIndex:0] intValue];
//            int nMin = [[ay objectAtIndex:1] intValue];
//            
//            
//            if ((nHour*60+nMin) >= 570 && (nHour*60+nMin) <= 960)
//            {
//                nDefault = 3;//开市选择市场
//            }
//            else
//            {
//                nDefault = 1;//闭市选择首页
//            }
//        }
//        [dateformatter release];
    }
    else
    {
        return [[pDict tztObjectForKey:@"tztstartpage"] intValue];
    }
    
    return nDefault;
}
@end

#endif
