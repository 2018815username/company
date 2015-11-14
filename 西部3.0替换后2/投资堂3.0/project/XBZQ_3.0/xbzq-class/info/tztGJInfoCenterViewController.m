/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯中心（iphone）
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztGJInfoCenterViewController.h"

@interface tztGJInfoCenterViewController()

@property(nonatomic,retain)UIView *pLeftView;
@property(nonatomic)BOOL bUserStockChanged;

@end

@implementation tztGJInfoCenterViewController
@synthesize pLeftView = _pLeftView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMessage:) name:@"tztGetPushMessage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUserStockChanged:) name:tztUserStockNotificationName object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.pWebView && _bUserStockChanged)
        [self.pWebView tztStringByEvaluatingJavaScriptFromString:@"GoBackOnLoad();"];
    
    _bUserStockChanged = NO;
}

-(void)OnUserStockChanged:(NSNotification*)notification
{
    if(notification)
    {
        if ([notification.name compare:tztUserStockNotificationName]==NSOrderedSame)//
        {
            _bUserStockChanged = YES;
        }
    }
}

-(void)OnContactUS:(id)sender
{
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}


-(void)GetMessage:(NSNotification*)noti
{
    NSInteger n = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (n > 0)
    {
        [self.tztTitleView.firstBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo+1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.tztTitleView.firstBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo.png"] forState:UIControlStateNormal];
    }
}


-(void)LoadLayoutView
{
    [super LoadLayoutView];
    [self onSetTztTitleView:@"资讯" type:TZTTitleIcon];
    self.pWebView.tztDelegate = self;
    
    [self.tztTitleView.fourthBtn setTztBackgroundImage:nil];
    [self.tztTitleView.fourthBtn setTztImage:nil];
    [self.tztTitleView.fourthBtn removeTarget:self.tztTitleView
                                      action:nil
                            forControlEvents:UIControlEventTouchUpInside];
    
//    CGRect rcFirst = self.tztTitleView.fourthBtn.frame;
//    rcFirst.origin.y = 0;
//    rcFirst.size.width = 60;
//    rcFirst.size.height = 44;
    //    self.tztTitleView.fourthBtn.frame = rcFirst;
    [self.tztTitleView.fourthBtn.titleLabel setFont:tztUIBaseViewTextFont(14)];
    self.tztTitleView.fourthBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.tztTitleView.fourthBtn setTztTitle:@"订阅"];
    [self.tztTitleView.fourthBtn addTarget:self
                                   action:@selector(OnDingYue)
                         forControlEvents:UIControlEventTouchUpInside];
    
    self.tztTitleView.fourthBtn.hidden = YES;
    
    /**/
    //增加左侧可拖动功能
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_tztTitleView];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_tztTitleView];
    CGRect rcLeft = CGRectMake(0, _tztTitleView.frame.size.height, 15, _tztBounds.size.height);
    if (_pLeftView == nil)
    {
        _pLeftView = [[UIView alloc] initWithFrame:rcLeft];
        _pLeftView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_pLeftView];
        [_pLeftView release];
    }
    else
    {
        _pLeftView.frame = rcLeft;
    }
    
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_pLeftView];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_pLeftView];
    
    [[TZTAppObj getShareInstance].rootTabBarController RefreshAddCustomsViews];
}

-(void)OnDingYue
{
    NSString* strUrl = @"10061/?url=/yjb/zx_choice.htm&&fullscreen=1";
    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strUrl lParam:0];
}

//-(BOOL)tztWebViewCanGoBack:(tztHTTPWebView *)webView
//{
//    if (webView != self.pWebView)
//        return NO;
//    if ([_pWebView canReturnBack])
//    {
//        self.tztTitleView.firstBtn.hidden = NO;
//    }
//    else
//    {
//        self.tztTitleView.firstBtn.hidden = YES;
//    }
//    return YES;
//}

//-(void)OnReturnBack
//{
//#ifdef tzt_NewVersion
//    if ([g_navigationController.viewControllers count] <=1)
//    {
//        [[TZTAppObj getShareInstance] tztAppObj:nil didSelectItemByPageType:tztHomePage options_:NULL];
//    }
//    else
//#endif
//        [super OnReturnBack];
//}

-(void)OnChangeTheme
{
    [self.pWebView RefreshWebView:-1];
    [super OnChangeTheme];
}
@end
