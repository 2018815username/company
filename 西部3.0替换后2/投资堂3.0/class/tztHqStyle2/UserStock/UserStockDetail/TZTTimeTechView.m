//
//  TZTTimeTechView.m
//  tztMobileApp_GJUserStock
//
//  Created by 在琦中 on 14-3-27.
//
//

#import "TZTTimeTechView.h"
#import "tztHoriView.h"
#import "tztHoriTrendView.h"
#ifndef tzt_ZSSC
#define  Use_Old
#endif
#define HeightGap 5.0
#define ViewWidth self.frame.size.width - 10
#define SegHeight 34.0
#define KTagTag 1000


#define tagtztCycle 0x10000
#define tagtztZhibiao 0x20000
#define tagtztEditParam 0x30000

@interface TZTTimeTechView()<tztHoriViewDelegate>
{
    TZTSegSectionView *segmentView;
    tztHoriView *blackView;
    CGRect normalRect;
    CGRect unnorHorRect;
    CGRect norHorRect;
    
    CGRect nortitleRect;
    CGRect unnortitleRect;
    
    NSInteger   nPreSelectIndex;
}

@property(nonatomic,retain)tztToolbarMoreView *pToolBarView;
#ifdef Use_Old
@property (nonatomic, retain)tztTrendView *pTrend;
#else
@property (nonatomic, retain)/*tztTrendView*/ tztHoriTrendView *pTrend;
#endif

@property (nonatomic,retain)tztFiveTrendView    *pFiveTrend;
@property (nonatomic, retain)tztTechView *pTech;

@end
@implementation TZTTimeTechView

@synthesize pTrend = _pTrend, pTech = _pTech;
@synthesize pToolBarView = _pToolBarView;
@synthesize isHorizon = _isHorizon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)initdata
{
    [super initdata];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnHiddenMoreView:)
                                                 name:TZTNotifi_HiddenMoreView
                                               object:nil];
}

-(void)dealloc
{
    [_pStockInfo release];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TZTNotifi_HiddenMoreView
                                                  object:nil];
    [super dealloc];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    [super onSetViewRequest:bRequest];
    if (!bRequest)
    {
        [self.pTrend onSetViewRequest:NO];
        [self.pTech onSetViewRequest:NO];
        [self.pFiveTrend onSetViewRequest:NO];
    }
    else
    {
        if (self.pTrend && !self.pTrend.hidden)
            [self.pTrend onSetViewRequest:bRequest];
        if (self.pTech && !self.pTech.hidden)
            [self.pTech onSetViewRequest:bRequest];
        if (self.pFiveTrend && !self.pFiveTrend.hidden)
            [self.pFiveTrend onSetViewRequest:bRequest];
    }
}

-(void)onRequestData:(BOOL)bShowProcess
{
    if (!_bRequest)
        return;
    [self.pTrend onSetViewRequest:!self.pTrend.hidden];
    [self.pFiveTrend onSetViewRequest:!self.pFiveTrend.hidden];
    [self.pTech onSetViewRequest:!self.pTech.hidden];
    if (self.pTrend && !self.pTrend.hidden)
        [self.pTrend onRequestData:bShowProcess];
    if (self.pFiveTrend && !self.pFiveTrend.hidden)
        [self.pFiveTrend onRequestData:bShowProcess];
    if (self.pTech && !self.pTech.hidden)
        [self.pTech onRequestData:bShowProcess];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
}

