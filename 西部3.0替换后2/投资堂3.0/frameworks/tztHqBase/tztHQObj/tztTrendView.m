/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztTrendView.m
 * 文件标识：
 * 摘    要：分时视图
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import "tztTrendView.h"
#ifdef Support_HKTrade
#import "tztHKQueueViee.h"
#import "tztJYLoginInfo.h"
#endif

#define TZTTrendPath @"Library/Documents/Trend"


@interface tztTrendValue ()
{
    unsigned long ulClosePrice;      //最新价，单位：厘
    unsigned long ulAvgPrice;      //均价，单位：厘
    int32_t nTotal_h;     //分钟成交量
    
    int nLead; //领先指标
    int nChiCangL;//持仓量
}
@end

@implementation tztTrendValue
@synthesize ulClosePrice;      //最新价，单位：厘
@synthesize ulAvgPrice;      //均价，单位：厘
@synthesize nTotal_h;     //分钟成交量
@synthesize nLead;
@synthesize nChiCangL;
- (id)init
{
    self = [super init];
    if(self)
    {
        ulClosePrice = UINT32_MAX;
        ulAvgPrice = UINT32_MAX;
        nTotal_h = INT32_MAX;
        nLead = INT32_MAX;
        nChiCangL = INT32_MAX;
    }
    return self;
}

- (BOOL)isVaild
{
    return (ulClosePrice != UINT32_MAX && nTotal_h != INT32_MAX);
}
@end


@interface tztTrendView ()<tztUIBaseViewCheckDelegate>
{
    
    BOOL          _bPercent;     //是否百分比
    BOOL          _bHideVolume; //是否隐藏分时量图
    
    BOOL        _Move;
    CGPoint     _TrendCursor;    //光标坐标
    BOOL        _bTrendDrawCursor;//是否绘制光标
    long        _TrendCursorValue;//光标值
        
    tztTrendPriceStyle _tztPriceStyle; //报价图状态
#ifdef Support_HKTrade
    tztHKQueueViee  *_tztHKQueueView;
#endif
    
    CALayer     *_pRoundPointLayer;
    CGPoint     _preClickPoint;
}
//分时时间段
@property (nonatomic, retain) NSString*   nsAccount;
/*圆点脉冲效果*/
@property (nonatomic,retain) CALayer *pRoundPointLayer;
@property (nonatomic, assign) CGFloat radius;                   // default:60pt
@property (nonatomic, assign) NSTimeInterval animationDuration; // default:3s
@property (nonatomic, assign) NSTimeInterval pulseInterval; // default is 0s
@property (nonatomic, retain) CAAnimationGroup *animationGroup;
/**/

- (NSString*)getValueString:(long)lValue;
- (void)CalculateValue;
- (NSString*)getDiffPercent:(float)ldiff maxdiff:(long)lMaxdiff;
//获取数据对应位置 分时图
- (CGFloat)ValueToVertPos:(CGRect)drawRect diff:(long)ldiff maxdiff:(long)lMaxdiff;
//获取数据对应位置 量图
- (CGFloat)ValueToVertPos:(CGRect)drawRect lValue:(long)lValue MaxValue:(long)lMaxValue;
- (NSString*)getstrTimeofPos:(NSInteger)nPos;
- (long)getTimeData:(NSString*)strTime;

//绘制底图
- (BOOL)drawBackGround:(CGContextRef)context rect:(CGRect)rect;
//绘制分时图
- (void)onDrawTrend:(CGContextRef)context;

//绘制分时指标图
- (void)onDrawVol:(CGContextRef)context;
//十字光标线
- (void)onDrawCursor:(CGContextRef)context;
- (void)onDrawCursorEx:(CGContextRef)context andIndex:(NSInteger)nIndex;

//绘制tips
- (void)onDrawTips:(CGRect)rect;
//获取文件路径
- (NSString *)getTrendPath;
//解析数据并刷新  parse:数据  bRead:是本地数据
- (NSUInteger)dealParse:(tztNewMSParse*)parse IsRead:(BOOL)bRead;
//读取本地数据并刷新
- (void)readParse;
@end

@implementation tztTrendView
@synthesize ayTrendInfo = _ayTrendInfo;
@synthesize ayTrendValues = _ayTrendValues;
@synthesize trendTimes = _trendTimes;
@synthesize trendEndDate = _trendEndDate;//add by xyt 20130816
@synthesize tztPriceStyle = _tztPriceStyle;
@synthesize bHideVolume = _bHideVolume;
@synthesize bHideFundFlows = _bHideFundFlows;
@synthesize bTrendDrawCursor = _bTrendDrawCursor;
@synthesize bSupportTrendCursor = _bSupportTrendCursor;
@synthesize bShowMaxMinPrice = _bShowMaxMinPrice;
@synthesize bShowLeadLine = _bShowLeadLine;
@synthesize bShowAvgPriceLine = _bShowAvgPriceLine;
@synthesize bShowRightRatio = _bShowRightRatio;
@synthesize pBtnDetail = _pBtnDetail;
@synthesize nsAccount = _nsAccount;
@synthesize pBtnNoRights = _pBtnNoRights;
@synthesize bHiddenTime = _bHiddenTime;
@synthesize bHoriShow = _bHoriShow;
@synthesize TrendDrawRect = _TrendDrawRect;  //分时图区域
@synthesize VolParamRect = _VolParamRect;   //量图参数区域
@synthesize VolDrawRect = _VolDrawRect;    //量图区域
@synthesize PriceDrawRect = _PriceDrawRect;  //报价图区域


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    DelObject(_ayTrendValues);
    DelObject(_ayTrendInfo);
    _tztdelegate = nil;
    if (_TrendHead)
    {
		free(_TrendHead);
        _TrendHead = nil;
    }
    
    if (_PriceData)
    {
        free(_PriceData);
        _PriceData = nil;
    }
    
    if (_PriceDataEx)
    {
        free(_PriceDataEx);
        _PriceDataEx = nil;
    }
    NilObject(self.trendTimes);
    [super dealloc];
}

//初始化数据
- (void)initdata
{
    [super initdata];
    if (_ayTrendValues == NULL)
        _ayTrendValues = NewObject(NSMutableArray);
    if (_ayTrendInfo == NULL)
        _ayTrendInfo = NewObject(NSMutableArray);
    if (_TrendHead == NULL)
        _TrendHead = malloc(sizeof(TNewTrendHead));
    memset(_TrendHead, 0x00, sizeof(TNewTrendHead));
    
    if (_PriceData == NULL)
        _PriceData = malloc(sizeof(TNewPriceData));
    memset(_PriceData, 0x00, sizeof(TNewPriceData));
    
    if (_PriceDataEx == NULL)
        _PriceDataEx = malloc(sizeof(TNewPriceData));
    memset(_PriceDataEx, 0x00, sizeof(TNewPriceData));
    
    self.trendTimes = @"09:30|11:30|13:00|15:00|";
    _nMaxCount = 241;
    self.trendEndDate = @"";
    _TrendCursor = CGPointZero;
    _bTrendDrawCursor = FALSE;
    _bSupportTrendCursor = TRUE;
    _bShowAvgPriceLine = TRUE;
    _bShowLeadLine = TRUE;
    _bShowRightRatio = TRUE;
    _bShowTips = TRUE;
    _TrendCursorValue = INT32_MAX;
    _TrendCurIndex = INT32_MAX;
    _Move = FALSE;
    if(IS_TZTIPAD)
    {
        _tztPriceStyle = TrendPriceNon;
        _bHide = YES;
        _bHideFundFlows = YES;
    }
    else
    {
        _tztPriceStyle = TrendPriceOne;
        _bHide = FALSE;
    }
    
    if(_tztPriceView == nil)
    {
        _tztPriceView = [[tztPriceView alloc] init];
        [self addSubview:_tztPriceView];
        [_tztPriceView release];
    }
#ifdef Support_HKTrade
    if (_pBtnDetail == nil)
    {
        _pBtnDetail = [[tztUISwitch alloc] initWithProperty:@"tag=1000|backgroundcolor=189,122,42|yestitle=收起队列|notitle=买卖经纪|textalignment=center|font=13"];
        _pBtnDetail.backgroundColor = [UIColor colorWithTztRGBStr:@"189,122,42"];
        _pBtnDetail.tztdelegate = self;
        _pBtnDetail.layer.cornerRadius = 2.5;
        [self addSubview:_pBtnDetail];
        [_pBtnDetail release];
        _pBtnDetail.hidden = YES;
    }
    
    if (_pBtnNoRights == nil)
    {
        _pBtnNoRights = [UIButton buttonWithType:UIButtonTypeCustom];
        _pBtnNoRights.backgroundColor = [UIColor colorWithTztRGBStr:@"189,122,42"];
        [_pBtnNoRights addTarget:self action:@selector(OnBtnNoRights:)
                forControlEvents:UIControlEventTouchUpInside];
        [_pBtnNoRights setTztTitle:@"切换十档"];
        [_pBtnNoRights.titleLabel setFont:tztUIBaseViewTextFont(13)];
        [_pBtnNoRights setTztTitleColor:[UIColor whiteColor]];
        [self addSubview:_pBtnNoRights];
        _pBtnNoRights.hidden = YES;
    }
    
    if (_tztHKQueueView == NULL)
    {
        _tztHKQueueView = [[tztHKQueueViee alloc] init];
        [self addSubview:_tztHKQueueView];
        [_tztHKQueueView release];
        _tztHKQueueView.hidden = YES;
    }
#endif
    
#ifdef TZT_ZYData
    //资金流向图
    if(_tztFundFlows == nil)
    {
        _tztFundFlows = [[TZTUIFundFlowsView alloc] init];
        _tztFundFlows.tztdelegate = self;
        _tztFundFlows.nMaxCount = _nMaxCount;
        _tztFundFlows.fLeftWidth = _fYAxisWidth;
        _tztFundFlows.hidden = YES;
        [self addSubview:_tztFundFlows];
        [_tztFundFlows release];
    }
    //
#endif
    
#if 0
    if (self.pRoundPointLayer == NULL)
    {
//        UIImage *image = [UIImage imageTztNamed:@"TZTChina@2x.png"];
        self.pRoundPointLayer = [CALayer layer];
//        self.pRoundPointLayer.contents = (id)image.CGImage;
        self.pRoundPointLayer.backgroundColor = [UIColor colorWithRed:44/255.f green:155/255.f blue:218/255.f alpha:1.0].CGColor;
        self.pRoundPointLayer.bounds = CGRectMake(0, 0, 5, 5);
        self.pRoundPointLayer.cornerRadius = 2;
        self.pRoundPointLayer.transform = CATransform3DMakeScale(0.3, 0.65, 1);
        [self.layer addSublayer:self.pRoundPointLayer];
        self.pRoundPointLayer.hidden = YES;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.autoreverses = YES;//自动回到最初
        animation.duration = 3.f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.repeatCount = HUGE_VALF;
        [self.pRoundPointLayer addAnimation:animation forKey:@"pulseAnimation"];
    }
#endif
    UIFont* drawfont = [tztTechSetting getInstance].drawTxtFont;
    CGSize drawsize = [@"999.99" sizeWithFont:drawfont];
    _fYAxisWidth = drawsize.width + 1;
    _nMaxVol = 0;
    _bPercent = FALSE;
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
}

-(void)OnDealLoginSucc:(NSInteger)nMsgType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    [self OnBtnNoRights:(id)wParam];
}

- (void)OnTradeLoginSuccess:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    [self onRequestData:YES];
}

