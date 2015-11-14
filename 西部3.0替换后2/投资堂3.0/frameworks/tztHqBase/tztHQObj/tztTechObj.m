/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztTechObj.m
 * 文件标识：
 * 摘    要：K线图单元
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * // zxl  20131206 修改了炒跟K线界面现实方式
 *******************************************************************************/

#import "tztTechObj.h"
#import "tztTechObjBase.h"

#define tztBuySaleMapHeight 35
#define PI 3.14159265358979323846
@interface  tztTechObj ()
{
    NSInteger         _KLineStart;//开始序号
    NSInteger         _KLineCount;//绘制总数
    
    NSInteger         _KLineCellWidth;//K线绘制单元宽度
    NSInteger         _KLineWidth;//K线宽度
    CGFloat     _YAxisWidth;//Y轴宽度
    tztKLineAxisStyle _KLineAxisStyle; //坐标绘制类型
    
    CGPoint     _KLineCursor; //光标点
    NSInteger   _KLineCurIndex; //当前光标序号
    BOOL        _KLineDrawCursor;//是否绘制光标线
    long        _KLineCursorValue;//光标值
    
	NSString*   _techName; //名称
    tzttechParamSet*     _techParamSet;//参数设置
    NSMutableArray*    _ayParamsValue;//参数值
    
    double        _MaxValue;//最大值
    double        _MinValue;//最小值
    
    NSInteger         _lDiv;//值除数
    NSInteger         _lDecimal;//小数位数
    
    id<tztTechObjDelegate>          _techView;
    
}
#pragma K线值计算
//计算K线值
- (void)CalculateKLineValues;
//计算Param值
- (void)CalculateParamValues;
//计算均线
- (void)CalculateMAParamValues;
//计算最大最小值
- (void)CalculateVolMaxMinValue;
- (void)CalculatePriceMaxMinValue;
- (void)CalculateParamMaxMinValue;
//计算K线指标数据
- (void)CalculateMACDValues;
- (void)CalculateKDJValues;
- (void)CalculateRSIValues;
- (void)CalculateWRValues;
- (void)CalculateBOLLValues;
- (void)CalculateDMIValues;
- (void)CalculateDMAValues;
- (void)CalculateTRIXValues;
- (void)CalculateBRARValues;
- (void)CalculateCRValues;
- (void)CalculateVRValues;
- (void)CalculateOBVValues;
- (void)CalculateASIValues;
- (void)CalculateEMVValues;
- (void)CalculateWVADValues;
- (void)CalculateSARValues;
- (void)CalculateCCIValues;
- (void)CalculateROCValues;
- (void)CalculateBIASValues;

#pragma K线绘制
//绘制K线数据图
- (void)onDrawKLineValues:(CGContextRef)context;
//绘制Param线
- (void)onDrawParamLines:(CGContextRef)context;
//绘制参数行
- (void)onDrawParams:(CGContextRef)context;
//绘制场外基金参数数据
- (void)onDrawOutFundParams:(CGContextRef)context;
//绘制坐标
- (void)onDrawAxis:(CGContextRef)context;

#pragma K线取值
//获取数据对应位置
-(CGFloat) ValueToVertPos:(CGRect)drawRect value:(double)lValue;
#pragma K线基础绘制
//绘制K线美国线
- (void)onDrawAmericaLineStyle:(CGContextRef)context;
//绘制场外基金线
- (void)onDrawOutFundLineStyle:(CGContextRef)context;
//绘制K线蜡烛图
- (void)onDrawPKLineStyle:(CGContextRef)context;
//绘制量
- (void)onDrawVolStyle:(CGContextRef)context rect:(CGRect)drawRect values:(NSArray*)ayValues
              maxvalue:(double)lMaxValue;
//绘制Param线
- (void)onDrawLinesStyle:(CGContextRef)context rect:(CGRect)drawRect valueIndex:(NSInteger)iIndex
                maxValue:(double)lMaxValue minValue:(double)lMinValue;
//绘制MACD
- (void)onDrawMACDStyle:(CGContextRef)context rect:(CGRect)drawRect values:(NSArray*)ayValues
              reference:(double)lReference maxdiff:(double)lMaxDiff;

//绘制Y坐标
- (void)onDrawYAxis:(CGContextRef)context nums:(int)lNums;
//绘制X坐标
- (void)onDrawXAxis:(CGContextRef)context;
- (void)onGetCursorValue:(CGPoint)point;
//绘制光标线
- (void)onDrawCursor:(CGContextRef)context;
//初始化参数
- (void)initParams:(NSInteger)nZhiBiao;
@end

@implementation tztTechObj
@synthesize KLineWidth = _KLineWidth;//K线宽度
@synthesize YAxisWidth = _YAxisWidth;

@synthesize techName = _techName;
@synthesize techParamSet = _techParamSet;
@synthesize ayParamsValue = _ayParamsValue; //参数值
@synthesize MaxValue = _MaxValue; //最大值
@synthesize MinValue = _MinValue; //最小值

@synthesize KLineAxisStyle = _KLineAxisStyle; //坐标绘制类型
@synthesize KLineZhibiao = _KLineZhibiao;//指标 PKLine VOL MACD
@synthesize KLineCycleStyle = _KLineCycleStyle;//周期
@synthesize KLineCursor = _KLineCursor;
@synthesize bIsDrawParams = _bIsDrawParams;
@synthesize fKLineViewChangeHeight = _fKLineViewChangeHeight;
@synthesize techView = _techView; //add by xyt 20130725
@synthesize kLineOutFund = _kLineOutFund;
@synthesize bIsShowCheDan = _bIsShowCheDan;
@synthesize bShowLeftInSide = _bShowLeftInSide;
@synthesize bShowMaxMin = _bShowMaxMin;
- (id)init
{
    self = [super init];
    if (self) 
    {
       [self initdata];
    }
    return self; 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initdata];
    }
    return self; 
}

- (void)initdata
{
    [super initdata];
    
    _KLineCellWidth = 0;//单元宽度
    _KLineWidth = 0;//K线宽度
    _YAxisWidth = 0.f;
    
    _KLineCursor = CGPointZero;
    _KLineDrawCursor = FALSE;
    
    _KLineStart = 0;//开始序号
    _KLineCount = INT32_MAX;//总数

    self.techName = @"";
    self.techParamSet = nil;
    _ayParamsValue = NewObject(NSMutableArray);
    _MaxValue = 0;
    _MinValue = INT32_MAX;
    self.KLineAxisStyle = KLineXYAxis; //坐标绘制类型
    
    _KLineZhibiao = PKLINE;//指标 PKLINE VOL MACD
    _bIsShowCheDan = TRUE;
    _lDiv = 1;
    _lDecimal = 0;
    _KLineDrawRect = CGRectZero;//绘制区域
    _KLineParamRect = CGRectZero;//参数区域
    
    
    _KLineCycleStyle = KLineCycleDay;//周期类型
    _bIsDrawParams = TRUE;
    _fKLineViewChangeHeight = 0;
    _kLineOutFund = KLineOutFundNo;
}

- (void)onClearData
{
    [super onClearData];
    if(_ayParamsValue)
    {
        [_ayParamsValue removeAllObjects];
    }
    _MaxValue = 0;
    _MinValue = INT32_MAX;

    _lDiv = 1;
    _lDecimal = 0;
}

- (void)dealloc
{
    DelObject(_ayParamsValue);
    self.techView = nil;
    self.techParamSet = nil;
    self.techName = nil;
    [super dealloc];
}

- (void)initParams:(NSInteger)nZhiBiao;
{
    self.techParamSet = [[tztTechSetting getInstance].techParamSetting objectForKey:[NSString stringWithFormat:@"%ld",(long)nZhiBiao]];
}


- (void)CalculateValue
{
    [self initZhibiaoData];
    if(_KLineZhibiao == PKLINE)     //计算K线值
    {
        [self CalculateKLineValues];
        [self CalculatePriceMaxMinValue];
    }
    else if(_KLineZhibiao == VOL)
    {
        [self CalculateVolMaxMinValue];
    }
    
    if (_kLineOutFund)
        return;
    //计算Param值
    [self CalculateParamValues];
    [self CalculateParamMaxMinValue];
}

- (void)setDiv:(NSInteger)lDiv Decimal:(NSInteger)lDecimal
{
    _lDiv = pow(10, lDiv);
    _lDecimal = lDecimal;
}

- (void)initZhibiaoData
{
    _MaxValue = INT32_MIN;
    _MinValue = INT32_MAX;
    self.techName = getZhiBiaoName(_KLineZhibiao);
    NSInteger nParamKind = _KLineZhibiao;
    switch (_KLineZhibiao) {
        case PKLINE:
            break;
        case VOL:
            _MinValue = 0;
            nParamKind = PKLINE;
            break;
        case MACD:
            break;
        case KDJ:
            [self setDiv:2 Decimal:2];
            _MaxValue = 10000;
            _MinValue = 0;
            break;
        case RSI:
            [self setDiv:2 Decimal:2];
            break;
        case WR:
            [self setDiv:2 Decimal:2];
            break;
        case BOLL:
            [self setDiv:3 Decimal:2];
            break;
        case DMI:
            [self setDiv:2 Decimal:2];
            break;
        case DMA:
            [self setDiv:3 Decimal:2];
            break;
        case TRIX:
            break;
        case BRAR:
            [self setDiv:2 Decimal:2];
            break;
        case TZTCR:
            [self setDiv:2 Decimal:2];
            break;
        case VR:
            [self setDiv:2 Decimal:2];
            break;
        case OBV:
            [self setDiv:2 Decimal:2];
            break;
        case ASI:
            [self setDiv:2 Decimal:2];
            break;
        case EMV:
            [self setDiv:2 Decimal:2];
            break;
        case WVAD:
            break;
        case SAR:
            break;
        case CCI:
            [self setDiv:2 Decimal:2];
            break;
        case ROC:
            [self setDiv:2 Decimal:2];
            break;
        case BIAS:
            break;
        default:
            break;
    }
    [self initParams:nParamKind];
}

- (void)setKLineCellWidth:(NSInteger)nKLineCellWidth
{
     if(_KLineCellWidth == nKLineCellWidth || nKLineCellWidth <= 0)
         return;
    _KLineCellWidth = nKLineCellWidth;
}

- (void)setKLineZhibiao:(NSInteger)nKLineZhiBiao
{
    _KLineZhibiao = nKLineZhiBiao;
    [self initZhibiaoData];
}

- (void)CalculateVolMaxMinValue
{
    _MaxValue = 0;
    _MinValue = 0;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    for (int i = 0; i < MIN(nValueCount-_KLineStart,_KLineCount); i++)
    {
        tztTechValue* techValue = [_ayTechValue objectAtIndex:i+_KLineStart];
        double lValue = techValue.ulTotal_h;
        if(lValue > _MaxValue)
            _MaxValue = lValue;
        if(lValue < _MinValue)
            _MinValue = lValue;
    }
    TZTNSLog(@"PriceMax=%f,Min=%f",_MaxValue,_MinValue);
}

- (void)CalculatePriceMaxMinValue
{
    _MaxValue = INT32_MIN;
    _MinValue = INT32_MAX;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    for (int i = 0; i < MIN(nValueCount-_KLineStart,_KLineCount); i++)
    {
        tztTechValue* techValue = [_ayTechValue objectAtIndex:i+_KLineStart];
        long lValue = techValue.nHighPrice;
        if(lValue > _MaxValue)
            _MaxValue = lValue;
        lValue = techValue.nLowPrice;
        if(lValue < _MinValue)
            _MinValue = lValue;
        if (_kLineOutFund == KLineOutFundHB)
        {
            lValue = techValue.ulTotal_h;
            if(lValue > _MaxValue)
                _MaxValue = lValue;
            if(lValue < _MinValue)
                _MinValue = lValue;
        }
    }
    TZTNSLog(@"PriceMax=%f,Min=%f",_MaxValue,_MinValue);
}

//计算最大最小值
- (void)CalculateParamMaxMinValue
{
    for (NSInteger i = 0; i < [_ayParamsValue count]; i++)
    {
        NSArray* ayValue = [_ayParamsValue objectAtIndex:i];
        if(ayValue)
        {
            NSInteger nValueCount = [ayValue count];
            for (int k = 0; k < MIN(nValueCount-_KLineStart,_KLineCount); k++)
            {
                double lValue = [[ayValue objectAtIndex:k+_KLineStart] doubleValue];
                if(lValue == INT32_MAX)
                    continue;
                if(lValue > _MaxValue)
                    _MaxValue = lValue;
                if(lValue < _MinValue)
                    _MinValue = lValue;
            }
        }
    }
    TZTNSLog(@"Max=%f,Min=%f",_MaxValue,_MinValue);
    switch(_KLineZhibiao)
    {
        case BOLL:
        {
            long  lParamMaxValue = _MaxValue;//最大值
            long  lParamMinValue = _MinValue;//最小值
            [self CalculatePriceMaxMinValue];
            _MaxValue = MAX(lParamMaxValue, _MaxValue);
            _MinValue = MIN(lParamMinValue, _MinValue);
        }
    }
    
}

//计算Param值
- (void)CalculateParamValues
{
    if (_kLineOutFund)
        return;
    switch (_KLineZhibiao) 
    {
        case PKLINE:
        case VOL:
            [self CalculateMAParamValues];
            break;
        case MACD:
            [self CalculateMACDValues];
            break;
        case KDJ:
            [self CalculateKDJValues];
            break;
        case RSI:
            [self CalculateRSIValues];
            break;
        case WR:
            [self CalculateWRValues];
            break;
        case BOLL:
            [self CalculateBOLLValues];
            break;
        case DMI:
            [self CalculateDMIValues];
            break;
        case DMA:
            [self CalculateDMAValues];
            break;
        case TRIX:
            [self CalculateTRIXValues];
            break;
        case BRAR:
            [self CalculateBRARValues];
            break;
        case TZTCR:
            [self CalculateCRValues];
            break;
        case VR:
            [self CalculateVRValues];
            break;
        case OBV:
            [self CalculateOBVValues];
            break;
        case ASI:
            [self CalculateASIValues];
            break;
        case EMV:
            [self CalculateEMVValues];
            break;
        case WVAD:
            [self CalculateWVADValues];
            break;
        case SAR:
            [self CalculateSARValues];
            break;
        case CCI:
            [self CalculateCCIValues];
            break;
        case ROC:
            [self CalculateROCValues];
            break;
        case BIAS:
            [self CalculateBIASValues];
            break;
        default:
            break;
    }
}

//计算K线值
- (void)CalculateKLineValues
{
    _MaxValue = INT32_MIN;
    _MinValue = INT32_MAX;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    for (NSInteger i = 0; i < MIN(nValueCount-_KLineStart,_KLineCount); i++)
    {
        tztTechValue* techValue = [_ayTechValue objectAtIndex:i+_KLineStart];
        long lValue = techValue.nHighPrice;
        if(lValue > _MaxValue)
            _MaxValue = lValue;
        lValue = techValue.nLowPrice;
        if(lValue < _MinValue)
            _MinValue = lValue;
    }
    TZTNSLog(@"PriceMax=%f,Min=%f",_MaxValue,_MinValue);
}


