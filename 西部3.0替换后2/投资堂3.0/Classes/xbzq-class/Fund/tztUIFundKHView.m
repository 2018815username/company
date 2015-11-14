/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金开户view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundKHView.h"
#import "tztWebView.h"
/*tag值，与配置文件中对应*/
enum  {
	kTagCode = 1000,//公司代码
    kTagName = 2000,//公司名称
    KTagZH = 3000,//基金账号
    KTagTS = 4000,
};

#define tztFundComCode @"tztFundComCode"
#define tztFundComName @"tztFundComName"

@interface tztUIFundKHView()<tztUIButtonDelegate,tztHTTPWebViewDelegate>
@property(nonatomic,retain)tztWebView   *pWebXY;//协议web
@property(nonatomic,retain)tztUIButton  *pButtonOK;
@end

@implementation tztUIFundKHView
@synthesize tztTradeTable = _tztTradeTable;
@synthesize ayCompanyData = _ayCompanyData;
@synthesize nReturn = _nReturn;
@synthesize ayKHType = _ayKHType;
@synthesize nsAddress = _nsAddress;
@synthesize nsEmail = _nsEmail;
@synthesize nsPhone =_nsPhone;
@synthesize nsPost =_nsPost;
@synthesize nsTelPhone = _nsTelPhone;
@synthesize pWebXY = _pWebXY;
@synthesize pButtonOK = _pButtonOK;
-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        //初始化数据
        self.nReturn = 0;
        _ayKHType = NewObject(NSMutableArray);
        [_ayKHType addObject:@"新开账号"];
        [_ayKHType addObject:@"增加账号"];
        self.nsAddress = @"";
        self.nsEmail = @"";
        self.nsPhone = @"";
        self.nsPost = @"";
        self.nsTelPhone = @"";
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayCompanyData);
    DelObject(_ayKHType);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)) 
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        [_tztTradeTable setTableConfig:@"tztUITradeFundKH"];
        [self addSubview:_tztTradeTable];
#ifdef Support_GTFundTrade
        //国泰的开户默认是新开
        [_tztTradeTable SetImageHidenFlag:@"TZTJJZH" bShow_:NO];
#endif
        [_tztTradeTable OnRefreshTableView];
        [_tztTradeTable setComBoxData:_ayKHType ayContent_:_ayKHType AndIndex_:0 withTag_:2001];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
        /*
    CGRect rcWeb = self.bounds;
    rcWeb.origin.y += 200;
    rcWeb.size.height = self.bounds.size.height - 350;
    if (_pWebXY == NULL)
    {
        _pWebXY = [[tztWebView alloc] initWithFrame:rcWeb];
        _pWebXY.tztDelegate = self;
        [self addSubview:_pWebXY];
        [_pWebXY release];
        _pWebXY.backgroundColor = [UIColor redColor];
        [_pWebXY setWebURL:[tztlocalHTTPServer getLocalHttpUrl:@"/yjb/agreement.htm"]];
        
    }
    else
    {
        _pWebXY.frame = rcWeb;
    }
    
    _pWebXY.hidden = YES;//ruyi
     */
    CGRect rcButton = self.bounds;
//    rcButton.origin.y += rcWeb.size.height + 5;
    rcButton.origin.y= 275;
    rcButton.size.height = 40;
    rcButton.size.width = 280;
    rcButton.origin.x = (self.bounds.size.width - rcButton.size.width) / 2;
    if (_pButtonOK == NULL)
    {
        _pButtonOK = [[tztUIButton alloc] initWithProperty:@"tag=5000|rect=,,,39|title=确 定|backimage=TZTButtonBack.png|type=custom|"];
        _pButtonOK.frame = rcButton;
        _pButtonOK.tztdelegate = self;
        [self addSubview:_pButtonOK];
        [_pButtonOK release];
    }
    else
    {
        _pButtonOK.frame = rcButton;
    }
}