-(void)OnBtnNoRights:(id)sender
{
#ifdef Support_HKTrade
    tztZJAccountInfo *pZJAccount = tztGetCurrentAccountHKRight();
    if (pZJAccount == NULL)//没有资金账号，直接登录
    {
        if(![TZTUIBaseVCMsg SystermLogin:0 wParam:(NSUInteger)sender lParam:0 delegate:self isServer:FALSE])
        {
            [TZTUIBaseVCMsg tztTradeLogin:0 wParam:(NSUInteger)sender lParam:0 lLoginType:TZTAccountPTType delegate:self];
        }
        return;
    }
    if (_nRightsType == 1)
    {
        tztAfxMessageBox(@"    您的账号有可能在其他设备登录，如需继续查看十档行情，请重新登录。如非本人操作，建议修改密码或联系95597。");
    }
    else
    {
        tztAfxMessageBox(@"    您尚无查看港股十档行情权限，如需购买，请联系客户经理或95597。");
    }
#endif
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView checked:(BOOL)checked
{
#ifdef Support_HKTrade
    if (checked)
    {
        _tztHKQueueView.hidden = NO;
        CGRect rcFrame = self.bounds;
        int nHeight = rcFrame.size.height - (_pBtnDetail.frame.size.height - 4);
        rcFrame.size.height = nHeight;
        CGRect rcAfter = rcFrame;
        rcFrame.size.height = 0;
        _tztHKQueueView.frame = rcFrame;
        [UIView animateWithDuration:0.2 animations:^{
            _tztHKQueueView.frame = rcAfter;
        }];
        [_tztHKQueueView setStockInfo:self.pStockInfo Request:1];
    }
    else
    {
        CGRect rcFrame = _tztHKQueueView.frame;
        CGRect rcAfter = rcFrame;
        rcAfter.size.height = 0;
        [UIView animateWithDuration:0.2
                         animations:^{
                             _tztHKQueueView.frame = rcAfter;
                         }
                         completion:^(BOOL bFinished){
                             _tztHKQueueView.hidden = YES;
                         }];
        [_tztHKQueueView onSetViewRequest:NO];
    }
#endif
}

- (void)onClearData
{
    [super onClearData];
    [_ayTrendValues removeAllObjects];
    [_ayTrendInfo removeAllObjects];
    memset(_TrendHead, 0x00, sizeof(TNewTrendHead));
    memset(_PriceData, 0x00, sizeof(TNewPriceData));
    self.trendTimes = @"";
    _nMaxCount = 0;
    _nMaxVol = 0;
    _nMaxChiCangL = 0;
    _nMinChiCangL = INT32_MAX;
    self.trendEndDate = @"";
    if(_tztPriceView)
    {
        [_tztPriceView onClearData];
    }
}

- (void)setTztPriceStyle:(tztTrendPriceStyle)tztPriceStyle
{
    if(_tztPriceStyle != tztPriceStyle)
    {
        _tztPriceStyle = tztPriceStyle;
        if(_tztPriceStyle == TrendPriceNon)
        {
            _bHide = YES;
        }
        else
        {
            if(_tztPriceView)
            {
                _tztPriceView.tztPriceStyle = _tztPriceStyle;
            }
            _bHide = NO;
        }
        [self setNeedsDisplay];
    }
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    [super onSetViewRequest:bRequest];
    if (_tztPriceView && _tztPriceView.pDetailView)
        [_tztPriceView.pDetailView onSetViewRequest:bRequest];
}

#pragma 分时请求
- (void)onRequestData:(BOOL)bShowProcess
{		
    TZTNSLog(@"%@",@"onRequestData");
    if(_bRequest)
    {
        if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
        {
            return;
        }
        if(_tztPriceView)
        {
            _tztPriceView.pStockInfo = self.pStockInfo;
        }
        NSInteger nStartPos = 0;
        if (MakeWHMarket(self.pStockInfo.stockType))
        {
            [self onClearData];
        }
        
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        if(_ayTrendValues && [_ayTrendValues count] > 0)//增量请求
        {
            nStartPos = [_ayTrendValues count] -1;
            if (!self.trendEndDate && self.trendEndDate.length>0)
                [sendvalue setTztObject:self.trendEndDate forKey:@"EndDate"];
        }
        
        NSString* strPos = [NSString stringWithFormat:@"%ld",(long)nStartPos];
 
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        [sendvalue setTztObject:strPos forKey:@"StartPos"];
        
        [sendvalue setTztObject:@"2" forKey:@"AccountIndex"];
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        
        NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
        [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
        
        if (MakeHKMarketStock(self.pStockInfo.stockType))
        {
            [sendvalue setTztObject:@"2" forKey:@"level"];
            //华泰港股通专用
#ifdef Support_HKTrade
            self.nsAccount = @"";
            tztZJAccountInfo *pZJAccount = tztGetCurrentAccountHKRight();
            if (pZJAccount)
            {
                if (pZJAccount.nsAccount && pZJAccount.nsAccount.length > 0)
                {
                    self.nsAccount = [NSString stringWithFormat:@"%@", pZJAccount.nsAccount];//记录下请求的账号和接收回来的账号进行比较，对权限要根据账号区分
                    [sendvalue setTztObject:pZJAccount.nsAccount forKey:@"Account"];
                }
                if (pZJAccount.Ggt_rights && pZJAccount.Ggt_rights.length > 0)
                    [sendvalue setTztObject:pZJAccount.Ggt_rights forKey:@"Ggt_rights"];
                if (pZJAccount.Ggt_rightsEndDate && pZJAccount.Ggt_rightsEndDate.length > 0)
                    [sendvalue setTztObject:pZJAccount.Ggt_rightsEndDate forKey:@"Ggt_rightsEndDate"];
            }
#endif
            
        }
        
        NSString* strReqno = tztKeyReqnoTokenOne((long)self, _ntztHqReq,0,0,(nStartPos == 0 ? tztTrendFirst : tztTrendAdd));
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20109" withDictValue:sendvalue];
        DelObject(sendvalue);
    }
    [super onRequestData:bShowProcess];
}

#pragma tztSocketData Delegate
- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if( wParam == 0 )
        return 0;
    tztNewMSParse *parse = (tztNewMSParse*)wParam;
    if([parse GetAction] == 20109)
    {
        if(![parse IsIphoneKey:(long)self reqno:_ntztHqReq])
        {
            return 0;
        }
//        dispatch_block_t block = ^{ @autoreleasepool {
        [self dealParse:parse IsRead:FALSE];
//        }};
//        if (dispatch_get_current_queue() == dispatch_get_main_queue())
//            block();
//        else
//            dispatch_sync(dispatch_get_main_queue(), block);
    }
    return 0;
}


//解析数据并刷新  parse:数据  bRead:是本地数据
- (NSUInteger)dealParse:(tztNewMSParse*)parse IsRead:(BOOL)bRead
{
    if(bRead) //先清空原数据
        [self onClearData];
    NSString* DataStockType = [parse GetValueData:@"NewMarketNo"];
    if (DataStockType == NULL || DataStockType.length < 1)
        DataStockType = [parse GetValueData:@"stocktype"];
    if(DataStockType && [DataStockType length] > 0)
    {
        self.pStockInfo.stockType = [DataStockType intValue];
    }
    
    if(_tztPriceView)
    {
        _tztPriceView.pStockInfo = self.pStockInfo;
    }
    
    BOOL bClearAll = FALSE;
    NSString* strReqno = [parse GetByName:@"Reqno"];
    tztNewReqno* tztReqno = [tztNewReqno reqnoWithString:strReqno];
    if(!bRead)
    {
        if([tztReqno getReqdefOne] == tztTrendFirst)
        {
            bClearAll = TRUE;
            [self onClearData];
        }
    }
    
    if(!bRead)
        self.trendEndDate = [parse GetValueData:@"EndDate"];
    
    NSString* DataMaxCount = [parse GetValueData:@"MaxCount"];
    if(DataMaxCount && [DataMaxCount length] > 0)
    {
        _nMaxCount = [DataMaxCount intValue];
        if(_nMaxCount <= 1)
            _nMaxCount = 241;
        
        //设置资金流向界面的 值的个数和 左边的宽度
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tzthqView:MaxCount:LeftWidth:)])
        {
            [self.tztdelegate tzthqView:self MaxCount:_nMaxCount LeftWidth:(int)_fYAxisWidth];
        }
        if (!_bHideFundFlows&&_tztFundFlows)
        {
            _tztFundFlows.fLeftWidth = _fYAxisWidth;
            _tztFundFlows.nMaxCount = _nMaxCount;
            [_tztFundFlows setNeedsDisplay];
        }
    }
    int nDataCount = [parse GetIntByName:@"ErrorNo"];//返回多少新数据

    NSString* strBase = [parse GetByName:@"Title"];
    NSData * DataTitle = [NSData tztdataFromBase64String:strBase];
    
    NSString* strStarPos = [parse GetByName:@"StartPos"];
    NSInteger nStart = (([_ayTrendValues count] < 1) ? 0 : ([_ayTrendValues count] - 1));
    if(strStarPos && [strStarPos length] > 0)
        nStart = [strStarPos intValue];
    
    if(DataTitle && [DataTitle length] > 0)
    {
        char *pBinData = (char*)[DataTitle bytes];
        int nCount = 0;
        memcpy(&nCount, pBinData, 4);
        char *pData = (char*)pBinData;
        pData += 4;
        for (int i = 0; i < nCount; i++)
        {
            short nPos = -1;
            memcpy(&nPos, pData, 2);
            pData += 2;
            if (nPos < 0)
                continue;
            
            nPos += nStart;
            [_ayTrendInfo addObject:[NSString stringWithFormat:@"%d", nPos]];
        }
    }
    
    strBase = [parse GetByName:@"Grid"];
    NSData* DataGrid = [NSData tztdataFromBase64String:strBase];
    
    if(DataGrid && [DataGrid length] > 0)
    {
        if([DataGrid length] / sizeof(TNewTrendData) == nDataCount
           && [DataGrid length] % sizeof(TNewTrendData) == 0)
        {
            NSString* strBase = [parse GetByName:@"Lead"];
            NSData* dataLead = [NSData tztdataFromBase64String:strBase];
            int* Lead = NULL;
            if(dataLead && [dataLead length] > 0)
            {
                Lead = (int *)[dataLead bytes];
                TZTNSLog(@"Lead = %d / %ld",*Lead,[dataLead length] / sizeof(int));
            }
            
            //Lead	String	数据流	领先指标，整型数组流。
            //Lead : array of  integer
            NSString* strBaseChiCangL = [parse GetByName:@"ChiCangL"];
            NSData* dataChiCangL = [NSData tztdataFromBase64String:strBaseChiCangL];
            int* ChiCangL = NULL;
            if(dataChiCangL && [dataChiCangL length] > 0)
            {
                ChiCangL = (int *)[dataChiCangL bytes];
                TZTNSLog(@"ChiCangL = %d / %ld",*ChiCangL,[dataChiCangL length] / sizeof(int));
            }
            
            
            NSData* Databindata = [parse GetNSData:@"BinData"];
            if(Databindata && [Databindata length] > 0)
            {
                NSString* strBaseBinData = [parse GetByName:@"BinData"];
                setTNewTrendHead(_TrendHead,strBaseBinData);
                if( _TrendHead->nClear)
                {
                    [_ayTrendValues removeAllObjects];
                }
                int32_t ntrendMinPrice = _TrendHead->nMinPrice;
                int nAddTrendValues = nDataCount;//返回数据数
                
                //超过最大数据数，清除原多余数据 （是否应该清空原数据？）
                NSInteger nHaveCount = [_ayTrendValues count];
                for (NSInteger i = nStart;  i < nHaveCount; i++)
                {
                    [_ayTrendValues removeLastObject];
                }
                
                if([_ayTrendValues count] == 0)
                {
                    _nMaxVol = 0;
                    _nMaxChiCangL = 0;
                    _nMinChiCangL = INT32_MAX;
                    bClearAll = TRUE;
                }
                
                for (NSInteger i = 0; i < nAddTrendValues; i++)
                {
                    tztTrendValue* trendvalue = NewObject(tztTrendValue);
                    [_ayTrendValues addObject:trendvalue];
                    [trendvalue release];
                }
                TNewTrendData* trendData = (TNewTrendData*)[DataGrid bytes];
                for (NSInteger i = [_ayTrendValues count] - nDataCount; i < [_ayTrendValues count]; i++,trendData++)
                {
                    tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:i];
                    if(trendvalue && trendData)
                    {
                        trendvalue.ulClosePrice = trendData->nClosePrice + ntrendMinPrice;
                        trendvalue.ulAvgPrice = trendData->nAvgPrice + ntrendMinPrice;
                        trendvalue.nTotal_h = trendData->nTotal_h;
                        if(trendvalue.nTotal_h > _nMaxVol)
                            _nMaxVol = trendvalue.nTotal_h;
                        if(Lead)
                        {
                            trendvalue.nLead = *Lead;
                            Lead++;
                        }
                        if(ChiCangL)
                        {
                            trendvalue.nChiCangL = *ChiCangL;
                            if(trendvalue.nChiCangL > _nMaxChiCangL)
                                _nMaxChiCangL = trendvalue.nChiCangL;
                            if(trendvalue.nChiCangL < _nMinChiCangL)
                                _nMinChiCangL = trendvalue.nChiCangL;
                            ChiCangL++;
                        }
                    }
                }
                //Grid	String		分时数据，结构体TFSZS数组数据流，每条记录代表1分钟的数据。
                //TFSZS = packed record
                //Last_p: word; //最新价
                //averprice: word; //均价
                //total_h: integer; //分钟成交量
                //end;
            }
            //bindata	String		股票数据，只有一条记录，是结构体TFSZSHead数据流。
            //TFSZSHead = packed record
            //StockName: array[0..15] of char; //股票名称
            //Close_p: longint; //昨收盘价
            //Open_p: longint; //开盘价
            //total_size: byte; //小数点位数
            //Units: byte; //单位   10的倍数 1表示需要乘10 2表示要乘100
            //Consult: longint; //参考值  取最小值
            //end;
        }
    }
    
    NSString* dataBeginDate = [parse GetValueData:@"BeginDate"];
    if(dataBeginDate && [dataBeginDate length] > 0)
    {
        self.trendTimes =  dataBeginDate;
        TZTNSLog(@"BeginDate = %@",_trendTimes);
    }
    
    NSString* strBaseData = [parse GetByName:@"WTAccount"];
    if(strBaseData && [strBaseData length] > 0)
    {
        setTNewPriceData(_PriceData, strBaseData);
        [_tztPriceView setPriceData:_PriceData len:sizeof(TNewPriceData)];
    }
    
    NSString* strAnswerno = [parse GetByName:@"AnswerNo"];
    if (strAnswerno && [strAnswerno length] > 0)
    {
        setTNewPriceDataEx(_PriceDataEx, strAnswerno);
        [_tztPriceView setPriceDataEx:_PriceDataEx len:sizeof(TNewPriceDataEx)];
    }
    
    _pBtnNoRights.hidden = !MakeHKMarketStock(self.pStockInfo.stockType);
    //华泰港股通专用