- (void)CalculateMAParamValues
{
    double lPriceTotal = 0; 
    
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil)
        return;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    for (NSInteger i = 0; i < _techParamSet.valueNums; i++)//参数数据
    {
        NSMutableArray* paramvalue = NewObject(NSMutableArray);
        [_ayParamsValue addObject:paramvalue];
        [paramvalue release];
    }
    
	for(NSInteger i = 0; i < MIN(_techParamSet.valueNums,[_techParamSet.ayParams count]); i++)
	{
        NSMutableArray* paramvalue = [_ayParamsValue objectAtIndex:i];
        [paramvalue removeAllObjects];
        NSNumber* paramKey = [_techParamSet.ayParams objectAtIndex:i];
		if(paramKey == nil || [paramKey intValue] <= 0)
		{
			for(NSInteger j = 0; j < [_ayTechValue count]; j++)
			{
				[paramvalue addObject:[NSNumber numberWithLong:INT32_MAX]];
			}
		}
        else
        {
            NSInteger nKeyValue = [paramKey intValue];
            for(NSInteger j = 0; j < [_ayTechValue count]; j++)
            {
                if(j < nKeyValue - 1)
                {
                    [paramvalue addObject:[NSNumber numberWithLong:INT32_MAX]];
                } 
                else
                {
                    lPriceTotal = 0;
                    for(NSInteger k = j + 1 - nKeyValue; k <= j; k++)
                    {
                        tztTechValue* techcal = [_ayTechValue objectAtIndex:k];
                        switch (_KLineZhibiao) {
                            case PKLINE:
                                lPriceTotal += (double)techcal.nClosePrice;
                                break;
                            case VOL:
                                lPriceTotal += (double)techcal.ulTotal_h;
                                break;
                            default:
                                break;
                        }
                    }
                    double lpramvalue = (double)(lPriceTotal/nKeyValue);
                    [paramvalue addObject:[NSNumber numberWithDouble:lpramvalue]];
                }
            }
        }
	}
}

//绘制底图
- (BOOL)drawBackGround:(CGRect)rect alpha:(CGFloat)alpha
{
    return [self drawBackGround:rect alpha:alpha context_:nil];
}
- (BOOL)drawBackGround:(CGRect)rect alpha:(CGFloat)alpha context_:(CGContextRef)context
{
    if (!_bShowLeftInSide)
    {
        _KLineDrawRect = CGRectInset(rect,_YAxisWidth,0);
        _KLineDrawRect.size.width += _YAxisWidth;
    }
    else
    {
        _KLineDrawRect = rect;// CGRectInset(rect, 1, 0);
    }
    
    _KLineParamRect = _KLineDrawRect;
    _KLineParamRect.size.height = tztParamHeight;
    _KLineParamRect = CGRectInset(_KLineParamRect,1,1);
    
    _KLineDrawRect.origin.y += tztParamHeight;
    _KLineDrawRect.size.height -= tztParamHeight;
    
    UIColor* backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    UIColor* gridColor = [UIColor tztThemeHQGridColor];
    
    if (context != nil)
    {
        context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetAlpha(context, alpha);
        
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextSetLineWidth(context, .5f);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddRect(context, _KLineDrawRect);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextStrokePath(context);
    }

    if(_KLineAxisStyle & KLineXAxis)
    {
        _KLineDrawRect.size.height -= tztParamHeight / 2;
        if (context != nil)
        {
            context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            CGContextSetAlpha(context, alpha);
            
            CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextSetLineWidth(context, .5f);
            CGContextMoveToPoint(context, CGRectGetMinX(_KLineDrawRect), CGRectGetMaxY(_KLineDrawRect));
            CGContextAddLineToPoint(context, CGRectGetMaxX(_KLineDrawRect), CGRectGetMaxY(_KLineDrawRect));
            CGContextDrawPath(context, kCGPathFillStroke);
            CGContextStrokePath(context);
        }
    }
    
    if (CGRectIsEmpty(_KLineDrawRect))
    {
        return FALSE;
    }
    //zxl 20130730 不显示参数数据背景
    if (_bIsDrawParams)
    {
        if (context != nil)
        {
//            context = UIGraphicsGetCurrentContext();
//            CGContextSaveGState(context);
//            CGContextSetAlpha(context, alpha);
//            CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
//            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
//            CGContextSetLineWidth(context, .5f);
//            CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(_KLineParamRect));
//            CGContextAddLineToPoint(context, CGRectGetMaxX(_KLineParamRect), CGRectGetMaxY(_KLineParamRect));
//            CGContextDrawPath(context, kCGPathFillStroke);
//            CGContextStrokePath(context);
        }
    }else
    {
        _KLineDrawRect.origin.y = _KLineParamRect.origin.y;
        _KLineDrawRect.size.height += _KLineParamRect.size.height;
    }

    if (context != nil)
    {
        context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetAlpha(context, alpha);
        
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextSetLineWidth(context, .2f);
        CGContextMoveToPoint(context, CGRectGetMinX(_KLineDrawRect), CGRectGetMinY(_KLineDrawRect));
        CGContextAddLineToPoint(context, CGRectGetMinX(_KLineDrawRect), CGRectGetMaxY(_KLineDrawRect));
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
//    //绘制中间虚线
//    CGContextSaveGState(context);
//    static float dashLengths[3] = {3, 3, 2};
//    CGContextSetLineDash(context, 0.0, dashLengths, 2);
//    CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
//    CGContextMoveToPoint(context, CGRectGetMinX(_KLineDrawRect), CGRectGetMidY(_KLineDrawRect));
//    CGContextAddLineToPoint(context, CGRectGetMaxX(_KLineDrawRect), CGRectGetMidY(_KLineDrawRect));
//    CGContextStrokePath(context);
//    CGContextRestoreGState(context);
    
    //zxl 20130802 K线界面变动引起的界面调整
    if (_fKLineViewChangeHeight > 0)
    {
        _KLineDrawRect.origin.y += _fKLineViewChangeHeight;
        _KLineDrawRect.size.height -= _fKLineViewChangeHeight*2;
    }
    return TRUE;
}

/*
 函数功能：再次设置各个View的区域
 入参：无
 出参：无
 */
-(void)SetDrawBackGroundRect
{
#ifdef tzt_ChaoGen
    _KLineDrawRect.origin.y += tztBuySaleMapHeight;
    _KLineDrawRect.size.height -= tztBuySaleMapHeight*2;
    _fKLineViewChangeHeight = tztBuySaleMapHeight;
#endif
}
- (BOOL)setDrawcursor:(BOOL)bDrawCursor cursorPoint:(CGPoint)cursor curIndex:(NSInteger)curIndex startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    if(_KLineCellWidth <= 0)
        return FALSE;
    NSInteger nKLineCount = endIndex - startIndex;
    if(nKLineCount <= 0)
        return FALSE;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nKLineValueCount = [_ayTechValue count];
    if(nKLineValueCount <= 0)
        return FALSE;
    _KLineCount = nKLineCount;
    _KLineStart = startIndex;
    _KLineCurIndex = curIndex;
    _KLineDrawCursor = bDrawCursor;
    _KLineCursor = cursor;
    
    [self CalculateValue];
    [self onGetCursorValue:cursor];
    return TRUE;
}

- (void)drawKLine:(CGFloat)alpha
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetAlpha(context, alpha);
    
    //绘制坐标
    [self onDrawAxis:context];
    //绘制K线图
    [self onDrawKLineValues:context];
    if (!_kLineOutFund)
    {
        //绘制指标图
        [self onDrawParamLines:context];
        //绘制参数数据
        [self onDrawParams:context];
    }
    else
    {
        [self onDrawOutFundParams:context];
    }
    [self onDrawCursor:context];
    CGContextRestoreGState(context);
    
}

//zxl  20130927 ipad 场外基金 Params 显示特殊处理
-(void)onDrawOutFundParams_ipadAdd:(TNewPriceData*)PriceData  KLineHead:(TNewKLineHead *)techHead isHB:(BOOL)isFundHB
{
    if (PriceData == NULL)
        return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 1);
    
    UIColor* pColor;
    if (PriceData->Last_p > PriceData->Close_p)
        pColor = [UIColor tztThemeHQUpColor];
    else if(PriceData->Last_p < PriceData->Close_p)
        pColor = [UIColor tztThemeHQDownColor];
    else
        pColor = [UIColor tztThemeHQBalanceColor];
    
    CGRect drawRect = _KLineParamRect;
    CGFloat drawtxtsize = [tztTechSetting getInstance].drawTxtSize;
    UIFont* drawfont = tztUIBaseViewTextFont(drawtxtsize);
    CGPoint strpoint = CGPointZero;
    

    NSString * ValueTitle = @"";
    NSString* strValue  = @"-";
    CGSize strzise = [strValue sizeWithFont:drawfont];
    CGFloat pointx = 0;
    CGFloat pointy =  CGRectGetMinY(drawRect) + (CGRectGetHeight(drawRect) - strzise.height) / 2;
    if (isFundHB)
    {
        strValue =  NSStringOfVal_Ref_Dec_Div(techHead->nQRNH, 0, 2, 10000);
        strValue = [NSString stringWithFormat:@"%@%@", strValue, @"%"];
        strzise = [strValue sizeWithFont:drawfont];
        pointx = CGRectGetMinX(drawRect) + CGRectGetWidth(drawRect) - 10 - strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, pColor.CGColor);
        [strValue drawAtPoint:strpoint withFont:drawfont];
        
        ValueTitle = @"七日年化";
        strzise = [ValueTitle sizeWithFont:drawfont];
        pointx -= 5 + strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        [ValueTitle drawAtPoint:strpoint withFont:drawfont];
        
        strValue =  NSStringOfVal_Ref_Dec_Div(techHead->nWFSY, 0, techHead->nDecimal, 10000);
        strzise = [strValue sizeWithFont:drawfont];
        pointx -= 5 + strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, pColor.CGColor);
        [strValue drawAtPoint:strpoint withFont:drawfont];
        
        ValueTitle = @"万份收益";
        strzise = [ValueTitle sizeWithFont:drawfont];
        pointx -= 5 + strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        [ValueTitle drawAtPoint:strpoint withFont:drawfont];
        
    }else
    {
        
        strValue = NSStringOfVal_Ref_Dec_Div(techHead->nMonthUp, 0, 2, 100);
        strValue = [NSString stringWithFormat:@"%@%@", strValue, @"%"];
        strzise = [strValue sizeWithFont:drawfont];
        pointx = CGRectGetMinX(drawRect) + CGRectGetWidth(drawRect) - 10 - strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, pColor.CGColor);
        [strValue drawAtPoint:strpoint withFont:drawfont];
        
        ValueTitle = @"月涨幅";
        strzise = [ValueTitle sizeWithFont:drawfont];
        pointx -= 5 + strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        [ValueTitle drawAtPoint:strpoint withFont:drawfont];
        
        strValue = NSStringOfVal_Ref_Dec_Div(techHead->nWeekUp, 0, 2, 100);
        strValue = [NSString stringWithFormat:@"%@%@", strValue, @"%"];
        strzise = [strValue sizeWithFont:drawfont];
        pointx -= 5 + strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, pColor.CGColor);
        [strValue drawAtPoint:strpoint withFont:drawfont];
        
        ValueTitle = @"周涨幅";
        strzise = [ValueTitle sizeWithFont:drawfont];
        pointx -= 5 + strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        [ValueTitle drawAtPoint:strpoint withFont:drawfont];
        
        
        strValue =  NSStringOfVal_Ref_Dec_Div(PriceData->Last_p, 0, PriceData->nDecimal, 10000);
        strzise = [strValue sizeWithFont:drawfont];
        pointx -= 5 + strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, pColor.CGColor);
        [strValue drawAtPoint:strpoint withFont:drawfont];
        
        ValueTitle = @"基金净值";
        strzise = [ValueTitle sizeWithFont:drawfont];
        pointx -= 5 + strzise.width;
        strpoint = CGPointMake(pointx, pointy);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        [ValueTitle drawAtPoint:strpoint withFont:drawfont];
    }
    
    CGContextRestoreGState(context);
}
- (void)onDrawKLineValues:(CGContextRef)context
{
    switch (_KLineZhibiao) {
        case PKLINE:
        {
            if (_kLineOutFund)
                [self onDrawOutFundLineStyle:context];
            else
                [self onDrawPKLineStyle:context];
        }
            break;
        case VOL: //量
            [self onDrawVolStyle:context rect:_KLineDrawRect values:[_techView tztTechObjAyValue:self] maxvalue:_MaxValue];
            break;
        case MACD://MACD
            if(_ayParamsValue && [_ayParamsValue count] > 2)
                [self onDrawMACDStyle:context rect:_KLineDrawRect values:[self.ayParamsValue objectAtIndex:0] reference:0 maxdiff:(labs(_MaxValue - _MinValue))];
            break;
        case BOLL:
            [self onDrawAmericaLineStyle:context];
            break;
        default:
            break;
    }
}

//绘制Param线
- (void)onDrawParamLines:(CGContextRef)context
{
    NSInteger i = 0;
    NSInteger nCount = [_ayParamsValue count];
    if(_KLineZhibiao == PKLINE || _KLineZhibiao == VOL)
        nCount = MIN(nCount,[[tztTechSetting getInstance] getTechParamSettingMAnum]);
    if(_KLineZhibiao == MACD) //MACD 第一个指标值非线型
        i = 1;
    for (; i < nCount; i++)
    {
        [self onDrawLinesStyle:context rect:_KLineDrawRect valueIndex:i maxValue:_MaxValue minValue:_MinValue];
    }
}

//获取十字光标 纵坐标值
- (void)onGetCursorValue:(CGPoint)point
{
    if(_KLineCursor.y >= CGRectGetMinY(_KLineDrawRect) && _KLineCursor.y <= CGRectGetMaxY(_KLineDrawRect) )
    {
        _KLineCursorValue = _MaxValue - (_KLineCursor.y - CGRectGetMinY(_KLineDrawRect)) * (_MaxValue - _MinValue)  / (CGRectGetHeight(_KLineDrawRect));
        if(_KLineCursorValue < _MinValue)
            _KLineCursorValue = _MinValue;
        if(_KLineCursorValue > _MaxValue)
            _KLineCursorValue = _MaxValue;
    }
}
//绘制十字光标线
- (void)onDrawCursor:(CGContextRef)context
{    
    if(_KLineDrawCursor)
    {
        CGContextSaveGState(context);
        UIColor* drawColor = [UIColor tztThemeHQCursorColor];
        CGContextSetStrokeColorWithColor(context, drawColor.CGColor);
        if (_KLineCursor.x >= CGRectGetMinX(_KLineDrawRect) && _KLineCursor.x <= CGRectGetMaxX(_KLineDrawRect)) 
        {
            CGContextMoveToPoint(context, _KLineCursor.x, CGRectGetMinY(_KLineDrawRect));
            CGContextAddLineToPoint(context, _KLineCursor.x, CGRectGetMaxY(_KLineDrawRect));
            CGContextStrokePath(context);
        }
        
        if(_KLineCursor.y >= CGRectGetMinY(_KLineDrawRect) && _KLineCursor.y <= CGRectGetMaxY(_KLineDrawRect) )
        {
            CGContextMoveToPoint(context, CGRectGetMinX(_KLineDrawRect), _KLineCursor.y);
            CGContextAddLineToPoint(context, CGRectGetMaxX(_KLineDrawRect), _KLineCursor.y);
            CGContextStrokePath(context);
        }
        CGContextRestoreGState(context);
    }
}

