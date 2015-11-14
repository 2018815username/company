//
//  TZTUIBaseTabBarViewController.m
//  IPAD-Table
//
//  Created by Dai Shouwei on 10-12-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "TZTUIBaseTabBarViewController.h"
//#import "tztUITradeViewController_iPad.h"
#import "tztUIBaseVCOtherMsg.h"
#import "TZTUIReportViewController.h"
#import "tztMainViewController.h"
#import "tztZXCenterViewController.h"

extern UIInterfaceOrientation g_nInterfaceOrientation;
TZTUIBaseTabBarViewController *g_tabBar = NULL;

@interface TZTUIBaseTabBarViewController(TZTPrivate)
-(BOOL)IsNeedJYLogin:(UIViewController*)vc;
@end

@implementation TZTUIBaseTabBarViewController

@synthesize maxDisplay;
@synthesize ayMoreItems;
@synthesize moreItem;
@synthesize m_pToolBarView;
@synthesize CurrentVC = _CurrentVC;
@synthesize nDefaultIndex = _nDefaultIndex;
@synthesize ayViews = _ayViews;
@synthesize leftVC = _leftVC;
@synthesize rightVC = _rightVC;
@synthesize pLeftNav = _pLeftNav;
@synthesize pRightNav = _pRightNav;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		maxDisplay = -1;
        self.m_pToolBarView = nil;
        if (g_pSystermConfig && g_pSystermConfig.nDefaultIndex)
            _nDefaultIndex = g_pSystermConfig.nDefaultIndex;
	}
	
	return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		maxDisplay = -1;
        self.m_pToolBarView = nil;
        if (g_pSystermConfig && g_pSystermConfig.nDefaultIndex)
            _nDefaultIndex = g_pSystermConfig.nDefaultIndex;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef tzt_UseUserTool //使用自定义
    self.tabBar.hidden = YES;
#endif
}

#pragma SideViewController处理
-(void)initSideViewController
{
    if (_ayViews == NULL)
    {
        _ayViews = NewObject(NSMutableArray);
    }
    
    if (g_nSupportLeftSide)
    {
        if (_leftVC == nil)
        {
            _leftVC = [[tzt_ht_zl_LeftViewController alloc] init];
            _leftVC.bLeftView = YES;
        }
        
        if (_pLeftNav == nil)
        {
            _pLeftNav = [[tztUINavigationController alloc] initWithRootViewController:_leftVC];
            _pLeftNav.navigationBar.hidden = YES;
        }
    }
    
    if (g_nSupportRightSide)
    {
        if (_rightVC == nil)
        {
            _rightVC = [[tzt_ht_zl_LeftViewController alloc] init];
            _rightVC.bLeftView = NO;
        }
        
        if (_pRightNav == nil)
        {
            _pRightNav = [[tztUINavigationController alloc] initWithRootViewController:_rightVC];
            _pRightNav.navigationBar.hidden = YES;
        }
    }
    
    if (g_nSupportLeftSide)
    {
        [self.revealSideViewController changeOffset:tzt_SideWidthLeft
                                       forDirection:PPRevealSideDirectionLeft];
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(preloadLeft)
                                                   object:nil];
        [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.3];
    }
    if (g_nSupportRightSide)
    {
        [self.revealSideViewController changeOffset:tzt_SideWidthRight
                                       forDirection:PPRevealSideDirectionRight];
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(preloadRight)
                                                   object:nil];
        [self performSelector:@selector(preloadRight) withObject:nil afterDelay:0.3];
    }
//    [self.revealSideViewController changeOffset:_offset
//                                   forDirection:PPRevealSideDirectionTop];
//    [self.revealSideViewController changeOffset:_offset
//                                   forDirection:PPRevealSideDirectionBottom];
}

-(void)RefreshAddCustomsViews
{
    [self.revealSideViewController updateViewWhichHandleGestures];
}

