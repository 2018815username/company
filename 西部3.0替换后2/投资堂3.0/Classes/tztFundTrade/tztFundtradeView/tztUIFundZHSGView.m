/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合申购view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundZHSGView.h"

@implementation tztUIFundZHSGView
@synthesize tztTradeTable = _tztTradeTable;
@synthesize pAyData = _pAyData;
@synthesize nCurrentIndex = _nCurrentIndex;
@synthesize bShowAll = _bShowAll;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _bShowAll = TRUE;
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
}

-(void)ClearData
{
    
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
        if (_nMsgType == WT_JJZHSGFUND)
        {
            if (_bShowAll)
                [_tztTradeTable setTableConfig:@"tztUITradeFundZHSG"];
            else
                [_tztTradeTable setTableConfig:@"tztUITradeFundZHSGEx"];
        }
        else if(_nMsgType == WT_JJZHInfo)
        {
            if (_bShowAll)
                [_tztTradeTable setTableConfig:@"tztUITradeFundZHInfo"];
            else
                [_tztTradeTable setTableConfig:@"tztUITradeFundZHInfoEx"];
        }
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
}

//请求数据
-(void)OnRefresh
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"2" forKey:@"p_type"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"25024" withDictValue:pDict];
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

//批量查询基金开户信息
-(void)OnQueryOpenAccount:(NSArray*)ayData
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strFundCode = @"";
    for (int i = 0; i < [ayData count]; i++)
    {
        NSMutableDictionary* pDict = [ayData objectAtIndex:i];
        if (pDict == NULL)
            continue;
        
        NSString* strCode = [pDict tztObjectForKey:@"tztCode"];
        strCode = [NSString stringWithFormat:@"%@;", strCode];
        
        strFundCode = [NSString stringWithFormat:@"%@%@", strFundCode, strCode];
    }
    [pDict setTztObject:strFundCode forKey:@"CommBatchEntrustInfo"];
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"620" withDictValue:pDict];
    
    DelObject(pDict);
    
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse* pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    int nErrNO = [pParse GetErrorNo];
    NSString* strErrMsg = [pParse GetErrorMessage];
    if ([tztBaseTradeView IsExitError:nErrNO])
    {
        [self OnNeedLoginOut];
        if (strErrMsg)
            tztAfxMessageBox(strErrMsg);
        return 0;
    }
    
    if (nErrNO < 0)
    {
        if (strErrMsg)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        return 0;
    }
    
    if ([pParse IsAction:@"25024"])
    {
        _nGroupCodeIndex = -1;
        _nGroupNameIndex = -1;
        _nGroupStockIndex = -1;
        _nGroupTypeIndex = -1;
        _nInitDateIndex = -1;
        _nLatestIndex = -1;
        _nProductIndex = -1;
        _nRiskWarningIndex = -1;
        _nUpdateDateIndex = -1;
        _nAmountIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"ProductIndex"];
        TZTStringToIndex(strIndex, _nProductIndex);
        
        strIndex = [pParse GetByName:@"GroupCodeIndex"];
        TZTStringToIndex(strIndex, _nGroupCodeIndex);
        
        strIndex = [pParse GetByName:@"GroupNameIndex"];
        TZTStringToIndex(strIndex, _nGroupNameIndex);
        
        strIndex = [pParse GetByName:@"GroupStockIndex"];
        TZTStringToIndex(strIndex, _nGroupStockIndex);
        
        strIndex = [pParse GetByName:@"LatestIndex"];
        TZTStringToIndex(strIndex, _nLatestIndex);
        
        strIndex = [pParse GetByName:@"GroupTypeIndex"];
        TZTStringToIndex(strIndex, _nGroupTypeIndex);
        
        strIndex = [pParse GetByName:@"InitDateIndex"];
        TZTStringToIndex(strIndex, _nInitDateIndex);
        
        strIndex = [pParse GetByName:@"UpdateDateIndex"];
        TZTStringToIndex(strIndex, _nUpdateDateIndex);
        
        strIndex = [pParse GetByName:@"RiskWarningIndex"];
        TZTStringToIndex(strIndex, _nRiskWarningIndex);
        
        strIndex = [pParse GetByName:@"AmountIndex"];
        TZTStringToIndex(strIndex, _nAmountIndex);
        
        NSArray* pGridAy = [pParse GetArrayByName:@"Grid"];
        
        if (_pAyData == NULL)
            _pAyData = NewObject(NSMutableArray);
        [_pAyData removeAllObjects];
        
        if (_nGroupNameIndex < 0)
            return 0;
        NSMutableArray* pAyTitle = NewObject(NSMutableArray);
        for (int i = 1; i < [pGridAy count]; i++)
        {
            NSArray *pAy = [pGridAy objectAtIndex:i];
            if (pAy == NULL)
                continue;
            NSInteger nCount = [pAy count];
            if (_nGroupNameIndex >= nCount)
                continue;
            
            NSString* strTitle = [pAy objectAtIndex:_nGroupNameIndex];
            if (strTitle == NULL)
                continue;
            
            [pAyTitle addObject:strTitle];
            [_pAyData addObject:pAy];
        }
        
        if (_tztTradeTable)
        {
            if (_nCurrentIndex < 0 || _nCurrentIndex >= [pAyTitle count])
                _nCurrentIndex = 0;
            if (_bShowAll)
            {
                [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentIndex withTag_:1000];
            }
            [self SetSelectData:_nCurrentIndex];
            
        }
        DelObject(pAyTitle);
    }
    if ([pParse IsAction:@"132"])
    {
        NSArray * pGridAy = [pParse GetArrayByName:@"Grid"];
        if (pGridAy == NULL || [pGridAy count] < 2)//1 是标题
            return 0;
        int nUsableIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"usableindex"];
        TZTStringToIndex(strIndex, nUsableIndex);
        
        if (nUsableIndex < 0)
            return 0;
        
        int nCurrencyIndex = -1;
        strIndex = [pParse GetByName:@"currencyindex"];
        TZTStringToIndex(strIndex, nCurrencyIndex);
        
        if (nCurrencyIndex < 0)
            return 0;
        for (int i = 0; i < [pGridAy count]; i++)
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
                [_tztTradeTable setLabelText:strMoney withTag_:2000];
                return 0;
            }
        }
    }
    //判断开户信息
    if ([pParse IsAction:@"620"])
    {
        NSArray *pAy = [pParse GetArrayByName:@"Grid"];
        //先判断是否已经开户，没开户，则显示开户界面；
        NSArray* ayCode = NULL;
        if (_pAyData && _nCurrentIndex >= 0 && _nCurrentIndex < [_pAyData count])
        {
            NSArray *pAy = [_pAyData objectAtIndex:_nCurrentIndex];
            if (pAy && _nGroupStockIndex >= 0 && _nGroupStockIndex < [pAy count])
                ayCode = [self GetFundCode:[pAy objectAtIndex:_nGroupStockIndex]];
        }
        if ([pAy count] <= 0)//已经全部开户了，直接跳转到委托界面
        {
            [TZTUIBaseVCMsg OnMsg:WT_JJZHSGCreate wParam:(NSUInteger)ayCode lParam:1];
        }
        else
        {
            [TZTUIBaseVCMsg OnMsg:WT_JJZHSGCreate wParam:(NSUInteger)ayCode lParam:2];
        }
    }
    return 1;
}

