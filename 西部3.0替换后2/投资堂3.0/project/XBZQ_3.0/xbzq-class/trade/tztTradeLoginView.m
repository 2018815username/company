/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易/融资融券登录
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTradeLoginView.h"
#import "TZTUIBaseVCMsg.h"
#import "tztUIAddAccountViewController.h"
#import "tztUISysLoginViewController.h"
#import "tztWebViewController.h"
#import "ShangChengViewController.h"

#define tztRememberPlist @"tztTradeLoginRemember"
#define BLUEColor [UIColor colorWithRed:56.0/255 green:117.0/255 blue:197.0/255 alpha:1.0]
#define ButtonColor [UIColor colorWithRed:71.0/255 green:151.0/255 blue:247.0/255 alpha:1.0]
#define ButtonOK [UIColor colorWithRed:71.0/255 green:151.0/255 blue:247.0/255 alpha:1.0]
#define ButtonQD [UIColor colorWithRed:235.0/255 green:152.0/255 blue:91.0/255 alpha:1.0]
#define ChooseViewHeight 100
#define tztYZM  @"验证码"
#define tztDTKL @"动态口令"

#define BlueColor [UIColor colorWithRed:67.0/255 green:148.0/255 blue:255.0/255 alpha:1.0]
#define TFSize CGSizeMake(270, 39)
#define BTNSize CGSizeMake(270, 44)
#define Center(y)  CGPointMake(self.center.x, y)

#define GrayWhite [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]
#define LightWhite [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0]

@interface TZTChooseView ()

@property(nonatomic,retain)UIView *LeftView;
@property(nonatomic,retain)UIView *RightView;

@end

@implementation TZTChooseView
@synthesize LeftView = _LeftView;
@synthesize RightView = _RightView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    self.backgroundColor =  [UIColor whiteColor];//[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:.1f];
    self.layer.borderWidth=0.3;
    self.layer.borderColor=[UIColor colorWithRed:44.0/255 green:44.0/255 blue:44.0/255 alpha:1.0].CGColor;
    
    CGRect rect = frame;
    rect.origin.x = 77;
    rect.origin.y = 30;
    rect.size = CGSizeMake(13, 13);
    
    if (imageOpen == nil) {
        imageOpen = [[UIImageView alloc] init];
        imageOpen.frame = rect;
        imageOpen.image = [UIImage imageTztNamed:@"tztOpenIcon"];
        imageOpen.userInteractionEnabled = YES;
        [self addSubview:imageOpen];
    }
    else
    {
        imageOpen.frame = rect;
    }
    
    rect.origin.x = 225;
    
    if (imageInfo == nil) {
        imageInfo = [[UIImageView alloc] init];
        imageInfo.frame = rect;
        imageInfo.image = [UIImage imageTztNamed:@"tztLoginInfoIcon"];
        imageInfo.userInteractionEnabled = YES;
        [self addSubview:imageInfo];
    }
    else
    {
        imageInfo.frame = rect;
    }
    
    rect.origin = CGPointMake(157, 33);
    rect.size = CGSizeMake(1, 39);
    
    if (imageSeparate == nil) {
        imageSeparate = [[UIImageView alloc] init];
        imageSeparate.frame = rect;
        imageSeparate.image = [UIImage imageTztNamed:@"tztSeparator"];
        imageSeparate.userInteractionEnabled = YES;
        [self addSubview:imageSeparate];
    }
    else
    {
        imageSeparate.frame = rect;
    }
    
    rect.origin = CGPointMake(15, 48);
    rect.size = CGSizeMake(135, 30);
    
    if (btnOpen == nil) {
        btnOpen = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOpen.frame = rect;
        btnOpen.tag = 0x9991;
        [btnOpen setTitle:@"我要开/转户" forState:UIControlStateNormal];
        [btnOpen setTitle:@"我要开/转户" forState:UIControlStateSelected];
        [btnOpen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnOpen setTitleColor:BLUEColor forState:UIControlStateHighlighted];
        [btnOpen addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnOpen];
    }
    else
    {
        btnOpen.frame = rect;
    }
    
    rect.origin.x = 168;
    
    if (btnInfo == nil) {
        btnInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        btnInfo.frame = rect;
        btnInfo.tag = 0x9990;
        [btnInfo setTitle:@"关于西部证券" forState:UIControlStateNormal];
        [btnInfo setTitle:@"关于西部证券" forState:UIControlStateSelected];
        [btnInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnInfo setTitleColor:BLUEColor forState:UIControlStateHighlighted];
        [btnInfo addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnInfo];
    }
    else
    {
        btnInfo.frame = rect;
    }
    [self reloadTheme];
}

- (void)reloadTheme
{
    
    if (g_nThemeColor == 0)
    {
        self.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:.1f];
        self.layer.borderColor=[UIColor colorWithRed:44.0/255 green:44.0/255 blue:44.0/255 alpha:1.0].CGColor;
        imageOpen.image = [UIImage imageTztNamed:@"tztOpenIcon"];
        imageInfo.image = [UIImage imageTztNamed:@"tztLoginInfoIcon"];
        imageSeparate.image = [UIImage imageTztNamed:@"tztSeparator"];
        
        [btnOpen setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if (g_nThemeColor == 1)
    {
        self.backgroundColor = [UIColor whiteColor];// GrayWhite;
        self.layer.borderColor=[UIColor colorWithRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0].CGColor;
        imageOpen.image = [UIImage imageTztNamed:@"tztOpenIcon_White"];
        imageInfo.image = [UIImage imageTztNamed:@"tztLoginInfoIcon_White"];
        imageSeparate.image = [UIImage imageTztNamed:@"tztSeparator_White"];
        
        [btnOpen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

}

- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0x9990) {
        [TZTUIBaseVCMsg OnMsg:TZT_MENU_StartOpen wParam:0 lParam:0];
    }
    else if (btn.tag == 0x9991)
    {
        NSString* strUrl = @"10061/?url=http://www.yongjinbao.com.cn&&fullscreen=1&&secondtype=0";
        [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strUrl lParam:0];
//        [TZTUIBaseVCMsg OnMsg:0x9991 wParam:0 lParam:0];
    }
}

@end

@interface tztTradeLoginView()<tztSevenSwitchDelegate, tztUIBaseViewTextDelegate>

@property(nonatomic,retain)UIImageView *imageBackView;
@property(nonatomic,retain)UIButton *btnOpenAccount;
@property(nonatomic,retain)UIButton *btnAbount;
@property(nonatomic,retain)UIView   *pAccountBackView;
@property(nonatomic,retain)UIView   *pTjxmmBackView;
@property(nonatomic,retain)UIView   *pTxmmBackView;
@property(nonatomic,retain)UIImageView *pAccountLeftView;


//add by ruyi
@property(nonatomic,strong)UILabel* jylbLabel;
@property(nonatomic,strong)UILabel* zhlbLabel;
@property(nonatomic,strong)tztUIDroplistView *accountTyPe; // 账号类别
@property(nonatomic,strong)tztUIDroplistView *accountTypeTwo; // 账号类型
@property(nonatomic,retain)tztUIDroplistView*  tfkInput;    //通讯密码输入框
@property(nonatomic,strong)UITextField*         txmmTexfiled;

@property(nonatomic,strong)UIButton* loginBtn;//登录按钮
@property(nonatomic,strong)UIButton* loginok;//确定按钮
@property(nonatomic,strong)UIButton* forgetPassWorld;//忘记密码
@property(nonatomic,strong)UIButton* kaihu;//我也开会
@property(nonatomic,strong)UIButton* loginCancel;//取消按钮

@property (nonatomic,assign) BOOL isInPutValue;
@property (nonatomic,strong) NSString* nsAccount;
//-(void)ChangeSegmentFont:(UIView *)aView;
//设置信息
-(void)OnSetPicker;
//删除账户
-(void)OnDelAccount;
//增加账户
-(void)OnAddAccount;
@end

@implementation tztTradeLoginView
@synthesize tztTableView = _tztTableView;
@synthesize pickerData = _pickerData;
@synthesize segmentControl = _segmentControl;
@synthesize pMsgInfo = _pMsgInfo;
@synthesize nLoginType = _nLoginType;
@synthesize bISHz = _bISHz;
@synthesize pCurZJAccount = _pCurZJAccount;
@synthesize ayAccountData = _ayAccountData;
@synthesize bWithoutCode;
@synthesize imageBackView = _imageBackView;
@synthesize btnOpenAccount = _btnOpenAccount;
@synthesize btnAbount = _btnAbount;
@synthesize switchO2O = _switchO2O;
@synthesize pAccountBackView = _pAccountBackView;
@synthesize pTxmmBackView = _pTxmmBackView;
@synthesize pAccountLeftView = _pAccountLeftView;
@synthesize pTjxmmBackView =_pTjxmmBackView;
@synthesize tfkInput = _tfkInput;
@synthesize txmmTexfiled =_txmmTexfiled;
@synthesize nsAccount = _nsAccount;
-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _pCurZJAccount = NewObject(tztZJAccountInfo);
        _bISHz = FALSE;
        _isInPutValue = NO;
        _nsAccount = [[NSString alloc] init];
        [self getAccountType];//获取账号类型
    }
    return self;
}