#ifdef Support_HKTrade
    tztZJAccountInfo *pZJAccount = tztGetCurrentAccountHKRight();
    _nRightsType = 0;
    if (pZJAccount)
    {
        NSString* strAccount = [parse GetByName:@"Account"];
        if (strAccount && [strAccount caseInsensitiveCompare:self.nsAccount] == NSOrderedSame)
        {
            NSString* strGgtRight = [parse GetByName:@"Ggt_rights"];
            if (strGgtRight && strGgtRight.length > 0)
                pZJAccount.Ggt_rights = [NSString stringWithFormat:@"%@", strGgtRight];
            else
                pZJAccount.Ggt_rights = @"";
            
            NSString* strGgtRightEndDate = [parse GetByName:@"Ggt_rightsEndDate"];
            if (strGgtRightEndDate && strGgtRightEndDate.length > 0)
                pZJAccount.Ggt_rightsEndDate = [NSString stringWithFormat:@"%@", strGgtRightEndDate];
            else
                pZJAccount.Ggt_rightsEndDate = @"";
            
            tztSaveCurrentHKRight(pZJAccount);
            
            //判断显示
            if (strGgtRight && strGgtRight.length > 0)//有股东账号
            {
                if ([strGgtRight intValue] > 0)//
                {
                    if (pZJAccount.nLogVolume < 1)//有权限，是被踢掉了，提示要变，否则就是没权限，直接提示升级
                    {
                        _nRightsType = 1;
                        _pBtnNoRights.hidden = NO;
                    }
                    else
                    {
                        _pBtnNoRights.hidden = YES;
                    }
                }
                else
                {
                    _nRightsType = 0;
                    _pBtnNoRights.hidden = NO;
                }
            }
        }
    }
    
#endif
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:setTitleStatus:andStockType_:)])
    {
        int nType = 0x0000;
        if (_PriceData->c_IsGgt == '1')
        {
            BOOL bCanBuy = (_PriceData->c_CanBuy == '1');
            BOOL bCanSell = (_PriceData->c_CanSell == '1');
            
            if (bCanBuy && bCanSell)
                nType = 0x0011;
            else if (bCanBuy)
                nType = 0x0001;
            else if (bCanSell)
                nType = 0x0010;
            else
                nType = 0;
            
        }
        if (_PriceData->c_RQBD == '1')
        {
            nType |= 0x1000;
        }
        if (_PriceData->c_RZBD == '1')
        {
            nType |= 0x0100;
        }
        [self.tztdelegate tztHqView:self setTitleStatus:nType andStockType_:self.pStockInfo.stockType];
    }
    
    NSString* strStockName = [NSString stringWithFormat:@"%@",self.pStockInfo.stockName];
    if(!bRead)
    {
        NSString* nsStockName = getName_TNewPriceData(_PriceData);
        nsStockName = [nsStockName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (nsStockName && nsStockName.length > 0)
        self.pStockInfo.stockName = [NSString stringWithFormat:@"%@", nsStockName];
    }
    
    if (self.pStockInfo.stockName && [self.pStockInfo.stockName length] > 0)
    {
        if([self.pStockInfo.stockName compare:strStockName] != NSOrderedSame)
            [self setStockInfo:self.pStockInfo];
    }
    
    [self CalculateValue];//计算数据
    [self setNeedsDisplay];
    if (_tztPriceView)
    {
        _tztPriceView.hidden = _bHide;
        if(!_bHide)
        {
            [_tztPriceView setNeedsDisplay];
        }
    }
  
    
    //通知delegate，更新界面显示数据
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(UpdateData:)])
    {
        [self.tztdelegate UpdateData:self];
    }
    
    //外汇每次都更新 所以不保存 保存本地数据 yangdl 20130812
    if (!MakeWHMarket(self.pStockInfo.stockType) && (!bRead) && bClearAll)
    {
        if([tztReqno getReqdefOne] > 0)//非历史分时
        {
            dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
            dispatch_async (FileWriteQueue,^
                            {
                                NSString* strPath = [self getTrendPath];
                                [parse WriteParse:strPath];
                            }
                            );
            dispatch_release(FileWriteQueue);
        }
    }
    return 1;
}

//获取文件路径
- (NSString *)getTrendPath
{
    return [NSString stringWithFormat:@"%@/%@/%@_%d.data",NSHomeDirectory(),TZTTrendPath,self.pStockInfo.stockCode,self.pStockInfo.stockType];
}


//读取本地数据并刷新
- (void)readParse
{
    if (!MakeWHMarket(self.pStockInfo.stockType))
    {
        dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
        dispatch_async (FileWriteQueue,^
                        {
                            NSString* strPath = [self getTrendPath];
                            tztNewMSParse* parse = NewObject(tztNewMSParse);
                            [parse ReadParse:strPath];
                            dispatch_block_t block = ^{ @autoreleasepool {
                                [self dealParse:parse IsRead:TRUE];
                            }};
                            if (dispatch_get_current_queue() == dispatch_get_main_queue())
                                block();
                            else
                                dispatch_sync(dispatch_get_main_queue(), block);
                            [parse release];
                        }
                        );
        dispatch_release(FileWriteQueue);
    }
}

#pragma 分时计算、取值处理
- (NSString*)getValueString:(long)lValue
{
    int nDiv = pow(10, _TrendHead->nUnit);
    return (NSStringOfVal_Ref_Dec_Div(lValue,0,_TrendHead->nDecimal,nDiv));
}

- (NSString*)getDiffPercent:(float)ldiff maxdiff:(long)lMaxdiff
{
    if(lMaxdiff == 0)
        return @"-";
    return [NSString stringWithFormat:@"%.2f%%",( ldiff / lMaxdiff)];
}


-(CGFloat) ValueToVertPos:(CGRect)drawRect diff:(long)ldiff maxdiff:(long)lMaxdiff
{
    if(lMaxdiff == 0)
        return CGRectGetMidY(drawRect);
    
    CGFloat fPos =CGRectGetHeight(drawRect) * ldiff / lMaxdiff;
    return CGRectGetMidY(drawRect)-fPos;
}

-(CGFloat) ValueToVertPos:(CGRect)drawRect lValue:(long)lValue MaxValue:(long)lMaxValue
{
    if(lMaxValue == 0)
        return CGRectGetMinY(drawRect);
    
    CGFloat fPos =CGRectGetHeight(drawRect) * lValue / lMaxValue;
    return CGRectGetMaxY(drawRect)-fPos;
}

- (void)CalculateValue
{
    
}

- (NSString*)getstrTimeofPos:(NSInteger)nPos
{
    NSArray* ay = [_trendTimes componentsSeparatedByString:@"|"];
    long nCount = 0;
    long nPreCount = 0;
    if(ay && [ay count] > 0)
    {
        for (int i = 0; i < [ay count]  / 2 && nCount <= _nMaxCount ; i++)
        {
            NSString* strBegin = [ay objectAtIndex:(i*2+0)];
            long lbegintime = [self getTimeData:strBegin];
            NSString* strEnd = [ay objectAtIndex:(i*2+1)];
            long lendtime = [self getTimeData:strEnd];
            if(lendtime > lbegintime)
            {
                nCount += (lendtime-lbegintime);
            }
            else //跨越24点
            {
                nCount += (24*60 - lbegintime) + lendtime;
            }
            if(nPos <= nCount)
            {
                NSInteger nPosTime = lbegintime+nPos - nPreCount;
                return [NSString stringWithFormat:@"%02d:%02d", (int)(nPosTime/60), (int)(nPosTime % 60)];
            }
            nPreCount = nCount;
        }
    }
    return @"";
}

- (long)getTimeData:(NSString*)strTime
{
    NSArray* ayTime = [strTime componentsSeparatedByString:@":"];
    if(ayTime && [ayTime count] > 1)
    {
        NSString* strHour = [ayTime objectAtIndex:0];
        NSString* strMin = [ayTime objectAtIndex:1];
        return [strHour intValue]*60 + [strMin intValue];
    }
    return 0;
}

-(void)setBHoriShow:(BOOL)bHoriShow
{
    _bHoriShow = bHoriShow;
    if (_tztPriceView)
        _tztPriceView.bHoriShow = bHoriShow;
}

#pragma 分时绘制处理
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    _tztPriceView.bHoriShow = _bHoriShow;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1);
    
    //绘制底图
     if([self drawBackGround:context rect:rect])
    {
       
        //绘制分时图
        [self onDrawTrend:context];
        
        //绘制坐标
        [self onDrawXAxis:context];
        [self onDrawYAxis:context];
        //十字光标线
        if(_bSupportTrendCursor && _bTrendDrawCursor /*&& ![self.nsBackColor intValue]*/)
        {
            [self onDrawCursor:context];
            [self onDrawTips:rect];
        }
        else
        {
            [self onDrawCursorEx:context andIndex:0];
        }
        //绘制分时指标图
        if (!_bHideVolume)
            [self onDrawVol:context];
        
        //        if(!_bHide && !CGRectIsEmpty(_PriceDrawRect))
        //        {
        //            [_tztPriceView onDrawPrice:context rect:_PriceDrawRect];
        //        }
        
#if 0
        if (_ayTrendValues.count > 0)
        {
            int nIndex = _ayTrendValues.count - 1;
            _TrendCursor.x = CGRectGetMinX(_TrendDrawRect)+ (nIndex) * CGRectGetWidth(_TrendDrawRect) / (_nMaxCount-1);
            
            if (_TrendCursor.x >= CGRectGetMinX(_TrendDrawRect) && _TrendCursor.x <= CGRectGetMaxX(_TrendDrawRect))
            {
                CGPoint drawPoint = _VolDrawRect.origin;
                drawPoint.y = CGRectGetMaxY(_VolDrawRect);
                drawPoint.x = CGRectGetMinX(_VolDrawRect) + nIndex * CGRectGetWidth(_VolDrawRect)/(_nMaxCount-1);
                if (drawPoint.x <= CGRectGetMinX(_VolDrawRect))
                {
                    drawPoint.x = CGRectGetMinX(_VolDrawRect);
                }
                else if(drawPoint.x >= CGRectGetMaxX(_VolDrawRect))
                {
                    drawPoint.x = CGRectGetMaxX(_VolDrawRect);
                }
                _TrendCursor.x = drawPoint.x;
            }
            tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:nIndex];
            if([trendvalue isVaild])
            {
                if (trendvalue.ulClosePrice != UINT32_MAX)
                {
                    long nMaxDiff = GetMaxDiff(_TrendHead->nPreClosePrice,_TrendHead->nMaxPrice,_TrendHead->nMinPrice);
                    _TrendCursor.y = [self ValueToVertPos:_TrendDrawRect diff:(trendvalue.ulClosePrice -_TrendHead->nPreClosePrice) maxdiff:nMaxDiff*2];
                }
            }
            
            self.pRoundPointLayer.hidden = NO;
            self.pRoundPointLayer.position = _TrendCursor;
        }
        else
            self.pRoundPointLayer.hidden = YES;

        
        self.pRoundPointLayer.hidden = (_bSupportTrendCursor && _bTrendDrawCursor /*&& ![self.nsBackColor intValue]*/);
#endif
//        if (_pRoundPoint)
//        {
//            _pRoundPoint.frame = rect;
//            _pRoundPoint.center = _TrendCursor;
//            [_pRoundPoint setNeedsDisplay];
//        }
    }
}

