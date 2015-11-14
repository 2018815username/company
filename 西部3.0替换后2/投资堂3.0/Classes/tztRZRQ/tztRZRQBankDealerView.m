/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztRZRQBankDealerView.h"
extern tztCardBankTransform *g_pBDTranseInfo;

#define BankList_Flag   0
#define MoneyType_Flag  1
#define InAccount_Flag  5
#define OutAccount_Flag  6

#define ZhuanZhuangPwd_Tag 0x01;
#define ZiJinPwd_Tag 0x02;
#define BankPwd_Tag 0x03;
#define ZiJInAccount_Tag 0x04;

@implementation tztRZRQBankDealerView

-(id) init
{
    if (self = [super init])
    {
        _nMsgType = WT_RZRQBANKTODEALER;
        _bNeedBankPW = -1;
        _bNeedFundPW = -1;
        _nMoneyTypeIndex = -1;
        _nBankTypeIndex = -1;
        
        _ayBank = NewObject(NSMutableArray);
        _ayMoney = NewObject(NSMutableArray);
        _ayAccount = NewObject(NSMutableArray);
        
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayAccount);
    DelObject(_ayBank);
    DelObject(_ayMoney);
    [super dealloc];
}

//-(void)OnButton:(id)sender
//{
//    [self Check];
//}
//
//-(void)Check
//{
//    if (!g_pBDTranseInfo || _tztTableView == NULL)
//        return;
//    
//    if (![_tztTableView CheckInput:_tztTableView])
//        return;
//    NSString* nsString = @"";
//    NSString* nsBank = @"";
//    NSString* nsMoney = @"";
//    NSString* nsAmount = @"";
//    NSString* nsOutAccount = @"";
//    NSString* nsInAccount = @"";
//    int nIndex = -1;
//    nsBank = [_tztTableView GetComBoxTextWithTag:1001 nSelectIndex:&nIndex];
//    nsMoney = [_tztTableView GetComBoxTextWithTag:1000 nSelectIndex:&nIndex];
//    
//    //转账金额
//    nsAmount = [_tztTableView GetEditorTextWithTag:2000];
//    if (_nMsgType == WT_RZRQQUERYBALANCE)
//    {
//        nsString = [NSString stringWithFormat:@"查询币种:%@\r\n查询银行:%@\r\n确认操作？",nsMoney,nsBank];
//    }
//    else
//    {
//        nsString = [NSString stringWithFormat:@"转账币种:%@\r\n转账银行:%@\r\n转账金额:%@\r\n确认操作？", nsMoney, nsBank, nsAmount];
//    }
//    
//    [self showMessageBox:nsString nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self withTitle_:@"系统提示"];
//}
//
//-(void)doOK
//{
//    if (!g_pBDTranseInfo)
//        return;
//    
//    NSString* strBank = @"";
//    int nIndex = -1;
//    strBank = [_tztTableView GetComBoxTextWithTag:1001 nSelectIndex:&nIndex];
//    if (strBank == NULL || [strBank length] < 1)
//        return;
//    [g_pBDTranseInfo SetBank:strBank];
//    NSString* strMoney = [_tztTableView  GetComBoxTextWithTag:1000 nSelectIndex:&nIndex];
//    if (strMoney == NULL | [strMoney length] < 1)
//        return;
//    [g_pBDTranseInfo SetMoneyType:strMoney];
//    
//    [g_pBDTranseInfo SetTransferType:_nMsgType];
//    
//    NSString* nsMoney = [_tztTableView GetEditorTextWithTag:2000];
//    NSString* nsBankPW = [_tztTableView GetEditorTextWithTag:2001];
//    NSString* nsFundPW = [_tztTableView GetEditorTextWithTag:2002];
//    if (_nMsgType == WT_RZRQBANKTODEALER
//        ||_nMsgType == WT_RZRQDEALERTOBANK)
//    {
//        if (nsMoney == NULL || [nsMoney floatValue] <= 0.001f)
//        {
//            [self showMessageBox:@"输入金额无效，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
//            return;
//        }
//    }
//    [g_pBDTranseInfo SetTransferVolume:[nsMoney floatValue]];
//    if (nsBankPW == NULL)
//        nsBankPW = @"";
//    [g_pBDTranseInfo SetBankPassword:nsBankPW];
//    
//    if (nsFundPW == NULL)
//        nsFundPW = @"";
//    [g_pBDTranseInfo SetDealerPassword:nsFundPW];
//    
//    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
//    NSString *strAction = @"";
//    if (_nMsgType == WT_RZRQBANKTODEALER)
//    {
//        if (![g_pBDTranseInfo IsShowBankPW:strBank])
//        {
//            nsBankPW = @"";
//            [g_pBDTranseInfo SetBankPassword:nsBankPW];
//        }
//        strAction = [g_pBDTranseInfo MakeStrBankToDealer:pDict];
//    }
//    else if(_nMsgType == WT_RZRQDEALERTOBANK)
//    {
//        strAction = [g_pBDTranseInfo MakeStrDealerToBank:pDict];
//    }
//    else if(_nMsgType == WT_RZRQQUERYBALANCE)
//    {
//        strAction = [g_pBDTranseInfo MakeStrQueryBalance:pDict];
//    }
//    else if(_nMsgType == WT_RZRQTRANSHISTORY)
//    {
//        
//    }
//    else
//    {
//        DelObject(pDict);
//        return;
//    }
//    _ntztReqNo++;
//    if (_ntztReqNo >= UINT16_MAX)
//        _ntztReqNo = 1;
//    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
//    [pDict setTztValue:strReqno forKey:@"Reqno"];
//    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
//    [self OnSendDataState];
//    DelObject(pDict);
//}
//
//-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
//{
//    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
//    if (pParse == NULL)
//        return 0;
//    
//    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
//        return 0;
//    NSString* strErrMsg = [pParse GetErrorMessage];
//    if ([pParse GetErrorNo] < 0)
//    {
//        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
//        return 0;
//    }
//    
//    BOOL isForce = YES;
//    //查询可用余额
//    if ([pParse IsAction:@"194"])
//    {
//        [g_pBDTranseInfo ClearAvailableVolumeData];
//        NSMutableArray *pAy = nil;
//        int availableVolumeIndex = -1;
//        int accountIndex = -1;
//        int CurrencyIndex = -1;
//        NSString* strTemp = [pParse GetByName:@"UsableIndex"];
//        if (strTemp != NULL && ![strTemp length] > 0)
//        {
//            availableVolumeIndex = [strTemp intValue];
//        }
//        else
//            availableVolumeIndex = -1;
//        
//        strTemp = [pParse GetByName:@"fundaccountIndex"];
//        if (strTemp != NULL && ![strTemp length] > 0)
//        {
//            accountIndex = [strTemp intValue];
//        }
//        else
//            accountIndex = -1;
//        
//        strTemp = [pParse GetByName:@"CurrencyIndex"];
//        if(strTemp && [strTemp length] > 0)
//        {
//            CurrencyIndex = [strTemp intValue];
//        }
//        
//        if (accountIndex < 0 || availableVolumeIndex < 0 || CurrencyIndex <0)
//            return 0;
//        
//        NSArray *pGrid = [pParse GetArrayByName:@"Grid"];
//        for (int i = 0; i < [pGrid count]; i++)
//        {
//            pAy = [pGrid objectAtIndex:i];
//            if (pAy == NULL || [pAy count] <= accountIndex || [pAy count] <= availableVolumeIndex || [pAy count] <= CurrencyIndex
//                || accountIndex < 0 || availableVolumeIndex < 0 || CurrencyIndex < 0)
//            {
//                continue;
//            }
//            
//            NSString* account = [pAy objectAtIndex:accountIndex];
//            NSString* availableVolume = [pAy objectAtIndex:availableVolumeIndex];
//            NSString* strMoney = [pAy objectAtIndex:CurrencyIndex];
//            
//            if (account == NULL || availableVolume == NULL || strMoney == NULL)
//                continue;
//            [g_pBDTranseInfo AddAvailableVolume:account strMoney_:strMoney sAvailableValume_:availableVolume];
//        }
//        isForce = NO;
//    }
//    
//    if (_nMsgType == WT_RZRQBANKTODEALER || _nMsgType == WT_RZRQDEALERTOBANK)
//	{
//        
//        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
//        [self ClearData];
//	}
////    if (isForce && (_nMsgType == WT_DFDEALERTOBANK || _nMsgType == WT_NeiZhuan)) 
////    {
////        [NSTimer scheduledTimerWithTimeInterval:0.1
////										 target:self 
////								       selector:@selector(doQueryBalance)
////								       userInfo:nil
////									    repeats:NO];
////    }
//    return 1;
//}
//
////查询银行余额
//-(void) doQueryBalance
//{
//    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
//    [pDict setTztValue:@"0" forKey:@"StartPos"];
//    [pDict setTztValue:@"10" forKey:@"MaxCount"];
//    [pDict setTztValue:@"10" forKey:@"Volume"];
//    
//    _ntztReqNo++;
//    if (_ntztReqNo >= UINT16_MAX)
//        _ntztReqNo = 1;
//    
//    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
//    [pDict setTztValue:strReqno forKey:@"Reqno"];
//    
//    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"194" withDictValue:pDict];
//    [pDict release];
//	[self OnSendDataState];
//	return;
//}
//
//-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        switch (TZTUIMessageBox.tag)
//        {
//            case 0x1111:
//                [self doOK];
//                break;
//                
//            default:
//                break;
//        }
//    }
//}
//
//-(BOOL)OnToolbarMenuClick:(id)sender
//{
//    UIButton* pBtn = (UIButton*)sender;
//    switch (pBtn.tag)
//    {
//        case TZTToolbar_Fuction_OK:
//        {
//            if (![_tztTableView CheckInput:_tztTableView])
//            {
//                return FALSE;
//            }
//            [self Check];
//            return TRUE;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return FALSE;
//}


@end
