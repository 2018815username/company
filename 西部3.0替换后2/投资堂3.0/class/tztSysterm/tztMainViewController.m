//
//  tztMainViewController.m
//  tztMobileApp_HTSC
//
//  Created by yangares on 13-8-21.
//
//

#import "tztMainViewController.h"
#import "TZTInitReportMarketMenu.h"  
  
#import "TZTUIReportViewController.h" //排名
#import "tztNineCellViewController.h" //交易九宫格、列表
#import "tztMenuViewController_iphone.h" //行情分类排名
#import "tztZXCenterViewController_iphone.h" //资讯中心
#import "tztHomePageViewController_iphone.h" //首页
#import "tztUIServiceCenterViewController.h" //服务中心

#import "tztWebViewController.h"

#import "tztZXCenterViewController.h"
#import "tztUIServiceCenterViewController_iPad.h"

#import "tztUIBaseVCOtherMsg.h"


@interface tztMainViewController ()

@end

@implementation tztMainViewController
@synthesize pPageInfoItem = _pPageInfoItem;
@synthesize nItemIndex = _nItemIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pPageInfoItem = nil;
        self.nItemIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建viewController 最开始先调用这里  
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
        
        for (int i = 0; i < nCount; i++)
        {
            TZTPageInfoItem* pItem = [ayTabBarItem objectAtIndex:i];
            if (pItem == NULL)
                continue;
            
            pVC = [tztMainViewController GetTabBarViewController:0 wParam_:(NSUInteger)pItem lParam_:1];
            if (pVC == NULL)
                continue;
            [controllers addObject:pVC];
            nIndex++;
        }
    }
    
    return controllers;
}
//功能号消息处理

+(UIViewController*) GetTabBarViewController:(NSInteger)nType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0 || lParam != 1)
        return  NULL;
    
    TZTPageInfoItem *pItem = (TZTPageInfoItem*)wParam;
    if (![pItem isKindOfClass:[TZTPageInfoItem class]])
        return NULL;
    
    UIViewController *pViewController = NULL;
    
    pViewController = [tztUIBaseVCOtherMsg GetTabBarViewController:nType wParam_:wParam lParam_:lParam];
    if (pViewController)
        return pViewController;
    
