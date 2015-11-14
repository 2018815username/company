//
//  tztUIFundCNTradeView.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-14.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztUIFundCNTradeView.h"

enum  {
	kTagCode = 1000,    //基金代码
    kTagZH = 2000,      //股东账号
    KTagTrade = 3000,   //认购金额
    kTagName = 4000,    //基金名称
    kTagKY = 5000,      //可用资金
    KTagTradelb = 6000, //
    kTagKYlb = 6001,
    KTagJJJZ = 7000,    //基金净值
    
    kTagOK = 10000,
    kTagClear,
    kTagCannel,    //返回
};
@interface tztUIFundCNTradeView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
@end

@implementation tztUIFundCNTradeView

@synthesize tztTradeTable = _tztTradeTable;
@synthesize CurStockName = _CurStockName;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize nsTSInfo = _nsTSInfo;
@synthesize pStock = _pStock;
@synthesize pCurSetStr = _pCurSetStr;

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
    if (!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        [_tztTradeTable setTableConfig:@"tztUITradeFundCN"];
        [self addSubview:_tztTradeTable];
        _nselectAccount = 0;
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
    
    switch (_nMsgType) 
    {
        case WT_JJRGFUNDEX:
        case WT_HBJJ_RG:
        case MENU_JY_FUNDIN_RenGou://场内基金认购
        {
            [_tztTradeTable setLabelText:@"认购金额" withTag_:KTagTradelb];
            [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入认购金额" withTag_:KTagTrade];
            [_tztTradeTable setLabelText:@"可用资金" withTag_:5001];
        }
            break;
        case WT_JJAPPLYFUNDEX:
        case WT_HBJJ_SG://(华泰 , 货币基金申购同 场内申购)
        case MENU_JY_FUND_HBShenGou:
        case MENU_JY_FUNDIN_ShenGou://场内基金申购
        {
            [_tztTradeTable SetImageHidenFlag:@"TZTJJJZ" bShow_:NO];
            //重新设置表格显示区域
            [_tztTradeTable OnRefreshTableView];
            [_tztTradeTable setLabelText:@"申购金额" withTag_:KTagTradelb];
            [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入申购金额" withTag_:KTagTrade];
            
            [_tztTradeTable setLabelText:@"可用资金" withTag_:5001];
        }
            break;
        case WT_JJREDEEMFUNDEX:
        case WT_HBJJ_SH://(华泰， 货币基金赎回同 场内赎回)
        case MENU_JY_FUND_HBShuHui:
        case MENU_JY_FUNDIN_ShuHui://场内基金赎回
        {
            [_tztTradeTable SetImageHidenFlag:@"TZTJJJZ" bShow_:NO];
            //重新设置表格显示区域
            [_tztTradeTable OnRefreshTableView];
            [_tztTradeTable setLabelText:@"赎回份额" withTag_:KTagTradelb];
            [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入赎回份额" withTag_:KTagTrade];
            [_tztTradeTable setLabelText:@"可用份额" withTag_:kTagKYlb];
            [_tztTradeTable setLabelText:@"可用份额" withTag_:5001];
        }
            break;
        default:
            break;
    }
    
	if(self.pStock && self.pStock.stockCode)
	{
		NSString* nsCode = @"";
		nsCode = [NSString stringWithFormat:@"%@", self.pStock.stockCode];
        [_tztTradeTable setEditorText:nsCode nsPlaceholder_:nil withTag_:kTagCode];
        NSString* nsname = [NSString stringWithFormat:@"%@", self.pStock.stockName];
        [_tztTradeTable setLabelText:nsname withTag_:kTagName];
	}
}

-(void)setStockCode:(NSString*)nsCode
{
    if (nsCode == NULL || [nsCode length] < 6)
        return;
    self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
    if (_tztTradeTable)
    {
        [_tztTradeTable setEditorText:nsCode nsPlaceholder_:NULL withTag_:kTagCode];
    }
}

//清空界面数据
-(void) ClearData
{   
    if (_tztTradeTable == NULL)
        return;
    
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:nil withTag_:kTagCode];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
}

-(void)ClearDataWithOutCode
{
    [_tztTradeTable setLabelText:@"" withTag_:kTagName];
    [_tztTradeTable setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTagZH];
    _nselectAccount = 0;
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:nil withTag_:KTagTrade];
    [_tztTradeTable setLabelText:@"" withTag_:kTagKY];
    [_tztTradeTable setLabelText:@"" withTag_:KTagJJJZ];
    
    [_ayAccount removeAllObjects];
    [_ayType removeAllObjects];
    [_ayStockNum removeAllObjects];
    
    
    self.CurStockName = @"";
}

-(void)DealWithSysTextField:(TZTUITextField *)inputField
{
    if (inputField.tag == kTagCode)
    {
        
    }
}

-(void)inputFieldDidChangeValue:(tztUITextField *)inputField
{
    switch ([inputField.tzttagcode intValue])
	{
		case kTagCode:
		{
			if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
                //[self ClearData];
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

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagCode:
		{
			if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
                [self ClearData];
			}
            
			if (inputField.text != NULL && inputField.text.length == 6)
			{
                if (self.CurStockCode && [self.CurStockCode caseInsensitiveCompare:inputField.text] != NSOrderedSame)
                {
                    self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                    [self ClearDataWithOutCode];
                }
			}
            else
            {
                self.CurStockCode = @"";
                [self ClearDataWithOutCode];
            }
            
			
			if ([self.CurStockCode length] == 6)
			{
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
    
    switch (_nMsgType) 
    {
        case WT_JJRGFUNDEX:
        case WT_JJAPPLYFUNDEX:
        case WT_HBJJ_RG://(华泰 , 货币基金认购同 场内认购)
        case WT_HBJJ_SG://(华泰 , 货币基金申购同 场内申购)
        case MENU_JY_FUND_HBShenGou:
        case MENU_JY_FUNDIN_RenGou://场内基金认购
        case MENU_JY_FUNDIN_ShenGou://场内基金申购
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
        }
            break;
        case WT_JJREDEEMFUNDEX:
        case WT_HBJJ_SH://(华泰， 货币基金赎回同 场内赎回)
        case MENU_JY_FUND_HBShuHui:
        case MENU_JY_FUNDIN_ShuHui://场内基金赎回
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"151" withDictValue:pDict];
        }
            break;
        default:
            break;
    }
    
    DelObject(pDict);
}


-(void)OnSend
{
    if (_tztTradeTable == nil)
        return;
    
    //股东账号
    NSInteger nIndex = [_tztTradeTable getComBoxSelctedIndex:kTagZH];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    
    NSString * nsCode = [_tztTradeTable GetEidtorText:kTagCode];
    if(nsCode == nil || [nsCode length] < 1)
    {
        [self showMessageBox:@"基金公司代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }

    NSString * countORprice = [_tztTradeTable GetEidtorText:KTagTrade];
    if (countORprice == nil || [countORprice length] < 1)
        return;
    
    NSString* nsPrice = [_tztTradeTable GetLabelText:KTagJJJZ];
    if (nsPrice == NULL)
        nsPrice = @"";
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsCode forKey:@"FUNDCODE"];
    [pDict setTztValue:countORprice forKey:@"VOLUME"];
    [pDict setTztValue:nsAccount forKey:@"WTACCOUNT"];
    [pDict setTztValue:nsAccountType forKey:@"WTACCOUNTTYPE"];
    
    switch (_nMsgType) 
    {
        case WT_JJRGFUNDEX:
        case MENU_JY_FUNDIN_RenGou://场内基金认购
        {
            [pDict setTztValue:nsPrice forKey:@"PRICE"];
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"146" withDictValue:pDict];
        }
            break;
        case WT_JJAPPLYFUNDEX:
        case MENU_JY_FUNDIN_ShenGou://场内基金申购
        {
            [pDict setTztValue:nsPrice forKey:@"PRICE"];
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"147" withDictValue:pDict];
        }
            break;
            
        case WT_JJREDEEMFUNDEX:
        case MENU_JY_FUNDIN_ShuHui://场内基金赎回
        {
            [pDict setTztValue:nsPrice forKey:@"PRICE"];
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"148" withDictValue:pDict];
        }
            break;
            
        case WT_HBJJ_RG:
            break;
        case WT_HBJJ_SG://(华泰， 货币基金申购同 场内申购)
        case MENU_JY_FUND_HBShenGou:
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"590" withDictValue:pDict];
        }
            break;
        case WT_HBJJ_SH://(华泰， 货币基金赎回同 场内赎回)
        case MENU_JY_FUND_HBShuHui:
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"591" withDictValue:pDict];
        }
            break;
        default:
            break;
    }
    
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
    
    if ([pParse IsAction:@"142"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
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
            [self showMessageBox:@"该证券代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
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
                
                NSString* strtype = [ayData objectAtIndex:1];
                if (strtype == NULL || [strtype length] <= 0)
                    strtype = @"";
                
                [_ayType addObject:strtype];
                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayStockNum addObject:strNum];
            }
        }
        
        [_tztTradeTable setComBoxData:_ayAccount ayContent_:_ayType AndIndex_:0 withTag_:kTagZH];
        
        //可买、可卖显示
        if ([_ayStockNum count] > 0 &&
            ((_nMsgType == WT_JJREDEEMFUNDEX) || (_nMsgType == MENU_JY_FUNDIN_ShuHui)
             || (_nMsgType == WT_HBJJ_SH) || (_nMsgType == MENU_JY_FUND_HBShuHui)))
        {
            NSString* nsValue = tztdecimalNumberByDividingBy([_ayStockNum objectAtIndex:0], 2);
            [_tztTradeTable setLabelText:nsValue withTag_:kTagKY];
        }
        
        //有效小数位
        NSString *nsDot = [pParse GetByName:@"Volume"];
        if (ISNSStringValid(nsDot))
            _nDotValid = [nsDot intValue];
        _fMoveStep = 10 * _nDotValid;
        
        //可用资金 //修改判断modify by xyt 20131030
        if ( (_nMsgType !=  WT_JJREDEEMFUNDEX) && (_nMsgType != MENU_JY_FUNDIN_ShuHui)
            && (_nMsgType != WT_HBJJ_SH) && (_nMsgType != MENU_JY_FUND_HBShuHui))
        {
//            NSString* nsMoney = @"";
//            nsMoney = [pParse GetByName:@"BANKVOLUME"];
//            [_tztTradeTable setLabelText:nsMoney withTag_:kTagKY];
            //可用资金
            NSString* nsMoney = [pParse GetByName:@"Banklsh"];//bankvolume
            if (nsMoney == NULL || [nsMoney length] < 1)
            {
                nsMoney = [pParse GetByName:@"Usable"];
                if (nsMoney == NULL || [nsMoney length] < 1)
                {
                    nsMoney = [pParse GetByName:@"BankVolume"];
                    if (nsMoney == NULL || [nsMoney length] < 1)
                        nsMoney = @"";
                }
            }
            [_tztTradeTable setLabelText:nsMoney withTag_:kTagKY];
        }

        //当前价格
        NSString* nsPrice = [pParse GetByName:@"Price"];
        if (nsPrice && _tztTradeTable)
        {
            [_tztTradeTable setLabelText:nsPrice withTag_:KTagJJJZ];
        }
        return 1;
    }
    else if ([pParse IsAction:@"146"] || [pParse IsAction:@"147"] || [pParse IsAction:@"148"] || [pParse IsAction:@"590"] || [pParse IsAction:@"591"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
        return 1;
    }
    return 1;
}