//获取用户预设账号信息
-(void)getZHxinxi
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    NSString* mobil = [tztKeyChain load:tztLogMobile];
    if (mobil) {
        [pDict setValue:mobil forKey:@"MobileCode"];
    }
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"207" withDictValue:pDict];
    DelObject(pDict);
}
-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_pickerData);
    if (_pMsgInfo)
    {
        [_pMsgInfo release];
        _pMsgInfo = nil;
    }
    DelObject(tfCode);
    DelObject(tfpw);
    // chooseView/dplAccount no release, crash
    
    [super dealloc];
}
#pragma mark 设置底部的View
-(void)setLoginOtherViewe{
    _loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor =ButtonColor;
    _loginBtn.layer.cornerRadius =10;
    [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(OnLogin) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.frame = CGRectMake(20, 44*6+40, TZTScreenWidth-40, 40);
    [_tztTableView addSubview:_loginBtn];
    
    
    _forgetPassWorld =[UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPassWorld.backgroundColor =[UIColor whiteColor];
    _forgetPassWorld.layer.borderWidth =2;
    _forgetPassWorld.layer.cornerRadius =10;
    _forgetPassWorld.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:241.0/255 blue:245.0/255.0 alpha:1].CGColor;
    [_forgetPassWorld setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255 blue:143.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_forgetPassWorld addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
    [_forgetPassWorld setTitle:@"忘记密码" forState:UIControlStateNormal];
    int top = _loginBtn.frame.size.height+_loginBtn.frame.origin.y;
    _forgetPassWorld.frame = CGRectMake(20, top+10, (TZTScreenWidth-40)/2-20, 30);
    [_tztTableView addSubview:_forgetPassWorld];//forgetPwd
    
    _kaihu=[UIButton buttonWithType:UIButtonTypeCustom];
    _kaihu.backgroundColor =[UIColor whiteColor];
    [_kaihu setTitle:@"我要开户" forState:UIControlStateNormal];
    [_kaihu setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255 blue:143.0/255.0 alpha:1] forState:UIControlStateNormal];
    _kaihu.layer.borderWidth =2;
    _kaihu.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:241.0/255 blue:245.0/255.0 alpha:1].CGColor;
    _kaihu.layer.cornerRadius =10;
    [_kaihu addTarget:self action:@selector(kaiHuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _kaihu.frame = CGRectMake(20+(TZTScreenWidth-40)/2+10, top+10, (TZTScreenWidth-40)/2-20, 30);
    [_tztTableView addSubview:_kaihu];
    
    _loginok =[UIButton buttonWithType:UIButtonTypeCustom];
    _loginok.backgroundColor =ButtonQD;
    _loginok.layer.cornerRadius =10;
    [_loginok setTitle:@"确  定" forState:UIControlStateNormal];
    _loginok.frame = CGRectMake(20, 44*8, (TZTScreenWidth-40)/2-20, 30);
    [_tztTableView addSubview:_loginok];
    
    _loginCancel =[UIButton buttonWithType:UIButtonTypeCustom];
    _loginCancel.backgroundColor =ButtonColor;
    _loginCancel.layer.cornerRadius =10;
    [_loginCancel setTitle:@"取  消" forState:UIControlStateNormal];
    _loginCancel.frame = CGRectMake(20+(TZTScreenWidth-40)/2+20, 44*8, (TZTScreenWidth-40)/2-20, 30);
    [_tztTableView addSubview:_loginCancel];

}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    

    CGRect rcFrame = self.bounds;
    if (_tztTableView == nil)
    {
        _tztTableView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTableView.tztDelegate = self;
        BOOL isRzrqLogin =(_nLoginType == TZTAccountRZRQType || _nLoginType == TZTAccountPTType);
        [_tztTableView setTableConfig:isRzrqLogin?@"tztUITradeLogin":@"tztUITradeLogin_AddCount"];
        [self addSubview:_tztTableView];
        [_tztTableView release];

    }
    [self setLoginOtherViewe];
    
    [self isLoginOrAddAccount:(_nLoginType == TZTAccountPTType ||_nLoginType == TZTAccountRZRQType)];
    
    __block TZTUITextField *text;
    __block CGRect rect1;
    UIView* cellView1 = [_tztTableView getCellWithFlag:@"TZTTXMMINPUT"];
    [cellView1.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* textfiled= (UIView*)obj;
        if ([textfiled isKindOfClass:[UITextField class]]) {
            text = (TZTUITextField*)textfiled;
            
            rect1 =text.frame;
            text.layer.borderWidth = 0.0f;
        }
    }];
    
    [self addLineImageView:cellView1 andRect:rect1];
    
    __block TZTUITextField *text1;
    __block CGRect rect2;
    UIView* cellView2 = [_tztTableView getCellWithFlag:@"TZTJYMM"];
    
    
    [cellView2.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* textfiled= (UIView*)obj;
        if ([textfiled isKindOfClass:[UITextField class]]) {
            text1 = (TZTUITextField*)textfiled;
            rect2 =text.frame;
            text1.layer.borderWidth = 0.0f;
        }
    }];
     [self addLineImageView:cellView2 andRect:rect2];
    
