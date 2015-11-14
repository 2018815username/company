//
//  tztHoriView.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 15-1-5.
//
//

#import "tztHoriView.h"
#import "tztHoriTechView.h"
#import "tztHoriTrendView.h"

@interface TZTTimeTechTitleView()<tztSegmentViewDelegate,tztTimeTechTitleViewDelegate>
{
    UILabel *lbStockName;       // 股票名称
    UILabel *lbNewPrice;        // 最新价
    UILabel *lbDeal;            // 成交额
    UIButton *btnClose;         // 关闭
}
@property(nonatomic,retain)UIView   *pBackView;

/*新增报价数据*/
/**
 *	@brief	涨跌和幅度
 */
@property(nonatomic,retain)UILabel  *lbRatioAndRange;

/**
 *	@brief	最高标题
 */
@property(nonatomic,retain)UILabel  *lbMaxTitle;
/**
 *	@brief	最高值
 */
@property(nonatomic,retain)UILabel  *lbMaxValue;
/**
 *	@brief	最低标题
 */
@property(nonatomic,retain)UILabel  *lbMinTitle;
/**
 *	@brief	最低值
 */
@property(nonatomic,retain)UILabel  *lbMinValue;
/**
 *	@brief	均价标题
 */
@property(nonatomic,retain)UILabel  *lbAvgTitle;
/**
 *	@brief	均价值
 */
@property(nonatomic,retain)UILabel  *lbAvgValue;
/**
 *	@brief	开盘标题
 */
@property(nonatomic,retain)UILabel  *lbOpenTitle;
/**
 *	@brief	开盘值
 */
@property(nonatomic,retain)UILabel  *lbOpenValue;


@end

@implementation TZTTimeTechTitleView
@synthesize pBackView = _pBackView;
@synthesize lbRatioAndRange = _lbRatioAndRange;
@synthesize lbMaxTitle = _lbMaxTitle;
@synthesize lbMaxValue = _lbMaxValue;
@synthesize lbAvgTitle = _lbAvgTitle;
@synthesize lbAvgValue = _lbAvgValue;
@synthesize lbOpenTitle = _lbOpenTitle;
@synthesize lbOpenValue = _lbOpenValue;

