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

#import "tztChangePWView.h"

@interface tztChangePWView (tztPrivate)
//设置界面数据
-(void)OnSetPicker:(int)Type;
-(void)OnNeedLoginOut:(int)nType;
@end

@implementation tztChangePWView
@synthesize tztTableView = _tztTableView;
@synthesize ayPWData = _ayPWData;
@synthesize ayPWType = _ayPWType;
@synthesize nPWType = _nPWType;

-(id)init
{
    if (self = [super init])
    {   
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
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
    
    if (_tztTableView == NULL)
    {
        _tztTableView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTableView.tztDelegate = self;
        [_tztTableView setTableConfig:@"tztUITradeChangePW"];
        [self addSubview:_tztTableView];
        [_tztTableView release];
    }
    else
        _tztTableView.frame = rcFrame;
    
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayPWData);
    DelObject(_ayPWType);
    [super dealloc];
}

-(void)ClearData
{
    if (_tztTableView == NULL)
        return;
    [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:2000];
    [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
    [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:2002];
}

-(void)OnRequestData
{
    [self SetDefaultData];
}

-(void)SetDefaultData
{
    [self OnSetPicker:_nPWType];
}

//设置界面数据
-(void)OnSetPicker:(int)Type
{
    if (_ayPWData == NULL)
        _ayPWData = NewObject(NSMutableArray);
    if (_ayPWType == NULL)
        _ayPWType = NewObject(NSMutableArray);
    
    [_ayPWType removeAllObjects];
    [_ayPWData removeAllObjects];
    
    [_ayPWData addObject:@"交易密码"];
    if (g_pSystermConfig && g_pSystermConfig.bSupportChangeFundPW)
        [_ayPWData addObject:@"资金密码"];
    if (g_pSystermConfig && g_pSystermConfig.bSupportChangeTXPW)
        [_ayPWData addObject:@"通讯密码"];
    
    [_ayPWType addObject:[NSString stringWithFormat:@"%d", PWT_Deal]];
    if (g_pSystermConfig && g_pSystermConfig.bSupportChangeFundPW)
        [_ayPWType addObject:[NSString stringWithFormat:@"%d", PWT_Money]];
    if (g_pSystermConfig && g_pSystermConfig.bSupportChangeTXPW)
        [_ayPWType addObject:[NSString stringWithFormat:@"%d", PWT_Server]];
    
    
    
    _nPWType = PWT_Deal;
    
    //
    [_tztTableView setComBoxData:_ayPWData ayContent_:_ayPWData AndIndex_:0 withTag_:1000];
//    [_tztTableView SetComBoxDataWith:1000 ayTitle_:_ayPWData ayContent_:_ayPWData AndIndex_:0];
}

-(void)Check
{
    [tztUIVCBaseView OnCloseKeybord:_tztTableView];
    NSString* nsString = [NSString stringWithFormat:@"确认修改密码?"];
    
    [self showMessageBox:nsString nType_:TZTBoxTypeButtonBoth nTag_:0x9999 delegate_:self withTitle_:@"修改密码"];
}

-(BOOL)CheckInputPW
{
    if (_tztTableView == NULL)
        return FALSE;
    NSString* strOld = [_tztTableView GetEidtorText:2000];
    NSString* strNew = [_tztTableView GetEidtorText:2001];
    NSString* strNewAgain = [_tztTableView GetEidtorText:2002];
    
    if (strOld == NULL || [strOld length] < 1)
    {
        [self showMessageBox:@"请输入旧密码!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"修改密码"];
        return FALSE;
    }
    if (strNew == NULL || [strNew length] < 1)
    {
        [self showMessageBox:@"请输入新密码!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"修改密码"];
        return FALSE;
    }
    if (strNewAgain == NULL || [strNewAgain length] < 1)
    {
        [self showMessageBox:@"请再次输入新密码!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"修改密码"];
        return FALSE;
    }
    
    if ([strNew compare:strNewAgain] != NSOrderedSame)
    {
        [self showMessageBox:@"确认密码和新密码必须一致!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"修改密码"];
        return FALSE;
    }
    return TRUE;
}

-(void)OnChangePW
{
    //
    if (![self CheckInputPW])
        return;
    
    NSString* strOld = [_tztTableView GetEidtorText:2000];
    NSString* strNew = [_tztTableView GetEidtorText:2001];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    if (_nPWType == PWT_Money)
    {
        [pDict setTztValue:@"1" forKey:@"PASSWORDTYPE"];
    }
    else if (_nPWType == PWT_Server)
    {
        [pDict setTztValue:@"0" forKey:@"PASSWORDTYPE"];
    }
    else
    {
        [pDict setTztValue:@"2" forKey:@"PASSWORDTYPE"];
    }
    
    [pDict setTztValue:strOld forKey:@"password"];
    [pDict setTztValue:strNew forKey:@"NewPassword"];
    //增加账号类型获取token
    if (_nMsgType == WT_RZRQChangePW ||_nMsgType == MENU_JY_RZRQ_Password)//新功能号 add by xyt 20131021
    {
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    }   
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"112" withDictValue:pDict];
    
    DelObject(pDict);
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
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        return 0;
    }
    else
    {
        [self ClearData];
        if (_nPWType == PWT_Money)
        {
            [self showMessageBox:@"资金密码修改成功!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"提示"];
        }
        else
        {
            [self showMessageBox:@"密码修改成功，请重新登录!"
                          nType_:TZTBoxTypeButtonOK
                           nTag_:0x7777
                       delegate_:self
                      withTitle_:@"提示"];
        }
        
    }
    return 1;
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x7777:
            {
                [self OnNeedLoginOut:0];
            }
                break;
            case 0x9999:
            {
                [self OnChangePW];
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
            case 0x7777:
            {
                [self OnNeedLoginOut:0];
            }
                break;
            case 0x9999:
            {
                [self OnChangePW];
            }
                break;
                
            default:
                break;
        }
    }
}


- (void)tztDroplistView:(tztUIDroplistView *)view didSelectIndex:(int)index//选中
{
    int nIndex = index;
    if (nIndex < 0 || nIndex > [_ayPWType count])
        return;
    _nPWType = [[_ayPWType objectAtIndex:nIndex] intValue];
    //切换清空输入数据 add by xyt 20131107
    [self ClearData];
}

-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
		return;
	tztUIButton * pButton = (tztUIButton*)sender;
	int nTag = [pButton.tzttagcode intValue];
    //确认修改
	if (nTag == 4000)
	{
//		[[NumberKeyboard sharedKeyboard] hide];
        if ([self CheckInputPW])
            [self Check];
    }
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if ([self CheckInputPW])
            {
//                [[NumberKeyboard sharedKeyboard] hide];	
                [self Check];
                return TRUE;
            }
            else
                return FALSE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}

-(void)OnNeedLoginOut:(int)nType
{
    //融资融券和普通交易一样退出后到首页再进交易
    if (_nMsgType == WT_RZRQChangePW || _nMsgType == MENU_JY_RZRQ_Password)//新功能号 add by xyt 20131021
    {
        //修改密码成功后,没有清空担保品对应账号token// modify by xyt 20131024
        g_CurUserData.nsDBPLoginToken = @"";
        [self SetOutCurLoginAccount:TZTAccountRZRQType];
        //融资融券修改ipad修改密码成功后,界面跳转modify by xyt 20131025
        if (IS_TZTIPAD)
        {
            [g_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
            return;
        }
        [g_navigationController popToRootViewControllerAnimated:NO];
        [TZTUIBaseVCMsg OnMsg:WT_JYRZRQ wParam:0 lParam:0];
    }
    else
    {
        [self SetOutCurLoginAccount:TZTAccountPTType];
        //修改ipad修改密码成功后,界面跳转modify by xyt 20130828
        if (IS_TZTIPAD)
        {
            [g_pToolBarView OnDealToolBarAtIndex:0 options_:NULL];
            return;
        }
        [g_navigationController popToRootViewControllerAnimated:NO];
        [TZTUIBaseVCMsg OnMsg:WT_JiaoYi wParam:0 lParam:0];
    }
//    [tztJYLoginInfo SetLoginAllOut];//全部登出
}

//zxl 20131204 修改密码当前账号退出适应多账号
-(void)SetOutCurLoginAccount:(int)AccountType
{
    tztJYLoginInfo * pCurAccount = [tztJYLoginInfo GetCurJYLoginInfo:AccountType];
    if (pCurAccount)
    {   
        [tztJYLoginInfo SetLoginOutAccount:pCurAccount.nsFundAccount];
        NSMutableArray *ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:AccountType];
        if (ayJyLoginInfo && [ayJyLoginInfo count] == 0)
        {
            if (AccountType == TZTAccountPTType)
            {
                [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:StockTrade_Log];
                
                ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountRZRQType];
                if(ayJyLoginInfo && [ayJyLoginInfo count] > 0)
                {
                    [tztJYLoginInfo SetCurJYLoginInfo:TZTAccountRZRQType _nIndex:0];
                }
            }else if (AccountType == TZTAccountRZRQType)
            {
                [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:RZRQTrade_Log];
                ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountPTType];
                if(ayJyLoginInfo && [ayJyLoginInfo count] > 0)
                {
                    [tztJYLoginInfo SetCurJYLoginInfo:TZTAccountPTType _nIndex:0];
                }
            }
        }
        if(ayJyLoginInfo && [ayJyLoginInfo count] > 0)
        {
            [tztJYLoginInfo SetCurJYLoginInfo:AccountType _nIndex:0];
        }
    }
}
@end
