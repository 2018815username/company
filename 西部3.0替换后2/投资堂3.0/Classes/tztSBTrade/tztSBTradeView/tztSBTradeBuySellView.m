/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztSBTradeBuySellView
 * 文件标识:
 * 摘要说明:		股转系统买卖界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztSBTradeBuySellView.h"

@implementation tztSBTradeBuySellView
-(void)OnSendBuySell
{
    if (_tztTradeView == nil)
    {
        [self setCanChange:TRUE];
        return;
    }
    //股东账号
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    //股票代码
    NSString* nsCode = [_tztTradeView GetEidtorText:2000];
    
    if (nsCode == NULL || [nsCode length] < 1)
    {
        nsCode = [_tztTradeView getComBoxText:2000];
    }
    
    if (nsCode == NULL || [nsCode length] < 1)
    {
        [self setCanChange:TRUE];
        return;
    }
    
    //委托加个
    NSString* nsPrice = [_tztTradeView GetEidtorText:2001];
    if (nsPrice == NULL || [nsPrice length] < 1 || [nsPrice floatValue] <= 0.0000001f)
    {
        [self showMessageBox:@"委托价格输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* nsAmount = [_tztTradeView GetEidtorText:2002];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] <= 0)
    {
        [self showMessageBox:@"委托数量输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        [self setCanChange:TRUE];
        return;
    }
    NSString *nsYDXH = @"";
    NSString *nsXWH = @"";
    if (_nMsgType == WT_SBQRBUY || _nMsgType == MENU_JY_SB_QRBuy || _nMsgType == WT_SBQRSALE || _nMsgType == MENU_JY_SB_QRSell|| _nMsgType==MENU_JY_SB_HBQRBuy || _nMsgType==MENU_JY_SB_HBQRSell)
    {
        nsYDXH = [_tztTradeView GetEidtorText:2003];
        if (nsYDXH == NULL || [nsYDXH length] < 1)
        {
            [self showMessageBox:@"约定序号输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
            [self setCanChange:TRUE];
            return;
        }
        
        nsXWH = [_tztTradeView GetEidtorText:2004];
        if (nsXWH == NULL || [nsXWH length] < 1)
        {
            [self showMessageBox:@"对方席位号输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
            [self setCanChange:TRUE];
            return;
        }
    }
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"WTAccount"];
    [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
    [pDict setTztValue:nsPrice forKey:@"Price"];
    [pDict setTztValue:nsAmount forKey:@"Volume"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [pDict setTztValue:nsAccount forKey:@"StockAccount"];
    if (_bBuyFlag)
    {
        [pDict setTztValue:@"B" forKey:@"Direction"];
    }
    else
        [pDict setTztValue:@"S" forKey:@"Direction"];

    switch (_nMsgType)
    {
        case WT_SBYXBUY:
        case MENU_JY_SB_YXBuy:
        case WT_SBYXSALE:
        case MENU_JY_SB_YXSell:
            [pDict setTztValue:@"a" forKey:@"PriceType"];
            break;
        case WT_SBDJBUY:
        case MENU_JY_SB_DJBuy:
        case WT_SBDJSALE:
        case MENU_JY_SB_DJSell:
            [pDict setTztValue:@"b" forKey:@"PriceType"];
            break;
        case WT_SBQRBUY:
        case MENU_JY_SB_QRBuy:
        case WT_SBQRSALE:
        case MENU_JY_SB_QRSell:
        {
            [pDict setTztValue:@"c" forKey:@"PriceType"];
            [pDict setTztValue:nsYDXH forKey:@"CONFERNO"];
            [pDict setTztValue:nsXWH forKey:@"OPPOSEATNO"];
        }
            break;
        case MENU_JY_SB_HBQRBuy://  互报成交确认买入
        case MENU_JY_SB_HBQRSell: //13017  互报成交确认卖出
        {
            
          [pDict setTztValue:@"d" forKey:@"PriceType"];
          [pDict setTztValue:nsYDXH forKey:@"CONFERNO"];
          [pDict setTztValue:nsXWH forKey:@"OPPOSEATNO"];
            
            //对方股东
            NSString *partyShareholder=[_tztTradeView GetEidtorText:2006];

            if (partyShareholder == NULL || [partyShareholder length] < 1)
            {
                [self showMessageBox:@"对方股东输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
                [self setCanChange:TRUE];
                return;
            }
            [pDict setTztValue:partyShareholder forKey:@"oppclientno"];

        }
             break;
        default:
            break;
    }
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"178" withDictValue:pDict];
    DelObject(pDict);
    [self setCanChange:TRUE];
}

-(void)ClearDataWithOutCode
{
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:1000];
    
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2002];
    [_tztTradeView setLabelText:@"" withTag_:3000];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2003];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2004];
    self.nsNewPrice = @"";
    for (int i = 4998; i <= 5026; i++)
    {
        [_tztTradeView setButtonTitle:@""
                              clText_:[UIColor whiteColor]
                            forState_:UIControlStateNormal
                             withTag_:i];
    }
}

//清空界面数据
-(void) ClearData
{
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2000];
    //清空可编辑的droplist控件数据 // byDBQ20130814
    [_tztTradeView setComBoxTextField:2000];

 
        [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2005];


//        [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2220 ];
        [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2006 ];
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:2011];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
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
        nsCode = [_tztTradeView getComBoxText:2000];
    }
    if (nsCode == NULL || [nsCode length] < 1)
        return FALSE;
    
    //委托价格
    NSString* nsPrice = [_tztTradeView GetEidtorText:2001];
    if (nsPrice == NULL || [nsPrice length] < 1)
    {
        [self showMessageBox:@"委托价格输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //委托数量
    NSString* nsAmount = [_tztTradeView GetEidtorText:2002];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"委托数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //股转系统判断
    NSString* nsYDXH = @"";
    NSString* nsXWH = @"";
    if (_nMsgType == WT_SBQRBUY || _nMsgType == MENU_JY_SB_QRBuy || _nMsgType == WT_SBQRSALE || _nMsgType ==MENU_JY_SB_QRSell)
    {
        nsYDXH = [_tztTradeView GetEidtorText:2003];
        if (nsYDXH == NULL || [nsYDXH length] < 1)
        {
            [self showMessageBox:@"约定序号输入有误!"
                          nType_:TZTBoxTypeNoButton
                           nTag_:0
                       delegate_:NULL
                      withTitle_:@"股转系统"];
            return FALSE;
        }
        
        nsXWH = [_tztTradeView GetEidtorText:2004];
        if (nsXWH == NULL || [nsXWH length] < 1)
        {
            [self showMessageBox:@"对方席位号输入有误!"
                          nType_:TZTBoxTypeNoButton
                           nTag_:0
                       delegate_:NULL
                      withTitle_:@"股转系统"];
            return FALSE;
        }
    }
    
    //股票名称
    NSString* nsName = [_tztTradeView GetLabelText:3000];
    if (nsName == NULL)
        nsName = @"";
    
    NSString* strInfo = @"";
    
    if (_nMsgType == WT_SBQRBUY || _nMsgType == MENU_JY_SB_QRBuy || _nMsgType == WT_SBQRSALE || _nMsgType == MENU_JY_SB_QRSell)
    {
        strInfo = [NSString stringWithFormat:@"委托账号:%@\r\n股票代码:%@\r\n股票名称:%@\r\n委托价格:%@\r\n委托数量:%@\r\n约定席位号:%@\r\n对方席位号:%@\r\n\r\n确认%@该股票？", nsAccount, nsCode, nsName, nsPrice, nsAmount, nsYDXH, nsXWH, (_bBuyFlag?@"买入":@"卖出")];
    }
    else
    {
        strInfo = [NSString stringWithFormat:@"委托账号:%@\r\n股票代码:%@\r\n股票名称:%@\r\n委托价格:%@\r\n委托数量:%@\r\n\r\n确认%@该股票？", nsAccount, nsCode, nsName, nsPrice, nsAmount, (_bBuyFlag?@"买入":@"卖出")];
    }
    
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
