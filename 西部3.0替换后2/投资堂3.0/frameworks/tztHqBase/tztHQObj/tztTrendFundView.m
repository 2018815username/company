/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztTrendFundView
 * 文件标识：    资金流向
 * 摘    要：
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/


#import "tztTrendFundView.h"

@class tztPriceView;
@class tztPieView;
@protocol tztPieViewDataSource;
@protocol tztPieViewDelegate;

 /**
 *	@brief	资金流向数据行高
 */
#define tztTrendFundDataLineHeight 30

 /**
 *	@brief	具体的资金流向表格数据显示view（机构、大户、散户的流入、流出数据表格， 非饼图）
 */
@interface tztTrendFundDataView : UIView

{
    NSInteger             _nColCount;
    NSInteger             _nRowCount;
    
    NSMutableArray  *_ayTitle;
    NSMutableArray  *_ayData;
    NSMutableArray  *_ayColor;
   
    
}

 /**
 *	@brief	表格数据显示列数
 */
@property(nonatomic)NSInteger nColCount;

 /**
 *	@brief	表格数据显示行数
 */
@property(nonatomic)NSInteger nRowCount;

 /**
 *	@brief	标题数据数组
 */
@property(nonatomic,retain)NSMutableArray *ayTitle;

 /**
 *	@brief	显示的具体数据数组
 */
@property(nonatomic,retain)NSMutableArray *ayData;

 /**
 *	@brief	数据显示颜色数组
 */
@property(nonatomic,retain)NSMutableArray *ayColor;

@end

@implementation tztTrendFundDataView
@synthesize nColCount = _nColCount;
@synthesize nRowCount = _nRowCount;
@synthesize ayTitle = _ayTitle;
@synthesize ayData = _ayData;
@synthesize ayColor = _ayColor;

