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

#import "tztWebViewController.h"
#ifdef tzt_ChaoGen
#import "tztChaoGenKLineView.h"
#endif

@implementation tztWebViewController
@synthesize pWebView = _pWebView;
@synthesize nsURL = _nsURL;
@synthesize nWebType = _nWebType;
@synthesize nHasToolbar = _nHasToolbar;
@synthesize tztDelegate = _tztDelegate;
@synthesize ViewTag = _ViewTag;
@synthesize bQianShu = _bQianShu;
@synthesize dictWebParams = _dictWebParams;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        _nHasToolbar = 1;
        if (IS_TZTIPAD)
        {
            _nTitleType = TZTTitleReturn|TZTTitleNormal;
        }
        else
        {
            _nTitleType = TZTTitleReport;
#ifdef TZT_JYSC
            _nTitleType = TZTTitleReturn;
#endif
        }
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
//    self.contentSizeForViewInPopover = CGSizeMake(500, 500);
    [self LoadLayoutView];
}

- (void)viewDidUnload
{
    NilObject(self.pWebView);
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IS_TZTIPAD)
    {
//        self.contentSizeForViewInPopover = CGSizeMake(500, 500);
        [self LoadLayoutView];
    }
    
//    [self LoadLayoutView];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!IS_TZTIPAD)
        [super viewDidAppear:animated];//????此处暂时先注释，pad版本弹出会导致右侧的关闭按钮失效，原因待查
//    [self LoadLayoutView];
}

