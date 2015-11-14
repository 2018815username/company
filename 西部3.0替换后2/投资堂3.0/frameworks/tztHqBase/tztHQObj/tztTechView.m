/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztTechView.m
 * 文件标识：
 * 摘    要：K线视图
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

#import "tztTechView.h"
#import "tztUIEditValueView.h"
#import "tztUIPickerView.h"
#define TZTTechPath @"Library/Documents/Tech"

#define tagtztCycle 0x10000
#define tagtztZhibiao 0x20000
#define tagtztEditParam 0x30000
#define IsTZTLandscape (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) && (!IS_TZTIPAD))

short KLineWidth_len = 11;// 13
//int   KLineWidth[] = {2,4,6,10,14,20};//
int   KLineWidth[] = {1,2,3,5,7,11,20,50,100,150,200,250,300};
short KLineZoomIndex = 3;

@interface  tztTechView ()
{
    NSInteger         _nStartPos;
    NSInteger         _TechCurIndex;//当前序号
    NSInteger         _TechStartIndex;//开始序号
    NSInteger         _TechEndIndex;//结束序号
    NSInteger         _TechCount; //K线总数
    
    CGFloat     _YAxisWidth;//Y轴宽度
    NSInteger         _KLineCellWidth;//K线绘制单元宽度
    
    tztKLineMapNum _KLineMapNum;//图数
    
    tztKLineCycle _KLineCycleStyle;//周期
    
    NSMutableArray*    _ayTechValue;//K线数据
        
    UIButton* _btnLeft;
    UIButton* _btnRight;
    
    NSArray* _ayCycle;
    NSArray* _ayZhiBiao;
    
    TNewPriceData *_PriceData;
    TNewKLineHead *_techHead;
    //选择器
    tztUIPickerView* _tztPickerView;
    //编辑器
    tztUIEditValueView* _tztEditView;
    NSInteger         _nKeybordOffset;
    //
    CGRect  _rcHisTrend;
    BOOL        _bShowHisBtn;
    BOOL        _bShowTips;
    BOOL        _bMoved;
    
    //每次记录两个点是为了缩放操作，通过计算两点间距离，从而放大或者缩小
    //开始位置
    CGPoint     _beginPoint;
    CGPoint     _beginPointEx;
    //
    CGPoint     _lastPoint;
    CGPoint     _lastPointEx;
    //当前位置
    CGPoint     _currentPoint;
    CGPoint     _currentPointEx;
    //
    BOOL        _bTwoTouchBegin;
    
    NSTimeInterval  _nPrevious;
    NSTimeInterval  _nCurrent;
    CGPoint     _preClickPoint;
    BOOL        _bFirst;
    
    CGRect _rcChuQuan;
    CGRect _rcObj;
    NSInteger _nObjIndex;
}
//合并K线数据
- (void)onCacluteTechArray;
//点击周期
- (void)onClickCycle:(id)obj;
//点击指标
- (void)onClickZhiBiao:(id)obj;
//点击放大缩小
- (void)onClickZoom:(id)obj;
//点击移动k线
-(void)onClickMove:(id)obj;
//弹出编辑器
- (void)onClickEditView:(NSMutableArray*)ayValue titleTip:(NSString*)strTitle Tag:(NSInteger)nTag;
//点击参数设置
- (void)onDbClickParam:(tztTechObj*)obj;

-(void)setStockInfo:(tztStockInfo*)pStock;

- (BOOL)onSetTechZoom:(int)nZoomIndex;
//绘制数据框
- (void)onDrawTips:(CGRect)rect;

- (NSInteger)CalculateDrawIndex:(NSInteger)nKind; //nKind 0 初始  1 move  2 放大缩小
NSComparisonResult compare(tztTechValue *firstValue, tztTechValue *secondValue, void *context);
CGFloat distanceBetweenPoints(CGPoint first, CGPoint second);
@end

@implementation tztTechView
@synthesize TechCursorDraw = _TechCursorDraw;
//add by xyt 20130909 
@synthesize ayTechValue = _ayTechValue;
@synthesize KLineZhibiao = _KLineZhibiao;
@synthesize KLineCycleStyle = _KLineCycleStyle;
@synthesize YAxisWidth = _YAxisWidth;
@synthesize btnCycle = _btnCycle;
@synthesize btnZhiBiao = _btnZhiBiao;
@synthesize bSupportTechCursor = _bSupportTechCursor;
@synthesize bTechMoved = _bTechMoved;
@synthesize bTouchParams = _bTouchParams;
@synthesize btnZoomIn = _btnZoomIn;
@synthesize btnZoomOut = _btnZoomOut;
@synthesize bShowTechParams = _bShowTechParams;
@synthesize bShowLeftInSide = _bShowLeftInSide;
@synthesize bShowMaxMin = _bShowMaxMin;
@synthesize bSupportHisTrend = _bSupportHisTrend;
@synthesize bHiddenCycle = _bHiddenCycle;
@synthesize bHiddenObj = _bHiddenObj;

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

- (void)initdata
{
    [super initdata];
    _PKLineAxisStyle = KLineXYAxis;
    _KLineCellWidth = 0;
    _TechCursorPoint = CGPointZero;
    _TechCurIndex = -1;//当前序号
    _TechStartIndex = 0;//开始序号
    _TechEndIndex = 0;//结束序号
    _TechCount = 0; //K线总数
    _TechCursorDraw = FALSE;
    _bShowHisBtn = TRUE;
    _bSupportTechCursor = TRUE;
    _bShowTips = TRUE;
    _bShowTechParams = TRUE;
    _bSupportHisTrend = TRUE;
    
    _KLineZhibiao = VOL;
    [self setTechMapNum:KLineMapTwo];

    _PriceData = malloc(sizeof(TNewPriceData));
    memset(_PriceData, 0x00, sizeof(TNewPriceData));
    
    _techHead = malloc(sizeof(TNewKLineHead));
    memset(_techHead, 0x00, sizeof(TNewKLineHead));
    
    _btnZoomIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnZoomIn addTarget:self action:@selector(onClickZoom:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnZoomIn setTztImage:[UIImage imageTztNamed:@"TZTZoomIn.png"]];
    [self addSubview:_btnZoomIn];
    
    _btnZoomOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnZoomOut addTarget:self action:@selector(onClickZoom:) forControlEvents:UIControlEventTouchUpInside];
    [_btnZoomOut setTztImage:[UIImage imageTztNamed:@"TZTZoomOut.png"]];
    [self addSubview:_btnZoomOut];
    
#ifndef tzt_HiddenCycle
    _btnCycle = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCycle addTarget:self action:@selector(onClickCycle:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnCycle setTztBackgroundImage:[UIImage imageTztNamed:@"TZT_hqbtn.png"]];
    [_btnCycle.titleLabel setFont:tztUIBaseViewTextFont(12.f)];
    [_btnCycle setTztTitle:@"周期"];
    [self addSubview:_btnCycle];
    _btnCycle.hidden = YES;
#endif
    
#ifndef tzt_HiddenTechObj
    _btnZhiBiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnZhiBiao addTarget:self action:@selector(onClickZhiBiao:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnZhiBiao setTztBackgroundImage:[UIImage imageTztNamed:@"TZT_hqbtn.png"]];
    
    [_btnZhiBiao.titleLabel setFont:tztUIBaseViewTextFont(12.f)];
    [_btnZhiBiao setTztTitle:@"指标"];
    
    [self addSubview:_btnZhiBiao];
    _btnZhiBiao.hidden = YES;
#endif
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    
    
    _ayCycle = [[NSArray alloc] initWithObjects:
                [NSNumber numberWithInt:KLineCycleDay],
                [NSNumber numberWithInt:KLineCycleWeek],
                [NSNumber numberWithInt:KLineCycleMonth],
                [NSNumber numberWithInt:KLineCycle1Min],
                [NSNumber numberWithInt:KLineCycle5Min],
                [NSNumber numberWithInt:KLineCycle15Min],
                [NSNumber numberWithInt:KLineCycle30Min],
                [NSNumber numberWithInt:KLineCycle60Min],
                [NSNumber numberWithInt:KLineCycleCustomMin],
                [NSNumber numberWithInt:KLineCycleCustomDay],
                [NSNumber numberWithInt:KLineChuQuan],
                nil ];
    
//#ifndef tzt_ZSSC
//    _ayZhiBiao = [[NSArray alloc] initWithObjects:
//                  [NSNumber numberWithInt:VOL],
//                  [NSNumber numberWithInt:MACD],
//                  [NSNumber numberWithInt:KDJ],
//                  [NSNumber numberWithInt:RSI],
//                  [NSNumber numberWithInt:WR],
//                  [NSNumber numberWithInt:BOLL],
//                  [NSNumber numberWithInt:DMI],
//                  [NSNumber numberWithInt:DMA],
//                  [NSNumber numberWithInt:TRIX],
//                  [NSNumber numberWithInt:BRAR],
//                  [NSNumber numberWithInt:VR],
//                  [NSNumber numberWithInt:OBV],
//                  [NSNumber numberWithInt:ASI],
//                  [NSNumber numberWithInt:EMV],
//                  [NSNumber numberWithInt:WVAD],
//                  [NSNumber numberWithInt:CCI],
//                  [NSNumber numberWithInt:ROC],
//                  [NSNumber numberWithInt:BIAS],
////                  [NSNumber numberWithInt:EXPMA],
////                  [NSNumber numberWithInt:TZTCR],
////                  [NSNumber numberWithInt:SAR],
////                  [NSNumber numberWithInt:MIKE],
//                  nil];
//#else
    _ayZhiBiao = [[NSArray alloc] initWithObjects:
                  [NSNumber numberWithInt:VOL],
                  [NSNumber numberWithInt:MACD],
                  [NSNumber numberWithInt:RSI],
                  [NSNumber numberWithInt:KDJ],
                  [NSNumber numberWithInt:BOLL],
                  [NSNumber numberWithInt:CCI],
                  [NSNumber numberWithInt:WR],
                  //                  [NSNumber numberWithInt:EXPMA],
                  //                  [NSNumber numberWithInt:TZTCR],
                  //                  [NSNumber numberWithInt:SAR],
                  //                  [NSNumber numberWithInt:MIKE],
                  nil];
//#endif
    _ayTechValue= NewObject(NSMutableArray);
    
    if (_bTechMoved)
    {
        _tztPickerView = [[tztUIPickerView alloc] init];
        _tztPickerView.pickerDelegate = self;
        [self addSubview:_tztPickerView];
        [_tztPickerView release];
        
        _tztPickerView.tag = tagtztZhibiao;
        _tztPickerView.contentOffset = CGPointZero;
        [_tztPickerView setFrame:CGRectZero];
        _tztPickerView.hidden = YES;
    }
    
    _bTouchParams = YES;
}

-(void)setBHiddenCycle:(BOOL)bHiddenCycle
{
    _bHiddenCycle = bHiddenCycle;
    _btnCycle.hidden = bHiddenCycle;
}

-(void)setBHiddenObj:(BOOL)bHiddenObj
{
    _bHiddenObj = bHiddenObj;
    _btnZhiBiao.hidden = bHiddenObj;
}

- (void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    DelObject(_ayCycle);
    DelObject(_ayZhiBiao);
    if (_PriceData)
    {
        free(_PriceData);
        _PriceData = nil;
    }
    if (_techHead)
    {
        free(_techHead);
        _techHead = nil;
    }
    [super dealloc];
}

- (void)setKLineZhibiao:(NSInteger)nKLineZhiBiao
{
     _KLineZhibiao = nKLineZhiBiao;
    if(_KLineMapNum & KLineMapMACD)
    {
        if(_TechObjMACD)
            [_TechObjMACD setKLineZhibiao:_KLineZhibiao];
    }
    else if(_KLineMapNum & KLineMapVOL)
    {
        if(_TechObjVol)
            [_TechObjVol setKLineZhibiao:_KLineZhibiao];
    }
}