#pragma mark forceChange
    __block tztUITextField *changeInputView;
    UIView* changeView = [_tztTableView getCellWithFlag:@"TZTZJZH"];
    [changeView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* textfiled= (UIView*)obj;
        if ([textfiled isKindOfClass:[tztUIDroplistView class]]) {
            changeInputView = ((tztUIDroplistView*)textfiled).textfield;
            changeInputView.tztdelegate =self;
        }
    }];

    NSMutableArray *ayData = NewObject(NSMutableArray);
    [ayData addObject:@"普通委托"];
    [ayData addObject:@"融资融券"];
    
    [_tztTableView setComBoxData:ayData ayContent_:ayData AndIndex_:(_nLoginType == TZTAccountRZRQType)?1:0 withTag_:998];
    
    NSMutableArray *ayDataT = NewObject(NSMutableArray);
    [ayDataT addObject:@"通讯密码"];
    [ayDataT addObject:@"动态口令"];
    [_tztTableView setComBoxData:ayDataT ayContent_:ayDataT AndIndex_:0 withTag_:1002];
    
  
}
//ruyi
-(void)isLoginOrAddAccount:(BOOL)show{
    _loginBtn.hidden = !show;
    _forgetPassWorld.hidden = !show;
    _kaihu.hidden = !show;
    _loginCancel.hidden = show;
    _loginok.hidden = show;
    [_tztTableView SetImageHidenFlag:@"TZTTXMM" bShow_:show];
    [_tztTableView SetImageHidenFlag:@"TZTTXMMINPUT" bShow_:show];
    [_tztTableView SetImageHidenFlag:@"TZTYYB" bShow_:!show];
    [_tztTableView OnRefreshTableView];
}

-(void)addLineImageView:(UIView*)cellView1 andRect:(CGRect)rect{
    UIImageView* line = [[UIImageView alloc]init];
    line.frame = CGRectMake(rect.origin.x-2, rect.size.height+2, rect.size.width+2,6);
    line.image = [UIImage imageNamed:@"line"];
    [cellView1 addSubview:line];
}
-(void)getAccountType
{
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:g_pSystermConfig.sYYBCode forKey:@"YybCode"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"201" withDictValue:pDict];
    DelObject(pDict);
}
- (void)reloadTheme
{
    [chooseView reloadTheme];
    if (g_nThemeColor == 1)
    {
        bgImageV.image = nil;
        bgImageV.backgroundColor = LightWhite;
        UIImageView *left1 = (UIImageView *)dplAccount.textfield.leftView;
        left1.image = [UIImage imageTztNamed:@"tztCodeIdf_white"];
        left1.backgroundColor = [UIColor whiteColor];
        left1.layer.borderWidth = 0;
        left1.layer.borderColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0].CGColor;

        
        dplAccount.backgroundColor = [UIColor tztThemeBackgroundColorEditor];;
        [dplAccount.dropbtn setTztBackgroundImage:[UIImage imageTztNamed:@"tztDrop_white"]];
        dplAccount.textfield.textColor = [UIColor blackColor];
        
        _pAccountBackView.backgroundColor = [UIColor tztThemeBackgroundColorEditor];;
        _pAccountBackView.layer.borderWidth = .5f;
        _pAccountBackView.layer.borderColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0].CGColor;
        

        tfpw.textColor = [UIColor blackColor];
        UIImageView *left2 = (UIImageView *)tfpw.leftView;
        left2.backgroundColor = [UIColor whiteColor];
        left2.image = [UIImage imageTztNamed:@"tztPWIdf_white"];
//        left2.layer.borderWidth = .5f;
//        left2.layer.borderColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0].CGColor;
        tfCode.backgroundColor = [UIColor tztThemeBackgroundColorEditor];;
//        tfCode.layer.borderWidth = .5f;
//        tfCode.layer.borderColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0].CGColor;
        tfCode.textColor = [UIColor blackColor];
        UIImageView *left3 = (UIImageView *)tfCode.leftView;
        left3.backgroundColor = [UIColor whiteColor];
        left3.image = [UIImage imageTztNamed:@"tztAccIdf_white"];
//        left3.layer.borderWidth = .5f;
        left3.layer.borderColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0].CGColor;
        [btnSend setBackgroundImage:nil forState:UIControlStateNormal];
        btnSend.backgroundColor = [UIColor colorWithRed:207.0/255 green:207.0/255 blue:207.0/255 alpha:1.0];
//        self.backgroundColor = [UIColor whiteColor];
//        _accountTyPe.backgroundColor = [UIColor whiteColor];
//        _accountTyPe.layer.borderWidth = 0;
//        _accountTyPe.layer.borderColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0].CGColor;
        //[btnLbRemember setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
  
}
/*
-(void)tztSevenSwitchChanged:(id)sender status_:(BOOL)bOn
{
    //
    NSMutableDictionary * dict = GetDictByListName(tztRememberPlist);
    if (self.switchO2O == sender)
    {
        if (bOn && ![[dict objectForKey:@"Remember"] boolValue])
        {
            [tztUIVCBaseView OnCloseKeybord:self];
            tztAfxMessageBox(@"在本机保存账号可能存在一定的风险，请注意。");
        }
    }
    
    if (dict == NULL)
        dict = NewObjectAutoD(NSMutableDictionary);
    [dict setObject:bOn ? @"1" : @"0" forKey:@"Remember"];
    SetDictByListName(dict, tztRememberPlist);
}
 - (void)ifRemembered:(id)sender
 {
 BOOL on = self.switchO2O.on;
 on = !on;
 [self.switchO2O setOn:on animated:YES];
 }
*/
-(void)OnAbount:(id)sender
{
    [TZTUIBaseVCMsg OnMsg:TZT_MENU_StartOpen wParam:0 lParam:0];
    return;
    NSString* strUrl = @"10061/?url=http://www.yongjinbao.com.cn&&fullscreen=1&&secondtype=0";
    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)strUrl lParam:0];
}

#pragma mark 开户调用方法
-(void)OnOpenAccount:(id)sender
{
    [TZTUIBaseVCMsg OnMsg:TZT_MENU_StartOpen wParam:0 lParam:0];
    return;
#ifdef Support_GJKHHTTPData
#if defined(__GNUC__) && !TARGET_IPHONE_SIMULATOR && ( defined(__APPLE_CPP__) || defined(__APPLE_CC__) || defined(__MACOS_CLASSIC__) )
    if (g_nThemeColor == 0) {
        [tztkhAppSetting getShareInstance].nSkinType = 0;
    }
    else if (g_nThemeColor == 1)
    {
        [tztkhAppSetting getShareInstance].nSkinType = 1;
    }
    g_nSkinType = [tztkhAppSetting getShareInstance].nSkinType;
    NSString* pActionKey = @"10048";
    NSArray* pArry = [NSArray arrayWithObjects:g_pTZTAppObj.window,g_navigationController,self,pActionKey,nil];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:pArry,@"APP",@"1", @"RunByURL",nil];
    [[tztkhApp getShareInstance] callService:(NSDictionary *)params withDelegate:self];
#endif
#endif
}



//处理融资融券划转登录
-(void)SetHZ
{
    if (!_bISHz)
        return;
    
    if (g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < 1)
        return;
    //当前融资融券账号数据
    NSMutableArray* ayLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountRZRQType];
    if (ayLoginInfo == NULL || [ayLoginInfo count] < 1)
        return;
    
    tztJYLoginInfo* pJyLoginInfo = [ayLoginInfo objectAtIndex:0];
    if (pJyLoginInfo == NULL)
        return;
    
    
    //融资融券对应的普通账号
    NSString* strAccount = pJyLoginInfo.nsUserCode;
    if (strAccount == NULL || [strAccount length] < 1)
        return;
    
    //普通账号
    if (_pickPtData == NULL)
        _pickPtData = NewObject(NSMutableArray);
    [_pickPtData removeAllObjects];
    
    tztZJAccountInfo* pZJAccount = pJyLoginInfo.ZjAccountInfo;
    if (pZJAccount == nil)
        return;
    
    pZJAccount.nsAccount = strAccount;
    [_pickPtData addObject:pZJAccount];
    
    [self OnSetPicker];
}