- (NSArray *)customViewsToAddPanGestureOnPPRevealSideViewController:(PPRevealSideViewController *)controller
{
    return [NSArray arrayWithArray:_ayViews];
}

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController *)controller directionsAllowedForPanningOnView:(UIView *)view;
{
    if (g_nSupportRightSide && g_nSupportLeftSide)
        return PPRevealSideDirectionLeft|PPRevealSideDirectionRight;
    else if (g_nSupportLeftSide)
        return PPRevealSideDirectionLeft;
    else if (g_nSupportRightSide)
        return PPRevealSideDirectionRight;
    return PPRevealSideDirectionLeft;
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller willPopToController:(UIViewController *)centerController
{
    self.tabBar.userInteractionEnabled = YES;
    self.m_pToolBarView.userInteractionEnabled = YES;
    g_navigationController.topViewController.view.userInteractionEnabled = YES;
    [g_navigationController.topViewController viewWillAppear:NO];
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController
{
    self.tabBar.userInteractionEnabled = NO;
    self.m_pToolBarView.userInteractionEnabled = NO;
    g_navigationController.topViewController.view.userInteractionEnabled = NO;
    [g_navigationController.topViewController viewDidDisappear:NO];
    //左侧回滚到最上面
    if (_leftVC)
        [_leftVC tztScrollToTop];
}

-(void)preloadLeft
{
    if (_pLeftNav)
    {
        [self.revealSideViewController preloadViewController:_pLeftNav
                                                     forSide:PPRevealSideDirectionLeft
                                                  withOffset:tzt_SideWidthLeft];
    }
}

-(void)preloadRight
{
    if (_pRightNav)
    {
        [self.revealSideViewController preloadViewController:_pRightNav
                                                     forSide:PPRevealSideDirectionRight
                                                  withOffset:tzt_SideWidthRight];
    }
}

-(void)ShowLeftVC
{
    if(_pLeftNav)
    {
        self.tabBar.userInteractionEnabled = NO;
        self.m_pToolBarView.userInteractionEnabled = NO;
        [self.revealSideViewController pushViewController:_pLeftNav onDirection:PPRevealSideDirectionLeft animated:YES];
    }
}

-(void)ShowRightVC
{
    if (_pRightNav)
    {
        [self.revealSideViewController pushViewController:_pRightNav onDirection:PPRevealSideDirectionRight animated:YES];
    }
}

-(void)LoadWebURL:(NSString*)strURL bLeft_:(BOOL)bleft
{
    if (bleft)
    {
        [_leftVC LoadWebURL:strURL];
    }
    else
    {
        [_rightVC LoadWebURL:strURL];
    }
}

#pragma mark -加载处理tabBarItem
-(void) LayoutTabBarItem
{
    CGRect rcFrame = self.view.bounds;
    if (g_nSupportLeftSide || g_nSupportRightSide)
        rcFrame.origin.y = g_nScreenHeight;
    else
    {
        if (g_nScreenHeight <= 0)
        {
            if (g_pSystermConfig.nToolBarHeight != 0)
            {
                rcFrame.origin.y = rcFrame.size.height - g_pSystermConfig.nToolBarHeight;
            }
            else
                rcFrame.origin.y = rcFrame.size.height - TZTToolBarHeight;
        }
        else
            rcFrame.origin.y = g_nScreenHeight + TZTStatuBarHeight;
    }
    rcFrame.size.height = TZTToolBarHeight + TZTStatuBarHeight / 2;
    //高度修改可配置的 modify by xyt 20131119
    if (g_pSystermConfig.nToolBarHeight != 0)
        rcFrame.size.height = g_pSystermConfig.nToolBarHeight;
#ifndef tzt_UseUserTool
//    self.tabBar.frame = rcFrame;
    rcFrame = self.tabBar.bounds;
#endif
    if (self.m_pToolBarView == nil)
    {
        self.m_pToolBarView = [[[TZTUIToolBarView alloc] init] autorelease];
        self.m_pToolBarView.frame = rcFrame;
        self.m_pToolBarView.backgroundColor = [UIColor clearColor];
        self.m_pToolBarView.pDelegate = self;
        self.m_pToolBarView.nSelected = _nDefaultIndex;
#ifndef tzt_UseUserTool
        [self.tabBar addSubview:self.m_pToolBarView];
#else
        [self.view addSubview:self.m_pToolBarView];
#endif
    }
    else
    {
        self.m_pToolBarView.frame = rcFrame;
    }
    
    g_pToolBarView = self.m_pToolBarView;
    
    if (g_nSupportRightSide || g_nSupportLeftSide)
    {
        if (_ayViews == NULL)
        {
            _ayViews = NewObject(NSMutableArray);
        }
        [_ayViews removeObject:self.tabBar];
        [_ayViews addObject:self.tabBar];
    
        //是否要阴影
//    [self.tabBar.layer setShadowColor:[UIColor darkTextColor].CGColor];
//    [self.tabBar.layer setShadowOffset:CGSizeMake(0,-0.5)];
//    [self.tabBar.layer setShadowOpacity:0.5];
    }
    else
    {
    //设置系统的tabbar区域，并隐藏
#ifdef tzt_UseUserTool
        UIView * transitionView = [[self.view subviews] objectAtIndex:0];
        transitionView.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight + TZTStatuBarHeight);
        self.tabBar.frame = rcFrame;
        self.tabBar.hidden = YES;
#endif
    }
}


- (void)viewWillAppear:(BOOL)animated    // Called when the view is about to made visible. Default does nothing
{
	[super viewWillAppear:animated];
//	[self LayoutTabBarItem];
}

- (void)viewDidAppear:(BOOL)animated     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
	[super viewDidAppear:animated];
	[self LayoutTabBarItem];
    self.moreNavigationController.navigationBarHidden = YES; // 隐藏moreNavigationController byDBQ20130729
    g_tabBar = self;
}

