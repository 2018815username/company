/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合基金查询
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundZHSGSearchView.h"

@implementation tztUIFundZHSGSearchView
@synthesize ayFundCode = _ayFundCode;
@synthesize nOpenAccountFlag = _nOpenAccountFlag;
@synthesize pAyData = _pAyData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _nErrorNO = 1;
    }
    return self;
}

-(void)OnRequestData
{
    if (_nMsgType == WT_JJZHSGCreate)//先判断开户情况
    {
        if (_nOpenAccountFlag != 1)
        {
            _reqAction = @"620";
        }
        else
        {
            _reqAction = @"624";
        }
    }
    else if(_nMsgType == WT_JJZHSHFUND)
    {
        _reqAction = @"25024";
    }
    else
        _reqAction = @"624";
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:[NSString stringWithFormat:@"%ld",(long)_nMaxCount] forKey:@"MaxCount"];
    [pDict setTztValue:[NSString stringWithFormat:@"%ld",(long)_nStartIndex] forKey:@"StartPos"];
    
    if (self.ayFundCode)
    {
        NSArray* pAy = [(NSMutableDictionary *)self.ayFundCode tztObjectForKey:@"tztStockList"];
        NSString* strFundCode = @"";
        for (int i = 0; i < [pAy count]; i++)
        {
            NSMutableDictionary* pDict = [pAy objectAtIndex:i];
            if (pDict == NULL)
                continue;
            
            NSString* strCode = [pDict tztObjectForKey:@"tztCode"];
            strCode = [NSString stringWithFormat:@"%@;", strCode];
            
            strFundCode = [NSString stringWithFormat:@"%@%@", strFundCode, strCode];
        }
        
        [pDict setTztObject:strFundCode forKey:@"CommBatchEntrustInfo"];
    }
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReq forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:_reqAction withDictValue:pDict];
    DelObject(pDict);
}

