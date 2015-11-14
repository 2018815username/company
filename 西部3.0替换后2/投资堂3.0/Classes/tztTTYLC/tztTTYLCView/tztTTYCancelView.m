/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        现金增值计划取消
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztTTYCancelView.h"

enum
{
    kTagCode = 1000,//产品代码
    kTagName,       //产品名称
    kTagCompany,    //登记公司
    kTagFE,         //产品份额
    
    kTagOK = 10000,
    kTagClear,
};

@implementation tztTTYCancelView
@synthesize tztTradeTable = _tztTradeTable;
@synthesize CurStockCode = _CurStockCode;
@synthesize nsJJGSCode = _nsJJGSCode;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _bInquire = FALSE;
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayData);
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
        [_tztTradeTable setTableConfig:@"tztUITradeTTYCancel"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }

}

-(void)SetDefaultData
{
    if (_tztTradeTable == NULL)
        return;
    
}

//清空界面数据
-(void) ClearData
{
    if (_tztTradeTable == NULL)
        return;
    
    [_tztTradeTable setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTagCode];
    [_tztTradeTable setLabelText:@"" withTag_:kTagName];
    [_tztTradeTable setLabelText:@"" withTag_:kTagCompany];
    [_tztTradeTable setLabelText:@"" withTag_:kTagFE];
    self.CurStockCode = @"";
    self.nsJJGSCode = @"";
    _nCurrentSelect = 0;
}

-(void)DealWithSysTextField:(TZTUITextField *)inputField
{
    if (inputField.tag == kTagCode)
    {
        self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
        [self OnRefresh];
    }
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView && [tztUIBaseView isKindOfClass:[tztUITextField class]])
    {
        if ([((tztUITextField*)tztUIBaseView).tzttagcode intValue] == kTagCode)
        {
            [self DealWithStockCode:((tztUITextField*)tztUIBaseView).text];
        }
    }
}

/*
-(void)inputFieldDidChangeValue:(tztUITextEdit *)inputField
{
    switch ([inputField.tzttagcode intValue])
	{
		case kTagCode:
		{
            [self DealWithStockCode:inputField.valueStr];
		}
			break;
		default:
			break;
	}
}
*/
-(void)DealWithStockCode:(NSString*)nsStockCode
{
    if (self.CurStockCode == NULL)
        self.CurStockCode = @"";
    if ([nsStockCode length] <= 0)
    {
        self.CurStockCode = @"";
    }
    
    if (nsStockCode != NULL)
    {
        self.CurStockCode = [NSString stringWithFormat:@"%@", nsStockCode];
    }
    
    if ([self.CurStockCode length] == 6)
    {
        [self OnRefresh];
        //[[NumberKeyboard sharedKeyboard] hide];
    }
    //清空
    if ([self.CurStockCode length] <= 0)
    {
        [self ClearData];
    }
}

-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    [self OnRequestData];
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTagCode)
    {
        _nCurrentSelect = index;
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            //当前界面没有输入框,注释此代码 modify by xyt 20130909
            //[_tztTradeTable setEditorText:strCode nsPlaceholder_:nil withTag_:kTagCode];
            [self DealWithStockCode:strCode];
        }
    }
}

-(void)OnRequestData
{
    NSString* strAction = @"530";
    _bInquire = TRUE;
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
}

