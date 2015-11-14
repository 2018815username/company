

#import "tztTrendFundBarView.h"


@interface tztTrendBarView : UIView

@property(nonatomic,assign)NSInteger    nDirection;
@end

@implementation tztTrendBarView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    NSArray *ayColor = nil;
    if (_nDirection > 0)
    {
        ayColor = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:229.f/255.f green:36.f/255.f blue:8.f/255.f alpha:1.0f].CGColor,
                   [UIColor colorWithRed:255.f/255.f green:175.f/255.f blue:125.f/255.f alpha:1.0].CGColor,
                   nil];
    }
    else
    {
        ayColor = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:0.f/255.f green:173.f/255.f blue:201.f/255.f alpha:1.0].CGColor,
                   [UIColor colorWithRed:0.f/255.f green:97.f/255.f blue:167.f/255.f alpha:1.0].CGColor,
                   nil];
    }
    
    CAGradientLayer *gLayer = (CAGradientLayer *)self.layer;
    gLayer.colors = ayColor;
//    gLayer.startPoint = CGPointMake(0, 0);
//    gLayer.endPoint = CGPointMake(1, 1);
//    CGColorRef color = [UIColor blackColor].CGColor;
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:
//                              @"startPoint"];
//    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
//    anim.duration = .6;
//    anim.timingFunction = [CAMediaTimingFunction
//                           functionWithName:kCAMediaTimingFunctionEaseIn];
//    [gLayer addAnimation:anim forKey:@"start"];
//    
//    
//    anim = [CABasicAnimation animationWithKeyPath:@"colors"];
//    anim.fromValue = [NSArray arrayWithObjects:(id)color, color, color, nil];
//    anim.duration = .6;
//    anim.timingFunction = [CAMediaTimingFunction
//                           functionWithName:kCAMediaTimingFunctionEaseIn];
//    [gLayer addAnimation:anim forKey:@"colors"];
    
}

@end

@interface tztTrendBarLayer : CAGradientLayer

@property(nonatomic,assign)NSInteger    nDirection;
-(void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate;
@end

@implementation tztTrendBarLayer
-(void)drawInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1);
    
    CGRect rectIn = self.frame;
    CGContextMoveToPoint(context, rectIn.origin.x, rectIn.origin.y);
    CGContextAddLineToPoint(context, rectIn.origin.x + rectIn.size.width, rectIn.origin.y);
    CGContextAddLineToPoint(context, rectIn.origin.x + rectIn.size.width, rectIn.origin.y + rectIn.size.height);
    CGContextAddLineToPoint(context, rectIn.origin.x, rectIn.origin.y + rectIn.size.height);
    CGContextAddLineToPoint(context, rectIn.origin.x, rectIn.origin.y);
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
    
    // 填充颜色梯度
    static CGFloat const gradientColors[] = {
        229.f/255.f, 36.f/255.f, 8.f/255.f, 1.0f, // red
        255.f/255.f, 175.f/255.f, 125.f/255.f, 1.0, // orange
    };
    static CGFloat const gradientColorsEx[] = {
        0.f/255.f, 173.f/255.f, 201.f/255.f, 1.0f, // red
        0.f/255.f, 97.f/255.f, 167.f/255.f, 1.0, // orange
    };
    
    // 创建填充实例
    CGGradientRef gradient = nil;
    gradient = CGGradientCreateWithColorComponents(
                                                   rgb,
                                                   (_nDirection > 0) ?  gradientColors : gradientColorsEx,
                                                   NULL,   // 使用默认的[0-1]
                                                   sizeof(gradientColors)/(sizeof(gradientColors[0])*4)
                                                   );
    CGColorSpaceRelease(rgb);
    rgb = NULL;
    
    // 线性填充
    CGContextDrawLinearGradient(context, gradient, rectIn.origin, CGPointMake(rectIn.origin.x, rectIn.origin.y + rectIn.size.height), options);
    // 释放
    CGGradientRelease(gradient);
    gradient = NULL;
    CGContextRestoreGState(context);
}

-(void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
    CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
    NSNumber *currentAngle = [[self presentationLayer] valueForKey:key];
    if (!currentAngle)
        currentAngle = from;
    
    [arcAnimation setFromValue:currentAngle];
    [arcAnimation setToValue:to];
    [arcAnimation setDelegate:delegate];
    [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:arcAnimation forKey:key];
    [self setValue:to forKey:key];
}
@end

@interface tztTrendFundBarView ()
{
    NSMutableArray  *_ayTitle;
    NSMutableArray  *_ayFundValues;
    NSMutableArray  *_ayRGB;
    
    NSString        *_PreStockCode;
    int             _nMaxCount;
    
    TNewPriceData   *_PriceData;
}

@property(nonatomic,retain) tztTrendBarLayer *zlInLayer;
@property(nonatomic,retain) tztTrendBarLayer *zlOutLayer;
@property(nonatomic,retain) tztTrendBarLayer *zlJELayer;

@property(nonatomic,retain) tztTrendBarView *zlInView;
@property(nonatomic,retain) tztTrendBarView *zlOutView;
@property(nonatomic,retain) tztTrendBarView *zlJEView;