//绘制底图
- (BOOL)drawBackGround:(CGContextRef)context rect:(CGRect)rect
{
    UIColor* backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    UIColor* gridColor = [UIColor tztThemeHQGridColor];
//    if ([self.nsBackColor intValue])
//    {
//        backgroundColor = [UIColor whiteColor];
//        gridColor = [UIColor colorWithTztRGBStr:@"200,200,200"];
//    }
    
    UIFont* drawfont = NULL;
//    if (self.bHideVolume)
//    {
//        drawfont = tztUIBaseViewTextFont([tztTechSetting getInstance].drawTxtSize - 2.5f);
//    }
//    else
    {
        drawfont = [tztTechSetting getInstance].drawTxtFont;
    }
    
    long lMaxValue = GetMaxDiff(_TrendHead->nPreClosePrice,_TrendHead->nMaxPrice,_TrendHead->nMinPrice);
    NSString* strValue = @"";
    if(_bPercent)
        strValue = [self getDiffPercent:-lMaxValue*100.0f maxdiff:_TrendHead->nPreClosePrice];
    else
        strValue = [self getValueString:_TrendHead->nPreClosePrice + lMaxValue];
    
    CGSize drawsize = [strValue sizeWithFont:drawfont];
    
    _fYAxisWidth = MAX(drawsize.width + 1,_fYAxisWidth);
    
    strValue = NStringOfULong(_nMaxVol);
    drawsize = [strValue sizeWithFont:drawfont];
    _fYAxisWidth = MAX(_fYAxisWidth, drawsize.width + 1);
    
    if (_bShowLeftPriceInSide)
        _fYAxisWidth = 0;
#ifdef TZT_ZYData
    long lFundFlowsLeft = [_tztFundFlows GetLeftMargin];
    _fYAxisWidth = MAX(lFundFlowsLeft, _fYAxisWidth);
    _tztFundFlows.fLeftWidth = _fYAxisWidth;
#endif
    
    
    _TrendDrawRect = CGRectInset(rect,_fYAxisWidth,2);
    
    _TrendDrawRect.size.width += _fYAxisWidth;
    
    CGFloat fHideWidth = 0;
    if(!_bHide)
    {
        fHideWidth = (rect.size.width) * 0.35f;
        if (_nPriceViewWidth > 0)
        {
            fHideWidth = _nPriceViewWidth;
        }
        if(IS_TZTIPAD)
        {
            fHideWidth = MIN(fHideWidth, 200); 
        }
        _TrendDrawRect.size.width -= fHideWidth;
    }
    
    CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextSetLineWidth(context, .5f);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    CGContextStrokePath(context); 
    
   
    if (!_bHideFundFlows)
    {
        _FundFlowsRect = CGRectZero;
        _FundFlowsRect.size.height = _TrendDrawRect.size.height * 1 / 3;
        _FundFlowsRect.origin.y = _TrendDrawRect.origin.y + _TrendDrawRect.size.height - _FundFlowsRect.size.height;
        _FundFlowsRect.size.width = _TrendDrawRect.size.width + _TrendDrawRect.origin.x;
        _FundFlowsRect.size.height -= tztParamHeight;
    }
    
    if (!_bHideVolume)
    {
        _VolDrawRect = _TrendDrawRect;
        _VolDrawRect.size.height = _VolDrawRect.size.height * 1 / 3;
        _TrendDrawRect.size.height -= _VolDrawRect.size.height;
        
        _VolDrawRect.origin.y += _TrendDrawRect.size.height;
        
        _VolParamRect = _VolDrawRect;
        _VolParamRect.size.height = tztParamHeight;
        
        if (_bHiddenTime)
        {
//            _VolDrawRect.origin.y += 2;
//            _VolParamRect.size.height = tztParamHeight / 5;
//            _VolDrawRect.size.height -= (tztParamHeight / 5);
        }
        else
        {
            _VolDrawRect.origin.y += tztParamHeight;
            _VolDrawRect.size.height -= (tztParamHeight + tztParamHeight / 2);
        }
        
    }
    else
    {
        _TrendDrawRect.size.height -= tztParamHeight;
        _VolDrawRect = _TrendDrawRect;
        _VolDrawRect.origin.y += _TrendDrawRect.size.height;
        _VolDrawRect.size.height = 0;
    }
    if (_tztFundFlows && !_tztFundFlows.hidden) 
    {
        _tztFundFlows.frame = _FundFlowsRect;
        [_tztFundFlows setNeedsDisplay];
    }
    
    _tztPriceView.hidden = _bHide;
    _PriceDrawRect = CGRectZero;
    if(!_bHide)
    {
        _PriceDrawRect = _TrendDrawRect;
        _PriceDrawRect.size.width = fHideWidth - 2;
        _PriceDrawRect.origin.x += _TrendDrawRect.size.width + 1;
        _PriceDrawRect.size.height = CGRectGetMaxY(_VolDrawRect)-_PriceDrawRect.origin.y;
        [_tztPriceView setFrame:_PriceDrawRect];
        [_tztPriceView setNeedsDisplay];
        
        CGRect rc = _PriceDrawRect;
        rc.origin.y += rc.size.height + 3;
        rc.size.height = self.frame.size.height - CGRectGetHeight(_PriceDrawRect);
        _pBtnDetail.frame = rc;
        _pBtnNoRights.frame = rc;
    }
   
    //绘制竖线
    static CGFloat dashLengths[3] = {3, 3, 2};
    CGPoint drawpoint = _TrendDrawRect.origin;
//    for (int i = 0; i < 5; i++)
//    {
//        if(i % 2)
//        {
//            CGContextSaveGState(context);
//            CGContextSetLineDash(context, 0.0, dashLengths, 2);
//            
//            CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(_TrendDrawRect));
//            CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(_TrendDrawRect));
//            
//            CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(_VolDrawRect));
//            CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(_VolDrawRect));
//            
//            CGContextStrokePath(context); 
//            
//            CGContextRestoreGState(context);
//        }
//        else
//        {
//            CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(_TrendDrawRect));
//            CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(_TrendDrawRect));
//            
//            CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(_VolDrawRect));
//            CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(_VolDrawRect));
//            CGContextStrokePath(context);
//        }
//        drawpoint.x += CGRectGetWidth(_TrendDrawRect) / 4;
//    }

    
    CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(_TrendDrawRect));
    CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(_TrendDrawRect));
    
    CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(_VolDrawRect));
    CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(_VolDrawRect));
    CGContextStrokePath(context);
    
    /*计算位置*/
    NSArray* ay = [self.trendTimes componentsSeparatedByString:@"|"];
    long nCount = 0;
    CGFloat fDiffWidth = CGRectGetWidth(_TrendDrawRect)/(_nMaxCount-1);
    
    for (int i = 0; i < [ay count] && nCount <= _nMaxCount ; i+=2)
    {
        NSString* strBegin = [ay objectAtIndex:(i+0)];
        long lbegintime = [self getTimeData:strBegin];
        if (ay.count <= i+1)
            break;
        NSString* strEnd = [ay objectAtIndex:(i+1)];
        long lendtime = [self getTimeData:strEnd];
        
        
        NSInteger nTimeCount = 0;
        //        if (i > 0)
        {
            if(lendtime > lbegintime)
            {
                nTimeCount = (lendtime - lbegintime);
                nCount += (lendtime-lbegintime);
            }
            else //跨越24点
            {
                nTimeCount = (24*60 - lbegintime) + lendtime;
                nCount += (24*60 - lbegintime) + lendtime;
            }
        }
        
        CGPoint drawpoint = _VolDrawRect.origin;
        drawpoint.y = CGRectGetMaxY(_VolDrawRect);
        drawpoint.x = CGRectGetMinX(_VolDrawRect) + (fDiffWidth*nCount);
        
        CGPoint drawDashPoint = drawpoint;
        float fLeft =  drawDashPoint.x - (fDiffWidth * nTimeCount);
        
        NSInteger nCount = nTimeCount / 60;
        if (nCount > 2)
            nCount = 2;
        
        NSInteger nSteps = (nTimeCount - nTimeCount % 60) / 2;
        
        for (int j = 0; j < nCount; j++)
        {
            drawDashPoint.x = fLeft + ((j+1) * nSteps * fDiffWidth);
            
            CGContextSaveGState(context);
            CGContextSetLineDash(context, 0.0, dashLengths, 2);
            CGContextMoveToPoint(context, drawDashPoint.x, CGRectGetMinY(_TrendDrawRect));
            CGContextAddLineToPoint(context, drawDashPoint.x, CGRectGetMaxY(_TrendDrawRect));
            CGContextMoveToPoint(context, drawDashPoint.x, CGRectGetMinY(_VolDrawRect));
            CGContextAddLineToPoint(context, drawDashPoint.x, CGRectGetMaxY(_VolDrawRect));
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
        }
        
        CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(_TrendDrawRect));
        CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(_TrendDrawRect));
        
        CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(_VolDrawRect));
        CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(_VolDrawRect));
        CGContextStrokePath(context);
        
        //        drawpoint.x = CGRectGetMinX(_TrendDrawRect) + (fDiffWidth*nCount);
    }
    
    for (int i = 0; i < 5; i++)
    {
        //绘制横线
        if (i == 2)
        {
            CGContextSaveGState(context);
            CGContextSetLineDash(context, 0.0, dashLengths, 2);
            
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextMoveToPoint(context, CGRectGetMinX(_TrendDrawRect),drawpoint.y);
            CGContextAddLineToPoint(context, CGRectGetMaxX(_TrendDrawRect), drawpoint.y);
            
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
        }
        else
            CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
        
        CGContextMoveToPoint(context, CGRectGetMinX(_TrendDrawRect),drawpoint.y);
        CGContextAddLineToPoint(context, CGRectGetMaxX(_TrendDrawRect), drawpoint.y);
        CGContextStrokePath(context);
        drawpoint.y += CGRectGetHeight(_TrendDrawRect) / 4;
    }
    
    CGContextMoveToPoint(context, CGRectGetMinX(_VolDrawRect), CGRectGetMinY(_VolDrawRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(_VolDrawRect), CGRectGetMinY(_VolDrawRect));
    
    CGContextMoveToPoint(context, CGRectGetMinX(_VolDrawRect), CGRectGetMidY(_VolDrawRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(_VolDrawRect), CGRectGetMidY(_VolDrawRect));
    
    CGContextMoveToPoint(context, CGRectGetMinX(_VolDrawRect), CGRectGetMaxY(_VolDrawRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(_VolDrawRect), CGRectGetMaxY(_VolDrawRect));
    CGContextStrokePath(context);
    
    return TRUE;
}

- (void)onDrawLead:(CGContextRef)context
{
    
}

//绘制分时图
- (void)onDrawTrend:(CGContextRef)context
{
    CGFloat fDiffWidth = CGRectGetWidth(_TrendDrawRect)/(_nMaxCount-1);
    CGPoint drawpoint = _TrendDrawRect.origin;
    UIColor* drawcolor;
    //    int nBeginPos = 
    //绘制Lead指标
    if (![self.nsBackColor intValue] && _bShowLeadLine)
    {
        for (int i = 0; i < [_ayTrendValues count]; i++)
        {
            tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:i];
            if(trendvalue.nLead == INT32_MAX)
                break;
            drawpoint.y = [self ValueToVertPos:_TrendDrawRect diff:trendvalue.nLead maxdiff:100];
            if(trendvalue.nLead >=0 )
                drawcolor = [UIColor tztThemeHQUpColor];
            else
                drawcolor = [UIColor tztThemeHQDownColor];
            
            CGContextSetStrokeColorWithColor(context, drawcolor.CGColor);
            CGContextMoveToPoint(context, drawpoint.x, CGRectGetMidY(_TrendDrawRect));
            CGContextAddLineToPoint(context, drawpoint.x, drawpoint.y);
            CGContextStrokePath(context);
            
            drawpoint.x += fDiffWidth;
        }
    }
    
    long nMaxDiff = GetMaxDiff(_TrendHead->nPreClosePrice,_TrendHead->nMaxPrice,_TrendHead->nMinPrice) * 2;
    
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    if ([self.nsBackColor intValue])
    {
        //140, 184,218
        balanceColor = [UIColor colorWithRed:57.f/255.f green:137.f/255.f blue:203.f/255.f alpha:1.0f];
    }
    
    //绘制最新价
    drawcolor = balanceColor;
    
    if (self.bHideVolume)
    {
        drawcolor = [UIColor colorWithRGBULong:0xc5c5c5];
    }
    
    if ([UIColor tztThemeTrendLineColor])
        drawcolor = [UIColor tztThemeTrendLineColor];
    
    CGContextSetStrokeColorWithColor(context, drawcolor.CGColor);
    BOOL bfrist = TRUE;
    
    [self drawTrendPrice:context fDiffWidth:fDiffWidth nMaxDiff:nMaxDiff bFirst:TRUE];
//    return;
    drawpoint.x = _TrendDrawRect.origin.x;
    CGContextSetLineWidth(context, 1.0f);
    for (int i = 0; i < [_ayTrendValues count]; i++)
    {
        tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:i];
        if([trendvalue isVaild])
        {
            drawpoint.y = CGRectGetMidY(_TrendDrawRect);
            if (trendvalue.ulClosePrice != UINT32_MAX) 
            {
                drawpoint.y = [self ValueToVertPos:_TrendDrawRect diff:(trendvalue.ulClosePrice -_TrendHead->nPreClosePrice) maxdiff:nMaxDiff];
            }
            
            if(bfrist)
            {
                CGContextMoveToPoint(context, drawpoint.x, drawpoint.y);
                bfrist = FALSE;
            }
            else
            {
                CGContextAddLineToPoint(context, drawpoint.x, drawpoint.y);
                CGContextStrokePath(context);
                CGContextMoveToPoint(context, drawpoint.x, drawpoint.y);
            }
            
//            NSArray *colors = [NSArray arrayWithObjects:
//                               [UIColor colorWithRed:141.0 / 255.0 green:189.0 / 255.0 blue:227.0 / 255.0 alpha:1.0],
//                               [UIColor colorWithRed:244.0 / 255.0 green:244.0 / 255.0 blue:244.0 / 255.0 alpha:1.0],
//                               nil];
//            [self _drawGradientColor:context
//                                rect:CGRectMake(drawpoint.x, drawpoint.y, 1+ fDiffWidth, _TrendDrawRect.size.height - drawpoint.y)
//                             options:kCGGradientDrawsAfterEndLocation
//                              colors:colors];
        }
        drawpoint.x += fDiffWidth;
    }
    
//    if ([self.nsBackColor intValue])
//        return;
    
    if (MakeIndexMarket(self.pStockInfo.stockType) && ![self.pStockInfo.stockCode hasPrefix:@"1A0001"] && ![self.pStockInfo.stockCode hasPrefix:@"2A01"] )
    {
        return;
    }
    
    if (!_bShowAvgPriceLine)
        return;
    //绘制均价
    drawcolor = [UIColor colorWithTztRGBStr:@"255,180,21"];
    CGContextSetStrokeColorWithColor(context, drawcolor.CGColor);
    bfrist = TRUE;
    drawpoint.x = _TrendDrawRect.origin.x;
    for (int i = 0; i < [_ayTrendValues count]; i++)
    {
        tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:i];
        if([trendvalue isVaild])
        {
            drawpoint.y = CGRectGetMidY(_TrendDrawRect);
            if (trendvalue.ulAvgPrice != UINT32_MAX && trendvalue.ulAvgPrice > 0)
            {
                drawpoint.y = [self ValueToVertPos:_TrendDrawRect diff:(trendvalue.ulAvgPrice -_TrendHead->nPreClosePrice) maxdiff:nMaxDiff];
            }
            
            if(bfrist)
            {
                CGContextMoveToPoint(context, drawpoint.x, drawpoint.y);
                bfrist = FALSE;
            }
            else
            {
                CGContextAddLineToPoint(context, drawpoint.x, drawpoint.y);
                CGContextStrokePath(context);
                CGContextMoveToPoint(context, drawpoint.x, drawpoint.y);
            }
        }
        drawpoint.x += fDiffWidth;
    }
    
}

