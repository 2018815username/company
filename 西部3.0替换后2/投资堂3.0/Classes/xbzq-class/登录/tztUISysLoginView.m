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

#define BlueColor [UIColor colorWithRed:67.0/255 green:148.0/255 blue:255.0/255 alpha:1.0]
#define GrayWhite [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]
#define LightWhite [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0]
#define TFSize CGSizeMake(270, 39)
#define BTNSize CGSizeMake(270, 44)
#define Center(y)  CGPointMake(self.center.x, y)


@interface tztUISysLoginView()
{
    int secondcount;
    UIImageView*    _accountImage;
    UILabel*        _accountLable;
    UIImageView*    _numberImage;
    UITextField*    _numberText;
    UIImageView*    _numberTextImage;
    UIImageView*    _numberyzImage;
    UIButton*       _getYZM;
    UIImageView*    _pwdImage;
    UILabel*        _tipLabel;
    
}
@end

@implementation tztUISysLoginView
@synthesize pLoginView = _pLoginView;
@synthesize pHelpInfo = _pHelpInfo;
@synthesize pRegistInfo = _pRegistInfo;
@synthesize pImageView = _pImageView;
@synthesize delegate = _delegate;
@synthesize nsMobileCode = _nsMobileCode;
@synthesize bIsServiceVC = _bIsServiceVC;
@synthesize currTimer;
@synthesize checkkey;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bIsServiceVC = FALSE;
        
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(id)init
{
    if( self = [super init])
    {
        if (g_nHQBackBlackColor)
        {
            self.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
        }
        _bIsServiceVC = FALSE;
        
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    self.currTimer = nil;
    DelObject(tfPhoneNo);
    DelObject(tfCode);
    
    [super dealloc];
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    
 
    CGRect rcFrame = self.bounds;
    if (_pLoginView == nil)
    {
        _pLoginView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _pLoginView.tztDelegate = self;
        [_pLoginView setTableConfig:@"tztUIUserRegist"];
        [self addSubview:_pLoginView];
        [_pLoginView release];
    }
    
    __block TZTUITextField *text;
    __block CGRect rect1;
    
    UIView* cellView1 = [_pLoginView getCellWithFlag:@"TZTMM"];
    [cellView1.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* textfiled= (UIView*)obj;
        if ([textfiled isKindOfClass:[UITextField class]]) {
            text = (TZTUITextField*)textfiled;
            rect1 =text.frame;
            text.layer.borderWidth = 0.0f;
            
        }
    }];
    [self addLineImageView:cellView1 andRect:rect1];
    btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame =CGRectMake(rect1.origin.x+rect1.size.width+10, 44+15,80,30);
    [btnSend setTitle:@"获取验证码" forState:UIControlStateNormal];
    btnSend.backgroundColor = [UIColor colorWithRed:165.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1];
    
    btnSend.layer.cornerRadius = 6;
    [btnSend addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    btnSend.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [_pLoginView addSubview:btnSend];
    
/////
     __block TZTUITextField *text1;
    __block CGRect rect2;
    UIView* cellView2 = [_pLoginView getCellWithFlag:@"TZTTXMM"];
    [cellView2.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* textfiled= (UIView*)obj;
        if ([textfiled isKindOfClass:[UITextField class]]) {
            text1 = (TZTUITextField*)textfiled;
            rect2 =text.frame;
            text1.layer.borderWidth = 0.0f;
            
        }
    }];
    [self addLineImageView:cellView2 andRect:rect2];
    
    
    btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame =CGRectMake(20, 44*3+40,TZTScreenWidth-40,40);
    [btnLogin setTitle:@"立即登录" forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLogin.backgroundColor = [UIColor colorWithRed:71.0/255.0 green:150.0/255.0 blue:247.0/255.0 alpha:1];
    btnLogin.layer.cornerRadius = 10;
    [btnLogin addTarget:self action:@selector(OnLogin) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [_pLoginView addSubview:btnLogin];
    
 
  
    if (!self.tipLable) {
        int left=20;
        int top =10+44*5;
        int widht =TZTScreenWidth-40;
        int height = rect2.size.height*5;
        self.tipLable = [[UILabel alloc]initWithFrame:CGRectMake(left,top ,widht , height)];
        self.tipLable.numberOfLines = 6;
        self.tipLable.font = [UIFont fontWithName:@"Helvetica" size:16];
        self.tipLable.text = @"请输入手机号码，点击“获取验证码”，验证码将以短信形式发送到您的手机。\n\n获取失败？\n您可以手机致电9558-1-6-3查询手机验证码";
        [self addSubview:self.tipLable];
    }
}
-(void)addLineImageView:(UIView*)cellView1 andRect:(CGRect)rect{
    UIImageView* line = [[UIImageView alloc]init];
    line.frame = CGRectMake(rect.origin.x-2, rect.size.height+2, rect.size.width+2,6);
    line.image = [UIImage imageNamed:@"line"];
    [cellView1 addSubview:line];
}
//-(void)setFrame:(CGRect)frame
//{
//    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
//        return;
//    [super setFrame:frame];
//
//    CGRect rcFrame = self.bounds;
//    
//    if (IS_TZTIPAD /*&& _bIsServiceVC*/)//iPad服务中心,激活登陆显示
//    {
//        rcFrame.size.width = 500;//CGRectGetWidth(rcFrame) / 2;
//    }
//    
//    if (bgImageV == nil) {
//        bgImageV = [[UIImageView alloc] init];
//        bgImageV.frame = rcFrame;
//        bgImageV.image = [UIImage imageTztNamed:@"tztLoginbackground"];
//        bgImageV.userInteractionEnabled = YES;
//        [self addSubview:bgImageV];
//        [bgImageV release];
//    }
//    int leftWidth =20;
//    int topHeight =20;
//    
//    if (_accountImage ==NULL) {
//        _accountImage=[[UIImageView alloc]initWithFrame:CGRectMake(leftWidth, topHeight, 30, 30)];
//        _accountImage.image =[UIImage imageNamed:@"login"];
//        [self addSubview:_accountImage];
//        
//    }
//    
//    if (_accountLable==NULL) {
//        _accountLable = [[UILabel alloc]initWithFrame:CGRectMake(_accountImage.frame.size.width+_accountImage.frame.origin.x+10,topHeight-5,300,40)];
//        [_accountLable setText:@"用户登录"];
//      
//        [_accountLable setFont:[UIFont fontWithName:@"STHeiti-Medium.ttc" size:16]];
//        [self addSubview:_accountLable];
//    }
//    rcFrame.origin.y += 30;
//    if (_numberImage==NULL) {
//        _numberImage =[[UIImageView alloc]initWithFrame:CGRectMake(leftWidth, rcFrame.origin.y+_accountLable.frame.size.height, 30, 30)];
//        _numberImage.image =[UIImage imageNamed:@"phone"];
//        [self addSubview:_numberImage];
//    }
//    if (_numberTextImage==NULL) {
//        _numberTextImage=[[UIImageView alloc]init];
//        _numberTextImage.frame =CGRectMake(_numberImage.frame.origin.x+_numberImage.frame.size.width+10,_numberImage.frame.origin.y+22,kScreenWidth-40-80-30, 8);
//        _numberTextImage.image = [UIImage imageNamed:@"line"];
//        [self addSubview:_numberTextImage];
//    }
//    if (tfPhoneNo == nil) {
//        NSString *property = @"tag=2000|checkdata=1|backgroundcolor=255,255,255|cornerradius=0|textalignment=left|textcolor=255,255,255|maxlen=11|maxaction=1|placeholder=输入手机号码|placechange=1|borderwidth=0|";
//        tfPhoneNo = [[tztUITextField alloc] initWithProperty:property];
//        [tfPhoneNo setBackgroundColor:[UIColor redColor]];
//        tfPhoneNo.frame = CGRectMake(_numberImage.frame.origin.x+_numberImage.frame.size.width+10+2,_numberImage.frame.origin.y-1,kScreenWidth-40-80-30-5, 30);
//        [self addSubview:tfPhoneNo];
//        [tfPhoneNo release];
//    }
//
//    if (_getYZM==NULL) {
//        _getYZM = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_getYZM setTitle:@"获取验证码" forState:UIControlStateNormal];
//        _getYZM.frame = CGRectMake(tfPhoneNo.frame.origin.x+tfPhoneNo.frame.size.width+10, tfPhoneNo.frame.origin.y, 70, 30);
//        _getYZM.layer.cornerRadius = 5;
//        [_getYZM.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//        _getYZM.alpha = 0.8;
//        [_getYZM setBackgroundColor:[UIColor grayColor]];
//        [_getYZM addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_getYZM];
//    }
//  
//    /////////
//    rcFrame.origin.y += 50;
//    if (_pwdImage ==NULL) {
//        _pwdImage =[[UIImageView alloc]initWithFrame:CGRectMake(leftWidth, rcFrame.origin.y+_accountLable.frame.size.height, 30, 30)];
//        _pwdImage.image =[UIImage imageNamed:@"yaoshi"];
//        [self addSubview:_pwdImage];
//    }
//    if (_numberyzImage==NULL) {
//        _numberyzImage=[[UIImageView alloc]init];
//        _numberyzImage.frame =CGRectMake(_numberImage.frame.origin.x+_numberImage.frame.size.width+10,_pwdImage.frame.origin.y+22,kScreenWidth-40-80-30, 8);
//        _numberyzImage.image = [UIImage imageNamed:@"line"];
//        [self addSubview:_numberyzImage];
//    }
//    if (tfCode == nil) {
//        NSString *property = @"tag=2000|checkdata=1|backgroundcolor=clearcolor|cornerradius=0|textalignment=left|textcolor=255,255,255|maxlen=6|maxaction=1|placeholder=输入手机验证码|placechange=1|borderwidth=0|";
//        tfCode = [[tztUITextField alloc] initWithProperty:property];
//        tfCode.backgroundColor =[ UIColor redColor];
//        tfCode.frame = CGRectMake(_pwdImage.frame.origin.x+_pwdImage.frame.size.width+10+2,_numberyzImage.frame.origin.y-24,kScreenWidth-40-80-30-5, 30);
//        [self addSubview:tfCode];
//        [tfCode release];
//    }
//    
//      rcFrame.origin.y += 120;
//    if (btnLogin == nil) {
//        btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnLogin.frame = CGRectMake(0, 0, BTNSize.width, BTNSize.height);
//        btnLogin.center = Center(rcFrame.origin.y);
//        btnLogin.tag = 4000;
//        btnLogin.layer.cornerRadius = 10;
//        [btnLogin setBackgroundColor:BlueColor];
//        [btnLogin setTitle:@"立即登录" forState:UIControlStateNormal];
//        [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btnLogin addTarget:self action:@selector(OnLogin) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnLogin];
//    }
//    
//    if (_tipLabel==NULL) {
//        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, kScreenHeight)];
//        _tipLabel.numberOfLines =6;
//        _tipLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
//        _tipLabel.text =@"请输入手机号码，点击“获取验证码”，验证码将以短信形式发送到您的手机。\n\n获取失败？\n您可以手机致电9558-1-6-3查询手机验证码";
//        [self addSubview:_tipLabel];
//    }
//    /*
//    if (tfPhoneNo == nil) {
//        NSString *property = @"tag=2000|checkdata=1|backgroundcolor=clearcolor|cornerradius=18|textalignment=left|textcolor=255,255,255|maxlen=11|maxaction=1|placeholder=输入手机号码|placechange=1|borderwidth=1|";
//        tfPhoneNo = [[tztUITextField alloc] initWithProperty:property];
//        tfPhoneNo.frame = CGRectMake(0, 0, TFSize.width, TFSize.height);
//        tfPhoneNo.center = Center(rcFrame.origin.y);
//        [self addSubview:tfPhoneNo];
//        [tfPhoneNo release];
//    }
//    
//    if (btnSend == nil) {
//        btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnSend.frame = CGRectMake(0, 0, 105, 38);
//        btnSend.layer.cornerRadius = 20;
//        [btnSend setBackgroundImage:[UIImage imageTztNamed:@"TZTSendCode"] forState:UIControlStateNormal];
//        [btnSend setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btnSend addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
//        [btnSend.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
//        tfPhoneNo.rightView = btnSend;
//        tfPhoneNo.rightViewMode = UITextFieldViewModeAlways;
////        tfPhoneNo.clearsOnBeginEditing = YES;
//        tfPhoneNo.clearButtonMode = UITextFieldViewModeWhileEditing;
//    }
//    
//    rcFrame.origin.y += 55;
//    if (tfCode == nil) {
//        NSString *property = @"tag=2001|checkdata=1|backgroundcolor=clearcolor|cornerradius=18|textalignment=left|textcolor=255,255,255|maxlen=6|maxaction=1|placeholder=输入验证码|placechange=1|borderwidth=1|";
//        tfCode = [[tztUITextField alloc] initWithProperty:property];
//        tfCode.frame = CGRectMake(0, 0, TFSize.width, TFSize.height);
//        tfCode.center = Center(rcFrame.origin.y);
//        [self addSubview:tfCode];
//        [tfCode release];
//    }
//    
//    rcFrame.origin.y += 68;
//    
//    if (btnLogin == nil) {
//        btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnLogin.frame = CGRectMake(0, 0, BTNSize.width, BTNSize.height);
//        btnLogin.center = Center(rcFrame.origin.y);
//        btnLogin.tag = 4000;
//        btnLogin.layer.cornerRadius = 20;
//        [btnLogin setBackgroundColor:BlueColor];
//        [btnLogin setTitle:@"立即登录" forState:UIControlStateNormal];
//        [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btnLogin addTarget:self action:@selector(OnLogin) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnLogin];
//    }
//    
//    if (_pImageView == NULL)
//    {
//        NSString* strUrl = [TZTCSystermConfig getShareClass].tztiniturl;
//        _pImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        [_pImageView setImageFromUrl:strUrl atFile:@"Default.png"];
//        [self addSubview:_pImageView];
//        _pImageView.hidden = NO;
//        [_pImageView release];
//    }
//    else
//    {
//        _pImageView.frame = self.bounds;
//    }
//    */
//    [self reloadTheme];
//}
//
- (void)reloadTheme
{
    
    if (g_nThemeColor == 1)
    {
        bgImageV.image = nil;
        bgImageV.backgroundColor = LightWhite;
        
        tfPhoneNo.backgroundColor = [UIColor tztThemeBackgroundColorEditor];
        tfPhoneNo.layer.borderColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0].CGColor;
        tfPhoneNo.textColor = [UIColor blackColor];
        
        tfCode.backgroundColor = [UIColor tztThemeBackgroundColorEditor];
        tfCode.layer.borderColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0].CGColor;
        tfCode.textColor = [UIColor blackColor];
        
        btnSend.backgroundColor = LightWhite;
        
    }
}

