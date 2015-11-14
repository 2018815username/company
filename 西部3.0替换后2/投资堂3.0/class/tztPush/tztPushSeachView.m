//
//  tztPushSeachView.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-3-7.
//
//

#import "tztPushSeachView.h"

@interface tztPushSeachView()
{
    int     _nMaxPrice;
    int     _nMinPrice;
}

@end


@implementation tztPushSeachView

- (void)initdata
{
    [super initdata];
    _nMaxPrice = -1;
    _nMinPrice = -1;
}

-(NSString*)GetReqAction:(NSInteger)nMsgID
{
    switch (_nMsgType) {
        case MENU_SYS_UserWarningList:
            _reqAction = @"20271";
            break;
        default:
            break;
    }
    
    return _reqAction;
}

-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
    switch (self.nMsgType)
    {
        case MENU_SYS_UserWarningList:
        {
            NSString* strUniqueId = [tztKeyChain load:tztUniqueID];
            if (strUniqueId)
            {
                [pDict setTztObject:strUniqueId forKey:@"uniqueid"];
                [pDict setTztObject:strUniqueId forKey:@"MobileCode"];
                [pDict setTztObject:strUniqueId forKey:@"Mobile_tel"];
            }
        }
            break;
        default:
            break;
    }
}

-(void)DealIndexData:(tztNewMSParse*)pParse
{
    if (pParse == NULL)
        return;
    NSString *strIndex = [pParse GetByName:@"INDEX_P1"];
    TZTStringToIndex(strIndex, _nStockCodeIndex);
    
    strIndex = [pParse GetByName:@"Index_p6"];
    TZTStringToIndex(strIndex, _nStockNameIndex);
    
    strIndex = [pParse GetByName:@"Index_ID"];
    TZTStringToIndex(strIndex, _nContactIndex);
    
    strIndex = [pParse GetByName:@"Index_p2"];
    TZTStringToIndex(strIndex, _nMaxPrice);
    
    strIndex = [pParse GetByName:@"Index_p3"];
    TZTStringToIndex(strIndex, _nMinPrice);
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    NSInteger nTag = 0;
    if (sender)
    {
        if ([sender isKindOfClass:[tztUIButton class]])
            nTag = [[(tztUIButton*)sender tzttagcode] intValue];
        else if ([sender isKindOfClass:[UIButton class]])
            nTag = ((UIButton*)sender).tag;
    }
    
    switch (nTag) {
        case 4000://修改
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count]
                || _nStockNameIndex < 0 || _nStockNameIndex >= [pAy count])
                return TRUE;//标识已经处理过了
            
            NSString* strCode = @"";
            TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            tztStockInfo *pStock = NewObject(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            if (_nStockNameIndex >= 0 && _nStockNameIndex < [pAy count])
            {
                pGridData = [pAy objectAtIndex:_nStockNameIndex];
                if (pGridData && pGridData.text)
                {
                    pStock.stockName = [NSString stringWithFormat:@"%@", pGridData.text];
                }
            }
            NSString* strOrderId = @"";
            if (_nContactIndex >= 0 && _nContactIndex < [pAy count])
            {
                pGridData = [pAy objectAtIndex:_nContactIndex];
                if (pGridData && pGridData.text)
                {
                    strOrderId = [NSString stringWithFormat:@"%@", pGridData.text];
                }
            }
            NSString *nsMaxPrice = @"";
            if (_nMaxPrice >= 0 && _nMaxPrice < [pAy count])
            {
                pGridData = [pAy objectAtIndex:_nMaxPrice];
                if (pGridData && pGridData.text)
                {
                    nsMaxPrice = [NSString stringWithFormat:@"%@", pGridData.text];
                }
            }
            NSString* nsMinPrice = @"";
            if (_nMinPrice >= 0 && _nMinPrice < [pAy count])
            {
                pGridData = [pAy objectAtIndex:_nMinPrice];
                if (pGridData && pGridData.text)
                {
                    nsMinPrice = [NSString stringWithFormat:@"%@", pGridData.text];
                }
            }
            
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:pStock forKey:@"tztStockInfo"];
            [pDict setTztObject:strOrderId forKey:@"tztOrderID"];
            [pDict setTztObject:nsMaxPrice forKey:@"tztMaxPrice"];
            [pDict setTztObject:nsMinPrice forKey:@"tztMinPrice"];
            
            //获取当前的股票代码传递过去
            [TZTUIBaseVCMsg OnMsg:MENU_SYS_UserWarning wParam:(NSUInteger)pDict lParam:0];
            [pStock release];
            [pDict release];
            return TRUE;
        }
            break;
        case 4001://删除
        {
            
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count]
                || _nContactIndex < 0 || _nContactIndex >= [pAy count])
                return TRUE;//标识已经处理过了
            
            NSString* strCode = @"";
            TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
            if (pGridData && pGridData.text)
                strCode = pGridData.text;
            
            NSString* strID = @"";
            pGridData = [pAy objectAtIndex:_nContactIndex];
            if (pGridData && pGridData.text)
                strID = pGridData.text;
            
            if (strCode.length < 1 || strID.length < 1)
                return TRUE;
            
            tztAfxMessageBlock(@"确定删除该预警信息?", nil, nil, TZTBoxTypeButtonBoth, ^(NSInteger buttonIndex)
                               {
                                   if (buttonIndex == 0)
                                   {
                                       NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
                                       _ntztReqNo++;
                                       if (_ntztReqNo >= UINT16_MAX)
                                           _ntztReqNo = 1;
                                       NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
                                       [pDict setTztValue:strReq forKey:@"Reqno"];
                                       [pDict setTztObject:@"2" forKey:@"op_type"];
                                       [pDict setTztObject:strID forKey:@"order_id"];
                                       [pDict setTztObject:strCode forKey:@"param1"];
                                       
                                       [[tztMoblieStockComm getShareInstance] onSendDataAction:@"20270" withDictValue:pDict];
                                       DelObject(pDict);
                                   }
                               });
        }
            break;
        default:
            break;
    }
    return FALSE;
}


@end