-(id)init
{
    self = [super init];
    if (self)
    {
        _ayData = NewObject(NSMutableArray);
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
//    [self setBackgroundColor:[UIColor tztThemeBackgroundColorHQ]];
//    self.backgroundColor = [UIColor redColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1);
    UIColor *pColor = [UIColor tztThemeBackgroundColorHQ];
    CGContextSetStrokeColorWithColor(context, pColor.CGColor);
    CGContextSetFillColorWithColor(context, pColor.CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    [self DrawData:context rect:rect];
}

 /**
 *	@brief	绘制具体的流入流出表格数据
 *
 *	@param 	context 	绘制上下文
 *	@param 	rect 	绘制区域
 *
 *	@return	NULL
 */
-(void)DrawData:(CGContextRef)context rect:(CGRect)rect
{
    UIFont *pFont = tztUIBaseViewTextFont(14.0f);
    if (IS_TZTIPAD)
        pFont = tztUIBaseViewTextFont(12.0f);
    NSString* strText = @"测试";
    CGSize size = [strText sizeWithFont:pFont];
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQGridColor].CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextStrokePath(context);
    
    CGRect rcText = rect;
    int nFirstWidth = 60;
    rcText.origin.x = 0;
    rcText.origin.y = (tztTrendFundDataLineHeight - size.height) / 2;
    int nWidth = (rect.size.width - nFirstWidth - _nColCount) / (_nColCount - 1);
    rcText.size.width = nWidth;
    rcText.size.height = tztTrendFundDataLineHeight - 2;
    
    CGContextSetFillColorWithColor(context, [UIColor tztThemeHQBalanceColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQBalanceColor].CGColor);
    
//    int nWidth = rcText.size.width;
    for (int i = 0; i < [_ayTitle count]; i++)
    {
        NSString* nsTitle = [_ayTitle objectAtIndex:i];
        if (nsTitle == NULL)
            nsTitle = @"";
        if (i == 0)
        {
            rcText.origin.x = 0;
            rcText.size.width = nFirstWidth;
        }
        else
        {
            rcText.origin.x = nFirstWidth + ((i-1) * nWidth);
            rcText.size.width = nWidth;
        }
        
        [nsTitle drawInRect:rcText
                   withFont:pFont
              lineBreakMode:NSLineBreakByCharWrapping
                  alignment:NSTextAlignmentCenter];
    }
    
    rcText.size.width = nWidth;
//    int nPCount = [self.ayData count]-1;
    for (int i = 0; i < [self.ayData count]; i++)
    {
        tztTrendFundFlows *fundFlows = [self.ayData objectAtIndex:i];
        //分类
        CGContextSetFillColorWithColor(context, [UIColor tztThemeHQBalanceColor].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQBalanceColor].CGColor);
        NSString* nsValue = fundFlows.nsKind;
        rcText.origin.x = 0;
        rcText.origin.y += tztTrendFundDataLineHeight;
        
        [nsValue drawInRect:CGRectMake(0, rcText.origin.y, nFirstWidth, rcText.size.height)
                   withFont:pFont
              lineBreakMode:NSLineBreakByCharWrapping
                  alignment:NSTextAlignmentCenter];
        
        rcText.origin.x += nFirstWidth;
        
        //流入
        //前面的颜色方块
        CGRect rc = rcText;
        rc.size = CGSizeMake(10, 10);
        rc.origin.y += (rcText.size.height - 20) / 2;
        
        UIColor *pColor = [UIColor colorWithTztRGBStr:[_ayColor objectAtIndex:(i*2)]];
        CGContextSetFillColorWithColor(context, pColor.CGColor);
        CGContextSetStrokeColorWithColor(context, pColor.CGColor);
        CGContextAddRect(context, rc);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextStrokePath(context);
        
        CGContextSetFillColorWithColor(context, [UIColor tztThemeHQUpColor].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQUpColor].CGColor);
        nsValue = fundFlows.nsFundIn;
        
        CGRect rc1 = rcText;
        rc1.origin.x += rc.size.width;
        rc1.size.width -= rc.size.width;
        
        [nsValue drawInRect:rc1
                   withFont:pFont
              lineBreakMode:NSLineBreakByCharWrapping
                  alignment:NSTextAlignmentCenter];
        
        //流出
        rcText.origin.x += rcText.size.width;
        rc = rcText;
        rc.size = CGSizeMake(10, 10);
        rc.origin.y += (rcText.size.height - 20) / 2;
        
        pColor = [UIColor colorWithTztRGBStr:[_ayColor objectAtIndex:(i*2)+1]];
        CGContextSetFillColorWithColor(context, pColor.CGColor);
        CGContextSetStrokeColorWithColor(context, pColor.CGColor);
        CGContextAddRect(context, rc);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextStrokePath(context);
        
        CGContextSetFillColorWithColor(context, [UIColor tztThemeHQDownColor].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQDownColor].CGColor);
        nsValue = fundFlows.nsFundOut;
        
        rc1 = rcText;
        rc1.origin.x += rc.size.width;
        rc1.size.width -= rc.size.width;
        [nsValue drawInRect:rc1
                   withFont:pFont
              lineBreakMode:NSLineBreakByCharWrapping
                  alignment:NSTextAlignmentCenter];
        
        //净额
        rcText.origin.x += rcText.size.width;
        nsValue = fundFlows.nsFundJE;
        if ([nsValue hasPrefix:@"-"])
        {
            CGContextSetFillColorWithColor(context, [UIColor tztThemeHQDownColor].CGColor);
            CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQDownColor].CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, [UIColor tztThemeHQUpColor].CGColor);
            CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQUpColor].CGColor);
        }
        [nsValue drawInRect:rcText
                   withFont:pFont
              lineBreakMode:NSLineBreakByCharWrapping
                  alignment:NSTextAlignmentCenter];
    }
    
    
}

-(void)dealloc
{
    DelObject(_ayData);
    [super dealloc];
}
@end

@interface tztTrendFundView ()<tztPieViewDataSource, tztPieViewDelegate>
{
    NSMutableArray  *_ayTitle;
    NSMutableArray  *_ayFundValues;
    NSMutableArray  *_ayPieValues;
    NSMutableArray  *_ayRGB;
    
    NSString        *_PreStockCode;
    int             _nMaxCount;
    
    CGPoint         _pCurPoint;
    
