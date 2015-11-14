//
//  tztHoriTechView.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-7-18.
//
//

#import "tztHoriTrendView.h"
#define tztDetailViewWidth  140

@interface tztHoriTrendView()<tztHqBaseViewDelegate, tztSegmentViewDelegate>

@property(nonatomic)int nMarketType;
//@property(nonatomic,retain)UISegmentedControl *pSegControl;

@end

@implementation tztHoriTrendView
@synthesize pTrendView = _pTrendView;
@synthesize pSegControl = _pSegControl;
@synthesize nCurIndex = _nCurIndex;
@synthesize nSegShowType = _nSegShowType;
@synthesize bHoriShow = _bHoriShow;
@synthesize fDetailWidth = _fDetailWidth;
@synthesize tztPriceStyle = _tztPriceStyle;
@synthesize bShowLeftPriceInSide = _bShowLeftPriceInSide;
@synthesize bShowMaxMinPrice = _bShowMaxMinPrice;
@synthesize bHiddenTime = _bHiddenTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    _nCurIndex = 0;
    _bHoriShow = YES;
    _fDetailWidth = tztDetailViewWidth;
    _tztPriceStyle = TrendPriceNon;
    _bShowMaxMinPrice = NO;
    _bShowLeftPriceInSide = NO;
    _bHiddenTime = NO;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    [super onSetViewRequest:bRequest];
    [_pTrendView onSetViewRequest:bRequest];
    [_pPriceView onSetViewRequest:(bRequest&&!_pPriceView.hidden)];
    [_pDetailView onSetViewRequest:(bRequest&&!_pDetailView.hidden)];
    [_pFenJiaView onSetViewRequest:(bRequest&&!_pFenJiaView.hidden)];
}

//
-(void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    if (pStockInfo == nil)
        return;
    [_pStockInfo release];
    _pStockInfo = [pStockInfo retain];
 
    _nMarketType = _pStockInfo.stockType;
    _pTrendView.pStockInfo = pStockInfo;
    _pTrendView.bTrendDrawCursor = NO;
    BOOL bIndex = (MakeStockMarketStock(self.pStockInfo.stockType) ||
                   MakeHKMarketStock(self.pStockInfo.stockType)
                   || MakeUSMarket(self.pStockInfo.stockType));//非个股，都不显示
#ifdef tzt_ZSSC
    bIndex = MakeStockMarketStock(self.pStockInfo.stockType);
#endif
    if (!bIndex)
    {
        _pSegControl.hidden = !bIndex;
        _pPriceView.hidden = !bIndex;
        _pDetailView.hidden = !bIndex;
        _pFenJiaView.hidden = !bIndex;
        return;
    }
    
    _pSegControl.hidden = NO;
    [self doSelectAtIndex:0];
    [self.pSegControl setCurrentSelect:0];
    if (MakeUSMarket(self.pStockInfo.stockType))
    {
        _pSegControl.hidden = YES;
    }
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    self.pStockInfo = pStockInfo;
    if (_pTrendView)
        [_pTrendView setStockInfo:pStockInfo Request:nRequest];
    if (_pPriceView)
        [_pPriceView setStockInfo:pStockInfo Request:(nRequest&&!_pPriceView.hidden)];
    if (_pDetailView)
        [_pDetailView setStockInfo:pStockInfo Request:(nRequest&&!_pDetailView.hidden)];
    if (_pFenJiaView)
        [_pDetailView setStockInfo:pStockInfo Request:(nRequest&&!_pFenJiaView.hidden)];
    [self layoutSubviews];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    BOOL bIndex = MakeStockMarketStock(self.pStockInfo.stockType);//非个股，都不显示
    BOOL bHKStock = MakeHKMarketStock(self.pStockInfo.stockType);//港股个股
    //
    BOOL bUsStock = MakeUSMarket(self.pStockInfo.stockType);//美股个股
    
#ifdef tzt_ZSSC
    if (bIndex)
#else
    if (bIndex || bHKStock || bUsStock)
#endif
        rcFrame.size.width -= _fDetailWidth;
    if (_pTrendView == NULL)
    {
        _pTrendView = [[tztTrendView alloc] initWithFrame:rcFrame];
        _pTrendView.bShowLeftPriceInSide = _bShowLeftPriceInSide;
        _pTrendView.bShowMaxMinPrice = _bShowMaxMinPrice;
        _pTrendView.bHiddenTime = _bHiddenTime;
        _pTrendView.pStockInfo = self.pStockInfo;
        _pTrendView.tztPriceStyle = _tztPriceStyle;
        _pTrendView.tztdelegate = self;
        _pTrendView.bHoriShow = _bHoriShow;
        _pTrendView.bShowTips = NO;
        if (g_bUseHQAutoPush)
            _pTrendView.bAutoPush = YES;
        _pTrendView.bIgnorTouch = YES;
        [self addSubview:_pTrendView];
        [_pTrendView release];
        
        _pTrendView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongPress:)];
        longpress.minimumPressDuration = 0.5;
        [_pTrendView addGestureRecognizer:longpress];
        [longpress release];
        
