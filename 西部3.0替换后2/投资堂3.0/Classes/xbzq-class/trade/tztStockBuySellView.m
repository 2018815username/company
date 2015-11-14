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
    kTagWTAccount = 1000,   //委托账号
    kTagWTType,             //委托方式
    
	kTagCode = 2000,        //输入框代码
	kTagPrice ,             //委托价格
	kTagCount,              //委托数量
    kTagYDXH,               //约定序号
    kTagDFXWH,              //对方席位号
    kTagDFGD = 2010,        //对方股东
    kTagYXD =2011,          //意向单
	kTagStockCode = 2220,   // 可选股票代码
    
    kTagStockNew = 4998,    //最新
    kTagStockTotal = 4999,  //总量
	kTagStockInfo = 5000,
    
    kTagPriceDel = 8000,
    kTagPriceAdd,
    
    kTagAmountDel = 9000,
    kTagAmountAdd,

};

//BOOL isBuyStock;//买卖区分标记

@interface tztStockBuySellView()<tztUIBaseViewTextDelegate,tztUIDroplistViewDelegate>
{
    //定时显示金额
    int     _nTimerCount;
    //请求行情
    BOOL    _bRequestStockHQ;
    UInt16  _ntztReqNoHQ;
}
@property(nonatomic,retain)UILabel  *labelPriceDel;
@property(nonatomic,retain)UILabel  *labelPriceAdd;
@property(nonatomic,retain)UILabel  *labelAmountDel;
@property(nonatomic,retain)UILabel  *labelAmountAdd;//金额提示
@property(nonatomic,retain)UILabel           *labelMoneyTips;
@property(nonatomic,retain)NSString *ns6Text;
//多个相同代码区分
//市场号
@property(nonatomic,retain)NSString         *nsMarketNo;

@property(nonatomic,retain)NSString         *nsWTAccount;

//委托账号
@property(nonatomic,retain)NSString         *nsWTAccountType;
@property(nonatomic,retain)NSMutableArray   *ayAccountName;
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
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
        self.nsNewPrice = @"";
        
        _currentSelect = 0;
        self.yxdArray = [NSMutableArray array];
        self.ydhArray = [NSMutableArray array];
        self.xwhArray = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    if (_ayType)
        [_ayType removeAllObjects];
    DelObject(_ayType);
    if (_ayAccount)
        [_ayAccount removeAllObjects];
    DelObject(_ayAccount);
    if (_ayStockNum)
        [_ayStockNum removeAllObjects];
    DelObject(_ayStockNum);
    if (_ayTransType)
        [_ayTransType removeAllObjects];
    DelObject(_ayTransType);
    if (_ayTypeContent)
        [_ayTypeContent removeAllObjects];
    DelObject(_ayTypeContent);
    if (_ayAccountName)
        [_ayAccountName removeAllObjects];
    DelObject(_ayAccountName);
    [super dealloc];
}


-(void)onSetViewRequest:(BOOL)bRequest
{
    if (bRequest)
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] removeObj:self];
        [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    }
}

-(void)setNMsgType:(NSInteger)nMsgType
{
    _nMsgType = nMsgType;
    _bBuyFlag = (nMsgType == WT_BUY || nMsgType == MENU_JY_PT_Buy
                 || nMsgType == WT_SBQRBUY || nMsgType == MENU_JY_SB_QRBuy
                 || nMsgType == MENU_JY_SB_HBQRBuy
                 || nMsgType == WT_SBYXBUY || nMsgType == MENU_JY_SB_YXBuy
                 || nMsgType == WT_SBDJBUY || nMsgType == MENU_JY_SB_DJBuy
                 || nMsgType == WT_DZJY_QRMR || nMsgType == MENU_JY_DZJY_QRBuy
                 || nMsgType == WT_DZJY_YXMR || nMsgType == MENU_JY_DZJY_YXBuy
                 || nMsgType == WT_DZJY_DJMR || nMsgType == MENU_JY_DZJY_DJBuy);
    
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
//    if (g_pSystermConfig.bBuySellWithTrend) {
//        rcFrame.size.height = BuySellViewHeight;
//    }
    
    if (_tztTradeView == NULL)
    {
        _tztTradeView = NewObject(tztUIVCBaseView);
        _tztTradeView.tztDelegate = self;
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
                    _tztTradeView.tableConfig = @"tztUITradeSBXJBuyStock";

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
                    _tztTradeView.tableConfig = @"tztUITradeBuyStock";
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
                    _tztTradeView.tableConfig = @"tztUITradeSBXJSaleStock";

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
                    _tztTradeView.tableConfig = @"tztUITradeSaleStock";
#endif
                }
                    break;
            }
        }
        _tztTradeView.frame = rcFrame;
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
        _tztTradeView.frame = rcFrame;

    
    UIView* zijinView = [_tztTradeView getCellWithFlag:@"TZTZJYM"];
    [zijinView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[tztUIButton class]]) {
            if (idx  == 2 || idx == 4) {
                tztUIButton* btn = (tztUIButton*)obj;
                CGRect rect = btn.frame;
                rect.origin.x-=10;
                btn.frame = rect;
            }
        }
    }];
    

    UIView* code = [_tztTradeView getCellWithFlag:@"TZTDM"];
    [code.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[tztUITextField class]]) {
            if (idx  == 2) {
                tztUITextField* text = (tztUITextField*)obj;
                text.tztdelegate =self;
            }
        }
//        if ([obj isKindOfClass:[tztUIDroplistView class]]) {
//            if (idx  == 2) {
//                tztUIDroplistView* text = (tztUIDroplistView*)obj;
//                text.tztdelegate =self;
//            }
//        }
        
    }];
    

    
//    if (_nMsgType == MENU_JY_SB_QRSell || _nMsgType == WT_SBQRSALE
//        || _nMsgType == MENU_JY_SB_QRBuy || _nMsgType == WT_SBQRBUY)
//    {
//        tztUIDroplistView* pCodeList = (tztUIDroplistView*)[_tztTradeView getViewWithTag:kTagCode];
//        if (pCodeList && [pCodeList isKindOfClass:[tztUIDroplistView class]])
//        {
//            pCodeList.textfield.enabled = NO;
//            pCodeList.dropbtnMode = NO;
//            pCodeList.dropbtn.hidden = YES;
//            [pCodeList layoutSubviews];
//        }
//        [_tztTradeView setEditorEnable:NO withTag_:kTagCode];
//        [_tztTradeView setEditorEnable:NO withTag_:kTagPrice];
//        [_tztTradeView setEditorEnable:NO withTag_:kTagYDXH];
//        [_tztTradeView setEditorEnable:NO withTag_:kTagDFXWH];
//        
//        if (self.dictOption.count > 0)
//        {
//            NSString* strCode = [self.dictOption tztObjectForKey:@"stockcode"];
//            NSString* strPrice = [self.dictOption tztObjectForKey:@"price"];
//            NSString* strAmount = [self.dictOption tztObjectForKey:@"amount"];
//            NSString* strOppseatno = [self.dictOption tztObjectForKey:@"oppseatno"];
//            NSString* strConferNo = [self.dictOption tztObjectForKey:@"conferno"];
//            
//            [_tztTradeView setEditorText:strCode nsPlaceholder_:nil withTag_:kTagCode];
//            [_tztTradeView setEditorText:strPrice nsPlaceholder_:nil withTag_:kTagPrice];
//            [_tztTradeView setEditorText:strAmount nsPlaceholder_:nil withTag_:kTagCount];
//            [_tztTradeView setEditorText:strOppseatno nsPlaceholder_:nil withTag_:kTagDFXWH];
//            [_tztTradeView setEditorText:strConferNo nsPlaceholder_:nil withTag_:kTagYDXH];
//            
//        }
//    }
    
