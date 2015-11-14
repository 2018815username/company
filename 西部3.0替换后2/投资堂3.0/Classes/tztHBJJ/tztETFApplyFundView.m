/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        货币基金(ETF) 认购/申购/赎回 
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztETFApplyFundView.h"

enum
{
    kTagQueryJJ = 1000, //查询基金
    kTagGDZH,           //股东账号
    kTagCode,           //基金代码
    kTagNum,            //份额
    kTagName,           //基金名称
    kTagKYZJ,           //可用资金
    kTagSX,             //上限
    kTagFELabel = 2000, //份额显示label
    kTagSXLabel,        //上限显示label
    
    kTagOK = 10000,     //确定
    kTagClear,          //清空
    KtagCannel,         //返回
};

@implementation tztETFApplyFundView
@synthesize ptztApplyFund = _ptztApplyFund;
@synthesize CurStockName = _CurStockName;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize ayData = _ayData;

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
    DelObject(_ayData);
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
    
    if (_ptztApplyFund == NULL)
    {
        _ptztApplyFund = NewObject(tztUIVCBaseView);
        _ptztApplyFund.tztDelegate = self;
        if (_nMsgType == WT_ETFApplyFundSH || _nMsgType == MENU_JY_FUND_HBShuHui)//货币基金赎回
        {
#ifdef tzt_NewVersion
            _ptztApplyFund.tableConfig = @"tztTradeETF_ApplyFundSH_NewVersion";
#else
            _ptztApplyFund.tableConfig = @"tztTradeETF_ApplyFundSH";
#endif
        }
        else//认购,申购去掉基金查询功能,隐藏掉 modify by xyt 20130822
        {
#ifdef tzt_NewVersion
            _ptztApplyFund.tableConfig = @"tztTradeETF_ApplyFund_NewVersion";
#else
            _ptztApplyFund.tableConfig = @"tztTradeETF_ApplyFund";
#endif
        }
        _ptztApplyFund.frame = rcFrame;
        [self addSubview:_ptztApplyFund];
        [_ptztApplyFund release];
    }else
        _ptztApplyFund.frame = rcFrame;
}

-(void)SetDefaultData
{
    if (_ptztApplyFund == NULL)
        return;
    
    switch (_nMsgType) {
        case WT_ETFApplyFundRG://货币基金认购
            [_ptztApplyFund setLabelText:@"认购金额" withTag_:kTagFELabel];
            [_ptztApplyFund setLabelText:@"认购上限" withTag_:kTagSXLabel];
            [_ptztApplyFund setEditorText:@"" nsPlaceholder_:@"请输入认购金额" withTag_:kTagNum];
            [_ptztApplyFund setComBoxPlaceholder:@"点击查询可认购基金" withTag_:kTagQueryJJ];
            break;
        case WT_ETFApplyFundSG://货币基金(ETF)申购
        case MENU_JY_FUND_HBShenGou://货币基金申购
#ifdef tzt_GLSC
            [_ptztApplyFund setLabelText:@"申购份额" withTag_:kTagFELabel];
            [_ptztApplyFund setEditorText:@"" nsPlaceholder_:@"请输入申购份额" withTag_:kTagNum];
#else
            [_ptztApplyFund setLabelText:@"申购份额" withTag_:kTagFELabel];
            [_ptztApplyFund setEditorText:@"" nsPlaceholder_:@"请输入申购份额" withTag_:kTagNum];
#endif
            [_ptztApplyFund setLabelText:@"申购上限" withTag_:kTagSXLabel];
            [_ptztApplyFund setComBoxPlaceholder:@"点击查询可申购基金" withTag_:kTagQueryJJ];
            break;
        case WT_ETFApplyFundSH://货币基金(ETF)赎回
        case MENU_JY_FUND_HBShuHui://货币基金赎回
        {
            [_ptztApplyFund SetImageHidenFlag:@"TZTRGZJ" bShow_:NO];
            //重新设置表格显示区域
            [_ptztApplyFund OnRefreshTableView];
            [_ptztApplyFund setLabelText:@"赎回份额" withTag_:kTagFELabel];
            [_ptztApplyFund setLabelText:@"赎回上限" withTag_:kTagSXLabel];
            [_ptztApplyFund setEditorText:@"" nsPlaceholder_:@"请输入赎回份额" withTag_:kTagNum];
            [_ptztApplyFund setComBoxPlaceholder:@"点击查询可赎回基金" withTag_:kTagQueryJJ];
        }
            break;            
        default:
            break;
    }
}

