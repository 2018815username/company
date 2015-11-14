/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztLargeMonitorView.h"

#define TZTKDGREED(x) ((x)  * M_PI * 2)

@interface tztLargeMonitorView ()
{
    NSMutableArray  *_ayGridData; //大单监控数据
    NSMutableArray  *_ayOtherData;//异动雷达数据
    NSMutableArray  *_ayRGB;     //颜色数组
    NSMutableArray  *_ayPieData; //保存绘制饼图数据
    NSMutableArray  *_ayBinData; //异动雷达数据颜色
    CGRect          _rcPie;      //饼图
    CGRect          _rcInfo;     //大单监控信息
    CGRect          _rcOhter;    //异动雷达
    BOOL            _bHave;      //是否有异动雷达
}
@property(nonatomic, retain)NSMutableArray *_ayGridData;
@property(nonatomic, retain)NSMutableArray *_ayOtherData;
@property(nonatomic, retain)NSMutableArray *_ayRGB;
@property(nonatomic, retain)NSMutableArray *_ayPieData;
@property(nonatomic, retain)NSMutableArray *_ayBinData;

-(void)onDrawView:(CGContextRef)context rect:(CGRect)rect;
-(void)drawBackGroundRect:(CGContextRef)context rect:(CGRect)rect;
-(void)DrawPie:(CGContextRef)context Point_:(CGPoint) pPoint radius_:(float)radius ayValue_:(NSMutableArray*)ayValue;
-(void)drawOther:(CGContextRef)context rect:(CGRect)rect;
@end

@implementation tztLargeMonitorView
@synthesize _ayGridData;
@synthesize _ayOtherData;
@synthesize _ayRGB;
@synthesize _ayPieData;
@synthesize _ayBinData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _ayGridData = NewObject(NSMutableArray);
        _ayOtherData = NewObject(NSMutableArray);
        _ayPieData = NewObject(NSMutableArray);
        _ayBinData = NewObject(NSMutableArray);
        _bHave = NO;
        
        //初始化颜色值
        _ayRGB = NewObject(NSMutableArray)
        NSString *str = [NSString stringWithFormat:@"%d,%d,%d",80,15,42];
        [_ayRGB addObject:str];
        str = [NSString stringWithFormat:@"%d,%d,%d",129,28,64];
        [_ayRGB addObject:str];
        str = [NSString stringWithFormat:@"%d,%d,%d",181,48,104];
        [_ayRGB addObject:str];
        str = [NSString stringWithFormat:@"%d,%d,%d",216,67,131];
        [_ayRGB addObject:str];
        str = [NSString stringWithFormat:@"%d,%d,%d",8,53,49];
        [_ayRGB addObject:str];
        str = [NSString stringWithFormat:@"%d,%d,%d",21,106,102];
        [_ayRGB addObject:str];
        str = [NSString stringWithFormat:@"%d,%d,%d",33,168,157];
        [_ayRGB addObject:str];
        str = [NSString stringWithFormat:@"%d,%d,%d",45,206,186];
        [_ayRGB addObject:str];        
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
 
    if (_ayGridData)
    {
        [_ayGridData removeAllObjects];
        _ayGridData = nil;
    }
    
    if (_ayOtherData)
    {
        [_ayOtherData removeAllObjects];
        _ayOtherData = nil;
    }
    
    if (_ayRGB)
    {
        [_ayRGB removeAllObjects];
        _ayRGB = nil;
    }
    
    if (_ayPieData)
    {
        [_ayPieData removeAllObjects];
        _ayPieData = nil;
    }
    
    if (_ayBinData) 
    {
        [_ayBinData removeAllObjects];
        _ayBinData = nil;
    }
    
    [super dealloc];
}

-(void)initdata
{
    [[tztMoblieStockComm getSharehqInstance ] addObj:self];
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1);
    [self onDrawView:context rect:rect];
}