-(void)drawTrendPrice:(CGContextRef)context
           fDiffWidth:(float)fDiffWidth
             nMaxDiff:(float)nMaxDiff
               bFirst:(BOOL)bfrist
{
    if (_ayTrendValues.count <= 0)
        return;
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1);
    CGPoint start, end;
    
    end.y = 0;// -MAXFLOAT * YAxisInvertFlag;
    // 开始路径
    CGContextBeginPath(context);
    
    CGPoint drawpoint;
    drawpoint.x = _TrendDrawRect.origin.x;
    end.y = [self ValueToVertPos:_TrendDrawRect diff:nMaxDiff maxdiff:nMaxDiff];
    for (int i = 0; i < [_ayTrendValues count]; i++)
    {
        tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:i];
        if([trendvalue isVaild])
        {
            if (trendvalue.ulClosePrice != UINT32_MAX)
            {
                drawpoint.y = [self ValueToVertPos:_TrendDrawRect diff:(trendvalue.ulClosePrice -_TrendHead->nPreClosePrice) maxdiff:nMaxDiff];
            }
            if (i == 0)
            {
                CGContextMoveToPoint(context, drawpoint.x, drawpoint.y);
                
                start = drawpoint;
                start.y = _TrendDrawRect.origin.y;
                end.x = start.x;
            }
            
//            if (drawpoint.y < end.y)
//                end.y = drawpoint.y;
            
            CGContextAddLineToPoint(context, drawpoint.x, drawpoint.y);
            
            // 填充区域闭合点
            if (i == ([_ayTrendValues count] - 1))
            {
                end.y = _TrendDrawRect.origin.y + _TrendDrawRect.size.height;
//                end.y = _TrendDrawRect.origin.y + _TrendDrawRect.size.height;
                CGContextAddLineToPoint(context, drawpoint.x, end.y);
            }
            
        }
        drawpoint.x += fDiffWidth;
    }
    
    CGContextAddLineToPoint(context, _TrendDrawRect.origin.x + _TrendDrawRect.size.height, _TrendDrawRect.origin.y + _TrendDrawRect.size.height);
    CGContextAddLineToPoint(context, _TrendDrawRect.origin.x, _TrendDrawRect.origin.y + _TrendDrawRect.size.height);
    
    // 闭合路径
    CGContextClosePath(context);
    
    // 重要，根据path剪裁填充区域，否则填充整个目标矩形。
    CGContextClip(context);
    
    // 填充边界处理，默认为0
    CGGradientDrawingOptions options = 0;
//    options |= kCGGradientDrawsBeforeStartLocation;
    options |= kCGGradientDrawsAfterEndLocation;
    // 创建填充色彩空间
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    UIColor *grandColor1 = [UIColor tztThemeTrendGradientColor];
    UIColor *grandColor2 = [UIColor tztThemeTrendGradientColorEx];
    
    CGFloat fRed1 = 140.f/255.f, fGreen1 = 193.f/255.f, fBlue1 = 238.f/255.f, fAlpha1 = 0.7f;
    CGFloat fRed2 = 233.f/255.f, fGreen2 = 241.f/255.f, fBlue2 = 247.f/255.f, fAlpha2 = 0.7f;
    if (grandColor1)
    {
        [grandColor1 getRed:&fRed1 green:&fGreen1 blue:&fBlue1 alpha:&fAlpha1];
    }
    if (grandColor2)
    {
        [grandColor2 getRed:&fRed2 green:&fGreen2 blue:&fBlue2 alpha:&fAlpha2];
    }
    
    // 填充颜色梯度
    CGFloat gradientColors[] =
    {
        fRed1, fGreen1, fBlue1, fAlpha1, // red
        fRed2, fGreen2, fBlue2, fAlpha2, // orange
    };
    
    static CGFloat const gradientColorsEx[] = {
        37.f/255.f,37.f/255.f,37.f/255.f,0.8,
        48.f/255.f,48.f/255.f,48.f/255.f,0.8,
    };
    
    // 创建填充实例
    CGGradientRef gradient = nil;
    
    if (g_nSkinType == 0)
    {
        gradient = CGGradientCreateWithColorComponents(
                                                       rgb,
                                                       gradientColors,
                                                       NULL,   // 使用默认的[0-1]
                                                       sizeof(gradientColors)/(sizeof(gradientColors[0])*4)
                                                       );
    }
    else
    {
        if (g_nHQBackBlackColor)
        {
            gradient = CGGradientCreateWithColorComponents(
                                                           rgb,
                                                           gradientColorsEx,
                                                           NULL,   // 使用默认的[0-1]
                                                           sizeof(gradientColors)/(sizeof(gradientColors[0])*4)
                                                           );
        }
        else
         gradient = CGGradientCreateWithColorComponents(
                                                rgb,
                                                gradientColors,
                                                NULL,   // 使用默认的[0-1]
                                                sizeof(gradientColors)/(sizeof(gradientColors[0])*4)
                                                );
    }
    CGColorSpaceRelease(rgb);
    rgb = NULL;
    
    // 线性填充
    CGContextDrawLinearGradient(context, gradient, start, end, options);
//    CGContextDrawLinearGradient(context, gradient, _TrendDrawRect.origin, CGPointMake(_TrendDrawRect.origin.x + _TrendDrawRect.size.width, _TrendDrawRect.origin.y + _TrendDrawRect.size.height), options);
    
    // 释放
    CGGradientRelease(gradient);
    gradient = NULL;
    
    // 普通填充
//    CGContextStrokePath(context);
//    CGContextFillPath(context);
//    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
}

/**
 * 绘制背景色渐变的矩形，p_colors渐变颜色设置，集合中存储UIColor对象（创建Color时一定用三原色来创建）
 **/
- (void)_drawGradientColor:(CGContextRef)p_context
                      rect:(CGRect)p_clipRect
                   options:(CGGradientDrawingOptions)p_options
                    colors:(NSArray *)p_colors {
    CGContextSaveGState(p_context);// 保持住现在的context
    CGContextClipToRect(p_context, p_clipRect);// 截取对应的context
    NSInteger colorCount = p_colors.count;
    int numOfComponents = 4;
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[colorCount * numOfComponents];
    for (int i = 0; i < colorCount; i++) {
        UIColor *color = p_colors[i];
        CGColorRef temcolorRef = color.CGColor;
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < numOfComponents; ++j) {
            colorComponents[i * numOfComponents + j] = components[j];
        }
    }
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, colorCount);
    CGColorSpaceRelease(rgb);
    CGPoint startPoint = p_clipRect.origin;
    CGPoint endPoint = CGPointMake(CGRectGetMinX(p_clipRect), CGRectGetMaxY(p_clipRect));
    CGContextDrawLinearGradient(p_context, gradient, startPoint, endPoint, p_options);
    CGGradientRelease(gradient);
    CGContextRestoreGState(p_context);// 恢复到之前的context
}

//绘制分时指标图
- (void)onDrawVol:(CGContextRef)context
{
    if(_nMaxVol == 0)
        return;
    //量
    CGFloat fDiffWidth = CGRectGetWidth(_VolDrawRect)/(_nMaxCount-1);
    UIColor* drawcolor = [UIColor tztThemeHQUpColor];
    //绘制纵坐标
    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;//tztUIBaseViewTextFont([tztTechSetting getInstance].drawTxtSize - 2.f);//
    //最大值
    CGContextSetFillColorWithColor(context, drawcolor.CGColor);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    NSString* strValue = NStringOfULong(_nMaxVol);
    CGSize drawsize = [strValue sizeWithFont:drawFont];
    
    CGPoint drawpoint = _VolDrawRect.origin;
    drawpoint.x -= drawsize.width;
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    
    drawpoint.x = _VolDrawRect.origin.x;
    for (int i = 0; i < [_ayTrendValues count]; i++)
    {
        tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:i];
        if([trendvalue isVaild])
        {
            if(i > 0)
            {
                tztTrendValue* pretrendvalue = [_ayTrendValues objectAtIndex:(i-1)];
                if(pretrendvalue.ulClosePrice <= trendvalue.ulClosePrice)
                {
                    drawcolor = [UIColor tztThemeHQUpColor];
                }
                else if(pretrendvalue.ulClosePrice > trendvalue.ulClosePrice)
                {
                    drawcolor = [UIColor tztThemeHQDownColor];
                }
            }
            
            drawpoint.y = [self ValueToVertPos:_VolDrawRect  lValue:trendvalue.nTotal_h MaxValue:_nMaxVol];
            CGContextSetStrokeColorWithColor(context, drawcolor.CGColor);
            CGContextMoveToPoint(context, drawpoint.x, CGRectGetMaxY(_VolDrawRect));
            CGContextAddLineToPoint(context, drawpoint.x, drawpoint.y);
            CGContextStrokePath(context);
        }
        drawpoint.x += fDiffWidth;
    }
    
    //持仓线    
    if(_nMaxChiCangL != 0)
    {
        BOOL bfirst = TRUE;
        drawpoint.x = _VolDrawRect.origin.x;
        drawcolor = [UIColor tztThemeHQBalanceColor];
        CGContextSetStrokeColorWithColor(context, drawcolor.CGColor);
        for (int i = 0; i < [_ayTrendValues count]; i++)
        {
            tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:i];
            if([trendvalue isVaild])
            {
                drawpoint.y = [self ValueToVertPos:_VolDrawRect  lValue:(trendvalue.nChiCangL-_nMinChiCangL) MaxValue:(_nMaxChiCangL - _nMinChiCangL)];
                if(bfirst)
                {
                    CGContextMoveToPoint(context,  drawpoint.x, drawpoint.y);
                    bfirst = FALSE;
                }
                else
                {
                    CGContextAddLineToPoint(context,  drawpoint.x, drawpoint.y);
                }
            }
            drawpoint.x += fDiffWidth;
        }
        CGContextStrokePath(context);
    }
    
    //
    if (self.bSupportTrendCursor && (_bTrendDrawCursor || !_bHiddenTime))
    {
        NSInteger nMaxData = [_ayTrendValues count];
        if(nMaxData > 0 && _TrendHead->nPreClosePrice != 0)
        {
            if(_TrendCurIndex < 0)
                _TrendCurIndex = 0;
            
            if(_TrendCurIndex >= nMaxData)
                _TrendCurIndex = nMaxData - 1;
            
            tztTrendValue* trendValue = [_ayTrendValues objectAtIndex:_TrendCurIndex];
            if([trendValue isVaild])
            {
                if(_TrendCurIndex > 0)
                {
                    tztTrendValue* pretrendvalue = [_ayTrendValues objectAtIndex:(_TrendCurIndex-1)];
                    if(pretrendvalue.ulClosePrice <= trendValue.ulClosePrice)
                    {
                        drawcolor = [UIColor tztThemeHQUpColor];
                    }
                    else if(pretrendvalue.ulClosePrice > trendValue.ulClosePrice)
                    {
                        drawcolor = [UIColor tztThemeHQDownColor];
                    }
                }
            }
            
            CGRect rcVolume = _TrendDrawRect;
            rcVolume.size.height = drawFont.lineHeight + 4;
            rcVolume.origin.y += _TrendDrawRect.size.height + (tztParamHeight - rcVolume.size.height) / 2;
            NSString* strValueVol = @"分时量";
            int nWidth = [strValueVol sizeWithFont:drawFont].width;
            rcVolume.size.width = nWidth + 4;
            
            
            UIColor *pColorRound = [[UIColor tztThemeHQBalanceColor] colorWithAlphaComponent:0.4f];
            CGContextSetFillColorWithColor(context, pColorRound.CGColor);
            CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
            CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(rcVolume.origin.x,rcVolume.origin.y, rcVolume.size.width, rcVolume.size.height) cornerRadius:2.5f].CGPath;
            CGContextAddPath(context, clippath);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
            
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            rcVolume.origin.y += (rcVolume.size.height - drawFont.lineHeight) / 2;
            [strValueVol drawInRect:rcVolume withFont:drawFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
//            [strValueVol drawInRect:rcVolume withFont:drawFont lineBreakMode:NSLineBreakByTruncatingTail];
            
            CGRect rc = _TrendDrawRect;
            rc.origin.x += rcVolume.size.width + 5;
            rc.origin.y  += _TrendDrawRect.size.height + 2;
            rc.size.height = tztParamHeight - 4;
            
            NSString* strValue = @"量:";
            nWidth = [strValue sizeWithFont:drawFont].width;
            CGRect rcEx = rc;
            rcEx.size.width = nWidth;
            UIColor *pColor = [UIColor tztThemeHQBalanceColor];
            CGContextSetFillColorWithColor(context, pColor.CGColor);
            rcEx.origin.y += (rcEx.size.height - drawFont.lineHeight) / 2;
            [strValue drawInRect:rcEx withFont:drawFont lineBreakMode:NSLineBreakByTruncatingTail];
            
            strValue = NStringOfULong(trendValue.nTotal_h);
            rc.origin.x += rcEx.size.width + 2;
            rc.size.width -= (rcEx.size.width + 2);
            CGContextSetFillColorWithColor(context, pColor.CGColor);
            CGContextSetFillColorWithColor(context, drawcolor.CGColor);
            rc.origin.y += (rc.size.height - drawFont.lineHeight) / 2;
            [strValue drawInRect:rc withFont:drawFont lineBreakMode:NSLineBreakByTruncatingTail];
        }
    }
}

