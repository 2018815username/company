/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券撤单view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztRZRQTradeWithDrawView.h"

@implementation tztRZRQTradeWithDrawView
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
            
            if (/*_nDrawIndex < 0 ||*/ _nContactIDIndex < 0 /*|| _nDrawIndex >= [pAy count]*/ || _nContactIDIndex >= [pAy count])
                return TRUE;
           
            /*
            TZTGridData *pGrid = [pAy objectAtIndex:_nDrawIndex];
            if (pGrid && [pGrid.text compare:tztCanWithDraw] != NSOrderedSame)
            {
                [self showMessageBox:@"该委托不可撤!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"撤单提示"];
                return TRUE;
            }
            */
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
//zxl 20131018 撤单的委托确定处理
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
    
    if (/*_nDrawIndex < 0 ||*/ _nContactIDIndex < 0 || _nAccountIndex < 0 /*|| _nDrawIndex >= [pAy count]*/ || _nContactIDIndex >= [pAy count] || _nAccountIndex >= [pAy count])
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
        
//        [pDict setTztValue:pGridAccount.text forKey:@"account"];
        
        //wry 普通撤单401 融资融券撤单431 的时候添加发送参数
//        if (_pGridView.curIndexRow>=0 && (self.marketArray.count>_pGridView.curIndexRow)) {
//            [pDict setTztValue:self.marketArray[_pGridView.curIndexRow] forKey:@"WTACCOUNTTYPE"];
//        }

        [pDict setTztValue:pGridAccount.text forKey:@"wtaccount"];
        [pDict setTztValue:pGrid.text forKey:@"contactid"];
        [pDict setTztValue:@"0" forKey:@"StartPos"];
        [pDict setTztValue:@"1" forKey:@"count"];
        NSString* strContact = [NSString stringWithFormat:@",%@,%@;", pGridAccount.text, pGrid.text];
        [pDict setTztValue:strContact forKey:@"CommBatchEntrustInfo"];
        //增加账号类型获取token
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
        
        //新功能 add by xyt 20131018
        if(_nMsgType == WT_RZRQQUERYDRWT || _nMsgType == WT_RZRQQUERYWITHDRAW || _nMsgType == MENU_JY_RZRQ_QueryDraw || _nMsgType == MENU_JY_RZRQ_Withdraw)
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"401" withDictValue:pDict];
        }
        else
        {//融资融券担保品划转撤单
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"431" withDictValue:pDict];
        }
        [pDict release];
    }
}
@end
