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

#import "tztUISysLoginView.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

extern int g_nLogVolume;
@implementation tztUISysLoginView
@synthesize pLoginView = _pLoginView;
@synthesize pHelpInfo = _pHelpInfo;
@synthesize pImageView = _pImageView;
@synthesize delegate = _delegate;
@synthesize nsMobileCode = _nsMobileCode;
@synthesize bIsServiceVC = _bIsServiceVC;
@synthesize pView = _pView;
@synthesize segmentControl = _segmentControl;
@synthesize nsEditMoblie = _nsEditMoblie;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bIsServiceVC = FALSE;
        _nsEditMoblie = @"";
    }
    return self;
}

-(id)init
{
    if( self = [super init])
    {
        if (g_nHQBackBlackColor)
        {
            self.backgroundColor = [UIColor blackColor];
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
        }
        _bIsServiceVC = FALSE;
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    _bAutoLogin = FALSE;
    [[tztMoblieStockComm getShareInstance] addObj:self];
    [super setFrame:frame];
    
    //读取用户信息
    [TZTUserInfoDeal SaveAndLoadLogin:TRUE nFlag_:1];
    
    CGRect rcFrame = self.bounds;
    
    if (IS_TZTIPAD /*&& _bIsServiceVC*/)//iPad服务中心,激活登陆显示
    {
        rcFrame.size.width = 500;//CGRectGetWidth(rcFrame) / 2;
    }
    
    CGRect rcSeg = rcFrame;
    rcSeg.size.height = TZTToolBarHeight;
    if (_pView == NULL)
    {
        _pView = [[UIToolbar alloc] initWithFrame:rcSeg];
        [self addSubview:_pView];
        [_pView release];
    }
    else
    {
        _pView.frame = rcSeg;
    }
    
    rcSeg.size.width = 200;
    rcSeg.origin.x = (rcFrame.size.width - rcSeg.size.width) / 2;
    rcSeg.size.height = TZTToolBarHeight - 10;
    rcSeg.origin.y = rcSeg.origin.y + (TZTToolBarHeight - rcSeg.size.height) / 2;
    
    if (_segmentControl == NULL)
    {
        NSArray *pAy = [NSArray arrayWithObjects:@"一键登录", @"帐号登录", nil];
        _segmentControl = [[UISegmentedControl alloc] initWithItems:pAy];
        _segmentControl.segmentedControlStyle = UISegmentedControlStyleBordered;
        _segmentControl.frame = rcSeg;
        if (g_CurUserData.iUserType == 1)
            _segmentControl.selectedSegmentIndex = 1;
        else
            _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventValueChanged];
        [_pView addSubview:_segmentControl];
        [self ChangeSegmentFont:_segmentControl];
        [_segmentControl release];
    }
    else
    {
        _segmentControl.frame = rcSeg;
    }
    
    //zxl 20131025 ipad 提示信息用配置
    CGRect rcLogin = rcFrame;
    rcLogin.origin = CGPointZero;
    rcLogin.origin.y = rcSeg.origin.y + rcSeg.size.height + 3;
    rcLogin.size.height -= rcLogin.origin.y;
    
    if (_pLoginView == nil)
    {
        _pLoginView = [[tztUIVCBaseView alloc] initWithFrame:rcLogin];
        _pLoginView.tztDelegate = self;
        [_pLoginView setTableConfig:@"tztUIUserRegist"];
        [self addSubview:_pLoginView];
        [_pLoginView release];
        [self bringSubviewToFront:_pView];
    }
    else
    {
        _pLoginView.frame = rcLogin;
        [_pLoginView OnRefreshTableView];
    }

    if (IS_TZTIPAD)
    {
        CGRect rcInfo = rcFrame;
        rcInfo.origin.x += 5;
        rcInfo.origin.y += _pLoginView.frame.size.height + rcLogin.origin.y;
        rcInfo.size.height -= (_pLoginView.frame.size.height + rcLogin.origin.y);
        rcInfo.size.width -= 10;
        if (_pHelpInfo == NULL)
        {
            _pHelpInfo = [[UITextView alloc] initWithFrame:rcInfo];
            _pHelpInfo.textAlignment = UITextAlignmentLeft;
            _pHelpInfo.userInteractionEnabled = NO;
            if (g_nHQBackBlackColor)
            {
                _pHelpInfo.textColor = [UIColor whiteColor];
            }
            else
            {
                _pHelpInfo.textColor = [UIColor blackColor];
            }
            _pHelpInfo.backgroundColor = [UIColor clearColor];
            _pHelpInfo.font = tztUIBaseViewTextFont(13.0f);
            NSString* strTips = @"";
            if (g_pSystermConfig && g_pSystermConfig.pDict)
            {
                strTips = [g_pSystermConfig.pDict objectForKey:@"RegistTips"];
                strTips = [strTips stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\r\n"];
            }
            
            _pHelpInfo.text = [NSString stringWithFormat:@"%@", strTips];// @"激活的用处:\r\n1、将自选股同步到云端服务器进行备份；\r\n2、离线时，股价预警通知通过短信发送给您；\r\n3、交易更为安全;\r\n4、客服答疑解惑，能直接致电解答；\r\n备注：软件操作不存在任何扣费问题，请放心使用，详询0571-56696192。";
            [self addSubview:_pHelpInfo];
            [_pHelpInfo release];
        }
        else
            _pHelpInfo.frame = rcInfo;

    }
    
    [self doSelect:_segmentControl];
    
    if (_pImageView == NULL)
    {
        NSString* strUrl = [TZTCSystermConfig getShareClass].tztiniturl;
        _pImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_pImageView setImageFromUrl:strUrl atFile:@"Default.png"];
        [self addSubview:_pImageView];
        _pImageView.hidden = NO;
    }
    else
    {
        _pImageView.frame = self.bounds;
    }
    [self bringSubviewToFront:_pImageView];
    
    //设置默认的数据
    if (_pLoginView)
    {
        [_pLoginView setEditorText:g_CurUserData.nsMobileCode nsPlaceholder_:NULL withTag_:2000];
    }
    //zxl 20130729 登录错误的时候保留编辑手机号
    if (_nsEditMoblie && [_nsEditMoblie length] > 0)
    {
        [_pLoginView setEditorText:_nsEditMoblie nsPlaceholder_:NULL withTag_:2000];
    }
}