@synthesize segmentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGRect rect = self.frame;
    rect.origin.x = 10;
    rect.origin.y = 0;
    rect.size.width = 90;
    rect.size.height = 30;
    
    float fRate = 0.2;
    /*横屏显示时处理界面布局显示*/
    //股票名称
    if (lbStockName == nil)
    {
        lbStockName = [[UILabel alloc] initWithFrame:rect];
        lbStockName.font = tztUIBaseViewTextFont(16);
        lbStockName.textAlignment = NSTextAlignmentCenter;
        lbStockName.adjustsFontSizeToFitWidth = YES;
        lbStockName.backgroundColor = [UIColor clearColor];
        lbStockName.textColor = [UIColor tztThemeTextColorLabel];
        [self addSubview: lbStockName];
        [lbStockName release];
    }
    rect.origin.x += rect.size.width + 4;
    rect.size.width = 50;
    //最新价
    if (lbNewPrice == nil)
    {
        lbNewPrice = [[UILabel alloc] initWithFrame:rect];
        lbNewPrice.font = tztUIBaseViewTextFont(16);
        lbNewPrice.textAlignment = NSTextAlignmentCenter;
        lbNewPrice.adjustsFontSizeToFitWidth = YES;
        lbNewPrice.backgroundColor = [UIColor clearColor];
        lbNewPrice.textColor = [UIColor redColor];
        [self addSubview: lbNewPrice];
        [lbNewPrice release];
    }
    
    CGRect rc = self.frame;
    rc.size.height = 26;
    rc.origin.y = 2;
    rc.origin.x = rect.origin.x + rect.size.width;
    rc.size.width = self.frame.size.height - (rc.origin.x + 40);
    if (_pBackView == NULL)
    {
        _pBackView = [[UIView alloc] initWithFrame:rc];
        _pBackView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
        _pBackView.layer.borderColor = [UIColor tztThemeHQTipBackColor].CGColor;
        _pBackView.layer.borderWidth = .5f;
        [self addSubview:_pBackView];
        [_pBackView release];
    }
    else
    {
        _pBackView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
        _pBackView.layer.borderColor = [UIColor tztThemeHQTipBackColor].CGColor;
        _pBackView.frame = rc;
    }
    
    int nXMargin = 2;
    float fWidth = (rc.size.width - 4 * nXMargin) / 3;
    //涨跌及幅度
    CGRect rcRange = rc;
    rcRange.origin.x += nXMargin;
    rcRange.size.width = fWidth;
    if (_lbRatioAndRange == NULL)
    {
        _lbRatioAndRange = [[UILabel alloc] initWithFrame:rcRange];
        _lbRatioAndRange.font = tztUIBaseViewTextFont(13.f);
        _lbRatioAndRange.textAlignment = NSTextAlignmentCenter;
        _lbRatioAndRange.adjustsFontSizeToFitWidth = YES;
        _lbRatioAndRange.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbRatioAndRange];
        [_lbRatioAndRange release];
    }
    else
    {
        _lbRatioAndRange.frame = rcRange;
    }
    //最高
    CGRect rcMax = rcRange;
    rcMax.origin.x += rcRange.size.width + nXMargin;
    CGRect rcMaxTitle = rcMax;
    rcMaxTitle.size.width = (rcMax.size.width) * fRate;
    if (_lbMaxTitle == NULL)
    {
        _lbMaxTitle = [[UILabel alloc] initWithFrame:rcMaxTitle];
        _lbMaxTitle.font = tztUIBaseViewTextFont(13.f);
        _lbMaxTitle.textAlignment = NSTextAlignmentCenter;
        _lbMaxTitle.adjustsFontSizeToFitWidth = YES;
        _lbMaxTitle.backgroundColor = [UIColor clearColor];
        _lbMaxTitle.text = @"高";
        _lbMaxTitle.textColor = [UIColor tztThemeHQBalanceColor];
        [self addSubview:_lbMaxTitle];
        [_lbMaxTitle release];
    }
    else
    {
        _lbMaxTitle.frame = rcMaxTitle;
    }
    
    rcMax.origin.x += rcMaxTitle.size.width;
    rcMax.size.width -= rcMaxTitle.size.width;
    if (_lbMaxValue == NULL)
    {
        _lbMaxValue = [[UILabel alloc] initWithFrame:rcMax];
        _lbMaxValue.font = tztUIBaseViewTextFont(13.f);
        _lbMaxValue.textAlignment = NSTextAlignmentCenter;
        _lbMaxValue.adjustsFontSizeToFitWidth = YES;
        _lbMaxValue.backgroundColor = [UIColor clearColor];
        _lbMaxValue.textColor = [UIColor tztThemeHQBalanceColor];
        [self addSubview:_lbMaxValue];
        [_lbMaxValue release];
    }
    else
    {
        _lbMaxValue.frame = rcMax;
    }
    
    //最低
    CGRect rcMin = rcMax;
    rcMin.size.width = fWidth;
    rcMin.origin.x += rcMax.size.width + nXMargin;
    CGRect rcMinTitle = rcMaxTitle;
    rcMinTitle.origin.x = rcMin.origin.x;
    rcMinTitle.size.width = (rcMin.size.width) * fRate;
    if (_lbMinTitle == NULL)
    {
        _lbMinTitle = [[UILabel alloc] initWithFrame:rcMinTitle];
        _lbMinTitle.font = tztUIBaseViewTextFont(13.f);
        _lbMinTitle.textAlignment = NSTextAlignmentCenter;
        _lbMinTitle.adjustsFontSizeToFitWidth = YES;
        _lbMinTitle.backgroundColor = [UIColor clearColor];
        _lbMinTitle.text = @"低";
        _lbMinTitle.textColor = [UIColor tztThemeHQBalanceColor];
        [self addSubview:_lbMinTitle];
        [_lbMinTitle release];
    }
    else
    {
        _lbMinTitle.frame = rcMinTitle;
    }
    
    rcMin.origin.x += rcMinTitle.size.width;
    rcMin.size.width -= rcMinTitle.size.width;
    if (_lbMinValue == NULL)
    {
        _lbMinValue = [[UILabel alloc] initWithFrame:rcMin];
        _lbMinValue.font = tztUIBaseViewTextFont(13.f);
        _lbMinValue.textAlignment = NSTextAlignmentCenter;
        _lbMinValue.adjustsFontSizeToFitWidth = YES;
        _lbMinValue.backgroundColor = [UIColor clearColor];
        _lbMinValue.textColor = [UIColor tztThemeHQBalanceColor];
        [self addSubview:_lbMinValue];
        [_lbMinValue release];
    }
    else
    {
        _lbMinValue.frame = rcMin;
    }
    
    //均价
    CGRect rcAvg = rcMin;
    rcAvg.origin.x += rcMin.size.width +nXMargin;
    rcAvg.size.width = fWidth;
    CGRect rcAvgTitle = rcMinTitle;
    rcAvgTitle.origin.x = rcAvg.origin.x;
    rcAvgTitle.size.width = (rcAvg.size.width) * fRate;
    if (_lbAvgTitle == NULL)
    {
        _lbAvgTitle = [[UILabel alloc] initWithFrame:rcAvgTitle];
        _lbAvgTitle.font = tztUIBaseViewTextFont(13.f);
        _lbAvgTitle.textAlignment = NSTextAlignmentCenter;
        _lbAvgTitle.adjustsFontSizeToFitWidth = YES;
        _lbAvgTitle.backgroundColor = [UIColor clearColor];
        _lbAvgTitle.text = @"均";
        _lbAvgTitle.textColor = [UIColor tztThemeHQBalanceColor];
        [self addSubview:_lbAvgTitle];
        [_lbAvgTitle release];
    }
    else
    {
        _lbAvgTitle.frame = rcAvgTitle;
    }
    
    rcAvg.origin.x += rcAvgTitle.size.width;
    rcAvg.size.width -= rcAvgTitle.size.width;
    if (_lbAvgValue == NULL)
    {
        _lbAvgValue = [[UILabel alloc] initWithFrame:rcAvg];
        _lbAvgValue.font = tztUIBaseViewTextFont(13.f);
        _lbAvgValue.textAlignment = NSTextAlignmentCenter;
        _lbAvgValue.adjustsFontSizeToFitWidth = YES;
        _lbAvgValue.backgroundColor = [UIColor clearColor];
        _lbAvgValue.textColor = [UIColor tztThemeHQBalanceColor];
        [self addSubview:_lbAvgValue];
        [_lbAvgValue release];
    }
    else
    {
        _lbAvgValue.frame = rcAvg;
    }
    
    //开盘
    CGRect rcOpen = rcAvg;
    rcOpen.origin.x += rcOpen.size.width + nXMargin;
    rcOpen.size.width = fWidth;
    CGRect rcOpenTitle = rcAvgTitle;
    rcOpenTitle.origin.x = rcOpen.origin.x;
    rcOpenTitle.size.width = (rcOpen.size.width) * fRate;
    if (_lbOpenTitle == NULL)
    {
        _lbOpenTitle = [[UILabel alloc] initWithFrame:rcOpenTitle];
        _lbOpenTitle.font = tztUIBaseViewTextFont(13.f);
        _lbOpenTitle.textAlignment = NSTextAlignmentCenter;
        _lbOpenTitle.adjustsFontSizeToFitWidth = YES;
        _lbOpenTitle.backgroundColor = [UIColor clearColor];
        _lbOpenTitle.text = @"开";
        _lbOpenTitle.textColor = [UIColor tztThemeHQBalanceColor];
        [self addSubview:_lbOpenTitle];
        [_lbOpenTitle release];
    }
    else
    {
        _lbOpenTitle.frame = rcOpenTitle;
    }
    
    rcOpen.origin.x += rcOpenTitle.size.width;
    rcOpen.size.width -= rcOpenTitle.size.width;
    if (_lbOpenValue == NULL)
    {
        _lbOpenValue = [[UILabel alloc] initWithFrame:rcOpen];
        _lbOpenValue.font = tztUIBaseViewTextFont(13.f);
        _lbOpenValue.textAlignment = NSTextAlignmentCenter;
        _lbOpenValue.adjustsFontSizeToFitWidth = YES;
        _lbOpenValue.backgroundColor = [UIColor clearColor];
        _lbOpenValue.textColor = [UIColor tztThemeHQBalanceColor];
        [self addSubview:_lbOpenValue];
        [_lbOpenValue release];
    }
    else
    {
        _lbOpenValue.frame = rcOpen;
    }
    
    rect.origin.x = self.frame.size.width - rect.size.height - 5;
    rect.size.width = rect.size.height;
    
    //关闭按钮
    if (btnClose == nil)
    {
        btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.frame = rect;
        [btnClose setImage:[UIImage imageTztNamed:@"TZTStockdetail_landscape_close"] forState:UIControlStateNormal];
        [btnClose setImage:[UIImage imageTztNamed:@"TZTStockdetail_landscape_close_down"] forState:UIControlStateHighlighted];
        [btnClose addTarget:self action:@selector(closed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnClose];
    }
    
    CGRect segRect;
    
    segRect = CGRectMake(5 , rect.size.height, self.frame.size.width - 10, self.frame.size.height - rect.size.height);
    
    //分时、周期切换
    if (segmentView == nil)
    {
        segmentView = [[TZTSegSectionView alloc] initWithFrame:segRect andItems:@[@"分时", @"日K", @"周K", @"月K",@"5分钟",@"15分钟",@"30分钟",@"60分钟"] andDelegate:self];
        [self addSubview:segmentView];
        [segmentView release];
    }
}