#ifndef tzt_ZSSC
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnDoubleClick:)];
        doubleTap.numberOfTapsRequired = 2;
        [_pTrendView addGestureRecognizer:doubleTap];
        [doubleTap release];
#endif
    }
    else
    {
        _pTrendView.bHoriShow = _bHoriShow;
        _pTrendView.frame = rcFrame;
    }
   
    if (bUsStock)
        _pSegControl.hidden = YES;
    
    CGRect rcSeg = self.bounds;
    rcSeg.origin.x = rcSeg.size.width - _fDetailWidth + 5;
    rcSeg.size.width = _fDetailWidth;
    rcSeg.size.height = 20;
    
    if (bUsStock)//美股个股
    {
        rcSeg.size.height = 0;
        
    }
#ifdef tzt_ZSSC
    if (_bHoriShow)
    {
        rcSeg.origin.y  = self.bounds.size.height - rcSeg.size.height;
    }
#else
    rcSeg.origin.y = self.bounds.size.height - rcSeg.size.height;
#endif
    if (_pSegControl == nil)
    {
        if (bHKStock || bUsStock)
        {
            _pSegControl = [[TZTSegSectionView alloc] initWithFrame:rcSeg andItems:@[@"十档", @"明细"] andDelegate:self];
        }
        else
        {
#ifdef Support_FenJia
            _pSegControl = [[TZTSegSectionView alloc] initWithFrame:rcSeg andItems:@[@"五档", @"明细", @"分价"] andDelegate:self];
#else
            _pSegControl = [[TZTSegSectionView alloc] initWithFrame:rcSeg andItems:@[@"五档", @"明细"] andDelegate:self];
#endif
        }
        [self addSubview:_pSegControl];
        [_pSegControl release];
    }
    else
    {
        if (bHKStock || bUsStock)
        {
            [_pSegControl SetSegmentViewItems:@[@"十档", @"明细"]];
        }
        else
        {
#ifdef Support_FenJia
            [_pSegControl SetSegmentViewItems:@[@"五档", @"明细", @"分价"]];
#else
            [_pSegControl SetSegmentViewItems:@[@"五档", @"明细"]];
#endif
        }
        _pSegControl.frame = rcSeg;
    }
    
    CGRect rcValid = CGRectMake(rcSeg.origin.x, rcFrame.origin.y, rcSeg.size.width, rcFrame.size.height - rcSeg.size.height - 2);
#ifdef tzt_ZSSC
    if (!_bHoriShow)
        rcValid =  CGRectMake(rcSeg.origin.x, rcSeg.size.height, rcSeg.size.width, rcFrame.size.height - rcSeg.size.height - 2);
