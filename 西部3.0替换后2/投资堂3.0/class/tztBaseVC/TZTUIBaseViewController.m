/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yangdl
 * 更新日期:
 * 整理修改:
 1、增加nsTitle字段，用于外部传入标题名称，不再使用原来的_nMsgType判断标题文字
 *
 ***************************************************************/
#import "TZTUIBaseViewController.h"
#import "tztMainViewController.h"
#import "tztListDetailView.h"


extern int  g_nToolbarHeight;
@implementation TZTUIBaseViewController

@synthesize toolBar;
@synthesize nMsgType = _nMsgType;
@synthesize pStockInfo = _pStockInfo;
@synthesize tztTitleView = _tztTitleView;
@synthesize tztBaseView = _tztBaseView;
@synthesize nsTitle = _nsTitle;
@synthesize bPopToRoot = _bPopToRoot;
@synthesize pParentVC = _pParentVC;
@synthesize shouldFixAnimation = _shouldFixAnimation;
@synthesize tztDelegate = _tztDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
       
    }
    return self;
}

- (void)dealloc
{
    if (_tztBaseView && _tztBaseView.superview)
        [_tztBaseView removeFromSuperview];
    self.navigationItem.titleView = NULL;   //??是否需要如此处理？？
    [super dealloc];
}

 - (void)viewDidLoad 
 {
#ifdef Support_HXSC
     self.hidesBottomBarWhenPushed = YES;
#endif
	 [super viewDidLoad];
     self.view.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
//     self.view.backgroundColor = [tztTechSetting getInstance].backgroundColor;
     /*增加基础view，所有的view视图都添加到改基础view上，保证界面显示*/
     [self LoadLayoutViewEx];
     _tztBaseView.backgroundColor = [UIColor tztThemeBackgroundColor];
//     _tztBaseView.backgroundColor = [tztTechSetting getInstance].backgroundColor;
     CGRect rcFrame = self.view.bounds;
#ifdef __IPHONE_7_0
     if (IS_TZTIOS(7))
     {
         self.edgesForExtendedLayout = UIRectEdgeNone;
         if (([self getVcShowKind] == tztvckind_Pop) && IS_TZTIPAD)
         {
         }
         else
         {
//             rcFrame.origin.y += TZTStatuBarHeight;
//             rcFrame.size.height -= TZTStatuBarHeight;
         }
     }
#endif
     
     if (_tztBaseView == nil)
     {
         _tztBaseView = [[tztBaseViewUIView alloc] initWithFrame:rcFrame];
         _tztBaseView.backgroundColor = [UIColor tztThemeBackgroundColor];
         //[tztTechSetting getInstance].backgroundColor;
         [self.view addSubview:_tztBaseView];
         [_tztBaseView release];
         [self.view sendSubviewToBack:_tztBaseView];
     }
     else
     {
         _tztBaseView.frame = rcFrame;
     }
     /*end*/
     
     UIImage * image = [UIImage imageTztNamed: @"TZTMainPBack.png"];
     if (image)
     {
         UIImageView* backgroundView = [[UIImageView alloc] initWithImage:image];
         backgroundView.tag = 0X1111;
         backgroundView.frame = CGRectMake(0.f, 0.f, TZTScreenWidth, TZTScreenHeight);
         backgroundView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
         [_tztBaseView addSubview:backgroundView];
         [backgroundView release];
     }
//     else
//     {
//         self.view.backgroundColor = [UIColor blackColor];
//     }
     if(_tztTitleView == nil)
     {
         _tztTitleView = [[TZTUIBaseTitleView alloc] init];
         _tztTitleView.pDelegate = self;
         [_tztBaseView addSubview:_tztTitleView];
         [_tztTitleView release];
     }
#ifndef tzt_NewVersion
     //可能继承的VC,没有实现CreateToolBar,在基类调用一下 modify by xyt 20130909
     [self CreateToolBar];
#endif
     
     if ([self getVcShowKind] == tztvckind_Pop)
     {
         if (IS_TZTIPAD)
         {
             _tztFrame = self.view.frame;
             _tztBounds = self.view.bounds;
         }
         else
         {
             _tztBounds = _tztBaseView.bounds;
             _tztFrame = _tztBaseView.frame;
         }
     }
     else
     {
         _tztBounds = _tztBaseView.bounds;
         _tztFrame = _tztBaseView.frame;
     }
     
     [self reloadTheme];
     //注册事件 通知 
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(OnChangeTheme)
                                                  name:TZTNotifi_ChangeTheme
                                                object:nil];
     
     //注册热点监听
     
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(OnStatusBarChange:)
                                                  name:UIApplicationWillChangeStatusBarFrameNotification
                                                object:nil];
     
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                              selector:@selector(OnStatusBarChange1:)
//                                                  name:UIApplicationDidChangeStatusBarFrameNotification
//                                                object:nil];
//     
//     [[NSNotificationCenter defaultCenter] addObserver:self
//                                              selector:@selector(OnStatusBarChange2:)
//                                                  name:UIApplicationStatusBarFrameUserInfoKey
//                                                object:nil];
////     
//     UIApplicationWillChangeStatusBarFrameNotification
//     UIApplicationDidChangeStatusBarFrameNotification;

 }