-(void)onDrawOutFundParams:(CGContextRef)context
{
    CGRect drawRect = _KLineParamRect;
    CGFloat drawtxtsize = [tztTechSetting getInstance].drawTxtSize;
    UIFont* drawfont = tztUIBaseViewTextFont(drawtxtsize);
    
    
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    if (_ayTechValue == NULL || [_ayTechValue count] < 1)
        return;
    
    tztTechValue *techValue = nil;
    //日期_KLineCurIndex
    if (_KLineCurIndex < 0 || _KLineCurIndex >= [_ayTechValue count])
    {
        techValue = [_ayTechValue lastObject];
    }
    else
    {
        techValue = [_ayTechValue objectAtIndex:_KLineCurIndex];
    }
    if (techValue == nil)
        return;
    CGContextSetShouldAntialias(context, YES);
    //时间
    unsigned long lvalue = techValue.ulTime;
    NSString* strTime = [self getTimeString:lvalue];
    
    CGSize namesize = [@"新" sizeWithFont:drawfont];
    CGFloat pointy = CGRectGetMinY(drawRect) + (CGRectGetHeight(drawRect) - namesize.height) / 2;
    CGFloat pointx = 10;
    CGPoint drawpoint = CGPointZero;
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    namesize.width = 0;
    pointx += namesize.width + 4;
    pointx = MAX(50, pointx);
    
    UIColor* drawColor = [UIColor colorWithTztRGBStr:@"212,0,156"];//212,0,156
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint = CGPointMake(pointx, pointy);
    namesize = [strTime drawAtPoint:drawpoint  withFont:drawfont];
    pointx += namesize.width;
    
    if (_kLineOutFund == KLineOutFund)
    {
        //净值
        CGContextSetFillColorWithColor(context, [UIColor tztThemeHQBalanceColor].CGColor);
        NSString* strName = @"净值";
        drawpoint = CGPointMake(pointx, pointy);
        namesize = [strName drawAtPoint:drawpoint withFont:drawfont];
        pointx += namesize.width + 3;
        
        NSString* strValue = [self getValueString:techValue.nClosePrice];
        drawpoint = CGPointMake(pointx, pointy);
        namesize = [strValue drawAtPoint:drawpoint  withFont:drawfont];
        pointx += namesize.width;
    }
    else if(_kLineOutFund == KLineOutFundHB)
    {   
        //净值
        CGContextSetFillColorWithColor(context, [UIColor tztThemeHQBalanceColor].CGColor);
        NSString* strName = @"万份";
        drawpoint = CGPointMake(pointx, pointy);
        namesize = [strName drawAtPoint:drawpoint withFont:drawfont];
        pointx += namesize.width + 3;
        
        NSString* strValue = [self getValueString:techValue.nClosePrice];
        drawpoint = CGPointMake(pointx, pointy);
        namesize = [strValue drawAtPoint:drawpoint  withFont:drawfont];
        pointx += namesize.width + 5;
        
        
        //净值
        CGContextSetFillColorWithColor(context, [UIColor tztThemeHQAxisTextColor].CGColor);
        strName = @"七日";
        drawpoint = CGPointMake(pointx, pointy);
        namesize = [strName drawAtPoint:drawpoint withFont:drawfont];
        pointx += namesize.width + 3;
        
        if (techValue.ulTotal_h <= 0)
        {
            strValue = @"0.00";
        }
        else
        {
            strValue = NSStringOfVal_Ref_Dec_Div(techValue.ulTotal_h, 0, 2, 10000);
        }
        strValue = [NSString stringWithFormat:@"%@%@", strValue, @"%"];
        
//        strValue = [self getValueString:techValue.ulTotal_h];
        drawpoint = CGPointMake(pointx, pointy);
        namesize = [strValue drawAtPoint:drawpoint  withFont:drawfont];
        pointx += namesize.width;
    }
    
    CGContextSetShouldAntialias(context, NO);
}

//绘制参数行
- (void)onDrawParams:(CGContextRef)context
{
    //zxl 20130730 不显示参数数据
    if (!_bIsDrawParams)
        return;
    CGRect drawRect = _KLineParamRect;
    
    CGFloat drawtxtsize = [tztTechSetting getInstance].drawTxtSize;
    UIFont* drawfont = tztUIBaseViewTextFont(drawtxtsize);
    
    CGSize namesize = [@"新" sizeWithFont:drawfont];
    
    CGFloat pointy = CGRectGetMinY(drawRect) + (CGRectGetHeight(drawRect) - namesize.height)/2 ;
    CGFloat pointx = drawRect.origin.x;
    
    if (_bShowObj)
    {
        pointx += 50;
    }
    CGPoint drawpoint = CGPointZero; 
    

    CGContextSetTextDrawingMode(context, kCGTextFill);
    namesize.width = 0;
    pointx += namesize.width + 4;
    pointx = MAX(50, pointx);
    NSString* strName =  _techParamSet.kindName;
    NSString* strFormat = _techParamSet.kindName;
    if(_techParamSet && [_techParamSet.ayParams count] > 0)
    {
        strName = [NSString stringWithFormat:strFormat,
                   (([_techParamSet.ayParams count] > 0) ?
                   [[_techParamSet.ayParams objectAtIndex:0] intValue] :0),
                   (([_techParamSet.ayParams count] > 1) ?
                   [[_techParamSet.ayParams objectAtIndex:1] intValue] : 0),
                   (([_techParamSet.ayParams count] > 2) ?
                   [[_techParamSet.ayParams objectAtIndex:2] intValue] : 0),
                   (([_techParamSet.ayParams count] > 3) ?
                    [[_techParamSet.ayParams objectAtIndex:3] intValue] : 0),
                   (([_techParamSet.ayParams count] > 4) ?
                    [[_techParamSet.ayParams objectAtIndex:4] intValue] : 0)
                   ];
    }
    if(strName && [strName length] > 0 && _KLineZhibiao != PKLINE && _KLineZhibiao != VOL)
    {
        UIColor* drawColor = [UIColor tztThemeHQFixTextColor];
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint = CGPointMake(pointx, pointy); 
        namesize = [strName drawAtPoint:drawpoint  withFont:drawfont];
        pointx += namesize.width;
    }
    
    NSArray *ayColor = [UIColor tztThemeHQParamColors];
    for (int i = 0; i < [_techParamSet.ayNames count]; i++)
    {
        int param = 0;
        if([_techParamSet.ayParams count] > i)
        {
            NSNumber* num = [_techParamSet.ayParams objectAtIndex:i];
            if(num)
            {
                param = [num intValue];
            }
        }

        NSString* strname = [_techParamSet.ayNames objectAtIndex:i];
        NSString* strparamname = [NSString stringWithFormat:strname,param];
        UIColor* drawParamColor = [ayColor objectAtIndex:i];
        if(strparamname && [strparamname length] > 0)
        {
            if(_ayParamsValue && i < [_ayParamsValue count])
            {
                NSArray* ayValue = [_ayParamsValue objectAtIndex:i];
                double lValue = INT32_MAX;
                NSString* strValue = @"-";
                if(ayValue && [ayValue count] > 0)
                {
                    if(_KLineDrawCursor)
                    {
                        if(_KLineCurIndex < 0)
                            _KLineCurIndex = 0;
                        if (_KLineCurIndex >= [ayValue count])
                            _KLineCurIndex = [ayValue count] -1;
                        lValue = [[ayValue objectAtIndex:_KLineCurIndex] doubleValue];
                    }
                    else
                    {
                        lValue = [[ayValue lastObject] doubleValue];
                    }
                    strValue = [self getValueString:lValue];
                }
                CGContextSetFillColorWithColor(context, drawParamColor.CGColor);
                NSString* strParam = [NSString stringWithFormat:@"%@%@:",((_KLineZhibiao == PKLINE || _KLineZhibiao == VOL) ? @"MA" : @""), strparamname];
                drawpoint = CGPointMake(pointx, pointy); 
                namesize = [strParam drawAtPoint:drawpoint  withFont:drawfont];
                pointx += namesize.width;
                
                drawpoint = CGPointMake(pointx, pointy);
                namesize = [strValue drawAtPoint:drawpoint withFont:drawfont];
                pointx += namesize.width + 4;
            }
        }
    }
}

- (NSString*)getValueString:(double)lValue
{
    if(_KLineZhibiao == VOL)
        return NStringOfULongLong(lValue);
    else
        return (NSStringOfVal_Ref_Dec_Div(lValue,0,_lDecimal,_lDiv));
}


#pragma 取值计算
//获取数据对应位置
-(CGFloat) ValueToVertPos:(CGRect)drawRect value:(double)lValue
{
    if(_MaxValue == _MinValue)
        return CGRectGetMinY(drawRect);
    CGFloat fPos = (CGRectGetHeight(drawRect) * (_MaxValue - lValue) / 
                    (_MaxValue - _MinValue));
	
	fPos = drawRect.origin.y + fPos;
	if (fPos <= drawRect.origin.y)
	{
		fPos = drawRect.origin.y;
	}
	if (fPos >= drawRect.origin.y + drawRect.size.height)
	{
		fPos = drawRect.origin.y + drawRect.size.height;
	}   
	return fPos;
}

- (int)getNeedNumber
{
    int nParamNeed = 0;
    if(_techParamSet)
    {
        for (int i = 0; i < MIN(_techParamSet.valueNums,[_techParamSet.ayParams count]); i++)
        {
            NSNumber* param = [_techParamSet.ayParams objectAtIndex:i];
            if(param)
            {
                if([param intValue] > nParamNeed)
                {
                    nParamNeed = [param intValue];
                }
            }
        }
    }
    
    int nParamValue = 0;
    switch (_KLineZhibiao) 
    {
        case MACD://MACD
        {
            if([_techParamSet.ayParams count] > 2)
            {
                NSNumber* param2 = [_techParamSet.ayParams objectAtIndex:2];
                NSNumber* param0 = [_techParamSet.ayParams objectAtIndex:0];
                nParamValue = [param2 intValue] + [param0 intValue] -2;
            }
        }
            break;
        default:
            break;
    }
    nParamNeed = MAX(nParamNeed, nParamValue);
    int nWidth = CGRectGetWidth(_KLineDrawRect) + _YAxisWidth;
    if (_bShowLeftInSide)
        nWidth = CGRectGetWidth(_KLineDrawRect);
    int nMaxReqCount = nWidth / MIN(MAX(1,_KLineCellWidth),4);
    return nParamNeed+nMaxReqCount;
}

- (NSString*)getTimeString:(long)lTime
{
    //时间：分钟K线时为MMDDHHNN，其他K线为YYYYMMDD
    NSString* strformat = @"%4d/%02d/%02d";
    NSString* strValue = @"";
    switch (_KLineCycleStyle)
    {
        case KLineCycle1Min: //1分钟
        case KLineCycle5Min: //5分钟
        case KLineCycle15Min://15分钟
        case KLineCycle30Min://30分钟
        case KLineCycle60Min://60分钟:
        case KLineCycleCustomMin://自定义分钟
            strformat = @"%02d/%02d %02d:%02d";
            strValue = [NSString stringWithFormat:strformat,lTime / 1000000, (lTime % 1000000) / 10000, (lTime % 10000) / 100,lTime % 100];
            break;
        default:
            strformat = @"%4d/%02d/%02d";
            strValue = [NSString stringWithFormat:strformat,lTime / 10000, (lTime % 10000) / 100,lTime % 100];
            break;
    }
    return strValue;
}

//绘制K线美国线
- (void)onDrawAmericaLineStyle:(CGContextRef)context
{
    BOOL bRise = TRUE;
    CGRect drawRect = _KLineDrawRect;
    CGRect draw = drawRect;
    CGFloat pointx = drawRect.origin.x + _KLineWidth / 2;
    draw.size.width = _KLineWidth;
    CGFloat drawtop;
    CGFloat drawBottom;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    for (NSInteger i = 0; i < MIN(nValueCount,_KLineCount); i++)
    {
        if(i+_KLineStart >= nValueCount)
        {
            continue;
        }
        tztTechValue* techvalue = [_ayTechValue objectAtIndex:(i+_KLineStart)];
        tztTechValue* pretechvalue = nil;
        if(i > 0)
            pretechvalue = [_ayTechValue objectAtIndex:(i+_KLineStart-1)];
        
        drawtop = [self ValueToVertPos:drawRect value:techvalue.nHighPrice];
        drawBottom = [self ValueToVertPos:drawRect value:techvalue.nLowPrice];
        
        draw.origin.y = [self ValueToVertPos:drawRect value:techvalue.nOpenPrice];
        draw.size.height = [self ValueToVertPos:drawRect value:techvalue.nClosePrice]-draw.origin.y;
        
        if (i > 0 && techvalue.nOpenPrice == techvalue.nClosePrice)
        {
            if (techvalue.nOpenPrice >= pretechvalue.nClosePrice)
            {
				bRise = TRUE;
            }
            else
            {
                bRise = FALSE;
            }
        }
		else if( techvalue.nOpenPrice < techvalue.nClosePrice)
		{
			if(!bRise)
			{
				bRise = TRUE;
			}
		}
		else if(bRise)
		{
			bRise = FALSE;
		}
        UIColor* drawColor = (bRise ? [UIColor tztThemeHQKLineUpColor] : [UIColor tztThemeHQKLineDownColor]);
        CGContextSetStrokeColorWithColor(context, drawColor.CGColor);
        CGContextSetShouldAntialias(context,FALSE);
        CGContextMoveToPoint(context, pointx, drawtop);
        CGContextAddLineToPoint(context, pointx, drawBottom);
        CGContextMoveToPoint(context, CGRectGetMinX(draw), CGRectGetMinY(draw));
        CGContextAddLineToPoint(context, pointx, CGRectGetMinY(draw));
        CGContextMoveToPoint(context, pointx, CGRectGetMinY(draw));
        CGContextAddLineToPoint(context, CGRectGetMaxX(draw), CGRectGetMinY(draw));
        CGContextStrokePath(context);  
        CGContextSetShouldAntialias(context,TRUE);
        pointx += _KLineCellWidth;
        draw.origin.x += _KLineCellWidth;
    }
}

