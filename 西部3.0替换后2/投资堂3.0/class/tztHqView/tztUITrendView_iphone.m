/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        分时显示view(带报价)
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUITrendView_iphone.h"
#import "tztUISysLoginViewController.h"
#import "tztUIReportViewController_iphone.h"

extern TZTCSystermConfig* g_pSystermConfig;//配置文件

@interface tztUITrendView_iphone ()
{
}
@end

@interface tztUITrendView_iphone(tztPrivate)
-(void)setBtnFrame:(CGRect)rcFrame;
- (void)setTradeBtn:(CGRect)frame;
@end

@implementation tztUITrendView_iphone
@synthesize pTrendView = _pTrendView;
@synthesize pQuoteView = _pQuoteView;
@synthesize nStockType = _nStockType;
@synthesize pDetailView = _pDetailView;
@synthesize pLargInfoView = _pLargeInfoView;
@synthesize pFenJiaView = _pFenJiaView;
@synthesize hasNoAddBtn = _hasNoAddBtn;
@synthesize pTrendFundView = _pTrendFundView;

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)dealloc
{
    DelObject(_pAyBtn);
    _tztdelegate = nil;
//    NilObject(self.pTrendView);
//    NilObject(self.pDetailView);
//    NilObject(self.pLargInfoView);
//    NilObject(self.pQuoteView);
//    NilObject(self.pFenJiaView);
#ifdef tzt_TrendFundFlow
    NilObject(self.pTrendFundView);
#endif
    [super dealloc];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    if (_pTrendView)
        [_pTrendView onSetViewRequest:bRequest && (!_pTrendView.hidden)];
    if (_pDetailView)
        [_pDetailView onSetViewRequest:bRequest && (!_pDetailView.hidden)];
    if (_pLargeInfoView)
        [_pLargeInfoView onSetViewRequest:bRequest && (!_pDetailView.hidden)];
    if (_pQuoteView)
        [_pQuoteView onSetViewRequest:(!_pLargeInfoView.hidden) && bRequest];
    if (_pFenJiaView)
        [_pFenJiaView onSetViewRequest:bRequest && (!_pFenJiaView.hidden)];
#ifdef tzt_TrendFundFlow
    if (_pTrendFundView)
        [_pTrendFundView onSetViewRequest:bRequest && (!_pTrendFundView.hidden)];
#endif
}

- (void)onTradeClick:(id)sender
{
    TZTLogInfo(@"%@",@"请添加快速买卖处理事件");
    UIButton* btn = (UIButton *)sender;
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztQuickBuySell:nType_:)])
    {
        [_tztdelegate tztQuickBuySell:self nType_:(int)btn.tag];
    }
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    CGRect rcQuote = rcFrame;
    rcQuote.size.height = tztQuoteViewHeight;
    if (_pQuoteView == nil)
    {
        _pQuoteView = [[tztQuoteView alloc] initWithFrame:rcQuote];
        _pQuoteView.hasNoAddBtn = self.hasNoAddBtn;
        _pQuoteView.tztdelegate = self;
        [self addSubview:_pQuoteView];
        [_pQuoteView release];
    }
    else
    {
        _pQuoteView.hasNoAddBtn = self.hasNoAddBtn;
        _pQuoteView.frame = rcQuote;
    }
    
    //按钮行
    CGRect rcBtn = rcFrame;
    rcBtn.origin.y += rcQuote.size.height;
    if (MakeStockMarket(self.pStockInfo.stockType))
    {
        rcBtn.size.height = tztTrendButtonHeight;
        if (_pAyBtn == NULL)
            _pAyBtn = NewObject(NSMutableArray);
    }
    else
        rcBtn.size.height = 0;
    [self setBtnFrame:rcBtn];
    
    CGRect rcTrend = rcFrame;
    rcTrend.origin.y += rcQuote.size.height + rcBtn.size.height;
    rcTrend.size.height = rcFrame.size.height - rcQuote.size.height - rcBtn.size.height;
