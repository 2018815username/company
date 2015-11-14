/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        报价回购买入(新开回购)
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztBJHGOpenView.h"

enum
{
    /*输入框*/
    kTagCode    = 1000,     //证券代码
    kTagPrice   = 1001,     //委托金额
    /*label*/
    kTagName    = 2000,     //证券名称
    kTagYE      = 2001,     //可用余额
    kTagMin     = 2002,     //最小买入金额
    kTagQX      = 2003,     //期限
    kTagDQSY    = 2004,     //到期年收益率
    kTagTQSY    = 2005,     //提前终止年受益率
    kTagWYED    = 2006,     //未用额度
    /*选择框*/
    kTagZQ      = 3000,     //展期
    /*下拉选择框*/
    kTagZZRQ    = 4000,     //终止日期
    /*按钮*/
    kTagOK      = 5000,     //确定
    kTagClear   = 5001,     //清空
    kTagRefresh = 5002,     //刷新
};

@interface tztBJHGOpenView()
-(void)DealInquireStockData:(NSArray*)ayData;
-(void)SendYE;
-(void)OnTrade:(BOOL)bSend;
@end

@implementation tztBJHGOpenView

@synthesize tztTableView = _tztTableView;
@synthesize ayAccountInfo = _ayAccountInfo;
@synthesize CurStockCode = _CurStockCode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(id) init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _ayAccountInfo = NewObject(NSMutableArray);
        self.CurStockCode = @"";
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
    
    if (!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_tztTableView == nil)
    {
        _tztTableView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTableView.tztDelegate = self;
        [_tztTableView setTableConfig:@"tztUITradeBJHGOpenSetting"];
        [self addSubview:_tztTableView];
        [_tztTableView release];
        
        [_tztTableView setCheckBoxValue:NO withTag_:kTagZQ];
        
        NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        [dateformatter setTimeZone:tz];
        [dateformatter setDateFormat:@"yyyyMMdd"];
        NSString* strDate = [dateformatter stringFromDate:[NSDate date]];
        [_tztTableView setComBoxText:strDate withTag_:kTagZZRQ];
        [dateformatter release];
    }
    else
    {
        _tztTableView.frame = rcFrame;
    }
}

-(void)ClearData
{
    if (_tztTableView == NULL)
        return;
    
    [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagCode];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
}

-(void)ClearDataWithOutCode
{
    [_tztTableView setLabelText:@"" withTag_:kTagName];
    [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagPrice];
    [_tztTableView setLabelText:@"" withTag_:kTagMin];
    [_tztTableView setLabelText:@"" withTag_:kTagYE];
    [_tztTableView setLabelText:@"" withTag_:kTagQX];
    [_tztTableView setLabelText:@"" withTag_:kTagDQSY];
    [_tztTableView setLabelText:@"" withTag_:kTagTQSY];
    [_tztTableView setLabelText:@"" withTag_:kTagWYED];
    [_tztTableView setCheckBoxValue:NO withTag_:kTagZQ];
    [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagZZRQ];
    
    if (_ayAccountInfo)
        [_ayAccountInfo removeAllObjects];
}