- (void)onDrawOutFundLineStyle:(CGContextRef)context
{
    CGRect draw = _KLineDrawRect;
    CGRect drawRect = _KLineDrawRect;
    CGFloat pointx = draw.origin.x + _KLineWidth/2;
    CGFloat pointy = 0;
    
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    
    BOOL bFirst = TRUE;
    UIColor* color = [UIColor tztThemeHQBalanceColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetShouldAntialias(context,YES);
    for (NSInteger i = 0; i < MIN(nValueCount,_KLineCount); i++)
    {
        if(i+_KLineStart >= nValueCount)
        {
            continue;
        }
        tztTechValue* techvalue = [_ayTechValue objectAtIndex:(i+_KLineStart)];
//        tztTechValue* pretechvalue = nil;
//        if(i > 0)
//            pretechvalue = [_ayTechValue objectAtIndex:(i+_KLineStart-1)];
        

        pointy = [self ValueToVertPos:drawRect value:techvalue.nClosePrice];
        if (bFirst)
        {
            bFirst = FALSE;
            CGContextMoveToPoint(context, pointx, pointy);
        }
        else
        {            
            CGContextAddLineToPoint(context, pointx, pointy);
            CGContextMoveToPoint(context, pointx, pointy);
        }
        pointx += _KLineCellWidth;
	}
    CGContextStrokePath(context);
    CGContextSetShouldAntialias(context,NO);
    
    if(_kLineOutFund == KLineOutFundHB)//货币基金
    {
        UIColor* color = [UIColor tztThemeHQAxisTextColor];
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetShouldAntialias(context,YES);
        pointx = draw.origin.x + _KLineWidth/2;
//        pointy = 0;
        bFirst = TRUE;
        for (int i = 0; i < MIN(nValueCount,_KLineCount); i++)
        {
            if(i+_KLineStart >= nValueCount)
            {
                continue;
            }
            tztTechValue* techvalue = [_ayTechValue objectAtIndex:(i+_KLineStart)];
//            tztTechValue* pretechvalue = nil;
//            if(i > 0)
//                pretechvalue = [_ayTechValue objectAtIndex:(i+_KLineStart-1)];
            
            
            pointy = [self ValueToVertPos:drawRect value:techvalue.ulTotal_h];
            if (bFirst)
            {
                bFirst = FALSE;
                CGContextMoveToPoint(context, pointx, pointy);
            }
            else
            {
                CGContextAddLineToPoint(context, pointx, pointy);
                CGContextMoveToPoint(context, pointx, pointy);
            }
            pointx += _KLineCellWidth;
        }
        
        CGContextStrokePath(context);
        CGContextSetShouldAntialias(context,NO);
    }
    

}
//zxl 20131206 绘制炒跟圆饼
-(void)drawCircle:(CGContextRef)context _Point:(CGPoint)point _nType:(int)type
{
    
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextAddArc(context, point.x, point.y, _KLineCellWidth/2, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    CGContextAddArc(context, point.x, point.y, 1, 0, 2*PI, 0);
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    switch (type)
    {
        case 0://买入
        {
            CGContextSetAlpha(context, 0.5);
            CGContextSetFillColorWithColor(context, [UIColor tztThemeHQUpColor].CGColor);
            //填充圆，无边框
            CGContextAddArc(context, point.x, point.y, _KLineCellWidth/2 - 0.5, 0, 2*PI, 0); //添加一个圆
            CGContextDrawPath(context, kCGPathFill);//绘制填充
            CGContextSetAlpha(context, 1.0);
        }
            break;
        case 1://卖出
        {
            CGContextSetAlpha(context, 0.5);
            CGContextSetFillColorWithColor(context, [UIColor tztThemeHQDownColor].CGColor);
            //填充圆，无边框
            CGContextAddArc(context, point.x, point.y, _KLineCellWidth/2 - 0.5, 0, 2*PI, 0); //添加一个圆
            CGContextDrawPath(context, kCGPathFill);//绘制填充
            CGContextSetAlpha(context, 1.0);
        }
            break;
            
        default:
            break;
    }
}

//绘制普通K线
- (void)onDrawPKLineStyle:(CGContextRef)context
{
    BOOL bRise = TRUE;
    CGRect draw = _KLineDrawRect;
    CGRect drawRect = _KLineDrawRect;
    CGFloat pointx = draw.origin.x + _KLineWidth/2;
    draw.size.width = _KLineWidth;
    draw.origin.x = draw.origin.x;
    
    CGFloat drawtop;
    CGFloat drawBottom;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    
    NSMutableDictionary* _ayDataByTime = nil;

#ifdef tzt_ChaoGen
    if ([_techView respondsToSelector:@selector(tztTechObjAyValueTime:)])
    {
        _ayDataByTime = [_techView tztTechObjAyValueTime:self];
    }
#endif
    
    for (NSInteger i = 0; i < MIN(nValueCount,_KLineCount); i++)
    {
        if(i+_KLineStart >= nValueCount)
        {
            continue;
        }
        tztTechValue* techvalue = [_ayTechValue objectAtIndex:(i+_KLineStart)];
        tztTechValue* pretechvalue = nil;
        if(i > 0)
            pretechvalue = [_ayTechValue objectAtIndex:(i+_KLineStart-1)];
        
        drawtop = [self ValueToVertPos:drawRect value:techvalue.nHighPrice];
        drawBottom = [self ValueToVertPos:drawRect value:techvalue.nLowPrice];
        draw.origin.y = [self ValueToVertPos:drawRect value:techvalue.nOpenPrice];
        draw.size.height = [self ValueToVertPos:drawRect value:techvalue.nClosePrice]-draw.origin.y;
        BOOL bIsDrawLine = TRUE;
        
        if (i > 0 && techvalue.nOpenPrice == techvalue.nClosePrice)
        {
            if (techvalue.nOpenPrice >= pretechvalue.nClosePrice)
            {
				bRise = TRUE;
            }
            else
            {
                bRise = FALSE;
            }
            
            if (techvalue.nHighPrice == techvalue.nLowPrice)
            {
                bIsDrawLine = FALSE;
            }
        }
		else if( techvalue.nOpenPrice < techvalue.nClosePrice)
		{
			if(!bRise)
			{
				bRise = TRUE;
			}
		}
		else if(bRise)
		{
			bRise = FALSE;
		}
        UIColor* downColor = [UIColor tztThemeHQKLineDownColor];
        UIColor* upColor = [UIColor tztThemeHQKLineUpColor];
//        UIColor* backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        
		if(!bRise)
		{
            CGContextSetStrokeColorWithColor(context, downColor.CGColor);
            CGContextSetShouldAntialias(context,FALSE);
            if (bIsDrawLine == TRUE)
            {
                CGContextMoveToPoint(context, pointx, drawtop);
                CGContextAddLineToPoint(context, pointx, drawBottom);
                CGContextMoveToPoint(context, pointx, drawBottom);
                CGContextStrokePath(context);
            }
            
            CGContextSetFillColorWithColor(context, downColor.CGColor);
            CGContextAddRect(context, draw);
            CGContextDrawPath(context, kCGPathFill);
            CGContextStrokePath(context);
            
            CGContextAddRect(context, draw);
            CGContextStrokePath(context);
            CGContextSetShouldAntialias(context,TRUE);
		}
		else
		{
            CGContextSetStrokeColorWithColor(context, upColor.CGColor);
            if (bIsDrawLine == TRUE)
            {
                CGContextMoveToPoint(context, pointx, drawtop);
				CGContextSetShouldAntialias(context,FALSE);
                CGContextAddLineToPoint(context, pointx, drawBottom);
                CGContextStrokePath(context);
				CGContextSetShouldAntialias(context,TRUE);
            }
			CGContextSetFillColorWithColor(context, upColor.CGColor);
            CGContextAddRect(context, draw);
            CGContextDrawPath(context, kCGPathFill);
            
            CGContextSetStrokeColorWithColor(context, upColor.CGColor);
            CGContextSetShouldAntialias(context,FALSE);
            CGContextAddRect(context, draw);
            CGContextStrokePath(context);
            CGContextSetShouldAntialias(context,TRUE);
		}
        
        if (_ayDataByTime && [_ayDataByTime count] > 0)
        {
            unsigned long lValue = techvalue.ulTime;
            NSString* nsDate = [self getTimeString:lValue];
            nsDate = [nsDate stringByReplacingOccurrencesOfString:@"/" withString:@""];
            NSMutableArray * ayByDate = [_ayDataByTime tztValueForKey:nsDate];
            if (ayByDate && [ayByDate count] > 0)
            {
                
                for (int y = 0; y < [ayByDate count]; y++)
                {
                    tztShareData * shareData = [ayByDate objectAtIndex:y];
                    int32_t nPrice = [shareData.nsPrice floatValue] * 1000;
                    CGFloat PriceY = drawtop + (techvalue.nHighPrice - nPrice)/((techvalue.nHighPrice - techvalue.nLowPrice)/(drawBottom - drawtop)) ;
                    int type = 2;
                    if ([shareData.nsWTType rangeOfString:@"买"].length > 0)
                    {
                        type = 0;
                    }else if ([shareData.nsWTType rangeOfString:@"卖"].length > 0)
                    {
                        type = 1;
                    }
                //zxl 20131223 控制炒跟撤单显示
                    if (_bIsShowCheDan || (!_bIsShowCheDan && (type == 0|| type == 1)))
                    {
                        [self drawCircle:context _Point:CGPointMake(draw.origin.x + _KLineCellWidth/2, PriceY) _nType:type];
                    }
                }
            }
        }
        
        pointx += _KLineCellWidth;
        draw.origin.x += _KLineCellWidth;
	}
}

//绘制K线  量
- (void)onDrawVolStyle:(CGContextRef)context rect:(CGRect)drawRect values:(NSArray*)ayValues
              maxvalue:(double)lMaxValue
{
    if(lMaxValue == 0)
        return;
    BOOL bRise = TRUE;	
    CGRect draw = drawRect;
    draw.size.width = _KLineWidth;
    CGFloat bottom = CGRectGetMaxY(drawRect);
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count]; //数据总数
    for (NSInteger i =  0; i < MIN(nValueCount,_KLineCount); i++)
    {
        if(i + _KLineStart >= nValueCount)
        {
            continue;
        }
        tztTechValue* techvalue = [_ayTechValue objectAtIndex:(i + _KLineStart )];
        tztTechValue* pretechvalue = nil;
        if(i > 0)
            pretechvalue = [_ayTechValue objectAtIndex:(i + _KLineStart -1)];
        draw.origin.y = [self ValueToVertPos:drawRect value:techvalue.ulTotal_h];
        draw.size.height = draw.origin.y - bottom;
        draw.origin.y = bottom;
        if (i > 0 && techvalue.nOpenPrice == techvalue.nClosePrice)
        {
            if (techvalue.nOpenPrice >= pretechvalue.nClosePrice)
            {
                
				bRise = TRUE;
            }
            else
            {
                bRise = FALSE;
            }
            
        }
		else if(techvalue.nOpenPrice <= techvalue.nClosePrice)
		{
			bRise = TRUE;
		}
		else
		{
			bRise = FALSE;
		}
        
        UIColor* downColor = [UIColor tztThemeHQKLineDownColor];
        UIColor* upColor = [UIColor tztThemeHQKLineUpColor];
//        UIColor* backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        
        CGContextSetFillColorWithColor(context, bRise ? upColor.CGColor : downColor.CGColor);
        CGContextAddRect(context, draw);
        CGContextDrawPath(context, kCGPathFill);
        
        CGContextSetStrokeColorWithColor(context, bRise ? upColor.CGColor : downColor.CGColor);
        CGContextSetShouldAntialias(context,FALSE);
        CGContextAddRect(context, draw);
        CGContextStrokePath(context);  
        CGContextSetShouldAntialias(context,TRUE);
        draw.origin.x += _KLineCellWidth;
    }
}

//绘制Param线
- (void)onDrawLinesStyle:(CGContextRef)context rect:(CGRect)drawRect valueIndex:(NSInteger)iIndex
                maxValue:(double)lMaxValue minValue:(double)lMinValue
{

    if(_ayParamsValue && iIndex < [_ayParamsValue count] && iIndex >= 0)
    {
        NSArray* ayValue = [_ayParamsValue objectAtIndex:iIndex];
        CGFloat pointx = drawRect.origin.x + _KLineWidth / 2;
        UIColor* drawcolor = [[UIColor tztThemeHQParamColors] objectAtIndex:iIndex];
        CGContextSetStrokeColorWithColor(context, drawcolor.CGColor);
        BOOL bfrist = TRUE;
        NSInteger nValueCount = [ayValue count];
        for (NSInteger i = 0; i < MIN(nValueCount,_KLineCount); i++)
        {
            if(i+_KLineStart >= nValueCount)
            {
                continue;
            }
            double lValue = [[ayValue objectAtIndex:(_KLineStart + i)] doubleValue];
            if (lValue != INT32_MAX) 
            {
                CGFloat pointy = [self ValueToVertPos:drawRect value:lValue];
                if(bfrist)
                {
                    CGContextMoveToPoint(context, pointx, pointy);
                    bfrist = FALSE;
                }
                else
                {
                    CGContextAddLineToPoint(context, pointx, pointy);
                    CGContextStrokePath(context);
                    CGContextMoveToPoint(context, pointx, pointy);
                }
            }
            pointx += _KLineCellWidth;
        }
    }
}

//绘制K线  MACD 指标
- (void)onDrawMACDStyle:(CGContextRef)context rect:(CGRect)drawRect values:(NSArray*)ayValues
              reference:(double)lReference maxdiff:(double)lMaxDiff
{
    CGRect draw = drawRect;
    draw.size.width = _KLineWidth;
    CGFloat pointx = draw.origin.x + _KLineWidth / 2;
    CGFloat fHeight = CGRectGetHeight(_KLineDrawRect) / labs(_MaxValue - _MinValue);
    CGFloat fRefPos = [self ValueToVertPos:_KLineDrawRect value:0];
    NSInteger nValueCount = [ayValues count]; //数据总数

    for (int i =  0; i < MIN(nValueCount,_KLineCount); i++)
    {

        if(i + _KLineStart >= nValueCount)
        {
            continue;
        }
        double  techvalue = [[ayValues objectAtIndex:(i + _KLineStart )] doubleValue];
        if (techvalue == INT32_MAX)
        {
            draw.origin.x += _KLineCellWidth;
            pointx += _KLineCellWidth;
			continue;
        }
        
        if (techvalue != 0)
		{		
            CGFloat fEnd = fRefPos - fHeight * techvalue;
            if(fEnd <= CGRectGetMinY(_KLineDrawRect))
            {
                fEnd = CGRectGetMinY(_KLineDrawRect);
            }
            else if(fEnd >= CGRectGetMaxY(_KLineDrawRect))
            {
                fEnd = CGRectGetMaxY(_KLineDrawRect);
            }
            BOOL bRise = techvalue > 0;
            UIColor* upLineColor = [UIColor tztThemeHQKLineUpColor];
            UIColor* downLineColor = [UIColor tztThemeHQKLineDownColor];
            CGContextSetStrokeColorWithColor(context, bRise ? upLineColor.CGColor : downLineColor.CGColor);
            CGContextSetShouldAntialias(context,FALSE);
            CGContextMoveToPoint(context, pointx, fRefPos);
            CGContextAddLineToPoint(context, pointx, fEnd);
            CGContextStrokePath(context);
            CGContextSetShouldAntialias(context,TRUE);
            
        }
        pointx += _KLineCellWidth;
        draw.origin.x += _KLineCellWidth;
    }
}

#pragma 绘制坐标
//绘制坐标
- (void)onDrawAxis:(CGContextRef)context
{
    if(_KLineAxisStyle & KLineYAxis)
    {
        int nYNums = 0;
        if (_KLineZhibiao == PKLINE)
        {
            nYNums = 3;
        }
        [self onDrawYAxis:context nums:nYNums];
    }
    
    if(_KLineAxisStyle & KLineXAxis)
    {
        [self onDrawXAxis:context];
    }
    
}

- (void)onDrawXAxis:(CGContextRef)context
{
    UIColor* AxisColor = [UIColor tztThemeHQAxisTextColor];
    UIColor* GridColor = [UIColor tztThemeHQGridColor];
    UIFont*  drawFont = [tztTechSetting getInstance].drawTxtFont;
    
//    if ([UIColor tztThemeHQFixYAxiColor])
//    {
//        drawFont = tztUIBaseViewTextFont([tztTechSetting getInstance].drawTxtSize-2.5f);;
//    }
    
    CGContextSetFillColorWithColor(context, AxisColor.CGColor);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    tztTechValue* techValue = [_ayTechValue objectAtIndex:_KLineStart];
    unsigned long lvalue = techValue.ulTime;
    
    NSString* strValue = [self getTimeString:lvalue];
    CGPoint drawpoint = _KLineDrawRect.origin;
    //zxl 20130730 绘制时间的位子高度调整
    drawpoint.y =  _KLineDrawRect.origin.y + _KLineDrawRect.size.height + _fKLineViewChangeHeight;
    CGSize drawsize =  [strValue sizeWithFont:drawFont];
    CGFloat drawsizeheight = drawsize.height;
    
    NSInteger nValueCount = MIN([_ayTechValue count] - _KLineStart,_KLineCount);
    
    CGFloat fDrawMaxSize = nValueCount * _KLineCellWidth;
    CGFloat fDrawPrePos = 0.f;
    int nCount =  fDrawMaxSize / drawsize.width;
    nCount = ((int)nCount / 5 ) * 2;
    nCount = MAX(1, nCount);
    for (int i = 0; i <= nCount; i++)
    {
        NSInteger  iIndex = _KLineStart + (nValueCount-1) * i / nCount;
        if(iIndex < 0)
        {
            continue;
        }
        else if(iIndex >= [_ayTechValue count])
        {
            iIndex = [_ayTechValue count] -1;
        }
        techValue = [_ayTechValue objectAtIndex:iIndex];
        if(techValue == nil)
            continue;
        lvalue = techValue.ulTime;
        strValue = [self getTimeString:lvalue];
        drawpoint.x = fDrawMaxSize * i /nCount +CGRectGetMinX(_KLineDrawRect);
        if(i == 0 )
        {
        }
        else if( i == nCount )
        {
            drawpoint.x = MAX(fDrawPrePos + drawsize.width * 3 / 2+ 2, drawpoint.x);
            drawpoint.x = MIN(drawpoint.x, CGRectGetMaxX(_KLineDrawRect)-drawsize.width/2)- drawsize.width/2;
        }
        else 
        {
            drawpoint.x -= drawsize.width/2;
        }
        fDrawPrePos = drawpoint.x;
        drawpoint.y =  _KLineDrawRect.origin.y + _KLineDrawRect.size.height + _fKLineViewChangeHeight + (tztParamHeight/2 - drawsizeheight) / 2;
        [strValue drawAtPoint:drawpoint withFont:drawFont];
        
        if( i != 0 && i != nCount)
        {
            CGContextSaveGState(context);
            static CGFloat dashLengths[3] = {3, 3, 2};
            CGContextSetLineDash(context, 0.0, dashLengths, 2);
            CGContextSetLineWidth(context, .5f);
            CGContextSetStrokeColorWithColor(context, GridColor.CGColor);
            CGContextMoveToPoint(context, drawpoint.x + drawsize.width/2, CGRectGetMaxY(_KLineDrawRect)+2);
            CGContextAddLineToPoint(context, drawpoint.x + drawsize.width/2, CGRectGetMaxY(_KLineDrawRect)-2);
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
        }
    }
    
    if (_KLineDrawCursor && _ayTechValue && [_ayTechValue count] > 0) //光标数据
    {
        if(_KLineCurIndex < 0)
            _KLineCurIndex = 0;
        
        if (_KLineCurIndex >= [_ayTechValue count])
            _KLineCurIndex = [_ayTechValue  count] -1;

        tztTechValue* techValue = [_ayTechValue objectAtIndex:_KLineCurIndex];
        unsigned long lvalue = techValue.ulTime;
        strValue = [self getTimeString:lvalue];
        drawpoint.x = _KLineCursor.x - drawsize.width/2;
        
        if(drawpoint.x <= CGRectGetMinX(_KLineDrawRect))
            drawpoint.x = CGRectGetMinX(_KLineDrawRect);
        if(drawpoint.x +drawsize.width >=  CGRectGetMaxX(_KLineDrawRect))
            drawpoint.x = CGRectGetMaxX(_KLineDrawRect) - drawsize.width;
        
        CGRect backRect = CGRectMake(drawpoint.x, drawpoint.y, drawsize.width, drawsizeheight);
        backRect = CGRectInset(backRect,-1,-1);
//        UIColor* TipGridColor = [UIColor tztThemeHQHideGridColor];
        UIColor* TipBackColor = [UIColor tztThemeHQCursorBackColor];
        
        CGContextSaveGState(context);
        CGContextSetAlpha(context, 1.f);
        CGContextSetStrokeColorWithColor(context, TipBackColor.CGColor);
        CGContextSetFillColorWithColor(context, TipBackColor.CGColor);
        
        CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:backRect cornerRadius:2.5f].CGPath;
        CGContextAddPath(context, clippath);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        //        drawpoint.y += (tztParamHeight - drawsizeheight) / 2;
        UIColor* AxisColor = [UIColor tztThemeHQCursorTextColor];// [tztTechSetting getInstance].axisTxtColor;
        CGContextSetFillColorWithColor(context, AxisColor.CGColor);
        [strValue drawAtPoint:drawpoint withFont:drawFont];
        
    }
}

