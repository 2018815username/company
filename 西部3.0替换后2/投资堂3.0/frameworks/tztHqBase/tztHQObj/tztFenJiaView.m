/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        分价
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztFenJiaView.h"
@interface tztFenJiaData : NSObject
{
    unsigned long         _nPrice;
    unsigned long         _nCount;
}
@property unsigned long       nPrice;
@property unsigned long       nCount;
@end

@implementation tztFenJiaData
@synthesize nPrice = _nPrice;
@synthesize nCount = _nCount;

- (id)init {
    self = [super init];
    if (self) {
        _nPrice = UINT32_MAX;
        _nCount = UINT32_MAX;
    }
    return self;
}

@end

@interface tztFenJiaView ()
{
    TNewDetailHead  *_tNewDetailHead;    //成交明细头
    NSMutableArray  *_ayData;            //分价数据
    
    NSInteger             _nStartPos;     //请求起始位置
    NSInteger             _nMaxCount;     //请求的条数
    NSInteger             _valuecount;    //数据总数
    NSInteger             _reqAdd;        //请求翻页变更请求数
    NSInteger             _reqchange;     //请求变更数
    
    TZTUIReportGridView *_gridView;     //表格显示
    TNewPriceData       *_PriceData;    //报价数据
}
@end

@implementation tztFenJiaView
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
    if (_ayData)
    {
        [_ayData removeAllObjects];
        [_ayData release];
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
    
    _ayData = NewObject(NSMutableArray);
    _reqchange = 0;
    _nStartPos = 0;
    _nMaxCount = 20;
    if(_gridView == nil)
    {
        _gridView = [[TZTUIReportGridView alloc] init];
        _gridView.nDefaultCellHeight = 25;
        _gridView.frame = self.bounds;
        _gridView.nDefaultCellWidth = self.bounds.size.width / 4;
        _nMaxCount = _gridView.rowCount;
        _reqAdd = _gridView.reqAdd;
        _gridView.colCount = 4;
        _gridView.fixColCount = 0;
        _gridView.nReqPage = 0;
        _gridView.delegate = self;
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
        _gridView.bLeftTop = YES;
        _gridView.nDefaultCellHeight = (_fCellHeight > 0 ? _fCellHeight : 25);
        _gridView.nTopViewHeight = (_fTopCellHeight > 0 ? _fTopCellHeight : 25);
        _gridView.nDefaultCellWidth = self.bounds.size.width / 3;
        _gridView.frame = self.bounds;
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

-(void)onClearData
{
    [super onClearData];
    memset(_tNewDetailHead, 0x00, sizeof(TNewDetailHead));
    if (_ayData)
    {
        [_ayData removeAllObjects];
    }
}

#pragma 请求数据
-(void)onRequestData:(BOOL)bShowProcess
{
    TZTNSLog(@"%@", @"分价请求数据");
    if (_bRequest)
    {
        if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
        {
            TZTLogWarn(@"%@", @"分价请求－－－股票代码有误！！！");
            return;
        }
        //req=Reqno|MobileCode|MobileType|from|Cfrom|Tfrom|Token|ZLib|StartPos|MaxCount|StockCode|AccountIndex|
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
//        [sendvalue setTztObject:[NSString stringWithFormat:@"%d",_nStartPos] forKey:@"StartPos"];
//        [sendvalue setTztObject:[NSString stringWithFormat:@"%d",_nMaxCount] forKey:@"MaxCount"];
        
        //分价数据不多,固定请求200条
        [sendvalue setTztObject:@"0" forKey:@"StartPos"];
        [sendvalue setTztObject:@"200" forKey:@"MaxCount"];
        [sendvalue setTztObject:@"1" forKey:@"AccountIndex"];
        NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
        [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"35" withDictValue:sendvalue];
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
    if([parse GetAction] == 35)
    {
        if(![parse IsIphoneKey:(long)self reqno:_ntztHqReq])
        {
            return 0;
        }
        //ans=Reqno|ErrorNo|ErrorMessage|Token|OnLineMessage|HsString|stocktype|BinData|Grid|AccountIndex|WTAccount|
        self.pStockInfo.stockType =  0;
        NSString *Datastocktype = [parse GetValueData:@"NewMarketNo"];
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
        
        strBaseData = [parse GetByName:@"Grid"];
        NSData *DataGrid = [NSData tztdataFromBase64String:strBaseData];
        NSInteger nGridLen = [DataGrid length];
        //数据总行数
        NSInteger nRecvCount = nGridLen / sizeof(TFenJiaData);
        
//        BOOL bAddSecond = FALSE;
//        char *level2Bin = nil;
//        if (DataLevel2Bin && nDataLevel2Bin == nRecvCount)
//        {
//            level2Bin = (char*)[DataLevel2Bin bytes];
//            bAddSecond = TRUE;
//        }
        
        if (_ayData)
            [_ayData removeAllObjects];
        if (DataGrid && nGridLen > 0)
        {
            if (nGridLen % sizeof(TFenJiaData) == 0) 
            {
                TFenJiaData *FenJiaData = (TFenJiaData*)[DataGrid bytes];
                for (int i = 0; i < nRecvCount; i++)
                {
                    tztFenJiaData *pData = NewObject(tztFenJiaData);
                    pData.nPrice = FenJiaData->nPrice;
                    pData.nCount = FenJiaData->nCount;
                    [_ayData addObject:pData];
                    [pData release];
                    FenJiaData++;
                }
            }
        }
        
        NSMutableArray *ayTitle = [[NSMutableArray alloc] init];
        //组织数据
        for (int i = 0; i < 3; i++)
        {
            TZTGridDataTitle* gridtitle = NewObject(TZTGridDataTitle);
            NSString* nsData = @"价格";
            switch (i) {
                case 1:
                {
                    nsData = @"";
                }
                    break;
//                case 2:
//                {
//                    nsData = @"";
//                }
//                    break;
                case 2:
                {
                    nsData = @"数量";
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
        for (NSInteger i = ([_ayData count] - 1); i >= 0; i--)
        {
            tztFenJiaData* pValue = [_ayData objectAtIndex:i];
            if (pValue == nil)
                continue;
            
            NSMutableArray *pAdd = NewObjectAutoD(NSMutableArray);
            
            UIColor *pColor = [UIColor whiteColor];
            if (!g_nHQBackBlackColor)
            {
                pColor = [UIColor darkGrayColor];
            }
            
            //price
            TZTGridData *pGridData = NewObject(TZTGridData);
            NSString* nsdata = NSStringOfVal_Ref_Dec_Div(pValue.nPrice, 0, _tNewDetailHead->cDemical, 1000);
            pGridData.text = nsdata;
            if (pValue.nPrice > _tNewDetailHead->Last_p) 
                pColor = [UIColor tztThemeHQUpColor];
            else if(pValue.nPrice < _tNewDetailHead->Last_p)
                pColor = [UIColor tztThemeHQDownColor];
            
            pGridData.textColor = pColor;
            [pAdd addObject:pGridData];
            [pGridData release];
            
//            pGridData = NewObject(TZTGridData);
//            pGridData.text = @"";
//            pGridData.textColor = pColor;
//            [pAdd addObject:pGridData];
//            [pGridData release];
            
            pGridData = NewObject(TZTGridData);
            pGridData.text = @"";
            pGridData.textColor = pColor;
            [pAdd addObject:pGridData];
            [pGridData release];
            
            //count
            pGridData = NewObject(TZTGridData);
            nsdata = NStringOfULong(pValue.nCount/100);// NSStringOfVal_Ref_Dec_Div(pValue.nCount, 0, 0, 100);
            pColor = [UIColor orangeColor];
            pGridData.text = nsdata;
            pGridData.textColor = pColor;
            [pAdd addObject:pGridData];
            [pGridData release];
            
            [ayReortData addObject:pAdd];
        }
        
        if(_gridView)
        {
            _gridView.rowCount = [ayReortData count];//设置列表显示条数
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