//选中列表数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == 1000)
    {
        _nCurrentIndex = index;
        [self SetSelectData:index];
    }
}

-(void)SetSelectData:(NSInteger)nIndex
{
    if (_pAyData == NULL || [_pAyData count] <= nIndex)
        return;
    
    if (_tztTradeTable == NULL)
        return;
    
    NSArray *pAy = [_pAyData objectAtIndex:nIndex];
    
    if (!_bShowAll)
    {
        if (_nGroupNameIndex < 0 || _nGroupNameIndex >= [pAy count])
            return;
        NSString* strName = [pAy objectAtIndex:_nGroupNameIndex];
        if (strName == NULL)
            strName = @"";
        [_tztTradeTable setEditorText:strName nsPlaceholder_:NULL withTag_:1000];
    }
    if (_nAmountIndex < 0 || _nAmountIndex >= [pAy count])
        return;
    
    NSString* str = [pAy objectAtIndex:_nAmountIndex];
    if (str == NULL)
        str = @"";
    [_tztTradeTable setLabelText:str withTag_:3000];
    //请求可用资金
    [self OnQueryFund];
}


-(NSMutableArray*)GetFundCode:(NSString*)strData
{
    NSMutableArray* ayReturn =  NewObjectAutoD(NSMutableArray);
    if (strData == NULL || [strData length] < 1)
        return ayReturn;
    
    NSArray* ayData = [strData componentsSeparatedByString:@","];
    for (int i = 0; i < [ayData count]; i++)
    {
        NSString* str = [ayData objectAtIndex:i];
        if (str == NULL || str.length < 1)
            continue;
        
        NSArray *pAy = [str componentsSeparatedByString:@"&"];
        if (pAy == NULL || [pAy count] < 3)
            continue;
        
        NSString* strCode = [pAy objectAtIndex:1];
        NSString* strQZ = [pAy objectAtIndex:2];
        
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        [pDict setTztObject:strCode forKey:@"tztCode"];
        [pDict setTztObject:strQZ forKey:@"tztQZ"];
        [ayReturn addObject:pDict];
        DelObject(pDict);
    }
    return ayReturn;
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case 4000://组合查询
        {
            NSArray* ayCode = NULL;
            if (_pAyData && _nCurrentIndex >= 0 && _nCurrentIndex < [_pAyData count])
            {
                NSArray *pAy = [_pAyData objectAtIndex:_nCurrentIndex];
                if (pAy && _nGroupStockIndex >= 0 && _nGroupStockIndex < [pAy count])
                    ayCode = [self GetFundCode:[pAy objectAtIndex:_nGroupStockIndex]];
            }
            
            NSString* strName = @"";
            if (_bShowAll)
            {
                 strName = [_tztTradeTable getComBoxText:1000];
            }
            else
            {
                strName = [_tztTradeTable GetEidtorText:1000];
            }
            if (strName == NULL)
                strName = @"";
            
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            if (ayCode)
                [pDict setTztObject:ayCode forKey:@"tztStockList"];
            [pDict setTztObject:strName forKey:@"tztGroupName"];
            [TZTUIBaseVCMsg OnMsg:WT_JJZHSGSearch wParam:(NSUInteger)pDict lParam:0];
            DelObject(pDict);
        }
            break;
        case 5000://生成清单
        {
            //先判断是否已经开户，没开户，则显示开户界面；
            NSArray* ayCode = NULL;
            if (_pAyData && _nCurrentIndex >= 0 && _nCurrentIndex < [_pAyData count])
            {
                NSArray *pAy = [_pAyData objectAtIndex:_nCurrentIndex];
                if (pAy && _nGroupStockIndex >= 0 && _nGroupStockIndex < [pAy count])
                    ayCode = [self GetFundCode:[pAy objectAtIndex:_nGroupStockIndex]];
            }
            NSString* strValue = [_tztTradeTable GetEidtorText:6000];
            if (strValue == NULL || strValue.length < 1 || [strValue floatValue] < 0.01)
            {
                [self showMessageBox:@"申购金额输入不正确!" nType_:TZTBoxTypeNoButton nTag_:0];
                return;
            }
            NSString* strMinValue = [_tztTradeTable GetLabelText:3000];
            if ([strValue floatValue] < [strMinValue floatValue])
            {
                [self showMessageBox:@"申购金额不能低于最小金额!" nType_:TZTBoxTypeNoButton nTag_:0];
                return;
            }
            NSString* strName = @"";
            if (_bShowAll)
            {
                 strName = [_tztTradeTable getComBoxText:1000];
            }
            else
            {
                strName = [_tztTradeTable GetEidtorText:1000];
            }
            if (strName == NULL)
                strName = @"";
            
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            if (ayCode)
                [pDict setTztObject:ayCode forKey:@"tztStockList"];
            [pDict setTztObject:strValue forKey:@"tztVolume"];
            [pDict setTztObject:strName forKey:@"tztGroupName"];
            [TZTUIBaseVCMsg OnMsg:WT_JJZHSGCreate wParam:(NSUInteger)pDict lParam:0];
            DelObject(pDict);
        }
            break;
            
        default:
            break;
    }
}

@end
