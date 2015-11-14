/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金定投view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztUIFundDTKHView.h"

enum  {
	kTagCode = 1000,
    kTagName = 2000,
    KTagDTType = 3000,//扣款周期
    KTagZQ = 4000,      //扣款日期
    KTagBegin = 5000,
    KTagEnd = 6000,
    kTagLX = 7000,
    KTagTradesl = 8000,
    kTagUseable = 9000,
};
@interface tztUIFundDTKHView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
@end

@implementation tztUIFundDTKHView

@synthesize tztTradeTable = _tztTradeTable;
@synthesize ayZq = _ayZq;
@synthesize ayZqData = _ayZqData;
@synthesize nsCompanyCode = _nsCompanyCode;
@synthesize CurStockCode = _CurStockCode;
@synthesize pDefaultDataDict = _pDefaultDataDict;

-(id)init
{
    if (self = [super init])
    {
        _pDefaultDataDict = NewObject(NSMutableDictionary);
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayZq);
    DelObject(_ayZqData);
    DelObject(_pDefaultDataDict);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)) 
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    
    if (IS_TZTIPAD)
    {
        rcFrame.size.width = rcFrame.size.width / 5 * 3;
    }
    else
        rcFrame.size.height = rcFrame.size.height;
    
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        [_tztTradeTable setTableConfig:@"tztUITradeFundDTKH"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
    
//    if (_nMsgType == WT_JJDTModify)
//    {
        [_tztTradeTable setEditorEnable:FALSE withTag_:kTagCode];
//    }
//    else
//    {
//        [_tztTradeTable setEditorEnable:TRUE withTag_:kTagCode];
//    }
}

-(void)SetData:(NSMutableDictionary*)pDict
{
    
}

