/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztWebInfoContentVC
 * 文件标识：
 * 摘    要：   网页打开资讯详情
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-06
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/
#import "tztWebInfoContentViewController.h"
//#import "tztUIBaseVCOtherMsg.h"
@interface tztWebInfoContentViewController ()

@end

@implementation tztWebInfoContentViewController
@synthesize nFirstType = _nFirstType;
@synthesize nSecondType = _nSecondType;
@synthesize nFullScreen = _nFullScreen;
@synthesize nsCurrenctURL = _nsCurrentURL;
@synthesize nsFirstURL = _nsFirstURL;
@synthesize nsSecondURL = _nsSecondURL;
@synthesize parentVC = _parentVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self LoadLayoutView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_pWebView)
        [_pWebView tztStringByEvaluatingJavaScriptFromString:_pWebView.strJsGoBack];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_nSecondType == 8)//快捷方式，需要刷新相应界面
    {
        NSString* strGoBackOnLoad = [NSString stringWithFormat:@"%@",_pWebView.strJsGoBack];
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_ChangeShortCut object:strGoBackOnLoad];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)DealNavButton:(UIButton*)button withType_:(int)nType bLeft_:(BOOL)bLeft
{
    [button setHidden:NO];
    
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    switch (nType)
    {
//        case 0://个股查询。默认
//        {
//            [button setBackgroundImage:[UIImage] forState:<#(UIControlState)#>]
////            [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn|TZTTitleSearch];
////            return;
//        }
//            break;
        case 0:
        case 1://右侧修改字体
        {
            //修改图片
            [button setBackgroundImage:[UIImage imageTztNamed:@"TZTNoAccount.png"] forState:UIControlStateNormal];
        }
            break;
        case 2://订阅
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@"tztNavBarBtnBg.png"] forState:UIControlStateNormal];
            [button setTztTitle:@"订阅"];
        }
            break;
        case 3://修改
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@"tztNavBarModify.png"] forState:UIControlStateNormal];
        }
            break;
        case 4://我要开户
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@"tztNavBarBtnBg.png"] forState:UIControlStateNormal];
            [button setTztTitle:@"我要开户"];
            CGRect frame = button.frame;
            int nWidth = frame.size.width;
            if (nType == _nSecondType)
                frame.origin.x -= (80 - nWidth);
            else
            frame.size.width = 80;
            button.frame =  frame;
        }
            break;
        case 5://在线客服
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@"tztNavBarBtnBg.png"] forState:UIControlStateNormal];
            [button setTztTitle:@"在线客服"];
            CGRect frame = button.frame;
            int nWidth = frame.size.width;
            if (nType == _nSecondType)
                frame.origin.x -= (80 - nWidth);
            frame.size.width = 80;
            button.frame =  frame;
        }
            break;
        case 6://筛选（文字）
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@"tztNavBarBtnBg.png"] forState:UIControlStateNormal];
            [button setTztTitle:@"筛选"];
        }
            break;
        case 7://筛选（图片）
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@""] forState:UIControlStateNormal];
        }
            break;
        case 10://返回
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@"TZTnavbarbackbg.png"] forState:UIControlStateNormal];
        }
            break;
        case 11://后退
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@"tztNavBarBtnBg.png"] forState:UIControlStateNormal];
            [button setTztTitle:@"退出"];
            CGRect frame = button.frame;
            frame.origin.y -= 6;
            frame.size.height = 35;
            button.frame = frame;
        }
            break;
        case 15://查看地图
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@"tztNavBarBtnBg.png"] forState:UIControlStateNormal];
            [button setTztTitle:@"查看地图"];
            CGRect frame = button.frame;
            int nWidth = frame.size.width;
            if (nType == _nSecondType)
                frame.origin.x -= (80 - nWidth);
            frame.size.width = 80;
            button.frame =  frame;
        }
            break;
        case 16://
        {
            [button setBackgroundImage:[UIImage imageTztNamed:@"tztNavBarBtnBg.png"] forState:UIControlStateNormal];
            [button setTztTitle:@"一键清除"];
            CGRect frame = button.frame;
            int nWidth = frame.size.width;
            if (nType == _nSecondType)
                frame.origin.x -= (80 - nWidth);
            frame.size.width = 80;
            button.frame =  frame;
        }
            break;
        case 8://快捷方式
        case 9://右侧没有按钮
        default:
        {
            [_tztTitleView.fourthBtn setHidden:YES];
        }
            break;
        case 98://自定义，图片名称
        {
            NSString* strPic = @"";
            if (bLeft)//左侧
                strPic = [self.dictWebParams objectForKey:@"firsttext"];
            else
                strPic = [self.dictWebParams objectForKey:@"secondtext"];
            if (strPic)
                [button setBackgroundImage:[UIImage imageTztNamed:strPic] forState:UIControlStateNormal];
        }
            break;
        case 99://自定义，文字，底图客户端默认
        {
            NSString* strText = @"";
            if (bLeft)//左侧
            {
                strText = [self.dictWebParams objectForKey:@"firsttext"];
            }
            else
                strText = [self.dictWebParams objectForKey:@"secondtext"];
            
            if (strText)
                [button setTztTitle:strText];
        }
            break;
    }
    
    //移除原有事件响应
    [_tztTitleView.fourthBtn removeTarget:_tztTitleView action:nil forControlEvents:UIControlEventAllEvents];
    //重新添加事件
    [_tztTitleView.fourthBtn addTarget:self action:@selector(OnToolbarMenuClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)DealTitleView
{
//    if (_nSecondType <= 0)
//        _nSecondType = 1;
    if (_nSecondType <= 0)
        [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn/*|TZTTitleSearch*/];
    else
        [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn|TZTTitleUser];
    if (_nSecondType > 0)
        [self DealNavButton:_tztTitleView.fourthBtn withType_:_nSecondType bLeft_:NO];
    if (_nFirstType > 0)
        [self DealNavButton:_tztTitleView.firstBtn withType_:_nFirstType bLeft_:YES];
    
    //调整区域
    if (_nFirstType == 99)
    {
        NSString* strTitle = [self.tztTitleView.firstBtn titleForState:UIControlStateNormal];
        if (strTitle.length > 3)
        {
            CGRect rcFirst = self.tztTitleView.firstBtn.frame;
            rcFirst.size.width = 100;
            self.tztTitleView.firstBtn.frame = rcFirst;
            self.tztTitleView.firstBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
    }
    
    if (_nSecondType == 99)
    {
        NSString* strTitle = [self.tztTitleView.fourthBtn titleForState:UIControlStateNormal];
        if (strTitle.length > 0)
        {
            CGRect rcFour = self.tztTitleView.fourthBtn.frame;
            rcFour.size.width = 100;
            rcFour.origin.x = self.tztTitleView.frame.size.width - 100 - 15;
            self.tztTitleView.fourthBtn.frame = rcFour;
            self.tztTitleView.fourthBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
    }
}

-(void)LoadLayoutView
{
    
    CGRect rcFrame = _tztBounds;//_tztBaseView.bounds;
    
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    
    [self DealTitleView];
    
    rcFrame = _tztBounds;//_tztBaseView.bounds;
    rcFrame.origin = CGPointZero;
    rcFrame.origin.y = _tztTitleView.frame.origin.y + _tztTitleView.frame.size.height;
    rcFrame.size.height -= rcFrame.origin.y;
    
//    CGRect rcFont = self.view.bounds;
//    rcFont.origin = CGPointZero;
//    rcFont.origin.y += _tztTitleView.frame.size.height + 2;
//    rcFont.size.height = self.view.bounds.size.height - (rcFont.origin.y);
//
//    rcFrame.origin.y -= TZTStatuBarHeight;
    if (_pWebView == nil)
    {
        _pWebView = [[tztWebView alloc] initWithFrame:rcFrame];
        _pWebView.tztDelegate = self;//.tztDelegate;
        _pWebView.tag = self.ViewTag;
        _pWebView.bblackground = NO;
        _pWebView.bScalesPageToFit = YES;
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
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
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
        NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
        [pAy addObject:@"tztFontSmall.png||75|"];
        [pAy addObject:@"tztFontMiddle.png||100|"];
        [pAy addObject:@"tztFontBig.png||125|"];
        pMoreView = [[tztToolbarMoreView alloc] init];
        pMoreView.tag = 0x7878;
        pMoreView.nPosition = tztToolbarMoreViewPositionTop;
        pMoreView.fCellHeight = 40;
        [pMoreView SetAyGridCell:pAy];
        pMoreView.pNineGridView.nsBackImage = nil;// [UIImage tztCreateImageWithColor:[UIColor tztThemeBackgroundColorTitle]]; //@"TZTnavbarbg.png";
        pMoreView.bgColor = [UIColor tztThemeBackgroundColorTitle];// [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTnavbarbg.png"]];
        pMoreView.frame = self.view.frame;//_tztBaseView.frame;
        pMoreView.pDelegate = self;
        [_tztBaseView addSubview:pMoreView];
        [pMoreView release];
    }
    else
    {
        [pMoreView removeFromSuperview];
    }
}

-(void)CreateToolBar
{
    
}

-(void)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return;
    NSInteger nTag = pBtn.tag;
    
    switch (nTag)
    {
        case HQ_MENU_UserInfo://处理字体
        {
            //需要根据type区分处理
            [self OnBtnClickDeal];
        }
            break;
        default:
        {
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:0 lParam:0];
        }
            break;
    }
}


 /**
 *	@brief	处理左上角返回按钮事件，网页可自定义
 *
 *	@return	无
 */
-(void)OnReturnBack
{
    if (self.parentVC && [self.parentVC respondsToSelector:@selector(OnDealReturn:)])
    {
        [self.parentVC OnDealReturn:self.dictWebParams];
    }
    
    if (self.parentVC)
    {
        [TZTUIBaseVCMsg IPadPopViewController:self.parentVC];
        return;
    }
    
    NSString* strFirstURL = @"";
    NSString* strFirstJS = @"";
    NSString* strFirstSys = @"";
    
    strFirstURL = [self.dictWebParams tztObjectForKey:@"firsturl"];
    if (!ISNSStringValid(strFirstURL))
        strFirstJS = [self.dictWebParams tztObjectForKey:@"firstjsfuncname"];
    if (!ISNSStringValid(strFirstJS) && !ISNSStringValid(strFirstURL))
        strFirstSys = [self.dictWebParams tztObjectForKey:@"firstsysfunction"];
    
    switch (_nFirstType)
    {
        case 98:
        case 99:
        {
            //优先级处理 url>JS>SYS，默认SYS放在URL里面，所以只处理URL和JS的优先级即可
            if(strFirstJS && strFirstJS.length > 0)//执行js
            {
                [self.pWebView tztStringByEvaluatingJavaScriptFromString:strFirstJS];
            }
            else
            {
                if (strFirstURL == NULL)
                {
                    [super OnReturnBack];
                    return;
                }
                if (strFirstURL && [strFirstURL hasPrefix:@"http://action:"] ) //处理action
                {
                    NSString* strAction = [strFirstURL substringFromIndex:[@"http://action:" length]];
                    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:0];
                }
                else
                {
                    NSString* str = [NSString stringWithFormat:@"10061/?type=9&&fullscreen=1&&url=%@",strFirstURL];
                    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:0];
                }
            }
        }
            break;
            
        default:
        {
            [super OnReturnBack];
            BOOL ClientIsTradeLogin = [[self.dictWebParams tztObjectForKey:@"clientistradelogin"] boolValue];
            if (ClientIsTradeLogin)
            {
                int nMsgID = [[self.dictWebParams tztObjectForKey:@"clientmsgid"] intValue];
                int wParam = [[self.dictWebParams tztObjectForKey:@"clientwparam"] intValue];
                int lParam = [[self.dictWebParams tztObjectForKey:@"clientlparam"] intValue];
                if (nMsgID > 0)
                {
                    TZTUIMessage *pMessage = NewObjectAutoD(TZTUIMessage);
                    pMessage.m_nMsgType = nMsgID;
                    pMessage.m_wParam = wParam;
                    pMessage.m_lParam = lParam;
//                    [[tztUIBaseVCOtherMsg getShareInstance] tztperformSelector:@"tztDoNextStep:" withObject:pMessage];
                }
            }
        }
            break;
    }
}
 /**
 *	@brief	右侧按钮事件处理
 *
 *	@return	无
 */
