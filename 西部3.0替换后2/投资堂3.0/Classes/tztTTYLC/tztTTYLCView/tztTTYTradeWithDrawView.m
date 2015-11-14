/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztTTYTradeWithDrawView
 * 文件标识:
 * 摘要说明:		天天盈撤单界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTTYTradeWithDrawView.h"

@implementation tztTTYTradeWithDrawView
@synthesize nsSerialNoIndex = _nsSerialNoIndex;
@synthesize nsInitDateIndex = _nsInitDateIndex;
@synthesize nsJJGSDM = _nsJJGSDM;
@synthesize nsJJDMIndex = _nsJJDMIndex;

-(NSString*)GetReqAction:(int)nMsgID
{
    switch (nMsgID)
    {
        case WT_TTYYYCD://天天盈预约撤单查询
            _reqAction = @"536";
            break;
        case WT_CrashZZYYCDEX://预约取款撤单查询
            _reqAction = @"536";
            break;
        default:
            break;
    }
    return _reqAction;
}

//
-(void)DealIndexData:(tztNewMSParse *)pParse
{
    if (pParse == NULL)
        return;
    //获取合同号
    NSString* strIndex = [pParse GetByName:@"ContactIndex"];
    TZTStringToIndex(strIndex,_nContactIDIndex);
    //发生日期
    strIndex = [pParse GetByName:@"InitDateIndex"];
    TZTStringToIndex(strIndex,_nInitDateIndex);
    //流水号
    strIndex = [pParse GetByName:@"SerialNoIndex"];
    TZTStringToIndex(strIndex,_nSerialNoIndex);
    //基金公司代码
    strIndex = [pParse GetByName:@"JJGSDM"];
    TZTStringToIndex(strIndex,_nJJGSDM);
    //基金代码
    strIndex = [pParse GetByName:@"JJDMIndex"];
    TZTStringToIndex(strIndex,_nJJDMIndex);
}

-(void)OnWithDraw
{
    //获取当前的选中行信息
    NSArray* pAy = [_pGridView tztGetCurrent];
    if (pAy == NULL || [pAy count] <= 0)
        return;
    
    if (_nSerialNoIndex < 0 || _nSerialNoIndex >= [pAy count])
        return;
    
    NSString* nsSerialNoIndex = @"";
    NSString* nsInitDataIndex = @"";
    TZTGridData* pGrid = [pAy objectAtIndex:_nSerialNoIndex];
    if (pGrid)
    {
        nsSerialNoIndex = pGrid.text;
        if (nsSerialNoIndex == NULL)
            nsSerialNoIndex = @"";
    }
    
    if (_nInitDateIndex < 0 || _nInitDateIndex >= [pAy count])
        return;
    TZTGridData* pData = [pAy objectAtIndex:_nInitDateIndex];
    
    if (pData)
    {
        nsInitDataIndex = pData.text;
        if (nsInitDataIndex == NULL)
            nsInitDataIndex = @"";
    }
    
    if (nsSerialNoIndex && nsInitDataIndex) 
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        
        NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        
        [pDict setTztValue:nsInitDataIndex forKey:@"INITDATE"];
        [pDict setTztValue:nsSerialNoIndex forKey:@"SERIALNO"];
        
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"537" withDictValue:pDict];
        [pDict release];

    }
    /*
    if (_nContactIDIndex < 0 || _nAccountIndex < 0 ||_nContactIDIndex >= [pAy count] || _nAccountIndex >= [pAy count])
        return;
    
    TZTGridData* pGrid = [pAy objectAtIndex:_nContactIDIndex];
    TZTGridData* pGridAccount = [pAy objectAtIndex:_nAccountIndex];
    if (pGrid && pGrid.text && pGridAccount)
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        
        NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        
        NSString* strContact = [NSString stringWithFormat:@",%@,%@;", pGridAccount.text, pGrid.text];
        [pDict setTztValue:strContact forKey:@"CommBatchEntrustInfo"];
        
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"537" withDictValue:pDict];
        [pDict release];
    }*/
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
            //撤单
        case TZTToolbar_Fuction_WithDraw:
        {
            //获取当前的选中行信息
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0)
                return TRUE;
            
//            if (_nContactIDIndex < 0 ||_nContactIDIndex >= [pAy count])
//                return TRUE;

            if (_nSerialNoIndex < 0 || _nSerialNoIndex >= [pAy count])
                return TRUE;
            
//            if (_nDrawIndex >= 0 && _nDrawIndex < [pAy count])
//            {
//                TZTGridData *pGrid = [pAy objectAtIndex:_nDrawIndex];
//                if (pGrid && [pGrid.text compare:tztCanWithDraw] != NSOrderedSame)
//                {
//                    [self showMessageBox:@"该委托不可撤!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"撤单提示"];
//                    return TRUE;
//                }
//            }
            
            //TZTGridData* pGrid = [pAy objectAtIndex:_nContactIDIndex];
            TZTGridData* pGrid = [pAy objectAtIndex:_nSerialNoIndex];
            if (pGrid && pGrid.text)
            {
                [self showMessageBox:@"确定要对该委托进行撤单处理么?" nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self withTitle_:@"撤单提示"];
                return TRUE;
            }
        }
            break;
            
        default:
            break;
    }
    
    return [super OnToolbarMenuClick:sender];
}
@end
