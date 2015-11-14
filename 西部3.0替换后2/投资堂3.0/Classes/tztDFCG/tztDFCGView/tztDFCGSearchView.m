/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztDFCGSearchView
 * 文件标识:
 * 摘要说明:		多方存管查询界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztDFCGSearchView.h"

@implementation tztDFCGSearchView
-(NSString*)GetReqAction:(NSInteger)nMsgID
{
    switch (nMsgID)
    {
        case WT_GuiJiResult://资金归集
        case MENU_JY_DFBANK_Input://资金归集
            _reqAction = @"194";
            break;
        case WT_NeiZhuanResult://查询流水
        case WT_DFQUERYDRNZ://当日内转查询
        case MENU_JY_DFBANK_QueryTransitHis://调拨流水
            _reqAction = @"197";
            break;
        case WT_DFTRANSHISTORY://转账流水
        case MENU_JY_DFBANK_QueryBankHis://查询流水
            _reqAction = @"341";
            break;
        case WT_DFQUERYHISTORYEx://计划查询流水
            _reqAction = @"511";
            break;
        case WT_DFQUERYNZLS://历史内转查询//zxl 20131128
            _reqAction = @"651";
            break;
        default:
            break;
    }
    return _reqAction;
}
//zxl 20131128 查询特殊处理
-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
    switch (self.nMsgType)
    {
        case WT_DFTRANSHISTORY://转账流水
            [pDict setTztValue:@" " forKey:@"FUNDACCOUNT"];
            break;
        case WT_DFQUERYDRNZ:
        case WT_NeiZhuanResult://查询流水
        {
            //获取当天日期
            NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
            [outputFormat setDateFormat:@"yyyyMMdd"];
            
            NSDate *CurrentDate = [NSDate date];
            NSString* nsCurrentDate = [outputFormat stringFromDate:CurrentDate];
            [outputFormat release];
            [pDict setTztValue:nsCurrentDate forKey:@"BeginDate"];
            [pDict setTztValue:nsCurrentDate forKey:@"EndDate"];
        }
            
            break;
        default:
            break;
    }
}

-(void)OnSendGuiJi
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"343" withDictValue:pDict];
    DelObject(pDict);
}
-(BOOL)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    bDeal = [super OnToolbarMenuClick:sender];
    if (!bDeal)
    {
        UIButton *button = (UIButton *)sender;
        if (button.tag == TZTToolbar_Fuction_BankGuiJi)
        {
            [self OnSendGuiJi];
        }
    }
    return bDeal;
}

@end
