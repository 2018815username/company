/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztDetailView.h"
#define tzt_DetailHiddenZD

#define TZTTableCellTime    0x1111
#define TZTTableCellPrice   0x1112
#define TZTTableCellRatio   0x1113
#define TZTTableCellHand    0x1114

@interface tztDetailValue : NSObject
{
    NSString* _nstime;
    unsigned long _ulNewPrice;//最新
    unsigned long _ulPreClose;//最新
    int32_t _nHand;  //现手
    unsigned char _nFlag;////  内外盘标识 2-内盘('↓')=卖入价成交    1-外盘('↑')=卖出价成交
}

@property(nonatomic,retain) NSString* nstime;
@property unsigned long ulNewPrice;//最新
@property unsigned long ulPreClose;//昨收
@property int32_t nHand;
@property unsigned char nFlag;
@end


@interface tztDetailView ()
{
    TNewDetailHead  *_tNewDetailHead;    //成交明细头
    NSMutableArray  *_ayDetailData;    //明细详细数据
    
    NSInteger             _nStartPos; //请求起始位置
    NSInteger             _nMaxCount;    //请求的条数
    NSInteger     _valuecount;    //数据总数
    NSInteger     _reqAdd;        //请求翻页变更请求数
    NSInteger     _reqchange;      //请求变更数
    
    TZTUIReportGridView *_gridView;     //表格显示
    TNewPriceData   *_PriceData;//报价数据
}

@end

@implementation tztDetailValue
@synthesize nstime = _nstime;
@synthesize ulNewPrice = _ulNewPrice;
@synthesize ulPreClose = _ulPreClose;
@synthesize nHand = _nHand;
@synthesize nFlag = _nFlag;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.nstime = @"--:--";
        _ulNewPrice = UINT32_MAX;
        _ulPreClose = UINT32_MAX;
        _nHand = INT32_MAX;
        _nFlag = 0;
    }
    return self;
}
@end

@implementation tztDetailView
@synthesize pDrawFont = _pDrawFont;
@synthesize fCellHeight = _fCellHeight;
@synthesize fTopCellHeight = _fTopCellHeight;
@synthesize bGridLines = _bGridLines;
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    if (_tNewDetailHead)
        free(_tNewDetailHead);
    if (_PriceData)
        free(_PriceData);
    if (_ayDetailData)
    {
        [_ayDetailData removeAllObjects];
        [_ayDetailData release];
    }
    [super dealloc];
}

-(void)initdata
{
    [super initdata];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _tNewDetailHead = malloc(sizeof(TNewDetailHead));
    memset(_tNewDetailHead, 0x00, sizeof(TNewDetailHead));
    
    _PriceData = malloc(sizeof(TNewPriceData));
    memset(_PriceData, 0x00, sizeof(TNewPriceData));
    _ayDetailData = NewObject(NSMutableArray);
    _reqchange = 0;
    _nStartPos = 0;
    _nMaxCount = 20;
    _bGridLines = YES;
#ifndef tztDetailHasSecond
    _bShowSeconds = YES;
#else
    _bShowSeconds = NO;
#endif
    if(_gridView == nil)
    {
        _gridView = [[TZTUIReportGridView alloc] init];
//        _gridView.
        _gridView.nDefaultCellHeight = 25;
        _gridView.frame = CGRectMake(self.bounds.origin.x + 1, self.bounds.origin.x, self.bounds.size.width - 1, self.bounds.size.height);
        _gridView.bLeftTop = YES;
#ifdef tzt_DetailHiddenZD
        _gridView.colCount = 3;
        _gridView.nDefaultCellWidth = self.bounds.size.width / 3;
#else
        _gridView.colCount = 4;
        _gridView.nDefaultCellWidth = self.bounds.size.width / 4;
#endif
        _nMaxCount = _gridView.rowCount;
        _reqAdd = _gridView.reqAdd;
        _gridView.nPageCount = 0;
        _gridView.delegate = self;
//        _gridView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_gridView];
        [_gridView release];
    }
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    
}

