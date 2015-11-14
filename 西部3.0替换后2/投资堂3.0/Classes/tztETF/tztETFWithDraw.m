/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF撤单
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztETFWithDraw.h"

enum
{
    kTag_ETFCode = 1000,    //ETF代码
    kTag_GDDM,              //股东代码
    kTag_ETFMC,             //ETF名称
    kTag_ETFKCSL,           //可撤数量
    kTag_CDSL,              //撤单数量
    kTag_CompCode = 2000,   //成份股代码
    kTag_CompName ,         //成份股名称
    kTagOK = 2002,          // 确定
    kTagCannel,             //返回
};

@implementation tztETFWithDraw
@synthesize ptztCrashTable = _ptztCrashTable;
@synthesize CurStockName = _CurStockName;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize ayName = _ayName;
@synthesize ayCompCode = _ayCompCode;
@synthesize ayCompName = _ayCompName;
@synthesize ayCompAccount = _ayCompAccount;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayType);
    DelObject(_ayAccount);
    DelObject(_ayStockNum);
    DelObject(_ayName);
    DelObject(_ayCompCode);
    DelObject(_ayCompName);
    DelObject(_ayCompAccount);
    [super dealloc];
    
}

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
    
    if (_ptztCrashTable == NULL)
    {
        _ptztCrashTable = NewObject(tztUIVCBaseView);
        _ptztCrashTable.tztDelegate = self;
        if (_nMsgType == WT_ETFGPRGCD || _nMsgType == MENU_JY_ETFWX_StockWithdraw || _nMsgType == WT_ETF_HS_GPCD || _nMsgType == MENU_JY_ETFKS_HSStockWithdraw || _nMsgType == WT_ETF_SS_RGCD || _nMsgType == MENU_JY_ETFKS_SSRGWithdraw)
        {
            _ptztCrashTable.tableConfig = @"tztTradeETFStock_WithDraw";
        }
        else
        {
            _ptztCrashTable.tableConfig = @"tztTradeETFCrash_WithDraw";
        }
        _ptztCrashTable.frame = rcFrame;
        [self addSubview:_ptztCrashTable];
        [_ptztCrashTable release];
    }else
        _ptztCrashTable.frame = rcFrame;    
}

-(void)OnClearData
{
    if (_ptztCrashTable == NULL) 
        return;
    
    //清空下拉框 modify by xyt 20131114
    [_ptztCrashTable setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTag_ETFCode];
    [_ptztCrashTable setEditorText:@"" nsPlaceholder_:nil withTag_:kTag_ETFCode];
    [_ptztCrashTable setLabelText:@"" withTag_:kTag_GDDM];
    [_ptztCrashTable setLabelText:@"" withTag_:kTag_ETFMC];
    [_ptztCrashTable setLabelText:@"" withTag_:kTag_ETFKCSL];
    [_ptztCrashTable setLabelText:@"" withTag_:kTag_CompCode];
    [_ptztCrashTable setLabelText:@"" withTag_:kTag_CompName];
    [_ptztCrashTable setEditorText:@"" nsPlaceholder_:nil withTag_:kTag_CDSL];
    
    self.CurStockName = @"";
    self.CurStockCode = @"";
    
    if (_ayAccount)
        [_ayAccount removeAllObjects];
    if (_ayType)
        [_ayType removeAllObjects];
    if (_ayStockNum)
        [_ayStockNum removeAllObjects];
    if (_ayName)
        [_ayName removeAllObjects];
    if (_ayCompCode)
        [_ayCompCode removeAllObjects];
    if (_ayCompName)
        [_ayCompName removeAllObjects];
    if (_ayCompAccount)
        [_ayCompAccount removeAllObjects];
    if (_ayData)
        [_ayData removeAllObjects];
    
    _nCurrentSel = 0;
}