//#ifndef Support_HXSC
//    BOOL bShowTradeBtn = FALSE;
//#ifdef tzt_NewVersion
//    if (MakeStockMarket(self.pStockInfo.stockType))
//    {
//        rcTrend.size.height -=tztTrendButtonHeight;
//        bShowTradeBtn = TRUE;
//    }
//#endif
//#endif
    
    //判断支持分时界面快速买卖 1不支持 0为支持,默认为0
    if (!g_pSystermConfig.bFenShiSupportTrade)
    {
        rcTrend.size.height -=tztTrendButtonHeight;
    }
    
    if (_pTrendView == nil)
    {
        _pTrendView = [[tztTrendView alloc] initWithFrame:rcTrend];
        _pTrendView.tztdelegate = self;
        [self addSubview:_pTrendView];
        [_pTrendView release];
    }
    else
    {
        _pTrendView.frame = rcTrend;
    }
    
    if (!g_pSystermConfig.bFenShiSupportTrade)
        [self setTradeBtn:rcTrend];
    
    if (!g_pSystermConfig.bFenShiSupportTrade) 
        rcTrend.size.height +=tztTrendButtonHeight;
    
    if(_pDetailView == nil)
    {
        _pDetailView = [[tztDetailView alloc] init];
        _pDetailView.tztdelegate = self;
        _pDetailView.hidden = YES;
        _pDetailView.frame = rcTrend;
        [self addSubview:_pDetailView];
        [_pDetailView release];
    }
    else
    {
        _pDetailView.frame = rcTrend;
    }
    
    if (_pLargeInfoView == nil)
    {
        _pLargeInfoView = [[tztLargeMonitorView alloc] init];
        _pLargeInfoView.tztdelegate = self;
        _pLargeInfoView.hidden = YES;
        _pLargeInfoView.frame = rcTrend;
        [self addSubview:_pLargeInfoView];
        [_pLargeInfoView release];
    }
    else
    {
        _pLargeInfoView.frame = rcTrend;
    }
    
    if (_pFenJiaView == nil)
    {
        _pFenJiaView = NewObject(tztFenJiaView);
        _pFenJiaView.tztdelegate = self;
        _pFenJiaView.hidden = YES;
        _pFenJiaView.frame = rcTrend;
        [self addSubview:_pFenJiaView];
        [_pFenJiaView release];
    }
    else
    {
        _pFenJiaView.frame = rcTrend;
    }
#ifdef tzt_TrendFundFlow
    if (_pTrendFundView == nil)
    {
        _pTrendFundView = NewObject(tztTrendFundView);
        _pTrendFundView.tztdelegate = self;
        _pTrendFundView.hidden = YES;
        _pTrendFundView.frame = rcTrend;
        [self addSubview:_pTrendFundView];
        [_pTrendFundView release];
    }
    else
    {
        _pTrendFundView.frame = rcTrend;
    }
#endif
}