-(void)setBScrollEnabled:(BOOL)bScrollEnabled
{
    if (_gridView)
        _gridView.bScrollEnable = bScrollEnabled;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_gridView)
    {
        _gridView.pDrawFont = self.pDrawFont;
        _gridView.nDefaultCellHeight = (_fCellHeight > 0 ? _fCellHeight : 25);
        _gridView.nTopViewHeight = (_fTopCellHeight > 0 ? _fTopCellHeight : 25);
#ifdef tzt_DetailHiddenZD
        _gridView.nDefaultCellWidth = self.bounds.size.width / 3;
#else
         _gridView.nDefaultCellWidth = self.bounds.size.width / 4;
#endif
        _gridView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.x, self.bounds.size.width, self.bounds.size.height);
        _gridView.bLeftTop = YES;
        _gridView.fixColCount = 0;
        _nMaxCount = _gridView.rowCount;
        _reqAdd = _gridView.reqAdd;
        [_gridView setNeedsDisplay];
    }
}

-(void)setBGridLines:(BOOL)bLines
{
    _bGridLines = bLines;
    if (_gridView)
        _gridView.bGridLines = bLines;
}
// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    if (IS_TZTIPAD)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetAlpha(context, 1);
        CGContextSaveGState(context);
        UIColor* HideGridColor = [UIColor tztThemeHQHideGridColor];// [tztTechSetting getInstance].hideGridColor;
        UIColor* BackgroundColor = [UIColor tztThemeBackgroundColorHQ];//[tztTechSetting getInstance].backgroundColor;
        CGContextSetStrokeColorWithColor(context, HideGridColor.CGColor);
        CGContextSetFillColorWithColor(context, BackgroundColor.CGColor);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextStrokePath(context);
        
        CGContextSetLineWidth(context,2.0f);
        //绘制竖线
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
    }
    
}

- (void)ClearGridData
{
    if (_gridView)
        [_gridView ClearGridData];
}

-(void)onClearData
{
    [super onClearData];
    memset(_tNewDetailHead, 0x00, sizeof(TNewDetailHead));
    if (_ayDetailData)
    {
        [_ayDetailData removeAllObjects];
    }
//    if (_gridView)
//        [_gridView ClearGridData];
}

