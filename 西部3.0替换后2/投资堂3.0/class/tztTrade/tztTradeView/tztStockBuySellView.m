/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        买卖
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztStockBuySellView.h"
#import "tztUIStockBuySellViewController.h"

#define BuySellViewHeight 170

/*tag值，与配置文件中对应*/
enum  {
	kTagCode = 2000,
	kTagPrice ,
	kTagCount,
	kTagStockCode = 2220, // 可选股票代码
    
    kTagStockNew = 4998,
    kTagStockTotal = 4999,
	kTagStockInfo = 5000,
};

//BOOL isBuyStock;//买卖区分标记

@interface tztStockBuySellView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
-(void)SetTransType:(NSString*)nsType nIndex_:(NSInteger)nIndex;
@end

@implementation tztStockBuySellView
@synthesize tztTradeView = _tztTradeView;
@synthesize CurStockName = _CurStockName;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize bBuyFlag = _bBuyFlag;
@synthesize nsTSInfo = _nsTSInfo;
@synthesize ayTransType = _ayTransType;
@synthesize nsNewPrice  = _nsNewPrice;
@synthesize tztStockDelegate = _tztStockDelegate;
@synthesize pMutilViews = _pMutilViews;
@synthesize pAyViews = _pAyViews;

-(id)init
{
    if (self = [super init])
    {
        _nDotValid = 2;
        _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
        _nAccountIndex = -1;
        _bCanChange = TRUE;
        [[tztMoblieStockComm getShareInstance] addObj:self];
        self.nsNewPrice = @"";
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayType);
    DelObject(_ayAccount);
    DelObject(_ayStockNum);
    DelObject(_ayTransType);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    _bRequest = TRUE;
    CGRect rcFrame = self.bounds;
    
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    if (g_pSystermConfig.bBuySellWithTrend) {
        rcFrame.size.height = BuySellViewHeight;
    }
    
    if (_tztTradeView == NULL)
    {
        _tztTradeView = NewObject(tztUIVCBaseView);
        _tztTradeView.tztDelegate = self;
//        _tztTradeView.nXMargin = 0;
//        _tztTradeView.nYMargin = 0;
        if (_bBuyFlag)
        {
            switch (_nMsgType)
            {
                case WT_SBQRBUY://三板确认买入
                case MENU_JY_SB_QRBuy:
                case WT_DZJY_QRMR://大宗交易确认买入
                case MENU_JY_DZJY_QRBuy:
                {
                    _tztTradeView.tableConfig = @"tztUISBQRTradeBuyStock";
                }
                    break;
                case WT_DZJY_YXMR:
                case MENU_JY_DZJY_YXBuy:
                case WT_DZJY_DJMR:
                case MENU_JY_DZJY_DJBuy:
                {
                    _tztTradeView.tableConfig = @"tztUITradeDZJYBuyStock";
                }
                    break;
                case MENU_JY_SB_HBQRBuy://  互报成交确认买入
                {
                    _tztTradeView.tableConfig = @"tztUISBHBQRTradeBuyStock";
                }
                    break;

                case WT_SBYXBUY: //限价买入
                case MENU_JY_SB_YXBuy:
                {
#ifdef kSUPPORT_XBSC
                    _tztTradeView.tableConfig = @"tztUITradeSBXJBuyStock";
#else
                _tztTradeView.tableConfig=@"tztUITradeSBBuyStock";
#endif
                }
                   break;
                case WT_SBDJBUY:
                case MENU_JY_SB_DJBuy:
                {
                    _tztTradeView.tableConfig = @"tztUITradeSBBuyStock";
                }
                    break;
                case MENU_JY_PT_Buy:
                {
                    // zxl 20131011 添加了在ipad 界面下在交易界面在和 push 出来的界面中显示界面不同而区分开
                    if (IS_TZTIPAD)
                    {
                        _tztTradeView.tableConfig = @"tztUITradeBuyStock_NewVersion_ipad";
                    }else
                    {
                        _tztTradeView.tableConfig = @"tztUITradeBuyStock_NewVersion";
                    }
                    
                }
                    break;
                default:
                {
#ifdef tzt_NewVersion
                    _tztTradeView.tableConfig = @"tztUITradeBuyStock_NewVersion";
#else
//#ifdef Support_EXE_VERSION
//                    _tztTradeView.tableConfig = @"tztUITradeBuyStock_NewVersion";
//#else
                    _tztTradeView.tableConfig = @"tztUITradeBuyStock";
//#endif
#endif
                }
                    break;
            }
        }
        else
        {
            switch (_nMsgType)
            {
                case WT_SBQRSALE://三板确认卖出
                case MENU_JY_SB_QRSell:
                    
                case WT_DZJY_QRMC://大宗交易确认卖出
                case MENU_JY_DZJY_QRSell:
                {
                    _tztTradeView.tableConfig = @"tztUISBQRTradeSaleStock"; 
                }
                    break;
                case WT_DZJY_YXMC:
                case MENU_JY_DZJY_YXSell:
                case WT_DZJY_DJMC:
                case MENU_JY_DZJY_DJSell:
                {
                    _tztTradeView.tableConfig = @"tztUITradeDZJYSaleStock";
                }
                    break;
                case WT_SBYXSALE://三板意向卖出 限价卖出
                case MENU_JY_SB_YXSell:
                {
#ifdef kSUPPORT_XBSC
                    _tztTradeView.tableConfig = @"tztUITradeSBXJSaleStock";
#else
                    _tztTradeView.tableConfig = @"tztUITradeSBSaleStock";
#endif

                }
                    break;

                case WT_SBDJSALE://三板定价卖出
                case MENU_JY_SB_DJSell:
                {
                    _tztTradeView.tableConfig = @"tztUITradeSBSaleStock";
                }
                    break;
                case MENU_JY_SB_HBQRSell: //13017  互报成交确认卖出
                {
                    _tztTradeView.tableConfig = @"tztUISBHBQRTradeSaleStock";
                }
                    break;
                case MENU_JY_PT_Sell:
                {
                    // zxl 20131011 添加了在ipad 界面下在交易界面在和 push 出来的界面中显示界面不同而区分开
                    if (IS_TZTIPAD)
                    {
                        _tztTradeView.tableConfig = @"tztUITradeSaleStock_NewVersion_ipad";
                    }
                    else
                    {
                        _tztTradeView.tableConfig = @"tztUITradeSaleStock_NewVersion";
                    }
                }
                    break;
                case MENU_JY_PT_NiHuiGou://逆回购
                {
                    _tztTradeView.tableConfig = @"tztUITradeBuyStock_NHG";
                }
                    break;
                default:
                {
#ifdef tzt_NewVersion // 新版配置 by20130718
                    _tztTradeView.tableConfig = @"tztUITradeSaleStock_NewVersion";
#else
//#ifdef Support_EXE_VERSION
//                    _tztTradeView.tableConfig = @"tztUITradeSaleStock_NewVersion";
//#else
                    _tztTradeView.tableConfig = @"tztUITradeSaleStock";
//#endif
#endif
                }
                    break;
            }
        }
        _tztTradeView.frame = rcFrame;
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }else
        _tztTradeView.frame = rcFrame;
    
    if (g_pSystermConfig.bBuySellWithTrend) {
        
        rcFrame.origin.y += rcFrame.size.height;
        
        if(!_pTradeToolBar.hidden)
        {
            rcFrame.size.height = frame.size.height - (_pTradeToolBar.frame.size.height+BuySellViewHeight);
        }
        else
        {
            rcFrame.size.height = frame.size.height - BuySellViewHeight;
        }
        
        if (_pMutilViews == NULL)
        {
            _pMutilViews = [[tztMutilScrollView alloc] init];
            _pMutilViews.bSupportLoop = NO;
            _pMutilViews.tztdelegate = self;
            _pMutilViews.backgroundColor = [UIColor clearColor];
            [self addSubview:_pMutilViews];
            [_pMutilViews release];
            
            if(_pAyViews == nil)
                _pAyViews = NewObject(NSMutableArray);
            [_pAyViews removeAllObjects];
            
            _wudang = NewObject(tztUIVCBaseView);
            _wudang.tztDelegate = self;
            if (_bBuyFlag) {
                _wudang.tableConfig = @"tztUIWudangSetting";

            }
            else
            {
                _wudang.tableConfig = @"tztUIWudangSellSetting";
            }
            _wudang.frame = rcFrame;
            
            rcFrame.size.width -= 5;
            pTrend = [[tztTrendView alloc] initWithFrame:rcFrame];
            pTrend.tztdelegate = self;
            pTrend.tztPriceStyle = TrendPriceNon;
            
            [_pAyViews addObject:_wudang];
            [_pAyViews addObject:pTrend];
            [_wudang release];
            [pTrend release];
            
            _pMutilViews.pageViews = _pAyViews;
            _pMutilViews.nCurPage = 1;
            
            _pMutilViews.frame = rcFrame;
        }
    }
}

