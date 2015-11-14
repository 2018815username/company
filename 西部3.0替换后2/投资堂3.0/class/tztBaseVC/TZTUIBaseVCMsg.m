
#import <tztMobileBase/tztNSLocation.h>
#import "TZTUIBaseVCMsg.h"
#import "tztMainViewController.h"
#import "TZTInitReportMarketMenu.h"

#import "tztBaseSetViewController.h"

#import "tztUITradeLogindViewController.h"

#import "TZTUIReportViewController.h"

#import "tztUIFenShiViewController_iphone.h"
#import "tztUIReportViewController_iphone.h"
#import "tztMenuViewController_iphone.h"
#import "tztHomePageViewController_iphone.h"

#import "tztUISearchStockViewController.h"
#import "tztUISearchStockCodeVCEx.h"

#import "tztUserStockEditViewController.h"
#import "tztWebViewController.h"
#import "tztZXCenterViewController_iphone.h"
#import "tztZXContentViewController.h"
#import "tztNineCellViewController.h"
#import "tztUIStockBuySellViewController.h"
#import "tztUITradeSearchViewController.h"
#import "TZTUIDateViewController.h"
#import "tztUIAddAccountViewController.h"
#import "tztUIBankDealerViewController.h"
#import "tztUIListDetailViewController.h"
#import "tztUITradeWithDrawViewController.h"
#import "tztUIChangePWViewController.h"
#import "tztUISysLoginViewController.h"
#import "tztUIServiceCenterViewController.h"
#import "tztCommRequstViewController.h"

#import "tztUISearchStockViewController_iPad.h"
#import "tztUIHQHoriViewController_iphone.h"
#import "tztUIAddOrDelectServerViewController.h"
#import "tztUIFuctionListViewController.h"
#import "tztWebInfoContentViewController.h"

#import "tztUITrendViewController.h"
#import "TZTUserStockDetailViewController.h"

#ifdef Support_OptionTrade
#import "tztOptionBuySellViewController.h"
#import "tztCoveredLockViewController.h"
#import "tztOptionSearchViewController.h"
#endif

#ifdef Support_THB
#import "tztUITHBSearchViewController.h"
#endif

#ifdef Support_HomePage
#import "tztUIHomePageViewController.h"
#endif
#import "tztUIBaseVCOtherMsg.h"

#ifdef Support_FundTrade
#import "tztUIFoundSGOrRG.h"
#import "tztUIFountSearchWTVC.h"
#import "tztUIFoundHKVC.h"
#import "tztUIFundFHVC.h"
#import "tztUIFundCNTradeVC.h"
#import "tztUIFundCFVC.h"
#import "TZTUIFundDTKHVC.h"
#import "tztUIFundZHVC.h"
#import "tztFundFxVC.h"
#import "TZTUIFundZHSGViewController.h"
#import "tztUIFundZHSGSearchViewController.h"
#import "tztUIFundZHSHViewController.h"
#import "tztUIFundZHInfoViewController.h"
#endif

#ifdef Support_RZRQ
#import "tztRZRQBankDealerView.h"
#import "tztUIRZRQBuySellViewController.h"
#import "tztUIRZRQStockHzViewController.h"
#import "tztUIRZRQWithDrawViewController.h"
#import "tztUIRZRQSearchViewController.h"
#import "tztUIRZRQChangePWViewController.h"
#import "tztUIRZRQFundReturnViewController.h"
#import "tztUIRZRQBankDealerViewController.h"
#import "tztUIRZRQCrashRetuenViewController.h"
#import "tztUIRZRQNeedPTLoginViewController.h"
#import "tztUIRZRQVotingViewController.h"
#endif

#ifdef Support_SBTrade
#import "tztUISBTradeBuySellViewController.h"
#import "tztUISBTradeSearchViewController.h"
#import "tztUISBTradeWithDrawViewController.h"
#import "tztUISBTradeHQSelectViewController.h"
#endif

#ifdef Support_DFCG
#import "tztUIDFCGBankDealerViewController.h"
#import "tztUIDFCGSearchViewController.h"
#endif

#ifdef Support_TradeETF
#import "tztUIETFCrashRGVC.h"
#import "tztUIETFStockRGVC.h"
#import "tztUIETFSearchVC.h"
#import "tztUIETFWithDrawVC.h"
#endif

#import "tztUIHisTrendViewController.h"

#ifdef Support_HKTrade
#import "tztUIHKBuySellViewController.h"
#endif

#ifdef kSUPPORT_XBSC
#import "RZRQMacro.h"
#endif

#import "TztViewController.h"

extern NSString* g_nsUserCardID;        //资金理财身份证号码
extern NSString* g_nsUserInquiryPW;     //资金理财查询密码

int RequestUserStockType;
enum{
    TFlushNone  = UIViewAnimationTransitionNone,
    TFlushRight  = UIViewAnimationTransitionFlipFromLeft,
    TFlushLeft = UIViewAnimationTransitionFlipFromRight,
    TFlushUp    = UIViewAnimationTransitionCurlUp,
    TFlushDown  = UIViewAnimationTransitionCurlDown,
};
@interface TZTUIBaseVCMsg (tztPrivate)

//判断相同的vc是否已经存在，若存在，则pop到该类的前一个vc，保证不重复显示，不无限push vc
+(UIViewController*)CheckCurrentViewContrllers:(Class)vcClass;
+(UIViewController*)CheckCurrentViewContrllers:(Class)vcClass withPageID_:(int)nPageID;
//返回同一个类创建的vc
+(UIViewController*)GetSameClassViewController:(Class)vcClass;
+(void) CheckWebViewControllers:(NSInteger)nType;

+(BOOL) OnAjaxAction:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;//ajax调用功能

+(BOOL) OnMenuMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
+(BOOL) OnSysMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
+(BOOL) OnHQMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
+(BOOL) OnTradeMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
+(BOOL) OnTradeFundMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
+(BOOL) OnTradeETFMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
@end

