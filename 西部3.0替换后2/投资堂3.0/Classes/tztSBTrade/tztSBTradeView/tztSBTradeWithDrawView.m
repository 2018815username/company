/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztSBTradeSearchView
 * 文件标识:
 * 摘要说明:		股转系统撤单界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztSBTradeWithDrawView.h"

@implementation tztSBTradeWithDrawView
-(NSString*)GetReqAction:(int)nMsgID
{
    switch (nMsgID)
    {
        case WT_SBWITHDRAW://三板撤单
        case MENU_JY_SB_Withdraw:
            _reqAction = @"179";
            break;
        case WT_QUERYSBDRWT://当日委托
        case MENU_JY_SB_QueryDraw:
            _reqAction = @"179";
            break;
        case WT_QUERYSBDRCJ://三板成交
        case MENU_JY_SB_QueryTrans:
            _reqAction = @"347";
            break;
        default:
            break;
    }
    return _reqAction;
}
-(void)OnWithDraw
{
    //获取当前的选中行信息
    NSArray* pAy = [_pGridView tztGetCurrent];
    if (pAy == NULL || [pAy count] <= 0)
        return;
    
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
        
        NSString* strContact = [NSString stringWithFormat:@"%@", pGrid.text];
        [pDict setTztValue:strContact forKey:@"ContactID"];
        NSString* nsAccountType = [NSString stringWithFormat:@"%@", @"sbaccount"];
        [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];

        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"198" withDictValue:pDict];
        [pDict release];
    }
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
            
            if (_nContactIDIndex < 0 || _nAccountIndex < 0 ||_nContactIDIndex >= [pAy count] || _nAccountIndex >= [pAy count])
                return TRUE;
            
            if (_nDrawIndex >= 0 && _nDrawIndex < [pAy count])
            {
                TZTGridData *pGrid = [pAy objectAtIndex:_nDrawIndex];
                if (pGrid && [pGrid.text compare:tztCanWithDraw] != NSOrderedSame)
                {
                    [self showMessageBox:@"该委托不可撤!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"撤单提示"];
                    return TRUE;
                }
            }
            
            TZTGridData* pGrid = [pAy objectAtIndex:_nContactIDIndex];
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