- (void)requestTrend
{
    tztStockInfo *stockInfo = [[tztStockInfo alloc] init];
    stockInfo.stockCode= self.CurStockCode;
    stockInfo.stockName = self.CurStockName;
    
    if (pTrend && [pTrend respondsToSelector:@selector(setStockInfo:Request:)])
    {
        [pTrend onSetViewRequest:YES];
        [pTrend setStockInfo:stockInfo Request:YES];
    }
    else
    {
        [pTrend onSetViewRequest:YES];
    }
    [stockInfo release];
}

-(void)ClearDataWithOutCode
{
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:1000];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2002];
    [_tztTradeView setLabelText:@"" withTag_:3000];
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:1001];
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
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagStockCode];
    [_tztTradeView setComBoxTextField:kTagStockCode];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
    [self requestTrend];
}

// 清空，以刷新委托价格 byDBQ20131115
- (void)clearUnusedData
{
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
    self.nsNewPrice = @"";
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
//    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
//    NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
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
                [self ClearData];
			}
            
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
        case kTagStockCode://可编辑的下拉控件 // byDBQ20130731
        {
            if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0 && self.CurStockCode.length > 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
                [self ClearData];
			}
            
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
		case kTagPrice:
		{
		}
			break;
		case kTagCount:
		{
            if(!_bBuyFlag)
                return;
            if (_tztTradeView)
            {
//                NSString* strPrice =  [_tztTradeView GetEidtorText:kTagPrice];
//                NSString* nsPrice = [NSString stringWithFormat:strPriceformat, [strPrice floatValue]];
//                NSString* strAmount = inputField.text;
                
//                NSString* strMoney = @"";
//                if ([strAmount intValue] > 0 && [nsPrice floatValue] >= _fMoveStep)
//                {
//                    strMoney = [NSString stringWithFormat:strMoneyformat, [nsPrice floatValue] * [strAmount intValue]];
//                }
//                [_tztTradeView setLabelText:strMoney withTag_:2020];
            }
		}
			break;
		default:
			break;
    }
}