-(void)ClearDataWithOutCode
{
    [_ptztApplyFund setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTagGDZH];
    [_ptztApplyFund setEditorText:@"" nsPlaceholder_:nil withTag_:kTagNum];
    [_ptztApplyFund setLabelText:@"" withTag_:kTagName];
    [_ptztApplyFund setLabelText:@"" withTag_:kTagKYZJ];
    [_ptztApplyFund setLabelText:@"" withTag_:kTagSX];
}

-(void)OnClearData
{
    if (_ptztApplyFund == NULL) 
        return;
    
    [_ptztApplyFund setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTagQueryJJ];
    [_ptztApplyFund setEditorText:@"" nsPlaceholder_:nil withTag_:kTagCode];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
    self.CurStockName = @"";
    
    _nCurrentSel = 0;
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagCode:
		{
			if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
                [self OnClearData];//修改清空 modify by xyt 20131114
			}
            //修改清空 modify by xyt 20131114
            if (inputField.text != NULL && inputField.text.length == 6)
			{
                if (self.CurStockCode && [self.CurStockCode compare:inputField.text] != NSOrderedSame)
                {
                    self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                    [self ClearDataWithOutCode];
                }
			}
            else
            {
                self.CurStockCode = @"";
                [self ClearDataWithOutCode];
            }
            
			
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
			}
		}
			break;
		default:
			break;
    }
}

-(void)setStockCode:(NSString*)nsCode
{
    if (nsCode == NULL || [nsCode length] < 6)
        return;
    self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
    if (_ptztApplyFund)
    {
        [_ptztApplyFund setEditorText:nsCode nsPlaceholder_:NULL withTag_:2000];
    }
}

//选中list
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagQueryJJ)
    {
        [self OnSendRequest];        
    }
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTagQueryJJ)
    {
        _nCurrentSel = index;
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            [_ptztApplyFund setEditorText:strCode nsPlaceholder_:nil withTag_:kTagCode];
            //setEdit已经发送了请求,避免重复调用 modify by xyt 20130909
            //[self DealWithStockCode:strCode];
        }
    }
}

//修改函数名称 //modify by xyt 20131029
-(void)OnSendRequest
{
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
    [pDict setTztObject:@"" forKey:@"Stockcode"];
    
    NSString* strAction = @"117";
//    switch (_nMsgType) {
//        case WT_ETFApplyFundRG://货币基金认购
//            strAction = @"117";
//            break;
//        case WT_ETFApplyFundSG://货币基金(ETF)申购641
//            strAction = @"665";
//            break;
//        case WT_ETFApplyFundSH://货币基金(ETF)赎回642
//            strAction = @"137";
//            break;            
//        default:
//            break;
//    }
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
}

//请求数据
-(void)OnRefresh
{
    if (_ptztApplyFund == NULL) 
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX) 
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    if (_nMsgType == WT_ETFApplyFundSH || _nMsgType == MENU_JY_FUND_HBShuHui)//货币基金赎回
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"151" withDictValue:pDict];
    }
    else
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
    DelObject(pDict);
}

