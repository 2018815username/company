/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        现金增值计划登记view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztTTYOpenServiceView.h"

enum
{
    kTagQuery = 900,    //查询产品
    kTagCode = 1000,    //产品代码
    kTagName ,          //产品名称
    kTagGS,             //登记公司
    kTagKQZJ,           //可取资金
    KTagJE,             //金额
    
    kTagOK = 10000,
    kTagClear,
};

@implementation tztTTYOpenServiceView
@synthesize tztTradeView = _tztTradeView;
@synthesize CurStockCode = _CurStockCode;
@synthesize nsJJGSCode  = _nsJJGSCode;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
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
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)) 
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_tztTradeView == nil)
    {
        _tztTradeView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeView.tztDelegate = self;
        [_tztTradeView setTableConfig:@"tztUITradeTTYDengji"];
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
    {
        _tztTradeView.frame = rcFrame;
    }
}

-(void)SetDefaultData
{
    if (_tztTradeView == NULL)
        return;
}

//清空界面数据
-(void) ClearData
{
    if (_tztTradeView == NULL)
        return;
    
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagCode];
    [_tztTradeView setLabelText:@"" withTag_:kTagName];
    [_tztTradeView setLabelText:@"" withTag_:kTagGS];
    [_tztTradeView setLabelText:@"" withTag_:kTagKQZJ];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:KTagJE];
    self.CurStockCode = @"";
    self.nsJJGSCode = @"";
}

-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    [self OnRequestData];
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTagQuery)
    {
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            [_tztTradeView setEditorText:strCode nsPlaceholder_:nil withTag_:kTagCode];
            //setEdit已经发送了请求,避免重复调用 modify by xyt 20130909
            //[self DealWithStockCode:strCode];
        }
    }
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
}*/

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

//查询可登记代码
-(void)OnRequestData
{
    NSString* strAction = @"539";
    
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
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"145" withDictValue:pDict];
    
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
    
    if ([pParse IsAction:@"533"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
        return 1;
    }
    
    if ([pParse IsAction:@"145"])
    {   
        //基金状态
        int JJGSMC = -1;//基金公司
        int JJGSDM = -1;//基金公司代码索引
        int JJSTATEINDEX = -1;//基金状态索引
        int JJMCINDEX = -1;//基金名称索引
        int JJSFFSINDEX = -1;
        int PRICEINDEX = -1;
        int JJDMINDEX = -1;//基金代码索引
        NSString* JJSTATEINDEXStr = [pParse GetByName:@"JJSTATEINDEX"];
        TZTStringToIndex(JJSTATEINDEXStr, JJSTATEINDEX);
        
        NSString* JJMCINDEXStr = [pParse GetByName:@"JJMCINDEX"];
        TZTStringToIndex(JJMCINDEXStr, JJMCINDEX);
        
        NSString* JJSFFSINDEXStr = [pParse GetByName:@"JJSFFSINDEX"];
        TZTStringToIndex(JJSFFSINDEXStr, JJSFFSINDEX);
        
        NSString* PRICEINDEXStr = [pParse GetByName:@"PRICEINDEX"];
        TZTStringToIndex(PRICEINDEXStr, PRICEINDEX);
        
        NSString* JJDMINDEXStr = [pParse GetByName:@"JJDMINDEX"];
        TZTStringToIndex(JJDMINDEXStr, JJDMINDEX);
        
        NSString* JJGSINDEXStr = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(JJGSINDEXStr, JJGSDM);
        
        NSString* JJGSMCStr = [pParse GetByName:@"JJGSMC"];
        TZTStringToIndex(JJGSMCStr, JJGSMC);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (JJDMINDEX >= 0 && JJDMINDEX < [ayData count])
                {
                    NSString* strCode = [ayData objectAtIndex:JJDMINDEX];
                    if ([strCode compare:self.CurStockCode] != NSOrderedSame)
                    {
                        return 0;
                    }
                }
                
//                if (JJSTATEINDEX >= 0 && JJSTATEINDEX < [ayData count])
//                {
//                    NSString* strState = [ayData objectAtIndex:JJSTATEINDEX];
//                    if (_tztTradeView)
//                        [_tztTradeView setLabelText:strState withTag_:KTagState];
//                }
                
                if (JJMCINDEX >= 0 && JJMCINDEX < [ayData count])
                {
                    NSString* strname = [ayData objectAtIndex:JJMCINDEX];
                    if (_tztTradeView)
                        [_tztTradeView setLabelText:strname withTag_:kTagName];
                }
                
//                if (PRICEINDEX >= 0 && PRICEINDEX < [ayData count])
//                {
//                    NSString* strname = [ayData objectAtIndex:PRICEINDEX];
//                    if (_tztTradeView)
//                        [_tztTradeView setLabelText:strname withTag_:kTagJJJZ];
//                }
                
                if (JJGSDM >= 0 && JJGSDM < [ayData count])
                {
                    NSString* strJJGS = [ayData objectAtIndex:JJGSDM];
                    self.nsJJGSCode = [NSString stringWithFormat:@"%@", strJJGS];
//                    if(_tztTradeView)
//                    {
//                        [_tztTradeView setLabelText:strJJGS withTag_:kTagGS];                        
//                        self.nsJJGSCode = [NSString stringWithFormat:@"%@", strJJGS];
//                    }
                }
                
                if (JJGSMC >= 0 && JJGSMC < [ayData count])
                {
                    NSString* strJJGS = [ayData objectAtIndex:JJGSMC];
                    if (_tztTradeView) 
                    {
                        [_tztTradeView setLabelText:strJJGS withTag_:kTagGS];  
                    }
                }
            }
        }
        
        NSString* strUseable = [pParse GetByName:@"Usable"];
        if (_tztTradeView)
        {
            [_tztTradeView setLabelText:strUseable withTag_:kTagKQZJ];
            //获取当前界面输入
            NSString* nsName = [_tztTradeView GetLabelText:kTagName];
            NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
            if (nsName && nsCode && [nsCode length] == 6)
            {
                NSString* nsDefault = [NSString stringWithFormat:@"%@(%@)", nsCode, nsName];
                [_tztTradeView setComBoxText:nsDefault withTag_:kTagQuery];
            }

        }
        
        return 1;
    }
    
    if ([pParse IsAction:@"539"])
    {
        int JJDMINDEX = -1;//基金代码索引
        int JJMCINDEX = -1;//基金名称索引
        NSString* strIndex = [pParse GetByName:@"JJDMINDEX"];
        TZTStringToIndex(strIndex, JJDMINDEX);
        
        strIndex = [pParse GetByName:@"JJMCINDEX"];
        TZTStringToIndex(strIndex, JJMCINDEX);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            NSMutableArray  *pAyTitle = NewObject(NSMutableArray)
            NSString* strCode = @"";
            NSString* strName = @"";
            for (int i = 1; i < [ayGrid count]; ++i) 
            {
                NSArray* pAy = [ayGrid objectAtIndex:i];
                if (pAy == NULL)
                    continue;
                
                NSInteger nCount = [pAy count];
                if (nCount < 1 || JJDMINDEX >= nCount || JJMCINDEX >= nCount)
                    continue;
                
                if(JJDMINDEX >= 0 && JJDMINDEX < [pAy count])
                    strCode = [pAy objectAtIndex:JJDMINDEX];
                if (strCode == NULL || [strCode length] <= 0)
                    continue;
                
                if (JJMCINDEX >= 0 && JJMCINDEX < [pAy count])
                    strName = [pAy objectAtIndex:JJMCINDEX];
                if (strName == NULL)
                    strName = @"";
                
                NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
                [pAyTitle addObject:strTitle];
            }
            
            if (_tztTradeView && [pAyTitle count] > 0)
            {
                //获取当前界面输入
                NSString* nsName = [_tztTradeView GetLabelText:kTagName];
                NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
                if (nsName && nsCode && [nsCode length] == 6)
                {
                    NSString* nsDefault = [NSString stringWithFormat:@"%@(%@)", nsCode, nsName];
                    [_tztTradeView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:0 withTag_:kTagQuery bDrop_:YES];
                    [_tztTradeView setComBoxText:nsDefault withTag_:kTagQuery];
                }
                else
                {
                    [_tztTradeView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:0 withTag_:kTagQuery bDrop_:YES];
                }

            }
            
            if ([pAyTitle count] < 1)
            {
                [self showMessageBox:@"查无相应数据!" nType_:TZTBoxTypeNoButton nTag_:0];
            }
            
            DelObject(pAyTitle);
        }
    }
    
    return 1;
}