    tztPieView      *_pPieViewChart;//饼图
    
    
    //主力流入
    UILabel         *_lbZLIn;
    UILabel         *_lbZLInValue;
    UILabel         *_lbZLInRect;
    UILabel         *_lbZLInRect1;
    //主力流出
    UILabel         *_lbZLOut;
    UILabel         *_lbZLOutValue;
    UILabel         *_lbZLOutRect;
    UILabel         *_lbZLOutRect1;
    //主力净流入
    UILabel         *_lbZLInFlow;
    UILabel         *_lbZLInFlowValue;
    
    //报价头
    TNewPriceData   *_PriceData;
    //左侧数据显示
    UIView          *_pLeftView;
    

    
    tztTrendFundDataView *_pTrendFundDataView;
    
     UIScrollView    *_scrollview;//4s 显示资金数据不去用一个ScrollView
}

//圆心说明
@property(nonatomic,retain) UIView          *pCenterView;
@property(nonatomic,retain) UILabel         *pLabelName;
@property(nonatomic,retain) UILabel         *pLabelNameEn;
@end

@implementation tztTrendFundView
@synthesize pCenterView = _pCenterView;
@synthesize pLabelName = _pLabelName;
@synthesize pLabelNameEn = _pLabelNameEn;
- (id)initWithFrame:(CGRect)frame
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
    if (_PriceData)
    {
        free(_PriceData);
        _PriceData = NULL;
    }
    DelObject(_ayFundValues);
    DelObject(_ayPieValues);
    DelObject(_ayTitle);
    DelObject(_ayRGB);
    [super dealloc];
}

-(void)initdata
{
    _nMaxCount = 0;
    _ayFundValues = NewObject(NSMutableArray);
    _ayPieValues = NewObject(NSMutableArray);
    _ayTitle = NewObject(NSMutableArray);
    _PreStockCode = @"";
    _pCurPoint = CGPointZero;
    
    _PriceData = malloc(sizeof(TNewPriceData));
    memset(_PriceData, 0x00, sizeof(TNewPriceData));
    
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];// [tztTechSetting getInstance].backgroundColor;
    //初始化颜色值
    _ayRGB = NewObject(NSMutableArray)
    NSString *str = [NSString stringWithFormat:@"%d,%d,%d",255,49,57];
    [_ayRGB addObject:str];
    str = [NSString stringWithFormat:@"%d,%d,%d",255,140,55];
    [_ayRGB addObject:str];
    str = [NSString stringWithFormat:@"%d,%d,%d",176,217,81];
    [_ayRGB addObject:str];
    str = [NSString stringWithFormat:@"%d,%d,%d",63,178,67];
    [_ayRGB addObject:str];
    