-(void)tztWebView:(tztHTTPWebView *)webView withTitle:(NSString *)title
{
    //
    
    if (webView != _pWebXY)
        return;
    
    [NSTimer scheduledTimerWithTimeInterval:0.2f
                                     target:self
                                   selector:@selector(OnReload)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)OnReload
{
    int nValidHeigh = self.bounds.size.height - 200 - 50;
    UIWebView *pWeb = [_pWebXY getCurWebView];
    [pWeb sizeToFit];
    CGSize sz = pWeb.scrollView.contentSize;
    CGRect rc = _pWebXY.frame;
    if (rc.size.height > sz.height)
        rc.size.height = sz.height;
    else if (rc.size.height < sz.height)
    {
        if (sz.height < nValidHeigh)
            rc.size.height = sz.height;
        else
            rc.size.height = nValidHeigh;
    }
    _pWebXY.frame = rc;
    
    CGRect rcButton = _pButtonOK.frame;
    rcButton.origin.y = rc.origin.y + rc.size.height + 5;
    _pButtonOK.frame = rcButton;
}

/*函数功能：初始化显示数据
 入参：nsJJGSMC 基金公司名称 nsJJGSDM 基金公司代码 MsgType 返回界面类型
 出参：无
 */
-(void)SetShowMSG:(NSString *)nsJJGSMC NSFundDM:(NSString *)nsJJGSDM Return:(int)MsgType
{
    self.nReturn = MsgType;
    
    if (_ayCompanyData == NULL)
        _ayCompanyData = NewObject(NSMutableArray);
    [_ayCompanyData removeAllObjects];
    
    NSMutableArray* pAyCom = NewObject(NSMutableArray);
    NSMutableArray* pAyComName = NewObject(NSMutableArray);
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    [pDict setTztObject:nsJJGSDM forKey:tztFundComCode];
    [pDict setTztObject:nsJJGSMC forKey:tztFundComName];
    [_ayCompanyData addObject:pDict];
    [pAyCom addObject:nsJJGSMC];
    [pAyComName addObject:nsJJGSMC];
    DelObject(pDict);
    
    if (_tztTradeTable)
    {
        [_tztTradeTable setComBoxData:pAyCom ayContent_:pAyComName AndIndex_:0 withTag_:kTagName];
        NSMutableDictionary* pDict = [_ayCompanyData objectAtIndex:0];
        NSString* str = [pDict tztObjectForKey:tztFundComCode];
        [_tztTradeTable setLabelText:str withTag_:kTagCode];
    }
    DelObject(pAyCom);
    DelObject(pAyComName);
    [self GetUserInfo];
    
}
/*函数功能：请求用户信息
 入参：无
 出参：无
 */
-(void)GetUserInfo
{
#ifdef Support_GTFundTrade//目前国泰的才需要获取用户信息
    //请求用户信息
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"1000" forKey:@"Maxcount"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"187" withDictValue:pDict];
    DelObject(pDict);
#endif
}
-(void)SetDefaultData
{
    [self OnRequestData];
}

// iPad会在加载时调用请求信息 byDBQ20130829
- (void)OnRequestData
{
    //请求基金公司数据
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"1000" forKey:@"Maxcount"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"154" withDictValue:pDict];
    
    DelObject(pDict);
}

//清空界面数据
-(void) ClearData
{
    if (_tztTradeTable == NULL)
        return;
//    [_tztTradeTable setComBoxData:NULL ayContent_:NULL AndIndex_:0 withTag_:kTagName];
    [_tztTradeTable setLabelText:@"" withTag_:kTagCode];
//    [_tztTradeTable setLabelText:@"" withTag_:kTagName];
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:NULL withTag_:KTagZH];
}