#pragma mark - OutActions

-(void)SetDefaultData
{
    if (g_CurUserData.nsMobileCode.length > 0) {
        tfPhoneNo.text = g_CurUserData.nsMobileCode;
    }
}

-(void)setControlEnable:(BOOL)bEnable
{
    if (_pLoginView)
    {
        [_pLoginView setEditorEnable:bEnable withTag_:2000];
        tztUIButton *pBtn = (tztUIButton *)[_pLoginView getViewWithTag:4000];
        if (pBtn)
            pBtn.enabled = bEnable;
        
        
    }
    
    tfPhoneNo.enabled = bEnable;
    tfCode.enabled = bEnable;
    btnSend.enabled = bEnable;
    btnLogin.enabled = bEnable;
    
    if(_pImageView)
        _pImageView.hidden = bEnable;
}

#pragma mark - Actions 获取验证吗
- (void)sendCode:(id)sender
{
    [tfPhoneNo resignFirstResponder];
    [tfCode resignFirstResponder];
    
    NSString* nsAccount = [_pLoginView GetEidtorText:2000];

    if (nsAccount == NULL || [nsAccount length] != 11)
    {
        tztAfxMessageBlock(@"手机号码输入有误，请重新输入!", nil, nil, TZTBoxTypeButtonOK, ^(NSInteger nIndex){
            [tfPhoneNo becomeFirstResponder];
        });
        return;
    }
    [self startCount];
    
    self.nsMobileCode = [NSString stringWithFormat:@"%@", nsAccount];
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"MobileCode"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"44050" withDictValue:pDict];
    
    DelObject(pDict);
}