//选中list
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTag_ETFCode)
    {
        [self OnRequestData];        
    }
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTag_ETFCode)
    {
        _nCurrentSel = index;
        NSString* strTitle = droplistview.text;
        if (_nCurrentSel < 0)
            return;
        if (([_ayAccount count] <= _nCurrentSel) || ([_ayName count] <= _nCurrentSel) || ([_ayStockNum count] <= _nCurrentSel)) {
            return;
        }
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            self.CurStockCode = [NSString stringWithFormat:@"%@", strCode];
            
            //当前股东代码
            NSString *strData = [_ayAccount objectAtIndex:_nCurrentSel];
            if (strData != NULL)
            {
                [_ptztCrashTable setLabelText:strData withTag_:kTag_GDDM];
            }
            //ETF名称
            strData = [_ayName objectAtIndex:_nCurrentSel];
            if (strData != NULL)
            {
                [_ptztCrashTable setLabelText:strData withTag_:kTag_ETFMC];
            }
            //可撤数量
            strData = [_ayStockNum objectAtIndex:_nCurrentSel];
            if (strData != NULL)
            {
                [_ptztCrashTable setLabelText:strData withTag_:kTag_ETFKCSL];
            }
            
            if (_nMsgType == WT_ETFGPRGCD || _nMsgType == MENU_JY_ETFWX_StockWithdraw || _nMsgType == WT_ETF_HS_GPCD || _nMsgType == MENU_JY_ETFKS_HSStockWithdraw || _nMsgType == WT_ETF_SS_RGCD || _nMsgType == MENU_JY_ETFKS_SSRGWithdraw)
            {
                strData = [_ayCompName objectAtIndex:_nCurrentSel];
                if (strData != NULL)
                {
                    [_ptztCrashTable setLabelText:strData withTag_:kTag_CompName];
                }
                
                strData = [_ayCompCode objectAtIndex:_nCurrentSel];
                if (strData != NULL)
                {
                    [_ptztCrashTable setLabelText:strData withTag_:kTag_CompCode];
                }
            }
        }
    }
}

/*
 查询持仓信息
 */
