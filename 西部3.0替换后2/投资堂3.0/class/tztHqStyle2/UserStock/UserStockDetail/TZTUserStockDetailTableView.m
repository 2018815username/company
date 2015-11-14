//
//  TZTUserStockDetailTableView.m
//  tztMobileApp_GJUserStock
//
//  Created by 在琦中 on 14-3-26.
//
//

#import "TZTUserStockDetailTableView.h"
#import "TZTUIStockDetailHeaderView.h"
#import "TZTTimeTechView.h"
#import "tztInfoTableView.h"
#import "TZTHSStockTableView.h"
#import "TZTUserStockTableViewCell.h"
#import "tztWebView.h"
#import "TZTInitReportMarketMenu.h"
#import "tztUIStockDetailHeaderViewEx.h"

#define HSTrend @"HSTrend"
#define HKTrend @"HKTrend"
#define USTrend @"USTrend"
#define HSIndexTrend @"HSIndexTrend"
#define HKIndexTrend @"HKIndexTrend"


#define UserStockDetailHeaderHeight (250.0/2 - 21)
#define TimeTechViewHeight (430.0/2 + 50)
#define SegSectionHeight 34.0

#define  tztInfoHeight  253
#define  tztFinaceHeight ([UIScreen mainScreen].bounds.size.height - 128)

@interface tztSectionObj : NSObject
@property(nonatomic,retain)NSString     *nsTitle;
@property(nonatomic,retain)NSString     *nsType;
@property(nonatomic,retain)NSString     *nsURL;
@property(nonatomic,assign)CGFloat      fRowHeight;
@property(nonatomic,assign)NSInteger    fRowCount;
@end

@implementation tztSectionObj

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

@end

@interface tztTrendDetailSectionObj : NSObject

@property(nonatomic,assign)CGFloat      fSectionHeight;
@property(nonatomic,assign)CGFloat      fRowHeight;
@property(nonatomic,assign)NSInteger    fRowCount;
@property(nonatomic,assign)CGFloat      fXMargin;
//对应tztSectionObj数组
@property(nonatomic,retain)NSMutableArray   *aySections;
@property(nonatomic,retain)UIView       *pSegcontrolView;
@property(nonatomic,assign)NSInteger    nCurrentIndex;
@property(nonatomic,retain)NSMutableArray   *ayShowViews;

@end

@implementation tztTrendDetailSectionObj

-(id)init
{
    if (self = [super init])
    {
        _fSectionHeight = 0;
        _fRowHeight = 0;
        _aySections = NewObject(NSMutableArray);
        _ayShowViews = NewObject(NSMutableArray);
    }
    return self;
}

-(void)dealloc
{
    [_aySections removeAllObjects];
    if (_aySections)
        [_aySections release];
    [super dealloc];
}

@end

@interface tztTrendDetailObj : NSObject
//报价
@property(nonatomic,assign)CGFloat      fQuoteHeight;//报价显示高度
@property(nonatomic,assign)BOOL         bShowUserStock;//显示自选股操作
@property(nonatomic,assign)BOOL         bShowBlock;//是否显示关联板块
@property(nonatomic,assign)BOOL         bShowExchange;//是否显示扩展报价数据
@property(nonatomic,assign)BOOL         bShowTradeStock;//是否支持显示持仓数据
@property(nonatomic,retain)NSMutableArray *ayQuoteKeys;//
@property(nonatomic,retain)NSMutableArray *ayQuoteExchangeKeys;
//中间分时图等
@property(nonatomic,retain)NSMutableArray  *aySections;

-(NSMutableArray*)GetSections;
-(NSMutableArray*)GetQuoteKeys;
-(NSMutableArray*)GetQuoteExchangeKeys;
@end

@implementation tztTrendDetailObj

-(id)init
{
    self = [super init];
    _aySections = NewObject(NSMutableArray);
    
    return self;
}

-(void)dealloc
{
    if (_aySections)
    {
        [_aySections removeAllObjects];
        [_aySections release];
    }
    if (_ayQuoteExchangeKeys)
    {
        [_ayQuoteExchangeKeys removeAllObjects];
        [_ayQuoteExchangeKeys release];
    }
    if (_ayQuoteKeys)
    {
        [_ayQuoteKeys removeAllObjects];
        [_ayQuoteKeys release];
    }
    [super dealloc];
}

-(void)setAyQuoteKeys:(NSMutableArray *)ayKeys
{
    if (_ayQuoteKeys == nil)
        _ayQuoteKeys = NewObject(NSMutableArray);
    [_ayQuoteKeys removeAllObjects];
    for (NSInteger i = 0; i < ayKeys.count; i++)
    {
        [_ayQuoteKeys addObject:[ayKeys objectAtIndex:i]];
    }
}

-(void)setAyQuoteExchangeKeys:(NSMutableArray *)ayKeys
{
    if (_ayQuoteExchangeKeys == nil)
        _ayQuoteExchangeKeys = NewObject(NSMutableArray);
    [_ayQuoteExchangeKeys removeAllObjects];
    for (NSInteger i = 0; i < ayKeys.count; i++)
    {
        [_ayQuoteExchangeKeys addObject:[ayKeys objectAtIndex:i]];
    }
}

-(NSMutableArray*)GetSections
{
    return _aySections;
}

-(NSMutableArray*)GetQuoteKeys
{
    return _ayQuoteKeys;
}

-(NSMutableArray*)GetQuoteExchangeKeys
{
    return _ayQuoteExchangeKeys;
}

@end

@interface tztTrendDetailConfig : NSObject
//标题
@property(nonatomic,assign)NSInteger    nTitleType;//标题类型，0－国金类型 1-华泰类型
@property(nonatomic,assign)BOOL         bToolbarAlways;
@property(nonatomic,retain)NSMutableDictionary  *dictMarkets;

-(id)initWithConfig:(NSString*)nsFileName;
+(tztTrendDetailConfig*)getShareInstance;
-(tztTrendDetailObj*)GetSectionDetailByStockType:(UInt32)stockType;
-(tztTrendDetailObj*)GetSectionDetail:(NSString*)nsType;
-(tztTrendDetailSectionObj*)GetSectionAtIndex:(NSInteger)nSection andType:(NSString*)nsType;
-(tztTrendDetailSectionObj*)GetSectionAtIndex:(NSInteger)nSection andStockType:(UInt32)stockType;

@end

@implementation tztTrendDetailConfig

+(tztTrendDetailConfig*)getShareInstance
{
    static dispatch_once_t trendconfigOnce;
    static tztTrendDetailConfig *trendConfig;
    dispatch_once(&trendconfigOnce, ^{ trendConfig = [[tztTrendDetailConfig alloc] initWithConfig:@"tztTrendDetailConfig"];
    });
    return trendConfig;
}