-(void)OnDealOtherData:(tztNewMSParse*)pParse
{
    if (pParse == NULL)
        return;
    
    //判断开户情况
    if ([pParse IsAction:@"620"])
    {
        _nErrorNO = [pParse GetErrorNo];
//        NSArray *pAy = [pParse GetArrayByName:@"Grid"];
        if ([pParse GetErrorNo] == 0)//基金已经全部开户
        {
//            if (_delegate && [_delegate respondsToSelector:@selector(setOpenAccountFlag:)])
            {
                [_delegate tztperformSelector:@"setOpenAccountFlag:" withObject:(id)1];
//                [_delegate setOpenAccountFlag:1];
            }
            _nOpenAccountFlag = 1;
            [self OnRequestData];
        }
    }
    else if([pParse IsAction:@"622"] || [pParse IsAction:@"621"])
    {
        NSString* str = [pParse GetErrorMessage];
        if (str && [str length] > 0)//处理成功了，只有errormessage有提示信息
        {
            [self showMessageBox:str nType_:TZTBoxTypeNoButton nTag_:0];
            if ([pParse IsAction:@"621"])//开户成功，跳转处理
            {
//                if (_delegate && [_delegate respondsToSelector:@selector(setOpenAccountFlag:)])
                {
                    [_delegate tztperformSelector:@"setOpenAccountFlag:" withObject:(id)1];
//                    [_delegate setOpenAccountFlag:1];
                }
                _nOpenAccountFlag = 1;
                [self OnRequestData];
            }
            return;
        }
        
        //处理不成功，则在grid里，有每只基金的申购处理信息
        NSArray *pAy = [pParse GetArrayByName:@"Grid"];
        NSString* strInfo = @"";
        
        NSArray *pAyTitle = NULL;
        for (int i = 0; i < [pAy count]; i++)
        {
            if (i == 0)
            {
                pAyTitle = [pAy objectAtIndex:i];
                continue;
            }
            
            NSArray* pAyData = [pAy objectAtIndex:i];
            NSString* strTemp = @"";
            for (int j = 0; j < [pAyData count]; j++)
            {
                strTemp = [NSString stringWithFormat:@"%@%@:%@\r\n",strTemp, [pAyTitle objectAtIndex:j], [pAyData objectAtIndex:j]];
            }
            strInfo = [NSString stringWithFormat:@"%@%@", strInfo, strTemp];
        }
        [self showMessageBox:strInfo nType_:TZTBoxTypeButtonOK nTag_:0];
    }
    else if([pParse IsAction:@"624"])
    {
        _nErrorNO = [pParse GetErrorNo];
        //基础索引，所以放在此处
        NSString* strIndex = [pParse GetByName:@"JJDMINDEX"];
        TZTStringToIndex(strIndex, _nStockCodeIndex);
        
        if (_nStockCodeIndex < 0)
        {
            strIndex = [pParse GetByName:@"FundCodeIndex"];
            TZTStringToIndex(strIndex, _nStockCodeIndex);
        }
        //基金名称
        strIndex = [pParse GetByName:@"JJMCINDEX"];
        TZTStringToIndex(strIndex, _nStockNameIndex);
        //可撤标识
        strIndex = [pParse GetByName:@"DrawIndex"];
        TZTStringToIndex(strIndex, _nDrawIndex);
        //基金账号
        strIndex = [pParse GetByName:@"JJACCOUNTINDEX"];
        TZTStringToIndex(strIndex, _nAccountIndex);
        //公司代码
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, _nJJGSDM);
        //公司名称
        strIndex = [pParse GetByName:@"JJGSMC"];
        TZTStringToIndex(strIndex, _nJJGSMC);
        //日期
        strIndex = [pParse GetByName:@"DATEINDEX"];
        TZTStringToIndex(strIndex, _nDateIndex);
        if (_nDateIndex < 0)
        {
            strIndex = [pParse GetByName:@"ORDERDATEINDEX"];
            TZTStringToIndex(strIndex, _nDateIndex);
        }
        //合同号
        strIndex = [pParse GetByName:@"CONTACTINDEX"];
        TZTStringToIndex(strIndex, _nCONTACTINDEX);
        //当前设置
        strIndex = [pParse GetByName:@"CURRENTSET"];
        TZTStringToIndex(strIndex, _nCURRENTSET);
        
        strIndex = [pParse GetByName:@"SignIndex"];
        TZTStringToIndex(strIndex, _nSignIndex);
        
        strIndex = [pParse GetByName:@"SendSNIndex"];
        TZTStringToIndex(strIndex, _nSendSNIndex);
        
        strIndex = [pParse GetByName:@"SNoIndex"];
        TZTStringToIndex(strIndex, _nSNoIndex);
        //开始日期
        strIndex = [pParse GetByName:@"BeginDateIndex"];
        TZTStringToIndex(strIndex, _nBeginDateIndex);
        //结束日期
        strIndex = [pParse GetByName:@"EndDateIndex"];
        TZTStringToIndex(strIndex, _nEndDateIndex);
        //投资金额
        strIndex = [pParse GetByName:@"TZJEIndex"];
        TZTStringToIndex(strIndex, _nTZJEIndex);
        //投资用途
        strIndex = [pParse GetByName:@"TZYTIndex"];
        TZTStringToIndex(strIndex, _nTZYTIndex);
        //扣款周期
        strIndex = [pParse GetByName:@"KGZQIndex"];
        TZTStringToIndex(strIndex, _nKgzqIndex);
        //扣款日期
        strIndex = [pParse GetByName:@"KGRQIndex"];
        TZTStringToIndex(strIndex, _nKgrqIndex);
        
        //处理特殊索引，到各自的view中单独处理
        [self DealIndexData:pParse];
        
        NSMutableArray *ayGridData = NewObject(NSMutableArray);
        if(_nStartIndex == 0)
            [_aytitle removeAllObjects];
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        
        for (int i = 0; i < [ayGrid count]; i++)
        {
            //第0行标题
            if (i == 0 && _nStartIndex == 0)
            {
                NSArray* ayValue = [ayGrid objectAtIndex:i];
                for (int j = 0; j < [ayValue count]; j++)
                {
                    TZTGridDataTitle *obj = NewObject(TZTGridDataTitle);
                    NSString* str = [ayValue objectAtIndex:j];
                    obj.text = str;
                    obj.textColor = [UIColor whiteColor];
                    
                    [_aytitle addObject:obj];
                    [obj release];
                }
            }
            else
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                NSMutableArray *ayGridValue = NewObjectAutoD(NSMutableArray);
                if (_nMsgType == WT_WITHDRAW || _nMsgType == MENU_JY_PT_Withdraw)//委托撤单
                {
                    if (ayData && _nDrawIndex > 0 && [ayData count] > _nDrawIndex )
                    {
                        int nValue = [[ayData objectAtIndex:_nDrawIndex] intValue];
                        if (nValue <= 0)
                            continue;
                    }
                }
                
                for ( int k = 0; k < [ayData count]; k++)
                {
                    TZTGridData *GridData = NewObject(TZTGridData);
                    if (k == _nDrawIndex && _nMsgType != WT_JJWWCashProdAccInquire)
                    {
                        if([[ayData objectAtIndex:k] intValue])
                            GridData.text = tztCanWithDraw;
                        else
                            GridData.text = tztCannotWithDraw;
                    }
                    else
                        GridData.text = [ayData objectAtIndex:k];
                    GridData.textColor = [UIColor whiteColor];
                    [ayGridValue addObject:GridData];
                    DelObject(GridData);
                }
                [ayGridData addObject:ayGridValue];
            }
        }
        
        BOOL bTrue = YES;
        NSMutableArray* pAy = [(NSMutableDictionary *)self.ayFundCode tztObjectForKey:@"tztStockList"];
        if ([pAy count] != [ayGridData count])
            bTrue = FALSE;
        if (self.ayFundCode && [self.ayFundCode count] > 0 && bTrue)
        {
            TZTGridDataTitle *pGridTitle = NewObject(TZTGridDataTitle);
            pGridTitle.textColor = [UIColor whiteColor];
            pGridTitle.text = @"基金权重";
            [_aytitle addObject:pGridTitle];
            DelObject(pGridTitle);
            
            pGridTitle = NewObject(TZTGridDataTitle);
            pGridTitle.textColor = [UIColor whiteColor];
            pGridTitle.text = @"基金金额";
            [_aytitle addObject:pGridTitle];
            DelObject(pGridTitle);
            
           // NSMutableArray* pAy = [self.ayFundCode tztObjectForKey:@"tztStockList"];
            NSString* strVolume = [(NSMutableDictionary *)self.ayFundCode tztObjectForKey:@"tztVolume"];
            for (int i = 0; i < [pAy count]; i++)
            {
                NSMutableDictionary* pDict = [pAy objectAtIndex:i];
                if (pDict == NULL)
                    continue;
                NSString* strQZ = [pDict tztObjectForKey:@"tztQZ"];
                NSString* strMoney = [NSString stringWithFormat:@"%.2f", [strVolume floatValue] * [strQZ intValue] / 100.f];
                
                NSMutableArray *pDataAy = [ayGridData objectAtIndex:i];
                
                TZTGridData* pDataQZ = NewObject(TZTGridData);
                pDataQZ.textColor = [UIColor whiteColor];
                pDataQZ.text = [NSString stringWithFormat:@"%@", strQZ];
                [pDataAy addObject:pDataQZ];
                DelObject(pDataQZ);
                
                TZTGridData* pData = NewObject(TZTGridData);
                pData.textColor = [UIColor whiteColor];
                pData.text = [NSString stringWithFormat:@"%@", strMoney];
                [pDataAy addObject:pData];
                DelObject(pData);
            }
        }
        
        if(_pGridView)
        {
            NSString* strMaxCount = [pParse GetByName:@"MaxCount"];
            _valuecount = [strMaxCount intValue];
            NSInteger pagecount = _valuecount * 3 / _nMaxCount + ((_valuecount * 3) % _nMaxCount ? 1 : 0);
            _pGridView.nValueCount = _valuecount;
            _pGridView.nPageCount = pagecount;
            NSInteger startpos = _nStartIndex;
            if(startpos == 0)
                startpos = 1;
            _pGridView.nCurPage = startpos / (_nMaxCount / 3) + (startpos % (_nMaxCount/ 3) ? 1 : 0);
            _pGridView.indexStarPos = startpos;
            [_pGridView CreatePageData:ayGridData title:_aytitle type:_reqchange];
            _reqchange = 0;
        }
        [ayGridData release];
    }
}