-(void)tztSegmentView:(id)segView didSelectAtIndex:(NSInteger)nIndex
{
    if (segView == segmentView)
    {
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(selectedSeg:)])
        {
            [self.tztdelegate selectedSeg:nIndex];
        }
    }
}

- (UIButton*)GetCurrentSelBtn
{
    if (segmentView)
        return [segmentView GetCurrentSelBtn];
    return nil;
}

- (void)closed:(id)sender
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztTimeTechTitleView:OnCloser:)])
    {
        [self.tztdelegate tztTimeTechTitleView:self OnCloser:sender];
    }
}

/**
 *	@brief	界面显示数据更新
 *
 *	@return	无
 */
- (void)updateContent
{
    NSDictionary *stockDic = [TZTPriceData stockDic];
    
    NSMutableDictionary *pDictName = [stockDic objectForKey:tztName];
    NSMutableDictionary *pDictNewPrice = [stockDic objectForKey:tztNewPrice];
    NSMutableDictionary *pDictUpDown = [stockDic objectForKey:tztUpDown];
    NSMutableDictionary *pDictRange = [stockDic objectForKey:tztPriceRange];
    NSMutableDictionary *pDictCode = [stockDic objectForKey:tztCode];
    NSMutableDictionary *pDictMax = [stockDic objectForKey:tztMaxPrice];
    NSMutableDictionary *pDictMin = [stockDic objectForKey:tztMinPrice];
    NSMutableDictionary *pDictAvg = [stockDic objectForKey:tztAveragePrice];
    NSMutableDictionary *pDictOpen = [stockDic objectForKey:tztStartPrice];
    
    NSString* nsCode = [pDictCode objectForKey:tztValue];
    nsCode = [nsCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString* strCurrent = [NSString stringWithFormat:@"%@", self.pStockInfo.stockCode];
    strCurrent = [strCurrent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (nsCode == NULL || nsCode.length < 1 || [nsCode caseInsensitiveCompare:strCurrent] != NSOrderedSame)
        return;
    
    NSString *nsName = [pDictName objectForKey:tztValue];
    nsName = [nsName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    lbStockName.text = nsName;
    lbNewPrice.text = [pDictNewPrice objectForKey:tztValue];
    
    
    NSMutableDictionary *pDict = [stockDic objectForKey:tztTransactionAmount];
    if (MakeIndexMarket(self.pStockInfo.stockType) || MakeBlockIndex(self.pStockInfo.stockType) || MakeHKMarket(self.pStockInfo.stockType))
    {
        pDict = [stockDic objectForKey:tztTradingVolume];
    }
    
    lbDeal.text = [pDict objectForKey:tztValue];
    lbDeal.textColor = [pDict objectForKey:tztColor];
    
    lbNewPrice.textColor = [pDictNewPrice objectForKey:tztColor];
    
    //涨跌、幅度
    NSString *strRatio = [pDictUpDown objectForKey:tztValue];
    NSString *strRange = [pDictRange objectForKey:tztValue];
    NSString *nsValue = [NSString stringWithFormat:@"%@  %@",strRatio, strRange];
    _lbRatioAndRange.text = nsValue;
    _lbRatioAndRange.textColor = [pDictRange objectForKey:tztColor];
    
    //    NSString *strClose = [pDictClose objectForKey:tztValue];
    //最高
    NSString *strMaxPrice = [pDictMax objectForKey:tztValue];
    _lbMaxValue.text = strMaxPrice;
    _lbMaxValue.textColor = [pDictMax objectForKey:tztColor];
    
    //最低
    NSString *strMinPrice = [pDictMin objectForKey:tztValue];
    _lbMinValue.text = strMinPrice;
    _lbMinValue.textColor = [pDictMin objectForKey:tztColor];
    
    //均价
    NSString *strAvgPrice = [pDictAvg objectForKey:tztValue];
    _lbAvgValue.text = strAvgPrice;
    _lbAvgValue.textColor = [pDictAvg objectForKey:tztColor];
    
    //开盘
    NSString *strOpen = [pDictOpen objectForKey:tztValue];
    _lbOpenValue.text = strOpen;
    _lbOpenValue.textColor = [pDictOpen objectForKey:tztColor];
}

@end


@interface tztHoriView()<tztTimeTechTitleViewDelegate>
{
    UIView *ttView;
    TZTTimeTechTitleView *titleView;
    BOOL isHorizon;
    UIView *blackView;
    tztHoriTrendView *horTrend;
    tztHoriTechView *horTech;
    CGRect normalRect;
    CGRect unnorHorRect;
    CGRect norHorRect;
    
    CGRect nortitleRect;
    CGRect unnortitleRect;
    
    NSInteger   nPreSelectIndex;
}

@property(nonatomic,retain)tztToolbarMoreView *pToolBarView;

@end

@implementation tztHoriView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    UIView *viewWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (blackView == nil) {
        blackView = [[UIView alloc] initWithFrame:viewWindow.frame];
        blackView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        blackView.alpha = .0f;
        [viewWindow addSubview:blackView];
        [blackView release];
    }
    
    CGAffineTransform at =CGAffineTransformMakeRotation(M_PI/2);
    at =CGAffineTransformTranslate(at,0,0);
    
    frame.size.width = viewWindow.frame.size.height;
    frame.size.height = 60;
    frame.origin.y += (viewWindow.frame.size.width - 66);
    frame.origin.x += 6;
    
    if (titleView == nil)
    {
        titleView = [[TZTTimeTechTitleView alloc] init];
        titleView.tztdelegate = self;
        titleView.frame = frame;
        [titleView setTransform:at];
        frame.origin.x = viewWindow.frame.size.width - frame.size.height; // frame.size.height == 60
        frame.origin.y = 0;
        frame.size = titleView.frame.size;
        titleView.frame = frame;
        [blackView addSubview:titleView];
        [titleView release];
        
        nortitleRect = titleView.frame;
        unnortitleRect = nortitleRect;
        unnortitleRect.origin.x += frame.size.height;
    }
    else
    {
        
    }
    
    frame = viewWindow.frame;
    frame.size.height = viewWindow.frame.size.width - 66;
    frame.size.width = viewWindow.frame.size.height - 20;
    frame.origin.y += (viewWindow.frame.size.width - frame.size.height + 90);
    frame.origin.x -= 145;
    
    if (horTrend == nil)
    {
        horTrend = [[tztHoriTrendView alloc] init];
        horTrend.pStockInfo = self.pStockInfo;
        horTrend.tztdelegate = self;
        horTrend.frame = frame;
        [horTrend setTransform:at];
        [blackView addSubview:horTrend];
        [horTrend release];
    }
    else
    {
        horTrend.pStockInfo = self.pStockInfo;
    }
    
    if (horTech == nil)
    {
        horTech = [[tztHoriTechView alloc] init];
        horTech.pStockInfo = self.pStockInfo;
        horTech.tztdelegate = self;
        horTech.KLineCycleStyle = KLineCycleWeek;
        horTech.frame = frame;
        [horTech setTransform:at];
        CGRect reFrame;
        reFrame.origin.x = 2;
        reFrame.origin.y = 9;
        reFrame.size = horTech.frame.size;
        horTech.frame = reFrame;
        [blackView addSubview:horTech];
        [horTech release];
        
        norHorRect = horTech.frame;
        unnorHorRect = norHorRect;
        unnorHorRect.origin.y -= viewWindow.frame.size.height;
    }
    else
    {
        horTech.pStockInfo = self.pStockInfo;
    }
    
    [UIView animateWithDuration:0.1f animations:^{
        blackView.alpha = 1.0f;
    }];
    
    horTrend.frame = unnorHorRect;
    horTech.frame = unnorHorRect;
    titleView.frame = unnortitleRect;
    [UIView animateWithDuration:0.4f animations:^{
        horTrend.frame = norHorRect;
        horTech.frame = norHorRect;
        titleView.frame = nortitleRect;
    }];
    
    [horTech setNeedsDisplay];
//    titleView.segmentView.segControl.currentSelected = segmentView.segControl.currentSelected;
//    [self updateSelected:_nCurrentIndex];
}

-(void)setNCurrentIndex:(NSInteger)nIndex
{
    _nCurrentIndex = nIndex;
    [self updateSelected:nIndex];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    [super onSetViewRequest:bRequest];
    
    if (!bRequest)
    {
        [horTrend onSetViewRequest:bRequest];
        [horTech onSetViewRequest:bRequest];
    }
    else
    {
        [horTrend onSetViewRequest:bRequest && horTech && !horTech.hidden];
        [horTech onSetViewRequest:bRequest && horTrend && !horTrend.hidden];
    }
}

-(void)onRequestData:(BOOL)bShowProcess
{
    if (!_bRequest)
        return;
    if (horTech && !horTech.hidden)
        [horTech onRequestDataAutoPush];
    if (horTrend && !horTrend.hidden)
        [horTrend onRequestDataAutoPush];
}

-(void)onRequestDataAutoPush
{
    if (!_bRequest)
        return;
    [self onRequestData:FALSE];
}

- (void)close:(id)sender
{
    
    horTech.tztdelegate = nil;
    horTrend.tztdelegate = nil;
    horTrend = nil;
    horTech = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        horTrend.frame = unnorHorRect;
        horTech.frame = unnorHorRect;
        titleView.frame = unnortitleRect;
    }];
    
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHoriViewClosedAtIndex:)])
    {
        [self.tztdelegate tztHoriViewClosedAtIndex:titleView.segmentView.segControl.currentSelected];
        [blackView removeFromSuperview];
    }
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    if (pStockInfo == nil)
        return;
    [super setStockInfo:pStockInfo Request:nRequest];
    
    [horTrend setStockInfo:_pStockInfo Request:nRequest];
    [horTech setStockInfo:_pStockInfo Request:nRequest];
    [horTech onSetViewRequest:!horTech.hidden];
    [horTrend onSetViewRequest:!horTrend.hidden];
    titleView.pStockInfo = _pStockInfo;
}

