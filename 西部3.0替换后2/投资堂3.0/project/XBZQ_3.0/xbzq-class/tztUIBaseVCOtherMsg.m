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
#import "tztMenuViewController_iphone.h"
#import "tztUIReportViewController_iphone.h"
#import "tztNineCellViewController.h"
#import "tztUIFuctionListViewController.h"
#import "tztMainViewController.h"
#import "tztFundFlowsViewController.h"
//#import "TZTIndexViewController.h"
//#import "TZTUserStockDetailViewController.h"
#import "tztUISearchStockViewController.h"
#import "tztNewStockSGViewController.h"
#import "tztETFApplyWithDrawVC.h"
#import "tztUIFundDTModifyVC.h"
#import "tztUIETFApplyFundVC.h"
#import "tztTradeMainViewController.h"
#import "tztUserStockEditViewController.h"

#ifndef YJBLightVersion
#import "TZTIndexViewController.h"
#import "TZTUserStockDetailViewController.h"
#endif

#import "tztGJInfoCenterViewController.h"
#import "tztGJTradeViewController.h"
#import "tztUIStockBuySellViewController.h"
#import "tztGJMeViewController.h"

#import "tztWebTradeWithDrawViewController.h"
#import "tztTradeHisSearchViewController.h"
#import "tztUISearchStockCodeVCEx.h"
#import "tztUIFountSearchWTVC.h"

#import "tztUIUserStockViewController.h"
#import "TZTInitReportMarketMenu.h"
#import "tztUIRZRQBuySellViewController.h"
#import "tztUIQuoteViewController.h"
#import "tztUIQuoteViewControllerStyle2.h"

#import "tztUITradeFundPHViewController.h"
#import "tztRZRQMainViewController.h"
#import "myWebViewController.h"
#import "tztUIRZRQSearchViewController.h"
#import "TZTUIDateViewController.h"

#import "tztZXCenterViewController_iphone.h"
//#import "TestViewController.h"
#import "ShangCheng/ShangChengViewController.h"
#import "AccountHelpViewController.h"
#import "tztUIZQTradeBuysellViewController.h"

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

+(void)ExitCurrentAccount:(NSString*)nsAccount
{
    /*增加交易登出，向服务器发送消息*/
    tztJYLoginInfo *pCurInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    [[tztPushDataObj getShareInstance] tztRequestSignOutTrade:pCurInfo.nsAccount];
    /**/
    
    BOOL bChange = FALSE;
    //获取当前登录的账号
    if ([TZTUserInfoDeal IsHaveTradeLogin:Trade_CommPassLog])
    {
        tztZJAccountInfo *pZJAccount = NewObjectAutoD(tztZJAccountInfo);
        [pZJAccount ReadLastSaveData:TZTAccountCommLoginType withFileName_:@"tztCustomerFile"];
        if (nsAccount && [nsAccount caseInsensitiveCompare:pZJAccount.nsAccount] == NSOrderedSame)
        {
            bChange = TRUE;
        }
    }
    
    NSString* strPath = GetPathWithListName(@"tztLoginFlag", TRUE);
    [@"0" writeToFile:strPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if (nsAccount == NULL || nsAccount.length <= 0)
        bChange = TRUE;
    if (!bChange)//没有修改，不用切换状态
    {
        return;
    }
    
    //登出所有账号
    [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllServer_Log withNotifi:YES];
    if(g_ayJYLoginInfo && [g_ayJYLoginInfo count] > 0)
    {
        for (int i = 0; i < [g_ayJYLoginInfo count]; i++)
        {
            NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:i];
            [ayJyLoginInfo removeAllObjects];
        }
    }
    
    if(g_CurUserData)
    {
        for (int i = 0; i < TZTMaxAccountType; i++)
        {
            [g_CurUserData delAccountToken:i];
        }
    }
    //个人中心退出所有
    [[TZTAppObj getShareInstance].rootTabBarController.leftVC tztTradeLogOut];
    [[TZTAppObj getShareInstance].rootTabBarController.leftVC OnReturnBack:NO];
    
    
    //行情
    tztUINavigationController *pHQNav = [tztMainViewController getNavController:tztvckind_HQ];
    [pHQNav popToRootViewControllerAnimated:YES];
}

-(void)onReturn
{
    //交易回到首页
    tztUINavigationController* pNav = [tztMainViewController getNavController:tztvckind_JY];
    if (pNav && pNav.nPageID == tztvckind_JY)
        [pNav popToRootViewControllerAnimated:NO];
    
    tztUINavigationController* pNavMe = [tztMainViewController getNavController:tztvckind_Set];
    if (pNavMe && pNavMe.nPageID == tztvckind_Set)
    {
        [pNavMe popToRootViewControllerAnimated:NO];
//        UIViewController *pVC = pNav.topViewController;
        
    }
}

- (void)tztLoginStateChanged:(NSNotification*)note
{
    NSString* strType = (NSString*)note.object;
    NSArray *ay = [strType componentsSeparatedByString:@"|"];
    if ([ay count] <= 0)
        return;
    long lType = [[ay objectAtIndex:0] intValue];
    BOOL IsLogin = TRUE;
    if ([ay count] > 1)
    {
        IsLogin = [[ay objectAtIndex:1] boolValue];
    }
    
//    if ([TZTUserInfoDeal IsHaveTradeLogin:lType])
    {
        if((StockTrade_Log & lType) == StockTrade_Log)//普通交易登出
        {
            tztUINavigationController *pZTNav = [tztMainViewController getNavController:tztvckind_Set];
            UIViewController *pZTVC = nil;
            for (int i = 0; i < [pZTNav.viewControllers count]; i++)
            {
                pZTVC = [pZTNav.viewControllers objectAtIndex:i];
                if (pZTVC && [pZTVC isKindOfClass:[tztWebViewController class]])
                {
                    [((tztWebViewController*)pZTVC).pWebView RefreshWebView:-1];
                }
            }
            
            if ([TZTAppObj getShareInstance].rootTabBarController && [TZTAppObj getShareInstance].rootTabBarController.leftVC)
            {
                if(!IsLogin)
                    [[TZTAppObj getShareInstance].rootTabBarController.leftVC tztTradeLogOut];
                else
                    [[TZTAppObj getShareInstance].rootTabBarController.leftVC tztTradeLogIn];
            }
        }
        else if ((RZRQTrade_Log & lType) == RZRQTrade_Log)
        {
            tztUINavigationController *pZTNav = [tztMainViewController getNavController:tztvckind_Set];
            UIViewController *pZTVC = nil;
            for (int i = 0; i < [pZTNav.viewControllers count]; i++)
            {
                pZTVC = [pZTNav.viewControllers objectAtIndex:i];
                if (pZTVC && [pZTVC isKindOfClass:[tztWebViewController class]])
                {
                    [((tztWebViewController*)pZTVC).pWebView RefreshWebView:-1];
                }
            }
        }
        
        
    }
}