//    if (g_pSystermConfig.bBuySellWithTrend)
//    {
//        rcFrame.origin.y += rcFrame.size.height;
//        if(!_pTradeToolBar.hidden)
//        {
//            rcFrame.size.height = frame.size.height - (_pTradeToolBar.frame.size.height+BuySellViewHeight);
//        }
//        else
//        {
//            rcFrame.size.height = frame.size.height - BuySellViewHeight;
//        }
//        
//        if (_pMutilViews == NULL)
//        {
//            _pMutilViews = [[tztMutilScrollView alloc] init];
//            _pMutilViews.bSupportLoop = NO;
//            _pMutilViews.tztdelegate = self;
//            _pMutilViews.backgroundColor = [UIColor clearColor];
//            [self addSubview:_pMutilViews];
//            [_pMutilViews release];
//            
//            if(_pAyViews == nil)
//                _pAyViews = NewObject(NSMutableArray);
//            [_pAyViews removeAllObjects];
//            
//            _wudang = NewObject(tztUIVCBaseView);
//            _wudang.tztDelegate = self;
//            if (_bBuyFlag) {
//                _wudang.tableConfig = @"tztUIWudangSetting";
//
//            }
//            else
//            {
//                _wudang.tableConfig = @"tztUIWudangSellSetting";
//            }
//            _wudang.frame = rcFrame;
//            
//            rcFrame.size.width -= 5;
//            pTrend = [[tztTrendView alloc] initWithFrame:rcFrame];
//            pTrend.tztdelegate = self;
//            pTrend.tztPriceStyle = TrendPriceNon;
//            
//            [_pAyViews addObject:_wudang];
//            [_pAyViews addObject:pTrend];
//            [_wudang release];
//            [pTrend release];
//            
//            _pMutilViews.pageViews = _pAyViews;
//            _pMutilViews.nCurPage = 1;
//            
//            _pMutilViews.frame = rcFrame;
//        }
//    }
}

-(void)setPriceUnit
{
    _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
    
    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%ldf",(long)_nDotValid];
    self.labelPriceAdd.text = [NSString stringWithFormat:strPriceformat, _fMoveStep];
    self.labelPriceDel.text = [NSString stringWithFormat:strPriceformat, _fMoveStep];
    self.labelAmountAdd.text = @"100";
    self.labelAmountDel.text = @"100";
}

//请求分时
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
    _bRequestStockHQ = FALSE;
    self.CurStockName = @"";
    _nDotValid = 2;
    _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
    [self setPriceUnit];
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagWTAccount];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagPrice];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagCount];
    [_tztTradeView setLabelText:@"" withTag_:3000];
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagWTType];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagYDXH];//  清空席位,约定号,对方股东   Tjf
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagDFGD];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagDFXWH];
    [_ayAccount removeAllObjects];
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
    
    if (_nMsgType == MENU_JY_SB_QRSell || _nMsgType == WT_SBQRSALE
        || _nMsgType == MENU_JY_SB_QRBuy || _nMsgType == WT_SBQRBUY)
    {
        [_tztTradeView setEditorText:@"" nsPlaceholder_:nil withTag_:kTagCount];
    }
    else
    {
        [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagCode];
        //清空可编辑的droplist控件数据 // byDBQ20130814
        [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagCode];
        [_tztTradeView setComBoxTextField:kTagCode];
        [self ClearDataWithOutCode];
        self.CurStockCode = @"";
        self.nsWTAccount = @"";
        self.nsWTAccountType = @"";
        [self requestTrend];
    }
}

// 清空，以刷新委托价格 byDBQ20131115
- (void)clearUnusedData
{
    if (_nMsgType == MENU_JY_SB_QRSell || _nMsgType == WT_SBQRSALE
        || _nMsgType == MENU_JY_SB_QRBuy || _nMsgType == WT_SBQRBUY)
        return;
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagPrice];
    self.nsNewPrice = @"";
}

-(void)setTipsShow:(NSString*)strAmount
{
    //¥
    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%ldf",(long)_nDotValid];
    NSString* strMoneyformat = [NSString stringWithFormat:@" %%.%ldf",(long)_nDotValid];
    
    NSString* strPrice = [_tztTradeView GetEidtorText:kTagPrice];
    NSString* nsPrice = [NSString stringWithFormat:strPriceformat, [strPrice floatValue]];
    
    NSString* strMoney = @"";
    if ([strAmount intValue] > 0 && [nsPrice floatValue] >= _fMoveStep)
    {
        strMoney = [NSString stringWithFormat:strMoneyformat, [nsPrice floatValue] * [strAmount intValue]];
    }
    else
    {
        _nTimerCount = 0;
        _labelMoneyTips.alpha = 0;
        _labelMoneyTips.hidden = YES;
        return;
    }
    
    if (_nTimerCount <= 0)
    {
        _labelMoneyTips.alpha = 0;
        _labelMoneyTips.hidden = NO;
    }
    [UIView animateWithDuration:0.2f
                     animations:^(void){
                         _labelMoneyTips.alpha = 1.0f;
                         _labelMoneyTips.text = [NSString stringWithFormat:@"%@  不含手续费", strMoney];
                     }
                     completion:^(BOOL bFinished){
                         if (bFinished)
                         {
                             _nTimerCount++;
                             [NSTimer scheduledTimerWithTimeInterval:3.f
                                                              target:self
                                                            selector:@selector(OnTimer)
                                                            userInfo:nil
                                                             repeats:NO];
                         }
                     }];
}