-(void)OnAddAccount
{
    tztUIAddAccountViewController *pVC = [[tztUIAddAccountViewController alloc] init];
    pVC.nLoginType = _nLoginType;
    [pVC setMsgID:_nMsgID MsgInfo:(void*)self.pMsgInfo LPARAM:(NSUInteger)_lParam];
    
    if (IS_TZTIPAD)
    {
        TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
        if (!pBottomVC)
            pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
        CGRect rcFrom = CGRectZero;
        rcFrom.origin = pBottomVC.view.center;
        rcFrom.size = CGSizeMake(500, 500);
        [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
    }
    else
    {
#ifdef tzt_NewVersion
        pVC.pParentVC = self.delegate;
        [TZTUIBaseVCMsg IPadPushViewController:self.delegate pop:pVC];
#else
        [g_navigationController popViewControllerAnimated:NO];
        [g_navigationController pushViewController:pVC animated:NO];
#endif
    }
    
    [pVC release];
}

//记录页面功能，用于页面跳转
-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam
{
    _nMsgID = nID;
    _pMsgInfo = pMsgInfo;
    if (_pMsgInfo)
        [_pMsgInfo retain];
    _lParam = lParam;
}

//获取用户预设账号信息
-(void)OnRefreshData
{
    if (_bISHz)
        return;
    
    //发送数据时候,清空下拉框内容,避免只有一条数据时,删除后,显示错误的问题 modify by xyt 20132024
//    [_tztTableView setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:1000];
    
    if (self.pCurZJAccount.nsAccount.length>0) {
        dplAccount.textfield.text = self.pCurZJAccount.nsAccount;
    }
    else
    {
        dplAccount.textfield.text = @"";
    }
    
    [TZTUserInfoDeal SaveAddLoadJYAccountList:FALSE ayList:self.ayAccountData];
    
 
    if (self.pCurZJAccount == NULL)
        _pCurZJAccount = NewObject(tztZJAccountInfo);
    //根据读取到的数据进行显示
    [tztZJAccountInfo ReadAccountInfo];
    [self setAccountWithType];
    [self OnSetPicker];
}

- (void)refreshWhenAppear
{
    if (bWithoutCode) // have login once or more times
    {
        tfCode.text = @"";
        tfpw.text = @"";
        [btnSend setTitle:[self GetRamdonsWord] forState:UIControlStateNormal];
    }
//    //根据读取到的数据进行显示
    [tztZJAccountInfo ReadAccountInfo];
    [self setAccountWithType];
    [self OnSetPicker];
}

#pragma mark --textFiledDelegate

- (void)tztDroplistView:(tztUIDroplistView *)view didSelectIndex:(NSInteger)index//选中
{
//    [tztJYLoginInfo SetDefaultAccount:view.text nType_:_nLoginType];
    switch ([view.tzttagcode integerValue]) {
        case  10102:
            //位图类型
            break;
        case 1002:{
            if (index==0) {
                [_tztTableView setEditorText:@"" nsPlaceholder_:@"请输入通讯密码" withTag_:2000];

            }else{
                    [_tztTableView setEditorText:@"" nsPlaceholder_:@"请输入动态口令" withTag_:2000];
                
            }
        }
            break;
        case 10405:
            //普通委托
            break;
        case 10202:
        {
            if (_nLoginType == TZTAccountPTType || _nLoginType == TZTAccountRZRQType) {
                _currentIndex  =  [_tztTableView getComBoxSelctedIndex:999];
                [self updateXZZH];
    
            }
            
        }
      
            break;
        case 10302:
        {
            _isInPutValue = NO;
            [_tztTableView setEditorText:@"" nsPlaceholder_:@"请输入交易密码" withTag_:1001];
            [_tztTableView setEditorText:@"" nsPlaceholder_:@"请输入通讯密码" withTag_:2000];
        }
        default:
            break;
    }

}

- (void)loginClicked:(id)sender
{
    if (dplAccount)
        [dplAccount doHideListEx];
    [self OnLogin];
}

-(void)OnButtonClick:(id)sender
{
    if (dplAccount)
        [dplAccount doHideListEx];
    tztUIButton *btn = (tztUIButton*)sender;
    if ([btn.tzttagcode intValue] == 4000)
    {
        if(_tztTableView)
        {
            if([_tztTableView CheckInput])
                [self OnLogin];
        }
    }
    else if ([btn.tzttagcode intValue] == 4001)
    {
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_MNJY wParam:(NSUInteger)self.delegate lParam:0];
    }
}