-(void)OnZHSG
{
    if (self.ayFundCode == NULL || [self.ayFundCode count] <= 0 || _nErrorNO == 0)
        return;
    
    if (_pGridView == NULL || [_pGridView.ayGriddata count] < 1 )
        return;
    
    for (int i = 0; i < [_pGridView.ayGriddata count]; i++)
    {
        NSArray* ayData = [_pGridView.ayGriddata objectAtIndex:i];
        if (_nStockCodeIndex < 0 || [ayData count] <= 1 || [ayData count] <= _nStockCodeIndex)
            return;
    }
    
    NSMutableArray* pAy = [(NSMutableDictionary *)self.ayFundCode tztObjectForKey:@"tztStockList"];
    if (pAy == NULL || [pAy count] < 1)
        return;
    
    NSString* strVolume = [(NSMutableDictionary *)self.ayFundCode tztObjectForKey:@"tztVolume"];
    NSString* strFundCode = @"";
    for (int i = 0; i < [pAy count]; i++)
    {
        NSMutableDictionary* pDict = [pAy objectAtIndex:i];
        if (pDict == NULL)
            continue;
        
        NSString* strCode = [pDict tztObjectForKey:@"tztCode"];
        NSString* strQZ = [pDict tztObjectForKey:@"tztQZ"];
        NSString* strMoney = [NSString stringWithFormat:@"%.2f", [strVolume floatValue] * [strQZ intValue] / 100.f];
        strCode = [NSString stringWithFormat:@"%@,%@;", strCode,strMoney];
        strFundCode = [NSString stringWithFormat:@"%@%@", strFundCode, strCode];
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    [pDict setTztObject:strFundCode forKey:@"CommBatchEntrustInfo"];
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"622" withDictValue:pDict];
    
    DelObject(pDict);
    
}