- (void)onDrawCursorEx:(CGContextRef)context andIndex:(NSInteger)nIndex
{
    return;
    NSInteger nValueCount = [_ayTrendValues count];
//    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
    UIColor* drawColor = [UIColor tztThemeHQCursorColor];// [tztTechSetting getInstance].cursorColor;
    if ([self.nsBackColor intValue])
    {
        drawColor = [UIColor grayColor];
    }
    
    if(nValueCount > 0 && nValueCount != _nMaxCount)
    {
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, drawColor.CGColor);
        
        CGPoint cursor = CGPointZero;
        nIndex = nValueCount - 1;
        if (nIndex <= 0)
        {
            nIndex = 0;
            cursor.x = CGRectGetMinX(_TrendDrawRect);;
        }
        else
        {
            cursor.x = CGRectGetMinX(_TrendDrawRect)+ (nIndex) * CGRectGetWidth(_TrendDrawRect) / (_nMaxCount-1);
        }
        
        long nMaxDiff = GetMaxDiff(_TrendHead->nPreClosePrice,_TrendHead->nMaxPrice,_TrendHead->nMinPrice);
        tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:nIndex];
        if([trendvalue isVaild])
        {
            if (trendvalue.ulClosePrice != UINT32_MAX)
            {
                cursor.y = [self ValueToVertPos:_TrendDrawRect diff:(trendvalue.ulClosePrice -_TrendHead->nPreClosePrice) maxdiff:nMaxDiff*2];
            }
        }
        
        CGContextSaveGState(context);
        
        //绘制一个小圆
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, cursor.x, cursor.y);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:44/255.f green:155/255.f blue:218/255.f alpha:1.0].CGColor);
        CGContextAddArc(context, cursor.x, cursor.y, 3.f,  2* M_PI, 0* M_PI/ 180, 1);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
    }
}
//十字光标线
- (void)onDrawCursor:(CGContextRef)context
{
    NSInteger nValueCount = [_ayTrendValues count];
    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
    UIColor* drawColor = [UIColor tztThemeHQCursorColor];// [tztTechSetting getInstance].cursorColor;
    if ([self.nsBackColor intValue])
    {
        drawColor = [UIColor grayColor];
    }
    
    if(nValueCount > 0)
    {
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, drawColor.CGColor);
        
        _TrendCurIndex = (_TrendCursor.x - CGRectGetMinX(_TrendDrawRect) ) * _nMaxCount / CGRectGetWidth(_TrendDrawRect);
        if (_TrendCurIndex <= 0)
        {
            _TrendCurIndex = 0;
            _TrendCursor.x = CGRectGetMinX(_TrendDrawRect);
        }
        else if(_TrendCurIndex >= nValueCount)
        {
            _TrendCurIndex = nValueCount -1;
            _TrendCursor.x = CGRectGetMinX(_TrendDrawRect)+ (_TrendCurIndex) * CGRectGetWidth(_TrendDrawRect) / (_nMaxCount-1);
        }
        
        if (_TrendCursor.x >= CGRectGetMinX(_TrendDrawRect) && _TrendCursor.x <= CGRectGetMaxX(_TrendDrawRect)) 
        {
            CGContextMoveToPoint(context, _TrendCursor.x, CGRectGetMinY(_TrendDrawRect));
            CGContextAddLineToPoint(context, _TrendCursor.x, CGRectGetMaxY(_TrendDrawRect));
            
            CGContextMoveToPoint(context, _TrendCursor.x, CGRectGetMinY(_VolDrawRect));
            CGContextAddLineToPoint(context, _TrendCursor.x, CGRectGetMaxY(_VolDrawRect));
            CGContextStrokePath(context);
            
            CGPoint drawPoint = _VolDrawRect.origin;
            UIColor* AxisColor = [UIColor tztThemeHQCursorTextColor];// [tztTechSetting getInstance].axisTxtColor;
            CGContextSetFillColorWithColor(context, AxisColor.CGColor);
            NSString* strValue = [self getstrTimeofPos:_TrendCurIndex];
            CGSize valuesize = [strValue sizeWithFont:drawFont];
            drawPoint.y = CGRectGetMaxY(_VolDrawRect);
            drawPoint.x = CGRectGetMinX(_VolDrawRect) + _TrendCurIndex * CGRectGetWidth(_VolDrawRect)/(_nMaxCount-1)- valuesize.width/2;
            if (drawPoint.x <= CGRectGetMinX(_VolDrawRect))
            {
                drawPoint.x = CGRectGetMinX(_VolDrawRect);
            }
            else if(drawPoint.x+valuesize.width >= CGRectGetMaxX(_VolDrawRect))
            {
                drawPoint.x = CGRectGetMaxX(_VolDrawRect) - valuesize.width; 
            }
            
            CGRect backRect = CGRectMake(drawPoint.x, drawPoint.y, valuesize.width, valuesize.height);
//            backRect = CGRectInset(backRect,-1,-1);
            CGContextSetAlpha(context, 1.f);
//            UIColor* TipGridColor = [UIColor tztThemeHQHideGridColor];
            UIColor* TipBackColor = [UIColor tztThemeHQCursorBackColor];//
            CGContextSaveGState(context);
            CGContextSetStrokeColorWithColor(context, TipBackColor.CGColor);
            CGContextSetFillColorWithColor(context, TipBackColor.CGColor);
            
            CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:backRect cornerRadius:2.5f].CGPath;
            CGContextAddPath(context, clippath);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
            [strValue drawInRect:backRect
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByTruncatingTail
                       alignment:NSTextAlignmentCenter];
        }
        
//        if(_TrendCursor.y >= CGRectGetMinY(_TrendDrawRect) && _TrendCursor.y <= CGRectGetMaxY(_TrendDrawRect) )
        {
            long nMaxDiff = GetMaxDiff(_TrendHead->nPreClosePrice,_TrendHead->nMaxPrice,_TrendHead->nMinPrice);
            
            UIColor* AxisColor = [UIColor tztThemeHQAxisTextColor];// [tztTechSetting getInstance].axisTxtColor;
            
            CGContextSaveGState(context);
            CGContextSetStrokeColorWithColor(context, drawColor.CGColor);
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            
            tztTrendValue* trendvalue = [_ayTrendValues objectAtIndex:_TrendCurIndex];
            if([trendvalue isVaild])
            {
                if (trendvalue.ulClosePrice != UINT32_MAX)
                {
                    _TrendCursor.y = [self ValueToVertPos:_TrendDrawRect diff:(trendvalue.ulClosePrice -_TrendHead->nPreClosePrice) maxdiff:nMaxDiff*2];
                }
            }
            
            
            CGContextMoveToPoint(context, CGRectGetMinX(_TrendDrawRect), _TrendCursor.y);
            CGContextAddLineToPoint(context, CGRectGetMaxX(_TrendDrawRect), _TrendCursor.y);
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
            
            CGContextSaveGState(context);
            
            //绘制一个小圆
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, _TrendCursor.x, _TrendCursor.y);
            CGContextSetFillColorWithColor(context, [UIColor colorWithRed:44/255.f green:155/255.f blue:218/255.f alpha:1.0].CGColor);
            CGContextAddArc(context, _TrendCursor.x, _TrendCursor.y, 3.f,  2* M_PI, 0* M_PI/ 180, 1);
            CGContextFillPath(context);
            //        CGContextStrokePath(context);
            //        CGContextRestoreGState(context);
//            //绘制一个小圆
//            CGContextMoveToPoint(context, _TrendCursor.x, _TrendCursor.y);
//            CGContextSetFillColorWithColor(context, [UIColor colorWithRed:44/255.f green:155/255.f blue:218/255.f alpha:1.0].CGColor);
//            CGContextAddArc(context, _TrendCursor.x, _TrendCursor.y, 3.f,  360* M_PI/ 180, 0* M_PI/ 180, 0);
//            CGContextFillPath(context);
//            CGContextRestoreGState(context);

            //
//            UIImage *image = [UIImage imageTztNamed:@"TZTChina@2x.png"];
//            CALayer *layer = [CALayer layer];
//            layer.contents = (id)image.CGImage;
//            layer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
//            layer.position = CGPointMake(160, 200);
//
//            layer.transform = CATransform3DMakeScale(0., 0.45, 1);  // 将图片大小按照X轴和Y轴缩放90%，永久
//            [self.layer addSublayer:layer];
//
//            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity]; // 将目标值设为原值
//            animation.autoreverses = YES; // 自动倒回最初效果
//            animation.duration = 3;
//            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            animation.repeatCount = HUGE_VALF;
//            [layer addAnimation:animation forKey:@"pulseAnimation"];
            
//            CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//            
//            self.animationDuration = 3;
//            self.animationGroup = [CAAnimationGroup animation];
//            self.animationGroup.duration = self.animationDuration + self.pulseInterval;
//            self.animationGroup.repeatCount = INFINITY;
//            self.animationGroup.removedOnCompletion = NO;
//            self.animationGroup.timingFunction = defaultCurve;
//            
//            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
//            scaleAnimation.fromValue = @0.0;
//            scaleAnimation.toValue = @1.0;
//            scaleAnimation.duration = self.animationDuration;
//            
//            CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//            opacityAnimation.duration = self.animationDuration;
//            opacityAnimation.values = @[@0, @0.45, @2];
//            opacityAnimation.keyTimes = @[@0, @0.2, @1];
//            opacityAnimation.removedOnCompletion = NO;
//            
//            NSArray *animations = @[scaleAnimation, opacityAnimation];
//            
//            self.animationGroup.animations = animations;
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^(void) {
//                
//                [self.layer addAnimation:self.animationGroup forKey:@"pulse"];
//            });
            
            
            _TrendCursorValue = _TrendHead->nPreClosePrice
            - (_TrendCursor.y - CGRectGetMidY(_TrendDrawRect)) * nMaxDiff * 2 / (CGRectGetHeight(_TrendDrawRect));//对应值
            
            //国金固定颜色
//            if(_TrendCursor.y < CGRectGetMidY(_TrendDrawRect))
//            {
//                AxisColor = [UIColor tztThemeHQDownColor];
//            }
//            else if(_TrendCursor.y > CGRectGetMidY(_TrendDrawRect))
//            {
//                AxisColor = [UIColor tztThemeHQUpColor];
//            }
//            else
//            {
//                AxisColor = [UIColor tztThemeHQBalanceColor];
//            }
            AxisColor = [UIColor tztThemeHQCursorTextColor];
            CGContextSetFillColorWithColor(context, AxisColor.CGColor);
            NSString* strValue = @"-";
            if(_bPercent)
            {
                strValue = [self getDiffPercent:(_TrendCursorValue-_TrendHead->nPreClosePrice)*100.0f maxdiff:_TrendHead->nPreClosePrice];
            }
            else
            {
                strValue = [self getValueString:_TrendCursorValue];
            }
            CGSize drawsize = [strValue sizeWithFont:drawFont];
            CGPoint drawpoint = _TrendDrawRect.origin;
            drawpoint.y = _TrendCursor.y - drawsize.height / 2;
            if(drawpoint.y < CGRectGetMinY(_TrendDrawRect))
            {
                drawpoint.y = CGRectGetMinY(_TrendDrawRect);
            }
            else if(drawpoint.y+drawsize.height > CGRectGetMaxY(_TrendDrawRect))
            {
                drawpoint.y = CGRectGetMaxY(_TrendDrawRect) - drawsize.height;
            }
            
            drawpoint.x = _TrendDrawRect.origin.x - _fYAxisWidth;
            if (_fYAxisWidth <= 0)
            {
                _fYAxisWidth = drawsize.width + 5;
            }
            CGRect backRect = CGRectMake(drawpoint.x, drawpoint.y, _fYAxisWidth, drawsize.height);
//            backRect = CGRectInset(backRect,0,-1);
            
//            UIColor* TipGridColor = [UIColor tztThemeHQHideGridColor];
            UIColor* TipBackColor = [UIColor tztThemeHQCursorBackColor];
//            if ([self.nsBackColor intValue])
//                TipBackColor = [UIColor whiteColor];
            CGContextSaveGState(context);
//            CGContextSetAlpha(context, 0.8);
            CGContextSetStrokeColorWithColor(context, TipBackColor.CGColor);
            CGContextSetFillColorWithColor(context, TipBackColor.CGColor);
            
            CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:backRect cornerRadius:2.5f].CGPath;
            CGContextAddPath(context, clippath);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFillStroke);
        
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
            
            drawpoint.x = _TrendDrawRect.origin.x - drawsize.width;
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:backRect
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByTruncatingTail
                       alignment:NSTextAlignmentCenter];
            
            
        }
//        else if(_TrendCursor.y >= CGRectGetMinY(_VolDrawRect) && _TrendCursor.y <= CGRectGetMaxY(_VolDrawRect) )
//        {
//            CGContextMoveToPoint(context, CGRectGetMinX(_VolDrawRect), _TrendCursor.y);
//            CGContextAddLineToPoint(context, CGRectGetMaxX(_VolDrawRect), _TrendCursor.y);
//            CGContextStrokePath(context);
//            
//            _TrendCursorValue = (CGRectGetMaxY(_VolDrawRect) - _TrendCursor.y) * _nMaxVol / (CGRectGetHeight(_VolDrawRect));//对应值
//            
//            UIColor* AxisColor = [UIColor tztThemeHQAxisTextColor];// [tztTechSetting getInstance].axisTxtColor;
//            CGContextSetFillColorWithColor(context, AxisColor.CGColor);
//            NSString* strValue = NStringOfULong(_TrendCursorValue);
//            CGSize drawsize = [strValue sizeWithFont:drawFont];
//            CGPoint drawpoint = _TrendDrawRect.origin;
//            
//            drawpoint.y = _TrendCursor.y - drawsize.height / 2;
//            if(drawpoint.y < CGRectGetMinY(_VolDrawRect))
//            {
//                drawpoint.y = CGRectGetMinY(_VolDrawRect);
//            }
//            else if(drawpoint.y+drawsize.height > CGRectGetMaxY(_VolDrawRect))
//            {
//                drawpoint.y = CGRectGetMaxY(_VolDrawRect) - drawsize.height;
//            }
//            
//            drawpoint.x = _TrendDrawRect.origin.x - _fYAxisWidth;
//            CGRect backRect = CGRectMake(drawpoint.x, drawpoint.y, _fYAxisWidth, drawsize.height);
//            backRect = CGRectInset(backRect,0,-1);
//            UIColor* TipGridColor = [UIColor tztThemeHQHideGridColor];
//            UIColor* TipBackColor = [UIColor tztThemeBackgroundColorHQ];
//            
//            CGContextSaveGState(context);
//            CGContextSetAlpha(context, 0.8);
//            CGContextSetStrokeColorWithColor(context, TipGridColor.CGColor);
//            CGContextSetFillColorWithColor(context, TipBackColor.CGColor);
//            CGContextAddRect(context, backRect);
//            CGContextDrawPath(context, kCGPathFillStroke);
//            CGContextStrokePath(context);
//            CGContextRestoreGState(context);
//            
//            drawpoint.x = _TrendDrawRect.origin.x - drawsize.width;
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
//        }
        CGContextRestoreGState(context);
    }
}