-(void)onRequestDataAutoPush
{
    if (_isHorizon)
    {
        [blackView onRequestDataAutoPush];
    }
    else
    {
        if (!_bRequest)
            return;
        [self onRequestData:FALSE];
    }
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect segRect;
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    segRect = CGRectMake(5 , HeightGap, ViewWidth, SegHeight);

    if (segmentView == nil)
    {
#ifdef tzt_Support5Day
        segmentView = [[TZTSegSectionView alloc] initWithFrame:segRect andItems:@[@"分时", @"五日", @"日K", @"周K", @"月K",@"分钟⌄"] andDelegate:self];
#else
        segmentView = [[TZTSegSectionView alloc] initWithFrame:segRect andItems:@[@"分时", @"日K", @"周K", @"月K",@"分钟⌄"] andDelegate:self];
#endif
        [self addSubview:segmentView];
        [segmentView release];
    }
    else
    {
        segmentView.frame = segRect;
    }
    
    CGRect rect;
    rect = CGRectMake(5, HeightGap*2 + SegHeight , ViewWidth /*- 5*/, frame.size.height - SegHeight - HeightGap*3);
    
#ifndef Use_Old
    rect.size.width -= 5;
#endif
    normalRect = rect;
    //分时
    if (self.pTrend == NULL)
    {
#ifndef Use_Old
        _pTrend = [[tztHoriTrendView alloc] init];
        self.pTrend.fDetailWidth = 99;
        self.pTrend.bHoriShow = NO;
        self.pTrend.tztPriceStyle = TrendPriceNon;
        self.pTrend.bShowLeftPriceInSide = YES;
        self.pTrend.bShowMaxMinPrice = YES;
#ifdef tzt_ZSSC
        self.pTrend.bHiddenTime = NO;
#else
        self.pTrend.bHiddenTime = YES;
#endif
        self.pTrend.tztdelegate = self;
        self.pTrend.frame = rect;
#else
        _pTrend = [[tztTrendView alloc] init];
        self.pTrend.tztdelegate = self;
        self.pTrend.pStockInfo = self.pStockInfo;
        self.pTrend.tztPriceStyle = TrendPricePriceOnly;
        self.pTrend.bSupportTrendCursor = FALSE;
        self.pTrend.bShowLeftPriceInSide = YES;
        self.pTrend.bShowMaxMinPrice = YES;
        self.pTrend.bHiddenTime = YES;
#endif


        self.pTrend.frame = rect;
        if (g_bUseHQAutoPush)
            self.pTrend.bAutoPush = YES;
        [self addSubview:self.pTrend];
        [self.pTrend release];
    }
    else
    {
        self.pTrend.frame = rect;
    }
    
#ifdef tzt_Support5Day
    if (self.pFiveTrend == NULL)
    {
        self.pFiveTrend = [[tztFiveTrendView alloc] init];
        self.pFiveTrend.tztdelegate = self;
        self.pFiveTrend.pStockInfo = self.pStockInfo;
        self.pFiveTrend.tztPriceStyle = TrendPriceNon;
        self.pFiveTrend.bSupportTrendCursor = FALSE;
        self.pFiveTrend.bShowLeftPriceInSide = YES;
        self.pFiveTrend.bShowMaxMinPrice = YES;
        self.pFiveTrend.bHiddenTime = NO;
        
        self.pFiveTrend.frame = rect;
        self.pFiveTrend.hidden = YES;
        if (g_bUseHQAutoPush)
            self.pFiveTrend.bAutoPush = YES;
        [self addSubview:self.pFiveTrend];
        [self.pFiveTrend release];
    }
    else
    {
        self.pFiveTrend.frame = rect;
    }
#endif
    
    // K线
    if (self.pTech == NULL)
    {
        _pTech = [[tztTechView alloc] initWithFrame:rect];
        self.pTech.tztdelegate = self;
        self.pTech.bHiddenCycle = YES;
        self.pTech.bHiddenObj  = YES;
        self.pTech.KLineCycleStyle = KLineCycleDay;
        [self addSubview:self.pTech];
        self.pTech.btnCycle.hidden = YES;
        self.pTech.btnZhiBiao.hidden = YES;
        self.pTech.bSupportTechCursor = NO;
#ifndef tzt_ZSSC
        self.pTech.btnZoomIn.hidden = YES;
        self.pTech.btnZoomOut.hidden = YES;
        self.pTech.bTouchParams = NO;
        self.pTech.bShowTechParams = NO;
        self.pTech.bShowLeftInSide = YES;
        self.pTech.bShowMaxMin = YES;
#else
        self.pTech.PKLineAxisStyle = KLineYAxis;
        self.pTech.ObjAxisStyle = KLineXYAxis;
        self.pTech.bShowObj = YES;
        self.pTech.bShowChuQuan = YES;
#endif
#ifndef Use_Old
        self.pTech.bTechMoved = YES;
#endif
        self.pTech.hidden = YES;
        if (g_bUseHQAutoPush)
            self.pTech.bAutoPush = YES;
        [self.pTech release];
    }
    else
    {
        self.pTech.frame = rect;
    }
   
}

-(void)tztSegmentView:(id)segView didSelectAtIndex:(int)nIndex
{
    if (segView == segmentView)
    {
        [self setSegment:nIndex];
    }
}

-(void)tztHoriViewClosedAtIndex:(NSInteger)nIndex
{
    segmentView.segControl.currentSelected = nIndex;
    if (nIndex >= 4)
        segmentView.segControl.currentSelected = 0;
    [self showNormal];
    [blackView removeFromSuperview];
    blackView = nil;
    [self onSetViewRequest:YES];
}

