/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztNewOpenGHView
 * 文件标识:
 * 摘要说明:		天汇宝新开回购界面
 * 先用 380 请求股票的详细信息，然后用150查询股东账号，新开回购功能发送请求 382
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztNewOpenGHView.h"
#import "tztJYLoginInfo.h"

@implementation tztNewOpenGHView
@synthesize tztTradeTable = _tztTradeTable;
@synthesize nsCurStockCode = _nsCurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize nsCurAccountType =_nsCurAccountType;

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
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
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
        [_tztTradeTable setTableConfig:@"tztUITradeTHBNewOpenSetting"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
}
//清空处理
-(void)ClearData
{
    [self.tztTradeTable setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
    [self.tztTradeTable setCheckBoxValue:FALSE withTag_:3000];
    [self.tztTradeTable setLabelText:@"" withTag_:4000];
    [self.tztTradeTable setLabelText:@"" withTag_:4001];
    [self.tztTradeTable setLabelText:@"" withTag_:4002];
    [self.tztTradeTable setLabelText:@"" withTag_:4003];
    [self.tztTradeTable setLabelText:@"" withTag_:4004];
    [self.tztTradeTable setLabelText:@"" withTag_:4005];
    [self.tztTradeTable setLabelText:@"" withTag_:4006];
}
- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    switch ([inputField.tzttagcode intValue])
	{
		case 2000:
		{
			if (inputField.text != NULL && [inputField.text length] == 6)
			{
                self.nsCurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                [self OnRequestData];
			}
		}
			break;
		default:
			break;
	}
}

-(void)GetMoney
{
    if (self.nsCurStockCode == NULL || [self.nsCurStockCode length] < 1)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:self.nsCurStockCode forKey:@"StockCode"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"26421" withDictValue:pDict];
	DelObject(pDict);
}
//获取股东账号请求
-(void)GetGDAndVolume
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"122" withDictValue:pDict];
	DelObject(pDict);
}
//获取基金账号
-(NSString *)GetFundAccount
{
     tztJYLoginInfo * userInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (userInfo)
        return  userInfo.nsFundAccount;
    
    return NULL;
}
//获取股票信息
-(void)OnRequestData
{
    if (self.nsCurStockCode == NULL || [self.nsCurStockCode length] < 1)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"MaxCount"];
    [pDict setTztValue:self.nsCurStockCode forKey:@"StockCode"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"380" withDictValue:pDict];
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
    if ([pParse IsAction:@"26421"])
    {
        NSString* strfundavl = [pParse GetByName:@"fundavl"];
        NSString* strstkmaxqty = [pParse GetByName:@"stkmaxqty"];
        if (strfundavl && [strfundavl length] > 0)
        {
            [self.tztTradeTable setLabelText:strfundavl withTag_:4000];
        }
        if (strstkmaxqty && [strstkmaxqty length] > 0)
        {
            [self.tztTradeTable setLabelText:strstkmaxqty withTag_:4001];
        }
        return 1;
    }
    if ([pParse IsAction:@"122"])
    {
        if (_ayAccount == nil)
            _ayAccount = NewObject(NSMutableArray);
        if (_ayType == nil)
            _ayType = NewObject(NSMutableArray);
        
        [_ayAccount removeAllObjects];
        [_ayType removeAllObjects];
        
        //股东账号及可卖可买
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 5)
                    continue;
                NSString* strType = [ayData objectAtIndex:0];
                if (strType == NULL || [strType length] <= 0)
                    strType = @"";
                strType = [strType lowercaseString];
                self.nsCurAccountType = [self.nsCurAccountType lowercaseString];
                if ([strType isEqualToString:self.nsCurAccountType])
                {
                    [_ayType addObject:strType];
                    NSString* strAccount = [ayData objectAtIndex:1];
                    if (strAccount == NULL || [strAccount length] <= 0)
                        continue;
                    
                    [_ayAccount addObject:strAccount];
                }
            }
        }
        
       [self.tztTradeTable setComBoxData:_ayAccount ayContent_:_ayAccount AndIndex_:0 withTag_:1000 bDrop_:FALSE];
       [self GetMoney];
        return 1;
    }
    
    if([pParse IsAction:@"380"])
    {
        int StockCodeIndex = -1;
        int StockNameIndex = -1;
        int PriceIndex = -1;
        int InterPriceIndex = -1;
        int AmonutIndex = -1;
        int DaysIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"StockCodeIndex"];
        TZTStringToIndex(strIndex, StockCodeIndex);
        
        strIndex = [pParse GetByName:@"StockNameIndex"];
        TZTStringToIndex(strIndex, StockNameIndex);
        
        strIndex = [pParse GetByName:@"PriceIndex"];
        TZTStringToIndex(strIndex, PriceIndex);
        
        strIndex = [pParse GetByName:@"InterPriceIndex"];
        TZTStringToIndex(strIndex, InterPriceIndex);
        
        strIndex = [pParse GetByName:@"AmonutIndex"];
        TZTStringToIndex(strIndex, AmonutIndex);
        
        strIndex = [pParse GetByName:@"DaysIndex"];
        TZTStringToIndex(strIndex, DaysIndex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 0; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData &&
                StockCodeIndex >= 0 && [ayData count] > StockCodeIndex&&
                StockNameIndex >= 0 && [ayData count] > StockNameIndex&&
                PriceIndex >= 0 && [ayData count] > PriceIndex&&
                InterPriceIndex >= 0 && [ayData count] > InterPriceIndex&&
                AmonutIndex >= 0 && [ayData count] > AmonutIndex&&
                DaysIndex >= 0 && [ayData count] > DaysIndex
                )
            {
                [self ClearData];
                NSString * Value = [ayData objectAtIndex:StockCodeIndex];
                if (![Value isEqualToString:self.nsCurStockCode])
                {
                    continue;
                }
                
                [self.tztTradeTable setEditorText:self.nsCurStockCode nsPlaceholder_:NULL withTag_:2000];
                
                Value = [ayData objectAtIndex:StockNameIndex];
                if (Value && [Value length] > 0)
                    [self.tztTradeTable setLabelText:Value withTag_:4002];
                Value = [ayData objectAtIndex:PriceIndex];
                if (Value && [Value length] > 0)
                    [self.tztTradeTable setLabelText:Value withTag_:4003];
                Value = [ayData objectAtIndex:InterPriceIndex];
                if (Value && [Value length] > 0)
                    [self.tztTradeTable setLabelText:Value withTag_:4005];
                Value = [ayData objectAtIndex:AmonutIndex];
                if (Value && [Value length] > 0)
                    [self.tztTradeTable setLabelText:Value withTag_:4006];
                Value = [ayData objectAtIndex:DaysIndex];
                if (Value && [Value length] > 0)
                    [self.tztTradeTable setLabelText:Value withTag_:4004];
            }
            [self GetGDAndVolume];
        }
        return 1;
    }
    
    if ([pParse IsAction:@"382"])
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        return 0;
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
	if (nTag == 5000)
	{
        [self CheckInput];
    }
}

