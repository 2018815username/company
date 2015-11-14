/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        用户信息修改
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTradeUserInfoView.h"

enum
{
    kTagName        = 1000,
    kTagMobileCode  = 2000,
    kTagEmail       = 2001,
    kTagAddress     = 2002,
    kTagCode        = 2003,
    
    kTagProvince    = 3000,
    kTagCity        = 3001,
    
    kTagOK          = 4000,
    kTagRefresh     = 4001,
};

@implementation tztTradeUserInfoView
@synthesize pUserInfoView = _pUserInfoView;
@synthesize ayProvinceAndCity = _ayProvinceAndCity;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

/*建立省份和城市的对应关系*/
-(void)InitProvinceAndCity
{
    if (_ayProvinceAndCity)
        [_ayProvinceAndCity removeAllObjects];
    
    self.ayProvinceAndCity = GetArrayByListName(@"tztProvinceCity_cn");
    
    if (self.ayProvinceAndCity == NULL || [self.ayProvinceAndCity count] <= 0 || _pUserInfoView == NULL)
        return;
    
    NSMutableArray *ayProvince = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.ayProvinceAndCity count]; i++)
    {
        NSMutableDictionary *pDict = [self.ayProvinceAndCity objectAtIndex:i];
        if (pDict == NULL)
            continue;
        
        NSArray *ayKey = [pDict allKeys];
        NSString* nsName = @"";
        if (ayKey && [ayKey count] == 1)
        {
            nsName = [ayKey objectAtIndex:0];
        }
        
        if (nsName.length <= 0)
            continue;
        
        [ayProvince addObject:nsName];
    }
    
    [_pUserInfoView setComBoxData:ayProvince ayContent_:ayProvince AndIndex_:0 withTag_:kTagProvince];
    
    NSInteger nIndex = [_pUserInfoView getComBoxSelctedIndex:kTagProvince];
    NSString* nsKey = [_pUserInfoView getComBoxText:kTagProvince];
    if (nIndex >= 0 && nIndex < [self.ayProvinceAndCity count])
    {
        NSMutableDictionary* pDict = [self.ayProvinceAndCity objectAtIndex:nIndex];
        NSMutableArray *pAyCity = [pDict objectForKey:nsKey];
        
        [_pUserInfoView setComBoxData:pAyCity ayContent_:pAyCity AndIndex_:0 withTag_:kTagCity];
    }
    DelObject(ayProvince);
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    
    if (_pTradeToolBar && !_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_pUserInfoView == NULL)
    {   
        _pUserInfoView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _pUserInfoView.tztDelegate = self;
        [_pUserInfoView setTableConfig:@"tztUITradeUserInfoSetting"];
        [self addSubview:_pUserInfoView];
        [_pUserInfoView release];
        //初始化省份城市信息
        [self InitProvinceAndCity];
    }
    else
        _pUserInfoView.frame = rcFrame;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
}

/*获取用户信息*/
-(void)OnRequestData
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:@"0" forKey:@"Direction"];
    [pDict setTztObject:@"0" forKey:@"PASSWORDTYPE"];
    tztJYLoginInfo *CurInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (CurInfo && CurInfo.nsAccount)
    {
        [pDict setTztObject:CurInfo.nsAccount forKey:@"Account"];
    }
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"13" withDictValue:pDict];
    
    DelObject(pDict);
}