@implementation TZTUIBaseVCMsg
//从基金交易转到系统登录
+(BOOL) SystermLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam delegate:(id)delegate isServer:(BOOL)bServer
{
    int nDeal = 0;
    TZTUIMessage *pMessage = NewObjectAutoD(TZTUIMessage);
    pMessage.m_nMsgType = nMsgType;
    pMessage.m_wParam = wParam;
    pMessage.m_lParam = lParam;
    pMessage.m_lRev1 = (NSUInteger)delegate;
    nDeal = (int)[[tztUIBaseVCOtherMsg getShareInstance] tztperformSelector:@"tztSystermLogin:" withObject:pMessage];
    if (nDeal == -1)
        return TRUE;
    
    [tztUserData getShareClass];
    if (g_pSystermConfig && g_pSystermConfig.bNeedRegist)
    {
        NSString* strLogMobile = [tztKeyChain load:tztLogMobile];
#ifdef Support_HTSC
        if (g_CurUserData && g_CurUserData.nsMobileCode && g_CurUserData.nsMobileCode.length > 0 && ![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
        {
            strLogMobile = g_CurUserData.nsMobileCode;
            [tztKeyChain save:tztLogMobile data:strLogMobile];
            [TZTUserInfoDeal SetTradeLogState:Trade_Login lLoginType_:Systerm_Log];
        }
        if ([strLogMobile length] < 11 /*|| ![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log]*/)
#else
        if ([strLogMobile length] < 11 || ![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
#endif
        {
            //系统登录
            tztUISysLoginViewController* pVC = [[tztUISysLoginViewController alloc] init];
            [pVC setVcShowKind:tztvckind_Pop];
            pVC.nMsgType = MENU_SYS_UserLogin;
            [pVC setMsgID:nMsgType MsgInfo:(void*)wParam LPARAM:lParam];
            pVC.delegate = delegate;
            pVC.bIsServer = bServer;
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 500);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else
            {
//#ifdef tzt_NewVersion
//                [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
//#else
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
//#endif
            }
            if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
            {
                [pVC setTitle:@"行情登录"];
            }
            [pVC release];
            return TRUE;
        }
    }
    return FALSE;
}

+(BOOL) SystermLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    return [TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam delegate:nil isServer:FALSE];
}

+(BOOL) tztTradeLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam lLoginType:(NSUInteger)lLoginType delegate:(id)delegate
{
    
    int nDeal = 0;
    TZTUIMessage *pMessage = NewObjectAutoD(TZTUIMessage);
    pMessage.m_nMsgType = nMsgType;
    pMessage.m_wParam = wParam;
    pMessage.m_lParam = lParam;
    pMessage.m_lRev1 = lLoginType;
    pMessage.m_lRev2 = (NSUInteger)delegate;
    nDeal = (int)[[tztUIBaseVCOtherMsg getShareInstance] tztperformSelector:@"tztTradeLogin:" withObject:pMessage];
    if (nDeal == -1)
        return FALSE;
    BOOL bIsHaveLogin = FALSE;
    switch (lLoginType)
    {
        case TZTAccountRZRQType:
            bIsHaveLogin = [TZTUserInfoDeal IsHaveTradeLogin:RZRQTrade_Log];
            break;
        case TZTAccountPTType:
            bIsHaveLogin = [TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log];
            break;
        case TZTAccountHKType:
            bIsHaveLogin = [TZTUserInfoDeal IsHaveTradeLogin:HKTrade_Log];
            break;
        case TZTAccountQHType:
            bIsHaveLogin = [TZTUserInfoDeal IsHaveTradeLogin:FuturesTrade_Log];
            break;
        case TZTAccountCommLoginType:
            bIsHaveLogin = [TZTUserInfoDeal IsHaveTradeLogin:Trade_CommPassLog];
            break;
        default:
            break;
    }
    //没有登录
    if (!bIsHaveLogin)
    {
        BOOL bPush = FALSE;
        tztUITradeLogindViewController *pVC = (tztUITradeLogindViewController *)gettztHaveViewContrller([tztUITradeLogindViewController class], tztvckind_Pop,[NSString stringWithFormat:@"%d", MENU_SYS_JYLogin], &bPush,TRUE);
        [pVC retain];
        pVC.nMsgType = MENU_SYS_JYLogin;
        pVC.nLoginType = lLoginType;
        pVC.tztDelegate = delegate;
        [pVC setMsgID:nMsgType MsgInfo:(void*)wParam LPARAM:(void*)lParam];
        if (IS_TZTIPAD)
        {
            TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
            if (!pBottomVC)
                pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
            CGRect rcFrom = CGRectZero;
            rcFrom.origin = pBottomVC.view.center;
            rcFrom.size = CGSizeMake(500, 500);
            [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
        }
        else if(bPush)
        {
//#ifdef tzt_NewVersion
//            [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
//#else
            [pVC SetHidesBottomBarWhenPushed:YES];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
//#endif
            //            [g_navigationController pushViewController:pVC animated:UseAnimated];
        }
        [pVC release];
        return FALSE;
    }
    return TRUE;

}

+(BOOL) tztTradeLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam lLoginType:(NSUInteger)lLoginType
{
    return [TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:lLoginType delegate:nil];
}

+(BOOL) tztTradeLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    return [TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountPTType];
}


+(BOOL) OnMenuActionMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    switch(nMsgType)
    {
        case ID_MENU_AJAXTEST:
        {
            TztViewController *pVC = [[TztViewController alloc] init];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
            
        default:
            return FALSE;
    }
    return TRUE;
}
//传入功能号和参数
+(void) OnMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    if(nMsgType == ID_MENU_ACTION)
    {
        //ajax调用功能
        if ([TZTUIBaseVCMsg OnAjaxAction:nMsgType wParam:wParam lParam:lParam])
            return;
        else
        {
            NSString* strValue = (NSString*)wParam;
            NSRange pathRang = [strValue rangeOfString:@"?"];
            NSString* strParam = @"";
            NSString* strPath = strValue;
            if(pathRang.location == NSNotFound) //不带参数
            {
                strParam = @"";
            }
            else
            {
                strPath = [strValue substringToIndex:pathRang.location-1];
                strParam = [strValue substringFromIndex:pathRang.location+pathRang.length];
            }
            
            int nType = [strPath intValue];
            if (strParam == NULL || strParam.length <= 0)
                [TZTUIBaseVCMsg OnMsg:nType wParam:0 lParam:lParam];
            else
                [TZTUIBaseVCMsg OnMsg:nType wParam:(NSUInteger)strParam lParam:lParam];
            return;
        }
    }
    if ([tztUIBaseVCOtherMsg OnMsg:nMsgType wParam:wParam lParam:lParam])
    {
        return;
    }
    
    if (IsUserLogin(nMsgType) && [TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam])
        return;
    
    if(nMsgType > ID_MENU_ACTION && nMsgType < HQ_MENU_BEGIN)
    {
        [TZTUIBaseVCMsg OnMenuActionMsg:nMsgType wParam:wParam lParam:lParam];
        return;
    }
    
    //个股期权功能独立出来处理,测试，应该要先系统登录留痕
    if (IsOptionMsgType(nMsgType))
    {
        [TZTUIBaseVCMsg OnTradeOptionMsg:nMsgType wParam:wParam lParam:lParam];
        return;
    }
    
    //操作功能
    if ([TZTUIBaseVCMsg OnMenuMsg:nMsgType wParam:wParam lParam:lParam])
    {
        return;
    }
    if ((nMsgType >= TZT_MENU_SYS_BEGIN) && (nMsgType <= TZT_MENU_SYS_END))
    {
        if ([TZTUIBaseVCMsg OnSysMsg:nMsgType wParam:wParam lParam:lParam])
            return;
    }
    //行情功能
    if ((nMsgType >= HQ_MENU_BEGIN && nMsgType <= HQ_MENU_END )
        || (nMsgType >= TZT_MENU_HQ_BEGIN && nMsgType <= TZT_MENU_HQ_END )
        || (nMsgType >= MENU_SYS_UserExpress && nMsgType <= MENU_SYS_ExpressFavorite ))
    {
        if([TZTUIBaseVCMsg OnHQMsg:nMsgType wParam:wParam lParam:lParam])
            return;
    }

    //交易功能,预警，
    if ([TZTUIBaseVCMsg OnTradeMsg:nMsgType wParam:wParam lParam:lParam])
    {
        return;
    }
    
    
    switch (nMsgType)
    {
            //页面调用市场行情
            /*hqmenuitem=&&isblock=&&subitempos=*/
        case TZT_MENU_HQMarket:
        {
            NSString* strValue = (NSString*)wParam;
            strValue = [strValue tztdecodeURLString];
            NSMutableDictionary * pDict = (NSMutableDictionary*)[NSDictionary GetDictFromParam:strValue];
            NSString* strHQMarketID = [pDict tztObjectForKey:@"hqmenuitem"];
            if (strHQMarketID.length <= 0)
                strHQMarketID = @"";
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)strHQMarketID lParam:0];
        }
            break;
        case HQ_MENU_UploadUserStock:
        case TZT_MENU_UpUserStock:
        {
            [tztUserStock UploadUserStock:YES];
        }
            break;
        case HQ_MENU_DownloadUserStock:
        case TZT_MENU_DownUserStock:
        {
            [tztUserStock DownloadUserStock];
        }
            break;
        case HQ_MENU_MergeUserStock:
        case TZT_MENU_MergeUserStock:
        {
            [tztUserStock MergerUserStock];
        }
            break;
        case TZT_MENU_Share://分享 http://action:10055?url=xxxx&&title=xxxx&&message=xxxx&&sharetype=
        {
            NSString* strValue = (NSString*)wParam;
            strValue = [strValue tztdecodeURLString];
            NSMutableDictionary * pDict = (NSMutableDictionary*)[NSDictionary GetDictFromParam:strValue];
            if (pDict == NULL || [pDict count] < 1)
            {
                pDict = NewObjectAutoD(NSMutableDictionary);
                [pDict setTztObject:@"www.tzt.cn" forKey:@"url"];
                [pDict setTztObject:g_pSystermConfig.strMainTitle forKey:@"title"];
                [pDict setTztObject:g_pSystermConfig.strMainTitle forKey:@"message"];
            }
            
#ifdef tzt_Share
            UIView *viewWindow = [[UIApplication sharedApplication] keyWindow];
            [TZTShareObject addShareViewin:viewWindow withDelegate:(id)g_navigationController.topViewController andInfo:pDict];
#endif
        }
            break;
        case TZT_MENU_OpenOtherApp://打开第三方应用
        {
            NSString* strValue = (NSString*)wParam;
            NSDictionary * pDict = [NSDictionary GetDictFromParam:strValue];
            NSString* strUrl = [pDict tztObjectForKey:@"appurl"];
            if (strUrl.length < 1)
                return;
            //直接先打开应用
            strUrl = [strUrl tztdecodeURLString];
            BOOL bOpenSucc = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
            
            if (bOpenSucc)//打开成功，不需要下载
                return;
            //打开失败，通过下载地址进行下载
            NSString* strDownload = [pDict tztObjectForKey:@"downloadurl"];
            if (strDownload.length < 1)
                return;
            
            strDownload = [strDownload tztdecodeURLString];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strDownload]];
        }
            break;
            //缓存清除
        case TZT_MENU_ClearCache:
        {
            NSString* strValue = (NSString*)wParam;
            NSDictionary * pDict = [NSDictionary GetDictFromParam:strValue];
            NSString* strUrl = [pDict tztObjectForKey:@"clearall"];
            NSString* strJs = [pDict tztObjectForKey:@"JsFuncName"];
            if (strUrl.length < 1 || [strUrl intValue] != 1)
                [[tztlocalHTTPServer getShareInstance] onInitData];//清除本地缓存
            else//删除所有数据
            {
                [NSString tztHttpFileDeleteAll];
                if (lParam != 0)
                {
                    tztWebView *webView = (tztWebView *)lParam;
                    if (strJs)
                        [webView tztperformSelector:@"tztStringByEvaluatingJavaScriptFromString:" withObject:strJs];
                }
            }
        }
            break;
        case TZT_TabBar_Status:
        {
            NSString* strData = (NSString*)wParam;
            //记录文件
            NSString* nsFileName = tztTabbarStatusFile;
            NSString* strPath = [nsFileName tztHttpfilepath];
            NSDictionary *pDict = nil;
            if (strData == NULL)
                pDict = [[[NSDictionary alloc] init] autorelease];
            else
                pDict = [NSDictionary GetDictFromParam:strData];
            NSError *error = nil;
            [pDict writeToFile:strPath atomically:YES];
            if (error)
            {
                TZTLogInfo(@"Action:1901,写文件出错，原因：%@",[error description]);
            }
            else
            {
                if (g_pToolBarView)
                    [g_pToolBarView ReloadToolBar:strData];
            }
        }
            break;
        case TZT_MENU_WebLogin://(10090)
        {
            NSString* strValue = (NSString*)wParam;
            NSDictionary * pDict = [NSDictionary GetDictFromParam:strValue];
            if (pDict == NULL)
                return;
            /*
             e.g:http://action:10090?logintype=1&loginkind=1&url=xxxxxxxxx
             loginType  :登陆类型 0-系统 1-交易 2-融资融券登录
             loginKind  :loginType＝1时，通知是强权限登陆或者是弱权限登陆 0-弱权限（通讯密码） 1－强权限（交易密码）
             url        :登陆成功后调转的url页面地址
             */
            int nLoginType = 1;//默认交易
            int nLoginKind = 1;//默认强权限登陆
            NSString* strLoginType = [pDict tztObjectForKey:@"logintype"];
            NSString* strLoginKinde = [pDict tztObjectForKey:@"loginkind"];
            
            NSRange pathRang = [strValue rangeOfString:@"url="];
            NSString* strUrl = [pDict tztObjectForKey:@"url"];
            if(pathRang.location == NSNotFound) //不带参数
            {
            }
            else
            {
                strUrl = [strValue substringFromIndex:pathRang.location+pathRang.length];
            }
            if (strUrl.length > 0)
                strUrl = [strUrl tztdecodeURLString];
            
            if (strUrl.length <= 0)
            {
                strUrl = [pDict tztObjectForKey:@"JsFuncName"];
                if (strUrl.length > 0)
                {
                    strUrl = [NSString stringWithFormat:@"JsFuncName=%@", strUrl];
                }
            }
            
            if (strLoginType && strLoginType.length > 0)
                nLoginType = [strLoginType intValue];
            if (strLoginKinde && strLoginKinde.length > 0)
                nLoginKind = [strLoginKinde intValue];
            
            nLoginKind = 1;//只有强权限
            //判断当前是否已经登录
            BOOL bLogin = FALSE;
            if (nLoginType == 1)
            {
                //交易登陆
                if (nLoginKind == 1)
                {
                    bLogin = [TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log];
                    
                    if (bLogin)
                        [TZTUIBaseVCMsg OnMsg:HQ_MENU_OpenNewWebURL wParam:(NSUInteger)strUrl lParam:lParam];
                    else
                    {
                        if (![TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam])
                        {
                            [TZTUIBaseVCMsg tztTradeLogin:HQ_MENU_OpenNewWebURL wParam:(NSUInteger)strUrl lParam:lParam];
                        }
                    }
                }
                else
                {
                    //判断是否已经通讯密码登录
                    bLogin = [TZTUserInfoDeal IsHaveTradeLogin:Trade_CommPassLog];
                    if (bLogin)
                        [TZTUIBaseVCMsg OnMsg:HQ_MENU_OpenNewWebURL wParam:(NSUInteger)strUrl lParam:lParam];
                    else
                    {
                        if (![TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam])
                        {
                            BOOL bPush = FALSE;
                            tztUISysLoginViewController *pVC = (tztUISysLoginViewController *)gettztHaveViewContrller([tztUISysLoginViewController class], tztvckind_Pop,[NSString stringWithFormat:@"%d", MENU_SYS_JYLogin], &bPush,TRUE);
                            [pVC retain];
                            [pVC setMsgID:HQ_MENU_OpenNewWebURL MsgInfo:(void*)strUrl LPARAM:lParam];
                            if(bPush)
                            {
                                [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
                            }
                            if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
                            {
                                [pVC setTitle:@"行情登录"];
                            }

                            [pVC release];
                        }
                    }
                }
            }
            else if (nLoginType == 2)//融资融券登录
            {
                bLogin = [TZTUserInfoDeal IsHaveTradeLogin:RZRQTrade_Log];
                
                if (bLogin)
                    [TZTUIBaseVCMsg OnMsg:HQ_MENU_OpenNewWebURL wParam:(NSUInteger)strUrl lParam:lParam];
                else
                {
                    if (![TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam])
                    {
                        [TZTUIBaseVCMsg tztTradeLogin:HQ_MENU_OpenNewWebURL wParam:(NSUInteger)strUrl lParam:lParam lLoginType:TZTAccountRZRQType];
                    }
                }
            }
            else
            {
                [TZTUIBaseVCMsg SystermLogin:HQ_MENU_OpenNewWebURL wParam:(NSUInteger)strUrl lParam:lParam];
            }
        }
            break;
        case TZT_MENU_OpenWebInfoContent://打开指定web,新开一个vc
        {
            NSString* strEndcodeURL = (NSString*)wParam;
            NSString* strParam = strEndcodeURL;// [strEndcodeURL tztdecodeURLString];
            NSMutableDictionary* pDict = nil;
            if(strParam && [strParam length] > 0)
            {
                pDict = (NSMutableDictionary*)[strParam tztNSMutableDictionarySeparatedByString:@"&&"];
            }
            
            for (NSString* strKey in pDict.allKeys)
            {
                NSString* strValue = [[pDict objectForKey:strKey] tztdecodeURLString];
                [pDict setObject:strValue forKey:strKey];
            }
            
            //
            int nFirstType = 0;
            int nSecondType = 0;
            int nFullScreen = 0;
            NSString* strURL = @"";
            NSString* strFirstURL = @"";
            NSString* strSecondURL = @"";
            
            if (pDict == NULL)
                return;
            NSString* secondType = @"";
            secondType = [pDict tztObjectForKey:@"secondtype"];
            if (secondType && secondType.length > 0)
                nSecondType = [secondType intValue];
            else
                nSecondType = [[pDict tztObjectForKey:@"type"] intValue];
            
            NSString* firstType = @"";
            firstType = [pDict tztObjectForKey:@"firsttype"];
            if (firstType == NULL || firstType.length <= 0)
                nFirstType = 0;
            else
                nFirstType = [firstType intValue];
            
            nFullScreen = [[pDict tztObjectForKey:@"fullscreen"] intValue];
            strURL = [pDict tztObjectForKey:@"url"];
            strSecondURL = [pDict tztObjectForKey:@"secondurl"];
            if (!ISNSStringValid(strSecondURL))
                strSecondURL = [pDict tztObjectForKey:@"secondjsfuncname"];
            if (!ISNSStringValid(strSecondURL))
                strSecondURL = [pDict tztObjectForKey:@"secondsysfunction"];
            
            strFirstURL = [pDict tztObjectForKey:@"firsturl"];
            if (!ISNSStringValid(strFirstURL))
                strFirstURL = [pDict tztObjectForKey:@"firstjsfuncname"];
            if (!ISNSStringValid(strFirstURL))
                strFirstURL = [pDict tztObjectForKey:@"secondsysfunction"];
            
            /*判断上个vc是否是webvc，若是，判断是否还有webview，若没，则直接关闭*/
            UIViewController *pTmpVC = [TZTAppObj getTopViewController];
            if ([pTmpVC isKindOfClass:[tztWebViewController class]])
            {
                if (![(tztWebViewController*)pTmpVC IsHaveWebView])
                {
                    [g_navigationController popViewControllerAnimated:NO];
                }
            }
            /**/
            tztWebInfoContentViewController *pVC = [[tztWebInfoContentViewController alloc] init];
            pVC.nHasToolbar = 0;
            pVC.nMsgType = nMsgType;
            pVC.nSecondType = nSecondType;
            pVC.nFirstType = nFirstType;
            pVC.nFullScreen = nFullScreen;
            pVC.nsCurrenctURL = [[NSString stringWithFormat:@"%@", strURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            pVC.nsSecondURL = [[NSString stringWithFormat:@"%@", strSecondURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            pVC.nsFirstURL = [[NSString stringWithFormat:@"%@", strFirstURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            pVC.dictWebParams = pDict;
            if (strURL && strURL.length > 0)
            {
                if ([strURL hasPrefix:@"http://action:"])//认为是功能处理，直接跳转
                {
                    NSString* str = [strURL substringFromIndex:[@"http://action:" length]];
                    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:lParam];
                    [pVC release];
                    return;
                }
                else
                {
                    NSString* str = [[tztlocalHTTPServer getLocalHttpUrl:strURL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [pVC setWebURL:str];
                }
                
                [TZTUIBaseVCMsg tztPushViewContrller:pVC animated:UseAnimated fullScreen:nFullScreen];
//                if ([[tztUIBaseVCOtherMsg getShareInstance] respondsToSelector:@selector(tztPushViewController:animated:fullScreen:)])
//                {
//                    [tztUIBaseVCOtherMsg tztPushViewContrller:pVC animated:UseAnimated fullScreen:nFullScreen];
//                }
//                else
//                {
//                    if (nFullScreen)
//                    {
//                        [pVC SetHidesBottomBarWhenPushed:YES];
//                        [g_navigationController pushViewController:pVC animated:UseAnimated];
//                    }
//                    else
//                    {
//                        if (g_navigationController.topViewController.hidesBottomBarWhenPushed)
//                        {
//                            [pVC SetHidesBottomBarWhenPushed:YES];
//                        }
//                        [g_navigationController pushViewController:pVC animated:UseAnimated];
//                    }
//                }
                
            }
            
            [pVC release];
            return;
        }
            break;
        case TZT_MENU_GetGPSLocation:
        {
            NSString* strValue = (NSString*)wParam;
            NSMutableDictionary* pDict = nil;
            if(strValue && [strValue length] > 0)
            {
                pDict = (NSMutableDictionary*)[strValue tztNSMutableDictionarySeparatedByString:@"&&"];
            }
            
            NSString* strURL = [pDict tztObjectForKey:@"url"];
            if (strURL && [strURL length] > 0)
            {

                [tztNSLocation getShareClass].bHiddenTips = NO;
                [[tztNSLocation getShareClass] getLocation:^(NSString *strGpsX, NSString *strGpsY) {
                    
                    NSString* strtemp = [strURL stringByReplacingOccurrencesOfString:@"($tztgpsx)" withString:strGpsX];
                    strtemp = [strtemp stringByReplacingOccurrencesOfString:@"($tztgpsy)" withString:strGpsY];
                    
                    NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strtemp];
                    UIViewController *pVC = g_navigationController.topViewController;
                    if (pVC && [pVC isKindOfClass:[tztWebViewController class]])
                    {
                    // [(tztWebViewController*)pVC setWebURL:strUrl];
                        /**
                         wry 定位记得开起来
                         */
                        tztWebViewController *pWebVC = [[tztWebViewController alloc] init];
                        pWebVC.nTitleType = TZTTitleReturn;
                        pWebVC.nHasToolbar = 0;
                        [pWebVC setWebURL:strUrl];
                        [g_navigationController pushViewController:pWebVC animated:UseAnimated];
                        [pWebVC release];
                    }
                    else
                    {
                        tztWebViewController *pWebVC = [[tztWebViewController alloc] init];
                        pWebVC.nTitleType = TZTTitleReturn;
                        pWebVC.nHasToolbar = 0;
                        [pWebVC setWebURL:strUrl];
                        [g_navigationController pushViewController:pWebVC animated:UseAnimated];
                        [pWebVC release];
                    }
//                    [self tztSetWebViewUrl:strURL];
                }];
            }
        }
            break;
        case HQ_MENU_OpenNewWebURL:
        {
            NSString* strFile = (NSString*)wParam;
            if (strFile.length < 1)
                return;
            if ([strFile hasPrefix:@"http://action:"])
            {
                NSString *strURL = [strFile substringFromIndex:[@"http://action:" length]];
                [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strURL lParam:lParam];
                return;
            }
            if (lParam != 0)
            {
                tztBaseUIWebView* pWebView = (tztBaseUIWebView*)lParam;
                if (pWebView && [pWebView isKindOfClass:[tztBaseUIWebView  class]])
                {
                    
                    //调用js函数
                    if (strFile && [strFile hasPrefix:@"JsFuncName="])
                    {
                        NSArray *pAy = [strFile componentsSeparatedByString:@"="];
                        if ([pAy count] > 1)
                        {
                            NSString* str = [pAy objectAtIndex:1];
                            str = [str tztdecodeURLString];
                            [pWebView tztStringByEvaluatingJavaScriptFromString:str];
                            return;
                        }
                    }
//                    [pWebView closeCurHTTPWebView];
                    NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];
//                    [pWebView stopLoad];
                    [pWebView setWebURL:strUrl];
                    return;
                }
            }
            UIViewController *pTmpVC = [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztWebViewController class]];
            if (pTmpVC && [pTmpVC isKindOfClass:[tztWebViewController class]] && ![strFile hasPrefix:@"http://"]
                && ([[pTmpVC getVcShowType] intValue] != tztVcShowTypeRoot))
            {
                ((tztWebViewController*)pTmpVC).nHasToolbar = 1;
                ((tztWebViewController*)pTmpVC).nWebType = tztwebChaoGen;
                [((tztWebViewController*)pTmpVC) CleanWebURL];
                NSString* strUrl = strFile;
                strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];
                [(tztWebViewController*)pTmpVC setWebURL:strUrl];
            }
            else
            {
                tztWebViewController *pVC = [[tztWebViewController alloc] init];
                pVC.nHasToolbar = 1;
                pVC.nWebType = tztwebChaoGen;
                [g_navigationController pushViewController:pVC animated:UseAnimated];
                NSString* strUrl = strFile;
                if (![strFile hasPrefix:@"http://"])
                {
                    strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];
                }
                [pVC setWebURL:strUrl];
                [pVC release]; // Avoid potential leak.  byDBQ20131031
            }
        }
            return;
        case HQ_MENU_Info_Center://资讯中心 切换到资讯中心首页
        case MENU_SYS_InfoCenter:
        {
#ifdef tzt_NewVersion
            tztUINavigationController* pNav = [tztMainViewController getNavController:tztvckind_ZX];
            if (pNav) //资讯中心 清空资讯列表
            {
                [pNav popToRootViewControllerAnimated:NO];
            }
            [tztMainViewController didSelectNavController:tztvckind_ZX options_:NULL];
            [g_ayPushedViewController removeObject:pNav.topViewController];
            [g_ayPushedViewController addObject:pNav.topViewController];
#else
            tztZXCenterViewController_iphone * pVC = (tztZXCenterViewController_iphone*)[TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztZXCenterViewController_iphone class]];
            [pVC setVcShowKind:tztvckind_All];
            if (pVC == NULL)
            {
                pVC = [[tztZXCenterViewController_iphone alloc] init];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
                [pVC release];
            }
#endif
        }
            break;
        case HQ_MENU_Info_Content://资讯信息
        {
            tztInfoItem *pItem = (tztInfoItem*)wParam;
            UIView *_tztInfoView = (UIView*)lParam;
            if (pItem == NULL)
                return;
            //列表
            if (pItem.nIsIndex == 1)
            {
                BOOL bPush = FALSE;
                tztZXCenterViewController_iphone *pVC = (tztZXCenterViewController_iphone *)gettztHaveViewContrller([tztZXCenterViewController_iphone class], tztvckind_ZX, [NSString stringWithFormat:@"%d", tztVcShowTypeDif], &bPush,NO);
                [pVC retain];
                
                pVC.nMsgType = nMsgType;
                if (_tztInfoView && [_tztInfoView isKindOfClass:[tztInfoTableView class]])
                {
                    pVC.pStockInfo = ((tztInfoTableView*)_tztInfoView).pStockInfo;
                }
                pVC.pInfoItem = pItem;
                pVC.nsTitle = pItem.InfoContent;
                if (bPush)
                {
                    [pVC SetHidesBottomBarWhenPushed:YES];
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                }
                [pVC release];
            }
            //内容
            else if(pItem.nIsIndex == 0)
            {
                BOOL bPush = FALSE;
                tztZXContentViewController *pVC = (tztZXContentViewController *)gettztHaveViewContrller([tztZXContentViewController class], tztvckind_Pop, [NSString stringWithFormat:@"%ld", (long)nMsgType], &bPush,TRUE);
                [pVC retain];
                
                pVC.nMsgType = nMsgType;
                pVC.pInfoItem = pItem;
                if (_tztInfoView && [_tztInfoView isKindOfClass:[tztInfoTableView class]])
                {
                    pVC.pListView = _tztInfoView;
                    pVC.pStockInfo = ((tztInfoTableView*)_tztInfoView).pStockInfo;
                }
                pVC.pAyInfo = ((tztInfoTableView*)_tztInfoView).ayInfoData;
                
                if (IS_TZTIPAD)
                {
                    TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                    if (!pBottomVC)
                        pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                    CGRect rcFrom = CGRectZero;
                    rcFrom.origin = pBottomVC.view.center;
                    rcFrom.size = CGSizeMake(500, 580);
                    [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
                }
                else
                {
                    if (bPush)
                    {
//                        [pVC SetHidesBottomBarWhenPushed:YES];
                        [g_navigationController pushViewController:pVC animated:UseAnimated];
                    }
                }
                [pVC release];
            }
        }
            break;
        case HQ_MENU_MNJY://模拟交易
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_JY, [NSString stringWithFormat:@"%ld", (long)nMsgType], &bPush,TRUE);
            [pVC retain];
            if(IS_TZTIPAD)//pad版本没有底部的工具栏
                pVC.nHasToolbar = NO;
#ifdef tzt_NewVersion
            pVC.nHasToolbar = 0;
#else
            pVC.nHasToolbar = 1;
#endif
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"模拟交易"];
            
            NSString* strFile = @"mncgregisterajax/mnjy.htm";
            NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            [pVC setLocalWebURL:strUrl];
            
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(400, 600);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
            {
#ifdef tzt_NewVersion
                UIViewController* pParentVC = (UIViewController*)wParam;
                if(pParentVC && [pParentVC isKindOfClass:[UIViewController class]])
                {
                    pVC.pParentVC = pParentVC;
                    [TZTUIBaseVCMsg IPadPushViewController:pParentVC pop:pVC];
                }
                else
                {
                    [TZTUIBaseVCMsg IPadPushViewController:pParentVC pop:pVC];
                }
#else
                [g_navigationController pushViewController:pVC animated:UseAnimated];
#endif
            }
            [pVC release];
            
        }
            break;
        case HQ_MENU_YUJING:
        case MENU_SYS_UserWarning:
        {
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_HQ, [NSString stringWithFormat:@"%ld", (long)nMsgType], &bPush,TRUE);
            [pVC retain];
#ifdef tzt_NewVersion
            pVC.nHasToolbar = 0;
#else
            pVC.nHasToolbar = 1;
#endif
            if (IS_TZTIPAD)//pad版本没有底部的工具栏
                pVC.nHasToolbar = NO;
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"预警设置"];
            NSString* strFile = @"EarlyWarning/index.htm";
            NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                {
                    strUrl = [NSString stringWithFormat:@"%@?StockCode=%@",strUrl,pStock.stockCode];   
                }
            }
            [pVC setLocalWebURL:strUrl];
            if (IS_TZTIPAD)
            {   
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(400, 600);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case HQ_MENU_Info_TBF10://图表f10
        case MENU_HQ_GraphF10:
        {
            BOOL bSucc = TRUE;
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            if (pStock == NULL)
            {
                bSucc = FALSE;
            }
            else if(MakeIndexMarket(pStock.stockType) || !MakeStockMarket(pStock.stockType))
            {
                bSucc = FALSE;
            }
            
            if (!bSucc) 
            {
                TZTUIMessageBox *pBox = [[[TZTUIMessageBox alloc] initWithFrame:[UIScreen mainScreen].bounds nBoxType_:TZTBoxTypeNoButton delegate_:nil] autorelease];
                pBox.m_nsTitle = @"提示信息";
                pBox.m_nsContent = @"暂无资讯内容";
                [pBox showForView:nil];
                return;
            }
            
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_HQ, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"图表F10"];
            NSString *strURL = [g_pSystermConfig.pDict objectForKey:@"tztWebF10"];
            if (strURL && [strURL length] > 0)
            {
                if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
                {
                    if (pStock.stockCode && ([strURL rangeOfString:@"%@"].location != NSNotFound))
                    {
                        strURL = [NSString stringWithFormat:strURL,pStock.stockCode];
                    }
                }
                [pVC setWebURL:strURL];
            }
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case HQ_MENU_Info_F10://维赛特f10
        case HQ_MENU_Info_F9://f9
        case MENU_HQ_GraphF9://维赛特f9
        case MENU_HQ_PADF10://维赛特f10
        {
            tztStockInfo* pStock = (tztStockInfo*)wParam;
            if (pStock == NULL)
            {
                return;
            }
            else if(MakeIndexMarket(pStock.stockType) || !MakeStockMarket(pStock.stockType))
            {
                return;
            }
            
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_HQ, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            [pVC retain];
    
            if (IS_TZTIPAD)//pad版本没有底部的工具栏
                pVC.nHasToolbar = NO;
            
            TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
            if (!pBottomVC)
                pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
            CGRect rcFrom = CGRectZero;
            rcFrom.origin = pBottomVC.view.center;
            rcFrom.size = pBottomVC.view.frame.size;
            rcFrom.origin.x -= 25;
            NSString* strURL = @"";
            if (nMsgType == HQ_MENU_Info_F10 || MENU_HQ_PADF10 == nMsgType)
            {
                strURL = [g_pSystermConfig.pDict objectForKey:@"tztWSTF10"];
            }
            else
            {
                strURL = [g_pSystermConfig.pDict objectForKey:@"tztWSTF9"];
            }
            
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]] && pStock.stockCode && strURL && [strURL length] > 0)
            {
                strURL = [NSString stringWithFormat:strURL, pStock.stockCode];
            }
            [pVC setWebURL:strURL];
            [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            [pVC release];
        }
            break;
        case HQ_MENU_Info_CJCenter://财经中心
        case MENU_SYS_FinanceCenter:
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Main, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
             
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            pVC.nMsgType = nMsgType;
#ifdef tzt_NewVersion
            pVC.nHasToolbar = 0;
#else
            pVC.nHasToolbar = 1;