-(void)dealloc
{
    NilObject(self.nsURL);
    NilObject(self.nsTitle);
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
 
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    if (IS_TZTIPAD) // 解决F9、F10关闭按钮没反应问题 和 投资快递、在线客服底部工具栏不显示问题 byDBQ20130726
    {
        _tztBaseView.frame = rcFrame; // _tztBaseView的区域和self.view一致，之前是横竖屏颠倒的
    }
    
    if (_nWebType == tztwebChaoGen)
    {
        if (!IS_TZTIPAD)
            _nTitleType = TZTTitleReturn;
#ifndef tzt_NewVersion
        if (!IS_TZTIPAD)
            _nHasToolbar = YES;
        else
            _nHasToolbar = NO;
#else
        _nHasToolbar = NO;
#endif
        [self onSetTztTitleView:self.nsTitle type:_nTitleType];
        _tztTitleView.bHasCloseBtn = YES;
    }
    else if(_nWebType == tztWebChaoGenSet)
    {
        _nTitleType = TZTTitleReturn;
        [self onSetTztTitleView:self.nsTitle type:_nTitleType];
    }
    else if (_nWebType == tztWebOnline)
    {
        _tztTitleView.bHasCloseBtn = YES;//带右侧的关闭按钮
        _nTitleType = TZTTitleReturn;
        [self onSetTztTitleView:self.nsTitle type:_nTitleType];
    }
    else if (_nMsgType == MENU_JY_DKRY_Index)
    {
        _nTitleType = TZTTitleDKRY;
        [self onSetTztTitleView:self.nsTitle type:_nTitleType];
    }
    else
    {
        [self onSetTztTitleView:self.nsTitle type:_nTitleType];
    }
    
    if (IS_TZTIPAD)
    {
        _tztTitleView.bHasCloseBtn = YES;//带右侧的关闭按钮
        _tztTitleView.pSearchBar.hidden = YES;
        [_tztTitleView setFrame:_tztTitleView.frame];
    }
    
    rcFrame = _tztBaseView.bounds;
    rcFrame.origin = CGPointZero;
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    
    if (_nMsgType == MENU_JY_DKRY_Index)
    {
        CGRect rc = _tztTitleView.fourthBtn.frame;
        [_tztTitleView.fourthBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [_tztTitleView.fourthBtn removeTarget:_tztTitleView action:NULL forControlEvents:UIControlEventAllEvents];
        [_tztTitleView.fourthBtn setBackgroundImage:[UIImage imageTztNamed:@"tztNavBarBtnBg.png"] forState:UIControlStateNormal];
        [_tztTitleView.fourthBtn addTarget:self action:@selector(OnFunction:) forControlEvents:UIControlEventTouchUpInside];
        [_tztTitleView.fourthBtn.titleLabel setFont:tztUIBaseViewTextFont(14.0f)];
        [_tztTitleView.fourthBtn setTztTitle:@"功能"];
        _tztTitleView.fourthBtn.frame = rc;
    }
//#ifdef tzt_NewVersion // 去掉toolBar byDBQ20130715
//    _nHasToolbar = NO;
//#endif
    
    if (_nHasToolbar)
        rcFrame.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    else
        rcFrame.size.height -= _tztTitleView.frame.size.height;
    if (_pWebView == nil)
    {
        _pWebView = [[tztWebView alloc] initWithFrame:rcFrame];
#ifdef Support_HTSC
        _pWebView.clBackground = [UIColor whiteColor];
        _pWebView.bblackground = FALSE;
#endif
        
        _pWebView.clBackground = [UIColor tztThemeBackgroundColor];
        if (g_nThemeColor == 1) {
            _pWebView.bblackground = FALSE;
        }
        
//        self.pWebView.scalesPageToFit = YES;
//      self.pWebView.multipleTouchEnabled = YES;
//        _pWebView.delegate = self;
        
        //ZXL 20130718 赋值添加（用户界面区分、功能回调、网页签署功能）
        _pWebView.tztDelegate = self;//.tztDelegate;
        _pWebView.tag = self.ViewTag;
        _pWebView.bQianShu = _bQianShu;
        _pWebView.nWebType = _nWebType;
        if (self.nsURL)
        {
            if(_nWebType == tztWebLoadHtml)
            {
                [_pWebView LoadHtmlData:self.nsURL];
            }
            else
            {
                [_pWebView setWebURL:self.nsURL];
            }
        }
        [_tztBaseView addSubview:_pWebView];
        [_pWebView release];
    }
    else
        _pWebView.frame = rcFrame;
    
    [self CreateToolBar];
}

//设置网页地址
-(void)setWebURL:(NSString *)nsURL
{
    if (nsURL && [nsURL length] > 0)
        self.nsURL = [NSString stringWithFormat:@"%@", nsURL];
    if (![self.nsURL hasPrefix:@"http://"] && ![self.nsURL hasPrefix:@"https://"])
    {
        self.nsURL = [NSString stringWithFormat:@"http://%@", nsURL];
    }
    if (_pWebView)
    {
        [_pWebView setWebURL:nsURL];
    }
}

-(void)setLocalWebURL:(NSString*)nsURL
{
    NSURL* url = [NSURL URLWithString:nsURL];
    self.nsURL = [NSString stringWithFormat:@"%@", url];
    if (_pWebView)
        [_pWebView setLocalWebURL:self.nsURL];
}

//直接加载静态网页格式
-(void)LoadHtmlData:(NSString*)nsHTML
{
    self.nWebType = tztWebLoadHtml;
    self.nsURL = [NSString stringWithFormat:@"%@", nsHTML];
    NSString* strPath = GetTztBundlePath(@"tzthtmlblack",@"html",@"plist");
    if (g_nThemeColor >= 1 || g_nSkinType >= 1)
    {
        strPath = GetTztBundlePath(@"tzthtmlwhite", @"html", @"plist");
    }
    if(strPath && [strPath length] > 0)
    {
        NSString* strtztHtml = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
        if(strtztHtml && [strtztHtml length] > 0)
            self.nsURL = [NSString stringWithFormat:strtztHtml,self.title, nsHTML];
    }
    if (_pWebView)
    {
        [_pWebView LoadHtmlData:self.nsURL];
    }
}

-(void)setTitle:(NSString *)title
{
//    NSString *strtitle = self.nsTitle;  // nsTitle is there
    [super setTitle:title]; // over this step, nsTitle is gone. so,,,, get it before this step
    if (title && [title length] > 0)
    {
        self.nsTitle = [NSString stringWithFormat:@"%@", title];
        if(_tztTitleView)
        {
            [_tztTitleView setTitle:title];
        }
    }
    else {
        [_tztTitleView setTitle:g_pSystermConfig.strMainTitle];
    }
}

-(void)CreateToolBar
{
    if (!_nHasToolbar)
        return;
    
#ifndef tzt_NewVersion
    [super CreateToolBar];
#else 
    if (_nWebType == tztwebChaoGen)
        return;
#endif
    NSMutableArray *pAy = NewObject(NSMutableArray);
    if (_nWebType == tztWebOnline)
    {
        //zxl 20130730 修改了客服热线 工具条
        [pAy addObject:@"常见问题|3314"];
        [pAy addObject:@"全部提问|3307"];
        [pAy addObject:@"我的提问|3308"];
        [pAy addObject:@"客服热线|3309"];
    }
    else if(_nWebType == tztWebMessage)
    {
        if (IS_TZTIPAD)
        {
            [pAy addObject:@"收件箱|3210"];
            [pAy addObject:@"收藏夹|3211"];
        }
        else
        {
            [pAy addObject:@"首页|3200"];
            [pAy addObject:@"收件箱|3210"];
            [pAy addObject:@"收藏夹|3211"];
            [pAy addObject:@"关闭|1234"];
        }
    }
    else if(_nWebType == tztWebInBox)
    {
        if (IS_TZTIPAD)
        {
            [pAy addObject:@"快递|3209"];
            [pAy addObject:@"清空|6803"];
        }
        else
        {
            [pAy addObject:@"首页|3200"];
            [pAy addObject:@"快递|3209"];
            [pAy addObject:@"清空|6803"];
            [pAy addObject:@"关闭|1234"];
        }
    }
    else if(_nWebType == tztWebCollect)
    {
        if (IS_TZTIPAD)
        {
            [pAy addObject:@"快递|3209"];
            [pAy addObject:@"清空|6803"];
        }
        else
        {
            [pAy addObject:@"首页|3200"];
            [pAy addObject:@"快递|3209"];
            [pAy addObject:@"清空|6803"];
            [pAy addObject:@"关闭|1234"];
        }
    }
    else if(_nWebType == tztwebChaoGen)
    {
        if (!IS_TZTIPAD)
        {
            [pAy addObject:@"首页|3200"];
            [pAy addObject:@"自选|3202"];
            [pAy addObject:@"预警|3701"];
            [pAy addObject:@"资讯|3601"];
            [pAy addObject:@"交易|3818"];
            [pAy addObject:@"服务|5801"];
        }
    }
    else if(_nWebType == tztWebSelect)
    {
        [pAy addObject:@"签署|6818"];
        [pAy addObject:@"取消|1234"];
    }
    else
    {
        [pAy addObject:@"首页|3200"];
        [pAy addObject:@"关闭|1234"];
    }
    
//#ifdef tzt_NewVersion
    if (_nHasToolbar)
    {
        if (!IS_TZTIPAD)
            [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
        else
//#else
//    if (_nHasToolbar)
//    {
        [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    }
//    }
//#endif
    [pAy release]; // Avoid potential leak.  byDBQ20131031
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    bDeal = [_pWebView OnToolbarMenuClick:sender];
    if (bDeal)
        return;
    [super OnToolbarMenuClick:sender];
}


//炒跟设置按钮
-(void)OnSetButton:(id)sender
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_ChaoGenSet wParam:0 lParam:0];
}

-(void)tztWebView:(tztBaseUIWebView *)webView withTitle:(NSString *)title
{
    if(_pWebView && webView == _pWebView)
    {
        if(title && [title length] > 0)
        {
            self.nsTitle = [NSString stringWithFormat:@"%@",title];
            if (_tztTitleView)
            {
                [_tztTitleView setTitle:title];
            }
        }
        else
        {
            [_tztTitleView setTitle:g_pSystermConfig.strMainTitle]; // important and good for title corrected
#ifdef TZT_JYSC
            [_tztTitleView setTitle:self.nsTitle];
#endif
        }
//            [self setTitle:title];
    }
}

-(void)DealToolClick:(id)Sender
{
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(DealToolClick:)])
    {
        [_tztDelegate DealToolClick:Sender];
    }
}

