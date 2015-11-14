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

#import "tztUIBaseVCOtherMsg.h"
#import "tztUISysLoginViewController.h"
#import "tztUITradeLogindViewController.h"
#import "tztWebViewController.h"
#import "tztTZKDSettingViewController.h"
#import "tztMenuViewController_iphone.h"
//#import "tztUIChaoGenKlineViewController.h"
#import "tztUIReportViewController_iphone.h"
#import "tztNineCellViewController.h"
#import "tztUIFuctionListViewController.h"
#import "tztUIServiceCenterViewController.h"
#import "tztMainViewController.h"
#import "tztUIQuoteViewController.h"
#import "TZTIndexViewController.h"
#import "tztUIQuoteViewControllerStyle2.h"
#import "tztFundFlowsViewController.h"

@interface tztUIBaseVCOtherMsg(tztPrivate)
+(int)CheckSysAndTradeLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
@end

static tztUIBaseVCOtherMsg *tztUIBaseVCOtherMsg_instance = nil;

@implementation tztUIBaseVCOtherMsg
+(tztUIBaseVCOtherMsg*)getShareInstance
{
    if (tztUIBaseVCOtherMsg_instance == nil)
    {
        tztUIBaseVCOtherMsg_instance = [[tztUIBaseVCOtherMsg alloc] init];
    }
    return tztUIBaseVCOtherMsg_instance;
}

-(void)freeShareInstance
{
    DelObject(tztUIBaseVCOtherMsg_instance);
}