#endif
            NSString *strURL = [g_pSystermConfig.pDict objectForKey:@"tztCJCenter"];
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                {
                    strURL = [NSString stringWithFormat:strURL,pStock.stockCode];   
                }
            }
            [pVC setTitle:@"财经中心"];
            [pVC setWebURL:strURL];
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case TZTToolbar_Fuction_Detail://详细
        {
            NSMutableDictionary *pDict = (NSMutableDictionary*)wParam;
            if (pDict == NULL)
                return;
            
            NSMutableArray *pAyData = [[pDict tztObjectForKey:@"GridDATA"] retain];
            int nCurIndex = [[pDict tztObjectForKey:@"CurIndex"] intValue];
            NSMutableArray *pAyTitle = [[pDict tztObjectForKey:@"TitleData"] retain];
            NSMutableArray *pAyTooBar = [pDict tztObjectForKey:@"tztToolBarBtn"];
            NSMutableDictionary *pDictIndex = [pDict tztObjectForKey:@"tztDictIndex"];
            int nMsgType = [[pDict tztObjectForKey:@"tztMsgType"] intValue];
            
            BOOL bPush = FALSE;
            tztUIListDetailViewController *pVC = (tztUIListDetailViewController *)gettztHaveViewContrller([tztUIListDetailViewController class], tztvckind_Main, [NSString stringWithFormat:@"%d", nMsgType],&bPush,TRUE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.pAyData = pAyData;
            pVC.nCurIndex = nCurIndex;
            pVC.pAyTitle = pAyTitle;
            pVC.pAyToolBar = pAyTooBar;
            pVC.pDictIndex = pDictIndex;
            pVC.nMsgType = nMsgType;
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(400, 500);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else
            {
                if(bPush)
                {
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                }
                else
                {
                    [pVC LoadLayoutView];
                }
            }
            [pVC release];
            [pAyData release];
            [pAyTitle release];
        }
            break;
        case Sys_Menu_AddDelServer://增删服务器
        {
            BOOL bPush = FALSE;
            tztUIAddOrDelectServerViewController *pVC = (tztUIAddOrDelectServerViewController *)gettztHaveViewContrller([tztUIAddOrDelectServerViewController class],tztvckind_Set, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
            
        }
            break;
        case Sys_Menu_ServiceCenter://服务中心 切换到服务中心首页
        case MENU_SYS_ServerCenter: // ServiceCenter for new ver
        {
#ifdef tzt_NewVersion
            tztUINavigationController* pNav = [tztMainViewController getNavController:tztvckind_Set];
            if (pNav) //资讯中心 清空资讯列表
            {
                [pNav popToRootViewControllerAnimated:NO];
            }
            [tztMainViewController didSelectNavController:tztvckind_Set options_:NULL];
            [g_ayPushedViewController removeObject:pNav.topViewController];
            [g_ayPushedViewController addObject:pNav.topViewController];
#else
            BOOL bPush = FALSE;
            tztUIServiceCenterViewController *pVC = (tztUIServiceCenterViewController *)gettztHaveViewContrller([tztUIServiceCenterViewController class], tztvckind_Set, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            pVC.nMsgType = nMsgType;
            pVC.nsProfileName = [NSString stringWithFormat:@"%@", @"tztTableSystemSetting"];
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
#endif
        }
            break;
        case MENU_SYS_UserLogin:
        case Sys_Menu_SysLogin:
        {
            //系统登录
            tztUISysLoginViewController* pVC = [[tztUISysLoginViewController alloc] init];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                CGRect rcFrom = CGRectZero;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 500);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else
            {
#ifdef tzt_NewVersion
                [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
#else
                [g_navigationController pushViewController:pVC animated:UseAnimated];
#endif
            }
            if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
            {
                [pVC setTitle:@"行情登录"];
            }

            [pVC release];
//            
//            tztUISysLoginViewController* pVC = [[tztUISysLoginViewController alloc] init];
//            [pVC setVcShowKind:tztvckind_Pop];
//            pVC.nMsgType = MENU_SYS_UserLogin;
//#ifdef tzt_NewVersion
//            [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
//#else
//            [g_navigationController pushViewController:pVC animated:UseAnimated];
//#endif
//            [pVC release];
        }
            break;
        case Sys_Menu_SoftCZ://充值方式
        {
            
        }
            break;
        case Sys_Menu_Contact://联系方式
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Set, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"联系方式"];
            pVC.nHasToolbar = 0;
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC setWebURL:@"http://3g.tzt.cn/help/tel.html"];
            [pVC release];
            
        }
            break;
        case Sys_Menu_SoftVersion://版本信息
        case MENU_SYS_About:
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_All, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"版本信息"];
            pVC.nHasToolbar = 0;
            
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            NSString *strURL = [g_pSystermConfig.pDict objectForKey:@"tztAboutURL"];
            if(strURL &&[strURL length] > 0)
            {
                NSString* strUrl = [NSString stringWithFormat:strURL,[[tztlocalHTTPServer getShareInstance] port]];
                [pVC setWebURL:strUrl];
            }
            else
            {
                NSString* strtztHtml = [NSString stringWithFormat:@"%@",g_pSystermConfig.strAboutCopyright];
                NSString* strPath = GetTztBundlePath(@"tzthtmlblack",@"html",@"plist");
                if (g_nThemeColor >= 1 || g_nSkinType >= 1)
                {
                    strPath = GetTztBundlePath(@"tzthtmlwhite", @"html", @"plist");
                }
                if(strPath && [strPath length] > 0)
                {
                    NSString* strtztHtmlFormat = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
                    if(strtztHtmlFormat && [strtztHtmlFormat length] > 0)
                        strtztHtml = [NSString stringWithFormat:strtztHtmlFormat,@"版本信息", g_pSystermConfig.strAboutCopyright];
                }
                
                [pVC LoadHtmlData:strtztHtml];
            }
            [pVC setTitle:@"版本信息"];
            [pVC release];
        }
            break;
        case Sys_Menu_QueryYXQ://有效期查询
        {
            BOOL bPush = FALSE;
            tztCommRequstViewController *pVC = (tztCommRequstViewController *)gettztHaveViewContrller([tztCommRequstViewController class], tztvckind_Set, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"有效期查询"];
            
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case Sys_Menu_SendToFriend://好友推荐
        case Sys_Menu_SetServer://服务器设置
        case Sys_Menu_HQSet://行情设置
        case Sys_Menu_KLineSet://k线设置
        case Sys_Menu_CheckServer://服务器测速
        case MENU_SYS_SerAddCheck:
        case Sys_Menu_SystemSetting://系统设置
        case MENU_SYS_System:
        case MENU_SYS_SerAddSet:
        {
            BOOL bPush = FALSE;
            tztBaseSetViewController *pVC = (tztBaseSetViewController *)gettztHaveViewContrller([tztBaseSetViewController class], tztvckind_Set, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case Sys_Menu_ReRegist://重新激活
        case MENU_SYS_ReLogin:
        {
            
            //清除本地数据
            [[tztUserData getShareClass] reSetUserData];
                        
            [TZTUserInfoDeal SaveAndLoadLogin:FALSE nFlag_:0];
            
            
            tztUISysLoginViewController *pVC = [[tztUISysLoginViewController alloc] init];
            [pVC setVcShowKind:tztvckind_Pop];
            pVC.nMsgType = MENU_SYS_UserLogin;
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 600);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else
            {
#ifdef tzt_NewVersion
                [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
#else
                [g_navigationController pushViewController:pVC animated:UseAnimated];
#endif
            }
            if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
            {
                [pVC setTitle:@"行情登录"];
            }

            
            [pVC release];
        }
            break;
        case Sys_Menu_MZTK://免责条款
        case MENU_SYS_Disclaimer:
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Set, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"免责条款"];
            pVC.nHasToolbar = 0;
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC LoadHtmlData:g_pSystermConfig.strMZTK];
            [pVC release];
        }
            break;
        case HQ_MENU_EditUserStock:
        case TZT_MENU_EditUserStock://自选股编辑
        {
            BOOL bPush = FALSE;
            tztUserStockEditViewController *pVC = (tztUserStockEditViewController *)gettztHaveViewContrller([tztUserStockEditViewController class], tztvckind_HQ, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"编辑自选"];
            //            if (IS_TZTIPAD)
            //            {
            //                [((TZTUIBaseViewController*)g_navigationController.topViewController) PopViewControllerWithoutArrow:pVC rect:CGRectZero];
            ////                [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
            //            }
            //            else
            if(bPush)
            {
                [g_navigationController pushViewController:pVC  animated:UseAnimated];
            }
            [pVC release];
            
        }
            break;
        default:
            break;
    }
    return;
}

//判断相同的vc是否已经存在，若存在，则pop到该类的前一个vc，保证不重复显示，不无限push vc

//用于判断tztWebViewController,不同类型的允许同时弹出
+(void)CheckWebViewControllers:(NSInteger)nType
{
    UINavigationController *pNav = g_navigationController;
    PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
    if (direction > 0)
    {
        if (direction == PPRevealSideDirectionLeft)
        {
            pNav = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
        }
        else if (direction == PPRevealSideDirectionRight)
        {
            pNav = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
        }
    }
    NSArray *pAy = [pNav viewControllers];
    if (pAy == NULL || [pAy count] <= 1)//只有一个，是根vc，无须判断
        return;
    
    NSInteger nCount = -1;
    for (NSInteger i = [pAy count] - 1; i >= 0; i--)
    {
        UIViewController *pVC = [pAy objectAtIndex:i];
        if (pVC && [pVC isKindOfClass:[tztWebViewController class]])//找到相同的，该vcpop掉
        {
            if (((tztWebViewController*)pVC).nWebType == nType)
            {
                nCount = i;
                break;
            }
        }
    }
    
    if (nCount < 0)
        return;
    
    NSMutableArray* pFirstAy = NewObject(NSMutableArray);
    for (NSInteger i = 0; i < nCount; i++)
    {
        [pFirstAy addObject:[pAy objectAtIndex:i]];
    }
    
    for (NSInteger i = nCount + 1; i < [pAy count]; i++)
    {
        [pFirstAy addObject:[pAy objectAtIndex:i]];
    }
    
    [pNav setViewControllers:pFirstAy animated:NO];
    
    DelObject(pFirstAy);
}
/*
 修改：2013-04-18
 判断相同的vc是否已经存在，若存在，则从viewController数组中移除，不影响其他已经显示的vc
 修改：2013-04－28
 增加返回值，用于判断当前最上层的vc是不是跟当前要显示的vc的类型一致，若一致，则无需pop，直接用该vc打开即可
 */

+(UIViewController*)CheckCurrentViewContrllers:(Class)vcClass
{
    UINavigationController *pNav = g_navigationController;
    PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
    if (direction > 0)
    {
        if (direction == PPRevealSideDirectionLeft)
        {
            pNav = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
        }
        else if (direction == PPRevealSideDirectionRight)
        {
            pNav = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
        }
    }
    UIViewController *pReturnVC = NULL;
    NSArray *pAy = [pNav viewControllers];
    if (pAy == NULL || [pAy count] <= 1)//只有一个，是根vc，无须判断
    {
        pReturnVC = pNav.topViewController;
        if (pReturnVC && [pReturnVC isKindOfClass:vcClass])
        {
            return pReturnVC;
        }
        return NULL;
    }
    
    NSInteger nCount = -1;
    for (NSInteger i = [pAy count] - 1; i >= 0; i--)
    {
        UIViewController *pVC = [pAy objectAtIndex:i];
        if (pVC && [pVC isKindOfClass:vcClass])//找到相同的，该vcpop掉
        {
            nCount = i;
            pReturnVC = pVC;
            break;
        }
    }
    
#ifdef tzt_NewVersion
    if (nCount <= 0)
        return NULL;
#else
    if (nCount < 0)
        return NULL;
#endif
    
    if (pReturnVC)
    {
        [g_ayPushedViewController removeObject:pReturnVC];
        [g_ayPushedViewController addObject:pReturnVC];
    }
    
    if (nCount == [pAy count] - 1)//当前最上层的vc
    {
        return pReturnVC;
    }
    
    NSMutableArray* pFirstAy = NewObject(NSMutableArray);
    for (NSInteger i = 0; i < nCount; i++)
    {
        [pFirstAy addObject:[pAy objectAtIndex:i]];
    }
    
    for (NSInteger i = nCount + 1; i < [pAy count]; i++)
    {
        [pFirstAy addObject:[pAy objectAtIndex:i]];
    }
    
    [pNav setViewControllers:pFirstAy animated:NO];
    
    DelObject(pFirstAy);
    
    return pReturnVC;
   
}

//返回同一个类创建的vc
+(UIViewController*)GetSameClassViewController:(Class)vcClass
{
    NSArray *pAy = [g_navigationController viewControllers];
    if (pAy == NULL || [pAy count] <= 1)//只有一个，是根vc，无须判断
        return NULL;
    
    for (NSInteger i = [pAy count] - 1; i >= 0; i--)
    {
        UIViewController *pVC = [pAy objectAtIndex:i];
        if (pVC && [pVC isKindOfClass:vcClass])//找到相同的，该vcpop掉
        {
            return pVC;
        }
    }
    return NULL;
}


+(BOOL) OnAjaxAction:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    BOOL bDeal = FALSE;
    NSString* strValue = (NSString*)wParam;
    NSString* strPath = strValue;
    NSString* strParam = @"";
    if(strValue && [strValue length] > 0)
    {
        NSRange pathRang = [strValue rangeOfString:@"?"];
        if(pathRang.location == NSNotFound) //不带参数
        {
            strParam = @"";
        }
        else
        {
            strPath = [strValue substringToIndex:pathRang.location-1];
            strParam = [strValue substringFromIndex:pathRang.location+pathRang.length];
        }
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
    
    int nType = [strPath intValue];
    switch (nType)
    {
        case TZT_MENU_ClearBadgeNumber:
        {
            bDeal = TRUE;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName: @"tztGetPushMessage" object:nil];
        }
            break;
        case MENU_JY_PT_Buy:
        case MENU_JY_PT_Sell:
        case MENU_JY_PT_XinGuShenGou:
        case MENU_JY_RZRQ_NewStockSG: // 15030//融资融券新股申购
        case MENU_JY_ZYHG_StockBuy://质押券入库
        case MENU_JY_ZYHG_StockSell://质押债券出库
        case MENU_JY_ZYHG_RZBuy:// 融资回购(正回购)
        case MENU_JY_ZYHG_RQBuy://融券回购(逆回购)
            /*理财产品*/
        case WT_JJLCRGFUND://理财认购
        case MENU_JY_LCCP_RenGou:
        case WT_JJLCAPPLYFUND://理财申购
        case MENU_JY_LCCP_ShenGou:
        case WT_JJLCREDEEMFUND://理财赎回  理财退出
        case MENU_JY_LCCP_Cancel:
            
        case WT_RZRQBUY://普通买入
        case WT_RZRQRZBUY:  //融资买入
        case WT_RZRQBUYRETURN:
            
        case WT_RZRQSALE:
        case WT_RZRQRQSALE:
        case WT_RZRQSALERETURN:
            //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
        case MENU_JY_RZRQ_XYBuy:// 融资买入
        case MENU_JY_RZRQ_XYSell://融券卖出
        case MENU_JY_RZRQ_BuyReturn://买券还券
        case MENU_JY_RZRQ_SellReturn://卖券还款
        {
//            web 设计的老版本 正回购
//          NSString*  strUrl = [tztlocalHTTPServer getLocalHttpUrl:@"yft/yft_finRepur.htm?type=0"];
//            BOOL bPush = FALSE;
//            tztWebViewController *pVC = (tztWebViewController*)gettztHaveViewContrller([tztWebViewController class],
//                                                                                       tztvckind_JY,
//                                                                                       [NSString stringWithFormat:@"%d", tztVcShowTypeSame],
//                                                                                       &bPush,
//                                                                                       FALSE);
//            [pVC retain];
//
//            [pVC setWebURL:strUrl];
//            pVC.nMsgType = nMsgType;
//            pVC.nHasToolbar = NO;
//            if (bPush)
//                [g_navigationController pushViewController:pVC animated:UseAnimated];
//            [pVC release];
//            return 1;
//新正回购  分割线
            bDeal = TRUE;
            NSString* str= @"";
            if (pDict && [pDict count] > 0)
            {
                str = [pDict tztObjectForKey:@"stockcode"];
            }
            tztStockInfo *pStcok = NewObject(tztStockInfo);
            pStcok.stockCode = [NSString stringWithFormat:@"%@",str];
            [TZTUIBaseVCMsg OnMsg:nType wParam:(NSUInteger)pStcok lParam:(NSUInteger)pDict];
            DelObject(pStcok);
        }
            break;
        case MENU_SYS_UpdataVersion: //10330 升级版本
        {
            bDeal = TRUE;
            NSString* strUrl = @"";
            if (pDict && [pDict count] > 0)
            {
                strUrl = [pDict tztObjectForKey:@"url"];
            }
            if(strUrl && [strUrl length] > 0)
            {
                strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *reqURL = [[NSURL alloc] initWithString:strUrl];
                [[UIApplication sharedApplication] openURL:reqURL];
                [reqURL release];
            }
        }
            break;
        case 1013://充值方式
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_SoftCZ wParam:0 lParam:0];
        }
            break;
        case 1026://服务器设置
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_SetServer wParam:0 lParam:0];
        }
            break;
        case 1034://好友推荐
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_SendToFriend wParam:0 lParam:0];
        }
            break;
        case 1140://快递设置
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_TZKDSetting wParam:0 lParam:0];
        }
            break;
        case 1968://行情设置
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_SystemSetting wParam:0 lParam:0];
        }
            break;
        case 1515://重新激活
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_ReRegist wParam:0 lParam:0];
        }
            break;
        case 1536://联系方式
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_Contact wParam:0 lParam:0];
        }
            break;
        case 1018://免责条款
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_MZTK wParam:0 lParam:0];
        }
            break;
        case 1009://最近浏览
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_RecentBrowse wParam:0 lParam:0];
        }
            break;
        case 1200://个性设置
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_ServiceCenter wParam:0 lParam:0];
        }
            break;
        case 1206://极速行情，综合排名
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Report wParam:0 lParam:0];
        }
            break;
        case 1284://查询有效期
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_QueryYXQ wParam:0 lParam:0];
        }
            break;
        case 1516://自选股票
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_UserStock wParam:0 lParam:0];
        }
            break;
        case 1527://预警
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_YUJING wParam:0 lParam:0];
        }
            break;
        case 1533://在线客服
        {
            bDeal = TRUE;
#ifdef tzt_NewVersion
            [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
            [tztMainViewController didSelectNavController:tztvckind_Main options_:NULL];
#endif
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Online wParam:0 lParam:0];
        }
            break;
        case 1600://分时图
        {
            
        }
            break;
        case 1609://返回首页
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_HomePage wParam:0 lParam:0];
        }
            break;
        case 1612://股市资讯（资讯中心）
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Center wParam:0 lParam:0];
        }
            break;
        case 1614://服务中心
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:Sys_Menu_SysSetting wParam:0 lParam:0];
        }
            break;
        case 1617://消息中心
        {
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_MsgCenter wParam:0 lParam:0];
        }
            break;
        case 2050://返回交易登录
        {
            bDeal = TRUE;
            if (IS_TZTIPAD)
            {
                [TZTUIBaseVCMsg OnMsg:WT_LOGIN wParam:0 lParam:0];
            }
            else
            {
#ifdef tzt_NewVersion
                [TZTUIBaseVCMsg IPadPopViewController:g_navigationController bUseAnima_:NO];
                [TZTUIBaseVCMsg OnMsg:WT_LOGIN wParam:0 lParam:0];
#else
                [TZTUIBaseVCMsg OnMsg:HQ_Return wParam:0 lParam:0];
#endif
            }
        }
            break;
        case 2101://在线交易
        case MENU_JY_PT_List://普通交易 股票交易
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:WT_JiaoYi wParam:0 lParam:0];
        }
            break;
        case 2500://基金交易
        case MENU_JY_FUND_List:
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:WT_FUND_TRADE wParam:0 lParam:0];
        }
            break;
        case 2608://组合申购，带选择的行索引
        {
            bDeal = TRUE;
            int nIndex = -1;
            if (pDict && [pDict count] > 0)
            {
                NSString* strIndex = [pDict tztObjectForKey:@"selectindex"];
                TZTStringToIndex(strIndex, nIndex);
            }
            [TZTUIBaseVCMsg OnMsg:WT_JJZHSGFUND wParam:(NSUInteger)nIndex lParam:1];
        }
            break;
        case 2615://组合说明，带选择的行索引
        {
            bDeal = TRUE;
            int nIndex = -1;
            if (pDict && [pDict count] > 0)
            {
                NSString* strIndex = [pDict tztObjectForKey:@"selectindex"];
                TZTStringToIndex(strIndex, nIndex);
            }
            [TZTUIBaseVCMsg OnMsg:WT_JJZHInfo wParam:(NSUInteger)nIndex lParam:0];
            
        }
            break;
        case 4000://融资融券
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:WT_JYRZRQ wParam:0 lParam:0];
        }
            break;
        case MENU_JY_PT_CardBank://银证转账
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_CardBank wParam:0 lParam:0];
        }
            break;
        case AJAX_MENU_CloseAllWeb:
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:HQ_Return wParam:0 lParam:0];
        }
            break;
        case 1964:
        {
            bDeal = TRUE;
            //zxl 20130801修改了获取Url的方式(有的URL 有可能也有问号所以不能按照以前的获取方式来获取)
            NSString* strUrl = @"";
            if (strValue && [strValue length] > 0)
            {
                strUrl = [strValue substringFromIndex:[@"1964/?url=" length]];
            }
            NSString* strData = [strUrl tztdecodeURLString];
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_OpenNewWebURL wParam:(NSUInteger)strData lParam:lParam];
        }
            break;
        case 1965:
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_ChaoGenKLine wParam:(NSUInteger)strParam lParam:0];
        }
            break;
        case 2001:
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Online_My wParam:(NSUInteger)strValue lParam:0];
        }
            break;
        //add by xyt
        /************东莞添加财富通功能 begin**************/
        case 1062://理财易 
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:CFT_LCY wParam:0 lParam:0];
        }
            break;
        case 1063://多股易
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:CFT_DGY wParam:0 lParam:0];
        }
            break;
        case 1064://热卖基金
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:WT_CFTJJDWRMFUND wParam:0 lParam:0];
        }
            break;
        case 1065://东证代销
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:WT_CFTJJDWDZDX wParam:0 lParam:0];
        }
            break;
        case 1066://东莞定投 基金定投
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:WT_CFTJJDWDTFUND wParam:0 lParam:0];
        }
            break;
        case 1067://集合产品
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:WT_CFTJJJHCP wParam:0 lParam:0];
        }
            break;
        case 1068://营业部导航
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:CFT_DaoHang wParam:0 lParam:0];
        }
            break;
        case 1071://持仓消息
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:CFT_ChiCang wParam:0 lParam:0];
        }
            break;
        case 1072://tq  互动平台
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:CFT_TQ wParam:0 lParam:0];
        }
            break;
        case 1074://东莞ipad资讯详细内容
        {
            [TZTUIBaseVCMsg OnMsg:CFT_ZXInfo wParam:0 lParam:(NSUInteger)lParam];
        }
            break;
        /************东莞添加财富通功能 end**************/
        case 1000://zxl 20130806 特殊处理 返回首页
        {
            bDeal = TRUE;
           [TZTUIBaseVCMsg OnMsg:HQ_ROOT wParam:0 lParam:0];
        }
            break;
        case 2103://zxl 20130806 炒跟PUSH 推送消息 点击"跟"跳入买界面
        {
            bDeal = TRUE;
            NSString* str= strValue;
            if (pDict && [pDict count] > 0)
            {
                str = [pDict tztObjectForKey:@"stockcode"];
            }
            tztStockInfo *pStcok = NewObject(tztStockInfo);
            pStcok.stockCode = [NSString stringWithFormat:@"%@",str];
            [TZTUIBaseVCMsg OnMsg:WT_BUY wParam:(NSUInteger)pStcok lParam:0];
            DelObject(pStcok);
        }
            break;
        case 10002://zxl 20130806 返回的时候发送 10002 功能号再直接跳返回
        {
            bDeal = TRUE;
            UIViewController* pVC = g_navigationController.topViewController;
            UIViewController* VC = g_navigationController.topViewController;
            if (IS_TZTIOS(5))
            {
                while (pVC.presentedViewController)
                {
                    VC = pVC.presentedViewController;
                    pVC = VC;
                }
            }
            else
            {
                while (pVC.modalViewController)
                {
                    VC = pVC.modalViewController;
                    pVC = VC;
                }
            }
            
            PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
            if (direction > 0)
            {
                if (direction == PPRevealSideDirectionLeft)
                {
                    pVC = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController.topViewController;
                    VC = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController.topViewController;
                }
                else if (direction == PPRevealSideDirectionRight)
                {
                    pVC = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController.topViewController;
                    VC = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController.topViewController;
                }
            }
            if (IS_TZTIOS(5))
            {
                while (pVC.presentedViewController)
                {
                    VC = pVC.presentedViewController;
                    pVC = VC;
                }
            }
            else
            {
                while (pVC.modalViewController)
                {
                    VC = pVC.modalViewController;
                    pVC = VC;
                }
            }
            
            if (VC && [VC isKindOfClass:[tzt_ht_zl_LeftViewController class]])
            {
                tzt_ht_zl_LeftViewController *pVC = (tzt_ht_zl_LeftViewController*)VC;
                [pVC OnWebReturnBack];
            }
            
            if (VC && [VC isKindOfClass:[tztWebViewController class]])
            {
                tztWebViewController *pVC = (tztWebViewController *)VC;
                pVC.dictWebParams = pDict;
                [pVC OnReturnBack];
            }
            if(IS_TZTIPAD)
                [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
        }
            break;
        case TZT_MENU_WebLogin://(10090)
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:TZT_MENU_WebLogin wParam:wParam lParam:lParam];
        }
            break;
        case TZT_MENU_GetStockCode:
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:TZT_MENU_GetStockCode wParam:wParam lParam:lParam];
        }
            break;
        case TZT_MENU_OpenWebInfoContent:
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:TZT_MENU_OpenWebInfoContent wParam:(NSUInteger)strParam lParam:lParam];
        }
            break;
        case TZT_MENU_DownloadFile://下载文件
        {
            bDeal = TRUE;
            [[TZTAppObj getShareInstance] tztDownloadFile:strParam];
        }
            break;
        case MENU_JY_FUND_ShenGou://基金申购
        case MENU_JY_FUND_RenGou://认购
        case MENU_JY_FUND_ShuHui://赎回
        case WT_JJWWOpen://定投开户
        case MENU_JY_FUND_DTReq:
        case WT_JJWWModify://定投变约
        case MENU_JY_FUND_DTChange:
        case WT_JJWWCancel://定投取消
        case MENU_JY_FUND_DTCancel:
        {
            bDeal = TRUE;
            NSString* strCode = [pDict tztObjectForKey:@"fundcode"];
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            if (strCode && strCode.length > 0)
                pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            [TZTUIBaseVCMsg OnMsg:nType wParam:(NSUInteger)pStock lParam:lParam];
        }
            break;
        case MENU_SYS_OnlineServe:
        {
            bDeal = TRUE;
            [TZTUIBaseVCMsg OnMsg:nType wParam:(NSUInteger)pDict lParam:0];
        }
            break;
        default:
            return FALSE;
    }
    return bDeal;
}

