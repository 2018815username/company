/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券直接还券
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:
 * 整理修改:    //湘财直接还券最大可还 取429查询的数据,不查询403和408比较
 *
 ***************************************************************/

#import "tztRZRQCrashRetuen.h"
enum
{
    KTag_GDCode = 1000,   //股东代码
    KTag_StockCode,     //证券代码
    KTag_MaxReturn,     //最大可还
    kTag_Num,           //还款数量
};


@implementation tztRZRQCrashRetuen
@synthesize pCrashReturn = _pCrashReturn;
@synthesize CurStockName = _CurStockName;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize nsMaxReturn = _nsMaxReturn;
-(id)init
{
    if (self = [super init])
    {
        _nsMaxReturn= @"0";
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayType);
    DelObject(_ayAccount);
    DelObject(_ayStockNum);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if (_pCrashReturn == nil)
    {
        _pCrashReturn = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _pCrashReturn.tztDelegate = self;
        [_pCrashReturn setTableConfig:@"tztRZRQTradeCrashReturn"];
        [self addSubview:_pCrashReturn];
        [_pCrashReturn release];
    }
    else
    {
        _pCrashReturn.frame = rcFrame;
    }
    
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case KTag_StockCode:
		{
			if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
			}
            
			if (inputField.text != NULL)
			{
                self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
			}
            
			
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
                //				[[NumberKeyboard sharedKeyboard] hide];
			}
		}
			break;
            
		default:
			break;
    }
}

-(void)inputFieldDidChangeValue:(tztUITextField *)inputField
{
    switch ([inputField.tzttagcode intValue])
	{
		case KTag_StockCode:
		{
			if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
			}
            
			if (inputField.text != NULL)
			{
                self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
			}
            
			
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
                //[[NumberKeyboard sharedKeyboard] hide];
			}
		}
			break;
		default:
			break;
	}
}

-(void)setStockCode:(NSString*)nsCode
{
    if (nsCode == NULL || [nsCode length] < 6)
        return;
    self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
    if (_pCrashReturn)
    {
        [_pCrashReturn setEditorText:nsCode nsPlaceholder_:NULL withTag_:KTag_StockCode];
    }
}

//清空界面数据
-(void) ClearData
{
    if (_pCrashReturn == NULL)
        return;
    [_pCrashReturn setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:KTag_GDCode];
    [_pCrashReturn setEditorText:@"" nsPlaceholder_:NULL withTag_:KTag_StockCode];
    [_pCrashReturn setLabelText:@"" withTag_:KTag_MaxReturn];
    [_pCrashReturn setEditorText:@"" nsPlaceholder_:NULL withTag_:kTag_Num];
}


//请求股票信息
-(void)OnRefresh
{
    if (_pCrashReturn == NULL)
        return;
    
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    //[pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    //[pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    [pDict setTztValue:@"0w" forKey:@"Direction"];
    [pDict setTztValue:@"0" forKey:@"CREDITTYPE"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"429" withDictValue:pDict];
    
    DelObject(pDict);
}

-(BOOL)CheckInput
{
    if (_pCrashReturn == NULL || ![_pCrashReturn CheckInput])
        return FALSE;
    
    NSInteger nIndex = [_pCrashReturn getComBoxSelctedIndex:KTag_GDCode];
    
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    
    //股票代码
    NSString* nsCode = [_pCrashReturn GetEidtorText:KTag_StockCode];
    if (nsCode == NULL || [nsCode length] < 1)
        return FALSE;
    
    //委托数量
    NSString* nsAmount = [_pCrashReturn GetEidtorText:kTag_Num];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"还款数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* strInfo = @"";
    
    strInfo = [NSString stringWithFormat:@"委托账号: %@\r\n证券代码: %@\r\n委托数量: %@\r\n\r\n确认%@该证券？", nsAccount, nsCode,nsAmount, @"现券还券"];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"现券还券"
                   nsOK_:@"现券还券"
               nsCancel_:@"取消"];
    return TRUE;
}