#pragma mark UISegmentedControl delegate
-(void)ChangeSegmentFont:(UIView *)aView
{
    if ([aView isKindOfClass:[UILabel class]])
    {
        UILabel *lb = (UILabel*)aView;
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setFont:tztUIBaseViewTextFont(14.f)];
    }
    NSArray *na = [aView subviews];
    NSEnumerator *ne = [na objectEnumerator];
    UIView *subView;
    while (subView = [ne nextObject])
    {
        [self ChangeSegmentFont:subView];
    }
}

-(void)doSelect:(id)sender
{
	UISegmentedControl *control = (UISegmentedControl*)sender;
	switch (control.selectedSegmentIndex)
	{
		case 1://点击的时预设账号
		{
            g_CurUserData.iUserType = 1;
            [_pLoginView SetImageHidenFlag:@"TZTMM" bShow_:YES];
            [_pLoginView SetImageHidenFlag:@"TZTKFDH" bShow_:NO];
		}
			break;
		case 0:
        {
            g_CurUserData.iUserType = 0;
            [_pLoginView SetImageHidenFlag:@"TZTMM" bShow_:NO];
            [_pLoginView SetImageHidenFlag:@"TZTKFDH" bShow_:YES];
        }
            break;
		default:
			break;
	}
    [_pLoginView OnRefreshTableView];
    [self ChangeSegmentFont:control];
    
    //设置默认的数据
    if (_pLoginView)
    {
        [_pLoginView setEditorText:g_CurUserData.nsMobileCode nsPlaceholder_:NULL withTag_:2000];
        
        [_pLoginView setEditorText:(g_CurUserData.iUserType == 1 ? g_CurUserData.nsPassword : @"") nsPlaceholder_:NULL withTag_:2001];
        
        
        [_pLoginView setLabelText: (g_CurUserData.iUserType == 1 ? @"若忘记密码可激活重置密码为888888":@"此功能需激活后才能使用") withTag_:1000];
        
        [_pLoginView setLabelText: (g_CurUserData.iUserType == 1 ? @"可登陆个人中心修改密码。":@"激活后在上面框中输入手机号码即可登录。") withTag_:7001];
        
//        [_pLoginView setLabelText: (g_CurUserData.iUserType == 1 ? @"激活方法:(激活后密码即重置为888888)":@"激活方法:") withTag_:5002];
        

        
        NSString *strRegistNo = [g_pSystermConfig.pDict objectForKey:@"Registnumber"];
        NSString* strTip = [_pLoginView GetLabelText:5002];
        strTip = [strTip stringByReplacingOccurrencesOfString:@"[-RegistNumber-]" withString:strRegistNo];
        strTip = [strTip stringByReplacingOccurrencesOfString:@"[-RegistPhone-]" withString:TZTDailPhoneNUM];
        [_pLoginView setLabelText:strTip  withTag_:5002];
        
        strTip = [_pLoginView GetLabelText:6002];
        strTip = [strTip stringByReplacingOccurrencesOfString:@"[-RegistNumber-]" withString:strRegistNo];
        strTip = [strTip stringByReplacingOccurrencesOfString:@"[-RegistPhone-]" withString:TZTDailPhoneNUM];
        [_pLoginView setLabelText:strTip  withTag_:6002];
        
        strTip = [_pLoginView GetLabelText:9002];
        strTip = [strTip stringByReplacingOccurrencesOfString:@"[-RegistNumber-]" withString:strRegistNo];
        strTip = [strTip stringByReplacingOccurrencesOfString:@"[-RegistPhone-]" withString:TZTDailPhoneNUM];
        [_pLoginView setLabelText:strTip  withTag_:9002];

    }
	return;
}