- (void)sendText
{
    NSString* mobileCode = [_pLoginView GetEidtorText:2000];
    
    self.nsMobileCode = [NSString stringWithFormat:@"%@", mobileCode];
    if (mobileCode == NULL || [mobileCode length] != 11)
    {
        [self showMessageBox:@"手机号码输入有误，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [pDict setTztValue:mobileCode forKey:@"mobilecode"];
    
    [pDict setTztValue:@"" forKey:@"CheckKEY"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"206" withDictValue:pDict];
    DelObject(pDict);
}


- (void)startCount
{
    if (self.currTimer)
    {
        [self.currTimer invalidate];
    }
    
    secondcount = 59;
    self.currTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.currTimer forMode:NSRunLoopCommonModes];
}

- (void)updateUI
{
    if (secondcount <= 59 && secondcount >= 0)
    {
        btnSend.enabled = NO;
        [btnSend setTitle:[NSString stringWithFormat:@"重新发送(%d)",secondcount] forState:UIControlStateDisabled];
        [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    }
    
    if (secondcount == -1)
    {
        btnSend.enabled = YES;
        [btnSend setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [btnSend setBackgroundImage:[UIImage imageTztNamed:@"TZTSendCode"] forState:UIControlStateNormal];
        [btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.currTimer invalidate];
        secondcount = 59;
    }
    
    secondcount --;
    
}

/**
 *  测试
 */
#pragma mark 测试
-(void)OnLoginTest{
    [tfPhoneNo resignFirstResponder];
    [tfCode resignFirstResponder];
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:@"15088702576" forKey:@"MobileCode"];
    [pDict setTztValue:@"8888" forKey:@"Checkkey"];
    self.nsMobileCode = @"15088702576";
    

    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"44051" withDictValue:pDict];
    
    DelObject(pDict);

}
#pragma mark - Login
-(void)OnLogin
{
    [tfPhoneNo resignFirstResponder];
    [tfCode resignFirstResponder];
    
    NSString* account = [_pLoginView GetEidtorText:2000];
    if (account.length<11) {
        [self showMessageBox:@"手机号码输入有误，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }

    NSString* nsCode = [_pLoginView GetEidtorText:2001];
    if (nsCode.length<1 || ![self.checkkey isEqualToString:nsCode]) {
        [self showMessageBox:@"验证码输入有误，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }

    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:self.nsMobileCode forKey:@"MobileCode"];
    [pDict setTztValue:nsCode forKey:@"Checkkey"];

//        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"10000" withDictValue:pDict];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"44051" withDictValue:pDict];
    
    DelObject(pDict);
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
    
 

    self.nsMobileCode = [NSString stringWithFormat:@"%@", nsAccount];
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"MobileCode"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"44051" withDictValue:pDict];
//        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"10000" withDictValue:pDict];
    
    [tztUIProgressView showWithMsg:@"系统自动登录中..."];
    
    DelObject(pDict);
}


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

#pragma mark - Delegate

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    [tztUIProgressView hidden];
    
    if ([pParse IsAction:@"44050"]  || [pParse IsAction:@"206"] )
    {
        NSString *strMsg = [pParse GetErrorMessage];
        [self showMessageBox:strMsg nType_:0 delegate_:nil];
        
        if ([pParse GetErrorNo] >= 0)
        {
            self.checkkey = [pParse GetByName:@"checkkey"];//CHECKKEY
#ifdef DEBUG
//            tfCode.text = self.checkkey;
//            [self showMessageBox:self.checkkey nType_:TZTBoxTypeButtonOK nTag_:0];
#endif
        }
        else
        {
             return 0;
        }
    }
    else if ([pParse IsAction:@"44051"] || [pParse IsAction:@"10000"] || [pParse IsAction:@"0"])
    {
 
        if ([pParse GetErrorNo] >= 0)
        {
            g_CurUserData.nsMobileCode = [NSString stringWithFormat:@"%@", self.nsMobileCode];

//          [tztKeyChain delete:tztLogMobile];
            [tztKeyChain save:tztLogMobile data:@""];
            [tztKeyChain save:tztLogMobile data:self.nsMobileCode];
            g_nsLogMobile = g_CurUserData.nsMobileCode;
            
            [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(OnLoginSucc)
                                           userInfo:NULL
                                            repeats:NO];
        }
        else
        {
            g_CurUserData.nsMobileCode = @"";
            g_nsLogMobile = @"";
            [tztKeyChain save:tztLogMobile data:g_CurUserData.nsMobileCode];
            [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllTrade_Log];
             NSString *strMsg = [pParse GetErrorMessage];
            [self showMessageBox:strMsg nType_:TZTBoxTypeButtonOK nTag_:0];
            [self setControlEnable:YES];
        }
    }
    
    return 1;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
}

@end
