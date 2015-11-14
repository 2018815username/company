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

#import "tztUIServiceCenterViewController_iPad.h"
#import "tztWebViewController.h"
#import "tztSendToFriendView.h"
#import "tztTradeSearchView.h"
#import "tztServerSettingView.h"
#import "tztKLineSetView.h"
#import "tztHQSetView.h"
#import "tztUISysLoginView.h"
#import "tztCheckServerListView.h"
#ifdef tzt_TZKDSetting
#import "tztTZKDSettingView_iPad.h"
#endif
@implementation tztUIServiceCenterViewController_iPad
@synthesize pTableView = _pTableView;
@synthesize pContentView = _pContentView;
@synthesize nsMenuID = _nsMenuID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.nsMenuID = @"";
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self LoadLayoutView];
//    m_nType = Sys_Menu_SoftVersion;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)dealloc
{
    [super dealloc];
}


-(void)SetDefaultData
{
    if (_pTableView)
        [_pTableView SetMsgType:MENU_SYS_About];
}


-(void)LoadLayoutView
{
    
    CGRect rcFrame = _tztBounds;
    if (CGRectIsNull(rcFrame) || CGRectIsEmpty(rcFrame))
        return;
        NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"服务中心";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleNormal];
    _tztTitleView.nLeftViewWidth = 210;
    [_tztTitleView setFrame:_tztTitleView.frame];
    
    CGRect rcDetail = rcFrame;
    rcDetail.origin.y += _tztTitleView.frame.size.height;
    rcDetail.size.height -= _tztTitleView.frame.size.height;
    rcDetail.size.width = 210;
    
    if (_pTableView == NULL)
    {
        _pTableView = [[tztUITableListView alloc] initWithFrame:rcDetail];
        //zxl 20131012 修改了获取默认设置交易类型Plistfile
        NSString* Plistfile = @"tztSystemSetting";
        
        [_pTableView setPlistfile:Plistfile listname:@"TZTTradeGrid"];
        _pTableView.tztdelegate = self;
        _pTableView.bExpandALL = TRUE;
        _pTableView.isMarketMenu = NO;
        [_tztBaseView addSubview:_pTableView];
        _pTableView.backgroundColor = [UIColor colorWithTztRGBStr:@"37,37,37"];
        [_pTableView release];
    }
    else
    {
        _pTableView.frame = rcDetail;
        [_pTableView reloadData];
    }
    
    CGRect rcContent = rcFrame;
    rcContent.origin.y += _tztTitleView.frame.size.height;
    rcContent.size.height -= _tztTitleView.frame.size.height;
    rcContent.origin.x += _pTableView.frame.size.width;
    rcContent.size.width -= _pTableView.frame.size.width;
    if (_pContentView == NULL)
    {
        _pContentView = [[UIView alloc] initWithFrame:rcContent];
        [_tztBaseView addSubview:_pContentView];
        [_pContentView release];
    }
    else
        _pContentView.frame = rcContent;
    
    if (_pTableView)
        [_pTableView SetMsgType:MENU_SYS_About];
}

-(BOOL)tztUITableListView:(tztUITableListView *)pMenuView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString *)strMsgValue
{
    if (pMenuView == _pTableView)
    {
        if(nMsgType != 1234)
        {
            [self DealWithMenu:nMsgType nsParam_:nil pAy_:nil];
        }
    }
    return TRUE;
}

-(void)OnDealLoginSucc:(NSInteger)nMsgType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    [self DealWithMenu:nMsgType nsParam_:nil pAy_:nil];
}

-(void)OnDealLoginCancel:(NSInteger)nMsgType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (self.nsMenuID && _pTableView)
    {
//        [_pTableView setCurrentSelected:self.nsMenuID];
    }
}

