/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztRZRQBuySellView.h"
/*tag值，与配置文件中对应*/
enum  {
	kTagCode = 2000,
	kTagPrice , //委托价格
	kTagCount,  //委托数量
	
    kTagNewPrice = 4997,
    kTagNewCount = 4999,
	kTagStockInfo = 5000,
    kTagStockCode = 2220,
};


@implementation tztRZRQBuySellView
@synthesize tztTradeView = _tztTradeView;
@synthesize CurStockName = _CurStockName;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize ayData = _ayData;
@synthesize bBuyFlag = _bBuyFlag;
@synthesize nsTSInfo = _nsTSInfo;

-(id)init
{
    if (self = [super init])
    {
        _nDotValid = 2;
        _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
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
    
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_tztTradeView == NULL)
    {
        _tztTradeView = NewObject(tztUIVCBaseView);
        _tztTradeView.tztDelegate = self;
        if (_bBuyFlag/*
            || _nMsgType == WT_RZRQRQSALE || _nMsgType == MENU_JY_RZRQ_XYSell
            || _nMsgType == WT_RZRQSALERETURN || _nMsgType == MENU_JY_RZRQ_SellReturn
            || _nMsgType == WT_RZRQSALE || _nMsgType == MENU_JY_RZRQ_PTSell*/)//3923 3925 3927
            _tztTradeView.tableConfig = @"tztUITradeRZRQBuyStock";
        else
            _tztTradeView.tableConfig = @"tztUITradeRZRQSaleStock";
        
        _tztTradeView.frame = rcFrame;
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
        _tztTradeView.frame = rcFrame;
    
    //根据不同页面,显示有所区别
    switch (_nMsgType) 
    {
        case WT_RZRQBUY:    //普通买入
        case MENU_JY_RZRQ_PTBuy:
        //case WT_RZRQSALE:   //普通卖出
            [_tztTradeView setLabelText:@"资金" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约买" withTag_:kTagNewCount-1];
            break;
        case WT_RZRQSALE:   //普通卖出
        case MENU_JY_RZRQ_PTSell:
            [_tztTradeView setLabelText:@"资金" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约卖" withTag_:kTagNewCount-1];
//            UIView *pTemp= [_tztTradeView getViewWithTag:kTagNewPrice-1];
//            pTemp.hidden = YES;
//            pTemp = [_tztTradeView getViewWithTag:kTagNewCount-1];
//            pTemp.hidden = YES;
            break;
        case WT_RZRQRZBUY:  //融资买入
        case MENU_JY_RZRQ_XYBuy:
            [_tztTradeView setLabelText:@"金额" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约买" withTag_:kTagNewCount-1];
            break;
        case WT_RZRQRQSALE: //融券卖出
        case MENU_JY_RZRQ_XYSell:
            [_tztTradeView setLabelText:@"专户" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约卖" withTag_:kTagNewCount-1];
            break;
        case WT_RZRQBUYRETURN://买券还券
        case MENU_JY_RZRQ_BuyReturn:
            [_tztTradeView setLabelText:@"合约" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约买" withTag_:kTagNewCount-1];
            [_tztTradeView setButtonTitle:@"买入" clText_:nil forState_:UIControlStateNormal withTag_:10000];
            break;
        case WT_RZRQSALERETURN://卖券还款
        case MENU_JY_RZRQ_SellReturn:
            [_tztTradeView setLabelText:@"负债" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约卖" withTag_:kTagNewCount-1];
            break;
        default:
            break;
    }
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    
//    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
//    NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
    
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
			}
            
			if (inputField.text != NULL)
			{
                self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
			}
            
			
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
			}
		}
			break;
        case kTagStockCode://可编辑的下拉控件 // byDBQ20130731
        {
            if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0 && self.CurStockCode.length > 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
                [self ClearData];
			}
            
			if (inputField.text != NULL)
			{
                self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
			}
            
			
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
			}
        }
            break;
		case kTagPrice:
		{
		}
			break;
		case kTagCount:
		{
		}
			break;
		default:
			break;
    }
}

-(void)tztUIBaseView:(UIView *)tztUIBaseView focuseChanged:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%ldf",(long)_nDotValid];
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagPrice:
        {
            if(!_bBuyFlag)
                return;
            NSString* strPrice = [NSString stringWithFormat:strPriceformat, [inputField.text floatValue]];
            if (_tztTradeView)
            {
                if(strPrice && [strPrice length] > 0 && [strPrice floatValue] >= _fMoveStep)
                {
                    [self OnRefresh];
                }
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
    if (_tztTradeView)
    {
        [_tztTradeView setEditorText:nsCode nsPlaceholder_:NULL withTag_:2000];
    }
}

//清空界面数据
-(void) ClearData
{
    [_tztTradeView setComBoxText:@"" withTag_:kTagStockCode]; // byDBQ20130731
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:1000];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2000];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2002];
    [_tztTradeView setLabelText:@"" withTag_:2020];
    //清空可编辑的droplist控件数据 // byDBQ20130731
    [_tztTradeView setComBoxTextField:kTagStockCode];
    
    [_tztTradeView setLabelText:@"" withTag_:3000];
    
    //
    [_tztTradeView setLabelText:@"" withTag_:kTagNewPrice];
    [_tztTradeView setButtonTitle:@""
                          clText_:[UIColor whiteColor]
                        forState_:UIControlStateNormal
                         withTag_:kTagNewCount];
    for (int i = 5000; i <= 5026; i++)
    {
        [_tztTradeView setButtonTitle:@""
                              clText_:[UIColor whiteColor]
                            forState_:UIControlStateNormal
                             withTag_:i];
    }
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
    switch (_nMsgType) 
    {
        case WT_RZRQBUY:    //普通买入  担保买入
        case MENU_JY_RZRQ_PTBuy:
        case WT_RZRQSALE:
        case MENU_JY_RZRQ_PTSell:
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"402" withDictValue:pDict];
            break;
