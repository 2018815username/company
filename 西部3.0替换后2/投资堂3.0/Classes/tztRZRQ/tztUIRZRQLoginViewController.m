//
//  tztUIRZRQLoginViewController.m
//  tztMobileApp_xcsc
//
//  Created by x yt on 13-4-11.
//  Copyright (c) 2013年 11111. All rights reserved.
//

#import "tztUIRZRQLoginViewController.h"

@implementation tztUIRZRQLoginViewController
@synthesize pLoginView = _pLoginView;
@synthesize pMsgInfo = _pMsgInfo;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self LoadLayoutView];
    
    //请求用户数据
    if (_pLoginView)
    {
        [_pLoginView OnRefreshData];
    }
}

-(void)dealloc
{
    if (_pMsgInfo)
        [_pMsgInfo release];
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    if (IS_TZTIPAD)
    {
        [self onSetTztTitleView:@"融资融券登录" type:TZTTitleNormal|TZTTitleReturn];
        _tztTitleView.bHasCloseBtn = YES;
    }
    else
    {
        [self onSetTztTitleView:@"融资融券登录" type:TZTTitleReport];
    }
    
    CGRect rcLogin = rcFrame;
    rcLogin.origin.y += _tztTitleView.frame.size.height;
    if (g_pSystermConfig.bShowbottomTool)
        rcLogin.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    else
        rcLogin.size.height -= (_tztTitleView.frame.size.height);
    if (_pLoginView == nil)
    {
        _pLoginView = [[tztRZRQLoginView alloc] init];
        _pLoginView.delegate = self;
        _pLoginView.frame = rcLogin;
        [_tztBaseView addSubview:_pLoginView];
        [_pLoginView setMsgID:_nMsgID MsgInfo:self.pMsgInfo LPARAM:_lParam];
        [_pLoginView release];
    }
    else
    {
        _pLoginView.frame = rcLogin;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeLogin" delegate_:self forToolbar_:toolBar];
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pLoginView)
    {
        bDeal = [_pLoginView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam
{
    _nMsgID = nID;
    _pMsgInfo = pMsgInfo;
    if (_pMsgInfo)
        [_pMsgInfo retain];
    _lParam = lParam;
}

-(void)OnMenuOK
{
    if (_pLoginView)
        [_pLoginView OnLogin];
}

-(void)OnMenuRefresh
{
    if (_pLoginView)
        [_pLoginView OnRefreshData];
}
@end