-(void)DoSendFXCP:(int)nSocre
{
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(DoSendFXCP:)])
    {
        [_tztDelegate DoSendFXCP:nSocre];
    }
}

-(BOOL)tztWebViewIsRoot:(tztBaseUIWebView*)webView
{
    NSString* vcShowType = [self getVcShowType];
    if ([vcShowType intValue] == tztVcShowTypeRoot)
        return TRUE;
    return FALSE;
}

-(void)OnReturnBack
{
    if (self.pWebView && [self.pWebView OnReturnBack] && _nMsgType != HQ_MENU_GTJAYYKH)
    {
        [self setTitle:[_pWebView getWebTitle]]; // why set title on this step? Kidding, it's the tittle from the pushed view, I want the tittle of this web
        return;
    }
    else
    {
#ifdef tzt_NewVersion
        if (self.pParentVC)
        {
            [TZTUIBaseVCMsg IPadPopViewController:self.pParentVC];
        }
        else
        {
            [super OnReturnBack];
        }
#else
        [super OnReturnBack];
#endif
    }
}

-(void)CleanWebURL
{
    if (_pWebView)
    {
        CGRect webRect = _pWebView.frame;
        [_pWebView removeFromSuperview];
        _pWebView = NULL;
        
        _pWebView = [[tztWebView alloc] initWithFrame:webRect];
        _pWebView.nWebType = _nWebType;
        _pWebView.tztDelegate = self;
        [_tztBaseView addSubview:_pWebView];
        [_pWebView release];
    }
}

-(void)setRiskSign:(NSString*)nsSign
{
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(setRiskSign:)])
    {
        [_tztDelegate setRiskSign:nsSign];
    }
}

-(BOOL)IsHaveWebView
{
    if (_pWebView)
        return [_pWebView IsHaveWebView];
    return FALSE;
}

-(void)OnFunction:(id)sender
{
    [TZTUIBaseVCMsg OnMsg:MENU_JY_DKRY_List wParam:0 lParam:0];
}
@end