#endif
    if (!_bHiddenTime && !_bHoriShow)//
    {
        rcValid.size.height -= tztParamHeight / 2;
    }
    if (_pPriceView == NULL)
    {
        _pPriceView = [[tztPriceView alloc] initWithFrame:rcValid];
        _pPriceView.tztdelegate = self;
        _pPriceView.bHoriShow = _bHoriShow;
        [self addSubview:_pPriceView];
        [_pPriceView release];
    }
    else
    {
        _pPriceView.bHoriShow = _bHoriShow;
        _pPriceView.frame = rcValid;
    }
    _pPriceView.layer.borderWidth = 0.5f;
    _pPriceView.layer.borderColor = [UIColor tztThemeHQGridColor].CGColor;
    
    if (_pDetailView == NULL)
    {
        _pDetailView = [[tztDetailView alloc] init];
        _pDetailView.bGridLines = NO;
        _pDetailView.pDrawFont = tztUIBaseViewTextFont(10.f);
        _pDetailView.fCellHeight = 10;
        _pDetailView.fTopCellHeight = 18;
        _pDetailView.bShowSeconds = _bHoriShow;
        _pDetailView.frame = rcValid;
        [self addSubview:_pDetailView];
        [_pDetailView release];
        _pDetailView.hidden = YES;
        if (!_bHoriShow)
            _pDetailView.bScrollEnabled = NO;
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(toggleAction:)] autorelease];
        [_pDetailView addGestureRecognizer:tapGesture];
    }
    else
    {
        _pDetailView.bShowSeconds = _bHoriShow;
        _pDetailView.frame = rcValid;
    }
    
    _pDetailView.layer.borderColor = [UIColor tztThemeHQGridColor].CGColor;
    _pDetailView.layer.borderWidth = 0.5f;
    
#ifdef Support_FenJia
    if (_pFenJiaView == NULL)
    {
        _pFenJiaView = [[tztFenJiaView alloc] init];
        _pFenJiaView.pDrawFont = tztUIBaseViewTextFont(10.f);
        _pFenJiaView.fCellHeight = 10;
        _pFenJiaView.fTopCellHeight = 18;
        _pFenJiaView.frame = rcValid;
        [self addSubview:_pFenJiaView];
        [_pFenJiaView release];
        if (!_bHoriShow)
            _pFenJiaView.bScrollEnabled = NO;
        _pFenJiaView.hidden = YES;
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(toggleAction:)] autorelease];
        [_pFenJiaView addGestureRecognizer:tapGesture];
    }
    else
        _pFenJiaView.frame = rcValid;
    
    _pFenJiaView.layer.borderWidth = 0.5f;
    _pFenJiaView.layer.borderColor = [UIColor tztThemeHQGridColor].CGColor;
#endif
    if (!bIndex && !bHKStock && !bUsStock)
    {
        _pSegControl.hidden = !bIndex;
        _pPriceView.hidden = !bIndex;
        _pDetailView.hidden = !bIndex;
        _pFenJiaView.hidden = !bIndex;
        return;
    }
}

-(IBAction)toggleAction:(id)sender
{
    NSInteger nIndex = _nCurIndex;
    nIndex++;
    
    int nMax = 3;
#ifndef Support_FenJia
    nMax = 2;
#endif
    if(MakeHKMarketStock(self.pStockInfo.stockType))
        nMax = 2;
    if (MakeUSMarket(self.pStockInfo.stockType))
    {
        nMax = 1;
    }
    if (nIndex >= nMax)
        nIndex = 0;
    [self doSelectAtIndex:nIndex];
    [self.pSegControl setCurrentSelect:nIndex];
}

-(void)tztSegmentView:(id)segView didSelectAtIndex:(NSInteger)nIndex
{
    if (segView == self.pSegControl)
    {
        [self doSelectAtIndex:nIndex];
    }
}

-(void)segmentAction:(id)sender
{
    UISegmentedControl *pSeg = (UISegmentedControl*)sender;
    if (![pSeg isKindOfClass:[UISegmentedControl class]])
        return;
    NSInteger nSelect = pSeg.selectedSegmentIndex;
    [self doSelectAtIndex:nSelect];
}

-(BOOL)OnSwitch
{
    [self toggleAction:nil];
    return YES;
}

