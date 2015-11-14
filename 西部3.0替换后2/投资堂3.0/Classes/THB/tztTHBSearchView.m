/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztTHBSearchView
 * 文件标识:
 * 摘要说明:		天汇宝查询界面
 * 新开回购查询功能号 380、业务查询（373）、不再续做（390）、代理委托（387）
 * 合约查询(372)、提前购回（370）、提前购回预约（371）、质押券查询（374）。
 * 新开回购功能:点击新开把当前行股票代码传送给新开界面（新打开新开回购功能界面）。
 * 不再续做功能:点击直接发送（375）功能号请求。
 * 代理委托功能:代理委托下面有开通（打开开通界面处理）、取消（377）、撤单（111）、预留金额（打开预留金额界面处理）
 * 提前购回功能:点击直接发送（384）功能号请求。
 * 提前购回预约功能:点击直接发送（385）功能号请求。
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTHBSearchView.h"
//#import "tztUITHBNewOpenGHViewController.h"
//#import "tztUITHBDLWTSetYLJEViewController.h"

@implementation tztTHBSearchView
@synthesize nRequestType  = _nRequestType;
@synthesize nDateIndex = _nDateIndex;
@synthesize nContactIDIndex = _nContactIDIndex;
@synthesize nFlagIndex = _nFlagIndex;
@synthesize nAmountIndex = _nAmountIndex;
@synthesize nMarketIndex = _nMarketIndex;
-(NSString*)GetReqAction:(int)nMsgID
{
    switch (nMsgID)
    {
        case WT_THB_NEWKHG://新开回购
        {
            _reqAction = @"380";
        }
            break;
        case WT_THB_YWSearch://业务查询
        {
            _reqAction = @"373";
        }
            break;
        case WT_THB_BZXZ://不再续做
        {
            _reqAction = @"390";
        }
            break;
        case WT_THB_DLWT://代理委托
        {
            _reqAction = @"387";
        }
            break;
        case WT_THB_HYSearch://合约查询
        {
            _reqAction = @"372";
        }
            break;
        case WT_THB_TQGH://提前购回
        {
            _reqAction = @"370";
        }
            break;
        case WT_THB_TQGHYY://提前购回预约
        {
            _reqAction = @"371";
        }
            break;
        case WT_THB_ZYQSearch://质押券查询
        {
            _reqAction = @"374";
        }
            break;
    }
    return _reqAction;
}
//查询需要的特殊索引
-(void)DealIndexData:(tztNewMSParse*)pParse
{
    NSString* strIndex = [pParse GetByName:@"DATEINDEX"];
    TZTStringToIndex(strIndex, _nDateIndex);
    
    strIndex = [pParse GetByName:@"SERIALNOINDEX"];
    if (strIndex == NULL || [strIndex length] < 1 )
    {
        strIndex = [pParse GetByName:@"CONTACTINDEX"];
    }
    TZTStringToIndex(strIndex, _nContactIDIndex);
    
    strIndex = [pParse GetByName:@"RightFlagIndex"];
    TZTStringToIndex(strIndex, _nFlagIndex);
    
    strIndex = [pParse GetByName:@"AmountIndex"];
    TZTStringToIndex(strIndex, _nAmountIndex);
    
    strIndex = [pParse GetByName:@"MARKETINDEX"];
    TZTStringToIndex(strIndex, _nMarketIndex);
}
//权限返回处理
-(void)DealOtherRequest:(tztNewMSParse*)pParse
{
    NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
    NSString* strIndex = [pParse GetByName:@"RightFlagIndex"];
    TZTStringToIndex(strIndex, _nFlagIndex);
    strIndex = [pParse GetByName:@"AmountIndex"];
    TZTStringToIndex(strIndex, _nAmountIndex);
    
    if ([ayGrid count] > 1)
    {
        NSArray* ayValue = [ayGrid objectAtIndex:1];
        NSString *nsFlag = @"";
        if (ayValue && _nFlagIndex >= 0 && [ayValue count] > _nFlagIndex)
        {
            nsFlag = [ayValue objectAtIndex:_nFlagIndex];
        }
        //权限 0 未开通  1开通 
        if (self.nRequestType == TZTToolbar_Fuction_OK)//开通处理
        {
            if (nsFlag == NULL || [nsFlag length] < 1 || [nsFlag intValue] == 0)
            {
                [self OnRequestDLWTKT];
            }
            self.nRequestType = 0;
        }else if(self.nRequestType == TZTToolbar_Fuction_QuXiao)//取消处理
        {
            if (nsFlag && [nsFlag length] >0 && [nsFlag intValue] == 1)
            {                
                [self showMessageBox:@"您是否确定取消委托代理权限？\r\n"
                              nType_:TZTBoxTypeButtonBoth
                               nTag_:0x1111
                           delegate_:self
                          withTitle_:@"代理委托"
                               nsOK_:@"确定"
                           nsCancel_:@"取消"];
            }
            self.nRequestType = 0;
        }else if(self.nRequestType == TZTToolbar_Fuction_THB_YLJE)//预留金额设置处理
        {
            NSString *nsYLJE = @"";
            if (ayValue && _nAmountIndex >= 0 && [ayValue count] > _nAmountIndex)
            {
                nsYLJE = [ayValue objectAtIndex:_nAmountIndex];
            }
            if (nsFlag && [nsFlag length] >0 && [nsFlag intValue] == 1)
            {
                [self OnDLWTYLJE:nsYLJE];
            }
            self.nRequestType = 0;
        }else
        {
            //根据不同的权限限制工具条按钮显示处理
            if (IS_TZTIPAD)
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(DealMsg:wParam:)])
                {
                    [self.delegate DealMsg:WT_THB_DLWT wParam:(UInt32)[nsFlag intValue]];
                }
            }else
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(ChangeTool:)])
                {
                    [self.delegate ChangeTool:[nsFlag intValue]];
                }
            }
        }
       
    }else
    {
        [self showMessageBox:@"您为首次开通,请登录富易或富通签署代理委托功能开通协议！"nType_:TZTBoxTypeNoButton nTag_:0];
        //根据不同的权限限制工具条按钮显示处理
        if (IS_TZTIPAD)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(DealMsg:wParam:)])
            {
                [self.delegate DealMsg:WT_THB_DLWT wParam:2];
            }
        }else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(ChangeTool:)])
            {
                [self.delegate ChangeTool:2];
            }
        }

    }
}
//新开功能界面跳转
-(void)OnNewOpen
{
    NSArray* pAy = [_pGridView tztGetCurrent];
    
    if (pAy == NULL || [pAy count] <= 0
        ||_nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count]
        ||_nMarketIndex < 0 || _nMarketIndex >= [pAy count])
    {
        [self showMessageBox:@"此委托不可操作！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    NSString* strCode = @"";
    NSString* strAccountType = @"";
    TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
    if (pGridData)
    {
        strCode = pGridData.text;
    }
    pGridData = [pAy objectAtIndex:_nMarketIndex];
    if (pGridData)
    {
        strAccountType = pGridData.text;
    }
    
    if (g_navigationController == NULL)
        return;
    
    
    NSMutableDictionary * pDict = [NSMutableDictionary dictionary];
    [pDict setTztObject:[NSString stringWithFormat:@"%@",strCode] forKey:@"JJCode"];
    [pDict setTztObject:[NSString stringWithFormat:@"%@",strAccountType] forKey:@"AccountType"];
    
    [[tztTradeMsg getShareTradeMsg] DealMsg:WT_THB_NEWKHG wParam:(UInt32)pDict];
}

//不再续做
-(void)OnRequestBZXZ
{
    
    NSArray* pAy = [_pGridView tztGetCurrent];
    
    if (pAy == NULL || [pAy count] <= 0 || _nDateIndex < 0 || _nContactIDIndex >= [pAy count])
    {
        [self showMessageBox:@"此委托不可操作！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* strData = @"";
    TZTGridData *pGridData = [pAy objectAtIndex:_nDateIndex];
    if (pGridData)
    {
        strData = pGridData.text;
    }
    
    NSString* strContactID = @"";
    TZTGridData *pGridContactID = [pAy objectAtIndex:_nContactIDIndex];
    if (pGridContactID)
    {
        strContactID = pGridContactID.text;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:strData forKey:@"BEGINDATE"];
    [pDict setTztValue:strContactID forKey:@"ContactID"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"375" withDictValue:pDict];
	DelObject(pDict);
}

-(void)SendOtherRequest
{
    [self CheckDLWT];
}
//代理委托查询权限
-(void)CheckDLWT
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"MaxCount"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"376" withDictValue:pDict];
	DelObject(pDict);
}

//代理委托开通
-(void)OnRequestDLWTKT
{
    if (g_navigationController == NULL)
        return;
    
    NSMutableDictionary * pDict = [NSMutableDictionary dictionary];
    [pDict setTztObject:[NSString stringWithFormat:@"%d",_nRequestType] forKey:@"ShowType"];
    [[tztTradeMsg getShareTradeMsg] DealMsg:WT_THB_DLWT wParam:(UInt32)pDict];
}
//代理委托取消
-(void)OnRequestDLWTQX
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"A" forKey:@"OPERATION"];
    [pDict setTztValue:@"0" forKey:@"RightFlag"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"377" withDictValue:pDict];
	DelObject(pDict);
}