//请求股票信息
-(void)OnRefresh
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"FUNDCODE"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"530" withDictValue:pDict];
    
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
    
    if ([pParse IsAction:@"534"] )
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
        return 1;
    }
    
    if (_bInquire && [pParse IsAction:@"530"])
    {
        _bInquire = FALSE;
        //代码，名称索引
        //int nBalanceIndex = -1;
        int nJJDMIndex = -1;   //基金代码
        int nJJMCIndex = -1;    //基金名称
        int nJJGSDM = -1;   //基金公司代码
        int nJJGSMC = -1;   //基金公司名称
        
        NSString* strIndex = [pParse GetByName:@"JJDMIndex"];
        TZTStringToIndex(strIndex, nJJDMIndex);
        
        strIndex = [pParse GetByName:@"JJMCIndex"];
        TZTStringToIndex(strIndex, nJJMCIndex);
        
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, nJJGSDM);
        
        strIndex = [pParse GetByName:@"JJGSMC"];
        TZTStringToIndex(strIndex, nJJGSMC);
        
        if (nJJDMIndex < 0 )
            return 0;
        
        if (_ayData == NULL)
            _ayData = NewObject(NSMutableArray);
        [_ayData removeAllObjects];
        
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        if (pGridAy)
        {
            NSMutableArray *pAyTitle = NewObject(NSMutableArray);
            NSString* strCode = @"";
            NSString* strName = @"";
            for (int i = 1; i < [pGridAy count]; i++)
            {
                NSArray* pAy = [pGridAy objectAtIndex:i];
                if (pAy == NULL)
                    continue;
                NSInteger nCount = [pAy count];
                if (nCount < 1 || nJJDMIndex >= nCount || nJJMCIndex >= nCount) 
                    continue;
                
                if(nJJDMIndex >= 0 && nJJDMIndex < [pAy count])
                    strCode = [pAy objectAtIndex:nJJDMIndex];
                if (strCode == NULL || [strCode length] <= 0)
                    continue;
                
                if (nJJMCIndex >= 0 && nJJMCIndex < [pAy count])
                    strName = [pAy objectAtIndex:nJJMCIndex];
                if (strName == NULL)
                    strName = @"";
                
                NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
                [pAyTitle addObject:strTitle];
            }
            
            if (_tztTradeTable && [pAyTitle count] > 0)
            {
                //获取当前界面输入
                NSString* nsName = [_tztTradeTable GetLabelText:kTagName];
                NSString* nsCode = [_tztTradeTable GetEidtorText:kTagCode];
                if (nsName && nsCode && [nsCode length] == 6)
                {
                    NSString* nsDefault = [NSString stringWithFormat:@"%@(%@)", nsCode, nsName];
                    [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSelect withTag_:kTagCode bDrop_:YES];
                    [_tztTradeTable setComBoxText:nsDefault withTag_:kTagCode];
                }
                else
                {
                    if (_nCurrentSelect < 0 || _nCurrentSelect >= [pAyTitle count])
                        _nCurrentSelect = 0;
                    [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSelect withTag_:kTagCode bDrop_:YES];
                }
            }
            
            if ([pAyTitle count] < 1)
            {
                [self showMessageBox:@"查无相应数据!" nType_:TZTBoxTypeNoButton nTag_:0];
            }
            DelObject(pAyTitle);
        }
        return 1;
    }
    
    if ([pParse IsAction:@"530"])
    {
        //代码，名称索引
        int nBalanceIndex = -1;
        int nJJDMIndex = -1;   //基金代码
        int nJJMCIndex = -1;    //基金名称
        int nJJGSDM = -1;   //基金公司代码
        int nJJGSMC = -1;   //基金公司名称
        
        NSString* strIndex = [pParse GetByName:@"JJDMIndex"];
        TZTStringToIndex(strIndex, nJJDMIndex);
        
        strIndex = [pParse GetByName:@"JJMCIndex"];
        TZTStringToIndex(strIndex, nJJMCIndex);
        
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, nJJGSDM);
        
        strIndex = [pParse GetByName:@"JJGSMC"];
        TZTStringToIndex(strIndex, nJJGSMC);
        
        strIndex = [pParse GetByName:@"BalanceIndex"];
        TZTStringToIndex(strIndex, nBalanceIndex);
        
        if (nJJDMIndex < 0 )
            return 0;
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        if (pGridAy)
        {
            NSString* strCode = @"";
            NSString* strName = @"";
            NSString* strGSMC = @"";
            NSString* strBalance = @"";
            NSString* strJJGSDM = @"";
            for (int i = 1; i < [pGridAy count]; i++)
            {
                NSArray* pAy = [pGridAy objectAtIndex:i];
                
                if(nJJDMIndex >= 0 && nJJDMIndex < [pAy count])
                    strCode = [pAy objectAtIndex:nJJDMIndex];
                if (strCode == NULL || [strCode length] <= 0)
                    continue;
                
                if (nJJMCIndex >= 0 && nJJMCIndex < [pAy count])
                    strName = [pAy objectAtIndex:nJJMCIndex];
                if (strName == NULL)
                    strName = @"";
                [_tztTradeTable setLabelText:strName withTag_:kTagName];
                
                if (nJJGSMC >= 0 && nJJGSMC < [pAy count])
                    strGSMC = [pAy objectAtIndex:nJJGSMC];
                if (strGSMC == NULL)
                    strGSMC = @"";
                [_tztTradeTable setLabelText:strGSMC withTag_:kTagCompany];
                
//                if (nBalanceIndex >= 0 && nBalanceIndex < [pAy count])
//                    strBalance = [pAy objectAtIndex:nBalanceIndex];
//                if (strBalance == NULL)
//                    strBalance = @"";
//                [_tztTradeTable setLabelText:strBalance withTag_:kTagFE];
                
                if (nJJGSDM >= 0 && nJJGSDM < [pAy count])
                    strJJGSDM = [pAy objectAtIndex:nJJGSDM];
                if (strJJGSDM == NULL)
                    strJJGSDM = @"";
                self.nsJJGSCode = [NSString stringWithFormat:@"%@",strJJGSDM];
                //请求可用份额
                [self OnRequestAmount];
                break;
            }
        }        
    }
    else if ([pParse IsAction:@"649"])
    {
        NSString *strAmount = @"0";
        
        strAmount = [pParse GetByName:@"Enable_amount"];
        if (strAmount == NULL || strAmount.length < 1)
            strAmount = @"0";
        
        [_tztTradeTable setLabelText:strAmount withTag_:kTagFE];
    }

    return 1;
}

