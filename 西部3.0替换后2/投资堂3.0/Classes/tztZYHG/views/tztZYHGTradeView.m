/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        质押回购交易界面
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztZYHGTradeView.h"

enum
{
    /*编辑框*/
    kTagCode    = 1000, //代码
    kTagPrice   = 1001, //价格（债券入库出库时，不可编辑，融资回购，融券回购时可编辑）
    kTagAmount  = 1002, //委托数量
    
    /*文本框*/
    kTagName    = 2000, //名称
    kTagAccount = 2001, //证券账号(债券入库出库时使用)
    kTagCodeIn  = 2002, //入库，出库代码
    kTagCanUse  = 2003, //可用数量
    
    /*特殊处理：左侧标题文字可变*/
    kTagCanUseTitle = 2100,
    kTagAmountTitle = 2101,
    
    /*下拉框*/
    kTagZQZH    = 3000, //融资，融券回购时，可选择委托账号
    
    /*按钮*/
    kTagOK      = 5000, //确定按钮
    kTagClear   = 5001, //重填，清空按钮
    kTagRefresh = 5002, //刷新
};

#define tztAccount      @"tztAccount"
#define tztAccountType  @"tztAccountType"
#define tztStockNum     @"tztStockNum"

@implementation tztZYHGTradeView
@synthesize tztTradeView = _tztTradeView;
@synthesize CurStockCode = _CurStockCode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

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
    DelObject(_ayAccountInfo);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    
    if (IS_TZTIPAD)
    {
        // 不加点击底部btn没反应 byDBQ20130823
        if(!_pTradeToolBar.hidden)
        {
            rcFrame.size.height -= _pTradeToolBar.frame.size.height;
        }
    }
    
    if (_tztTradeView == nil)
    {
        _tztTradeView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeView.tztDelegate = self;
        switch (_nMsgType)
        {
            case WT_ZYHG_ZQRK:
            case MENU_JY_ZYHG_StockBuy:
            {
                [_tztTradeView setTableConfig:@"tztUITradeZYHG_ZQRKSetting"];
            }
                break;
            case WT_ZYHG_ZQCK:
            case MENU_JY_ZYHG_StockSell:
            {
                [_tztTradeView setTableConfig:@"tztUITradeZYHG_ZQCKSetting"];
            }
                break;
            case WT_ZYHG_RZHG:
            case MENU_JY_ZYHG_RZBuy:
            {
                [_tztTradeView setTableConfig:@"tztUITradeZYHG_RZHGSetting"];
            }
                break;
            case WT_ZYHG_RQHG:
            case MENU_JY_ZYHG_RQBuy:
            {
                [_tztTradeView setTableConfig:@"tztUITradeZYHG_RQHGSetting"];
            }
                break;
            default:
                break;
        }
        
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
    {
        _tztTradeView.frame = rcFrame;
    }
}

-(void)ClearData
{
    if (_tztTradeView == NULL)
        return;
    
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagCode];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
}

-(void)ClearDataWithOutCode
{
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagPrice];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagAmount];
    
    [_tztTradeView setLabelText:@"" withTag_:kTagName];
    [_tztTradeView setLabelText:@"" withTag_:kTagAccount];
    [_tztTradeView setLabelText:@"" withTag_:kTagCodeIn];
    [_tztTradeView setLabelText:@"" withTag_:kTagCanUse];
    
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagZQZH];
    [_tztTradeView setComBoxText:@"" withTag_:kTagZQZH];
    
    if (_ayAccountInfo)
        [_ayAccountInfo removeAllObjects];
}

/*
 输入框数据改变响应事件处理
 */
-(void)tztUIBaseView:(UIView*)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagCode:
        {
            /*清空股票代码后，清空界面数据*/
            if (text == NULL || text.length <= 0)
            {
                [self ClearData];
                return;
            }
            
            if (inputField.text != NULL && inputField.text.length == 6)
            {
                if (self.CurStockCode && [self.CurStockCode caseInsensitiveCompare:inputField.text] != NSOrderedSame)
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
            
            if (text.length == 6)
            {
                [self OnRefresh];
            }
        }
            break;
            
        default:
            break;
    }
    
}

//选中列表证券账号数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    switch ([droplistview.tzttagcode intValue])
    {
        case kTagZQZH:
        {
            [self OnSelectAccountAtIndex:index];
        }
            break;
        default:
            break;
    }
}
// iPad确定框 byZXL20130925
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnTrade:TRUE];
            }
                break;
                
            default:
                break;
        }
    }
}