-(BOOL)CheckSysLogin
{
    [tztUserData getShareClass];
    if (g_pSystermConfig && g_pSystermConfig.bNeedRegist)
    {
        g_nsLogMobile = [tztKeyChain load:tztLogMobile];
        if ([g_nsLogMobile length] < 11 || ![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
        {
            //系统登录
            BOOL bPush = FALSE;
            tztUISysLoginViewController *pVC = (tztUISysLoginViewController *)gettztHaveViewContrller([tztUISysLoginViewController class], tztvckind_Pop,[NSString stringWithFormat:@"%d", MENU_SYS_JYLogin], &bPush,TRUE);
            [pVC retain];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 500);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if (bPush)
            {
//#ifdef tzt_NewVersion
//                [TZTUIBaseVCMsg IPadPushViewController:g_navigationController pop:pVC];
//#else
                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
//#endif
            }
            [pVC release];
            return FALSE;
        }
    }
    return TRUE;
}

#pragma mark 开户

-(void)kaiHuBtnClick
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xi-bu-zheng-quan-zhang-shang/id962278472?l=en&mt=8"]];
}
#pragma mark 忘记密码
-(void)forgetPwd{

    ShangChengViewController *vc = [[[ShangChengViewController alloc] init] autorelease];
    NSString* strFile = @"xbxty/app/jy/jy_wjmm.htm";
    NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:strFile];
    vc.nHasToolbar = NO;
    [vc setWebURL:strURL];
    [vc setTitle:@"忘记密码"];
    [g_navigationController pushViewController:vc animated:YES];

}
#pragma mark 用户登录
-(void)OnLogin
{
    //交易类别
    NSString* jyAccountType=nil;
    if (_nLoginType == TZTAccountPTType)
    {
        
        jyAccountType = @"0";
    }
    else if (_nLoginType == TZTAccountRZRQType)
    {
        jyAccountType = @"1";
    }else{
        jyAccountType = @"2";//addAccount
    }
    
    NSString* nsAccountType = nil;//委托类别
    NSInteger accoutInde = [_tztTableView getComBoxSelctedIndex:999];
    nsAccountType =[_pickerTypeData objectAtIndex:accoutInde];

    //    NSString* nsAccount = @"";
 

    //账号
    NSString* nsAccount = @"";
    NSInteger select = 0;
    /*
    NSString* account = [_tztTableView getComBoxText:1000];
    BOOL isWiteByInputValue = NO;
    select = [_tztTableView getComBoxSelctedIndex:1000];
    if (account<=0) {
         tztAfxMessageBoxAnimated(@"账号不能为空!", YES);
        return;
    }else{
         if (select>=0) {
            nsAccount = [_pickerData objectAtIndex:select];
        }else{
            nsAccount = [_tztTableView getComBoxText:1000];
        }
        
        
        if (![nsAccount isEqualToString: account] && select >=0) {
            nsAccount = account;
            isWiteByInputValue = YES;
        }else {
            isWiteByInputValue = NO;
        }
 
//        //索引默认是0 0有两种情况
//        if (select ==0 && ![nsAccount isEqualToString: account]) {
//            isWiteByInputValue = NO;
//        }else if (select == 0 && [nsAccount isEqualToString: account]){
//            isWiteByInputValue = NO;
//        }else if(select >0 && ![nsAccount isEqualToString: account]){
//            isWiteByInputValue = YES;
//        }else if(select >0 && [nsAccount isEqualToString: account]){
//            isWiteByInputValue = NO;
//        }else if(select<0){
//            isWiteByInputValue = YES;
//        }
        //如果是YES说明的是你输入的和返回的有同相同账号 如果是NO 是你输入的
 
        
    }
     */
 
    if (_isInPutValue) {
        nsAccount =_nsAccount;
    }else{
         select = [_tztTableView getComBoxSelctedIndex:1000];
        if (select>=0) {
        nsAccount = [_pickerData objectAtIndex:select];
        }
    }
    //交易密码
    NSString* nsPass = [_tztTableView GetEidtorText:1001];
    if (nsPass.length < 6)
    {
        [self showMessageBox:@"请输入正确的交易密码!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    //输入通讯密码
    NSInteger txmmIndex = [_tztTableView getComBoxSelctedIndex:1002];
    NSString* nsYZM = @"";
    nsYZM = [_tztTableView GetEidtorText:2000];

    

    if (nsYZM == NULL || [nsYZM length] < 1)
    {
        NSString* errorMessage ;
        if (txmmIndex==0) {
            errorMessage = @"请输入正确的通讯密码！";
        }else{
            errorMessage = @"请输入正确的口令！";
        }
        [self showMessageBox:errorMessage nType_:TZTBoxTypeNoButton nTag_:0];
        
        return;
    }
    //通讯密码Drection 是0 动态口令 是1
    NSString* direction = 0;
    if (txmmIndex ==0 ) {
        direction = @"0";
    }else if (txmmIndex ==1){
        direction = @"1";
    }
    if (![self CheckSysLogin])
        return;
    
    NSString* nsYYB = @"";
    if (!_isInPutValue) {
        tztZJAccountInfo *info = [tztZJAccountInfo GetCurAccount];
        nsYYB = info.nsCellIndex;
    }else
    {
        nsYYB = [NSString stringWithFormat:@"%@", g_pSystermConfig.sYYBCode];
    }
    if (self.pCurZJAccount)
    {
        self.pCurZJAccount.nsAccount = [NSString stringWithFormat:@"%@", nsAccount];
        self.pCurZJAccount.nsPassword = [NSString stringWithFormat:@"%@", nsPass];
        self.pCurZJAccount.nsCellIndex = [NSString stringWithFormat:@"%@", nsYYB];
        self.pCurZJAccount.nsAccountType = [NSString stringWithFormat:@"%@", nsAccountType];
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [pDict setTztValue:nsAccountType forKey:@"accounttype"];
    
    [pDict setTztValue:nsYYB forKey:@"YybCode"];
    
    [pDict setTztValue:nsAccount forKey:@"account"];
    [pDict setTztValue:nsPass forKey:@"password"];
    [pDict setTztValue:@"10" forKey:@"Maxcount"];
    [pDict setValue:direction forKey:@"direction"];
    [pDict setValue:nsYZM forKey:@"compassword"];
    //增加账号类型获取token
    // [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountPTType] forKey:tztTokenType];
    [pDict setTztObject:jyAccountType forKey:tztTokenType];
    
    if (_nLoginType == TZTAccountPTType)
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"100" withDictValue:pDict];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"104" withDictValue:pDict];
    }
    DelObject(pDict);
}

-(void)OnSendUniqueId
{
    [self OnSendUniqueId:nil];
}

