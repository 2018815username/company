/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztZQTradeBuySellView
 * 文件标识:
 * 摘要说明:		债转股,债券回售
 *
 * 当前版本:      2.0
 * 作    者:     xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztZQTradeBuySellView.h"

@implementation tztZQTradeBuySellView

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    //
    if (_tztTradeView)
    {
        [_tztTradeView removeFromSuperview];
        _tztTradeView = nil;
    }
    
    if (_tztTradeView == NULL)
    {
        _tztTradeView = NewObject(tztUIVCBaseView);
        _tztTradeView.tztDelegate = self;
        _tztTradeView.tableConfig = @"tztUITradeZQSaleStock_NewVersion";
        _tztTradeView.frame = rcFrame;
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }else
        _tztTradeView.frame = rcFrame;
    
    NSMutableArray *datat =[NSMutableArray array];
    [datat addObject:@"债券转股"];
    [datat addObject:@"债券回售"];
    [_tztTradeView setComBoxData:datat ayContent_:datat AndIndex_:0 withTag_:2010];
}

//债转股，债券回售
-(void)OnSendBuySell
{
    if (_tztTradeView == nil)
    {
        [self setCanChange:TRUE];
        return;
    }
    //股东帐户
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    //股票代码
    NSString* nsCode = [_tztTradeView GetEidtorText:2000];
    
    if (nsCode == NULL || [nsCode length] < 1)
    {
//        nsCode = [_tztTradeView getComBoxText:2220];
        nsCode = [_tztTradeView GetEidtorText:2220];
    }
    
    if (nsCode == NULL || [nsCode length] < 1)
    {
        [self setCanChange:TRUE];
        return;
    }
    
    //委托价格
    NSString* nsPrice = @"0";//[_tztTradeView GetEidtorText:2001];
//    if (nsPrice == NULL || [nsPrice length] < 1 || [nsPrice floatValue] <= 0.0000001f)
//    {
//        [self showMessageBox:@"委托价格输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
//        return;
//    }
    
    NSString* nsAmount = [_tztTradeView GetEidtorText:2002];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] <= 0)
    {
        [self showMessageBox:@"委托数量输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        [self setCanChange:TRUE];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"WTAccount"];
    [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
    //[pDict setTztValue:nsPrice forKey:@"Price"];
    [pDict setTztValue:nsAmount forKey:@"Volume"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [pDict setTztValue:@"S" forKey:@"Direction"];
    
    if (_nMsgType == MENU_JY_PT_ZhaiZhuanGu || self.currentSelect ==0) //债券转股
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"350" withDictValue:pDict];
    }
    else//债券回购
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"351" withDictValue:pDict];
    }
    
    DelObject(pDict);
    [self setCanChange:TRUE];
}


-(BOOL)CheckInput
{
    if (_tztTradeView == NULL || ![_tztTradeView CheckInput])
        return FALSE;
    
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
    
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    
    //股票代码
    NSString* nsCode = [_tztTradeView GetEidtorText:2000];
    
    if (nsCode == NULL || [nsCode length] < 1)
    {
//        nsCode = [_tztTradeView getComBoxText:2220];
                nsCode = [_tztTradeView GetEidtorText:2220];
    }
    if (nsCode == NULL || [nsCode length] < 1)
        return FALSE;
    
    //委托价格
//    NSString* nsPrice = [_tztTradeView GetEidtorText:2001];
//    if (nsPrice == NULL || [nsPrice length] < 1)
//    {
//        [self showMessageBox:@"委托价格输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
//        return FALSE;
//    }
    
    //委托数量
    NSString* nsAmount = [_tztTradeView GetEidtorText:2002];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"委托数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //股票名称
    NSString* nsName = [_tztTradeView GetLabelText:3000];
    if (nsName == NULL)
        nsName = @"";
    
    NSString* strInfo = @"";
    NSString* strTemp  = @"";
    if (_nMsgType == MENU_JY_PT_ZhaiZhuanGu)
    {
        strTemp = @"债转股";
    }
    else
    {
        strTemp = @"债券回售";
    }
    
    strInfo = [NSString stringWithFormat:@" 委托账号:%@\r\n股票代码:%@\r\n股票名称:%@\r\n委托价格:%@\r\n委托数量:%@\r\n\r\n确认%@该股票？", nsAccount, nsCode, nsName, @"0.00", nsAmount, strTemp];
    
    if (_nLeadTSFlag == 0)
    {
        if (self.nsTSInfo)
        {
            strInfo = [NSString stringWithFormat:@"%@\r\n%@", strInfo, self.nsTSInfo];
        }
    }
    
    NSString* strTitle = @"系统提示";
    NSString* strButtonOK = @"确定";
    [self setCanChange:FALSE];
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:strTitle
                   nsOK_:strButtonOK
               nsCancel_:@"取消"];
    return TRUE;
}


@end