-(void)OnStatusBarChange:(id)sender
{
    return;
//    [self LoadLayoutViewEx];
//    _tztBaseView.frame = self.view.bounds;
//    if ([self getVcShowKind] == tztvckind_Pop)
//    {
//        if (IS_TZTIPAD)
//        {
//            _tztFrame = self.view.frame;
//            _tztBounds = self.view.bounds;
//        }
//        else
//        {
//            _tztBounds = _tztBaseView.bounds;
//            _tztFrame = _tztBaseView.frame;
//        }
//    }
//    else
//    {
//        _tztBounds = _tztBaseView.bounds;
//        _tztFrame = _tztBaseView.frame;
//    }
//    [self LoadLayoutView];
}


-(void)ChangeSubView:(UIView*)pView
{
    NSInteger nCount = [pView.subviews count];
    if (nCount >= 1)
    {
        for (int i = 0; i < [pView.subviews count]; i++)
        {
            UIView *pSubView = [pView.subviews objectAtIndex:i];
            if ([pView isKindOfClass:[UITableView class]])
            {
                [(UITableView*)pView reloadData];
            }
            [pView layoutSubviews];
            [pView setNeedsDisplay];
            
            [pSubView layoutSubviews];
            [pSubView setNeedsDisplay];
            
            [self ChangeSubView:pSubView];
        }
    }
    else
    {
        if ([pView isKindOfClass:[UITableView class]])
        {
            [(UITableView*)pView reloadData];
        }
        [pView layoutSubviews];
        [pView setNeedsDisplay];
    }
    
}

-(void)OnChangeTheme
{
    [self reloadTheme];
    for (int i = 0; i < [[self.tztBaseView subviews] count]; i++)
    {
        UIView *pView = [[self.tztBaseView subviews] objectAtIndex:i];
        [self ChangeSubView:pView];
//        if ([pView isKindOfClass:[UITableView class]])
//        {
//            [(UITableView*)pView reloadData];
//        }
//        [pView layoutSubviews];
//        [pView setNeedsDisplay];
    }
    [self LoadLayoutView];
}

- (void)reloadTheme
{
    //
    if (IS_TZTIOS(7))
    {
//        self.view.tintColor = _tztTitleView.backgroundColor;
//        self.view.backgroundColor = _tztTitleView.backgroundColor;//[UIColor tztThemeBackgroundColor];
    }
    self.view.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
    self.tztBaseView.backgroundColor = [UIColor tztThemeBackgroundColor];
    self.tztTitleView.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
    if (g_nThemeColor == 1)
    {
//        self.view.backgroundColor = [UIColor colorWithTztRGBStr:@"35,120,220"];
//        self.tztBaseView.backgroundColor = [UIColor colorWithTztRGBStr:@"35,120,220"];
//        self.tztTitleView.backgroundColor = [UIColor colorWithTztRGBStr:@"35,120,220"];
//        [self.tztTitleView.firstBtn setImage:tztBackWhiteImag forState:UIControlStateNormal];
    }
    else if (g_nThemeColor == 0)
    {
//        self.view.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
//        self.tztBaseView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
//        self.tztTitleView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
    }
}

- (void)onSetTztTitleView:(NSString*)strTitle type:(int)nType //设置标题
{
    if (_tztBaseView == NULL)
        return;
    CGRect rcTitle = _tztBounds;// self.view.bounds; //（0,0,320,431）
    rcTitle.size.height = TZTToolBarHeight;//(0,0,320,44)
    if (IS_TZTIOS(7))
    {
//        rcTitle.origin.y -= TZTStatuBarHeight;
        rcTitle.size.height += TZTStatuBarHeight;
    }
    if(_tztTitleView == nil)
    {
        _tztTitleView = [[TZTUIBaseTitleView alloc] init];
        _tztTitleView.pDelegate = self;
        [_tztBaseView addSubview:_tztTitleView];
        [_tztTitleView release];
    }
    _tztTitleView.nType = nType; //257
    if(strTitle) //设置1234
        [_tztTitleView setTitle:strTitle];
    _tztTitleView.frame = rcTitle; //(0,0,320,44)
}

- (void)onSetTztTitleViewFrame:(CGRect)rcFrame
{
    if (_tztTitleView)
    {
        CGRect rcTitle = self.view.bounds;
        rcTitle.size.height = TZTToolBarHeight;
        if (IS_TZTIOS(7))
        {
            //        rcTitle.origin.y -= TZTStatuBarHeight;
            rcTitle.size.height += TZTStatuBarHeight;
        }
        _tztTitleView.frame = rcTitle;
    }
}