-(void)OnButtonClick:(id)sender
{
    tztUIButton *pBtn = (tztUIButton*)sender;
    switch ([[pBtn tzttagcode] intValue])
    {
        case 4000://立即激活按钮
        {
            [self OnLogin];
        }
            break;
        case 5001://发送短信按钮
        {
            [self GetSendMobileCode];
//            [self OnSendMessage];
        }
            break;
        case 6001:
        case 9001://拨打客服电话按钮
        {
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_TztTelPhone wParam:0 lParam:0];
        }
            break;
            
        default:
            break;
    }
}
-(void)GetSendMobileCode
{
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"20290" withDictValue:pDict];
    DelObject(pDict);
}


-(void)OnLogin
{
    NSString* nsAccount = [_pLoginView GetEidtorText:2000];
    
    if (nsAccount == NULL || [nsAccount length] < 11)
    {
        [self showMessageBox:@"手机号码输入有误，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* nsPWD = @"";
    if (g_CurUserData.iUserType == 1)
    {
        nsPWD = [_pLoginView GetEidtorText:2001];
        if (nsPWD == NULL || [nsPWD length] < 1)
        {
            [self showMessageBox:@"请输入密码!" nType_:TZTBoxTypeNoButton delegate_:nil];
            return;
        }
    }
    
    self.nsMobileCode = [NSString stringWithFormat:@"%@", nsAccount];
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"MobileCode"];
    [pDict setTztValue:@"1" forKey:@"Direction"];
    if (g_nsUpVersion)
    {
        [pDict setTztValue:g_nsUpVersion forKey:@"Version"];
    }
    
    if (g_nsdeviceToken && [g_nsdeviceToken length] > 0)
    {
        [pDict setTztValue:g_nsdeviceToken forKey:@"devicetoken"];
    }
    
    g_CurUserData.nsMobileCode = [NSString stringWithFormat:@"%@", self.nsMobileCode];
    if (g_CurUserData.iUserType == 1)
    {
        [pDict setTztValue:nsPWD forKey:@"password"];
    }
    else //激活登录
    {
        if (g_CurUserData.nsCheckKEY && [g_CurUserData.nsCheckKEY length] > 0)
        {
            [pDict setTztObject:g_CurUserData.nsCheckKEY forKey:@"CheckKEY"];
        }
    }
    [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)g_CurUserData.iUserType] forKey:@"login_type"];
    
    if (g_pSystermConfig && g_pSystermConfig.strRegAction && [g_pSystermConfig.strRegAction length] > 0)
        [[tztMoblieStockComm getShareInstance] onSendDataAction:g_pSystermConfig.strRegAction withDictValue:pDict];
    else
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"40100" withDictValue:pDict];
    DelObject(pDict);
}

-(void)setControlEnable:(BOOL)bEnable
{
    if (_pLoginView)
    {
        [_pLoginView setEditorEnable:bEnable withTag_:2000];
        [_pLoginView setEditorEnable:bEnable withTag_:2001];
        tztUIButton *pBtn = (tztUIButton *)[_pLoginView getViewWithTag:4000];
        if (pBtn)
            pBtn.enabled = bEnable;
        if(_segmentControl)
            _segmentControl.enabled = bEnable;
    }
    if(_pImageView)
    {
        _pImageView.userInteractionEnabled = !bEnable;
        _pImageView.hidden = bEnable;
    }
}

