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

#define tztTitleKey @"tztTitle"
#define tztValueKey @"tztValue"
#define tztColorKey @"tztColor"

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
    rect.size.width = 100;
    rect.size.height = 30;
    
    float fRate = 0.3;
    /*横屏显示时处理界面布局显示*/
    //股票名称
    if (lbStockName == nil)
    {
        lbStockName = [[UILabel alloc] initWithFrame:rect];
        lbStockName.font = tztUIBaseViewTextFont(16);
        lbStockName.textAlignment = NSTextAlignmentLeft;
        lbStockName.adjustsFontSizeToFitWidth = YES;
        lbStockName.backgroundColor = [UIColor clearColor];
        lbStockName.textColor = [UIColor tztThemeTextColorLabel];
        [self addSubview: lbStockName];
        [lbStockName release];
    }
    rect.origin.x += rect.size.width + 4;
    rect.size.width = 60;
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
#ifdef tzt_ZSSC
    _pBackView.hidden = YES;
#endif
    int nXMargin = 15;
    float fWidth = (rc.size.width - 4 * nXMargin - 60) / 2;
    //涨跌及幅度
    CGRect rcRange = rc;
    rcRange.origin.x += nXMargin;
    rcRange.size.width = 40;
    if (_lbRatioAndRange == NULL)
    {
        _lbRatioAndRange = [[UILabel alloc] initWithFrame:rcRange];
        _lbRatioAndRange.font = tztUIBaseViewTextFont(13.f);
        _lbRatioAndRange.textAlignment = NSTextAlignmentLeft;
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
    rcMax.size.width = fWidth;
    rcMax.origin.x += rcRange.size.width + nXMargin + 20;
    CGRect rcMaxTitle = rcMax;
    rcMaxTitle.size.width = (rcMax.size.width) * fRate;
    if (_lbMaxTitle == NULL)
    {
        _lbMaxTitle = [[UILabel alloc] initWithFrame:rcMaxTitle];
        _lbMaxTitle.font = tztUIBaseViewTextFont(16.f);
        _lbMaxTitle.textAlignment = NSTextAlignmentLeft;
        _lbMaxTitle.adjustsFontSizeToFitWidth = YES;
        _lbMaxTitle.backgroundColor = [UIColor clearColor];
        _lbMaxTitle.text = @"成交:";
        _lbMaxTitle.textColor = [UIColor tztThemeHQFixTextColor];
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
        _lbMaxValue.font = tztUIBaseViewTextFont(16.f);
        _lbMaxValue.textAlignment = NSTextAlignmentLeft;
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
        _lbMinTitle.font = tztUIBaseViewTextFont(16.f);
        _lbMinTitle.textAlignment = NSTextAlignmentLeft;
        _lbMinTitle.adjustsFontSizeToFitWidth = YES;
        _lbMinTitle.backgroundColor = [UIColor clearColor];
        _lbMinTitle.text = @"时间:";
        _lbMinTitle.textColor = [UIColor tztThemeHQFixTextColor];
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
        _lbMinValue.font = tztUIBaseViewTextFont(16.f);
        _lbMinValue.textAlignment = NSTextAlignmentLeft;
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
    
    rect.origin.x = self.frame.size.width - rect.size.height - 5;
    rect.size.width = rect.size.height;
    
    //关闭按钮
    if (btnClose == nil)
    {
        btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.frame = rect;
        btnClose.showsTouchWhenHighlighted = YES;
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
#ifdef tzt_ZSSC
        segmentView = [[TZTSegSectionView alloc] initWithFrame:segRect andItems:@[@"分时", @"五日", @"日K", @"周K", @"月K",@"分钟⌄"] andDelegate:self];
#else
#ifdef tzt_Support5Day
        segmentView = [[TZTSegSectionView alloc] initWithFrame:segRect andItems:@[@"分时", @"日K", @"周K", @"月K",@"5分钟",@"15分钟",@"30分钟",@"60分钟"] andDelegate:self];
#else
        segmentView = [[TZTSegSectionView alloc] initWithFrame:segRect andItems:@[@"分时", @"五日", @"日K", @"周K", @"月K",@"5分钟",@"15分钟",@"30分钟",@"60分钟"] andDelegate:self];
#endif
#endif
        segmentView.bSepLine = YES;
        segmentView.pBordColor = [UIColor tztThemeBorderColor];
        [self addSubview:segmentView];
        [segmentView release];
    }
    else
    {
#ifdef tzt_ZSSC
        [segmentView SetSegmentViewItems:@[@"分时", @"五日", @"日K", @"周K", @"月K",@"分钟⌄"]];
#else
#ifdef tzt_Support5Day
        [segmentView SetSegmentViewItems:@[@"分时", @"五日", @"日K", @"周K", @"月K",@"5分钟",@"15分钟",@"30分钟",@"60分钟"]];
#else
        [segmentView SetSegmentViewItems:@[@"分时", @"日K", @"周K", @"月K",@"5分钟",@"15分钟",@"30分钟",@"60分钟"]];
#endif
#endif
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
    
    NSMutableDictionary *pDictTime = [stockDic objectForKey:tztTime];
//    NSMutableDictionary *pDictTotalH = [stockDic objectForKey:tztTradingVolume];
    
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
//    NSString *strRatio = [pDictUpDown objectForKey:tztValue];
    NSString *strRange = [pDictRange objectForKey:tztValue];
    NSString *nsValue = [NSString stringWithFormat:@"%@", strRange];
    _lbRatioAndRange.text = nsValue;
    _lbRatioAndRange.textColor = [pDictRange objectForKey:tztColor];
    
    //    NSString *strClose = [pDictClose objectForKey:tztValue];
    //最高
    NSString *strMaxPrice = [pDict objectForKey:tztValue];
    _lbMaxValue.text = strMaxPrice;
    _lbMaxValue.textColor = [pDict objectForKey:tztColor];
    
    //最低
    NSString *strMinPrice = [pDictTime objectForKey:tztValue];
    _lbMinValue.text = strMinPrice;
    _lbMinValue.textColor = [pDictTime objectForKey:tztColor];
    
//    //均价
//    NSString *strAvgPrice = [pDictAvg objectForKey:tztValue];
//    _lbAvgValue.text = strAvgPrice;
//    _lbAvgValue.textColor = [pDictAvg objectForKey:tztColor];
//    
//    //开盘
//    NSString *strOpen = [pDictOpen objectForKey:tztValue];
//    _lbOpenValue.text = strOpen;
//    _lbOpenValue.textColor = [pDictOpen objectForKey:tztColor];
}

@end

@interface tztTipsView : UIView
@property(nonatomic,retain)NSMutableArray *ayDataContent;
@property(nonatomic,retain)NSMutableArray *ayViews;
@property(nonatomic,retain)UIView         *pLineView;
-(void)setContent:(NSMutableArray*)ayData;
-(void)clearViews;
@end

@implementation tztTipsView
-(id)init
{
    self = [super init];
    if (self)
    {
        if (_ayDataContent == NULL)
            _ayDataContent = NewObject(NSMutableArray);
        if (_ayViews == NULL)
            _ayViews = NewObject(NSMutableArray);
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (_ayDataContent == NULL)
            _ayDataContent = NewObject(NSMutableArray);
        if (_ayViews == NULL)
            _ayViews = NewObject(NSMutableArray);
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    self.backgroundColor = [UIColor tztThemeHQTipBackColor];
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.size.width -= 10;
    rcFrame.size.height -= 4;
    rcFrame.origin.y += 2;
    CGFloat fXMargin = 5;
    
    NSInteger nCount = [_ayDataContent count];
    
    CGFloat fWidth = (rcFrame.size.width - fXMargin * nCount-1) / nCount;
    CGRect rcLabel = rcFrame;
    rcLabel.size.width = fWidth;
    UIFont *font = tztUIBaseViewTextFont(12);
    for (NSInteger i = 0; i < nCount; i++)
    {
        NSDictionary *dict = [_ayDataContent objectAtIndex:i];
        if (dict == nil)
            continue;
        
        CGRect rc = rcLabel;
        NSString* strTitle = [dict tztObjectForKey:tztTitleKey];
        CGRect rcTitle = rc;
        if (strTitle.length > 0)
        {
            CGFloat fTitleWidth = [strTitle sizeWithFont:font].width;
            rcTitle.size.width = fTitleWidth + 2;
            UILabel *labelTitle = (UILabel*)[self viewWithTag:0x1234 + i];
            if (labelTitle == nil)
            {
                labelTitle = [[UILabel alloc] initWithFrame:rcTitle];
                labelTitle.tag = 0x1234+i;
                labelTitle.backgroundColor = [UIColor clearColor];
                labelTitle.textColor = [UIColor tztThemeTextColorLabel];
                labelTitle.font = font;
                labelTitle.textAlignment = NSTextAlignmentCenter;
                labelTitle.adjustsFontSizeToFitWidth = YES;
                [self addSubview:labelTitle];
                [_ayViews addObject:labelTitle];
                [labelTitle release];
            }
            else
                labelTitle.frame = rcTitle;
            labelTitle.text = strTitle;
        }
        else
            rcTitle.size.width = 0;
        
        NSString* strValue = [dict tztObjectForKey:tztValueKey];
        UIColor* color = [dict tztObjectForKey:tztColorKey];
        if (color == nil)
            color = [UIColor tztThemeTextColorLabel];
        
        CGRect rcValue = rcLabel;
        rcValue.origin.x += rcTitle.size.width;
        rcValue.size.width = rcLabel.size.width - rcTitle.size.width;
        UILabel *labelValue = (UILabel*)[self viewWithTag:0x1234*2+i];
        
        if (i == 0)
        {
            rcValue.origin.x += 10;
        }
        if (labelValue == nil)
        {
            labelValue = [[UILabel alloc] initWithFrame:rcValue];
            labelValue.tag = 0x1234*2+i;
            labelValue.backgroundColor = [UIColor clearColor];
            labelValue.textAlignment = NSTextAlignmentCenter;
            labelValue.adjustsFontSizeToFitWidth = YES;
            labelValue.font = font;
            [self addSubview:labelValue];
            [_ayViews addObject:labelValue];
            [labelValue release];
        }
        else
            labelValue.frame = rcValue;
        if(i == 0)
            labelValue.textAlignment = NSTextAlignmentLeft;
        labelValue.text = strValue;
        labelValue.textColor = color;
        
        rcLabel.origin.x += rcLabel.size.width + fXMargin;
    }
    
    CGRect rcLine = self.bounds;
    rcLine.origin.y += self.bounds.size.height - 4;
    rcLine.size.height = 1;
    if (_pLineView == nil)
    {
        _pLineView = [[UIView alloc] initWithFrame:rcLine];
        _pLineView.backgroundColor = [UIColor tztThemeBorderColor];
        [self addSubview:_pLineView];
        [_pLineView release];
    }
    else
    {
        _pLineView.frame = rcLine;
    }
}

-(void)setContent:(NSMutableArray *)ayData
{
    if (_ayDataContent == NULL)
        _ayDataContent = NewObject(NSMutableArray);
    
    [_ayDataContent removeAllObjects];
    for (id data in ayData)
    {
        [_ayDataContent addObject:data];
    }
    
    [self setFrame:self.frame];
}

-(void)clearViews
{
    for (UIView *view in _ayViews)
    {
        [view removeFromSuperview];
    }
    [_ayViews removeAllObjects];
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
    tztFiveTrendView    *horFiveTrend;
    
    CGRect normalRect;
    CGRect unnorHorRect;
    CGRect norHorRect;
    
    CGRect nortitleRect;
    CGRect unnortitleRect;
    
    NSInteger   nPreSelectIndex;
    NSInteger   _nShowType;
}

@property(nonatomic,retain)tztToolbarMoreView *pToolBarView;
@property(nonatomic,retain)tztTipsView *tipsView;

@end

@implementation tztHoriView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:TZTNotifi_HiddenMoreView
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(OnHiddenMoreView:)
                                                     name:TZTNotifi_HiddenMoreView
                                                   object:nil];
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TZTNotifi_HiddenMoreView
                                                  object:nil];
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
    
    CGRect rcTips = frame;
    
    rcTips = viewWindow.frame;
    rcTips.size.height = 36;
    rcTips.size.width = viewWindow.frame.size.height - 96;
    rcTips.origin.y += (viewWindow.frame.size.width - 30);
    rcTips.origin.x += 36;
    
    if (_tipsView == nil)
    {
        _tipsView = [[tztTipsView alloc] initWithFrame:rcTips];
        _tipsView.alpha = 0.f;
        [_tipsView setTransform:at];
        
        rcTips.origin.x = viewWindow.frame.size.width - rcTips.size.height - 28; // frame.size.height == 60
        rcTips.origin.y = 0;
        rcTips.size = _tipsView.frame.size;
        rcTips.size.height = viewWindow.frame.size.height;
        _tipsView.frame = rcTips;
        
        [blackView addSubview:_tipsView];
        [_tipsView release];
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
    
    if (horFiveTrend == nil)
    {
        horFiveTrend = [[tztFiveTrendView alloc] init];
        horFiveTrend.pStockInfo = self.pStockInfo;
        horFiveTrend.bHiddenTime = NO;
        horFiveTrend.bShowMaxMinPrice = YES;
        horFiveTrend.bShowTips = NO;
        horFiveTrend.tztPriceStyle = TrendPriceNon;
        horFiveTrend.tztdelegate = self;
        horFiveTrend.bIgnorTouch = YES;
        horFiveTrend.frame = frame;
        [horFiveTrend setTransform:at];
        [blackView addSubview:horFiveTrend];
        
        
        horFiveTrend.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongPress:)];
        longpress.minimumPressDuration = 0.5;
        [horFiveTrend addGestureRecognizer:longpress];
        [longpress release];
        
        
#ifndef tzt_ZSSC
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnDoubleClick:)];
        doubleTap.numberOfTapsRequired = 2;
        [horFiveTrend addGestureRecognizer:doubleTap];
        [doubleTap release];