- (void)setNMsgType:(NSInteger)nMsgType
{
    _nMsgType = nMsgType;
    if ([self getVcShowKind] == tztvckind_All && [[self getVcShowType] intValue] == 0) //所有tab都可以添加
    {
        [self setVcShowType:[NSString stringWithFormat:@"%d", tztVcShowTypeDif]];
    }
    else if([self getVcShowKind] == tztvckind_JY && [[self getVcShowType] intValue] == 0) //交易功能号替代类型
    {
        [self setVcShowType:[NSString stringWithFormat:@"%ld", (long)nMsgType]];
    }
    else if([self getVcShowKind] == tztvckind_ZX && [[self getVcShowType] intValue] == 0) //资讯不区分类型
    {
        [self setVcShowType:[NSString stringWithFormat:@"%d", tztVcShowTypeDif]];
    }
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:@""];
    self.nsTitle = [NSString stringWithFormat:@"%@", title];
    if(_tztTitleView)
    {
        [_tztTitleView setTitle:title];
    }
}

-(void)ShowHelperImageView
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (g_CallNavigationController)
        g_CallNavigationController.navigationBar.hidden = YES;
    if (g_navigationController)
        g_navigationController.navigationBar.hidden = YES;
//    self.hidesBottomBarWhenPushed  = NO;
#ifdef Support_HXSC
    self.hidesBottomBarWhenPushed = YES;
#endif
    if (toolBar)
        g_nToolbarHeight = toolBar.bounds.size.height;
    
    if (IS_TZTIOS(7))//处理ios7下弹出界面会上下移动的问题
    {
        if (/*self.hidesBottomBarWhenPushed && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7 &&*/ animated && self.navigationController) {
            self.shouldFixAnimation = YES;
        }
    }
    
    if ([self getVcShowKind] == tztvckind_Pop)
    {
        if (IS_TZTIPAD)
        {
            _tztFrame = self.view.frame;
            _tztBounds = self.view.bounds;
        }
        else
        {
            _tztBounds = _tztBaseView.bounds;
            _tztFrame = _tztBaseView.frame;
        }
    }
    else
    {
        _tztBounds = _tztBaseView.bounds;
        _tztFrame = _tztBaseView.frame;
    }
    
   