-(id)initWithConfig:(NSString *)nsFileName
{
    if ([self init])
    {
        NSMutableDictionary *dictData = GetDictByListName(nsFileName);
        if (_dictMarkets == NULL)
            _dictMarkets = NewObject(NSMutableDictionary);
        [_dictMarkets removeAllObjects];
        for (NSString* nsKey in dictData.allKeys)
        {
            if ([nsKey caseInsensitiveCompare:@"TitleType"] == NSOrderedSame)
            {
               self.nTitleType = [[dictData objectForKey:@"TitleType"] intValue];
                continue;
            }
            
            if ([nsKey caseInsensitiveCompare:@"ToolbarAlways"] == NSOrderedSame)
            {
                self.bToolbarAlways = ([dictData objectForKey:@"ToolbarAlways"] > 0);
                continue;
            }
            
            NSDictionary* content = [dictData objectForKey:nsKey];
            if (content == NULL)
                continue;
            
            tztTrendDetailObj *trendObj = NewObject(tztTrendDetailObj);
            //标题
            //报价
            NSDictionary *dictQuote = [content objectForKey:@"Quotes"];
            CGFloat fQuoteHeight = [[dictQuote objectForKey:@"height"] floatValue];
            NSString* nsUserStock = [dictQuote objectForKey:@"userstock"];
            NSString* nsBlock = [dictQuote objectForKey:@"isblock"];
            NSString* nsExchange = [dictQuote objectForKey:@"isexchange"];
            NSString* nsTradeStock = [dictQuote objectForKey:@"istradestock"];
            NSMutableArray *ayKeys = [dictQuote objectForKey:@"keys"];
            NSMutableArray *ayExchangeKeys = [dictQuote objectForKey:@"exchangekeys"];
            
            trendObj.fQuoteHeight = fQuoteHeight;
            trendObj.bShowUserStock = ([nsUserStock length] > 0 ? ([nsUserStock intValue] > 0) : YES);
            trendObj.bShowBlock = ([nsBlock length] > 0 ? ([nsBlock intValue] > 0) : YES);
            trendObj.bShowExchange = ([nsExchange length] > 0 ? ([nsExchange intValue] > 0) : YES);
            trendObj.bShowTradeStock = ([nsTradeStock intValue] > 0);
            trendObj.ayQuoteKeys = ayKeys;
            trendObj.ayQuoteExchangeKeys = ayExchangeKeys;
            
            //具体显示
            NSArray *ayBody = [content objectForKey:@"detail"];
            for (NSInteger i = 0; i < ayBody.count; i++)
            {
                NSDictionary *dictSection = [ayBody objectAtIndex:i];
                if (dictSection == nil)
                    continue;
                
                tztTrendDetailSectionObj *obj = NewObject(tztTrendDetailSectionObj);
                //
                CGFloat fSectionHeight = [[dictSection objectForKey:@"SectionHeight"] floatValue];
                CGFloat fRowHeight = [[dictSection objectForKey:@"RowHeight"] floatValue];
                CGFloat fXMargin = [[dictSection objectForKey:@"XMargin"] floatValue];
                NSInteger fRowCount = [[dictSection objectForKey:@"RowCount"] intValue];
                obj.fSectionHeight = fSectionHeight;
                obj.fRowHeight = fRowHeight;
                obj.fXMargin = fXMargin;
                obj.fRowCount = fRowCount;
                NSArray *aySection = [dictSection objectForKey:@"Sections"];
                for (NSInteger j = 0; j < aySection.count; j++)
                {
                    NSDictionary *dictObj = [aySection objectAtIndex:j];
                    if (dictObj == nil)
                        continue;
                    
                    tztSectionObj * secObj = NewObject(tztSectionObj);
                    NSString* nsTitle = [dictObj objectForKey:@"Title"];
                    NSString* nsType = [dictObj objectForKey:@"Type"];
                    NSString* nsURL = [dictObj objectForKey:@"URL"];
                    NSString* nsRowHeight = [dictObj objectForKey:@"RowHeight"];
                    NSString* nsRowCount = [dictObj objectForKey:@"RowCount"];
                    
                    secObj.nsTitle = [NSString stringWithFormat:@"%@", nsTitle];
                    secObj.nsType = [NSString stringWithFormat:@"%@", nsType];
                    secObj.nsURL = [NSString stringWithFormat:@"%@", nsURL];
                    if ([nsRowHeight floatValue] <= 0)
                        secObj.fRowHeight = fRowHeight;
                    else
                        secObj.fRowHeight = [nsRowHeight floatValue];
                    
                    if ([nsRowCount intValue] < 1)
                        secObj.fRowCount = fRowCount;
                    else
                        secObj.fRowCount = [nsRowCount intValue];
                    [obj.aySections addObject:secObj];
                    DelObject(secObj);
                }
                [trendObj.aySections addObject:obj];
                DelObject(obj);
            }
            [_dictMarkets setObject:trendObj forKey:nsKey];
        }
    }
    return self;
}

-(void)dealloc
{
    if (_dictMarkets)
    {
        [_dictMarkets removeAllObjects];
        [_dictMarkets release];
    }
    [super dealloc];
}

-(NSString*)GetKeyByStockType:(UInt32)stockType
{
    NSString* nsType = @"";
    
    if (MakeStockMarketStock(stockType))
    {
        nsType = HSTrend;
    }
    else if (MakeHKMarketStock(stockType))
    {
        nsType = HKTrend;
    }
    else if (MakeMarket(stockType) == HQ_WP_MARKET
             && (stockType == 0x5181 || stockType == 0x5110))//指数
    {
        nsType = USTrend;
    }
    else if(MakeUSMarket(stockType) || MakeWPMarket(stockType) || MakeWHMarket(stockType))
    {
        nsType = USTrend;
    }
    else if (MakeIndexMarket(stockType))
    {
        nsType = HSIndexTrend;
    }
    else if ((MakeMainMarket(stockType) == (HQ_HK_MARKET|HQ_INDEX_BOURSE)))
    {
        nsType = HKIndexTrend;
    }
    else
        nsType = @"DefaultTrend";
    return nsType;
}

-(tztTrendDetailObj*)GetSectionDetailByStockType:(UInt32)stockType
{
    NSString* nsType = [self GetKeyByStockType:stockType];
    if (nsType.length > 0)
        return [_dictMarkets objectForKey:nsType];
    
    return nil;
}

-(tztTrendDetailObj*)GetSectionDetail:(NSString*)nsType
{
    return [_dictMarkets objectForKey:nsType];
}

-(tztTrendDetailSectionObj*)GetSectionAtIndex:(NSInteger)nSection andType:(NSString*)nsType
{
    tztTrendDetailObj* obj = [self GetSectionDetail:nsType];
    if (nSection < 0 || nSection >= obj.aySections.count)
        return nil;
    return [obj.aySections objectAtIndex:nSection];
}

-(NSInteger)GetSectionIndexWithObj:(tztTrendDetailSectionObj*)obj andStockType:(UInt32)stockType
{
    if (obj == nil)
        return 0;
    
    NSString* nsType = [self GetKeyByStockType:stockType];
    if (nsType.length <= 0)
        return nil;
    
    tztTrendDetailObj* detailobj = [self GetSectionDetail:nsType];
    
    return [detailobj.aySections indexOfObject:obj];
}

-(tztTrendDetailSectionObj*)GetSectionAtIndex:(NSInteger)nSection andStockType:(UInt32)stockType
{
    NSString* nsType = [self GetKeyByStockType:stockType];
    if (nsType.length <= 0)
        return nil;
        
    tztTrendDetailObj* obj = [self GetSectionDetail:nsType];
    if (nSection < 0 || nSection >= obj.aySections.count)
        return nil;
    return [obj.aySections objectAtIndex:nSection];
}

@end



@interface TZTUserStockDetailTableView()<SWTableViewCellDelegate,tztSegmentViewDelegate,tztHTTPWebViewDelegate,tztBottomOperateViewDelegate>
{
    TZTUIBaseTitleView         *_tztTitleTypeOne;
    TZTUIStockDetailHeaderView *stockDetailHeaderView;
    tztUIStockDetailHeaderViewEx    *stockDetailHeaderViewEx;
    TZTTimeTechView *timeTechView;
    TZTSegSectionView *segSectionView;
    UIView            *infoView;
    UIView            *pViewOther;
    UIView            *pBackView;
    
    BOOL change; // 标题变换标记
    NSInteger  _nCurSegmentIndex;
    
    NSInteger centerCount;
    NSInteger nonCenCount;
    NSInteger nSectionExHeight;
    
    BOOL _bShowBottom;
    int  _nReqAction;
    
    NSInteger  _nTimeTechHeight;
    CGFloat _fPreTradeCCHeight;
    CGFloat _fCurrnetTradeCCHeight;
}

@property(nonatomic, retain)NSMutableArray *dataArray;
 /**
 *	@brief	市场类型
 */
@property (nonatomic,retain) NSMutableArray         *ayStockType;

@property (nonatomic, assign)BOOL     bNOFresh;
@property NSInteger   nTickCount;


 /**
 *	@brief	资金流向
 */
@property (nonatomic,retain)tztTrendFundView  *pFundFlowsView;

 /**
 *	@brief	财务数据
 */
@property (nonatomic,retain)tztFinanceView      *pFinanceView;

@property (nonatomic,retain)tztTrendDetailConfig   *trendDetailConfig;

@property (nonatomic,retain)NSMutableDictionary    *dictViews;

@property (nonatomic,retain)NSString*           strDirection;
@property (nonatomic,retain)NSString*           strAccountIndex;
@property (nonatomic,retain)NSString*           strSectionName;
@property (nonatomic,retain)NSMutableArray      *ayShowCols;
@end

@implementation TZTUserStockDetailTableView

@synthesize dataArray = _dataArray;
@synthesize pTableView = _pTableView;
@synthesize ayStockType = _ayStockType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
        [self initData];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    timeTechView.tztdelegate = nil;
    [self ClearSectionDatas];
    NilObject(stockDetailHeaderView);
    NilObject(stockDetailHeaderViewEx);
    NilObject(timeTechView);
    DelObject(infoView);
    [super dealloc];
}

-(void)ClearSectionDatas
{
    tztTrendDetailObj *obj = [self.trendDetailConfig GetSectionDetailByStockType:self.pStockInfo.stockType];
    if (obj == nil)
        return;
    
    for (NSInteger i = 0; i < obj.aySections.count; i++)
    {
        tztTrendDetailSectionObj *secObj = [obj.aySections objectAtIndex:i];
        if (secObj == nil)
            continue;
        
        secObj.nCurrentIndex = 0;
        [secObj.ayShowViews removeAllObjects];
        secObj.pSegcontrolView = nil;
    }
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    [super onSetViewRequest:bRequest];
    if (timeTechView)
    {
        [timeTechView onSetViewRequest:bRequest];
    }
    
    tztTrendDetailObj * obj = [self.trendDetailConfig GetSectionDetailByStockType:self.pStockInfo.stockType];
    
    for (NSInteger i = 0; i < obj.aySections.count; i++)
    {
        tztTrendDetailSectionObj * secObj = [obj.aySections objectAtIndex:i];
        if (secObj == nil)
            return;
        for (NSInteger j = 0; j < secObj.ayShowViews.count; j++)
        {
            UIView *pView = [secObj.ayShowViews objectAtIndex:j];
            if (secObj.nCurrentIndex == j)
            {
                [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)(bRequest ? YES : NO)];
            }
            else
                [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
        }
    }
}