- (void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    if (pStockInfo == nil)
        return;
    [_pStockInfo release];
    _pStockInfo = [pStockInfo retain];
    horTrend.pStockInfo = _pStockInfo;
    horTech.pStockInfo = _pStockInfo;
    titleView.pStockInfo = _pStockInfo;
}

-(void)UpdateData:(id)obj
{
    TNewPriceData *pData = [self GetNewPriceData];
    [TZTPriceData setStockDic:[self dealNewPriceData:pData]];
    
    if (obj == horTrend && !horTrend.hidden)
    {
        [titleView updateContent];
    }
    else if (obj == horTech && ! horTech.hidden)
    {
        [titleView updateContent];
    }
}

-(TNewPriceData*)GetNewPriceData
{
    if (horTrend && !horTrend.hidden)
        return [horTrend GetNewPriceData];
    else if (horTech && !horTech.hidden)
        return [horTech GetNewPriceData];
    else
        return NULL;
}

- (NSMutableDictionary *)dealNewPriceData:(TNewPriceData *)pNewPriceData
{
    NSMutableDictionary *pReturnDict = [NSMutableDictionary dictionary];
    
    //股票代码
    NSString* nsCode = [[[NSString alloc] initWithBytes:pNewPriceData->Code
                                                 length:sizeof(pNewPriceData->Code)
                                               encoding:NSASCIIStringEncoding] autorelease];
    [pReturnDict setObject:nsCode forKey:@"Stock_Code"];
    
    //股票名称
    NSString* nsName = getName_TNewPriceData(pNewPriceData);
    [pReturnDict setObject:nsName forKey:@"Stock_Name"];
    
    int nHand = pNewPriceData->m_nUnit;
    
    //根据类型进行解析
    if (MakeIndexMarket(self.pStockInfo.stockType))//指数
    {
        [TZTPriceData dealWithIndexPrice:pNewPriceData pDict_:pReturnDict];
    }
    else if(MakeStockMarket(self.pStockInfo.stockType)
            || MakeUSMarket(self.pStockInfo.stockType))//个股
    {
        [TZTPriceData dealWithStockPrice:pNewPriceData andType_:self.pStockInfo.stockType pDict_:pReturnDict];
    }
    else if (MakeHKMarket(self.pStockInfo.stockType))//港股
    {
        [TZTPriceData dealWithHKStockPrice:pNewPriceData andUnit_:1000 pDict_:pReturnDict];
    }
    else if (MakeWPMarket(self.pStockInfo.stockType))//外盘
    {
        
        if ((self.pStockInfo.stockType == WP_INDEX)
            || (MakeMidMarket(self.pStockInfo.stockType) == HQ_WP_INDEX)
            )
        {
            [TZTPriceData dealwithWPStockPrice:pNewPriceData pDict_:pReturnDict];
        }
        else
        {
            if (nHand <= 0)
                nHand = 10000;
            [TZTPriceData dealWithQHStockPrice:pNewPriceData andHand_:nHand pDict_:pReturnDict];
        }
        
    }
    else if (MakeWHMarket(self.pStockInfo.stockType))//外汇
    {
        
    }
    else if (MakeQHMarket(self.pStockInfo.stockType))//期货
    {
        //板块指数
        if (MakeMainMarket(self.pStockInfo.stockType) == (HQ_FUTURES_MARKET|HQ_SELF_BOURSE|0x0060))
        {
            [TZTPriceData DealWithBlockIndexPice:pNewPriceData pDict_:pReturnDict];
            //            [self onDrawStockPrice:context];
        }
        else//期货
        {
            if (nHand <= 0)
                nHand = 100;
            [TZTPriceData dealWithQHStockPrice:pNewPriceData andHand_:nHand pDict_:pReturnDict];
        }
    }
    return pReturnDict;
}