//    if (g_nThemeColor == 1)
//    {
//        [self.tztTitleView.firstBtn setImage:tztBackWhiteImag forState:UIControlStateNormal];
//    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (IS_TZTIOS(7))//处理ios7下弹出界面会上下移动的问题
    {
        if(self.shouldFixAnimation)
        {
            self.shouldFixAnimation = NO;
            CABasicAnimation *basic = (CABasicAnimation *)[self.view.superview.layer animationForKey:@"position"];
            if(!basic || ![basic isKindOfClass:[CABasicAnimation class]])
                return;
            if(![basic.fromValue isKindOfClass:[NSValue class]])
                return;
            CABasicAnimation *animation = [basic mutableCopy];
            CGPoint point = [basic.fromValue CGPointValue];
            point.y = self.view.superview.layer.position.y;
            animation.fromValue = [NSValue valueWithCGPoint:point];
            [self.view.superview.layer removeAnimationForKey:@"position"];
            [self.view.superview.layer addAnimation:animation forKey:@"position"];
            [animation release];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (self.presentedViewController || self.modalViewController)
//    {
//        [self presentModalViewController:self.presentedViewController animated:animated];
//    }
    
    [self LoadLayoutViewEx];
    CGRect rcFrame = self.view.bounds;
#ifdef __IPHONE_7_0
    if (IS_TZTIOS(7))
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        if (([self getVcShowKind] == tztvckind_Pop) && IS_TZTIPAD)
        {
        }
        else
        {
//            rcFrame.origin.y += TZTStatuBarHeight;
//            rcFrame.size.height -= TZTStatuBarHeight;
        }
    }
#endif
    _tztBaseView.frame = rcFrame;
    
    if (!IS_TZTIPAD)
    {
#ifndef tzt_NewVersion
        //查询界面的详细信息,切换到其他界面,返回会造成toolbar错误 modify by xyt 20130909
        //[self CreateToolBar];
#endif
    }
    else
    {
        [self CreateToolBar];
    }

#ifdef tzt_NewVersion
    tztUINavigationController *pNav = (tztUINavigationController*)self.navigationController;
    if (pNav &&[pNav isKindOfClass:[tztUINavigationController class]])
        [self setVcShowKind:pNav.nPageID];
    else
        [self setVcShowKind:tztHomePage];
#endif
    
    if ([self getVcShowKind] == tztvckind_Pop)
    {
        if (IS_TZTIPAD)
        {
            _tztFrame = self.view.frame;
            _tztBounds = self.view.bounds;
        }
        else
        {
            _tztBounds = _tztBaseView.bounds;
            _tztFrame = _tztBaseView.frame;
        }
    }
    else
    {
        _tztBounds = _tztBaseView.bounds;
        _tztFrame = _tztBaseView.frame;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

/*
 创建底部工具栏，若不需要工具栏，请到具体vc里进行空实现即可
 */
-(void)CreateToolBar
{
    CGRect rc = CGRectMake(0.0, _tztBaseView.frame.origin.y + _tztBaseView.frame.size.height - TZTToolBarHeight, self.view.bounds.size.width, TZTToolBarHeight);
    
    // zxl 20131016 修改了ipad toolbar的位子修改
    if (IS_TZTIPAD)
    {
        UIView *lastView = (UIView *) [_tztBaseView.subviews lastObject];
        if (lastView && [lastView isKindOfClass:[UIToolbar class]])
        {
            rc = lastView.frame;
        }else
        {
            CGRect lastrect = lastView.frame;
            rc.origin.y = lastrect.origin.y + lastView.frame.size.height;
            rc.size.width = lastrect.size.width;
        }
    }
    

    if (toolBar == nil)
	{
		toolBar = [[UIToolbar alloc]initWithFrame:rc];
		toolBar.barStyle = UIBarStyleBlackOpaque;
		[self.view addSubview:toolBar];
		[toolBar release];
	}
    else
    {
        toolBar.frame = rc;
    }
    [self.view bringSubviewToFront:toolBar];
}


// 底部工具栏更多变服务项 byDBQ20130730
-(BOOL)toolBarItemForContainService
{
    if ([g_pSystermConfig.hasServiceTool intValue] == 1) {
        return TRUE;
    }
    NSArray* pAy = [g_pSystermConfig.pDict objectForKey:@"TZTToolbarContainService"]; // 新配字段用于更多项变服务项 byDBQ20130730
    if (pAy && [pAy count] > 0)
    {
        [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
        return TRUE;
    }
    return FALSE;
}

-(void) OnCloseKeybord:(UIView *)pView
{
	[self OnCloseKeybord];
}

-(void) OnCloseKeybord
{
	NSArray* pAyView = [self.view subviews];
	for(int i = 0; i< [pAyView count]; i++)
	{
		UIView* pView = [pAyView objectAtIndex:i];
		if(pView && [pView isKindOfClass:[UIResponder class]]&&[pView isFirstResponder])
		{
			[pView resignFirstResponder];
		}
	}
}

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType delegate_:(id)delegate
{
	return [self showMessageBox:nsString nType_:nType nTag_:0 delegate_:delegate];
}

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag
{
	return [self showMessageBox:nsString nType_:nType nTag_:nTag delegate_:nil];
}

-(TZTUIMessageBox*) showMessageBox:(NSString*)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate
{
	return [self showMessageBox:nsString nType_:nType nTag_:nTag delegate_:delegate withTitle_:nil];
}

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle
{
	return [self showMessageBox:nsString nType_:nType nTag_:nTag delegate_:delegate withTitle_:nsTitle nsOK_:nil nsCancel_:nil];
}

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle nsOK_:(NSString*)nsOK nsCancel_:(NSString*)nsCacel
{
    
	if (nsTitle == nil || [nsTitle length] < 1)
	{
		nsTitle = self.title;
	}
	if (nsOK == nil || [nsOK length] < 1)
		nsOK = @"确定";
	if (nsCacel == nil || [nsCacel length] < 1)
		nsCacel = @"取消";
    
	if (nsTitle == nil || [nsTitle length] < 1)
	{
		nsTitle = self.title;
	}
	if (nsOK == nil || [nsOK length] < 1)
		nsOK = @"确定";
	if (nsCacel == nil || [nsCacel length] < 1)
		nsCacel = @"取消";
	
	CGRect appRect = [[UIScreen mainScreen] bounds];
	TZTUIMessageBox *pMessage = [[[TZTUIMessageBox alloc] initWithFrame:appRect nBoxType_:nType delegate_:delegate] autorelease];;
	pMessage.tag = nTag;
	//需要组织字符串
	pMessage.m_nsContent = [NSString stringWithString:nsString];
	[pMessage setButtonText:nsOK cancel_:nsCacel];
	pMessage.m_nsTitle = nsTitle;
	
	[pMessage showForView:g_navigationController.topViewController.view];
	return pMessage;
}

-(void) OnBackMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
	[TZTUIBaseVCMsg OnMsg:nMsgType wParam:wParam lParam:lParam];
}

// action sheet callback: maybe start a re-download on congress data
- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch ( buttonIndex )
	{
		case 0:
        {
			NSString * phoneNum = [modalView buttonTitleAtIndex:buttonIndex];//;
            [self OnMakePhoneCall:phoneNum];
        }
			break;
		case 1:
			break;
		default:
			break;
	}
}

- (void) OnMakePhoneCall:(NSString*)telePhoneNum
{
	// make a phone call!
	NSString *telStr = [[NSString alloc] initWithFormat:@"tel:%@",telePhoneNum]; 
    NSString *strUrl = [telStr stringByAddingPercentEscapesUsingEncoding:NSMacOSRomanStringEncoding];
	NSURL *telURL = [[NSURL alloc] initWithString:strUrl];
	[[UIApplication sharedApplication] openURL:telURL];
    
    [telStr release];
	[telURL release];
}

- (void)OnShowPhoneList:(NSString*)telphone
{
	UIActionSheet *contactAlert = nil;
    if(telphone == nil || [telphone length] <=0 )
        telphone = TZTDailPhoneNUM;
	contactAlert = [[UIActionSheet alloc] initWithTitle:@"拨打电话" 
											   delegate:self
                                      cancelButtonTitle:@"取消" 
								 destructiveButtonTitle:nil 
									  otherButtonTitles:telphone,nil];
	
	// use the same style as the nav bar
	contactAlert.actionSheetStyle = UIActionSheetStyleDefault;
	[contactAlert showInView:[UIApplication sharedApplication].keyWindow];
	[contactAlert release];
}

-(NSUInteger)supportedInterfaceOrientations
{
    if (IS_TZTIPAD)
    {
        //zxl 20130930 感觉这里没有什么用就去掉了
//        g_nScreenHeight = TZTScreenWidth - TZTStatuBarHeight - TZTToolBarHeight- TZTStatuBarHeight / 2;
//        g_nScreenWidth = TZTScreenHeight;
//        self.view.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
//        self.view.bounds = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
//        
//        [self LoadLayoutView];
//        
//        if (g_pToolBarView)
//        {
//            g_pToolBarView.frame = CGRectMake(0, g_nScreenHeight + TZTStatuBarHeight, g_nScreenWidth, TZTToolBarHeight + TZTStatuBarHeight / 2);
//        }
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
//#ifdef tzt_NewVersion
//        if (self.hidesBottomBarWhenPushed)
//        {
//            g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight;
////            g_pToolBarView.hidden = YES;
//        }
//        else
//        {
//            g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight - TZTToolBarHeight - TZTStatuBarHeight / 2;
////            g_pToolBarView.hidden = NO;
//        }
//#else
//        g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight;// - TZTToolBarHeight - TZTStatuBarHeight / 2;
//#endif
//        g_nScreenWidth = TZTScreenWidth;
//        self.view.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
//        self.view.bounds = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
//        
//        [self LoadLayoutView];
//        
//        if (g_pToolBarView)
//        {
//            g_pToolBarView.frame = CGRectMake(0, g_nScreenHeight + TZTStatuBarHeight, g_nScreenWidth, TZTToolBarHeight);
//        }
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    int nToolBarHeight = 49;// TZTToolBarHeight + TZTStatuBarHeight / 2;
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
//            if (self.parentViewController == nil)
//            {
//                g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight;
//            }
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
    [self LoadLayoutView];
    
    if (!g_nSupportLeftSide && !g_nSupportRightSide)
    {
#ifdef tzt_UseUserTool
        if (g_pToolBarView)
        {
            g_pToolBarView.frame = CGRectMake(0, g_nScreenHeight + TZTStatuBarHeight, g_nScreenWidth, TZTToolBarHeight + TZTStatuBarHeight / 2);
        }
#endif
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

-(void)LoadLayoutView
{
    
}

-(void)LoadLayoutViewEx
{
    //使用系统，默认49高度，不可修改
    int nToolBarHeight = 49;// TZTToolBarHeight + TZTStatuBarHeight / 2;
    if (IS_TZTIPAD)
        nToolBarHeight = 56;
    if (g_pSystermConfig && g_pSystermConfig.nToolBarHeight != 0)
        nToolBarHeight = g_pSystermConfig.nToolBarHeight;
 
    int nDirection = self.interfaceOrientation;
    if (IS_TZTIOS(6))
        nDirection = [self preferredInterfaceOrientationForPresentation];//[UIDevice currentDevice].orientation;
    
    
    if (nDirection == UIDeviceOrientationPortrait || nDirection == UIDeviceOrientationPortraitUpsideDown)
    {
        if (IS_TZTIPAD)
        {
            g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight - nToolBarHeight;
            g_nScreenWidth = TZTScreenWidth;
        }
        else
        {
#ifdef tzt_NewVersion
            if (self.hidesBottomBarWhenPushed || [self getVcShowKind] == tztvckind_Pop)
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
            CGFloat y = 0;
            if (self.parentViewController == nil && !IS_TZTIOS(7))
            {
                g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight;
                y = TZTStatuBarHeight;
            }
            if (IS_TZTIOS(7))
                self.view.frame = CGRectMake(0, y, g_nScreenWidth, g_nScreenHeight + TZTStatuBarHeight);
            else
                self.view.frame = CGRectMake(0, y, g_nScreenWidth, g_nScreenHeight);
        }
    }
    else//横屏
    {
        if (IS_TZTIPAD)
        {
#ifdef __IPHONE_8_0
            if (IS_TZTIOS(8))
            {
                g_nScreenHeight = TZTScreenHeight - TZTStatuBarHeight - nToolBarHeight;
                g_nScreenWidth = TZTScreenWidth;
            }
            else
            {
                g_nScreenHeight = TZTScreenWidth - TZTStatuBarHeight - nToolBarHeight;
                g_nScreenWidth = TZTScreenHeight;
            }
#else
                g_nScreenHeight = TZTScreenWidth - TZTStatuBarHeight - nToolBarHeight;
                g_nScreenWidth = TZTScreenHeight;
#endif
        }
        else
        {
            g_nScreenHeight = TZTScreenWidth - TZTStatuBarHeight/* - TZTToolBarHeight*/;
            g_nScreenWidth = TZTScreenHeight;
        }
        if (IS_TZTIOS(7))
            self.view.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight + TZTStatuBarHeight);
        else
            self.view.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
    }
}



-(void)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    
    NSInteger nTag = pBtn.tag;
    if (nTag == HQ_Menu_More)//更多
    {
        [self OnMore];
    }
    else if(nTag == HQ_Return)
    {
        [self OnReturnBack];
    }
    else if (nTag == TZTToolbar_Fuction_WithDraw)
    {
        tztListDetailView *pView = (tztListDetailView*)[_tztBaseView viewWithTag:0x2323];
        if (pView)
        {
            [pView OnReturnBack];
            return;
        }
    }
    else
    {
        [TZTUIBaseVCMsg OnMsg:nTag wParam:(NSUInteger)self.pStockInfo lParam:0];
    }
}

-(void)OnIpadSearchStock:(id)sender
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_SearchStock wParam:(NSUInteger)sender lParam:0];
}