-(void)OnInquireFund
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"403" withDictValue:pDict];
    
    DelObject(pDict);
}


-(void)OnSend
{
    if (_pCrashReturn == nil)
        return;
    //股东账户
    NSInteger nIndex = [_pCrashReturn getComBoxSelctedIndex:1000];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    //股票代码
    NSString* nsCode = [_pCrashReturn GetEidtorText:KTag_StockCode];
    if (nsCode == NULL || [nsCode length] < 1)
        return;
    
    NSString* nsAmount = [_pCrashReturn GetEidtorText:kTag_Num];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] <= 0)
    {
        [self showMessageBox:@"委托数量输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"WTAccount"];
    [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
    [pDict setTztValue:nsAmount forKey:@"Volume"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [pDict setTztValue:@"B" forKey:@"Direction"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"422" withDictValue:pDict];
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
    
    if ([pParse IsAction:@"422"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
        return 0;
    }
    
    if ([pParse IsAction:@"429"])
    {
        NSString* strCode = [pParse GetByName:@"StockCode"];
        if (strCode == NULL || [strCode length] <= 0)//错误
            return 0;
        //返回的跟当前的代码不一致
        if ([strCode compare:self.CurStockCode] != NSOrderedSame)
        {
            return 0;
        }
        
        //股票名称
        NSString* strName = [pParse GetByNameUnicode:@"Title"];
        if (strName && [strName length] > 0)
        {
            self.CurStockName = [NSString stringWithFormat:@"%@",strName];
            if (_pCrashReturn)
            {
                [_pCrashReturn setLabelText:strName withTag_:1004];
                //[_tztTradeView setEditorText:self.CurStockCode nsPlaceholder_:NULL withTag_:2000];
            }
        }
        else
        {
            [self showMessageBox:@"该证券代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
        
        //       NSString* strTSInfo = [pParse GetByName:@"BankMoney"];
        //
        
        if (_ayAccount == nil)
            _ayAccount = NewObject(NSMutableArray);
        if (_ayType == nil)
            _ayType = NewObject(NSMutableArray);
        if (_ayStockNum == nil)
            _ayStockNum = NewObject(NSMutableArray);
        
        [_ayAccount removeAllObjects];
        [_ayType removeAllObjects];
        [_ayStockNum removeAllObjects];
        
        //股东账号及可卖可买
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                NSString* strAccount = [ayData objectAtIndex:0];
                if (strAccount == NULL || [strAccount length] <= 0)
                    continue;
                
                [_ayAccount addObject:strAccount];
                
                NSString* strType = [ayData objectAtIndex:1];
                if (strType == NULL || [strType length] <= 0)
                    strType = @"";
                
                [_ayType addObject:strType];
                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayStockNum addObject:strNum];
            }
        }
        
        [_pCrashReturn setComBoxData:_ayAccount ayContent_:_ayAccount AndIndex_:0 withTag_:KTag_GDCode];
        
        //可买、可卖显示
        NSString* nsValue = @"0";
        if ([_ayStockNum count] > 0)
        {
            unsigned long dCanCount = (unsigned long)[[_ayStockNum objectAtIndex:0] longLongValue];
            if (dCanCount > 100000000)
                nsValue = [NSString stringWithFormat:@"%.4f亿", (float)(dCanCount/100000000)];
            else
                nsValue = [NSString stringWithFormat:@"%ld", dCanCount];
            
            //            [_tztTradeView setButtonTitle:nsValue clText_:[UIColor redColor] forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
        }
        //最大可还
        [_pCrashReturn setLabelText:nsValue withTag_:KTag_MaxReturn];
        //查询最大可还
//#ifdef Support_HXSC
//        [_pCrashReturn setLabelText:nsValue withTag_:KTag_MaxReturn];
//#else
//        [self OnInquireFund];
//#endif
        //        [_pCrashReturn setLabelText:nsValue withTag_:KTag_MaxReturn];
    }
    if ([pParse IsAction:@"403"])
    {
        int nKYIndex = -1;//最大可还
        int nStockIndex = -1;//股票代码
        
        NSString *strIndex = [pParse GetByName:@"KYIndex"];
        TZTStringToIndex(strIndex, nKYIndex);
        
        strIndex = [pParse GetByName:@"STOCKCODEINDEX"];
        TZTStringToIndex(strIndex, nStockIndex);
        
        //        self.nsMaxReturn = @"0";
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            NSString* strCode = @"";
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                if (nStockIndex >= 0 && [ayData count] > nStockIndex)
                    strCode = [ayData objectAtIndex:nStockIndex];
                if (strCode == NULL || [strCode length] <= 0)
                    continue;
                
                if (nKYIndex >= 0 && [ayData count] > nKYIndex)
                {
                    NSString *str = [ayData objectAtIndex:nKYIndex];
                    if ([self.CurStockCode compare:strCode] == NSOrderedSame)
                    {
                        if (str != NULL && [str length]>0)
                        {
                            NSString* nsValue = @"";
                            //[_pCrashReturn setLabelText:str withTag_:KTag_MaxReturn];
                            unsigned long dCanCount = (unsigned long)[str longLongValue];
                            if (dCanCount > 100000000)
                                nsValue = [NSString stringWithFormat:@"%.4f亿", (float)(dCanCount/100000000)];
                            else
                                nsValue = [NSString stringWithFormat:@"%ld", dCanCount];
                            
                            self.nsMaxReturn = [NSString stringWithFormat:@"%@",nsValue];
                        }
                        else
                        {
                            self.nsMaxReturn = @"0";
                        }
                    }
                    
                }
            }
        }
        else
        {
            self.nsMaxReturn = @"0";
        }
        //403持仓查询后再去查融券情况 比较2个结果取最小值
        [self OnrequestMaxReturn];
    }
    
    if ([pParse IsAction:@"408"])
    {
        int nDebitaMountIndex = -1;
        NSString *strIndex = [pParse GetByName:@"DebitaMountIndex"];
        TZTStringToIndex(strIndex, nDebitaMountIndex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid && [ayGrid count] > 1)
        {
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < nDebitaMountIndex || nDebitaMountIndex < 0)
                    continue;
                NSString *nsValue = [ayData objectAtIndex:nDebitaMountIndex];
                if (nsValue && [nsValue length] > 0)
                {
                    if ([nsValue intValue] < [self.nsMaxReturn intValue])
                    {
                        [_pCrashReturn setLabelText:nsValue withTag_:KTag_MaxReturn];
                    }else
                    {
                        [_pCrashReturn setLabelText:self.nsMaxReturn withTag_:KTag_MaxReturn];
                    }
                }
            }
        }
        else
        {
            if (self.nsMaxReturn == NULL||(self.nsMaxReturn && 0 < [self.nsMaxReturn intValue]))
            {
                [_pCrashReturn setLabelText:@"0" withTag_:KTag_MaxReturn];
            }else
            {
                [_pCrashReturn setLabelText:self.nsMaxReturn withTag_:KTag_MaxReturn];
            }
        }
        if ([_pCrashReturn GetLabelText:KTag_MaxReturn].length < 1)
        {
            [_pCrashReturn setLabelText:@"0" withTag_:KTag_MaxReturn];
        }
    }
    return 1;
}
/*函数功能：请求最大可还
 入参：无
 出参：无
 */
-(void)OnrequestMaxReturn
{
    
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"408" withDictValue:pDict];
    
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
            if (_pCrashReturn)
            {
                if ([_pCrashReturn CheckInput])
                {
                    [self OnSend];
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
-(void)OnButtonClick:(id)sender
{
    tztUIButton *button = (tztUIButton *)sender;
    //添加了按钮发送请求方式
    
    switch ([button.tzttagcode intValue])
    {
        case 4000:
        case 10000:
        {
            [self CheckInput];
        }
            break;
        case 10001:
        {
            [self OnRefresh];
        }
            break;
        case 10002:
        {
            [self ClearData];
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