#pragma 请求数据
-(void)onRequestData:(BOOL)bShowProcess
{
    TZTNSLog(@"%@", @"成交明细请求数据");
    if (_bRequest)
    {
        if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
        {
            return;
        }      
        //Reqno|MobileCode|MobileType|Cfrom|Tfrom|Token|ZLib|StartPos|MaxCount|StockCode|Level|AccountIndex|
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%ld",(long)_nStartPos] forKey:@"StartPos"];
        [sendvalue setTztObject:[NSString stringWithFormat:@"%ld",(long)_nMaxCount] forKey:@"MaxCount"];
        [sendvalue setTztObject:@"1" forKey:@"Level"];
        [sendvalue setTztObject:@"1" forKey:@"AccountIndex"];
        
        NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
        [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"44" withDictValue:sendvalue];
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
    if([parse GetAction] == 44)
    {
        if(![parse IsIphoneKey:(long)self reqno:_ntztHqReq])
        {
            return 0;
        }
        //Reqno|ErrorNo|ErrorMessage|Token|OnLineMessage|HsString|stocktype|BinData|Grid|Level|Level2Bin|AccountIndex|WTAccount|
//        self.pStockInfo.stockType =  0;
        NSString* Datastocktype = [parse GetValueData:@"NewMarketNo"];
        if (Datastocktype == NULL || Datastocktype.length < 1)
            Datastocktype = [parse GetValueData:@"stocktype"];
        if(Datastocktype && [Datastocktype length] > 0)
        {
            self.pStockInfo.stockType = [Datastocktype intValue];
        }
        
        //报价数据 
        NSData* dataWTAccount = [parse GetNSData:@"WTAccount"];
        NSInteger nLen = [dataWTAccount length];
        if(dataWTAccount && nLen > 0)
        {
            NSString* strBase = [parse GetByName:@"WTAccount"];
            setTNewPriceData(_PriceData,strBase);
            //通知delegate，更新界面显示数据
            if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(UpdateData:)])
            {
                [_tztdelegate UpdateData:self];
            }
        }

        NSString* strBaseData = [parse GetByName:@"BinData"];
        setTNewDetailHead(_tNewDetailHead, strBaseData);
        
        strBaseData = [parse GetByName:@"Level2Bin"];
        NSData *DataLevel2Bin = [NSData tztdataFromBase64String:strBaseData];
        NSInteger nDataLevel2Bin = [DataLevel2Bin length];
        
        strBaseData = [parse GetByName:@"Grid"];
        NSData *DataGrid = [NSData tztdataFromBase64String:strBaseData];
        NSInteger nGridLen = [DataGrid length];
        //数据总行数
        NSInteger nRecvCount = nGridLen / sizeof(TNewDetailData);
        
        BOOL bAddSecond = FALSE;
        char *level2Bin = nil;
        if (DataLevel2Bin && nDataLevel2Bin == nRecvCount)
        {
            level2Bin = (char*)[DataLevel2Bin bytes];
            bAddSecond = TRUE;
        }
        
        if (_ayDetailData)
            [_ayDetailData removeAllObjects];
        if (DataGrid && nGridLen > 0)
        {
            if (nGridLen % sizeof(TNewDetailData) == 0) 
            {
                TNewDetailData *detailData = (TNewDetailData*)[DataGrid bytes];
                for (int i = 0; i < nRecvCount; i++)
                {
                    tztDetailValue *detailvalue = NewObject(tztDetailValue);
                    detailvalue.nstime = [NSString stringWithFormat:@"%02d:%02d", detailData->nHour, detailData->nMin];
                    if (bAddSecond && level2Bin && _bShowSeconds)
                    {
                        int n = *level2Bin;
                        detailvalue.nstime = [NSString stringWithFormat:@"%@:%02d", detailvalue.nstime, n];
                    }
                    detailvalue.ulNewPrice = detailData->nPrice;
                    detailvalue.nHand = detailData->nVolume;     
                    detailvalue.nFlag = detailData->nFlag;
                    [_ayDetailData addObject:detailvalue];
                    [detailvalue release];
                    detailData++;
                    level2Bin++;
                }
            }
        }
        
        
        NSMutableArray *ayTitle = [[NSMutableArray alloc] init];
        //组织数据
        int nCount = 4;
#ifdef tzt_DetailHiddenZD
        nCount = 3;
#endif
        BOOL bStockMarket = YES;
        if (MakeUSMarket(self.pStockInfo.stockType) || MakeHKMarket(self.pStockInfo.stockType))
        {
            bStockMarket = NO;
        }
        for (int i = 0; i < nCount; i++)
        {
            TZTGridDataTitle* gridtitle = NewObject(TZTGridDataTitle);
            NSString* nsData = @"时间";//wry 修改文字
            switch (i) {
                case 1:
                {
                    nsData = @"最新";
                }
                    break;
                //
                case 2:
                {
                    nsData = (bStockMarket ? @"现手" : @"量");
                }
                    break;
                case 3:
                {
                    nsData = @"涨跌";
                }
                    break;
                default:
                    break;
            }
            gridtitle.text = nsData;
            [ayTitle addObject:gridtitle];
            [gridtitle release];
        }
        
        NSMutableArray *ayReortData = NewObject(NSMutableArray);
        for (int i = 0; i < [_ayDetailData count]; i++)
        {
            tztDetailValue* pValue = [_ayDetailData objectAtIndex:i];
            if (pValue == nil)
                continue;
            
            NSMutableArray *pAdd = NewObjectAutoD(NSMutableArray);
            
            UIColor *pColor = [UIColor tztThemeHQBalanceColor];
            if (!g_nHQBackBlackColor)
            {
                pColor = [UIColor darkGrayColor];
            }
            //时间
            TZTGridData *pGridData = NewObject(TZTGridData);
            NSString* nsdata = pValue.nstime;
            pGridData.text = nsdata;
            pGridData.textColor = pColor;
            [pAdd addObject:pGridData];
            [pGridData release];
            
            //最新
            pGridData = NewObject(TZTGridData);
            nsdata = NSStringOfVal_Ref_Dec_Div(pValue.ulNewPrice, 0, _tNewDetailHead->cDemical, 1000);
            if (pValue.ulNewPrice > _tNewDetailHead->Last_p)
                pColor = [UIColor tztThemeHQUpColor];
            else if (pValue.ulNewPrice < _tNewDetailHead->Last_p)
                pColor = [UIColor tztThemeHQDownColor];
            pGridData.text = nsdata;
            pGridData.textColor = pColor;
            [pAdd addObject:pGridData];
            [pGridData release];
            
            //现手
            pGridData = NewObject(TZTGridData);
            int nHand = _PriceData->m_nUnit;
            NSString* strUnit = @"";
            if (!bStockMarket)
            {
                if(pValue.nHand > 10000)
                {
                    nHand = 1000;
                    strUnit = @"k";
                }
                else if (pValue.nHand > 1000*10000)
                {
                    nHand = 1000000;
                    strUnit = @"m";
                }
            }
            else
            {
                if (nHand <= 0)
                    nHand = 100;
            }
//            if (MakeUSMarket(self.pStockInfo.stockType))
//            {
//                nHand = 1;
//            }
//            else
//            {
//                
//            }
            nsdata = NSStringOfVal_Ref_Dec_Div(pValue.nHand, 0, 0, nHand);
            if (pValue.nFlag == 1)
            {
                //↑
                nsdata = [NSString stringWithFormat:@"%@%@",nsdata, strUnit];
                pColor = [UIColor tztThemeHQUpColor];
            }
            else if(pValue.nFlag == 2)
            {
                //↓
                nsdata = [NSString stringWithFormat:@"%@%@",nsdata, strUnit];
                pColor = [UIColor tztThemeHQDownColor];
            }
            else
            {
                //−
                nsdata = [NSString stringWithFormat:@"%@%@",nsdata, strUnit];
                pColor = [UIColor tztThemeHQAxisTextColor];// [tztTechSetting getInstance].axisTxtColor;
            }
            pGridData.text = nsdata;
            pGridData.textColor = pColor;
            [pAdd addObject:pGridData];
            [pGridData release];
#ifndef tzt_DetailHiddenZD
            //涨跌
            pGridData = NewObject(TZTGridData);
            nsdata = NSStringOfVal_Ref_Dec_Div(pValue.ulNewPrice - _tNewDetailHead->Last_p, 0, _tNewDetailHead->cDemical, 1000);
            pGridData.text = nsdata;
            pGridData.textColor = pColor;
            [pAdd addObject:pGridData];
            [pGridData release];
#endif
            [ayReortData addObject:pAdd];
        }
        
        if(_gridView)
        {
            NSString* strMaxCount = [parse GetByName:@"MaxCount"];
            _valuecount = [strMaxCount intValue];
            NSInteger pagecount = _valuecount * 3 / _nMaxCount + ((_valuecount * 3) % _nMaxCount ? 1 : 0);
            _gridView.nValueCount = _valuecount;
            _gridView.nPageCount = pagecount;
            _gridView.nCurPage = _nStartPos / ((_nMaxCount / 3) > 0 ? (_nMaxCount/3) : 1) + ((_nStartPos % (_nMaxCount/ 3)) > 0 ? 1 : 0);
            _gridView.indexStarPos = _nStartPos;
            [_gridView CreatePageData:ayReortData title:ayTitle type:_reqchange];
            _reqchange = 0;
        }
        [ayReortData release];
        [ayTitle release];
    }
    return 1;
}