- (void)onDrawYAxis:(CGContextRef)context nums:(int)lNums
{
    UIColor* AxisColor = [UIColor tztThemeHQAxisTextColor];
    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
    
    UIColor *color = [UIColor tztThemeHQFixYAxiColor];
    if (color)
    {
        AxisColor = color;
//        drawFont = tztUIBaseViewTextFont([tztTechSetting getInstance].drawTxtSize-2.5f);;
    }
    
    CGContextSetFillColorWithColor(context, AxisColor.CGColor);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    CGPoint drawPoint = _KLineDrawRect.origin;
    NSString* strValue = [self getValueString:_MaxValue];
    CGSize valuesize = [strValue sizeWithFont:drawFont];
    if (_bShowLeftInSide)
    {
        drawPoint.x = _KLineDrawRect.origin.x + 2;
        CGContextSetFillColorWithColor(context, [UIColor tztThemeHQTipBackColor].CGColor);
        CGContextFillRect(context, CGRectMake(drawPoint.x, drawPoint.y, valuesize.width, valuesize.height));
    }
    else
        drawPoint.x = _KLineDrawRect.origin.x - valuesize.width;
    CGContextSetFillColorWithColor(context, AxisColor.CGColor);
    CGSize drawsize = [strValue drawAtPoint:drawPoint withFont:drawFont];
    CGFloat drawsizeheight = drawsize.height;
    
    TZTNSLog(@"onDrawYAxis drawsize=%f,%f,%f",drawsize.width,drawsize.height,drawsizeheight);
    UIColor* gridColor = [UIColor tztThemeHQGridColor];
    for (int i = 0; i < lNums; i++)
    {
        double lMidValue = _MinValue + (_MaxValue - _MinValue) * (i+1) / (lNums+1);
        drawPoint.y = CGRectGetMaxY(_KLineDrawRect) - CGRectGetHeight(_KLineDrawRect) * (i+1) / (lNums+1) - drawsizeheight / 2;
        
        strValue = [self getValueString:lMidValue];
        
        valuesize = [strValue sizeWithFont:drawFont];
        if (_bShowLeftInSide)
            drawPoint.x = _KLineDrawRect.origin.x + 2;
        else
            drawPoint.x = _KLineDrawRect.origin.x - valuesize.width;
        if (!_bShowMaxMin)
            [strValue drawAtPoint:drawPoint withFont:drawFont];
        drawPoint.y += drawsizeheight / 2;

        //绘制中间虚线
        CGContextSaveGState(context);
        static CGFloat dashLengths[3] = {3, 3, 2};
        CGContextSetLineDash(context, 0.0, dashLengths, 2);
        CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
        CGContextSetLineWidth(context, .5f);
        CGContextMoveToPoint(context, CGRectGetMinX(_KLineDrawRect),drawPoint.y);
        CGContextAddLineToPoint(context, CGRectGetMaxX(_KLineDrawRect), drawPoint.y);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
    
    drawPoint.y =  CGRectGetMaxY(_KLineDrawRect) - drawsizeheight;
    if(_KLineZhibiao == VOL)
        strValue = NStringOfULong(_MinValue);
    else
        strValue = [self getValueString:_MinValue];

    valuesize = [strValue sizeWithFont:drawFont];
    if (_bShowLeftInSide)
    {
        drawPoint.x = _KLineDrawRect.origin.x + 2;
        CGContextSetFillColorWithColor(context, [UIColor tztThemeHQTipBackColor].CGColor);
        CGContextFillRect(context, CGRectMake(drawPoint.x, drawPoint.y, valuesize.width, valuesize.height));
    }
    else
        drawPoint.x = _KLineDrawRect.origin.x - valuesize.width;
    CGContextSetFillColorWithColor(context, AxisColor.CGColor);
    [strValue drawAtPoint:drawPoint withFont:drawFont];
    
    TZTNSLog(@"onDrawYAxis %@=%f,%f,%f",strValue,CGRectGetMaxY(_KLineDrawRect),drawsizeheight,drawPoint.y);
    
    CGContextStrokePath(context);
    

    if (_KLineDrawCursor && _KLineCursor.y >= CGRectGetMinY(_KLineDrawRect) && _KLineCursor.y <= CGRectGetMaxY(_KLineDrawRect) )
    {
        strValue = [self getValueString:_KLineCursorValue];
        valuesize = [strValue sizeWithFont:drawFont];
        drawPoint.y = _KLineCursor.y - drawsizeheight / 2;
        
        if(drawPoint.y <= CGRectGetMinY(_KLineDrawRect))
            drawPoint.y = CGRectGetMinY(_KLineDrawRect);
        if(drawPoint.y + drawsizeheight >=  CGRectGetMaxY(_KLineDrawRect))
            drawPoint.y = CGRectGetMaxY(_KLineDrawRect) - drawsizeheight;
        
        if (_bShowLeftInSide)
            drawPoint.x = _KLineDrawRect.origin.x;
        else
            drawPoint.x = _KLineDrawRect.origin.x - _YAxisWidth;
        CGRect backRect = CGRectMake(drawPoint.x, drawPoint.y, _YAxisWidth, drawsizeheight);
        backRect = CGRectInset(backRect,0,-1);
//        UIColor* TipGridColor = [UIColor tztThemeHQHideGridColor];
        UIColor* TipBackColor = [UIColor tztThemeHQCursorBackColor];
        
        CGContextSaveGState(context);
        CGContextSetAlpha(context, 1.0f);
        CGContextSetStrokeColorWithColor(context, TipBackColor.CGColor);
        CGContextSetFillColorWithColor(context, TipBackColor.CGColor);
        
        CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:backRect cornerRadius:2.5f].CGPath;
        CGContextAddPath(context, clippath);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        
        if (_bShowLeftInSide)
            drawPoint.x = _KLineDrawRect.origin.x;
        else
            drawPoint.x = MAX(CGRectGetMinX(backRect),_KLineDrawRect.origin.x - valuesize.width);
        CGFloat *actual = nil;
        
        UIColor* AxisColor = [UIColor tztThemeHQCursorTextColor];// [tztTechSetting getInstance].axisTxtColor;
        CGContextSetFillColorWithColor(context, AxisColor.CGColor);
        
        [strValue drawAtPoint:drawPoint forWidth:CGRectGetWidth(backRect) withFont:drawFont minFontSize:8.0f actualFontSize:actual lineBreakMode:NSLineBreakByTruncatingMiddle baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//        [strValue drawInRect:backRect withFont:drawFont lineBreakMode:UILineBreakModeMiddleTruncation alignment:NSTextAlignmentRight];
//        [strValue drawAtPoint:drawPoint withFont:drawFont];
    }
}

#pragma K线指标计算
// MACD=================================================================
//计算MACD指标
- (void)CalculateMACDValues
{
    [_ayParamsValue removeAllObjects];
    
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 3 || _techParamSet.valueNums < 3)
        return;
    
	for(int i = 0; i < [_techParamSet.ayParams count]; i++)
	{
        NSNumber* param = [_techParamSet.ayParams objectAtIndex:i];
		if([param intValue] <= 0)
			return;   
	}	
	double AX = 0,BX = 0, CX = 0, DI;
	
    NSNumber* numparam0 = [_techParamSet.ayParams objectAtIndex:0];
    int param0 = [numparam0 intValue];
    NSNumber* numparam1 = [_techParamSet.ayParams objectAtIndex:1];
    int param1 = [numparam1 intValue];
    NSNumber* numparam2 = [_techParamSet.ayParams objectAtIndex:2];
    int param2 = [numparam2 intValue];
    
    NSMutableArray* ayParam0 = NewObject(NSMutableArray);
    [_ayParamsValue addObject:ayParam0];
    [ayParam0 release];
    
    NSMutableArray* ayParam1 = NewObject(NSMutableArray);
    [_ayParamsValue addObject:ayParam1];
    [ayParam1 release];
    NSMutableArray* ayParam2 = NewObject(NSMutableArray);
    [_ayParamsValue addObject:ayParam2];
    [ayParam2 release];
    
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
	for (int i =  0; i < [_ayTechValue count]; i++)
	{
        tztTechValue* techValue = [_ayTechValue objectAtIndex:i];
        
		DI = ((double)techValue.nHighPrice + 
              techValue.nLowPrice + 2 * techValue.nClosePrice) / 4.0;

		if(i < param1 - 1)
		{
			AX += DI;
		}
		else if(i == param1 - 1)
		{
			AX += DI;
			AX /= param1;
		} 
		else
		{
			AX = (DI - AX) * 0.1538 + AX;
		}
        
		if (i < param2 - 1)
		{
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam2 addObject:[NSNumber numberWithLong:INT32_MAX]];
			BX += DI;
		}
		else if (i == param2 - 1)
		{
			BX += DI;
			BX /= param2;  
			CX  = AX - BX;
            [ayParam1 addObject:[NSNumber numberWithLong:doubletolong(CX)]];
            [ayParam2 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			BX = (DI - BX) * 0.0741 + BX;
            [ayParam1 addObject:[NSNumber numberWithLong:doubletolong(AX - BX)]];
			if(i < param2 - 1 + param0 - 1)
			{
				CX += AX - BX;
				[ayParam2 addObject:[NSNumber numberWithLong:INT32_MAX]];
                [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
			}
			else if (i == param2 - 1 + param0 - 1)
			{
				CX += AX - BX;
				CX /= param0;

                [ayParam2 addObject:[NSNumber numberWithLong:doubletolong(CX)]];
                [ayParam0 addObject:[NSNumber numberWithLong:doubletolong(2 * (AX - BX - CX))]];
			}
			else
			{
				CX = (AX - BX - CX)* 0.2 + CX;
                
                [ayParam2 addObject:[NSNumber numberWithLong:doubletolong(CX)]];
                [ayParam0 addObject:[NSNumber numberWithLong:doubletolong(2 * (AX - BX - CX))]];
			}
			
		}
	}
}

// KDJ=================================================================
//计算KDJ指标
- (void)CalculateKDJValues
{
    [_ayParamsValue removeAllObjects];
    
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 3)
        return;

    NSNumber* numparam0 = [_techParamSet.ayParams objectAtIndex:0];
    int param0 = [numparam0 intValue];
    if(param0 <= 0)
        return;
    
    NSMutableArray* ayParam0 = NewObject(NSMutableArray);
    [_ayParamsValue addObject:ayParam0];
    [ayParam0 release];
    
    NSMutableArray* ayParam1 = NewObject(NSMutableArray);
    [_ayParamsValue addObject:ayParam1];
    [ayParam1 release];
    NSMutableArray* ayParam2 = NewObject(NSMutableArray);
    [_ayParamsValue addObject:ayParam2];
    [ayParam2 release];
    
    int lMax = 0, lMin = 0;
    int lRSV;
    NSInteger j;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    for(NSInteger i = 0; i < nValueCount; i++)
    {
        if(i < param0 - 1)
        {
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam2 addObject:[NSNumber numberWithLong:INT32_MAX]];
        } 
        else if(i == param0 -1)
        {	
            [ayParam0 addObject:[NSNumber numberWithLong:5000]];
            [ayParam1 addObject:[NSNumber numberWithLong:5000]];
            long lValue = 3 * [[ayParam1 objectAtIndex:i] longValue] - 2 * [[ayParam0 objectAtIndex:i] longValue];
            [ayParam2 addObject:[NSNumber numberWithLong:lValue]];
        }
        else
        {
            for (j = i + 1 -param0 -1; j <= i; j++)
            {
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
                if (j == i + 1 - param0 -1)
                {
                    lMax = techvalue.nHighPrice;
                    lMin = techvalue.nLowPrice;
                }
                else
                {
                    if (lMax < techvalue.nHighPrice)
                        lMax = techvalue.nHighPrice;
                    if (lMin > techvalue.nLowPrice)
                        lMin = techvalue.nLowPrice;	
                }
            }
            tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
            if ( (lMax - lMin) != 0 )
                lRSV = (int)( (double)(techvalue.nClosePrice - lMin) * 10000 / (lMax - lMin) );
            else
                lRSV = 0; 	
            
            long lValue = ([[ayParam0 objectAtIndex:i-1] longValue] * 2 + lRSV) / 3;
            [ayParam0 addObject:[NSNumber numberWithLong:lValue]];
            
            lValue = ([[ayParam0 objectAtIndex:i] longValue] + 2 * [[ayParam1 objectAtIndex:i-1] longValue]) / 3;
            [ayParam1 addObject:[NSNumber numberWithLong:lValue]];
            lValue = 3 * [[ayParam0 objectAtIndex:i] longValue] - 2 * [[ayParam1 objectAtIndex:i] longValue];
            [ayParam2 addObject:[NSNumber numberWithLong:lValue]];
        }
    }
}

