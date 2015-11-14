/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztSBTradeSearchView
 * 文件标识:
 * 摘要说明:		股转系统查询界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztSBTradeSearchView.h"

@implementation tztSBTradeSearchView
@synthesize nsStock = _nsStock;
@synthesize nsHQType = _nsHQType;
-(NSString*)GetReqAction:(NSInteger)nMsgID
{
    switch (nMsgID)
    {
        case WT_QUERYSBHQ://三板行情
        case MENU_JY_SB_HQ:
            _reqAction = @"199";
            break;
        default:
            break;
    }
    return _reqAction;
}

-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
//    if (_nsStock && _nsHQType && [_nsStock length] > 0 && [_nsHQType length] > 0)
    {
        [pDict setTztValue:@"SBACCOUNT" forKey:@"WTACCOUNTTYPE"];
        [pDict setTztValue:_nsStock forKey:@"StockCode"];
        [pDict setTztValue:_nsHQType forKey:@"YXMMLB"];
    }
}


//工具栏点击
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case HQ_MENU_Trend://分时
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
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
            //获取当前的股票代码传递过去
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:0];
            [pStock release];
            return TRUE;
        }
            break;
            
        default:
            break;
    }
    BOOL bDeal = FALSE;
    bDeal = [super OnToolbarMenuClick:sender];
    
    return bDeal;
}
@end
