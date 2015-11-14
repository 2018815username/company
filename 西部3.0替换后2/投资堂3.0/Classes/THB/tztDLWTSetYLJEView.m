/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztDLWTSetYLJEView
 * 文件标识:
 * 摘要说明:		天汇宝代理委托-预留金额设置界面、开通界面
 * 预留金额设置和开通的请求都是一样的都是发送 377功能号，预留金额的 OPERATION 发送M
 * 开通的请求 OPERATION 发送A。
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztDLWTSetYLJEView.h"
#import "tztJYLoginInfo.h"

@implementation tztDLWTSetYLJEView
@synthesize tztTradeTable = _tztTradeTable;
@synthesize nShowType = _nShowType;
@synthesize nsStcokCode =_nsStcokCode;
@synthesize nsStockName = _nsStockName;
@synthesize nsNowYLJE = _nsNowYLJE;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}
-(void)dealloc
{
    [super dealloc];
    [[tztMoblieStockComm getShareInstance] removeObj:self];
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        [_tztTradeTable setTableConfig:@"tztUITradeTHBDLWTYLJESetting"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
        [self SetDefaultData];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
}
//设置界面
-(void)SetDefaultData
{
    
    if (_nShowType == TZTToolbar_Fuction_OK)
    {
        [self.tztTradeTable SetImageHidenFlag:@"TZTDQYLJE" bShow_:FALSE];
        [self.tztTradeTable OnRefreshTableView];
    }
    tztJYLoginInfo * userInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (userInfo)
    {
        [self.tztTradeTable setLabelText:userInfo.nsFundAccount withTag_:1003];
    }
    
    if (self.nsNowYLJE && [self.nsNowYLJE length] > 0)
    {
        [self.tztTradeTable setLabelText:self.nsNowYLJE withTag_:1002];
    }
//    if (self.nsStockName && [self.nsStockName length] > 0)
//    {
//        [self.tztTradeTable setLabelText:self.nsStockName withTag_:1000];
//    }
}
//检查空处理
-(void)CheckInput
{
    NSString *nsYLJE = [self.tztTradeTable GetEidtorText:2000];
    if (nsYLJE == NULL || [nsYLJE length] < 1)
    {
        nsYLJE = @"0.0";
    }

    NSString* strInfo = @"";
    strInfo = [NSString stringWithFormat:@"资金账号:%@\r\n预留金额:%@\r\n\r\n您是否确定此操作？\r\n", [self.tztTradeTable GetLabelText:1003],nsYLJE];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"代理委托"
                   nsOK_:@"确定"
               nsCancel_:@"取消"];
}
//发送请求
-(void)OnSend
{
    if (self.nShowType == TZTToolbar_Fuction_OK)
    {
        [self OnRequestKT];
    }else if (self.nShowType == TZTToolbar_Fuction_THB_YLJE)
    {
        [self OnRequestSetYLJE];
    }
}
//预留金额设置请求
-(void)OnRequestSetYLJE
{
    NSString *nsYLJE = [self.tztTradeTable GetEidtorText:2000];
    if (nsYLJE == NULL || [nsYLJE length] < 1)
    {
        nsYLJE = @"0.0";
    }
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"M" forKey:@"OPERATION"];
    [pDict setTztValue:@"1" forKey:@"RightFlag"];
    [pDict setTztValue:nsYLJE forKey:@"Price"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"377" withDictValue:pDict];
	DelObject(pDict);
}
//开通请求
-(void)OnRequestKT
{
    NSString *nsYLJE = [self.tztTradeTable GetEidtorText:2000];
    if (nsYLJE == NULL || [nsYLJE length] < 1)
    {
        nsYLJE = @"0.0";
    }
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"A" forKey:@"OPERATION"];
    [pDict setTztValue:@"1" forKey:@"RightFlag"];
    [pDict setTztValue:nsYLJE forKey:@"Price"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"377" withDictValue:pDict];
	DelObject(pDict);
}

-(UInt32)OnCommNotify:(UInt32)wParam lParam_:(UInt32)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    if ([pParse GetErrorNo] < 0)
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        if ([tztBaseTradeView IsExitError:[pParse GetErrorNo]])
        {
            [self OnNeedLoginOut];
        }
        return 0;
    }
    if ([pParse IsAction:@"377"])
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        if (IS_TZTIPAD)
        {
            [[tztTradeMsg getShareTradeMsg] DealMsg:WT_THB_DLWT wParam:(UInt32)10];
        }else
        {
            [g_navigationController popViewControllerAnimated:NO];
        }
    }
    return 1;
}
//按钮处理
-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
		return;
	tztUIButton * pButton = (tztUIButton*)sender;
	int nTag = [pButton.tzttagcode intValue];
    //确认
	if (nTag == 3000)
	{
        [self CheckInput];
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
                    [self OnSend];
                }
                    break;
                    
                default:
                    break;
            }
        }
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnSend];
            }
                break;
                
            default:
                break;
        }
    }
}
@end