-(void)tztDroplistViewGetData:(tztUIDroplistView *)droplistview
{
    if ([droplistview.tzttagcode intValue] ==  1000)
    {
        if ([droplistview.ayData count] < 1 || [droplistview.ayValue count] < 1)
        {
            [self GetGDAndVolume];
        }
    }
}

-(void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] ==  1000)
    {
        if ([_ayStockNum count] > 0)
        {
            unsigned long dCanCount = (unsigned long)[[_ayStockNum objectAtIndex:index] longLongValue];
            NSString* nsValue = @"";
            if (dCanCount > 100000000)
                nsValue = [NSString stringWithFormat:@"%.4f亿", (float)(dCanCount/100000000)];
            else
                nsValue = [NSString stringWithFormat:@"%ld", dCanCount];
            
            [self.tztTradeTable setLabelText:nsValue withTag_:4001];
        }
    }
}
//检查空处理
-(void)CheckInput
{
    NSString *strGDCode = [self.tztTradeTable getComBoxText:1000];
    if (strGDCode == NULL || [strGDCode length] < 1)
    {
        [self showMessageBox:@"股东代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString *strZQCode = [self.tztTradeTable GetEidtorText:2000];
    if (strZQCode == NULL || [strZQCode length] < 1)
    {
        [self showMessageBox:@"证券代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }

    NSString *strSL = [self.tztTradeTable GetEidtorText:2001];
    if (strSL == NULL || [strSL length] < 1)
    {
        [self showMessageBox:@"委托数量不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    NSString *strXZ = @"不续做";
    if([self.tztTradeTable getCheckBoxValue:3000])
    {
        strXZ = @"续做";
    }
    NSString* strInfo = @"";
    strInfo = [NSString stringWithFormat:@"证券代码:%@\r\n股东代码:%@\r\n委托数量:%@\r\n续做方式:%@\r\n",strZQCode,strGDCode,strSL,strXZ];

    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"新开回购"
                   nsOK_:@"确定"
               nsCancel_:@"取消"];

}
//发送请求
-(void)OnSend
{
    
    NSString *strGDCode = [self.tztTradeTable getComBoxText:1000];
    if (strGDCode == NULL || [strGDCode length] < 1)
    {
        [self showMessageBox:@"股东代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString *strZQCode = [self.tztTradeTable GetEidtorText:2000];
    if (strZQCode == NULL || [strZQCode length] < 1)
    {
        [self showMessageBox:@"证券代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString *strSL = [self.tztTradeTable GetEidtorText:2001];
    if (strSL == NULL || [strSL length] < 1)
    {
        [self showMessageBox:@"委托数量不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:strGDCode forKey:@"WTACCOUNT"];
    [pDict setTztValue:[_ayType objectAtIndex:[self.tztTradeTable getComBoxSelctedIndex:1000]] forKey:@"WTACCOUNTTYPE"];
    [pDict setTztValue:strZQCode forKey:@"StockCode"];
    [pDict setTztValue:strSL forKey:@"Volume"];
    
    [pDict setTztValue:[self.tztTradeTable GetLabelText:4003] forKey:@"Price"];
    [pDict setTztValue:[self.tztTradeTable GetLabelText:4005] forKey:@"InterPrice"];
    [pDict setTztValue:strSL forKey:@"Volume"];
    if ([self.tztTradeTable getCheckBoxValue:3000])
    {
        [pDict setTztValue:@"1" forKey:@"AutoRenew"];
    }else
    {
        [pDict setTztValue:@"0" forKey:@"AutoRenew"];
    }
    [pDict setTztValue:@"_" forKey:@"Direction"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"382" withDictValue:pDict];
	DelObject(pDict);
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