- (void)viewWillDisappear:(BOOL)animated // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
	[super viewDidDisappear:animated];
}

#pragma mark -横竖屏切换时的界面处理
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self LayoutTabBarItem];
}


-(NSUInteger)supportedInterfaceOrientations
{
    if (IS_TZTIPAD)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        return UIInterfaceOrientationMaskAll;
    }
}

-(BOOL)shouldAutorotate
{
    return YES;
}


#pragma mark -是否允许横竖屏切换
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        if (g_navigationController && [g_navigationController topViewController])
        {
            return [[g_navigationController topViewController] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
        }
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }
}



#pragma mark -内存警告
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	DelObject(ayMoreItems);
    [super dealloc];
}

-(BOOL)IsHomePage:(UIViewController*)vc
{
    if (vc == nil)
        return FALSE;
    
//    Class vcClass = [[NSBundle mainBundle] classNamed:@"tztHomePageViewController_iphone"];
//    if (vcClass != NULL && [vc isKindOfClass:vcClass])
    {
        if ([vc respondsToSelector:@selector(setInfoViewFrame)]) 
        {
            [(id)vc setInfoViewFrame];
        }
        return TRUE;
    }
    return FALSE;
}

-(BOOL)IsNeedJYLogin:(UIViewController*)vc
{
    if (vc == nil)
        return FALSE;
    
    BOOL bRZRQ = FALSE;
    bRZRQ = [vc isKindOfClass:[[NSBundle mainBundle] classNamed:@"tztUIRZRQTradeViewController_iPad"]];
    if ((![TZTUserInfoDeal IsTradeLogin:StockTrade_Log]) &&
        (([vc isKindOfClass: [[NSBundle mainBundle] classNamed:@"tztUITradeViewController_iPad"]] && !bRZRQ)
         ||[vc isKindOfClass:[[NSBundle mainBundle] classNamed:@"tztLCDTViewController"]]
         || [vc getTztTradeLoginSign] == 1))//zxl 20131128 添加理财大厅
        return TRUE;
    
    return FALSE;
}

