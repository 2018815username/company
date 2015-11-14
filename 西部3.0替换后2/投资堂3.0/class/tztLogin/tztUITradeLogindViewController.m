/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易登录vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUITradeLogindViewController.h"

@implementation tztUITradeLogindViewController
@synthesize pTradeLoginView = _pTradeLoginView;
@synthesize pMsgInfo = _pMsgInfo;
@synthesize lParam = _lParam;
@synthesize nLoginType = _nLoginType;
@synthesize bISHz = _bISHz;
@synthesize pDictLoginInfo = _pDictLoginInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.view.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
    self.tztBaseView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(500, 500);
    [self LoadLayoutView];
    
    //获取账号类型
    if (_pTradeLoginView)
    {
        [_pTradeLoginView OnRefreshData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

-(void)dealloc
{
    if (_pMsgInfo)
        [_pMsgInfo release];
//    if (_lParam)
//        [_lParam release];
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    if (IS_TZTIPAD)
    {
        _tztTitleView.bHasCloseBtn = YES;
        [self onSetTztTitleView:((_nLoginType == TZTAccountRZRQType) ? @"融资融券登录" : @"交易登录") type:TZTTitleNormal];
    }
    else
    {
#ifdef tzt_NewVersion
        [self onSetTztTitleView:((_nLoginType == TZTAccountRZRQType) ? @"融资融券登录" : @"交易登录") type:TZTTitleReturn];
#else
        [self onSetTztTitleView:((_nLoginType == TZTAccountRZRQType) ? @"融资融券登录" : @"交易登录") type:TZTTitleReport];
#endif
    }
    _tztTitleView.bShowSearchBar = FALSE;
    [_tztTitleView setFrame:_tztTitleView.frame];
    
    CGRect rcLogin = rcFrame;
    rcLogin.origin.y += _tztTitleView.frame.size.height;
#ifdef tzt_NewVersion
    rcLogin.size.height -=  _tztTitleView.frame.size.height;
#else
    rcLogin.size.height -=  _tztTitleView.frame.size.height * 2;
#endif
    if (_pTradeLoginView == nil)
    {
        _pTradeLoginView = [[tztTradeLoginView alloc] init];
        _pTradeLoginView.delegate = self;
        _pTradeLoginView.nLoginType = _nLoginType;
        _pTradeLoginView.bISHz = _bISHz;
        _pTradeLoginView.frame = rcLogin;
        [_tztBaseView addSubview:_pTradeLoginView];
        [_pTradeLoginView setMsgID:_nMsgID MsgInfo:self.pMsgInfo LPARAM:self.lParam];
        [_pTradeLoginView release];
    }
    else
    {
        _pTradeLoginView.frame = rcLogin;
    }
//#ifdef TZT_ZYData // 在loginview的底部添加两个按钮  byDBQ20130718
//    UIImage *pImage = [UIImage imageTztNamed:@"TZTButtonBackMiddle.png"];
//    
//    CGRect rcBtn = rcLogin;
//    rcBtn.origin.x = 15;
//    rcBtn.origin.y = 240;
//    rcBtn.size.width =  (rcFrame.size.width - rcBtn.origin.x*2 - 15 ) / 2;
//    rcBtn.size.height =  30;
//    
//    UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    pBtn.tag = 3842;
//    [pBtn setBackgroundImage:pImage forState:UIControlStateNormal];
//    pBtn.titleLabel.font = tztUIBaseViewTextFont(15.0f);
//    pBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [pBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [pBtn setTztTitle:@"添加账号"];
//    [pBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    pBtn.frame = rcBtn;
//    [_tztBaseView addSubview:pBtn];
//   
//    rcBtn.origin.x += (rcBtn.size.width +15);
//    
//    UIButton *pBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    pBtn2.tag = 3702;
//    [pBtn2 setBackgroundImage:pImage forState:UIControlStateNormal];
//    pBtn2.titleLabel.font = tztUIBaseViewTextFont(15.0f);
//    pBtn2.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [pBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [pBtn2 setTztTitle:@"模拟交易"];
//    [pBtn2 addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    pBtn2.frame = rcBtn;
//    [_tztBaseView addSubview:pBtn2];
//    
//#endif
    
    [self.view bringSubviewToFront:_tztTitleView];
#ifdef tzt_NewVersion // 新版本无toolbar
#else
    [self CreateToolBar];
#endif
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool|| IS_TZTIPAD)
        return;
    
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeLogin" delegate_:self forToolbar_:toolBar];
}

-(void)OnToolbarMenuClick:(id)sender
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    
    BOOL bDeal = FALSE;
    if (_pTradeLoginView)
    {
        bDeal = [_pTradeLoginView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return ;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_QuXiao:
        {
            [g_navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }

}

-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(void*)lParam
{
    _nMsgID = nID;
    _pMsgInfo = pMsgInfo;
    if (_pMsgInfo)
        [_pMsgInfo retain];
    self.lParam = lParam;
//    if (_lParam)
//        [_lParam retain];
}

-(void)OnMenuOK
{
    if (_pTradeLoginView)
        [_pTradeLoginView OnLogin];
}

-(void)OnMenuRefresh
{
    if (_pTradeLoginView)
        [_pTradeLoginView OnRefreshData];
}

#ifdef tzt_NewVersion
-(void)onButtonClick:(id)sender // 按钮相应事件
{
    UIButton *btn = (UIButton*)sender;
    [TZTUIBaseVCMsg OnMsg:btn.tag wParam:(NSUInteger)self.pStockInfo lParam:0];
}
#endif

-(void)OnReturnBack
{
//#ifdef tzt_NewVersion
//    [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
//#else
    [super OnReturnBack];
//#endif
}
@end