//计算RSI指标
- (void)CalculateRSIValues
{		
    [_ayParamsValue removeAllObjects];
    
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 1)
        return;
    
    NSInteger nCount = MIN(_techParamSet.valueNums, [_techParamSet.ayParams count]);
    
	for(int i = 0; i < nCount; i++)
	{
        NSNumber* param = [_techParamSet.ayParams objectAtIndex:i];
		if([param intValue] <= 0)
			return;  
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}	
    
    nCount = [_ayParamsValue count];
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    for (int j = 0; j < nCount; j++) 
    {
        double  upsum1 = 0,downsum1 = 0;
        double  AX1 = 0,BX1 = 0;
        for(int i = 0; i < nValueCount; i++)
        {
            if(i == 0)
            {
                [[_ayParamsValue objectAtIndex:j] addObject:[NSNumber numberWithLong:INT32_MAX]];
            }
            else
            {
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
                tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:i-1];
                //calculate RSI   

                NSNumber* numparam0 = [_techParamSet.ayParams objectAtIndex:j];
                int param0 = [numparam0 intValue];
                NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:j];
                if(i < param0)
                {
                    if (techvalue.nClosePrice > pretechvalue.nClosePrice)
                        upsum1 += techvalue.nClosePrice - pretechvalue.nClosePrice;
                    else if (techvalue.nClosePrice < pretechvalue.nClosePrice)		
                        downsum1 += pretechvalue.nClosePrice - techvalue.nClosePrice;
                    [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
                }
                else if(i == param0)
                {
                    if (techvalue.nClosePrice > pretechvalue.nClosePrice)
                        upsum1 += techvalue.nClosePrice - pretechvalue.nClosePrice;
                    else if (techvalue.nClosePrice < pretechvalue.nClosePrice)		
                        downsum1 += pretechvalue.nClosePrice - techvalue.nClosePrice;
                    
                    AX1 = upsum1 * 10 / param0;
                    BX1 = downsum1 * 10 / param0;	
                    if( (AX1 + BX1) != 0 )
                    {
                        long lvalue = (long)((upsum1 * 100000 / (upsum1 + downsum1) + 5) / 10);
                        [ayParam0 addObject:[NSNumber numberWithLong:lvalue]];
                    }
                    else
                        [ayParam0 addObject:[NSNumber numberWithLong:0]];
                }
                else
                {
                    
                    if (techvalue.nClosePrice > pretechvalue.nClosePrice)
                    {
                        AX1 = AX1 * (param0 - 1)  + (techvalue.nClosePrice - pretechvalue.nClosePrice) * 10;
                        BX1 = BX1 * (param0 - 1);
                    }
                    else if (techvalue.nClosePrice < pretechvalue.nClosePrice)
                    {
                        AX1 = AX1 * (param0 - 1);
                        BX1 = BX1 * (param0 - 1) + (pretechvalue.nClosePrice - techvalue.nClosePrice) * 10;
                    }
                    else
                    {
                        AX1 = AX1 * (param0 - 1);
                        BX1 = BX1 * (param0 - 1);
                    }
                    AX1 = AX1 / param0;
                    BX1 = BX1 / param0;	
                    if( (AX1 + BX1) != 0 )
                    {
                        long lvalue = (long)(((double)AX1 * 100000 / (AX1 + BX1) + 5) / 10);
                        [ayParam0 addObject:[NSNumber numberWithLong:lvalue]];
                    }
                    else
                        [ayParam0 addObject:[NSNumber numberWithLong:0]];
                }
                        
                }	
        }
    }
}

//计算WR指标
- (void)CalculateWRValues
{
    [_ayParamsValue removeAllObjects];
    
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 1)
        return;
    
    NSInteger nCount = MIN(_techParamSet.valueNums, [_techParamSet.ayParams count]);
	for(int i = 0; i < nCount; i++)
	{
        NSNumber* param = [_techParamSet.ayParams objectAtIndex:i];
		if([param intValue] <= 0)
			return;  
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}	
    
    nCount = [_ayParamsValue count];
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    for (int pk = 0; pk < nCount; pk++)
    {
        int lMax = 0, lMin = 0;
        NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:pk];
        int param = [numparam intValue];
        NSMutableArray* ayParam = [_ayParamsValue objectAtIndex:pk];
        
        for(int j = 0; j < nValueCount; j++)
        {
            if(j < param - 1)
            {
                [ayParam addObject:[NSNumber numberWithLong:INT32_MAX]];
            } 
            else
            {
                for(int k = j + 1 - param; k <= j; k++)
                {
                    tztTechValue* techvalue = [_ayTechValue objectAtIndex:k];
                    if (k == j + 1 - param)
                    {
                        lMax = techvalue.nHighPrice;
                        lMin = techvalue.nLowPrice;
                    }
                    else
                    {
                        if (lMax < techvalue.nHighPrice)
                            lMax = techvalue.nHighPrice;
                        if (lMin > techvalue.nLowPrice)
                            lMin = techvalue.nLowPrice;	
                    }
                }
                if( (lMax - lMin) != 0 )
                {
                    tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
                    long lValue = (long)((double)(lMax - techvalue.nClosePrice) * 10000 / (lMax - lMin));
                    [ayParam addObject:[NSNumber numberWithLong:lValue]];
                }
                else
                    [ayParam addObject:[NSNumber numberWithLong:0]];
            }
        }
        	
    }
	
}

//计算BOLL指标
- (void)CalculateBOLLValues
{
    [_ayParamsValue removeAllObjects];
    
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 2 || _techParamSet.valueNums < 2)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{ 
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}	
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    if(param <= 0)
        return;
    NSNumber* numparam1 = [_techParamSet.ayParams objectAtIndex:1];
    int param1 = [numparam1 intValue];
    if(param1 <= 0)
        return;
    double lTotalPrice;
	double lTotalDev;       
	int j;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* ayParam1 = [_ayParamsValue objectAtIndex:1];
    NSMutableArray* ayParam2 = [_ayParamsValue objectAtIndex:2];
    
	for(int i = 0; i < nValueCount; i++)
	{
		if(i < param - 1)
		{
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam2 addObject:[NSNumber numberWithLong:INT32_MAX]];
		} 
		else
		{
			//calulate MB
			lTotalPrice = 0;
			
			for (j = i + 1 - param; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
				lTotalPrice += techvalue.nClosePrice;
			}
            long lValue = (long)(lTotalPrice / param);
            [ayParam0 addObject:[NSNumber numberWithLong:lValue]];
			
			//calulate MBUP
			lTotalDev = 0;
			
			for (j = i + 1 - param; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
                long lValue = [[ayParam0 objectAtIndex:i] longValue];
				lTotalDev += ((double)techvalue.nClosePrice-lValue)*(techvalue.nClosePrice-lValue);     
			} 
			
			lTotalDev = lTotalDev / param;
			
			lTotalDev = sqrt(lTotalDev);             
			long lValue0 = [[ayParam0 objectAtIndex:i] longValue];
            lValue = lValue0+ (long)(lTotalDev*param1);
            [ayParam1 addObject:[NSNumber numberWithLong:lValue]];
            lValue = lValue0 - (long)(lTotalDev*param1);
            [ayParam2 addObject:[NSNumber numberWithLong:lValue]];
		}    
	}
}

- (void)CalculateDMIValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 4)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    if(param <= 0)
        return;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* ayParam1 = [_ayParamsValue objectAtIndex:1];
    NSMutableArray* ayParam2 = [_ayParamsValue objectAtIndex:2];
    NSMutableArray* ayParam3 = [_ayParamsValue objectAtIndex:3];
    
    int j;
	double long TR,TRSUM,DM1SUM,DM2SUM;
	double long DX;
	long DM1, DM2;
    
	for(int i = 0; i < nValueCount; i++)
	{
		if(i < param)
		{
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			TRSUM = 0;
			DM1SUM = 0;
			DM2SUM = 0;
			for (int j = i - param + 1; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
                tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:j-1];
                
				TR = MAX(labs(techvalue.nHighPrice - techvalue.nLowPrice),
                         labs(techvalue.nHighPrice - pretechvalue.nClosePrice));
				TR = MAX(TR,labs(techvalue.nLowPrice - pretechvalue.nClosePrice));
				TRSUM += TR;
                
				DM1 = techvalue.nHighPrice - pretechvalue.nHighPrice;
				if(DM1 < 0)
				{
					DM1 = 0;
				}
				DM2 = pretechvalue.nLowPrice - techvalue.nLowPrice;
				if(DM2 < 0)
				{
					DM2 = 0;
				}
				if(DM1 > DM2)
				{
					DM2 = 0;
				}
				else if(DM1 < DM2)
				{
					DM1 = 0;
				}
				else
				{
					DM1 = 0;
					DM2 = 0;
				}
				DM1SUM += DM1;
				DM2SUM += DM2;
			}
			if (TRSUM)
			{
                [ayParam0 addObject:[NSNumber numberWithLong:(long)(DM1SUM * 10000 / TRSUM)]];
                [ayParam1 addObject:[NSNumber numberWithLong:(long)(DM2SUM * 10000 / TRSUM)]];
			}
			else
			{
                [ayParam0 addObject:[NSNumber numberWithLong:0]];
                [ayParam1 addObject:[NSNumber numberWithLong:0]];
			}
		}
        
		if (i < param * 2)
		{
            [ayParam2 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else if (i == param * 2)
		{
			DX = 0;
			for (j = i - param + 1; j <= i; j++)
			{
                long param0 = [[ayParam0 objectAtIndex:j] longValue];
                long param1 = [[ayParam1 objectAtIndex:j] longValue];
                
				if (param0 + param1)
					DX += labs(param0 - param1) * 10000 / labs((param0 + param1));
			}
            [ayParam2 addObject:[NSNumber numberWithLong:(long)(DX / param)]];
		}
		else
		{
            long param0 = [[ayParam0 objectAtIndex:i] longValue];
            long param1 = [[ayParam1 objectAtIndex:i] longValue];
            long preparam2 = [[ayParam2 objectAtIndex:i-1] longValue];
            
			if (param0 + param1)
				DX = labs(param0 - param1) * 10000 / labs((param0 + param1));
			else
				DX = 0;
            long param2 = (long)(((double long)preparam2 * (param - 1) + DX) / param);
            [ayParam2 addObject:[NSNumber numberWithLong:param2]];
		}
		//calculate ADXR
		if(i < param * 3)
		{
            [ayParam3 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
            long param2 = [[ayParam2 objectAtIndex:i] longValue];
            long preparam2 = [[ayParam2 objectAtIndex:(i - param)] longValue];
			long param3 = (long)(((double long)param2 +preparam2) / 2);
            [ayParam3 addObject:[NSNumber numberWithLong:param3]];
		}
	}
}

- (void)CalculateDMAValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 2 || _techParamSet.valueNums < 2)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    if(param <= 0)
        return;
    
    numparam = [_techParamSet.ayParams objectAtIndex:1];
    int param1 = [numparam intValue];
    if(param1 <= 0)
        return;
    
    if (param > param1)
    {
        int nTemp = param;
        param = param1;
        param1 = nTemp;
    }
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* ayParam1 = [_ayParamsValue objectAtIndex:1];

	int j;
	double lPriceTotal, lMAPrice1, lMAPrice2;
	
	for (int i = 0; i < nValueCount; i++)
	{
		if(i < param1 - 1)
		{
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			lPriceTotal = 0;
			for (j = i - param + 1; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
				lPriceTotal += techvalue.nClosePrice;
			}
			lMAPrice1 = lPriceTotal / param;
			
			lPriceTotal = 0;
			for (j = i - param1 + 1; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
				lPriceTotal += techvalue.nClosePrice;
			}
			lMAPrice2 = lPriceTotal / param1;
			
            int param_val = (int)(lMAPrice1 - lMAPrice2);
			[ayParam0 addObject:[NSNumber numberWithLong:param_val]];
			if(i < (param + param1 - 2))
			{
                [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
			}
			else
			{
				lPriceTotal = 0;
				for (j = i + 1 - param; j <= i; j++)
				{
                    long paramval0 = [[ayParam0 objectAtIndex:j] longValue];
					lPriceTotal += paramval0;
				}
				int param_val1 = (int)(lPriceTotal /param);
                [ayParam1 addObject:[NSNumber numberWithLong:param_val1]];
			}
		}
	}
}

