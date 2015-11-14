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

#import "tztUIAddAccountViewController.h"
#import "tztUITradeLogindViewController.h"
@implementation tztUIAddAccountViewController
@synthesize pAddAccountView = _pAddAccountView;
@synthesize pMsgInfo = _pMsgInfo;
@synthesize nLoginType = _nLoginType;

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
    if (_pMsgInfo)
        [_pMsgInfo release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self LoadLayoutView];
}

-(void) LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    if (IS_TZTIPAD)
    {
        _tztTitleView.nType = TZTTitleNormal;
        _tztTitleView.bHasCloseBtn = YES;
        _tztTitleView.bShowSearchBar = FALSE;
        [self onSetTztTitleView:@"账号管理" type:TZTTitleNormal];
    }
    else
    {
        [self onSetTztTitleView:@"账号管理" type:TZTTitleReport];
    }
   
    CGRect rcLogin = rcFrame;
    rcLogin.origin.y += self.tztTitleView.frame.size.height;
    rcLogin.size.height -= (self.tztTitleView.frame.size.height /*+ TZTToolBarHeight*/);
    if (_pAddAccountView == nil)
    {
        _pAddAccountView = [[tztAddAccountView alloc] init];
        _pAddAccountView.nLoginType = _nLoginType;
        _pAddAccountView.delegate = self;
        _pAddAccountView.frame = rcLogin;
        [_tztBaseView addSubview:_pAddAccountView];
        [_pAddAccountView setMsgID:_nMsgID MsgInfo:_pMsgInfo LPARAM:_lParam];
        [_pAddAccountView release];
        //添加账号界面的刷新请求放在第一次  注：国泰的添加账号有可能要去更新令牌然后再回到添加账号界面所以不能放在viewWillAppear中
        [_pAddAccountView OnRefreshData];
    }
    else
    {
        _pAddAccountView.frame = rcLogin;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
}

-(void)CreateToolBar
{
    
}

-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam
{
    _nMsgID = nID;
    _pMsgInfo = pMsgInfo;
    if (_pMsgInfo)
        [_pMsgInfo retain];
    _lParam = lParam;
}

-(void)OnPopSelf
{
#ifdef tzt_NewVersion
    [g_navigationController popViewControllerAnimated:UseAnimated];
//    BOOL bPush = FALSE;
//    tztUITradeLogindViewController *pVC = (tztUITradeLogindViewController *)gettztHaveViewContrller([tztUITradeLogindViewController class], tztvckind_Pop,[NSString stringWithFormat:@"%d", MENU_SYS_JYLogin], &bPush,TRUE);
//    [pVC retain];
//    if (IS_TZTIPAD)
//    {
//        TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
//        if (!pBottomVC)
//            pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
//        CGRect rcFrom = CGRectZero;
//        rcFrom.origin = pBottomVC.view.center;
//        rcFrom.size = CGSizeMake(500, 500);
//        [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
//    }
//    else if(bPush)
//    {
//
//        [pVC SetHidesBottomBarWhenPushed:YES];
//        [g_navigationController pushViewController:pVC animated:UseAnimated];
//    }
//    [pVC release];

#else
    [g_navigationController popViewControllerAnimated:UseAnimated];
    //返回，取消风火轮显示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIViewController* pTop = g_navigationController.topViewController;
    if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
    {
        g_navigationController.navigationBar.hidden = NO;
        [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
    }
#endif
}

-(void)OnReturnBack
{

    [TZTUIBaseVCMsg IPadPopViewController:self.pParentVC];
    [super OnReturnBack];
}
@end