-(BOOL)CheckInput
{
    if (_ptztApplyFund == NULL)
        return FALSE;
    
    NSInteger nIndex = [_ptztApplyFund getComBoxSelctedIndex:kTagGDZH];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    
    NSString *nsCode = [_ptztApplyFund GetEidtorText:kTagCode];
    if (nsCode == nil || [nsCode length] < 1) 
    {
        [self showMessageBox:@"请输入基金代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString *typestr = @"认购";
    NSString *eDu  = @"";
    switch (_nMsgType) {
        case WT_ETFApplyFundRG:
        case MENU_JY_FUND_HBRenGou://货币基金认购
        {
            typestr = @"认购";
            eDu = [typestr stringByAppendingString:@"金额输入有误!"];
        }
            break;
        case WT_ETFApplyFundSG:
        case MENU_JY_FUND_HBShenGou://货币基金申购
        {
           typestr = @"申购";
            eDu = [typestr stringByAppendingString:@"份额输入有误!"];
        }
         
            break;
        case WT_ETFApplyFundSH:
        case MENU_JY_FUND_HBShuHui://货币基金赎回
        {
            typestr = @"赎回";
             eDu = [typestr stringByAppendingString:@"份额输入有误!"];
        }
            
            break;
        default:
            break;
    }
    
    //委托数量
    NSString* nsAmount = [_ptztApplyFund GetEidtorText:kTagNum];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:eDu nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString *nsName = [_ptztApplyFund GetLabelText:kTagName];
    if (nsName == NULL)
        nsName = @"";

    
    NSString* strInfo = @"";
    if (_nMsgType ==WT_ETFApplyFundRG) {
    strInfo = [NSString stringWithFormat:@"委托账号:%@\r\n基金代码:%@\r\n基金名称:%@\r\n%@金额:%@\r\n\r\n确认%@？", nsAccount, nsCode, nsName, typestr, nsAmount, typestr];
    }else{
            strInfo = [NSString stringWithFormat:@"委托账号:%@\r\n基金代码:%@\r\n基金名称:%@\r\n%@份额:%@\r\n\r\n确认%@？", nsAccount, nsCode, nsName, typestr, nsAmount, typestr];
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

-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
        return;
    
    UIButton* pButton = (UIButton*)sender;
    NSInteger nTag= pButton.tag;
    
    if ([pButton isKindOfClass:[tztUIButton class]])
    {
        nTag = [((tztUIButton*)pButton).tzttagcode intValue];
    }
    
    switch (nTag)
    {
        case kTagOK://确定
        {
            if (_ptztApplyFund)
            {
                [self CheckInput];
            }
        }
            break;
        case kTagClear://清空
        {
            [self OnClearData];
        }
            break;
        case KtagCannel://返回
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

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRefresh];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_OK:
        {
            if (_ptztApplyFund)
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
    if (_ptztApplyFund == nil)
        return;
    
    NSInteger nIndex = [_ptztApplyFund getComBoxSelctedIndex:kTagGDZH];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return ;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    
    //ETF代码
    NSString *nsCode = [_ptztApplyFund GetEidtorText:kTagCode];
    if (nsCode == NULL || [nsCode length] < 1)
        return;
    
    //委托数量  份额
    NSString* nsAmount = [_ptztApplyFund GetEidtorText:kTagNum];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"认购份额输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }
    
    self.CurStockCode = nsCode;
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
    //[pDict setTztValue:nsPrice forKey:@"PRICE"];
    //[pDict setTztValue:@"B" forKey:@"DIRECTION"];
    
    NSString* strAction = @"";
    switch (_nMsgType) {
        case WT_ETFApplyFundRG://货币基金认购
        case MENU_JY_FUND_HBRenGou: //ruyi add
        {
//            [pDict setTztValue:@"1" forKey:@"PriceType"];
            [pDict setTztValue:@"B" forKey:@"Direction"];
            strAction = @"110";
        }
            break;
        case WT_ETFApplyFundSG://货币基金(ETF)申购641
        case MENU_JY_FUND_HBShenGou://货币基金申购
            strAction = @"641";
            break;
        case WT_ETFApplyFundSH://货币基金(ETF)赎回642
        case MENU_JY_FUND_HBShuHui://货币基金赎回
            strAction = @"642";
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
    
    if ([pParse IsAction:@"110"] ||[pParse IsAction:@"641"] ||[pParse IsAction:@"642"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self OnClearData];
        return 0;
    }
#ifdef IsGLSC
    if ([pParse IsAction:@"137"])
    {
        int nFundCodeIndex = -1;
        int nFundNameIndex = -1;
        int nKYIndex = -1;
        int nJJGSIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"JJDMIndex"];
        TZTStringToIndex(strIndex, nFundCodeIndex);
        
        strIndex = [pParse GetByName:@"JJMCIndex"];
        TZTStringToIndex(strIndex, nFundNameIndex);
        
        strIndex = [pParse GetByName:@"JJKYINDEX"];
        TZTStringToIndex(strIndex, nKYIndex);
        
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, nJJGSIndex);
        
        if (nFundCodeIndex < 0)//代码字段小于0
            return 0;
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        
        if (_ayData == NULL)
            _ayData = NewObject(NSMutableArray);
        [_ayData removeAllObjects];
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSString* strCode = @"";
        NSString* strName = @"";
        //        NSString* strKY = @"";
        //        NSString* strAccount = @"";
        for (int i = 1; i < [pGridAy count]; i++)
        {
            NSArray* pAy = [pGridAy objectAtIndex:i];
            //add
            if (pAy == NULL)
                continue;
            
            int nCount = [pAy count];
            if (nCount < 1 || nFundCodeIndex >= nCount || nFundNameIndex >= nCount)
                continue;
            
            if(nFundCodeIndex >= 0 && nFundCodeIndex < [pAy count])
                strCode = [pAy objectAtIndex:nFundCodeIndex];
            if (strCode == NULL || [strCode length] <= 0)
                continue;
            
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strCode forKey:@""];
            
            if (nFundNameIndex >= 0 && nFundNameIndex < [pAy count])
                strName = [pAy objectAtIndex:nFundNameIndex];
            if (strName == NULL)
                strName = @"";
            [pDict setTztObject:strName forKey:@""];
            
            [_ayData addObject:pDict];
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
            [pAyTitle addObject:strTitle];
            
            DelObject(pDict);
        }
        
        if (_ptztApplyFund && [pAyTitle count] > 0)
        {
            if (_nCurrentSel < 0 || _nCurrentSel >= [pAyTitle count])
                _nCurrentSel = 0;
            [_ptztApplyFund setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSel withTag_:kTagQueryJJ bDrop_:YES];
        }
        
        if ([pAyTitle count] < 1)
        {
            [self showMessageBox:@"查无相关数据!" nType_:TZTBoxTypeNoButton nTag_:0];
        }
        
        DelObject(pAyTitle);
    }
#endif
    if ([pParse IsAction:@"117"])
    {
        int nStockName = -1;
        int nStockCodeIndex = -1;
        int nKYIndex = -1;
        int nAccountIndex = -1;
        
        NSString *strIndex = [pParse GetByName:@"STOCKNAMEINDEX"];
        TZTStringToIndex(strIndex, nStockName);
        
        strIndex = [pParse GetByName:@"StockIndex"];
        TZTStringToIndex(strIndex, nStockCodeIndex);
        
        strIndex = [pParse GetByName:@"KYIndex"];
        TZTStringToIndex(strIndex, nKYIndex);
        
        strIndex = [pParse GetByName:@"AccountIndex"];
        TZTStringToIndex(strIndex, nAccountIndex);
        
        if (nStockName < 0)
            return 0;
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        
        if (_ayData == NULL)
            _ayData = NewObject(NSMutableArray);
        [_ayData removeAllObjects];
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSString* strCode = @"";
        NSString* strName = @"";
//        NSString* strKY = @"";
//        NSString* strAccount = @"";
        for (int i = 1; i < [pGridAy count]; i++)
        {
            NSArray* pAy = [pGridAy objectAtIndex:i];
            //add
            if (pAy == NULL)
                continue;
            
            NSInteger nCount = [pAy count];
            if (nCount < 1 || nStockCodeIndex >= nCount || nStockName >= nCount) 
                continue;
            
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
            
            [_ayData addObject:pDict];
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
            [pAyTitle addObject:strTitle];
            
            DelObject(pDict);
        }
        
        if (_ptztApplyFund && [pAyTitle count] > 0)
        {
            if (_nCurrentSel < 0 || _nCurrentSel >= [pAyTitle count])
                _nCurrentSel = 0;
            [_ptztApplyFund setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSel withTag_:kTagQueryJJ bDrop_:YES];
        }
        
        if ([pAyTitle count] < 1)
        {
            [self showMessageBox:@"查无相关数据!" nType_:TZTBoxTypeNoButton nTag_:0];
        }
        
        DelObject(pAyTitle);
    }
    
    if ([pParse IsAction:@"150"] || [pParse IsAction:@"151"])
    {   
        NSString* strCode = [pParse GetByName:@"StockCode"];
        if (strCode == NULL || [strCode length] <= 0)//错误
            return 0;
        //返回的跟当前的代码不一致
        if ([strCode compare:self.CurStockCode] != NSOrderedSame)
        {
            return 0;
        }
        
        //股票名称
        NSString* strName = [pParse GetByNameUnicode:@"Title"];
        if (strName && [strName length] > 0)
        {
            if (_ptztApplyFund)
                [_ptztApplyFund setLabelText:strName withTag_:kTagName];
        }
#ifndef IsGLSC
        else
        {
            [self showMessageBox:@"该证券代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
#endif
        if (_ayAccount == nil)
            _ayAccount = NewObject(NSMutableArray);
        if (_ayType == nil)
            _ayType = NewObject(NSMutableArray);
        if (_ayStockNum == nil)
            _ayStockNum = NewObject(NSMutableArray);
        
        [_ayAccount removeAllObjects];
        [_ayType removeAllObjects];
        [_ayStockNum removeAllObjects];
        
        if (_ayTypeContent == nil)
            _ayTypeContent = NewObject(NSMutableArray);

        [_ayTypeContent removeAllObjects];
        
        //股东账号及可卖可买
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                NSString* strAccount = [ayData objectAtIndex:0];
                if (strAccount == NULL || [strAccount length] <= 0)
                    continue;
                
                [_ayAccount addObject:strAccount];
                
                NSString* strType = [ayData objectAtIndex:1];
                if (strType == NULL || [strType length] <= 0)
                    strType = @"";
                
                [_ayType addObject:strType];
                
                [_ayTypeContent addObject:[self transType2Content:strType]];

                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayStockNum addObject:strNum];
            }
        }
        
        if (g_pSystermConfig.bTransType2Content)
        {
            [_ptztApplyFund setComBoxData:_ayTypeContent ayContent_:_ayAccount AndIndex_:0 withTag_:kTagGDZH];
        }
        else
        {
            [_ptztApplyFund setComBoxData:_ayAccount ayContent_:_ayAccount AndIndex_:0 withTag_:kTagGDZH];
        }
        
        //可买、可卖显示  认购上限
        if ([_ayStockNum count] > 0)
        {
            NSString* nsValue = tztdecimalNumberByDividingBy([_ayStockNum objectAtIndex:0], 4);
            [_ptztApplyFund setLabelText:nsValue withTag_:kTagSX];
        }
        
        //可用资金
        NSString* nsMoney = [pParse GetByName:@"Banklsh"];//bankvolume
        if (nsMoney == NULL || [nsMoney length] < 1)
        {
            nsMoney = [pParse GetByName:@"Usable"];
            if (nsMoney == NULL || [nsMoney length] < 1)
            {
                nsMoney = [pParse GetByName:@"BankVolume"];
                if (nsMoney == NULL || [nsMoney length] < 1)
                    nsMoney = @"";
            }
        }
        
//        double dMoney = (double)[nsMoney doubleValue];
//        NSString* nsValue = @"";
//        if (dMoney > 100000000)
//            nsValue = [NSString stringWithFormat:@"%.2f亿", (dMoney/100000000)];
//        else if (dMoney > 10000)
//            nsValue = [NSString stringWithFormat:@"%.2f万", (dMoney/10000)];
//        else
//            nsValue = [NSString stringWithFormat:@"%.2f", dMoney];
        
        if (nsMoney == NULL || [nsMoney length] < 1)
            nsMoney = @"";
        
        [_ptztApplyFund setLabelText:nsMoney withTag_:kTagKYZJ];
        
        if (_ptztApplyFund)
        {
            //获取当前界面输入
            NSString* nsName = [_ptztApplyFund GetLabelText:kTagName];
            NSString* nsCode = [_ptztApplyFund GetEidtorText:kTagCode];
            if (nsName && nsCode && [nsCode length] == 6)
            {
                NSString* nsDefault = [NSString stringWithFormat:@"%@(%@)", nsCode, nsName];
                [_ptztApplyFund setComBoxText:nsDefault withTag_:kTagQueryJJ];
            }
        }
    }
    
    return 1;
}

// 将市场类型转换成中文
- (NSString *)transType2Content:(NSString *)string
{
    if ([string isEqualToString:@"SHACCOUNT"]) {
        return @"上海市场A股";
    }
    else if ([string isEqualToString:@"SZACCOUNT"]) {
        return @"深圳市场A股";
    }
    else if ([string isEqualToString:@"SHBACCOUNT"]) {
        return @"上海市场B股";
    }
    else if ([string isEqualToString:@"SZBACCOUNT"]) {
        return @"深圳市场B股";
    }
    else if ([string isEqualToString:@"SBACCOUNT"]) {
        return @"股转市场";
    }
    else if ([string isEqualToString:@"SBBACCOUNT"]) {
        return @"股转市场B股";
    }
    else
        return string;
}

@end
