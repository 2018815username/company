//
//  LeftViewController.m
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import "tzt_ht_zl_LeftViewController.h"
#import "tztWebView.h"
#import "tztUIBaseVCOtherMsg.h"

@interface tzt_ht_zl_LeftViewController ()
{
    tztWebView* _webView;
}
@end

@implementation tzt_ht_zl_LeftViewController
@synthesize bLeftView = _bLeftView;
@synthesize bShowed = _bShowed;
- (id)init
{
    self = [super init];
    if (self) {
        _bLeftView = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMessage:) name:@"tztGetPushMessage" object:nil];
    self.view.backgroundColor = [UIColor blackColor];
    CGRect rcFrame = self.view.bounds;
#ifdef __IPHONE_7_0
    if (IS_TZTIOS(7))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        rcFrame.origin.y += TZTStatuBarHeight;
        rcFrame.size.height -= TZTStatuBarHeight;
    }
#endif
    if(_webView == nil)
    {
        _webView = [[tztWebView alloc] initWithFrame:rcFrame];
        [self.view addSubview:_webView];
        _webView.tztDelegate = self;
        [_webView release];
    }
    if(_webView)
    {
        if(_bLeftView)
        {
            NSString* str = @"";
            if (g_pSystermConfig)
                str = [g_pSystermConfig.pDict tztObjectForKey:@"tztLeftUrlNoLogin"];
            
            if (str.length <= 0)
            {
                return;
            }
            NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:str];
            [_webView setWebURL:strURL];
        }
        else
        {
            NSString* str = @"";
            if (g_pSystermConfig)
                str = [g_pSystermConfig.pDict tztObjectForKey:@"tztLeftUrlNoLogin"];
            
            if (str.length <= 0)
            {
                return;
            }
            NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:str];
            [_webView setWebURL:strURL];
        }
    }
    CGRect leftframe = rcFrame;
    leftframe.origin.x += (_bLeftView ? 0 : tzt_SideWidthRight);
    leftframe.size.width -= (_bLeftView ? tzt_SideWidthLeft : tzt_SideWidthRight);
    _webView.frame = leftframe;
}

-(void)LoadWebURL:(NSString*)strURL
{
    if (_webView)
        [_webView setWebURL:strURL];
}

-(void)GetMessage:(NSNotification*)noti
{
    if (_webView)
    {
        NSMutableArray* ayWebView = [_webView GetAyWebViews];
        for (int i = 0; i < [ayWebView count]; i++)
        {
            UIWebView* pWebView = [ayWebView objectAtIndex:i];
            NSString* s  = [pWebView stringByEvaluatingJavaScriptFromString:@"getMessage();"];
            NSLog(@"%@",s);
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self GetMessage:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
    if (direction > 0)
    {
        
        NSString* nsName = @"";
        if (direction == PPRevealSideDirectionLeft)
        {
            if (IS_TZTIphone5)
                nsName = @"tzt_Personal-568h@2x.png";
            else
                nsName = @"tzt_Personal@2x.png";
            [tztUIHelperImageView tztShowHelperView:nsName forClass_:@"tztPersonal-left"];
        }
    }
    _bShowed = TRUE;
}

-(void)tztScrollToTop
{
    if (_webView)
        [_webView scrollToTop];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _bShowed = FALSE;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    int nToolBarHeight = TZTToolBarHeight + TZTStatuBarHeight / 2;
    if (g_pSystermConfig && g_pSystermConfig.nToolBarHeight != 0)
        nToolBarHeight = g_pSystermConfig.nToolBarHeight;
	TZTNSLog(@"%@",@"Base will");
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)//竖屏显示
	{
        if (IS_TZTIPAD)
        {
            g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight -  nToolBarHeight;
        }
        else
        {
#ifdef tzt_NewVersion
            if (self.hidesBottomBarWhenPushed)
            {
                g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight;
            }
            else
            {
                g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight - nToolBarHeight;
            }
#else
            g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight;// - TZTToolBarHeight - TZTStatuBarHeight / 2;
#endif
            g_nScreenWidth = TZTScreenWidth;
            if (self.parentViewController == nil)
            {
                g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight;
            }
        }
        g_nScreenWidth = TZTScreenWidth;
		self.view.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
		self.view.bounds = CGRectMake(0, 0, g_nScreenWidth,g_nScreenHeight);
	}
    else
    {
        if (IS_TZTIPAD)
        {
            g_nScreenHeight = TZTScreenWidth - TZTStatuBarHeight - nToolBarHeight;
        }
        else
        {
            g_nScreenHeight = TZTScreenWidth - TZTStatuBarHeight;
        }
        g_nScreenWidth = TZTScreenHeight;
		self.view.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
		self.view.bounds = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
        
    }
    [self.view setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
                || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}


-(BOOL)tztWebViewIsRoot:(tztHTTPWebView *)webView
{
    return TRUE;
}

-(void)tztTradeLogOut
{
    if (_webView)
    {
        [_webView returnRootWebView];
        NSString* str = @"";
        if (g_pSystermConfig)
            str = [g_pSystermConfig.pDict tztObjectForKey:@"tztLeftUrlNoLogin"];
        
        if (str.length <= 0)
        {
            return;
        }
        NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:str];
        [_webView setWebURL:strURL];
    }
}

-(void)tztTradeLogIn
{
    if (_webView)
    {
        NSString* str = @"";
        if (g_pSystermConfig)
            str = [g_pSystermConfig.pDict tztObjectForKey:@"tztLeftUrlLogined"];
        
        if (str.length <= 0)
        {
            return;
        }
        NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:str];
        [_webView setWebURL:strURL];
    }
}

-(void)OnReturnBack
{
    [self OnReturnBack:UseAnimated];
}

-(void)OnReturnBack:(BOOL)useanimated
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:useanimated];
        if ([self.navigationController.viewControllers count] <= 1)
        {
            if (g_nSupportLeftSide)
                [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:tzt_SideWidthLeft forDirection:PPRevealSideDirectionLeft animated:YES];
            if (g_nSupportRightSide)
                [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:tzt_SideWidthRight forDirection:PPRevealSideDirectionRight animated:YES];
        }
    }
}

-(void)OnWebReturnBack
{
    if (_webView && [_webView OnReturnBack])
    {
        [self setTitle:[_webView getWebTitle]];
    }
}

-(void)tztPushViewController:(UIViewController*)pVC animated:(BOOL)animated
{
    if (![TZTAppObj getShareInstance].rootTabBarController.revealSideViewController.wasClosed
        && ![TZTAppObj getShareInstance].rootTabBarController.revealSideViewController.IgnoredTouch)
        return;
    if (self.navigationController)
    {
        /*
         首先隐藏右侧
         */
        [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionLeft animated:YES];
        [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionRight animated:YES];
        [self.navigationController pushViewController:pVC animated:animated];
    }
}

-(void)RefreshWebView:(int)nIndex
{
    if (_webView)
    {
        [_webView RefreshWebView:nIndex];
    }
}
@end