-(BOOL)CheckInput
{
    if (_tztTradeView == NULL)
        return  FALSE;
    
    NSString* nsMoney = [_tztTradeView GetEidtorText:KTagJE];
    NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
    NSString* nsName = [_tztTradeView GetLabelText:kTagName];
    
    if (nsCode == NULL || nsCode.length < 1)
    {
        [self showMessageBox:@"请输入基金代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    if (nsMoney == NULL || nsMoney.length < 1)
    {
        [self showMessageBox:@"请输入金额！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSString *typestr = nil;
    typestr = @"登记";
    
    //允许触发金额为0（0为允许所有资金参与该产品）
    if ([nsMoney compare:@"0"] == NSOrderedSame) 
    {
        NSString* nsPrice = [_tztTradeView GetLabelText:kTagKQZJ];
        if (nsPrice == NULL)
            nsPrice = @"0";
        nsMoney = [NSString stringWithFormat:@"%@",nsPrice];
    }
    
    if ([nsMoney floatValue] < 0.01)
    {
        NSString *str = [NSString stringWithFormat:@"%@金额输入不正确，请重新输入!", typestr];
        [self showMessageBox:str nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* strInfo = @"";
    strInfo = [NSString stringWithFormat:@"产品代码:%@\r\n产品名称:%@\r\n触发金额:%@\r\n\r\n确认%@该股票？",nsCode, nsName, nsMoney, typestr];
    
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
    if (_tztTradeView == NULL)
        return;
    
    NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
    if (nsCode == NULL || nsCode.length < 1)
    {
        [self showMessageBox:@"请输入基金代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }
    
    NSString* nsMoney = [_tztTradeView GetEidtorText:KTagJE];
    //允许触发金额为0（0为允许所有资金参与该产品）
    if ([nsMoney compare:@"0"] == NSOrderedSame) 
    {
        NSString* nsPrice = [_tztTradeView GetLabelText:kTagKQZJ];
        if (nsPrice == NULL)
            nsPrice = @"0";
        nsMoney = [NSString stringWithFormat:@"%@",nsPrice];
    }
    
    if (nsMoney == NULL || nsMoney.length < 1)
    {
        [self showMessageBox:@"请输入金额！" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsMoney forKey:@"BALANCE"];
    [pDict setTztValue:nsCode forKey:@"FUNDCODE"];
    if (self.nsJJGSCode)
        [pDict setTztObject:self.nsJJGSCode forKey:@"JJDJGSDM"];
    [pDict setTztValue:@"0" forKey:@"SERVICEFLAG"];

    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"533" withDictValue:pDict];
    
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
            if (_tztTradeView)
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