- (void)updateSelected:(NSInteger)index
{
    [titleView.segmentView setCurrentSelect:index];
    switch (index) {
        case 0:
        {
            horTrend.hidden = NO;
            horTech.hidden = YES;
        }
            break;
        case 1:
        {
            horTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycleDay;
        }
            break;
        case 2:
        {
                horTrend.hidden = YES;
                horTech.hidden = NO;
                horTech.KLineCycleStyle = KLineCycleWeek;
        }
            break;
        case 3:
        {
            horTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycleMonth;
        }
            break;
        case 4:
        {
            horTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycle5Min;
        }
            break;
        case 5://15分钟
        {
            horTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycle15Min;
        }
            break;
        case 6://30分钟
        {
            horTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycle30Min;
        }
            break;
        case 7://60分钟
        {
            horTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycle60Min;
        }
            break;
            
        default:
            break;
    }
    
    [self setStockInfo:_pStockInfo Request:1];
    self.pStockInfo = _pStockInfo;
    nPreSelectIndex = index;
}

-(void)tztTimeTechTitleView:(id)view OnCloser:(id)sender
{
    [self close:nil];
}


- (void)setSegment:(int)segmentIndex
{
    [self updateSelected:segmentIndex];
}


- (void)selectedSeg:(NSInteger)index
{
    [self updateSelected:index];
}
@end