-(void)ClearData
{
    self.pStockInfo = nil;
    if (timeTechView)
    {
        [timeTechView ClearData];
        [timeTechView onClearData];
    }
    
}

-(void)onClearData
{
    [super onClearData];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
//    self.trendDetailConfig = [tztTrendDetailConfig getShareInstance];
    if (self.trendDetailConfig == nil)
        _trendDetailConfig = [[tztTrendDetailConfig alloc] initWithConfig:@"tztTrendDetailConfig"];
    [super setFrame:frame];
    CGRect rcTitle = self.bounds;
    rcTitle.size.height = TZTToolBarHeight + (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
    
    if (self.trendDetailConfig.nTitleType > 0)
    {
        if (_tztTitleTypeOne == nil)
        {
            _tztTitleTypeOne = [[TZTUIBaseTitleView alloc] initWithFrame:rcTitle];
            _tztTitleTypeOne.pDelegate = self;
            [self addSubview:_tztTitleTypeOne];
            [_tztTitleTypeOne release];
        }
        
        _tztTitleTypeOne.nType = TZTTitleTrendNew;
        _tztTitleTypeOne.frame = rcTitle; //(0,0,320,44)
        _tztTitleTypeOne.firstBtn.hidden = YES;
        _tztTitleTypeOne.fourthBtn.hidden = YES;
    }
    else
    {
        if (_stockDetailTittleView == nil)
        {
            _stockDetailTittleView = [[TZTStockDetailTittleVeiw alloc] initWithFrame:rcTitle];
            [self addSubview:_stockDetailTittleView];
            [_stockDetailTittleView release];
        }
        else
            _stockDetailTittleView.frame = rcTitle;
    }
    
    CGRect rcBottom = self.bounds;
    rcBottom.origin.y = rcBottom.size.height - (TZTToolBarHeight - 5);
    rcBottom.size.height = (TZTToolBarHeight - 5);
    
    if (_bottomOperateView == nil)
    {
        _bottomOperateView = [[TZTBottomOperateView alloc] init];
        _bottomOperateView.frame = rcBottom;
        _bottomOperateView.tztDelegate = self;
        [self addSubview:_bottomOperateView];
        [_bottomOperateView release];
    }
    else
    {
        _bottomOperateView.frame = rcBottom;
    }
    CGRect rcFrame = self.bounds;
    rcFrame.origin.y += rcTitle.size.height;
    rcFrame.size.height -= (rcTitle.size.height + (_bShowBottom ? rcBottom.size.height : 0));
    if (_pTableView == NULL)
    {
        _pTableView = [[UITableView alloc] initWithFrame:rcFrame style:UITableViewStylePlain];
        _pTableView.delegate = self;
        _pTableView.dataSource = self;
        _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pTableView.backgroundColor = [UIColor tztThemeBackgroundColor];
        [self addSubview:_pTableView];
        [_pTableView release];
    }
    else
    {
        _pTableView.frame = rcFrame;
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    _pTableView.backgroundColor = [UIColor tztThemeBackgroundColor];
    stockDetailHeaderView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    stockDetailHeaderViewEx.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
}

- (void)initData
{
    self.backgroundColor = [UIColor clearColor];
    _dataArray = [[NSMutableArray alloc] init];
    _nCurSegmentIndex = -1;
    _bShowBottom = YES;
    _nTimeTechHeight = TimeTechViewHeight;
    self.strAccountIndex = @"0";
    self.strDirection = @"1";
    self.strSectionName = @"Range";
    _ayShowCols = NewObject(NSMutableArray);
    [_ayShowCols addObject:@"Name"];
    [_ayShowCols addObject:@"NewPrice"];
    [_ayShowCols addObject:@"Range"];
}

- (void)more:(id)sender
{
    
}

#pragma 分时数据收到返回，调用更新数据
-(void)UpdateData:(id)obj
{
    if(obj)
    {
        TZTTimeTechView *ttView = (TZTTimeTechView *)obj;
        TNewPriceData *pData = [ttView GetNewPriceData];
        
        if (pData)
        {
            [TZTPriceData setStockDic:[self dealNewPriceData:pData]];
            [stockDetailHeaderView updateContent];
            [stockDetailHeaderViewEx updateContent];
            self.stockDetailTittleView.pStockInfo = self.pStockInfo;
            [self.stockDetailTittleView updateContent];
            self.bottomOperateView.pStockInfo = self.pStockInfo;
        }
    }
    
    tztTrendDetailObj * detailobj = [self.trendDetailConfig GetSectionDetailByStockType:self.pStockInfo.stockType];
    
    for (NSInteger i = 0; i < detailobj.aySections.count; i++)
    {
        tztTrendDetailSectionObj * secObj = [detailobj.aySections objectAtIndex:i];
        if (secObj == nil)
            return;
        for (NSInteger j = 0; j < secObj.ayShowViews.count; j++)
        {
            UIView *pView = [secObj.ayShowViews objectAtIndex:j];
            if (secObj.nCurrentIndex == j)
            {
                [pView tztperformSelector:@"UpdateData:" withObject:obj];
            }
        }
    }
    
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(UpdateData:)])
    {
        [_tztdelegate UpdateData:obj];
    }
}

-(void)reFrame
{
    if (self.trendDetailConfig.bToolbarAlways)
        return;
    if (CGRectIsEmpty(self.frame) || CGRectIsNull(self.frame))
        return;
    BOOL bGG = MakeStockMarketStock(self.pStockInfo.stockType);
    CGRect rcFrame = self.pTableView.frame;
    if (bGG)
    {
        if (!_bShowBottom)
        {
            rcFrame.size.height -= 44;
            [_pTableView reloadData];
            self.pTableView.frame = rcFrame;
        }
        _bShowBottom = YES;
    }
    else
    {
        if (_bShowBottom)
        {
            rcFrame.size.height += 44;
        }
        _bShowBottom = NO;
    }
    
    [_pTableView reloadData];
    self.pTableView.frame = rcFrame;
    [segSectionView setCurrentSelect:0];
    _nCurSegmentIndex = 0;
}

-(void)SetDefaultSelect
{
    if (timeTechView)
    {
        [timeTechView setSegment:0];
    }
    [segSectionView setCurrentSelect:0];
    _nCurSegmentIndex = 0;
}