//        case WT_RZRQSALE:   //普通卖出 担保卖出
            //[[tztMoblieStockComm getShareInstance] onSendDataAction:@"403" withDictValue:pDict];
//            break;
        case WT_RZRQRZBUY:  //融资买入
        case MENU_JY_RZRQ_XYBuy:
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"406" withDictValue:pDict];
            break;
        case WT_RZRQRQSALE: //融券卖出
        case MENU_JY_RZRQ_XYSell:
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"406" withDictValue:pDict];
            break;
        case WT_RZRQBUYRETURN://卖券还券
        case MENU_JY_RZRQ_BuyReturn:
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"408" withDictValue:pDict];
            break;
        case WT_RZRQSALERETURN://买券还款
        case MENU_JY_RZRQ_SellReturn:
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"406" withDictValue:pDict];
            break;
        default:
            break;
    }
    DelObject(pDict);
}

//请求股票信息
-(void)OnRefresh
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    //
    
    if (_bBuyFlag)
    {
        NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
        if (nsPrice && [nsPrice length] > 0 && [nsPrice floatValue] >= _fMoveStep)
        {
            [pDict setTztValue:nsPrice forKey:@"Price"];
        }
    }
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    switch (_nMsgType) 
    {
        case WT_RZRQBUY:
        case MENU_JY_RZRQ_PTBuy:
            [pDict setTztValue:@"1" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQSALE:
        case MENU_JY_RZRQ_PTSell:
            [pDict setTztValue:@"2" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQRZBUY:
        case MENU_JY_RZRQ_XYBuy:
            [pDict setTztValue:@"3" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQRQSALE:
        case MENU_JY_RZRQ_XYSell:
            [pDict setTztValue:@"4" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQBUYRETURN:
        case MENU_JY_RZRQ_BuyReturn:
            [pDict setTztValue:@"5" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQSALERETURN:
        case MENU_JY_RZRQ_SellReturn:
            [pDict setTztValue:@"6" forKey:@"CREDITTYPE"];
            break;
        default:
            break;
    }
    
    NSString *strAction = @"";
    if (_bBuyFlag)
    {
        strAction = @"428";
        [pDict setTztValue:@"B" forKey:@"Direction"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    }
    else
    {
        strAction = @"429";
        [pDict setTztValue:@"S" forKey:@"Direction"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
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
    
    NSString* strReqno = [pParse GetByName:@"Reqno"];
    tztNewReqno *reqno = [tztNewReqno reqnoWithString:strReqno];
    if ([pParse IsAction:@"400"] || [pParse IsAction:@"422"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
        return 0;
    }
    
    if ([pParse IsAction:@"402"]) 
    {
        int nUsableIndex = -1;      //可用余额
        
        NSString *strIndex = [pParse GetByName:@"UsableIndex"];
        TZTStringToIndex(strIndex, nUsableIndex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                if (nUsableIndex >= 0 && [ayData count] > nUsableIndex) 
                {
                    NSString *str = [ayData objectAtIndex:nUsableIndex];
                    if (str != NULL) 
                    {
                        [_tztTradeView setLabelText:str withTag_:kTagNewPrice];
                    }
                }
                
            }
        }
    }
    
    if ([pParse IsAction:@"403"] || [pParse IsAction:@"416"]
        || ([pParse IsAction:@"408"] && [reqno getReqdefOne] == _nMsgType))
    {
        int nStockName = -1;
        int nStockCodeIndex = -1;
        
        NSString *strIndex = [pParse GetByName:@"StockName"];
        TZTStringToIndex(strIndex, nStockName);
        
        if (nStockName < 0)
        {
            strIndex = [pParse GetByName:@"StockNameIndex"];
            TZTStringToIndex(strIndex, nStockName);
        }
        
        strIndex = [pParse GetByName:@"StockCodeIndex"];
        TZTStringToIndex(strIndex, nStockCodeIndex);
        
        if (nStockCodeIndex < 0)
        {
            strIndex = [pParse GetByName:@"stockindex"];
            TZTStringToIndex(strIndex, nStockCodeIndex);
        }
        
        if (nStockName < 0)
            return 0;
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        
        if (_ayData == NULL)
            _ayData = NewObject(NSMutableArray);
        [_ayData removeAllObjects];
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSString* strCode = @"";
        NSString* strName = @"";
        for (int i = 1; i < [pGridAy count]; i++)
        {
            NSArray* pAy = [pGridAy objectAtIndex:i];
            
            if(nStockCodeIndex >= 0 && nStockCodeIndex < [pAy count])
                strCode = [pAy objectAtIndex:nStockCodeIndex];
            if (strCode == NULL || [strCode length] <= 0)
                continue;
            
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strCode forKey:@""];
            
            if (nStockName >= 0 && nStockName < [pAy count])
                strName = [pAy objectAtIndex:nStockName];
            if (strName == NULL)
                strName = @"";
            [pDict setTztObject:strName forKey:@""];
            
            [_ayData addObject:pDict];
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
            [pAyTitle addObject:strTitle];
            DelObject(pDict);
        }
        
        if (_tztTradeView && [pAyTitle count] > 0)
        {
            //获取当前界面输入
            NSString* nsName = [_tztTradeView GetLabelText:3000];
            NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
            if (nsName && nsCode && [nsCode length] == 6)
            {
                NSString* nsDefault = [NSString stringWithFormat:@"%@(%@)", nsCode, nsName];
                [_tztTradeView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSel withTag_:kTagStockCode bDrop_:YES];
                [_tztTradeView setComBoxText:nsDefault withTag_:kTagStockCode];
            }
            else
            {
                if (_nCurrentSel < 0 || _nCurrentSel >= [pAyTitle count])
                    _nCurrentSel = 0;
                [_tztTradeView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSel withTag_:kTagStockCode bDrop_:YES];
                //清空combox显示内容 byDBQ20130731
                [_tztTradeView setComBoxText:@"" withTag_:kTagStockCode];
                [_tztTradeView setComBoxTextField:kTagStockCode];
            }
        }
    }

    
    if ([pParse IsAction:@"406"]) 
    {
        int nFzzjeindex = -1;//负债总金额
        
        NSString *strIndex = [pParse GetByName:@"fzzjeindex"];
        TZTStringToIndex(strIndex, nFzzjeindex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                if (nFzzjeindex >= 0 && [ayData count] > nFzzjeindex) 
                {
                    NSString *str = [ayData objectAtIndex:nFzzjeindex];
                    if (str != NULL && [str length]>0) 
                    {
                        [_tztTradeView setLabelText:str withTag_:kTagNewPrice];
                    }
                    else
                    {
                        [_tztTradeView setLabelText:@"0" withTag_:kTagNewPrice];
                    }
                }
            }
        }
    }
    
    if ([pParse IsAction:@"408"] && !([reqno getReqdefOne] == _nMsgType))
    {
        int nDebitamountindex = -1;//负债数量
        
        NSString *strIndex = [pParse GetByName:@"debitamountindex"];
        TZTStringToIndex(strIndex, nDebitamountindex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        [_tztTradeView setLabelText:@"0" withTag_:kTagNewPrice];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                if (nDebitamountindex >= 0 && [ayData count] > nDebitamountindex) 
                {
                    NSString *str = [ayData objectAtIndex:nDebitamountindex];
                    if (str != NULL && [str length]>0) 
                    {
                        [_tztTradeView setLabelText:str withTag_:kTagNewPrice];
                    }
                    else
                    {
                        [_tztTradeView setLabelText:@"0" withTag_:kTagNewPrice];
                    }
                }
            }
        }
    }

    
    if ([pParse IsAction:@"150"] || [pParse IsAction:@"151"] 
        || [pParse IsAction:@"428"] || [pParse IsAction:@"429"])
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
            if (_tztTradeView)
            {
                [_tztTradeView setLabelText:strName withTag_:3000];
                //                [_tztTradeView setEditorText:self.CurStockCode nsPlaceholder_:NULL withTag_:2000];
            }
        }
        else
        {
            [self showMessageBox:@"该股票代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
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
        
        [_tztTradeView setComBoxData:_ayAccount ayContent_:_ayAccount AndIndex_:0 withTag_:1000];
        
        //可买、可卖显示
        NSString* nsValue = @"";
        if ([_ayStockNum count] > 0)
        {
            unsigned long dCanCount = (unsigned long)[[_ayStockNum objectAtIndex:0] longLongValue];
            if (dCanCount > 100000000) 
                nsValue = [NSString stringWithFormat:@"%.4f亿", (float)(dCanCount/100000000)];
            else
                nsValue = [NSString stringWithFormat:@"%ld", dCanCount];
        }
        
        UIColor * color = [UIColor whiteColor];
        if (!g_nJYBackBlackColor)
            color = [UIColor blackColor];
        
        [_tztTradeView setButtonTitle:nsValue
                              clText_:color
                            forState_:UIControlStateNormal
                             withTag_:kTagNewCount];   
        
        //有效小数位
        NSString *nsDot = [pParse GetByName:@"Volume"];
        _nDotValid = [nsDot intValue];
        _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
        
        [_tztTradeView setEditorDotValue:_nDotValid withTag_:kTagPrice];
        
        //可用资金
        NSString* nsMoney = [pParse GetByName:@"BankVolume"];
        if (nsMoney == NULL || [nsMoney length] < 1)
            nsMoney = @"";
        
//        [_tztTradeView setButtonTitle:nsMoney
//                              clText_:[UIColor magentaColor]
//                            forState_:UIControlStateNormal
//                             withTag_:kTagStockInfo];
        
        nsMoney = [pParse GetByName:@"BankLsh"];
        
        //买卖5档数据
        float dPClose = 0.0f;
        NSString *nsBuySell = [pParse GetByName:@"buysell"];
        if (nsBuySell && [nsBuySell length] > 0)
        {
            NSArray* ayGridRow = [nsBuySell componentsSeparatedByString:@"|"];
            //昨收
            if([ayGridRow count] > 5)
            {
                dPClose = [[ayGridRow objectAtIndex:5] floatValue];
            }
            
            for (int i = 0; i < [ayGridRow count]; i++)
            {
                NSString* nsValue = [ayGridRow objectAtIndex:i];
                
                UIColor* txtColor = ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1] :
                ( ([nsValue floatValue] > dPClose) ? [UIColor redColor] : [UIColor  colorWithRed:0.0 green:136.0/255.0 blue:26.0/255.0 alpha:1.0] );
                int nTag = 0;
                switch (i)
                {
                    case 0://现手
                    {
                        nTag = kTagStockInfo+1;
                        if (!g_nJYBackBlackColor)
                            txtColor = [UIColor blackColor];
                        else
                            txtColor = [UIColor whiteColor];
                    }
                        break;
                    case 1://买一
                    {
                        nTag = 5004;
                    }
                        break;
                    case 2://买一量
                    {
                        nTag = 5017;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 3://卖一
                    {
                        nTag = 5009;
                    }
                        break;
                    case 4://卖一量
                    {
                        nTag = 5022;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 5://昨收
                        break;
                    case 6://涨停
                    {
                        nTag = 5002;
                    }
                        break;
                    case 7://跌停
                    {
                        nTag = 5003;
                    }
                        break;
                    case 8://买二
                    {
                        nTag = 5005;
                    }
                        break;
                    case 9://买二量
                    {
                        nTag = 5018;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 10://买三
                    {
                        nTag = 5006;
                    }
                        break;
                    case 11://买三量
                    {
                        nTag = 5019;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 12://买四
                    {
                        nTag = 5007;
                    }
                        break;
                    case 13://买四量
                    {
                        nTag = 5020;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 14://买五
                    {
                        nTag = 5008;
                    }
                        break;
                    case 15://买五量
                    {
                        nTag = 5021;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 16://卖二
                    {
                        nTag = 5010;
                    }
                        break;
                    case 17://卖二量
                    {
                        nTag = 5023;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 18://卖三
                    {
                        nTag = 5011;
                    }
                        break;
                    case 19://卖三量
                    {
                        nTag = 5024;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 20://卖四
                    {
                        nTag = 5012;
                    }
                        break;
                    case 21://卖四量
                    {
                        nTag = 5025;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 22://卖五
                    {
                        nTag = 5013;
                    }
                        break;
                    case 23://卖五量
                    {
                        nTag = 5026;
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    default:
                        break;
                }
                
                [_tztTradeView setButtonTitle:nsValue
                                      clText_:txtColor
                                    forState_:UIControlStateNormal
                                     withTag_:nTag];
            }
        }
        
        //当前价格
        NSString* nsPrice = [pParse GetByName:@"Price"];
        //
        NSString* strPrice = [_tztTradeView GetEidtorText:kTagPrice];
        if (nsPrice && _tztTradeView && strPrice.length < 1)
        {
            [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:2001];
            //
            [_tztTradeView setButtonTitle:nsPrice clText_:[UIColor redColor] forState_:UIControlStateNormal withTag_:kTagStockInfo];
        }
        
//        if (_nMsgType != WT_RZRQSALE) 
        {
            [self OnInquireFund];
        }
    }
    return 1;
}

-(BOOL)CheckInput
{
    if (_tztTradeView == NULL || ![_tztTradeView CheckInput])
        return FALSE;
    
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
    
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    //股票代码
    NSString* nsCode = @"";
    if (_nMsgType == WT_RZRQSALE || _nMsgType == MENU_JY_RZRQ_PTSell
        || _nMsgType == WT_RZRQRQSALE || _nMsgType == MENU_JY_RZRQ_XYSell
        || _nMsgType == WT_RZRQSALERETURN || _nMsgType == MENU_JY_RZRQ_SellReturn
        || _nMsgType == WT_RZRQBUYRETURN || _nMsgType == MENU_JY_RZRQ_BuyReturn)
    {
        nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    }
    else
    {
        nsCode = [_tztTradeView GetEidtorText:kTagCode];
    }
    
    if (nsCode == NULL || [nsCode length] < 1)
        return FALSE;
    
    //委托价格
    NSString* nsPrice = [_tztTradeView GetEidtorText:2001];
    if (nsPrice == NULL || [nsPrice length] < 1 || [nsPrice floatValue] < 0.01f)
    {
        [self showMessageBox:@"委托价格输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //委托数量
    NSString* nsAmount = [_tztTradeView GetEidtorText:2002];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"委托数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //股票名称
    NSString* nsName = [_tztTradeView GetLabelText:3000];
    if (nsName == NULL)
        nsName = @"";
    
    NSString* strInfo = @"";
    
    if (_nMsgType == WT_RZRQBUYRETURN || _nMsgType == MENU_JY_RZRQ_BuyReturn)
    {
        strInfo = [NSString stringWithFormat:@"委托账号:%@\r\n股票代码:%@\r\n股票名称:%@\r\n委托价格:%@\r\n委托数量:%@\r\n\r\n确认%@该股票？", nsAccount, nsCode, nsName, nsPrice, nsAmount, @"买入"];
    }
    else
        strInfo = [NSString stringWithFormat:@"委托账号:%@\r\n股票代码:%@\r\n股票名称:%@\r\n委托价格:%@\r\n委托数量:%@\r\n\r\n确认%@该股票？", nsAccount, nsCode, nsName, nsPrice, nsAmount, (_bBuyFlag?@"买入":@"卖出")];
    
    if (_nLeadTSFlag == 0)
    {
        if (self.nsTSInfo)
        {
            strInfo = [NSString stringWithFormat:@"%@\r\n%@", strInfo, self.nsTSInfo];
        }
    }
    
    NSString* nsTitle = @"系统提示";
    switch (_nMsgType)
    {
        case WT_RZRQRZBUY:
        case MENU_JY_RZRQ_XYBuy:
            nsTitle = @"融资买入";
            break;
        case WT_RZRQRQSALE:
        case MENU_JY_RZRQ_XYSell:
            nsTitle = @"融券卖出";
            break;
            
        default:
            break;
    }
    
    if (_nMsgType == WT_RZRQBUYRETURN || _nMsgType == MENU_JY_RZRQ_BuyReturn)
    {
        [self showMessageBox:strInfo
                      nType_:TZTBoxTypeButtonBoth
                       nTag_:0x1111
                   delegate_:self
                  withTitle_:nsTitle
                       nsOK_:@"买入"
                   nsCancel_:@"取消"];
    }
    else
    {
        [self showMessageBox:strInfo
                      nType_:TZTBoxTypeButtonBoth
                       nTag_:0x1111
                   delegate_:self
                  withTitle_:nsTitle
                       nsOK_:(_bBuyFlag?@"买入":@"卖出")
                   nsCancel_:@"取消"];
    }
    return TRUE;
}

-(void)goBuySell
{
    if (_nLeadTSFlag == -1)
    {
        if (self.nsTSInfo && [self.nsTSInfo length] > 0)
        {
            [self showMessageBox:self.nsTSInfo
                          nType_:TZTBoxTypeNoButton
                           nTag_:0
                       delegate_:nil
                      withTitle_:@"退市提醒"];
        }
        return;
    }
    else
        [self CheckInput];
}

//买卖确认
-(void)OnSendBuySell
{
    if (_tztTradeView == nil)
        return;
    //股东账户
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    //股票代码
    NSString* nsCode = @"";
    if (_nMsgType == WT_RZRQSALE || _nMsgType == MENU_JY_RZRQ_PTSell
        || _nMsgType == WT_RZRQRQSALE || _nMsgType == MENU_JY_RZRQ_XYSell
        || _nMsgType == WT_RZRQSALERETURN || _nMsgType == MENU_JY_RZRQ_SellReturn
        || _nMsgType == WT_RZRQBUYRETURN || _nMsgType == MENU_JY_RZRQ_BuyReturn)
    {
        nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    }
    else
    {
        nsCode = [_tztTradeView GetEidtorText:kTagCode];
    }
    if (nsCode == NULL || [nsCode length] < 1)
        return;
    
    //委托加个
    NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
    if (nsPrice == NULL || [nsPrice length] < 1 || [nsPrice floatValue] <= 0.0000001f)
    {
        [self showMessageBox:@"委托价格输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* nsAmount = [_tztTradeView GetEidtorText:kTagCount];
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
    [pDict setTztValue:nsPrice forKey:@"Price"];
    [pDict setTztValue:nsAmount forKey:@"Volume"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    switch (_nMsgType) 
    {
        case WT_RZRQBUY:
        case MENU_JY_RZRQ_PTBuy:
            [pDict setTztValue:@"1" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQSALE:
        case MENU_JY_RZRQ_PTSell:
            [pDict setTztValue:@"2" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQRZBUY:
        case MENU_JY_RZRQ_XYBuy:
            [pDict setTztValue:@"3" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQRQSALE:
        case MENU_JY_RZRQ_XYSell:
            [pDict setTztValue:@"4" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQBUYRETURN:
        case MENU_JY_RZRQ_BuyReturn:
            [pDict setTztValue:@"5" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQSALERETURN:
        case MENU_JY_RZRQ_SellReturn:
            [pDict setTztValue:@"6" forKey:@"CREDITTYPE"];
            break;
        default:
            break;
    }
    
    if (_bBuyFlag)
    {
        [pDict setTztValue:@"B" forKey:@"Direction"];
    }
    else
        [pDict setTztValue:@"S" forKey:@"Direction"];
    
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    
    if (_nMsgType == WT_RZRQFUNDRETURN || _nMsgType == MENU_JY_RZRQ_ReturnFunds) //直接还款确定
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"422" withDictValue:pDict];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"400" withDictValue:pDict];
    }
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
                if ([_tztTradeView CheckInput])
                {
                    [self goBuySell];
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
                [self OnSendBuySell];
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
    [self OnButton:sender];
}

-(void)OnButton:(id)sender
{
    if (sender == NULL)
        return;
    
	UIButton * pButton = (UIButton*)sender;
	NSInteger nTag = pButton.tag;
    if ([pButton isKindOfClass:[tztUIButton class]])
    {
        nTag = [((tztUIButton*)pButton).tzttagcode intValue];
    }
    
    NSString* nsString = [pButton titleForState:UIControlStateNormal];
    
    if (nTag == kTagNewCount)//约卖，约买数量点击
    {
        if (_tztTradeView)
        {
            [_tztTradeView setEditorText:nsString nsPlaceholder_:NULL withTag_:2002];
        }
    }
    else if(nTag >= 5002 && nTag <= 5013)
    {
        //价格点击
        //价格输入框，填充数据
        [_tztTradeView setEditorText:nsString nsPlaceholder_:NULL withTag_:2001];
    }
    else if(nTag >= 5014 && nTag <= 5023)
    {
        //量点击
    }
    else if(nTag == 8001 || nTag == 8000)//价格增加
    {
        NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
        //获取当前价格
        NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
        
        float fPrice = [nsPrice floatValue];
        if (nTag == 8001)
            fPrice += _fMoveStep;
        else if(nTag == 8000)
            fPrice -= _fMoveStep;
        if (fPrice < _fMoveStep)
            fPrice = 0.0;
        
        nsPrice = [NSString stringWithFormat:strPriceformat, fPrice];
        [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:kTagPrice];
        
        if (_bBuyFlag)
        {
            if (nsPrice && [nsPrice length] > 0 && [nsPrice floatValue] >= _fMoveStep)
            {
                [self OnRefresh];
            }
        }
        
        NSString* strAmount = [_tztTradeView GetEidtorText:kTagCount];
        NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
        NSString* strMoney = @"";
        if ([strAmount intValue] > 0 && [nsPrice floatValue] >= _fMoveStep)
        {
            strMoney = [NSString stringWithFormat:strMoneyformat, [nsPrice floatValue] * [strAmount intValue]];
        }
        [_tztTradeView setLabelText:strMoney withTag_:2020];
    }
    else if(nTag == 9001 || nTag == 9000)//数量增加
    {
        NSString* nsAmount = [_tztTradeView GetEidtorText:kTagCount];
        int nAmount = [nsAmount intValue];
        
        if (nTag == 9001)
        {
            nAmount += 100; // 买卖都加100 byDBQ20130729
        }
        if (nTag == 9000)
        {
            nAmount -= 100; // 买卖都减100 byDBQ20130729
            
            if (nAmount <= 0)
                nAmount = 0;
        }
        nsAmount = [NSString stringWithFormat:@"%d", nAmount];
        [_tztTradeView setEditorText:nsAmount nsPlaceholder_:NULL withTag_:kTagCount];
        
        
        NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
        NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
        NSString* strPrice =  [_tztTradeView GetEidtorText:kTagPrice];
        NSString* nsPrice = [NSString stringWithFormat:strPriceformat, [strPrice floatValue]];
        
        NSString* strMoney = @"";
        if ([nsAmount intValue] > 0 && [nsPrice floatValue] >= _fMoveStep)
        {
            strMoney = [NSString stringWithFormat:strMoneyformat, [nsPrice floatValue] * [nsAmount intValue]];
        }
        [_tztTradeView setLabelText:strMoney withTag_:2020];
    }
    else if (nTag == 5030 || nTag == 10000)
    {
        if (_tztTradeView)
        {
            if ([_tztTradeView CheckInput])
            {
                [self goBuySell];
            }
        }
    }
    else if (nTag == 10001) // 如有按钮会响应 byDBQ20131010
    {
        [self OnRefresh];
    }
    else if (nTag == 10002)
    {
        [self ClearData];
    }
}

//选中list
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagStockCode)
    {
        [self OnSendRequestData];
    }
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTagStockCode)
    {
        _nCurrentSel = index;
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            
            //设置股票代码
            [_tztTradeView setComBoxText:strCode withTag_:kTagStockCode];
            
            self.CurStockCode = [NSString stringWithFormat:@"%@", strCode];
            [self OnRefresh];
        }
    }
}

/*
 查询持仓信息
 */
-(void)OnSendRequestData
{
    NSString* strAction = @"";
    switch (_nMsgType)
    {
        case WT_RZRQSALE://普通卖出
        case MENU_JY_RZRQ_PTSell:
        {
            strAction = @"403";
        }
            break;
        case WT_RZRQRQSALE://融券卖出
        case MENU_JY_RZRQ_XYSell:
        {
            strAction = @"416";
        }
            break;
        case WT_RZRQSALERETURN://买券还款
        case MENU_JY_RZRQ_SellReturn:
        {
            strAction = @"403";
        }
            break;
        case WT_RZRQBUYRETURN:
        case MENU_JY_RZRQ_BuyReturn:
        {
            strAction = @"408";
        }
        default:
            break;
    }
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    
    if (_nMsgType == WT_RZRQBUYRETURN || _nMsgType == MENU_JY_RZRQ_BuyReturn)
    {
        tztNewReqno * reqno = [tztNewReqno reqnoWithString:strReqno];
        [reqno setReqdefOne:(int)_nMsgType];
        strReqno = [reqno getReqnoValue];
    }
    
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
    [pDict setTztObject:@"" forKey:@"Stockcode"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
}

@end