#if 1
    switch (pItem.nPageID)
    {
        case tztHomePage:
        {
            tztHomePageViewController_iphone *vc = NULL;
            vc = [[[tztHomePageViewController_iphone alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztMarketPage:  //行情
        {
            tztMenuViewController_iphone *vc = [[[tztMenuViewController_iphone alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = MENU_HQ_Report;
            
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"其他市场"];
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztInfoPage:  //资讯
        {
            tztZXCenterViewController_iphone *vc = [[[tztZXCenterViewController_iphone alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = MENU_SYS_InfoCenter;
            
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"资讯中心"];
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztTradePage:  //交易
        {
            tztNineCellViewController *vc = [[[tztNineCellViewController alloc] init] autorelease];
            vc.fCellSize = 60;
            NSArray *pAyCell = [g_pSystermConfig.pDict objectForKey:@"TZTTradeGrid"];
            if (pAyCell && [pAyCell count] > 0)
            {
                int nCol = [[g_pSystermConfig.pDict objectForKey:@"tztNineCol"] intValue];
                if (nCol <= 0)
                    nCol = 3;
                
                int nPerRow = [[g_pSystermConfig.pDict objectForKey:@"tztNineRow"] intValue];
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
        case tztMorePage:  //更多
        {
            
        }
            break;
        case tztServicePage://服务(网页)
        {   
            tztWebViewController *vc = [[[tztWebViewController alloc] init] autorelease];
            vc.nHasToolbar = NO;
            
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"系统设置"];
            
            NSString* strFile = @"service/index.htm";
            NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            [vc setLocalWebURL:strUrl];
            
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = pItem.nPageID;
            [(UINavigationController*)pViewController setNavigationBarHidden:TRUE animated:NO];
            pViewController.tabBarItem = (UITabBarItem*)[pItem CreateTabBarItem];
        }
            break;
        case tztServicePageLocal://服务（本地）
        {
            
            tztUIServiceCenterViewController *vc = NULL;
            vc = [[[tztUIServiceCenterViewController alloc] init] autorelease];
            vc.nsProfileName = [NSString stringWithFormat:@"%@", @"tztTableSystemSetting"];
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            vc.nMsgType = Sys_Menu_ServiceCenter;
            
            [vc setVcShowKind:tztServicePage];
            [vc setVcShowType:[NSString stringWithFormat:@"%d", tztVcShowTypeRoot]];
            
            pViewController = [[[tztUINavigationController alloc] initWithRootViewController:vc] autorelease];
            ((tztUINavigationController*)pViewController).nPageID = tztServicePage;
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

+ (void)addViewController:(TZTPageInfoItem *)pItem withNav:(UINavigationController *)viewController
{
    if([tztUIBaseVCOtherMsg addViewController:pItem withNav:viewController])
        return;
#if 1
    switch (pItem.nPageID)
    {
        case tztMarketPage:  //行情
        {
            tztMenuViewController_iphone *vc = [[[tztMenuViewController_iphone alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = MENU_HQ_Report;
            
            if (pItem.pRev1 && pItem.pRev1.length > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"其它市场"];
            [vc setTitle:pItem.nsPageName];
            [viewController pushViewController:vc animated:NO];
        }
            break;
        case tztInfoPage:  //资讯
        {
            tztZXCenterViewController_iphone *vc = [[[tztZXCenterViewController_iphone alloc] init] autorelease];
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
            vc.nMsgType = MENU_SYS_InfoCenter;
            [viewController pushViewController:vc animated:NO];
        }
            break;
        case tztTradePage:  //交易
        {
            tztNineCellViewController *vc = [[[tztNineCellViewController alloc] init] autorelease];
            vc.fCellSize = 60;
            NSArray *pAyCell = [g_pSystermConfig.pDict objectForKey:@"TZTTradeGrid"];
            if (pAyCell && [pAyCell count] > 0)
            {
                int nCol = [[g_pSystermConfig.pDict objectForKey:@"tztNineCol"] intValue];
                if (nCol <= 0)
                    nCol = 3;
                
                int nPerRow = [[g_pSystermConfig.pDict objectForKey:@"tztNineRow"] intValue];
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
        }
            break;
        case tztMorePage:  //更多
        {
            
        }
            break;
        case tztServicePage://服务
        {
            tztWebViewController *vc = [[[tztWebViewController alloc] init] autorelease];
            vc.nHasToolbar = NO;
            if (pItem.pRev1 && [pItem.pRev1 length] > 0)
                [vc setTitle:pItem.pRev1];
            else
                [vc setTitle:@"系统设置"];
            NSString* strFile = @"service/index.htm";
            NSString* strUrl = [tztlocalHTTPServer getLocalHttpUrl:strFile];
            [vc setLocalWebURL:strUrl];
            
            [vc setVcShowKind:pItem.nPageID];
            [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
           [viewController pushViewController:vc animated:NO];
        }
            break;
        case tztServicePageLocal:
        {   
            tztUIServiceCenterViewController *vc = NULL;
            vc = [[[tztUIServiceCenterViewController alloc] init] autorelease];
            vc.nsProfileName = [NSString stringWithFormat:@"%@", @"tztTableSystemSetting"];
            
            [vc setVcShowKind:tztServicePage];
            [vc setVcShowType:[NSString stringWithFormat:@"%d", tztVcShowTypeRoot]];
            vc.nMsgType = MENU_SYS_System;
            [viewController pushViewController:vc animated:NO];
        }
        default:
            break;
    }
#endif
}

+(void)didSelectNavController:(int)nVcKind options_:(NSMutableDictionary *)options
{
    if ([TZTAppObj getShareInstance].rootTabBarController)
    {
        [[TZTAppObj getShareInstance].rootTabBarController didSelectItemByPageType:nVcKind options_:options];
    }
}

+ (tztUINavigationController*)getNavController:(int)nVcKind
{
#ifdef tzt_NewVersion
    if(nVcKind == tztvckind_All || nVcKind == tztvckind_Pop)
        return g_navigationController;
    NSArray* ayControllers = [TZTAppObj getShareInstance].rootTabBarController.viewControllers;
    for (int i = 0; i < [ayControllers count]; i++)
    {
        UIViewController* pVc = [ayControllers objectAtIndex:i];
        if(pVc)
        {
            tztUINavigationController* pNavVc = (tztUINavigationController* )pVc;
            if (nVcKind == tztvckind_Set)
            {
#ifdef Support_HXSC
                if (pNavVc && (pNavVc.nPageID == nVcKind))
#else
                if (pNavVc && (pNavVc.nPageID == nVcKind || pNavVc.nPageID == tztvckind_SetEx))
#endif
                {
                    return pNavVc;
                }
            }
            else if (pNavVc && pNavVc.nPageID == nVcKind)
            {
                return pNavVc;
            }
        }
    }
#endif
    return g_navigationController;
}
/*
 统一排名菜单列表中存在着英文字母，直接转int会导致市场类型对不上，无法请求到正确的排名数据，所以改成NSString
 int nVcType -> NSString* nsVcType
 by yinjp 20130826
 */
FOUNDATION_EXPORT UIViewController* gettztHaveViewContrller(Class vcClass,int nVcKind,NSString* nVcType, BOOL* bPush,BOOL bCreate)
{
    return gettztHaveViewContrllerEx(vcClass, nVcKind, nVcType, bPush, bCreate, nil);
    
}

UIViewController* gettztHaveViewContrllerEx(Class vcClass,int nVcKind,NSString* nVcType, BOOL* bPush,BOOL bReUse, UIViewController* vcControl)
{
    *bPush = TRUE;
//    bReUse = FALSE;
    UIViewController *pRetVC =  NULL;
    tztUINavigationController* pNavC = nil;
     if ([[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose] <= 0)
     {
         pNavC = [tztMainViewController getNavController:nVcKind];
         [tztMainViewController didSelectNavController:pNavC.nPageID options_:NULL];
     }
    if(pNavC)
    {
        NSArray* ayVc = pNavC.viewControllers;
        for (NSInteger i = [ayVc count] - 1 ; i > 0 ; i--) //第0个不包含，因为他是rootvc
        {
            UIViewController *pVC = [ayVc objectAtIndex:i];
            if (pVC && [pVC isKindOfClass:vcClass] && [pVC isKindofVcKind:nVcKind VcType:nVcType] )//找到对应的vc
            {
                
                NSMutableArray* aySet = NewObject(NSMutableArray);
                for (int j = 0; j < [ayVc count]; j++)
                {
                    if(j == i)
                    {
                        continue;
                    }
                    [aySet addObject:[ayVc objectAtIndex:j]];
                }
                if (bReUse
                    || [pVC isKindOfClass:[[NSBundle mainBundle] classNamed:@"tztUIFenShiViewController_iphone"]]
                    /*|| [pVC isKindOfClass:[[NSBundle mainBundle] classNamed:@"TZTUserStockDetailViewController"]]*/
                    )
                {
                    [aySet addObject:pVC];
                    *bPush = FALSE;
                    pRetVC = [pVC retain];
                    [pNavC setViewControllers:aySet animated:NO];
                }
                else
                {
                    [g_ayPushedViewController removeObject:pVC];
                    [pNavC setViewControllers:aySet animated:NO];
                }
                [aySet release]; // Avoid potential leak.  byDBQ20131031
                break;
            }
        }
    }
    if(pRetVC == NULL)
    {
        if (([NSStringFromClass(vcClass) caseInsensitiveCompare:@"TZTUserStockDetailViewController"] == NSOrderedSame)
            && vcControl != NULL)
        {
            pRetVC = [vcControl retain];
            *bPush = TRUE;
        }
        else
        {
            pRetVC = (UIViewController *)[[vcClass alloc] init];
            [pRetVC setVcShowKind:nVcKind];
            [pRetVC setVcShowType:nVcType];
            *bPush = TRUE;
        }
    }
    return [pRetVC autorelease];
}
@end