-(void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    int nStockType = self.pStockInfo.stockType;
    [_pStockInfo release];
    _pStockInfo = [pStockInfo retain];
    
    if (nStockType != self.pStockInfo.stockType)
    {
        tztTrendDetailObj * obj = [self.trendDetailConfig GetSectionDetailByStockType:nStockType];
        
        for (NSInteger i = 0; i < obj.aySections.count; i++)
        {
            tztTrendDetailSectionObj * secObj = [obj.aySections objectAtIndex:i];
            if (secObj == nil)
                return;
            for (NSInteger j = 0; j < secObj.ayShowViews.count; j++)
            {
                UIView *pView = [secObj.ayShowViews objectAtIndex:j];
                [pView removeFromSuperview];
            }
            [secObj.ayShowViews removeAllObjects];
        }
    }
 
    _fPreTradeCCHeight = _fCurrnetTradeCCHeight;
    if ([tztJYLoginInfo IsTradeStockInfo:self.pStockInfo])
        _fCurrnetTradeCCHeight = 30;
    else
        _fCurrnetTradeCCHeight = 0;
    
    if (_stockDetailTittleView)
        _stockDetailTittleView.pStockInfo = _pStockInfo;
    if (_tztTitleTypeOne)
    {
        [_tztTitleTypeOne setCurrentStockInfo:_pStockInfo.stockCode nsName_:_pStockInfo.stockName];
        _tztTitleTypeOne.firstBtn.hidden = YES;
        _tztTitleTypeOne.fourthBtn.hidden = YES;
    }
    if (_bottomOperateView)
        _bottomOperateView.pStockInfo = _pStockInfo;
    
#ifndef tzt_ZSSC
    if (MakeHKMarketStock(self.pStockInfo.stockType))
    {
        _nTimeTechHeight = 20 * 15 + 60;
    }
    else
#endif
        _nTimeTechHeight = TimeTechViewHeight;
    
    
    [self reFrame];
    
    if (timeTechView)
    {
        timeTechView.pStockInfo = pStockInfo;
    }
    if (stockDetailHeaderView)
    {
        if (stockDetailHeaderView.bExpand)
            [self tztDetailHeader:nil OnTapClicked:NO];
        [stockDetailHeaderView setStockInfo:pStockInfo Request:0];
    }
    
    if (stockDetailHeaderViewEx)
    {
        [stockDetailHeaderViewEx setStockInfo:pStockInfo Request:0];
    }
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    [super setStockInfo:pStockInfo Request:nRequest];
    
    [self reFrame];
    if (stockDetailHeaderView)
    {
        if (stockDetailHeaderView.bExpand)
            [self tztDetailHeader:nil OnTapClicked:NO];
        [stockDetailHeaderView setStockInfo:pStockInfo Request:nRequest];
    }
    
    if (stockDetailHeaderViewEx)
    {
        tztTrendDetailObj* obj = [self.trendDetailConfig GetSectionDetailByStockType:self.pStockInfo.stockType];
        [stockDetailHeaderViewEx setShowKeys:obj.ayQuoteKeys andExchangeKeys:obj.ayQuoteExchangeKeys];
        [stockDetailHeaderViewEx setStockInfo:pStockInfo Request:nRequest];
    }
    
    [_stockDetailTittleView SetDefaultState];
    if (timeTechView)
    {
        [timeTechView setStockInfo:pStockInfo Request:nRequest];
    }
    
#ifndef tzt_ZSSC
    if (MakeHKMarketStock(self.pStockInfo.stockType))
    {
        _nTimeTechHeight = 20 * 15 + 60;
    }
    else
#endif
        _nTimeTechHeight = TimeTechViewHeight;
    
    if (timeTechView)
    {
        CGRect rcTime =  timeTechView.frame;
        rcTime.size.height = _nTimeTechHeight + 5;
        timeTechView.frame = rcTime;
    }
    [self.pTableView setContentOffset:CGPointMake(0, 0)];
    //判断市场类型，如果是个股，显示个股资讯栏目；若是指数，则显示涨幅、跌幅、换手前10行情列表
    [self.pTableView reloadData];
    
    self.bottomOperateView.pStockInfo = self.pStockInfo;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tztTrendDetailSectionObj *obj = [self.trendDetailConfig GetSectionAtIndex:indexPath.section-1 andStockType:self.pStockInfo.stockType];
    if (obj)
    {
        NSInteger nIndex = obj.nCurrentIndex;
        tztSectionObj *objSec = [obj.aySections objectAtIndex:nIndex];
        if (objSec)
        {
            return objSec.fRowHeight;
        }
        return obj.fRowHeight;
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        tztTrendDetailObj* obj = [self.trendDetailConfig GetSectionDetailByStockType:self.pStockInfo.stockType];
        return obj.fQuoteHeight + _nTimeTechHeight + nSectionExHeight + _fCurrnetTradeCCHeight;
    }
    else
    {
        tztTrendDetailSectionObj *obj = [self.trendDetailConfig GetSectionAtIndex:section-1 andStockType:self.pStockInfo.stockType];
        if (obj)
        {
            return obj.fSectionHeight;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *groupHeaderView = nil;
    CGRect sectionRect= CGRectMake(0, 0, self.bounds.size.width, tableView.sectionHeaderHeight );
    if (section == 0)//分时、k线，//分时图及顶部的报价目前固定在section＝0位置
    {
        CGRect rcFrame = sectionRect;
        tztTrendDetailObj* obj = [self.trendDetailConfig GetSectionDetailByStockType:self.pStockInfo.stockType];
        rcFrame.size.height = obj.fQuoteHeight+_nTimeTechHeight;
        if (pBackView == nil)
        {
            pBackView = [[UIView alloc] initWithFrame:rcFrame];
        }
        
        CGRect rcHeader = rcFrame;
        rcHeader.size.height = obj.fQuoteHeight;
        CGRect rcTime = rcFrame;
#ifndef tzt_ZSSC
        rcHeader.size.height = 104;
        if (stockDetailHeaderView == nil)//报价信息
        {
            stockDetailHeaderView = [[TZTUIStockDetailHeaderView alloc] initWithFrame:rcHeader];
            stockDetailHeaderView.tztdelegate = self;
            [stockDetailHeaderView setStockInfo:self.pStockInfo Request:0];
            stockDetailHeaderView.clipsToBounds = YES;
            [pBackView addSubview:stockDetailHeaderView];
            [stockDetailHeaderView release];
        }
        rcTime.origin.y += rcHeader.size.height - 5;
        rcTime.size.height -= (rcHeader.size.height - 5);
#else
        CGFloat fHeight = 0;
        if ([tztJYLoginInfo IsTradeStockInfo:self.pStockInfo])
        {
            fHeight += 30;
        }
        rcHeader.size.height += fHeight;
        rcHeader.size.height -= 10;
        if (stockDetailHeaderViewEx == nil)
        {
            stockDetailHeaderViewEx = [[tztUIStockDetailHeaderViewEx alloc] initWithFrame:rcHeader];
            stockDetailHeaderViewEx.tztdelegate = self;
            [stockDetailHeaderViewEx setShowKeys:obj.ayQuoteKeys andExchangeKeys:obj.ayQuoteExchangeKeys];
            [stockDetailHeaderViewEx setStockInfo:self.pStockInfo Request:0];
//            stockDetailHeaderViewEx.clipsToBounds = YES;
            [pBackView addSubview:stockDetailHeaderViewEx];
            [stockDetailHeaderViewEx release];
        }
        else
            stockDetailHeaderViewEx.frame = rcHeader;
        rcTime.origin.y += rcHeader.size.height - 10;
        rcTime.size.height -= (rcHeader.size.height-10-fHeight);
#endif
        
        if (timeTechView == nil)
        {
            timeTechView = [[TZTTimeTechView alloc] initWithFrame:rcTime];
            timeTechView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
            timeTechView.tztdelegate = self;
            if (g_bUseHQAutoPush)
                timeTechView.bAutoPush = YES;
            
            [timeTechView setStockInfo:self.pStockInfo Request:_bRequest];
            [pBackView addSubview:timeTechView];
            [timeTechView release];
        }
        else
        {
#ifdef tzt_ZSSC
            timeTechView.frame = rcTime;
#endif
        }
//        [pBackView bringSubviewToFront:stockDetailHeaderViewEx];
        [pBackView bringSubviewToFront:stockDetailHeaderView];
        groupHeaderView = pBackView;
        
    }
    else//根据配置来进行处理
    {
        tztTrendDetailSectionObj *detailSecObj = [self.trendDetailConfig GetSectionAtIndex:section-1 andStockType:self.pStockInfo.stockType];
        CGFloat fHeight = SegSectionHeight;
        fHeight = detailSecObj.fSectionHeight;
        
        CGRect rcFrame = CGRectMake(0, 0, self.bounds.size.width, fHeight);
        UIView *pInfoView = nil;
        if (pInfoView == NULL)
        {
            pInfoView = [[UIView alloc] initWithFrame:rcFrame];
            pInfoView.tag = 0x12345;
        }
        pInfoView.frame = rcFrame;
        pInfoView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        
        if (detailSecObj)
        {
            NSMutableArray *ayTitle = NewObject(NSMutableArray);
            for (NSInteger i = 0; i < detailSecObj.aySections.count; i++)
            {
                tztSectionObj* objSec = [detailSecObj.aySections objectAtIndex:i];
                if (objSec == NULL || objSec.nsTitle == nil)
                    continue;
                
                [ayTitle addObject:objSec.nsTitle];
            }
            if (detailSecObj.pSegcontrolView == nil)
            {
                detailSecObj.pSegcontrolView = [[TZTSegSectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, SegSectionHeight) andItems:ayTitle andDelegate:self];
                if (detailSecObj.fXMargin > 0)
                {
                    detailSecObj.pSegcontrolView.frame = CGRectInset(segSectionView.frame, detailSecObj.fXMargin, 0);
                }
                detailSecObj.pSegcontrolView.frame = CGRectInset(segSectionView.frame, 50, 10);
                detailSecObj.pSegcontrolView.tag = 0x1234+section;
            }
        }
        else
        {
            if (detailSecObj.pSegcontrolView == nil)
            {
                detailSecObj.pSegcontrolView = [[TZTSegSectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, SegSectionHeight) andItems:@[@"新闻", @"公告", @"研报"] andDelegate:self];
                detailSecObj.pSegcontrolView.tag = 0x1234+section;
            }
        }
        groupHeaderView = detailSecObj.pSegcontrolView;
    }
    return groupHeaderView;
}

-(void)tztSegmentView:(id)segView didSelectAtIndex:(NSInteger)nIndex
{
    //根据tag获取是哪个，然后根据市场读取配置中的属性
    TZTSegSectionView *view = (TZTSegSectionView*)segView;
    NSInteger nTag = view.tag - 0x1234;//得到是哪个section
    tztTrendDetailSectionObj *obj = [self.trendDetailConfig GetSectionAtIndex:nTag-1 andStockType:self.pStockInfo.stockType];
    
    if (nIndex < 0 || nIndex >= obj.aySections.count)
        return;
    obj.nCurrentIndex = nIndex;
    
    
    [self RequestInfo:obj bScroll:TRUE frame_:CGRectNull contentView:nil];
}

- (NSMutableDictionary *)dealNewPriceData:(TNewPriceData *)pNewPriceData
{
    NSMutableDictionary *pReturnDict = [NSMutableDictionary dictionary];
    
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
    
    //根据类型进行解析
    if (MakeIndexMarket(timeTechView.pStockInfo.stockType))//指数
    {
        [TZTPriceData dealWithIndexPrice:pNewPriceData pDict_:pReturnDict];
    }
    else if(MakeStockMarket(timeTechView.pStockInfo.stockType)
            || MakeUSMarket(timeTechView.pStockInfo.stockType))//个股
    {
        [TZTPriceData dealWithStockPrice:pNewPriceData andType_:timeTechView.pStockInfo.stockType pDict_:pReturnDict];
    }
    else if (MakeHKMarket(timeTechView.pStockInfo.stockType))//港股
    {
        [TZTPriceData dealWithHKStockPrice:pNewPriceData andUnit_:1000 pDict_:pReturnDict];
    }
    else if (MakeWPMarket(timeTechView.pStockInfo.stockType))//外盘
    {
        
        if ((self.pStockInfo.stockType == WP_INDEX)
            || (MakeMidMarket(self.pStockInfo.stockType) == HQ_WP_INDEX)
            )
        {
            [TZTPriceData dealwithWPStockPrice:pNewPriceData pDict_:pReturnDict];
        }
        else
        {
            [TZTPriceData dealWithQHStockPrice:pNewPriceData andHand_:10000 pDict_:pReturnDict];
        }
        
    }
    else if (MakeWHMarket(timeTechView.pStockInfo.stockType))//外汇
    {
        
    }
    else if (MakeQHMarket(timeTechView.pStockInfo.stockType))//期货
    {
        //板块指数
        if (MakeMainMarket(self.pStockInfo.stockType) == (HQ_FUTURES_MARKET|HQ_SELF_BOURSE|0x0060))
        {
            [TZTPriceData DealWithBlockIndexPice:pNewPriceData pDict_:pReturnDict];
//            [self onDrawStockPrice:context];
        }
        else//期货
        {
            [TZTPriceData dealWithQHStockPrice:pNewPriceData andHand_:100 pDict_:pReturnDict];
        }
    }
    return pReturnDict;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //判断类型
    NSInteger n  = 2;
    if (MakeStockMarketStock(self.pStockInfo.stockType))
    {
        n = [self.trendDetailConfig GetSectionDetail:HSTrend].aySections.count;
    }
    else if (MakeHKMarketStock(self.pStockInfo.stockType))
    {
        n = [self.trendDetailConfig GetSectionDetail:HKTrend].aySections.count;
    }
    else if (MakeMarket(self.pStockInfo.stockType) == HQ_WP_MARKET
             && self.pStockInfo.stockType == 0x5181)//指数
    {
        n = 0;//只有分时
    }
    else if(MakeUSMarket(self.pStockInfo.stockType))
    {
        n = [self.trendDetailConfig GetSectionDetail:USTrend].aySections.count;
    }
    else if (MakeIndexMarket(self.pStockInfo.stockType))
    {
        n = [self.trendDetailConfig GetSectionDetail:HSIndexTrend].aySections.count;
    }
    else if ((MakeMainMarket(self.pStockInfo.stockType) == (HQ_HK_MARKET|HQ_INDEX_BOURSE)))
    {
        n = [self.trendDetailConfig GetSectionDetail:HKIndexTrend].aySections.count;
    }
    else
        return 1;
    return n + 1;//＋1是因为目前的配置中，没有把第0个的分时报价算在里面
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 0;
    tztTrendDetailSectionObj *obj = [self.trendDetailConfig GetSectionAtIndex:section-1 andStockType:self.pStockInfo.stockType];
    if (obj)
    {
        
        NSInteger nIndex = obj.nCurrentIndex;
        tztSectionObj *objSec = [obj.aySections objectAtIndex:nIndex];
        if (objSec)
        {
            return objSec.fRowCount;
        }
    }
    return 0;
}

-(BOOL)IsIndexMarket
{
    BOOL bIndex = MakeIndexMarket(self.pStockInfo.stockType);
    //增加港股指数判断
    NSString* strStockCode = self.pStockInfo.stockCode;
    int nType = self.pStockInfo.stockType;
    
    //属于港股指数，并且是恒生指数｜恒生国企指数｜恒生红筹指数
    if (MakeMainMarket(nType) == (HQ_HK_MARKET|HQ_INDEX_BOURSE))
    {
        strStockCode = [strStockCode stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([strStockCode caseInsensitiveCompare:@"HSI"] == NSOrderedSame
            || [strStockCode caseInsensitiveCompare:@"HSCEI"] == NSOrderedSame
            || [strStockCode caseInsensitiveCompare:@"HSCCI"] == NSOrderedSame)
        {
            bIndex = YES;
        }
    }
    return bIndex;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"cellId%ld%ld", (long)indexPath.section, (long)indexPath.row ];
    
    tztTrendDetailSectionObj *obj = [self.trendDetailConfig GetSectionAtIndex:indexPath.section-1 andStockType:self.pStockInfo.stockType];
    
    NSInteger nCurrent = obj.nCurrentIndex;
    if (nCurrent >= 0 && nCurrent < obj.aySections.count)
    {
        tztSectionObj *secObj = [obj.aySections objectAtIndex:nCurrent];
        if ([secObj.nsType caseInsensitiveCompare:@"tztReport"] == NSOrderedSame)
        {
            identify = [NSString stringWithFormat:@"%@_index", identify];
            TZTUserStockTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (cell == nil)
            {
                NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc] init];
                [rightUtilityButtons addUtilityButtonWithColor:[UIColor clearColor]
                                                          icon:@"TZTCellBuy"];
                [rightUtilityButtons addUtilityButtonWithColor:[UIColor clearColor]
                                                          icon:@"TZTCellSell"];
                // 根据配置 是否显示预警
                if ([[g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_SupportWarning] intValue] > 0)
                {
                    [rightUtilityButtons addUtilityButtonWithColor:[UIColor clearColor]
                                                              icon:@"TZTCellWarning"];
                }
                
                BOOL bUseSep = ([[g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_HQTableUseGrid] intValue] > 0);
                cell = [[[TZTUserStockTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                         reuseIdentifier:identify
                                                     containingTableView:tableView // Used for row height and selection
                                                      leftUtilityButtons:nil
                                                     rightUtilityButtons:rightUtilityButtons
                                                              ayColKeys_:self.ayShowCols
                                                                bUseSep_:bUseSep] autorelease];
                ((TZTUserStockTableViewCell *)cell).delegate = self;
                [rightUtilityButtons release];
            }
            ((TZTUserStockTableViewCell*)cell).nsSection = self.strSectionName;
            [((TZTUserStockTableViewCell*)cell) setShowColKeys:self.ayShowCols];
            if ([self.dataArray count] > indexPath.row)
            {
                [(TZTUserStockTableViewCell*)cell setContent:[self.dataArray objectAtIndex:indexPath.row]];
            }
            else
            {
                [(TZTUserStockTableViewCell*)cell setContent:NULL];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    CGRect rc = cell.bounds;
    rc.size.height = obj.fRowHeight;
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        rc.size.width = self.pTableView.frame.size.width;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    cell.contentView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    [self RequestInfo:obj bScroll:FALSE frame_:rc contentView:cell.contentView];
    
    cell.backgroundColor = [UIColor tztThemeBackgroundColorZX];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self IsIndexMarket])
    {
        if ([self.dataArray count] <= indexPath.row || [self.ayStockType count] <= indexPath.row)
            return;
        
        NSDictionary *pDict = [self.dataArray objectAtIndex:indexPath.row];
        NSArray     *stockTypeArr = self.ayStockType;
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockName = [[pDict tztObjectForKey:@"Name"] objectForKey:@"value"];
        pStock.stockCode = [[pDict tztObjectForKey:@"Code"] objectForKey:@"value"];
        
        if (stockTypeArr && indexPath.row < [stockTypeArr count])
        {
            NSString* strType = [stockTypeArr objectAtIndex:indexPath.row];
            if (strType && [strType length] > 0)
            {
                pStock.stockType = [strType intValue];
            }
        }
        [TZTUIBaseVCMsg OnMsg:MENU_HQ_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)self.dataArray];
    }
}


-(void)OnBottomOperateButtonClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return;
    switch (pBtn.tag)
    {
        case TZT_MENU_AddUserStock:
        {
            if ([tztUserStock IndexUserStock:_pStockInfo] < 0)
            {
                [tztUserStock AddUserStock:self.pStockInfo];
                UIImageView *imageView = (UIImageView*)[pBtn viewWithTag:0x9999];
                [imageView setImage:[UIImage imageTztNamed:@"tztQuickDel.png"]];
            }
            else
            {
                [tztUserStock DelUserStock:self.pStockInfo];
                UIImageView *imageView = (UIImageView*)[pBtn viewWithTag:0x9999];
                [imageView setImage:[UIImage imageTztNamed:@"tztQuickAdd.png"]];
            }
        }
            break;
        case MENU_JY_PT_Buy://买入
        case MENU_JY_PT_Sell://卖出
        case MENU_SYS_UserWarning://预警
        case MENU_JY_RZRQ_PTBuy:
        case MENU_JY_RZRQ_PTSell:
        {
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:(NSUInteger)self.pStockInfo lParam:0];
        }
            break;
        default:
        {
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:0 lParam:0];
        }
            break;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL hide;
    if (_pTableView.contentOffset.y < 80) {
        hide = NO;
        
    }
    else
    {
        hide = YES;
        
    }
    
    if (hide && change == NO)
    {
        [_stockDetailTittleView updateUserStockTitle:YES];
        change = YES;
    }
    else if (hide == NO && change == YES)
    {
        [_stockDetailTittleView updateUserStockTitle:NO];
        change = NO;
    }
}