//绘制坐标
- (void)onDrawXAxis:(CGContextRef)context
{
    if (_bHiddenTime)
        return;
    //09:30|11:30|13:00|15:00|
    NSArray* ay = [_trendTimes componentsSeparatedByString:@"|"];
    long nCount = 0;
    CGFloat fDiffWidth = CGRectGetWidth(_VolDrawRect)/(_nMaxCount-1);
    if(ay && [ay count] > 0)
    {
        UIFont* drawFont = NULL;
//        if (self.bHideVolume)
//        {
//            drawFont =  tztUIBaseViewTextFont([tztTechSetting getInstance].drawTxtSize-2.5f);
//        }
//        else
//        {
//            drawFont = tztUIBaseViewTextFont([tztTechSetting getInstance].drawTxtSize-2.5f);
//        }
        drawFont = [tztTechSetting getInstance].drawTxtFont;
        
        UIColor* AxisColor = [UIColor tztThemeHQFixTextColor];//[tztTechSetting getInstance].axisTxtColor;
        if ([self.nsBackColor intValue])
            AxisColor = [UIColor tztThemeHQFixTextColor];
        
        CGContextSetFillColorWithColor(context, AxisColor.CGColor);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGFloat fPrePos = _VolDrawRect.origin.x;
        for (int i = 0; i < [ay count]  / 2 && nCount <= _nMaxCount ; i++)
        {
            NSString* strBegin = [ay objectAtIndex:(i*2+0)];
            long lbegintime = [self getTimeData:strBegin];
            NSString* strEnd = [ay objectAtIndex:(i*2+1)];
            long lendtime = [self getTimeData:strEnd];
            
            CGPoint drawpoint = _VolDrawRect.origin;
            drawpoint.y = CGRectGetMaxY(_VolDrawRect);
            drawpoint.x = CGRectGetMinX(_VolDrawRect) + (fDiffWidth*nCount);
            CGSize drawsize = CGSizeZero;
            if(i == 0)
            {
                drawsize = [strBegin drawAtPoint:drawpoint withFont:drawFont];
                fPrePos = drawpoint.x + drawsize.width;
            }
            else 
            {
                drawsize = [strBegin sizeWithFont:drawFont];
                if(fPrePos <= drawpoint.x && drawpoint.x <= CGRectGetMaxX(_VolDrawRect) - 2 * (1+drawsize.width))
                {
#ifndef tztNoTrendTime
                    
                    if (i > 0)
                    {
                        strBegin = [NSString stringWithFormat:@"/%@", strBegin];
                    }
                    drawpoint.x += 1;
                    drawsize = [strBegin drawAtPoint:drawpoint withFont:drawFont];
#endif
                    fPrePos = drawpoint.x + drawsize.width;
                }
            }
            
            if(lendtime > lbegintime)
            {
                nCount += (lendtime-lbegintime);
            }
            else //跨越24点
            {
                nCount += (24*60 - lbegintime) + lendtime;
            }
            drawpoint.x = CGRectGetMinX(_VolDrawRect) + (fDiffWidth*nCount) - drawsize.width;
            
            if(fPrePos <= drawpoint.x && drawpoint.x <= CGRectGetMaxX(_VolDrawRect) - 2 * (1+drawsize.width))
            {
                drawsize = [strEnd drawAtPoint:drawpoint withFont:drawFont];
                fPrePos = drawpoint.x + drawsize.width;
            }
            else if(i == ([ay count]  / 2 - 1))
            {
                [strEnd drawAtPoint:drawpoint withFont:drawFont];
            }
        }
    }
}