// 判断融资融券登陆 add by xyt 20130930
-(BOOL)IsRZRQNeedJYLogin:(UIViewController *)vc
{
    if (vc == nil)
        return FALSE;
    
    Class vcClass = [[NSBundle mainBundle] classNamed:@"tztUIRZRQTradeViewController_iPad"];
    if (vcClass != NULL)
    {
        if ((![TZTUserInfoDeal IsTradeLogin:RZRQTrade_Log]) && [vc isKindOfClass:vcClass])
        {
            return TRUE;
        }
    }
    return FALSE;
}

//判断底部交易VC是否需要登录
-(BOOL)IsJYNeedLogin:(UIViewController*)vc
{
    if (vc == nil)
        return FALSE;
    Class vcClass = [[NSBundle mainBundle] classNamed:@"tztUIFuctionListViewController"];
    if (vcClass != NULL && [vc isKindOfClass:vcClass])
    {
        //激活登录
        if ([TZTUIBaseVCMsg SystermLogin:WT_JiaoYi wParam:0 lParam:0])
        {
            return TRUE;
        }
        //交易登录
        if (![TZTUIBaseVCMsg tztTradeLogin:WT_JiaoYi wParam:0  lParam:0 lLoginType:TZTAccountPTType])
        {
            return TRUE;
        }
    }
    
    return FALSE;
}

//判断底部有预警VC时候,需要激活登陆
-(BOOL)IsYuJingNeedSysLogin:(UIViewController *)vc
{
    if (vc == nil)
        return FALSE;
    Class vcClass = [[NSBundle mainBundle] classNamed:@"tztYuJingWebViewController"];
    if (vcClass != NULL && [vc isKindOfClass:vcClass]) 
    {
        if ([TZTUIBaseVCMsg SystermLogin:HQ_MENU_YUJING wParam:0 lParam:0])
        {
            return TRUE;
        }
    }
    
    return FALSE;
}

// 判断系统登陆
-(BOOL)IsNeedSystermLogin:(UIViewController *)vc
{
    if (vc == nil)
        return FALSE;
    
	//添加iphone的
    Class vcClassiphone = [[NSBundle mainBundle] classNamed:@"tztUIOnLineServiceCenterViewController"];
	Class vcClass = [[NSBundle mainBundle] classNamed:@"TZTZXKFViewController_iPad"];
    if ((vcClass != NULL && [vc isKindOfClass:vcClass])
        || (vcClassiphone != NULL && [vc isKindOfClass:vcClassiphone]))
    {
        if ([TZTUIBaseVCMsg SystermLogin:ZXKFPage wParam:0 lParam:0])
        {
            return TRUE;
        }
    }
    return FALSE;
}

// 判断TQ,需要登陆  add by xyt 20130925
-(BOOL)IsTQNeedJYLogin:(UIViewController *)vc
{
    if (vc == nil)
        return FALSE;
    
    Class vcClass = [[NSBundle mainBundle] classNamed:@"tztUITQViewController"];
    if (vcClass != NULL)
    {
        if ((![TZTUserInfoDeal IsTradeLogin:StockTrade_Log]) && [vc isKindOfClass:vcClass])
        {
            return TRUE;
        }
    }
    return FALSE;
    //    if ((![TZTUserInfoDeal IsTradeLogin:StockTrade_Log]) && [vc isKindOfClass:[tztUITQViewController class]])
    //        return TRUE;
    //
    //    return FALSE;
}