#pragma mark 个股资讯对应界面操作

-(void)RequestInfo:(tztTrendDetailSectionObj*)obj bScroll:(BOOL)bScroll frame_:(CGRect)rcFrame contentView:(UIView*)pContentView
{
    NSInteger nIndex = obj.nCurrentIndex;
    if (nIndex < 0 || nIndex >= obj.aySections.count)
        nIndex = 0;
    
    rcFrame = CGRectInset(rcFrame, obj.fXMargin, 0);
    //根据index获取对应的数组数据
    tztSectionObj *sectionObj = [obj.aySections objectAtIndex:nIndex];
    UIView *pView = NULL;
    if (nIndex >= 0 && nIndex < obj.ayShowViews.count)
        pView = [obj.ayShowViews objectAtIndex:nIndex];
    CGFloat fHeight = sectionObj.fRowHeight;
    if ([sectionObj.nsType caseInsensitiveCompare:@"tztWebInfo"] == NSOrderedSame)//网页
    {
        NSString* nsURL = sectionObj.nsURL;
        NSString* strURL = [NSString stringWithFormat:nsURL, self.pStockInfo.stockCode];
        if (pView == nil && pContentView != nil)
        {
            rcFrame.size.height = sectionObj.fRowHeight;
            tztWebView *pWebView = [[tztWebView alloc] initWithFrame:rcFrame];
            pWebView.tztDelegate = self;
            pWebView.bblackground = (g_nSkinType == 0);
            [pWebView setWebURL:[tztlocalHTTPServer getLocalHttpUrl:strURL]];
            [pContentView addSubview:pWebView];
            pView = pWebView;
            ((tztWebView*)pView).pStockInfo = self.pStockInfo;
            [obj.ayShowViews addObject:pView];
            [pWebView release];
            
        }
        else
        {
            if (((tztWebView*)pView).pStockInfo == NULL
                || [self.pStockInfo.stockCode caseInsensitiveCompare:((tztWebView*)pView).pStockInfo.stockCode] != NSOrderedSame)
            {
                [((tztWebView*)pView) stopLoad];
                [((tztWebView*)pView) closeAllHTTPWebView];
                ((tztWebView*)pView).bblackground = (g_nSkinType == 0);
                [((tztWebView*)pView) setWebURL:[tztlocalHTTPServer getLocalHttpUrl:strURL]];
            }
            fHeight = [((tztWebView*)pView) getCurWebView].scrollView.contentSize.height;
            [((tztWebView*)pView) scrollToTop];
            [pContentView bringSubviewToFront:((tztWebView*)pView)];
            
            ((tztWebView*)pView).pStockInfo = self.pStockInfo;
        }
    }
    else if ([sectionObj.nsType caseInsensitiveCompare:@"tztReport"] == NSOrderedSame)//指数排名列表
    {
        //请求的数据
        NSString* nsURL = sectionObj.nsURL;
        //分解
        NSMutableDictionary *dict = [nsURL tztNSMutableDictionarySeparatedByString:@"&"];
        NSString* strAction = [dict tztObjectForKey:@"action"];
        if (ISNSStringValid(strAction))
            _nReqAction = [strAction intValue];
        
        NSString* nsDirection = [dict tztObjectForKey:@"direction"];
        if (ISNSStringValid(nsDirection))
            self.strDirection = [NSString stringWithFormat:@"%@", nsDirection];
        
        NSString* nsAccountIndex = [dict tztObjectForKey:@"accountindex"];
        if (ISNSStringValid(nsAccountIndex))
            self.strAccountIndex = [NSString stringWithFormat:@"%@", nsAccountIndex];
        
        NSString* nsSection = [dict tztObjectForKey:@"sectionname"];
        if (ISNSStringValid(nsSection))
            self.strSectionName = [NSString stringWithFormat:@"%@", nsSection];
        
        NSString* nsShowCols = [dict tztObjectForKey:@"showcols"];
        if (ISNSStringValid(nsShowCols))
        {
            NSArray *ay = [nsShowCols componentsSeparatedByString:@"|"];
            if (ay.count > 0)
                [_ayShowCols removeAllObjects];
            for (NSInteger i = 0; i < ay.count; i++)
            {
                [_ayShowCols addObject:[ay objectAtIndex:i]];
            }
        }
        else//使用默认
        {
            [_ayShowCols removeAllObjects];
            [_ayShowCols addObject:@"Name"];
            [_ayShowCols addObject:@"NewPrice"];
            [_ayShowCols addObject:@"Range"];
        }
        
        [self onRequestData:YES];
    }
    else if ([sectionObj.nsType caseInsensitiveCompare:@"tztFundFlow"] == NSOrderedSame
             || [sectionObj.nsType caseInsensitiveCompare:@"tzthqview"] == NSOrderedSame)
    {
        //对应具体类名
        NSString *nsURL = sectionObj.nsURL;

        if (pView == nil && pContentView != nil)
        {
            rcFrame.size.height = sectionObj.fRowHeight;
            
            pView = [[NSClassFromString(nsURL) alloc] init];
            pView.frame = rcFrame;
            if ([pView isKindOfClass:[tztHqBaseView class]])
            {
                if (g_bUseHQAutoPush)
                    ((tztHqBaseView*)pView).bAutoPush = YES;
            }
            
            [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)YES];
            [pView tztperformSelector:@"setStockInfo:Request:" withObject:self.pStockInfo withObject:(id)YES];
            [pContentView addSubview:pView];
            [obj.ayShowViews addObject:pView];
            [pView release];
            
        }
        else
        {
            if ([pView isKindOfClass:[tztHqBaseView class]])
            {
                if ([self.pStockInfo.stockCode caseInsensitiveCompare:((tztHqBaseView*)pView).pStockInfo.stockCode] != NSOrderedSame)
                {
                    [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)YES];
                    [pView tztperformSelector:@"setStockInfo:Request:" withObject:self.pStockInfo withObject:(id)YES];
                }
            }
            [pContentView bringSubviewToFront:pView];
            pView.frame = rcFrame;
        }
    }
    if (fHeight != obj.fRowHeight)
    {
        obj.fRowHeight = fHeight;
        [self.pTableView reloadData];
    }
    
    for (UIView *subView in obj.ayShowViews)
    {
        subView.hidden = (pView != subView);
        if ([subView isKindOfClass:NSClassFromString(@"tztHqBaseView")])
        {
            [subView tztperformSelector:@"onSetViewRequest:" withObject:(id)(!subView.hidden)];
        }
    }
    
    //需要滚动
    if (bScroll)
    {
        NSInteger nSection = [self.trendDetailConfig GetSectionIndexWithObj:obj andStockType:self.pStockInfo.stockType];
        
        
        tztTrendDetailObj* terndobj = [self.trendDetailConfig GetSectionDetailByStockType:self.pStockInfo.stockType];
        int nHeight = terndobj.fQuoteHeight;
        CGFloat fLastheight = _nTimeTechHeight / 2;
        if (nSection <= 0)
            nHeight += (_nTimeTechHeight / 2);
        else
        {
            nHeight += _nTimeTechHeight;
            for (NSInteger i = 0; i < nSection; i++)
            {
                tztTrendDetailSectionObj *sub = [self.trendDetailConfig GetSectionAtIndex:i andStockType:self.pStockInfo.stockType];
                
                if (sub == nil)
                    continue;
                
                NSInteger segIndex = sub.nCurrentIndex;
                if (segIndex < 0 || segIndex >= sub.aySections.count)
                    segIndex = 0;
                tztSectionObj *obj = [sub.aySections objectAtIndex:segIndex];
                if (i == nSection - 1)
                {
                    nHeight += obj.fRowHeight / 2 + sub.fSectionHeight;
                    fLastheight = obj.fRowHeight / 2;
                }
                else
                {
                    nHeight += obj.fRowHeight + sub.fSectionHeight;
                }
            }
        }
        
        CGPoint ptOffset = self.pTableView.contentOffset;
        if (ptOffset.y < nHeight)
            [self.pTableView setContentOffset:CGPointMake(0, nHeight) animated:YES];
        else if(ptOffset.y > nHeight + fLastheight)
            [self.pTableView setContentOffset:CGPointMake(0, nHeight + fLastheight) animated:YES];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:nSection+1];