-(void)OnRequestData
{
    NSString* strAction = @"";
    switch (_nMsgType)
    {
        case WT_ETFXJRGCD:  //网下现金认购查询撤单
        case MENU_JY_ETFWX_FundWithdraw:
        case WT_ETF_HS_XJCD://沪市现金撤单查询
        case MENU_JY_ETFKS_HSFundWithdraw:
        {
            strAction = @"672";
        }
            break;
        case WT_ETFGPRGCD:  //网下股票认购查询撤单
        case MENU_JY_ETFWX_StockWithdraw:
        case WT_ETF_HS_GPCD://沪市股份认购查询可撤
        case MENU_JY_ETFKS_HSStockWithdraw: //14075  沪市股票撤单
        {
            strAction = @"673";
        }
            break;
        case WT_ETF_SS_RGCD://深市认购撤单
        case MENU_JY_ETFKS_SSRGWithdraw: // 14076  深市认购撤单
        {
            strAction = @"671";
        }
            break;
        default:
            break;
    }
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
    [pDict setTztObject:@"" forKey:@"Stockcode"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
}

-(BOOL)CheckInput
{
    if (_ptztCrashTable == nil)
        return FALSE;
    
    if (_nCurrentSel < 0 || _nCurrentSel >= [_ayAccount count]|| _nCurrentSel >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:_nCurrentSel];
    
    //ETF代码
    NSString *nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    if (self.CurStockCode == NULL ||nsCode == NULL || [nsCode length] < 1)
    {
        [self showMessageBox:@"请选择持仓股票！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //委托数量
    NSString* nsAmount = [_ptztCrashTable GetEidtorText:kTag_CDSL];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"撤单数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //成分股代码
    NSString* strComCode = @"";
    if (_nMsgType == WT_ETFGPRGCD || _nMsgType == MENU_JY_ETFWX_StockWithdraw || _nMsgType == WT_ETF_HS_GPCD || _nMsgType == MENU_JY_ETFKS_HSStockWithdraw || _nMsgType == WT_ETF_SS_RGCD || _nMsgType == MENU_JY_ETFKS_SSRGWithdraw)
    {
        strComCode = [_ptztCrashTable GetLabelText:kTag_CompCode];
        if (strComCode == NULL || [strComCode length] < 1)
        {
            [self showMessageBox:@"成分股有误！" nType_:TZTBoxTypeNoButton delegate_:nil];
            return FALSE;
        }
    }
    
    //关联账号
    NSString* strCompAccount = @"";
    if ((_nMsgType == WT_ETF_SS_RGCD || _nMsgType == MENU_JY_ETFKS_SSRGWithdraw) && _nCurrentSel >= 0 && _nCurrentSel < [_ayCompAccount count])
    {
        strCompAccount = [_ayCompAccount objectAtIndex:_nCurrentSel];
    }
    
    NSString *nsName = @"";
    nsName = [_ptztCrashTable GetLabelText:kTag_ETFMC];
    
    NSString* strInfo = @"";
    NSString *typestr = @"认购";
    
    switch (_nMsgType)
    {
        case WT_ETFXJRGCD://网下现金撤单
        case MENU_JY_ETFWX_FundWithdraw:
        case WT_ETF_HS_XJCD://沪市现金撤单
        case MENU_JY_ETFKS_HSFundWithdraw:
        {
            strInfo = [NSString stringWithFormat:@"委托账号: %@\r\nETF代码: %@\r\nETF名称: %@\r\n委托数量: %@\r\n\r\n确认%@该证券？", nsAccount, nsCode,nsName,nsAmount,typestr];
        }
            break;
        case WT_ETFGPRGCD://网下股份认购查询撤单
        case MENU_JY_ETFWX_StockWithdraw:
        case WT_ETF_HS_GPCD://沪市现金撤单查询
        case MENU_JY_ETFKS_HSStockWithdraw: //14075  沪市股票撤单
        {
            strInfo = [NSString stringWithFormat:@"委托账号: %@\r\nETF代码: %@\r\nETF名称: %@\r\n委托数量: %@\r\n成份股代码: %@\r\n\r\n确认%@该证券？", nsAccount, nsCode, nsName, nsAmount, strComCode,typestr];
        }
            break;
        case WT_ETF_SS_RGCD://深市网下股份认购查询可撤
        case MENU_JY_ETFKS_SSRGWithdraw: // 14076  深市认购撤单
        {
            strInfo = [NSString stringWithFormat:@"委托账号: %@\r\nETF代码: %@\r\nETF名称: %@\r\n委托数量: %@\r\n成份股代码: %@\r\n关联证券账号: %@\r\n\r\n确认%@该证券？", nsAccount, nsCode, nsName, nsAmount, strComCode, strCompAccount,typestr];
        }
            break;
            
        default:
            break;
    }
   
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:typestr
                   nsOK_:typestr
               nsCancel_:@"取消"];
    
    return TRUE;
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRequestData];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_OK:
        {
            if (_ptztCrashTable)
            {
                if ([self CheckInput])
                {
                    return TRUE;
                }
            }
        }
            break;
        case TZTToolbar_Fuction_Clear:
        {
            [self OnClearData];
            return TRUE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnSendBuySell];
            }
                break;
                
            default:
                break;
        }
    }
}

//添加ipad确定响应方法 //add by xyt 20131114
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnSendBuySell];
            }
                break;                
            default:
                break;
        }
    }
}