//    str = [NSString stringWithFormat:@"%d,%d,%d",0,130,0];
//    [_ayRGB addObject:str];
//    str = [NSString stringWithFormat:@"%d,%d,%d",0,148,0];
//    [_ayRGB addObject:str];
//    str = [NSString stringWithFormat:@"%d,%d,%d",0,231,0];
//    [_ayRGB addObject:str];
//    str = [NSString stringWithFormat:@"%d,%d,%d",0,214,188];
//    [_ayRGB addObject:str];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
//// 3.5 寸的屏幕显示数据不全
    if (_scrollview == nil)
    {
        _scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollview.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height+70);
        [self addSubview:_scrollview];
        [_scrollview release];
    }
    else
    {
        _scrollview.frame = self.bounds;
        _scrollview.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height+70);
    }
    
    CGRect rcFrame = self.bounds;
    CGRect rcPie =  CGRectMake(rcFrame.origin.x+rcFrame.size.width / 4, rcFrame.origin.y + 50, rcFrame.size.width/2, rcFrame.size.height *2/3);
    if (_pPieViewChart== NULL)
    {
        _pPieViewChart = [[tztPieView alloc] initWithFrame:rcPie];
        _pPieViewChart.tztDataSource = self;
        _pPieViewChart.tztDelegate = self;
        _pPieViewChart.bShowInfo = YES;
        _pPieViewChart.fStartPieAngle = M_PI;
        _pPieViewChart.fAnimationSpeed = .5f;
        [_pPieViewChart setLabelFont:tztUIBaseViewTextFont(12)];
        _pPieViewChart.fLabelRadius = rcPie.size.width / 2 + 10;
        _pPieViewChart.bShowPercentage = YES;
        [_pPieViewChart setPieBackgroudColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [_pPieViewChart setFPieCener:_pPieViewChart.center];
        _pPieViewChart.fPieRadius = 70;
//        [_pPieViewChart setUserInteractionEnabled:NO];
        [_pPieViewChart setLabelShadowColor:[UIColor blackColor]];
        [_scrollview addSubview:_pPieViewChart];
    }
    else
    {
        //[_scrollview addSubview:_pPieViewChart];
        _pPieViewChart.frame = rcPie;
    }
    
    CGRect rcCenter = rcPie;
    rcCenter.size = CGSizeMake(_pPieViewChart.fPieRadius * 2 - 50, _pPieViewChart.fPieRadius* 2 - 50);
    rcCenter.origin.x = (rcPie.size.width - rcCenter.size.width) / 2;
    rcCenter.origin.y = (rcPie.size.height - rcCenter.size.height) / 2;
    if (_pCenterView == NULL)
    {
        _pCenterView = [[UIView alloc] initWithFrame:rcCenter];
        [_pPieViewChart addSubview:_pCenterView];
        [_pCenterView release];
        _pCenterView.layer.cornerRadius = 45;
    }
    _pCenterView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _pCenterView.frame = rcCenter;
    _pCenterView.center = _pPieViewChart.fPieCener;
    
    CGRect rcLabel = rcCenter;
    rcLabel.size.height = 30;
    if (_pLabelName == NULL)
    {
        _pLabelName = [[UILabel alloc] initWithFrame:rcLabel];
        _pLabelName.text = @"今日资金";
        _pLabelName.font = tztUIBaseViewTextFont(16);
        _pLabelName.textColor = [UIColor blackColor];
        _pLabelName.textAlignment = NSTextAlignmentCenter;
        _pLabelName.backgroundColor = [UIColor clearColor];
        [_pPieViewChart addSubview:_pLabelName];
        [_pLabelName release];
    }
    _pLabelName.center = CGPointMake(_pPieViewChart.fPieCener.x, _pPieViewChart.fPieCener.y - 6);
    
    if (_pLabelNameEn == NULL)
    {
        _pLabelNameEn = [[UILabel alloc] initWithFrame:rcLabel];
        _pLabelNameEn.text = @"Capital Flows";
        _pLabelNameEn.font = tztUIBaseViewTextFont(12);
        _pLabelNameEn.textColor = [UIColor lightGrayColor];
        _pLabelNameEn.textAlignment = NSTextAlignmentCenter;
        [_pPieViewChart addSubview:_pLabelNameEn];
        _pLabelNameEn.backgroundColor = [UIColor clearColor];
        [_pLabelNameEn release];
    }
    _pLabelNameEn.center = CGPointMake(_pPieViewChart.fPieCener.x, _pPieViewChart.fPieCener.y+8);
    
    [self setLeftFrame:rcFrame];
    [self setBottom:rcFrame];
 
//   [self bringSubviewToFront:_pCenterView];
    [self bringSubviewToFront:_scrollview];
}

-(void)drawRect:(CGRect)rect
{
    return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 0.8f);
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQGridColor].CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextStrokePath(context);
    
    //绘制虚线
    CGFloat fLengths[] = {3,3};
    CGContextSetLineDash(context, 0, fLengths,2);
    CGContextMoveToPoint(context, CGRectGetMinX(rect) + CGRectGetWidth(rect) / 2 + 1 , CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, CGRectGetMinX(rect) + CGRectGetWidth(rect) / 2 + 1 , CGRectGetMinY(rect) + CGRectGetMaxY(rect) / 2);
    CGContextStrokePath(context);
    
    CGRect rc1 = _lbZLInValue.frame;
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rc1) + CGRectGetHeight(rc1));
    CGContextAddLineToPoint(context, CGRectGetMinX(rect) + CGRectGetWidth(rect)/2, CGRectGetMinY(rc1) + CGRectGetHeight(rc1));
    CGContextStrokePath(context);
    
    rc1 = _lbZLOutValue.frame;
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rc1) + CGRectGetHeight(rc1));
    CGContextAddLineToPoint(context, CGRectGetMinX(rect) + CGRectGetWidth(rect)/2, CGRectGetMinY(rc1) + CGRectGetHeight(rc1));
    CGContextStrokePath(context);
    
}