//        [self.pTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


-(void)tztWebViewDidFinishLoad:(tztHTTPWebView *)webView fail:(BOOL)bfail
{
    NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
    [pDict setObject:webView forKey:@"webView"];
    [NSTimer scheduledTimerWithTimeInterval:0.8f
                                     target:self
                                   selector:@selector(OnReload:)
                                   userInfo:pDict
                                    repeats:NO];
}

-(void)OnReload:(id)sender
{
    NSDictionary *pDict = [sender userInfo];
    if (pDict == NULL)
        return;
    
    
    tztWebView *pWeb = [pDict objectForKey:@"webView"];
    if (pWeb == NULL)
        return;
    
    UIWebView *web = [pWeb getCurWebView];
    [web sizeToFit];
    CGSize sz = web.scrollView.contentSize;
    BOOL bNeedRefresh = FALSE;
    
    tztTrendDetailObj *obj = [self.trendDetailConfig GetSectionDetailByStockType:self.pStockInfo.stockType];
    for (NSInteger i = 0; i < obj.aySections.count; i++)
    {
        tztTrendDetailSectionObj *secObj = [obj.aySections objectAtIndex:i];
        if (secObj == nil)
            continue;
        
        for (NSInteger k = 0; k < secObj.ayShowViews.count; k++)
        {
            UIView *pView = [secObj.ayShowViews objectAtIndex:k];
            if (pWeb == pView)
            {
                if (secObj.fRowHeight != sz.height)
                {
                    tztSectionObj *sectionObj = [secObj.aySections objectAtIndex:k];
                    sectionObj.fRowHeight = sz.height;
                    bNeedRefresh = TRUE;
//                    secObj.fRowHeight = sz.height;
                    break;
                }
            }
        }
    }
    
    if (bNeedRefresh)
        [self.pTableView reloadData];
}

