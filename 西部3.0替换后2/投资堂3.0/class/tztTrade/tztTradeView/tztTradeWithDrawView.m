/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        委托撤单
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztTradeWithDrawView.h"

@interface tztTradeWithDrawView (tztPrivate)
-(void)OnWithDraw;
@end

@implementation tztTradeWithDrawView
@synthesize nContactIDIndex = _nContactIDIndex;
-(id)init
{
    if (self = [super init])
    {
        _nContactIDIndex = -1;
    }
    return self;
}

-(void)DealIndexData:(tztNewMSParse *)pParse
{
    if (pParse == NULL)
        return;
    //获取合同号索引
    NSString* strIndex = [pParse GetByName:@"ContactIndex"];
    TZTStringToIndex(strIndex, _nContactIDIndex);
    
}

//各个不同的请求增加个字特定的请求数据字段
-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
    if (_nMsgType == WT_SBWITHDRAW || _nMsgType == MENU_JY_SB_Withdraw)
    {
        [pDict setTztObject:@"1" forKey:@"action_in"];
    }
    else if(_nMsgType == WT_WITHDRAW || _nMsgType == MENU_JY_PT_Withdraw)
    {
        [pDict setTztObject:@"1" forKey:@"Direction"];
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
            
            if (_nContactIDIndex < 0 ||_nContactIDIndex >= [pAy count])
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
            
            if (pGrid && pGrid.text && ![pGrid.text isEqualToString:@"查无记录!"])
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

-(void)OnWithDraw
{
    //获取当前的选中行信息
    
    NSArray* pAy = [_pGridView tztGetCurrent];
    
    if (pAy == NULL || [pAy count] <= 0)
        return;
    
    if (_nDrawIndex < 0 || _nContactIDIndex < 0 || _nAccountIndex < 0 || _nDrawIndex >= [pAy count] || _nContactIDIndex >= [pAy count] || _nAccountIndex >= [pAy count])
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
        //wry 撤单的时候添加发送参数
        if (_pGridView.curIndexRow>=0 && (self.marketArray.count>_pGridView.curIndexRow) ) {
        [pDict setTztValue:self.marketArray[_pGridView.curIndexRow] forKey:@"WTACCOUNTTYPE"];//_pGridView.curIndexRow
        }
      
        NSString* strContact = [NSString stringWithFormat:@",%@,%@;", pGridAccount.text, pGrid.text];
        [pDict setTztValue:strContact forKey:@"CommBatchEntrustInfo"];
        
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"120" withDictValue:pDict];
        [pDict release];
    }
}
@end