-(void)OnSendKH
{
    if (_tztTradeTable == NULL)
        return;
    
    //ZXL 20130718 修改了获取基金公司代码的获取方式
    NSInteger select = [_tztTradeTable getComBoxSelctedIndex:kTagName];
    if (select >=  [_ayCompanyData count])
        return;
    NSMutableDictionary *pCompanyDict = [_ayCompanyData objectAtIndex:select];
    NSString* nsCode = [pCompanyDict tztObjectForKey:tztFundComCode];
    
    if (nsCode == NULL || [nsCode length] < 1)
    {
        [self showMessageBox:@"基金公司代码错误!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    NSString* nsAccount = [_tztTradeTable GetEidtorText:KTagZH];
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsCode forKey:@"JJDJGSDM"];
    
//    [pDict setTztValue:@"" forKey:@"JJGDXM"];
//    [pDict setTztValue:@"" forKey:@"JJGDLB"];
//    [pDict setTztValue:@"" forKey:@"JJSEX"];
//    [pDict setTztValue:@"" forKey:@"JJYZBM"];
//    [pDict setTztValue:@"" forKey:@"JJADDRESS"];
//    [pDict setTztValue:@"" forKey:@"JJTELPHONE"];
    if (nsAccount && nsAccount.length > 0)
        [pDict setTztObject:nsAccount forKey:@"JJTADM"];
    else
        [pDict setTztValue:@"" forKey:@"JJTADM"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"153" withDictValue:pDict];

    DelObject(pDict);
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo]) 
        return 0;
    
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];
    
    if ([tztBaseTradeView IsExitError:nErrNo])
    {
        [self OnNeedLoginOut];
        if (strError)
            tztAfxMessageBox(strError);
        return 0;
    }
    
    if (nErrNo < 0)
    {
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"153"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        [_tztTradeTable setEditorText:@"" nsPlaceholder_:NULL withTag_:KTagZH];
        return 1;
    }
    //zxl 20130711用户信息请求返回处理
    if ([pParse IsAction:@"187"])
    {
        int AddressIndex = -1;
        int PostIndex = -1;
        int TelePhoneIndex = -1;
        int MobilePhoneIndex = -1;
        int EmailIndex = -1;
        NSString * StrValue = [pParse GetByName:@"AddressIndex"];
        TZTStringToIndex(StrValue, AddressIndex);
        
        StrValue = [pParse GetByName:@"PostIndex"];
        TZTStringToIndex(StrValue, PostIndex);
        
        StrValue = [pParse GetByName:@"TelePhoneIndex"];
        TZTStringToIndex(StrValue, TelePhoneIndex);
        
        StrValue = [pParse GetByName:@"MobilePhoneIndex"];
        TZTStringToIndex(StrValue, MobilePhoneIndex);
        
        StrValue = [pParse GetByName:@"EmailIndex"];
        TZTStringToIndex(StrValue, EmailIndex);
        NSArray* pAyGrid = [pParse GetArrayByName:@"Grid"];
        
        for (int i = 1; i < [pAyGrid count]; i++)
        {
            NSArray* pAy = [pAyGrid objectAtIndex:i];
            if (pAy == NULL
                || AddressIndex >= [pAy count]
                || PostIndex >= [pAy count]
                || TelePhoneIndex >= [pAy count]
                || MobilePhoneIndex >= [pAy count]
                || EmailIndex >= [pAy count])
                continue;
            NSString * nsStr = [pAy objectAtIndex:AddressIndex];
            if (nsStr && [nsStr length] > 0)
                self.nsAddress = [NSString stringWithFormat:@"%@",nsStr];
            
            nsStr = [pAy objectAtIndex:PostIndex];
            if (nsStr && [nsStr length] > 0)
                self.nsPost = [NSString stringWithFormat:@"%@",nsStr];
            
            nsStr = [pAy objectAtIndex:TelePhoneIndex];
            if (nsStr && [nsStr length] > 0)
                self.nsTelPhone = [NSString stringWithFormat:@"%@",nsStr];
            
            nsStr = [pAy objectAtIndex:MobilePhoneIndex];
            if (nsStr && [nsStr length] > 0)
                self.nsPhone = [NSString stringWithFormat:@"%@",nsStr];
            
            nsStr = [pAy objectAtIndex:EmailIndex];
            if (nsStr && [nsStr length] > 1)
                self.nsEmail = [NSString stringWithFormat:@"%@",nsStr];
            else
                self.nsEmail = @"JJEMAIL";
            
            [self SetUserInfo];
        }
    }
    //查询基金公司返回
    if ([pParse IsAction:@"154"])
    {
        int nJJGSDMIndex = -1;
        int nJJGSMCIndex = -1;
        
        NSString* strValue = [pParse GetByName:@"JJGSDM"];
        if (strValue && [strValue length] > 0)
            nJJGSDMIndex = [strValue intValue];
        strValue = [pParse GetByName:@"JJGSMC"];
        if (strValue && [strValue length] > 0)
            nJJGSMCIndex = [strValue intValue];
        
        if (nJJGSDMIndex < 0 || nJJGSMCIndex < 0)
        {
            [self showMessageBox:@"返回数据有误(索引错误),请重新刷新数据!" nType_:TZTBoxTypeNoButton delegate_:nil];
            return 0;
        }
        
        NSArray* pAyGrid = [pParse GetArrayByName:@"Grid"];
        NSMutableArray* pAyCom = NewObject(NSMutableArray);
        NSMutableArray* pAyComName = NewObject(NSMutableArray);
        if (_ayCompanyData == NULL)
            _ayCompanyData = NewObject(NSMutableArray);
        [_ayCompanyData removeAllObjects];
        //0 是表格标题
        for (NSInteger i = 1; i < [pAyGrid count]; i++)
        {
            NSMutableArray* pAy = [pAyGrid objectAtIndex:i];
            if (pAy == NULL)
                continue;
            
            NSInteger nRet = [g_pSystermConfig CheckValidRow:pAy
                                            nRowIndex_:i
                                            nComIndex_:nJJGSDMIndex
                                             nMsgType_:_nMsgType
                                           bCodeCheck_:FALSE];
            if (nRet <= 0)
                continue;
            
            if (nJJGSMCIndex >= [pAy count] || nJJGSDMIndex >= [pAy count])
                continue;
            
            NSString* strGSDM = [pAy objectAtIndex:nJJGSDMIndex];
            NSString* strGSMC = [pAy objectAtIndex:nJJGSMCIndex];
            if (strGSDM == NULL || strGSMC == NULL)
                continue;
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strGSDM forKey:tztFundComCode];
            [pDict setTztObject:strGSMC forKey:tztFundComName];
            [_ayCompanyData addObject:pDict];
            [pAyCom addObject:strGSMC];
            [pAyComName addObject:strGSDM];
            DelObject(pDict);
        }
        
        if (_tztTradeTable)
        {
            [_tztTradeTable setComBoxData:pAyCom ayContent_:pAyComName AndIndex_:0 withTag_:kTagName];
            NSMutableDictionary* pDict = [_ayCompanyData objectAtIndex:0];
            NSString* str = [pDict tztObjectForKey:tztFundComCode];
            [_tztTradeTable setLabelText:str withTag_:kTagCode];
        }
        DelObject(pAyCom);
        DelObject(pAyComName);
        
        [self GetUserInfo];
    }
    return 1;
}

