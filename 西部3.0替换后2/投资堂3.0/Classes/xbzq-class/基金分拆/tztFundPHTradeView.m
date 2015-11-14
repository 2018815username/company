/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金盘后业务 合并、分拆
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztFundPHTradeView.h"

enum
{
    /*编辑框*/
    kTagCode    = 1000,//基金代码
    kTagAmount  = 1001,//委托数量
    /*文本*/
    kTagName    = 2000,//基金名称
    kTagCanUse  = 2001,//可用
    kTagAmountTitle = 2002,
    /*下拉框*/
    kTagAccount = 3000,//账号
    /*按钮*/
    kTagOK      = 5000,//确定
    kTagClear   = 5001,//清空
    kTagRefresh = 5002,//刷新
    kZT  = 2009,
};

#define tztFundPH_Code      @"tztFundPH_Code"
#define tztFundPH_KY        @"tztFundPH_KY"
#define tztFundPH_Account   @"tztFundPH_Account"
#define tztFundPH_AccountType   @"tztFundPH_AccountType"
#define tztFundPH_Name      @"tztFundPH_Name"

@implementation tztFundPHTradeView
@synthesize tztTradeView = _tztTradeView;
@synthesize ayCodeInfo = _ayCodeInfo;
@synthesize ayAccountInfo = _ayAccountInfo;
@synthesize CurStockCode = _CurStockCode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
        _kyData  = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    [[tztMoblieStockComm getShareInstance] addObj:self];
    _ayAccountInfo = NewObject(NSMutableArray);
    _ayCodeInfo = NewObject(NSMutableArray);
    self.CurStockCode = @"";
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayCodeInfo);
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
        [_tztTradeView setTableConfig:@"tztUITradeFunFHSetting"];
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
        if (_nMsgType == WT_FundPH_JJHB || _nMsgType == MENU_JY_FUND_PHMerge)
        {
            [_tztTradeView setLabelText:@"合并数量" withTag_:kTagAmountTitle];
        }
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
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagAmount];
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagAccount];
    [_tztTradeView setComBoxText:@"" withTag_:kTagAccount];
    
    [_tztTradeView setLabelText:@"" withTag_:kTagName];
    [_tztTradeView setLabelText:@"" withTag_:kTagCanUse];
    
    if(_ayAccountInfo)
        [_ayAccountInfo removeAllObjects];
    if (_ayCodeInfo)
        [_ayCodeInfo removeAllObjects];
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
                if (self.CurStockCode && [self.CurStockCode caseInsensitiveCompare:[NSString stringWithFormat:@"%@",inputField.text]] != NSOrderedSame)
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

// 为iPad添加底部button的触发事件 byDBQ20130823
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            [self OnTrade:FALSE];
        }
            break;
        case TZTToolbar_Fuction_Clear:
        {
            [self ClearData];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRefresh];
            return TRUE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}

//选中列表证券账号数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    switch ([droplistview.tzttagcode intValue])
    {
        case kTagAccount:
        {
            [self OnSelectAccountAtIndex:index];
        }
            break;
        default:
            break;
    }
}

-(void)OnSelectAccountAtIndex:(int)nIndex
{
    _nSelectAccount = -1;
    if (nIndex < 0 || nIndex >= [_ayAccountInfo count])
        return;
    if ([_ayAccountInfo count] < 1)
        return;
    
    _nSelectAccount = nIndex;
    NSMutableDictionary *pDict = [_ayAccountInfo objectAtIndex:nIndex];
    if (pDict == NULL)
        return;
    if (_kyData && _kyData.count>0) {
        [_tztTradeView setLabelText:_kyData[_nSelectAccount] withTag_:kTagCanUse];
    }
    //    [self OnInquireFundCanUse:pDict];
    
}

//按钮事件处理
-(void)OnButtonClick:(id)sender
{
    tztUIButton *pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case kTagOK:
        {
            [self OnTrade:FALSE];
        }
            break;
        case kTagClear:
        {
            [self ClearData];
        }
            break;
        case kTagRefresh:
        {
            [self OnRefresh];
        }
            break;
        default:
            break;
    }
}

//对话框事件处理
- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
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

// iPad确定框 byDBQ20130823
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

/*
 
 */
-(void)OnRequestData
{
    [self OnRefresh];
}

/*
 请求证券代码信息
 */
-(void)OnRefresh
{
    if (_tztTradeView == NULL)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    if (_nMsgType == WT_FundPH_JJZH)
    {
        [pDict setTztValue:@"0" forKey:@"StartPos"];
        [pDict setTztValue:@"1000" forKey:@"MaxCount"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"137" withDictValue:pDict];
    }
    else
    {
        NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
        if (nsCode.length == 6)
        {
            [pDict setTztValue:nsCode forKey:@"StockCode"];
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
        }
    }
    DelObject(pDict);
}