- (void)setTradeBtn:(CGRect)frame
{
    BOOL bShow = FALSE;
    bShow = TRUE;
    UIButton* btnBuy = (UIButton*)[self viewWithTag:tztBtnTradeBuyTag];
    CGSize btnSize = CGSizeZero;
    
    NSMutableDictionary * dict = GetDictByListName(@"KMKM");
    BOOL bKMKMNormal = ([[dict objectForKey:@"KMKMNormal"] intValue] > 0);
    
    if(btnBuy == NULL)
    {
        UIImage* buyImage;
        if (bKMKMNormal)
            buyImage = [UIImage imageTztNamed:@"tztTrendRZRQTradeBuy.png"];
        else
            buyImage = [UIImage imageTztNamed:@"tztTrendTradeBuy.png"];
        btnSize = buyImage.size;
        btnSize.width /= 2;
        btnSize.height /= 2;
        btnBuy = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBuy.tag = tztBtnTradeBuyTag;
        [btnBuy setTztBackgroundImage:buyImage];
        [btnBuy addTarget:self action:@selector(onTradeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBuy];
    }
    else
    {
        btnSize = btnBuy.bounds.size;
    }
    btnBuy.hidden = !bShow;
    
    CGRect btnFrame = frame;
    btnFrame.origin.y += btnFrame.size.height + (tztTrendButtonHeight - btnSize.height)  / 2;
    btnFrame.size.height = btnSize.height;
    btnFrame.size.width = btnSize.width;
    btnFrame.origin.x = 3;
    btnBuy.frame = btnFrame;
    
    UIButton* btnSell = (UIButton*)[self viewWithTag:tztBtnTradeSellTag];
    if(btnSell == NULL)
    {
        UIImage* sellImage;
        if (bKMKMNormal)
            sellImage = [UIImage imageTztNamed:@"tztTrendRZRQTradeSell.png"];
        else
            sellImage = [UIImage imageTztNamed:@"tztTrendTradeSell.png"];
        btnSell = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSell.tag = tztBtnTradeSellTag;
        [btnSell setTztBackgroundImage:sellImage];
        [btnSell addTarget:self action:@selector(onTradeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSell];
    }
    btnFrame.origin.x += btnFrame.size.width + 5;
    btnSell.frame = btnFrame;
    btnSell.hidden = !bShow;
    
    UIButton* btnDraw = (UIButton*)[self viewWithTag:tztBtnTradeDrawTag];
    if(btnDraw == NULL)
    {
        UIImage* drawImage;
        if (bKMKMNormal)
            drawImage = [UIImage imageTztNamed:@"tztTrendRZRQTradeDraw.png"];
        else
            drawImage = [UIImage imageTztNamed:@"tztTrendTradeDraw.png"];
        btnDraw = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDraw.tag = tztBtnTradeDrawTag;
        [btnDraw setTztBackgroundImage:drawImage];
        [btnDraw addTarget:self action:@selector(onTradeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDraw];
    }
    btnFrame.origin.x += btnFrame.size.width + 5;
    btnDraw.frame = btnFrame;
    btnDraw.hidden = !bShow;
    
#ifdef TZT_ZYData
        UIButton* btnWarning = (UIButton*)[self viewWithTag:tztBtnWarningTag];
#else
         UIButton* btnWarning = (UIButton*)[self viewWithTag:tztBtnStockTag];
#endif
    if(btnWarning == NULL)
    {
        UIImage* warningImage = nil;
#ifdef TZT_ZYData
        warningImage = [UIImage imageTztNamed:@"tztTrendWarning.png"];
#else
        if (bKMKMNormal) {
            warningImage = [UIImage imageTztNamed:@"tztTrendRZRQTradeStock.png"];
        }
        else {
            warningImage = [UIImage imageTztNamed:@"tztTrendTradeStock.png"];
        }
#endif
        btnWarning = [UIButton buttonWithType:UIButtonTypeCustom];
#ifdef TZT_ZYData
        btnWarning.tag = tztBtnWarningTag;
#else
        btnWarning.tag = tztBtnStockTag;
#endif
        [btnWarning setTztBackgroundImage:warningImage];
        [btnWarning addTarget:self action:@selector(onTradeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnWarning];
    }
    btnFrame.origin.x += btnFrame.size.width + 5;
    btnWarning.frame = btnFrame;
    btnWarning.hidden = !bShow;
}

-(void)setBtnFrame:(CGRect)frame
{
#ifdef Support_ZYFuction
    int nCount = 4;
#else
    int nCount = 3;
#endif
    
    BOOL bHidden = FALSE;
    
    if (!MakeStockMarket(self.pStockInfo.stockType))
        bHidden = TRUE;
    
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
#ifdef tzt_TrendFundFlow
    BOOL bShowFundFlow = FALSE;
    bShowFundFlow = MakeFundFlowsMarket(self.pStockInfo.stockType);
    if(bShowFundFlow)
        nCount += 1;
#endif
    UIImage *pImage = [UIImage imageTztNamed:@"TZTTabButtonBg.png"];
    UIImage *pImageSel = [UIImage imageTztNamed:@"TZTTabButtonSelBg.png"];
    //此处需要判断市场类型
    
    CGFloat nWidth = (frame.size.width-(nCount+1)*tztTrendSpace)/nCount;
    int nSpace = tztTrendSpace;//(frame.size.width - nCount*nWidth)/(nCount+1);
    //默认个股操作
    CGRect rcFrame = frame;
    rcFrame.origin.x += nSpace;
    rcFrame.origin.y += nSpace/2;
    rcFrame.size.height -= nSpace;
    rcFrame.size.width = nWidth;
    
    UIButton *pBtn = (UIButton*)[self viewWithTag:tztTrendBtnTag];
    //分时
    if (!bHidden)
    {
        if (pBtn == NULL)
        {
            pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pBtn.tag = tztTrendBtnTag;
            [pBtn setBackgroundImage:pImageSel forState:UIControlStateNormal];
            [pBtn setBackgroundImage:pImageSel forState:UIControlStateHighlighted];
            pBtn.titleLabel.font = tztUIBaseViewTextFont(15.0f);
            pBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [pBtn setTztTitle:@"分时"];
            [pBtn addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:pBtn];
            [_pAyBtn addObject:pBtn];
        }
        else
        {
            pBtn.frame = rcFrame;
        }
    }
    pBtn.hidden = bHidden;
    
    //明细
    rcFrame.origin.x +=nWidth + nSpace;
    pBtn = (UIButton*)[self viewWithTag:tztTrendBtnTag + 1];
    if (!bHidden)
    {
        if (pBtn == NULL)
        {
            pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pBtn.tag = tztTrendBtnTag+1;
            [pBtn setBackgroundImage:pImage forState:UIControlStateNormal];
            [pBtn setBackgroundImage:pImageSel forState:UIControlStateHighlighted];
            [pBtn setTztTitle:@"明细"];
            pBtn.titleLabel.font = tztUIBaseViewTextFont(15.0f);
            pBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [pBtn addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            pBtn.frame = rcFrame;
            [self addSubview:pBtn];
            [_pAyBtn addObject:pBtn];
        }
        else
        {
            pBtn.frame = rcFrame;
        }
    }
    pBtn.hidden = bHidden;
    
    rcFrame.origin.x += nWidth + nSpace;
    pBtn = (UIButton*)[self viewWithTag:tztTrendBtnTag + 4];
    if (!bHidden)
    {
        if (pBtn == nil)
        {
            pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pBtn.tag = tztTrendBtnTag+4;
            [pBtn setBackgroundImage:pImage forState:UIControlStateNormal];
            [pBtn setBackgroundImage:pImageSel forState:UIControlStateHighlighted];
            [pBtn setTztTitle:@"分价"];
            pBtn.titleLabel.font = tztUIBaseViewTextFont(15.0f);
            pBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [pBtn addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            pBtn.frame = rcFrame;
            [self addSubview:pBtn];
            [_pAyBtn addObject:pBtn];
        }
        else
        {
            pBtn.frame = rcFrame;
        }
    }
    pBtn.hidden = bHidden;
    
#ifdef Support_ZYFuction

    //龙虎
    rcFrame.origin.x += nWidth + nSpace;
    pBtn = (UIButton*)[self viewWithTag:tztTrendBtnTag + 2];
    if (!bHidden)
    {
        if (pBtn == nil)
        {
            pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pBtn.tag = tztTrendBtnTag+2;
            [pBtn setBackgroundImage:pImage forState:UIControlStateNormal];
            [pBtn setBackgroundImage:pImageSel forState:UIControlStateHighlighted];
            [pBtn setTztTitle:@"龙虎"];
            pBtn.titleLabel.font = tztUIBaseViewTextFont(15.0f);
            pBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [pBtn addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            pBtn.frame = rcFrame;
            [self addSubview:pBtn];
            [_pAyBtn addObject:pBtn];
        }
        else
        {
            pBtn.frame = rcFrame;
        }
    }
    pBtn.hidden = bHidden;
#endif
    
#ifdef tzt_TrendFundFlow
    if (bShowFundFlow)
    {
        rcFrame.origin.x += nWidth + nSpace;
        pBtn = (UIButton*)[self viewWithTag:tztTrendBtnTag + 5];
        if (!bHidden)
        {
            if (pBtn == nil)
            {
                pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                pBtn.tag = tztTrendBtnTag + 5;
                [pBtn setBackgroundImage:pImage forState:UIControlStateNormal];
                [pBtn setBackgroundImage:pImageSel forState:UIControlStateHighlighted];
                [pBtn setTztTitle:@"资金"];
                pBtn.titleLabel.font = tztUIBaseViewTextFont(15.0f);
                pBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
                [pBtn addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                pBtn.frame = rcFrame;
                [self addSubview:pBtn];
                [_pAyBtn addObject:pBtn];
            }
            else
            {
                pBtn.frame = rcFrame;
            }
        }
        if (bHidden)
        {
            pBtn.hidden = bHidden;
        }
        else
        {
            pBtn.hidden = NO;
        }
    }
    else
    {
        pBtn = (UIButton*)[self viewWithTag:tztTrendBtnTag + 5];
        pBtn.hidden = YES;
        if (_pTrendFundView && !_pTrendFundView.hidden)
        {
            pBtn = (UIButton*)[self viewWithTag:tztTrendBtnTag];
            [self OnBtnClick:pBtn];
        }
    }
#endif
}

//-(void)setStockCode:(NSString *)strCode stockType_:(NSInteger)stockType
//{
//    if (strCode == nil)
//        return;
//    
//    self.stockCode = [NSString stringWithFormat:@"%@", strCode];
//    _nStockType = stockType;
//}


-(void)setStockInfo:(tztStockInfo *)pStockCode Request:(int)nRequest
{
    if (pStockCode == NULL || pStockCode.stockCode == NULL)
        return;
    if (MakeFundFlowsMarket(pStockCode.stockType) != MakeFundFlowsMarket(self.pStockInfo.stockType))
    {
        self.pStockInfo = pStockCode;
        //按钮行
        CGRect rcBtn = self.bounds;
        rcBtn.origin.y += _pQuoteView.frame.size.height;
        rcBtn.size.height = tztTrendButtonHeight;
        if (_pAyBtn == NULL)
            _pAyBtn = NewObject(NSMutableArray);
        [self setBtnFrame:rcBtn];
        
    }
    else
    {
        self.pStockInfo = pStockCode;
    }
    //
    [self setFrame:self.frame];
    if (!MakeStockMarket(self.pStockInfo.stockType))
    {
        UIButton *pBtn = (UIButton*)[self viewWithTag:tztTrendBtnTag];
        [self setTrendView:pBtn];
    }
    
    if (_pQuoteView)
    {
        [_pQuoteView setStockInfo:pStockCode Request:((!_pLargeInfoView.hidden) && nRequest)];
    }
    
    if (_pTrendView && !_pTrendView.hidden)
    {
        [_pTrendView onSetViewRequest:nRequest];
        [_pTrendView setStockInfo:pStockCode Request:nRequest];
    }
    else
    {
        [_pTrendView onSetViewRequest:FALSE];
    }
    
    if (_pDetailView && !_pDetailView.hidden)
    {
        [_pDetailView onSetViewRequest:nRequest];
        [_pDetailView setStockInfo:pStockCode Request:nRequest];
    }
    else
    {
        [_pDetailView onSetViewRequest:FALSE];
    }
    
    if (_pLargeInfoView && !_pLargeInfoView.hidden)
    {
        [_pLargeInfoView onSetViewRequest:nRequest];
        [_pLargeInfoView setStockInfo:pStockCode Request:nRequest];
    }
    else
    {
        [_pLargeInfoView onSetViewRequest:FALSE];
    }
    
    if (_pFenJiaView && !_pFenJiaView.hidden)
    {
        [_pFenJiaView onSetViewRequest:nRequest];
        [_pFenJiaView setStockInfo:pStockCode Request:nRequest];
    }
    else
    {
        [_pFenJiaView onSetViewRequest:FALSE];
    }
    
#ifdef tzt_TrendFundFlow
    if (_pTrendFundView && !_pTrendFundView.hidden)
    {
        [_pTrendFundView onSetViewRequest:nRequest];
        [_pTrendFundView setStockInfo:pStockCode Request:nRequest];
    }
    else
    {
        [_pTrendFundView onSetViewRequest:FALSE];
    }
#endif

}

-(tztStockInfo*)GetCurrentStock
{
    if (_pTrendView)
        return [_pTrendView GetCurrentStock];
    return NULL;
}

-(void)UpdateData:(id)obj
{
    if (obj == _pTrendView)
    {
        TNewPriceData *pData = [(tztTrendView*)obj GetNewPriceData];
        if (pData && _pQuoteView)
        {
            _pQuoteView.pStockInfo = _pTrendView.pStockInfo;
            [_pQuoteView setPriceData:pData len:sizeof(TNewPriceData)];
        }
    }
    if (obj == _pDetailView) 
    {
        TNewPriceData *pData = [(tztDetailView*)obj GetNewPriceData];
        if (pData && _pQuoteView)
        {
            _pQuoteView.pStockInfo = _pDetailView.pStockInfo;
            [_pQuoteView setPriceData:pData len:sizeof(TNewPriceData)];
            [_pQuoteView UpdateLabelData];
        }
    }
    if (obj == _pFenJiaView)
    {
        TNewPriceData *pData = [(tztFenJiaView*)obj GetNewPriceData];
        if (pData && _pQuoteView)
        {
            _pQuoteView.pStockInfo = _pFenJiaView.pStockInfo;
            [_pQuoteView setPriceData:pData len:sizeof(TNewPriceData)];
            [_pQuoteView UpdateLabelData];
        }
    }
#ifdef tzt_TrendFundFlow
    if (obj == _pTrendFundView)
    {
        TNewPriceData *pData = [(tztTrendFundView*)obj GetNewPriceData];
        if (pData && _pQuoteView)
        {
            _pQuoteView.pStockInfo = _pTrendFundView.pStockInfo;
            [_pQuoteView setPriceData:pData len:sizeof(TNewPriceData)];
            [_pQuoteView UpdateLabelData];
        }
    }
#endif
}

-(void)OnBtnClick:(id)sender
{
    [self setTrendView:sender];
    [self setStockInfo:self.pStockInfo Request:1];
}

-(void)setTrendView:(id)sender
{
    UIButton* btn = (UIButton *)sender;
    if(btn.tag == tztTrendBtnTag + 2)
    {
        if([TZTUIBaseVCMsg SystermLogin:0 wParam:(NSUInteger)sender lParam:0 delegate:self isServer:FALSE])
            return;
    }
    
    UIImage *pImage = [UIImage imageTztNamed:@"TZTTabButtonBg.png"];
    UIImage *pImageSel = [UIImage imageTztNamed:@"TZTTabButtonSelBg.png"];
    for (int i = 0; i < [_pAyBtn count]; i++)
    {
        UIButton* pBtn = [_pAyBtn objectAtIndex:i];
        if (pBtn == sender)
        {
            [pBtn setBackgroundImage:pImageSel forState:UIControlStateNormal];
        }
        else
        {
            [pBtn setBackgroundImage:pImage forState:UIControlStateNormal];
        }
    }
    _pTrendView.hidden = (btn.tag != tztTrendBtnTag);
    _pDetailView.hidden = (btn.tag != tztTrendBtnTag + 1);
    _pLargeInfoView.hidden = (btn.tag != tztTrendBtnTag + 2);
    _pFenJiaView.hidden = (btn.tag!= tztTrendBtnTag + 4);
#ifdef tzt_TrendFundFlow
    _pTrendFundView.hidden = (btn.tag != tztTrendBtnTag + 5);
#endif
    [_pQuoteView onSetViewRequest:(btn.tag == tztTrendBtnTag + 2)];
}

-(void)OnDealLoginSucc:(NSInteger)nMsgType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (nMsgType == 0)
    {
        [self OnBtnClick:(id)wParam];
    }
}

//自选操作
-(void)tzthqView:(id)hqView AddOrDelStockCode:(tztStockInfo *)pStock
{
    if (pStock == NULL)
        return;
    
    //删除操作
    if ([tztUserStock IndexUserStock:pStock] >= 0)
    {
        [tztUserStock DelUserStock:pStock];
    }
    //添加操作
    else
    {
        [tztUserStock AddUserStock:pStock];
    }
}

-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo*)pStock
{
    if (MakeFundFlowsMarket(pStock.stockType))
    {
        self.pStockInfo = pStock;
        //按钮行
        CGRect rcBtn = self.bounds;
        rcBtn.origin.y += _pQuoteView.frame.size.height;
        rcBtn.size.height = tztTrendButtonHeight;
        if (_pAyBtn == NULL)
            _pAyBtn = NewObject(NSMutableArray);
        [self setBtnFrame:rcBtn];
    }
    
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
    {
        [_tztdelegate tzthqView:hqView setStockCode:pStock];
    }
}

-(void)tztHqView:(id)hqView OnBlcokClick:(NSDictionary *)info
{
    if (info == nil)
        return;
    
    
    //板块
    NSString* strCode = [info tztObjectForKey:@"tztParams"];
    NSString* strName = [info tztObjectForKey:@"tztTitle"];
    NSString* strAction = [info tztObjectForKey:@"tztAction"];
    BOOL bPush = FALSE;
    int nType = tztvckind_HQ;
    //#ifdef Support_HTSC
    nType = tztvckind_Pop;
    //#endif
    [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIReportViewController_iphone class]];
    tztUIReportViewController_iphone *pVC = (tztUIReportViewController_iphone *)gettztHaveViewContrller([tztUIReportViewController_iphone class], nType, [NSString stringWithFormat:@"%d",tztReportShowBlockInfo], &bPush,FALSE);
    [pVC retain];
    pVC.nReportType = tztReportBlockIndex;
    pVC.nsReqAction = [NSString stringWithFormat:@"%@", strAction];
    pVC.nsReqParam = [NSString stringWithFormat:@"%@", strCode];
    [pVC setTitle:strName];
    //#ifdef Support_HTSC
    [pVC SetHidesBottomBarWhenPushed:YES];
    //#endif
    if(bPush)
        [g_navigationController pushViewController:pVC animated:UseAnimated];
    else
        [pVC RequestData:[strAction intValue] nsParam_:strCode];
    [pVC release];
}

-(void)tztHqView:(id)hqView setTitleStatus:(NSInteger)nStatus andStockType_:(NSInteger)nStockType
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:setTitleStatus:andStockType_:)])
    {
        [self.tztdelegate tztHqView:hqView setTitleStatus:nStatus andStockType_:nStockType];
    }
}
@end