/*函数功能：设置用户信息
 入参：无
 出参：无
 */
-(void)SetUserInfo
{
    if (!_tztTradeTable)
        return;
    
    if (self.nsAddress && [self.nsAddress length] > 0)
        [_tztTradeTable setEditorText:self.nsAddress nsPlaceholder_:NULL withTag_:3001];
    
    if (self.nsPost && [self.nsPost length] > 0)
        [_tztTradeTable setEditorText:self.nsPost nsPlaceholder_:NULL withTag_:3002];
    
    if (self.nsTelPhone && [self.nsTelPhone length] > 0)
        [_tztTradeTable setEditorText:self.nsTelPhone nsPlaceholder_:NULL withTag_:3003];
    
    if (self.nsPhone && [self.nsPhone length] > 0)
        [_tztTradeTable setEditorText:self.nsPhone nsPlaceholder_:NULL withTag_:3004];
    
    if (self.nsEmail && [self.nsEmail length] > 0)
        [_tztTradeTable setEditorText:self.nsEmail nsPlaceholder_:NULL withTag_:3005];
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    int tag = [droplistview.tzttagcode intValue];
    switch (tag)
    {
        case 2000:
        {
            if (index >= [_ayCompanyData count] || [_ayCompanyData count] < 1)
                return;
            
            NSMutableDictionary *pDict = [_ayCompanyData objectAtIndex:index];
            if (pDict == NULL)
                return;
            NSString* strGSMD = [pDict tztObjectForKey:tztFundComCode];
            
            if (_tztTradeTable)
                [_tztTradeTable setLabelText:strGSMD withTag_:kTagCode];
        }
            break;
        case 2001://zxl 20130711新开 、增加 类型转换处理
        {
            if (!_tztTradeTable)
                return;
            if (index == 0)
            {
                [_tztTradeTable SetImageHidenFlag:@"TZTJJZH" bShow_:NO];
            }else if(index == 1)
            {
                [_tztTradeTable SetImageHidenFlag:@"TZTJJZH"bShow_:YES];
            }
            NSInteger JJGSSelect = [_tztTradeTable getComBoxSelctedIndex:2000];
            [_tztTradeTable OnRefreshTableView];
            [self SetUserInfo];
            [_tztTradeTable setComBoxData:_ayKHType ayContent_:_ayKHType AndIndex_:index withTag_:2001];
            //zxl 20130711新开 、增加 类型转换的时候界面数据重新显示
            NSMutableArray * ayCompany = NewObject(NSMutableArray);
            for (int i = 0 ; i < [_ayCompanyData count]; i++ )
            {
                NSMutableDictionary *pDict = [_ayCompanyData objectAtIndex:i];
                NSString* strGSMC = [pDict tztObjectForKey:tztFundComName];
                [ayCompany addObject:strGSMC];
            }
            if (JJGSSelect >= [_ayCompanyData count] && JJGSSelect >= 0)
            {
                JJGSSelect = 0;
            }
            [_tztTradeTable setComBoxData:ayCompany ayContent_:ayCompany AndIndex_:JJGSSelect withTag_:2000];
            DelObject(ayCompany);
        }
            break;
        default:
            break;
    }
}