-(void)OnRequestAmount
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"FUNDCODE"];
    if (self.nsJJGSCode)
        [pDict setTztValue:self.nsJJGSCode forKey:@"JJDJGSDM"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"649" withDictValue:pDict];
    
    DelObject(pDict);
}

-(BOOL)CheckInput
{
    if (_tztTradeTable == NULL)
        return  FALSE;
    
    NSString* nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    NSString* nsName = [_tztTradeTable GetLabelText:kTagName];
    
    if (self.CurStockCode == NULL || nsCode == NULL || nsCode.length < 1)
    {
        [self showMessageBox:@"请选择产品代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* nsCompany = [_tztTradeTable GetLabelText:kTagCompany];
    
    NSString *typestr = [NSString stringWithFormat:@"注销"];
    
    NSString* strInfo = [NSString stringWithFormat:@"产品代码:%@\r\n产品名称:%@\r\n登记公司:%@\r\n",nsCode, nsName, nsCompany];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:typestr
                   nsOK_:typestr
               nsCancel_:@"取消"];
    
    return TRUE;
}


//买卖确认
-(void)OnSendBuySell
{
    if (_tztTradeTable == NULL)
        return;
    
    NSString* nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    if (nsCode == NULL || [nsCode length] != 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsCode forKey:@"FUNDCODE"];
    if (self.nsJJGSCode)
        [pDict setTztObject:self.nsJJGSCode forKey:@"JJDJGSDM"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"534" withDictValue:pDict];
    DelObject(pDict);
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
        case TZTToolbar_Fuction_Clear:
        {
            [self ClearData];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRefresh];
            return TRUE;
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
                [self OnSendBuySell];
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
                [self OnSendBuySell];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
        return;
    
    UIButton *pButton = (UIButton*)sender;
    NSInteger nTag = pButton.tag;
    
    if ([pButton isKindOfClass:[tztUIButton class]])
    {
        nTag = [((tztUIButton*)pButton).tzttagcode intValue];
    }
    
    switch (nTag)
    {
        case kTagOK:
        {
            [self CheckInput];
        }
            break;
        case kTagClear:
        {
            [self ClearData];
        }
            break;
        default:
            break;
    }
}

@end