- (void)showNormal
{
    _isHorizon = NO;
    [self updateSelected:segmentView.segControl.currentSelected];
    
    [UIView animateWithDuration:0.1f animations:^{
        blackView.alpha = .0f;
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.3f animations:^{
        self.pTrend.frame = normalRect;
        self.pTech.frame = normalRect;
        self.pFiveTrend.frame = normalRect;
    }];
}

- (void)setSegment:(int)segmentIndex
{
    [self updateSelected:segmentIndex];
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    [super setStockInfo:pStockInfo Request:nRequest];
    if (!self.pTrend.hidden)
    {
        [self.pTech onSetViewRequest:NO];
        [self.pFiveTrend onSetViewRequest:NO];
#ifdef Use_Old
        if (!MakeStockMarketStock(self.pStockInfo.stockType) && !MakeHKMarketStock(self.pStockInfo.stockType)
            && !MakeUSMarket(self.pStockInfo.stockType))
        {
            self.pTrend.tztPriceStyle = TrendPriceNon;
        }
        else
        {
            self.pTrend.tztPriceStyle = TrendPricePriceOnly;
        }
#endif
        if (self.pTrend && [self.pTrend respondsToSelector:@selector(setStockInfo:Request:)])
        {
            [self.pTrend onSetViewRequest:YES];
            [self.pTrend setStockInfo:_pStockInfo Request:YES];
        }
        else
        {
            [self.pTrend onSetViewRequest:YES];
        }
    }
    if (!self.pTech.hidden)
    {
        [self.pTrend onSetViewRequest:NO];
        [self.pFiveTrend onSetViewRequest:YES];
        if (self.pTech && [self.pTech respondsToSelector:@selector(setStockInfo:Request:)])
        {
            [self.pTech onSetViewRequest:YES];
            [self.pTech setStockInfo:_pStockInfo Request:YES];
        }
        else
        {
            [self.pTech onSetViewRequest:YES];
        }
    }
    if (!self.pFiveTrend.hidden)
    {
        [self.pTrend onSetViewRequest:NO];
        [self.pFiveTrend onSetViewRequest:NO];
        
        if (self.pFiveTrend && [self.pFiveTrend respondsToSelector:@selector(setStockInfo:Request:)])
        {
            [self.pFiveTrend onSetViewRequest:YES];
            [self.pFiveTrend setStockInfo:_pStockInfo Request:YES];
        }
        else
        {
            [self.pFiveTrend onSetViewRequest:YES];
        }
        
    }
}

- (void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    [_pStockInfo release];
    _pStockInfo = [pStockInfo retain];
    self.pTrend.pStockInfo = _pStockInfo;
#ifdef Use_Old
    if (!MakeStockMarketStock(self.pStockInfo.stockType) && !MakeHKMarketStock(self.pStockInfo.stockType)
        && !MakeUSMarket(self.pStockInfo.stockType))
    {
        self.pTrend.tztPriceStyle = TrendPriceNon;
    }
    else
    {
        self.pTrend.tztPriceStyle = TrendPricePriceOnly;
    }
#else
    self.pTrend.frame = self.pTrend.frame;
#endif
    self.pTech.pStockInfo = _pStockInfo;
    self.pFiveTrend.frame = self.pFiveTrend.frame;
    self.pFiveTrend.pStockInfo = _pStockInfo;
}

-(void)ClearData
{
    self.pStockInfo = nil;
    if (self.pTrend)
        self.pTrend.pStockInfo = nil;
    if (self.pTech)
        self.pTech.pStockInfo = nil;
    if (self.pFiveTrend)
        self.pFiveTrend.pStockInfo = nil;
}

-(void)onClearData
{
    if (self.pTrend)
        [self.pTrend onClearData];
    if (self.pTech)
        [self.pTech onClearData];
    if (self.pFiveTrend)
        [self.pFiveTrend onClearData];
}

-(void)UpdateData:(id)obj
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(UpdateData:)])
    {
        [_tztdelegate UpdateData:self];
    }
//    [blackView UpdateData:obj];
}

#pragma mark - tztHqBaseViewDelegate