-(BOOL)CheckInput
{
    if (_tztTradeTable == NULL)
        return FALSE;
    
    NSInteger nIndex = [_tztTradeTable getComBoxSelctedIndex:kTagName];
    if (nIndex < 0 || nIndex >= [_ayCompanyData count])
        return FALSE;
    NSMutableDictionary* pDict = [_ayCompanyData objectAtIndex:nIndex];
    if (pDict == NULL)
        return FALSE;
    
    
//    BOOL bChecked = [_tztTradeTable getCheckBoxValue:7000];
//    if (!bChecked)
//    {
//        tztAfxMessageBox(@"请仔细阅读并同意签署协议!");
//        return FALSE;
//    }
    
    NSString* nsCode = [pDict tztObjectForKey:tztFundComCode];
    NSString* nsName = [pDict tztObjectForKey:tztFundComName];
    if(nsCode == nil || [nsCode length] < 1)
    {
        [self showMessageBox:@"基金公司代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* strInfo = @"";
    strInfo = [NSString stringWithFormat:@"基金公司代码:%@\r\n基金公司名称:%@\r\n\r\n",nsCode,nsName];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"基金开户"
                   nsOK_:@"开户"
               nsCancel_:@"取消"];
    
    return TRUE;
}



//工具栏点击事件
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if (_tztTradeTable)
            {
                if ([self CheckInput])
                {
                    return TRUE;
                }
            }
        }
            break;
        default:
            break;
    }
    return FALSE;
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnSendKH];
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
                [self OnSendKH];
            }
                break;
                
            default:
                break;
        }
    }
}
-(void)OnButtonClick:(id)sender
{
    tztUIButton *button = (tztUIButton *)sender;
    //zxl 20130711 添加了按钮触发确定功能
    switch ([button.tzttagcode intValue])
    {
        case 5000:
        {   
            if (_tztTradeTable)
            {
                [self CheckInput];
            }
        }
            break;
        case 5001:
        {
            [g_navigationController popViewControllerAnimated:UseAnimated];
            //返回，取消风火轮显示
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIViewController* pTop = g_navigationController.topViewController;
            if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
            {
                g_navigationController.navigationBar.hidden = NO;
                [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
-(void)OnButton:(id)sender
{
  
}

@end
