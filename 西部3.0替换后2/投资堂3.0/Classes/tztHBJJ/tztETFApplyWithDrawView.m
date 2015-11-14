/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        货币基金(ETF)内部撤单
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:        
 *
 ***************************************************************/
#import "tztETFApplyWithDrawView.h"

@implementation tztETFApplyWithDrawView
@synthesize nContactIDIndex = _nContactIDIndex;


-(id)init
{
    if (self = [super init]) 
    {
        _nContactIDIndex = -1;
    }
//    [[tztMoblieStockComm getShareInstance] addObj:self];
    return self;
}

-(void)DealIndexData:(tztNewMSParse *)pParse
{
    if (pParse == NULL)
        return;
    //获取合同号
    NSString* strIndex = [pParse GetByName:@"ContactIndex"];
    TZTStringToIndex(strIndex, _nContactIDIndex);
    
    strIndex = [pParse GetByName:@"marketindex"];
    TZTStringToIndex(strIndex, _nMarketIndex);
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
            
//            if (_nDrawIndex < 0 || _nContactIDIndex < 0 || _nDrawIndex >= [pAy count] || _nContactIDIndex >= [pAy count])
//                return TRUE;
            
            if (_nContactIDIndex < 0 || _nContactIDIndex >= [pAy count])
                return TRUE;
            
//            TZTGridData *pGrid = [pAy objectAtIndex:_nDrawIndex];
//            if (pGrid && [pGrid.text compare:tztCanWithDraw] != NSOrderedSame)
//            {
//                [self showMessageBox:@"该委托不可撤!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"撤单提示"];
//                return TRUE;
//            }
            
            TZTGridData *pGrid = [pAy objectAtIndex:_nContactIDIndex];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnWithDraw];
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
                [self OnWithDraw];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)OnWithDraw
{
    //获取当前的选中行信息
    NSArray* pAy = [_pGridView tztGetCurrent];
    if (pAy == NULL || [pAy count] <= 0)
        return;
    
//    if (_nDrawIndex < 0 || _nContactIDIndex < 0 || _nAccountIndex < 0 || _nDrawIndex >= [pAy count] || _nContactIDIndex >= [pAy count] || _nAccountIndex >= [pAy count])
//        return;
    
    if (_nStockCodeIndex < 0|| _nStockCodeIndex >= [pAy count]|| _nContactIDIndex < 0 || _nMarketIndex < 0 || _nContactIDIndex >= [pAy count] || _nMarketIndex >= [pAy count])
        return;
    
    TZTGridData* pGrid = [pAy objectAtIndex:_nContactIDIndex];
    TZTGridData* pGridCode = [pAy objectAtIndex:_nStockCodeIndex];
    TZTGridData* pGridMarket = [pAy objectAtIndex:_nMarketIndex];
    if (pGrid && pGrid.text && pGridCode)
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX) 
            _ntztReqNo = 1;
        
        NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        
//        NSString* strContact = [NSString stringWithFormat:@",%@,%@;", pGridAccount.text, pGrid.text];
//        [pDict setTztValue:strContact forKey:@"CommBatchEntrustInfo"];
        if (pGrid)
        {
            [pDict setTztValue:pGrid.text forKey:@"ContactID"];
        }
        if (pGridCode)
        {
            [pDict setTztValue:pGridCode.text forKey:@"StockCode"];
        }
        if (pGridMarket)
        {
            [pDict setTztValue:pGridMarket.text forKey:@"WTACCOUNTTYPE"];
        }
        
        if (_pGridView.curIndexRow>=0 && (self.marketArray.count>_pGridView.curIndexRow)) {
            [pDict setTztValue:self.marketArray[_pGridView.curIndexRow] forKey:@"WTACCOUNTTYPE"];//
        }
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"640" withDictValue:pDict];
        [pDict release];
    }
}

//-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
//{
//    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
//    if (pParse == NULL)
//        return 0;
//    
//    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
//        return 0;
//    
//    NSString* strErrMsg = [pParse GetErrorMessage];
//    tztAfxMessageBox(strErrMsg);
//    if ([pParse GetErrorNo] < 0)
//    {
//        return 0;
//    }
//    
//    if ([pParse IsAction:@"640"])
//    {
//        [self OnRequestData];
//    }
//    return 1;
//}

@end
