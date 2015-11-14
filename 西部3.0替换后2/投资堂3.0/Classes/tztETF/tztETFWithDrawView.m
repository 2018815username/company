/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        etf撤单
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztETFWithDrawView.h"

@implementation tztETFWithDrawView



- (NSString*) GetReqAction:(int)nMsgID
{
    switch (nMsgID)
    {
        case WT_ETFWithDraw:
        case MENU_JY_ETFWX_Withdraw:
        {
            _reqAction = @"522";
        }
            break;
            
        default:
            break;
    }
    return _reqAction;
}

-(void)OnDealOtherData:(tztNewMSParse*)pParse
{
    if (pParse == NULL)
        return;
    
    NSString* strErrMsg = [pParse GetErrorMessage];
    if ([pParse IsAction:@"521"])
    {
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
    }
}

-(void)DealIndexData:(tztNewMSParse *)pParse
{
    if (pParse == NULL)
        return;
    
    NSString* strIndex = nil;
    
    strIndex = [pParse GetByName:@"StockIndex"];
    TZTStringToIndex(strIndex, _nStockIndex);
    
    strIndex = [pParse GetByName:@"AccountIndex"];
    TZTStringToIndex(strIndex, _nAccountIndex);
    
    strIndex = [pParse GetByName:@"MarketIndex"];
    TZTStringToIndex(strIndex, _nAccountType);
    
    strIndex = [pParse GetByName:@"JJDMIndex"];
    TZTStringToIndex(strIndex, _nJJDMIndex);
    
    strIndex = [pParse GetByName:@"PriceIndex"];
    TZTStringToIndex(strIndex, _nPriceIndex);
    
    strIndex = [pParse GetByName:@"StockNumIndex"];
    TZTStringToIndex(strIndex, _nStockNumIndex);
}



-(BOOL)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_WithDraw:
        {
            [self OnWithDraw:FALSE];
            bDeal = TRUE;
        }
            break;
            
        default:
            break;
    }
    
    if (!bDeal)
        bDeal = [super OnToolbarMenuClick:sender];
    return bDeal;
}

-(void)OnWithDraw:(BOOL)bSend
{
    //获取当前的选中行信息
    NSArray* pAy = [_pGridView tztGetCurrent];
    NSInteger nMin = MIN(_nAccountType, MIN(_nPriceIndex, MIN(_nStockNumIndex, _nAccountIndex)));
    NSInteger nMax = MAX(_nAccountType, MAX(_nPriceIndex, MAX(_nStockNumIndex, _nAccountIndex)));
    if (pAy == NULL || [pAy count] <= 0 || nMin < 0 || nMax >= [pAy count])
    {
        TZTNSLog(@"%@", @"ETF委托撤单，索引错误！！！");
        return;
    }
    
    if (!bSend)
    {
        [self showMessageBox:@"您确定对所选委托进行撤单处理吗？" nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self];
        return;
    }
    else
    {
        NSString* nsFundCode = @"";
        NSString* nsStockCode = @"";
        NSString* nsWTAccountType= @"";
        NSString* nsWTAccount  = @"";
        NSString* nsVolume = @"";
        NSString* nsPrice = @"";
        
        TZTGridData *pGridData = [pAy objectAtIndex:_nJJDMIndex];
        if (pGridData && pGridData.text)
            nsFundCode = [NSString stringWithFormat:@"%@", pGridData.text];
        
        pGridData = [pAy objectAtIndex:_nStockIndex];
        if (pGridData && pGridData.text)
            nsStockCode = [NSString stringWithFormat:@"%@", pGridData.text];
        
        pGridData = [pAy objectAtIndex:_nAccountType];
        if (pGridData && pGridData.text)
            nsWTAccountType = [NSString stringWithFormat:@"%@", pGridData.text];
        
        pGridData = [pAy objectAtIndex:_nAccountIndex];
        if (pGridData && pGridData.text)
            nsWTAccount = [NSString stringWithFormat:@"%@", pGridData.text];
        
        pGridData = [pAy objectAtIndex:_nStockNumIndex];
        if (pGridData && pGridData.text)
            nsVolume = [NSString stringWithFormat:@"%@", pGridData.text];
        
        pGridData = [pAy objectAtIndex:_nPriceIndex];
        if (pGridData && pGridData.text)
            nsPrice = [NSString stringWithFormat:@"%@", pGridData.text];
        
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        [pDict setTztValue:@"S" forKey:@"Direction"];
        [pDict setTztValue:nsFundCode forKey:@"FundCode"];
        if (nsStockCode && nsStockCode.length == 6)
            [pDict setTztValue:nsStockCode forKey:@"StockCode"];
        [pDict setTztValue:nsWTAccountType forKey:@"WTACCOUNTTYPE"];
        [pDict setTztValue:nsWTAccount forKey:@"WTACCOUNT"];
        [pDict setTztValue:nsVolume forKey:@"Volume"];
        [pDict setTztValue:nsPrice forKey:@"Price"];
        
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"521" withDictValue:pDict];
        DelObject(pDict);
    }
}

- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnWithDraw:TRUE];
            }
                break;
        }
    }
}

// iPad确定框 byDBQ20130823
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnWithDraw:TRUE];
            }
                break;
                
            default:
                break;
        }
    }
}

@end