+(int) OnMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    
    int nDeal = 0;
    TZTUIMessage *pMessage = NewObjectAutoD(TZTUIMessage);
    pMessage.m_nMsgType = nMsgType;
    pMessage.m_wParam = wParam;
    pMessage.m_lParam = lParam;
    nDeal = (int)[[tztUIBaseVCOtherMsg getShareInstance] tztperformSelector:@"tztDealNewHQMessageWithParams:" withObject:pMessage];
    if (nDeal > 0)
        return 1;
    
    
    switch (nMsgType)
    {
        case 0x123456: // 排行榜
        {
            NSMutableDictionary *dic = (NSMutableDictionary *)pMessage.m_lParam;
            NSString* strMenuID = @"";
            NSString* strAction = @"";
            NSString* strAccount = @"";
            NSString* strDirection = @"";
            NSString* strMarket = @"";
            NSString* strTitle = @"";
            if (dic.count>0)
            {
                NSString* nsHQMenuID = [dic objectForKey:@"HQMenuID"];
                if (ISNSStringValid(nsHQMenuID))
                    strMenuID = [NSString stringWithFormat:@"%@", nsHQMenuID];
                NSString* nsAction  = [dic objectForKey:@"Action"];
                if (ISNSStringValid(nsAction))
                    strAction = [NSString stringWithFormat:@"%@", nsAction];
                NSString* nsAccount = [dic objectForKey:@"AccountIndex"];
                if (ISNSStringValid(nsAccount))
                    strAccount = [NSString stringWithFormat:@"%@", nsAccount];
                NSString* nsDirection = [dic objectForKey:@"Direction"];
                if (ISNSStringValid(nsDirection))
                    strDirection = [NSString stringWithFormat:@"%@", nsDirection];
                NSString* nsMarket = [dic objectForKey:@"Market"];
                if (ISNSStringValid(nsMarket))
                    strMarket = [NSString stringWithFormat:@"%@", nsMarket];
                NSString* nsTitle = [dic objectForKey:@"Name"];
                if (ISNSStringValid(nsTitle))
                    strTitle = [NSString stringWithFormat:@"%@", nsTitle];
                
            }
            
            BOOL bShowBlockList = ([strAction caseInsensitiveCompare:@"20196"]==NSOrderedSame);
            BOOL bBlockList = ([strAction caseInsensitiveCompare:@"20199"]==NSOrderedSame);
            BOOL bFundFlowList = (([strAction caseInsensitiveCompare:@"20620"] == NSOrderedSame) && ([strMarket intValue]==13));
            BOOL bPush = FALSE;
            
            if (bBlockList)
            {
                [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIReportViewController_iphone class]];
                tztUIReportViewController_iphone *pVC = (tztUIReportViewController_iphone *)gettztHaveViewContrller([tztUIReportViewController_iphone class], tztvckind_Pop, [NSString stringWithFormat:@"%d",tztReportShowBlockList], &bPush,FALSE);
                [pVC retain];
                //                pVC.nMsgType = nMsgType;
                tztStockInfo *pStock = (tztStockInfo*)pMessage.m_wParam;
                pVC.nReportType = tztReportBlockIndex;
                pVC.pStockInfo = pStock;
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20199"];
                pVC.nsReqParam = [NSString stringWithFormat:@"%@", pStock.stockCode];
                NSString* strTitle = [NSString stringWithFormat:@"%@\\r\\n%@", pStock.stockName, pStock.stockCode];
                [pVC SetHidesBottomBarWhenPushed:YES];
                [pVC setTitle:strTitle];
                if (bPush)
                {
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                }
            }
            else if (bFundFlowList)//打开资金流向界面
            {
                [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztFundFlowsViewController class]];
                tztFundFlowsViewController *pVC = (tztFundFlowsViewController *)gettztHaveViewContrller([tztFundFlowsViewController class], tztvckind_Pop, [NSString stringWithFormat:@"%d",tztReportShowBlockList], &bPush,FALSE);
                [pVC retain];
                pVC.nsMenuID = strMarket;
                pVC.nsFirstID = strMenuID;
                [pVC setTitle:strTitle];
                if (bPush)
                {
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                }
            }
            else
            {
                NSString* strMsgType = [NSString stringWithFormat:@"%d", (bShowBlockList ? tztReportShowBlockList : tztReportShowStockList)];
                tztUIReportViewController_iphone* pVC = (tztUIReportViewController_iphone *)gettztHaveViewContrller([tztUIReportViewController_iphone class], tztvckind_Pop, strMsgType,&bPush,FALSE);
                [pVC retain];
                pVC.nMsgType = pMessage.m_nMsgType;
                pVC.nMarketPosition = 1;
                
                tztStockInfo *pStock = (tztStockInfo*)pMessage.m_wParam;
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", strAction];
                if (pStock == NULL || pStock.stockCode.length <= 0)
                {
                    NSString *str = [dic objectForKey:@"StockCode"];
                    if (str.length > 0)
                        pVC.nsReqParam = [NSString stringWithFormat:@"%@", str];
                }
                else
                {
                    pVC.nsReqParam = [NSString stringWithFormat:@"%@", pStock.stockCode];
                }
                //                pVC.nsReqParam = [NSString stringWithFormat:@"%@", pStock.stockCode];
                [pVC setTitle:strTitle];
                [pVC RequestDefaultMenuData:strMarket andShowID:[NSString stringWithFormat:@"%@",strMenuID]];
                //                [pVC RequestDefaultMenuData:];
                [pVC SetHidesBottomBarWhenPushed:YES];
                pVC.nsOrdered = [NSString stringWithFormat:@"%d", [strAccount intValue] * 2];
                pVC.nsDirection = strDirection;
                if(bPush)
                {
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                }
                [pVC release];
            }
            return 1;
        }
            break;
        case HQ_MENU_MarketMenu:
        {
#ifdef tzt_NewVersion
            tztUINavigationController* pNav = [tztMainViewController getNavController:tztvckind_HQ];
            if (pNav) //资讯中心 清空资讯列表
            {
                [pNav popToRootViewControllerAnimated:NO];
            }
            [tztMainViewController didSelectNavController:tztvckind_HQ options_:NULL];
            [g_ayPushedViewController removeObject:pNav.topViewController];
            [g_ayPushedViewController addObject:pNav.topViewController];
            return 1;
#endif
        }
            break;
        case Sys_Menu_ServiceCenter://服务中心 切换到服务中心首页
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
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Main, [NSString stringWithFormat:@"%d", nMsgType], &bPush,TRUE);
            [pVC retain];
            if(IS_TZTIPAD)//pad版本没有底部的工具栏
                pVC.nHasToolbar = NO;
            
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"服务中心"];
            
            NSString* strFile = @"service/index.htm";
            NSString* strUrl = [NSString stringWithFormat:@"http://127.0.0.1:%d/%@",[[tztlocalHTTPServer getShareInstance] port],strFile];
            pVC.nHasToolbar = 0;
            [pVC setLocalWebURL:strUrl];
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
#endif
            return 1;
        }
            break;
        case HQ_MENU_Personal://个人中心
        {
            if (IsUserLogin(nMsgType) && [TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Main, [NSString stringWithFormat:@"%ld", (long)nMsgType], &bPush,TRUE);
            [pVC retain];
            [pVC setTitle:@"个人中心"];
            pVC.nHasToolbar = 1;
            pVC.nWebType = tztwebChaoGen;
            NSString* strFile = @"chaogenajax/basemsg.htm";
            NSString* strUrl = [NSString stringWithFormat:@"http://127.0.0.1:%d/%@",[[tztlocalHTTPServer getShareInstance] port],strFile];
            [pVC setWebURL:strUrl];
            if (bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
            break;
        case HQ_MENU_ChooseStock://模型选股
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)@"405" lParam:0];
            return 1;
        }
            break;
        case WT_JiaoYi:
        {
            if (IsUserLogin(nMsgType) && [TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            
            if (IsTradeType(nMsgType) && ![TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam])
            {
                return 1;
            }
            
#ifdef tzt_TradeList
            tztUIFuctionListViewController * pVC = NewObject(tztUIFuctionListViewController);
            [pVC SetTitle:@"委托交易"];
            [pVC setProfileName:@"tztUITradeListSetting"];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
#else
            NSArray *pAy = [g_pSystermConfig.pDict objectForKey:@"TZTTradeGrid"];
            if (pAy == NULL || [pAy count] <= 0)
                return 1;
            
            [((tztMobileAppAppDelegate*)[UIApplication sharedApplication].delegate) didSelectItemByPageType:tztTradePage options_:NULL];
            
            tztNineCellViewController *pVC = [[tztNineCellViewController alloc] init];
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
            
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
#endif
        }
            break;
        case HQ_MENU_Report://排名  //隐藏菜单,如 我的自选,大盘指数等
        {
#ifdef tzt_NewVersion
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_MarketMenu wParam:0 lParam:0];
//            [((tztMobileAppAppDelegate*)[UIApplication sharedApplication].delegate) didSelectItemByPageType:tztMarketPage options_:NULL];
//            tztUIReportViewController_iphone *pVC = (tztUIReportViewController_iphone *)[TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIReportViewController_iphone class]];
//            
//            if (pVC == NULL)
//            {
//                pVC = [[tztUIReportViewController_iphone alloc] init];
//                [pVC RequestDefaultMenuData:@"3"];
//                [g_navigationController pushViewController:pVC animated:UseAnimated];
//                [pVC setTitle:@"沪深股市"];
//                [pVC release];
//            }
//            else
//            {
//                [pVC RequestDefaultMenuData:@"3"];
//                [pVC setTitle:@"沪深股市"];
//                [pVC RequestData:0 nsParam_:NULL];
//            }
#else
//            [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztMenuViewController_iphone class]];
//            //打开排名的列表
//            tztMenuViewController_iphone *pVC = [[tztMenuViewController_iphone alloc] init];
//            [pVC setTitle:@"综合排名"];
//#ifdef  Support_ShowMenuID
//            pVC.nsHiddenMenuID = @"1|2|12|4|";
//#endif
//            [g_navigationController pushViewController:pVC animated:UseAnimated];
//            [pVC release];
#endif
            return 1;
        }
            break;

        case Sys_Menu_TZKDSetting:
        {
            if (IsUserLogin(nMsgType) && [TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            tztTZKDSettingViewController *pVC = [[tztTZKDSettingViewController alloc] init];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
            break;
        case HQ_MENU_ChaoGen://炒跟
        {
            if (IsUserLogin(nMsgType) && [TZTUIBaseVCMsg SystermLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Pop, [NSString stringWithFormat:@"%ld", (long)nMsgType], &bPush,TRUE);
            [pVC retain];
            [pVC setTitle:@"我的炒跟"];
            pVC.nHasToolbar = 1;
            pVC.nWebType = tztwebChaoGen;
            
            NSString* strFile = @"chaogenajax/index.htm";
            NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];// [NSString stringWithFormat:@"http://127.0.0.1:%d/%@",[[tztlocalHTTPServer getShareInstance] port],strFile];
            [pVC setWebURL:strUrl];
            if (bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
            break;
        case HQ_MENU_ChaoGenEx:
        {
            UIViewController *pTmpVC = [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztWebViewController class]];
            if (pTmpVC && [pTmpVC isKindOfClass:[tztWebViewController class]])
            {
                ((tztWebViewController*)pTmpVC).nHasToolbar = 1;
                ((tztWebViewController*)pTmpVC).nWebType = tztwebChaoGen;
                [((tztWebViewController*)pTmpVC) CleanWebURL];
                NSString* strFile = (NSString*)wParam;
                NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];// [NSString stringWithFormat:@"http://127.0.0.1:%d%@",[[tztlocalHTTPServer getShareInstance] port],strFile];
                [(tztWebViewController*)pTmpVC setWebURL:strUrl];
            }
            else
            {
                tztWebViewController *pVC = [[tztWebViewController alloc] init];
                pVC.nHasToolbar = 1;
                pVC.nWebType = tztwebChaoGen;
                [g_navigationController pushViewController:pVC animated:UseAnimated];
                NSString* strFile = (NSString*)wParam;
                NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];// [NSString stringWithFormat:@"http://127.0.0.1:%d%@",[[tztlocalHTTPServer getShareInstance] port],strFile];
                [pVC setWebURL:strUrl];
                [pVC release];
            }
            return 1;
        }
            break;
//        case HQ_MENU_ChaoGenSet:
//        {
//            tztWebViewController *pVC = [[tztWebViewController alloc] init];
//            [pVC setTitle:@"炒跟逆袭"];
//            pVC.nHasToolbar = 1;
//            pVC.nWebType = tztWebChaoGenSet;
//            [g_navigationController pushViewController:pVC animated:UseAnimated];
//            NSString* strFile = @"chaogenajax/setting.htm";
//            NSString* strUrl = [NSString stringWithFormat:@"http://127.0.0.1:%d/%@",[[tztlocalHTTPServer getShareInstance] port],strFile];
//            [pVC setWebURL:strUrl];
//            
//        }
//            break;
        case HQ_MENU_ChaoGenKLine:
        {
            
//            NSString * strValue = (NSString *)wParam;
//            NSArray * ayValue = [strValue componentsSeparatedByString:@"&"];
//            if (ayValue && [ayValue count] == 3)
//            {
//                NSString *strBZPhone = [ayValue objectAtIndex:0];
//                NSString *strStockCode = [ayValue objectAtIndex:1];
//                NSString *strDate = [ayValue objectAtIndex:2];
//                
//                strBZPhone = [strBZPhone substringFromIndex:[@"mobilecode_bz=" length]];
//                strStockCode = [strStockCode substringFromIndex:[@"stockcode=" length]];
//                strDate = [strDate substringFromIndex:[@"date=" length]];
//                strDate = [strDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
////                strDate = [strDate substringToIndex:[strDate rangeOfString:@"%20"].location];
//                tztUIChaoGenKlineViewController *pVC = [[tztUIChaoGenKlineViewController alloc] init];
//                pVC.nsBZPhone = [NSString stringWithFormat:@"%@",strBZPhone];
//                pVC.nsStockCode = [NSString stringWithFormat:@"%@",strStockCode];
//                pVC.nsDate = [NSString stringWithFormat:@"%@",strDate];
//                
//                [g_navigationController pushViewController:pVC animated:UseAnimated];
//                [pVC release];
//                return 1;
//            }
        }
            break;
        default:
            break;
    }
    return 0;
}

+(int)CheckSysAndTradeLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    [tztUserData getShareClass];
    
    if (g_pSystermConfig && g_pSystermConfig.bNeedRegist)
    {
        NSString* strLogMobile = [tztKeyChain load:tztLogMobile];
        if (strLogMobile == nil || [strLogMobile length] < 11 || ![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
        {
            //系统登录
            tztUISysLoginViewController* pVC = [[tztUISysLoginViewController alloc] init];
            [pVC setMsgID:nMsgType MsgInfo:(void*)wParam LPARAM:lParam];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                CGRect rcFrom = CGRectZero;
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
            [pVC release];
            return 0;
        }
    }
    
    if (![TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])
    {
        [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUITradeLogindViewController class]];
        //需要登录
        tztUITradeLogindViewController *pVC = [[tztUITradeLogindViewController alloc] init];
        [pVC setMsgID:nMsgType MsgInfo:(void*)wParam LPARAM:lParam];
        if (IS_TZTIPAD)
        {
            TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
            CGRect rcFrom = CGRectZero;
            rcFrom.origin = pBottomVC.view.center;
            rcFrom.size = CGSizeMake(500, 500);
            [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
        }
        else
            [g_navigationController pushViewController:pVC animated:UseAnimated];
        [pVC release];
        return 0;
    }
    
    return 1;
}

+ (UIViewController*)GetTabBarViewController:(NSInteger)nType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0 || lParam != 1)
        return  NULL;
    
    TZTPageInfoItem *pItem = (TZTPageInfoItem*)wParam;
    if (![pItem isKindOfClass:[TZTPageInfoItem class]])
        return NULL;
    UIViewController *pViewController = NULL;
#if 1
    switch (pItem.nPageID)
    {
        case tztMarketPage://行情
        {
//            tztUIQuoteViewControllerStyle2 *vc = [[[tztUIQuoteViewControllerStyle2 alloc] init] autorelease];
//            TZTIndexViewController *vc = [[[TZTIndexViewController alloc] init] autorelease];
            tztUIQuoteViewController *vc = [[[tztUIQuoteViewController alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
            
            
//            tztUIQuoteViewController *vc = [[[tztUIQuoteViewController alloc] init] autorelease];
//            
//            [vc setVcShowKind:pItem.nPageID];
//            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
////            vc.nMsgType = TZT_MENU_JY_LIST;
//            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
//                [vc setTitle:pItem.pRev1];
//            else
//                [vc setTitle:@"行情"];
//            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
//            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
//            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
//            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztTradePage:  //交易
        {
            tztNineCellViewController *vc = [[[tztNineCellViewController alloc] init] autorelease];
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
            
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = TZT_MENU_JY_LIST;
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"委托交易"];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        default:
            break;
    }
#endif
    return pViewController;
}

+ (BOOL)addViewController:(TZTPageInfoItem *)pItem withNav:(UINavigationController *)viewController
{
    BOOL bDeal = FALSE;
#if 1
    switch (pItem.nPageID)
    {
        case tztTradePage:  //交易
        {
            tztNineCellViewController *vc = [[[tztNineCellViewController alloc] init] autorelease];
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
            
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = TZT_MENU_JY_LIST;
            [viewController pushViewController:vc animated:NO];
            bDeal = TRUE;
        }
            break;
        default:
            break;
    }
#endif
    return bDeal;
}
@end

@implementation tztHTTPData(tztOther)
-(id)tztPopViewControllerAnimated:(UINavigationController*)nav
{
    PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
    if ( direction > 0)
    {
        id returnValue = nil;
        if (direction == PPRevealSideDirectionLeft)
        {
            returnValue = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
        }
        else if(direction == PPRevealSideDirectionRight)
        {
            returnValue = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
        }
        if (returnValue)
        {
            if (returnValue == nav)
                return nil;
            return returnValue;
        }
    }
    return nil;
}

-(id)tztPushViewController:(UIViewController*)viewController nav:(UINavigationController*)nav
{
    
    if (([viewController getVcShowKind] == tztvckind_JY
         || [viewController getVcShowKind] == tztvckind_Pop
         || [viewController getVcShowKind] ==tztvckind_ZX
         || [viewController getVcShowKind] == tztvckind_HQ)
        && ![viewController isKindOfClass:[[NSBundle mainBundle] classNamed:@"tztUIHomePageViewController"]]
        && ![viewController isKindOfClass:[[NSBundle mainBundle] classNamed:@"tztUITradeViewController"]]
        && [[viewController getVcShowType] intValue] != tztVcShowTypeRoot )//交易不显示底部tabbar
    {
        [viewController SetHidesBottomBarWhenPushed:YES];
    }
    PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
    if (direction > 0)
    {
        id returnValue = nil;
        if (direction == PPRevealSideDirectionLeft)
        {
            returnValue = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
        }
        else if (direction == PPRevealSideDirectionRight)
        {
            returnValue = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
        }
        if (returnValue)
        {
            [viewController SetHidesBottomBarWhenPushed:YES];
            [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionLeft animated:YES];
            [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionRight animated:YES];
            
            if (returnValue == nav)
                return nil;
            if (direction == PPRevealSideDirectionLeft)
                [[TZTAppObj getShareInstance].rootTabBarController.leftVC tztPushViewController:viewController animated:UseAnimated];
            else if (direction == PPRevealSideDirectionRight)
                [[TZTAppObj getShareInstance].rootTabBarController.rightVC tztPushViewController:viewController animated:UseAnimated];
            
            return returnValue;
        }
    }
    return nil;
}

-(void)tztInitWithRootViewController:(tztUINavigationController*)nav
{
#ifdef __IPHONE_7_0
    if (nav)
    {
        nav.interactivePopGestureRecognizer.enabled = NO;
    }
#endif
}

@end

@implementation TZTUIMessageBox(tztPrivate)

-(NSMutableDictionary*)tztMsgBoxSetProperties:(TZTUIMessageBox*)msgBox
{
    NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
    [pDict setTztObject:@"center" forKey:tztMsgBoxTitleAlignment];
    msgBox.m_TitleFont = tztUIBaseViewTextFont(20);
    if (g_ntztHaveBtnOK && msgBox.m_nType == TZTBoxTypeNoButton)
    {
        msgBox.m_nType = TZTBoxTypeButtonOK;
    }
    return pDict;
}

@end