+(int) OnMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    if ([tztUIBaseVCOtherMsg IsNeedJYLogin:nMsgType])
    {
        if(![tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
            return 1;
    }
    switch (nMsgType)
    {
        case TZT_MENU_SysAddAccount:{
            AccountHelpViewController *pVC  = [[AccountHelpViewController alloc] init];
            [pVC retain];
            pVC.nMsgType = nMsgType;
            [pVC SetHidesBottomBarWhenPushed:YES];
            [g_navigationController pushViewController:pVC animated:YES];
            [pVC release];
            return 1;
        }
            break;
        case  MENU_JY_RZRQ_QueryFundsHis: //资金流水历史
        {
            BOOL bPush = FALSE;
            TZTUIDateViewController *pVC = (TZTUIDateViewController *)gettztHaveViewContrller([TZTUIDateViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
            break;
        case MENU_JY_FUND_XJBLEDSetting://历史委托
        case MENU_JY_FUND_PHQueryHisWT://历史委托
        {
            
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            BOOL bPush = FALSE;
            TZTUIDateViewController *pVC = (TZTUIDateViewController *)gettztHaveViewContrller([TZTUIDateViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            pVC.nsTitle = @"历史委托";
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            return 1;
        }
            break;
     //查询持仓xbxty/app/jy/jy_cxcc.htm
        case MENU_JY_PT_QueryStock:{
            NSString* urlStr = @"xbxty/app/jy/jy_cxcc.htm";

            tztWebViewController *webVC = [[tztWebViewController alloc] init];
            webVC.nHasToolbar = NO;
            NSString* url =  [tztlocalHTTPServer getLocalHttpUrl:urlStr];
            [webVC setWebURL:url];
            [g_navigationController pushViewController:webVC animated:NO];
            return 1;
        }
            break;
        //基金盘后当日委托 基金撤单 ruyi
        case MENU_JY_FUND_PHQueryDraw:
        case MENU_JY_FUND_PHCancel:
        {
            BOOL bPush = FALSE;
            tztUIFountSearchWTVC *pVC = (tztUIFountSearchWTVC *)gettztHaveViewContrller([tztUIFountSearchWTVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];

            return 1;
        }break;
        case MENU_HQ_UserStock:
        {
            tztUINavigationController* pNav = [tztMainViewController getNavController:tztvckind_HQ];
            if (pNav) //
            {
                [pNav popToRootViewControllerAnimated:NO];
            }
            [tztMainViewController didSelectNavController:tztvckind_HQ options_:NULL];
            [g_ayPushedViewController removeObject:pNav.topViewController];
            [g_ayPushedViewController addObject:pNav.topViewController];
            
            UIViewController* pVC = g_navigationController.topViewController;
            if ([pVC isKindOfClass:[tztUIQuoteViewController class]])
            {
                [pVC view];
                [pVC tztperformSelector:@"RequestUserStockData"];
            }
            return 1;
        }
            break;
            
        case MENU_JY_PT_Buy: //12310 股票买入 普通买入
        case MENU_JY_PT_Sell: //12311 股票卖出 普通卖出
        case WT_BUY://买入
        case WT_SALE://卖出
            //        case MENU_JY_PT_ZhaiZhuanGu:  //债券股 12315
        case MENU_JY_PT_NiHuiGou: //12319  逆向回购
        {
            
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;

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
            
            return 1;
        }
            break;

        case Sys_Menu_ReRegist://重新激活
        case MENU_SYS_ReLogin:
        {
            
            //清除本地数据
            [[tztUserData getShareClass] reSetUserData];
            [tztKeyChain save:tztLogMobile data:@""];
            [TZTUserInfoDeal SaveAndLoadLogin:FALSE nFlag_:0];
            [[TZTAppObj getShareInstance].rootTabBarController.leftVC RefreshWebView:-1];
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
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
            return 1;
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
            else{
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
            return 1;
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
            NSString* strUrla = [NSString stringWithFormat:strURL,[ayPush objectAtIndex:1],[ayPush objectAtIndex:0]];
            if(strUrla == nil || [strUrla length] <= 0)
                return TRUE;
            
            TZTNSLog(@"%@",strUrla);
            strUrla = [tztlocalHTTPServer getLocalHttpUrl:strUrla];
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Pop,[NSString stringWithFormat:@"%d", (unsigned int)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
            pVC.nHasToolbar = NO;
            pVC.nMsgType = nMsgType;
            //            pVC.nWebType = tztWebInBox;
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
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
            return 1;
        }
            break;

            
            
        //查询//资金流水历史 保证金可用余额
        case MENU_JY_RZRQ_QueryKRZQ:
        case MENU_JY_RZRQ_QueryBail:
        {
            BOOL bPush = FALSE;
            tztUIRZRQSearchViewController *pVC = (tztUIRZRQSearchViewController *)gettztHaveViewContrller([tztUIRZRQSearchViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];

            return 1;
        }break;
        case MENU_SYS_UserLogout://登出当前账号，各个界面回到首页
        {
            if (lParam != 1)
            {
                tztAfxMessageBlock(@"确定退出当前登录账号？", nil, nil, TZTBoxTypeButtonBoth, ^(NSInteger nIndex){
                    if (nIndex == 0)
                    {
                        [self ExitCurrentAccount:nil];
                        [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
#ifdef tzt_NewVersion
                        [g_navigationController popToRootViewControllerAnimated:UseAnimated];
#endif
                        if (IS_TZTIPAD)
                        {
                            [g_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
                        }
                        [tztJYLoginInfo SetLoginAllOut];
                    }
                });
            }
            else
            {
                [self ExitCurrentAccount:nil];
                [tztJYLoginInfo SetLoginAllOut:FALSE];
            }
            return 1;
        }
            break;
            
        case HQ_MENU_UploadUserStock:
        case TZT_MENU_UpUserStock:
        {
            NSString* strAccount = [[tztHTTPData getShareInstance] getmapValue:@"fund_account"];
            if (strAccount.length > 0)
            {
                [tztUserStock getShareClass].nsAccount = [NSString stringWithFormat:@"%@", strAccount];
                [tztUserStock UploadUserStock:YES];
            }
            else//激活登录
            {
                if (![tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                    return 1;
                [tztUserStock getShareClass].nsAccount = @"";
                [tztUserStock UploadUserStock:YES];
            }
            return 1;
        }
            break;
        case HQ_MENU_DownloadUserStock:
        case TZT_MENU_DownUserStock:
        {
            NSString* strAccount = [[tztHTTPData getShareInstance] getmapValue:@"fund_account"];
            if (strAccount.length > 0)
            {
                [tztUserStock getShareClass].nsAccount = [NSString stringWithFormat:@"%@", strAccount];
                [tztUserStock DownloadUserStock];
            }
            else//激活登录
            {
                if (![tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                    return 1;
                
                [tztUserStock getShareClass].nsAccount = @"";
                [tztUserStock DownloadUserStock];
            }
            return 1;
        }
            break;
        case HQ_MENU_MergeUserStock:
        case TZT_MENU_MergeUserStock:
        {
            NSString* strAccount = [[tztHTTPData getShareInstance] getmapValue:@"fund_account"];
            if (strAccount.length > 0)
            {
                [tztUserStock getShareClass].nsAccount = [NSString stringWithFormat:@"%@", strAccount];
                [tztUserStock MergerUserStock];
            }
            else//激活登录
            {
                if (![tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                    return 1;
                [tztUserStock getShareClass].nsAccount = @"";
                [tztUserStock MergerUserStock];
            }
            return 1;
        }
            break;
            
        case HQ_MENU_EditUserStock:
        case TZT_MENU_EditUserStock://自选股编辑
        {
            BOOL bPush = FALSE;
            tztUserStockEditViewController *pVC = (tztUserStockEditViewController *)gettztHaveViewContrller([tztUserStockEditViewController class], tztvckind_Pop, [NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"编辑自选"];
            if(bPush)
            {
                [g_navigationController pushViewController:pVC  animated:UseAnimated];
            }
            [pVC release];
            return 1;
        }
            break;
            
        case TZT_MENU_StartOpen:
        {
            //国金使用独立的开户程序
            
            BOOL bOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.yjb.kh://ui=1&terminal=tzt&callid=gjtrade.gjkaihu"]];
            if (!bOpen)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xi-bu-zheng-quan-zhang-shang/id962278472?l=en&mt=8"]];
            }
            return 1;
            
#ifdef Support_GJKHHTTPData
#if defined(__GNUC__) && !TARGET_IPHONE_SIMULATOR && ( defined(__APPLE_CPP__) || defined(__APPLE_CC__) || defined(__MACOS_CLASSIC__) )
            
            UIViewController* navVC = g_navigationController.topViewController;
            if ([[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose] > 0)
            {
                navVC = [TZTAppObj getShareInstance].rootTabBarController.leftVC;
            }
            else
            {
                navVC = g_navigationController.topViewController;
            }
            
            if (g_nThemeColor == 0) {
                [tztkhAppSetting getShareInstance].nSkinType = 0;
            }
            else if (g_nThemeColor == 1)
            {
                [tztkhAppSetting getShareInstance].nSkinType = 1;
            }
            g_nSkinType = [tztkhAppSetting getShareInstance].nSkinType;
            NSString* pActionKey = @"10048";
            NSArray* pArry = [NSArray arrayWithObjects:g_pTZTAppObj.window,navVC.navigationController,navVC,pActionKey,nil];
            NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:pArry,@"APP",@"1", @"RunByURL",nil];
            [[tztkhApp getShareInstance] callService:(NSDictionary *)params withDelegate:self];
#endif
#endif
            return 1;
        }
            break;
        case MENU_SYS_JYErrorLogout://交易错误登出
        {
            [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
            [tztJYLoginInfo SetLoginAllOut];
//            [NSTimer scheduledTimerWithTimeInterval:0.8
//                                             target:[tztUIBaseVCOtherMsg getShareInstance]
//                                           selector:@selector(onReturn)
//                                           userInfo:nil
//                                            repeats:NO];
            return 1;
        }
            break;
        case HQ_MENU_SearchStock://个股查询
        case MENU_HQ_SearchStock:
        {
            NSString* strUrl = nil;
            if (wParam)
                strUrl = (NSString*)wParam;
            BOOL bPush = FALSE;
            tztUISearchStockCodeVCEx *pVC = (tztUISearchStockCodeVCEx *)gettztHaveViewContrller([tztUISearchStockCodeVCEx class], tztvckind_Pop,@"0",&bPush,TRUE);
            
            [pVC retain];
            if (strUrl)
                pVC.nsURL = [NSString stringWithFormat:@"%@", strUrl];
            pVC.nMsgType = nMsgType;
            pVC.lParam = (id)lParam;
            if (bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
            return 1;
        }
            break;
        case WT_OUT://退出登录
        case MENU_SYS_JYLogout:
        {
            NSString* nsTips = @"交易登录已经退出！";
            if (![TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log] && ![TZTUserInfoDeal IsHaveTradeLogin:RZRQTrade_Log])
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
                tztAfxMessageBlock(strContext, nil, nil, TZTBoxTypeButtonOK, ^(NSInteger nIndex){
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
                tztAfxMessageBox(nsTips);
                if (strUrl.length > 0 && [strUrl hasPrefix:@"http://action:"])
                {
                    NSString* strAction = [strUrl substringFromIndex:[@"http://action:" length]];
                    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:/*lParam*/0];
                }
            }
            return 1;
        }
            break;
        case MENU_SYS_UserWarning://预警
        {
            //
//            NSString *strUrlFirst = @"/yjb/warning.html";
//            NSString *str = @"10061/?fullscreen=1&&secondtype=99&&secondtext=全部提醒&&url=";
//            NSString *strUrlSecond = @"/yjb/warnList.html";
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Pop, [NSString stringWithFormat:@"%ld", (long)nMsgType], &bPush,TRUE);
            [pVC retain];
            pVC.nHasToolbar = 0;
            pVC.nTitleType = TZTTitleReturn;
            if (IS_TZTIPAD)//pad版本没有底部的工具栏
                pVC.nHasToolbar = NO;
            pVC.nMsgType = nMsgType;
            [pVC setTitle:@"股价提醒"];
            NSString* strFile = @"/yjb/warning.html";
            NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            
            
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode)
                {
//                    strUrlFirst = [NSString stringWithFormat:@"%@?stockcode=%@",strUrl,pStock.stockCode];
                    strUrl = [NSString stringWithFormat:@"%@?stockcode=%@",strUrl,pStock.stockCode];
                }
            }
            
//            strUrlFirst = [strUrlFirst tztencodeURLString];
//            str = [NSString stringWithFormat:@"%@%@&&secondurl=%@",str, strUrlFirst,strUrlSecond];
//            str = [str tztencodeURLString];
//            [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:0];
//            return 1;
//            
            [pVC setLocalWebURL:strUrl];
            if(bPush)
            {
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
            return 1;
        }
            break;
            /*
            //查询持仓
#ifndef  YJBLightVersion
        case MENU_JY_PT_Buy:
        case MENU_JY_PT_Sell:
        case WT_BUY://买入
        case WT_SALE://卖出
        case MENU_JY_PT_NiHuiGou: //12319  逆向回购
        {
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            
            tztUIStockBuySellViewController* pVC = (tztUIStockBuySellViewController*)[TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIStockBuySellViewController class]];
            
            tztStockInfo *pStock = nil;
            pStock = (tztStockInfo*)wParam;
            
            BOOL bPush = FALSE;
            if (pVC == NULL)
            {
                pVC = [[tztUIStockBuySellViewController alloc] init];
                bPush = TRUE;
            }
            
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode && (pStock.stockType == 0 || MakeStockMarketStock(pStock.stockType)))
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            }
            pVC.nMsgType = nMsgType;
            pVC.bBuyFlag = (nMsgType == WT_BUY || nMsgType == MENU_JY_PT_Buy);
            if (bPush)
            {
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
                [pVC release];
            }
            else
            {
                [pVC OnRequestData];
            }
            return 1;
        }
            break;
            
            /*
        case WT_WITHDRAW:
        case MENU_JY_PT_Withdraw:
        {
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            
            BOOL bPush = TRUE;
            tztWebTradeWithDrawViewController *pVC = [[tztWebTradeWithDrawViewController alloc] init];
            pVC.nMsgType = nMsgType;
            pVC.nHasToolbar = NO;
            [pVC setWebURL:[tztlocalHTTPServer getLocalHttpUrl:@"/yjb/jy_cancelPrin.htm"]];
            if (bPush)
            {
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            
            [pVC release];
            return 1;
        }
            break;

        case WT_QUERYDRWT:
        case MENU_JY_PT_QueryDraw://当日委托
        {
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            
            BOOL bPush = TRUE;
            tztWebTradeWithDrawViewController *pVC = [[tztWebTradeWithDrawViewController alloc] init];
            pVC.nMsgType = nMsgType;
            pVC.nHasToolbar = NO;
            [pVC setWebURL:[tztlocalHTTPServer getLocalHttpUrl:@"/yjb/jy_todayPrin.htm"]];
            if (bPush)
            {
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            
            [pVC release];
            return 1;
        }
            break;
            
        case MENU_JY_PT_QueryTradeDay://当日成交
        case MENU_JY_PT_QueryTransHis://历史成交
        case MENU_JY_PT_QueryJG://交割单
        {
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            
            BOOL bPush = TRUE;
            tztTradeHisSearchViewController *pVC = [[tztTradeHisSearchViewController alloc] init];
            if(nMsgType == MENU_JY_PT_QueryTradeDay
               || nMsgType == MENU_JY_PT_QueryTransHis)
                pVC.strURL = @"yjb/jy_history.htm?begindate=%@&enddate=%@";
            else if (nMsgType == MENU_JY_PT_QueryJG)
                pVC.strURL = @"/yjb/deliveryOrder.htm?begindate=%@&enddate=%@";
            pVC.nMsgType = nMsgType;
            if (bPush)
            {
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            
            [pVC release];
            return 1;
        }
            break;
             
#endif*/
       
        /*case WT_JiaoYi:
        case MENU_JY_PT_List:
        case WT_FUND_TRADE:
        case MENU_JY_FUND_List:
        case MENU_JY_PT_CardBank:
        {
            NSString* strTitle = GetTitleByID(nMsgType);
            BOOL bPush = FALSE;
            tztUIFuctionListViewController *pVC = (tztUIFuctionListViewController *)gettztHaveViewContrller([tztUIFuctionListViewController class],tztvckind_Pop,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,FALSE);
            [pVC retain];
            if (ISNSStringValid(strTitle))
                [pVC SetTitle:strTitle];
            
            switch (nMsgType)
            {
//                case WT_JiaoYi:
//                case MENU_JY_PT_List:
//                {
//                    [pVC setProfileName:@"tztUIStockTradeListSetting"];
//                }
//                    break;
                case WT_FUND_TRADE:
                case MENU_JY_FUND_List:
                {
                    [pVC setProfileName:@"tztUITradeFundListSetting"];
                }
                    break;
                case MENU_JY_PT_CardBank:
                {
                    [pVC setProfileName:@"tztUITradeYZZZListSetting"];
                }
                    break;
                
                default:
                    break;
            }
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
            break;
         */
            // 首页标题栏logo点击后跳转到版本信息 byDBQ20130711
        case Sys_Menu_Contact:
        {
            tztWebViewController *pVC = [[tztWebViewController alloc] init];
            [pVC setTitle:@"版本信息"];
            pVC.nHasToolbar = 0;
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC LoadHtmlData:g_pSystermConfig.strAboutCopyright];
            [pVC release];
            return YES;
        }
            break;
//        case WT_JJWWInquire:
//        case MENU_JY_FUND_DTReq:
//        {
//            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
//                return 1;
//            BOOL bPush = FALSE;
//            tztUIFountSearchWTVC *pVC = (tztUIFountSearchWTVC *)gettztHaveViewContrller([tztUIFountSearchWTVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
//            [pVC retain];
//            pVC.nMsgType = WT_JJWWInquire;
//            if(bPush)
//                [g_navigationController pushViewController:pVC animated:UseAnimated];
//            [pVC release];
//            return 1;
//        }
//            break;
            /*货币基金*/

        case WT_ETFApplyFundRG://货币基金认购 old
        case WT_ETFApplyFundSG://货币基金(ETF)申购
        case MENU_JY_FUND_HBShenGou://货币基金申购
        case WT_ETFApplyFundSH://货币基金(ETF)赎回
        case MENU_JY_FUND_HBShuHui://货币基金赎回
        case MENU_JY_FUND_HBRenGou://货币基金认购 新的功能号 12762
            
        {
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            
            BOOL bPush = FALSE;
            tztUIETFApplyFundVC *pVC = (tztUIETFApplyFundVC *)gettztHaveViewContrller([tztUIETFApplyFundVC class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];

            pVC.nMsgType = nMsgType;
//            if (nMsgType == MENU_JY_FUND_HBRenGou) {
//                pVC.nMsgType = WT_ETFApplyFundRG;
//            }
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
            break;
        case WT_ETFInquireEntrust://货币基金(ETF)当日委托查询
        case MENU_JY_FUND_HBQueryDraw://货币基金当日委托
        case MENU_JY_FUND_HBWithdraw://货币基金委托撤单
   // #define  MENU_JY_FUND_HBQueryLSWT           (TZT_MENU_JY_FUND_BEGIN +144) //12844  货币基金当日委托
        {
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            
            BOOL bPush = FALSE;
            tztETFApplyWithDrawVC *pVC = (tztETFApplyWithDrawVC *)gettztHaveViewContrller([tztETFApplyWithDrawVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
            break;
            /*基金定投功能结束*/
        case WT_JJWWOpen:   //基金定投和修改
        case WT_JJWWModify:
        case WT_JJWWInquire: //ruyi 
        case MENU_JY_FUND_DTReq:
//        case WT_JJWWCancel://定投取消 ruyi
//        case MENU_JY_FUND_DTCancel:
        {
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
           // NSMutableDictionary *pDict = (NSMutableDictionary*)wParam;
            BOOL bPush = FALSE;
            tztUIFundDTModifyVC *pVC = (tztUIFundDTModifyVC *)gettztHaveViewContrller([tztUIFundDTModifyVC class],tztvckind_JY,[NSString stringWithFormat:@"%d", tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];
//            if (pDict)
//            {
//                pVC.pDefaultDateDict = pDict;
//            }
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
         break;

        case WT_JJWWCancel://定投取消 ruyi
        case MENU_JY_FUND_DTCancel:
        {
            //这个地方 基金查询 ，持仓基金
            BOOL bPush = FALSE;
            tztUIFountSearchWTVC *pVC = (tztUIFountSearchWTVC *)gettztHaveViewContrller([tztUIFountSearchWTVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
            break;
            /*基金盘后业务*/
        case WT_FundPH_JJFC:
        case MENU_JY_FUND_PHSplit:
        case WT_FundPH_JJHB:
        case MENU_JY_FUND_PHMerge:
        case WT_FundPH_JJZH:
//        case MENU_JY_FUND_PHCancel:
        {
            BOOL bPush = FALSE;
            tztUITradeFundPHViewController *pVC = (tztUITradeFundPHViewController *)gettztHaveViewContrller([tztUITradeFundPHViewController class], tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            return 1;
        }
            break;
        case MENU_JY_PT_XinGuShenGou:
        case MENU_JY_RZRQ_NewStockSG:
        {
            if (! [tztUIBaseVCOtherMsg CheckSysAndTradeLogin:nMsgType wParam:wParam lParam:lParam])
                return 1;
            BOOL bPush = TRUE;
            tztNewStockSGViewController *pVC = [[tztNewStockSGViewController alloc] init];
            pVC.nMsgType = nMsgType;
            
            if(bPush)
            {
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
            return 1;
        }
            break;
            
        case 0x9991: // 关于佣金宝
        {
            BOOL bPush = FALSE;
            tztWebViewController *pVC = (tztWebViewController *)gettztHaveViewContrller([tztWebViewController class], tztvckind_Set,[NSString stringWithFormat:@"%ld", (long)nMsgType],&bPush,TRUE);
            
            [pVC retain];
            
#ifdef tzt_NewVersion
            pVC.nHasToolbar = 0;
#else
            pVC.nHasToolbar = 1;
#endif
            pVC.nMsgType = nMsgType;
            pVC.nWebType = tztWebMyRoom;
            pVC.nsTitle = @"西部信天游";
            NSString *strURL;
            strURL = @"http://www.yongjinbao.com.cn";
            [pVC setWebURL:strURL];
            [pVC SetHidesBottomBarWhenPushed:YES];
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
            return TRUE;
        }
            break;
        case 0x123456: // 排行榜
        {
            NSMutableDictionary *dic = (NSMutableDictionary *)lParam;
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
                tztStockInfo *pStock = (tztStockInfo*)wParam;
                pVC.nReportType = tztReportBlockIndex;
                pVC.pStockInfo = pStock;
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20199"];
                pVC.nsReqParam = [NSString stringWithFormat:@"%@", pStock.stockCode];
                NSString* strTitle = [NSString stringWithFormat:@"%@\\r\\n%@", pStock.stockName, pStock.stockCode];
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
                pVC.nMsgType = nMsgType;
                
                tztStockInfo *pStock = (tztStockInfo*)wParam;
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
//                [pVC RequestDefaultMenuData:strMarket andShowID:[NSString stringWithFormat:@"%@",strMenuID]];
//                [pVC RequestDefaultMenuData:];
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
            
            /*融资融券操作*/
            
        case WT_JYRZRQ://融资融券九宫格
        case MENU_JY_RZRQ_List: //融资融券
        {
            //zxl 20130718 融资融券添加列表
#ifdef tzt_TradeList
            
            NSString* strWParam = (NSString*)wParam;
            NSDictionary *dict = [strWParam tztNSMutableDictionarySeparatedByString:@"&&"];
            
            tztRZRQMainViewController *pVC = [[tztRZRQMainViewController alloc] init];
            pVC.nHasToolbar = NO;
            pVC.nMsgType = nMsgType;
            NSString* strURL = [dict tztObjectForKey:@"url"];
            NSString* nsURL = [tztlocalHTTPServer getLocalHttpUrl:@"/yjb/jy_finanIndex.htm"];
            if (strURL.length > 0)
                nsURL = [tztlocalHTTPServer getLocalHttpUrl:strURL];
                
            [pVC setWebURL:nsURL];
            [pVC SetHidesBottomBarWhenPushed:YES];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
            
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
            return 1;
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
            if (![TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountRZRQType])
            {
                return TRUE;
            }
            tztStockInfo *pStock = (tztStockInfo*)wParam;
            BOOL bPush = FALSE;
            
            tztUIRZRQBuySellViewController* pVC = (tztUIRZRQBuySellViewController*)[TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIRZRQBuySellViewController class]];
            
            if (pVC == NULL)
            {
                pVC = [[tztUIRZRQBuySellViewController alloc] init];
                bPush = TRUE;
            }
            
            if (pStock && [pStock isKindOfClass:[tztStockInfo class]])
            {
                if (pStock.stockCode && (pStock.stockType == 0 || MakeStockMarketStock(pStock.stockType)))
                    pVC.CurStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            }
            
            NSDictionary* dict = (NSDictionary*)lParam;
            NSString* nsSerialNo = @"";
            if (dict)
            {
                nsSerialNo = [dict tztObjectForKey:@"serial"];
                pVC.nsSeraialNo = [NSString stringWithFormat:@"%@", nsSerialNo];
            }
            
            pVC.nMsgType = nMsgType;
            pVC.bBuyFlag = (WT_RZRQBUY == nMsgType || WT_RZRQRZBUY == nMsgType || nMsgType == WT_RZRQBUYRETURN || nMsgType == MENU_JY_RZRQ_PTBuy || nMsgType == MENU_JY_RZRQ_XYBuy || nMsgType == MENU_JY_RZRQ_BuyReturn);
            
            if(bPush)
            {
                [g_navigationController pushViewController:pVC animated:UseAnimated];
                [pVC release];
            }
            else
            {
                [pVC OnRequestData];
            }
            return 1;
        }
            break;
//        case MENU_JY_RZRQ_QueryTransHis://融资融券历史成交
//        case MENU_JY_RZRQ_QueryJG:
//        case MENU_JY_RZRQ_QueryRZQK:
//        case MENU_JY_RZRQ_QueryFundsDay:
//        case MENU_JY_RZRQ_QueryFundsDayHis://资金流水
//        {
//            if (![TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:TZTAccountRZRQType])
//                return TRUE;
//            
//            tztTradeHisSearchViewController *pVC = [[tztTradeHisSearchViewController alloc] init];
//            pVC.nMsgType = nMsgType;
//            NSString* strURL = @"/yjb/rzrq/rzrq-history.htm?type=2&begindate=%@&enddate=%@";
//            if (nMsgType == MENU_JY_RZRQ_QueryJG)
//            {
//                strURL = @"/yjb/rzrq/rzrq-history.htm?type=3&begindate=%@&enddate=%@";
//            }
//            else if (nMsgType == MENU_JY_RZRQ_QueryFundsDayHis
//                     || nMsgType == MENU_JY_RZRQ_QueryFundsDay)
//            {
//                strURL = @"/yjb/rzrq/rzrq-history.htm?type=4";
//            }
//            pVC.strURL = strURL;
//            [pVC SetHidesBottomBarWhenPushed:YES];
//            [g_navigationController pushViewController:pVC animated:UseAnimated];
//            [pVC release];
//            return 1;
//        }
//            break;
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
            
#ifdef tzt_NewVersion
//            [g_navigationController popToRootViewControllerAnimated:UseAnimated];
#endif
            //融资融券退出  modify by xyt 20131025
            if (IS_TZTIPAD)
            {
                [g_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
            }
//            pBox.m_nsTitle = @"提示信息";
//            pBox.m_nsContent = nsTips;
//            [pBox showForView:nil];
            return 1;
        }
            break;
            //债券回购
        case MENU_JY_PT_ZhaiQuanHuiShou+1:
        {
            BOOL bPush = FALSE;
            tztUIZQTradeBuysellViewController *pVC = (tztUIZQTradeBuysellViewController *)gettztHaveViewContrller([tztUIZQTradeBuysellViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
            [pVC retain];
            
            pVC.nMsgType = nMsgType;
            pVC.bBuyFlag = FALSE;
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
            else
            {
                if(bPush)
                {
                    [g_navigationController pushViewController:pVC animated:UseAnimated];
                }
                else
                {
                    [pVC OnRequestData];
                }
            }
            [pVC release];
            return 1;
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
//        g_CurUserData.nsMobileCode
        g_nsLogMobile = [tztKeyChain load:tztLogMobile];
        if (g_nsLogMobile && g_nsLogMobile.length >= 11)
        {
            if(![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
            {
                [tztUserData getShareClass].nsMobileCode = [NSString stringWithFormat:@"%@",g_nsLogMobile];
                [tztKeyChain save:tztLogMobile data:g_nsLogMobile];
                [TZTUserInfoDeal SetTradeLogState:Trade_Login lLoginType_:Systerm_Log];
            }
        }
        else
//            if ([g_nsLogMobile length] < 11 )//|| ![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log]
        {
            //系统登录
            tztUISysLoginViewController* pVC = [[tztUISysLoginViewController alloc] init];
            [pVC setMsgID:nMsgType MsgInfo:(void*)wParam LPARAM:lParam];
            pVC.nMsgType = nMsgType;
            
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
//#ifdef tzt_NewVersion
//                [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
//#else
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
//#endif
            }
            [pVC release];
            return 0;
        }
    }
    
    int nFalg = [TZTUIBaseVCMsg tztTradeLogin:nMsgType wParam:wParam lParam:lParam lLoginType:(IsRZRQMsgType(nMsgType) ? TZTAccountRZRQType : TZTAccountPTType)];
    return nFalg;
}
/*
+ (UIViewController*)GetTabBarViewController:(NSInteger)nType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0 || lParam != 1)
        return  NULL;
    
    TZTPageInfoItem *pItem = (TZTPageInfoItem*)wParam;
    if (![pItem isKindOfClass:[TZTPageInfoItem class]])
        return NULL;
    
    UIViewController *pViewController = NULL;
    switch (pItem.nPageID)
    {
        case tztHomePage://自选
        {
            tztUIUserStockViewController *vc = [[[tztUIUserStockViewController alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztMarketPage:// 行情
        {
            TZTIndexViewController *vc = [[[TZTIndexViewController alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztInfoPage:  // 资讯
        {
            tztGJInfoCenterViewController *vc = [[[tztGJInfoCenterViewController alloc] init] autorelease];
            vc.nHasToolbar = NO;
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = TZT_MENU_JY_LIST;
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"资讯中心"];
            NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:@"/yjb/zhzx_index.htm"];
            [vc setWebURL:strURL];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
            
        }
            break;
        case tztTradePage:  // 交易
        {
#ifdef YJBLightVersion
            tztUITradeLogindViewController *vc = [[[tztUITradeLogindViewController alloc] init] autorelease];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = tztTradePage;
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
#else
            tztGJTradeViewController *vc = [[[tztGJTradeViewController alloc] init] autorelease];
            NSString* strFile = @"/yjb/jy_index.htm";
            NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            vc.nHasToolbar = NO;
            [vc setWebURL:strURL];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = tztTradePage;
//            [vc setTztTradeLoginSign:1];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
#endif
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztServicePage:  // 我
        {
            tztGJMeViewController *vc = [[[tztGJMeViewController alloc] init] autorelease];
            NSString* strFile = @"me/index.html";
            NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            vc.nHasToolbar = NO;
            [vc setWebURL:strURL];
//            [vc setTztTradeLoginSign:1];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"我"];
            vc.nMsgType = tztInfoPage;
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        
        default:
            break;
    }

    
    return pViewController;
}
*/

+ (UIViewController*)GetTabBarViewController:(NSInteger)nType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0 || lParam != 1)
        return  NULL;
    
    TZTPageInfoItem *pItem = (TZTPageInfoItem*)wParam;
    if (![pItem isKindOfClass:[TZTPageInfoItem class]])
        return NULL;
    
    UIViewController *pViewController = NULL;
    switch (pItem.nPageID)
    {
        case tztHomePage://首页
        {
        myWebViewController *pvc = [[[myWebViewController alloc] init] autorelease];
        NSString* strFile = @"xbxty/app/index.htm";
        NSString* strURL =[tztlocalHTTPServer getLocalHttpUrl:strFile];
        pvc.nHasToolbar = NO;
        [pvc setWebURL:strURL];
        [pvc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
        pvc.nMsgType = tztHomePage;
        
        pViewController = [[[tztUINavigationController alloc] initWithRootViewController:pvc] autorelease];
        ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
        [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
        pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
            
        }
            break;
        case tztMarketPage:// 行情
        {
#ifndef YJBLightVersion
            tztUIQuoteViewController *vc = [[[tztUIQuoteViewController alloc] init] autorelease];
//            MyHQViewController* vc  = [MyHQViewController getShareViewController];
            [vc setVcShowKind:pItem.nPageID];
            
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
#endif
        }
            break;
        case tztTradePage:  // 交易
        {
//
#ifdef YJBLightVersion
            tztUITradeLogindViewController *vc = [[[tztUITradeLogindViewController alloc] init] autorelease];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = tztTradePage;
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
#else
            tztGJTradeViewController *vc = [[[tztGJTradeViewController alloc] init] autorelease];
            NSString* strFile = @"/xbxty/app/jy/jy_index.htm";
            NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            vc.nHasToolbar = NO;
            [vc setWebURL:strURL];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = tztTradePage;
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            
            
//            TestViewController *vc = [[TestViewController alloc] init];
//            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            
#endif
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztInfoPage:  //商城
        {
            /*
            tztZXCenterViewController_iphone *vc = [[[tztZXCenterViewController_iphone alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = MENU_SYS_InfoCenter;
            
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"商城"];
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
             */
            ShangChengViewController *vc = [[[ShangChengViewController alloc] init] autorelease];
            NSString* strFile = @"http://www.west95582.com/jdwm/m/wshopping/wsindex.jsp";
            NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            vc.nHasToolbar = NO;
            [vc setWebURL:strURL];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
//            else
//                [vc setTitle:@"商城"];
            vc.nMsgType = tztServicePage;
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];

        }
            break;
        case tztServicePage:  // 营业厅
        {
            tztGJMeViewController *vc = [[[tztGJMeViewController alloc] init] autorelease];
            NSString* strFile = @"xbxty/app/zt/zt_index.htm";
            NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            vc.nHasToolbar = NO;
            [vc setWebURL:strURL];
            //            [vc setTztTradeLoginSign:1];other
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"掌厅"];
            vc.nMsgType = tztServicePage;
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
            
        default:
            break;
    }
    
    
    return pViewController;
}
+ (BOOL)addViewController:(TZTPageInfoItem *)pItem withNav:(UINavigationController *)viewController
{
    BOOL bDeal = FALSE;
    switch (pItem.nPageID)
    {
        case tztMarketPage:  //行情
        {
#ifndef YJBLightVersion
            TZTIndexViewController *vc = [[[TZTIndexViewController alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = MENU_HQ_Report;
//            vc.nTztTitleType = TZTTitleIcon;
            
            if (pItem.pRev1 && pItem.pRev1.length > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"其它市场"];
            [vc setTitle:pItem.nsPageName];
            [viewController pushViewController:vc animated:NO];
            return TRUE;
#endif
        }
            break;
        case tztTradePage:  //交易
        {
            tztUIFuctionListViewController *vc = [[[tztUIFuctionListViewController alloc] init] autorelease];
            [vc setProfileName:@"tztUIStockTradeListSetting"];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d", tztVcShowTypeRoot]];
            vc.nMsgType = TZT_MENU_JY_LIST;
            [viewController pushViewController:vc animated:NO];
            bDeal = TRUE;
        }
            break;
        default:
            break;
    }
    
    return bDeal;
}

-(int)tztSystermLogin:(TZTUIMessage*)pMessage
{
    [tztUserData getShareClass];
    if (g_pSystermConfig && g_pSystermConfig.bNeedRegist)
    {
        g_nsLogMobile = [tztKeyChain load:tztLogMobile];
        
        if (g_nsLogMobile && g_nsLogMobile.length >= 11)
        {
            if(![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
            {
                [tztUserData getShareClass].nsMobileCode = [NSString stringWithFormat:@"%@",g_nsLogMobile];
                [tztKeyChain save:tztLogMobile data:g_nsLogMobile];
                [TZTUserInfoDeal SetTradeLogState:Trade_Login lLoginType_:Systerm_Log];
            }
        }
        else
//        if ([g_nsLogMobile length] < 11 || ![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
        {
            //系统登录
            BOOL bPush = FALSE;
            tztUISysLoginViewController *pVC = (tztUISysLoginViewController *)gettztHaveViewContrller([tztUISysLoginViewController class], tztvckind_Pop,[NSString stringWithFormat:@"%d", MENU_SYS_JYLogin], &bPush,TRUE);
            [pVC retain];
            [pVC setMsgID:pMessage.m_nMsgType MsgInfo:(void*)pMessage.m_wParam LPARAM:(NSUInteger)pMessage.m_lParam];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 500);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if (bPush)
            {
                
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
                [pVC SetHidesBottomBarWhenPushed:YES];
                [nav pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
            return -1;
        }
    }

    return FALSE;
}

//交易登录
-(int)tztTradeLogin:(TZTUIMessage*)pMessage
{
    BOOL bIsHaveLogin = FALSE;
    switch (pMessage.m_lRev1)
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
        bPush = TRUE;
#ifdef YJBLightVersion
        tztUITradeLogindViewController *pVC = [[tztUITradeLogindViewController alloc] init];
#else
        tztUITradeLogindViewController *pVC = (tztUITradeLogindViewController *)gettztHaveViewContrller([tztUITradeLogindViewController class], tztvckind_Pop,[NSString stringWithFormat:@"%d", MENU_SYS_JYLogin], &bPush,FALSE);
        [pVC retain];
#endif
        pVC.nMsgType = MENU_SYS_JYLogin;
        pVC.nLoginType = pMessage.m_lRev1;
        [pVC setMsgID:pMessage.m_nMsgType MsgInfo:(void*)pMessage.m_wParam LPARAM:pMessage.m_lParam];
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
#ifdef YJBLightVersion
            [g_navigationController popToRootViewControllerAnimated:UseAnimated];
#else
            
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
            
            [pVC SetHidesBottomBarWhenPushed:YES];
            [nav pushViewController:pVC animated:UseAnimated];
#endif
        }
        [pVC release];
        return -1;
    }
    return 1;
}

//判断登陆
+(BOOL)IsNeedJYLogin:(NSInteger)nMsgType
{
    if (nMsgType == MENU_JY_RZRQ_List)
        return FALSE;
    if ((nMsgType >= WT_HBJJ_Begin      && nMsgType <= WT_HBJJ_End)   //货币基金
        || (nMsgType >= WT_BJHG_Begin   && nMsgType <= WT_BJHG_End)   //报价回购
        || (nMsgType >= WT_DZJY_Begin   && nMsgType <= WT_DZJY_End)   //大宗交易
        || (nMsgType >= WT_DKRY_Begin   && nMsgType <= WT_DKRY_End)   //多空如弈
        || (nMsgType >= WT_ZYHG_Begin   && nMsgType <= WT_ZYHG_End)   //质押回购
        || (nMsgType >= WT_FundPH_Begin && nMsgType <= WT_FundPH_End)//基金盘后
        || (nMsgType >= WT_ETF_TRADE_BEGIN && nMsgType <= WT_ETF_TRADE_End)//ETF
        || (nMsgType >= MENU_QS_HTSC_ZJLC_BGEIN && nMsgType <= MENU_QS_HTSC_ZJLC_END)//紫金理财
        || (nMsgType >= WT_XJLC_Begin   && nMsgType <= WT_XJLC_End)   //现金理财功能
        || (nMsgType >= WT_ZRT_Begin    && nMsgType <= WT_ZRT_End)      //转融通
        || (nMsgType >= MENU_JY_RZRQ_ZRT_Begin    && nMsgType <= MENU_JY_RZRQ_ZRT_END)      //转融通
        || (nMsgType == MENU_JY_PT_StockOut || nMsgType == MENU_JY_PT_QueryStockOut)        //出借
        || ((nMsgType >= ID_MENU_Stock_TRADE && nMsgType <= ID_MENU_Stock_TRADE_End) && (nMsgType != WT_OUT))
        || ((nMsgType >= TZT_MENU_JY_LIST && nMsgType <= TZT_MENU_JY_END))
//        || (nMsgType == TZT_MENU_UpUserStock)    //上传自选
//        || (nMsgType == TZT_MENU_DownUserStock)  //下载自选
//        || (nMsgType == TZT_MENU_MergeUserStock)  //合并自选
//        || (nMsgType == HQ_MENU_UploadUserStock)    //上传自选
//        || (nMsgType == HQ_MENU_DownloadUserStock)  //下载自选
//        || (nMsgType == HQ_MENU_MergeUserStock)     //合并自选))//普通交易。基金
        || (nMsgType == MENU_JY_PT_XinGuShenGou) // 新股申购
//        || (nMsgType == TZT_MENU_OpenWebInfoContent)//打开新的网页 wry
        )
    {
        return TRUE;
    }
    return FALSE;
}

@end

@implementation tztHTTPData(tztOther)

-(void)tztPopViewDealSideViewController:(UINavigationController*)nav
{
    if ([nav.viewControllers count] <= 1)
    {
        [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:tzt_SideWidthLeft forDirection:PPRevealSideDirectionLeft animated:YES];
        [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:tzt_SideWidthRight forDirection:PPRevealSideDirectionRight animated:YES];
    }
    
}

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
//#ifdef YJBLightVersion
    if (([viewController getVcShowKind] == tztvckind_JY
         || [viewController getVcShowKind] == tztvckind_Pop
         || [viewController getVcShowKind] == tztvckind_HQ
         || [viewController getVcShowKind] == tztvckind_ZX
         || [viewController getVcShowKind] == tztvckind_Main)
        && ([[viewController getVcShowType] intValue] != tztVcShowTypeRoot))//交易不显示底部tabbar
    {
        [viewController SetHidesBottomBarWhenPushed:YES];
    }
//#endif
    
    UIViewController *pVC = nav.topViewController;
    if (pVC.hidesBottomBarWhenPushed)
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

@end

@implementation TZTUIMessageBox(tztPrivate)
-(NSMutableDictionary*)tztMsgBoxSetProperties:(TZTUIMessageBox*)msgBox
{
    NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
    [pDict setTztObject:@"255,255,255,0.9" forKey:tztMsgBoxBackColor];
    [pDict setTztObject:@"241,241,241,0.9" forKey:tztMsgBoxTitleBackColor];
    [pDict setTztObject:@"1" forKey:tztMsgBoxCornRadius];
//    [pDict setTztObject:@"1234556" forKey:tztMsgBoxBtnOKImg];
//    [pDict setTztObject:@"28,149,238" forKey:tztMsgBoxBtnOKTitleColor];
//    [pDict setTztObject:@"1234455" forKey:tztMsgBoxBtnCancelImg];
//    [pDict setTztObject:@"28,149,238" forKey:tztMsgBoxBtnCancelTitleColor];
    [pDict setTztObject:@"center" forKey:tztMsgBoxTitleAlignment];
    [pDict setTztObject:@"top" forKey:tztMsgBoxSepLinePos];

//    msgBox.m_nsContent = @"温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示温馨提示";
    msgBox.m_nsTitle = @"系统提示";
    msgBox.m_TitleFont = tztUIBaseViewTextFont(18.0);
    return pDict;
}

@end