-(void)OnOpenAccount
{
    if (_pGridView == NULL || [_pGridView.ayGriddata count] < 1 || _nErrorNO == 0)
        return;
    
    NSArray *pAyData = _pGridView.ayData;
    if (_nJJGSDM < 0)
        return;
    
    //得到基金公司代码
    NSString* strJJGSDM = @"";
    for (int i = 0; i < [pAyData count]; i++)
    {
        NSArray *pSubAy = [pAyData objectAtIndex:i];
        if (pSubAy == NULL || [pSubAy count] <= _nJJGSDM)
            continue;
        TZTGridData *pGridData = [pSubAy objectAtIndex:_nJJGSDM];
        if (pGridData && pGridData.text && [pGridData.text length] > 0)
        {
            strJJGSDM = [NSString stringWithFormat:@"%@;%@", strJJGSDM, pGridData.text];
        }
    }
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)_nMaxCount] forKey:@"MaxCount"];
    [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)_nStartIndex] forKey:@"StartPos"];
    
    if (strJJGSDM)
    {
        [pDict setTztObject:strJJGSDM forKey:@"Title"];
    }
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReq forKey:@"Reqno"];
    [pDict setTztObject:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsFundAccount forKey:@"FUNDACCOUNT"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"621" withDictValue:pDict];
    DelObject(pDict);
}
@end