-(void)OnSelectDefault
{
    if (m_pToolBarView)
    {
        [m_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
    }
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0)
{
    return NO;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

-(BOOL)didSelectItemAtIndex:(NSInteger)nIndex options_:(NSDictionary *)options
{
    NSMutableArray *ayControl = [NSMutableArray arrayWithArray:self.viewControllers];
    
    UIViewController *viewController = NULL;
	if (ayControl && nIndex >= 0 && nIndex < [ayControl count])
	{
		viewController = [ayControl objectAtIndex:nIndex];
	}
    
    if (viewController == NULL)
	{
		return FALSE;
	}
    
    if(!IS_TZTIPAD)
    {
        UIViewController* pTopVc = ((UINavigationController*)viewController).topViewController;
        if([pTopVc isKindOfClass:[tztMainViewController class]])
        {
            tztMainViewController* ptztMainVc = (tztMainViewController *)pTopVc;
            [tztMainViewController addViewController:ptztMainVc.pPageInfoItem withNav:(UINavigationController *)viewController];
        }
    }
    
    //首页
    if ([self IsHomePage:((UINavigationController*)viewController).topViewController]) 
    {
    }
    
    //判断底部有预警VC时候,需要激活登陆
    if ([self IsYuJingNeedSysLogin:((UINavigationController*)viewController).topViewController])
    {
        //[TZTUIBaseVCMsg OnMsg:HQ_MENU_YUJING wParam:0 lParam:0];
        return FALSE;
    }
    
    //判断底部交易VC，选择后需要登录交易
    if (g_pSystermConfig.bSelectJYTabbar &&
        [self IsJYNeedLogin:((UINavigationController*)viewController).topViewController])
    {
        return FALSE;
    }
    
    //需要交易登录
    if ([self IsNeedJYLogin:((UINavigationController*)viewController).topViewController])
    {
        //zxl 20130927 添加了华泰外部调用交易内的功能
        if (options && [options objectForKey:@"JYType"])
        {
            NSString *strType = [options objectForKey:@"JYType"];
            if (strType && [strType length] > 0)
            {
                [TZTUIBaseVCMsg OnMsg:[strType intValue] wParam:0 lParam:0];
            }
        }else
        {
            [TZTUIBaseVCMsg OnMsg:WT_Trade_IPAD wParam:0 lParam:nIndex];
        }
        //弹出交易登录框
        return FALSE;
    }
    
    // 需要系统登录
    if ([self IsNeedSystermLogin:((UINavigationController*)viewController).topViewController]) {
//        [TZTUIBaseVCMsg OnMsg:ZXKFPage wParam:0 lParam:0];
        return FALSE;
    }
    
    //需要融资融券登陆
    if ([self IsRZRQNeedJYLogin:((UINavigationController*)viewController).topViewController])
    {
        [TZTUIBaseVCMsg OnMsg:WT_RZRQ_IPAD wParam:0 lParam:0];
        return FALSE;
    }
    
    //东莞TQ需要调用登陆 add by xyt 20130925
    if ([self IsTQNeedJYLogin:((UINavigationController*)viewController).topViewController])
    {
        [TZTUIBaseVCMsg OnMsg:WT_TQ_IPAD wParam:0 lParam:0];
        return FALSE;
    }
    
    //直接弹出网页
    if (nIndex < [g_pTZTTabBarProfile.ayTabBarItem count])
    {
        TZTPageInfoItem * item = [g_pTZTTabBarProfile.ayTabBarItem objectAtIndex:nIndex];
        
        if (item)
        {
            switch (item.nPageID)
            {
                case ReportTZTMessage:
                {
                    [TZTUIBaseVCMsg OnMsg:HQ_MENU_Message wParam:0 lParam:0];
                    return FALSE;
                }
                    break;
                case ReportTZTChaoGen:
                {
                    [TZTUIBaseVCMsg OnMsg:HQ_MENU_ChaoGen wParam:0 lParam:0];
                    return FALSE;
                }
                    break;
                case ReportETHeper:
                {   //zxl 20131128 添加ET助手
                    [TZTUIBaseVCMsg OnMsg:HQ_MENU_GTETHelper wParam:0 lParam:0];
                    return FALSE;
                }
                    break;
                case ReportWSTInfoPage:
                case ReportWSTZaoCan://维赛特早餐
                case ReportWSTGongl://维赛特攻略
                {//zxl 20131223 添加维赛特研究报告
                    [TZTUIBaseVCMsg OnMsg:item.nPageID wParam:0 lParam:0];
                    return FALSE;
                }
                    break;
                default:
                    break;
            }
        }
    }

    
    //根据选择tab 设置当前navc
    g_navigationController = (tztUINavigationController*)viewController;
    if(options && [options objectForKey:@"MenuID"]) //排名默认选中那个市场
    {
        UIViewController* pVC =  ((UINavigationController*)viewController).topViewController;
        if ([pVC isKindOfClass:[TZTUIReportViewController class]])
        {
            ((TZTUIReportViewController *)pVC).pStrMenID = [options objectForKey:@"MenuID"];
        }
    }
    //zxl 20130927 添加了华泰外部调用交易内的功能 设置交易中的功能名称
    if (options && [options objectForKey:@"JYType"])
    {
//        UIViewController* pVC =  ((UINavigationController*)viewController).topViewController;
//        if ([pVC isKindOfClass:[tztUITradeViewController_iPad class]])
//        {
//            NSString *strType = [options objectForKey:@"JYType"];
//            if (strType && [strType length] > 0)
//            {
//                [(tztUITradeViewController_iPad *)pVC SetJYType:[strType intValue]];
//            }
//        }
    }
    //zxl 20131031 国联ipad外部接口调用查询股票直接跳转到自选股 再显示个股
    if (options && [options objectForKey:@"SearchStock"])
    {
        UIViewController* pVC =  ((UINavigationController*)viewController).topViewController;
        if ([pVC isKindOfClass:[TZTUIReportViewController class]])
        {
            NSString *strStock = [options objectForKey:@"SearchStock"];
            if (strStock && [strStock length] > 0)
            {
                NSArray * pArry = [strStock componentsSeparatedByString:@"|"];
                if ([pArry count] == 3)
                {
                    tztStockInfo *pStock = NewObject(tztStockInfo);
                    pStock.stockCode = [NSString stringWithFormat:@"%@",[pArry objectAtIndex:0]];
                    pStock.stockName = [NSString stringWithFormat:@"%@",[pArry objectAtIndex:1]];
                    NSString * strStockType = [NSString stringWithFormat:@"%@",[pArry objectAtIndex:2]];
                    pStock.stockType = [strStockType intValue];
                    
                    TZTUIReportViewController * pVC = (TZTUIReportViewController *)g_navigationController.topViewController;
                    pVC.pReportGrid.bFlag = NO;
                    pVC.pStockInfo = pStock;
                    [pVC.pStockDetailView SetStockCode:pStock];
                    [pVC.tztTitleView setCurrentStockInfo:pStock.stockCode nsName_:pStock.stockName];
                    
                    DelObject(pStock);
                }
            }
        }
    }
#ifdef	GLSC_IPAD_Interface
	if (viewController)
	{
		UIViewController* pVC =  ((UINavigationController*)viewController).topViewController;
		if (pVC && [pVC isKindOfClass:[tztZXCenterViewController class]])
		{
			if (g_pTZTAppObj.rootTabBarController)
			{
				[g_pTZTAppObj.rootTabBarController.view removeFromSuperview];
			}
			[[NSNotificationCenter defaultCenter]postNotificationName:@"FromeZhongZhuo" object:NULL];
			return NO;
		}
	}
#endif
    
    if(self.selectedIndex != nIndex) //切换列表
    {
        [super setSelectedIndex:nIndex];
        g_bChangeNav = TRUE;
    }
    else
    {
        g_bChangeNav = FALSE;
    }
    
//    TZTUITabBarItem *item = ((tztUINavigationController*)viewController).tabBarItem;
//    self.tabBarItem.badgeValue = @"New";
//    [item setBadgeValue:@"222"];
//    
//    for (int i = 0; i < [self.viewControllers count]; i++)
//    {
//        tztUINavigationController* pNav = [self.viewControllers objectAtIndex:i];
//        NSLog(@"pNav  nPageID :%d\r\nviewControllers:%@", pNav.nPageID,pNav.viewControllers);
//    }
    
    self.CurrentVC = ((UINavigationController*)viewController).topViewController;
    if (!self.CurrentVC)
        self.CurrentVC = self.moreNavigationController.topViewController; // moreNavigationController情况下 byDBQ20130729
    TZTNSLog(@"%@",@"didSelectViewController");
//    viewController.view.alpha = 0.5f;
//    [UIView beginAnimations:@"fadeIn" context:nil];
//    [UIView setAnimationDuration:0.5];
//    viewController.view.alpha = 1.0f;
//    [UIView commitAnimations];
    
    [[tztUIBaseVCOtherMsg getShareInstance] tztperformSelector:@"tztNSLocationStop" withObject:nil];
    return TRUE;
}

-(void)didSelectItemByPageType:(int)nType options_:(NSDictionary*)options
{
#ifndef tzt_NewVersion
    return;
#endif
    if (g_pTZTTabBarProfile == NULL || g_pTZTTabBarProfile.ayTabBarItem == NULL || [g_pTZTTabBarProfile.ayTabBarItem count] < 1)
        return;
    
    //找到对应类型在数组中的位置
    int nIndex = -1;
    for (int i = 0; i < [g_pTZTTabBarProfile.ayTabBarItem count]; i++)
    {
        TZTPageInfoItem *pItem = [g_pTZTTabBarProfile.ayTabBarItem objectAtIndex:i];
        if (pItem == NULL)
            continue;
        if (nType == tztvckind_Set)
        {
#ifdef Support_HXSC
            if (pItem.nPageID == nType)
#else
            if (pItem.nPageID == nType || pItem.nPageID == tztvckind_SetEx)
#endif
            {
                nIndex = i;
                break;
            }
        }
        else if (pItem.nPageID == nType)
        {
            nIndex = i;
            break;
        }
    }
    
    if (m_pToolBarView == NULL)
    {
        [self LayoutTabBarItem];
    }
    
    [m_pToolBarView OnDealToolBarAtIndex:nIndex options_:options];
    self.tabBar.userInteractionEnabled = YES;
}

-(void)didSelectItemByIndex:(int)nIndex options_:(NSDictionary*)options
{
#ifndef tzt_NewVersion
    return;
#endif
    if (g_pTZTTabBarProfile == NULL || g_pTZTTabBarProfile.ayTabBarItem == NULL || [g_pTZTTabBarProfile.ayTabBarItem count] < 1)
        return;
    if (m_pToolBarView == NULL)
    {
        [self LayoutTabBarItem];
    }
    //找到对应类型在数组中的位置
//    [g_navigationController popToRootViewControllerAnimated:NO];
    [m_pToolBarView OnDealToolBarAtIndex:nIndex options_:options];
}

-(UIViewController*)GetTopViewController
{
    if (IS_TZTIPAD)
    {
        NSMutableArray *ayControl = [NSMutableArray arrayWithArray:self.viewControllers];
        
        UIViewController *viewController = NULL;
        if (ayControl && self.selectedIndex < [ayControl count])
        {
            viewController = [ayControl objectAtIndex:self.selectedIndex];
        }
        
        if (viewController == NULL)
        {
            return (TZTUIBaseViewController*)g_pTZTAppObj.rootTabBarController.CurrentVC;;
        }
        
        UIViewController* pVC = ((UINavigationController*)viewController).topViewController;
        if (!pVC)
            pVC = self.moreNavigationController.topViewController; //
        return pVC;
    }
    else
    {
        PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
        if (direction > 0)
        {
            if (direction == PPRevealSideDirectionLeft)
            {
                return [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController.topViewController;
            }
            else if (direction == PPRevealSideDirectionRight)
            {
                return [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController.topViewController;
            }
        }
        return g_navigationController.topViewController;
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item; // called when a new view is selected by the user (but
{
    NSLog(@"tabbarcontroller - (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item; // called when a new view is selected by the user (but ");
}
@end
