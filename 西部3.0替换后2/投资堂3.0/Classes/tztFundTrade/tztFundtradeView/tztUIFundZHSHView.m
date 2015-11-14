/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundZHSHView.h"

@implementation tztUIFundZHSHView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}
-(void)OnRequestData
{
    _reqAction = @"25024";
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)_nMaxCount] forKey:@"MaxCount"];
    [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)_nStartIndex] forKey:@"StartPos"];
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReq forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:_reqAction withDictValue:pDict];
    DelObject(pDict);
}

-(void)OnRequestFundList
{
    _reqAction = @"625";
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)_nMaxCount] forKey:@"MaxCount"];
    [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)_nStartIndex] forKey:@"StartPos"];
    
    if(self.ayFundCode)
    {
        NSString* strFundCode = @"";
        for (int i = 0; i < [self.ayFundCode count]; i++)
        {
            NSMutableDictionary* pDict = [(NSArray *)self.ayFundCode objectAtIndex:i];
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

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse* pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    
    if ([tztBaseTradeView IsExitError:[pParse GetErrorNo]])
    {
        [self OnNeedLoginOut];
        NSString* strErrMsg = [pParse GetErrorMessage];
        if (strErrMsg && [strErrMsg length] > 0)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeButtonOK nTag_:0];
        
        return 0;
    }
    
    
    if ([pParse IsAction:@"25024"])
    {
        if (_delegate && [_delegate respondsToSelector:@selector(OnSetViewData:)])
        {
            [_delegate OnSetViewData:pParse];
            
        }
        return 0;
    }
    else if([pParse IsAction:@"623"])
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        if (strErrMsg && [strErrMsg length] > 0)
        {
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeButtonOK nTag_:0];
            return 0;
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
        return 0;
    }
    
    return [super OnCommNotify:wParam lParam_:lParam];
}

-(void)DealIndexData:(tztNewMSParse*)pParse
{
    if (pParse == NULL)
        return;
    
    if ([pParse IsAction:@"625"])
    {
        _nStockCodeIndex = -1;
        _nKYIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"JJDMIndex"];
        TZTStringToIndex(strIndex, _nStockCodeIndex);
        
        strIndex = [pParse GetByName:@"KYIndex"];
        TZTStringToIndex(strIndex, _nKYIndex);
    }
}

-(void)OnZHSH
{
    NSString* strInfo = @"";
    if (_pGridView && _pGridView.ayData && _nStockCodeIndex >= 0 && _nKYIndex >= 0)
    {
        NSArray *pAy = _pGridView.ayData;
        for (int i = 0; i < [pAy count]; i++)
        {
            NSArray *pData = [pAy objectAtIndex:i];
            if (pData == NULL || [pData count] < 1)
                continue;
            if(_nStockCodeIndex >= [pData count] || _nKYIndex >= [pData count])
                continue;
            
            TZTGridData *pGridData = [pData objectAtIndex:_nStockCodeIndex];
            if (pGridData == NULL || pGridData.text == NULL || pGridData.text.length < 1)
                continue;
            strInfo = [NSString stringWithFormat:@"%@%@,",strInfo, pGridData.text];
            
            pGridData = [pData objectAtIndex:_nKYIndex];
            if (pGridData == NULL || pGridData.text == NULL || pGridData.text.length < 1)
            {
                strInfo = [NSString stringWithFormat:@"%@;", strInfo];
                continue;
            }
            strInfo = [NSString stringWithFormat:@"%@%@;",strInfo, pGridData.text];
        }
    }
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztObject:strInfo forKey:@"CommBatchEntrustInfo"];
    
    [pDict setTztObject:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsFundAccount forKey:@"FundAccount"];
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReq forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"623" withDictValue:pDict];
    DelObject(pDict);
}

- (void)OnRequestFundListEx:(NSString*)strGroupCode
{
    
}

-(void)OnDetail
{
    
}

@end