-(void)OnSendUniqueId:(NSTimer*)nsTimer
{
    int nAccountType = TZTAccountPTType;
    if (nsTimer != nil)
    {
        NSString *nsAccountType = [nsTimer userInfo];
        if (nsAccountType && nsAccountType.length > 0)
        {
            nAccountType = [nsAccountType intValue];
        }
    }
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    if (self.pCurZJAccount && self.pCurZJAccount.nsAccount)
        [pDict setTztObject:self.pCurZJAccount.nsAccount forKey:@"account"];
    
    if (g_nsUpVersion)
        [pDict setTztObject:g_nsUpVersion forKey:@"version"];
    
    tztJYLoginInfo *pLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (pLoginInfo && pLoginInfo.nsKHBranch)
    {
        [pDict setTztObject:pLoginInfo.nsKHBranch forKey:@"khbranch"];
    }
    
    NSString *str = [tztKeyChain load:tztUniqueID];
    if (str)
        [pDict setTztObject:str forKey:@"uniqueid"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"44800" withDictValue:pDict];
    DelObject(pDict);
    
    //    /*发出请求后，直接认为跳转，对返回不做处理*/
    if (nAccountType == TZTAccountRZRQType)//融资融券，直接跳转成功处理
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(OnOK)
                                       userInfo:nil
                                        repeats:NO];
    }
    else//否则，请求多存管信息
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(doInquireMoreAccount)
                                       userInfo:nil
                                        repeats:NO];
    }
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
//    if (bWithoutCode) // have login once or more times
    {
        tfCode.text = @"";
        [btnSend setTitle:[self GetRamdonsWord] forState:UIControlStateNormal];
    }
    
    if ([pParse IsAction:@"44800"])
    {
        if ([pParse GetErrorNo] >= 0)
        {
            NSString* strPID = [pParse GetByName:@"PID"];
            if (strPID && strPID.length > 0)
            {
                NSString* strID = [NSString stringWithFormat:@"%@-%@", tztPID, self.pCurZJAccount.nsAccount];
                [tztKeyChain save:strID data:strPID];
            }
        }
        return 0;
    }
    
    if ([pParse GetErrorNo] < 0)
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        if ([pParse IsAction:@"340"])//多银行请求，虽然失败，但仍然可以使用
        {
            [self OnOK];
        }
        return 0;
    }


    if ([pParse IsAction:@"100"] || [pParse IsAction:@"104"])
    {
//		if(g_ZJAccountArray && g_AccountIndex >= 0 && g_AccountIndex < [g_ZJAccountArray count])//数组越界
//			self.pCurZJAccount = [g_ZJAccountArray objectAtIndex:g_AccountIndex];
        NSString* nsPass = tfpw.text;
        int nAccountType = TZTAccountPTType;
        if([pParse IsAction:@"104"])
            nAccountType = TZTAccountRZRQType;
        
        [tztUserStock getShareClass].nsAccount = [NSString stringWithFormat:@"%@", self.pCurZJAccount.nsAccount];
		[tztJYLoginInfo SetLoginInAccount:pParse Pass_:nsPass AccountInfo_:self.pCurZJAccount AccountType:nAccountType];
        
//wry 保存账号信息
#ifdef SaveAccountInLocal
        [self.pCurZJAccount SaveAccountInfo];
#endif
        [self.pCurZJAccount SaveCurrentData:nAccountType];
        
        if (self.pCurZJAccount.nsAccount.length == 0) {
            dplAccount.textfield.text = @"";
        }
        
        [tztJYLoginInfo SetDefaultAccount:self.pCurZJAccount.nsAccount nType_:_nLoginType];
        bWithoutCode = YES;
        
		SEL doOkLogin;
        //判断登录类型
		if([tztJYLoginInfo getcreditfund] == 1 || nAccountType == TZTAccountRZRQType)
		{
			doOkLogin = @selector(OnOK);
		}
		else//非融资融券账户，请求多账户信息
		{
#ifdef TZT_PUSH
            //
            NSString* strAccount = @"";
            NSString* strkhbranch = @"";
            
            if (self.pCurZJAccount && self.pCurZJAccount.nsAccount)
                strAccount =  self.pCurZJAccount.nsAccount;
            
            tztJYLoginInfo *pLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
            if (pLoginInfo && pLoginInfo.nsKHBranch)
            {
                strkhbranch = pLoginInfo.nsKHBranch;
            }

            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:strAccount, @"account", strkhbranch, @"khbranch", nil];
            [[tztPushDataObj getShareInstance] tztSendUniqueIdWithAccount:dict];
#endif
            //doOkLogin = @selector(OnOK);
            doOkLogin = @selector(doInquireMoreAccount);
		}
		[NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:doOkLogin
                                       userInfo:nil
                                        repeats:NO];
        
    }
    if ([pParse IsAction:@"340"])
    {
        tztJYLoginInfo *pJyLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
        [pJyLoginInfo saveMoreAccountToDealerInfo:pParse];
        [self OnOK];
    }

    if ([pParse IsAction:@"201"])//获取账号类型
    {
        NSString* nsAccountType = [pParse GetByNameUnicode:@"AccountType"];
        if (nsAccountType && nsAccountType.length > 0)
        {
            NSArray* pAyType = [nsAccountType componentsSeparatedByString:@"\r\n"];
            
            if (_pickerTypeData == NULL)
                _pickerTypeData = NewObject(NSMutableArray);
            
            [_pickerTypeData removeAllObjects];
            
            NSMutableArray* pAyName = NewObjectAutoD(NSMutableArray);
            for (int i = 0; i < [pAyType  count]; i++)
            {
                NSString* strData = [pAyType objectAtIndex:i];
                if (strData == NULL || [strData length] < 1)
                    continue;
                
                NSArray* pAy = [strData componentsSeparatedByString:@"|"];
                if (pAy == NULL || [pAy count] < 2)
                    continue;
                NSString* nsType = [pAy objectAtIndex:0];
                NSString* nsName = [pAy objectAtIndex:1];
                if (nsType == NULL)
                    continue;
                 nsType = [nsType uppercaseString];
                if (_nLoginType ==TZTAccountPTType) {
                    if ([nsType hasPrefix:@"RZRQ"]) {
                       continue;
                    }
                }else if (_nLoginType ==TZTAccountRZRQType) {
                    if (![nsType hasPrefix:@"RZRQ"]) {
                        continue;
                    }
                }
//                else if(_nLoginType == addAccount){
//                    //添加账号没有做处理
//                }
                [_pickerTypeData addObject:nsType];
                [pAyName addObject:nsName];
               
                
            }
            //设置下拉框的账号选择数据
            [_tztTableView setComBoxData:pAyName ayContent_:pAyName AndIndex_:0 withTag_:999];
//            [self getZHxinxi];//获取账号信息
            
            if (_nLoginType == TZTAccountPTType || _nLoginType == TZTAccountRZRQType) {
 
                [self setAccountWithType];
                [tztZJAccountInfo ReadAccountInfo];
                NSMutableArray *tempAy = [self getCurrentAccountAy];
                if (tempAy.count>0) {
                    [self addAccountAndShowListView];
                    [TZTUserInfoDeal SaveAndLoadJYAccountList:TRUE];
                }
            }

//            [self setComboxType:_nLoginType];
        }
    }
    if ([pParse IsAction:@"207"]) {
         if (_nLoginType == TZTAccountPTType || _nLoginType == TZTAccountRZRQType) {
             [tztJYLoginInfo SetAccountList:pParse];
             [self setAccountWithType];
//             [self OnSetPicker];

              [tztZJAccountInfo ReadAccountInfo];
             NSMutableArray *tempAy = [self getCurrentAccountAy];
             if (tempAy.count>0) {
                 [self addAccountAndShowListView];
                 [TZTUserInfoDeal SaveAndLoadJYAccountList:TRUE];
             }
        }
        
    }
    return 0;
}
-(void)setComboxType:(NSInteger)type{
    
    if (type == TZTAccountRZRQType || type == TZTAccountPTType ) {
        [_tztTableView SetImageHidenFlag:@"TZTZJZH" bShow_:YES];
        [_tztTableView SetImageHidenFlag:@"TZTADDCount" bShow_:NO];
    }else{
        [_tztTableView SetImageHidenFlag:@"TZTZJZH" bShow_:NO];
        [_tztTableView SetImageHidenFlag:@"TZTADDCount" bShow_:YES];

    }
   
	[_tztTableView  OnRefreshTableView];
    

}
-(void) doInquireMoreAccount
{
#ifdef Support_DFCG//支持多存管
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    tztZJAccountInfo *pCurZJ = [tztZJAccountInfo GetCurAccount];
    if (pCurZJ.nsAccount)
        [pDict setTztValue:pCurZJ.nsAccount forKey:@"account"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"340" withDictValue:pDict];
    DelObject(pDict);
#else//不支持，直接跳转
    [self OnOK];
#endif
}

-(void)OnOK
{
    if ([TZTUserInfoDeal IsTradeLogin:StockTrade_Log] || [TZTUserInfoDeal IsTradeLogin:RZRQTrade_Log])
    {
        if (IS_TZTIPAD)
        {
            [g_navigationController popViewControllerAnimated:UseAnimated];
//            [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
            if (_nMsgID != -1)
            {
                [TZTUIBaseVCMsg OnMsg:_nMsgID wParam:(NSUInteger)self.pMsgInfo lParam:_lParam];
            }
        }
        else
        {
//            _lParam = 0;
//            
            
            if (_nMsgID > 0)
            {
#ifndef YJBLightVersion
                
#ifdef tzt_SideViewController
                PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
                if (direction > 0)
                {
                    if (direction == PPRevealSideDirectionLeft)
                    {

                        [[TZTAppObj getShareInstance].rootTabBarController.leftVC OnReturnBack];
                    }
                    else if (direction == PPRevealSideDirectionRight)
                    {
                        [[TZTAppObj getShareInstance].rootTabBarController.rightVC OnReturnBack];
                    }
//                    return;
                }
                else
                    [g_navigationController popViewControllerAnimated:NO];
#else
                [g_navigationController popViewControllerAnimated:NO];
#endif
#endif
// 修改重新激活密码后错误
//                [g_navigationController popViewControllerAnimated:NO];
                [TZTUIBaseVCMsg OnMsg:_nMsgID wParam:(NSUInteger)self.pMsgInfo lParam:_lParam];
            }
            else
            {
                //登陆成功，打开交易首页
                tztWebViewController *vc = [[[tztWebViewController alloc] init] autorelease];
                NSString* strFile = @"sjkh/jy_index.htm";
                if (g_nThemeColor == 1) {
                    strFile = @"sjkh/jy_index.htm?skinType=1";
                }
                NSString* strURL = [tztlocalHTTPServer getLocalHttpUrl:strFile];
                vc.nHasToolbar = NO;
                [vc setWebURL:strURL];
                vc.nTitleType = TZTTitleNormal;
                [vc setVcShowType:[NSString stringWithFormat:@"%d",tztVcShowTypeRoot]];
#ifdef YJBLightVersion
                [vc SetHidesBottomBarWhenPushed:YES];
#endif
                vc.nMsgType = tztTradePage;
                [g_navigationController pushViewController:vc animated:UseAnimated];
            }
        }
		
    }
    else
    {
//#ifndef YJBLightVersion
//        [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
//#else
        [g_navigationController popViewControllerAnimated:UseAnimated];
//#endif
    }
}
-(NSMutableArray*)getCurrentAccountAy
{
    NSMutableArray *tempAy = nil;
    //当前登录类型是普通交易
    if (_nLoginType == TZTAccountPTType)
    {
        if ([_pickPtData count] > 0)
        {
            tempAy = [NSMutableArray arrayWithArray:_pickPtData];
        }
    }
    else
    {
        if ([_pickRZRQData count] > 0)
        {
            tempAy = [NSMutableArray arrayWithArray:_pickRZRQData];
        }
    }
    return tempAy;
}