- (void)setTechMapNum:(tztKLineMapNum)num
{
    _KLineMapNum = num;
    if(_KLineMapNum & KLineMapPKLine)
    {
        if(_TechObjPKLine == nil)
        {
            _TechObjPKLine = NewObject(tztTechObj);
            _TechObjPKLine.techView = self;
            _TechObjPKLine.bIsDrawParams = _bShowTechParams;
            _TechObjPKLine.bShowLeftInSide = _bShowLeftInSide;
            [_TechObjPKLine setKLineZhibiao:PKLINE];
            [self addSubview:_TechObjPKLine];
            [_TechObjPKLine release];
        }
        else
        {
            [_TechObjPKLine setKLineZhibiao:PKLINE];
        }
    }
    if(_TechObjPKLine)
    {
        _TechObjPKLine.KLineAxisStyle = (_KLineMapNum == KLineMapPKLine ? KLineXYAxis:KLineYAxis);
        _TechObjPKLine.hidden = !(_KLineMapNum & KLineMapPKLine);
    }
    
    if(_KLineMapNum & KLineMapVOL)
    {
        if(_TechObjVol == nil)
        {
            _TechObjVol = NewObject(tztTechObj);
            _TechObjVol.techView = self;
            _TechObjVol.bIsDrawParams = _bShowTechParams;
            _TechObjVol.bShowLeftInSide = _bShowLeftInSide;
            [_TechObjVol setKLineZhibiao:VOL];
            [self addSubview:_TechObjVol];
            [_TechObjVol release];
        }
        else
        {
            [_TechObjVol setKLineZhibiao:VOL];
        }
    }
    
    if(_TechObjVol)
    {
        _TechObjVol.KLineAxisStyle = ( (_KLineMapNum & KLineMapMACD) ? KLineYAxis : KLineXYAxis);
        _TechObjVol.hidden = !(_KLineMapNum & KLineMapVOL);
    }
    
    if(_KLineMapNum & KLineMapMACD)
    {
        if(_TechObjMACD == nil)
        {
            _TechObjMACD = NewObject(tztTechObj);
            _TechObjMACD.techView = self;
            _TechObjMACD.bIsDrawParams = _bShowTechParams;
            _TechObjMACD.bShowLeftInSide = _bShowLeftInSide;
            [_TechObjMACD setKLineZhibiao:_KLineZhibiao];
            [self addSubview:_TechObjMACD];
            [_TechObjMACD release];
        }
        else
        {
            [_TechObjMACD setKLineZhibiao:_KLineZhibiao];
        }
    }

    if(_TechObjMACD)
    {
        _TechObjMACD.KLineAxisStyle = KLineXYAxis;
        _TechObjMACD.hidden = !(_KLineMapNum & KLineMapMACD);
    }
    [self onSetTechZoom:KLineZoomIndex];
}