//对话框确定处理
- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag) {
            case 0x1111:
                [self OnTrade:TRUE];
                break;
                
            default:
                break;
        }
    }
}

//按钮事件处理
-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case kTagOK://确定
        {
            [self OnTrade:FALSE];
        }
            break;
        case kTagClear://清空
        {
            [self ClearData];
        }
            break;
        case kTagRefresh://刷新
        {
            [self OnRefresh];
            break;
        }
        default:
            break;
    }
}

/*
 请求证券代码对应信息
 */
-(void)OnRefresh
{
    if (_tztTradeView == NULL)
        return;
    
    NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
    if (nsCode.length < 6)
    {
        [self showMessageBox:@"请输入证券的证券代码!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    
    if (_nMsgType == WT_ZYHG_ZQRK || _nMsgType == MENU_JY_ZYHG_StockBuy)
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"607" withDictValue:pDict];
    }
    else if(_nMsgType == WT_ZYHG_ZQCK || _nMsgType == MENU_JY_ZYHG_StockSell)
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"608" withDictValue:pDict];
    }
    else
    {
        [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
        [pDict setTztValue:@"1" forKey:@"StartPos"];
        [pDict setTztValue:@"1" forKey:@"NeedCheck"];
        [pDict setTztValue:@"100" forKey:@"Maxcount"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
    }
    DelObject(pDict);
}

/*
 提交质押回购请求
 bSend  －是否发送数据
 */
-(void)OnTrade:(BOOL)bSend
{
    if (_tztTradeView == NULL)
        return;
    
    NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
    if (nsCode.length < 6)
    {
        [self showMessageBox:@"请输入证券代码!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
    if (nsPrice.length < 1 || [nsPrice floatValue] < 0.01)
    {
        [self showMessageBox:@"请输入委托价格!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    NSString* nsAmount = [_tztTradeView GetEidtorText:kTagAmount];
    if (nsAmount.length < 1 || [nsAmount intValue] <= 0)
    {
        [self showMessageBox:@"请输入委数量!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSString* nsName = [_tztTradeView GetLabelText:kTagName];
    if (nsName == NULL)
        nsName = @"";
    NSString* nsAccount = [_tztTradeView GetLabelText:kTagAccount];
    if (_nMsgType == WT_ZYHG_RZHG || _nMsgType == MENU_JY_ZYHG_RZBuy
        || _nMsgType == WT_ZYHG_RQHG || _nMsgType == MENU_JY_ZYHG_RQBuy)
        nsAccount = [_tztTradeView getComBoxText:kTagZQZH];
    if (nsAccount == NULL)
        nsAccount = @"";
    
    NSString* nsCodeIn = [_tztTradeView GetLabelText:kTagCodeIn];
    if (nsCodeIn.length < 1)
    {
        if (_nMsgType == WT_ZYHG_ZQRK || _nMsgType == MENU_JY_ZYHG_StockBuy)
        {
            [self showMessageBox:@"入库代码为空,请重新刷新数据!" nType_:TZTBoxTypeNoButton delegate_:nil];
            return;
        }
        if (_nMsgType == WT_ZYHG_ZQCK || _nMsgType == MENU_JY_ZYHG_StockSell)
        {
            [self showMessageBox:@"出库代码为空,请重新刷新数据!" nType_:TZTBoxTypeNoButton delegate_:nil];
            return;
        }
    }
    
    if (!bSend)
    {
        NSString* strMsg = @"";
        if (_nMsgType == WT_ZYHG_ZQRK || _nMsgType == MENU_JY_ZYHG_StockBuy)
        {
            strMsg = [NSString stringWithFormat:@" 证券代码:%@\r\n 证券名称:%@\r\n 证券账号:%@\r\n 入库代码:%@\r\n 入库数量:%@\r\n 确认委托？", nsCode, nsName, nsAccount, nsCodeIn, nsAmount];
        }
        else if (_nMsgType == WT_ZYHG_ZQCK || _nMsgType == MENU_JY_ZYHG_StockSell)
        {
            strMsg = [NSString stringWithFormat:@" 证券代码:%@\r\n 证券名称:%@\r\n 证券账号:%@\r\n 出库代码:%@\r\n 入库数量:%@\r\n 确认委托？", nsCode, nsName, nsAccount, nsCodeIn, nsAmount];
        }
        else if (_nMsgType == WT_ZYHG_RZHG || _nMsgType == MENU_JY_ZYHG_RZBuy)
        {
            strMsg = [NSString stringWithFormat:@" 证券代码:%@\r\n 证券名称:%@\r\n 证券账号:%@\r\n 融资价格:%@\r\n 融资数量:%@\r\n 确认委托？", nsCode, nsName, nsAccount, nsPrice, nsAmount];
        }
        else if (_nMsgType == WT_ZYHG_RQHG || _nMsgType == MENU_JY_ZYHG_RQBuy)
        {
            strMsg = [NSString stringWithFormat:@" 证券代码:%@\r\n 证券名称:%@\r\n 证券账号:%@\r\n 融券价格:%@\r\n 融券数量:%@\r\n 确认委托？", nsCode, nsName, nsAccount, nsPrice, nsAmount];
        }
    
        [self showMessageBox:strMsg nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self];
    }
    else
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        
        if (_nMsgType == WT_ZYHG_ZQRK || _nMsgType == MENU_JY_ZYHG_StockBuy
            || _nMsgType == WT_ZYHG_ZQCK || _nMsgType == MENU_JY_ZYHG_StockSell)
            [pDict setTztValue:nsCodeIn forKey:@"StockCode"];
        else
            [pDict setTztValue:nsCode forKey:@"StockCode"];
        
        [pDict setTztValue:nsPrice forKey:@"Price"];
        [pDict setTztValue:nsAmount forKey:@"Volume"];
        
        NSString* strAction = @"";
        switch (_nMsgType)
        {
            case WT_ZYHG_ZQCK:
            case MENU_JY_ZYHG_StockSell:
                strAction = @"601";
                break;
            case WT_ZYHG_ZQRK:
            case MENU_JY_ZYHG_StockBuy:
                strAction = @"600";
                break;
            case WT_ZYHG_RZHG:
            case MENU_JY_ZYHG_RZBuy:
                strAction = @"602";
                break;
            case WT_ZYHG_RQHG:
            case MENU_JY_ZYHG_RQBuy:
                strAction = @"603";
                break;
            default:
                break;
        }
        
        [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
        DelObject(pDict);
    }
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return  0;
    
    NSString* strErrMsg = [pParse GetErrorMessage];
    int nErrNo = [pParse GetErrorNo];
    if (nErrNo < 0)
    {
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        if ([tztBaseTradeView IsExitError:nErrNo])
        {
            [self OnNeedLoginOut];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"607"] || [pParse IsAction:@"608"])
    {
        //取索引
        NSString* strIndex = nil;
        int nAccountIndex = -1;
        int nStockCodeIndex = -1;
        int nStockNameIndex = -1;
        int nStockCodeInOutIndex = -1;
        int nUseableIndex = -1;
        int nWTAccountTypeIndex = -1;
        
        strIndex = [pParse GetByName:@"AccountIndex"];
        TZTStringToIndex(strIndex, nAccountIndex);
        
        strIndex = [pParse GetByName:@"StockCodeIndex"];
        TZTStringToIndex(strIndex, nStockCodeIndex);
        
        strIndex = [pParse GetByName:@"StockNameIndex"];
        TZTStringToIndex(strIndex, nStockNameIndex);
        
        if (_nMsgType == WT_ZYHG_ZQRK || _nMsgType == MENU_JY_ZYHG_StockBuy)
            strIndex = [pParse GetByName:@"StockCodeInIndex"];
        else
            strIndex = [pParse GetByName:@"StockCodeOutIndex"];
        TZTStringToIndex(strIndex, nStockCodeInOutIndex);
        
        strIndex = [pParse GetByName:@"UseableIndex"];
        TZTStringToIndex(strIndex, nUseableIndex);
        
        strIndex = [pParse GetByName:@"WTAccountTypeIndex"];
        TZTStringToIndex(strIndex, nWTAccountTypeIndex);
        
        int nMin = MIN(nAccountIndex, MIN(nStockCodeIndex, MIN(nStockNameIndex, MIN(nStockCodeInOutIndex, MIN(nUseableIndex, nWTAccountTypeIndex)))));
        int nMax = MAX(nAccountIndex, MAX(nStockCodeIndex, MAX(nStockNameIndex, MAX(nStockCodeInOutIndex, MAX(nUseableIndex, nWTAccountTypeIndex)))));
        
        if (nMin < 0 || _tztTradeView == NULL)
            return 0;
        
        NSString* nsCurrentCode = [_tztTradeView GetEidtorText:kTagCode];
        nsCurrentCode = [nsCurrentCode uppercaseString];
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 1; i < [ayGrid count]; i++)
        {
            NSArray* ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL || [ayData count] < 1 || nMax >= [ayData count])
                continue;
            //先判断界面显示的代码是否和返回一致
            NSString* nsCode = [ayData objectAtIndex:nStockCodeIndex];
            if ([[nsCode uppercaseString] compare:nsCurrentCode] != NSOrderedSame)
                continue;
            
            NSString* nsName = [ayData objectAtIndex:nStockNameIndex];
            NSString* nsCodeInOut = [ayData objectAtIndex:nStockCodeInOutIndex];
            NSString* nsAccount = [ayData objectAtIndex:nAccountIndex];
            NSString* nsUseable = [ayData objectAtIndex:nUseableIndex];
            NSString* nsAccountType = [ayData objectAtIndex:nWTAccountTypeIndex];
            
            [_tztTradeView setLabelText:nsName withTag_:kTagName];
            [_tztTradeView setLabelText:nsAccount withTag_:kTagAccount];
            [_tztTradeView setLabelText:nsCodeInOut withTag_:kTagCodeIn];
            [_tztTradeView setLabelText:nsUseable withTag_:kTagCanUse];
            [_tztTradeView setEditorText:@"1" nsPlaceholder_:NULL withTag_:kTagPrice];
            
            
            if (nsAccountType && [nsAccountType length] > 0)
            {
                nsAccountType = [nsAccountType uppercaseString];
                if ([nsAccountType hasPrefix:@"SZ"])//深证
                {
                    if (_nMsgType == WT_ZYHG_ZQRK || _nMsgType == MENU_JY_ZYHG_StockBuy)
                    {
                        [_tztTradeView setLabelText:@"可入数量(张)" withTag_:kTagCanUseTitle];
                        [_tztTradeView setLabelText:@"入库数量(张)" withTag_:kTagAmountTitle];
                    }
                    else if(_nMsgType == WT_ZYHG_ZQCK || _nMsgType == MENU_JY_ZYHG_StockSell)
                    {
                        [_tztTradeView setLabelText:@"可出数量(张)" withTag_:kTagCanUseTitle];
                        [_tztTradeView setLabelText:@"出库数量(张)" withTag_:kTagAmountTitle];
                    }
                }
                else
                {
                    if (_nMsgType == WT_ZYHG_ZQRK || _nMsgType == MENU_JY_ZYHG_StockBuy)
                    {
                        [_tztTradeView setLabelText:@"可入数量(手)" withTag_:kTagCanUseTitle];
                        [_tztTradeView setLabelText:@"入库数量(手)" withTag_:kTagAmountTitle];
                    }
                    else if(_nMsgType == WT_ZYHG_ZQCK || _nMsgType == MENU_JY_ZYHG_StockSell)
                    {
                        [_tztTradeView setLabelText:@"可出数量(手)" withTag_:kTagCanUseTitle];
                        [_tztTradeView setLabelText:@"出库数量(手)" withTag_:kTagAmountTitle];
                    }
                }
            }
            break;
        }
    }
    
    else if ([pParse IsAction:@"150"])
    {
        //首先比较显示代码和服务器返回代码是否一致
        NSString* nsCurrentCode = [_tztTradeView GetEidtorText:kTagCode];
        nsCurrentCode = [nsCurrentCode uppercaseString];
        
        NSString* nsCode = [pParse GetByName:@"StockCode"];
        nsCode = [nsCode uppercaseString];
        if ([nsCode compare:nsCurrentCode] != NSOrderedSame)
            return 0;
        
        if (_ayAccountInfo == NULL)
            _ayAccountInfo = NewObject(NSMutableArray);
        [_ayAccountInfo removeAllObjects];
        
        NSString* nsName = [pParse GetByName:@"Title"];
        
        NSString* nsPrice = [pParse GetByName:@"ContactID"];
        if (nsPrice == NULL || nsPrice.length <= 0)
            nsPrice = [pParse GetByName:@"Price"];
        
        NSString *nsDot = [pParse GetByName:@"Volume"];
        int nDotValue = [nsDot intValue];
        
        [_tztTradeView setEditorDotValue:nDotValue withTag_:kTagPrice];
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        
        NSMutableArray *ayAccount = NewObject(NSMutableArray);
        NSMutableArray *ayAccountType = NewObject(NSMutableArray);
        for (int i = 0; i < [ayGrid count]; i++)
        {
            NSArray *tempAy = [ayGrid objectAtIndex:i];
            if([tempAy count] < 3)
                continue;
            
            NSString* nsAccount = [tempAy objectAtIndex:0];
            if (nsAccount.length < 1)
                continue;
            NSString* nsAccountType = [tempAy objectAtIndex:1];
            if (nsAccountType == NULL)
                nsAccountType = @"";
            NSString* nsStockNum = [tempAy objectAtIndex:2];
            if (nsStockNum  == NULL)
                nsStockNum = @"";
            
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztValue:nsAccount forKey:tztAccount];
            [pDict setTztValue:nsAccountType forKey:tztAccountType];
            [pDict setTztValue:nsStockNum forKey:tztStockNum];
            
            [ayAccount addObject:nsAccount];
            [ayAccountType addObject:nsAccountType];
            [_ayAccountInfo addObject:pDict];
            DelObject(pDict);
        }
        
        if ([_ayAccountInfo count] > 0)
        {
            [_tztTradeView setLabelText:nsName withTag_:kTagName];
            [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:kTagPrice];
            [_tztTradeView setComBoxData:ayAccount ayContent_:ayAccountType AndIndex_:0 withTag_:kTagZQZH];
            [self OnSelectAccountAtIndex:0];
        }
        DelObject(ayAccountType);
        DelObject(ayAccount);
    }
    else if ([pParse IsAction:@"600"] || [pParse IsAction:@"601"] || [pParse IsAction:@"602"] || [pParse IsAction:@"603"])
    {
        if (strErrMsg.length > 0)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        else
            [self showMessageBox:@"委托处理成功!" nType_:TZTBoxTypeNoButton delegate_:nil];
        
        [self ClearData];
    }
    return 1;
}

-(void)OnSelectAccountAtIndex:(int)nIndex
{
    if (nIndex < 0 || nIndex >= [_ayAccountInfo count])
        nIndex = 0;
    if ([_ayAccountInfo count] < 1)
        return;
    
    NSMutableDictionary *pDict = [_ayAccountInfo objectAtIndex:nIndex];
    NSString* nsAccount = [pDict tztObjectForKey:tztAccount];
    NSString* nsAccountType = [pDict tztObjectForKey:tztAccountType];
    NSString* nsStockNum = [pDict tztObjectForKey:tztStockNum];
    
    nsAccountType = [nsAccountType uppercaseString];
    if ([nsAccountType hasPrefix:@"SZ"])
    {
        if (_nMsgType == WT_ZYHG_RQHG || _nMsgType == MENU_JY_ZYHG_RQBuy)
        {
            [_tztTradeView setLabelText:@"可融数量(张)" withTag_:kTagCanUseTitle];
            [_tztTradeView setLabelText:@"融券数量(张)" withTag_:kTagAmountTitle];
        }
        if (_nMsgType == WT_ZYHG_RZHG || _nMsgType == MENU_JY_ZYHG_RZBuy)
        {
            [_tztTradeView setLabelText:@"可融数量(张)" withTag_:kTagCanUseTitle];
            [_tztTradeView setLabelText:@"融资数量(张)" withTag_:kTagAmountTitle];
        }
    }
    else
    {
        if (_nMsgType == WT_ZYHG_RQHG || _nMsgType == MENU_JY_ZYHG_RQBuy)
        {
            [_tztTradeView setLabelText:@"可融数量(手)" withTag_:kTagCanUseTitle];
            [_tztTradeView setLabelText:@"融券数量(手)" withTag_:kTagAmountTitle];
        }
        if (_nMsgType == WT_ZYHG_RZHG || _nMsgType == MENU_JY_ZYHG_RZBuy)
        {
            [_tztTradeView setLabelText:@"可融数量(手)" withTag_:kTagCanUseTitle];
            [_tztTradeView setLabelText:@"融资数量(手)" withTag_:kTagAmountTitle];
        }
    }
    
    nsStockNum = tztdecimalNumberByDividingBy(nsStockNum, 2);
    
    [_tztTradeView setLabelText:nsStockNum withTag_:kTagCanUse];
    [_tztTradeView setComBoxText:nsAccount withTag_:kTagZQZH];
}
@end