-(void)setLeftFrame:(CGRect)frame
{
    _lbZLIn.hidden = YES;
    _lbZLInRect.hidden = YES;
    _lbZLInRect1.hidden = YES;
    _lbZLOut.hidden = YES;
    _lbZLOutRect.hidden = YES;
    _lbZLOutRect1.hidden = YES;
    return;
    CGRect rcFrame = frame;
    rcFrame.size.width = rcFrame.size.width / 2 - 20;
    rcFrame.size.height = rcFrame.size.height / 2;
    
    rcFrame.origin.x += 10;
//    rcFrame.origin.y = 10;
    
    int nPerHeight = rcFrame.size.height / 6;
    
    UIFont *font = tztUIBaseViewTextFont(13.0f);
    CGRect rcLabel = rcFrame;
    rcLabel.size.height = nPerHeight;
    if (_lbZLIn == nil)
    {
        _lbZLIn = [[UILabel alloc] initWithFrame:rcLabel];
        [_lbZLIn setText:@"主力流入(万元)"];
        [_lbZLIn setFont:font];
        _lbZLIn.backgroundColor = [UIColor clearColor];
        [_lbZLIn setTextColor:[UIColor tztThemeHQBalanceColor]];
        _lbZLIn.adjustsFontSizeToFitWidth = YES;
        [_scrollview addSubview:_lbZLIn];
        [_lbZLIn release];
    }
    else
    {
        _lbZLIn.frame = rcLabel;
    }
    
    rcLabel.origin.y += nPerHeight;
    
    CGRect rcInValue = rcLabel;
    rcInValue.size = CGSizeMake(10, 10);
    rcInValue.origin.x += 5;
    rcInValue.origin.y += (rcLabel.size.height - 10) / 2;
    if (_lbZLInRect == NULL)
    {
        _lbZLInRect = [[UILabel alloc] initWithFrame:rcInValue];
        [_lbZLOutRect setBackgroundColor:[UIColor clearColor]];
        [_scrollview addSubview:_lbZLInRect];
//        _lbZLInRect.hidden = YES;
        [_lbZLInRect release];
    }
    else
    {
        _lbZLInRect.frame = rcInValue;
    }
    
    rcInValue.origin.x += rcInValue.size.width + 2;
    if (_lbZLInRect1 == NULL)
    {
        _lbZLInRect1 = [[UILabel alloc] initWithFrame:rcInValue];
        [_lbZLInRect1 setBackgroundColor:[UIColor clearColor]];
        [_scrollview addSubview:_lbZLInRect1];
        [_lbZLInRect1 release];
    }
    else
    {
        _lbZLInRect1.frame = rcInValue;
    }
    
    CGRect rcIn = rcLabel;
    rcIn.origin.x += 30;
    if (_lbZLInValue == nil)
    {
        _lbZLInValue = [[UILabel alloc] initWithFrame:rcIn];
        [_lbZLInValue setFont:font];
        [_scrollview addSubview:_lbZLInValue];
        _lbZLInValue.backgroundColor = [UIColor clearColor];
        [_lbZLInValue release];
    }
    else
    {
        _lbZLInValue.frame = rcIn;
    }
    
    rcLabel.origin.y += nPerHeight;
    if (_lbZLOut == nil)
    {
        _lbZLOut = [[UILabel alloc] initWithFrame:rcLabel];
        [_lbZLOut setText:@"主力流出(万元)"];
        _lbZLOut.backgroundColor = [UIColor clearColor];
        [_lbZLOut setFont:font];
        [_lbZLOut setTextColor:[UIColor tztThemeHQBalanceColor]];
        _lbZLOut.adjustsFontSizeToFitWidth = YES;
        [_scrollview addSubview:_lbZLOut];
        [_lbZLOut release];
    }
    else
    {
        _lbZLOut.frame = rcLabel;
    }
    
    rcLabel.origin.y += nPerHeight;
    CGRect rcOutValue = rcLabel;
    rcOutValue.size = CGSizeMake(10, 10);
    rcOutValue.origin.x += 5;
    rcOutValue.origin.y += (rcLabel.size.height - 10) / 2;
    if (_lbZLOutRect == nil)
    {
        _lbZLOutRect = [[UILabel alloc] initWithFrame:rcOutValue];
        _lbZLOutRect.backgroundColor = [UIColor clearColor];
        [_scrollview addSubview:_lbZLOutRect];
//        _lbZLOutRect.hidden = YES;
        [_lbZLOutRect release];
    }
    else
    {
        _lbZLOutRect.frame = rcOutValue;
    }
    
    rcOutValue.origin.x += rcOutValue.size.width + 2;
    if (_lbZLOutRect1 == NULL)
    {
        _lbZLOutRect1 = [[UILabel alloc] initWithFrame:rcOutValue];
        _lbZLOutRect1.backgroundColor = [UIColor clearColor];
        [_scrollview addSubview:_lbZLOutRect1];
        [_lbZLOutRect1 release];
    }
    else
    {
        _lbZLOutRect1.frame = rcOutValue;
    }
    
    CGRect rcOut = rcLabel;
    rcOut.origin.x += 30;
    if (_lbZLOutValue == nil)
    {
        _lbZLOutValue = [[UILabel alloc] initWithFrame:rcOut];
        _lbZLOutValue.backgroundColor = [UIColor clearColor];
        [_lbZLOutValue setFont:font];
        [_scrollview addSubview:_lbZLOutValue];
        [_lbZLOutValue release];
    }
    else
    {
        _lbZLOutValue.frame = rcOut;
    }
    
    rcLabel.origin.y += nPerHeight;
    if (_lbZLInFlow == nil)
    {
        _lbZLInFlow = [[UILabel alloc] initWithFrame:rcLabel];
        [_lbZLInFlow setText:@"主力净流入(万元)"];
        _lbZLInFlow.backgroundColor = [UIColor clearColor];
        [_lbZLInFlow setFont:font];
        [_lbZLInFlow setTextColor:[UIColor tztThemeHQBalanceColor]];
        _lbZLInFlow.adjustsFontSizeToFitWidth = YES;
        [_scrollview addSubview:_lbZLInFlow];
        [_lbZLInFlow release];
    }
    else
    {
        _lbZLInFlow.frame = rcLabel;
    }
    
    
    rcLabel.origin.y += nPerHeight;
    rcLabel.origin.x += 30;
    if (_lbZLInFlowValue == nil)
    {
        _lbZLInFlowValue = [[UILabel alloc] initWithFrame:rcLabel];
        _lbZLInFlowValue.backgroundColor = [UIColor clearColor];
        [_lbZLInFlowValue setFont:font];
        [_scrollview addSubview:_lbZLInFlowValue];
        [_lbZLInFlowValue release];
    }
    else
    {
        _lbZLInFlowValue.frame = rcLabel;
    }

}