//自动登录
-(void)OnAutoLogin
{
    NSString* nsAccount = g_CurUserData.nsMobileCode;
    if (nsAccount == NULL || [nsAccount length] < 11)
    {
        [self showMessageBox:@"手机号码输入有误，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    [self setControlEnable:NO];

    _bAutoLogin = TRUE;
    self.nsMobileCode = [NSString stringWithFormat:@"%@", nsAccount];
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"MobileCode"];
    
    if (g_CurUserData.nsCheckKEY)
    {
        if (g_CurUserData.iUserType == 1)
            [pDict setTztValue:g_CurUserData.nsPassword forKey:@"password"];
        else
            [pDict setTztValue:g_CurUserData.nsCheckKEY forKey:@"CheckKEY"];
    }
    
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)g_CurUserData.iUserType] forKey:@"login_Type"];
    
    if (g_nsUpVersion)
    {
        [pDict setTztValue:g_nsUpVersion forKey:@"Version"];
    }
    if (g_nsdeviceToken && [g_nsdeviceToken length] > 0)
    {
        [pDict setTztValue:g_nsdeviceToken forKey:@"devicetoken"];
    }
    
    
    if (g_pSystermConfig && g_pSystermConfig.strRegAction && [g_pSystermConfig.strRegAction length] > 0)
        [[tztMoblieStockComm getShareInstance] onSendDataAction:g_pSystermConfig.strRegAction withDictValue:pDict];
    else
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"40100" withDictValue:pDict];
    [tztUIProgressView showWithMsg:@"系统自动登录中..."];
    DelObject(pDict);
}
//zxl 20131216 自营修改发送短信方式
-(void)OnSendMessage:(NSString *)strMsg PhoneNO:(NSString *)strPhone
{
    Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (smsClass != nil && [MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = _delegate;
        if (strMsg == NULL|| [strMsg length] < 1)
        {
            [picker setBody:@"8"];
        }else
        {
            [picker setBody:strMsg];
        }
        
        NSString *strRegistNo = [g_pSystermConfig.pDict objectForKey:@"Registnumber"];
        if (strRegistNo == NULL || [strRegistNo length] < 1)
            strRegistNo = @"106901601050";
        
        if (strPhone && [strPhone length] > 0)
        {
            strRegistNo = [NSString stringWithFormat:@"%@",strPhone];
        }
        
        NSArray *recipients = [[NSArray alloc] initWithObjects:strRegistNo, nil];
        picker.recipients = recipients;
        [recipients release];
        
        [_delegate presentModalViewController:picker animated:YES];
    }
    else
    {
        [self showMessageBox:@"此设备不支持该功能！" nType_:TZTBoxTypeNoButton nTag_:0];
    }
}

-(void)CheckLoginState:(NSString*)strLogVolume
{
    if (strLogVolume == NULL || [strLogVolume length] <= 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(OnLoginSucc)
                                       userInfo:NULL
                                        repeats:NO];
        return;
    }
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:strLogVolume forKey:@"LogVolume"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"20401" withDictValue:pDict];
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    [tztUIProgressView hidden];
    
    if ([pParse IsAction:@"40100"] || [pParse IsAction:g_pSystermConfig.strRegAction] )
    {
        NSString *strMsg = [pParse GetErrorMessage];
        [self showMessageBox:strMsg nType_:TZTBoxTypeButtonOK nTag_:0];
 //       NSString* strCheck = [pParse GetByName:@"CheckKEY"];
        if ([pParse GetErrorNo] >= 0 && g_CurUserData.nsMobileCode && [g_CurUserData.nsMobileCode length] > 0)
        {
            if (g_CurUserData.iUserType == 1 && _segmentControl.selectedSegmentIndex == 1)
            {
                NSString* strPassword = [_pLoginView GetEidtorText:2001];
                g_CurUserData.nsPassword = [NSString stringWithFormat:@"%@", strPassword];
            }
            else if(g_CurUserData.iUserType == 0 && _segmentControl.selectedSegmentIndex == 0 )
            {
                NSString* strPassword = [pParse GetByName:@"password"];
                g_CurUserData.nsCheckKEY = [NSString stringWithFormat:@"%@", strPassword];
            }
            else
            {
                [self setControlEnable:YES];
                [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllTrade_Log];
                [self setFrame:self.frame];
                return 0;
            }
            //zxl 20130802 修改了手机号登录返回该用户买卖信息 是否默认分享
            NSString* strShare = [pParse GetByName:@"share"];
            if (strShare && [strShare length] > 0)
            {
                g_CurUserData.bCGFenXiang = ([strShare intValue] == 1);
            }
            //唯一登陆判断
            NSString* strLogVolume = [pParse GetByName:@"LogVolume"];
            g_nsLogMobile = g_CurUserData.nsMobileCode;
            [tztKeyChain save:tztLogMobile data:g_nsLogMobile];
            if(strLogVolume && [strLogVolume length] > 0)
                g_nLogVolume = [strLogVolume intValue];
            else
                g_nLogVolume = -1;
            [self CheckLoginState:strLogVolume];
        }
        else
        {
            [self setControlEnable:YES];
            g_CurUserData.nsMobileCode = @"";
            g_nsLogMobile = @"";
            g_nLogVolume = -1;
            //zxl 20130729 登录错误的时候保留编辑手机号
            _nsEditMoblie = [_pLoginView GetEidtorText:2000];
            [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllTrade_Log];
            [self setFrame:self.frame];
        }
    }
    if ([pParse IsAction:@"20401"])
    {
        if ([pParse GetErrorNo] == -202008)
        {
            NSString* strErrMsg = [pParse GetErrorMessage];
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
            return 0;
        }
        
        [NSTimer scheduledTimerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(OnLoginSucc)
                                       userInfo:NULL
                                        repeats:NO];
    }
    //zxl 20131216 自营修改发送短信方式
    if ([pParse IsAction:@"20290"])
    {
        // 手机运营商代码规定：1电信 2移动 3联通，如：
		// 1|8|106901601050|
		// 2|8|106901601050|
		// 3|8|106901601050|
        
        if ([pParse GetErrorNo] < 0)
        {
            NSString *strMsg = [pParse GetErrorMessage];
            [self showMessageBox:strMsg nType_:TZTBoxTypeButtonOK nTag_:0];
        }else
        {
            NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
            if (ayGrid && [ayGrid count] > 0)
            {
                int iphoneType = [self GetIphoneSIMType];
                NSString *strMsg = @"";
                NSString *strPhoneNO = @"";
                for (int i = 0; i < [ayGrid count]; i++)
                {
                    NSArray *ayData = [ayGrid objectAtIndex:i];
                    if (ayData == NULL || [ayData count] < 3)
                        continue;
                    
                    NSString* strphoneType = [ayData objectAtIndex:0];
                    if ([strphoneType intValue] == iphoneType)
                    {
                        strMsg = [ayData objectAtIndex:1];
                        strPhoneNO = [ayData objectAtIndex:2];
                        break;
                    }
                }
                
                if (iphoneType > 0)
                {
                    if (strMsg && [strMsg length] > 0 && strPhoneNO && [strPhoneNO length] > 0)
                    {
                        [self OnSendMessage:strMsg PhoneNO:strPhoneNO];
                    }
                }else
                {
                    if (iphoneType == 0)
                    {
                        [self OnSendMessage:@"" PhoneNO:@""];
                    }else
                    {
                        [self showMessageBox:@"此设备没有SIM卡或不支持该功能！" nType_:TZTBoxTypeNoButton nTag_:0];
                    }
                }
            }
            [self OnSendMessage:@"" PhoneNO:@""];
        }
    }
    return 1;
}
/*
 zxl 20131216
 0其他运营商 1电信 2移动 3联通，
 */
-(int)GetIphoneSIMType
{
    CTTelephonyNetworkInfo *IphoneInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *Carrier = [IphoneInfo subscriberCellularProvider];
    [IphoneInfo release];
    if (Carrier)
    {
        NSString * StrCarrierName = [Carrier carrierName];
        if (StrCarrierName && [StrCarrierName length] > 0)
        {
            if ([StrCarrierName isEqualToString:@"中国电信"])
            {
                return 1;
            }
            if ([StrCarrierName isEqualToString:@"中国移动"])
            {
                return 2;
            }
            if ([StrCarrierName isEqualToString:@"中国联通"])
            {
                return 3;
            }
        }
        return 0;
    }
    return -1;
}

//-(void)OnLogin:()

-(void)OnLoginSucc
{
    //设置系统登录标志
    [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:TestTrade_Log];
    [TZTUserInfoDeal SetTradeLogState:Trade_Login lLoginType_:Systerm_Log];
    //本地保存
    [TZTUserInfoDeal SaveAndLoadLogin:FALSE nFlag_:0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(OnLoginSucc)])
    {
        [self.delegate OnLoginSucc];
    }
    return;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
}

@end