-(void)tzthqViewNeedsDisplay:(id)hqview
{
//    if (hqview == _pFinanceView && !_pFinanceView.hidden)
//    {
//        _nSectionTwoHeight = MAX([_pFinanceView GetFinaceViewHeight], tztFinaceHeight);
//        [self.pTableView reloadData];
//    }
}

-(void)onRequestDataAutoPush
{
    if (!_bRequest)
        return;
    [timeTechView onRequestDataAutoPush];
    [self.pFundFlowsView onRequestDataAutoPush];
}

-(void)onRequestData:(BOOL)bShowProcess
{
    if (!_bRequest || timeTechView.isHorizon)//横屏显示时，无须请求排名数据
        return;
    if (![self IsIndexMarket])
        return;
    if (_bRequest)
    {
        
        NSString* strStockCode = self.pStockInfo.stockCode;
        int nType = self.pStockInfo.stockType;
        
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        if (_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 0;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [pDict setTztObject:strReqno forKey:@"Reqno"];
        if (self.strDirection)
            [pDict setTztObject:self.strDirection forKey:@"Direction"];
        if (self.strAccountIndex)
            [pDict setTztObject:self.strAccountIndex forKey:@"AccountIndex"];
        [pDict setTztObject:@"0" forKey:@"DeviceType"];
        [pDict setTztObject:@"1" forKey:@"StartPos"];
        [pDict setTztObject:@"1" forKey:@"StockIndex"];
        [pDict setTztObject:@"0" forKey:@"NewMarketNo"];
        [pDict setTztObject:@"30" forKey:@"MaxCount"];
        
        if (MakeMainMarket(nType) == (HQ_HK_MARKET|HQ_INDEX_BOURSE))
        {
            strStockCode = [strStockCode stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSMutableDictionary *pMarketDict = NULL;
            NSString *strMarket = @"";
            if ([strStockCode caseInsensitiveCompare:@"HSI"] == NSOrderedSame)
            {
                if (g_pReportMarket)
                    pMarketDict = [g_pReportMarket GetSubMenuById:nil nsID_:@"608"];
                if (pMarketDict == NULL)
                    strMarket = @"恒指成份";
            }
            else if([strStockCode caseInsensitiveCompare:@"HSCEI"] == NSOrderedSame)
            {
                if (g_pReportMarket)
                    pMarketDict = [g_pReportMarket GetSubMenuById:nil nsID_:@"602"];
                if (pMarketDict == NULL)
                    strMarket = @"国企股";
            }
            else if([strStockCode caseInsensitiveCompare:@"HSCCI"] == NSOrderedSame)
            {
                if (g_pReportMarket)
                    pMarketDict = [g_pReportMarket GetSubMenuById:nil nsID_:@"603"];
                if (pMarketDict == NULL)
                    strMarket = @"红筹股";
            }
            if (pMarketDict && pMarketDict.count > 0)
            {
                NSString* strData = [pMarketDict objectForKey:@"MenuData"];
                if (ISNSStringValid(strData))
                {
                    NSArray *ayMarket = [strData componentsSeparatedByString:@"|"];
                    if (ayMarket.count > 3)
                    {
                        NSString* strParam = [ayMarket objectAtIndex:3];
                        NSArray *pAyParam = [strParam componentsSeparatedByString:@"#"];
                        if ([pAyParam count] > 1)
                        {
                            strMarket = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:0]];
                        }
                    }
                }
            }
            
            if (_nReqAction <= 0)
                _nReqAction = 20192;
            [pDict setTztObject:strMarket forKey:@"StockCode"];
        }
        else
        {
            if (MakeMainMarket(nType) == (HQ_STOCK_MARKET|HQ_SZ_BOURSE))//深证指数
            {
                if ([self.pStockInfo.stockCode caseInsensitiveCompare:@"399006"] == NSOrderedSame)
                {
                    [pDict setTztObject:@"120B" forKey:@"StockCode"];
                }
                else
                {
                    [pDict setTztObject:@"1201,1206" forKey:@"StockCode"];
                }
            }
            else/* if (MakeMainMarket(nType) == (HQ_STOCK_MARKET|HQ_SH_BOURSE))*///上证指数
            {
                [pDict setTztObject:@"1101" forKey:@"StockCode"];
            }
            if(_nReqAction <= 0)
                _nReqAction = 20191;
        }
        [pDict setTztObject:@"1" forKey:@"Lead"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:[NSString stringWithFormat:@"%d", _nReqAction] withDictValue:pDict];
        DelObject(pDict);
    }
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0)
        return 0;
    tztNewMSParse* pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztHqReq])
        return 0;
    
    if ([pParse IsAction:@"20191"] || [pParse GetAction] == _nReqAction)
    {
        if (_dataArray == NULL)
            _dataArray = NewObject(NSMutableArray);
        [_dataArray removeAllObjects];
        
        //解析指数数据
        NSArray *ayGridVol = [pParse GetArrayByName:@"Grid"];
        if ([ayGridVol count] <= 0)
        {
            if (!self.bNOFresh)
                [_pTableView reloadData];//刷新
            return 1;
        }
        
        NSInteger nCodeIndex = -1;//代码索引
        /*
         注：
         默认返回数据的固定位置，然后去获取索引，若没索引，直接用固定制*/
        NSInteger nNameIndex = 0;//名称索引
        NSInteger nPriceIndex = 1;//最新价索引
        NSInteger nRatioIndex = 3;//涨跌索引
        NSInteger nRangeIndex = 2;//幅度索引
        NSInteger nTotalHandIndex = 9;//总手索引
        NSInteger nTotalValueIndex = 10;//总市值索引
        NSInteger nchangeIndex = 12;//换手率
        NSInteger nZFIndex = 13;//振幅
        NSString *strIndex = [pParse GetByName:@"stockcodeindex"];
        TZTStringToIndex(strIndex, nCodeIndex);
        
        strIndex = [pParse GetByName:@"stocknameindex"];
        TZTStringToIndex(strIndex, nNameIndex);
        if (nNameIndex < 0)
            nNameIndex = 0;
        
        strIndex = [pParse GetByName:@"NewPriceIndex"];
        TZTStringToIndex(strIndex, nPriceIndex);
        if (nPriceIndex < 0)
            nPriceIndex = 1;
        
        strIndex = [pParse GetByName:@"UPDOWNINDEX"];
        TZTStringToIndex(strIndex, nRatioIndex);
        if (nRatioIndex < 0)
            nRatioIndex = 3;
        
        strIndex = [pParse GetByName:@"UPDOWNPINDEX"];
        TZTStringToIndex(strIndex, nRangeIndex);
        if (nRangeIndex < 0)
            nRangeIndex = 2;
        
        strIndex = [pParse GetByName:@"TOTALHINDEX"];
        TZTStringToIndex(strIndex, nTotalHandIndex);
        if (nTotalHandIndex < 0)
            nTotalHandIndex = 9;
        
        strIndex = [pParse GetByName:@"TotalMIndex"];
        TZTStringToIndex(strIndex, nTotalValueIndex);
        if (nTotalValueIndex < 0)
            nTotalValueIndex = 10;
        
        strIndex = [pParse GetByName:@"ChangePerIndex"];
        TZTStringToIndex(strIndex, nchangeIndex);
        if (nchangeIndex < 0)
            nchangeIndex = 12;
        
        strIndex = [pParse GetByName:@"SHOCKRANGINDEX"];
        TZTStringToIndex(strIndex, nZFIndex);
        if (nZFIndex < 0)
            nZFIndex = 13;
        
        
        //颜色
        NSString* strBase = [pParse GetByName:@"BinData"];
        NSData* DataBinData = [NSData tztdataFromBase64String:strBase];
        char *pColor = (char*)[DataBinData bytes];
        if(pColor)
            pColor = pColor + 2;//时间 2个字节
        
        
        NSString* strGridType = [pParse GetByName:@"NewMarketNo"];
        if (strGridType == NULL || strGridType.length < 1)
            strGridType = [pParse GetByName:@"DeviceType"];
        NSArray* ayGridType = [strGridType componentsSeparatedByString:@"|"];
        if(_ayStockType == NULL)
            _ayStockType = NewObject(NSMutableArray);
        [_ayStockType removeAllObjects];
        for (int i = 0; i < [ayGridType count]; i++)
        {
            NSString* strtype = [ayGridType objectAtIndex:i];
            if (strtype)
                [_ayStockType addObject:strtype];
            else
                [_ayStockType addObject:@"0"];
        }
        for (int i = 1; i < [ayGridVol count]; i++)
        {
            NSArray* ayData = [ayGridVol objectAtIndex:i];
            
            if (nNameIndex < 0)
                nNameIndex = 0;
            if (nCodeIndex < 0)
                nCodeIndex = [ayData count] -1;
            NSMutableDictionary* pStockDict = NewObject(NSMutableDictionary);
            for (int j = 0; j < [ayData count]; j++) //最后一个竖线
            {
                NSString* strKey = @"";
                NSString* strValue = @"";
                UIColor*  txtColor = nil;
                BOOL bDeal = FALSE;
                if (j == nNameIndex)
                {
                    bDeal = TRUE;
                    strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    NSArray* pAy = [strValue componentsSeparatedByString:@"."];
                    if ([pAy count] > 1)
                    {
                        strValue = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
                    }
                    else
                    {
                        strValue = [NSString stringWithFormat:@"%@", strValue];
                    }
                    
                    strKey = @"Name";
                    if (pColor)
                        txtColor = [UIColor colorWithChar:*pColor];
                }
                else if (j == nCodeIndex)
                {
                    bDeal = TRUE;
                    strKey = @"Code";
                    strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    
                    NSArray* pAy = [strValue componentsSeparatedByString:@"."];
                    if ([pAy count] > 1)
                    {
                        strValue = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
                    }
                    else
                    {
                        strValue = [NSString stringWithFormat:@"%@", strValue];
                    }
                    if (pColor)
                        txtColor = [UIColor colorWithChar:*pColor];
                }
                else if (j == nPriceIndex)//最新价
                {
                    bDeal = TRUE;
                    strKey = @"NewPrice";
                    strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    if (pColor)
                        txtColor = [UIColor colorWithChar:*pColor];
                }
                else if (j == nRatioIndex)//涨跌值
                {
                    bDeal = TRUE;
                    strKey = @"Ratio";
                    strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    if (pColor)
                        txtColor = [UIColor colorWithChar:*pColor];
                }
                else if (j == nRangeIndex)//涨跌幅
                {
                    strKey = @"Range";
                    if (_nCurSegmentIndex != 2)
                    {
                        bDeal = TRUE;
                        strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                        if (pColor)
                            txtColor = [UIColor colorWithChar:*pColor];
                    }
                }
                else if (j == nTotalValueIndex)//总市值
                {
                    bDeal = TRUE;
                    strKey = @"TotalValue";
                    strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    if (pColor)
                        txtColor = [UIColor colorWithChar:*pColor];
                }
                else if (j == nTotalHandIndex)
                {
                    bDeal = TRUE;
                    strKey = @"TotalHand";
                    strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    if (pColor)
                        txtColor = [UIColor colorWithChar:*pColor];
                }
                else if (j == nchangeIndex)//换手率
                {
                    bDeal = TRUE;
                    strKey = @"ChangeValue";
                    strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    if (pColor)
                        txtColor = [UIColor colorWithChar:*pColor];
                }
                else if (j == nZFIndex)//振幅
                {
                    bDeal = TRUE;
                    strKey = @"RangeValue";
                    strValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    if (pColor)
                        txtColor = [UIColor colorWithChar:*pColor];
                }
                
                if (bDeal)
                {
                    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
                    [pDict setTztObject:strValue forKey:@"value"];
                    if (txtColor)
                        [pDict setTztObject:txtColor forKey:@"color"];
                    [pStockDict setTztObject:pDict forKey:strKey];
                    DelObject(pDict);
                }
                pColor++;
            }
            
            if (ayGridType && [ayGridType count] > (i-1))
            {
                [pStockDict setTztObject:[ayGridType objectAtIndex:(i-1)] forKey:@"StockType"];
            }
            [_dataArray addObject:pStockDict];
            [pStockDict release];
        }
    }
    if (!self.bNOFresh)
        [_pTableView reloadData];
    return 1;
}