/*
 查询可用
 */
-(void)OnInquireFundCanUse:(NSMutableDictionary*)pDict
{
    if (_tztTradeView == NULL)
        return;
    if (_nMsgType == WT_FundPH_JJFC || _nMsgType == MENU_JY_FUND_PHSplit
        || _nMsgType == WT_FundPH_JJHB || _nMsgType == MENU_JY_FUND_PHMerge)
    {
        NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
        if (nsCode.length == 6)
        {
            NSString* nsAccount = @"";
            NSString* nsAccountType = @"";
            if (pDict)
            {
                nsAccount = [pDict tztObjectForKey:tztFundPH_Account];
                nsAccountType = [pDict tztObjectForKey:tztFundPH_AccountType];
            }
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            _ntztReqNo++;
            if(_ntztReqNo >= UINT16_MAX)
                _ntztReqNo = 1;
            
            NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
            [pDict setTztValue:strReqno forKey:@"Reqno"];
            [pDict setTztValue:nsCode forKey:@"StockCode"];
            [pDict setTztValue:nsAccount forKey:@"WTAccount"];
            [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
            
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"151" withDictValue:pDict];
            DelObject(pDict);
        }
    }
}

-(void)onqurest:(NSMutableDictionary*)pDict
{
    if (_tztTradeView == NULL)
        return;
    if (_nMsgType == WT_FundPH_JJFC || _nMsgType == MENU_JY_FUND_PHSplit
        || _nMsgType == WT_FundPH_JJHB || _nMsgType == MENU_JY_FUND_PHMerge)
    {
        NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
        if (nsCode.length == 6)
        {
            NSString* nsAccount = @"";
            NSString* nsAccountType = @"";
            if (pDict)
            {
                nsAccount = [pDict tztObjectForKey:tztFundPH_Account];
                nsAccountType = [pDict tztObjectForKey:tztFundPH_AccountType];
            }
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            _ntztReqNo++;
            if(_ntztReqNo >= UINT16_MAX)
                _ntztReqNo = 1;
            
            NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
            [pDict setTztValue:strReqno forKey:@"Reqno"];
            [pDict setTztValue:nsCode forKey:@"StockCode"];
            [pDict setTztValue:nsAccount forKey:@"WTAccount"];
            [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
            
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"6031" withDictValue:pDict];
            DelObject(pDict);
        }
    }
}
-(void)OnTrade:(BOOL)bSend
{
    if (_tztTradeView == NULL)
        return;
    NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
    if (nsCode.length < 6)
    {
        [self showMessageBox:@"基金代码不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSString* nsAmount = [_tztTradeView GetEidtorText:kTagAmount];
    if ([nsAmount floatValue] < 0.01)
    {
        [self showMessageBox:@"委托数量输入不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    
    if (!bSend)
    {
        NSString* nsName = [_tztTradeView GetLabelText:kTagName];
        if (nsName == NULL)
            nsName = @"";
        
        NSString* nsAccount = [_tztTradeView getComBoxText:kTagAccount];
        if (nsAccount == NULL)
            nsAccount = @"";
        
        NSString *strMsg = @"";
        if (_nMsgType == WT_FundPH_JJFC || _nMsgType == MENU_JY_FUND_PHSplit)
        {
            strMsg = [NSString stringWithFormat:@" 基金代码:%@\r\n 基金名称:%@\r\n 股东代码:%@\r\n 分拆数量:%@\r\n 确认操作？", nsCode, nsName, nsAccount, nsAmount];
            [self showMessageBox:strMsg nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self withTitle_:@"基金分拆"];
        }
        if (_nMsgType == WT_FundPH_JJHB || _nMsgType == MENU_JY_FUND_PHMerge)
        {
            strMsg = [NSString stringWithFormat:@" 基金代码:%@\r\n 基金名称:%@\r\n 股东代码:%@\r\n 合并数量:%@\r\n 确认操作？", nsCode, nsName, nsAccount, nsAmount];
            [self showMessageBox:strMsg nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self withTitle_:@"基金合并"];
        }
        return;
    }
    else
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqNo++;
        if(_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        
        NSString* nsAccount = @"";
        NSString* nsAccountType = @"";
        if (_nSelectAccount >= 0 && _nSelectAccount < [_ayAccountInfo count])
        {
            NSMutableDictionary *pDict = [_ayAccountInfo objectAtIndex:_nSelectAccount];
            if (pDict)
            {
                nsAccount = [pDict tztObjectForKey:tztFundPH_Account];
                nsAccountType = [pDict tztObjectForKey:tztFundPH_AccountType];
            }
        }
        [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
        [pDict setTztValue:nsAccount forKey:@"WTAccount"];
        
        [pDict setTztValue:nsCode forKey:@"StockCode"];
        [pDict setTztValue:nsAmount forKey:@"Volume"];
        
        if (_nMsgType == WT_FundPH_JJHB || _nMsgType == MENU_JY_FUND_PHMerge)
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"632" withDictValue:pDict];
        }
        if (_nMsgType == WT_FundPH_JJFC || _nMsgType == MENU_JY_FUND_PHSplit)
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"633" withDictValue:pDict];
        }
        DelObject(pDict);
    }
    
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    //    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
    //        return 0;
    
    NSString* strErrMsg = [pParse GetErrorMessage];
    int nErrNo = [pParse GetErrorNo];
    
    if (nErrNo < 0)
    {
        if ([tztBaseTradeView IsExitError:nErrNo])
        {
            [self OnNeedLoginOut];
        }
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        return 0;
    }
    
    if ([pParse IsAction:@"150"])
    {
        NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
        if (nsCode == NULL || nsCode.length < 6)
            return 0;
        
        NSString* nsCurrentCode = [pParse GetByName:@"StockCode"];
        if (nsCurrentCode == NULL)
            return 0;
        if ([[nsCurrentCode uppercaseString] compare:[nsCode uppercaseString]] != NSOrderedSame)
            return 0;
        
        NSString* nsName = [pParse GetByName:@"Title"];
        if (nsName == NULL)
            nsName = @"";
        
        [_tztTradeView setLabelText:nsName withTag_:kTagName];
        if (_ayAccountInfo == NULL)
            _ayAccountInfo = NewObject(NSMutableArray);
        [_ayAccountInfo removeAllObjects];
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        NSMutableArray  *ayAccount = NewObject(NSMutableArray);
        NSMutableArray  *ayAccountType = NewObject(NSMutableArray);
        for (int i = 1; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL || [ayData count] < 3)
                continue;
            
            NSString* nsAccount = [ayData objectAtIndex:0];
            NSString* nsAccounType = [ayData objectAtIndex:1];
            if (nsAccount == NULL || nsAccount.length < 1)
                continue;
            if (nsAccounType == NULL)
                nsAccounType = @"";
            
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztValue:nsAccounType forKey:tztFundPH_AccountType];
            [pDict setTztValue:nsAccount forKey:tztFundPH_Account];
            [_ayAccountInfo addObject:pDict];
            [ayAccount addObject:nsAccount];
            [ayAccountType addObject:nsAccounType];
            DelObject(pDict)
        }
        [_tztTradeView setComBoxData:ayAccount ayContent_:ayAccountType AndIndex_:0 withTag_:kTagAccount];
        NSMutableDictionary *pDict = [_ayAccountInfo objectAtIndex:0];
        if (pDict) {
            [self OnInquireFundCanUse:pDict];
            [self onqurest:pDict];
        }
        [self OnSelectAccountAtIndex:0];
        
        [ayAccount release];
        [ayAccountType release];
    }
    else if([pParse IsAction:@"137"])
    {
    }
    
    else if ([pParse IsAction:@"6031"]){
        NSString* ic = [pParse GetByName:@"MSTATUSNAMEINDEX"];
        int icc = 0;
        TZTStringToIndex(ic,icc);
        NSString* str = @"";
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 1; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData.count >= icc) {
                str  = ayData[icc];
            }
            
        }
        if (str.length<2) {
            str =@"合并状态名称";
        }
        
        //MSTATUSNAMEINDEX
        [_tztTradeView setLabelText:str withTag_:kZT];
        //         [_tztTradeView setEditorText:str nsPlaceholder_:@"" withTag_:kZT];
        
    }
    else if ([pParse IsAction:@"151"])
    {
        //        NSString* nsData = @"";
        //        if (_nMsgType == WT_FundPH_JJHB || _nMsgType == MENU_JY_FUND_PHMerge)
        //        {
        //            nsData = [pParse GetByName:@"Merge_amount"];
        //        }
        //        if (_nMsgType == WT_FundPH_JJFC || _nMsgType == MENU_JY_FUND_PHSplit)
        //        {
        //            nsData = [pParse GetByName:@"Split_amount"];
        //        }
        
        [_kyData removeAllObjects];
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 1; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL || [ayData count] < 3)
                continue;
            [_kyData addObject:ayData[2]];
            
        }
        
        //        if (nsData == NULL || nsData.length < 1)
        //            nsData = @"0";
        
        [_tztTradeView setLabelText:_kyData[_nSelectAccount] withTag_:kTagCanUse];
    }
    else
    {
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        [self ClearData];
    }
    return 1;
}
@end