-(void)OnBtnClickDeal
//此处都是右侧都按钮处理
{
    NSString* strSecondURL = @"";
    NSString* strSecondJS = @"";
    NSString* strSecondSys = @"";
    
    strSecondURL = [self.dictWebParams tztObjectForKey:@"secondurl"];
    if (!ISNSStringValid(strSecondURL))
        strSecondJS = [self.dictWebParams tztObjectForKey:@"secondjsfuncname"];
    if (!ISNSStringValid(strSecondJS) && !ISNSStringValid(strSecondURL))
        strSecondSys = [self.dictWebParams tztObjectForKey:@"secondsysfunction"];
    
    switch (_nSecondType)
    {
        case 1://
        {
            [self OnMore];
        }
            break;
        case 6:
        {
            NSString * strURL = [tztlocalHTTPServer getLocalHttpUrl:self.nsSecondURL];
            [[TZTAppObj getShareInstance].rootTabBarController LoadWebURL:strURL bLeft_:NO];
            [[TZTAppObj getShareInstance].rootTabBarController ShowRightVC];
        }
            break;
        case 16://一键清楚
        {
            if (self.nsSecondURL && self.nsSecondURL.length > 0)
            {
                [self.pWebView tztStringByEvaluatingJavaScriptFromString:@"clearKey();"];
            }
        }
            break;
        case 98:
        case 99:
        {
            //优先级处理 url>JS>SYS，默认SYS放在URL里面，所以只处理URL和JS的优先级即可
            if(strSecondJS && strSecondJS.length > 0)//执行js
            {
                [self.pWebView tztStringByEvaluatingJavaScriptFromString:strSecondJS];
            }
            else
            {
                if ([strSecondURL hasPrefix:@"http://action:"] ) //处理action
                {
                    NSString* strAction = [strSecondURL substringFromIndex:[@"http://action:" length]];
                    if (self.parentVC)
                        [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:(NSUInteger)self];
                    else
                        [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:0];
                }
                else
                {
                    NSString* str = [NSString stringWithFormat:@"10061/?type=9&&fullscreen=1&&url=%@",strSecondURL];
                    if (self.parentVC)
                        [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:(NSUInteger)self];
                    else
                        [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:0];
                }
            }
        }
            break;
        default:
        {
            //优先级处理 url>JS>SYS，默认SYS放在URL里面，所以只处理URL和JS的优先级即可
            if(strSecondJS && strSecondJS.length > 0)//执行js
            {
                [self.pWebView tztStringByEvaluatingJavaScriptFromString:strSecondJS];
            }
            else
            {
                if ([strSecondURL hasPrefix:@"http://action:"] ) //处理action
                {
                    NSString* strAction = [strSecondURL substringFromIndex:[@"http://action:" length]];
                    if (self.parentVC)
                        [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:(NSUInteger)self];
                    else
                        [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:0];
                }
                else
                {
                    NSString* str = [NSString stringWithFormat:@"10061/?type=9&&fullscreen=1&&url=%@",strSecondURL];
                    if (self.parentVC)
                        [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:(NSUInteger)self];
                    else
                        [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:0];
                }
            }
//            if ([self.nsSecondURL hasPrefix:@"http://action:"] ) //处理action
//            {
//                NSString* strAction = [self.nsSecondURL substringFromIndex:[@"http://action:" length]];
//                [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strAction lParam:0];
//            }
//            else
//            {
//                NSString* str = [NSString stringWithFormat:@"10061/?type=9&&fullscreen=1&&url=%@",self.nsSecondURL];
//                [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:0];
//            }
        }
            break;
    }
}

-(void)tztWebView:(tztHTTPWebView *)webView withTitle:(NSString *)title
{
    NSString* strFile = @"tztFontSize";
    NSString* strURL = [strFile tztHttpfilepath];
    NSString* str = [NSString stringWithContentsOfFile:strURL encoding:NSUTF8StringEncoding error:nil];
    if (str && str.length > 0 && _nSecondType == 1)
    {
//        NSString* strJS = [str tztencodeURLString];
        [webView tztStringByEvaluatingJavaScriptFromString:str];
    }
    if (title.length < 1)
        title = g_pSystermConfig.strMainTitle;
    [super tztWebView:webView withTitle:title];
}

-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    if (cellData == NULL)
        return;
    
    NSInteger nSize = cellData.cmdid;
    if (nSize < 75 || nSize > 125)
        nSize = 100;
    NSString* str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'", (long)nSize];
    
    NSString* strJS = [str tztencodeURLString];
    //
    [self.pWebView tztStringByEvaluatingJavaScriptFromString:strJS];
}

- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [g_navigationController popViewControllerAnimated:YES];
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
                [g_navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