//更多(根据各个vc不同，显示的更多也不一样，到各个vc单独处理)
-(void)OnMore
{
    //首先获取更多需要显示的东西
    if (g_pSystermConfig == NULL || g_pSystermConfig.pDict == NULL)
        return;
    
    tztToolbarMoreView *pMoreView = (tztToolbarMoreView*)[self.view viewWithTag:0x7878];
    if (pMoreView == NULL)
    {
        NSArray* pAy = [g_pSystermConfig.pDict objectForKey:@"TZTToolbarMoreDefault"];
        pMoreView = [[tztToolbarMoreView alloc] init];
        pMoreView.tag = 0x7878;
        pMoreView.nPosition = tztToolbarMoreViewPositionBottom;
        [pMoreView SetAyGridCell:pAy];
        pMoreView.frame = _tztBaseView.frame;
        pMoreView.pDelegate = self;
        [self.view addSubview:pMoreView];
        [pMoreView release];
    }
    else
    {
        [pMoreView removeFromSuperview];
    }
}

-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    [TZTUIBaseVCMsg OnMsg:cellData.cmdid wParam:(NSUInteger)self.pStockInfo lParam:0];
}


-(void)PopViewControllerDismiss
{
    if (_popoverVC)
    {
        [_popoverVC dismissPopoverAnimated:UseAnimated];
        [_popoverVC release];
        _popoverVC = NULL;
    }
}