-(void)setBottom:(CGRect)frame
{
    CGRect rcFrame = frame;
    rcFrame.origin.x = 2;
    rcFrame.origin.y  += rcFrame.size.height *2/3 + 2 +50;
    rcFrame.size.width = rcFrame.size.width - 4;
    rcFrame.size.height = rcFrame.size.height /3 - 4+50;
    if (_pTrendFundDataView == NULL)
    {
        _pTrendFundDataView = [[tztTrendFundDataView alloc] init];
        _pTrendFundDataView.frame = rcFrame;
        [_scrollview addSubview:_pTrendFundDataView];
        [_pTrendFundDataView release];
    }
    else
    {
        _pTrendFundDataView.frame = rcFrame;
    }
}

-(TNewPriceData*)GetNewPriceData
{
    return _PriceData;
}

-(void)onClearData
{
}

-(void)onRequestDataAutoPush
{
    [self onRequestData:NO];
}

-(void)onRequestData:(BOOL)bShowProcess
{
    if (_bRequest)
    {
        if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil || self.pStockInfo.stockCode.length == 0)
            return;
        
        NSMutableDictionary *sendvalue = NewObject(NSMutableDictionary);
        _ntztHqReq++;
        if (_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [sendvalue setTztObject:@"2" forKey:@"AccountIndex"];
        
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        
        NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
        [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20130" withDictValue:sendvalue];
        DelObject(sendvalue);
    }
    [super onRequestData:bShowProcess];
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0)
        return 0;
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
//    if (![pParse IsIphoneKey:(long)self reqno:_ntztHqReq])
//        return 0;
    
    [_ayFundValues removeAllObjects];
    [_ayPieValues removeAllObjects];
    [_ayTitle removeAllObjects];
    if ([pParse IsAction:@"20130"])
    {
        NSString* DataStockType = [pParse GetValueData:@"NewMarketNo"];
        if (DataStockType == NULL || DataStockType.length < 1)
            DataStockType = [pParse GetValueData:@"stocktype"];
        if (DataStockType && DataStockType.length > 0)
            self.pStockInfo.stockType = [DataStockType intValue];
        
        NSString* strBaseData = [pParse GetByName:@"WTAccount"];
        if (strBaseData && strBaseData.length > 0)
        {
            setTNewPriceData(_PriceData, strBaseData);
            if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(UpdateData:)])
                [_tztdelegate UpdateData:self];
        }
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 0; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL || [ayData count] < 4)
                continue;
         
            if (i == 0)
            {
                [_ayTitle setArray:ayData];
                continue;
            }
            
            if (i == 2 || i == 3)
                continue;
            
            tztTrendFundFlows *fundValue = NewObject(tztTrendFundFlows);
            NSString* nskind = [ayData objectAtIndex:0];
            if (nskind == NULL)
                nskind = @"";
            fundValue.nsKind = [NSString stringWithFormat:@"%@", nskind];
            
            NSString* nsFundIn = [ayData objectAtIndex:1];
            if (nsFundIn == NULL)
                nsFundIn = @"";
            fundValue.nsFundIn = [NSString stringWithFormat:@"%@", nsFundIn];
            
            NSString* nsFundOut = [ayData objectAtIndex:2];
            if (nsFundOut == NULL)
                nsFundOut = @"";
            fundValue.nsFundOut = [NSString stringWithFormat:@"%@", nsFundOut];
            
            NSString* nsFundJE = [ayData objectAtIndex:3];
            if (nsFundJE == NULL)
                nsFundJE = @"";
            fundValue.nsFundJE = [NSString stringWithFormat:@"%@", nsFundJE];
            
            [_ayFundValues addObject:fundValue];
            if (i >= 1)//0 是标题， 1-是主力，饼图不绘制
                [_ayPieValues addObject:fundValue];
            [fundValue release];
        }
        
        if ([_ayFundValues count] > 0)
        {
            dispatch_async (dispatch_get_main_queue(), ^
                            {
                                [_pPieViewChart reloadData];
//                                [_pPieView reloadData];
//                                [_pPieView setBShowPercentage:YES];
                            });
            
//            [self performSelectorOnMainThread:@selector(OnRefreshPieView) withObject:nil waitUntilDone:NO];
            _pTrendFundDataView.nRowCount = [_ayFundValues count];
            _pTrendFundDataView.nColCount = 4;
            _pTrendFundDataView.ayTitle = _ayTitle;
            _pTrendFundDataView.ayData = _ayFundValues;
            
            
            NSMutableArray *ayColor = NewObject(NSMutableArray)
            NSString *str = [NSString stringWithFormat:@"%d,%d,%d",255,49,57];
            [ayColor addObject:str];
            str = [NSString stringWithFormat:@"%d,%d,%d",63,178,67];
            [ayColor addObject:str];
            str = [NSString stringWithFormat:@"%d,%d,%d",255,140,55];
            [ayColor addObject:str];
            str = [NSString stringWithFormat:@"%d,%d,%d",176,217,81];
            [ayColor addObject:str];
            
            _pTrendFundDataView.ayColor = ayColor;
            DelObject(ayColor)
            [_pTrendFundDataView setNeedsDisplay];
            [self UpDateData];
        }
        
    }
    return 0;
}