//刷新页面
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageRefreshAtPage:(NSInteger)page
{
    [self onRequestData:TRUE];
    return _nStartPos;
}


//前翻页
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageBackAtPage:(NSInteger)page
{
    if(_reqchange == 0) //不累加翻页 返回请求数据后置为0后 翻页有效 yangdl 2013.03.15
    {
        NSInteger reqIndex  = _nStartPos - _reqAdd;
        if(reqIndex <= 0)
            reqIndex = 0;
        
        _reqchange = reqIndex - _nStartPos;
        _nStartPos = reqIndex;
    }
    [self onRequestData:TRUE];
    return _nStartPos;
}

//后翻页
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageNextAtPage:(NSInteger)page
{
    if(_reqchange == 0) //不累加翻页 返回请求数据后置为0后 翻页有效 yangdl 2013.03.15
    {
        NSInteger reqIndex  = _nStartPos + _reqAdd;
        if(reqIndex > _valuecount - _nMaxCount)
            reqIndex = _valuecount - _nMaxCount+1;
        if(reqIndex <= 0)
            reqIndex = 0;
        _reqchange = reqIndex - _nStartPos;
        _nStartPos = reqIndex;
    }
    [self onRequestData:TRUE];
    return _nStartPos;
}
-(TNewPriceData*)GetNewPriceData
{
    return _PriceData;
}
@end