-(void)OnTrade:(BOOL)bSend
{
    tztJYLoginInfo* pLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (pLoginInfo == NULL || pLoginInfo.ZjAccountInfo == NULL || pLoginInfo.ZjAccountInfo.nsAccount.length < 1 || pLoginInfo.ZjAccountInfo.nsPassword.length < 1)
    {
        [self showMessageBox:@"当前登陆账号错误或密码为空，无法获取用户信息!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSString* nsAccount = [NSString stringWithFormat:@"%@", pLoginInfo.ZjAccountInfo.nsAccount];
    NSString* nsPassword = [NSString stringWithFormat:@"%@", pLoginInfo.ZjAccountInfo.nsPassword];
    
    NSString* nsMobileCode = [_pUserInfoView GetEidtorText:kTagMobileCode];
    if (nsMobileCode.length != 11)
    {
        [self showMessageBox:@"手机号码输入不正确！" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSString* nsEmail  = [_pUserInfoView GetEidtorText:kTagEmail];
    if (nsEmail.length < 1)
    {
        [self showMessageBox:@"电子邮件地址输入不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    /*
    NSString* nsProvince = [_pUserInfoView getComBoxText:kTagProvince];
    if (nsProvince.length < 1)
    {
        [self showMessageBox:@"请选择省份！" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSString* nsCity = [_pUserInfoView getComBoxText:kTagCity];
    if (nsCity.length < 1)
    {
        [self showMessageBox:@"请选择城市!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
     */
    
    NSString* nsAddress = [_pUserInfoView GetEidtorText:kTagAddress];
    if (nsAddress.length < 1)
    {
        [self showMessageBox:@"地址输入不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSString* nsPostCode = [_pUserInfoView GetEidtorText:kTagCode];
    if (nsPostCode.length < 1)
    {
        [self showMessageBox:@"邮政编码不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    if (!bSend)
    {//省份:%@\r\n 城市:%@\r\n 
        NSString* strMsg = [NSString stringWithFormat:@" 手机号:%@\r\n EMail:%@\r\n 地址:%@\r\n 邮政编码:%@\r\n 确认修改？", nsMobileCode, nsEmail, /*nsProvince, nsCity,*/ nsAddress, nsPostCode];
        
        [self showMessageBox:strMsg nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self];
        return;
    }
    else
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        [pDict setTztValue:@"1" forKey:@"Direction"];
        [pDict setTztObject:@"0" forKey:@"PASSWORDTYPE"];
        [pDict setTztObject:nsPassword forKey:@"password"];
        [pDict setTztObject:nsMobileCode forKey:@"Mobile"];
        [pDict setTztObject:nsEmail forKey:@"EMail"];
        [pDict setTztObject:@"" forKey:@"state"];
        [pDict setTztObject:@"" forKey:@"city"];
        [pDict setTztObject:nsAddress forKey:@"street"];
        [pDict setTztObject:nsPostCode forKey:@"PostCode"];
        [pDict setTztObject:nsAccount forKey:@"Account"];
        
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"13" withDictValue:pDict];
        
        DelObject(pDict);
    }
    
    
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    NSString* strErrMsg = [pParse GetErrorMessage];
    if ([pParse GetErrorNo] < 0)
    {
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        return 0;
    }
    
    if ([pParse IsAction:@"13"])
    {
        NSString* strDirection = [pParse GetByName:@"Direction"];
        if ([strDirection intValue] == 1)//修改后返回，直接显示处理信息
        {
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
            return 1;
        }
        
        NSString* nsName = [pParse GetByName:@"UserName"];
        if (nsName == NULL)
            nsName = @"";
        
        NSString* nsMobileNo = [pParse GetByName:@"mobileNo"];
        if (nsMobileNo == NULL)
            nsMobileNo = @"";
        
        NSString* nsEMail = [pParse GetByName:@"EMail"];
        if (nsEMail == NULL)
            nsEMail = @"";
        
        NSString* nsProvince = [pParse GetByName:@"state"];
        if (nsProvince == NULL)
            nsProvince = @"";
        
        //根据省份显示
        
        NSString* nsCity = [pParse GetByName:@"City"];
        if (nsCity == NULL)
            nsCity = @"";
    
        NSString* nsStreet = [pParse GetByName:@"street"];
        if (nsStreet == NULL)
            nsStreet = @"";
        
        NSString* nsPostCode = [pParse GetByName:@"ZipCode"];
        if (nsPostCode == NULL)
            nsPostCode = @"";
        
        if (_pUserInfoView)
        {
            [_pUserInfoView setLabelText:nsName withTag_:kTagName];
            [_pUserInfoView setEditorText:nsMobileNo nsPlaceholder_:NULL withTag_:kTagMobileCode];
            [_pUserInfoView setEditorText:nsEMail nsPlaceholder_:NULL withTag_:kTagEmail];
            [_pUserInfoView setComBoxText:nsProvince withTag_:kTagProvince];
            [_pUserInfoView setComBoxText:nsCity withTag_:kTagCity];
            [_pUserInfoView setEditorText:nsStreet nsPlaceholder_:NULL withTag_:kTagAddress];
            [_pUserInfoView setEditorText:nsPostCode nsPlaceholder_:NULL withTag_:kTagCode];
        }
    }
    else
    {
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        return 0;
    }
    return 1;
}
//zxl 20131017 修改了ipad 点确定的处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnTrade:TRUE];
            }
                break;
                
            default:
                break;
        }
    }
}

//对话框事件处理
- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnTrade:TRUE];
            }
                break;
                
            default:
                break;
        }
    }
}
-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case kTagOK:
        {
            [self OnTrade:FALSE];
        }
            break;
        case kTagRefresh:
        {
            [self OnRequestData];
        }
            break;
        default:
            break;
    }
}

//选中列表数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    switch ([droplistview.tzttagcode intValue])
    {
        case kTagProvince://省份
        {
            NSInteger nIndex = [_pUserInfoView getComBoxSelctedIndex:kTagProvince];
            NSString* nsKey = [_pUserInfoView getComBoxText:kTagProvince];
            if (nIndex >= 0 && nIndex < [self.ayProvinceAndCity count])
            {
                NSMutableDictionary* pDict = [self.ayProvinceAndCity objectAtIndex:nIndex];
                NSMutableArray *pAyCity = [pDict objectForKey:nsKey];
                
                [_pUserInfoView setComBoxData:pAyCity ayContent_:pAyCity AndIndex_:0 withTag_:kTagCity];
            }
        }
            break;
        case kTagCity://城市
        {
            
        }
            break;
        default:
            break;
    }
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    BOOL bDeal = FALSE;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK://修改
        {
            bDeal = TRUE;
        }
            break;
        case TZTToolbar_Fuction_Refresh://刷新
        {
            [self OnRequestData];
            bDeal = TRUE;
        }
            break;
        default:
            break;
    }
    
    return bDeal;
}

@end