-(void)OnRefreshPieView
{
    [_pPieViewChart reloadData];
    [_pPieViewChart setBShowPercentage:YES];
//    [_pPieView reloadData];
//    [_pPieView setBShowPercentage:YES];
}

-(void)UpDateData
{
    return;
//    //
//    if (_ayFundValues == NULL || [_ayFundValues count] < 1)
//        return;
//    tztTrendFundFlows *fundFlows = [_ayFundValues objectAtIndex:0];//第0个，是主力
//    if (fundFlows == NULL)
//        return;
//    
//    [_lbZLInRect setBackgroundColor:[UIColor colorWithTztRGBStr:[_ayRGB objectAtIndex:2]]];
//    [_lbZLInRect1 setBackgroundColor:[UIColor colorWithTztRGBStr:[_ayRGB objectAtIndex:1]]];
//    [_lbZLOutRect setBackgroundColor:[UIColor colorWithTztRGBStr:[_ayRGB objectAtIndex:3]]];
//    [_lbZLOutRect1 setBackgroundColor:[UIColor colorWithTztRGBStr:[_ayRGB objectAtIndex:4]]];
//    
//    _lbZLInValue.text = [NSString stringWithFormat:@"%@", fundFlows.nsFundIn];
//    _lbZLInValue.textColor = [UIColor tztThemeHQUpColor];
//    
//    _lbZLOutValue.text = [NSString stringWithFormat:@"%@", fundFlows.nsFundOut];
//    _lbZLOutValue.textColor = [UIColor tztThemeHQDownColor];
//    
//    _lbZLInFlowValue.text = [NSString stringWithFormat:@"%@", fundFlows.nsFundJE];
//    if ([fundFlows.nsFundJE hasPrefix:@"-"])
//        _lbZLInFlowValue.textColor = [UIColor tztThemeHQDownColor];
//    else
//        _lbZLInFlowValue.textColor = [UIColor tztThemeHQUpColor];
}