- (void)CalculateTRIXValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 2 || _techParamSet.valueNums < 2)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    if(param <= 0)
        return;
    
    numparam = [_techParamSet.ayParams objectAtIndex:1];
    int param1 = [numparam intValue];
    if(param1 <= 0)
        return;
    
    if (param < param1)
    {
        int nTemp = param;
        param = param1;
        param1 = nTemp;
    }
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSInteger nValueCount = [_ayTechValue count];
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* ayParam1 = [_ayParamsValue objectAtIndex:1];
    
	int i;

	double lTRIXTotal;
 	float AX = 0, BX = 0;
	int j;
 	for (i = 0; i < nValueCount; i++)
	{
        tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
		if(i == 0)
		{
			AX = techvalue.nClosePrice;
			BX = techvalue.nClosePrice;
            [ayParam0 addObject:[NSNumber numberWithLong:BX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			AX = (techvalue.nClosePrice - AX) * 2 / (param + 1) + AX;
			BX = (AX - BX) * 2 / (param + 1) + BX;
            long nPreParamVal = [[ayParam0 objectAtIndex:i-1] longValue];
			long nParam_val = (float)(BX - nPreParamVal) * 2 / (param + 1) + nPreParamVal;
            [ayParam0 addObject:[NSNumber numberWithLong:nParam_val]];
            
#if 0
			if(i < param - 1)
			{
				m_ppCurveValue[1][i] = 0x7fffffff;
			}
			else
			{
				lTRIXTotal = 0;
				for (j = i + 1 - m_pParamValue[1]; j <= i; j++)
				{
					lTRIXTotal += m_ppCurveValue[0][j];
				}
				m_ppCurveValue[1][i] = (int)(lTRIXTotal / param1);
			}
#endif
		}
	}
    
#if 1
    NSMutableArray* pCur = NewObject(NSMutableArray);
    [pCur setArray:ayParam0];

	for (i = 1; i < nValueCount; i++)
	{
		if(i < param - 1)
		{
            [ayParam0 replaceObjectAtIndex:i withObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
            long nPreCur = [[pCur objectAtIndex:i-1] longValue];
            long nCur = [[pCur objectAtIndex:i] longValue];
			if( nPreCur != 0 )
            {
                long param_val = ((float)nCur - (float)nPreCur) / (float)nPreCur * 100000;
				[ayParam0 replaceObjectAtIndex:i withObject:[NSNumber numberWithLong:param_val]];
            }
		}
	}
    
    [pCur removeAllObjects];
    [pCur setArray:ayParam0];
	//
	for (i = 0; i < nValueCount; i++)
	{
		if(i < param - 1)
		{
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			lTRIXTotal = 0;
			for (j = i + 1 - param1; j <= i; j++)
			{
                long nCur = [[pCur objectAtIndex:j] longValue];
				lTRIXTotal += nCur;
			}
            long param_val1 = (int)(lTRIXTotal / param1);
            [ayParam1 addObject:[NSNumber numberWithLong:param_val1]];
		}
	}
    DelObject(pCur);
#endif
    
}


- (void)CalculateBRARValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 2)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    if(param <= 0)
        return;
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* ayParam1 = [_ayParamsValue objectAtIndex:1];
    
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
	NSInteger nValueCount = [_ayTechValue count];
	double up,down;
	int j;
	for (int i = 0; i < nValueCount; i++)
	{
		if(i < param)
		{
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			up = down = 0;
			for (j = i - param + 1; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
                tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:j - 1];
                
				if (techvalue.nHighPrice - pretechvalue.nClosePrice > 0)
					up += techvalue.nHighPrice - pretechvalue.nClosePrice;
				if (pretechvalue.nClosePrice - techvalue.nLowPrice > 0)
					down += pretechvalue.nClosePrice - techvalue.nLowPrice;
			}
			if (up != 0 && down != 0)
			{
                long nParam_val  = (int)(up * 20000 / down);
                [ayParam0 addObject:[NSNumber numberWithLong:nParam_val]];
			}
			else
            {
				[ayParam0 addObject:[NSNumber numberWithLong:0]];
            }
			up = down = 0;
			for (j = i - param + 1; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
				if (techvalue.nHighPrice - techvalue.nOpenPrice > 0)
					up += techvalue.nHighPrice - techvalue.nOpenPrice;
				if (techvalue.nOpenPrice - techvalue.nLowPrice > 0)
					down += techvalue.nOpenPrice - techvalue.nLowPrice;
			}
			if (up != 0 && down != 0)
			{
                long nParam_val1  = (int)(up * 20000 / down);
                [ayParam1 addObject:[NSNumber numberWithLong:nParam_val1]];
			}
			else
            {
                [ayParam1 addObject:[NSNumber numberWithLong:0]];
            }
		}
	}
}

- (void)CalculateCRValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < _techParamSet.valueNums || _techParamSet.valueNums < 5)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    for (int i = 0; i < [_techParamSet.ayParams count] ; i++)
    {
        NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
        int param = [numparam intValue];
        if(param <= 0)
            return;
    }
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];

    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* ayParam1 = [_ayParamsValue objectAtIndex:1];
    NSMutableArray* ayParam2 = [_ayParamsValue objectAtIndex:2];
    NSMutableArray* ayParam3 = [_ayParamsValue objectAtIndex:3];
    NSMutableArray* ayParam4 = [_ayParamsValue objectAtIndex:4];
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
	NSInteger nValueCount = [_ayTechValue count];
    
	int j;
	double up = 0,down = 0;
	//double lCRATotal = 0,lCRBTotal = 0,lCRCTotal = 0,lCRDTotal = 0;
	
	double* MID =(double*)malloc(sizeof(double) * (nValueCount));
	for(int i = 0; i < nValueCount; i++)
	{
        tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
		MID[i] = (techvalue.nHighPrice + techvalue.nLowPrice + techvalue.nClosePrice) / 3;
	}
    
	for (int i = 0; i < nValueCount; i++)
	{
		//calculate CR
		if(i < param)
		{
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam2 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam3 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam4 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			up = down = 0;
			for (j = i - param + 1; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
				up   += MAX(0,(techvalue.nHighPrice - MID[j-1]));
				down += MAX(0,(MID[j-1] - techvalue.nLowPrice));
			}
			if (down != 0)
            {
                long param_val = (int)(up / down * 10000);
                [ayParam0 addObject:[NSNumber numberWithLong:param_val]];
            }
			else
            {
				[ayParam0 addObject:[NSNumber numberWithLong:0]];
            }
		}
	}
    
    
	float lPriceTotal = 0;
    
	for(int i = 1; i < _techParamSet.valueNums; i++)
	{
		int nRef = [[_techParamSet.ayParams objectAtIndex:i] intValue];
        
		if(nRef <= 0)
		{
			for(int j = 0; j < nValueCount; j++)
			{
                NSMutableArray* ayParami = [_ayParamsValue objectAtIndex:i];
                if([ayParami count] <= j)
                {
                    [ayParami addObject:[NSNumber numberWithLong:INT32_MAX]];
                }
                else
                {
                    [ayParami replaceObjectAtIndex:j withObject:[NSNumber numberWithLong:INT32_MAX]];
                }
			}
			continue;
		}
        
		for(int j = 0; j < nValueCount; j++)
		{
			if(j < nRef - 1)
			{
                NSMutableArray* ayParami = [_ayParamsValue objectAtIndex:i];
                if([ayParami count] <= j)
                {
                    [ayParami addObject:[NSNumber numberWithLong:INT32_MAX]];
                }
                else
                {
                    [ayParami replaceObjectAtIndex:j withObject:[NSNumber numberWithLong:INT32_MAX]];
                }
			}
			else
			{
				lPriceTotal = 0;
				for(int k = j + 1 - nRef; k <= j; k++)
				{
                    long param_val = [[ayParam0 objectAtIndex:k] longValue];
					lPriceTotal += param_val;
				}
                long parami_val = lPriceTotal/nRef;
                NSMutableArray* ayParami = [_ayParamsValue objectAtIndex:i];
                if([ayParami count] <= j)
                {
                    [ayParami addObject:[NSNumber numberWithLong:parami_val]];
                }
                else
                {
                    [ayParami replaceObjectAtIndex:j withObject:[NSNumber numberWithLong:parami_val]];
                }
			}
		}
	}
    
	for(int i = 1; i < _techParamSet.valueNums; i++)
	{
        int nParami = [[_techParamSet.ayParams objectAtIndex:i] intValue];
		if(nParami <= 0)
		{
			continue;
		}
        
		int nRef = ((float)nParami / 2.5 + 1);
        
        NSMutableArray* ayParami = [_ayParamsValue objectAtIndex:i];
        
        NSMutableArray* ayValue = NewObject(NSMutableArray);
        [ayValue setArray:ayParami];

		int nPos = 0;
        
		for(int j = 0; j < nValueCount; j++, nPos++)
		{
            long parami_val = 0;
			if(j < nParami + nRef - 1)
			{
				parami_val  = INT32_MAX;
			}
			else
			{
				parami_val = [[ayValue objectAtIndex:(j-nRef)] longValue];
			}
            
            if([ayParami count] <= nPos)
            {
                [ayParami addObject:[NSNumber numberWithLong:parami_val]];
            }
            else
            {
                [ayParami replaceObjectAtIndex:nPos withObject:[NSNumber numberWithLong:parami_val]];
            }
            
		}
        DelObject(ayValue);
	}
    free((void*)MID);
}


- (void)CalculateVRValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 1)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    if(param <= 0)
        return;
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSInteger nValueCount = [_ayTechValue count];
    
	int i;
	int j;
	double AVS,BVS,CVS;
	for (i = 0; i < nValueCount; i++)
	{
		if(i < param)
		{
			[ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			AVS = BVS = CVS = 0;
			for (j = i + 1 - param; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
                tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:j-1];
				if (techvalue.nClosePrice > pretechvalue.nClosePrice)
				{
					AVS += techvalue.ulTotal_h / _lDiv;
				}
				else if (techvalue.nClosePrice < pretechvalue.nClosePrice)
				{
					BVS += techvalue.ulTotal_h  / _lDiv;
				}
				else
				{
					CVS += techvalue.ulTotal_h / _lDiv;
				}
			}
			if ( (BVS + CVS / 2) != 0)
            {
				long param_val = (int)((AVS + CVS / 2) * 10000 / (BVS + CVS / 2));
                [ayParam0 addObject:[NSNumber numberWithLong:param_val]];
            }
			else
            {
				[ayParam0 addObject:[NSNumber numberWithLong:0]];
            }
		}
	}
}

- (void)CalculateOBVValues
{
	[_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || _techParamSet.valueNums < 1)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSInteger nValueCount = [_ayTechValue count];
    
	NSInteger nCount = 1;
    
    //k线没返回数据时候，[_ayTechValue objectAtIndex:0];将会越界，添加判断
    if (nValueCount == 0)
        return;
	
    tztTechValue* techvalue = [_ayTechValue objectAtIndex:0];
    
	if ((double)techvalue.ulTotal_h * techvalue.nClosePrice / 1000000 >  0x0fffffff)
    {
		nCount = 100;
	}
	
	for(int i = 0; i < nValueCount; i++)
	{
		if( i == 0)
		{
			[ayParam0 addObject:[NSNumber numberWithLong:0]];
		}
		else
		{
            techvalue = [_ayTechValue objectAtIndex:i];
            tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:(i- 1)];
            long prepram_val = [[ayParam0 objectAtIndex:(i-1)] longValue];
            long param_val = 0;
			if (techvalue.nClosePrice > pretechvalue.nClosePrice)
				param_val = prepram_val + (int)((double)techvalue.ulTotal_h * techvalue.nClosePrice / 1000000/nCount);//000);
			else if	(techvalue.nClosePrice < pretechvalue.nClosePrice)
				param_val = prepram_val - (int)((double)techvalue.ulTotal_h * techvalue.nClosePrice / 1000000/nCount);//000);
			else
				param_val = prepram_val;
            [ayParam0 addObject:[NSNumber numberWithLong:param_val]];
		}
	}
}

- (void)CalculateASIValues
{
	[_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || _techParamSet.valueNums < 1)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSInteger nValueCount = [_ayTechValue count];
    
	int A,B,C,D,E,F,G,X,K,L = 0,R = 0;
	for(int i = 0; i < nValueCount; i++)
	{
		if(i == 0)
		{
			[ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
			continue;
		}
        
        tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
        tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:(i- 1)];
        
		A = abs(techvalue.nHighPrice - pretechvalue.nClosePrice);
		B = abs(techvalue.nLowPrice - pretechvalue.nClosePrice);
		C = abs(techvalue.nHighPrice - pretechvalue.nLowPrice);
		D = abs(pretechvalue.nClosePrice - pretechvalue.nOpenPrice);
		E = techvalue.nClosePrice - pretechvalue.nClosePrice;
		F = techvalue.nClosePrice - techvalue.nOpenPrice;
		G = pretechvalue.nClosePrice - pretechvalue.nOpenPrice;
		X = E + F / 2 + G;
		K = MAX(A,B);
		
		if (A >= B && A>= C)
		{
			R = A + B / 2 + D / 4;
		}
		else if (B >= A && B >= C)
		{
			R = B + A / 2 + D / 4;
		}
		else if (C >= A && C >= B)
		{
			R = C + D / 4;
		}
		
		L = 38;
		
		if (i == 1)
		{
            long param_val = 0;
			if (R * L != 0)
            {
				param_val = 50 * X * K / (R * L);
            }
			else
            {
				param_val = 0;
            }
            [ayParam0 addObject:[NSNumber numberWithLong:param_val]];
		}
		else
		{
            long preparam_val = [[ayParam0 objectAtIndex:(i-1)] longValue];
            long param_val = 0;
			if (R * L != 0)
				param_val = 50 * X * K / (R * L) + preparam_val;
			else
				param_val = preparam_val;
            [ayParam0 addObject:[NSNumber numberWithLong:param_val]];
		}
	}
}