//定时显示消失委托金额显示
-(void)OnTimer
{
    _nTimerCount--;
    if (_nTimerCount < 0)
    {
        _nTimerCount = 0;
        return;
    }
    if (_nTimerCount <= 0)
    {
        [UIView animateWithDuration:.5f
                         animations:^{
                             _labelMoneyTips.alpha = 0.2;
                         } completion:^(BOOL bFinished){
                             if (bFinished)
                                 _labelMoneyTips.hidden = YES;
                         }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([((tztUITextField*)textField).tzttagcode intValue] == kTagCode)
    {
        if (self.CurStockCode.length == 6)
        {
            textField.text = self.CurStockCode;
        }
    }
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView beginEditText:(NSString *)text
{
    if ([((tztUITextField*)tztUIBaseView).tzttagcode intValue] == kTagCode)
    {
        if (self.CurStockCode.length == 6)
        {
            ((tztUITextField*)tztUIBaseView).text = self.CurStockCode;
        }
    }
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
                [self ClearData];
			}
            
			if (inputField.text != NULL && inputField.text.length == 6)
			{
                if (self.CurStockCode && [self.CurStockCode compare:inputField.text] != NSOrderedSame)
                {
                    self.nsWTAccount = @"";
                    self.nsWTAccountType = @"";
                    self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                    [self ClearDataWithOutCode];
                }
                self.ns6Text = inputField.text;
			}
            else if (inputField.text.length == 7)
            {
                inputField.text = self.ns6Text;
                break;
            }
            else if (inputField.text.length > 6)
            {
                break;
            }
            else
            {
                self.nsWTAccount = @"";
                self.nsWTAccountType = @"";
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
                self.nsWTAccount = @"";
                self.nsWTAccountType = @"";
                self.CurStockCode = @"";
				//清空界面其它数据
                [self ClearData];
			}
            
			if (inputField.text != NULL && inputField.text.length == 6)
			{
                if (self.CurStockCode && [self.CurStockCode compare:inputField.text] != NSOrderedSame)
                {
                    self.nsWTAccount = @"";
                    self.nsWTAccountType = @"";
                    self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                    [self ClearDataWithOutCode];
                }
			}
            else
            {
                self.nsWTAccount = @"";
                self.nsWTAccountType = @"";
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
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagCode:
        {
            if (self.CurStockCode.length <= 0)
                return;
            if (self.CurStockName.length > 0)
            {
                [_tztTradeView setEditorText:[NSString stringWithFormat:@"%@(%@)",self.CurStockCode, self.CurStockName]
                              nsPlaceholder_:nil
                                    withTag_:nTag
                                   andNotifi:NO];
                [_tztTradeView setComBoxText:[NSString stringWithFormat:@"%@(%@)",self.CurStockCode, self.CurStockName]
                                    withTag_:nTag];
            }
            else
            {
                [_tztTradeView setEditorText:[NSString stringWithFormat:@"%@", self.CurStockCode]
                              nsPlaceholder_:nil
                                    withTag_:nTag
                                   andNotifi:NO];
                [_tztTradeView setComBoxText:[NSString stringWithFormat:@"%@", self.CurStockCode]
                                    withTag_:nTag];
            }
        }
            break;
        case kTagStockCode:
        {
            if (self.CurStockCode.length <= 0)
                return;
            if (self.CurStockName.length > 0)
                [_tztTradeView setComBoxText:[NSString stringWithFormat:@"%@(%@)",self.CurStockCode, self.CurStockName]
                                    withTag_:nTag];
            else
                [_tztTradeView setComBoxText:[NSString stringWithFormat:@"%@", self.CurStockCode]
                                    withTag_:nTag];
        }
            break;
        case kTagPrice:
        {
            if(!_bBuyFlag)
                return;
            if (![tztUIBaseView isFirstResponder])
                return;
            NSString* strPrice = [NSString stringWithFormat:strPriceformat, [inputField.text floatValue]];
            if (_tztTradeView)
            {
                if(strPrice && [strPrice length] > 0 && [strPrice floatValue] >= _fMoveStep)
                {
                    [self OnRefreshWithAccountType:self.nsWTAccountType andMarketNo:nil];
                }
                else
                {
                    if (g_pSystermConfig.bBuySellWithTrend && _wudang)
                        [_wudang setButtonTitle:@"" clText_:[UIColor tztThemeHQUpColor] forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
                    else
                        [_tztTradeView setButtonTitle:@"" clText_:[UIColor tztThemeHQUpColor] forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
                }
            }
        }
            break;
        default:
            break;
    }
}

/*未知用途，待确认**/
-(void)setAppointmentSerial:(NSString*)nsCode
{
    if (nsCode == NULL )
        return;
    if (_tztTradeView )
    {
        if ([_tztTradeView getViewWithTag:kTagYDXH])
        {
            [_tztTradeView setEditorText:nsCode nsPlaceholder_:NULL withTag_:kTagYDXH];
           
        }
       
    }
    
}

-(void)setTradeUnit:(NSString*)nsCode
{
    if (nsCode == NULL )
        return;
    if (_tztTradeView )
    {
        if ([_tztTradeView getViewWithTag:kTagDFXWH])
        {
            [_tztTradeView setEditorText:nsCode nsPlaceholder_:NULL withTag_:kTagDFXWH];
            
        }
    }
}


// 请求股转转让类型 xinlan
-(void)transferType
{
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
    
    
}
//请求约定序号
-(void)searchTradeUnit{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
    {
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    if (_nMsgType == MENU_JY_SB_QRBuy) {
        [pDict setTztValue:@"OS" forKey:@"YXMMLB"];
    }
    if (_nMsgType == MENU_JY_SB_QRSell) {
        [pDict setTztValue:@"OB" forKey:@"YXMMLB"];
    }
    [pDict setTztValue:@"SBACCOUNT" forKey:@"WTACCOUNTTYPE"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
    {
        _ntztReqNo = 1;
    }
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"199" withDictValue:pDict];
    
}
/**/

-(void)setStockCode:(NSString*)nsCode
{
    if (nsCode == NULL || [nsCode length] < 6)
    {
        [self ClearData];
        return;
    }
    self.nsMarketNo = @"";
    self.ns6Text = @"";
    if (_tztTradeView)
    {
        if ([_tztTradeView getViewWithTag:kTagCode])
        {
            [_tztTradeView setEditorText:nsCode nsPlaceholder_:NULL withTag_:kTagCode andNotifi:NO];
            self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
            [_tztTradeView setComBoxText:nsCode withTag_:kTagStockCode];
            [self OnRefreshWithAccountTypeEx:self.nsWTAccountType andMarketNo:nil bNeedReqdef:NO];
        }
        else if ([_tztTradeView getViewWithTag:kTagStockCode])
        {
            self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
            [_tztTradeView setComBoxText:nsCode withTag_:kTagStockCode];
            [self OnRefreshWithAccountTypeEx:self.nsWTAccountType andMarketNo:nil bNeedReqdef:NO];
        }
    }
    
}


-(void)setWTAccount:(NSString*)nsAccount andAccountType:(NSString*)nsAccountType
{
    if (ISNSStringValid(nsAccount))
        self.nsWTAccount = [NSString stringWithFormat:@"%@", nsAccount];
    else
        self.nsWTAccount = @"";
    if (ISNSStringValid(nsAccountType))
        self.nsWTAccountType = [NSString stringWithFormat:@"%@", nsAccountType];
    else
        self.nsWTAccountType = @"";
}


-(void)setCanChange:(BOOL)bChange
{
    _bCanChange = bChange;
}

//请求股票信息
-(void)OnRefresh
{
    NSString* str = nil;
    if (self.nsMarketNo)
        str = [NSString stringWithFormat:@"%@", self.nsMarketNo];
    [self OnRefreshWithAccountType:self.nsWTAccountType andMarketNo:str];
}

-(void)OnRefreshWithAccountType:(NSString*)nsAccountType andMarketNo:(NSString*)nsMarketNo
{
    [self OnRefreshWithAccountTypeEx:nsAccountType andMarketNo:nsMarketNo bNeedReqdef:YES];
}


-(void)OnRequestStockInfo
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    if (self.nsWTAccountType.length > 0)
    {
        [pDict setTztValue:self.nsWTAccountType forKey:@"WTACCOUNTTYPE"];
    }
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5061" withDictValue:pDict];
    DelObject(pDict);
}

-(void)OnRefreshWithAccountTypeEx:(NSString*)nsAccountType andMarketNo:(NSString*)nsMarketNo bNeedReqdef:(BOOL)bNeed
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    if (nsAccountType.length <= 0)
    {
        [self OnRequestStockInfo];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    [pDict setTztValue:@"1" forKey:@"Accountlist"];
    [pDict setTztValue:@"2" forKey:@"AccountIndex"];
    
    if (nsMarketNo.length > 0)
        self.nsMarketNo = [NSString stringWithFormat:@"%@", nsMarketNo];
    
    if(_tztTradeView)
    {
        NSString* strPrice =  [_tztTradeView GetEidtorText:kTagPrice];
        if(strPrice && [strPrice length] > 0 && [strPrice floatValue] > 0)
        {
            [pDict setTztValue:strPrice forKey:@"PRICE"];
        }
        
        //获取pricetype
        NSInteger select = [self.tztTradeView getComBoxSelctedIndex:kTagWTType];
        NSString * PriceType = @"";
        if (select >= 0 && select < [self.ayTransType count])
        {
            PriceType = [self.ayTransType objectAtIndex:select];
        }
        else if (g_pSystermConfig.bSBSpecialPriceType)
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
    
    if (nsMarketNo.length > 0)
        [pDict setTztValue:nsMarketNo forKey:@"NewMarketNo"];
    
    if (nsAccountType.length > 0)
    {
        [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
        if (bNeed)
        {
            tztNewReqno *reqno = [tztNewReqno reqnoWithString:strReqNo];
            [reqno setReqdefOne:10050];
            strReqNo = [reqno getReqnoValue];
            [pDict setTztObject:strReqNo forKey:@"Reqno"];
        }
    }
    
    if (_bBuyFlag || _nMsgType == MENU_JY_PT_NiHuiGou)
    {
        if (self.nsWTAccount.length > 0)
            [pDict setTztObject:self.nsWTAccount forKey:@"WTAccount"];
        
        [pDict setTztValue:@"B" forKey:@"Direction"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
    }
    else
    {
        if (self.nsWTAccount.length > 0)
            [pDict setTztObject:self.nsWTAccount forKey:@"WTAccount"];
        
        [pDict setTztValue:@"S" forKey:@"Direction"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"151" withDictValue:pDict];
    }
    DelObject(pDict);
//    [tztUIProgressView showWithMsg:@"正在处理，请稍候..."];
}

-(void)InquireHQData:(BOOL)bTimer
{
    if (self.CurStockCode.length < 6)
        return;
    NSMutableDictionary *dict = NewObject(NSMutableDictionary);
    _ntztReqNoHQ++;
    if (_ntztReqNoHQ >= UINT16_MAX)
        _ntztReqNoHQ = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNoHQ);
    [dict setTztObject:strReqno forKey:@"Reqno"];
    
    if (!bTimer)
    {
        tztNewReqno *newreqno = [tztNewReqno reqnoWithString:strReqno];
        [newreqno setReqdefOne:10050];
        strReqno = [newreqno getReqnoValue];
        [dict setTztObject:strReqno forKey:@"Reqno"];
    }
    
    [dict setTztObject:self.CurStockCode forKey:@"StockCode"];
    [dict setTztObject:(_bBuyFlag ? @"0" : @"1") forKey:@"BuySell"];
    if (self.nsWTAccountType.length > 0)
        [dict setTztObject:self.nsWTAccountType forKey:@"WTAccountType"];
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"33" withDictValue:dict];
    DelObject(dict);
}

//发送请求 设置定时器
-(NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (self.hidden)
        return 0;
    //modify by xyt 20130731 当查询成功后,设置成TRUE才去定时刷新
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return 0;
    if (!_bRequestStockHQ)
        return 0;
    
    NSUInteger ntranstype = wParam;
    //不是行情刷新，
    if(!tztSessionType_IS(ntranstype, tztSession_ExchangeHQ))
        return 0;
    
    TZTLogInfo(@"%@", @"买卖界面行情定时刷新\r\n");
    
    [self InquireHQData:YES];
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
    
    if ((![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        && [newReqno getReqno] != 0
        && (![pParse IsIphoneKey:(long)self reqno:_ntztReqNoHQ]))
        return 0;
    
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];
    
    if ([tztBaseTradeView IsExitError:nErrNo] && [newReqno getReqno] != 0)
    {
        [self OnNeedLoginOut];
        if (strError)
            tztAfxMessageBox(strError);
        return 0;
    }
    
    if (nErrNo < 0)
    {
        if ([pParse IsAction:@"33"])
        {
            _bRequestStockHQ = FALSE;
            //33失败，不能影响后面的处理
            tztNewReqno *reqno = [tztNewReqno reqnoWithString:strReqno];
            if ([reqno getReqdefOne] == 10050)//只有获取主动获取行情的时候，因为得到最新价，重新刷新可买可卖，定数刷新的都不再请求
                [self OnRefreshWithAccountType:self.nsWTAccountType andMarketNo:nil];
            
            return 0;
        }
        else if ([pParse IsAction:@"110"] || [pParse IsAction:@"178"])
        {
//            [tztUIProgressView hidden];
        }
        if ([pParse IsAction:@"150"] || [pParse IsAction:@"151"])
        {
//            [tztUIProgressView hidden];
            if (nErrNo == COMM_ERR_NO_SAMECODE)
            {
                NSArray *ayGrid2 = [pParse GetArrayByName:@"accountlist"];
                if (ayGrid2.count > 0)
                {
                    int nWTAccountType = -1;
                    int nStockCode = -1;
                    int nStockName = -1;
                    NSString* strIndex = [pParse GetByName:@"STOCKCODEINDEX"];
                    TZTStringToIndex(strIndex, nStockCode);
                    if (nStockCode < 0)
                        nStockCode = 0;
                    
                    strIndex = [pParse GetByName:@"STOCKNAMEINDEX"];
                    TZTStringToIndex(strIndex, nStockName);
                    if (nStockName < 0)
                        nStockName = 1;
                    
                    strIndex = [pParse GetByName:@"WTACCOUNTTYPEINDEX"];
                    TZTStringToIndex(strIndex, nWTAccountType);
                    if (nWTAccountType < 0)
                        nWTAccountType = 2;
                    
                    NSMutableArray *ayShow = NewObject(NSMutableArray);
                    //股票代码|股票名称|新市场号|股票属性|
                    for (NSArray* ayData in ayGrid2)
                    {
                        NSString* strCode = @"";
                        NSString* strName = @"";
                        NSString* strMarket = @"";
                        
                        if (nStockCode >= 0 && nStockCode < ayData.count)
                            strCode = [ayData objectAtIndex:nStockCode];
                        if (strCode.length < 1)
                            continue;
                        if (nStockName >= 0 && nStockName < ayData.count)
                            strName = [ayData objectAtIndex:nStockName];
                        if (nWTAccountType >= 0 && nWTAccountType < ayData.count)
                            strMarket = [ayData objectAtIndex:nWTAccountType];
                        NSString* strNewMarketNo = @"";
                        if (ayData.count > 4)
                            strNewMarketNo = [ayData objectAtIndex:4];
                        
                        NSString* strTitle = [NSString stringWithFormat:@"|%@ %@|%@|%@|%@", strCode, strName, strCode, strMarket, strNewMarketNo];
                        [ayShow addObject:strTitle];
                    }
                    
                    if (ayShow.count > 0)
                    {
                        /*增加解析判断是否有多个股票代码，若存在多个，则弹出让用户选择，然后再根据选择的股票代码，带上相应的股东账户类型信息重新请求指定的股票数据*/
                        UIView *window = [UIApplication sharedApplication].keyWindow;
                        tztToolbarMoreView *pMoreView = (tztToolbarMoreView*)[window viewWithTag:0x7878];
                        if (pMoreView == NULL)
                        {
                            CGRect rcFrame = [UIScreen mainScreen].bounds;
                            pMoreView = [[tztToolbarMoreView alloc] init];
                            pMoreView.bgColor = [UIColor tztThemeBackgroundColorJY];
                            pMoreView.clText = [UIColor tztThemeTextColorButton];
                            pMoreView.clSeporater = [UIColor tztThemeJYGridColor];
                            pMoreView.clBorderColor = [UIColor tztThemeBorderColor];
                            pMoreView.fBorderWidth = 0.5f;
                            pMoreView.nShowType = tztShowType_List;
                            pMoreView.fCellHeight = 45;
                            UIView *pView = [_tztTradeView getViewWithTag:kTagCode];
                            pMoreView.fMenuWidth = pView.frame.size.width;
                            pMoreView.szOffset = CGSizeMake(pView.frame.origin.x,  [pView gettztwindowy:nil] + pView.frame.size.height);
                            pMoreView.tag = 0x7878;
                            pMoreView.nPosition = tztToolbarMoreViewPositionTop;
                            [pMoreView SetAyGridCell:ayShow];
                            pMoreView.frame = rcFrame;
                            pMoreView.pDelegate = self;
                            [window addSubview:pMoreView];
                            [pMoreView release];
                        }
                        else
                        {
                            [pMoreView removeFromSuperview];
                        }
                        /**/
                    }
                    return 1;
                }
            }
        }
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
    else if ([pParse IsAction:@"110"] || [pParse IsAction:@"350"] || [pParse IsAction:@"351"])
    {
#ifdef tzt_ChaoGen
        //zxl 20130801 修改了炒跟分享的时候先需要的是数据保存传送到炒跟中 发送请求的时候再传送过来
        tztChaoGenView *pChaogen = [[tztChaoGenView alloc] initWithTitle:@"" message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" delegate:self block:nil cancelButtonTitle:nil otherButtonTitles:nil];
        
        pChaogen.tag = 0x9888;
        pChaogen.nsWTMsg = strError;
        pChaogen.nsNeiRong = [NSString stringWithFormat:@"委托买入： %@|委托价格： %@元。",self.CurStockCode,[_tztTradeView GetEidtorText:kTagPrice]];
        NSString* nsAccount = [_ayAccount objectAtIndex:[_tztTradeView getComBoxSelctedIndex:kTagWTAccount]];

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
        
//        [tztUIProgressView hidden];
        return 0;
    }
    else if ([pParse IsAction:@"178"])//178-股转系统处理
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
//        [tztUIProgressView hidden];
        return 0;
    }
    else if ([pParse IsAction:@"5061"])
    {
        int nIndexCode = -1;//代码
        int nIndexName = -1;//名称
        int nIndexType = -1;//市场
        
        NSString* strIndex = [pParse GetByName:@"StockCodeIndex"];
        TZTStringToIndex(strIndex, nIndexCode);
        
        strIndex = [pParse GetByName:@"StockNameIndex"];
        TZTStringToIndex(strIndex, nIndexName);
        
        strIndex = [pParse GetByName:@"WTAccountTypeIndex"];
        TZTStringToIndex(strIndex, nIndexType);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        NSMutableArray *ayShow = NewObject(NSMutableArray);
        //
        BOOL bOnlyCode = FALSE;
        if (ayGrid.count == 2)
            bOnlyCode = YES;
        
        for (int i = 1; i < ayGrid.count; i++)//第0行为标题
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            
            NSString* strCode = @"";
            NSString* strName = @"";
            NSString* strMarket = @"";
            
            strCode = tztGetDataInArrayByIndex(ayData, nIndexCode);
            if (strCode.length < 1)
                continue;
            strName = tztGetDataInArrayByIndex(ayData, nIndexName);
            if (strName == NULL)
                strName = @"";
            strMarket = tztGetDataInArrayByIndex(ayData, nIndexType);
            
            if (bOnlyCode && strMarket)
                self.nsWTAccountType = [NSString stringWithFormat:@"%@", strMarket];
            else
                self.nsWTAccountType = @"";
            NSString* strTitle = [NSString stringWithFormat:@"|%@ %@|%@|%@", strCode, strName, strCode, strMarket];
            [ayShow addObject:strTitle];
        }
        
        
        if (ayShow.count > 1)
        {
            /*增加解析判断是否有多个股票代码，若存在多个，则弹出让用户选择，然后再根据选择的股票代码，带上相应的股东账户类型信息重新请求指定的股票数据*/
            UIView *window = [UIApplication sharedApplication].keyWindow;
            tztToolbarMoreView *pMoreView = (tztToolbarMoreView*)[window viewWithTag:0x7878];
            if (pMoreView)
            {
                [pMoreView removeFromSuperview];
                pMoreView = NULL;
            }
            if (pMoreView == NULL)
            {
                
                CGRect rcFrame = [UIScreen mainScreen].bounds;
                pMoreView = [[tztToolbarMoreView alloc] init];
                pMoreView.bgColor = [UIColor tztThemeBackgroundColorJY];
                pMoreView.clText = [UIColor tztThemeTextColorButton];
                pMoreView.clSeporater = [UIColor tztThemeJYGridColor];
                pMoreView.clBorderColor = [UIColor tztThemeBorderColor];
                pMoreView.fBorderWidth = 0.5f;
                pMoreView.nShowType = tztShowType_List;
                pMoreView.fCellHeight = 45;
                UIView *pView = [_tztTradeView getViewWithTag:kTagCode];
                pMoreView.fMenuWidth = pView.frame.size.width;
                pMoreView.szOffset = CGSizeMake(pView.frame.origin.x,  [pView gettztwindowy:nil] + pView.frame.size.height);
                pMoreView.tag = 0x7878;
                pMoreView.nPosition = tztToolbarMoreViewPositionTop;
                [pMoreView SetAyGridCell:ayShow];
                pMoreView.frame = rcFrame;
                pMoreView.pDelegate = self;
                [window addSubview:pMoreView];
                [pMoreView release];
            }
            else
            {
                [pMoreView removeFromSuperview];
            }
            /**/
        }
        else
        {
            [self InquireHQData:NO];
        }
    }
    if ([pParse IsAction:@"150"] || [pParse IsAction:@"151"] || [pParse IsAction:@"428"] || [pParse IsAction:@"429"])
    {
//        [tztUIProgressView hidden];
        NSString* strCode = [pParse GetByName:@"StockCode"];
        if (strCode == NULL || [strCode length] <= 0)//错误
            return 0;
        //返回的跟当前的代码不一致
        if ([strCode compare:self.CurStockCode] != NSOrderedSame)
        {
            return 0;
        }
        _bRequestStockHQ = YES;
        //股票名称
        NSString* strName = [pParse GetByNameUnicode:@"Title"];
        if (strName && [strName length] > 0)
        {
            self.CurStockName = [NSString stringWithFormat:@"%@",strName];
            UIView *pView = [_tztTradeView getViewWithTag:kTagCode];
            
            BOOL bFirst = YES;
            if ([pView isKindOfClass:[tztUIDroplistView class]])
                bFirst = [((tztUIDroplistView*)pView).textfield isFirstResponder];
            else
                bFirst = [pView isFirstResponder];
            if (self.CurStockName.length > 0 && !bFirst)
            {
                [_tztTradeView setEditorText:[NSString stringWithFormat:@"%@(%@)", self.CurStockCode, self.CurStockName] nsPlaceholder_:nil withTag_:kTagCode andNotifi:NO];
                [_tztTradeView setComBoxText:[NSString stringWithFormat:@"%@(%@)", self.CurStockCode, self.CurStockName] withTag_:kTagCode];
            }
        }
        else
        {
            if (_tztTradeView)
            {
                [_tztTradeView setLabelText:@"" withTag_:3000];
            }
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
        if (_ayAccountName == nil)
            _ayAccountName = NewObject(NSMutableArray);
        
        [_ayAccount removeAllObjects];
        [_ayType removeAllObjects];
        [_ayStockNum removeAllObjects];
        [_ayTypeContent removeAllObjects];
        [_ayAccountName removeAllObjects];
        
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
                
                NSString* strAccountName = [self transType2Content:strType];
                [_ayTypeContent addObject:strAccountName];
                
                [_ayAccountName addObject:[NSString stringWithFormat:@"%@(%@)", strAccount, strAccountName]];
                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayStockNum addObject:strNum];
            }
        }
        
        //获取委托类型
        NSInteger accoutIndex = -1;//[self.tztTradeView getComBoxSelctedIndex:kTagWTAccount];
        
        if (accoutIndex < 0 || accoutIndex >= [_ayType count])
            accoutIndex = 0;
        
        
        [_tztTradeView setComBoxData:_ayAccountName ayContent_:_ayType AndIndex_:accoutIndex withTag_:kTagWTAccount];// 始终显示账号+中文  怎么改
        [_tztTradeView setComBoxText:[_ayAccountName objectAtIndex:accoutIndex] withTag_:kTagWTAccount];
        
        NSInteger select = [_tztTradeView getComBoxSelctedIndex:kTagWTType];
        NSString * PriceType = @"";
        if (select >= 0 && select < [self.ayTransType count])
            PriceType = [self.ayTransType objectAtIndex:select];
        else
            PriceType = @"0";
        
        if (accoutIndex < 0 || accoutIndex >= [_ayType count])
            accoutIndex = 0;
        
        //            [_tztTradeView setComBoxData:_ayAccountName ayContent_:_ayType AndIndex_:accoutIndex withTag_:kTagWTAccount];// 始终显示账号+中文  怎么改
        //            [_tztTradeView setComBoxText:[_ayAccount objectAtIndex:accoutIndex] withTag_:kTagWTAccount];
        
        
        //添加判断 add by xyt 20130917
        if (_ayType && [_ayType count] > 0)
        {
            [self SetTransType:[_ayType objectAtIndex:accoutIndex] nIndex_:select];
        }
        
        //wry
//        [_tztTradeView setComBoxText:self.nsNewPrice withTag_:kTagPrice];

        NSString* nsNowPrice = @"";
        nsNowPrice = [_tztTradeView GetEidtorText:kTagPrice];
        UIView  *pView = [_tztTradeView getViewWithTag:kTagPrice];
        if(([PriceType compare:@"0"] == NSOrderedSame))
        {
            if (pView && ![pView isFirstResponder]
                && _nMsgType != MENU_JY_SB_QRSell && _nMsgType != WT_SBQRSALE
                && _nMsgType != MENU_JY_SB_QRBuy && _nMsgType != WT_SBQRBUY)
            {
                if (nsNowPrice == nil || [nsNowPrice length] <= 0 || [nsNowPrice floatValue] < _fMoveStep)
                    //没有输入价格
                {
                    UIView* pEditor = [_tztTradeView getViewWithTag:kTagPrice];
                    if (pEditor != NULL && [pEditor isKindOfClass:[tztUITextField class]])
                    {
                        [(tztUITextField*)pEditor setText:self.nsNewPrice];
                    }
                }
            }
        }
        else
        {
            [_tztTradeView setEditorText:@"市价委托" nsPlaceholder_:NULL withTag_:kTagPrice];
            [_tztTradeView setEditorEnable:NO withTag_:kTagPrice];
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
            
            if (g_pSystermConfig.bBuySellWithTrend && _wudang)
                [_wudang setButtonTitle:nsValue clText_:[UIColor tztThemeHQUpColor] forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
            else
                [_tztTradeView setButtonTitle:nsValue clText_:[UIColor tztThemeHQUpColor] forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
        }
        
//        //有效小数位
//        NSString *nsDot = [pParse GetByName:@"Volume"];
//        if (ISNSStringValid(nsDot))
//            _nDotValid = [nsDot intValue];
//        _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
//        
//        [self setPriceUnit];
//        [_tztTradeView setEditorDotValue:_nDotValid withTag_:kTagPrice];
        
        //可用资金
        NSString* nsMoney = [pParse GetByName:@"Banklsh"];//bankvolume
        if (nsMoney == NULL || [nsMoney length] < 1)
        {
            nsMoney = [pParse GetByName:@"Usable"];
            if (nsMoney == NULL || [nsMoney length] < 1)
            {
                nsMoney = [pParse GetByName:@"BankVolume"];
                if (nsMoney == NULL || [nsMoney length] < 1)
                    nsMoney = @"--";
            }
        }
        
        NSString* nsValue = tztdecimalNumberByDividingBy(nsMoney, 2);
        
        if (g_pSystermConfig.bBuySellWithTrend && _wudang) {
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
        
        if (self.nsWTAccountType.length <= 0)
        {
            NSInteger nSelect = [_tztTradeView getComBoxSelctedIndex:kTagWTType];
            if (nSelect < 0 )
                nSelect = 0;
            
            if (nSelect >= 0 && nSelect < _ayType.count)
                self.nsWTAccountType = [NSString stringWithFormat:@"%@", [_ayType objectAtIndex:nSelect]];
        }
        
        tztNewReqno *reqno = [tztNewReqno reqnoWithString:strReqno];
        if ([reqno getReqdefOne] != 10050)
        {
            [self InquireHQData:NO];
        }
        
        //如果是三板的代码 请求转入类型 wry ---  ----
        switch (_nMsgType) {
            case WT_SBYXBUY: //限价买入
            case MENU_JY_SB_YXBuy:
            case WT_SBYXSALE://三板意向卖出 限价卖出
            case MENU_JY_SB_YXSell:
            {
                [self transferType];
                [self requestTrend];
        
            }
            default:
                break;
        }
   }
    else if ([pParse IsAction:@"33"])
    {
        NSString* strCode = [pParse GetByName:@"StockCode"];
        if ([self.CurStockCode caseInsensitiveCompare:strCode] != NSOrderedSame)
            return 0;
        //股票名称
        NSString* strName = [pParse GetByNameUnicode:@"Title"];
        if (strName && [strName length] > 0)
        {
            self.CurStockName = [NSString stringWithFormat:@"%@",strName];
            UIView *pView = [_tztTradeView getViewWithTag:kTagCode];

            BOOL bFirst = YES;
            if ([pView isKindOfClass:[tztUIDroplistView class]])
                bFirst = [((tztUIDroplistView*)pView).textfield isFirstResponder];
            else
                bFirst = [pView isFirstResponder];
            if (self.CurStockName.length > 0 && !bFirst)
            {
                [_tztTradeView setEditorText:[NSString stringWithFormat:@"%@(%@)", self.CurStockCode, self.CurStockName] nsPlaceholder_:nil withTag_:kTagCode andNotifi:NO];
                [_tztTradeView setComBoxText:[NSString stringWithFormat:@"%@(%@)", self.CurStockCode, self.CurStockName] withTag_:kTagCode];
            }
        }
        
        //有效小数位
        NSString *nsDot = [pParse GetByName:@"Volume"];
        _nDotValid = [nsDot intValue];
        _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
        
        [self setPriceUnit];
        [_tztTradeView setEditorDotValue:_nDotValid withTag_:kTagPrice];
        
        
        if (_tztTradeView)
        {
            //当前价格
            NSString* nsPrice = [pParse GetByName:@"ContactID"];
            if (!ISNSStringValid(nsPrice))
                nsPrice = [pParse GetByName:@"Price"];
            
            if (!ISNSStringValid(nsPrice))
                nsPrice = @"";
            self.nsNewPrice = [NSString stringWithFormat:@"%@", nsPrice];
            
            //wry 设置价格后面会去取值
            [_tztTradeView setEditorText:self.nsNewPrice nsPlaceholder_:@"" withTag_:kTagPrice];
        }


        [self DealWithBuySell:pParse];
        tztNewReqno *reqno = [tztNewReqno reqnoWithString:strReqno];
        if ([reqno getReqdefOne] == 10050)
            [self OnRefreshWithAccountType:self.nsWTAccountType andMarketNo:nil];
    }
    else if ([pParse IsAction:@"117"] || [pParse IsAction:@"5173"])
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
            [_tztTradeView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTagCode bDrop_:YES];
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
    else if ([pParse IsAction:@"5124"]) //获取股转类型数据
    {
        int ntransTypeIndex=-1;
        if ([[pParse GetErrorMessage]isEqualToString:@"查无记录!"])
        {
            [ self showMessageBox:[pParse GetErrorMessage] nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
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
    if ([pParse IsAction:@"199"]){
        
        NSString* strErrMsg = [pParse GetErrorMessage];
        if (strErrMsg.length>0)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        //基础索引，所以放在此处
        
        int wtjg=-1;//委托价格
        int wtSl = -1;//委托数量
        int ydxh =-1;//约定序号
        int xwhm= -1;//席位号码
        NSString* strIndex = [pParse GetByName:@"ENTRUSTPRICE"];
        TZTStringToIndex(strIndex, wtjg);
        
        strIndex = [pParse GetByName:@"AMOUNTINDEX"];
        TZTStringToIndex(strIndex, wtSl);
        
        strIndex = [pParse GetByName:@"CONFERNOINDEX"];
        TZTStringToIndex(strIndex, ydxh);
        
        strIndex = [pParse GetByName:@"SEATNOINDEX"];
        TZTStringToIndex(strIndex, xwhm);
        
        
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        
        NSString* Nprice = @"";
        NSString* Nshuliang =@"";
        NSString *Nydh=@"";
        NSString*Nxyh =@"";
        [self.yxdArray removeAllObjects];
        [self.ydhArray removeAllObjects];
        [self.xwhArray removeAllObjects];
        for (int i = 1; i < [ayGrid count]; i++)
        {//第一行是提示标题
            
            NSArray *pAy = [ayGrid objectAtIndex:i];
            
            if (pAy.count>wtjg) Nprice = pAy[wtjg];
            
            if (pAy.count>wtSl) Nshuliang = pAy[wtSl];
            
            if (pAy.count>ydxh) Nydh = pAy[ydxh];
            
            if (pAy.count>xwhm) Nxyh = pAy[xwhm];
            
            if ([Nprice isEqualToString:@" "] &&[Nshuliang isEqualToString:@" "] && [Nydh isEqualToString:@" "] && [Nxyh isEqualToString:@" "]) {
                tztAfxMessageBox(@"查无意向单");
                break;
                return 1;
            }
            if (Nprice.length>0 || Nshuliang.length>0) {
                NSString *left = [Nprice stringByAppendingString:@"("];
                NSString*right = [Nshuliang stringByAppendingString:@")"];
                NSString*str = [left stringByAppendingString:right];
                [self.yxdArray addObject:str];
                
            }
            
            if (Nydh.length>0) {
                [self.ydhArray addObject:Nydh];
            }
            
            if (Nxyh.length>0) {
                [self.xwhArray addObject:Nxyh];
            }
            
        }
        
        if (self.yxdArray.count>0) {
            [_tztTradeView setComBoxData:self.yxdArray ayContent_:self.yxdArray AndIndex_:0 withTag_:kTagYXD];
        }
        
        if (self.ydhArray.count>0) {
            [_tztTradeView setEditorText:self.ydhArray[0] nsPlaceholder_:@"输入约定序号" withTag_:2003];
        }
        if (self.xwhArray.count>0) {
            [_tztTradeView setEditorText:self.xwhArray[0] nsPlaceholder_:@"输入对方席位号" withTag_:2004];
        }
        
        
    }
    
    return 1;
}
    
   

// 将市场类型转换成中文
- (NSString *)transType2Content:(NSString *)string
{
    if ([[string uppercaseString] isEqualToString:@"SHACCOUNT"] || [[string uppercaseString] isEqualToString:@"RZRQSHACCOUNT"]) {
        return @"上海A";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SZACCOUNT"] || [[string uppercaseString]  isEqualToString:@"RZRQSZACCOUNT"]) {
        return @"深圳A";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SHBACCOUNT"] || [[string uppercaseString]  isEqualToString:@"RZRQSHBACCOUNT"]) {
        return @"上海B";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SZBACCOUNT"] || [[string uppercaseString]  isEqualToString:@"RZRQSZBACCOUNT"]) {
        return @"深圳B";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SBACCOUNT"] || [[string uppercaseString]  isEqualToString:@"RZRQSBACCOUNT"]) {
        return @"三板A";
    }
    else if ([[string uppercaseString]  isEqualToString:@"SBBACCOUNT"] || [[string uppercaseString]  isEqualToString:@"RZRQSBBACCOUNT"]) {
        return @"三板B";
    }
    else if ([[string uppercaseString]  isEqualToString:@"HKACCOUNT"]) {
        return @"沪HK";
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
                ( ([nsValue floatValue] > dPClose) ? [UIColor tztThemeHQUpColor] : [UIColor tztThemeHQDownColor] );
            else
                cl = ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? [UIColor tztThemeHQBalanceColor] :
                ( ([nsValue floatValue] > dPClose) ? [UIColor tztThemeHQUpColor] : [UIColor tztThemeHQDownColor] );
        }
        if (g_pSystermConfig.bBuySellWithTrend && _wudang) {
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
            
            UIColor* txtColor = nil;
            if (g_nThemeColor == 1 || g_nSkinType == 1)
                txtColor = ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? [UIColor darkTextColor] :
                ( ([nsValue floatValue] > dPClose) ? [UIColor tztThemeHQUpColor] : [UIColor tztThemeHQDownColor] );
            else
                txtColor = ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? [UIColor tztThemeHQBalanceColor] :
                ( ([nsValue floatValue] > dPClose) ? [UIColor tztThemeHQUpColor] : [UIColor tztThemeHQDownColor] );
            
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
            if (g_pSystermConfig.bBuySellWithTrend && _wudang) {
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
    
    //股票代码
    NSString* nsCode = @"";
//    if ([_tztTradeView getViewWithTag:kTagCode])
//    {
//        nsCode = [_tztTradeView GetEidtorText:kTagCode];
//    }
//    else
    {
        nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    }
    if (nsCode == NULL || [nsCode length] < 1)
    {
        tztAfxMessageBox(@"您好，请输入相关信息");
        return FALSE;
    }
    
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:kTagWTAccount];
    
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
    {
            return FALSE;
    }
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];

//    委托方式
    UIView* pView = [_tztTradeView getViewWithTag:kTagWTType];
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
    NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
    if (nsPrice == NULL || [nsPrice length] < 1)
    {
        [self showMessageBox:@"委托价格输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //委托数量
    NSString* nsAmount = [_tztTradeView GetEidtorText:kTagCount];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"委托数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //股转系统判断
    if (_nMsgType == WT_SBQRBUY || _nMsgType == MENU_JY_SB_QRBuy ||
        _nMsgType == WT_SBQRSALE || _nMsgType == MENU_JY_SB_QRSell)
    {
        NSString* nsYDXH = [_tztTradeView GetEidtorText:kTagYDXH];
        if (nsYDXH == NULL || [nsYDXH length] < 1)
        {
            [self showMessageBox:@"约定序号输入有误!"
                          nType_:TZTBoxTypeNoButton
                           nTag_:0
                       delegate_:NULL
                      withTitle_:@"股转系统"];
            return FALSE;
        }
        
        NSString* nsXWH = [_tztTradeView GetEidtorText:kTagDFXWH];
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
    if (nsName.length < 1)
        nsName = self.CurStockName;
    
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
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:kTagWTAccount];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
    {
            return;
    }
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    
    //股票代码
    NSString* nsCode = @"";
    nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
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
    NSInteger select = [self.tztTradeView getComBoxSelctedIndex:kTagWTType];
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
    
//    [tztUIProgressView showWithMsg:@"正在处理,请稍候..."];
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
            [self OnRefreshWithAccountType:self.nsWTAccountType andMarketNo:nil];
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
        [self InquireHQData:YES];
//        [self OnRefresh];
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
            [_tztTradeView setEditorText:nsString nsPlaceholder_:NULL withTag_:kTagCount];
        }
    }
    else if(nTag == 4998 || (nTag >= 5002 && nTag <= 5013))
    {
        if (_nMsgType == MENU_JY_SB_QRSell || _nMsgType == WT_SBQRSALE
            || _nMsgType == MENU_JY_SB_QRBuy || _nMsgType == WT_SBQRBUY)
            //成交确认买入卖出，价格不允许编辑
        {
            return;
        }
        //获取pricetype
        NSInteger select = [self.tztTradeView getComBoxSelctedIndex:kTagWTType];
        if (select > 0)
            return;
        //价格点击
        //价格输入框，填充数据
        [_tztTradeView setEditorText:nsString nsPlaceholder_:NULL withTag_:kTagPrice];
        self.nsNewPrice = [NSString stringWithFormat:@"%@",nsString];
        
        if (!_bBuyFlag)
            return;
        [self OnRefreshWithAccountType:self.nsWTAccountType andMarketNo:nil];
    }
    else if(nTag >= 5014 && nTag <= 5023)
    {
        //量点击
    }
    else if(nTag == 8001 || nTag == 8000)//价格增加
    {
        if (_nMsgType == MENU_JY_SB_QRSell || _nMsgType == WT_SBQRSALE
            || _nMsgType == MENU_JY_SB_QRBuy || _nMsgType == WT_SBQRBUY)
            //成交确认买入卖出，价格不允许编辑
        {
            return;
        }
        NSInteger select = [self.tztTradeView getComBoxSelctedIndex:kTagWTType];
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
                [self OnRefreshWithAccountType:self.nsWTAccountType andMarketNo:nil];
            }
        }
        [self setTipsShow:[_tztTradeView GetEidtorText:kTagCount]];
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
        
        [self setTipsShow:nsAmount];
    }
    else if (nTag == 5030)
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
        [self.tztTradeView setComBoxData:ayTransName ayContent_:ayTransName AndIndex_:nIndex withTag_:kTagWTType];
		DelObject(ayTransName);
        
        if (_nMsgType != MENU_JY_SB_QRSell && _nMsgType != WT_SBQRSALE
            && _nMsgType != MENU_JY_SB_QRBuy && _nMsgType != WT_SBQRBUY)
        {
            [self.tztTradeView setEditorEnable:TRUE withTag_:kTagPrice];
        }
		if (nIndex == 0)
		{
            if (self.nsNewPrice)
            {
                UIView* pEditor = [_tztTradeView getViewWithTag:kTagPrice];
                if(pEditor && [pEditor isKindOfClass:[tztUITextField class]] && (((tztUITextField*)pEditor).text == nil || [((tztUITextField*)pEditor).text length] <= 0 || [((tztUITextField*)pEditor).text floatValue] < _fMoveStep) && ![pEditor isFirstResponder])
                {
                    ((tztUITextField*)pEditor).text = self.nsNewPrice;
                }
            }
		}
		else
		{
			[self.tztTradeView setEditorText:@"市价委托" nsPlaceholder_:NULL withTag_:kTagPrice];
		}
	}
}

- (void)tztDroplistViewBeginShowData:(tztUIDroplistView*)droplistview
{
    switch ([droplistview.tzttagcode intValue])
    {
        case kTagWTAccount:
        {
            NSInteger accountIndex = droplistview.selectindex;
            if (accountIndex < 0 || accountIndex >= _ayStockNum.count)
                accountIndex = 0;
            NSString* strIgnore = nil;
            if (accountIndex >= 0 && accountIndex < _ayTypeContent.count)
            {
                strIgnore = [NSString stringWithFormat:@"(%@)", [_ayTypeContent objectAtIndex:accountIndex]];
            }
//            droplistview.nsIgnoreEx = strIgnore;
        }
            break;
        case kTagYXD:{
            //三板 请求约定序列号
            switch (_nMsgType) {
                case  MENU_JY_SB_QRBuy:
                case  MENU_JY_SB_QRSell:
                case  MENU_JY_SB_HBQRBuy:
                case  MENU_JY_SB_HBQRSell:
                {
                    [self searchTradeUnit];
                }
                default:
                    break;
            }
        }
        default:
            break;
    }
    
}

//选中list
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagCode)
    {
        switch (_nMsgType)
        {
            case WT_SBDJSALE:
            case MENU_JY_SB_DJSell:
            case WT_SBYXSALE:
            case MENU_JY_SB_YXSell:
//            case WT_SBQRBUY://三板确认买入
//            case MENU_JY_SB_QRBuy:
            case MENU_JY_SB_HBQRBuy://  互报成交确认买入
//            case WT_SBQRSALE://三板确认卖出
            case MENU_JY_SB_QRSell:
            case MENU_JY_SB_HBQRSell: //13017  互报成交确认卖出
            {
                //查三板行情
                [self OnRequestSBHQData];
            }
                break;
            default:
                [self OnRequestStockData];
                break;
        }
    }
}

-(void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(NSInteger)index
{
    if ([droplistview.tzttagcode intValue] == kTagWTAccount)
    {
        //根据委托账号类型设置市价委托类型
        if (index >= 0 && index < [_ayType count] )
        {
            NSString *accountType = [_ayType objectAtIndex:index];
            NSInteger nSelect = [_tztTradeView getComBoxSelctedIndex:kTagWTType];
            
            if (_nAccountIndex != index)
            {
                _nAccountIndex = index;
                nSelect = 0;
            }
            [self SetTransType:accountType nIndex_:nSelect];
            
            
            NSInteger nIndex = index;
            if (nIndex >= 0 && nIndex < _ayAccount.count)
            {
                NSString *strAccount = [_ayAccount objectAtIndex:nIndex];
                self.nsWTAccount = [NSString stringWithFormat:@"%@", strAccount];
            }
            if (ISNSStringValid(accountType))
                self.nsWTAccountType = [NSString stringWithFormat:@"%@",accountType];
            else
                self.nsWTAccountType = @"";
            //取得wtaccountType 和 wtaccount 重新请求可卖数量
            [self OnRefreshWithAccountTypeEx:accountType andMarketNo:nil bNeedReqdef:YES];
            [_ayAccount removeAllObjects];
            [_ayType removeAllObjects];
            // 股东账号 显示特殊处理 ===========Tjf
//            [_tztTradeView setComBoxText:[_ayAccount objectAtIndex:index] withTag_:kTagWTAccount];
        }
    }
    if ([droplistview.tzttagcode intValue] == kTagWTType)
    {
        //市价委托选择设置
        if (index == 0)
        {
            if (_nMsgType != MENU_JY_SB_QRSell && _nMsgType != WT_SBQRSALE
                && _nMsgType != MENU_JY_SB_QRBuy && _nMsgType != WT_SBQRBUY)
                [self.tztTradeView setEditorEnable:TRUE withTag_:kTagPrice];
            if (self.nsNewPrice)
            {
                [self.tztTradeView setEditorText:self.nsNewPrice nsPlaceholder_:NULL withTag_:kTagPrice];
            }
            else
            {
                [self.tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagPrice];
            }
        }
        else
        {
            [self.tztTradeView setEditorEnable:FALSE withTag_:kTagPrice];
            [self.tztTradeView setEditorText:@"市价委托" nsPlaceholder_:NULL withTag_:kTagPrice];
        }
        
        [self OnRefreshWithAccountType:self.nsWTAccountType andMarketNo:nil];
    }
    if ([droplistview.tzttagcode intValue] == kTagCode)
    {
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            //wry ------  ----
            //设置股票代码
//            [_tztTradeView setComBoxText:strCode withTag_:kTagCode];

//            self.nsWTAccount = @"";
            self.nsWTAccountType = @"";

            self.CurStockCode = [NSString stringWithFormat:@"%@", strCode];
            [self ClearDataWithOutCode];
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
    
    //wry --- 成交买卖意向单
    if ([droplistview.tzttagcode integerValue] == 2010) {
        _currentSelect = index;
        if (_currentSelect ==0) {
            [_tztTradeView setEditorText:@"" nsPlaceholder_:@"请输入转股代码" withTag_:2220];
        }else {
            [_tztTradeView setEditorText:@"" nsPlaceholder_:@"请输入回售代码" withTag_:2220];
        }
        
    }
    if ([droplistview.tzttagcode integerValue] == kTagYXD) {
        if (index<self.yxdArray.count) {
            
            [_tztTradeView setEditorText:self.ydhArray[index] nsPlaceholder_:@"输入约定序号" withTag_:2003];
        }
        if (index<self.xwhArray.count) {
            [_tztTradeView setEditorText:self.xwhArray[index] nsPlaceholder_:@"输入对方席位号" withTag_:2004];
        }
    }
}

-(BOOL)tztDroplistView:(tztUIDroplistView*)pSliderView showlistview:(UITableView*)pView
{
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
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%ld",(long)TZTAccountPTType] forKey:tztTokenType];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"117" withDictValue:pDict];
    DelObject(pDict);
}

//股转行情获取
-(void)OnRequestSBHQData
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
//    [pDict setTztValue:@"SBACCOUNT" forKey:@"WTACCOUNTTYPE"];
//    switch (_nMsgType)
//    {
//        case WT_SBQRBUY://成交确认买入
//        case MENU_JY_SB_QRBuy:
//        {
//            [pDict setTztValue:@"1B" forKey:@"YXMMLB"];
//        }
//            break;
//            
//        case MENU_JY_SB_HBQRBuy://  互报成交确认买入
//        {
//            [pDict setTztValue:@"" forKey:@"YXMMLB"];
//        }
//            break;
//            
//        case WT_SBQRSALE://成交确认卖出
//        case MENU_JY_SB_QRSell:
//        {
//            [pDict setTztValue:@"1S" forKey:@"YXMMLB"];
//        }
//            break;
//            
//        case MENU_JY_SB_HBQRSell: //13017  互报成交确认卖出
//        {
//            [pDict setTztValue:@"" forKey:@"YXMMLB"];
//        }
//            break;
//            
//        default:
//            break;
//    }
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5173" withDictValue:pDict];
    DelObject(pDict);

}

//选择股票数据
-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    //数据处理解析
    NSString* strData = cellData.cmdparam;
    NSArray *ay = [strData componentsSeparatedByString:@"|"];
    if (ay.count < 4)
        return;
    
//    NSString* strCode = [ay objectAtIndex:2];
    NSString* strAccount = [ay objectAtIndex:3];
    NSString* strMarket = @"";
    if (ay.count > 4)
        strMarket = [ay objectAtIndex:4];
    
    self.nsWTAccountType = [NSString stringWithFormat:@"%@", strAccount];
    self.nsMarketNo = @"";
    [self OnRequestStockInfo];
//    [self OnRefreshWithAccountTypeEx:strAccount andMarketNo:strMarket bNeedReqdef:NO];
}

@end