-(void)setAccountWithType
{
    //普通账号
    if (_pickPtData == NULL)
        _pickPtData = NewObject(NSMutableArray);
    [_pickPtData removeAllObjects];
    
    //融资融券账号
    if (_pickRZRQData == NULL)
        _pickRZRQData = NewObject(NSMutableArray);
    [_pickRZRQData removeAllObjects];
    
    if (g_ZJAccountArray == NULL || [g_ZJAccountArray count] <1)
        return;
    
    for (int i = 0; i < [g_ZJAccountArray count]; i++)
    {
        tztZJAccountInfo* pZJAccount = [g_ZJAccountArray objectAtIndex:i];
        if (pZJAccount == nil)
            continue;
        NSString* strType = [NSString stringWithFormat:@"%@", pZJAccount.nsAccountType];
        if (strType == NULL)
            continue;
        strType = [strType uppercaseString];
        if (strType != NULL && [strType hasPrefix:@"RZRQ"])
        {
            [_pickRZRQData addObject:pZJAccount];
        }
        else
        {
            [_pickPtData addObject:pZJAccount];
        }
        
    }
}
-(void)updateXZZH{
    if (_pickerData == NULL)
        _pickerData = NewObject(NSMutableArray);
    [_pickerData removeAllObjects];
    
    //根据登录的类型获取
    NSMutableArray *tempAy = [self getCurrentAccountAy];
    if (tempAy == NULL || [tempAy count] < 1)
        return;
    
    //清空账号数据,重新设置
    [g_ZJAccountArray removeAllObjects];
    [g_ZJAccountArray setArray:tempAy];
    
    g_AccountIndex = -1;
    NSString* nsfault = @"";
    //获取默认
    nsfault = [tztJYLoginInfo GetDefaultAccount:YES nType_:_nLoginType];
    
    for (int i = 0; i < [tempAy count]/*g_ZjAccountArrayNum*/; i++)
    {
        tztZJAccountInfo* pZJAccount = [tempAy objectAtIndex:i];//[g_ZJAccountArray objectAtIndex:i];
        if (pZJAccount == nil)
            continue;
        if(nsfault && [nsfault length] > 0)
        {
            if ([nsfault compare:pZJAccount.nsAccount] == NSOrderedSame )
            {
                g_AccountIndex = i;
            }
        }
        if ([pZJAccount.nsAccountType isEqualToString: [_pickerTypeData objectAtIndex:_currentIndex]]) {
            [_pickerData addObject:pZJAccount.nsAccount];
        }
        
    }
    
    if (g_AccountIndex < 0 || g_AccountIndex >= [tempAy count]/*g_ZjAccountArrayNum*/)
    {
        g_AccountIndex = 0;
    }
    
    [self OnDealData];

}
//设置信息
-(void)OnSetPicker
{
    if (_pickerData == NULL)
        _pickerData = NewObject(NSMutableArray);
    [_pickerData removeAllObjects];
    
    //根据登录的类型获取
    NSMutableArray *tempAy = [self getCurrentAccountAy];
    if (tempAy == NULL || [tempAy count] < 1)
        return;
    
    //清空账号数据,重新设置
    [g_ZJAccountArray removeAllObjects];
    [g_ZJAccountArray setArray:tempAy];
    
    g_AccountIndex = -1;
	NSString* nsfault = @"";
	//获取默认
	nsfault = [tztJYLoginInfo GetDefaultAccount:YES nType_:_nLoginType];
    
	for (int i = 0; i < [tempAy count]/*g_ZjAccountArrayNum*/; i++)
	{
		tztZJAccountInfo* pZJAccount = [tempAy objectAtIndex:i];//[g_ZJAccountArray objectAtIndex:i];
        if (pZJAccount == nil)
            continue;
		if(nsfault && [nsfault length] > 0)
		{
			if ([nsfault compare:pZJAccount.nsAccount] == NSOrderedSame )
			{
				g_AccountIndex = i;
			}
		}
        if (_nLoginType == TZTAccountRZRQType)
            [_pickerData addObject:pZJAccount.nsAccount];
        else
            [_pickerData addObject:pZJAccount.nsAccount];
	}
    
    if (g_AccountIndex < 0 || g_AccountIndex >= [tempAy count]/*g_ZjAccountArrayNum*/)
    {
        g_AccountIndex = 0;
    }
    
    [self OnDealData];

}
#pragma mark x207 新增加方法
-(void)addAccountAndShowListView{
    if (_pickerData == NULL)
        _pickerData = NewObject(NSMutableArray);
    [_pickerData removeAllObjects];
    
    //根据登录的类型获取
    NSMutableArray *tempAy = [self getCurrentAccountAy];
    if (tempAy == NULL || [tempAy count] < 1){
//        dplAccount.ayData = tempAy;
//        dplAccount.ayValue = tempAy;
//        [_tztTableView setComBoxData:tempAy ayContent_:tempAy AndIndex_:-1 withTag_:1000];
        return;
    }

    [tztZJAccountInfo ReadAccountInfo];
    
//    for (int i=0; i<g_ZJAccountArray.count; i++) {
//        tztZJAccountInfo *save = [g_ZJAccountArray[i] retain];
//        NSLog(@"~~~~~%@",save.nsAccount);
//    }
    for (int i=0; i<g_ZJAccountArray.count; i++) {
        tztZJAccountInfo *save = [g_ZJAccountArray[i] retain];
        for (int j =0; j<tempAy.count; j++) {
            tztZJAccountInfo *get = tempAy[j];
            if ([save.nsAccount isEqualToString:get.nsAccount]) {
                [g_ZJAccountArray removeObject:save];
            }
     
        }
    }
    for (int i =0;  i<g_ZJAccountArray.count;  i++) {
            tztZJAccountInfo *get = g_ZJAccountArray[i];
            
            BOOL isAccount = NO;
            if (_nLoginType == TZTAccountPTType) {
                if ([get.nsAccountType rangeOfString:@"RZRQ"].length>0) {
                    isAccount = NO;
                }else{
                    isAccount = YES;
                }
            }
            else {
                if ([get.nsAccountType rangeOfString:@"RZRQ"].length>0) {
                    isAccount = YES;
                }else {
                    isAccount = NO;
                }
            }
            if (isAccount) {
            [tempAy insertObject:g_ZJAccountArray[i] atIndex:0];
            }
    }
    //清空账号数据,重新设置
    [g_ZJAccountArray removeAllObjects];
    [g_ZJAccountArray setArray:tempAy];
    
    g_AccountIndex = -1;
    NSString* nsfault = @"";
    //获取默认
    nsfault = [tztJYLoginInfo GetDefaultAccount:YES nType_:_nLoginType];
    
    for (int i = 0; i < [tempAy count]/*g_ZjAccountArrayNum*/; i++)
    {
        tztZJAccountInfo* pZJAccount = [tempAy objectAtIndex:i];//[g_ZJAccountArray objectAtIndex:i];
        if (pZJAccount == nil)
            continue;
        if(nsfault && [nsfault length] > 0)
        {
            if ([nsfault compare:pZJAccount.nsAccount] == NSOrderedSame )
            {
                g_AccountIndex = i;
            }
        }
        if (_nLoginType == TZTAccountRZRQType)
            [_pickerData addObject:pZJAccount.nsAccount];
        else
            [_pickerData addObject:pZJAccount.nsAccount];
    }
    
    if (g_AccountIndex < 0 || g_AccountIndex >= [tempAy count]/*g_ZjAccountArrayNum*/)
    {
        g_AccountIndex = 0;
    }
    
    [self OnDealData];
    

}
-(void)SetDefaultData
{
    [self OnDealData];
}