- (void)CalculateValue
{
    double lMaxValue = 0;
    NSString* strValue = @"";
    CGSize drawsize = CGSizeZero;
    UIFont* drawfont = [tztTechSetting getInstance].drawTxtFont;
    if(_TechObjPKLine && (!_TechObjPKLine.hidden))
    {
        [_TechObjPKLine CalculateValue];
        lMaxValue = MAX(labs(_TechObjPKLine.MaxValue), labs(_TechObjPKLine.MinValue));
        if (lMaxValue >= INT32_MAX)
        {
            lMaxValue = 0.00;
        }
        strValue = [_TechObjPKLine getValueString:lMaxValue];
        strValue = [NSString stringWithFormat:@"-%@",strValue];
        drawsize = [strValue sizeWithFont:drawfont];
        
        _YAxisWidth = MAX(_YAxisWidth, drawsize.width);
    }
    
    if(_TechObjVol && (!_TechObjVol.hidden))
    {
        [_TechObjVol CalculateValue];
        lMaxValue = MAX(labs(_TechObjVol.MaxValue), labs(_TechObjVol.MinValue));
        if (lMaxValue >= INT32_MAX)
        {
            lMaxValue = 0.00;
        }
        strValue = [_TechObjVol getValueString:lMaxValue];
        strValue = [NSString stringWithFormat:@"-%@",strValue];
        drawsize = [strValue sizeWithFont:drawfont];
        _YAxisWidth = MAX(_YAxisWidth, drawsize.width);
    }
    
    if(_TechObjMACD && (!_TechObjMACD.hidden))
    {
        [_TechObjMACD CalculateValue];
        lMaxValue = MAX(labs(_TechObjMACD.MaxValue), labs(_TechObjMACD.MinValue));
        if (lMaxValue >= INT32_MAX)
        {
            lMaxValue = 0.00;
        }
        strValue = [_TechObjMACD getValueString:lMaxValue];
        strValue = [NSString stringWithFormat:@"-%@",strValue];
        drawsize = [strValue sizeWithFont:drawfont];
        _YAxisWidth = MAX(_YAxisWidth, drawsize.width);
    }
    
    if (!_bShowTechParams || _bShowLeftInSide)
        _YAxisWidth = 0;
    
    if (_TechObjPKLine)
    {
        _TechObjPKLine.YAxisWidth = _YAxisWidth;
    }
    
    if (_TechObjVol)
    {
        _TechObjVol.YAxisWidth = _YAxisWidth;
    }
    
    if (_TechObjMACD)
    {
        _TechObjMACD.YAxisWidth = _YAxisWidth;
    }
    //计算开始绘制序号 绘制数 当前光标序号
    
    CGRect frameRect = self.frame;
    _KLineDrawRect = self.frame;
    _KLineDrawRect = CGRectOffset(_KLineDrawRect, 0, tztParamHeight);
    CGRect PKLineRect = frameRect;
    CGRect VOLRect = frameRect;
    CGRect MACDRect = frameRect;
    if (_TechObjMACD == nil || _TechObjMACD.hidden) //MACD隐藏
    {
        MACDRect = CGRectZero;
        if(_TechObjVol == nil || _TechObjVol.hidden)
        {
            VOLRect = CGRectZero;
        }
        else
        {
            PKLineRect.size.height = frameRect.size.height * 2 / 3;
            VOLRect.size.height = frameRect.size.height / 3;
            VOLRect.origin.y += PKLineRect.size.height;
        }
    }
    else //MACD显示
    {
        if(_TechObjVol == nil || _TechObjVol.hidden) //VOL隐藏
        {
            VOLRect = CGRectZero;
            if(_TechObjPKLine == nil || _TechObjPKLine.hidden) //PKLine隐藏
            {
                PKLineRect = CGRectZero;
            }
            else
            {
                PKLineRect.size.height = frameRect.size.height * 2 / 3;
                MACDRect.size.height = frameRect.size.height / 3;
                MACDRect.origin.y += PKLineRect.size.height;
            }
        }
        else //VOL显示
        {
            if(_TechObjPKLine == nil || _TechObjPKLine.hidden) //PKLine隐藏
            {
                PKLineRect = CGRectZero;
                VOLRect.size.height = frameRect.size.height / 2;
                VOLRect.origin.y += PKLineRect.size.height;
                
                MACDRect.size.height = frameRect.size.height / 2;
                MACDRect.origin.y += VOLRect.size.height;
            }
            else
            {
                PKLineRect.size.height = frameRect.size.height / 2;
                
                VOLRect.size.height = frameRect.size.height / 4;
                VOLRect.origin.y += PKLineRect.size.height;
                
                MACDRect.size.height = frameRect.size.height / 4;
                MACDRect.origin.y += VOLRect.size.height;
            }
        }
    }
    
    if(_TechObjMACD && (!_TechObjMACD.hidden))
    {
        [_TechObjMACD drawBackGround:MACDRect alpha:1];
    }
    
    if(_TechObjVol && (!_TechObjVol.hidden))
    {
        [_TechObjVol drawBackGround:VOLRect alpha:1];
    }
    
    if(_TechObjPKLine && (!_TechObjPKLine.hidden))
    {
        [_TechObjPKLine drawBackGround:PKLineRect alpha:1];
    }

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect frameRect = rect;
    _KLineDrawRect = rect;
    _KLineDrawRect = CGRectOffset(_KLineDrawRect, 0, tztParamHeight);
    
    if (self.needPickerView) {
        CGRect Viewframe = CGRectZero;
        Viewframe.origin.x += (_KLineDrawRect.size.width-90);
        Viewframe.size.width = 90;
        Viewframe.size.height = MIN(30.f*([_ayZhiBiao count]+1),CGRectGetHeight(_KLineDrawRect)) - 20;
        _tztPickerView.frame = Viewframe;
        [_tztPickerView reloadAllComponents];
        _tztPickerView.hidden = NO;
        _KLineDrawRect.size.width -= 90;
        _tztPickerView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    }
    
    [self CalculateDrawIndex:1]; // 解决横屏K线半屏问题
    
    CGRect PKLineRect = frameRect;
    CGRect VOLRect = frameRect;
    CGRect MACDRect = frameRect;
    if (_TechObjMACD == nil || _TechObjMACD.hidden) //MACD隐藏
    {
        MACDRect = CGRectZero;
        if(_TechObjVol == nil || _TechObjVol.hidden)
        {
            VOLRect = CGRectZero;
        }
        else
        {
            PKLineRect.size.height = frameRect.size.height * 2 / 3;
            VOLRect.size.height = frameRect.size.height / 3;
            VOLRect.origin.y += PKLineRect.size.height;
        }
    }
    else //MACD显示
    {
        if(_TechObjVol == nil || _TechObjVol.hidden) //VOL隐藏
        {
            VOLRect = CGRectZero;
            if(_TechObjPKLine == nil || _TechObjPKLine.hidden) //PKLine隐藏
            {
                PKLineRect = CGRectZero;
            }
            else
            {
                PKLineRect.size.height = frameRect.size.height * 2 / 3+1;
                MACDRect.size.height = frameRect.size.height / 3;
                MACDRect.origin.y += (PKLineRect.size.height-1);
            }
        }
        else //VOL显示
        {
            if(_TechObjPKLine == nil || _TechObjPKLine.hidden) //PKLine隐藏
            {
                PKLineRect = CGRectZero;
                VOLRect.size.height = frameRect.size.height / 2;
                VOLRect.origin.y += PKLineRect.size.height-1;
                
                MACDRect.size.height = frameRect.size.height / 2;
                MACDRect.origin.y += VOLRect.size.height-1;
            }
            else
            {
                PKLineRect.size.height = frameRect.size.height / 2;
                
                VOLRect.size.height = frameRect.size.height / 4;
                VOLRect.origin.y += PKLineRect.size.height-1;
                
                MACDRect.size.height = frameRect.size.height / 4;
                MACDRect.origin.y += VOLRect.size.height-1;
            }
        }
    }

    if(_TechObjMACD && (!_TechObjMACD.hidden))
    {
        _TechObjMACD.bIsDrawParams = _bShowTechParams;
        _TechObjMACD.bShowLeftInSide = _bShowLeftInSide;
        _TechObjMACD.bShowMaxMin = _bShowMaxMin;
        _TechObjMACD.bShowObj = _bShowObj;
        if (_bShowLeftInSide)
        {
            _TechObjMACD.KLineAxisStyle = _ObjAxisStyle;
        }
        [_TechObjMACD drawBackGround:MACDRect alpha:1 context_:context];
        if([_TechObjMACD setDrawcursor:_TechCursorDraw cursorPoint:_TechCursorPoint curIndex:_TechCurIndex startIndex:_TechStartIndex endIndex:_TechEndIndex])
        {
            [_TechObjMACD drawKLine:1];
        }
        CGRect btnframe = MACDRect;
        btnframe.size.width = 49;
        btnframe.size.height = 19;
        [_btnZhiBiao setTztTitle:_TechObjMACD.techName];
        [_btnZhiBiao setFrame:btnframe];
        if (_bHiddenObj || _bShowObj)
            _btnZhiBiao.hidden = YES;
        else
            _btnZhiBiao.hidden = NO;
    }
    else
    {
        if (_bHiddenObj || _bShowObj)
            _btnZhiBiao.hidden = YES;
        else
        {
            //zxl  20131014 场外基金 隐藏掉指标按钮
            if (!MakeHTFundMarket(self.pStockInfo.stockType) && !_bShowObj)
                _btnZhiBiao.hidden = NO;
            else
                _btnZhiBiao.hidden = YES;
        }
//        if (_bTechMoved)
//        {
//            _btnZhiBiao.hidden = YES;
//        }
    }

    if(_TechObjVol && (!_TechObjVol.hidden))
    {
        _TechObjVol.bIsDrawParams = _bShowTechParams;
        _TechObjVol.bShowLeftInSide = _bShowLeftInSide;
        _TechObjVol.bShowMaxMin = _bShowMaxMin;
        _TechObjVol.bShowObj = _bShowObj;
        if (_bShowLeftInSide)
        {
            _TechObjVol.KLineAxisStyle = _ObjAxisStyle;
        }
        
        [_TechObjVol drawBackGround:VOLRect alpha:1 context_:context];
        if([_TechObjVol setDrawcursor:_TechCursorDraw cursorPoint:_TechCursorPoint curIndex:_TechCurIndex startIndex:_TechStartIndex endIndex:_TechEndIndex])
        {
            [_TechObjVol drawKLine:1];
        }
        if(_btnZhiBiao.hidden)
        {
            CGRect btnframe = VOLRect;
            btnframe.size.width = 49;
            btnframe.size.height = 19;
            [_btnZhiBiao setTztTitle:_TechObjVol.techName];
            [_btnZhiBiao setFrame:btnframe];
            //zxl  20131014 场外基金 隐藏掉指标按钮
            if (_bHiddenObj || _bShowObj)
                _btnZhiBiao.hidden = YES;
            else
            {
                if (!MakeHTFundMarket(self.pStockInfo.stockType) && !_bShowObj)
                    _btnZhiBiao.hidden = NO;
            }
        }
    }

    if(_TechObjPKLine && (!_TechObjPKLine.hidden))
    {
        _TechObjPKLine.bIsDrawParams = _bShowTechParams;
        _TechObjPKLine.bShowLeftInSide = _bShowLeftInSide;
        _TechObjPKLine.bShowMaxMin = _bShowMaxMin;
        _TechObjPKLine.bShowObj = NO;
        if (_bShowLeftInSide)
        {
            _TechObjPKLine.KLineAxisStyle = _PKLineAxisStyle;
        }
        [_TechObjPKLine drawBackGround:PKLineRect alpha:1 context_:context];
        if([_TechObjPKLine setDrawcursor:_TechCursorDraw cursorPoint:_TechCursorPoint curIndex:_TechCurIndex startIndex:_TechStartIndex endIndex:_TechEndIndex])
        {
            [_TechObjPKLine drawKLine:1];
            //zxl  20130927 ipad 场外基金 Params 显示特殊处理(绘制)
            if (MakeHTFundMarket(self.pStockInfo.stockType) && IS_TZTIPAD)
            {
                [_TechObjPKLine onDrawOutFundParams_ipadAdd:[self GetNewPriceData] KLineHead:[self GetNewKLineHead] isHB:MakeHTFundHBMarket(self.pStockInfo.stockType)];
            }
        }
        [self setBtnFrame:PKLineRect];
//        _TechCursorLine = _TechObjPKLine.KLineCurIndex;
    }

    if(_TechCursorDraw)
    {
        [self onDrawTips:rect];
        if (_bShowHisBtn)
        {
            [self onDrawHisBtn:PKLineRect context_:context];
        }
    }
    
    if (_bShowObj && (_TechObjVol || _TechObjMACD))
    {
        _btnZhiBiao.hidden = YES;
        _rcObj = PKLineRect;
        _rcObj.origin.y += PKLineRect.size.height + 4;
        _rcObj.size.height = tztParamHeight - 6;
        _rcObj.size.width = 50;
        
        _rcObj.origin.x += _YAxisWidth;
        
        UIColor *pColorRound = [UIColor tztThemeHQCursorBackColor];
        CGContextSetFillColorWithColor(context, pColorRound.CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
        CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:_rcObj cornerRadius:2.5f].CGPath;
        CGContextAddPath(context, clippath);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        NSString* str = @"成交量";//⌄
        
        if (_ayZhiBiao && _nObjIndex < _ayZhiBiao.count)
        {
            str = getZhiBiaoName([[_ayZhiBiao objectAtIndex:_nObjIndex] intValue]);
            str = [NSString stringWithFormat:@"%@", str];
        }
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        _rcObj.origin.y += (_rcObj.size.height - [tztTechSetting getInstance].drawTxtFont.lineHeight) / 2 - 1;
        [str drawInRect:_rcObj withFont:[tztTechSetting getInstance].drawTxtFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    }
    //绘制除权显示按钮
    if (_bShowTechParams && _bShowChuQuan)
    {
        _rcChuQuan = _KLineDrawRect;
        _rcChuQuan.size.width = 40;
        _rcChuQuan.origin.y -= (tztParamHeight-1);
        _rcChuQuan.size.height =  tztParamHeight - 3;
        _rcChuQuan.origin.x += _KLineDrawRect.size.width - 40;
        
        UIColor *pColorRound = [UIColor tztThemeHQCursorBackColor];
        CGContextSetFillColorWithColor(context, pColorRound.CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
        CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:_rcChuQuan cornerRadius:2.5f].CGPath;
        CGContextAddPath(context, clippath);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        NSString* str = @"";
        if ([tztTechSetting getInstance].nKLineChuQuan)
            str = @"除权";
        else
            str = @"复权";
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        _rcChuQuan.origin.y += (_rcChuQuan.size.height - [tztTechSetting getInstance].drawTxtFont.lineHeight) / 2 -1;
        [str drawInRect:_rcChuQuan withFont:[tztTechSetting getInstance].drawTxtFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    }
    
}



-(void)setHisBtnShow:(BOOL)bShow
{
    _bShowHisBtn = bShow;
}

/*
 绘制历史分时按钮
 add by yinjp
 
 */
-(void)onDrawHisBtn:(CGRect)rect context_:(CGContextRef)context
{
    if (!_bSupportHisTrend)
        return;
    if (self.KLineCycleStyle != KLineCycleDay)
        return;
    if (MakeHTFundMarket(self.pStockInfo.stockType))
        return;
    UIFont* drawfont = [tztTechSetting getInstance].drawTxtFont;
    //获取当前光标位置
    CGPoint pt = _TechObjPKLine.KLineCursor;
    _rcHisTrend = CGRectNull;
    //获取k线的绘制区域
    CGRect rcTechObjPKLine = [_TechObjPKLine getDrawRect];
    //判断点的位置是否再k线绘制区域里，不在则不处理
    if (!CGRectContainsPoint(rcTechObjPKLine, pt))
    {
        return;
    }
    NSString* str = @"分时";
    CGSize sz = [str sizeWithFont:drawfont];
    CGRect rcHis = rect;
    rcHis.origin.x = pt.x - 15;
    rcHis.size.width = 30;
    rcHis.size.height = 15;
    rcHis.origin.y = rect.size.height - 15;
    
    CGPoint drawpt = CGPointZero;
    drawpt.x = rcHis.origin.x + (rcHis.size.width - sz.width) / 2;
    drawpt.y = rcHis.origin.y + (rcHis.size.height - sz.height) / 2;
    
    _rcHisTrend = rcHis;//纪录绘制的区域，用于点击的时候响应事件处理
    if (context == NULL)
        context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 0.8);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddRect(context, _rcHisTrend);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [@"分时" drawAtPoint:drawpt withFont:drawfont];
}

-(void)setTipsShow:(BOOL)bShow
{
    _bShowTips = bShow;
}

- (void)onDrawTips:(CGRect)rect
{
    if (MakeHTFundMarket(self.pStockInfo.stockType))
        return;
    if (!_bShowTips)
    {
        if (_TechCurIndex >= _TechCount)
            return;
        tztTechValue* preTechValue;
        if(_TechCurIndex == 0)
            preTechValue = [_ayTechValue objectAtIndex:0];
        else
            preTechValue = [_ayTechValue objectAtIndex:_TechCurIndex-1];
        if(preTechValue.nClosePrice == 0)
            return;
        
        tztTechValue* techValue = [_ayTechValue objectAtIndex:_TechCurIndex];
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        //时间
        NSString* strTime = [NSString stringWithFormat:@"%u",techValue.ulTime];
        [pDict setTztObject:strTime forKey:tztTime];
        //开盘
        NSString* strOpen = [_TechObjPKLine getValueString:techValue.nOpenPrice];
        [pDict setTztObject:strOpen forKey:tztStartPrice];
        //最高
        NSString* strMax = [_TechObjPKLine getValueString:techValue.nHighPrice];
        [pDict setTztObject:strMax forKey:tztMaxPrice];
        //最低
        NSString* strMin = [_TechObjPKLine getValueString:techValue.nLowPrice];
        [pDict setTztObject:strMin forKey:tztMinPrice];
        //昨收
        NSString* strClose = [_TechObjPKLine getValueString:techValue.nClosePrice];
        [pDict setTztObject:strClose forKey:tztYesTodayPrice];
        //涨
        NSString* strRatio = [_TechObjPKLine getValueString:techValue.nClosePrice - preTechValue.nClosePrice];
        [pDict setTztObject:strRatio forKey:tztUpDown];
        //幅度
        NSString* strRange = [NSString stringWithFormat:@"%.2f%%",(techValue.nClosePrice - preTechValue.nClosePrice) * 100.0 /preTechValue.nClosePrice ];
        [pDict setTztObject:strRatio forKey:tztPriceRange];
        //量
        NSString* strVolume = NStringOfULongLong(techValue.ulTotal_h);
        [pDict setTztObject:strVolume forKey:tztNowVolume];
        
        //昨收preTechValue.nClosePrice
        NSString* strPreClose = [_TechObjPKLine getValueString:preTechValue.nClosePrice];
        [pDict setTztObject:strPreClose forKey:@"tztKLinePreClose"];
        
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:SetCursorData:)])
        {
            [self.tztdelegate tztHqView:self SetCursorData:pDict];
        }
        
        DelObject(pDict);
        return;
    }
    _TechCount = [_ayTechValue count];
    if(_TechCount > 0 && _TechObjPKLine)
    {
        if(_TechCurIndex >= 0 && _TechCurIndex < _TechCount)
        {
            UIFont* drawfont = [tztTechSetting getInstance].drawTxtFont;
            CGSize drawsize = CGSizeZero;
            CGSize valuesize = CGSizeZero;
            
            tztTechValue* preTechValue;
            if(_TechCurIndex == 0)
                preTechValue = [_ayTechValue objectAtIndex:0];
            else
                preTechValue = [_ayTechValue objectAtIndex:_TechCurIndex-1];
            if(preTechValue.nClosePrice == 0)
                return;
            NSString* strValue = [NSString stringWithFormat:@"时 %u",preTechValue.ulTime];
            valuesize = [strValue sizeWithFont:drawfont];
            valuesize.height = (CGRectGetHeight([_TechObjPKLine getDrawRect]) - 9 * 2) / 8;
            if (valuesize.height > 20)
                valuesize.height = 20;
            
            float nLineHeight = valuesize.height;
            
            CGRect TipRect = _KLineDrawRect;
//            TipRect.origin.x = rect.origin.x;
            if (_TechCursorPoint.x <= CGRectGetMidX(_KLineDrawRect)) {
                TipRect.origin.x = CGRectGetMaxX(_KLineDrawRect) - valuesize.width - 2;
            }
            TipRect.origin.y = _KLineDrawRect.origin.y - 1;
            
            UIColor* FixTxtColor = [UIColor tztThemeHQFixTextColor];
            UIColor* AxisColor = [UIColor tztThemeHQAxisTextColor];
            
            UIColor* upColor = [UIColor tztThemeHQUpColor];
            UIColor* downColor = [UIColor tztThemeHQDownColor];
            UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
            UIColor* tipbackColor = [UIColor tztThemeHQTipBackColor];
            UIColor* tipGridColor = [UIColor tztThemeHQHideGridColor];
            
            CGPoint drawpoint = TipRect.origin;
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, FixTxtColor.CGColor);
            CGContextSetTextDrawingMode(context, kCGTextFill);
            
            TipRect.size.width = valuesize.width + 2;
            TipRect.size.height = (valuesize.height + 2) * 8 + 3;
            
            CGContextSaveGState(context);
            CGContextSetAlpha(context, 0.8);
            CGContextSetStrokeColorWithColor(context, tipGridColor.CGColor);
            CGContextSetFillColorWithColor(context, tipbackColor.CGColor);
            CGContextAddRect(context, TipRect);
            CGContextDrawPath(context, kCGPathFillStroke);
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
            
            
            tztTechValue* techValue = [_ayTechValue objectAtIndex:_TechCurIndex];
            strValue = [NSString stringWithFormat:@"%u",techValue.ulTime];
            drawpoint.y += drawsize.height + 2;
            drawpoint.x = CGRectGetMinX(TipRect)+1;
            CGContextSetFillColorWithColor(context, FixTxtColor.CGColor);
            drawsize = [@"时 " drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.x+= drawsize.width;
            CGContextSetFillColorWithColor(context, AxisColor.CGColor);
            drawsize = [strValue drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.y += nLineHeight /*drawsize.height*/ + 2;
            
            UIColor* drawColor = balanceColor;
            if (techValue.nOpenPrice > preTechValue.nClosePrice)
            {
                drawColor = upColor;
            }
            else if (techValue.nOpenPrice < preTechValue.nClosePrice)
            {
                drawColor = downColor;
            }
            strValue = [_TechObjPKLine getValueString:techValue.nOpenPrice];
            valuesize = [strValue sizeWithFont:drawfont];
            drawpoint.x = CGRectGetMinX(TipRect)+1;
            CGContextSetFillColorWithColor(context, FixTxtColor.CGColor);
            drawsize = [@"开" drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            [strValue drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.y += nLineHeight /*drawsize.height*/ + 2;
            
            
            drawColor = balanceColor;
            if (techValue.nHighPrice > preTechValue.nClosePrice)
            {
                drawColor = upColor;
            }
            else if (techValue.nHighPrice < preTechValue.nClosePrice)
            {
                drawColor = downColor;
            }
            
            strValue = [_TechObjPKLine getValueString:techValue.nHighPrice];
            valuesize = [strValue sizeWithFont:drawfont];
            drawpoint.x = CGRectGetMinX(TipRect)+1;
            CGContextSetFillColorWithColor(context, FixTxtColor.CGColor);
            drawsize = [@"高" drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            [strValue drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.y += nLineHeight /*drawsize.height*/ + 2;
            
            
            drawColor = balanceColor;
            if (techValue.nLowPrice > preTechValue.nClosePrice)
            {
                drawColor = upColor;
            }
            else if (techValue.nLowPrice < preTechValue.nClosePrice)
            {
                drawColor = downColor;
            }
            
            strValue = [_TechObjPKLine getValueString:techValue.nLowPrice];
            valuesize = [strValue sizeWithFont:drawfont];
            drawpoint.x = CGRectGetMinX(TipRect)+1;
            CGContextSetFillColorWithColor(context, FixTxtColor.CGColor);
            drawsize = [@"低" drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            [strValue drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.y += nLineHeight /*drawsize.height*/ + 2;
            
            
            drawColor = balanceColor;
            if (techValue.nClosePrice > preTechValue.nClosePrice)
            {
                drawColor = upColor;
            }
            else if (techValue.nClosePrice < preTechValue.nClosePrice)
            {
                drawColor = downColor;
            }
            
            strValue = [_TechObjPKLine getValueString:techValue.nClosePrice];
            valuesize = [strValue sizeWithFont:drawfont];
            drawpoint.x = CGRectGetMinX(TipRect)+1;
            CGContextSetFillColorWithColor(context, FixTxtColor.CGColor);
            drawsize = [@"收" drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            [strValue drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.y += nLineHeight /*drawsize.height*/ + 2;
            
            strValue = [_TechObjPKLine getValueString:techValue.nClosePrice - preTechValue.nClosePrice];
            valuesize = [strValue sizeWithFont:drawfont];
            drawpoint.x = CGRectGetMinX(TipRect)+1;
            CGContextSetFillColorWithColor(context, FixTxtColor.CGColor);
            drawsize = [@"涨" drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            [strValue drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.y += nLineHeight /*drawsize.height*/ + 2;
            
            strValue = [NSString stringWithFormat:@"%.2f%%",(techValue.nClosePrice - preTechValue.nClosePrice) * 100.0 /preTechValue.nClosePrice ];
            valuesize = [strValue sizeWithFont:drawfont];
            drawpoint.x = CGRectGetMinX(TipRect)+1;
            CGContextSetFillColorWithColor(context, FixTxtColor.CGColor);
            drawsize = [@"幅" drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            [strValue drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.y += nLineHeight /*drawsize.height*/ + 2;
            
            strValue =  NStringOfULongLong(techValue.ulTotal_h);
            valuesize = [strValue sizeWithFont:drawfont];
            drawpoint.x = CGRectGetMinX(TipRect)+1;
            CGContextSetFillColorWithColor(context, FixTxtColor.CGColor);
            drawsize = [@"量" drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            [strValue drawAtPoint:drawpoint withFont:drawfont];
            drawpoint.y += nLineHeight /*drawsize.height*/ + 2;
        }
    }
    
}

//K线数据排序
NSComparisonResult compare(tztTechValue *firstValue, tztTechValue *secondValue, void *context)
{
    if (firstValue.uYear < secondValue.uYear)
    {
//        if (firstValue.ulTime < secondValue.ulTime)
            return NSOrderedAscending;
//        else if (firstValue.ulTime > secondValue.ulTime)
//            return NSOrderedDescending;
    }
    else if (firstValue.uYear > secondValue.uYear)
    {
//        if (firstValue.ulTime < secondValue.ulTime)
//            return NSOrderedAscending;
//        else if (firstValue.ulTime > secondValue.ulTime)
            return NSOrderedDescending;
    }
    if (firstValue.ulTime < secondValue.ulTime)
        return NSOrderedAscending;
    else if (firstValue.ulTime > secondValue.ulTime)
        return NSOrderedDescending;
    else
    {
        if(firstValue.ulTotal_h < secondValue.ulTotal_h)
        {
            return NSOrderedAscending;
        }
        else if(firstValue.ulTotal_h < secondValue.ulTotal_h)
        {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }
}


- (void)onCacluteTechArray
{
    //合并数组
    if(_ayTechValue == nil || [_ayTechValue count] <= 0)
        return;
    [_ayTechValue sortUsingFunction:compare context:NULL];    
    NSInteger nCount = [_ayTechValue count];
    NSMutableArray* ayRemove = NewObject(NSMutableArray);
    for (int i = 0 ; i < nCount; i++)
    {
        tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
        if( (i+1) < nCount)
        {
            tztTechValue* nextvalue = [_ayTechValue objectAtIndex:(i+1)];
            if(techvalue.ulTime == nextvalue.ulTime)
            {
                [ayRemove addObject:techvalue];
            }
        }
    }
    if(ayRemove && [ayRemove count] > 0)
    {
        [_ayTechValue removeObjectsInArray:ayRemove];
        [ayRemove removeAllObjects];
    }
    [ayRemove release];
}


- (void)setBtnFrame:(CGRect)rect
{
    CGRect btnframe = rect;
    btnframe.origin.x += rect.size.width - 80;
    btnframe.origin.y += rect.size.height - 30;
    btnframe.size.width = 30;
    btnframe.size.height = 30;
    [_btnZoomIn setFrame:btnframe];
    
    CGRect rcLeft = btnframe;
    rcLeft.origin.x -= 50;
    [_btnLeft setFrame:rcLeft];
    
    btnframe.origin.x += 40;
    [_btnZoomOut setFrame:btnframe];
    
    btnframe.origin.x += 40;
    [_btnRight setFrame:btnframe];
    
    btnframe = CGRectZero;
    btnframe.size.width = 49;
    btnframe.size.height = 19;
    [_btnCycle setFrame:btnframe];
    
    NSString* strTitle = getCycleName(_KLineCycleStyle);
    if(_KLineCycleStyle == KLineCycleCustomMin)
    {
        strTitle = [NSString stringWithFormat:@"%ld分钟",(long)[tztTechSetting getInstance].nTechCustomMin];
    }
    else if(_KLineCycleStyle == KLineCycleCustomDay)
    {
        strTitle = [NSString stringWithFormat:@"%ld日线",(long)[tztTechSetting getInstance].nTechCustomDay];
    }
    [_btnCycle setTztTitle:strTitle];
    
    if (_bHiddenCycle)
        _btnCycle.hidden = YES;
    else
    {
        if (MakeHTFundMarket(self.pStockInfo.stockType))
            _btnCycle.hidden = YES;
        else
            _btnCycle.hidden = NO;
    }
//    if (_bTechMoved)
//        _btnCycle.hidden = YES;
}


- (void)onClickCycle:(id)obj
{
    _tztPickerView.hidden = YES;
    CGRect Viewframe = _btnCycle.frame;
    Viewframe.origin.x += _btnCycle.frame.size.width + 2;
    Viewframe.size.width = 90;
    Viewframe.size.height = MIN(30.f*([_ayCycle count]+1),(CGRectGetHeight(_KLineDrawRect) - tztParamHeight));
    
    //Viewframe.origin.y -= tztParamHeight;
    if(_tztPickerView == nil)
    {
        _tztPickerView = [[tztUIPickerView alloc] initWithFrame:Viewframe];
        _tztPickerView.pickerDelegate = self;
        [self addSubview:_tztPickerView];
        [_tztPickerView release];
    }
    _tztPickerView.tag = tagtztCycle;
    _tztPickerView.contentOffset = CGPointZero;
    [_tztPickerView setFrame:Viewframe];
    [_tztPickerView reloadAllComponents];
    _tztPickerView.hidden = NO;
}


- (void)onClickZhiBiao:(id)obj
{
    TZTNSLog(@"%@",@"onClickZhiBiao");
    if(_tztPickerView == nil)
    {
        _tztPickerView = [[tztUIPickerView alloc] init];
        _tztPickerView.pickerDelegate = self;
        [self addSubview:_tztPickerView];
        [_tztPickerView release];
    }
    CGRect Viewframe = _btnZhiBiao.frame;
    Viewframe.origin.x += _btnZhiBiao.frame.size.width + 2;
    Viewframe.size.width = 90;
    Viewframe.size.height = MIN(30.f*([_ayZhiBiao count]+1),CGRectGetHeight(_KLineDrawRect)-tztParamHeight);
    if(Viewframe.origin.y + Viewframe.size.height/2  < CGRectGetMaxY(_KLineDrawRect))
        Viewframe.origin.y = Viewframe.origin.y-Viewframe.size.height/2;
    else
        Viewframe.origin.y = CGRectGetMaxY(_KLineDrawRect)-Viewframe.size.height;
    Viewframe.origin.y -= tztParamHeight;
    
    _tztPickerView.tag = tagtztZhibiao;
    _tztPickerView.contentOffset = CGPointZero;
    [_tztPickerView setFrame:Viewframe];
    [_tztPickerView reloadAllComponents];
    _tztPickerView.hidden = NO;
}

- (BOOL)onSetTechZoom:(int)nZoomIndex
{
    NSInteger nKLineWidth = 0;
    nKLineWidth = KLineWidth[nZoomIndex];
    NSInteger nKLineCellWidth = _KLineCellWidth;
    _KLineCellWidth = nKLineWidth + 2;
    if(nKLineCellWidth != _KLineCellWidth)
    {
        if(_TechObjPKLine)
        {
            _TechObjPKLine.KLineWidth = nKLineWidth;
            [_TechObjPKLine setKLineCellWidth:_KLineCellWidth];
        }
        if(_TechObjVol)
        {
            _TechObjVol.KLineWidth = nKLineWidth;
            [_TechObjVol setKLineCellWidth:_KLineCellWidth];
        }
        if(_TechObjMACD)
        {
            _TechObjMACD.KLineWidth = nKLineWidth;
            [_TechObjMACD setKLineCellWidth:_KLineCellWidth];
        }
        [self CalculateValue];
        [self CalculateDrawIndex:2];
        return TRUE;
    }
    return FALSE;
}

-(void)OnZoom:(BOOL)bIn
{
    if (bIn)
    {
        KLineZoomIndex -= 1;
        if(KLineZoomIndex <= 0)
        {
            KLineZoomIndex = 0;
            _btnZoomIn.alpha = 0.5;
            _btnZoomIn.enabled = NO;
        }
        _btnZoomOut.alpha = 1.0f;
        _btnZoomOut.enabled = YES;
    }
    else
    {
        KLineZoomIndex += 1;
        if(KLineZoomIndex >= KLineWidth_len-1)
        {
            KLineZoomIndex = KLineWidth_len-1;
            _btnZoomOut.alpha = 0.5f;
            _btnZoomOut.enabled = NO;
        }
        _btnZoomIn.enabled = YES;
        _btnZoomIn.alpha = 1.0f;
    }
    if([self onSetTechZoom:KLineZoomIndex])
        [self setNeedsDisplay];
}

- (void)onClickZoom:(id)obj
{
    UIButton* btn = (UIButton *)obj;
    if(btn ==  _btnZoomIn)
    {
        [self OnZoom:YES];
    }
    else if(btn == _btnZoomOut)
    {
        [self OnZoom:NO];
    }
}

-(void)onClickMove:(id)obj
{
    UIButton* btn = (UIButton *)obj;
    if(btn ==  _btnLeft)
    {
        NSInteger nDrawCount = MIN(_TechCount,(CGRectGetWidth(_KLineDrawRect)- _YAxisWidth - 2) / _KLineCellWidth);
        NSInteger nStartPos = [_ayTechValue count] - _TechEndIndex;
        if (nStartPos < 0)
            nStartPos = 0;
        NSInteger nTemp = _TechStartIndex - nDrawCount;
        if (nTemp  <= 30)
        {
            _TechStartIndex -= nDrawCount;
            if (_TechStartIndex < 0)
                _TechStartIndex = 0;
            _TechEndIndex = _TechStartIndex + MIN(_TechCount-_TechStartIndex,nDrawCount);
            [self OnMovess:nStartPos];
        }
        else
        {
            _TechStartIndex -= nDrawCount;
            _TechEndIndex = _TechStartIndex + MIN(_TechCount-_TechStartIndex,nDrawCount);
            [self CalculateValue];
            [self CalculateDrawIndex:1];
            [self setNeedsDisplay];
        }
    }
    else if(btn == _btnRight)
    {
        int nDrawCount = MIN(_TechCount,(CGRectGetWidth(_KLineDrawRect)- _YAxisWidth - 2) / _KLineCellWidth);
        NSInteger nStartPos = [_ayTechValue count];
        if ((_TechStartIndex + nDrawCount) > nStartPos)
            return;
        _TechStartIndex += nDrawCount;
        _TechEndIndex = _TechStartIndex + MIN(_TechCount-_TechStartIndex,nDrawCount);
        [self CalculateValue];
        [self CalculateDrawIndex:1];
        [self setNeedsDisplay];
    }
    //
}

- (void)OnMovess:(NSInteger)nStartPos
{
    if (self.pStockInfo== nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
    {
        return;
    }
    int nMaxCount = 0;
    _nStartPos = nStartPos;
    int nObjVol = 0;
    int nObj = 0;
    
    if(_TechObjPKLine && _TechObjPKLine.hidden == NO)
    {
        nMaxCount = [_TechObjPKLine getNeedNumber];
    }
    
    if(_TechObjVol && _TechObjVol.hidden == NO)
    {
        nObjVol = [_TechObjVol getNeedNumber];
        nMaxCount = MAX(nObjVol, nMaxCount);
    }
    
    if(_TechObjMACD && _TechObjMACD.hidden == NO)
    {
        nObj = [_TechObjMACD getNeedNumber];
        nMaxCount = MAX(nObj, nMaxCount);
    }
    
    nMaxCount = ((nMaxCount <= 0 )? 50 : nMaxCount);
    NSInteger nEndPos = nStartPos + nMaxCount;
    
    NSString* StartPos = [NSString stringWithFormat:@"%ld",(long)nStartPos];
    NSString* EndPos = [NSString stringWithFormat:@"%ld",(long)nEndPos];
    
    NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
    
    _ntztHqReq++;
    if(_ntztHqReq >= UINT16_MAX)
        _ntztHqReq = 1;
    NSString* strReqno = tztKeyReqnoTokenOne((long)self, _ntztHqReq,0,0,(nStartPos == 0 ? _KLineCycleStyle+1 : 0 ));
    [sendvalue setTztObject:strReqno forKey:@"Reqno"];
    [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
    [sendvalue setTztObject:StartPos forKey:@"StartPos"];
    [sendvalue setTztObject:EndPos forKey:@"MaxCount"];
    NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
    [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
    
    NSString* strCycle = [NSString stringWithFormat:@"%d",_KLineCycleStyle];
    [sendvalue setTztObject:strCycle forKey:@"StockIndex"];//日线
    if (_KLineCycleStyle == KLineCycle1Min) //1分钟线
    {
        NSString* strCycle = [NSString stringWithFormat:@"%d",KLineCycleCustomMin];
        [sendvalue setTztObject:strCycle forKey:@"StockIndex"];
        [sendvalue setTztObject:@"1" forKey:@"Volume"];
    }
    else if (_KLineCycleStyle == KLineCycleCustomDay) //自定义日线
    {
        NSString* strVolume = [NSString stringWithFormat:@"%ld",(long)[tztTechSetting getInstance].nTechCustomDay];
        [sendvalue setTztObject:strVolume forKey:@"Volume"];//日线
    }
    else if (_KLineCycleStyle == KLineCycleCustomMin) //自定义分钟线
    {
        NSString* strVolume = [NSString stringWithFormat:@"%ld",(long)[tztTechSetting getInstance].nTechCustomMin];
        [sendvalue setTztObject:strVolume forKey:@"Volume"];//分钟线
    }
    
    [sendvalue setObject:@"0" forKey:@"Direction"];//K线
    [sendvalue setTztObject:@"1" forKey:@"StockNumIndex"];//分钟K线年份，当请求中StockNumIndex=1时返回此字段，是8位无符号整数数据流，0..255表示1990..2245年。数量与K线相同，一一对应。
    NSString* strChuQuan = [NSString stringWithFormat:@"%ld",(long)[tztTechSetting getInstance].nKLineChuQuan];
    [sendvalue setTztObject:strChuQuan forKey:@"BankDirection"];//不复权
    
    [sendvalue setTztValue:@"2" forKey:@"AccountIndex"];
    TZTNSLog(@"ReqCount = %@", EndPos);
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"64" withDictValue:sendvalue];
    DelObject(sendvalue);
}

- (void)onClickEditView:(NSMutableArray*)ayValue titleTip:(NSString*)strTitle Tag:(NSInteger)nTag
{
    [ayValue retain];
    _tztEditView.hidden = YES;
    
    CGRect Viewframe = _tztPickerView.frame;
    CGFloat viewwidth = 150.f;
    if(IS_TZTIPAD)
        viewwidth = 250.f;
    if(nTag == tagtztEditParam)
    {
        if (_tztPickerView == nil)
        {
            Viewframe = _KLineDrawRect;
            Viewframe.origin.x += (CGRectGetWidth(_KLineDrawRect)- viewwidth ) / 2;
            Viewframe.origin.y = CGRectGetMinY(_KLineDrawRect);
            Viewframe.size.width = viewwidth;
            Viewframe.size.height = CGRectGetHeight(_KLineDrawRect);
        }
        else
        {
            Viewframe.origin.x += _tztPickerView.frame.size.width + 2;
            //zxl 20130806修改自定义日线分钟线设置界面显示位置
            Viewframe.origin.y += (_tztPickerView.frame.size.height - 32)/2;
            Viewframe.size.width = viewwidth;
            Viewframe.size.height = _tztPickerView.frame.size.height;
        }
    }
    else
    {
        Viewframe = _KLineDrawRect;
        Viewframe.origin.x += (CGRectGetWidth(_KLineDrawRect)- viewwidth ) / 2;
        Viewframe.origin.y = CGRectGetMinY(_KLineDrawRect);
        Viewframe.size.width = viewwidth;
        Viewframe.size.height = CGRectGetHeight(_KLineDrawRect);
    }
    
    if(_tztEditView == nil)
    {
        _tztEditView = [[tztUIEditValueView alloc] init];
        _tztEditView.delegate = self;
        [self addSubview:_tztEditView];
        [_tztEditView release];
    }
    _tztEditView.tag = nTag;
    _tztEditView.titleTip = strTitle;
    _tztEditView.arrayData = ayValue;
    _tztEditView.frame = Viewframe;
    [_tztEditView reloadAllComponents];
    _tztEditView.hidden = NO;
    [ayValue release];
}

- (void)onDbClickParam:(tztTechObj*)obj
{
//wry 均线设置打开
//    if (_bTechMoved)
//        return;
    tzttechParamSet* paramset = obj.techParamSet;
    if(paramset)
    {
        NSString* paramtitle = getZhiBiaoName(obj.KLineZhibiao);
        if(obj.KLineZhibiao == PKLINE || obj.KLineZhibiao == VOL)
           paramtitle = @"均线(MA)";
        NSString* strTitle = [NSString stringWithFormat:@"设置%@参数", paramtitle];
        NSMutableArray* ayValue = NewObject(NSMutableArray);
        for (int i = 0; i < [paramset.ayParams count]; i++)
        {
            NSMutableDictionary* values = NewObject(NSMutableDictionary);
            NSString* strName = [NSString stringWithFormat:@"参数%d:",i];
            NSNumber* numValue = [paramset.ayParams objectAtIndex:i];
            NSString* strValue = @"";
            if(numValue)
                strValue = [numValue stringValue];
            [values setValue:strName forKey:@"title"];
            [values setValue:strValue forKey:@"value"];
            [values setValue:[NSNumber numberWithInt:i] forKey:@"key"];
            [ayValue addObject:values];
            [values release];
        }
        [self onClickEditView:ayValue titleTip:strTitle Tag:(NSInteger)obj];
        [ayValue release];
    }
    //    NSString* strTitle = getCycleName(nKLineCycleStyle);
    //    NSMutableArray* ayValue = NewObject(NSMutableArray);
    //    NSMutableDictionary* values = NewObject(NSMutableDictionary);
    //    [values setValue:strTitle forKey:@"title"];
    //    [values setValue:@"2" forKey:@"value"];
    //    [values setValue:[NSNumber numberWithInt:_KLineCycleStyle] forKey:@"key"];
    //    [ayValue addObject:values];
    //    
    //    [values release];
    //    [self onClickEditView:ayValue];
    //    [ayValue release];
    
}


- (void)onClearData
{
    [super onClearData];
    _nStartPos = 0;
    if(_ayTechValue)
    {
        [_ayTechValue removeAllObjects];
    }
    
    if(_TechObjPKLine)
    {
        [_TechObjPKLine onClearData];
    }

    if(_TechObjVol)
    {
        [_TechObjVol onClearData];
    }
    
    if(_TechObjMACD)
    {
        [_TechObjMACD onClearData];
    }
//    [self setNeedsDisplay];
}

//设置代码并请求数据
-(void)setStockInfo:(tztStockInfo*)pStockInfo Request:(int)nRequest
{
    _TechCursorPoint = CGPointZero;
    if (pStockInfo && pStockInfo.stockCode)
    {
        self.pStockInfo = pStockInfo;
        if (MakeHTFundMarket(self.pStockInfo.stockType))
        {
            [self setTechMapNum:KLineMapOne];
            if (MakeHTFundHBMarket(self.pStockInfo.stockType))
            {
                _TechObjPKLine.kLineOutFund = KLineOutFundHB;
            }
            else
            {
                _TechObjPKLine.kLineOutFund = KLineOutFund;
            }
            _btnCycle.hidden = YES;
        }else
        {
             //zxl 20131014 场外基金以外界面 KLineMapTwo 设置回去
             [self setTechMapNum:KLineMapTwo];
            _TechObjPKLine.kLineOutFund  = KLineOutFundNo;
            //zxl 20130927 设置场外基金 false值
        }
    }
    if(nRequest)
    {
        memset(_PriceData, 0, sizeof(TNewPriceData));
        [self onClearData];
        _bRequest = TRUE;
        _bFirst = TRUE;
        [self onRequestData:TRUE];
        if(_KLineCycleStyle == KLineCycleDay)
        {
            [self readParse];
        }
        else
        {
            [self setNeedsDisplay];
        }
    }
}


- (void)onRequestData:(BOOL)bShowProcess
{
    if(_bRequest)
    {
        if (self.pStockInfo== nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
        {
            return;
//            self.stockCode = @"600570";
        }
//        _YAxisWidth = 0;
        NSInteger nStartPos = _nStartPos;
        NSInteger nMaxCount = 0;

        NSInteger nObjVol = 0;
        NSInteger nObj = 0;
        
        if(_TechObjPKLine && _TechObjPKLine.hidden == NO)
        {
            nMaxCount = [_TechObjPKLine getNeedNumber];
        }
        
        if(_TechObjVol && _TechObjVol.hidden == NO)
        {
            nObjVol = [_TechObjVol getNeedNumber];
            nMaxCount = MAX(nObjVol, nMaxCount);
        }
        
        if(_TechObjMACD && _TechObjMACD.hidden == NO)
        {
            nObj = [_TechObjMACD getNeedNumber];
            nMaxCount = MAX(nObj, nMaxCount);
        }
        
        nMaxCount = ((nMaxCount <= 0 )? 50 : nMaxCount);
        NSInteger nEndPos = nStartPos + nMaxCount;
        
//        if([_ayTechValue count] > 0 ) //前面数据不再重复获取 只取最新数据
//            nEndPos = 1;
        
        NSString* StartPos = [NSString stringWithFormat:@"%ld",(long)nStartPos];
        NSString* EndPos = [NSString stringWithFormat:@"%ld",(long)nEndPos];
        
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqnoTokenOne((long)self, _ntztHqReq,0,0,(nStartPos == 0 ? _KLineCycleStyle+1 : 0 ));
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        [sendvalue setTztObject:StartPos forKey:@"StartPos"];
        [sendvalue setTztObject:EndPos forKey:@"MaxCount"];
        NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
        [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
        
        [sendvalue setTztObject:@"1" forKey:@"StockNumIndex"];//分钟K线年份，当请求中StockNumIndex=1时返回此字段，是8位无符号整数数据流，0..255表示1990..2245年。数量与K线相同，一一对应。
        
        NSString* strCycle = [NSString stringWithFormat:@"%d",_KLineCycleStyle];
        [sendvalue setTztObject:strCycle forKey:@"StockIndex"];//日线
        if (_KLineCycleStyle == KLineCycle1Min) //1分钟线
        {
            NSString* strCycle = [NSString stringWithFormat:@"%d",KLineCycleCustomMin];
            [sendvalue setTztObject:strCycle forKey:@"StockIndex"];
            [sendvalue setTztObject:@"1" forKey:@"Volume"];
        }
        else if (_KLineCycleStyle == KLineCycleCustomDay) //自定义日线
        {
            NSString* strVolume = [NSString stringWithFormat:@"%ld",(long)[tztTechSetting getInstance].nTechCustomDay];
            [sendvalue setTztObject:strVolume forKey:@"Volume"];//日线
        }
        else if (_KLineCycleStyle == KLineCycleCustomMin) //自定义分钟线
        {
            NSString* strVolume = [NSString stringWithFormat:@"%ld",(long)[tztTechSetting getInstance].nTechCustomMin];
            [sendvalue setTztObject:strVolume forKey:@"Volume"];//分钟线
        }
       
        [sendvalue setObject:@"0" forKey:@"Direction"];//K线
        
        NSString* strChuQuan = [NSString stringWithFormat:@"%ld",(long)[tztTechSetting getInstance].nKLineChuQuan];
        [sendvalue setTztObject:strChuQuan forKey:@"BankDirection"];//不复权
        
        [sendvalue setTztValue:@"2" forKey:@"AccountIndex"];
        TZTNSLog(@"ReqCount = %@", EndPos);
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"64" withDictValue:sendvalue];
        DelObject(sendvalue);
    }
    [super onRequestData:bShowProcess];
}

//获取文件路径
- (NSString *)getTechPath
{
    return [NSString stringWithFormat:@"%@/%@/%@_%d.data",NSHomeDirectory(),TZTTechPath,self.pStockInfo.stockCode,self.pStockInfo.stockType];
}

//解析数据并刷新  parse:数据  bRead:是本地数据
- (NSUInteger)dealParse:(tztNewMSParse*)parse IsRead:(BOOL)bRead
{
    if([parse GetAction] == 64)
    {
//        [_ayTechValue removeAllObjects];
        NSData* headdata = [parse GetNSData:@"BinData"];
        if(headdata && [headdata length] > 0)
        {
            TNewKLineHead* phead;
            
            TNewKLineHead klinehead;
            NSString* strBinData = [parse GetByName:@"BinData"];
            setTNewKLineHead(&klinehead,strBinData);
            setTNewKLineHead(_techHead, strBinData);
            phead = &klinehead;
            
            if(_TechObjPKLine)
                [_TechObjPKLine setDiv:phead->nUnit Decimal:phead->nDecimal];
        }
        
        NSData* dataWTAccount = [parse GetNSData:@"WTAccount"];
        NSInteger nDataLen = [dataWTAccount length];
        if(dataWTAccount && nDataLen > 0)
        {
            NSString* strBinData = [parse GetByName:@"WTAccount"];
            setTNewPriceData(_PriceData,strBinData);
            NSString* strStockName = [NSString stringWithFormat:@"%@",  self.pStockInfo.stockName];
            NSString* nsStockName = getName_TNewPriceData(_PriceData);
            if (nsStockName)
                self.pStockInfo.stockName = [NSString stringWithFormat:@"%@", nsStockName];
            
            if (self.pStockInfo.stockName && [self.pStockInfo.stockName length] > 0)
            {
                if([self.pStockInfo.stockName compare:strStockName] != NSOrderedSame)
                    [self setStockInfo:self.pStockInfo];
            }
        }
        
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

        int nVolume = [[parse GetByName:@"Volume"] intValue];
        if (nVolume <= 0)
            nVolume = 1;
        //            self.pStockInfo.stockType =  0;
        NSString* DataStockType = [parse GetValueData:@"NewMarketNo"];
        if (DataStockType == NULL || DataStockType.length < 1)
            DataStockType = [parse GetValueData:@"stocktype"];
        if(DataStockType && [DataStockType length] > 0)
        {
            self.pStockInfo.stockType = [DataStockType intValue];
        }
        NSString* strBinDataGrid = [parse GetByName:@"Grid"];
        NSData* klinedata = [NSData tztdataFromBase64String:strBinDataGrid];
        if(klinedata && [klinedata length])
        {
            NSString *strPriceData = [parse GetByName:@"price"];
            NSData *priceData = [NSData tztdataFromBase64String:strPriceData];
            char* pPriceData = (char*)[priceData bytes];
            NSInteger nSize = 1;// sizeof(unsigned short);
            
            TNewKLineData* kline = (TNewKLineData*)[klinedata bytes];
            NSInteger n = [klinedata length] / sizeof(TNewKLineData);
            NSInteger m = [klinedata length] % sizeof(TNewKLineData);
            if(m != 0 )
            {
                TZTLogError(@"%@",@"K线数据解析错误");
            }
            
            for (NSInteger i = 0; i < n; i++)
            {
                tztTechValue* techvalue = [[tztTechValue alloc] init];
                techvalue.nVolume = nVolume;
//                int kkk = pPriceData;
//                NSString *str = [NSString stringWithFormat:@"%u%lu",kkk,kline->ulTime];
//                kline->ulTime = (unsigned long)[str longLongValue];
                [techvalue setdata:kline];
                if (pPriceData != NULL)
                {
                    int kkk = 0;
                    memcpy(&kkk, pPriceData, nSize);
                    pPriceData += nSize;
                    techvalue.uYear = kkk;
                }
                if([techvalue isVaild])
                {
                    [_ayTechValue addObject:techvalue];
                }
                [techvalue release];
                kline++;
            }
            [self onCacluteTechArray];
            [self CalculateValue];//计算数据
            [self CalculateDrawIndex:1];
            [self setNeedsDisplay];
            if (bRead)
                _bFirst = TRUE;
            //                if(_delegate && [_delegate conformsToProtocol:@protocol(tztHqBaseViewDelegate)])
            //                {
            //                    [_delegate tzthqViewNeedsDisplay:self];
            //                }
        }
        
        
        //通知delegate，更新界面显示数据
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(UpdateData:)])
        {
            [_tztdelegate UpdateData:self];
        }
        
        if(!bRead)
        {
            NSString* strReqno = [parse GetByName:@"Reqno"];
            tztNewReqno* tztReqno = [tztNewReqno reqnoWithString:strReqno];
            if ([tztReqno getReqdefOne]  == KLineCycleDay + 1) //日线才保存
            {
                dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
                dispatch_async (FileWriteQueue,^
                                {
                                    NSString* strPath = [self getTechPath];
                                    [parse WriteParse:strPath];
                                }
                                );
                dispatch_release(FileWriteQueue);
            }
        }
    }
    return 1;
}
//读取本地数据并刷新
- (void)readParse
{
    if (!MakeWHMarket(self.pStockInfo.stockType))
    {
        dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
        dispatch_async (FileWriteQueue,^
                        {
                            NSString* strPath = [self getTechPath];
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
    else
    {
        [self setNeedsDisplay];
    }
}


#pragma tztSocketData Delegate
- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if( wParam == 0 )
        return 0;
    tztNewMSParse *parse = (tztNewMSParse*)wParam;
    if([parse IsIphoneKey:(long)self reqno:_ntztHqReq])
    {
        return [self dealParse:parse IsRead:FALSE];
    }
    return 0;
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
    
    _preClickPoint = lastPoint;
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    _bTwoTouchBegin = FALSE;
    
    _beginPoint = [[[touches allObjects] objectAtIndex:0] locationInView:self];
    if ([[event allTouches] count] == 2)
    {
        _beginPoint = [[[[event allTouches] allObjects] objectAtIndex:0] locationInView:self];
        _beginPointEx = [[[[event allTouches] allObjects] objectAtIndex:1] locationInView:self];
//        _beginPointEx = [[[touches allObjects] objectAtIndex:1] locationInView:self];
        _lastPointEx = _beginPointEx;
        _bTwoTouchBegin = TRUE;
    }
    else
    {
        _lastPointEx = _beginPoint;
    }
    _lastPoint = _beginPoint;
    
    _TechCursorPoint = [touch locationInView:self];
    if (!self.needPickerView) {
        if(_tztPickerView)
            _tztPickerView.hidden = YES;
    }
    
    if (_TechObjPKLine && ![_TechObjVol ParamRectContainsPoint:_TechCursorPoint])
    {
        if(_tztEditView)
            _tztEditView.hidden = YES;
    }
    if (_bIgnorTouch)
    {
        _TechCursorDraw = NO;
        return;
    }
    _nPrevious = event.timestamp;
    [self CalculateDrawIndex:1];
    [self setNeedsDisplay];
}

//关闭自动刷新  ipad打开历史分时时候，关闭自动刷新功能，否则会有问题
-(void)tztStopRequest:(BOOL)bStop
{
    //如果刷新已经关闭了，则不设置刷新状态
    int nTime = [tztTechSetting getInstance].nRequestTimer;
    if (nTime == 0)
        return;
    
    _bRequest = bStop;
}

/*获取历史分时的日期
 hqView     -当前的k线界面
 nDirection -0,向前，1-向后
 返回： 成功返回日期，失败返回空字符串
 add by yinjp 20130715
 */
-(NSString*)GetHisDate:(id)hqView direction:(UInt16)nDirection
{
    NSString* nsDate = @"";
    if (hqView == self)
    {
        NSInteger nValueCount = [_ayTechValue count];
        if (nDirection == 0)
        {
            _TechCurIndex -= 1;
            if (_TechCurIndex < 0 )
                _TechCurIndex = 0;
        }
        if (nDirection == 1)
        {
            _TechCurIndex += 1;
            if (_TechCurIndex > nValueCount)
                _TechCurIndex = nValueCount;
        }
        
        if (_TechCurIndex >= 0 && _TechCurIndex < nValueCount)
        {
            tztTechValue* preTechValue;
            if(_TechCurIndex == 0)
                preTechValue = [_ayTechValue objectAtIndex:0];
            else
                preTechValue = [_ayTechValue objectAtIndex:_TechCurIndex-1];
            nsDate = [NSString stringWithFormat:@"%u",preTechValue.ulTime];
        }
    }
    
    return nsDate;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
//	NSUInteger numTaps = [touch tapCount];
//    if (numTaps >= 2) //双击
    {
        if (_TechCursorDraw && _TechObjPKLine && CGRectContainsPoint(_rcHisTrend, _TechCursorPoint))
        {
            if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:RequestHisTrend:nsHisDate:)])
            {
                NSInteger nValueCount = [_ayTechValue count];
                if (_TechCurIndex >= 0 && _TechCurIndex < nValueCount)
                {
                    tztTechValue* preTechValue;
                    if(_TechCurIndex == 0)
                        preTechValue = [_ayTechValue objectAtIndex:0];
                    else
                        preTechValue = [_ayTechValue objectAtIndex:_TechCurIndex];
                    NSString* strValue = [NSString stringWithFormat:@"%u",preTechValue.ulTime];
                    
                    [_tztdelegate tzthqView:self RequestHisTrend:self.pStockInfo nsHisDate:strValue];
                }
            }
            return;
        }
        
        if (CGRectContainsPoint(_rcObj, _TechCursorPoint))
        {
            _TechCursorDraw = NO;
            _nObjIndex++;
            if (_nObjIndex >= _ayZhiBiao.count)
                _nObjIndex = 0;
            int nKLineZhiBiao = [[_ayZhiBiao objectAtIndex:_nObjIndex] intValue];
            [_btnZhiBiao setTztTitle:getZhiBiaoName(nKLineZhiBiao)];
            [self tztChangeZhiBiao:nKLineZhiBiao];
//            [self onClickZhiBiao:nil];
            return;
        }
        if (CGRectContainsPoint(_rcChuQuan, _TechCursorPoint))
        {
            if([tztTechSetting getInstance].nKLineChuQuan == 0)
            {
                [tztTechSetting getInstance].nKLineChuQuan = 1;
            }
            else
            {
                [tztTechSetting getInstance].nKLineChuQuan = 0;
            }
            
            [self onClearData];
            [self onRequestData:TRUE];
            return;
        }
        
        //zxl 20131017 场外基金点击这些区域是没有用的
        if (_bTouchParams && _TechObjPKLine && [_TechObjPKLine ParamRectContainsPoint:_TechCursorPoint]&&!MakeHTFundMarket(self.pStockInfo.stockType))
        {
            TZTNSLog(@"%@",@"点击参数列");
            [self onDbClickParam:_TechObjPKLine];
            return;
        }
        else if (_bTouchParams && _TechObjVol && [_TechObjVol ParamRectContainsPoint:_TechCursorPoint]&&!MakeHTFundMarket(self.pStockInfo.stockType))
        {
            TZTNSLog(@"%@",@"点击参数列");
            [self onDbClickParam:_TechObjVol];
            return;
        }
        else if (_bTouchParams && _TechObjMACD && [_TechObjMACD ParamRectContainsPoint:_TechCursorPoint]&&!MakeHTFundMarket(self.pStockInfo.stockType))
        {
            TZTNSLog(@"%@",@"点击参数列");
            [self onDbClickParam:_TechObjMACD];
            return;
        }
//        if (_bTechMoved)
//            _TechCursorDraw = NO;
//        else
        if (!_bMoved && _bSupportTechCursor)
            _TechCursorDraw = !_TechCursorDraw;
        
    }
    if (CGRectContainsPoint([_TechObjPKLine getDrawRect], _TechCursorPoint))
    {
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(showHorizenView:)])
        {
            BOOL bDeal = [self.tztdelegate showHorizenView:self];
            if (bDeal)
                return;
        }
    }
    else if (CGRectContainsPoint([_TechObjMACD getDrawRect], _TechCursorPoint)
             || CGRectContainsPoint([_TechObjVol getDrawRect], _TechCursorPoint))
    {
        //切换指标
        _TechCursorDraw = NO;
        _nObjIndex++;
        if (_nObjIndex >= _ayZhiBiao.count)
            _nObjIndex = 0;
        int nKLineZhiBiao = [[_ayZhiBiao objectAtIndex:_nObjIndex] intValue];
        [_btnZhiBiao setTztTitle:getZhiBiaoName(nKLineZhiBiao)];
        [self tztChangeZhiBiao:nKLineZhiBiao];
        return;
    }
    _TechCursorPoint = [touch locationInView:self];
    
    if (_bIgnorTouch)
    {
        _TechCursorDraw = NO;
        return;
    }
//    if (_bMoved)
//    {
//        //计算滑动速度，进行界面减速缓冲
//        CGPoint location = [touch locationInView:self];
//        CGPoint prevLocation = [touch previousLocationInView:self];
//        CGFloat distanceFromPrevious = distanceBetweenPoints(location,prevLocation);
//        NSTimeInterval timeSincePrevious = event.timestamp - _nPrevious;
//        CGFloat speed = distanceFromPrevious/timeSincePrevious;
//        _nPrevious = event.timestamp;
//        
//        NSLog(@"==========结束滑动速度：%lf", speed);
//        
//        if (speed > 100)
//        {
//            speed = 7;
//        }
//        else if(speed > 50)
//        {
//            speed = 3;
//        }
//        else
//            speed = 1;
//        
//        for (int i = 0; i < speed; i++)
//        {
//            [NSTimer scheduledTimerWithTimeInterval:0.1f
//                                             target:self
//                                           selector:@selector(OnRefresh)
//                                           userInfo:nil
//                                            repeats:NO];
//            
//        }
//    }
//    else
    {
        [self CalculateDrawIndex:1];
        [self setNeedsDisplay];
        _bMoved = FALSE;
    }
}

-(void)OnRefresh
{
    [self onCacluteTechArray];
    [self CalculateValue];//计算数据
    [self CalculateDrawIndex:(_TechStartIndex > 0 ? 1 : 0)];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _bMoved = TRUE;
    if(_TechCursorDraw && _bSupportTechCursor)
    {
        if (_bIgnorTouch)
        {
            _TechCursorDraw = NO;
            return;
        }
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        _TechCursorPoint = [touch locationInView:self];
        [self CalculateDrawIndex:1];
        [self setNeedsDisplay];
    }
    else//k线拖动
    {
        if (!_bTechMoved)
            return;
        
        //计算滑动速度
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:self];
        CGPoint prevLocation = [touch previousLocationInView:self];
        CGFloat distanceFromPrevious = distanceBetweenPoints(location,prevLocation);
        NSTimeInterval timeSincePrevious = event.timestamp - _nPrevious;
        CGFloat speed = distanceFromPrevious/timeSincePrevious;
        _nPrevious = event.timestamp;
        
        float fSp = speed / 100;
//        if (speed < 50)
//            fSp = 0.5;
//        else if(speed >= 50 && speed < 100)
//            fSp = 1.5;
//        else
//            fSp = 2.5;
//        if (speed > 100)
//        {
//            fSp = 7;
//        }
//        else if(speed > 50)
//        {
//            fSp = 4;
//        }
//        else
//            fSp = 1;
//        
//        if (fSp > 7)
//            fSp = 7;
        
        _currentPoint = [[[touches allObjects] objectAtIndex:0] locationInView:self];
        
        if ([[event allTouches] count] == 2)
        {
            _currentPoint = [[[[event allTouches] allObjects] objectAtIndex:0] locationInView:self];
            _currentPointEx = [[[[event allTouches] allObjects] objectAtIndex:1] locationInView:self];
            CGFloat currentDistance = distanceBetweenPoints(_currentPoint,_currentPointEx);
            CGFloat oldDistance = distanceBetweenPoints(_beginPoint, _beginPointEx);
            if (!_bTwoTouchBegin)
                oldDistance = currentDistance;
            
            if (currentDistance > oldDistance)//放大
            {
                [self OnZoom:NO];
            }
            else if (currentDistance < oldDistance)//缩小
            {
                [self OnZoom:YES];
            }
//            _lastPoint = _currentPoint;
//            _lastPointEx = _currentPointEx;
            return;
        }
        if (_currentPoint.x > _lastPoint.x)//向右滑动
        {
            _TechStartIndex -= (1* fSp);
            NSInteger nStartPos = [_ayTechValue count];// - _TechEndIndex;
            if (nStartPos < 0)
                nStartPos = 0;
            if (_TechStartIndex  <= 0)
            {
                _TechStartIndex = [_ayTechValue count];
                if (_TechStartIndex <= 0)
                    _TechStartIndex = -1;
                _TechCurIndex = _TechStartIndex;
                [self OnMovess:nStartPos];
                return;
            }
            
            [self onCacluteTechArray];
            [self CalculateValue];//计算数据
            [self CalculateDrawIndex:(_TechStartIndex > 0 ? 1 : 0)];
            //        }
        }
        else if (_currentPoint.x < _beginPoint.x)//向左滑动
        {
            _TechStartIndex +=(1 * fSp);
            if (_TechStartIndex >= [_ayTechValue count])
            {
                _TechStartIndex = [_ayTechValue count] - 1;
                return;
            }
            [self onCacluteTechArray];
            [self CalculateValue];//计算数据
            [self CalculateDrawIndex:(_TechStartIndex > 0 ? 3 : 0)];
        }
        [self setNeedsDisplay];
    }
    
    _beginPoint = [[[touches allObjects] objectAtIndex:0] locationInView:self];
    if ([[event allTouches] count] == 2)
    {
        _beginPoint = [[[[event allTouches] allObjects] objectAtIndex:0] locationInView:self];
//        _beginPointEx = [[[[event allTouches] allObjects] objectAtIndex:1] locationInView:self];
        //        _beginPointEx = [[[touches allObjects] objectAtIndex:1] locationInView:self];
//        _lastPointEx = _beginPointEx;
//        _bTwoTouchBegin = TRUE;
    }
    _lastPoint.x = _currentPoint.x;
    _lastPoint.y = _currentPoint.y;
    _lastPointEx.x = _currentPointEx.x;
    _lastPointEx.y = _currentPointEx.y;
}

-(void)trendTouchMoved:(CGPoint)point bShowCursor_:(BOOL)bShowCursor
{
    _TechCursorPoint = point;
    _TechCursorDraw = bShowCursor;
    [self CalculateDrawIndex:1];
    [self setNeedsDisplay];
}

//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    _KLineCursor = CGPointZero;
//    [self setNeedsDisplay];
//}
#pragma tztPickerView Delegate
//几类
- (NSInteger)numberOfComponentsIntztPickerView:(tztUIPickerView *)pickerView
{
    if(pickerView.tag == tagtztCycle)
        return 1;
    else if(pickerView.tag == tagtztZhibiao)
        return 1;
    return  0;
}


//对应数据数
- (NSInteger)tztPickerView:(tztUIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == tagtztCycle)
        return [_ayCycle count];
    else if(pickerView.tag == tagtztZhibiao)
        return [_ayZhiBiao count];
    return 0;
}

- (NSString *)tztPickerView:(tztUIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == tagtztCycle)
    {
        tztKLineCycle nKLineCycle = [[_ayCycle objectAtIndex:row] intValue];
        if(nKLineCycle == KLineChuQuan)
        {
            return [tztTechSetting getInstance].nKLineChuQuan ? @"复权":@"除权";
        }
        return getCycleName(nKLineCycle);
    }
    else if(pickerView.tag == tagtztZhibiao)
        return getZhiBiaoName([[_ayZhiBiao objectAtIndex:row] intValue]);
    return @"";
}

- (BOOL)tztPickerView:(tztUIPickerView *)pickerView isSelectForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == tagtztCycle)
    {
        tztKLineCycle nKLineCycle = [[_ayCycle objectAtIndex:row] intValue];
        if(nKLineCycle == KLineChuQuan)
        {
            return TRUE;
        }
        else if(nKLineCycle == _KLineCycleStyle)
        {
            return TRUE;
        }
    }
    else if(pickerView.tag == tagtztZhibiao)
    {
        return [[_ayZhiBiao objectAtIndex:row] intValue] == _KLineZhibiao;
    }
    return FALSE;
}

-(void)tztChangeCycle:(int)nKLineCycleStyle picker_:(tztUIPickerView *)pickerView
{
    if(KLineChuQuan == nKLineCycleStyle)
    {
        if([tztTechSetting getInstance].nKLineChuQuan == 0)
        {
            [tztTechSetting getInstance].nKLineChuQuan = 1;
        }
        else
        {
            [tztTechSetting getInstance].nKLineChuQuan = 0;
        }
        pickerView.hidden = YES;
        [self onClearData];
        [self onRequestData:TRUE];
        return;
    }
    
    if(nKLineCycleStyle == KLineCycleCustomMin || nKLineCycleStyle == KLineCycleCustomDay)
    {
        NSString* strTitle = getCycleName(nKLineCycleStyle);
        NSMutableArray* ayValue = NewObject(NSMutableArray);
        NSMutableDictionary* values = NewObject(NSMutableDictionary);
        [values setValue:strTitle forKey:@"title"];
        
        if (nKLineCycleStyle == KLineCycleCustomDay)
        {
            [values setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[tztTechSetting getInstance].nTechCustomDay] forKey:@"value"];
        }
        else
        {
            [values setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[tztTechSetting getInstance].nTechCustomMin] forKey:@"value"];
        }
        [values setValue:[NSNumber numberWithLong:nKLineCycleStyle] forKey:@"key"];
        [ayValue addObject:values];
        
        [values release];
        [self onClickEditView:ayValue titleTip:@"" Tag:tagtztEditParam];
        [ayValue release];
        return;
    }
    if(_KLineCycleStyle != nKLineCycleStyle)
    {
        self.KLineCycleStyle = nKLineCycleStyle;
        
        if(_TechObjPKLine)
        {
            _TechObjPKLine.KLineCycleStyle = self.KLineCycleStyle;
        }
        
        if(_TechObjVol)
        {
            _TechObjVol.KLineCycleStyle = self.KLineCycleStyle;
        }
        
        if (_TechObjMACD)
        {
            _TechObjMACD.KLineCycleStyle = self.KLineCycleStyle;
        }
        
        NSString* strTitle = getCycleName(_KLineCycleStyle);
        [_btnCycle setTztTitle:strTitle];
        [self onClearData];
        [self onRequestData:TRUE];
        if(_KLineCycleStyle == KLineCycleDay)
            [self readParse];
    }
}

-(void)tztChangeZhiBiao:(NSInteger)nKLineZhiBiao
{
    [self setKLineZhibiao:nKLineZhiBiao];
    [self CalculateValue];
    [self setNeedsDisplay];
}

- (void)tztPickerView:(tztUIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_tztEditView)
        _tztEditView.hidden = YES;
    
    if(pickerView.tag == tagtztCycle)
    {
        TZTNSLog(@"%@",[_ayCycle objectAtIndex:row]);
        pickerView.hidden = YES;
        int nKLineCycleStyle = [[_ayCycle objectAtIndex:row] intValue];
        [self tztChangeCycle:nKLineCycleStyle picker_:pickerView];
    }
    else if(pickerView.tag == tagtztZhibiao)
    {
        TZTNSLog(@"%@",[_ayZhiBiao objectAtIndex:row]);
        pickerView.hidden = YES;
        int nKLineZhiBiao = [[_ayZhiBiao objectAtIndex:row] intValue];
        _nObjIndex = row;
        [_btnZhiBiao setTztTitle:getZhiBiaoName(nKLineZhiBiao)];
        [self tztChangeZhiBiao:nKLineZhiBiao];
    }
}

#pragma tztEditView Delegate
- (void)tztEditView:(tztUIEditValueView *)editView didEditValue:(NSArray *)ayValue
{
    //自定义周期
    if(_tztPickerView)
        _tztPickerView.hidden = YES;
    NSInteger tag = editView.tag;
     editView.hidden = YES;
    if(tag == tagtztEditParam)
    {
        [ayValue retain];
        NSDictionary* value = [ayValue objectAtIndex:0];
        NSNumber* key = [value objectForKey:@"key"];
        NSString* strValue = [value objectForKey:@"value"];
        if(key && strValue && [strValue length] > 0)
        {
            int nKLineCycleStyle = [key intValue];
            NSString* strTitle = getCycleName(_KLineCycleStyle);
            if(nKLineCycleStyle == KLineCycleCustomMin)
            {
                [tztTechSetting getInstance].nTechCustomMin = [strValue intValue];
                strTitle = [NSString stringWithFormat:@"%ld分钟",(unsigned long)[tztTechSetting getInstance].nTechCustomMin];
            }
            else if(nKLineCycleStyle == KLineCycleCustomDay)
            {
                [tztTechSetting getInstance].nTechCustomDay = [strValue intValue];
                strTitle = [NSString stringWithFormat:@"%ld日线",(unsigned long)[tztTechSetting getInstance].nTechCustomDay];
            }

            self.KLineCycleStyle = nKLineCycleStyle;
            if(_TechObjPKLine)
            {
                _TechObjPKLine.KLineCycleStyle = self.KLineCycleStyle;
            }
            
            if(_TechObjVol)
            {
                _TechObjVol.KLineCycleStyle = self.KLineCycleStyle;
            }
            
            if (_TechObjMACD)
            {
                _TechObjMACD.KLineCycleStyle = self.KLineCycleStyle;
            }
            [_btnCycle setTztTitle:strTitle];
            [[tztTechSetting getInstance] SaveData];
            [self onClearData];
            [self onRequestData:TRUE];
        }
        [ayValue release];
    }
    else
    {
        tztTechObj* techobj = (tztTechObj *)tag;
        if(techobj)
        {
            NSInteger nKLineZhiBiao = techobj.KLineZhibiao;
            if(nKLineZhiBiao == VOL)
                nKLineZhiBiao = PKLINE;
            tzttechParamSet* paramset = [[tztTechSetting getInstance].techParamSetting objectForKey:[NSString stringWithFormat:@"%ld",(long)nKLineZhiBiao]];
            if(paramset)
            {
                [ayValue retain];
                NSInteger nCount = MIN([ayValue count], [paramset.ayParams count]);
                for (NSInteger i = 0; i < nCount; i++)
                {
                    NSDictionary* Values = [ayValue objectAtIndex:i];
                    if(Values)
                    {
                        NSString* strValue = [Values objectForKey:@"value"];
                        NSNumber* numValue = [NSNumber numberWithInt:[strValue intValue]];
                        [paramset.ayParams replaceObjectAtIndex:i withObject:numValue];
                    }
                }
                [[tztTechSetting getInstance].techParamSetting setObject:paramset forKey:[NSString stringWithFormat:@"%ld",(long)nKLineZhiBiao]];
                [[tztTechSetting getInstance] SaveData];
                [ayValue release];
                [self CalculateValue];//计算数据
                [self setNeedsDisplay];
            }
            
        }
    }
}

-(TNewPriceData*)GetNewPriceData
{
    return _PriceData;
}

-(TNewKLineHead*)GetNewKLineHead
{
    return _techHead;
}

-(void)setStockInfo:(tztStockInfo*)pStock
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
    {
        [_tztdelegate tzthqView:self setStockCode:pStock];
    }
}

-(void)tztEditView:(tztUIEditValueView *)editView shouldBeginEdit:(UITextField *)textField
{
    if (editView == _tztEditView)
    {
        CGRect rcEdit = _tztEditView.frame;
        int nY = [editView gettztwindowy:nil];
        int nKeyboardheight = 220;
        CGFloat fMaxHeight = TZTScreenHeight;
        if(IsTZTLandscape)
        {
            nKeyboardheight = 160;
            fMaxHeight = TZTScreenWidth;
        }
        
        if(nY >= fMaxHeight - nKeyboardheight - editView.frame.size.height)
        {
            _nKeybordOffset = (nY) - (fMaxHeight - nKeyboardheight - editView.frame.size.height);
            CGFloat locY = rcEdit.origin.y - _nKeybordOffset;
            if( locY >= 0)
            {
                rcEdit.origin = CGPointMake(rcEdit.origin.x, locY);
            }
            else
            {
                rcEdit.size.height += (locY);
                rcEdit.origin.y = 0;
            }
            _tztEditView.frame = rcEdit;
        }
    }
}

-(void)tztEditView:(tztUIEditValueView *)editView shouldEndEdit:(UITextField *)textField
{
    if (editView == _tztEditView)
    {   
        if (_nKeybordOffset > 0)
        {   
            CGRect rcEdit = _tztEditView.frame;
            rcEdit.origin = CGPointMake(rcEdit.origin.x, rcEdit.origin.y + _nKeybordOffset);
            _tztEditView.frame = rcEdit;
        }
        _nKeybordOffset = 0;
    }
}

#pragma tztTechObjDelegate
//返回K线数据
- (NSMutableArray*)tztTechObjAyValue:(tztTechObj *)techObj
{
    return _ayTechValue;
}

- (NSMutableDictionary*)tztTechObjAyValueTime:(tztTechObj *)techObj
{
    return nil;
}

- (NSInteger)CalculateDrawIndex:(NSInteger)nKind
{
    if(CGRectIsEmpty(_KLineDrawRect))
        return 0;
    if(_KLineCellWidth <= 0)
        return 0;
    if(_ayTechValue == nil || [_ayTechValue count] <= 0)
        return 0;
    NSInteger nOldTechCount = _TechCount;
    _TechCount = [_ayTechValue count];
    
    //数据有偏移
    if(nOldTechCount == 0)
    {
        nKind = 0;
    }
    else if(_TechCount != nOldTechCount || nKind == 1)//数据有变动
    {
        if(_TechStartIndex >= 0 && _TechStartIndex < _TechCount)
            _TechStartIndex += (_TechCount - nOldTechCount);
        if(_TechStartIndex < 0 )
            _TechStartIndex = 0;
        if(_TechStartIndex >= _TechCount)
            _TechStartIndex = _TechCount - 1;
        
        if(_TechCurIndex >= 0 && _TechCurIndex < _TechCount)
        {
            _TechCurIndex += (_TechCount - nOldTechCount);
            if(_TechCurIndex < 0 )
                _TechCurIndex = 0;
            if(_TechCurIndex >= _TechCount)
                _TechCurIndex = _TechCount - 1;
        }
    }
    
    BOOL bMoveCur = FALSE;
    int nDrawCount = MIN(_TechCount,(CGRectGetWidth(_KLineDrawRect)- _YAxisWidth - 2) / _KLineCellWidth);
    if(nKind == 0 || nKind == 1)//重新计算
    {
        if(nKind == 0)
            _TechStartIndex = MAX(_TechCount-nDrawCount, 0);
        if(_TechCursorDraw || _bMoved)
        {
            _TechCurIndex = _TechStartIndex + (_TechCursorPoint.x - CGRectGetMinX(_KLineDrawRect) - _YAxisWidth) / _KLineCellWidth;
        }
        else
        {
            _TechCurIndex = -1;
        }
    }
    else if( nKind == 2 )
    {
        bMoveCur = TRUE;
//        if (_bTechMoved)
//            return 1;
        if(!_TechCursorDraw)
        {
            _TechCurIndex = _TechEndIndex-1;
        }
        if(_TechCurIndex >= 0 && _TechCurIndex < _TechCount)
        {
            if(_TechStartIndex > _TechCurIndex)
            {
                _TechStartIndex = _TechCurIndex;
               
            }
            else if(_TechCurIndex  > _TechStartIndex + nDrawCount)
            {
                _TechStartIndex = MAX(_TechCurIndex - nDrawCount + 1,0);
            }
        }
//        if(!_TechCursorDraw)
//        {
//            _TechCurIndex = -1;
//        }
       
    }
    
    if(nDrawCount > _TechCount-_TechStartIndex) //绘制不完全
    {
//        if (_bTechMoved)
//            _TechStartIndex = MIN(_TechCount-nDrawCount, 0);
//        else
        //        _TechStartIndex = MAX(_TechCount-nDrawCount, 0);
        if (nKind == 3)
        {
            _TechStartIndex = MAX(_TechCount-nDrawCount, 0);
        }
        else
            _TechStartIndex = MIN(_TechCount-nDrawCount, 0);
        bMoveCur = TRUE;
    }
    else
    {
        if (_TechStartIndex == 0 && _nStartPos == 0)//防止数据超过1屏显示，第一次显示的不是最新日期的数据
        {
            _TechStartIndex = MAX(_TechCount - nDrawCount, 0);
            _bFirst = FALSE;
        }
    }
    _TechEndIndex = _TechStartIndex + MIN(_TechCount-_TechStartIndex,nDrawCount);
    
    if(bMoveCur && _TechCursorDraw)
    {
        _TechCursorPoint.x = CGRectGetMinX(_KLineDrawRect)+ _YAxisWidth + (_TechCurIndex - _TechStartIndex) * _KLineCellWidth + _KLineCellWidth/2.0f;
    }
    return 1;
}

//获取当前光标线所在位置的当天的tztTechValue
- (tztTechValue *)GetCurIndexTechValue
{
    if (self.ayTechValue && [self.ayTechValue count] > 0 && [self.ayTechValue count] > _TechCurIndex)
    {
        return [self.ayTechValue objectAtIndex:_TechCurIndex];
    }
    return NULL;
}


CGFloat distanceBetweenPoints(CGPoint first, CGPoint second)
{
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY);
};

@end