- (BOOL)showHorizenView:(UIView*)view
{
    if (_isHorizon)
    {
        return FALSE;
    }
    
    UIView *viewWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint center = view.center;
    center.x -= viewWindow.frame.size.width;
    [UIView animateWithDuration:0.1f animations:^{
        self.pTrend.center = center;
        self.pTech.center = center;
        self.pFiveTrend.center = center;
    }];
    [self performSelector:@selector(showHorizen) withObject:nil afterDelay:0.1f];
    _isHorizon = YES;
    return TRUE;
}

- (void)showHorizen{
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    UIView *viewWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (blackView == nil) {
        blackView = [[tztHoriView alloc] init];
        blackView.nCurrentIndex = segmentView.segControl.currentSelected;
        blackView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        blackView.alpha = .0f;
        blackView.tztdelegate = self;
        blackView.pStockInfo = self.pStockInfo;
        blackView.frame = viewWindow.frame;
        [viewWindow addSubview:blackView];
        [blackView release];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self onSetViewRequest:NO];
    [blackView setStockInfo:self.pStockInfo Request:1];
}

- (void)updateSelected:(NSInteger)index
{
    int n = 4;
#ifdef tzt_Support5Day
    n = 5;
#endif
    if (index != n && !_isHorizon)
    {
        [segmentView.segControl reducedTitle];
        
        [segmentView setCurrentSelect:index];
    }
#ifdef tzt_Support5Day
    switch (index) {
        case 0:
        {
            self.pFiveTrend.hidden = YES;
            self.pTrend.hidden = NO;
            self.pTech.hidden = YES;
        }
            break;
        case 1:
        {
            self.pFiveTrend.hidden = YES;
            self.pTrend.hidden = YES;
            self.pTech.hidden = YES;
            self.pFiveTrend.hidden = NO;
        }
            break;
        case 2:
        {
            self.pFiveTrend.hidden = YES;
            self.pTrend.hidden = YES;
            self.pTech.hidden = NO;
            self.pTech.KLineCycleStyle = KLineCycleDay;
        }
            break;
        case 3:
        {
            self.pFiveTrend.hidden = YES;
            self.pTrend.hidden = YES;
            self.pTech.hidden = NO;
            self.pTech.KLineCycleStyle = KLineCycleWeek;
        }
            break;
        case 4:
        {
            self.pFiveTrend.hidden = YES;
            self.pTrend.hidden = YES;
            self.pTech.hidden = NO;
            self.pTech.KLineCycleStyle = KLineCycleMonth;
        }
            break;
        case 5:
        {
            if (!_isHorizon)
            {
                UIView *window = [UIApplication sharedApplication].keyWindow;
                UIButton* pBtn = [segmentView GetCurrentSelBtn];
                CGRect Viewframe = pBtn.frame;
                //                if (_isHorizon)
                //                {
                //                    pBtn = [titleView GetCurrentSelBtn];
                //                    Viewframe = pBtn.frame;
                //                }
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
                    
                    if (_isHorizon)
                    {
                        CGAffineTransform at =CGAffineTransformMakeRotation(M_PI/2);
                        at =CGAffineTransformTranslate(at,0,0);
                        [pMoreView setTransform:at];
                        pMoreView.szOffset = CGSizeMake(0, Viewframe.origin.y + Viewframe.size.height);
                    }
                    else
                    {
                        pMoreView.szOffset = CGSizeMake(0, Viewframe.origin.y + Viewframe.size.height);
                    }
                    
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
            }
            else//5分钟
            {
                self.pTrend.hidden = YES;
                self.pTech.hidden = YES;
                //                horTrend.hidden = YES;
                //                horTech.hidden = NO;
                //                horTech.KLineCycleStyle = KLineCycle5Min;
            }
        }
            break;
        default:
            break;
    }
#else
    switch (index) {
        case 0:
        {
            self.pTrend.hidden = NO;
            self.pTech.hidden = YES;
        }
            break;
        case 1:
        {
            self.pTrend.hidden = YES;
            self.pTech.hidden = NO;
            self.pTech.KLineCycleStyle = KLineCycleDay;
        }
            break;
        case 2:
        {
            self.pTrend.hidden = YES;
            self.pTech.hidden = NO;
            self.pTech.KLineCycleStyle = KLineCycleWeek;
        }
            break;
        case 3:
        {
            self.pTrend.hidden = YES;
            self.pTech.hidden = NO;
            self.pTech.KLineCycleStyle = KLineCycleMonth;
        }
            break;
        case 4:
        {
            if (!_isHorizon)
            {
                UIView *window = [UIApplication sharedApplication].keyWindow;
                UIButton* pBtn = [segmentView GetCurrentSelBtn];
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
                    
                    if (_isHorizon)
                    {
                        CGAffineTransform at =CGAffineTransformMakeRotation(M_PI/2);
                        at =CGAffineTransformTranslate(at,0,0);
                        [pMoreView setTransform:at];
                        pMoreView.szOffset = CGSizeMake(0, Viewframe.origin.y + Viewframe.size.height);
                    }
                    else
                    {
                        pMoreView.szOffset = CGSizeMake(0, Viewframe.origin.y + Viewframe.size.height);
                    }
                    
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
            }
            else//5分钟
            {
                self.pTrend.hidden = YES;
                self.pTech.hidden = YES;
                //                horTrend.hidden = YES;
                //                horTech.hidden = NO;
                //                horTech.KLineCycleStyle = KLineCycle5Min;
            }
        }
            break;
        default:
            break;
    }

#endif
    [self.pTrend setStockInfo:_pStockInfo Request:!self.pTrend.hidden];
    [self.pTrend onSetViewRequest:!self.pTrend.hidden];
    [self.pTech setStockInfo:_pStockInfo Request:!self.pTech.hidden];
    [self.pTech onSetViewRequest:!self.pTech.hidden];
    [self.pFiveTrend setStockInfo:_pStockInfo Request:!self.pFiveTrend.hidden];
    [self.pFiveTrend onSetViewRequest:!self.pFiveTrend.hidden];
    self.pStockInfo = _pStockInfo;
    nPreSelectIndex = index;
}