@end

@implementation tztTrendFundBarView

-(id)initWithFrame:(CGRect)frame
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
    DelObject(_ayTitle);
    DelObject(_ayRGB);
    [super dealloc];
}

-(void)initdata
{
    _nMaxCount = 0;
    _ayFundValues = NewObject(NSMutableArray);
    _ayTitle = NewObject(NSMutableArray);
    _PreStockCode = @"";
    
    _PriceData = malloc(sizeof(TNewPriceData));
    memset(_PriceData, 0x00, sizeof(TNewPriceData));
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    
    _ayRGB = NewObject(NSMutableArray);
    
}

//绘制数据
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //绘制背景色
    CGContextSetStrokeColorWithColor(context, [UIColor tztThemeBackgroundColorHQ].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor tztThemeBackgroundColorHQ].CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    
    CGFloat fHeight = rect.size.height / 2 - 10;
    CGFloat fXMargin = rect.size.width * 0.1;
    //绘制中间的横线
    //设置线条颜色
    CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQGridColor].CGColor);
    CGContextMoveToPoint(context, fXMargin, fHeight);
    CGContextAddLineToPoint(context, rect.size.width - fXMargin, fHeight);
    CGContextStrokePath(context);
    
    if (_ayFundValues.count < 1)
        return;
    //绘制柱状图
    /*
     绘制原则：主力流入＝主力流出＋主力净流入
     */
    