- (void)CalculateEMVValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 2 || _techParamSet.valueNums < 2)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    for (int i = 0; i < [_techParamSet.ayParams count] ; i++)
    {
        NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
        int param = [numparam intValue];
        if(param <= 0)
            return;
    }
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    numparam = [_techParamSet.ayParams objectAtIndex:1];
    int param1 = [numparam intValue];
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* ayParam1 = [_ayParamsValue objectAtIndex:1];
    
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
	NSInteger nValueCount = [_ayTechValue count];
    
    int i = 0;
 	long A,B,MID,C;
	double long REM,SUMEMV, BRO;
	int j;
	for(i = 0; i < nValueCount; i++)
	{
		if(i < param)
		{
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			REM = 0;
			for (j = i - param + 1; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
                tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:j-1];
				if (techvalue.nHighPrice - techvalue.nLowPrice && (long)techvalue.ulTotal_h > 0)
				{
					A = (techvalue.nHighPrice + techvalue.nLowPrice) / 2;
					B = (pretechvalue.nHighPrice + pretechvalue.nLowPrice) / 2;
					MID = A - B;
                    
					C = (techvalue.nHighPrice + techvalue.nLowPrice + 2 * techvalue.nClosePrice) / 4;
					//C = pData[j].m_lMinPrice;
					BRO = (double long)techvalue.ulTotal_h * C / (techvalue.nHighPrice - techvalue.nLowPrice);
					//BRO = pData[j].m_lTotal;
					if (BRO)
                        //						REM += (double long) MID * 1000000 / BRO;
						REM += (double long) MID * 1000000000 / BRO;
				}
			}
            
            [ayParam0 addObject:[NSNumber numberWithLong:(long)(REM / param)]];
			if(i < param + param1 -1)
			{
                [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
			}
			else
			{
				SUMEMV = 0;
				for (j = i + 1 - param1; j <= i; j++)
				{
                    long param_val = [[ayParam0 objectAtIndex:j] longValue];
					SUMEMV += param_val;
				}
                [ayParam1 addObject:[NSNumber numberWithLong:(long)(SUMEMV / param1)]];
			}
		}
	}
}

- (void)CalculateWVADValues
{
	[_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 1)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];

    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
	NSInteger nValueCount = [_ayTechValue count];
    
	int i;
	int j;
	double A,B,V;
	double SUMWVAD;
	for(i = 0; i < nValueCount; i++)
	{
		if(i < param - 1)
		{
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			SUMWVAD = 0;
			for (j = i + 1 - param; j <= i; j++)
			{
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
				A = techvalue.nClosePrice - techvalue.nOpenPrice;
				B = techvalue.nHighPrice - techvalue.nLowPrice;
				V = techvalue.ulTotal_h / _lDiv;
				if (B != 0 && V > 0)
				{
					SUMWVAD += A * V / B;
				}
			}
            [ayParam0 addObject:[NSNumber numberWithLong:(int)(SUMWVAD * 100 / param)]];
		}
	}
}

- (void)CalculateSARValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 4)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* ayParam1 = [_ayParamsValue objectAtIndex:1];
    NSMutableArray* ayParam2 = [_ayParamsValue objectAtIndex:2];
    NSMutableArray* ayParam3 = [_ayParamsValue objectAtIndex:3];
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
	NSInteger nValueCount = [_ayTechValue count];
    
    
	long lMax = 0,lMin;
	long lNewMax;
	long lBuy = 1;
	double AF = -1;
 	
 	for(int i = 0; i < nValueCount; i++)
 	{
		if(i < param)
		{
            [ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
	    else
	    {
			if(AF < 0)
			{
                tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:i - param];
                
				lMax = pretechvalue.nHighPrice;
				lMin = pretechvalue.nLowPrice;
				for(int j = i - param + 1; j < i; j++)
				{
                    tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
					if (lMax < techvalue.nHighPrice)
					{
						lMax = techvalue.nHighPrice;
					}
					if (lMin > techvalue.nLowPrice)
					{
						lMin = techvalue.nLowPrice;
					}
				}
                [ayParam1 addObject:[NSNumber numberWithLong:lBuy]];
				if(lBuy)
				{
                    [ayParam0 addObject:[NSNumber numberWithLong:lMin]];
				}
				else
				{
                    [ayParam0 addObject:[NSNumber numberWithLong:lMax]];
				}
				AF = 0;
			}
			else
			{
				lNewMax = 0;
				for(int j = i - 1 - param ; j < i - 1; j++)
				{
                    tztTechValue* techvalue = [_ayTechValue objectAtIndex:j];
					if (lNewMax < techvalue.nHighPrice)
					{
						lNewMax = techvalue.nHighPrice;
					}
				}
				if(lNewMax != lMax)
				{
					AF += 0.02;
					lMax = lNewMax;
				}
				if(lBuy && AF < 0.02)
				{
					AF = 0.02;
				}
				if(AF > 0.2)
				{
					AF = 0.2;
				}
                long preparam_val = [[ayParam0 objectAtIndex:i-1] longValue];
                tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:i-1];
				long param_val = (long)(preparam_val +
                                              AF * (lNewMax - preparam_val));
				long param_val1 = pretechvalue.nClosePrice >= preparam_val ? 1 : 0;
                [ayParam0 addObject:[NSNumber numberWithLong:param_val]];
                [ayParam1 addObject:[NSNumber numberWithLong:param_val1]];
				if(param_val1 != lBuy)
				{
					AF = -1;
					lBuy = param_val1;
				}
			}
		}
	}
    [ayParam2 setArray:ayParam0];
    [ayParam3 setArray:ayParam0];
	for(int i = 0; i < nValueCount; i++)
	{
        long param_val = [[ayParam0 objectAtIndex:i] longValue];
        long param_val1 = [[ayParam1 objectAtIndex:i] longValue];
        
		if((param_val == INT32_MAX) || (param_val1 == INT32_MAX) ||
           (param_val <= 0))
		{
            [ayParam2 replaceObjectAtIndex:i withObject:[NSNumber numberWithLong:INT32_MAX]];
            [ayParam3 replaceObjectAtIndex:i withObject:[NSNumber numberWithLong:INT32_MAX]];
			continue;
		}
		if(param_val1)
		{
			[ayParam3 replaceObjectAtIndex:i withObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			[ayParam2 replaceObjectAtIndex:i withObject:[NSNumber numberWithLong:INT32_MAX]];
		}
	} 
}

- (void)CalculateCCIValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 1)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    if(param <= 0)
        return;
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
	NSInteger nValueCount = [_ayTechValue count];
    
	int i;
	double lPriceTotal;
	double lAveragePrice;
	double D;
	int j;
	for(i = 0; i < nValueCount; i++)
	{
		if(i < param - 1)
		{
			[ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
			lPriceTotal = 0;
            
            tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
			for (j = i + 1 - param;j <= i; j++)
			{
                tztTechValue* techvaluej = [_ayTechValue objectAtIndex:j];
				lPriceTotal += (techvaluej.nClosePrice + techvalue.nOpenPrice + techvaluej.nHighPrice + techvaluej.nLowPrice) / 4;
			}
			
			lAveragePrice = lPriceTotal / param;
			D = 0;
			
			for (j = i + 1 - param; j <= i; j++)
            {
                tztTechValue* techvaluej = [_ayTechValue objectAtIndex:j];
				D += abs((int)(((double)techvaluej.nClosePrice + techvalue.nOpenPrice + techvaluej.nHighPrice + techvaluej.nLowPrice) / 4 - lAveragePrice));
            }
            
			
			D = D / param;
			long param_val = 0;
			if(D > 0)
            {
				param_val = (int)(((( double)techvalue.nClosePrice + techvalue.nOpenPrice + techvalue.nHighPrice + techvalue.nLowPrice) / 4 - lAveragePrice) * 100000 / (15 * D));
            }
			else
            {
				param_val = 0;
            }
            [ayParam0 addObject:[NSNumber numberWithLong:param_val]];
		}
	}
}

- (void)CalculateROCValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 1 || _techParamSet.valueNums < 1)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    if(param <= 0)
        return;
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
	NSInteger nValueCount = [_ayTechValue count];

	int lClose;
	for(int i = 0; i < nValueCount; i++)
	{
		if(i < param)
		{
			[ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
            tztTechValue* pretechvalue = [_ayTechValue objectAtIndex:i - param];
            tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
            
			lClose = pretechvalue.nClosePrice;
            long param_val = INT32_MAX;
			if (lClose != 0)
				param_val = (techvalue.nClosePrice - lClose) * 10000 / lClose;
			else
				param_val = INT32_MAX;
            [ayParam0 addObject:[NSNumber numberWithLong:param_val]];
		}
	}
}

- (void)CalculateBIASValues
{
    [_ayParamsValue removeAllObjects];
    if(_techParamSet == nil || [_techParamSet.ayParams count] < 3 || _techParamSet.valueNums < 3)
        return;
    
	for(int i = 0; i < _techParamSet.valueNums; i++)
	{
        NSMutableArray* ayParam = NewObject(NSMutableArray);
        [_ayParamsValue addObject:ayParam];
        [ayParam release];
	}
    
    for(int i = 0; i < [_techParamSet.ayParams count]; i++)
	{
        NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:i];
        int param = [numparam intValue];
        if(param <= 0)
            return;
	}
    
    NSNumber* numparam = [_techParamSet.ayParams objectAtIndex:0];
    int param = [numparam intValue];
    numparam = [_techParamSet.ayParams objectAtIndex:1];
    int param1 = [numparam intValue];
    numparam = [_techParamSet.ayParams objectAtIndex:2];
    int param2 = [numparam intValue];
    
    
    NSMutableArray* ayParam0 = [_ayParamsValue objectAtIndex:0];
    NSMutableArray* ayParam1 = [_ayParamsValue objectAtIndex:1];
    NSMutableArray* ayParam2 = [_ayParamsValue objectAtIndex:2];
    NSMutableArray* _ayTechValue = [_techView tztTechObjAyValue:self];
	NSInteger nValueCount = [_ayTechValue count];
    double avg,avg1,avg2;
    for(int i = 0; i < nValueCount; i++)
	{
		if(i < param)
		{
			[ayParam0 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
            avg = 0;
            for (int j = 1; j <= param; j++)
            {
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:i-j];
                avg += techvalue.nClosePrice;
            }
            long param_vol = 0;
            if(avg)
            {
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
                param_vol = (long) ((techvalue.nClosePrice * param - avg)*100/avg);
            }
            [ayParam0 addObject:[NSNumber numberWithLong:param_vol]];
		}
        
        if(i < param1)
		{
			[ayParam1 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
            avg1 = 0;
            for (int j = 1; j <= param1; j++)
            {
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:i-j];
                avg1 += techvalue.nClosePrice;
            }
            long param_vol1 = 0;
            if(avg1)
            {
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
                param_vol1 = (long) ((techvalue.nClosePrice * param1 - avg1)* 100/avg1);
            }
            [ayParam1 addObject:[NSNumber numberWithLong:param_vol1]];
		}
        
        
        if(i < param2)
		{
			[ayParam2 addObject:[NSNumber numberWithLong:INT32_MAX]];
		}
		else
		{
            avg2 = 0;
            for (int j = 1; j <= param2; j++)
            {
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:i-j];
                avg2 += techvalue.nClosePrice;
            }
            long param_vol2 = 0;
            if(avg2)
            {
                tztTechValue* techvalue = [_ayTechValue objectAtIndex:i];
                param_vol2 = (long) ((techvalue.nClosePrice * param2 - avg2)* 100/avg2);
            }
            [ayParam2 addObject:[NSNumber numberWithLong:param_vol2]];
		}
	}
}
#if 0
- (void)CalculateMIKEValues
{
	if((nStart >= nEnd) || (nStart < 0) || (nEnd > m_nValueNum))
		return ;
	int i;
	for(i = 0; i < m_nParams; i++)
	{
		if(m_pParamValue[i] <= 0)
			return;
	}
	long TPY;
	long lMax;
	long lMin;
	int j;
	for(i = nStart; i < nEnd; i++)
	{
		if(i < m_pParamValue[0])
		{
   			m_ppCurveValue[0][i] = 0;
   			m_ppCurveValue[1][i] = 0;
   			m_ppCurveValue[2][i] = 0;
   			m_ppCurveValue[3][i] = 0;
   			m_ppCurveValue[4][i] = 0;
   			m_ppCurveValue[5][i] = 0;
   			m_ppCurveValue[6][i] = 0;
		}
		else
		{
			TPY = 0;
			for (j = i - m_pParamValue[0]; j < i; j++)
			{
				if (j == i - m_pParamValue[0])
				{
					lMax = pData[j].m_lMaxPrice;
					lMin = pData[j].m_lMinPrice;
				}
				else
				{
					if (lMax < pData[j].m_lMaxPrice)
						lMax = pData[j].m_lMaxPrice;
					if (lMin > pData[j].m_lMinPrice)
						lMin = pData[j].m_lMinPrice;
				}
				TPY += (pData[j].m_lMaxPrice + pData[j].m_lMinPrice + pData[j].m_lClosePrice) / 3;
			}
			m_ppCurveValue[0][i] = (TPY + TPY - m_pParamValue[0] * lMin) / m_pParamValue[0];
			m_ppCurveValue[1][i] = (TPY + (m_pParamValue[0] * lMax - m_pParamValue[0] * lMin)) / m_pParamValue[0];
			m_ppCurveValue[2][i] = (m_pParamValue[0] * 2 * lMax - m_pParamValue[0] * lMin) / m_pParamValue[0];
			m_ppCurveValue[3][i] = (TPY - (m_pParamValue[0] * lMax - TPY)) / m_pParamValue[0];
			m_ppCurveValue[4][i] = (TPY - (m_pParamValue[0] * lMax - m_pParamValue[0] * lMin)) / m_pParamValue[0];
			m_ppCurveValue[5][i] = (m_pParamValue[0] * 2 * lMin - m_pParamValue[0] * lMax) / m_pParamValue[0];
   			m_ppCurveValue[6][i] = pData[j].m_lClosePrice;
		}
	}
}
#endif


- (BOOL)ParamRectContainsPoint:(CGPoint) touchPoint
{
    if(self.hidden)
        return FALSE;
    return CGRectContainsPoint(_KLineParamRect, touchPoint);  
}

- (CGRect)getDrawRect
{
    return _KLineDrawRect;
}
@end
