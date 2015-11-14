//
//  tztUIFundFCView.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-14.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztUIFundFCView.h"
enum  {
	kTagCode = 1000,
    kTagZH = 2000,
    KTagCFType = 3000,
    kTagName = 4000,
    kTagKY = 5000,
    KTagTradesl = 7000,
};
@interface tztUIFundFCView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
@end

@implementation tztUIFundFCView

@synthesize tztTradeTable = _tztTradeTable;
@synthesize CurStockName = _CurStockName;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayType = _ayType;
@synthesize ayTypeData = _ayTypeData;
@synthesize nsTSInfo = _nsTSInfo;
@synthesize ayAccount = _ayAccount;
@synthesize ayAccountType = _ayAccountType;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _ayType = NewObject(NSMutableArray);
        [_ayType addObject:@"拆分"];
        [_ayType addObject:@"合并"];
        
        _ayTypeData = NewObject(NSMutableArray);
        [_ayTypeData addObject:@"{"];
        [_ayTypeData addObject:@"}"];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayType);
    DelObject(_ayTypeData);
    DelObject(_ayStockNum);
    DelObject(_ayAccount);
    DelObject(_ayAccountType);
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
        [_tztTradeTable setTableConfig:@"tztUITradeFundCF"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
        [_tztTradeTable setComBoxData:_ayType ayContent_:_ayType AndIndex_:0 withTag_:KTagCFType];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
}

//清空界面数据
-(void) ClearData
{
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagCode];
    [_tztTradeTable setLabelText:@"" withTag_:kTagName];
    [_tztTradeTable setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagZH];
    [_tztTradeTable setLabelText:@"" withTag_:kTagKY];
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:NULL withTag_:KTagTradesl];
    self.CurStockCode = @"";
    self.CurStockName = @"";
    
}

-(void)DealWithSysTextField:(TZTUITextField *)inputField
{
    if (inputField.tag == kTagCode)
    {
        
    }
}
- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    switch ([inputField.tzttagcode intValue])
	{
		case kTagCode:
		{
			if (inputField.text != NULL && [inputField.text length] == 6)
			{
                self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                [self OnRefresh];
			}
		}
			break;
		default:
			break;
	}
}

//请求股票信息
-(void)OnRefresh
{
    //    req=Reqno|MobileCode|MobileType|Cfrom|Tfrom|Token|ZLib|StartPos|MaxCount|StockCode|NeedCheck|CommBatchEntrustInfo|
    //    ans=Reqno|ErrorNo|ErrorMessage|Token|OnLineMessage|HsString|BankLsh|Title|StockCode|Price|buysell|MaxCount|Grid|CommBatchEntrustInfo|BankMoney|
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    [pDict setTztValue:@"0" forKey:@"NeedCheck"];
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"151" withDictValue:pDict];
    DelObject(pDict);
}



-(void)OnSend
{
    if (_tztTradeTable == nil)
        return;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:[_tztTradeTable GetEidtorText:KTagTradesl] forKey:@"VOLUME"];
    [pDict setTztValue:@"" forKey:@"Price"];
    [pDict setTztValue:[_ayTypeData objectAtIndex:[_tztTradeTable getComBoxSelctedIndex:KTagCFType]] forKey:@"Direction"];
    [pDict setTztValue:[_ayAccount objectAtIndex:[_tztTradeTable getComBoxSelctedIndex:kTagZH]] forKey:@"WTACCOUNT"];
    [pDict setTztValue:[_ayAccountType objectAtIndex:[_tztTradeTable getComBoxSelctedIndex:kTagZH]] forKey:@"WTACCOUNTTYPE"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"110" withDictValue:pDict];
    
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
    
    if ([pParse IsAction:@"110"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        [self ClearData];
        return 1;
    }
    
    if ([pParse IsAction:@"150"] || [pParse IsAction:@"151"])
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
            if (_tztTradeTable)
                [_tztTradeTable setLabelText:strName withTag_:kTagName];
        }
        else
        {
            [self showMessageBox:@"该基金代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
        
        //退市整理判断
        NSString* strTSFlag = [pParse GetByName:@"CommBatchEntrustInfo"];
        if (strTSFlag && [strTSFlag length] > 0)
            _nLeadTSFlag = [strTSFlag intValue];
        else
            _nLeadTSFlag = 1;
        
        NSString* strTSInfo = [pParse GetByName:@"BankMoney"];
        if (strTSInfo)
        {
            self.nsTSInfo = [NSString stringWithFormat:@"%@", strTSInfo];
        }
        else
            self.nsTSInfo = @"";
        //
        
        if (_ayAccount == nil)
            _ayAccount = NewObject(NSMutableArray);
        if (_ayAccountType == nil)
            _ayAccountType = NewObject(NSMutableArray);
        if (_ayStockNum == nil)
            _ayStockNum = NewObject(NSMutableArray);
        
        
        [_ayAccount removeAllObjects];
        [_ayAccountType removeAllObjects];
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
                
                
                NSString* strtype = [ayData objectAtIndex:1];
                if (strtype == NULL || [strtype length] <= 0)
                    strtype = @"";
                
                [_ayAccountType addObject:strtype];
                
                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayStockNum addObject:strNum];
                
                //可买、可卖显示
                if ([_ayStockNum count] > 0)
                {
                    NSString* nsValue = tztdecimalNumberByDividingBy([_ayStockNum objectAtIndex:0], 2);
                    [_tztTradeTable setLabelText:nsValue withTag_:kTagKY];
                }
            }
        }
        [_tztTradeTable setComBoxData:_ayAccount ayContent_:_ayType AndIndex_:0 withTag_:kTagZH];
        
        //有效小数位
        NSString *nsDot = [pParse GetByName:@"Volume"];
        if (ISNSStringValid(nsDot))
            _nDotValid = [nsDot intValue];
        _fMoveStep = 10 * _nDotValid;
        return 1;
    }
    return 1;
}

-(BOOL)CheckInput
{
    NSString * JJDM = [_tztTradeTable GetEidtorText:kTagCode];
    if(JJDM == nil || [JJDM length] < 1)
    {
        [self showMessageBox:@"基金公司代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSString *JJMC = [_tztTradeTable GetLabelText:kTagName];
    if(JJMC && [JJMC length] < 1)
    {
        [self showMessageBox:@"数据错误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSString * Account = [_tztTradeTable getComBoxText:kTagZH];
    if(Account == nil || [Account length] < 1)
    {
        [self showMessageBox:@"没有可用资金账号进行交易!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSString * typestr = [_tztTradeTable getComBoxText:KTagCFType];
    if(typestr == nil || [typestr length] < 1)
    {
        [self showMessageBox:@"委托类型错误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSString *count = [_tztTradeTable GetEidtorText:KTagTradesl];
    if(count == nil || [count length] < 1)
    {
        [self showMessageBox:@"请输入委托数量!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSString* strInfo = @"";
    strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n基金名称:%@\r\n委托账号:%@\r\n委托类型:%@\r\n委托数量:%@\r\n\r\n",self.CurStockCode,JJMC,Account,typestr,count];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"基金拆分合并"
                   nsOK_:@"确定"
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
                [self OnSend];
            }
                break;
                
            default:
                break;
        }
    }
}
//zxl 20131128 添加ipad点击处理
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

-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
		return;
	tztUIButton * pButton = (tztUIButton*)sender;
	int nTag = [pButton.tzttagcode intValue];
    //确认
	if (nTag == 5001)
	{
        [self CheckInput];
    }
}

@end