- (void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    NSString* strTitle = cellData.text;
    strTitle = [NSString stringWithFormat:@"%@⌄", strTitle];
    
    UIButton* pBtn = NULL;
    self.pTrend.hidden = YES;
    self.pTech.hidden = NO;
    self.pFiveTrend.hidden = YES;
    pBtn = [segmentView GetCurrentSelBtn];
    [pBtn setTztTitle:strTitle];
    [pBtn layoutSubviews];
    [segmentView setCurrentSelect:4];
    [pBtn layoutSubviews];
    
    
    switch (cellData.cmdid)
    {
        case 15000://5分钟
        {
            self.pTech.KLineCycleStyle = KLineCycle5Min;
        }
            break;
        case 15001://15
        {
            self.pTech.KLineCycleStyle = KLineCycle15Min;
        }
            break;
        case 15002://30
        {
            self.pTech.KLineCycleStyle = KLineCycle30Min;
        }
            break;
        case 15003://60
        {
            self.pTech.KLineCycleStyle = KLineCycle60Min;
        }
            break;
        default:
            break;
    }
    nPreSelectIndex = segmentView.segControl.currentSelected;
    
    self.pStockInfo = _pStockInfo;
    [self.pTrend setStockInfo:_pStockInfo Request:!self.pTrend.hidden];
    [self.pTrend onSetViewRequest:!self.pTrend.hidden];
    [self.pTech setStockInfo:_pStockInfo Request:!self.pTech.hidden];
    [self.pTech onSetViewRequest:!self.pTech.hidden];
    [self.pFiveTrend setStockInfo:_pStockInfo Request:!self.pFiveTrend.hidden];
    [self.pFiveTrend onSetViewRequest:!self.pFiveTrend.hidden];
}

-(TNewPriceData*)GetNewPriceData
{
    if (self.pTrend && !self.pTrend.hidden)
    {
        return [self.pTrend GetNewPriceData];
    }
    else if (self.pTech && !self.pTech.hidden)
        return [self.pTech GetNewPriceData];
    else if (self.pFiveTrend && !self.pFiveTrend.hidden)
        return [self.pFiveTrend GetNewPriceData];
    return NULL;
}

//更多界面隐藏，回到上个界面的选中
-(void)OnHiddenMoreView:(NSNotification*)notification
{
    if(notification && [notification.name compare:TZTNotifi_HiddenMoreView]== NSOrderedSame)
    {
//        if( notification.object != self.pToolBarView)
//            return;
//        
        if (nPreSelectIndex == segmentView.segControl.currentSelected)
            return;
        [segmentView setCurrentSelect:nPreSelectIndex];
    }
}

-(void)tztHqView:(id)hqView setTitleStatus:(NSInteger)nStatus andStockType_:(NSInteger)nType
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:setTitleStatus:andStockType_:)])
    {
        [self.tztdelegate tztHqView:hqView setTitleStatus:nStatus andStockType_:nType];
    }
}
@end