- (void)onDrawYAxis:(CGContextRef)context
{
    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
//    if (self.bHideVolume)
//    {
//        drawFont = tztUIBaseViewTextFont([tztTechSetting getInstance].drawTxtSize-2.5f);
//    }
//    else
//    {
//        drawFont = tztUIBaseViewTextFont([tztTechSetting getInstance].drawTxtSize-2.5f);;
//    }
    
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    
    if ([self.nsBackColor intValue])
    {
        balanceColor = [UIColor blackColor];
    }
    
    UIColor *color = [UIColor tztThemeHQFixYAxiColor];
    if (color)
    {
        upColor = color;
        downColor = color;
        balanceColor = color;
    }
    
    CGPoint drawpoint = _TrendDrawRect.origin;
    long nMaxDiff = GetMaxDiff(_TrendHead->nPreClosePrice,_TrendHead->nMaxPrice,_TrendHead->nMinPrice);
    //绘制纵坐标
    //最大值
    CGContextSetFillColorWithColor(context, upColor.CGColor);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    NSString* strValue =  @"-";
    NSString* strSize = @"";
    if(_bPercent)
    {
        strValue = [self getDiffPercent:nMaxDiff*100.0f maxdiff:_TrendHead->nPreClosePrice]; 
        strSize = [self getDiffPercent:-nMaxDiff*100.0f maxdiff:_TrendHead->nPreClosePrice];
    }
    else
    {
        strValue = [self getValueString:_TrendHead->nPreClosePrice + nMaxDiff];
        strSize = strValue;
    }
    CGSize drawsize = [strSize sizeWithFont:drawFont];
    if (_bShowLeftPriceInSide)
        drawpoint.x = _TrendDrawRect.origin.x;
    else
        drawpoint.x = CGRectGetMinX(_TrendDrawRect)-drawsize.width;
    drawpoint.y = CGRectGetMinY(_TrendDrawRect);
    if (_bShowLeftPriceInSide)
    {
        CGContextSetFillColorWithColor(context, [[UIColor tztThemeHQTipBackColor] colorWithAlphaComponent:0.5f].CGColor);
        CGContextFillRect(context, CGRectMake(drawpoint.x, drawpoint.y, drawsize.width, drawsize.height));
    }
    
    CGContextSetFillColorWithColor(context, upColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    //右侧绘制最大涨幅
    CGPoint pt = drawpoint;
    CGSize size = CGSizeZero;
    if (_bShowRightRatio)
    {
        NSString *strRatio = [self getDiffPercent:nMaxDiff*100.0f maxdiff:_TrendHead->nPreClosePrice];
        size = [strRatio sizeWithFont:drawFont];
        pt.x = _TrendDrawRect.origin.x + CGRectGetWidth(_TrendDrawRect) - size.width;
        if (_bShowLeftPriceInSide)
        {
            CGContextSetFillColorWithColor(context, [[UIColor tztThemeHQTipBackColor] colorWithAlphaComponent:0.5f].CGColor);
            CGContextFillRect(context, CGRectMake(pt.x, pt.y, size.width, size.height));
        }
        
        CGContextSetFillColorWithColor(context, upColor.CGColor);
        [strRatio drawAtPoint:pt withFont:drawFont];
    }
    
    //绘制数值
    drawpoint.y = CGRectGetMinY(_TrendDrawRect)  + CGRectGetHeight(_TrendDrawRect)/4;
    drawpoint.y -= drawsize.height / 2;
    long lvalue = _TrendHead->nPreClosePrice + (nMaxDiff + 1) / 2;
    if(_bPercent)
    {
        strValue = [self getDiffPercent:nMaxDiff*50.0f maxdiff:_TrendHead->nPreClosePrice];
    }
    else
    {
        strValue = [self getValueString:lvalue];
    }
//    if(nMaxDiff % 2 == 0)
    if (!_bShowMaxMinPrice)
    {
        if (_bShowLeftPriceInSide)
        {
            CGContextSetFillColorWithColor(context, [[UIColor tztThemeHQTipBackColor] colorWithAlphaComponent:0.5f].CGColor);
            CGContextFillRect(context, CGRectMake(drawpoint.x, drawpoint.y, drawsize.width, drawsize.height));
        }
        CGContextSetFillColorWithColor(context, upColor.CGColor);
        [strValue drawAtPoint:drawpoint withFont:drawFont];
    }
    
    //绘制昨收数值
    CGContextSetFillColorWithColor(context, balanceColor.CGColor);
    drawpoint.y = CGRectGetMidY(_TrendDrawRect)-drawsize.height/2;
    lvalue = _TrendHead->nPreClosePrice;
    if(_bPercent)
    {
        strValue = [self getDiffPercent:0 maxdiff:_TrendHead->nPreClosePrice]; 
    }
    else
    {
        strValue = [self getValueString:lvalue];
    }
    
    if (!_bShowLeftPriceInSide)
    {
//        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.8f].CGColor);
//        CGContextFillRect(context, CGRectMake(drawpoint.x, drawpoint.y, drawsize.width, drawsize.height));
        CGContextSetFillColorWithColor(context, balanceColor.CGColor);
        [strValue drawAtPoint:drawpoint withFont:drawFont];
    }
    
    
    //绘制数值
    CGContextSetFillColorWithColor(context, downColor.CGColor);
    drawpoint.y = CGRectGetMaxY(_TrendDrawRect)  - CGRectGetHeight(_TrendDrawRect)/4;
    drawpoint.y -= drawsize.height / 2;
    lvalue = _TrendHead->nPreClosePrice - (nMaxDiff + 1) / 2;
    if(_bPercent)
    {
        strValue = [self getDiffPercent:-nMaxDiff*50.f maxdiff:_TrendHead->nPreClosePrice];
    }
    else
    {
        strValue = [self getValueString:lvalue];
    }
//    if(nMaxDiff % 2 == 0)
    if (!_bShowMaxMinPrice)
    {
        if (_bShowLeftPriceInSide)
        {
            CGContextSetFillColorWithColor(context, [[UIColor tztThemeHQTipBackColor] colorWithAlphaComponent:0.5f].CGColor);
            CGContextFillRect(context, CGRectMake(drawpoint.x, drawpoint.y, drawsize.width, drawsize.height));
        }
        
        CGContextSetFillColorWithColor(context, downColor.CGColor);
        [strValue drawAtPoint:drawpoint withFont:drawFont];
    }
    
    
    //绘制值
    lvalue = _TrendHead->nPreClosePrice - nMaxDiff;
    if(_bPercent)
    {
        strValue = [self getDiffPercent:-nMaxDiff*100.0f maxdiff:_TrendHead->nPreClosePrice];
    }
    else
    {
        strValue = [self getValueString:lvalue];
    }
    drawpoint.y = CGRectGetMaxY(_TrendDrawRect) - drawsize.height;
    
    if (_bShowLeftPriceInSide)
    {
        CGContextSetFillColorWithColor(context, [[UIColor tztThemeHQTipBackColor] colorWithAlphaComponent:0.5f].CGColor);
        CGContextFillRect(context, CGRectMake(drawpoint.x, drawpoint.y, drawsize.width, drawsize.height));
    }
    
    CGContextSetFillColorWithColor(context, downColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    
    if (_bShowRightRatio)
    {
        //右侧绘制最大涨幅
        pt = drawpoint;
        NSString *strMinRatio = [self getDiffPercent:-nMaxDiff*100.0f maxdiff:_TrendHead->nPreClosePrice];
        size = [strMinRatio sizeWithFont:drawFont];
        pt.x = _TrendDrawRect.origin.x + CGRectGetWidth(_TrendDrawRect) - size.width;
        
        if (_bShowLeftPriceInSide)
        {
            CGContextSetFillColorWithColor(context, [[UIColor tztThemeHQTipBackColor] colorWithAlphaComponent:0.5f].CGColor);
            CGContextFillRect(context, CGRectMake(pt.x, pt.y, size.width, size.height));
        }
        
        CGContextSetFillColorWithColor(context, downColor.CGColor);
        [strMinRatio drawAtPoint:pt withFont:drawFont];
    }
}

- (void)onDrawTips:(CGRect)rect
{
    NSInteger nMaxData = [_ayTrendValues count];
    
    if(nMaxData > 0 && _TrendHead->nPreClosePrice != 0)
    {
        UIFont* drawfont = [tztTechSetting getInstance].drawTxtFont;
        CGSize drawsize = CGSizeZero;
        CGSize valuesize = CGSizeZero;
        if(_TrendCurIndex < 0)
            _TrendCurIndex = 0;
        
        if(_TrendCurIndex >= nMaxData)
            _TrendCurIndex = nMaxData - 1;
        tztTrendValue* trendValue = [_ayTrendValues objectAtIndex:_TrendCurIndex];
        
        //时间
        NSString* strTime = [self getstrTimeofPos:_TrendCurIndex];
        //最新
        NSString* strNewPrice = [self getValueString:trendValue.ulClosePrice];
        //均价
        NSString* strAvgPrice = [self getValueString:trendValue.ulAvgPrice];
        //昨收
        NSString* strPreClose = [self getValueString:_TrendHead->nPreClosePrice];
        //涨跌
        NSString* strRatio = [self getValueString:(trendValue.ulClosePrice-_TrendHead->nPreClosePrice)];
        //幅度
        NSString* strRange = [NSString stringWithFormat:@"%.2f%%",((long)trendValue.ulClosePrice - _TrendHead->nPreClosePrice) * 100.0 /(long)_TrendHead->nPreClosePrice ];
        //最高
        NSString* strMaxPrice = [self getValueString:_TrendHead->nMaxPrice];
        //最低
        NSString* strMinPrice = [self getValueString:_TrendHead->nMinPrice];
        //现手
        NSString* strNowHand = NStringOfULong(trendValue.nTotal_h);
        
        if (!_bShowTips)
        {
            if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:SetCursorData:)])
            {
                //组织数据
                NSMutableDictionary *dict = NewObject(NSMutableDictionary);
                [dict setTztObject:strTime forKey:tztTime];
                [dict setTztObject:strNewPrice forKey:tztNewPrice];
                [dict setTztObject:strAvgPrice forKey:tztAveragePrice];
                [dict setTztObject:strPreClose forKey:tztYesTodayPrice];
                [dict setTztObject:strRatio forKey:tztUpDown];
                [dict setTztObject:strRange forKey:tztPriceRange];
                [dict setTztObject:strMaxPrice forKey:tztMaxPrice];
                [dict setTztObject:strMinPrice forKey:tztMinPrice];
                [dict setTztObject:strNowHand forKey:tztNowVolume];
                [self.tztdelegate tztHqView:self SetCursorData:dict];
                [dict release];
            }
            return;
        }
        
        NSString* strValue =  @"新 99999.999";
        valuesize = [strValue sizeWithFont:drawfont];
        valuesize.height = (CGRectGetHeight(_TrendDrawRect) - 10 * 2) / 9;
        if (valuesize.height > 20)
            valuesize.height = 20;
        
        float nLineHeight = valuesize.height;
        
        CGRect TipRect = _TrendDrawRect;
        TipRect.origin.x = rect.origin.x;
        if (_TrendCursor.x <= CGRectGetMidX(_TrendDrawRect))
        {
            TipRect.origin.x = CGRectGetMaxX(_TrendDrawRect) - valuesize.width - 2 ;
        }
        TipRect.origin.y = _TrendDrawRect.origin.y ;
        
        UIColor* FixtxtColor = [UIColor tztThemeHQFixTextColor];
        UIColor* AxisColor = [UIColor tztThemeHQAxisTextColor];
        
        UIColor* upColor = [UIColor tztThemeHQUpColor];
        UIColor* downColor = [UIColor tztThemeHQDownColor];
        UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
        
        UIColor* tipbackColor = [UIColor tztThemeHQTipBackColor];
        UIColor* tipGridColor = [UIColor tztThemeHQHideGridColor];
        
//        if ([self.nsBackColor intValue])
//        {
//            FixtxtColor = [UIColor blackColor];
//            balanceColor = [UIColor blackColor];
//            tipbackColor = [UIColor whiteColor];
//            tipGridColor = [UIColor grayColor];
//        }
        
        CGPoint drawpoint = TipRect.origin;
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        
        TipRect.size.width = valuesize.width + 2;
        TipRect.size.height = (valuesize.height + 2) * 9 + 2;
        if (TipRect.size.width > _TrendDrawRect.size.width / 2)
        {
            TipRect.size.width = _TrendDrawRect.size.width / 2;
            if (_TrendCursor.x <= CGRectGetMidX(_TrendDrawRect))
            {
                TipRect.origin.x = CGRectGetMaxX(_TrendDrawRect) - TipRect.size.width;
            }
        }
        
        CGContextSaveGState(context);
        CGContextSetAlpha(context, 0.9);
        CGContextSetStrokeColorWithColor(context, tipGridColor.CGColor);
        CGContextSetFillColorWithColor(context, tipbackColor.CGColor);
        CGContextAddRect(context, TipRect);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        valuesize = [strTime sizeWithFont:drawfont];
        drawpoint.x = CGRectGetMinX(TipRect)+1;
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        drawsize = [@"时" drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
        drawpoint.y += 2;
        CGContextSetFillColorWithColor(context, AxisColor.CGColor);
        [strTime drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.y += /*drawsize.height*/nLineHeight + 2;

        UIColor* drawColor = balanceColor;
        if (trendValue.ulClosePrice > _TrendHead->nPreClosePrice)
        {
            drawColor = upColor;
        }
        else if (trendValue.ulClosePrice < _TrendHead->nPreClosePrice)
        {
            drawColor = downColor;
        }
        
        valuesize = [strNewPrice sizeWithFont:drawfont];
        drawpoint.x = CGRectGetMinX(TipRect)+1;
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        drawsize = [@"新" drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        [strNewPrice drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
        
        drawColor = balanceColor;
        if (trendValue.ulAvgPrice > _TrendHead->nPreClosePrice)
        {
            drawColor = upColor;
        }
        else if (trendValue.ulAvgPrice < _TrendHead->nPreClosePrice)
        {
            drawColor = downColor;
        }
        valuesize = [strAvgPrice sizeWithFont:drawfont];
        drawpoint.x = CGRectGetMinX(TipRect)+1;
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        drawsize = [@"均" drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        [strAvgPrice drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
        
        valuesize = [strPreClose sizeWithFont:drawfont];
        drawpoint.x = CGRectGetMinX(TipRect)+1;
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        drawsize = [@"昨" drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
        CGContextSetFillColorWithColor(context, balanceColor.CGColor);
        [strPreClose drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
        
        
        drawColor = balanceColor;
        if (trendValue.ulClosePrice > _TrendHead->nPreClosePrice)
        {
            drawColor = upColor;
        }
        else if (trendValue.ulClosePrice < _TrendHead->nPreClosePrice)
        {
            drawColor = downColor;
        }
        
        valuesize = [strRatio sizeWithFont:drawfont];
        drawpoint.x = CGRectGetMinX(TipRect)+1;
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        drawsize = [@"涨" drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        [strRatio drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
        
        valuesize = [strRange sizeWithFont:drawfont];
        drawpoint.x = CGRectGetMinX(TipRect)+1;
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        drawsize = [@"幅" drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        [strRange drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
        
        drawColor = balanceColor;
        if (_TrendHead->nMaxPrice > _TrendHead->nPreClosePrice)
        {
            drawColor = upColor;
        }
        else if (_TrendHead->nMaxPrice < _TrendHead->nPreClosePrice)
        {
            drawColor = downColor;
        }
        
        valuesize = [strMaxPrice sizeWithFont:drawfont];
        drawpoint.x = CGRectGetMinX(TipRect)+1;
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        drawsize = [@"高" drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        [strMaxPrice drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
        
        
        drawColor = balanceColor;
        if (_TrendHead->nMinPrice > _TrendHead->nPreClosePrice)
        {
            drawColor = upColor;
        }
        else if (_TrendHead->nMinPrice < _TrendHead->nPreClosePrice)
        {
            drawColor = downColor;
        }
        
        valuesize = [strMinPrice sizeWithFont:drawfont];
        drawpoint.x = CGRectGetMinX(TipRect)+1;
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        drawsize = [@"低" drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        [strMinPrice drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
        
        valuesize = [strNowHand sizeWithFont:drawfont];
        drawpoint.x = CGRectGetMinX(TipRect)+1;
        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
        drawsize = [@"现" drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
        CGContextSetFillColorWithColor(context, balanceColor.CGColor);
        [strNowHand drawAtPoint:drawpoint withFont:drawfont];
        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
    }
}


#pragma touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
	UITouch *touchTap = [touches anyObject];
	NSUInteger numTaps = [touchTap tapCount];
	CGPoint lastPoint = [touchTap locationInView:self];
    if(numTaps >= 2)
    {
        if(abs(_preClickPoint.y - lastPoint.y) < 5)//双击
        {
            if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:clickAction:)])
            {
                [self.tztdelegate tztHqView:self clickAction:numTaps];
                return;
            }
        }
    }
    
    if (_bIgnorTouch)
    {
        _bTrendDrawCursor = FALSE;
        return;
    }
    _preClickPoint = lastPoint;
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    _TrendCursor = [touch locationInView:self];
    CGRect rectYAxis = _TrendDrawRect;
    rectYAxis.origin.x -= _fYAxisWidth;
    rectYAxis.size.width = _fYAxisWidth;
    if (CGRectContainsPoint(rectYAxis, _TrendCursor)) 
    {
        _bPercent = !_bPercent;
    }
//    if (CGRectContainsPoint(_TrendDrawRect, _TrendCursor)
//        || CGRectContainsPoint(_VolDrawRect, _TrendCursor))
//        _bTrendDrawCursor = TRUE;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
    _TrendCursor = [touch locationInView:self];
//  	NSUInteger numTaps = [touch tapCount];
//    if (numTaps >= 2) //双击
//    {
        _bTrendDrawCursor = !_bTrendDrawCursor;
//    }

    if (_Move)
    {
        _bTrendDrawCursor = TRUE;
    }
#ifdef TrendNMove  // 移动时没光标
    _bTrendDrawCursor = NO;
#endif
//    _bTrendDrawCursor = NO;
    
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(ShowZJLXCurLine:Point:)])
    {
        [self.tztdelegate ShowZJLXCurLine:_bTrendDrawCursor Point:_TrendCursor];
    }
    
    
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(showHorizenView:)])
    {
        BOOL bDeal = [self.tztdelegate showHorizenView:self];
        if (bDeal)
            return;
    }
    
    if (_bIgnorTouch)
    {
        _bTrendDrawCursor = FALSE;
        return;
    }
    if (!_bHideFundFlows && _tztFundFlows)
    {
        _tztFundFlows.bCursorLine = _bTrendDrawCursor;
        _tztFundFlows.pCurPoint  = CGPointMake(_TrendCursor.x, _tztFundFlows.pCurPoint.y);
        [_tztFundFlows setNeedsDisplay];
        if (_TrendCursor.y > _VolDrawRect.origin.y && !_Move) 
        {
            _tztFundFlows.frame = _FundFlowsRect;
            _tztFundFlows.hidden = !_tztFundFlows.hidden;
        }
    }
    _Move = FALSE;
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    _TrendCursor = [touch locationInView:self];
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(MoveZJLXCurLine:)])
    {
        [self.tztdelegate MoveZJLXCurLine:_TrendCursor];
    }
    
    if (_bIgnorTouch)
    {
        _bTrendDrawCursor = FALSE;
        return;
    }
    if (!_bHideFundFlows && _tztFundFlows)
    {
        _tztFundFlows.pCurPoint  = CGPointMake(_TrendCursor.x, _tztFundFlows.pCurPoint.y);
        [_tztFundFlows setNeedsDisplay];
    }
    _Move = TRUE;
    
    [self setNeedsDisplay];
}

-(void)trendTouchMoved:(CGPoint)point bShowCursor_:(BOOL)bShowCursor
{
    _TrendCursor = point;
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(MoveZJLXCurLine:)])
    {
        [self.tztdelegate MoveZJLXCurLine:_TrendCursor];
    }
    
    if (!_bHideFundFlows && _tztFundFlows)
    {
        _tztFundFlows.pCurPoint  = CGPointMake(_TrendCursor.x, _tztFundFlows.pCurPoint.y);
        [_tztFundFlows setNeedsDisplay];
    }
    _Move = TRUE;
    _bTrendDrawCursor = bShowCursor;
    [self setNeedsDisplay];
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    [super setStockInfo:pStockInfo Request:nRequest];
    if (_tztFundFlows)
    {
        _tztFundFlows.fLeftWidth = _fYAxisWidth;
        _tztFundFlows.nMaxCount = _nMaxCount;
        [_tztFundFlows setStockInfo:pStockInfo Request:nRequest];
    }
    
#ifdef Support_HKTrade
    if (_tztHKQueueView)
    {
        [_tztHKQueueView setStockInfo:self.pStockInfo Request:!_tztHKQueueView.hidden];
    }
    _pBtnDetail.hidden = !MakeHKMarketStock(self.pStockInfo.stockType);
#endif
    
    if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
    {
        return;
    }
    
//    [self onClearData];
    //读取本地数据－分时 yangdl 2013.08.14
    [self readParse];
}

-(void)ShowFenshiCurLine:(BOOL)show Point:(CGPoint)point
{
    _bTrendDrawCursor = show;
    _TrendCursor = point;
    _tztFundFlows.hidden = !_tztFundFlows.hidden;
    [self setNeedsDisplay];
}

-(TNewPriceData*)GetNewPriceData
{
    return _PriceData;
}

-(TNewTrendHead*)GetNewTrendHead
{
    return _TrendHead;
}

-(void)setStockInfo:(tztStockInfo*)pStock
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
    {
        [_tztdelegate tzthqView:self setStockCode:pStock];
    }
}

/*
 大单净量取到数据后，回调下分时界面显示，防止左侧的坐标显示出现遮挡
 add by yinjp 
 20130716
 */
-(void)tzthqViewNeedsDisplay:(id)hqview
{
#ifdef TZT_ZYData
    if (_tztFundFlows == hqview)
    {
        long lFundFlowsLeft = [_tztFundFlows GetLeftMargin];
        if (lFundFlowsLeft > _fYAxisWidth)
        {
            _fYAxisWidth = lFundFlowsLeft;
            _tztFundFlows.fLeftWidth = _fYAxisWidth;
            [self setNeedsDisplay];//重新刷新界面
        }
    }
#endif
}

@end