-(void)SetDefaultData
{
    if (_tztTradeTable == NULL)
        return;
    if (self.CurStockCode && [self.CurStockCode length] > 0)
    {
        [_tztTradeTable setEditorText:self.CurStockCode nsPlaceholder_:NULL withTag_:kTagCode];
        if ([self.CurStockCode length] == 6)
        {
            [self OnRefresh];
//            [[NumberKeyboard sharedKeyboard] hide];
        }
    }
    NSInteger nIndex = [_tztTradeTable getComBoxSelctedIndex:KTagDTType];
    if (nIndex < 0)
        nIndex = 0;
    
    if (_ayZqData == NULL)
        _ayZqData = NewObject(NSMutableArray);
    [_ayZqData removeAllObjects];
    if (nIndex == 0)//每月
    {
        for (int i = 0; i < 31; i++)
        {
            [_ayZqData addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    else//每周
    {
        for (int i = 0; i < 7; i++)
        {
            [_ayZqData addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    
    [_tztTradeTable setComBoxData:_ayZqData ayContent_:_ayZqData AndIndex_:0 withTag_:KTagZQ];
    UIView *pList = [_tztTradeTable getViewWithTag:KTagDTType];
    if (pList && [pList isKindOfClass:[tztUIDroplistView class]])
    {
        [((tztUIDroplistView*)pList) setSelectindex:nIndex];
    }
    
	//设置日期
    //获取当天日期
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:@"yyyyMMdd"];
    
    NSDate *beginDate = IS_TZTIOS(6) ?([[NSDate date] dateByAddingTimeInterval:0 * 24 * 60 * 60]) : ([[NSDate date] dateByAddingTimeInterval:(0 * 24 * 60 *60)]);
    NSDate *endDate = [[NSDate date] dateByAddingTimeInterval:( 1.0 * 24 * 60 *60)];
    
    UIView* pBegin = [_tztTradeTable getViewWithTag:KTagBegin];
    UIView* pEnd = [_tztTradeTable getViewWithTag:KTagEnd];
    
    if (pBegin && [pBegin isKindOfClass:[tztUIDroplistView class]])
    {
        [(tztUIDroplistView*)pBegin setText:[outputFormat stringFromDate:beginDate]];
    }
    
    if (pEnd && [pEnd isKindOfClass:[tztUIDroplistView class]])
    {
        [(tztUIDroplistView*)pEnd setText:[outputFormat stringFromDate:endDate]];
    }
    
    [outputFormat release];
    
//    tztUIDroplistView* pBeginlist = (tztUIDroplistView*)[_pBaseControls gettztUIBaseViewWithTag:[NSString stringWithFormat:@"%d",KTagBegin]];
//    tztUIDroplistView* pendlist = (tztUIDroplistView*)[_pBaseControls gettztUIBaseViewWithTag:[NSString stringWithFormat:@"%d",KTagEnd]];
//    pBeginlist.text = [outputFormat stringFromDate:beginDate];
//    pendlist.text = [outputFormat stringFromDate:endDate];
}

//选中列表数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == KTagDTType)
    {
        if (_ayZqData == NULL)
            _ayZqData = NewObject(NSMutableArray);
        [_ayZqData removeAllObjects];
        if (index == 0)//每月
        {
            for (int i = 0; i < 31; i++)
            {
                [_ayZqData addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
        }
        else//每周
        {
            for (int i = 0; i < 7; i++)
            {
                [_ayZqData addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
        }
        
        [_tztTradeTable setComBoxData:_ayZqData ayContent_:_ayZqData AndIndex_:0 withTag_:KTagZQ];
    }
}

//清空界面数据
-(void) ClearData
{   
//	tztUITextEdit *codetf = (tztUITextEdit *)[_pBaseControls gettztUIBaseViewWithTag:[NSString stringWithFormat:@"%d",kTagCode]];
//    
//    tztUILabel *labelname = (tztUILabel *)[_pBaseControls gettztUIBaseViewWithTag:[NSString stringWithFormat:@"%d",kTagName]];
//    
//    tztUIDroplistView* pDroplist = (tztUIDroplistView*)[_pBaseControls gettztUIBaseViewWithTag:[NSString stringWithFormat:@"%d",KTagZQ]];
//    _nZq = 0;
//    
//    tztUIDroplistView* pDroptypelist = (tztUIDroplistView*)[_pBaseControls gettztUIBaseViewWithTag:[NSString stringWithFormat:@"%d",KTagDTType]];
//    _nDTType = 0;
//    
//    tztUIDroplistView* plxlist = (tztUIDroplistView*)[_pBaseControls gettztUIBaseViewWithTag:[NSString stringWithFormat:@"%d",kTagLX]];
//    _nDTLX = 0;
//    
//    tztUITextEdit *tradetf = (tztUITextEdit *)[_pBaseControls gettztUIBaseViewWithTag:[NSString stringWithFormat:@"%d",KTagTradesl]];
//    
//    
//    [codetf setNewStringValue:@""];
//    [tradetf setNewStringValue:@""];
//    
//    labelname.text = @"";
//    
//    if (_ayZq == nil || [_ayZq count] < _nZq) 
//    {
//        pDroplist.text = @"";
//    }
//    else
//        pDroplist.text = [_ayZq objectAtIndex:_nZq];
//    pDroplist.selectindex = _nZq;
//    
//    if (_ayDTType == nil || [_ayDTType count] < _nZq) 
//    {
//        pDroptypelist.text = @"";
//    }
//    else
//        pDroptypelist.text = [_ayDTType objectAtIndex:_nDTType];
//    pDroptypelist.selectindex = _nDTType;
//    
//    if (_ayDTLX == nil || [_ayDTLX count] < _nDTLX) 
//    {
//        plxlist.text = @"";
//    }
//    else
//        plxlist.text = [_ayDTLX objectAtIndex:_nDTLX];
//    plxlist.selectindex = _nDTLX;
//    
//    self.CurStockCode = @"";
//    self.CurStockName = @"";
    
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
                //				[self ClearData];
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

//请求股票信息
-(void)OnRefresh
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    self.nsCompanyCode = @"";
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"FUNDCODE"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"616" withDictValue:pDict];
    
    DelObject(pDict);
}

-(void)OnQueryFund
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"132" withDictValue:pDict];
    
    DelObject(pDict);
}


-(void)OnSend
{
    if (_tztTradeTable == NULL)
        return;
    
    NSString *nsCode = [_tztTradeTable GetEidtorText:kTagCode];
    if (nsCode == NULL || [nsCode length] < 6)
    {
        [self showMessageBox:@"基金代码输入不正确，请重新输入!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSString* nsMoney = [_tztTradeTable GetEidtorText:KTagTradesl];
    if (nsMoney == NULL || [nsMoney length] <= 0 || [nsMoney floatValue] < 0.01f)
    {
        [self showMessageBox:@"金额输入不正确，请重新输入!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    NSInteger nZQ = [_tztTradeTable getComBoxSelctedIndex:KTagDTType];//扣款周期
    NSString* nsKKRQ = [_tztTradeTable getComBoxText:KTagZQ];//扣款日期
    if (nsKKRQ == NULL)
        nsKKRQ = @"";
    NSString* nsBegin = [_tztTradeTable getComBoxText:KTagBegin];
    if (nsBegin == NULL)
        nsBegin = @"";
    NSString* nsEnd = [_tztTradeTable getComBoxText:KTagEnd];
    if (nsEnd == NULL)
        nsEnd = @"";
    NSString* nsYT = [_tztTradeTable getComBoxText:kTagLX];
    if (nsYT == NULL)
        nsYT = @"";
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztObject:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsFundAccount forKey:@"FundAccount"];
    [pDict setTztObject:nsCode forKey:@"FundCode"];
    [pDict setTztObject:self.nsCompanyCode forKey:@"JJDJGSDM"];
    [pDict setTztObject:nsKKRQ forKey:@"SendDay"];
    [pDict setTztObject:nsBegin forKey:@"BeginDate"];
    [pDict setTztObject:nsEnd forKey:@"EndDate"];
    [pDict setTztObject:nsMoney forKey:@"Volume"];
    [pDict setTztObject:nsYT forKey:@"Title"];
    if (nZQ == 0)//每月
    {
        [pDict setTztObject:@"0" forKey:@"ACTIONMODE"];
    }
    else
    {
        [pDict setTztObject:@"3" forKey:@"ACTIONMODE"];
    }
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    if (_nMsgType == WT_JJDTModify)
    {
        NSString* strEntrustDate = [self.pDefaultDataDict tztObjectForKey:@"tztENTRUSTDATE"];
        if (strEntrustDate)
        {
            [pDict setTztObject:strEntrustDate forKey:@"ENTRUSTDATE"];
        }
        
        NSString* strSendSN = [self.pDefaultDataDict tztObjectForKey:@"tztSENDSN"];
        if (strSendSN)
        {
            [pDict setTztObject:strSendSN forKey:@"SENDSN"];
        }
        
        NSString* strSNO = [self.pDefaultDataDict tztObjectForKey:@"tztSNO"];
        if (strSNO)
        {
            [pDict setTztObject:strSNO forKey:@"SNO"];
        }
        
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"615" withDictValue:pDict];
    }
    else
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"551" withDictValue:pDict];
    
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
    
    if ([pParse IsAction:@"616"])
    {
        int nFundCodeIndex = -1;
        int nFundNameIndex = -1;
        int nFundComNameIndex = -1;
        int nFundComCodeIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"JJDMIndex"];
        TZTStringToIndex(strIndex, nFundCodeIndex);
        
        if (nFundCodeIndex < 0)
            return 0;
        strIndex = [pParse GetByName:@"JJMCIndex"];
        TZTStringToIndex(strIndex, nFundNameIndex);
        
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, nFundComCodeIndex);
        
        strIndex = [pParse GetByName:@"JJGSMC"];
        TZTStringToIndex(strIndex, nFundComNameIndex);
        
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        NSString* strFundCode = @"";
        NSString* strFundName = @"";
        NSString* strCompanyName = @"";
        for (NSInteger i = 1; i < [pGridAy count]; i++)
        {
            NSArray* pAy = [pGridAy objectAtIndex:i];
            if (pAy == NULL)
                continue;
            NSInteger nCount = [pAy count];
            if (nCount <= nFundCodeIndex)
                continue;
            strFundCode = [pAy objectAtIndex:nFundCodeIndex];
            
            if (nFundNameIndex >= 0 && nFundNameIndex < nCount)
                strFundName = [pAy objectAtIndex:nFundNameIndex];
            else
                strFundName = @"";
            
            if (nFundComCodeIndex >= 0 && nFundComCodeIndex < nCount)
                self.nsCompanyCode = [NSString stringWithFormat:@"%@",[pAy objectAtIndex:nFundComCodeIndex]];
            else
                self.nsCompanyCode = @"";
            
            if (nFundComNameIndex >= 0 && nFundComNameIndex < nCount)
                strCompanyName = [pAy objectAtIndex:nFundComNameIndex];
            else
                strCompanyName = @"";
        }
        
        if (_tztTradeTable)
        {
            //会导致死循环的
//            [_tztTradeTable setEditorText:strFundCode nsPlaceholder_:NULL withTag_:kTagCode];
            [_tztTradeTable setLabelText:strFundName withTag_:kTagName];
            [_tztTradeTable setLabelText:strCompanyName withTag_:kTagName+1];
            
            if (self.pDefaultDataDict)
            {
                //获取代码判断是否一致
                NSString* strCode = [self.pDefaultDataDict tztObjectForKey:@"tztJJDM"];
                if (strCode && [strCode compare:strFundCode] == NSOrderedSame)
                {
                    //扣款周期
                    NSString* strKKZQ = [self.pDefaultDataDict tztObjectForKey:@"tztKKZQ"];
                    if (strKKZQ)
                    {
                        UIView* pViewZQ = [_tztTradeTable getComBoxViewWith:KTagDTType];
                        if (pViewZQ && [pViewZQ isKindOfClass:[tztUIDroplistView class]])
                        {
                            if ([strKKZQ intValue] == 3)//每周
                            {
                                [(tztUIDroplistView*)pViewZQ setText:@"每周"];
                                [_ayZqData removeAllObjects];
                                for (int i = 0; i < 7; i++)
                                {
                                    [_ayZqData addObject:[NSString stringWithFormat:@"%d",i+1]];
                                }
                            }
                            else
                            {
                                [(tztUIDroplistView*)pViewZQ setText:@"每月"];
                                [_ayZqData removeAllObjects];
                                for (int i = 0; i < 31; i++)
                                {
                                    [_ayZqData addObject:[NSString stringWithFormat:@"%d",i+1]];
                                }
                            }
                        }
                    }
                    
                    
                    [_tztTradeTable setComBoxData:_ayZqData ayContent_:_ayZqData AndIndex_:0 withTag_:KTagZQ];
                    //扣款日期
                    NSString* strKKRQ = [self.pDefaultDataDict tztObjectForKey:@"tztKKRQ"];
                    if (strKKRQ)
                    {
                        UIView* pViewRQ = [_tztTradeTable getComBoxViewWith:KTagZQ];
                        if (pViewRQ && [pViewRQ isKindOfClass:[tztUIDroplistView class]])
                        {
                            [(tztUIDroplistView*)pViewRQ setText:strKKRQ];
                        }
                    }
                    //开始日期
                    NSString* strBeginDate = [self.pDefaultDataDict tztObjectForKey:@"tztBeginDate"];
                    if (strBeginDate == NULL || [strBeginDate length] <= 0)
                    {
                        //设置日期
                        //获取当天日期
                        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
                        [outputFormat setDateFormat:@"yyyyMMdd"];
                        NSDate *beginDate = [[NSDate date] dateByAddingTimeInterval:(0 * 24 * 60 *60)];
                        
                        strBeginDate = [NSString stringWithFormat:@"%@", [outputFormat stringFromDate:beginDate]];
                        [outputFormat release];
                    }
                    UIView* pBeginView = [_tztTradeTable getComBoxViewWith:KTagBegin];
                    if (pBeginView && [pBeginView isKindOfClass:[tztUIDroplistView class]])
                    {
                        [((tztUIDroplistView*)pBeginView) setText:strBeginDate];
                    }
                    //结束日期
                    NSString* strEndDate = [self.pDefaultDataDict tztObjectForKey:@"tztEndDate"];
                    if (strEndDate == NULL || [strEndDate length] <= 0)
                    {
                        //设置日期
                        //获取当天日期
                        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
                        [outputFormat setDateFormat:@"yyyyMMdd"];
                        NSDate *endDate = [[NSDate date] dateByAddingTimeInterval:( 1.0 * 24 * 60 *60)];
                        strEndDate = [NSString stringWithFormat:@"%@", [outputFormat stringFromDate:endDate]];
                        [outputFormat release];
                    }
                    UIView* pEndView = [_tztTradeTable getComBoxViewWith:KTagEnd];
                    if (pEndView && [pEndView isKindOfClass:[tztUIDroplistView class]])
                    {
                        [((tztUIDroplistView*)pEndView) setText:strEndDate];
                    }
                    
                    //投资用途
                    NSString* strTZYT = [self.pDefaultDataDict tztObjectForKey:@"tztTZYT"];
                    UIView* pTZYTView = [_tztTradeTable getComBoxViewWith:kTagLX];
                    if (strTZYT && [strTZYT length] > 0 && pTZYTView && [pTZYTView isKindOfClass:[tztUIDroplistView class]])
                    {
                        [((tztUIDroplistView*)pTZYTView) setText:strTZYT];
                    }
                    
                    //投资金额
                    NSString* strTZJE = [self.pDefaultDataDict tztObjectForKey:@"tztTZJE"];
                    [_tztTradeTable setEditorText:strTZJE nsPlaceholder_:NULL withTag_:KTagTradesl];
                }
            }
        }
        
        //查询可用资金
        [self OnQueryFund];
    }
    else if([pParse IsAction:@"132"])
    {
        NSArray * pGridAy = [pParse GetArrayByName:@"Grid"];
        if (pGridAy == NULL || [pGridAy count] < 2)//1 是标题
            return 0;
        NSInteger nUsableIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"usableindex"];
        TZTStringToIndex(strIndex, nUsableIndex);
        
        if (nUsableIndex < 0)
            return 0;
        
        NSInteger nCurrencyIndex = -1;
        strIndex = [pParse GetByName:@"currencyindex"];
        TZTStringToIndex(strIndex, nCurrencyIndex);
        
        if (nCurrencyIndex < 0)
            return 0;
        for (NSInteger i = 0; i < [pGridAy count]; i++)
        {
            NSArray *pAy = [pGridAy objectAtIndex:i];
            if (pAy == NULL)
                continue;
            NSInteger nCount = [pAy count];
            if (nUsableIndex >= nCount || nCurrencyIndex >= nCount)
                continue;
            NSString* strValue = [pAy objectAtIndex:nCurrencyIndex];
            if ([strValue compare:@"人民币"] == NSOrderedSame)
            {
                NSString* strMoney = [pAy objectAtIndex:nUsableIndex];
                if (strMoney == NULL)
                    strMoney = @"";
                [_tztTradeTable setLabelText:strMoney withTag_:kTagUseable];
                return 0;
            }
        }
    }
    else if([pParse IsAction:@"551"] || [pParse IsAction:@"615"])
    {
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        return 0;
    }
    
    return 1;
}

-(BOOL)CheckInput
{
    if (_tztTradeTable == NULL)
        return FALSE;
    
    NSString *nsCode = [_tztTradeTable GetEidtorText:kTagCode];
    if (nsCode == NULL || [nsCode length] < 6)
    {
        [self showMessageBox:@"基金代码输入不正确，请重新输入!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return FALSE;
    }
    
    NSString* nsMoney = [_tztTradeTable GetEidtorText:KTagTradesl];
    if (nsMoney == NULL || [nsMoney length] <= 0 || [nsMoney floatValue] < 0.01f)
    {
        [self showMessageBox:@"金额输入不正确，请重新输入!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return FALSE;
    }
    
    NSString* strInfo = @"";
    NSString* nsName = [_tztTradeTable GetLabelText:kTagName];
    NSString* nsCompany = [_tztTradeTable GetLabelText:kTagName+1];
    NSString* nsZQ = [_tztTradeTable getComBoxText:KTagDTType];//扣款周期
    NSString* nsKKRQ = [_tztTradeTable getComBoxText:KTagZQ];//扣款日期
    NSString* nsBegin = [_tztTradeTable getComBoxText:KTagBegin];
    NSString* nsEnd = [_tztTradeTable getComBoxText:KTagEnd];
//    NSString* nsYT = [_tztTradeTable getComBoxText:kTagLX];
    
    strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n基金公司:%@\r\n基金名称:%@\r\n扣款周期:%@\r\n扣款日期:%@\r\n开始日期:%@\r\n结束日期:%@\r\n定投金额:%@\r\n 确认定投？",nsCode, nsCompany,nsName,nsZQ,nsKKRQ,nsBegin,nsEnd,nsMoney];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"基金定投"
                   nsOK_:@"定投"
               nsCancel_:@"取消"];
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

-(void)OnButton:(id)sender
{
    
}


@end