-(void) PopViewController:(UIViewController*)pVC rect:(CGRect)rect
{
    if (pVC == NULL)
		return;
	
	if (_popoverVC != NULL)
	{
		[_popoverVC dismissPopoverAnimated:NO];
		[_popoverVC release];
		_popoverVC = NULL;
	}
	
    [pVC setVcShowKind:tztvckind_Pop];
    pVC.contentSizeForViewInPopover = rect.size;
	_popoverVC = [[UIPopoverController alloc] initWithContentViewController:pVC];
    _popoverVC.delegate = self;
    _popoverVC.popoverContentSize = rect.size;
    
    CGRect rc = rect;
    rc.size = CGSizeZero;
	
	@try {
		[_popoverVC presentPopoverFromRect:rc
								   inView:_tztBaseView
				 permittedArrowDirections:
         UIPopoverArrowDirectionAny
								 animated:YES];
	}
	@catch (NSException * e) {
		TZTLogError(@"PopViewController %@", [e description]);
		[_popoverVC release];
		_popoverVC = NULL;
	}
}

-(void) PopViewControllerWithoutArrow:(UIViewController*)pVC rect:(CGRect)rect
{
	if (pVC == NULL)
		return;
	
	if (_popoverVC != NULL  )
    {
		[_popoverVC dismissPopoverAnimated:NO];
		[_popoverVC release];
		_popoverVC = NULL;
	}
	
    [pVC setVcShowKind:tztvckind_Pop];
    //zxl 20131011 在显示界面的时候直接设置contentSizeForViewInPopover（所以在界面中不是特殊设置大小的地方就不用再设置了）
    pVC.contentSizeForViewInPopover = rect.size;
    _popoverVC = [[UIPopoverController alloc] initWithContentViewController:pVC];
    _popoverVC.delegate = self;
    _popoverVC.popoverContentSize = rect.size;
    CGRect  rcFrame = rect;
    rcFrame.size = CGSizeZero;
	@try {
		[_popoverVC presentPopoverFromRect:rcFrame
								   inView:_tztBaseView
				 permittedArrowDirections:0
								 animated:YES];
	}
	@catch (NSException * e) {
		TZTLogError(@"PopViewController %@", [e description]);
		
		[_popoverVC release];
		_popoverVC = NULL;
	}
	
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	return YES;
}

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	if (_popoverVC && _popoverVC == popoverController)
	{
		[_popoverVC release];
		_popoverVC = NULL;
	}
	return;
}