-(void)OnDealData
{
    //设置下拉框的账号选择数据
    if(_pickerData && [_pickerData count] > g_AccountIndex)
    {
        dplAccount.ayData = _pickerData;
        dplAccount.ayValue = _pickerData;
#ifdef AccoutAddPWD
        NSMutableArray* pickDat = NewObject(NSMutableArray);
        for (int i=0; i<_pickerData.count; i++) {
            NSString*data = [_pickerData objectAtIndex:i];
            NSString*account = [tztJYLoginInfo HideFund:data];
            [pickDat addObject:account];
        }
        [_tztTableView setComBoxData:pickDat ayContent_:pickDat AndIndex_:g_AccountIndex withTag_:1000];
#else
          [_tztTableView setComBoxData:_pickerData ayContent_:_pickerData AndIndex_:g_AccountIndex withTag_:1000];
#endif
        //设置当前账号对应的登陆方式
//        [self setCurAccountLoginType];
    }
    else
    {
        g_AccountIndex = -1;
        dplAccount.ayData = _pickerData;
        dplAccount.ayValue = _pickerData;
        [_tztTableView setComBoxData:nil ayContent_:nil AndIndex_:g_AccountIndex withTag_:1000];
    }
    [_tztTableView setEditorText:@"" nsPlaceholder_:@"请输入交易密码" withTag_:1001];

    [_tztTableView setEditorText:@"" nsPlaceholder_:@"请输入通讯密码" withTag_:2000];
    [dplAccount setSelectindex:g_AccountIndex];
    
    
}

- (void)changeIDCode:(id)sender
{
    if (dplAccount)
        [dplAccount doHideListEx];
    
    [btnSend setTitle:[self GetRamdonsWord] forState:UIControlStateNormal];
}

//获取随机数
-(NSString *)GetRamdonsWord
{
	int first =  arc4random();
	first = abs(first);
	do{
		first =  arc4random();
		first = abs(first);
	}while(first < 1000);
	
	NSString *tempStr = [NSString stringWithFormat:@"%d",first];
	tempStr = [tempStr substringWithRange:NSMakeRange(0, 4)];
	return tempStr;
}
#pragma mark --beginEditText
- (void)tztUIBaseView:(UIView *)tztUIBaseView beginEditText:(NSString *)text
{
//    if (dplAccount)
//        [dplAccount doHideListEx];
//    if(tztUIBaseView.tag ==2003) {
//    [UIView animateWithDuration:2 animations:^{
//        CGRect rect = self.frame;
//        rect.origin.y-=216;
//        self.frame = rect;
//    }];
//    }
    
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    if (nTag == 1000) {
        
        [_tztTableView setComBoxText:@"" withTag_:1000];
//        [_tztTableView setEditorText:@"" nsPlaceholder_:@"请输入交易密码" withTag_:1000];
        _isInPutValue = YES;
    }
    
}
- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    //    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
    //    NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    if (nTag ==1000) {
        _nsAccount = text;
        _nsAccount = [_nsAccount copy];
    }
}

//删除账号
- (BOOL)tztDroplistView:(tztUIDroplistView *)droplistview didDeleteIndex:(NSInteger)index
{
    g_AccountIndex = index;
    [self OnDelAccount];
    return TRUE;
}

-(void)OnDelAccount
{
    //检查有效性
    if (g_AccountIndex < 0 || g_AccountIndex >= [g_ZJAccountArray count])
    {
		[self showMessageBox:@"没有账号可以操作!" nType_:TZTBoxTypeNoButton delegate_:self];
        return;
    }
    
    //得到账户
    tztZJAccountInfo *pZJAccount = [g_ZJAccountArray objectAtIndex:g_AccountIndex];
    //本地手动添加的
    if (pZJAccount.nsCellName == NULL || [pZJAccount.nsCellName length] < 1)
    {
        [g_ZJAccountArray removeObject:pZJAccount];
        g_ZjAccountArrayNum = [g_ZJAccountArray count];
        //重新保存
        //重新设置下拉列表的显示数据
        
        //删除当前账号
        if (self.pCurZJAccount.nsAccount.length>0) {
        [self.pCurZJAccount DeLAccount:pZJAccount.nsAccount];
        }
        
        [_tztTableView setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:1000];
        //清空combox
        [dplAccount.ayValue removeAllObjects];
        [dplAccount.ayData removeAllObjects];
        dplAccount.selectindex = -1;
        //wry
//        if ([dplAccount.textfield.text isEqualToString:pZJAccount.nsAccount]) {
//            dplAccount.textfield.text = @"";
//        }
//        if ([self.pCurZJAccount.nsAccount isEqualToString:pZJAccount.nsAccount]) {
//            self.pCurZJAccount = nil;
//        }
        
        //重新读取
//        [self OnRefreshData];
        [self addAccountAndShowListView];
        return;
    }
    
    
    //
    if (pZJAccount.nsCellIndex == NULL || [pZJAccount.nsCellIndex length] < 1)
        return;
    if (pZJAccount.nsAccount == NULL || [pZJAccount.nsAccount length] < 1)
        return;
    if (pZJAccount.nsAccountType == NULL || [pZJAccount.nsAccountType length] < 1)
        return;
    //向服务器发送删除账号请求
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [pDict setTztValue:pZJAccount.nsCellIndex forKey:@"YybCode"];
    [pDict setTztValue:pZJAccount.nsAccount forKey:@"account"];
    [pDict setTztValue:pZJAccount.nsAccountType forKey:@"accounttype"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"209" withDictValue:pDict];
    DelObject(pDict);
    [self getZHxinxi];
}


-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if(_tztTableView)
            {
                if([_tztTableView CheckInput])
                    [self OnLogin];
            }
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRefreshData];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Add:
        {
            [self OnAddAccount];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Del:
        {
            [self OnDelAccount];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Clear://
        {
            return TRUE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}
 
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏下拉
    if (dplAccount)
        [dplAccount doHideListEx];
    NSLog(@"点到啦！！");
}
@end