//认购
-(void)OnSendBuySell
{
    if (_ptztCrashTable == nil)
        return;
    
    if (_nCurrentSel < 0 || _nCurrentSel >= [_ayAccount count] || _nCurrentSel >= [_ayType count])
        return ;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:_nCurrentSel];
    NSString* nsAccountType = [_ayType objectAtIndex:_nCurrentSel];
    
    //ETF代码
    NSString *nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    if (nsCode == NULL || [nsCode length] < 1)
        return;
    
    //成份股代码
    NSString *strCompCode = @"";
    if (_nMsgType == WT_ETFGPRGCD || _nMsgType == MENU_JY_ETFWX_StockWithdraw || _nMsgType == WT_ETF_HS_GPCD || _nMsgType == MENU_JY_ETFKS_HSStockWithdraw || _nMsgType == WT_ETF_SS_RGCD || _nMsgType == MENU_JY_ETFKS_SSRGWithdraw)
    {
        strCompCode = [_ptztCrashTable GetLabelText:kTag_CompCode];
        if (strCompCode == NULL || [strCompCode length] < 1)
            return;
    }
    
    //关联账号
    NSString* strCompAccount = @"";
    if ((_nMsgType == WT_ETF_SS_RGCD || _nMsgType == MENU_JY_ETFKS_SSRGWithdraw) && _nCurrentSel >= 0 && _nCurrentSel < [_ayCompAccount count])
    {
        strCompAccount = [_ayCompAccount objectAtIndex:_nCurrentSel];
    }
    
    //委托数量
    NSString* nsAmount = [_ptztCrashTable GetEidtorText:kTag_CDSL];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"撤单数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"WTAccount"];
    [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [pDict setTztValue:nsAmount forKey:@"VOLUME"];
    [pDict setTztValue:@"S" forKey:@"DIRECTION"];
    
    NSString* strAction = @"";
    switch (_nMsgType)
    {
        case WT_ETFXJRGCD:  //网下现金撤单
        case MENU_JY_ETFWX_FundWithdraw:
        case WT_ETF_HS_XJCD://沪市现金撤单
        case MENU_JY_ETFKS_HSFundWithdraw:
        {
            strAction = @"667";
        }
            break;
        case WT_ETFGPRGCD://网下股份认购查询撤单
        case MENU_JY_ETFWX_StockWithdraw:
        case WT_ETF_HS_GPCD://沪市现金撤单查询
        case MENU_JY_ETFKS_HSStockWithdraw: //14075  沪市股票撤单
        {
            [pDict setTztValue:strCompCode forKey:@"CompCode"];
            strAction = @"669";
        }
            break;
        case WT_ETF_SS_RGCD://深市网下股份认购查询可撤
        case MENU_JY_ETFKS_SSRGWithdraw: // 14076  深市认购撤单
        {
            [pDict setTztValue:strCompCode forKey:@"CompCode"];
            [pDict setTztValue:strCompAccount forKey:@"JWTACCOUNT"];
            strAction = @"660";
        }
            break;
        default:
            break;
    }
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    
    DelObject(pDict);
    
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo]) 
        return 0;
    
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];
    
    if ([tztBaseTradeView IsExitError:nErrNo])
    {
        [self OnNeedLoginOut];
        if (strError)
            tztAfxMessageBox(strError);
        return 0;
    }
    
    if (nErrNo < 0)
    {
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"667"] || [pParse IsAction:@"669"] || [pParse IsAction:@"660"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self OnClearData];
        return 0;
    }
    
    if ([pParse IsAction:@"672"] || [pParse IsAction:@"671"] || [pParse IsAction:@"673"]) 
    {
        int nStockName = -1;
        int nStockCodeIndex = -1;
        int nAccountIndex = -1;
        int nProamountIndex = -1;
        int nCompCode = -1;
        int nCompName = -1;
        int nMarketindex = -1;
        int nCompaccountindex = -1;
        
        NSString *strIndex = [pParse GetByName:@"StockNameIndex"];
        TZTStringToIndex(strIndex, nStockName);
        
        strIndex = [pParse GetByName:@"StockCodeIndex"];
        TZTStringToIndex(strIndex, nStockCodeIndex);
        
        strIndex = [pParse GetByName:@"AccountIndex"];
        TZTStringToIndex(strIndex, nAccountIndex);
        
        strIndex = [pParse GetByName:@"PROAMOUNTINDEX"];
        TZTStringToIndex(strIndex, nProamountIndex);
        
        strIndex = [pParse GetByName:@"COMPCODEINDEX"];
        TZTStringToIndex(strIndex, nCompCode);
        
        strIndex = [pParse GetByName:@"COMPNAMEINDEX"];
        TZTStringToIndex(strIndex, nCompName);
        
        strIndex = [pParse GetByName:@"Marketindex"];
        TZTStringToIndex(strIndex, nMarketindex);
        
        strIndex = [pParse GetByName:@"Compaccountindex"];
        TZTStringToIndex(strIndex, nCompaccountindex);
        
        if (nStockName < 0)
            return 0;
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        
        if (_ayData == NULL)
            _ayData = NewObject(NSMutableArray);
        [_ayData removeAllObjects];
        
        if (_ayName == NULL)
            _ayName = NewObject(NSMutableArray);
        [_ayName removeAllObjects];
        
        if (_ayAccount == NULL)
            _ayAccount = NewObject(NSMutableArray);
        [_ayAccount removeAllObjects];
        
        if (_ayType == NULL)
            _ayType = NewObject(NSMutableArray);
        [_ayType removeAllObjects];
        
        if (_ayStockNum == NULL)
            _ayStockNum = NewObject(NSMutableArray);
        [_ayStockNum removeAllObjects];
        
        if (_ayCompName == NULL)
            _ayCompName = NewObject(NSMutableArray);
        [_ayCompName removeAllObjects];
        
        if (_ayCompCode == NULL) 
            _ayCompCode = NewObject(NSMutableArray);
        [_ayCompCode removeAllObjects];
        
        if (_ayCompAccount == NULL)
            _ayCompAccount = NewObject(NSMutableArray);
        [_ayCompAccount removeAllObjects];
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSString* strCode = @"";
        NSString* strName = @"";
        NSString* strAccount = @"";
        NSString* strNum = @"";
        NSString* strCompName = @"";
        NSString* strCompCode = @"";
        NSString* strType = @"";
        NSString* strCompAccount = @"";
        for (int i = 1; i < [pGridAy count]; i++)
        {
            NSArray* pAy = [pGridAy objectAtIndex:i];
            
            if(nStockCodeIndex >= 0 && nStockCodeIndex < [pAy count])
                strCode = [pAy objectAtIndex:nStockCodeIndex];
            if (strCode == NULL || [strCode length] <= 0)
                continue;
            
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strCode forKey:@""];
            
            if (nStockName >= 0 && nStockName < [pAy count])
                strName = [pAy objectAtIndex:nStockName];
            if (strName == NULL)
                strName = @"";
            [pDict setTztObject:strName forKey:@""];
            [_ayName addObject:strName];
            
            [_ayData addObject:pDict];
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
            [pAyTitle addObject:strTitle];
            
            if (nAccountIndex >= 0 && nAccountIndex < [pAy count]) 
                strAccount = [pAy objectAtIndex:nAccountIndex];
            if (strAccount == NULL)
                strAccount = @"";
            [_ayAccount addObject:strAccount];
            
            if (nMarketindex >= 0 && nMarketindex < [pAy count])
                strType = [pAy objectAtIndex:nMarketindex];
            if (strType == NULL)
                strType = @"";
            [_ayType addObject:strType];
            
            
            if (nProamountIndex >= 0 && nProamountIndex <[pAy count]) 
                strNum = [pAy objectAtIndex:nProamountIndex];
            if (strNum == NULL)
                strNum = @"";
            [_ayStockNum addObject:strNum];
            
            if (nCompCode >= 0 && nCompCode < [pAy count]) 
                strCompCode = [pAy objectAtIndex:nCompCode];
            if (strCompCode == NULL)
                strCompCode = @"";
            [_ayCompCode addObject:strCompCode];
            
            if (nCompName >= 0 && nCompName < [pAy count])
                strCompName = [pAy objectAtIndex:nCompName];
            if (strCompName == NULL)
                strCompName = @"";
            [_ayCompName addObject:strCompName];
            
            if (nCompaccountindex > 0 && nCompaccountindex < [pAy count]) 
                strCompAccount = [pAy objectAtIndex:nCompaccountindex];
            if (strCompAccount == NULL) 
                strCompAccount = @"";
            [_ayCompAccount addObject:strCompAccount];
            
            DelObject(pDict);
        }
        
        if (_ptztCrashTable && [pAyTitle count] > 0)
        {
            if (_nCurrentSel < 0 || _nCurrentSel >= [pAyTitle count])
                _nCurrentSel = 0;
            //zxl 20131011 默认不显示
            [_ptztCrashTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSel withTag_:kTag_ETFCode bDrop_:YES];
        }
        if ([pAyTitle count] < 1)
        {
            [self showMessageBox:@"查无相关数据!" nType_:TZTBoxTypeNoButton delegate_:nil];
        }
        DelObject(pAyTitle);
    }
    return 1;
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case kTagOK:
        {
            //[self OnSendBuySell];
            if (_ptztCrashTable)
            {
                [self CheckInput];
            }
        }
            break;
        case kTagCannel://返回
        {
            [g_navigationController popViewControllerAnimated:UseAnimated];
            //返回，取消风火轮显示
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIViewController* pTop = g_navigationController.topViewController;
            if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
            {
                g_navigationController.navigationBar.hidden = NO;
                [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

@end