//代理委托撤单
-(void)OnRequestDLWTCheDan
{
    
    NSArray* pAy = [_pGridView tztGetCurrent];
    
    if (pAy == NULL || [pAy count] <= 0 || _nDateIndex < 0 || _nContactIDIndex >= [pAy count])
    {
        [self showMessageBox:@"此委托不可操作！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    NSString* strData = @"";
    TZTGridData *pGridData = [pAy objectAtIndex:_nDateIndex];
    if (pGridData)
    {
        strData = pGridData.text;
    }
    
    NSString* strContactID = @"";
    TZTGridData *pGridContactID = [pAy objectAtIndex:_nContactIDIndex];
    if (pGridContactID)
    {
        strContactID = pGridContactID.text;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:strData forKey:@"BEGINDATE"];
    [pDict setTztValue:strContactID forKey:@"ContactID"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"111" withDictValue:pDict];
	DelObject(pDict);
}

//代理委托预留金额
-(void)OnDLWTYLJE:(NSString *)nsYLJE
{
    if (g_navigationController == NULL)
        return;
    
    NSMutableDictionary * pDict = [NSMutableDictionary dictionary];
    [pDict setTztObject:[NSString stringWithFormat:@"%d",_nRequestType] forKey:@"ShowType"];
    [pDict setTztObject:[NSString stringWithFormat:@"%@",nsYLJE] forKey:@"YLJE"];
    [[tztTradeMsg getShareTradeMsg] DealMsg:WT_THB_DLWT wParam:(UInt32)pDict];
}

//提前购回
-(void)OnRequestTQGH
{
    NSArray* pAy = [_pGridView tztGetCurrent];
    
    if (pAy == NULL || [pAy count] <= 0 || _nDateIndex < 0 || _nContactIDIndex >= [pAy count])
    {
        [self showMessageBox:@"此委托不可操作！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* strData = @"";
    TZTGridData *pGridData = [pAy objectAtIndex:_nDateIndex];
    if (pGridData)
    {
        strData = pGridData.text;
    }
    
    NSString* strContactID = @"";
    TZTGridData *pGridContactID = [pAy objectAtIndex:_nContactIDIndex];
    if (pGridContactID)
    {
        strContactID = pGridContactID.text;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:strData forKey:@"BEGINDATE"];
    [pDict setTztValue:strContactID forKey:@"ContactID"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"384" withDictValue:pDict];
	DelObject(pDict);
}
//提前购回预约
-(void)OnRequestTQGHYY
{
    NSArray* pAy = [_pGridView tztGetCurrent];
    
    if (pAy == NULL || [pAy count] <= 0 || _nDateIndex < 0 || _nContactIDIndex >= [pAy count])
    {
        [self showMessageBox:@"此委托不可操作！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* strData = @"";
    TZTGridData *pGridData = [pAy objectAtIndex:_nDateIndex];
    if (pGridData)
    {
        strData = pGridData.text;
    }
    
    NSString* strContactID = @"";
    TZTGridData *pGridContactID = [pAy objectAtIndex:_nContactIDIndex];
    if (pGridContactID)
    {
        strContactID = pGridContactID.text;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:strData forKey:@"BEGINDATE"];
    [pDict setTztValue:strContactID forKey:@"ContactID"];
    [pDict setTztValue:@"0" forKey:@"Direction"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"385" withDictValue:pDict];
	DelObject(pDict);
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    bDeal = [super OnToolbarMenuClick:sender];
    if (!bDeal)
    {
        UIButton *button = (UIButton *)sender;
        _nRequestType = button.tag;
        switch (button.tag)
        {
            case TZTToolbar_Fuction_OK:
            {
                if (_nMsgType == WT_THB_NEWKHG)
                {
                    [self OnNewOpen];
                }
                else if (_nMsgType == WT_THB_BZXZ)
                {
                    [self OnRequestBZXZ];
                    
                }else if(_nMsgType == WT_THB_DLWT)
                {
                    [self CheckDLWT];
                }else if(_nMsgType == WT_THB_TQGH)
                {
                    [self OnRequestTQGH];
                }else if(_nMsgType == WT_THB_TQGHYY)
                {
                    [self OnRequestTQGHYY];
                }
                    
            }
                break;
            case TZTToolbar_Fuction_QuXiao:
            {
                if(_nMsgType == WT_THB_DLWT)
                {
                    [self CheckDLWT];
                }
            }
                break;
            case TZTToolbar_Fuction_WithDraw:
            {
                if(_nMsgType == WT_THB_DLWT)
                {
                    [self OnRequestDLWTCheDan];
                }
            }
                break;
            case TZTToolbar_Fuction_THB_YLJE:
            {
                if(_nMsgType == WT_THB_DLWT)
                {
                    [self CheckDLWT];
                }
            }
                break;
            default:
                break;
        }
    }
    return bDeal;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnRequestDLWTQX];
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
                [self OnRequestDLWTQX];
            }
                break;
                
            default:
                break;
        }
    }
}
@end
