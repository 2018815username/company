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

#import "tztUISysLoginViewController.h"
#import "tztUITradeLogindViewController.h"

@interface tztUISysLoginViewController(tztPrivate)
-(void)OnLogin;
-(void)OnSendMessage;
@end

@implementation tztUISysLoginViewController
@synthesize pLoginView = _pLoginView;
@synthesize pMsgInfo = _pMsgInfo;
@synthesize delegate = _delegate;
@synthesize bIsServer = _bIsServer;

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
    
    [self LoadLayoutView];
    
    if (g_CurUserData.nsMobileCode && [g_CurUserData.nsMobileCode length] >= 11)
    {
        [_pLoginView setControlEnable:NO];
        [NSTimer scheduledTimerWithTimeInterval:0.2f
                                         target:_pLoginView
                                       selector:@selector(OnAutoLogin)
                                       userInfo:NULL
                                        repeats:NO];
    }
    else
    /* */
    {
        [_pLoginView setControlEnable:YES];
        _pLoginView.pImageView.hidden = YES;

    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self LoadLayoutView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self LoadLayoutView];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(OnDealLoginSucc:wParam_:lParam_:)])
        {
            [_delegate OnDealLoginSucc:_nMsgID wParam_:(NSUInteger)self.pMsgInfo lParam_:_lParam];
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(OnDealLoginCancel:wParam_:lParam_:)])
        {
            [_delegate OnDealLoginCancel:_nMsgID wParam_:(NSUInteger)self.pMsgInfo lParam_:_lParam];
        }
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
    {
        [_pMsgInfo release];
        _pMsgInfo = nil;
    }
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    
    //标题view
     //zxl 20131017 ipad 不要返回按钮
    if (IS_TZTIPAD)
        [self onSetTztTitleView:g_pSystermConfig.strMainTitle type:TZTTitleNormal];  
    else
        [self onSetTztTitleView:g_pSystermConfig.strMainTitle type:TZTTitleReturn|TZTTitleNormal];
    _tztTitleView.bHasCloseBtn = IS_TZTIPAD;
    
    CGRect rcLogin = rcFrame;
    rcLogin.origin.y += _tztTitleView.frame.size.height;
    
#ifdef tzt_NewVersion
    rcLogin.size.height = rcFrame.size.height - _tztTitleView.frame.size.height;
#else
    rcLogin.size.height -= _tztTitleView.frame.size.height;
#endif
    
    if (_pLoginView == NULL)
    {
        _pLoginView = [[tztUISysLoginView alloc] init];
        _pLoginView.delegate = self;
        _pLoginView.frame = rcLogin;
        [_tztBaseView addSubview:_pLoginView];
        [_pLoginView release];
    }
    else
        _pLoginView.frame = rcLogin;
}

-(void)CreateToolBar
{
    
}

-(void)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag) 
    {
        case TZTToolbar_Fuction_OK:
        {
            if (_pLoginView)
                [_pLoginView OnLogin];
            return;
        }
    }
    
    [super OnToolbarMenuClick:sender];
}

//记录页面功能，用于页面跳转
-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pInfo LPARAM:(NSUInteger)lParam
{
    _nMsgID = nID;
    _pMsgInfo = pInfo;
    if (_pMsgInfo)
        [_pMsgInfo retain];
    _lParam = lParam;
}
//
//-(void)OnButton:(id)sender
//{
//    UIButton *pBtn = (UIButton*)sender;
//    switch (pBtn.tag)
//    {
//        case 4000://立即激活按钮
//        {
//            [self OnLogin];
//        }
//            break;
//        case 4001://发送短信按钮
//        {
//            [self OnSendMessage];
//        }
//            break;
//        case 4002://拨打电话按钮
//        {
//            UIViewController* pVC = g_navigationController.topViewController;
//            if (pVC)
//            {
//                UIActionSheet *contactAlert = [[UIActionSheet alloc] initWithTitle:@"拨打电话" 
//                                                                          delegate:(id)pVC
//                                                                 cancelButtonTitle:@"Cancel" 
//                                                            destructiveButtonTitle:nil 
//                                                                 otherButtonTitles:@"0571-56696192",nil];
//                contactAlert.actionSheetStyle = (UIActionSheetStyle)pVC.navigationController.navigationBar.barStyle;
//                [contactAlert showInView:pVC.view];
//                [contactAlert release];
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
//
//-(void)OnSendMessage
//{
//    Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
//    if (smsClass != nil && [MFMessageComposeViewController canSendText])
//    {
//        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
//        picker.messageComposeDelegate = self;
//        NSString *content =@"8";
//        [picker setBody:content];
//        
//        NSArray *recipients = [[NSArray alloc] initWithObjects:@"106695887105", nil];
//        picker.recipients = recipients;
//        [recipients release];
//        
//        [self presentModalViewController:picker animated:YES];
//    } 
//    else if([[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",@"106695887105"]]])
//    {
//    }
//    else
//    {
//        [self showMessageBox:@"此设备不支持该功能！" nType_:TZTBoxTypeNoButton nTag_:0];
//    }
//}

-(void)OnLoginFail
{
}

-(void)OnLoginSucc
{
    //zxl 20130718 国泰君安先手机注册成功以后跳转功能九宫格界面
    if (_delegate && [_delegate respondsToSelector:@selector(OnDealLoginSuccChangeToNine)])
    {
        [_delegate OnDealLoginSuccChangeToNine];
        return;
    }
    
    NSData* pData = [_pMsgInfo retain];
    if (IS_TZTIPAD)
    {
        [TZTUIBaseVCMsg IPadPopViewController:self.pParentVC];
    }
    else
    {
        [TZTUIBaseVCMsg IPadPopViewControllerEx:self.pParentVC
                                     bUseAnima_:NO
                                     completion:^{
                                         
                                         if (_nMsgID > 0 && !_bIsServer)
                                             [TZTUIBaseVCMsg OnMsg:_nMsgID wParam:(NSUInteger)pData lParam:_lParam];
                                         
                                         [pData release];
                                         
                                         if ([g_navigationController.topViewController isKindOfClass:[tztUITradeLogindViewController class]]) {
                                             
                                             tztUITradeLogindViewController *vc = (tztUITradeLogindViewController*)g_navigationController.topViewController;
                                             [vc onLoginOK];
                                         }
                                         
                                     }];
//#ifdef tzt_NewVersion
//        [TZTUIBaseVCMsg IPadPopViewController:self.pParentVC bUseAnima_:NO];
//#else
        //返回，取消风火轮显示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [g_navigationController popViewControllerAnimated:NO]; //通过popVC清除队列
        UIViewController* pTop = g_navigationController.topViewController;
        if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
        {
            g_navigationController.navigationBar.hidden = NO;
            [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
        }
//#endif
    }
    
//    if (_delegate && [_delegate respondsToSelector:@selector(OnDealLoginSucc:wParam_:lParam_:)])
//    {
//        [_delegate OnDealLoginSucc:_nMsgID wParam_:(NSUInteger)self.pMsgInfo lParam_:_lParam];
//    }
//    else
    {
    }
    
}

//add by xyt 20130725修改自营激活返回响应
-(void)OnReturnBack
{
    _pLoginView.delegate = nil;
    [super OnReturnBack];
}

#pragma mark message compose delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissModalViewControllerAnimated:YES];
    if (result == MessageComposeResultSent)
    {
    }
    else if (result == MessageComposeResultFailed)
    {
    }
}
@end