-(BOOL)CheckInput
{
    if (_tztTradeTable == NULL)
        return FALSE;
    
    //股东账号
    NSInteger nIndex = [_tztTradeTable getComBoxSelctedIndex:kTagZH];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    
    NSString * nsCode = [_tztTradeTable GetEidtorText:kTagCode];
    if(nsCode == nil || [nsCode length] < 1)
    {
        [self showMessageBox:@"基金公司代码不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    NSString *nsName = [_tztTradeTable GetLabelText:kTagName];
    if(nsName && [nsName length] < 1)
    {
        [self showMessageBox:@"数据错误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    if(nsAccount == nil || [nsAccount length] < 1)
    {
        [self showMessageBox:@"没有可用资金账号进行交易!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* title = @"";
    if ((_nMsgType == WT_JJRGFUNDEX) ||(_nMsgType == MENU_JY_FUNDIN_RenGou)
        || (_nMsgType == WT_HBJJ_RG))
    {
        title = @"认购金额";
    }else if( (_nMsgType == WT_JJAPPLYFUNDEX) || (_nMsgType == MENU_JY_FUNDIN_ShenGou)
             || (_nMsgType == WT_HBJJ_SG) || (_nMsgType == MENU_JY_FUND_HBShenGou))
    {
        title = @"申购金额";
    }else if((_nMsgType == WT_JJREDEEMFUNDEX) || (_nMsgType == MENU_JY_FUNDIN_ShuHui)
             || (_nMsgType == WT_HBJJ_SH) || (_nMsgType == MENU_JY_FUND_HBShuHui))
    {
        title =  @"赎回份额";
    }
    
    NSString * nsCount = [_tztTradeTable GetEidtorText:KTagTrade];
    if(nsCount == nil || [nsCount length] < 1)
    {
        [self showMessageBox:[NSString stringWithFormat:@"%@不能为空！",title] nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n%@:%@\r\n账号:%@\r\n基金名称:%@\r\n\r\n",nsCode, title, nsCount, nsAccount, nsName];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:GetTitleByID(_nMsgType)
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
                [self OnSend];
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
    //zxl 20130711 添加了按钮确认处理方式
    switch (nTag)
    {
        case 5001:
        case kTagOK:
        {
            [self CheckInput];
        }
            break;
        case kTagClear:
        {
            [self ClearData];
        }
        case kTagCannel://返回
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

@end