-(void)SetStockCode:(NSString*)nsStockCode
{
    if (_tztTableView)
    {
        [_tztTableView setEditorText:nsStockCode nsPlaceholder_:NULL withTag_:kTagCode];
    }
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

/*展期选中处理*/
- (void)tztUIBaseView:(UIView *)tztUIBaseView checked:(BOOL)checked
{
    tztUICheckButton *pCheck = (tztUICheckButton*)tztUIBaseView;
    switch ([pCheck.tzttagcode intValue])
    {
        case kTagZQ:
        {
            UIView* pView = [_tztTableView getViewWithTag:kTagZZRQ];
            if (checked)//选中
            {
                pView.hidden = NO;
            }
            else
            {
                pView.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
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
 //zxl 20131017 ipad 添加确定处理
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

/*
 请求报价回购股票数据信息
 */
-(void)OnRefresh
{
    if (_tztTableView == NULL)
        return;
    
    NSString* nsCode = [_tztTableView GetEidtorText:kTagCode];
    if (nsCode.length < 6)
        return;
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"380" withDictValue:pDict];
    DelObject(pDict);
}

/*
 提交报价回购请求
 bSend  －是否发送数据
 */
-(void)OnTrade:(BOOL)bSend
{
    if (_tztTableView == NULL)
        return;
    //代码
    NSString* nsCode = [_tztTableView GetEidtorText:kTagCode];
    if (nsCode.length < 6)
    {
        [self showMessageBox:@"证券代码输入不正确" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    NSString* nsWTAccount = @"";
    NSString* nsWTAccountType = @"";
    NSString* nsPrice = [_tztTableView GetEidtorText:kTagPrice];
    if ([nsPrice floatValue] < 0.01)
    {
        [self showMessageBox:@"委托金额输入不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    NSString* nsName = [_tztTableView GetLabelText:kTagName];
    
    BOOL bZQ = [_tztTableView getCheckBoxValue:kTagZQ];
    int nDirection = (bZQ ? 1:0);
    NSString* nsEndData = @"";
    if (bZQ)
    {
        nsEndData = [_tztTableView getComBoxText:kTagZZRQ];
    }
    
    if (!bSend)
    {
        NSString* strMsg = @"";
        if (nDirection)
        {
            strMsg = [NSString stringWithFormat:@" 证券代码:%@\r\n 证券名称:%@\r\n 委托金额:%@\r\n 终止日期:%@\r\n 确认委托？", nsCode, nsName, nsPrice, nsEndData];
        }
        else
        {
            strMsg = [NSString stringWithFormat:@" 证券代码:%@\r\n 证券名称:%@\r\n 委托金额:%@\r\n 确认委托？", nsCode, nsName, nsPrice];
        }
        [self showMessageBox:strMsg nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self];
        return;
    }
    else
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        [pDict setTztValue:nsCode forKey:@"StockCode"];
        [pDict setTztValue:nsPrice forKey:@"Volume"];
        [pDict setTztValue:nsWTAccount forKey:@"WTAccount"];
        [pDict setTztValue:nsWTAccountType forKey:@"WTAccountType"];
        if (bZQ)
            [pDict setTztValue:@"1" forKey:@"Direction"];
        else
            [pDict setTztValue:@"0" forKey:@"Direction"];
        [pDict setTztValue:nsEndData forKey:@"endDate"];
        
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"382" withDictValue:pDict];
        DelObject(pDict);
    }
    
}

/*请求可用余额*/
-(void)SendYE
{
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"381" withDictValue:pDict];
    DelObject(pDict);
}

/*
 */

/*
服务器返回数据处理
 */
-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    NSString* nsErrMsg = [pParse GetErrorMessage];
    int nErrNo = [pParse GetErrorNo];
    if (nErrNo < 0)
    {
        if ([tztBaseTradeView IsExitError:nErrNo])
        {
            [self OnNeedLoginOut];
        }
        [self showMessageBox:nsErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        return 0;
    }
    
    /*报价回购股票信息返回*/
    if ([pParse IsAction:@"380"])
    {
        NSArray* ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid && [ayGrid count] > 1)
        {
            NSArray* ayData = [ayGrid objectAtIndex:1];//第0行为标题
            if ([ayData count] > 0)
            {
                [self DealInquireStockData:ayData];
            }
        }
    }
    else if([pParse IsAction:@"381"])
    {
        NSString* nsMoney = [pParse GetByName:@"answerno"];
        if (nsMoney && [nsMoney length] > 0)
        {
            nsMoney = tztdecimalNumberByDividingBy(nsMoney, 2);
            [_tztTableView setLabelText:nsMoney withTag_:kTagYE];
        }
        else
        {
            [_tztTableView setLabelText:@"" withTag_:kTagYE];
        }
    }
    else if([pParse IsAction:@"382"])
    {
        [self showMessageBox:nsErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        [self ClearData];//清空界面数据显示
    }
    return 1;
}

-(void)DealInquireStockData:(NSArray*)ayData
{
    //0      1       2           3         4                5      6      7
	//证券代码|证券名称|最小认购金额|产品期限|到期年收益率|提前购回年收益率|是否自动续约|未用额度|
    
    if ([ayData count] < 1 || _tztTableView == NULL)
        return;
    NSString* nsCode = [_tztTableView GetEidtorText:kTagCode];
    
    if ([ayData count] > 0)
    {
        /*判断返回的证券代码和当前界面显示的是否一致，不一致，则不显示相应信息*/
        NSString* nsReturnCode = [ayData objectAtIndex:0];
        if (nsReturnCode == NULL || [nsReturnCode length] < 1)
            return;
        if ([[nsReturnCode uppercaseString] compare:[nsCode uppercaseString]] != NSOrderedSame)
        {
            return;
        }
    }
    
    //名称
    NSString* nsName = tztGetDataInArrayByIndex(ayData, 1);
    //最小买入金额
    NSString* nsMin = tztGetDataInArrayByIndex(ayData, 2);
    //期限
    NSString* nsQX = tztGetDataInArrayByIndex(ayData, 3);
    //到期年收益率
    NSString* nsDQSY = tztGetDataInArrayByIndex(ayData, 4);
    //提前终止年收益率
    NSString* nsTQSY = tztGetDataInArrayByIndex(ayData, 5);
    //未用额度
    NSString* nsKYED = tztGetDataInArrayByIndex(ayData, 7);
    nsKYED = tztdecimalNumberByDividingBy(nsKYED, 2);
    //是否展期
//    NSString* nsZQ = tztGetDataInArrayByIndex(ayData, 6);
    
    [_tztTableView setLabelText:nsName withTag_:kTagName];
    [_tztTableView setLabelText:nsMin withTag_:kTagMin];
    [_tztTableView setLabelText:nsQX withTag_:kTagQX];
    [_tztTableView setLabelText:nsDQSY withTag_:kTagDQSY];
    [_tztTableView setLabelText:nsTQSY withTag_:kTagTQSY];
    [_tztTableView setLabelText:nsKYED withTag_:kTagWYED];
    
    
    
    [self SendYE];
}

@end