+(BOOL) OnMenuMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    switch (nMsgType)
    {
        case TZT_MENU_Root:
        case HQ_ROOT://首页
        case HQ_MENU_HomePage:
        {
#ifdef tzt_NewVersion
#ifdef Support_EXE_VERSION
            if(g_navigationController) //独苗rootvc，切换到首页。
            {
                [g_ayPushedViewController removeAllObjects];
                [tztMainViewController didSelectNavController:tztvckind_Main options_:NULL];
//                [g_navigationController popToRootViewControllerAnimated:UseAnimated];
                NSArray* ayVC = g_navigationController.viewControllers; //将当前vc列加入操作列
                for (int i = 0; i < [ayVC count]; i++)
                {
                    [g_ayPushedViewController addObject:[ayVC objectAtIndex:i]];
                }
                return TRUE;
            }
#else
            if (g_pTZTTopVC)
            {
                if (g_pTZTTopVC && [g_pTZTTopVC isKindOfClass:[UIViewController class]])
                {
                    if (g_CallNavigationController.topViewController && [g_CallNavigationController.topViewController isKindOfClass:[tztHomePageViewController_iphone class]])
                    {
                        return TRUE;
//                        [g_CallNavigationController popToViewController:g_pTZTTopVC animated:UseAnimated];
                    }
                    else
                    {
                        NSArray *ayVC = [g_CallNavigationController viewControllers];
                        BOOL bHomePage = FALSE;
                        for (int i = 0; i < [ayVC count]; i++)
                        {
                            UIViewController *pVC = [ayVC objectAtIndex:i];
                            if (pVC && [pVC isKindOfClass:[tztHomePageViewController_iphone class]])
                            {
                                [g_CallNavigationController popToViewController:pVC animated:UseAnimated];
                                bHomePage = TRUE;
                                break;
                            }
                        }
                        
                        if (!bHomePage)
                        {
                            [g_CallNavigationController popToViewController:g_pTZTTopVC animated:UseAnimated];
                        }
                    }
                }
                else
                {
                    [g_CallNavigationController popToRootViewControllerAnimated:UseAnimated];
                }
            }
            else
                [g_CallNavigationController popToRootViewControllerAnimated:UseAnimated];
            
            UIViewController* pTop = g_navigationController.topViewController;
            if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
            {
                g_navigationController.navigationBar.hidden = NO;
                [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
            }
#endif
#else
#ifdef Support_EXE_VERSION
            //老版本处理 modify by xyt 20131008
            [g_navigationController popToRootViewControllerAnimated:UseAnimated];
#else
            if (g_pTZTTopVC)
            {
                if (g_pTZTTopVC && [g_pTZTTopVC isKindOfClass:[UIViewController class]])
                {
                    if (g_CallNavigationController.topViewController && [g_CallNavigationController.topViewController isKindOfClass:[tztHomePageViewController_iphone class]])
                    {
                        return TRUE;
                        //                        [g_CallNavigationController popToViewController:g_pTZTTopVC animated:UseAnimated];
                    }
                    else
                    {
                        NSArray *ayVC = [g_CallNavigationController viewControllers];
                        BOOL bHomePage = FALSE;
                        for (int i = 0; i < [ayVC count]; i++)
                        {
                            UIViewController *pVC = [ayVC objectAtIndex:i];
                            if (pVC && [pVC isKindOfClass:[tztHomePageViewController_iphone class]])
                            {
                                [g_CallNavigationController popToViewController:pVC animated:UseAnimated];
                                bHomePage = TRUE;
                                break;
                            }
                        }
                        
                        if (!bHomePage)
                        {
                            [g_CallNavigationController popToViewController:g_pTZTTopVC animated:UseAnimated];
                        }
                    }
                }
                else
                {
                    [g_CallNavigationController popToRootViewControllerAnimated:UseAnimated];
                }
            }
            else
                [g_CallNavigationController popToRootViewControllerAnimated:UseAnimated];
            
            UIViewController* pTop = g_navigationController.topViewController;
            if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
            {
                g_navigationController.navigationBar.hidden = NO;
                [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
            }
#endif
#endif
        }
        break;
        case HQ_Return:
        case TZT_MENU_Return:
        {
            UIViewController *pVC = g_navigationController.topViewController;
            if (pVC && [pVC isKindOfClass:[TZTUIBaseViewController class]])
            {
                [(TZTUIBaseViewController*)pVC PopViewControllerDismiss];
            }
            [g_navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            return FALSE;
    }
    return TRUE;
}

+(BOOL) OnSysMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    switch (nMsgType)
    {
        case MENU_SYS_OnlineServe://在线客服
        case MENU_SYS_HotLine://客服热线
        case MENU_SYS_SystemQA://常见问题 zxl 20130729 自营添加常见问题
        case MENU_SYS_AllQuestion://全部提问
        case MENU_SYS_MyQuestion://我的提问
        {
            NSString* strKey = @"tztOnlineCJWT";
            if (MENU_SYS_OnlineServe == nMsgType || HQ_MENU_Online == nMsgType)
            {
                strKey = @"tztOnlineCJWT";
            }
            else if(MENU_SYS_HotLine == nMsgType || HQ_MENU_Online_Hot == nMsgType)
            {
                strKey = @"tztOnlineHot";
            }
            else if(MENU_SYS_SystemQA == nMsgType || HQ_MENU_Online_CJWT == nMsgType)
            {
                strKey = @"tztOnlineCJWT";
            }
            else if(MENU_SYS_AllQuestion == nMsgType || HQ_MENU_Online_All == nMsgType)
            {
                strKey = @"tztOnline";
            }
            else if(MENU_SYS_MyQuestion == nMsgType || HQ_MENU_Online_My == nMsgType)
            {
                strKey = @"tztOnlineMy";
            }
            NSString *strURL = [g_pSystermConfig.pDict objectForKey:strKey];
            if(strURL == NULL || [strURL length] <= 0)
            {
                strURL = @"/serviceajax/index.htm";
            }
            NSString* strUrla = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Set,[NSString stringWithFormat:@"%d", tztWebOnline],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.nWebType = tztWebOnline;
            [pVC setTitle:@"在线客服"];
            [pVC setWebURL:strUrla];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = pBottomVC.view.frame;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size.width -= 200;
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        default:
            return FALSE;
    }
    
    return TRUE;
}

+(BOOL) OnHQMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    switch (nMsgType)
    {
        case HQ_MENU_TztTelPhone:
        {
            NSString* strTelphone = (NSString *)wParam;
            if(strTelphone == nil || [strTelphone length] <= 0)
            {
                strTelphone = TZTDailPhoneNUM;
            }
            UIViewController* pVC = [g_navigationController topViewController];
            if(pVC && [pVC isKindOfClass:[TZTUIBaseViewController class]])
            {
                [(TZTUIBaseViewController *)pVC OnShowPhoneList:strTelphone];
            }
            else
            {
                NSString *telStr = [[NSString alloc] initWithFormat:@"tel:%@",strTelphone];
                NSString *strUrl = [telStr stringByAddingPercentEscapesUsingEncoding:NSMacOSRomanStringEncoding];
                NSURL *telURL = [[NSURL alloc] initWithString:strUrl];
                [[UIApplication sharedApplication] openURL:telURL];
                [telStr release];
                [telURL release];
            }
        }
            break;
        case HQ_MENU_MarketMenu:
        case MENU_HQ_MarketMenu:
        {
            BOOL bPush = FALSE;
            tztMenuViewController_iphone *pVC = (tztMenuViewController_iphone *)gettztHaveViewContrller([tztMenuViewController_iphone class], tztvckind_HQ, [NSString stringWithFormat:@"%d", MENU_HQ_Report],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            //[pVC setTitle:@"市场选择"];
            [pVC setTitle:@"综合排名"];
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case HQ_MENU_Message://投资快递
        case MENU_SYS_UserExpress:
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Pop, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.nWebType = tztWebMessage;
            NSString *strURL = @"/Investment_ajax/index.htm";
            NSString* strUrla = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [pVC setTitle:@"投资快递"];
            [pVC setWebURL:strUrla];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
//                CGRect rcFrom = pBottomVC.view.frame;
//                rcFrom.origin = pBottomVC.view.center;
//                rcFrom.size.width -= 400;
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(600, 650);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case HQ_MENU_Inbox://收件箱
        case MENU_SYS_ExpressInBox:
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Pop, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.nWebType = tztWebInBox;
            NSString *strURL = @"/Investment_ajax/Inbox.htm";
            NSString* strUrla = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            
            [pVC setTitle:@"收件箱"];
            [pVC setWebURL:strUrla];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = pBottomVC.view.frame;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size.width -= 400;
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case HQ_MENU_Collect://收藏夹
        case MENU_SYS_ExpressFavorite:
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Pop, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.nWebType = tztWebCollect;
            NSString *strURL = @"/Investment_ajax/Collect.htm";//[g_pSystermConfig.pDict objectForKey:@"tztOnline"];
            NSString* strUrla = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [pVC setTitle:@"收藏夹"];
            [pVC setWebURL:strUrla];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = pBottomVC.view.frame;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size.width -= 400;
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case MENU_HQ_Report://综合排名
        case HQ_MENU_Report://排名
        {
            if(wParam == 0)//综合排名首页 切换到行情首页
            {
#ifdef tzt_NewVersion
                tztUINavigationController* pNav = [tztMainViewController getNavController:tztvckind_HQ];
                [pNav popToRootViewControllerAnimated:NO];
                [tztMainViewController didSelectNavController:tztvckind_HQ options_:NULL];
                
                [g_ayPushedViewController removeObject:pNav.topViewController];
                [g_ayPushedViewController addObject:pNav.topViewController];
#else
                BOOL bPush = FALSE;
                tztMenuViewController_iphone* pVC = (tztMenuViewController_iphone *)gettztHaveViewContrller([tztMenuViewController_iphone class], tztvckind_HQ, [NSString stringWithFormat:@"%d", MENU_HQ_Report],&bPush,FALSE);
                [pVC retain];
                pVC.nMsgType = nMsgType;
                if(bPush)
                {
                    NSString *strTitle = GetTitleByID(nMsgType);
                    if (!ISNSStringValid(strTitle))
                        strTitle = @"其它市场";
                    [pVC setTitle:strTitle];
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                }
                [pVC release];
#endif
            }
            else
            {
                NSString* nHQMenuID = (NSString*)wParam; //menuID
                NSString* strMenuID = [NSString stringWithFormat:@"%@",nHQMenuID];
                NSString* strHQMenuInfo = @"";
                if(lParam > 0)
                  strHQMenuInfo = (NSString *)lParam; //menuInfo
                if(strHQMenuInfo.length <= 0)
                {
                    //获取信息
                    if (g_pReportMarket == NULL)
                        g_pReportMarket = NewObject(TZTInitReportMarketMenu);
                    NSMutableDictionary* pDic = [g_pReportMarket GetSubMenuById:nil nsID_:strMenuID];
                    if(pDic)
                        strHQMenuInfo = [pDic objectForKey:@"MenuData"];
                }
                
                //判断自选股是否要登录 add by xyt 20130917
                if(strMenuID && ([strMenuID compare:@"1"] == NSOrderedSame))
                {
                    if (g_pSystermConfig && g_pSystermConfig.bUserStockNeedLogin && [TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam])
                    {
                        return FALSE;
                    }
                }
                
                if(strHQMenuInfo && [strHQMenuInfo length] > 0)
                {
                    if([strHQMenuInfo rangeOfString:@"|S|" options:NSCaseInsensitiveSearch].location != NSNotFound ) //有|S|还是列表
                    {
                        BOOL bPush = FALSE;
                        tztMenuViewController_iphone* pVC = (tztMenuViewController_iphone *)gettztHaveViewContrller([tztMenuViewController_iphone class], tztvckind_HQ, strMenuID,&bPush,FALSE);
                        [pVC retain];
                        pVC.nMsgType = nMsgType;
                        pVC.nsMenuID = strMenuID;//[NSString stringWithFormat:@"%d",nHQMenuID];
                        if(bPush)
                        {
                            [g_navigationController pushViewController:pVC animated:UseAnimated];
                        }
                        [pVC release];
                    }
                    else   //
                    {
                        BOOL bShowBlockList = [strHQMenuInfo rangeOfString:@"#20196|" options:NSCaseInsensitiveSearch].location != NSNotFound;
                        BOOL bPush = FALSE;
                        
                        NSString* strMsgType = [NSString stringWithFormat:@"%d", (bShowBlockList ? tztReportShowBlockList : tztReportShowStockList)];
                        tztUIReportViewController_iphone* pVC = (tztUIReportViewController_iphone *)gettztHaveViewContrller([tztUIReportViewController_iphone class], tztvckind_HQ, strMsgType,&bPush,FALSE);
                        [pVC retain];
                        pVC.nMsgType = nMsgType;
                        [pVC RequestDefaultMenuData:[NSString stringWithFormat:@"%@",nHQMenuID]];
                        if(bPush)
                        {
                            [g_navigationController pushViewController:pVC animated:UseAnimated];
                        }
                        [pVC release];
                    }
                }
            }
        }
            break;
        case HQ_MENU_UserStock://自选
        case MENU_HQ_UserStock:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"1" lParam:0];
        }
            break;
        case HQ_MENU_RecentBrowse://最近浏览
        case MENU_HQ_Recent:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"2" lParam:0];
        }
            break;
        case HQ_MENU_HSMarket: //沪深股市
        case MENU_HQ_HS:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"3" lParam:0];
        }
            break;
        case HQ_MENU_HotBlock://热门板块
        case MENU_HQ_BlockHq:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"4" lParam:0];
        }
            break;
            //5
        case HQ_MENU_HKMarket://港股市场
        case MENU_HQ_HK:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"6" lParam:0];
        }
            break;
        case HQ_MENU_QHMarket://期货市场
        case MENU_HQ_QH:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"7" lParam:0];
        }
            break;
        case MENU_HQ_WH://外汇市场
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"8" lParam:0];
        }
            break;
        case HQ_MENU_GlobalMarket://全球市场
        case MENU_HQ_Global:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"9" lParam:0];
        }
            break;
        case HQ_MENU_OutFund://场外基金
        case MENU_HQ_OutFund:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"10" lParam:0];
        }
            break;
        case MENU_HQ_Gold:   //黄金白银
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"11" lParam:0];
        }
            break;
        case HQ_MENU_IndexTrend://大盘
        case MENU_HQ_Index:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"12" lParam:0];
        }
            break;
        case MENU_HQ_FundLiuxiang:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"13" lParam:0];
        }
            break;
        case MENU_HQ_Fund: // 基金超市、基金市场
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"14" lParam:0];
        }
            break;
        case HQ_MENU_HoriTrend:
        case HQ_MENU_HoriTech:
        case MENU_HQ_HorizTrend:
        case MENU_HQ_HorizTech:
        {
            BOOL bPush = FALSE;
            tztUIHQHoriViewController_iphone *pVC = (tztUIHQHoriViewController_iphone *)gettztHaveViewContrller([tztUIHQHoriViewController_iphone class], tztvckind_Pop, @"0",&bPush,FALSE);
            
            [pVC retain];
            
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            pVC.nMsgType = nMsgType;
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                [tztUserStock AddRecentStock:pStock];
                pVC.pStockInfo = pStock;
            }
            [pVC setViewKind:((HQ_MENU_HoriTrend == nMsgType || MENU_HQ_HorizTrend == nMsgType) ? HoriViewKind_Trend : HoriViewKind_Tech)];
            pVC.pListView = (id)lParam;//列表传递
            if (bPush)
            {
//                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case HQ_MENU_HisTrend://
        case MENU_HQ_HisTrend:
        {
            id pDict = (id)wParam;
            if (pDict == NULL || ![pDict isKindOfClass:[NSMutableDictionary class]])
                return TRUE;
            
            NSString* nsDate = [(NSMutableDictionary*)pDict tztObjectForKey:@"tztHisDate"];
            id pDelegate = [(NSMutableDictionary*)pDict tztObjectForKey:@"tztDelegate"];
            tztStockInfo *pStock = [(NSMutableDictionary*)pDict tztObjectForKey:@"tztStock"];
            
            BOOL bPush = TRUE;
            tztUIHisTrendViewController *pVC = [[tztUIHisTrendViewController alloc] init];
//            tztUIHisTrendViewController *pVC = (tztUIHisTrendViewController *)gettztHaveViewContrller([tztUIHisTrendViewController class], tztvckind_HQ, @"0", &bPush,TRUE);
            
//            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.tztdelegate = pDelegate;
            pVC.nsHisDate = [NSString stringWithFormat:@"%@",nsDate];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 600);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }else
            {
                if(bPush)
                {
                    [pVC SetHidesBottomBarWhenPushed:YES];
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                }
            }

            [pVC setRequestDate:nsDate pStock_:pStock];
            [pVC release];
        }
            break;
        case HQ_MENU_Trend://分时
        case MENU_HQ_Trend:
        {
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            if(IS_TZTIPAD)
            {
                TZTUIBaseViewController *pTop = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if ([pTop isKindOfClass:[TZTUIReportViewController class]])
                {
                    [((TZTUIReportViewController*)pTop) OnSelectHQData:pStock];
                }
#ifdef Support_HomePage
                else if([pTop isKindOfClass:[tztUIHomePageViewController class]])
                {
                    [((tztUIHomePageViewController*)pTop) SelectStock:pStock];
                }
#endif
                return TRUE;
            }
            
            BOOL bPush = TRUE;
            
            //允许多种分时显示同时存在
            int nType = 1;
            NSString *strType = [g_pSystermConfig.pDict tztObjectForKey:@"FenShiShowType"];
            if (strType && strType.length > 0)
                nType = [strType intValue];
            
            
            if (nType == 2)//国金显示分时类型
            {
                tztStockInfo *pStock = (tztStockInfo*)wParam;
                if (pStock == NULL || pStock.stockCode.length < 1)
                    return 1;
                g_pSystermConfig.bWudangOnly = TRUE;
                BOOL bPush = TRUE;
                tztUINavigationController* pNavC = nil;
                if ([[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose] <= 0)
                {
                    pNavC = [tztMainViewController getNavController:tztvckind_Pop];
                    [tztMainViewController didSelectNavController:pNavC.nPageID options_:NULL];
                }
                
                UINavigationController *nav = g_navigationController;
                PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
                if (direction > 0)
                {
                    if (direction == PPRevealSideDirectionLeft)
                    {
                        nav = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
                    }
                    else if (direction == PPRevealSideDirectionRight)
                    {
                        nav = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
                    }
                    [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionLeft animated:YES];
                    [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionRight animated:YES];
                }
                NSArray *ay = nav.viewControllers;
                NSMutableArray *mutAy = NewObject(NSMutableArray);
                for (int i = 0; i < ay.count; i++)
                {
                    [mutAy addObject:[ay objectAtIndex:i]];
                }
                UIViewController *vc = [TZTUIBaseVCMsg CheckCurrentViewContrllers:[TZTUserStockDetailViewController class]];
                
                TZTUserStockDetailViewController *pVC = [[TZTUserStockDetailViewController alloc] init];
                [pVC setVcShowKind:tztvckind_Pop];
                id stockArray = (id)lParam;
                BOOL bIsArray = (stockArray && [stockArray isKindOfClass:[NSArray class]]);
                [pVC ClearData];
                if (stockArray)
                {
                    if (bIsArray)
                    {
                        if (stockArray && ((NSArray*)stockArray).count > 0)
                        {
                            pVC.stockArray = stockArray;
                        }
                    }
                    else if ([stockArray isKindOfClass:[NSDictionary class]])
                    {
                        tztReportListView *pView = (tztReportListView*)[(NSDictionary*)stockArray tztObjectForKey:@"View"];
                        pVC.stockArray = pView.ayStockData;
                    }
                    else if ([stockArray isKindOfClass:[tztReportListView class]])
                    {
                        pVC.stockArray = ((tztReportListView*)stockArray).ayStockData;
                    }
                }
                else
                {
                    [pVC.stockArray removeAllObjects];
                }
                
                if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
                {
                    if (pVC.stockArray.count <= 0 && pStock.stockCode.length > 0)
                    {
                        NSMutableArray *ayStock = NewObject(NSMutableArray);
                        if (pStock.stockName == NULL)
                            pStock.stockName = @"";
                        NSMutableDictionary* dict = NewObject(NSMutableDictionary);
                        NSMutableDictionary* dictCode = NewObject(NSMutableDictionary);
                        [dictCode setObject:pStock.stockCode forKey:@"value"];
                        [dict setObject:dictCode forKey:@"Code"];
                        NSMutableDictionary* dictName = NewObject(NSMutableDictionary);
                        [dictName setObject:pStock.stockName forKey:@"value"];
                        [dict setObject:dictName forKey:@"Name"];
                        [dict setObject:[NSString stringWithFormat:@"%d", pStock.stockType] forKey:@"StockType"];
                        [ayStock addObject:dict];
                        pVC.stockArray = ayStock;
                        DelObject(dict);
                        DelObject(dictName);
                        DelObject(dictCode);
                        DelObject(ayStock);
                    }
                    
                    //                [tztUserStock AddRecentStock:pStock];
                    pVC.pStockInfo = pStock;
                }
                
                if (bPush)
                {
                    if (vc)
                        [mutAy removeObject:vc];
                    [mutAy addObject:pVC];
                    [g_ayPushedViewController removeObject:pVC];
                    [g_ayPushedViewController addObject:pVC];
                    [pVC SetHidesBottomBarWhenPushed:YES];
                    [nav setViewControllers:mutAy animated:UseAnimated];
                    [pVC release];
                }
                else
                {
                    [pVC OnRequestNewData:pStock];
                    [mutAy release];
                    [pVC release];
                    return YES;
                }
                [mutAy release];
                return YES;
            }
            else if (nType == 1)//华泰显示分时类型
            {
                tztStockInfo *pStock = (tztStockInfo*)wParam;
                bPush = YES;
                g_pSystermConfig.bWudangOnly = FALSE;
                tztUITrendViewController *pVC = [[tztUITrendViewController alloc] init];
                
                tztUINavigationController* pNavC = nil;
                if ([[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose] <= 0)
                {
                    pNavC = [tztMainViewController getNavController:tztvckind_Pop];
                    [tztMainViewController didSelectNavController:pNavC.nPageID options_:NULL];
                }
                
                UINavigationController *nav = g_navigationController;
                PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
                if (direction > 0)
                {
                    if (direction == PPRevealSideDirectionLeft)
                    {
                        nav = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
                    }
                    else if (direction == PPRevealSideDirectionRight)
                    {
                        nav = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
                    }
                    [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionLeft animated:YES];
                    [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionRight animated:YES];
                }
                UIViewController *vc = [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUITrendViewController class]];
                NSArray *ay = nav.viewControllers;
                NSMutableArray *mutAy = NewObject(NSMutableArray);
                for (int i = 0; i < ay.count; i++)
                {
                    [mutAy addObject:[ay objectAtIndex:i]];
                }
                

                
                pVC.nMsgType = nMsgType;
                pVC.pListView = (id)lParam;
                if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
                {
                    if (pStock && pStock.stockCode.length == 5 && MakeHKMarketStock(pStock.stockType))
                    {
                        pStock.stockCode = [NSString stringWithFormat:@"H%@",pStock.stockCode];
                    }
                    [tztUserStock AddRecentStock:pStock];
                    pVC.pStockInfo = pStock;
                    [pVC setStockInfo:pStock nRequest_:0];
                }
                if (bPush)
                {
                    if (vc)
                        [mutAy removeObject:vc];
                    [mutAy addObject:pVC];
                    [g_ayPushedViewController removeObject:pVC];
                    [g_ayPushedViewController addObject:pVC];
                    [pVC SetHidesBottomBarWhenPushed:YES];
                    [nav setViewControllers:mutAy animated:UseAnimated];
                }
                
                [mutAy release];
                [pVC release];
            }
            else//默认显示分时方式
            {
                tztUIFenShiViewController_iphone *pVC = [[tztUIFenShiViewController_iphone alloc] init];
                
                
                tztUINavigationController* pNavC = nil;
                if ([[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose] <= 0)
                {
                    pNavC = [tztMainViewController getNavController:tztvckind_Pop];
                    [tztMainViewController didSelectNavController:pNavC.nPageID options_:NULL];
                }
                
                UINavigationController *nav = g_navigationController;
                PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
                if (direction > 0)
                {
                    if (direction == PPRevealSideDirectionLeft)
                    {
                        nav = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
                    }
                    else if (direction == PPRevealSideDirectionRight)
                    {
                        nav = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
                    }
                    [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionLeft animated:YES];
                    [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionRight animated:YES];
                }
                UIViewController *vc = [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIFenShiViewController_iphone class]];
                NSArray *ay = nav.viewControllers;
                NSMutableArray *mutAy = NewObject(NSMutableArray);
                for (int i = 0; i < ay.count; i++)
                {
                    [mutAy addObject:[ay objectAtIndex:i]];
                }
                
                pVC.nMsgType = nMsgType;
                id dic = (id)lParam;

                if (dic && [dic isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *dic = (NSMutableDictionary *)lParam;
                    pVC.pListView = (id)[dic objectForKey:@"View"];
                    NSString *codeIndex = [dic objectForKey:@"CodeIndex"];
                    if (codeIndex) {
                        pVC.nStockCodeIndex = [codeIndex intValue];
                    }
                    NSString *nameIndex = [dic objectForKey:@"nameIndex"];
                    if (nameIndex) {
                        pVC.nStockNameIndex = [nameIndex intValue];
                    }
                }
                else if (dic && [dic isKindOfClass:[tztReportListView class]])
                {
                    
                    pVC.pListView = (id)(tztReportListView *)lParam;
                    
                }
                else if (dic && [dic isKindOfClass:[NSArray class]])
                {
                    pVC.pListView = (id)lParam;
                }
                if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
                {
                    [tztUserStock AddRecentStock:pStock];
                    pVC.pStockInfo = pStock;
                    [pVC setStockInfo:pStock nRequest_:0];
                }
                if (bPush)
                {
                    if (vc)
                        [mutAy removeObject:vc];
                    [mutAy addObject:pVC];
                    [g_ayPushedViewController removeObject:pVC];
                    [g_ayPushedViewController addObject:pVC];
                    [pVC SetHidesBottomBarWhenPushed:YES];
                    [nav setViewControllers:mutAy animated:UseAnimated];
                }
                [mutAy release];
                [pVC release];
            }
        }
            break;
        case HQ_MENU_KLine://k线
        case MENU_HQ_Tech:
        {
            
        }
            break;
        case HQ_MENU_SearchStock://个股查询
        case MENU_HQ_SearchStock:
        {
            //zxl 20130719 交易界面进入个股查询时交易锁不用显示
            if (g_CurUserData)
            {
                g_CurUserData.bNeedShowLock = FALSE;
            }
            if (IS_TZTIPAD)
            {
                tztUISearchStockViewController_iPad *pVC = [[tztUISearchStockViewController_iPad alloc] init];
                [pVC setVcShowKind:tztvckind_Pop];
                pVC.nMsgType = nMsgType;
                
                pVC.nKeyBordType = TZTUserKeyBord_Number;
                
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                UIView* pView = (UIView*)wParam;
                CGRect rcFrom = CGRectZero;
                if (pView)
                {
                    rcFrom.origin = pView.center;
                    pVC.pSearchBar = (UISearchBar*)pView;
                }
                pVC.contentSizeForViewInPopover = CGSizeMake(600, 300);
                rcFrom.size = CGSizeMake(600, 300);
//                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
                [pBottomVC PopViewController:pVC rect:rcFrom];
                [pVC release];
            }
            else
            {
                BOOL bPush = FALSE;
                
                //允许多种分时显示同时存在
                int nType = 1;
                NSString *strType = [g_pSystermConfig.pDict tztObjectForKey:@"SearchStockType"];
                if (strType && strType.length > 0)
                    nType = [strType intValue];
                
                if (nType >= 1)
                {
                    tztUISearchStockCodeVCEx *pVC = (tztUISearchStockCodeVCEx *)gettztHaveViewContrller([tztUISearchStockCodeVCEx class], tztvckind_Pop,@"0",&bPush,TRUE);
                    [pVC retain];
                    pVC.nMsgType = nMsgType;
                    [pVC setTitle:@"个股查询"];
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                    [pVC release];
                }
                else
                {
                    tztUISearchStockViewController *pVC = (tztUISearchStockViewController *)gettztHaveViewContrller([tztUISearchStockViewController class], tztvckind_Pop,@"0",&bPush,TRUE);
                    
                    [pVC retain];
                    pVC.bShowSearchView = TRUE;
                    pVC.nMsgType = nMsgType;
                    [pVC setTitle:@"个股查询"];
#ifdef tzt_NewVersion
                    [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
#else
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
#endif
                    [pVC release];
                }
            }
        }
            break;
        case HQ_MENU_TztPushInfo://推送详细信息
        {
            NSString* strPushInfo = (NSString *)wParam;
            if(strPushInfo == nil || [strPushInfo length] <= 0)
            {
                return TRUE;
            }
            NSArray* ayPush = [strPushInfo componentsSeparatedByString:@"|"];
            if(ayPush == nil || [ayPush count] < 2)
                return TRUE;

            NSString *strURL = [g_pSystermConfig.pDict objectForKey:@"tztPushInfo"];
            if(strURL == nil || [strURL length] <= 0)
                return TRUE;
            NSString* strUrla = [NSString stringWithFormat:strURL,[[tztlocalHTTPServer getShareInstance] port],[ayPush objectAtIndex:0],[ayPush objectAtIndex:1]];
            if(strUrla == nil || [strUrla length] <= 0)
                return TRUE;
            TZTNSLog(@"%@",strUrla);
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_ZX,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.nWebType = tztWebInBox;
            [pVC setTitle:@"详细信息"];
            [pVC setWebURL:strUrla];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = pBottomVC.view.frame;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size.width -= 200;
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case HQ_MENU_Hudong://互动社区
        case MENU_SYS_InterActive:
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Main,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.nWebType = tztWebHudon;
#ifdef tzt_NewVersion
            pVC.nHasToolbar = 0;
#else
            pVC.nHasToolbar = 1;
#endif
            [pVC setTitle:@"互动社区"];
            NSString *strURL = [g_pSystermConfig.pDict objectForKey:@"tztHudong"];
            [pVC setWebURL:strURL];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = pBottomVC.view.frame;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size.width -= 200;
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case HQ_MENU_Online://在线客服
        case MENU_SYS_OnlineServe:
        case HQ_MENU_Online_Hot://客服热线
        case MENU_SYS_HotLine:
        case HQ_MENU_Online_CJWT://常见问题 zxl 20130729 自营添加常见问题
        case MENU_SYS_SystemQA:
        case HQ_MENU_Online_All://全部提问
        case MENU_SYS_AllQuestion:
        case HQ_MENU_Online_My://我的提问
        case MENU_SYS_MyQuestion:
        {
            NSString* strKey = @"tztOnlineCJWT";
            if (MENU_SYS_OnlineServe == nMsgType || HQ_MENU_Online == nMsgType)
            {
                strKey = @"tztOnlineCJWT";
            }
            else if(MENU_SYS_HotLine == nMsgType || HQ_MENU_Online_Hot == nMsgType)
            {
                strKey = @"tztOnlineHot";
            }
            else if(MENU_SYS_SystemQA == nMsgType || HQ_MENU_Online_CJWT == nMsgType)
            {
                strKey = @"tztOnlineCJWT";
            }
            else if(MENU_SYS_AllQuestion == nMsgType || HQ_MENU_Online_All == nMsgType)
            {
                strKey = @"tztOnline";
            }
            else if(MENU_SYS_MyQuestion == nMsgType || HQ_MENU_Online_My == nMsgType)
            {
                strKey = @"tztOnlineMy";
            }
            NSString *strURL = [g_pSystermConfig.pDict objectForKey:strKey];
            if(strURL == NULL || [strURL length] <= 0)
            {
                strURL = @"serviceajax/index.htm";
            }
            
            NSString* strUrla = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            //[NSString stringWithFormat:strURL,[[tztlocalHTTPServer getShareInstance] port]];
            UIViewController *pTopVC = [g_navigationController topViewController];
            if (pTopVC && [pTopVC isKindOfClass:[tztWebViewController class]])
            {
                [(tztWebViewController*)pTopVC setWebURL:strUrla];
                return TRUE;
            }
            else if(pTopVC && [pTopVC isKindOfClass:[TZTUIBaseViewController class]] && [(TZTUIBaseViewController*)pTopVC PopViewController])
            {
                UIPopoverController* pop = [(TZTUIBaseViewController*)pTopVC PopViewController];
                //当前已经是弹出窗口了
                UIViewController* pVC = pop.contentViewController;
                if (pVC && [pVC isKindOfClass:[tztWebViewController class]])
                {
                    [(tztWebViewController*)pVC setWebURL:strUrla];
                    return TRUE;
                }
            }
            
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Set,[NSString stringWithFormat:@"%d", tztWebOnline],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.nWebType = tztWebOnline;
            [pVC setTitle:@"在线客服"];
            [pVC setWebURL:strUrla];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = pBottomVC.view.frame;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size.width -= 200;
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        default:
            return FALSE;
    }
    return TRUE;
}


+(BOOL) OnTradeMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{ 
    //融资融券功能
    if (IsRZRQMsgType(nMsgType) && (nMsgType != MENU_JY_RZRQ_List && nMsgType != MENU_JY_RZRQ_Out && nMsgType != WT_RZRQList /*&& nMsgType != WT_RZRQLogin*/ && nMsgType != WT_RZRQOut && nMsgType != WT_JYRZRQ))
    {
        if (![TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountRZRQType])
        {
            return TRUE;
        }
    }
    
    if (IsRZRQMsgType(nMsgType))
    {
        return [TZTUIBaseVCMsg OnTradeRZRQMsg:nMsgType wParam:wParam lParam:lParam];
    }
    
    if (IsTradeType(nMsgType) && (nMsgType != WT_JiaoYi && nMsgType != WT_YZZZList && nMsgType != WT_AddAccount && nMsgType != WT_LOGIN && nMsgType != WT_OUT && nMsgType != MENU_SYS_JYLogout && nMsgType != WT_JJList && nMsgType != WT_FUND_TRADE))
    {
        if (![TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountPTType])
        {
            return TRUE;
        }
    }
    
    //if ( (nMsgType >= WT_FUND_TRADE)  && (nMsgType <=  WT_FUND_TRADE_End))
    if (IsFundMsgType(nMsgType))
    {
        // 基金交易
        return [TZTUIBaseVCMsg OnTradeFundMsg:nMsgType wParam:wParam lParam:lParam];
    }
    
    if (IsSBJYMsgType(nMsgType))
    {
        return [TZTUIBaseVCMsg OnTradeSBTradeMsg:nMsgType wParam:wParam lParam:lParam];
    }
    
    if (IsETFMsgType(nMsgType))
    {
        return [TZTUIBaseVCMsg OnTradeETFMsg:nMsgType wParam:wParam lParam:lParam];
    }
    if (IsTHBMsgType(nMsgType))
    {
        return [TZTUIBaseVCMsg OnTradeTHBMsg:nMsgType wParam:wParam lParam:lParam];
    }
    if (IsHKTradeMsgType(nMsgType))
    {
        return [TZTUIBaseVCMsg OnTradeHKMsg:nMsgType wParam:wParam lParam:lParam];
    }
    switch (nMsgType)
    {
        case WT_Trade_IPAD://iPad交易界面
        {
            if (![TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountPTType])
            {
                return TRUE;
            }
            if (g_pToolBarView)
            {
                [g_pToolBarView OnDealToolBarAtIndex:(int)lParam options_:nil];
//                [g_pToolBarView OnDealToolBarByName:@"股票交易"];
            }
        }
            break;
        case WT_JiaoYi://交易列表
        case TZT_MENU_JY_LIST:
        {
#ifdef tzt_TradeList
            if (g_navigationController.nPageID == tztvckind_JY)
            {
                [g_navigationController popToRootViewControllerAnimated:UseAnimated];
                return 1;
            }
            BOOL bPush = FALSE;
            tztUIFuctionListViewController *pVC = (tztUIFuctionListViewController *)gettztHaveViewContrller([tztUIFuctionListViewController class], tztvckind_JY, [NSString stringWithFormat:@"%d",TZT_MENU_JY_LIST], &bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            [pVC setProfileName:@"tztUITradeListSetting"];
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            [pVC SetTitle:@"委托交易"];
            return TRUE;
#else
            NSArray *pAy = [g_pSystermConfig.pDict objectForKey:@"TZTTradeGrid"];
            if (pAy == NULL || [pAy count] <= 0)
                return TRUE;
            
            BOOL bPush = FALSE;
            tztNineCellViewController *pVC = (tztNineCellViewController *)gettztHaveViewContrller([tztNineCellViewController class], tztvckind_JY, [NSString stringWithFormat:@"%ld", (long)nMsgType], &bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            
            NSInteger nCol = [[g_pSystermConfig.pDict objectForKey:@"tztNineCol"] intValue];
            if (nCol <= 0)
                nCol = 4;
            
            NSInteger nPerRow = [[g_pSystermConfig.pDict objectForKey:@"tztNineRow"] intValue];
            if (nPerRow <= 0)
                nPerRow = 4;
            NSInteger nRow = [pAy count] / nCol;
            if ([pAy count] % nCol != 0)
                nRow++;
            if (nRow < nPerRow)
                nRow = nPerRow;
            
            pVC.nCol = nCol;
            pVC.nRow = nRow;
            pVC.pAyNineCell = pAy;
            pVC.nsTitle = @"委托交易";
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
#endif
        }
            break;
        case WT_LOGIN://交易登录 10402 基金交易的登录
        case MENU_SYS_JYLogin:
        {
            [TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam];
        
        }
            break;
        case WT_AddAccount://预设账号
        case MENU_SYS_JYAddAccount:
        {
            BOOL bPush = FALSE;
            tztUIAddAccountViewController *pVC = (tztUIAddAccountViewController *)gettztHaveViewContrller([tztUIAddAccountViewController class], tztvckind_JY,[NSString stringWithFormat:@"%d", MENU_SYS_JYAddAccount], &bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            [pVC setMsgID:nMsgType MsgInfo:(void*)wParam LPARAM:lParam];
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case MENU_JY_PT_Buy: //12310 股票买入 普通买入
        case MENU_JY_PT_Sell: //12311 股票卖出 普通卖出
        case WT_BUY://买入
        case WT_SALE://卖出
//        case MENU_JY_PT_ZhaiZhuanGu:  //债券股 12315
        case MENU_JY_PT_NiHuiGou: //12319  逆向回购
        {
            tztStockInfo *pStock = nil;
            pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            
            tztUIStockBuySellViewController *pVC = (tztUIStockBuySellViewController *)gettztHaveViewContrller([tztUIStockBuySellViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];
            
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode && (pStock.stockType == 0 || MakeStockMarketStock(pStock.stockType)))
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            }
            
            pVC.nMsgType = nMsgType;
            pVC.bBuyFlag = (nMsgType == WT_BUY || nMsgType == MENU_JY_PT_Buy);
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                //zxl 20131011 修改了显示界面的大小
                rcFrom.size = CGSizeMake(490, 640);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else
            {
                if(bPush)
                {
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                }
                else
                {
                    [pVC LoadLayoutView];
                    [pVC OnRequestData];
                }
            }
            [pVC release];
        }
            break;
        case WT_QUERYDRWT://当日委托
        case MENU_JY_PT_QueryDraw:
        case WT_WITHDRAW://撤单
        case MENU_JY_PT_Withdraw: //基金撤单撤单 12340
        {
            BOOL bPush = FALSE;
            tztUITradeWithDrawViewController *pVC = (tztUITradeWithDrawViewController *)gettztHaveViewContrller([tztUITradeWithDrawViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if (bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            else
            {
                [pVC.pWithDrawView OnRequestData];
            }
            [pVC release];
        }
            break;
        case WT_QUERYDRCJ://当日成交
        case MENU_JY_PT_QueryTradeDay:
        case MENU_JY_PT_QueryDeal:
        case WT_QUERYGP://查询股票
        case MENU_JY_PT_QueryStock:
        case WT_QUERYGDZL://股东资料
        case MENU_JY_PT_QueryGdzl:
        case WT_QUERYFUNE://查询资金
        case MENU_JY_PT_QueryFunds:
        case WT_TRANSHISTORY://转账流水
        case MENU_JY_PT_QueryBankHis://转账流水 //新功能号
        case WT_ZiChanZZ://资产总值
        case MENU_JY_PT_QueryNewStockED: // 新股申购额度查询
        case MENU_JY_PT_QueryXinGu://新股列表查询
        {
            BOOL bPush = FALSE;
#ifdef Support_HTSC
            tztUITradeSearchViewController *pVC = (tztUITradeSearchViewController *)gettztHaveViewContrller([tztUITradeSearchViewController class],tztvckind_Pop,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
#else
            tztUITradeSearchViewController *pVC = (tztUITradeSearchViewController *)gettztHaveViewContrller([tztUITradeSearchViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
#endif
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if (bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            else
            {
                [pVC LoadLayoutView];
                [pVC.pSearchView OnRequestData];
            }
            [pVC release];
        }
            break;
        case WT_QUERYJG://查询交割
        case MENU_JY_PT_QueryJG:
        case MENU_JY_PT_QueryHisTrade:
        case WT_QUERYPH://查询配号
        case MENU_JY_PT_QueryPH:
        case WT_QUERYLS://资金明细
        case MENU_JY_PT_QueryZJMX:
        case WT_QUERYLSCJ://历史成交
        case MENU_JY_PT_QueryTransHis://历史成交 新功能号add by xyt 20131128
        case WT_LiShiDZD://对账单
        case MENU_JY_BJHG_HisQuery: // 13848  历史委托查询389
        case MENU_JY_PT_QueryNewStockZQ: //12384  查询新股中签
    
        {
            BOOL bPush = FALSE;
            TZTUIDateViewController *pVC = (TZTUIDateViewController *)gettztHaveViewContrller([TZTUIDateViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
            break;
        case MENU_SYS_JYErrorLogout://交易错误登出
        {
            [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
            [tztJYLoginInfo SetLoginAllOut];
        }
            break;
        case WT_OUT://退出登录
        case MENU_SYS_JYLogout:
        {
            NSString* nsTips = @"交易登录已经退出！";
            if (![TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])
            {
                nsTips = @"当前没有账号登录!";
                tztAfxMessageBox(nsTips);
                return 1;
            }
            NSString* str = (NSString*)wParam;
            NSDictionary * pDict = [NSDictionary GetDictFromParam:str];
            NSString* strContext = [pDict tztObjectForKey:@"context"];
            NSString* strUrl = [[[pDict tztObjectForKey:@"url"] tztdecodeURLString] lowercaseString];
            
            if (strContext.length > 0)
            {
                tztAfxMessageBlock(strContext, nil, nil, TZTBoxTypeButtonBoth, ^(NSInteger nIndex){
                    if (nIndex == 0)
                    {
                        [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
#ifdef tzt_NewVersion
                        [g_navigationController popToRootViewControllerAnimated:((strUrl.length > 0) ? NO : UseAnimated)];
#endif
                        if (IS_TZTIPAD)
                        {
                            [g_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
                        }
                        [tztJYLoginInfo SetLoginAllOut];
                        
                        if (strUrl.length > 0 && [strUrl hasPrefix:@"http://action:"])
                        {
                            NSString* strAction = [strUrl substringFromIndex:[@"http://action:" length]];
                            [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:/*lParam*/0];
                        }
                        else
                            tztAfxMessageBox(nsTips);
                    }
                });
            }
            else
            {
                [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
#ifdef tzt_NewVersion
                [g_navigationController popToRootViewControllerAnimated:((strUrl.length > 0) ? NO : UseAnimated)];
#endif
                if (IS_TZTIPAD)
                {
                    [g_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
                }
                [tztJYLoginInfo SetLoginAllOut];
                
                if (strUrl.length > 0 && [strUrl hasPrefix:@"http://action:"])
                {
                    NSString* strAction = [strUrl substringFromIndex:[@"http://action:" length]];
                    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:/*lParam*/0];
                }
                else
                {
                    tztAfxMessageBox(nsTips);
                }
            }
//            NSString* nsTips = @"交易登录已经退出！";
//            if (![TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])
//            {
//                nsTips = @"当前没有账号登录!";
//            }
//            [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
//#ifdef tzt_NewVersion
//            [g_navigationController popToRootViewControllerAnimated:UseAnimated];
//#endif
//            if (IS_TZTIPAD)
//            {
//                [g_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
//            }
//            [tztJYLoginInfo SetLoginAllOut];
//            tztAfxMessageBox(nsTips);
        }
            break;
        case WT_BANKTODEALER:
        case MENU_JY_PT_Bank2Card:
        case WT_DEALERTOBANK:
        case MENU_JY_PT_Card2Bank:
        case WT_QUERYBALANCE:
        case MENU_JY_PT_BankYue:
        {
            BOOL bPush = FALSE;
            tztUIBankDealerViewController *pVC = (tztUIBankDealerViewController *)gettztHaveViewContrller([tztUIBankDealerViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@""];
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_PWD:
        case MENU_JY_PT_Password:
        {
            BOOL bPush = FALSE;
            tztUIChangePWViewController *pVC = (tztUIChangePWViewController *)gettztHaveViewContrller([tztUIChangePWViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
            
            //****************************多方存管**********************
#ifdef Support_DFCG
        case WT_GuiJiResult://资金归集
        case WT_DFQUERYDRNZ://当日内转查询
        case WT_NeiZhuanResult://查询流水
        case WT_DFTRANSHISTORY://调拨流水
        case MENU_JY_DFBANK_Input://资金归集
        case MENU_JY_DFBANK_QueryBankHis://查询流水
        case MENU_JY_DFBANK_QueryTransitHis://调拨流水
        
        {
            BOOL bPush = FALSE;
            tztUIDFCGSearchViewController *pVC = (tztUIDFCGSearchViewController *)gettztHaveViewContrller([tztUIDFCGSearchViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_DFQUERYNZLS://历史内转查询
        {
            BOOL bPush = FALSE;
            TZTUIDateViewController *pVC = (TZTUIDateViewController *)gettztHaveViewContrller([TZTUIDateViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        //zxl 20130718 计划转账流水默认是时间不同
        case WT_DFQUERYHISTORYEx://计划查询流水
        {
            BOOL bPush = FALSE;
            TZTUIDateViewController *pVC = (TZTUIDateViewController *)gettztHaveViewContrller([TZTUIDateViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            [pVC SetMinDate:[NSDate date]];
            [pVC SetMaxDate:[[NSDate date] dateByAddingTimeInterval:(30.0 * 24 * 60 * 60)]];
            [pVC.pDateView SetBegDate:[NSDate date]];
            [pVC.pDateView SetEndDate:[[NSDate date] dateByAddingTimeInterval:(30.0 * 24 * 60 * 60)]];
        }
            break;
        case WT_DFDEALERTOBANK://证券转卡
        case WT_DFBANKTODEALER://卡转证券
        case WT_DFQUERYBALANCE://查询金额
        case MENU_JY_DFBANK_Bank2Card://证券转卡
        case MENU_JY_DFBANK_Card2Bank://卡转证券
        case MENU_JY_DFBANK_BankYue://查询金额
        case WT_NeiZhuan://资金内转
        case MENU_JY_DFBANK_Transit: // 资金调拨
        {
            BOOL bPush = FALSE;
            tztUIDFCGBankDealerViewController *pVC = (tztUIDFCGBankDealerViewController *)gettztHaveViewContrller([tztUIDFCGBankDealerViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
#endif
            //********************************************************
        default:
            return FALSE;
    }
    return TRUE;
}

+(BOOL) OnTradeFundMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
#ifdef Support_FundTrade
    if (IsTradeType(nMsgType) && (nMsgType != WT_JiaoYi && nMsgType != WT_YZZZList && nMsgType != WT_AddAccount && nMsgType != WT_LOGIN && nMsgType != WT_OUT && nMsgType != MENU_SYS_JYLogout && nMsgType != WT_JJList && nMsgType != WT_FUND_TRADE))
    {
        if (![TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountPTType])
        {
            return TRUE;
        }
    }
//ZXL 20130718 区分了国泰的基金特殊处理
#ifdef Support_GTFundTrade
    tztJYLoginInfo * curUserInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (curUserInfo && !curUserInfo.bCheckFXCP)
    {
        if (IsCheckFundFxdj(nMsgType))
        {
            //做过风险测评 和签署风险揭示（最开始的检测）
            return [TZTUIBaseVCMsg OnTradeFundMsg:WT_JJRiskSign wParam:nMsgType lParam:lParam];
        }
    }
    if ([tztUIBaseVCOtherMsg OnTradeFundMsg:nMsgType wParam:wParam lParam:lParam])
         return TRUE;
#endif
    switch (nMsgType)
    {
        case WT_JJList://列表
        {
            BOOL bPush = FALSE;
            tztUIFuctionListViewController *pVC = (tztUIFuctionListViewController *)gettztHaveViewContrller([tztUIFuctionListViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            [pVC setProfileName:@"tztUIFundTradeListSetting"];
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            [pVC SetTitle:@"开放式基金"];
            return TRUE;
        }
            break;
        case WT_JiaoYi://交易列表
        {
#ifdef tzt_NewVersion
            tztUINavigationController* pNav = [tztMainViewController getNavController:tztvckind_JY];
            [pNav popToRootViewControllerAnimated:NO];
            [tztMainViewController didSelectNavController:tztvckind_JY options_:NULL];
            [g_ayPushedViewController removeObject:pNav.topViewController];
            [g_ayPushedViewController addObject:pNav.topViewController];
            return TRUE;
#endif            
            NSArray *pAy = [g_pSystermConfig.pDict objectForKey:@"TZTTradeGrid"];
            if (pAy == NULL || [pAy count] <= 0)
                return TRUE;
            
            BOOL bPush = FALSE;
            tztNineCellViewController *pVC = (tztNineCellViewController *)gettztHaveViewContrller([tztNineCellViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",TZT_MENU_JY_LIST],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            
            NSInteger nCol = [[g_pSystermConfig.pDict objectForKey:@"tztNineCol"] intValue];
            if (nCol <= 0)
                nCol = 4;
            
            NSInteger nPerRow = [[g_pSystermConfig.pDict objectForKey:@"tztNineRow"] intValue];
            if (nPerRow <= 0)
                nPerRow = 4;
            NSInteger nRow = [pAy count] / nCol;
            if ([pAy count] % nCol != 0)
                nRow++;
            if (nRow < nPerRow)
                nRow = nPerRow;
            
            pVC.nCol = nCol;
            pVC.nRow = nRow;
            pVC.pAyNineCell = pAy;
            pVC.nsTitle = @"委托交易";
            if (bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_FUND_TRADE:
        {
#ifdef tzt_TradeList
            BOOL bPush = FALSE;
            tztUIFuctionListViewController *pVC = (tztUIFuctionListViewController *)gettztHaveViewContrller([tztUIFuctionListViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
#ifndef IsZYSC
            [pVC SetTitle:@"委托交易"];
            [pVC setProfileName:@"tztUITradeFundListSetting"];
#else
            [pVC SetTitle:@"基金交易"];
            [pVC setProfileName:@"tztUITradeETFundListSetting"];
#endif
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return TRUE;
#else
            NSArray *pAy = [g_pSystermConfig.pDict objectForKey:@"TZTFundTradeGrid"];
            if (pAy == NULL || [pAy count] <= 0)
                return TRUE;
            
            BOOL bPush = FALSE;
            tztNineCellViewController *pVC = (tztNineCellViewController *)gettztHaveViewContrller([tztNineCellViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            NSInteger nCol = [[g_pSystermConfig.pDict objectForKey:@"tztNineCol"] intValue];
            if (nCol <= 0)
                nCol = 4;
            
            NSInteger nPerRow = [[g_pSystermConfig.pDict objectForKey:@"tztNineRow"] intValue];
            if (nPerRow <= 0)
                nPerRow = 4;
            NSInteger nRow = [pAy count] / nCol;
            if ([pAy count] % nCol != 0)
                nRow++;
            if (nRow < nPerRow)
                nRow = nPerRow;
            pVC.nCol = nCol;
            pVC.nRow = nRow;
            pVC.pAyNineCell = pAy;
            pVC.nsTitle = @"基金交易";
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
#endif
        }
            break;
        case WT_LOGIN://交易登录
        {
            [TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountPTType];
        }
            break;
        case WT_JJRGFUND://基金认购
        case WT_JJAPPLYFUND:
        case WT_JJREDEEMFUND:
        case MENU_JY_FUND_RenGou: //基金认购 //新功能号add by xyt 20131018
        case MENU_JY_FUND_ShenGou://基金申购
        case MENU_JY_FUND_ShuHui://基金赎回
        {
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            tztUIFoundSGOrRG *pVC = (tztUIFoundSGOrRG *)gettztHaveViewContrller([tztUIFoundSGOrRG class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            }
        
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 400);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_JJINQUIREENTRUST:
        case WT_JJINCHAXUNACCOUNT:
        case WT_JJINQUIREGUFEN:
        case WT_JJWITHDRAW:
        case WT_JJINZHUCEACCOUNT://基金开户
        case WT_JJINQUIREDT:
        case WT_JJWWContactInquire://电子合同签署
        case WT_JJWWCashProdAccInquire:
        case WT_JJWWPlansTransQuery:
        case WT_JJSEARCHDT:
        case WT_JJGSINQUIRE:        //add 基金公司
        case MENU_JY_FUND_QueryAllCompany: //12825  基金公司查询
        case WT_JJWWInquire:
        case WT_JJPHInquireCJ:      //基金盘后当日成交查询  LOF当日成交
        case WT_JJPHInquireEntrust: //  基金盘后当日委托查询  LOF当日委托
    //        case WT_JJPHWithDraw:       //  基金盘后业务撤单     LOF当日撤单
        case WT_JJInquireLevel:     //基金客户风险等级查询
        case WT_JJLCWithDraw:       //理财撤单
        case WT_JJLCFEInquire:      //理财份额查询
        case WT_JJLCDRWTInquire:    //理财当日委托查询
        case WT_JJINQUIRETransCX:   //基金转换查询
        case WT_JJPCKM:             //评测可购买基金
        case WT_JJLCCPDM:       //产品代码查询
        case WT_JJDRCJ:         //基金当日成交
        case WT_INQUIREFUNDEX: // 基金查询
        case MENU_JY_FUND_QueryAllCode: // 基金代码查询
        //新功能号add by xyt 20131018
        case MENU_JY_FUND_QueryDraw://当日委托
        case MENU_JY_FUND_QueryStock://基金份额（持仓基金）
        case MENU_JY_FUND_Withdraw://委托撤单  
        case MENU_JY_FUND_QueryKaihu://基金账号（已开户基金）
        case MENU_JY_FUND_FengXianDengJIQuery://基金风险等级查询
        {
            //这个地方 基金查询 ，持仓基金
            BOOL bPush = FALSE;
            tztUIFountSearchWTVC *pVC = (tztUIFountSearchWTVC *)gettztHaveViewContrller([tztUIFountSearchWTVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            
        }
            break;
        case WT_JJINQUIRECJ://历史成交
        case WT_JJINQUIREWT://历史委托
        case WT_JJPHInquireHisEntrust://基金盘后历史委托查询  LOF历史委托
        case WT_JJPHInquireHisCJ:     //基金盘后历史成交查询  LOF历史成交查询
        //新功能号add by xyt 20131018
        case MENU_JY_FUND_QueryVerifyHis://历史确认(历史成交？)
        case MENU_JY_FUND_QueryWTHis://历史委托
        {
            BOOL bPush = FALSE;
            TZTUIDateViewController *pVC = (TZTUIDateViewController *)gettztHaveViewContrller([TZTUIDateViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            [pVC view];
            pVC.pDateView.pEndDate =[[NSDate date] dateByAddingTimeInterval:(-1.0 * 24 * 60 * 60)];
            pVC.pDateView.pBeginDate = [[NSDate date] dateByAddingTimeInterval:(-31 * 24 * 60 * 60)];
            
//            [pVC SetMinDate:[NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970] - 24 * 60 * 60)]];
//            [pVC SetMaxDate:[NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970] - 24 * 60 * 60)]];
            
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];


            
            [pVC release];
        }
            break;
        case WT_JJFHTypeChange://分红设置
        case MENU_JY_FUND_FenHongSet://基金分红设置
        {
            BOOL bPush = FALSE;
            tztUIFundFHVC *pVC = (tztUIFundFHVC *)gettztHaveViewContrller([tztUIFundFHVC class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_JJINZHUCEACCOUNTEx://基金开户
        case MENU_JY_FUND_Kaihu://基金开户
        {
            BOOL bPush = FALSE;
            tztUIFoundHKVC *pVC = (tztUIFoundHKVC *)gettztHaveViewContrller([tztUIFoundHKVC class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            //zxl 20130718 修改了基金开户传参方式
            NSString *Value = (NSString*)wParam;
            if (Value && [Value length] > 0)
            {
                NSArray *array = [Value componentsSeparatedByString:@"|"];
                if (array && [array count] == 3)
                {
                    Value = [array objectAtIndex:0];
                    if (Value && [Value length] > 0)
                        pVC.nsJJGSDM = [NSString stringWithFormat:@"%@",Value];
                    
                    Value = [array objectAtIndex:1];
                    if (Value && [Value length] > 0)
                        pVC.nsJJGSMC = [NSString stringWithFormat:@"%@",Value];
                    
                    Value = [array objectAtIndex:2];
                    if (Value && [Value length] > 0)
                        pVC.nReturn = [Value intValue];
                }
            }
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_JJFHTypeChangeD:
        {
            BOOL bPush = FALSE;
            tztUIFundFHVC *pVC = (tztUIFundFHVC *)gettztHaveViewContrller([tztUIFundFHVC class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                    pVC.pStock = pStock;
            }
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            
        }
            break;
        case WT_JJRGFUNDEX://场内基金认购申购赎回
        case WT_JJAPPLYFUNDEX:
        case WT_JJREDEEMFUNDEX:
        //新功能号 add by xyt 20131018
        case MENU_JY_FUNDIN_RenGou://场内基金认购
        case MENU_JY_FUNDIN_ShenGou://场内基金申购
        case MENU_JY_FUNDIN_ShuHui://场内基金赎回
        {
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            tztUIFundCNTradeVC *pVC = (tztUIFundCNTradeVC *)gettztHaveViewContrller([tztUIFundCNTradeVC class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            }
            pVC.nMsgType = nMsgType;
            
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 400);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_JJSplitAndMerge:
        {
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            tztUIFundCFVC *pVC = (tztUIFundCFVC *)gettztHaveViewContrller([tztUIFundCFVC class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            }
            pVC.nMsgType = nMsgType;
            
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 400);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_JJDTModify://已定投基金修改
        case WT_JJZHUCEACCOUNTDT:
        {
            NSMutableDictionary *pDict = (NSMutableDictionary*)wParam;
            
            BOOL bPush = FALSE;
            TZTUIFundDTKHVC *pVC = (TZTUIFundDTKHVC *)gettztHaveViewContrller([TZTUIFundDTKHVC class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            if (pDict)
            {
                pVC.pDefaultDateDict = pDict;
            }
            pVC.nMsgType = nMsgType;
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 400);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_JJINQUIRETrans:
        case MENU_JY_FUND_Change://基金转换
        {
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            tztUIFundZHVC *pVC = (tztUIFundZHVC *)gettztHaveViewContrller([tztUIFundZHVC class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            }
            pVC.nMsgType = nMsgType;
            
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 400);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_JJRiskSign://风险问卷测评
		case WT_JJRevealsSign://风险揭示书签署
		{
			tztFundFxVC *RequestBs = NewObjectAutoD(tztFundFxVC);
			RequestBs.m_nMsgID = nMsgType;
			RequestBs.requestID = @"188";
            RequestBs.nChangeMsgID = (int)wParam;
			RequestBs.requestBody = RequestBs;
			[RequestBs Dorequest];
		}
			break;
        case WT_JJZHSGFUND://组合申购
        {
            BOOL bPush = FALSE;
            TZTUIFundZHSGViewController *pVC = (TZTUIFundZHSGViewController *)gettztHaveViewContrller([TZTUIFundZHSGViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.nCurrentIndex = (int)wParam;
            int nShowAll = (int)lParam;
            pVC.bShowAll = (nShowAll != 1);
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 400);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_JJZHSGSearch://组合基金查询
        case WT_JJZHSGCreate://生成清单，
        {
            BOOL bPush = FALSE;
            tztUIFundZHSGSearchViewController *pVC = (tztUIFundZHSGSearchViewController *)gettztHaveViewContrller([tztUIFundZHSGSearchViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];

            NSMutableArray* pDict = (NSMutableArray*)wParam;
            pVC.nMsgType = nMsgType;
            if (pDict)
                pVC.ayFundCode = pDict;
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 400);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_JJZHSHFUND://组合赎回
        {
            BOOL bPush = FALSE;
            tztUIFundZHSHViewController *pVC = (tztUIFundZHSHViewController *)gettztHaveViewContrller([tztUIFundZHSHViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            [pVC retain];
            NSMutableDictionary* ayCode = (NSMutableDictionary*)wParam;
            pVC.nMsgType = nMsgType;
            if (ayCode)
                pVC.ayFundCode = (NSMutableArray *)ayCode;
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 400);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            
        }
            break;
        case WT_JJZHInfo://组合说明
        {
            BOOL bPush = FALSE;
            tztUIFundZHInfoViewController *pVC = (tztUIFundZHInfoViewController *)gettztHaveViewContrller([tztUIFundZHInfoViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            [pVC retain];
            
            pVC.nCurrentIndex = wParam;
            pVC.nMsgType = nMsgType;
            pVC.bShowAll = FALSE;
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 400);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            
        }
            break;
        default:
            return FALSE;
    }
    
#endif
    return TRUE;
}

+(BOOL) OnTradeRZRQMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
#ifdef Support_RZRQ
    switch (nMsgType)
    {
        case WT_JYRZRQ://融资融券九宫格
        case MENU_JY_RZRQ_List: //融资融券
        {
        //zxl 20130718 融资融券添加列表
#ifdef tzt_TradeList
            BOOL bPush = FALSE;
            tztUIFuctionListViewController *pVC = (tztUIFuctionListViewController *)gettztHaveViewContrller([tztUIFuctionListViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            [pVC setProfileName:@"tztUIRZRQTradeListSetting"];
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            [pVC SetTitle:@"融资融券"];
            return TRUE;
#else
            NSArray *pAy = [g_pSystermConfig.pDict objectForKey:@"TZTTradeRZRQGrid"];
            if (pAy == NULL || [pAy count] <= 0)
                return TRUE;
            
            BOOL bPush = FALSE;
            tztNineCellViewController *pVC = (tztNineCellViewController *)gettztHaveViewContrller([tztNineCellViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d", nMsgType],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            int nCol = [[g_pSystermConfig.pDict objectForKey:@"tztNineCol"] intValue];
            if (nCol <= 0)
                nCol = 4;
            
            int nPerRow = [[g_pSystermConfig.pDict objectForKey:@"tztNineRow"] intValue];
            if (nPerRow <= 0)
                nPerRow = 4;
            int nRow = [pAy count] / nCol;
            if ([pAy count] % nCol != 0)
                nRow++;
            if (nRow < nPerRow)
                nRow = nPerRow;
            
            pVC.nCol = nCol;
            pVC.nRow = nRow;
            pVC.pAyNineCell = pAy;
            pVC.nsTitle = @"融资融券";
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
#endif
            
        }
            break;
        case WT_RZRQOut://退出融资融券
        case MENU_JY_RZRQ_Out:
        case MENU_SYS_RZRQOut:
        {
            g_CurUserData.nsDBPLoginToken = @"";
            NSString* nsTips = @"融资融券登录已经退出！";
            if (![TZTUserInfoDeal IsHaveTradeLogin:RZRQTrade_Log])
            {
                nsTips = @"当前没有融资融券账号登录!";
            }
            tztAfxMessageBox(nsTips);
//            TZTUIMessageBox *pBox = [[[TZTUIMessageBox alloc] initWithFrame:[UIScreen mainScreen].bounds nBoxType_:TZTBoxTypeNoButton delegate_:nil] autorelease];
            [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:RZRQTrade_Log];
//            [tztJYLoginInfo SetLoginAllOut];
            //融资融券退出  modify by xyt 20131025
            if (IS_TZTIPAD)
            {
                [g_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
            }
//            pBox.m_nsTitle = @"提示信息";
//            pBox.m_nsContent = nsTips;
//            [pBox showForView:nil];
        }
            break;
        case WT_RZRQBUY://普通买入
        case WT_RZRQRZBUY:  //融资买入
        case WT_RZRQBUYRETURN:
            
        case WT_RZRQSALE:
        case WT_RZRQRQSALE:
        case WT_RZRQSALERETURN:
        //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
        case MENU_JY_RZRQ_XYBuy:// 融资买入
        case MENU_JY_RZRQ_XYSell://融券卖出
        case MENU_JY_RZRQ_BuyReturn://买券还券
        case MENU_JY_RZRQ_SellReturn://卖券还款
        {
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            tztUIRZRQBuySellViewController *pVC = (tztUIRZRQBuySellViewController *)gettztHaveViewContrller([tztUIRZRQBuySellViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];

            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
                
            }
            pVC.nMsgType = nMsgType;
           
            pVC.bBuyFlag = (WT_RZRQBUY == nMsgType || WT_RZRQRZBUY == nMsgType || nMsgType == WT_RZRQBUYRETURN || nMsgType == MENU_JY_RZRQ_PTBuy || nMsgType == MENU_JY_RZRQ_XYBuy || nMsgType == MENU_JY_RZRQ_BuyReturn);
            
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
#ifdef kSUPPORT_XBSC
        case kRZRQ_ZDMQHK: //指定卖券还款

        {
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            tztUIRZRQBuySellViewController *pVC = (tztUIRZRQBuySellViewController *)gettztHaveViewContrller([tztUIRZRQBuySellViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
                if (pStock.contractNumber)
                {
                    pVC.contractNumber=pStock.contractNumber;
                }
                if (pStock.repaymentAmount)
                {
                    pVC.repaymentAmount=pStock.repaymentAmount;
                }
            }
            pVC.nMsgType = nMsgType;
            
            pVC.bBuyFlag = (WT_RZRQBUY == nMsgType || WT_RZRQRZBUY == nMsgType || nMsgType == WT_RZRQBUYRETURN || nMsgType == MENU_JY_RZRQ_PTBuy || nMsgType == MENU_JY_RZRQ_XYBuy || nMsgType == MENU_JY_RZRQ_BuyReturn);
            
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
#endif

        case WT_RZRQSTOCKHZ://担保品划转
        case MENU_JY_RZRQ_Transit://担保划转 //新功能号 add by xyt 20131018
        {
            //需要对应的普通账号登录
            //modify by xyt 20130718 修改判断条件,不需要判断交易是否登录
            //if (![TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log] && g_pSystermConfig.bRZRQHZLogin)
            if (g_pSystermConfig.bRZRQHZLogin)
            {
                if (g_CurUserData.nsDBPLoginToken == NULL || [g_CurUserData.nsDBPLoginToken length] <= 0)
                {
                    BOOL bPush = FALSE;
                    tztUIRZRQNeedPTLoginViewController *pVC = (tztUIRZRQNeedPTLoginViewController *)gettztHaveViewContrller([tztUIRZRQNeedPTLoginViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
                    [pVC retain];
                    
                    pVC.nMsgType = nMsgType;
                    if(bPush)
                        [g_navigationController pushViewController:pVC animated:UseAnimated];
                    [pVC release];
                    return TRUE;
                }
            }
            
            BOOL bPush = FALSE;
            tztUIRZRQStockHzViewController *pVC = (tztUIRZRQStockHzViewController *)gettztHaveViewContrller([tztUIRZRQStockHzViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;//添加界面类型,超时时候回调 add by xyt20130820
            if(pVC)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
//            //需要判断交易登录
//            tztUIRZRQStockHzViewController *pVC = NewObject(tztUIRZRQStockHzViewController);
//            [g_navigationController pushViewController:pVC animated:UseAnimated];
//            [pVC release];
        }
            break;
        case WT_RZRQFUNDRETURN://直接还款
        case MENU_JY_RZRQ_ReturnFunds://直接还款 //新功能号 add by xyt 20131018
//#ifdef kSUPPORT_XBSC
//            case kRZRQ_ZDHYHK: //指定合约还款
//#endif
        {
//            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            
            tztUIRZRQFundReturnViewController *pVC = (tztUIRZRQFundReturnViewController *)gettztHaveViewContrller([tztUIRZRQFundReturnViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            [pVC retain];
//            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
//            {
//                if (pStock.stockCode) //股票代码
//                {
//                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
//                }
//                if (pStock.stockName) //股票名称
//                {
//                    pVC.CurStockName = [NSString stringWithFormat:@"%@", pStock.stockName];
//                }
//                if (pStock.contractNumber) //合约编号
//                {
//                    pVC.contractNumber=pStock.contractNumber;
//                }
//                if (pStock.repaymentAmount) //需还款数量(需还款金额)
//                {
//                    pVC.repaymentAmount=pStock.repaymentAmount;
//                }
//                if(pStock.backDate) //到货日期
//                {
//                    pVC.backDate=pStock.backDate;
//                }
//                if(pStock.debitBalance) //负债金额（费用负债）
//                {
//                    pVC.debitBalance=pStock.debitBalance;
//                }
//                if(pStock.debitInterest) //预计利息
//                {
//                    pVC.debitInterest=pStock.debitInterest;
//                }
//                if(pStock.debitType) //负债类型
//                {
//                    pVC.debitType=pStock.debitType;
//                }
//
//            }
//#ifdef kSUPPORT_XBSC
//            if (nMsgType==kRZRQ_ZDMQHK) {
//                pVC.nsTitle=@"指定合约还款";
//            }
//#endif
//            

            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_RZRQSTOCKRETURN://直接还券
        case MENU_JY_RZRQ_ReturnStock://现券还券（直接还券）//新功能号 add by xyt 20131018
        {
            BOOL bPush = FALSE;
            tztUIRZRQCrashRetuenViewController *pVC = (tztUIRZRQCrashRetuenViewController *)gettztHaveViewContrller([tztUIRZRQCrashRetuenViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_RZRQQUERYDRWT:  //当日委托
        case WT_RZRQQUERYHZLS:  //划转查询
        case WT_RZRQWITHDRAW:   //查询撤单
        case WT_RZRQQUERYWITHDRAW://
        case WT_RZRQQUERYNOJY://
        case WT_RZRQWITHDRAWHZ://划转撤单
        //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_QueryDraw://当日委托
        case MENU_JY_RZRQ_Withdraw://委托撤单
        case MENU_JY_RZRQ_TransWithdraw://划转撤单
        case MENU_JY_RZRQ_TransQueryDraw://划转流水 add by xyt 20131021
        case MENU_JY_RZRQ_NoTradeQueryDraw://非交易过户委托 add by xyt 20131021
        {
            BOOL bPush = FALSE;
            tztUIRZRQWithDrawViewController *pVC = (tztUIRZRQWithDrawViewController *)gettztHaveViewContrller([tztUIRZRQWithDrawViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_RZRQQUERYFUNE:  //查询资金
        case WT_RZRQQUERYGP:    //查询股票
        case WT_RZRQQUERYDRCJ:  //当日成交
            //case WT_RZRQQUERYLS:    //资金流水
        case WT_RZRQQUERYRZQK:  //融资负债
        case WT_RZRQQUERYRQQK:  //融券负债
        case WT_RZRQQUERYRZFZ:  //融资明细
        case WT_RZRQQUERYRQFZ:  //融券明细
        case WT_RZRQQUERYXYSX:  //信用上限
        case WT_RZRQQUERYZCFZ:  //信用负债
        case MENU_JY_RZRQ_QueryHeYue:
        case WT_RZRQQUERYCANBUY://融资标的查询
        case WT_RZRQQUERYCANSALE://融券标的查询
        case WT_RZRQQUERYDBP:   //查询担保品
        case WT_RZRQQUERYXYGF:  //信用股份
            
        case WT_RZRQQUERYXYZC:  //信用资产
        case MENU_JY_RZRQ_QueryXYZC:
            
        case WT_RZRQGDLB:       //股东列表
        case WT_RZRQWPC:        //信用合约未平仓
        case WT_RZRQTRANSHISTORY://转账流水
        case MENU_JY_RZRQ_QueryBankHis://转账流水 //新功能号 add by xyt 20131021
        case WT_RZRQQUERYBDQ://标的券查询
        case WT_RZRQDBPBL:
        //zxl 20130718 添加以下功能请求
        case WT_RZRQQUERYContract://合同查询
        case WT_RZRQQUERYBZJ://保证金查询
        case WT_RZRQQUERYDRLS://当日资金流水
        case WT_RZRQQUERYDRFZLS://当日负债流水
        //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_QueryFunds://查询资金
        case MENU_JY_RZRQ_QueryStock://查询股票（查询持仓）
        case MENU_JY_RZRQ_QUeryTransDay://当日成交
        case MENU_JY_RZRQ_QueryRZFZQK://融资负债查询 融资合约
        case MENU_JY_RZRQ_QueryRQFZQK://融券负债查询 融券合约
        case MENU_JY_RZRQ_QueryRZQK://融资情况查询  融资债细 融资明细
        case MENU_JY_RZRQ_QueryRQQK://融券情况查询  融券债细 融券明细
        case MENU_JY_RZRQ_QueryZCFZQK://资产负债查询 查询资产 信用负债
        case MENU_JY_RZRQ_QueryDBZQ:// 担保证券查询 查询担保品
        case MENU_JY_RZRQ_QueryCANBUY://委托查询可融资买入标的券   融资标的查询
        case MENU_JY_RZRQ_QueryRZBD:
        case MENU_JY_RZRQ_QueryCANSALE://委托查询可融券卖出标的券  融券标的查询
        case MENU_JY_RZRQ_QueryRQBD:
        case MENU_JY_RZRQ_QueryXYShangXian://信用上限
        case MENU_JY_RZRQ_QueryBDZQ://标的证券查询
        case MENU_JY_RZRQ_QueryFundsDay: //当日资金流水
        case MENU_JY_RZRQ_QueryNewStockED: //15220  新股申购额度查询
#ifdef kSUPPORT_XBSC
        case kMENU_JY_RZRQ_ZDHYHK: //15444 指定合约还款融资融券合约信息
        case kMENU_JY_RZRQ_ZDMQHK:  //15445 指定卖券还款融资融券合约信息
#endif
        {
            BOOL bPush = FALSE;
            tztUIRZRQSearchViewController *pVC = (tztUIRZRQSearchViewController *)gettztHaveViewContrller([tztUIRZRQSearchViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            
        }
            break;
        case WT_RZRQQUERYLSCJ://历史成交
        case WT_RZRQQUERYLSWT://历史委托
        case WT_RZRQQUERYLS://资金流水
        case WT_RZRQQUERYJG://查询交割
        case WT_RZRQQUERYDZD://对账单
        case WT_RZRQYPC:        //信用合约已平仓
        case MENU_JY_RZRQ_QueryDealOver:
        case WT_RZRQQUERYFZLS:
        //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_QueryTransHis://历史成交
        case MENU_JY_RZRQ_QueryJG://交割单查询
        case MENU_JY_RZRQ_QueryDZD://对账单查询
        case MENU_JY_RZRQ_QueryFZQKHis:// 负债变动 负债变动流水
        case MENU_JY_RZRQ_QueryWTHis://历史委托 新功能号 //add by xyt 20131030
        case MENU_JY_RZRQ_QueryFundsDayHis: //资金流水
        case MENU_JY_RZRQ_NewStockPH: //15309  新股配号查询
        case MENU_JY_RZRQ_NewStockZQ: //15310  新股中签查询

        case MENU_JY_RZRQ_RZFZHis: //15306  已偿还融资负债 474
        case MENU_JY_RZRQ_RQFZHis: //15307  已偿还融券负债 475

        case MENU_JY_RZRQ_NoTradeTransHis://历史非交易划转查询/历史非交易过户委托

        {
            BOOL bPush = FALSE;
            TZTUIDateViewController *pVC = (TZTUIDateViewController *)gettztHaveViewContrller([TZTUIDateViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_RZRQChangePW://修改密码
        case MENU_JY_RZRQ_Password://修改密码 //新功能号 add by xyt 20131018
        {
            BOOL bPush = FALSE;
            tztUIRZRQChangePWViewController *pVC = (tztUIRZRQChangePWViewController *)gettztHaveViewContrller([tztUIRZRQChangePWViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_RZRQBANKTODEALER://银行转证券
        case MENU_JY_RZRQ_Bank2Card:
        case WT_RZRQDEALERTOBANK://证券转银行
        case MENU_JY_RZRQ_Card2Bank:
        case WT_RZRQQUERYBALANCE://查询余额
        case MENU_JY_RZRQ_BankYue:
        {
            BOOL bPush = FALSE;
            tztUIRZRQBankDealerViewController *pVC = (tztUIRZRQBankDealerViewController *)gettztHaveViewContrller([tztUIRZRQBankDealerViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            
        }
            break;
            //zxl 20130718 添加客户投票功能
        case WT_RZRQVOTING://客户投票
        case MENU_JY_RZRQ_Vote://客户投票 //新功能号 add by xyt 20131018
        {
            BOOL bPush = FALSE;
            tztUIRZRQVotingViewController *pVC = (tztUIRZRQVotingViewController *)gettztHaveViewContrller([tztUIRZRQVotingViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];

            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        default:
            return FALSE;
    }
#endif
    return TRUE;
}

+(BOOL)OnTradeSBTradeMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
#ifdef Support_SBTrade
    switch (nMsgType)
    {
        case WT_SBYXBUY://三板意向买入 限价买入
        case MENU_JY_SB_YXBuy:
        case WT_SBQRBUY://三板确认买入
        case MENU_JY_SB_QRBuy:
        case WT_SBDJBUY://三板定价买入
        case MENU_JY_SB_DJBuy:
          
        case WT_SBYXSALE://三板意向卖出
        case MENU_JY_SB_YXSell:
        case WT_SBQRSALE://三板确认卖出
        case MENU_JY_SB_QRSell:
        case WT_SBDJSALE://三板定价卖出
        case MENU_JY_SB_DJSell:
            
        case MENU_JY_SB_HBQRBuy://  互报成交确认买入
        case MENU_JY_SB_HBQRSell: //13017  互报成交确认卖出
        {
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            
            BOOL bPush = FALSE;
            tztUISBTradeBuySellViewController *pVC = (tztUISBTradeBuySellViewController *)gettztHaveViewContrller([tztUISBTradeBuySellViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];


            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            }
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.tradeUnit)
                    pVC.CurtradeUnit = [NSString stringWithFormat:@"%@", pStock.tradeUnit];
            }
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.appointmentSerial)
                    pVC.CurAppointmentSerial = [NSString stringWithFormat:@"%@", pStock.appointmentSerial];
            }

            pVC.bBuyFlag = (WT_SBYXBUY == nMsgType || nMsgType == MENU_JY_SB_YXBuy || WT_SBQRBUY == nMsgType || nMsgType == MENU_JY_SB_QRBuy || WT_SBDJBUY == nMsgType || nMsgType == MENU_JY_SB_DJBuy || nMsgType == MENU_JY_SB_HBQRBuy);
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [g_navigationController hidesBottomBarWhenPushed];
            [pVC release];
        }
        break;
        case WT_QUERYSBDRWT://三板当日委托
        case MENU_JY_SB_QueryDraw:
        case WT_SBWITHDRAW://三板查撤委托
        case MENU_JY_SB_Withdraw:
        case WT_QUERYSBDRCJ://三板成交
        case MENU_JY_SB_QueryTrans:
        {
            BOOL bPush = FALSE;
            tztUISBTradeWithDrawViewController *pVC = (tztUISBTradeWithDrawViewController *)gettztHaveViewContrller([tztUISBTradeWithDrawViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            else
                [pVC LoadLayoutView];
            [pVC release];
        }
        break;
        case WT_QUERYSBHQ://三板行情
        case MENU_JY_SB_HQ:
        {
            BOOL bPush = FALSE;
            tztUISBTradeHQSelectViewController *pVC = (tztUISBTradeHQSelectViewController *)gettztHaveViewContrller([tztUISBTradeHQSelectViewController class],tztvckind_JY,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            else
                [pVC LoadLayoutView];
            [pVC release];
        }
        break;
     default:
            return FALSE;
    }
#endif
    return TRUE;
}

+(BOOL) OnTradeETFMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
#ifdef Support_TradeETF
    if (IsTradeType(nMsgType) && (nMsgType != WT_JiaoYi && nMsgType != WT_YZZZList && nMsgType != WT_AddAccount && nMsgType != WT_LOGIN && nMsgType != WT_OUT && nMsgType != MENU_SYS_JYLogout))
    {
        if (![TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountPTType])
        {
            return TRUE;
        }
    }
    switch (nMsgType) {
        case WT_ETFCrashRG:       //网下现金认购
        case MENU_JY_ETFWX_FundBuy: //14010  现金认购
        case WT_ETF_HS_CrashRG:   //沪市现金认购
        case MENU_JY_ETFKS_HSFundBuy: //14071  沪市现金认购
        {
            BOOL bPush = FALSE;
            tztUIETFCrashRGVC *pVC = (tztUIETFCrashRGVC *)gettztHaveViewContrller([tztUIETFCrashRGVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_ETFStockRG:     //网下股份认购
        case MENU_JY_ETFWX_StockBuy: //14011  股票认购
        case WT_ETF_HS_StockRG: //沪市股票认购
        case MENU_JY_ETFKS_HSStockBuy: //14072  沪市股票认购
        case WT_ETF_SS_GFRG://深市股份认购
         case MENU_JY_ETFKS_SSStockBuy: //14073  深市股份认购
        {
            BOOL bPush = FALSE;
            tztUIETFStockRGVC *pVC = (tztUIETFStockRGVC *)gettztHaveViewContrller([tztUIETFStockRGVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_ETFCrashRGQuery:    //网下现金认购查询
        case MENU_JY_ETFWX_QueryFund: //14041  现金认购查询
        case MENU_JY_ETFWX_QueryStock: //14042  股票认购查询
        case WT_ETFStockRGQuery:    //网下股票认购查询
        case WT_ETF_HS_CrashQUery:  //沪市现金查询
        case MENU_JY_ETFKS_HSQueryFund: //14081  沪市现金查询
        case WT_ETF_HS_StockQuery:  //沪市股票查询
        case MENU_JY_ETFKS_HSQueryStock: //14082  沪市股票查询
        case WT_ETF_SS_RGQuery:     //深市认购查询
        case MENU_JY_ETFKS_SSRGQuery: //14083  深市认购查询
        {
            BOOL bPush = FALSE;
            tztUIETFSearchVC *pVC = (tztUIETFSearchVC *)gettztHaveViewContrller([tztUIETFSearchVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];

            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case WT_ETFXJRGCD:  //网下现金认购撤单
        case MENU_JY_ETFWX_FundWithdraw://14012  现金认购撤单 //add by xyt 20131107
        case WT_ETFGPRGCD:  //网下股票认购撤单
        case MENU_JY_ETFWX_StockWithdraw: //14013  股票认购撤单
        case WT_ETF_HS_XJCD:    //沪市现金撤单
        case WT_ETF_HS_GPCD:    //沪市股票撤单
        case MENU_JY_ETFKS_HSStockWithdraw: //14075  沪市股票撤单
        case WT_ETF_SS_RGCD:    //深市认购撤单
        case MENU_JY_ETFKS_SSRGWithdraw: // 14076  深市认购撤单
        {
            BOOL bPush = FALSE;
            tztUIETFWithDrawVC *pVC = (tztUIETFWithDrawVC *)gettztHaveViewContrller([tztUIETFWithDrawVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        default:
            return FALSE;
    }
#endif
    return TRUE;
}

#pragma mark 港股
+(BOOL) OnTradeHKMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
#ifdef Support_HKTrade
    switch (nMsgType)
    {
        case MENU_JY_HK_Buy:
        case MENU_JY_HK_Sell:
        {
            tztStockInfo *pStock = nil;
            pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            BOOL bExist = FALSE;
            UIViewController *pTmpVC = [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIHKBuySellViewController class]];
            if (pTmpVC && [pTmpVC isKindOfClass:[tztUIHKBuySellViewController class]])
            {
                bExist = TRUE;
                [g_navigationController popViewControllerAnimated:NO];
            }
            
            bPush = YES;
            tztUIHKBuySellViewController *pVC = [[tztUIHKBuySellViewController alloc] init] ;
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode && (pStock.stockType == 0 || MakeHKMarketStock(pStock.stockType)))
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            }
            pVC.nMsgType = nMsgType;
            pVC.bBuyFlag = (nMsgType == MENU_JY_HK_Buy);
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                if (!pBottomVC)
                    pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                //zxl 20131011 修改了显示界面的大小
                rcFrom.size = CGSizeMake(490, 640);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else
            {
                if(bPush)
                {
                    [pVC SetHidesBottomBarWhenPushed:YES];
                    [g_navigationController pushViewController:pVC animated:(bExist ? NO : UseAnimated)];
                }
                else
                {
                    [pVC OnRequestData];
                }
            }
            [pVC release];
        }
            break;
            //
        case MENU_JY_HK_WithDraw:
        {
            tztWebViewController *pVC = [[tztWebViewController alloc] init];
            pVC.nMsgType = nMsgType;
            pVC.nHasToolbar = 0;
            [pVC setWebURL:[tztlocalHTTPServer getLocalHttpUrl:@"/ggt/cd.html?id=1"]];
            [pVC SetHidesBottomBarWhenPushed:YES];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
            
        default:
            break;
    }
    return TRUE;
#else
    return FALSE;
#endif
}

+(BOOL) OnTradeTHBMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
#ifdef Support_THB
    switch (nMsgType)
    {
        case WT_THB_List:
        {
//            g_nCurUseAccountType = TZTAccountPTType;
            [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIFuctionListViewController class]];
            tztUIFuctionListViewController * pVC = NewObject(tztUIFuctionListViewController);
            [pVC setProfileName:@"tztUITradeTHBListSetting"];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            [pVC SetTitle:@"天汇宝"];
        }
            break;
        case WT_THB_NEWKHG:
        case WT_THB_YWSearch:
        case WT_THB_BZXZ:
        case WT_THB_DLWT:
        case WT_THB_HYSearch:
        case WT_THB_TQGH:
        case WT_THB_TQGHYY:
        case WT_THB_ZYQSearch:
        {
            tztUITHBSearchViewController *pVC = [[tztUITHBSearchViewController alloc] init];
            [pVC setVcShowKind:tztvckind_JY];
            pVC.nMsgType = nMsgType;
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        default:
            return FALSE;
    }
    return TRUE;
#else
    return FALSE;
#endif
}

+(BOOL) OnTradeOptionMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
#ifdef Support_OptionTrade
    
    if (IsOptionMsgType(nMsgType) && (nMsgType != MENU_JY_GGQQ_List && nMsgType != MENU_JY_GGQQ_WithDrawList && nMsgType != MENU_JY_GGQQ_SearchList && nMsgType != MENU_JY_GGQQ_BankList && nMsgType != MENU_JY_GGQQ_Out))
    {
        if (![TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountGGQQType])
        {
            return TRUE;
        }
    }
    //先要判断登录状态
    switch (nMsgType)
    {
        case MENU_JY_GGQQ_BankList:
        case MENU_JY_GGQQ_SearchList:
        case MENU_JY_GGQQ_WithDrawList:
        {
            NSString* strTitle = GetTitleByID(nMsgType);
            tztUIFuctionListViewController *pVC = [[tztUIFuctionListViewController alloc] init];
            if (ISNSStringValid(strTitle))
                [pVC SetTitle:strTitle];
            pVC.nMsgType = nMsgType;
            
            switch (nMsgType)
            {
                case MENU_JY_GGQQ_BankList:
                {
                    [pVC setProfileName:@"tztUIOptionBankList"];
                }
                    break;
                case MENU_JY_GGQQ_SearchList:
                {
                    [pVC setProfileName:@"tztUIOptionSearchList"];
                }
                    break;
                case MENU_JY_GGQQ_WithDrawList:
                {
                    [pVC setProfileName:@"tztUIOptionWithDrawList"];
                }
                    break;
                default:
                    break;
            }
            
            [pVC SetHidesBottomBarWhenPushed:YES];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case MENU_JY_GGQQ_BuyOpen:          //买入开仓
        case MENU_JY_GGQQ_BuyPosition:      //买入平仓
        case MENU_JY_GGQQ_SellOpen:         //卖出开仓
        case MENU_JY_GGQQ_SellPosition:     //卖出平仓
        case MENU_JY_GGQQ_CoveredOpen:      //备兑开仓
        case MENU_JY_GGQQ_CoveredPosition:  //备兑平仓
        {
            tztOptionBuySellViewController *pVC = [[tztOptionBuySellViewController alloc] init];
            pVC.nMsgType = nMsgType;
            [pVC SetHidesBottomBarWhenPushed:YES];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case MENU_JY_GGQQ_CoveredLock://备兑券锁定
        case MENU_JY_GGQQ_CoveredUnLock://备兑券解锁
        {
            tztCoveredLockViewController *pVC = [[tztCoveredLockViewController alloc] init];
            pVC.nMsgType = nMsgType;
            [pVC SetHidesBottomBarWhenPushed:YES];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case MENU_JY_GGQQ_XQ://行权
        case MENU_JY_GGQQ_XQAuto://自动行权
        {
        }
            break;
        case MENU_JY_GGQQ_QueryCC://持仓合约
        case MENU_JY_GGQQ_QueryWithDraw://可撤委托
        case MENU_JY_GGQQ_QueryDRCJ://当日成交
        case MENU_JY_GGQQ_QueryDRWT://当日委托
        case MENU_JY_GGQQ_QueryCovered://备兑股份
        case MENU_JY_GGQQ_QueryCJHis://历史成交
        case MENU_JY_GGQQ_QueryJG://交割单
        case MENU_JY_GGQQ_QueryDZD://对账单
        {
            tztOptionSearchViewController *pVC = [[tztOptionSearchViewController alloc] init];
            pVC.nMsgType = nMsgType;
            [pVC SetHidesBottomBarWhenPushed:YES];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
            break;
        case MENU_JY_GGQQ_BankToOption://银转期
        case MENU_JY_GGQQ_OptionToBank://期转银
        case MENU_JY_GGQQ_BankYE://银行余额
        case MENU_JY_GGQQ_BankFundDetail://资金明细
        case MENU_JY_GGQQ_BankHis://转账查询
        {
            
        }
            break;
        default:
            break;
    }
    
    return TRUE;
#endif
    return FALSE;
}

+(void) StarProcess
{
}

+(void) StopProcess
{
}


+(void) SetLock
{
}

+(void) OnJYLockTimer
{
}

+(void)IPadPushViewController:(UIViewController*)pBottomVC pop:(UIViewController*)pPop
{
    if (![TZTAppObj getShareInstance].rootTabBarController.revealSideViewController.wasClosed
        && ![TZTAppObj getShareInstance].rootTabBarController.revealSideViewController.IgnoredTouch)
        return;
    if (pPop == NULL)
        return;
    
    pPop.modalPresentationStyle = UIModalPresentationFormSheet;
    pPop.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    BOOL bFlag = TRUE;
    if (pBottomVC != NULL)
    {
#if 1
//        /*支持多个弹出*/
        UIViewController *pVC = nil;
        UIViewController *pBtmVC = pBottomVC;
        if ([pBottomVC isKindOfClass:[UINavigationController class]])
        {
            pVC = ((UINavigationController*)pBottomVC).topViewController;
            if (IS_TZTIOS(5))
            {
                while (pVC.presentedViewController)
                {
                    pBtmVC = pVC.presentedViewController;
                    pVC = pBtmVC;
                    bFlag = FALSE;
                }
            }
            else
            {
                while (pVC.modalViewController)
                {
                    pBtmVC = pVC.modalViewController;
                    pVC = pBtmVC;
                    bFlag = FALSE;
                }
            }
            
            if (pBtmVC == nil)
                pBtmVC = pBottomVC;
            
            if ([pPop isKindOfClass:[TZTUIBaseViewController class]])
            {
                ((TZTUIBaseViewController*)pPop).pParentVC = pVC;
            }
        }
        /*支持多个弹出end*/
        if (bFlag)
        {
//            [pBtmVC presentViewController:pPop animated:UseAnimated completion:nil];
            [pBtmVC presentModalViewController:pPop animated:UseAnimated];
        }
#else
        CATransition *animation = [CATransition animation];
        [animation setDuration:1];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [pPop.view.layer addAnimation:animation forKey:nil];
        [pBottomVC presentModalViewController:pPop animated:NO];
#endif
    }
}

+(void) IPadPopViewController:(UIViewController*)pBottomVC bUseAnima_:(BOOL)animation
{
    [TZTUIBaseVCMsg IPadPopViewControllerEx:pBottomVC bUseAnima_:animation completion:nil];
}

+(void) IPadPopViewControllerEx:(UIViewController*)pBottomVC bUseAnima_:(BOOL)animation completion:(void(^)(void))completion
{
    if (pBottomVC == NULL)
    {
        pBottomVC = g_navigationController;
    }
    
    /*支持多个弹出*/
    UIViewController *pVC = nil;
    UIViewController *pBtmVC = pBottomVC;
    if ([pBottomVC isKindOfClass:[UINavigationController class]])
    {
        pVC = ((UINavigationController*)pBottomVC).topViewController;
        if (IS_TZTIOS(5))
        {
            while (pVC.presentedViewController)
            {
                pBtmVC = pVC.presentedViewController;
                pVC = pBtmVC;
            }
        }
        else
        {
            while (pVC.modalViewController)
            {
                pBtmVC = pVC.modalViewController;
                pVC = pBtmVC;
            }
        }
        
        if (pBtmVC == nil)
            pBtmVC = pBottomVC;
    }
    /*end*/
    
    if ([pBottomVC isKindOfClass:[UINavigationController class]])
    {
        UIViewController *vc = ((UINavigationController*)pBottomVC).topViewController;
        if (vc == NULL)
        {
            vc = [TZTAppObj getTopViewController];
        }
        if ([vc isKindOfClass:[TZTUIBaseViewController class]])
        {
            [((TZTUIBaseViewController*)vc) PopViewControllerDismiss];
        }
    }
    else if ([pBottomVC isMemberOfClass:[TZTUIBaseViewController class]])
    {
        [((TZTUIBaseViewController*)pBottomVC) PopViewControllerDismiss];
    }
    
    if (pBottomVC == NULL)
        return;
    
    UIViewController* pTop = g_navigationController.topViewController;
    if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
    {
        g_navigationController.navigationBar.hidden = NO;
        [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
    }
    
	//1 不使用效果退出，避免同时加载两个Model出问题
#ifdef __IPHONE_8_0
    [pBtmVC dismissViewControllerAnimated:animation completion:completion];
#else
    [pBtmVC dismissViewControllerAnimated:animation completion:completion];
#endif
}

+(void) IPadPopViewController:(UIViewController*)pBottomVC
{
    [TZTUIBaseVCMsg IPadPopViewController:pBottomVC completion:nil];
}


+(void) IPadPopViewController:(UIViewController*)pBottomVC completion:(void (^)(void))completion
{
    if (pBottomVC == NULL)
    {
        pBottomVC = g_navigationController;
    }
    
    BOOL bUserAnimated = UseAnimated;
#ifdef kSUPPORT_XBSC  //XINALN
    bUserAnimated = YES;
#endif
    UIViewController *pBtmVC = pBottomVC;
    if ([pBottomVC isKindOfClass:[UINavigationController class]])
    {
        UIViewController *pVC = ((UINavigationController*)pBottomVC).topViewController;
        if (IS_TZTIOS(5))
        {
            while (pVC.presentedViewController)
            {
                pBtmVC = pVC.presentedViewController;
                pVC = pBtmVC;
            }
        }
        else
        {
            while (pVC.modalViewController)
            {
                pBtmVC = pVC.modalViewController;
                pVC = pBtmVC;
            }
        }
        
        if (pBtmVC == nil)
            pBtmVC = pBottomVC;
//        if (pVC.parentViewController == NULL)
//        {
//            bUserAnimated = FALSE;
//        }
    }
    
    [TZTUIBaseVCMsg IPadPopViewControllerEx:pBottomVC bUseAnima_:bUserAnimated completion:completion];
}


+(int)tztPushViewContrller:(UIViewController*)pVC animated:(BOOL)animated fullScreen:(int)fullScreen
{
    if (fullScreen > 0)
    {
        if ([[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose] > 0)
        {
            [pVC SetHidesBottomBarWhenPushed:YES];
            [[TZTAppObj getShareInstance].rootTabBarController.leftVC tztPushViewController:pVC animated:animated];
        }
        else
        {
            [pVC SetHidesBottomBarWhenPushed:YES];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
        }
    }
    else
    {
        if ([[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose] > 0)
        {
            [pVC SetHidesBottomBarWhenPushed:YES];//默认全屏
            [[TZTAppObj getShareInstance].rootTabBarController.leftVC tztPushViewController:pVC animated:animated];
        }
        else
        {
            [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController popViewControllerAnimated:!animated];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
        }
    }
    
    return 1;
}

@end

@implementation NSDictionary(TZTPrivate)

+(NSDictionary*)GetDictFromParam:(NSString*)nsData
{
    NSString* strValue = (NSString*)nsData;
    //    NSString* strPath = strValue;
    NSString* strParam = strValue;
    if(strValue && [strValue length] > 0)
    {
        NSRange pathRang = [strValue rangeOfString:@"?"];
        if(pathRang.location == NSNotFound) //不带参数
        {
            //            strParam = @"";
        }
        else
        {
            //            strPath = [strValue substringToIndex:pathRang.location-1];
            strParam = [strValue substringFromIndex:pathRang.location+pathRang.length];
        }
    }
    
    NSMutableDictionary* pDict = nil;
    if(strParam && [strParam length] > 0)
    {
        pDict = (NSMutableDictionary*)[strParam tztNSMutableDictionarySeparatedByString:@"&&"];
        
        if (pDict == NULL || pDict.count < 1)
            pDict = (NSMutableDictionary*)[strParam tztNSMutableDictionarySeparatedByString:@"&"];
    }
    
    return pDict;
}
@end