-(void)doSelectAtIndex:(NSInteger)nIndex
{
//    if (self.nCurIndex == nIndex)
//        return;
    
    self.nCurIndex = nIndex;
    switch (nIndex)
    {
        case 0://选中报价，隐藏明细和财务
        {
            self.pPriceView.alpha = 1.0;
            self.pPriceView.hidden = NO;
            self.pDetailView.hidden = YES;
            self.pFenJiaView.hidden = YES;
        }
            break;
        case 1:
        {
            self.pPriceView.hidden = YES;
            self.pDetailView.hidden = NO;
            self.pFenJiaView.hidden = YES;
        }
            break;
        case 2:
        {
            self.pPriceView.hidden = YES;
            self.pDetailView.hidden = YES;
            self.pFenJiaView.hidden = NO;
        }
            break;
        default:
            break;
    }
    
    
    [_pPriceView onSetViewRequest:(!_pPriceView.hidden)];
    [_pDetailView onSetViewRequest:(!_pDetailView.hidden)];
    [_pFenJiaView onSetViewRequest:(!_pFenJiaView.hidden)];
    
    if (_pPriceView)
        [_pPriceView setStockInfo:self.pStockInfo Request:(!_pPriceView.hidden)];
    if (_pDetailView)
        [_pDetailView setStockInfo:self.pStockInfo Request:(!_pDetailView.hidden)];
    if (_pFenJiaView)
        [_pFenJiaView setStockInfo:self.pStockInfo Request:(!_pFenJiaView.hidden)];
    [self bringSubviewToFront:self.pPriceView];
}

-(void)UpdateData:(id)obj
{
    if (obj && [obj isKindOfClass:[tztHqBaseView class]])
    {
        tztStockInfo *stockInfo = ((tztHqBaseView*)obj).pStockInfo;
        if (stockInfo && stockInfo.stockCode.length > 0 && [self.pStockInfo.stockCode caseInsensitiveCompare:stockInfo.stockCode] == NSOrderedSame && (stockInfo.stockType != 0) && ((stockInfo.stockType != _nMarketType)))
        {
            self.pStockInfo.stockType = stockInfo.stockType;
            _nMarketType = self.pStockInfo.stockType;
            [self setStockInfo:self.pStockInfo Request:1];
        }
    }
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(UpdateData:)])
    {
        [_tztdelegate UpdateData:self];
    }
}

-(void)onRequestDataAutoPush
{
    if (_pTrendView)
        [_pTrendView onRequestData:FALSE];
    if (_pPriceView && !_pPriceView.hidden)
        [_pPriceView onRequestData:FALSE];
    if (_pDetailView && !_pDetailView.hidden)
        [_pDetailView onRequestData:FALSE];
    if (_pFenJiaView && !_pFenJiaView.hidden)
        [_pFenJiaView onRequestData:FALSE];
    
}


//获取报价数据
- (TNewPriceData*)GetNewPriceData
{
    if (_pTrendView)
        return [_pTrendView GetNewPriceData];
    return NULL;
}

-(void)tztHqView:(id)hqView clickAction:(NSInteger)nClickTimes
{
    if (nClickTimes >= 2)
    {
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztTimeTechTitleView:OnCloser:)])
        {
            [self.tztdelegate tztTimeTechTitleView:self OnCloser:NULL];
        }
    }
}

-(BOOL)showHorizenView:(UIView *)view
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(showHorizenView:)])
    {
        return [self.tztdelegate showHorizenView:self];
    }
    return FALSE;
}

-(void)tztHqView:(id)hqView setTitleStatus:(NSInteger)nStatus andStockType_:(NSInteger)nType
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:setTitleStatus:andStockType_:)])
    {
        [self.tztdelegate tztHqView:hqView setTitleStatus:nStatus andStockType_:nType];
    }
}

-(void)OnLongPress:(UILongPressGestureRecognizer*)reco
{
    CGPoint pt = [reco locationInView:_pTrendView];
    
    UIGestureRecognizerState state = reco.state;
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateFailed)
    {
        [_pTrendView trendTouchMoved:pt bShowCursor_:NO];
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:ShowCursorTipsView:)])
        {
            [self.tztdelegate tztHqView:self ShowCursorTipsView:NO];
        }
    }
    else
    {
        [_pTrendView trendTouchMoved:pt bShowCursor_:YES];
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:ShowCursorTipsView:)])
        {
            [self.tztdelegate tztHqView:self ShowCursorTipsView:YES];
        }
    }
}

-(void)tztHqView:(id)hqView SetCursorData:(id)pData
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:SetCursorData:)])
    {
        [self.tztdelegate tztHqView:hqView SetCursorData:pData];
    }
}

-(void)OnDoubleClick:(UITapGestureRecognizer*)reco
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztTimeTechTitleView:OnCloser:)])
    {
        [self.tztdelegate tztTimeTechTitleView:self OnCloser:NULL];
    }
}

@end