-(void)DealWithMenu:(NSInteger)nMsgType nsParam_:(NSString *)nsParam pAy_:(NSArray *)pAy
{
    if(IsUserLogin(nMsgType) && [TZTUIBaseVCMsg SystermLogin:nMsgType wParam:0 lParam:0 delegate:self isServer:TRUE])
        return;
    switch (nMsgType)
    {
        case Sys_Menu_SoftVersion://版本信息
        case MENU_SYS_About:
        {
            if (m_nType == nMsgType)
                return;
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            NSString *strURL = [g_pSystermConfig.pDict objectForKey:@"tztAboutURL"];
            
            //判断是否打开本地网页 add by xyt 20130929
            if(strURL &&[strURL length] > 0)
            {
                _pContentView = [[tztBaseUIWebView alloc] initWithFrame:rcFrame];
                NSString* strUrl = [NSString stringWithFormat:strURL,[[tztlocalHTTPServer getShareInstance] port]];
                [((tztBaseUIWebView*)_pContentView) setWebURL:strUrl];
            }
            else
            {
                _pContentView = [[UIWebView alloc] initWithFrame:rcFrame];
                _pContentView.backgroundColor = [UIColor clearColor];
                [_pContentView setOpaque:NO];
                
                NSString* strtztHtml = [NSString stringWithFormat:@"%@",g_pSystermConfig.strAboutCopyright];
                NSString* strPath = GetTztBundlePath(@"tzthtmlblack",@"html",@"plist");
                if(strPath && [strPath length] > 0)
                {
                    NSString* strtztHtmlFormat = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
                    if(strtztHtmlFormat && [strtztHtmlFormat length] > 0)
                        strtztHtml = [NSString stringWithFormat:strtztHtmlFormat,self.title, g_pSystermConfig.strAboutCopyright];
                }
                [(UIWebView*)_pContentView loadHTMLString:strtztHtml baseURL:nil];
            }
            
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        case Sys_Menu_Contact://版本信息
        {
            if (m_nType == nMsgType)
                return;
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            _pContentView = [[UIWebView alloc] initWithFrame:rcFrame];
            _pContentView.backgroundColor = [UIColor clearColor];
            [_pContentView setOpaque:NO];
            NSURLRequest *pRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://3g.tzt.cn/help/tel.html"]];
            [(UIWebView*)_pContentView loadRequest:pRequest];
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        case Sys_Menu_SoftCZ://充值方式
        {
            
        }
            break;
        case MENU_SYS_YYBJiuJin://10353就近营业部
        {
            if (m_nType == nMsgType)
                return;
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            NSString* str = @"10062/?url=/sywgkh/mapsale.htm?gpsx=($tztgpsx)&gpsy=($tztgpsy)";
            [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:0];
        }
            break;
        case Sys_Menu_CheckServer: //服务器测速 5815
        case MENU_SYS_SerAddCheck:
        {
            if (m_nType == nMsgType)
                return;
            m_nType = nMsgType; // 避免下次服务中心没跳转 byDBQ20131018
            CGRect rcFrame;
            rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            _pContentView = [[tztCheckServerListView alloc] init];
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            _pContentView.frame = rcFrame;
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        case Sys_Menu_SendToFriend://好友推荐
        {
            CGRect rcFrame;
            rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            _pContentView = [[tztSendToFriendView alloc] init];
            
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            _pContentView.frame = rcFrame;
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        case Sys_Menu_MZTK://免责条款
        case MENU_SYS_Disclaimer:
        {
            //modify by xyt 20130731 修改免责条款多次点击闪屏问题
            if (m_nType == nMsgType)
                return;
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            _pContentView = [[UIWebView alloc] initWithFrame:rcFrame];
            //modify by xyt 20130731 修改免责条款多次点击闪屏问题
            _pContentView.backgroundColor = [UIColor clearColor];
            [_pContentView setOpaque:NO];
            
            NSString* strtztHtml = [NSString stringWithFormat:@"%@",g_pSystermConfig.strMZTK];
            NSString* strPath = GetTztBundlePath(@"tzthtmlblack",@"html",@"plist");
            if(strPath && [strPath length] > 0)
            {
                NSString* strtztHtmlFormat = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
                if(strtztHtmlFormat && [strtztHtmlFormat length] > 0)
                    strtztHtml = [NSString stringWithFormat:strtztHtmlFormat,self.title, g_pSystermConfig.strMZTK];
            }
            [(UIWebView*)_pContentView loadHTMLString:strtztHtml baseURL:nil];
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        case Sys_Menu_KLineSet://k线设置
        case MENU_SYS_System:
        {
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            _pContentView = [[tztKLineSetView alloc] initWithFrame:rcFrame];
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        case Sys_Menu_HQSet://行情设置
        {
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            _pContentView = [[tztHQSetView alloc] init];
            _pContentView.frame = rcFrame;
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        case Sys_Menu_QueryYXQ://有效期查询
        {
            //需要用户登录
            [tztUserData getShareClass];
            if (g_pSystermConfig && g_pSystermConfig.bNeedRegist)
            {
                //系统登录
                _pContentView = [[tztUISysLoginView alloc] init];
                ((tztUISysLoginView*)_pContentView).delegate = self;
                ((tztUISysLoginView*)_pContentView).bIsServiceVC = YES;
                NSString* strLogMobile = [tztKeyChain load:tztLogMobile];
                if (strLogMobile && [strLogMobile length] >= 11)
                {
                    [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                     target:(tztUISysLoginView*)_pContentView
                                                   selector:@selector(OnAutoLogin)
                                                   userInfo:NULL
                                                    repeats:NO];
                }
            }
            
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            _pContentView = [[tztTradeSearchView alloc] init];
            ((tztTradeSearchView*)_pContentView).delegate = self;
            _pContentView.frame = rcFrame;
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
            ((tztTradeSearchView*)_pContentView).nMsgType = nMsgType;
            [((tztTradeSearchView*)_pContentView) OnRequestData];
        }
            break;
        case Sys_Menu_TZKDSetting: // 快递设置 byDBQ20130812
        case MENU_SYS_ExpreSet:
        {
#ifdef tzt_TZKDSetting
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            _pContentView = [[tztTZKDSettingView_iPad alloc] init];
            _pContentView.frame = rcFrame;
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
#endif
        }
            break;
        case Sys_Menu_SetServer://服务器设置
        case MENU_SYS_SerAddSet:
        {
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            _pContentView = [[tztServerSettingView alloc] init];
            _pContentView.frame = rcFrame;
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        case Sys_Menu_ReRegist://重新激活
        case MENU_SYS_ReLogin:
        {
            [self showMessageBox:@"您确定要重新激活吗?"
                          nType_:TZTBoxTypeButtonBoth
                           nTag_:0x1111
                       delegate_:self
                      withTitle_:@"重新激活确认"];
            
           
        }
            break;
        case MENU_QS_QLSC_YYKH://齐鲁 预约开户 add by xyt 20131010
        {
            if (m_nType == nMsgType)
                return;
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            _pContentView = [[UIWebView alloc] initWithFrame:rcFrame];
            _pContentView.backgroundColor = [UIColor clearColor];
            [_pContentView setOpaque:NO];
            NSURLRequest *pRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.easysino.com/hall/ReservationsAccount.jsp"]];
            [(UIWebView*)_pContentView loadRequest:pRequest];
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        case MENU_QS_QLSC_YYT://齐鲁  营业厅
        {
            if (m_nType == nMsgType)
                return;
            m_nType = nMsgType;
            if (pAy && [pAy count] > 0)
            {
                self.nsMenuID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
            }
            CGRect rcFrame = _pContentView.frame;
            [_pContentView removeFromSuperview];
            
            _pContentView = [[UIWebView alloc] initWithFrame:rcFrame];
            _pContentView.backgroundColor = [UIColor clearColor];
            [_pContentView setOpaque:NO];
            NSURLRequest *pRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.easysino.com/branches/branches.html"]];
            [(UIWebView*)_pContentView loadRequest:pRequest];
            [_tztBaseView addSubview:_pContentView];
            [_pContentView release];
        }
            break;
        default:
            break;
    }
}

-(void)CreateToolBar
{
    
}

-(void)OnLoginSucc
{
    [self DealWithMenu:m_nType nsParam_:nil pAy_:nil];
}

- (void)onReRegist
{
    //清除本地数据
    [[tztUserData getShareClass] reSetUserData];
    [TZTUserInfoDeal SaveAndLoadLogin:FALSE nFlag_:0];
    
    [TZTUIBaseVCMsg OnMsg:MENU_SYS_UserLogin wParam:0 lParam:0];
//    //系统登录
//    tztUISysLoginViewController* pVC = [[tztUISysLoginViewController alloc] init];
//    pVC.delegate = self;
//    pVC.bIsServer = TRUE;
//    [pVC setMsgID:m_nType MsgInfo:(void*)0 LPARAM:0];
//    if (IS_TZTIPAD)
//    {
//        TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
//        CGRect rcFrom = CGRectZero;
//        if (!pBottomVC)
//            pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
//        rcFrom.origin = pBottomVC.view.center;
//        rcFrom.size = CGSizeMake(500, 500);
//        [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
//    }
//    else
//    {
//#ifdef tzt_NewVersion
//        [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
//#else
//        [g_navigationController pushViewController:pVC animated:UseAnimated];
//#endif
//    }
//    [pVC release];
//    return;
    
//    [TZTUIBaseVCMsg OnMsg:Sys_Menu_ReRegist wParam:0 lParam:0];
}

- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self onReRegist];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self onReRegist];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