#pragma mark - 表格cell手势事件响应处理

- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.pTableView indexPathForCell:cell];
    if (self.dataArray == nil || self.dataArray.count <= indexPath.row)
        return;
    NSDictionary *pDict = [self.dataArray objectAtIndex:indexPath.row];
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    pStock.stockName = [pDict tztObjectForKey:@"Name"];
    pStock.stockCode = [pDict tztObjectForKey:@"Code"];
    
    if (self.ayStockType && indexPath.row < [self.ayStockType count])
    {
        NSString* strType = [self.ayStockType objectAtIndex:indexPath.row];
        if (strType && [strType length] > 0)
        {
            pStock.stockType = [strType intValue];
        }
    }
    switch (index)
    {
        case 0:
        {
            [TZTUIBaseVCMsg OnMsg:WT_BUY wParam:(NSUInteger)pStock lParam:0];
            break;
        }
        case 1:
        {
            [TZTUIBaseVCMsg OnMsg:WT_SALE wParam:(NSUInteger)pStock lParam:0];
            break;
        }
        case 2:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_SYS_UserWarning wParam:(NSUInteger)pStock lParam:0];
//            [TZTUIBaseVCMsg OnMsg:TZT_MENU_Share wParam:0 lParam:0];
            break;
        }
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swippableTableViewCell:(TZTUserStockTableViewCell *)cell scrollingToState:(SWCellState)state
{
    
    if (state == kCellStateCenter) {
        centerCount ++;
    }
    else
    {
        nonCenCount ++;
    }
    if (centerCount == nonCenCount) {
        self.bNOFresh = NO;
    }
    else
    {
        self.bNOFresh = YES;
    }
}

-(void)tztDetailHeader:(id)sender OnTapClicked:(BOOL)bExpand
{
    float fHeight = [stockDetailHeaderView GetNeedHeight];
    if (fHeight <= 0)
        return;
    
    CGRect rc = self.frame;
    rc.origin.y += stockDetailHeaderView.frame.size.height - 54;
    [UIView animateWithDuration:0.2f animations:^(void)
     {
         CGRect rcFrame = stockDetailHeaderView.frame;
         CGRect rcTimeTech = timeTechView.frame;
         if (bExpand)
         {
             rcFrame.size.height += fHeight;
             rcTimeTech.origin.y += (fHeight);
             nSectionExHeight = (fHeight);
         }
         else
         {
             rcFrame.size.height -= fHeight;
             rcTimeTech.origin.y -= (fHeight);
             nSectionExHeight = 0;
         }
         stockDetailHeaderView.frame = rcFrame;
         timeTechView.frame = rcTimeTech;
         stockDetailHeaderView.bExpand = bExpand;
         [self.pTableView reloadData];
         
         if (bExpand)
         {
             //覆盖一层view，不允许页面进行其他操作
             CGRect rcView = self.frame;
             rcView.origin.y += rcFrame.size.height - 54;
             if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztDetailHeader:OnTapClicked:)])
             {
                 [self.tztdelegate tztDetailHeader:nil OnTapClicked:bExpand];
             }
             [self bringSubviewToFront:pBackView];
             [self.pTableView scrollsToTop];
             [self.pTableView setContentOffset:CGPointMake(0, 0) animated:YES];
         }
         else
         {
         }
         
         [stockDetailHeaderView setNeedsDisplay];
     }];
    
}

-(void)tztHqView:(id)hqView setTitleStatus:(NSInteger)nStatus andStockType_:(NSInteger)nType
{
    if (_tztTitleTypeOne)
    {
        [_tztTitleTypeOne setStockDetailInfo:nType nStatus:nStatus];
        _tztTitleTypeOne.firstBtn.hidden = YES;
        _tztTitleTypeOne.fourthBtn.hidden = YES;
    }
    if (_stockDetailTittleView)
    {
        [_stockDetailTittleView setStockDetailInfo:nType nStatus:nStatus];
    }
}
@end