-(UIPopoverController*) PopViewController
{
    return _popoverVC;
}

//返回上页
-(void) OnReturnBack
{
/*****************返回规则 修改者务必注意 ****************
操作队列维护规则
1、加入操作队列g_ayPushedViewController规则，加入队列只有2个途径:
 a.PushVC（加入VC）.
 b.点击分类Tabar（清空原操作队列，加入对应分类TopVC，可能是rootVC）。
 c.调用分类功能，调用分类功能时，切换至该分类，清空该分类VC组（PopToRootVC），显示该分类rootVC，需手动加入rootVc至操作队列。
 
2、移除队列g_ayPushedViewController规则，移除队列有3个途径:
 a.PopVC（移除VC）.
 b.PopToRootVC（移除该分类的所有（除rootVC外）VC）。
 c.点击分类Tabbar（清空原操作队列，加入对应分类TopVC，可能是rootVC）。
 
返回处理规则：
1、如果有操作队列，必须处理操作队列，且从操作队列中移除最后一个VC，有移除操作队列VC，就有操作，就需要返回，不再继续后续处理。如果没有任何清除操作队列的操作，说明处理不完整，处理逻辑有问题。

2、不允许有popVC时，通过removeObject方式移除（PopVC时会处理操作队列）。
 
3、当前navigationController的VC队列，只有一个时，这个VC是RootVC，不允许popVC，从操作队列移除，切换下个显示VC的对应分类（千万记住第1条规则哦）。

4、没有操作队列，按当前分类处理。
 
分类切换规则
1.点击分类Tabbar切换到分类列，需清空队列，加入对应分类TopVC，可能是rootVC（记住操作队列从哪开始）

2.程序切换对应分类列，只是为了显示分类列的TopVC，不能加入队列。
******************************************************/
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (IS_TZTIPAD)
    {
        if (![g_navigationController popViewControllerAnimated:UseAnimated])
            [TZTUIBaseVCMsg IPadPopViewController:self.pParentVC];
        return;
    }
    
    tztListDetailView *pView = (tztListDetailView*)[_tztBaseView viewWithTag:0x2323];
    if (pView)
    {
        [pView OnReturnBack];
        return;
    }
    PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
    if (direction > 0)
    {
        if (direction == PPRevealSideDirectionLeft)
        {
            [[TZTAppObj getShareInstance].rootTabBarController.leftVC OnReturnBack];
        }
        else if (direction == PPRevealSideDirectionRight)
        {
            [[TZTAppObj getShareInstance].rootTabBarController.rightVC OnReturnBack];
        }
        return;
    }
//返回处理 记住规则
#ifdef tzt_NewVersion
    if (g_ayPushedViewController && [g_ayPushedViewController count] > 0)//有队列数据，肯定要清除队列数据的哦
    {
        UIViewController *pPopVC = [g_ayPushedViewController lastObject];
        if( pPopVC && [pPopVC isKindOfClass:[TZTUIBaseViewController class]] ) //如果是我们的baseVC 肯定能处理啦
        {
            if([g_ayPushedViewController count] > 1) //列表中超过1个VC
            {
                if([g_navigationController.viewControllers count] > 1)//不是rootVC，可以PopVC
                {
                    [g_navigationController popViewControllerAnimated:UseAnimated]; //PopVC 从队列清除
                }
                else //是rootVC，通过removeObject 
                {
                    [g_ayPushedViewController removeObject:pPopVC]; //从队列清除
                }
                UIViewController *pWillShowVC = [g_ayPushedViewController lastObject]; //移除后将要显示的VC
                if(pWillShowVC)//将要显示什么VC，看下是否需要切换到对应队列予以显示
                {
                    if([pWillShowVC isKindOfClass:[TZTUIBaseViewController class]] )
                    {
                        tztUINavigationController *ptempNav = (tztUINavigationController*)pWillShowVC.navigationController;
                        if( ptempNav.nPageID != g_navigationController.nPageID ) //不同的队列
                        {
                            [tztMainViewController didSelectNavController:ptempNav.nPageID options_:NULL];
                        }
                        return;
                    }
                    else //不是baseVC派生的
                    {
                        TZTLogInfo(@"这是什么第三方VC啊:%@",pWillShowVC);
                        return;
                    }
                }
                else //不是吧，没有了，不是有超过1个队列才进来的么，移除了一个，怎么就没了
                {
                    TZTLogInfo(@"返回处理出错啦，请检查下处理规则，有超过1个队列，移除了一个，怎么队列就没了");
                    [tztMainViewController didSelectNavController:tztvckind_Main options_:NULL];
                }
                return;
            }
            else //列表中只有1个VC 队列清空
            {
                NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
                if([g_navigationController.viewControllers count] > 1)//不是rootVC，可以PopVC
                {
//                    [g_navigationController popViewControllerAnimated:NO]; //PopVC 从队列清除,要切换到首页，不加载动画。
                    [g_navigationController popViewControllerAnimated:UseAnimated];
                }
                else //是rootVC，通过removeObject
                {
                    [g_ayPushedViewController removeObject:pPopVC]; //从队列清除
                }
                
                if([g_navigationController.viewControllers count] <= 1)
                {
                    [tztMainViewController didSelectNavController:[TZTAppObj getShareInstance].nStartType options_:NULL];
                }
                [thePool release];
                return;
            }
        }
    }
    //前面队列没处理过啊 继续处理
    if([g_navigationController.viewControllers count] <= 1) //独苗rootvc，切换到首页。
    {
        [g_ayPushedViewController removeLastObject]; //从队列清除
        [tztMainViewController didSelectNavController:tztvckind_Main options_:NULL];
        return;
    }
    else
#endif
    {
        UIViewController *pVC = g_navigationController.topViewController;
        if (!pVC) // 防止在moreNavigationController之上加载的view的close按钮没反应 byDBQ20130729
        {
            pVC = ((TZTAppObj*)[TZTAppObj getShareInstance]).rootTabBarController.moreNavigationController.topViewController;
        }
        if (pVC && [pVC isKindOfClass:[TZTUIBaseViewController class]])
        {
            [(TZTUIBaseViewController*)pVC PopViewControllerDismiss];
        }
        //返回，取消风火轮显示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [g_navigationController popViewControllerAnimated:UseAnimated]; //通过popVC清除队列
        UIViewController* pTop = g_navigationController.topViewController;
        if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
        {
            g_navigationController.navigationBar.hidden = NO;
            [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
        }
        return;
    }
}

-(NSMutableArray*)GetAyToolBar
{
#ifdef tzt_NewVersion
    if (_tztBaseView)
        return [_tztBaseView GetAyToolBar];
#else
    if (toolBar)
        return (NSMutableArray*)toolBar.items;
#endif
        
    return nil;
}


-(void) onSetToolBarBtn:(NSMutableArray*)ayBtn bDetail_:(BOOL)bDetail
{
    //创建之前删除按钮
    if (_tztBaseView)
        [_tztBaseView removeAllToolBar];
    if (bDetail)
    {
        [_tztTitleView setNType:TZTTitleDetail];
        [_tztTitleView setFrame:_tztTitleView.frame];
#ifdef tzt_NewVersion // 新版本去toolbar byDBQ20130718
#else
        [self CreateToolBar];
#endif
    
#ifdef tzt_NewVersion // 新版本改变样式 byDBQ20130718
        [tztUIBarButtonItem getTradeBottomItemByArray:ayBtn target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
        [tztUIBarButtonItem GetToolBarItemByArray:ayBtn delegate_:self forToolbar_:toolBar];
#endif
    }
    else
    {
        [_tztTitleView setNType:TZTTitleReport];
        [_tztTitleView setFrame:_tztTitleView.frame];
        [self CreateToolBar];
    }
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)SetToolbarHiddens:(BOOL)bHide
{
    return;
    if (g_pToolBarView)
    {
        CGRect menuBarFrame = g_pToolBarView.frame;
        
        CGFloat height = self.view.frame.size.height;
        
        int to;
        if(bHide)
        {
            to = height;
        }
        else
        {
            to = height - menuBarFrame.size.height;
        }
        if (menuBarFrame.origin.y != to)
        {
            if (UseAnimated)
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationDuration:0.2];
            }
            menuBarFrame.origin.y = to;
            g_pToolBarView.frame = menuBarFrame;
            if (UseAnimated)
            {
                [UIView commitAnimations];
            }
        }
    }
}


-(void)OnBtnClose
{
    UIViewController* pVC = g_navigationController.topViewController;
    if (!pVC) // 防止在moreNavigationController之上加载的view的close按钮没反应 byDBQ20130729
    {
        pVC = ((TZTAppObj*)[TZTAppObj getShareInstance]).rootTabBarController.moreNavigationController.topViewController;
    }
    
    TZTUIBaseViewController* pBottomVC = [TZTAppObj getTopViewController];
    
    if (pVC && [pVC isKindOfClass:[TZTUIBaseViewController class]] && [pBottomVC PopViewController])
    {
        [(TZTUIBaseViewController*)pVC PopViewControllerDismiss];
    }
    else
    {
        [g_navigationController popViewControllerAnimated:UseAnimated];
        //返回，取消风火轮显示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIViewController* pTop = g_navigationController.topViewController;
        if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
        {
            g_navigationController.navigationBar.hidden = NO;
            [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
        }
        //         [g_navigationController popViewControllerAnimated:UseAnimated];
    }
}

@end