#endif
        
        [horFiveTrend release];
    }
    else
    {
        horFiveTrend.pStockInfo = self.pStockInfo;
    }
    
    [UIView animateWithDuration:0.1f animations:^{
        blackView.alpha = 1.0f;
    }];
    
    horTrend.frame = unnorHorRect;
    horTech.frame = unnorHorRect;
    horFiveTrend.frame = unnorHorRect;
    titleView.frame = unnortitleRect;
    [UIView animateWithDuration:0.4f animations:^{
        horTrend.frame = norHorRect;
        horTech.frame = norHorRect;
        horFiveTrend.frame = norHorRect;
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
        [horFiveTrend onSetViewRequest:bRequest];
    }
    else
    {
        [horTrend onSetViewRequest:bRequest && horTech && !horTech.hidden];
        [horTech onSetViewRequest:bRequest && horTrend && !horTrend.hidden];
        [horFiveTrend onSetViewRequest:bRequest && horFiveTrend && !horFiveTrend.hidden];
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
    if (horFiveTrend && !horFiveTrend.hidden)
        [horFiveTrend onRequestDataAutoPush];
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
    horFiveTrend.tztdelegate = nil;
    horTrend = nil;
    horTech = nil;
    horFiveTrend = nil;
    
    
    [UIView animateWithDuration:0.3f animations:^{
        horTrend.frame = unnorHorRect;
        horTech.frame = unnorHorRect;
        horFiveTrend.frame = unnorHorRect;
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
    [horFiveTrend setStockInfo:_pStockInfo Request:nRequest];
    [horTech onSetViewRequest:!horTech.hidden];
    [horTrend onSetViewRequest:!horTrend.hidden];
    [horFiveTrend onSetViewRequest:!horFiveTrend.hidden];
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
    horFiveTrend.pStockInfo = _pStockInfo;
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
    else if (obj == horFiveTrend && !horFiveTrend.hidden)
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
    else if (horFiveTrend && !horFiveTrend.hidden)
        return [horFiveTrend GetNewPriceData];
    else
        return NULL;
}

- (NSMutableDictionary *)dealNewPriceData:(TNewPriceData *)pNewPriceData
{
    NSMutableDictionary *pReturnDict = [NSMutableDictionary dictionary];
    
    if (pNewPriceData == NULL)
        return NULL;
    //股票代码
    NSString* nsCode = [[[NSString alloc] initWithBytes:pNewPriceData->Code
                                                 length:sizeof(pNewPriceData->Code)
                                               encoding:NSASCIIStringEncoding] autorelease];
    
    if(nsCode == NULL)
        nsCode = @"-";
    NSMutableDictionary *pDictCode = GetDictWithValue(nsCode, 0, 0);
    [pReturnDict setObject:pDictCode forKey:tztCode];
    
    //股票名称
    NSString* nsName = getName_TNewPriceData(pNewPriceData);
    if (nsName == NULL)
        nsName = @"--";
    NSMutableDictionary *pDictName = GetDictWithValue(nsName, 0, 0);
    [pReturnDict setObject:pDictName forKey:tztName];
    
    //时间
    NSString* nsTime = [NSString stringWithFormat:@"%02d:%02d", pNewPriceData->nHour, pNewPriceData->nMin];
    if (nsTime == NULL)
        nsTime = @"-:-";
    NSMutableDictionary *pDictTime = GetDictWithValue(nsTime, 0, 0);
    [pReturnDict setObject:pDictTime forKey:tztTime];
    
    //总成交量
    NSString* nsTotal_h = NStringOfULong(pNewPriceData->Total_h);
    
    if (nsTotal_h == NULL)
        nsTotal_h = @"--";
    NSMutableDictionary *pDictTotalH = GetDictWithValue(nsTotal_h, 0, 0);
    [pReturnDict setObject:pDictTotalH forKey:tztTradingVolume];
    
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
#ifdef tzt_ZSSC
    if (index != 5)
    {
        [titleView.segmentView.segControl reducedTitle];
        [titleView.segmentView setCurrentSelect:index];
    }
#endif

#ifndef tzt_Support5Day
    if(index > 0)
        index += 1;
#endif
    
    switch (index)
    {
        case 0:
        {
            horTech.hidden = YES;
            horFiveTrend.hidden = YES;
            horTrend.hidden = NO;
        }
            break;
        case 1:
        {
            horTrend.hidden = YES;
            horTech.hidden = YES;
            horFiveTrend.hidden = NO;
        }
            break;
        case 2:
        {
            horTrend.hidden = YES;
            horFiveTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycleDay;
        }
            break;
        case 3:
        {
            horTrend.hidden = YES;
            horFiveTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycleWeek;
        }
            break;
        case 4:
        {
            horTrend.hidden = YES;
            horFiveTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycleMonth;
        }
            break;
        case 5:
        {
#ifdef tzt_ZSSC
            UIView *window = [UIApplication sharedApplication].keyWindow;
            UIButton* pBtn = [titleView.segmentView GetCurrentSelBtn];
            CGRect Viewframe = pBtn.frame;
            float yOff = [pBtn gettztwindowy:nil];
            Viewframe.origin.y += yOff;
            
            tztToolbarMoreView *pMoreView = (tztToolbarMoreView*)[window viewWithTag:0x7878];
            if (pMoreView == NULL)
            {
                NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
                [pAy addObject:@"|5分钟|15000|"];
                [pAy addObject:@"|15分钟|15001|"];
                [pAy addObject:@"|30分钟|15002|"];
                [pAy addObject:@"|60分钟|15003|"];
                pMoreView = [[tztToolbarMoreView alloc] initWithShowType:tztShowType_List];
                pMoreView.tag = 0x7878;
                pMoreView.pDelegate = self;
                pMoreView.nPosition = tztToolbarMoreViewPositionTop | tztToolbarMoreViewPositionRight;
                pMoreView.fCellHeight = 30;
                pMoreView.nColCount = 1;
                pMoreView.nFontSize = 14.f;
                pMoreView.clSeporater = [UIColor tztThemeHQGridColor];
                pMoreView.clText = [UIColor tztThemeTextColorLabel];
                pMoreView.fMenuWidth = 120;
                
                CGAffineTransform at =CGAffineTransformMakeRotation(M_PI/2);
                at =CGAffineTransformTranslate(at,0,0);
                [pMoreView setTransform:at];
                pMoreView.szOffset = CGSizeMake(0, Viewframe.origin.y + Viewframe.size.height);
                [pMoreView SetAyGridCell:pAy];
                pMoreView.bgColor = [UIColor tztThemeBackgroundColorSection];//[UIColor colorWithPatternImage:[UIImage imageTztNamed:@"tztPopMenuBack.png"]];
                pMoreView.frame = [UIScreen mainScreen].bounds;// self.view.frame;
                pMoreView.pDelegate = self;
                [window addSubview:pMoreView];
                [pMoreView release];
            }
            else
            {
                [pMoreView removeFromSuperview];
            }
            return;
#endif
            horTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycle5Min;
        }
            break;
        case 6://15分钟
        {
            horTrend.hidden = YES;
            horFiveTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycle15Min;
        }
            break;
        case 7://30分钟
        {
            horTrend.hidden = YES;
            horFiveTrend.hidden = YES;
            horTech.hidden = NO;
            horTech.KLineCycleStyle = KLineCycle30Min;
        }
            break;
        case 8://60分钟
        {
            horTrend.hidden = YES;
            horFiveTrend.hidden = YES;
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

- (void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    NSString* strTitle = cellData.text;
    strTitle = [NSString stringWithFormat:@"%@⌄", strTitle];
    
    UIButton* pBtn = NULL;
    horTrend.hidden = YES;
    horTech.hidden = NO;
    horFiveTrend.hidden = YES;
    pBtn = [titleView.segmentView GetCurrentSelBtn];
    [pBtn setTztTitle:strTitle];
    [pBtn layoutSubviews];
    [titleView.segmentView setCurrentSelect:5];
    [pBtn layoutSubviews];
    
    
    switch (cellData.cmdid)
    {
        case 15000://5分钟
        {
            horTech.KLineCycleStyle = KLineCycle5Min;
        }
            break;
        case 15001://15
        {
            horTech.KLineCycleStyle = KLineCycle15Min;
        }
            break;
        case 15002://30
        {
            horTech.KLineCycleStyle = KLineCycle30Min;
        }
            break;
        case 15003://60
        {
            horTech.KLineCycleStyle = KLineCycle60Min;
        }
            break;
        default:
            break;
    }
    nPreSelectIndex =  titleView.segmentView.segControl.currentSelected;
    
    self.pStockInfo = _pStockInfo;
    [horTrend setStockInfo:_pStockInfo Request:!horTrend.hidden];
    [horTrend onSetViewRequest:!horTrend.hidden];
    [horTech setStockInfo:_pStockInfo Request:!horTech.hidden];
    [horTech onSetViewRequest:!horTech.hidden];
    [horFiveTrend setStockInfo:_pStockInfo Request:!horFiveTrend.hidden];
    [horFiveTrend onSetViewRequest:!horFiveTrend.hidden];
}

//更多界面隐藏，回到上个界面的选中
-(void)OnHiddenMoreView:(NSNotification*)notification
{
    if(notification && [notification.name compare:TZTNotifi_HiddenMoreView]== NSOrderedSame)
    {
        if (nPreSelectIndex == titleView.segmentView.segControl.currentSelected)
            return;
        [titleView.segmentView setCurrentSelect:nPreSelectIndex];
    }
}


- (void)setSegment:(int)segmentIndex
{
    [self updateSelected:segmentIndex];
}


- (void)selectedSeg:(NSInteger)index
{
    [self updateSelected:index];
}

-(void)tztHqView:(id)hqView ShowCursorTipsView:(BOOL)bShow
{
    [UIView animateWithDuration:0.2f animations:^{
        self.tipsView.alpha = (bShow ? 1.0 : 0.0);
    }];
}

-(void)tztHqView:(id)hqView SetCursorData:(id)pData
{
    //收到数据
    NSMutableArray *ay = NewObject(NSMutableArray);
    
    UIColor *clBalance = [UIColor tztThemeHQBalanceColor];
    UIColor *clUpColor = [UIColor tztThemeHQUpColor];
    UIColor *clDownColor = [UIColor tztThemeHQDownColor];
    UIColor *clFixColor = [UIColor tztThemeHQFixTextColor];
    
    //分时
    if ([hqView isKindOfClass:[tztTrendView class]])
    {
        if (_nShowType != 0)
        {
            [self.tipsView clearViews];
            _nShowType = 0;
        }
        NSString* strPreClose = [pData tztObjectForKey:tztYesTodayPrice];
        //时间
        NSString* strTime = [pData tztObjectForKey:tztTime];
        NSDictionary* dict = @{tztTitleKey:@"", tztValueKey:strTime, tztColorKey : clBalance};
        [ay addObject:dict];
        //最新
        NSString* strNewPrice = [pData tztObjectForKey:tztNewPrice];
        UIColor *pColor = clBalance;
        if ([strNewPrice floatValue] > [strPreClose floatValue])
        {
            pColor = clUpColor;
        }
        else if ([strNewPrice floatValue] < [strPreClose floatValue])
        {
            pColor = clDownColor;
        }
        NSDictionary* dictNew = @{tztTitleKey:@"价格:", tztValueKey:strNewPrice, tztColorKey : pColor};
        [ay addObject:dictNew];
        
        //涨跌
        NSString* strRatio = [pData tztObjectForKey:tztPriceRange];
        NSDictionary* dictRatio = @{tztTitleKey:@"涨跌:", tztValueKey:strRatio, tztColorKey : pColor};
        [ay addObject:dictRatio];
        
        //现手
        NSString* strNowHand = [pData tztObjectForKey:tztNowVolume];
        NSDictionary* dictHand = @{tztTitleKey:@"成交:", tztValueKey:strNowHand, tztColorKey : clFixColor};
        [ay addObject:dictHand];
//        //幅度
//        NSString* strRange = [pData tztObjectForKey:tztPriceRange];
//        NSDictionary* dictRange = @{tztTitleKey:@"幅", tztValueKey:strRange, tztColorKey : pColor};
//        [ay addObject:dictRange];
//        
        //均价
        NSString* strAvgPrice = [pData tztObjectForKey:tztNowVolume];
        if ([strAvgPrice floatValue] > [strPreClose floatValue])
            pColor = clUpColor;
        else if ([strAvgPrice floatValue] < [strPreClose floatValue])
            pColor = clDownColor;
        NSDictionary* dictAvg = @{tztTitleKey:@"均价:", tztValueKey:strAvgPrice, tztColorKey : pColor};
        [ay addObject:dictAvg];
//        
//        //最高
//        NSString* strMaxPrice = [pData tztObjectForKey:tztMaxPrice];
//        if ([strMaxPrice floatValue] > [strPreClose floatValue])
//            pColor = clUpColor;
//        else if ([strMaxPrice floatValue] < [strPreClose floatValue])
//            pColor = clDownColor;
//        NSDictionary* dictMax = @{tztTitleKey:@"高", tztValueKey:strMaxPrice, tztColorKey : pColor};
//        [ay addObject:dictMax];
//        
//        //最低
//        NSString* strMinPrice = [pData tztObjectForKey:tztMinPrice];
//        if ([strMinPrice floatValue] > [strPreClose floatValue])
//            pColor = clUpColor;
//        else if ([strMinPrice floatValue] < [strPreClose floatValue])
//            pColor = clDownColor;
//        NSDictionary* dictMin = @{tztTitleKey:@"低", tztValueKey:strMinPrice, tztColorKey : pColor};
//        [ay addObject:dictMin];
        
        
    }
    else if ([hqView isKindOfClass:[tztTechView class]])
    {
        if (_nShowType != 1)
        {
            [self.tipsView clearViews];
            _nShowType = 1;
        }
        NSString* strPreClose = [pData tztObjectForKey:@"tztKLinePreClose"];
        //时间
        NSString* strTime = [pData tztObjectForKey:tztTime];
        NSDictionary* dict = @{tztTitleKey:@"", tztValueKey:strTime, tztColorKey : clBalance};
        [ay addObject:dict];
        //开盘
        NSString* strOpenPrice = [pData tztObjectForKey:tztStartPrice];
        UIColor *pColor = clBalance;
        if ([strOpenPrice floatValue] > [strPreClose floatValue])
        {
            pColor = clUpColor;
        }
        else if ([strOpenPrice floatValue] < [strPreClose floatValue])
        {
            pColor = clDownColor;
        }
        NSDictionary* dictNew = @{tztTitleKey:@"开:", tztValueKey:strOpenPrice, tztColorKey : pColor};
        [ay addObject:dictNew];
        //最高
        NSString* strMaxPrice = [pData tztObjectForKey:tztMaxPrice];
        if ([strMaxPrice floatValue] > [strPreClose floatValue])
            pColor = clUpColor;
        else if ([strMaxPrice floatValue] < [strPreClose floatValue])
            pColor = clDownColor;
        NSDictionary* dictMax = @{tztTitleKey:@"高:", tztValueKey:strMaxPrice, tztColorKey : pColor};
        [ay addObject:dictMax];
        
        //最低
        NSString* strMinPrice = [pData tztObjectForKey:tztMinPrice];
        if ([strMinPrice floatValue] > [strPreClose floatValue])
            pColor = clUpColor;
        else if ([strMinPrice floatValue] < [strPreClose floatValue])
            pColor = clDownColor;
        NSDictionary* dictMin = @{tztTitleKey:@"低:", tztValueKey:strMinPrice, tztColorKey : pColor};
        [ay addObject:dictMin];
        
        //昨收
        NSString* strClose = [pData tztObjectForKey:tztYesTodayPrice];
        if ([strClose floatValue] > [strPreClose floatValue])
            pColor = clUpColor;
        else if ([strClose floatValue] < [strPreClose floatValue])
            pColor = clDownColor;
        NSDictionary* dictClose = @{tztTitleKey:@"收:", tztValueKey:strMinPrice, tztColorKey : pColor};
        [ay addObject:dictClose];
        
        //涨跌
        NSString* strRatio = [pData tztObjectForKey:tztUpDown];
        NSDictionary* dictRatio = @{tztTitleKey:@"涨:", tztValueKey:strRatio, tztColorKey : pColor};
        [ay addObject:dictRatio];
        
//        //幅度
//        NSString* strRange = [pData tztObjectForKey:tztPriceRange];
//        NSDictionary* dictRange = @{tztTitleKey:@"幅", tztValueKey:strRange, tztColorKey : pColor};
//        [ay addObject:dictRange];
//        
//        //现手
//        NSString* strNowHand = [pData tztObjectForKey:tztNowVolume];
//        NSDictionary* dictHand = @{tztTitleKey:@"量", tztValueKey:strNowHand, tztColorKey : clFixColor};
//        [ay addObject:dictHand];
    }
        
    [self.tipsView setContent:ay];
    DelObject(ay);
}

-(void)OnLongPress:(UILongPressGestureRecognizer*)reco
{
    CGPoint pt = [reco locationInView:horFiveTrend];
    
    UIGestureRecognizerState state = reco.state;
    if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateFailed)
    {
        [horFiveTrend trendTouchMoved:pt bShowCursor_:NO];
        [self tztHqView:self ShowCursorTipsView:NO];
    }
    else
    {
        [horFiveTrend trendTouchMoved:pt bShowCursor_:YES];
        [self tztHqView:self ShowCursorTipsView:YES];
    }
}



-(void)OnDoubleClick:(UITapGestureRecognizer*)reco
{
    [self tztTimeTechTitleView:self OnCloser:NULL];
}

@end