#pragma tztPieView data source

-(NSInteger)numberOfSlicesInPieView:(tztPieView *)pieView
{
    return [_ayPieValues count] * 2;
}

-(CGFloat)tztPieView:(tztPieView *)pieView valueForSliceAtIndex:(NSUInteger)nIndex
{
    //0-主力 1-机构 2-大户 3-散户
    if (nIndex < [_ayPieValues count])//属于流入
    {
        tztTrendFundFlows *fundFlows = [_ayPieValues objectAtIndex:nIndex];
        return [fundFlows.nsFundIn floatValue];
    }
    else//属于流出
    {
        tztTrendFundFlows *fundFlows = [_ayPieValues objectAtIndex:[_ayPieValues count] - (nIndex - [_ayPieValues count]) - 1];
        return [fundFlows.nsFundOut floatValue];
    }
}

-(UIColor*)tztPieView:(tztPieView *)pieView colorForSliceAtIndex:(NSUInteger)nIndex
{
    NSString* strRGB = [_ayRGB objectAtIndex:nIndex];
    return [UIColor colorWithTztRGBStr:strRGB];
}

-(void)tztPieView:(tztPieView *)pieView didSelectSliceAtIndex:(NSUInteger)nIndex
{
//    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}

- (NSString *)tztPieChart:(tztPieView *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    NSString* strTitle = @"";
    if (index < [_ayPieValues count])//属于流入
    {
        tztTrendFundFlows *fundFlows = [_ayPieValues objectAtIndex:index];
        strTitle = [NSString stringWithFormat:@"%@流入", fundFlows.nsKind];
    }
    else//属于流出
    {
        tztTrendFundFlows *fundFlows = [_ayPieValues objectAtIndex:[_ayPieValues count] - (index - [_ayPieValues count]) - 1];
        strTitle = [NSString stringWithFormat:@"%@流出", fundFlows.nsKind];
    }
    
    return strTitle;
}
@end
