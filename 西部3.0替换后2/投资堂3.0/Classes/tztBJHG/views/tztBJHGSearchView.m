/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        报价回购查询view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztBJHGSearchView.h"

@implementation tztBJHGSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(NSString*)GetReqAction:(NSInteger)nMsgID
{
    switch (nMsgID)
    {
        case WT_BJHG_WTCX:
        case MENU_JY_BJHG_QueryDraw:
        {
            _reqAction = @"387";
        }
            break;
        case WT_BJHG_XXZZ:
        case MENU_JY_BJHG_Stop:
        {
            _reqAction = @"387";
        }
            break;
        case WT_BJHG_TQGH:
        case MENU_JY_BJHG_Ahead:
        {
            _reqAction = @"388";
        }
            break;
        case WT_BJHG_YYTG:
        case MENU_JY_BJHG_MakeAn:
        {
            _reqAction = @"388";
        }
            break;
        case WT_BJHG_WDQ:
        case MENU_JY_BJHG_QueryNoDue:
        {
            _reqAction = @"388";
        }
            break;
        case WT_BJHG_ZYMX:
        case MENU_JY_BJHG_QueryInfo:
        {
            _reqAction = @"394";
        }
            break;
            
        default:
            break;
    }
    return _reqAction;
}

-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
    if (_nMsgType == WT_BJHG_XXZZ || _nMsgType == MENU_JY_BJHG_Stop)
    {
        [pDict setTztObject:@"1" forKey:@"Direction"];
    }
}

-(void)DealIndexData:(tztNewMSParse *)pParse
{
    if (pParse == NULL)
        return;
    NSString *strIndex = [pParse GetByName:@"ContactIndex"];
    TZTStringToIndex(strIndex, _nContactIndex);
    
    strIndex = [pParse GetByName:@"DateIndex"];
    TZTStringToIndex(strIndex, _nBeginIndex);
    
    strIndex = [pParse GetByName:@"DrawIndex"];
    TZTStringToIndex(strIndex, _nDrawIndex);
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_WithDraw:
        {
            bDeal = TRUE;
            [self OnWithDraw:FALSE];
        }
            break;
        default:
            break;
    }
    bDeal = [super OnToolbarMenuClick:sender];
    return bDeal;
}
//zxl 20131017 ipad 添加确定处理
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
                
            default:
                break;
        }
    }
}

-(void)OnWithDraw:(BOOL)bSend
{
    NSArray* pAy = [_pGridView tztGetCurrent];
    if (pAy == NULL || [pAy count] <= 0 ||  _nContactIndex < 0 || _nContactIndex >= [pAy count] /*|| _nBeginIndex < 0 || _nBeginIndex >= [pAy count]*/)
        return;
    
    if (!bSend)
    {
        if (_nDrawIndex >= 0 && _nDrawIndex < [pAy count])
        {
            TZTGridData *pGrid = [pAy objectAtIndex:_nDrawIndex];
            if (pGrid && pGrid.text && [pGrid.text compare:tztCanWithDraw] != NSOrderedSame)
            {
                [self showMessageBox:@"该委托不可操作!" nType_:TZTBoxTypeNoButton delegate_:nil];
                return;
            }
        }
        [self showMessageBox:@"确定要对该委托进行处理吗？" nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self];
        return;
    }
    else
    {
        NSString* nsContactID = @"";
        NSString* nsBeginDate = @"";
        
        TZTGridData *pGridContact = [pAy objectAtIndex:_nContactIndex];
        nsContactID = pGridContact.text;
        
        if (_nBeginIndex >= 0 && _nBeginIndex < [pAy count])
        {
            TZTGridData *pGridDate = [pAy objectAtIndex:_nBeginIndex];
            nsBeginDate = pGridDate.text;
        }
        
        if (nsBeginDate == NULL)
            nsBeginDate = @"";
        
        if (nsContactID == NULL)
            return;
        
        //续作终止， 提前购回
        if (_nMsgType == WT_BJHG_XXZZ || _nMsgType == WT_BJHG_TQGH || _nMsgType == MENU_JY_BJHG_Stop || _nMsgType == MENU_JY_BJHG_Ahead)
        {
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            _ntztReqNo++;
            if (_ntztReqNo >= UINT16_MAX)
                _ntztReqNo = 1;
            NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
            [pDict setTztObject:strReqno forKey:@"Reqno"];
            [pDict setTztObject:nsContactID forKey:@"ContactID"];
            
            if (_nMsgType == WT_BJHG_TQGH || _nMsgType == MENU_JY_BJHG_Ahead)
            {
                [pDict setTztObject:nsBeginDate forKey:@"BeginDate"];
                [[tztMoblieStockComm getShareInstance] onSendDataAction:@"384" withDictValue:pDict];
            }
            else
            {
                [[tztMoblieStockComm getShareInstance] onSendDataAction:@"383" withDictValue:pDict];
            }
            
            DelObject(pDict);
        }
        else if(_nMsgType == WT_BJHG_YYTG || _nMsgType == MENU_JY_BJHG_MakeAn || _nMsgType == WT_BJHG_WTCX || _nMsgType == MENU_JY_BJHG_QueryDraw)
        {
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            _ntztReqNo++;
            if (_ntztReqNo >= UINT16_MAX)
                _ntztReqNo = 1;
            NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
            [pDict setTztObject:strReqno forKey:@"Reqno"];
            [pDict setTztObject:nsContactID forKey:@"ContactID"];
            [pDict setTztObject:nsBeginDate forKey:@"BeginDate"];
            if (_nMsgType == WT_BJHG_YYTG || _nMsgType == MENU_JY_BJHG_MakeAn)
            {
                [pDict setTztObject:@"0" forKey:@"Direction"];
            }
            else
            {
                [pDict setTztObject:@"1" forKey:@"Direction"];
            }
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"385" withDictValue:pDict];
            
            DelObject(pDict);
        }
    }
    
}

@end