-(void)drawBackGroundRect:(CGContextRef)context rect:(CGRect)rect
{
    CGRect rc = rect;
    CGContextSaveGState(context);
    UIColor* HideGridColor = [UIColor tztThemeHQHideGridColor];
    UIColor* BackgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGContextSetStrokeColorWithColor(context, HideGridColor.CGColor);
    CGContextSetFillColorWithColor(context, BackgroundColor.CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    
    if (IS_TZTIPAD) 
    {
        //饼图
        _rcPie = rc;
        _rcPie.origin = CGPointMake(1, 1);
        _rcPie.size.width = rc.size.width / 3;
        
        //大单数据
        _rcInfo = rc;
        _rcInfo.origin.x  = _rcPie.origin.x + _rcPie.size.width;
        //_rcInfo.origin.y  = _rcPie.origin.y;
        _rcInfo.size.width = rc.size.width *2 / 3;        
    }
    else
    {
        rc.size.height = rc.size.height;// * 4 / 5;
        //大单数据
        _rcInfo = rc;
        _rcInfo.origin = CGPointMake(1, 1);
        _rcInfo.origin.y = rc.size.height / 2;
        _rcInfo.size.height = rc.size.height / 2;//_rcInfo.origin.y +rc.size.height / 2 -1;
        
        //饼图
        _rcPie = rc;
        _rcPie.origin = CGPointMake(1, 1);
        _rcPie.size.width = rc.size.width / 2 ;
        _rcPie.size.height = rc.size.height / 2;
        
        //异动雷达
        _rcOhter = _rcPie;
        _rcOhter.origin.x = _rcPie.origin.x + _rcPie.size.width + 1;
        
        _bHave = YES;
    }
    
    //绘制背景表格
    CGPoint drawPoint = _rcInfo.origin;
    float fHidth = _rcInfo.size.height / 6;
    float fWidth = _rcInfo.size.width / 2;
    for(int i = 0 ; i < 3; i++)
    {
        //绘制竖线
        CGContextMoveToPoint(context, drawPoint.x, CGRectGetMinY(_rcInfo));
        CGContextAddLineToPoint(context, drawPoint.x, CGRectGetMaxY(_rcInfo));
        
        drawPoint.x += fWidth - 1;//CGRectGetWidth(_rcInfo) / 2;
    }
    
    for (int i = 0; i < 7; i++)
    {
        //绘制横线    
        CGContextMoveToPoint(context, CGRectGetMinX(_rcInfo),drawPoint.y);
        CGContextAddLineToPoint(context, CGRectGetMaxX(_rcInfo), drawPoint.y);
        CGContextStrokePath(context);
        drawPoint.y += fHidth;//CGRectGetHeight(_rcInfo) / 7;
    }
}

-(void)drawLargeInfo:(CGContextRef)context rect:(CGRect)rect
{
    //大单资金数据
    if (_ayGridData == NULL || [_ayGridData count] < 1)
        return;
    
    //保存绘制饼图所需数据
    NSMutableArray *ayPieData = NewObject(NSMutableArray);
    
    UIFont *pFont = [tztTechSetting getInstance].drawTxtFont;
    UIColor *yellowColor = [UIColor tztThemeHQFixTextColor];
    UIColor *whiteColor = [UIColor tztThemeHQBalanceColor];
    NSString *text = @"无相关数据";
    NSString* str = [NSString stringWithFormat:@"%@",@"■ "];
    CGSize sz = [str sizeWithFont:pFont];
    
    CGRect rcLeft = _rcInfo;
    if (IS_TZTIPAD)
    {
        rcLeft.origin.y += 8;
    }
    else
    {
        rcLeft.origin.y += 3;
    }
    rcLeft.size.width = _rcInfo.size.width / 2;
    
    CGRect rcRight = rcLeft;
    rcRight.origin.x = rcLeft.origin.x + rcLeft.size.width;

    float fHidth = rcLeft.size.height / 6;
    float fWidth = rcLeft.size.width / 3;
    int nColor = 0;     //颜色索引
    
    for (int i = 0;i < [_ayGridData count]; ++i) 
    {
        UIColor *textColor = nil;
        if (_ayRGB && [_ayRGB count] > nColor) 
        {
            textColor = [UIColor colorWithTztRGBStr:[_ayRGB objectAtIndex:nColor]];
        }else
        {
            textColor = [UIColor tztThemeHQBalanceColor];
        }
        
        CGContextSetStrokeColorWithColor(context, textColor.CGColor);
        CGContextSetFillColorWithColor(context, yellowColor.CGColor);
        
        NSMutableArray *pAyData = [_ayGridData objectAtIndex:i];
//        for (int j = 0; j < [pAyData count]; ++j) 
//        {
//            TZTNSLog(@"%@",[pAyData objectAtIndex:j]);
//        }
        switch (i) {
            case 0:
            {
                CGRect rc = rcLeft;
                rc.size.height = fHidth;
                rcLeft.origin.y += fHidth;
                text = @"主动买入(手)";
                if (pAyData && [pAyData count] > 1) 
                {
                    text = [pAyData objectAtIndex:1];
                }
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping  alignment:NSTextAlignmentCenter];
            }
                break;
            case 1:
            {
                CGContextSetFillColorWithColor(context, whiteColor.CGColor);
                CGRect rc = rcLeft;
                rc.size.height = fHidth;
                rc.size.width = fWidth;
                text = [pAyData objectAtIndex:0];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                CGContextSetFillColorWithColor(context, yellowColor.CGColor);
                rc.origin.x += fWidth;
                text = [pAyData objectAtIndex:1];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                rc.origin.x += fWidth;
                text = [pAyData objectAtIndex:2];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                
                rcLeft.origin.y += fHidth;
            }
                break;
            case 2:
            case 3:
            case 4:
            case 5:
            {
                //方块的区域
                CGContextSetFillColorWithColor(context, textColor.CGColor);
                CGRect rc = rcLeft;
                rc.size.height = fHidth;
                rc.size.width = sz.width;
                [str drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                //名字的区域
                CGContextSetFillColorWithColor(context, whiteColor.CGColor);
                rc.origin.x += sz.width;
                rc.size.width = fWidth - sz.width;            
                text = [pAyData objectAtIndex:0];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                rc.origin.x -= sz.width;
                CGContextSetFillColorWithColor(context, yellowColor.CGColor);
                rc.origin.x += fWidth;
                rc.size.width = fWidth;
                text = [pAyData objectAtIndex:1];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                rc.origin.x += fWidth;
                text = [pAyData objectAtIndex:2];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                
                nColor++;
                rcLeft.origin.y += fHidth;
                [ayPieData addObject:text];
            }
                break;
            case 6:
            {
                CGRect rc = rcRight;
                rc.size.height = fHidth;
                
                text = @"主动卖出(手)";
                if (pAyData && [pAyData count] > 1) 
                {
                    text = [pAyData objectAtIndex:1];
                }
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            
                rcRight.origin.y += fHidth;
            }     
                break;
            case 7:
            {
                CGContextSetFillColorWithColor(context, whiteColor.CGColor);
                CGRect rc = rcRight;
                rc.size.height = fHidth;
//                rc.origin.x += sz.width;
                rc.size.width = fWidth;
                text = [pAyData objectAtIndex:0];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                CGContextSetFillColorWithColor(context, yellowColor.CGColor);
                rc.origin.x += fWidth;
                text = [pAyData objectAtIndex:1];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                rc.origin.x += fWidth;
                text = [pAyData objectAtIndex:2];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                
                rcRight.origin.y += fHidth;
            }
                break;
            case 8:
            case 9:
            case 10:
            case 11:
            {
                //方块的区域
                CGContextSetFillColorWithColor(context, textColor.CGColor);
                CGRect rc = rcRight;
                rc.size.height = fHidth;
                rc.size.width = sz.width;
                [str drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                CGContextSetFillColorWithColor(context, whiteColor.CGColor);
                rc.origin.x += sz.width;
                rc.size.width = fWidth - sz.width; 
                text = [pAyData objectAtIndex:0];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                //
                rc.origin.x -= sz.width;
                CGContextSetFillColorWithColor(context, yellowColor.CGColor);
                rc.origin.x += fWidth;
                rc.size.width = fWidth;
                text = [pAyData objectAtIndex:1];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
                
                rc.origin.x += fWidth;
                text = [pAyData objectAtIndex:2];
                [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
                
                nColor++;
                rcRight.origin.y += fHidth;
                [ayPieData addObject:text];
            }
                break;
            default:
                break;
        }
    }
    
    //保存绘制饼图的数据
    if (_ayPieData) 
    {
        [_ayPieData removeAllObjects];
        [_ayPieData setArray:ayPieData];
    }
    [ayPieData release];
}

//饼图绘制函数
//pPoint -中心点
//radius
//ayvalue －值
-(void)DrawPie:(CGContextRef)context Point_:(CGPoint) pPoint radius_:(float)radius ayValue_:(NSMutableArray*)ayValue
{
	if (ayValue == NULL || [ayValue count] < 1)
		return;
	
    CGContextSaveGState(context);
	
	//抗锯齿效果
	CGContextSetAllowsAntialiasing(context, TRUE);
	float fSum = 0.0;
	float fCurrent = 0.0;
	BOOL  bDraw = YES;//是否绘制厚度
	
	for (int j = 0; j < [ayValue count]; j++)
	{
		NSArray* pAy = [ayValue objectAtIndex:j];
		if (pAy == NULL || [pAy count] <= 1)
			continue;
		fSum += [[pAy objectAtIndex:0] floatValue];
	}
	
	if (fSum <= 0.000001)
	{
		TZTNSLog(@"%@",@"没有相关数据");
		return;
	}
	CGContextMoveToPoint(context, pPoint.x, pPoint.y);
	CGContextSaveGState(context);
	CGContextScaleCTM(context, 1.0, 1.0);
	
	
	for (int i = 0; i < [ayValue count]; i++)
	{
		NSArray* pAy = [ayValue objectAtIndex:i];
		if (pAy == NULL || [pAy count] <= 1)
			continue;
		
		//第一个存储数据
		float startAngle = TZTKDGREED(fCurrent);
		fCurrent += [[pAy objectAtIndex:0] floatValue] / fSum;
		
		float endAngle = TZTKDGREED(fCurrent);
		//绘制上面的扇形
		CGContextMoveToPoint(context, pPoint.x, pPoint.y);
		
		//第二个存储颜色
        NSString *strColor = [pAy objectAtIndex:1];
        UIColor *cl = [UIColor colorWithTztRGBStr:strColor];
        
		if (cl) 
			[cl setFill];
		[[UIColor colorWithWhite:1.0 alpha:0.8] setStroke];
		CGContextAddArc(context, pPoint.x, pPoint.y, radius, startAngle, endAngle, 0);//0表示顺时针
		
		CGContextClosePath(context);
		CGContextDrawPath(context, kCGPathFill);
		
        if (0) {
            
            //绘制侧面
            float fStartX = cos(startAngle) * radius + pPoint.x;
            float fStartY = sin(startAngle) * radius + pPoint.y;
            float fEndX = cos(endAngle) * radius + pPoint.x;
            float fEndY = sin(endAngle) * radius + pPoint.y;
            
            float fEndYTemp = fEndY + 15;
            
            if (endAngle < M_PI)
            {
            }
            //只有弧度< 3.14的才会画前面的厚度
            else if(startAngle < M_PI)
            {
                endAngle = M_PI;
                fEndX = 10;
                fEndYTemp = pPoint.y + 15;
                
            }
            else
            {
                bDraw = NO;
            }
            
            if (bDraw && 0)
            {
                //绘制厚度
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, nil, fStartX, fStartY);
                CGPathAddArc(path, nil, pPoint.x, pPoint.y, radius, startAngle, endAngle, 0);
                CGPathAddArc(path, nil, pPoint.x, pPoint.y + 15, radius, startAngle, endAngle, 1);
                CGContextAddPath(context, path);
                NSString *strColor = [pAy objectAtIndex:1];
                UIColor *cl = [UIColor colorWithTztRGBStr:strColor];
                
                if (cl) 
                    [cl setFill];
                //[[[pAy objectAtIndex:1] intValue] setFill];
                [[UIColor colorWithWhite:0.9 alpha:1.0] setStroke];
                CGContextDrawPath(context, kCGPathFill);
                [[UIColor colorWithWhite:0.1 alpha:0.4] setFill];
                CGContextAddPath(context, path);
                CGContextDrawPath(context, kCGPathFill);
            }
        }
	}
	
	CGContextRestoreGState(context);
}

-(void)drawOther:(CGContextRef)context rect:(CGRect)rect
{
    if (_ayOtherData == NULL || [_ayOtherData count] < 1)
        return;
    
    //颜色的值不对应
    if ([_ayOtherData count] > [_ayBinData count])
        return;
    
    UIFont *pFont = [tztTechSetting getInstance].drawTxtFont;
    NSString *text = @"无相关数据";
    
    CGRect rc1 = _rcOhter;
    rc1.origin.x += 1;
    
    float fHidth = rc1.size.height / 8;//显示八条数据
    float fWidth = rc1.size.width / 3;
    UIColor *textColor = [UIColor tztThemeHQBalanceColor];

    for (int i = 0;i < [_ayOtherData count]; ++i) 
    {
        UIColor *binColor = [_ayBinData objectAtIndex:i];
        CGContextSetStrokeColorWithColor(context, textColor.CGColor);
        CGContextSetFillColorWithColor(context, textColor.CGColor);
        
        NSMutableArray *pAyData = [_ayOtherData objectAtIndex:i];
        if (pAyData && [pAyData count] > 1) 
        {
            CGRect rc = rc1;
            rc.size.height = fHidth;
            rc.size.width = fWidth;
            rc1.origin.y += fHidth;
            text = [pAyData objectAtIndex:0];
            [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentLeft];
            
            CGContextSetFillColorWithColor(context, binColor.CGColor);
            rc.origin.x += fWidth;
            text = [pAyData objectAtIndex:1];
            [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            
            rc.origin.x += fWidth;
            text = [pAyData objectAtIndex:2];
            [text drawInRect:rc withFont:pFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        }
        
    }
}

-(void)onDrawView:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    //绘制背景和计算区域
    [self drawBackGroundRect:context rect:rect];
    
    //绘制大单数据
    [self drawLargeInfo:context rect:_rcInfo];
    
    //半径计算
    CGPoint pointPie = CGPointZero;
    float fRadius = (_rcPie.size.width - _rcPie.origin.x ) / 2 - 2;
    float fRadius1 = (_rcPie.size.height - _rcPie.origin.y) / 2 -2;
    if (fRadius > fRadius1) 
        fRadius = fRadius1;
    
    pointPie.x = _rcPie.origin.x + fRadius + 2;
    pointPie.y = _rcPie.origin.y + fRadius + 2;
    
    NSMutableArray *ayValue = NewObject(NSMutableArray);
    if ([_ayPieData count]  < 1)
    {
        DelObject(ayValue);
        return;
    }
    for (int i = 0; i < 8; ++i) //此处，由于买卖各4个数据，所以直接固定为8，最好使用变量自动根据多少加载数据到数组
    {
        NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
        
        NSString *str = [_ayPieData objectAtIndex:i];
        float fValue = atof([str UTF8String]) * 100;
        if (fValue > 0.0)
        {
            [pAy addObject:[NSNumber numberWithFloat:fValue]];
            [pAy addObject:[_ayRGB objectAtIndex:i]];
            [ayValue addObject:pAy];
        }
        else
        {
            [pAy addObject:[NSNumber numberWithInt:1.0]];
            [pAy addObject:[_ayRGB objectAtIndex:i]];
            [ayValue addObject:pAy];
        }
    }
    
    [self DrawPie:context Point_:pointPie radius_:fRadius ayValue_:ayValue];
    DelObject(ayValue);
    
    if (_bHave) 
    {
        [self drawOther:context rect:_rcOhter];
//        UILabel *label = [[UILabel alloc] init];
//        [self addSubview:label];
//        [label setFrame:_rcOhter];
//        [label setBackgroundColor:[UIColor yellowColor]];
    }
    
    return;
}

-(void)onClearData
{
    [super onClearData];
    if (_ayGridData)
    {
        [_ayGridData removeAllObjects];
    }
    if (_ayOtherData)
    {
        [_ayOtherData removeAllObjects];
    }
    if (_ayBinData)
    {
        [_ayBinData removeAllObjects];
    }
    if (_ayPieData)
    {
        [_ayPieData removeAllObjects];
    }
}

#pragma 请求数据
-(void)onRequestData:(BOOL)bShowProcess
{
    if (_bRequest)
    {
        if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil ||[self.pStockInfo.stockCode length] <= 0)
        {
            TZTNSLog(@"%@", @"大单监控请求---股票代码有误!!!");
            return;
        }
        //;大单监控
        //[20119]
        //req=Reqno|MobileCode|MobileType|Cfrom|Tfrom|Token|ZLib|StockCode|MaxCount|DeviceType|AccountIndex|
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        [sendvalue setTztObject:@"0" forKey:@"DeviceType"];
        [sendvalue setTztObject:@"8" forKey:@"MaxCount"];       //请求8条数据
        NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
        [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20119" withDictValue:sendvalue];
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
    if([parse GetAction] == 20119)
    {
        if(![parse IsIphoneKey:(long)self reqno:_ntztHqReq])
        {
            return 0;
        }
        //清空数据
        [self onClearData];
//Reqno|ErrorNo|ErrorMessage|Token|OnLineMessage|HsString|ErrorNo|Grid|MaxCount|Level2Bin|BinData|AccountIndex|WTAccount|        
        //大单监控数据
        NSArray* ayGrid = [parse GetArrayByName:@"Grid"];
        if (ayGrid && [ayGrid count] > 0) 
        {
            [_ayGridData setArray:ayGrid];
        }
        
        //异动雷达数据
        NSArray* ayLevel = [parse GetArrayByName:@"Level2Bin"];
        if (ayLevel && [ayLevel count] > 0) 
        {
            [_ayOtherData setArray:ayLevel];
        }
        
        //时间颜色
        UIColor *color = nil;
        NSString* strBase = [parse GetByName:@"BinData"];
        NSData* DataBinData = [NSData tztdataFromBase64String:strBase];
        if (DataBinData && [DataBinData length] > 0)
        {
            char *pColor = (char*)[DataBinData bytes];
            if(pColor)
            {
                pColor = pColor + 2;//时间两个字节
                for (int i = 0; i < [_ayOtherData count]; ++i)
                {
                    color = [UIColor colorWithChar:*pColor];
                    [_ayBinData addObject:color];
                    pColor++;
                }
            }
        }
        [self setNeedsDisplay];
    }
    return 0;
}

@end