//    CGFloat fHeight = rect.size.height / 2;
//    CGFloat fXMargin = rect.size.width * 0.1;
    CGFloat fWidth = (rect.size.width - 2 * fXMargin) / 3;
    CGFloat fBarWidth = 40;
    if (fBarWidth >= fWidth)
        fBarWidth = fWidth - 2;
    CGFloat fSep = (fWidth - fBarWidth) / 2;
    
    tztTrendFundFlows *zlFundFlows = [_ayFundValues objectAtIndex:0];
    for (NSInteger i = 0; i < _ayFundValues.count; i++)
    {
        zlFundFlows = [_ayFundValues objectAtIndex:i];
        if (zlFundFlows.nKind == 4)//＝＝4，主力
        {
            break;
        }
    }
    
    CGFloat fTotalHeight = (rect.size.height / 2 - 40);
    
    //流出大于流入
    BOOL bFlag = FALSE;
    CGFloat fTotalValue = [zlFundFlows.nsFundIn floatValue];
    if ([zlFundFlows.nsFundIn floatValue] < [zlFundFlows.nsFundOut floatValue])
    {
        bFlag = TRUE;
        fTotalValue = [zlFundFlows.nsFundOut floatValue];
    }
    
    //主力流入
    CGRect rectIn = CGRectMake(fXMargin+fSep, fHeight- ( fTotalValue != 0 ? ([zlFundFlows.nsFundIn floatValue] / fTotalValue * fTotalHeight) : 0 ), fBarWidth, (fTotalValue != 0 ? ([zlFundFlows.nsFundIn floatValue] / fTotalValue * fTotalHeight) : 0));
    
    if (_zlInView == nil)
    {
        _zlInView = [[tztTrendBarView alloc] init];
        _zlInView.frame = CGRectMake(rectIn.origin.x, rectIn.origin.y + (fTotalValue != 0 ? ([zlFundFlows.nsFundIn floatValue] / fTotalValue * fTotalHeight) : 0), rectIn.size.width, 0);
        _zlInView.nDirection = 1;
        [self addSubview:_zlInView];
        [_zlInView release];
    }
    
    [UIView animateWithDuration:0.5f
                         animations:^{
                             _zlInView.frame = rectIn;
                         }
                     completion:^(BOOL bFinished){//绘制具体数值
                     }];
    
    UIColor *pColor = [UIColor tztThemeHQBalanceColor];
    CGContextSetFillColorWithColor(context, pColor.CGColor);
    CGRect rc = rect;
    rc.origin.x = rectIn.origin.x;
    rc.origin.y = rect.origin.y + rect.size.height - 30;
    rc.size.height = 30;
    [@"主力流入" drawInRect:rc withFont:tztUIBaseViewTextFont(12.f) lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGRect rcInValue = rc;
    rcInValue.origin.y = rectIn.origin.y + rectIn.size.height + 10;
    CGContextSetFillColorWithColor(context, [UIColor tztThemeHQUpColor].CGColor);
    NSString *nsIn = [NSString stringWithFormat:@"%@万",zlFundFlows.nsFundIn];
    [nsIn drawInRect:rcInValue withFont:tztUIBaseViewTextFont(12.f) lineBreakMode:NSLineBreakByTruncatingTail];
    
    //主力流出
    
    CGRect rectOut = CGRectMake(fXMargin+ fWidth +fSep, fHeight, fBarWidth, (fTotalValue != 0 ? (([zlFundFlows.nsFundOut floatValue] / fTotalValue) * fTotalHeight) : 0));
    if (_zlOutView == nil)
    {
        _zlOutView = [[tztTrendBarView alloc] init];
        _zlOutView.frame = CGRectMake(rectOut.origin.x, fHeight, rectOut.size.width, 0);
        _zlOutView.nDirection = 0;
        [self addSubview:_zlOutView];
        [_zlOutView release];
    }
    
    [UIView animateWithDuration:.5f
                     animations:^{
                        _zlOutView.frame = rectOut;
                     }];
    
    CGContextSetFillColorWithColor(context, pColor.CGColor);
    rc = rect;
    rc.origin.x = rectOut.origin.x;
    rc.origin.y = rect.origin.y + rect.size.height - 30;
    rc.size.height = 30;
    [@"主力流出" drawInRect:rc withFont:tztUIBaseViewTextFont(12.f) lineBreakMode:NSLineBreakByTruncatingTail];
    
    rcInValue = rc;
    rcInValue.origin.y = rectOut.origin.y - 20;
    CGContextSetFillColorWithColor(context, [UIColor tztThemeHQDownColor].CGColor);
    NSString *nsOut = [NSString stringWithFormat:@"%@万",zlFundFlows.nsFundOut];
    [nsOut drawInRect:rcInValue withFont:tztUIBaseViewTextFont(12.f) lineBreakMode:NSLineBreakByTruncatingTail];
    
    //主力净流入
    CGRect rectJIn = CGRectMake(fXMargin+fWidth * 2 + fSep, fHeight - (fTotalValue != 0 ? ([zlFundFlows.nsFundJE floatValue] / fTotalValue * fTotalHeight) : 0), fBarWidth, (fTotalValue != 0 ? ([zlFundFlows.nsFundJE floatValue] / fTotalValue * fTotalHeight) : 0));
    
    int nDirection = (([zlFundFlows.nsFundJE floatValue] >= 0) ? 1 : 0);
    if (_zlJEView == nil)
    {
        _zlJEView = [[tztTrendBarView alloc] init];
        _zlJEView.frame = CGRectMake(rectJIn.origin.x, fHeight, rectJIn.size.width, 0);
        _zlJEView.nDirection = nDirection;
        [self addSubview:_zlJEView];
        [_zlJEView release];
    }
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _zlJEView.nDirection = (([zlFundFlows.nsFundJE floatValue] >= 0) ? 1 : 0);
                         _zlJEView.frame = rectJIn;
                }];
    
    CGContextSetFillColorWithColor(context, pColor.CGColor);
    rc = rect;
    rc.origin.x = rectJIn.origin.x;
    rc.origin.y = rect.origin.y + rect.size.height - 30;
    rc.size.height = 30;
    if (bFlag)
        [@"主力净流出" drawInRect:rc withFont:tztUIBaseViewTextFont(12.f) lineBreakMode:NSLineBreakByTruncatingTail];
    else
        [@"主力净流入" drawInRect:rc withFont:tztUIBaseViewTextFont(12.f) lineBreakMode:NSLineBreakByTruncatingTail];
    
    rcInValue = rc;
    if (nDirection > 0)
        rcInValue.origin.y = rectJIn.origin.y + rectJIn.size.height + 10;
    else
        rcInValue.origin.y = fHeight - 20;
    CGContextSetFillColorWithColor(context, (nDirection > 0 ? [UIColor tztThemeHQUpColor].CGColor : [UIColor tztThemeHQDownColor].CGColor));
    NSString *nsJE = [NSString stringWithFormat:@"%@万",zlFundFlows.nsFundJE];
    if ([zlFundFlows.nsFundJE hasPrefix:@"-"] && zlFundFlows.nsFundJE.length > 1)
    {
        nsJE = [NSString stringWithFormat:@"%@万", [zlFundFlows.nsFundJE substringFromIndex:1]];
    }
    [nsJE drawInRect:rcInValue withFont:tztUIBaseViewTextFont(12.f) lineBreakMode:NSLineBreakByTruncatingTail];
    
    
    CGContextRestoreGState(context);
}

-(TNewPriceData*)GetNewPriceData
{
    return _PriceData;
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
    if (![pParse IsIphoneKey:(long)self reqno:_ntztHqReq])
        return 0;
    
    [_ayFundValues removeAllObjects];
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
            [fundValue release];
        }
        [self setNeedsDisplay];
    }
    return 0;
}

-(void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"Start %@", anim);
    
    // 填充颜色梯度
    static CGFloat const gradientColors[] = {
        229.f/255.f, 36.f/255.f, 8.f/255.f, 1.0f, // red
        255.f/255.f, 175.f/255.f, 125.f/255.f, 1.0, // orange
    };
    static CGFloat const gradientColorsEx[] = {
        0.f/255.f, 173.f/255.f, 201.f/255.f, 1.0f, // red
        0.f/255.f, 97.f/255.f, 167.f/255.f, 1.0, // orange
    };
    _zlInLayer.colors = @[[UIColor colorWithRed:229.f/255.f green:36.f/255.f blue:8.f/255.f alpha:1.0], [UIColor colorWithRed:255.f/255.f green:175.f/255.f blue:125.f/255.f alpha:1.f]];
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"Stop %@", anim);
}
@end