-(void)tztUIBaseView:(UIView *)tztUIBaseView focuseChanged:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
//    NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagPrice:
        {
            if(!_bBuyFlag)
                return;
            if (![tztUIBaseView isFirstResponder])
                return;
            NSString* strPrice = [NSString stringWithFormat:strPriceformat, [inputField.text floatValue]];
            if (_tztTradeView)
            {
//                NSString* strAmount = [_tztTradeView GetEidtorText:kTagCount];
//                NSString* strMoney = @"";
//                if ([strAmount intValue] > 0 && [strPrice floatValue] >= _fMoveStep)
//                {
//                    strMoney = [NSString stringWithFormat:strMoneyformat, [strPrice floatValue] * [strAmount intValue]];
//                }
                if(strPrice && [strPrice length] > 0 && [strPrice floatValue] >= _fMoveStep)
                {
                    [self OnRefresh];
                }
                else
                {
                    if (g_pSystermConfig.bBuySellWithTrend) {
                        [_wudang setButtonTitle:@"" clText_:tztUpColor forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
                    }
                    else
                    {
                        [_tztTradeView setButtonTitle:@"" clText_:tztUpColor forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}
-(void)setAppointmentSerial:(NSString*)nsCode
{
    if (nsCode == NULL )
        return;
    if (_tztTradeView )
    {
        if ([_tztTradeView getViewWithTag:2003])
        {
            [_tztTradeView setEditorText:nsCode nsPlaceholder_:NULL withTag_:2003];
           
        }
       
    }
    
}

-(void)setTradeUnit:(NSString*)nsCode
{
    if (nsCode == NULL )
        return;
    if (_tztTradeView )
    {
        if ([_tztTradeView getViewWithTag:2004])
        {
            [_tztTradeView setEditorText:nsCode nsPlaceholder_:NULL withTag_:2004];
            
        }
        
    }
    
}


-(void)setStockCode:(NSString*)nsCode
{
    if (nsCode == NULL || [nsCode length] < 6)
        return;
    if (_tztTradeView )
    {
        if ([_tztTradeView getViewWithTag:2000])
        {
            [_tztTradeView setEditorText:nsCode nsPlaceholder_:NULL withTag_:2000];
            self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
        }
        else if ([_tztTradeView getViewWithTag:kTagStockCode])
        {
            self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
            [_tztTradeView setComBoxText:nsCode withTag_:kTagStockCode];
            [self OnRefresh];
        }
    }
    
}

-(void)setCanChange:(BOOL)bChange
{
    _bCanChange = bChange;
}

//请求股票信息
-(void)OnRefresh
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    if(_tztTradeView)
    {
        NSString* strPrice =  [_tztTradeView GetEidtorText:kTagPrice];
        if(strPrice && [strPrice length] > 0 && [strPrice floatValue] > 0)
        {
            [pDict setTztValue:strPrice forKey:@"PRICE"];
        }
        
        //获取pricetype
        NSInteger select = [self.tztTradeView getComBoxSelctedIndex:1001];
        NSString * PriceType = @"";
        if (select >= 0 && select < [self.ayTransType count])
        {
            PriceType = [self.ayTransType objectAtIndex:select];
        }else if (g_pSystermConfig.bSBSpecialPriceType)
        {
            switch (_nMsgType)
            {
                case WT_SBQRBUY://三板确认买入
                case MENU_JY_SB_QRBuy:
                case WT_SBQRSALE://三板确认卖出
                case MENU_JY_SB_QRSell:
                {
                    PriceType = @"c";
                }
                    break;
                
                case WT_SBYXBUY:  //限价买入
                case MENU_JY_SB_YXBuy:
                case WT_SBYXSALE://三板意向卖出
                case MENU_JY_SB_YXSell:
                {
                    PriceType = @"a";
                }
                    break;
                case WT_SBDJSALE://三板定价卖出
                case MENU_JY_SB_DJSell:
                case WT_SBDJBUY:
                case MENU_JY_SB_DJBuy:
                {
                    PriceType = @"b";
                }
                    break;
                case MENU_JY_SB_HBQRBuy://  互报成交确认买入
                case MENU_JY_SB_HBQRSell: //13017  互报成交确认卖出
                {
                    PriceType = @"d";
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
            PriceType = @"0";
        }
        if (_nMsgType == MENU_JY_PT_NiHuiGou)
            PriceType = @"4";
        [pDict setTztValue:PriceType forKey:@"PriceType"];
    }
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    if (_bBuyFlag || _nMsgType == MENU_JY_PT_NiHuiGou)
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"151" withDictValue:pDict];
    }
    DelObject(pDict);
}
// 请求股转转让类型 xinlan
-(void)transferType
{
#ifdef kSUPPORT_XBSC
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
    {
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
//    [pDict setTztValue:/*_strCode*/self.CurStockCode forKey:@"StockCode"];
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
    {
        _ntztReqNo = 1;
    }
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5124" withDictValue:pDict];

#endif
}
//发送请求 设置定时器
-(NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (!_bRequest)
        return 0;
    //modify by xyt 20130731 当查询成功后,设置成TRUE才去定时刷新
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return 0;
    TZTLogInfo(@"%@", @"买卖界面行情定时刷新\r\n");
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    if(_tztTradeView)
    {
        NSString* strPrice =  [_tztTradeView GetEidtorText:kTagPrice];
        if(strPrice && [strPrice length] > 0 && [strPrice floatValue] > 0)
        {
            [pDict setTztValue:strPrice forKey:@"PRICE"];
        }
    }
    
    [pDict setTztValue:@"1" forKey:@"StockIndex"];
    NSString* strReqNo = tztKeyReqno((long)self, 0);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    if (_bBuyFlag || _nMsgType == MENU_JY_PT_NiHuiGou)
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"151" withDictValue:pDict];
    }
    DelObject(pDict);
    
    return 1;
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    NSString* strReqno = [pParse GetByName:@"Reqno"];
    tztNewReqno *newReqno = [tztNewReqno  reqnoWithString:strReqno];
    
    
    if ([newReqno getIphoneKey] != (long)self)
        return 0;
    
    if ((![pParse IsIphoneKey:(long)self reqno:_ntztReqNo]) && [newReqno getReqno] != 0)
        return 0;
    
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];
    
    if ([tztBaseTradeView IsExitError:nErrNo] && [newReqno getReqno] != 0)
    {
        [self OnNeedLoginOut];
        return 0;
    }
    
    if (nErrNo < 0)
    {
        if(strError && [newReqno getReqno] != 0)
        {
#ifdef DEBUG
            NSString* strIphoneKey = [pParse GetByName:@"Reqno"];
            TZTLogInfo(@"Reqno=%@",strIphoneKey);
#endif
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"41139"])
    {
        if (strError && strError.length > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton delegate_:nil];
        [self ClearData];
        return 0;
    }
    
    //债券回售,债转股 确定响应 add by xyt 20131101
    if ([pParse IsAction:@"110"] || [pParse IsAction:@"350"] || [pParse IsAction:@"351"])
    {
#ifdef tzt_ChaoGen
        //zxl 20130801 修改了炒跟分享的时候先需要的是数据保存传送到炒跟中 发送请求的时候再传送过来
        tztChaoGenView *pChaogen = [[tztChaoGenView alloc] initWithTitle:@"" message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self block:nil cancelButtonTitle:nil otherButtonTitles:nil];
        
        pChaogen.tag = 0x9888;
        pChaogen.nsWTMsg = strError;
        pChaogen.nsNeiRong = [NSString stringWithFormat:@"委托买入： %@|委托价格： %@元。",self.CurStockCode,[_tztTradeView GetEidtorText:kTagPrice]];
        NSString* nsAccount = [_ayAccount objectAtIndex:[_tztTradeView getComBoxSelctedIndex:1000]];

        //股票代码
        NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
        //委托加个
        NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
        NSString* nsAmount = [_tztTradeView GetEidtorText:kTagCount];
        [pChaogen.ayData setTztValue:nsAccount forKey:@"Account"];
        [pChaogen.ayData setTztValue:nsCode forKey:@"Code"];
        [pChaogen.ayData setTztValue:nsPrice forKey:@"Price"];
        [pChaogen.ayData setTztValue:nsAmount forKey:@"Amount"];
        [pChaogen show];
        [pChaogen release];
#else
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
#endif
        //清理界面数据
        [self ClearData];
        _nAccountIndex = -1;
        return 0;
    }
    if ([pParse IsAction:@"178"])//178-股转系统处理
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
        return 0;
    }
    
    
    if (!_bCanChange)
    {
        return 0;
    }
    
    //刷新五档行情
    if (([newReqno getReqno] == 0) && ([pParse IsAction:@"150"] || [pParse IsAction:@"151"]))
    {
        NSString* strCode = [pParse GetByName:@"StockCode"];
//        _strCode=strCode;
//        if (strCode == NULL || [strCode length] <= 0)//错误
//            return 0;
        //返回的跟当前的代码不一致
        if (strCode && [strCode compare:self.CurStockCode] != NSOrderedSame)
        {
            return 0;
        }
        //解析处理五档行情
        [self DealWithBuySell:pParse];
        
        return 1;
    }
    
    if ([pParse IsAction:@"150"] || [pParse IsAction:@"151"] || [pParse IsAction:@"428"] || [pParse IsAction:@"429"])
    {   
        NSString* strCode = [pParse GetByName:@"StockCode"];
//        _strCode=strCode;

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
            self.CurStockName = [NSString stringWithFormat:@"%@",strName];
            if (_tztTradeView)
            {
                [_tztTradeView setLabelText:strName withTag_:3000];
//                [_tztTradeView setEditorText:self.CurStockCode nsPlaceholder_:NULL withTag_:2000];
            }
        }
        else
        {
            if (_tztTradeView)
            {
                [_tztTradeView setLabelText:@"" withTag_:3000];
                //                [_tztTradeView setEditorText:self.CurStockCode nsPlaceholder_:NULL withTag_:2000];
            }
//            [self showMessageBox:@"该股票代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
//            return 0;
        }
        
        //退市整理判断
        NSString* strTSFlag = [pParse GetByName:@"CommBatchEntrustInfo"]; 
        if (strTSFlag && [strTSFlag length] > 0)
            _nLeadTSFlag = [strTSFlag intValue];
        else
            _nLeadTSFlag = 1;
        
        NSString* strTSInfo = [pParse GetByName:@"BankMoney"];
        if (strTSInfo)
        {
            self.nsTSInfo = [NSString stringWithFormat:@"%@", strTSInfo];
        }
        else
            self.nsTSInfo = @"";
        //
        
        if (_ayAccount == nil)
            _ayAccount = NewObject(NSMutableArray);
        if (_ayType == nil)
            _ayType = NewObject(NSMutableArray);
        if (_ayStockNum == nil)
            _ayStockNum = NewObject(NSMutableArray);
        if (_ayTypeContent == nil)
            _ayTypeContent = NewObject(NSMutableArray);
        
        [_ayAccount removeAllObjects];
        [_ayType removeAllObjects];
        [_ayStockNum removeAllObjects];
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
        
        //获取委托类型
        NSInteger accoutIndex = [self.tztTradeView getComBoxSelctedIndex:1000];
        
        if (accoutIndex < 0 || accoutIndex >= [_ayType count])
            accoutIndex = 0;
        
        if (g_pSystermConfig.bTransType2Content)
        {
            [_tztTradeView setComBoxData:_ayTypeContent ayContent_:_ayType AndIndex_:accoutIndex withTag_:1000];
        }
        else
        {
            [_tztTradeView setComBoxData:_ayAccount ayContent_:_ayType AndIndex_:accoutIndex withTag_:1000];
        }
        
        //可买、可卖显示
        if ([_ayStockNum count] > 0)
        {
            NSString* nsValue = tztdecimalNumberByDividingBy([_ayStockNum objectAtIndex:0], 2);
            NSLog(@"%@",pParse.dictvalue);
            //持仓数量单位 10-手 1-张
            NSString* strTSFlag = [pParse GetByName:@"AmountUnit"];
            if (strTSFlag && [strTSFlag length] > 0)
            {
                int nTSFlag = [strTSFlag intValue];
                if (nTSFlag == 10)
                {
                    nsValue = [NSString stringWithFormat:@"%@手",nsValue];
                }
                else if(nTSFlag == 1)
                {
                    nsValue = [NSString stringWithFormat:@"%@张",nsValue];
                }
            }
            
            if (g_pSystermConfig.bBuySellWithTrend) {
                [_wudang setButtonTitle:nsValue clText_:tztUpColor forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
            }
            else
            {
                [_tztTradeView setButtonTitle:nsValue clText_:tztUpColor forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
            }
            
            
            
        }
        
        //有效小数位
        NSString *nsDot = [pParse GetByName:@"Volume"];
        if (ISNSStringValid(nsDot))
            _nDotValid = [nsDot intValue];
        _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
        
        [_tztTradeView setEditorDotValue:_nDotValid withTag_:kTagPrice];
        
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
        
        NSString* nsValue = tztdecimalNumberByDividingBy(nsMoney, 2);
        
        if (g_pSystermConfig.bBuySellWithTrend) {
            [_wudang setButtonTitle:nsValue
                                  clText_:[UIColor orangeColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagStockInfo];
        }
        else
        {
            [_tztTradeView setButtonTitle:nsValue
                                  clText_:[UIColor orangeColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagStockInfo];
        }
        
        //解析处理五档行情
        [self DealWithBuySell:pParse];
        
        if (_tztTradeView)
        {
            //当前价格
//            NSString* nsPrice = [pParse GetByName:@"ContactID"];//融资融券取的是contactID作为最新价
//            if (nsPrice == NULL || nsPrice.length <= 0)
            NSString* nsPrice = [pParse GetByName:@"ContactID"];
            if (!ISNSStringValid(nsPrice))
                nsPrice = [pParse GetByName:@"Price"];
//            if (nsPrice && nsPrice.length > 0)
//                [_tztTradeView setLabelText:nsPrice withTag_:kTagStockNew];
//            else
//                [_tztTradeView setLabelText:@"-" withTag_:kTagStockNew];
            
            NSInteger select = [self.tztTradeView getComBoxSelctedIndex:1001];
            NSString * PriceType = @"";
            if (select >= 0 && select < [self.ayTransType count])
            {
                PriceType = [self.ayTransType objectAtIndex:select];
            }
            else
            {
                PriceType = @"0";
            }
            
            //添加判断 add by xyt 20130917
            if (_ayType && [_ayType count] > 0) 
            {
                [self SetTransType:[_ayType objectAtIndex:accoutIndex] nIndex_:select];
            }
            
            NSString* nsNowPrice = [_tztTradeView GetEidtorText:2001];
            if(([PriceType compare:@"0"] == NSOrderedSame))
            {
                if (nsNowPrice == nil || [nsNowPrice length] <= 0 || [nsNowPrice floatValue] < _fMoveStep)
                //没有输入价格
                {
                    UIView* pEditor = [_tztTradeView getViewWithTag:2001];
                    if (pEditor != NULL && [pEditor isKindOfClass:[tztUITextField class]])
                    {
                        [(tztUITextField*)pEditor setText:nsPrice];
                    }
    //                [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:2001];
                    //初始化市价委托（默认选择限价委托）
                    self.nsNewPrice = [NSString stringWithFormat:@"%@",nsPrice];
                }
            }
            else
            {
                [_tztTradeView setEditorText:@"市价委托" nsPlaceholder_:NULL withTag_:2001];
                [_tztTradeView setEditorEnable:NO withTag_:2001];
            }
        }
        [self transferType];
        [self requestTrend];
        
    }
    
    if ([pParse IsAction:@"5124"]) //获取股转类型数据
    {
        int ntransTypeIndex=-1;
        if ([[pParse GetErrorMessage]isEqualToString:@"查无记录!"])
        {
            [ self showMessageBox:[pParse GetErrorMessage] nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
//        NSString* strCode = [pParse GetByName:@"StockCode"];
//        if (strCode == NULL || [strCode length] <= 0)//错误
//            return 0;
        //返回的跟当前的代码不一致
//        if ([strCode compare:self.CurStockCode] != NSOrderedSame)
//        {
//            return 0;
//        }
        //获取股转类型索引
        NSString *transTypeIndex= [pParse GetByName:@"TransTypeIndex"];
        if (transTypeIndex==NULL)
        {
            [self showMessageBox:@"股转类型索引为空" nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
               if (ntransTypeIndex < 0)
        {
            TZTStringToIndex(transTypeIndex, ntransTypeIndex);
        }
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *pAy = [ayGrid objectAtIndex:i];
                if (ntransTypeIndex>[pAy count])
                {
                    [ self showMessageBox:@"股票代码无效" nType_:TZTBoxTypeNoButton nTag_:0];
                    break;
                }


                NSString* transType = [pAy objectAtIndex:ntransTypeIndex];
                [_tztTradeView setEditorText:transType nsPlaceholder_:@"" withTag_:2005];
                
            }
        }


  
    }
        
        
        
        
    if ([pParse IsAction:@"117"])
    {
        int nStockName = -1;
        int nStockCodeIndex = -1;
        
        NSString *strIndex = [pParse GetByName:@"StockName"];
        TZTStringToIndex(strIndex, nStockName);
        
        if (nStockName < 0)
        {
            strIndex = [pParse GetByName:@"StockNameIndex"];
            TZTStringToIndex(strIndex, nStockName);
        }
        
        strIndex = [pParse GetByName:@"StockCodeIndex"];
        TZTStringToIndex(strIndex, nStockCodeIndex);
        
        if (nStockCodeIndex < 0)
        {
            strIndex = [pParse GetByName:@"StockIndex"];
            TZTStringToIndex(strIndex, nStockCodeIndex);
        }
        
//        if (nStockName < 0)
//            return 0;
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        
        NSMutableArray *pAyTitle = [NSMutableArray array];
        NSString* strCode = @"";
        NSString* strName = @"";
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
            
            NSString* strTitle = [NSString stringWithFormat:@"%@", strCode];
            if (strName && strName.length > 0)
            {
                strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
            }
            [pAyTitle addObject:strTitle];
            DelObject(pDict);
        }
        
        if (_tztTradeView && [pAyTitle count] > 0)
        {
            [_tztTradeView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTagStockCode bDrop_:YES];
        }
        else
        {
            if (ISNSStringValid(strError))
                tztAfxMessageBox(strError);
            else
                tztAfxMessageBox(@"查无相关记录!");
        }
    }
    else if ([pParse IsAction:@"5000"])
    {
        [self showMessageBox:strError nType_:TZTBoxTypeNoButton delegate_:nil];
        [self ClearData];
        return 1;
    }

    
    return 1;
}
    
   

// 将市场类型转换成中文
- (NSString *)transType2Content:(NSString *)string
{
    if ([[string uppercaseString] isEqualToString:@"SHACCOUNT"]) {
        return @"上海市场A股";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SZACCOUNT"]) {
        return @"深圳市场A股";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SHBACCOUNT"]) {
        return @"上海市场B股";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SZBACCOUNT"]) {
        return @"深圳市场B股";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SBACCOUNT"]) {
        return @"三板市场";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SBBACCOUNT"]) {
        return @"三板市场B股";
    }
    else
        return string;//return nil; //返回nil会崩溃。。
}
    


/*
 函数功能：解析处理五档行情
 入参：数据解析类
 出参：无
 */
-(void)DealWithBuySell:(tztNewMSParse *)pParse
{
    if (pParse == NULL)
        return;
    
    //买卖5档数据
    float dPClose = 0.0f;
    NSString *nsBuySell = [pParse GetByName:@"buysell"];
    if (nsBuySell && [nsBuySell length] > 0)
    {
        NSArray* ayGridRow = [nsBuySell componentsSeparatedByString:@"|"];
        //昨收
        if([ayGridRow count] > 5)
        {
            dPClose = [[ayGridRow objectAtIndex:5] floatValue];
        }
        
        NSString* nsValue = [pParse GetByName:@"Price"];
//        if (nsValue == NULL || nsValue.length <= 0)
//            nsValue = [pParse GetByName:@"Price"];
        
        UIColor* cl = [UIColor whiteColor];
        if (g_nThemeColor == 1 || g_nSkinType == 1)
        {
            cl = [UIColor darkTextColor];
        }
        if (nsValue == NULL || nsValue.length <= 0)
            nsValue = @"-";
        else
        {
            if (g_nThemeColor == 1 || g_nSkinType == 1)
                cl = ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? [UIColor darkTextColor] :
                ( ([nsValue floatValue] > dPClose) ? tztUpColor : tztDownColor );
            else
                cl = ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? tztBalanceColor :
                ( ([nsValue floatValue] > dPClose) ? tztUpColor : tztDownColor );
        }
        if (g_pSystermConfig.bBuySellWithTrend) {
            [_wudang setButtonTitle:nsValue
                            clText_:cl
                          forState_:UIControlStateNormal
                           withTag_:kTagStockNew];
        }
        else
        {
            [_tztTradeView setButtonTitle:nsValue
                                  clText_:cl
                                forState_:UIControlStateNormal
                                 withTag_:kTagStockNew];
        }
        
        
        for (int i = 0; i < [ayGridRow count]; i++)
        {
            NSString* nsValue = [ayGridRow objectAtIndex:i];
            
            UIColor* txtColor = nil;// ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? tztBalanceColor :
//            ( ([nsValue floatValue] > dPClose) ? tztUpColor : tztDownColor );
            if (g_nThemeColor == 1 || g_nSkinType == 1)
                txtColor = ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? [UIColor darkTextColor] :
                ( ([nsValue floatValue] > dPClose) ? tztUpColor : tztDownColor );
            else
                txtColor = ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? tztBalanceColor :
                ( ([nsValue floatValue] > dPClose) ? tztUpColor : tztDownColor );
            
            int nTag = 0;
            switch (i)
            {
                case 0://现手
                {
                    nTag = 4999;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 1://买一
                {
                    nTag = 5004;
                }
                    break;
                case 2://买一量
                {
                    nTag = 5017;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 3://卖一
                {
                    nTag = 5009;
                }
                    break;
                case 4://卖一量
                {
                    nTag = 5022;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 5://昨收
                    break;
                case 6://涨停
                {
                    nTag = 5002;
                }
                    break;
                case 7://跌停
                {
                    nTag = 5003;
                }
                    break;
                case 8://买二
                {
                    nTag = 5005;
                }
                    break;
                case 9://买二量
                {
                    nTag = 5018;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 10://买三
                {
                    nTag = 5006;
                }
                    break;
                case 11://买三量
                {
                    nTag = 5019;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 12://买四
                {
                    nTag = 5007;
                }
                    break;
                case 13://买四量
                {
                    nTag = 5020;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 14://买五
                {
                    nTag = 5008;
                }
                    break;
                case 15://买五量
                {
                    nTag = 5021;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 16://卖二
                {
                    nTag = 5010;
                }
                    break;
                case 17://卖二量
                {
                    nTag = 5023;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 18://卖三
                {
                    nTag = 5011;
                }
                    break;
                case 19://卖三量
                {
                    nTag = 5024;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 20://卖四
                {
                    nTag = 5012;
                }
                    break;
                case 21://卖四量
                {
                    nTag = 5025;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                case 22://卖五
                {
                    nTag = 5013;
                }
                    break;
                case 23://卖五量
                {
                    nTag = 5026;
                    nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                    txtColor = [UIColor orangeColor];
                }
                    break;
                default:
                    break;
            }
            if (g_pSystermConfig.bBuySellWithTrend) {
                [_wudang setButtonTitle:nsValue
                                clText_:txtColor
                              forState_:UIControlStateNormal
                               withTag_:nTag];
            }
            else
            {
                [_tztTradeView setButtonTitle:nsValue
                                  clText_:txtColor
                                forState_:UIControlStateNormal
                                 withTag_:nTag];
            }
        }
    }    
}

-(BOOL)CheckInput
{
    if (_tztTradeView == NULL || ![_tztTradeView CheckInput])
        return FALSE;
    
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
    
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
    {
            return FALSE;
    }
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    
    //股票代码
    NSString* nsCode = @"";
    if ([_tztTradeView getViewWithTag:kTagCode])
    {
        nsCode = [_tztTradeView GetEidtorText:kTagCode];
    }
    else
    {
        nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    }
    if (nsCode == NULL || [nsCode length] < 1)
        return FALSE;

//    委托方式
    UIView* pView = [_tztTradeView getViewWithTag:1001];
    NSString* nsType = @"";
    if (pView != NULL)
    {
        if ([pView isKindOfClass:[tztUITextField class]])
        {
            nsType = ((tztUITextField*)pView).text;
        }
        if ([pView isKindOfClass:[tztUIDroplistView class]])
        {
            nsType = ((tztUIDroplistView*)pView).text;
        }
        
        if (nsType == NULL || [nsType length] < 1)
        {
            [self showMessageBox:@"委托方式选择有误!" nType_:TZTBoxTypeNoButton nTag_:0];
            return FALSE;
        }
    }
    
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
    if (_nMsgType == WT_SBQRBUY || _nMsgType == MENU_JY_SB_QRBuy ||
        _nMsgType == WT_SBQRSALE || _nMsgType == MENU_JY_SB_QRSell)
    {
        NSString* nsYDXH = [_tztTradeView GetEidtorText:2003];
        if (nsYDXH == NULL || [nsYDXH length] < 1)
        {
            [self showMessageBox:@"约定序号输入有误!"
                          nType_:TZTBoxTypeNoButton
                           nTag_:0
                       delegate_:NULL
                      withTitle_:@"股转系统"];
            return FALSE;
        }
        
        NSString* nsXWH = [_tztTradeView GetEidtorText:2004];
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
    switch (_nMsgType)
    {
        case WT_BUY:
        case MENU_JY_PT_Buy:
        case MENU_JY_ZYHG_ZQBuy:
        {
#ifdef kSUPPORT_FIRST
                strTitle = [NSString stringWithFormat:@"%@",nsType];
#else
            strTitle = @"委托买入";
#endif
            strButtonOK = @"买入";
        }
            break;
        case WT_SALE:
        case MENU_JY_PT_Sell:
        case MENU_JY_ZYHG_ZQSell:
        {
            strTitle = @"委托卖出";
            strButtonOK = @"卖出";
        }
            break;
        case MENU_JY_PT_NiHuiGou:
        {
            strTitle = @"逆向回购";
            strButtonOK = @"卖出";
        }
            break;
        case WT_RZRQBUY:
        {
            strTitle = @"普通买入";
            strButtonOK = @"买入";
        }
            break;
        case WT_RZRQSALE:
        {
            strTitle = @"普通卖出";
            strButtonOK = @"卖出";
        }
            break;
        case WT_RZRQRZBUY:
        {
            strTitle = @"融资买入";
            strButtonOK = @"买入";
        }
            break;
        case WT_RZRQRQSALE:
        {
            strTitle = @"融券卖出";
            strButtonOK = @"卖出";
        }
            break;
        case WT_RZRQSALERETURN:
        {
            strTitle = @"卖券还款";
            strButtonOK = @"卖出";
        }
        
            break;
        case WT_RZRQBUYRETURN:
        {
            strTitle = @"买券还券";
            strButtonOK = @"买入";
        }
            break;
            
        default:
            break;
    }
    _bCanChange = FALSE;
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:strTitle
                   nsOK_:strButtonOK
               nsCancel_:@"取消"];
    return TRUE;
}

-(void)goBuySell
{
    if (_nLeadTSFlag == -1)
    {
        if (self.nsTSInfo && [self.nsTSInfo length] > 0)
        {
            [self showMessageBox:self.nsTSInfo
                          nType_:TZTBoxTypeNoButton
                           nTag_:0
                       delegate_:nil
                      withTitle_:@"退市提醒"];
        }
        return;
    }
    else
        [self CheckInput];
}

//买卖确认
-(void)OnSendBuySell
{
    if (_tztTradeView == nil)
    {
        _bCanChange = TRUE;
        return;
    }
    //股东账号
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
    {
            return;
    }
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    
    //股票代码
    NSString* nsCode = @"";
    if ([_tztTradeView getViewWithTag:kTagCode])
    {
        nsCode = [_tztTradeView GetEidtorText:kTagCode];
    }
    else
    {
        nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    }
    if (nsCode == NULL || [nsCode length] < 1)
    {
        _bCanChange = TRUE;
        return;
    }
    
    //委托加个
    NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
    if (nsPrice == NULL || [nsPrice length] < 1)
    {
        [self showMessageBox:@"委托价格输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        _bCanChange = TRUE;
        return;
    }
    
    NSString* nsAmount = [_tztTradeView GetEidtorText:kTagCount];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] <= 0) 
    {
        [self showMessageBox:@"委托数量输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        _bCanChange = TRUE;
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
    [pDict setTztValue:nsPrice forKey:@"Price"];
    [pDict setTztValue:nsAmount forKey:@"Volume"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    
    //zxl 20130819 修改市价委托发送方式
    NSInteger select = [self.tztTradeView getComBoxSelctedIndex:1001];
    NSString * PriceType = @"";
    if (select >= 0 && select < [self.ayTransType count])
    {
        PriceType = [self.ayTransType objectAtIndex:select];
    }else
    {
        PriceType = @"0";
    }
    if (select == 0 || PriceType == NULL || [PriceType length] < 1)
    {
        [pDict setTztValue:nsPrice forKey:@"Price"];
        [pDict setTztValue:PriceType forKey:@"PriceType"];
        
    }else if(select > 0 && PriceType && [PriceType length] > 0)
    {
        [pDict setTztValue:@"1" forKey:@"Price"];
        [pDict setTztValue:PriceType forKey:@"PriceType"];
    }
    
    if (_bBuyFlag)
    {
        [pDict setTztValue:@"B" forKey:@"Direction"];
    }
    else
        [pDict setTztValue:@"S" forKey:@"Direction"];
    
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"110" withDictValue:pDict];
    DelObject(pDict);
    _bCanChange = TRUE;
}

//工具栏点击事件
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if (_tztTradeView)
            {
                if ([_tztTradeView CheckInput])
                {
                    [self goBuySell];
                    return TRUE;
                }
            }
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
            {
                _bCanChange = TRUE;
            }
                break;
        }
    }
    _bCanChange = TRUE;
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
            {
                _bCanChange = TRUE;
            }
                break;
        }
    }
    _bCanChange = TRUE;
}

-(void)OnButtonClick:(id)sender
{
    [self OnButton:sender];
}

-(void)OnButton:(id)sender
{
    if (sender == NULL)
        return;
    
	UIButton * pButton = (UIButton*)sender;
	NSInteger nTag = pButton.tag;
    
    if ([pButton isKindOfClass:[tztUIButton class]])
    {
        nTag = [((tztUIButton*)pButton).tzttagcode intValue];
    }
    
    NSString* nsString = [pButton titleForState:UIControlStateNormal];
    
    if (nTag == 6801) // 买卖 byDBQ20130716
    {
        [self goBuySell];
    }
    else if (nTag == 6802) // 刷新 byDBQ20130716
    {
        [self clearUnusedData];
        [self OnRefresh];
    }
    else if (nTag == 6803) // 清空 byDBQ20130716
    {
        [self ClearData];
    }
    else if (nTag == 6804) // 切换 byDBQ20130716
    {
        if(self.tztStockDelegate && [self.tztStockDelegate respondsToSelector:@selector(pushQHView)])
            [self.tztStockDelegate pushQHView];
    }
    else if (nTag == 5001)//约卖，约买数量点击
    {
        if (_tztTradeView)
        {
            if (_ayStockNum && [_ayStockNum count] > 0 )
                nsString = [_ayStockNum objectAtIndex:0];
            [_tztTradeView setEditorText:nsString nsPlaceholder_:NULL withTag_:2002];
        }
    }
    else if(nTag == 4998 || (nTag >= 5002 && nTag <= 5013))
    {
        //获取pricetype
        NSInteger select = [self.tztTradeView getComBoxSelctedIndex:1001];
        if (select > 0)
            return;
        //价格点击
        //价格输入框，填充数据
        [_tztTradeView setEditorText:nsString nsPlaceholder_:NULL withTag_:2001];
        self.nsNewPrice = [NSString stringWithFormat:@"%@",nsString];
        
        if (!_bBuyFlag)
            return;
        [self OnRefresh];
    }
    else if(nTag >= 5014 && nTag <= 5023)
    {
        //量点击
    }
    else if(nTag == 8001 || nTag == 8000)//价格增加
    {
        NSInteger select = [self.tztTradeView getComBoxSelctedIndex:1001];
        NSString * Direction = @"";
        if (select >= 0 && select < [self.ayTransType count])
        {
            Direction = [self.ayTransType objectAtIndex:select];
        }
        if (select == 0 || Direction == NULL || [Direction length] < 1)//限价委托时才能操作
        {
        }
        else
        {
            return;
        }
        NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
        //获取当前价格
        NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
        
        float fPrice = [nsPrice floatValue];
        if (nTag == 8001)
            fPrice += _fMoveStep;
        else if(nTag == 8000)
            fPrice -= _fMoveStep;
        if (fPrice < _fMoveStep)
            fPrice = 0.0;
        
        nsPrice = [NSString stringWithFormat:strPriceformat, fPrice];
        [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:kTagPrice];
        
        if (_bBuyFlag)
        {
            if (nsPrice && [nsPrice length] > 0 && [nsPrice floatValue] >= _fMoveStep)
            {
                [self OnRefresh];
            }
        }
        
//        NSString* strAmount = [_tztTradeView GetEidtorText:kTagCount];
//        NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
//        NSString* strMoney = @"";
//        if ([strAmount intValue] > 0 && [nsPrice floatValue] >= _fMoveStep)
//        {
//            strMoney = [NSString stringWithFormat:strMoneyformat, [nsPrice floatValue] * [strAmount intValue]];
//        }
//        [_tztTradeView setLabelText:strMoney withTag_:2020];
    }
    else if(nTag == 9001 || nTag == 9000)//数量增加
    {
        NSString* nsAmount = [_tztTradeView GetEidtorText:kTagCount];
        int nAmount = [nsAmount intValue];
        
        if (nTag == 9001)
        {
            nAmount += 100; // 买卖都加100 byDBQ20130729
        }
        if (nTag == 9000)
        {
            nAmount -= 100; // 买卖都减100 byDBQ20130729
            
            if (nAmount <= 0)
                nAmount = 0;
        }
        nsAmount = [NSString stringWithFormat:@"%d", nAmount];
        [_tztTradeView setEditorText:nsAmount nsPlaceholder_:NULL withTag_:kTagCount];
        
        
//        NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
//        NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
//        NSString* strPrice =  [_tztTradeView GetEidtorText:kTagPrice];
//        NSString* nsPrice = [NSString stringWithFormat:strPriceformat, [strPrice floatValue]];
        
//        NSString* strMoney = @"";
//        if ([nsAmount intValue] > 0 && [nsPrice floatValue] >= _fMoveStep)
//        {
//            strMoney = [NSString stringWithFormat:strMoneyformat, [nsPrice floatValue] * [nsAmount intValue]];
//        }
//        [_tztTradeView setLabelText:strMoney withTag_:2020];
    }else if (nTag == 5030)
    {
        if (_tztTradeView)
        {
            if ([_tztTradeView CheckInput])
            {
                [self goBuySell];
            }
        }
    }
}
/*函数功能：设置市价委托类型
 入参：市场类型
 出参：无
 */
-(void)SetTransType:(NSString*)nsType nIndex_:(NSInteger)nIndex
{
	if (nsType == nil)
		return;
	if (_ayTransType == nil)
        _ayTransType = NewObject(NSMutableArray);
	[self.ayTransType removeAllObjects];
	NSMutableArray *ayTransName = NewObject(NSMutableArray);
	if (nsType)
	{
        //zxl 20130819 修改市价委托类型
		//上证
		if ([nsType hasPrefix:@"SH"])
		{
			[self.ayTransType addObject:@"0"];
			[ayTransName addObject:@"限价委托"];
			[self.ayTransType addObject:@"U"];
			[ayTransName addObject:@"最优五档即时成交剩余撤销"];
			[self.ayTransType addObject:@"R"];
			[ayTransName addObject:@"五档成交剩余转限"];
		}
		//深证
		else if([nsType hasPrefix:@"SZ"])
		{
			[self.ayTransType addObject:@"0"];
			[ayTransName addObject:@"限价委托"];
			[self.ayTransType addObject:@"Q"];
			[ayTransName addObject:@"对手方最优价格"];
			[self.ayTransType addObject:@"S"];
			[ayTransName addObject:@"本方最优价格"];
			[self.ayTransType addObject:@"U"];
			[ayTransName addObject:@"最优五档即时成交剩余撤销"];
//			[self.ayTransType addObject:@"R"];
//			[ayTransName addObject:@"五档成交剩余撤销"];
			[self.ayTransType addObject:@"T"];
			[ayTransName addObject:@"即时成交剩余撤销"];
			[self.ayTransType addObject:@"V"];
			[ayTransName addObject:@"全额成交或撤销"];
		}
        else
        {
			[self.ayTransType addObject:@"0"];
			[ayTransName addObject:@"限价委托"];
        }
        
        if (nIndex < 0 || nIndex >= [ayTransName count])
            nIndex = 0;
        [self.tztTradeView setComBoxData:ayTransName ayContent_:ayTransName AndIndex_:nIndex withTag_:1001];
		DelObject(ayTransName);
        [self.tztTradeView setEditorEnable:TRUE withTag_:2001];
		if (self.nsNewPrice && nIndex == 0)
		{
            UIView* pEditor = [_tztTradeView getViewWithTag:2001];
            if(pEditor && [pEditor isKindOfClass:[tztUITextField class]] && (((tztUITextField*)pEditor).text == nil || [((tztUITextField*)pEditor).text length] <= 0 || [((tztUITextField*)pEditor).text floatValue] < _fMoveStep))
            {
                ((tztUITextField*)pEditor).text = self.nsNewPrice;
            }
//			[self.tztTradeView setEditorText:self.nsNewPrice nsPlaceholder_:NULL withTag_:2001];
		}
		else
		{
			[self.tztTradeView setEditorText:@"市价委托" nsPlaceholder_:NULL withTag_:2001];
		}
	}
}

//选中list
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagStockCode)
    {
        [self OnRequestStockData];
    }
}

-(void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(NSInteger)index
{
    if ([droplistview.tzttagcode intValue] == 1000)
    {
        //根据委托账号类型设置市价委托类型
        if (index >= 0 && index < [_ayType count] )
        {
            NSString *accountType = [_ayType objectAtIndex:index];
            NSInteger nSelect = [_tztTradeView getComBoxSelctedIndex:1001];
            
            if (_nAccountIndex != index)
            {
                _nAccountIndex = index;
                nSelect = 0;
            }
            [self SetTransType:accountType nIndex_:nSelect];
        }
    }
    if ([droplistview.tzttagcode intValue] == 1001)
    {
        //市价委托选择设置
        if (index == 0)
        {
            [self.tztTradeView setEditorEnable:TRUE withTag_:2001];
            if (self.nsNewPrice)
            {
                [self.tztTradeView setEditorText:self.nsNewPrice nsPlaceholder_:NULL withTag_:2001];
            }
            else
            {
                [self.tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
            }
        }
        else
        {
            [self.tztTradeView setEditorEnable:FALSE withTag_:2001];
            [self.tztTradeView setEditorText:@"市价委托" nsPlaceholder_:NULL withTag_:2001];
        }
        [self OnRefresh];
    }
    if ([droplistview.tzttagcode intValue] == kTagStockCode)
    {
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            
            //设置股票代码
            [_tztTradeView setComBoxText:strCode withTag_:kTagStockCode];
            [self ClearDataWithOutCode];
            self.CurStockCode = [NSString stringWithFormat:@"%@", strCode];
            if (self.CurStockCode.length == 6)
                [self OnRefresh];
        }
        else
        {
            if (strTitle.length == 6)
            {
                [self ClearDataWithOutCode];
                self.CurStockCode = [NSString stringWithFormat:@"%@", strTitle];
                if (self.CurStockCode.length == 6)
                    [self OnRefresh];
            }
        }
    }
}
-(BOOL)tztDroplistView:(tztUIDroplistView*)pSliderView showlistview:(UITableView*)pView
{
//    [self addSubview:pSliderView];
//    CGPoint point = pView.frame.origin;
//    point = [self tztDroplistView:pSliderView point:point];
//    //设置弹出的frame
//    pView.frame = CGRectMake(point.x, point.y, pView.frame.size.width, pView.frame.size.height);
//	if (m_pDelegate)
//	{
//		CGRect rc = pView.frame;
//		CGRect appRect = [[UIScreen mainScreen] bounds];
//		if ((rc.origin.y + rc.size.height + 10) > (appRect.size.height - 20 - 50))
//		{
//			rc.size.height -= (rc.origin.y + rc.size.height + 10 - appRect.size.height + 20 + 50 );
//		}
//		pView.frame = rc;
//		if([m_pDelegate isKindOfClass:[UIView class]])
//			[m_pDelegate addSubview:pView];
//		else if([m_pDelegate isKindOfClass:[UIViewController class]])
//			[((UIViewController*)m_pDelegate).view addSubview:pView];
//	}
//	else
//	{
//		[self addSubview:pView];
//	}
//    pSliderView.nShowSuper = TRUE;
//    m_nSliderCount++;
//    m_pFocuesSlider = pSliderView;
    return TRUE;
}

-(void)OnFenXiang:(NSString *)LYMsg Date:(NSMutableDictionary *)ayData
{
    //zxl 20130801 修改了炒跟分享的时候发送所需要的数据获取方式
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [pDict setTztValue:[ayData tztValueForKey:@"Account"] forKey:@"gdaccount"];
    [pDict setTztValue:[ayData tztValueForKey:@"Price"] forKey:@"price"];
    [pDict setTztValue:[ayData tztValueForKey:@"Amount"] forKey:@"consign"];
    [pDict setTztValue:[ayData tztValueForKey:@"Code"] forKey:@"stockcode"];
    [pDict setTztValue:self.CurStockName forKey:@"stockname"];
    tztJYLoginInfo *pCurInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (pCurInfo)
    {
        [pDict setTztValue:pCurInfo.ZjAccountInfo.nsCellIndex forKey:@"yybcode"];
        [pDict setTztValue:pCurInfo.ZjAccountInfo.nsAccount forKey:@"zjaccount"];
    }
    if(self.bBuyFlag)
    {
        [pDict setTztValue:@"1" forKey:@"direction"];
    }
    else
    {
        [pDict setTztValue:@"2" forKey:@"direction"];
    }
    [pDict setTztValue:LYMsg forKey:@"remark"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"41139" withDictValue:pDict];
    DelObject(pDict);
}

#pragma 炒跟
#ifdef tzt_ChaoGen
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    if ([alertView isKindOfClass:[tztChaoGenView class]])
    {
        for (UIView * view in alertView.subviews)
        {
            [view removeFromSuperview];
        }
    }
}
- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if ([alertView isKindOfClass:[tztChaoGenView class]])
    {
        [(tztChaoGenView*)alertView LoadlayoutViews:alertView.frame];
    }
    
}
#endif

/*
 查询持仓信息
 */
-(void)OnRequestStockData
{
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
//    if (g_CurUserData.nsDBPLoginToken && [g_CurUserData.nsDBPLoginToken length] > 0)
//        [pDict setTztValue:g_CurUserData.nsDBPLoginToken forKey:@"Token"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountPTType] forKey:tztTokenType];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"117" withDictValue:pDict];
    DelObject(pDict);
}

@end
