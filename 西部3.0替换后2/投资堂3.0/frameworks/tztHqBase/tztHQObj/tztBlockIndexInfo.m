//
//  tztBlockIndexInfo.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-2-27.
//
//

#import "tztBlockIndexInfo.h"

@interface tztBlockIndexInfo()
{
    NSMutableArray *_pArrayValue;
    
    NSString* _nsNewPrice;
    NSString* _nsStockCode;
    NSString* _nsRatio;
    NSString* _nsRange;
    NSString* _nsChangeValue;
    NSString* _nsClosePrice;
    NSString* _nsOpenPrice;
    NSString* _nsMaxPrice;
    NSString* _nsMinPrice;
    NSString* _nsStockName;
    UIColor  *_clNewPriceColor;
    UIColor  *_clOpenColor;
    UIColor  *_clMaxColor;
    UIColor  *_clMinColor;
    UInt32   _nStockType;
}
@property(nonatomic,retain)NSMutableArray *pArrayValue;
@property(nonatomic,retain)NSString *nsNewPrice;
@property(nonatomic,retain)NSString *nsStockCode;
@property(nonatomic,retain)NSString *nsStockName;
@property(nonatomic,retain)NSString *nsRatio;
@property(nonatomic,retain)NSString *nsChangeValue;
@property(nonatomic,retain)NSString *nsRange;
@property(nonatomic,retain)NSString *nsClosePrice;
@property(nonatomic,retain)NSString *nsOpenPrice;
@property(nonatomic,retain)NSString *nsMaxPrice;
@property(nonatomic,retain)NSString *nsMinPrice;
@property(nonatomic,retain)UIColor  *clOpenColor;
@property(nonatomic,retain)UIColor  *clMaxColor;
@property(nonatomic,retain)UIColor  *clMinColor;
@property(nonatomic,retain)UIColor  *clNewPriceColor;

//板块显示涨跌平盘数
@property(nonatomic,retain)NSString *nsUpStocks;
@property(nonatomic,retain)NSString *nsDownStocks;
@property(nonatomic,retain)NSString *nsDrawStocks;

//资金流向下显示不同数据
@property(nonatomic,retain)NSString *nsFundflowTitle;
@property(nonatomic,retain)NSString *nsFundflowValue;
@property(nonatomic,retain)UIColor  *clFundValue;

@end

@implementation tztBlockIndexInfo
@synthesize pArrayValue = _pArrayValue;
@synthesize nsNewPrice = _nsNewPrice;
@synthesize nsStockCode = _nsStockCode;
@synthesize nsStockName = _nsStockName;
@synthesize nsRatio = _nsRatio;
@synthesize nsChangeValue = _nsChangeValue;
@synthesize nsRange = _nsRange;
@synthesize nsClosePrice = _nsClosePrice;
@synthesize nsOpenPrice = _nsOpenPrice;
@synthesize nsMaxPrice = _nsMaxPrice;
@synthesize nsMinPrice = _nsMinPrice;
@synthesize clOpenColor = _clOpenColor;
@synthesize clMaxColor = _clMaxColor;
@synthesize clMinColor = _clMinColor;
@synthesize clNewPriceColor = _clNewPriceColor;

@synthesize tztBlockType = _tztBlockType;
@synthesize nsFundflowTitle = _nsFundflowTitle;
@synthesize nsFundflowValue = _nsFundflowValue;
@synthesize clFundValue = _clFundValue;


@synthesize nsUpStocks = _nsUpStocks;
@synthesize nsDownStocks = _nsDownStocks;
@synthesize nsDrawStocks = _nsDrawStocks;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)intdata
{
    self.nsNewPrice = @"-.-";
    self.nsRatio = @"-.-";
    self.nsRange = @"-.-";
    self.nsOpenPrice = @"";
    self.nsClosePrice = @"";
    self.nsStockName = @"";
    self.nsChangeValue = @"-.-%";
    self.nsMaxPrice = @"-.-";
    self.nsMinPrice = @"-.-";
    
    self.nsUpStocks = @"-.-";
    self.nsDownStocks = @"-.-";
    self.nsDrawStocks = @"-.-";
    
    self.clNewPriceColor = [UIColor tztThemeHQBalanceColor];
    self.clOpenColor = [UIColor tztThemeHQBalanceColor];
    self.clMaxColor = [UIColor tztThemeHQBalanceColor];
    self.clMinColor = [UIColor tztThemeHQBalanceColor];
    self.clFundValue = [UIColor tztThemeHQBalanceColor];
}

-(void)drawDataEx:(CGContextRef)context rect_:(CGRect)rect
{
    CGRect rcFrame = rect;
    rcFrame.origin.y += 10;
    rcFrame.size.height -= 20;
    rcFrame.origin.x += 10;
    rcFrame.size.width -= 20;
    
    CGFloat fHeight = CGRectGetHeight(rcFrame) / 4;
    UIColor *drawColor = [UIColor tztThemeHQBalanceColor];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    
    UIFont *nameFont = tztUIBaseViewTextBoldFont(16.f);
    //名称
    CGRect rcName = CGRectMake(rcFrame.origin.x,
                               rcFrame.origin.y,
                               rcFrame.size.width * 0.4,
                               fHeight * 2);
    [self.nsStockName drawInRect:rcName
                        withFont:nameFont
                   lineBreakMode:NSLineBreakByWordWrapping
                       alignment:NSTextAlignmentCenter];
    UIFont *dataFont = tztUIBaseViewTextFont(16.f);
    CGRect rcNewPrice = rcName;
    rcNewPrice.origin.x += rcName.size.width;
    rcNewPrice.size.width = rcFrame.size.width * 0.3;
    rcNewPrice.size.height = fHeight * 2;
    CGContextSetFillColorWithColor(context, self.clNewPriceColor.CGColor);
    [self.nsNewPrice drawInRect:rcNewPrice
                       withFont:dataFont
                  lineBreakMode:NSLineBreakByWordWrapping
                      alignment:NSTextAlignmentCenter];
    
    CGRect rcRang = rcNewPrice;
    rcRang.origin.x += rcNewPrice.size.width;
    rcRang.size.height = fHeight;
    [self.nsRange drawInRect:rcRang
                    withFont:dataFont
               lineBreakMode:NSLineBreakByWordWrapping
                   alignment:NSTextAlignmentCenter];
    
    UIFont *font = tztUIBaseViewTextFont(12.f);
    //上涨家数
    UIColor *pUp = [UIColor tztThemeHQUpColor];
    UIColor *pDown = [UIColor tztThemeHQDownColor];
    
    int nDataWidth = 40;
    float fWidth = (rcFrame.size.width - 3 * nDataWidth) / 3;
    
    CGRect rcUpTitle = rcFrame;
    rcUpTitle.size.height = fHeight;
    rcUpTitle.origin.y += 2*fHeight;
    rcUpTitle.size.width = fWidth;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [@"上涨家数" drawInRect:rcUpTitle
               withFont:font
          lineBreakMode:NSLineBreakByWordWrapping
              alignment:NSTextAlignmentRight];
    
    CGRect rcUp = rcUpTitle;
    rcUp.origin.x += rcUpTitle.size.width;
    rcUp.size.width = nDataWidth;
    CGContextSetFillColorWithColor(context, pUp.CGColor);
    [self.nsUpStocks drawInRect:rcUp
                       withFont:font
                  lineBreakMode:NSLineBreakByWordWrapping
                      alignment:NSTextAlignmentCenter];
    
    //下跌家数
    CGRect rcDownTitle = rcUp;
    rcDownTitle.origin.x += rcUp.size.width;
    rcDownTitle.size.width = fWidth;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [@"下跌家数" drawInRect:rcDownTitle
               withFont:font
          lineBreakMode:NSLineBreakByWordWrapping
              alignment:NSTextAlignmentRight];
    CGRect rcDown = rcDownTitle;
    rcDown.origin.x += rcDownTitle.size.width;
    rcDown.size.width = nDataWidth;
    CGContextSetFillColorWithColor(context, pDown.CGColor);
    [self.nsDownStocks drawInRect:rcDown
                         withFont:font
                    lineBreakMode:NSLineBreakByWordWrapping
                        alignment:NSTextAlignmentCenter];
    
    //平盘家数
    CGRect rcDrawTitle = rcDown;
    rcDrawTitle.origin.x += rcDown.size.width;
    rcDrawTitle.size.width = fWidth;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [@"平盘家数" drawInRect:rcDrawTitle
               withFont:font
          lineBreakMode:NSLineBreakByWordWrapping
              alignment:NSTextAlignmentRight];
    
    CGRect rcDraw = rcDrawTitle;
    rcDraw.origin.x += rcDrawTitle.size.width;
    rcDraw.size.width = nDataWidth;
    //    CGContextSetFillColorWithColor(context, pDown.CGColor);
    [self.nsDrawStocks drawInRect:rcDraw
                         withFont:font
                    lineBreakMode:NSLineBreakByWordWrapping
                        alignment:NSTextAlignmentCenter];
}

-(void)drawDataNormal:(CGContextRef)context rect_:(CGRect)rect
{
    
    CGRect  rcFrame = rect;
    rcFrame.origin.y += 10;
    rcFrame.size.height -= 20;
    rcFrame.origin.x += 10;
    rcFrame.size.width -= 20;
    
    CGFloat fHeight = CGRectGetHeight(rcFrame) / 3;
    UIColor *drawColor = [UIColor tztThemeHQBalanceColor];// [UIColor whiteColor];
    UIColor *rectColor = [UIColor tztThemeHQGridColor];// [UIColor colorWithTztRGBStr:@"48,48,48"];
    CGContextSetFillColorWithColor(context, self.clNewPriceColor.CGColor);
    
    UIFont *newFont = tztUIBaseViewTextBoldFont(30.0f);
    UIFont *normalFont = tztUIBaseViewTextFont(13.0f);
    CGFloat nFontHeignt = normalFont.lineHeight;
    //最新价
    CGRect rcNewPirce = CGRectMake(0,
                                   0,
                                   rcFrame.size.width * 0.4 + 10,
                                   fHeight * 2);
    [self.nsNewPrice drawInRect:rcNewPirce
                       withFont:newFont
                  lineBreakMode:NSLineBreakByWordWrapping
                      alignment:NSTextAlignmentCenter];
    
    CGRect rcRatio = CGRectMake(0,
                                rcNewPirce.origin.y + rcNewPirce.size.height + 10,
                                rcFrame.size.width * 0.4 + 10,
                                fHeight);
    //涨跌、幅度
    NSString* str = [NSString stringWithFormat:@"%@    %@",(self.nsRatio != NULL ? self.nsRatio : @""), (self.nsRange != NULL ? self.nsRange : @"")];
    [str drawInRect:rcRatio
           withFont:normalFont
      lineBreakMode:NSLineBreakByWordWrapping
          alignment:NSTextAlignmentCenter];
    
    //绘制分割线
    CGPoint ptStart = CGPointMake(rcFrame.size.width * 0.4 + 5, self.bounds.origin.y);
    CGPoint ptEnd   = CGPointMake(rcFrame.size.width * 0.4 + 5, self.bounds.origin.y + self.frame.size.height);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQGridColor].CGColor);
    CGContextMoveToPoint(context, ptStart.x, ptStart.y);
    CGContextAddLineToPoint(context, ptEnd.x, ptEnd.y);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQGridColor].CGColor);
    CGContextMoveToPoint(context, ptStart.x+1, ptStart.y);
    CGContextAddLineToPoint(context, ptEnd.x+1, ptEnd.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    int nWidth = rcFrame.size.width * 0.6 - 30;
    fHeight = rcFrame.size.height / 2;
    //换手
    CGRect rcChange = CGRectMake(rcFrame.origin.x + rcNewPirce.size.width,
                                 rcFrame.origin.y,
                                 15,
                                 fHeight);
    //绘制底色
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, rectColor.CGColor);
    CGContextFillRect(context, CGRectMake(rcChange.origin.x, rcChange.origin.y, rcChange.size.width, nFontHeignt));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    
    [@"换" drawInRect:rcChange
            withFont:normalFont
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentCenter];
    
    CGRect rcChangeValue = CGRectMake(rcChange.origin.x + rcChange.size.width,
                                      rcFrame.origin.y,
                                      nWidth / 2,
                                      fHeight);
    [self.nsChangeValue drawInRect:rcChangeValue
                          withFont:normalFont
                     lineBreakMode:NSLineBreakByWordWrapping
                         alignment:NSTextAlignmentCenter];
    
    //开盘
    CGRect  rcOpen = rcChange;
    rcOpen.origin.y += fHeight;
    
    //绘制底色
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, rectColor.CGColor);
    CGContextFillRect(context, CGRectMake(rcOpen.origin.x, rcOpen.origin.y, rcOpen.size.width, nFontHeignt));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    
    
    [@"开" drawInRect:rcOpen
            withFont:normalFont
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentCenter];
    
    CGRect rcOpenValue = rcChangeValue;
    rcOpenValue.origin.y += fHeight;
    
    CGContextSetFillColorWithColor(context, self.clOpenColor.CGColor);
    [self.nsOpenPrice drawInRect:rcOpenValue
                        withFont:normalFont
                   lineBreakMode:NSLineBreakByWordWrapping
                       alignment:NSTextAlignmentCenter];
    
    //最高
    CGRect rcMax = rcChange;
    rcMax.origin.x = rcChangeValue.origin.x + rcChangeValue.size.width;
    
    //绘制底色
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, rectColor.CGColor);
    CGContextFillRect(context, CGRectMake(rcMax.origin.x, rcMax.origin.y, rcMax.size.width, nFontHeignt));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    
    
    [@"高" drawInRect:rcMax
            withFont:normalFont
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentCenter];
    
    CGRect rcMaxValue = rcChangeValue;
    rcMaxValue.origin.x = rcMax.origin.x + rcMax.size.width;
    
    CGContextSetFillColorWithColor(context, self.clMaxColor.CGColor);
    [self.nsMaxPrice drawInRect:rcMaxValue
                       withFont:normalFont
                  lineBreakMode:NSLineBreakByWordWrapping
                      alignment:NSTextAlignmentCenter];
    
    //最低
    CGRect rcMin = rcMax;
    rcMin.origin.y += rcMax.size.height;
    
    //绘制底色
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, rectColor.CGColor);
    CGContextFillRect(context, CGRectMake(rcMin.origin.x, rcMin.origin.y, rcMin.size.width, nFontHeignt));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    
    [@"低" drawInRect:rcMin
            withFont:normalFont
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentCenter];
    
    CGRect rcMinValue = rcMaxValue;
    rcMinValue.origin.y += rcMaxValue.size.height;
    
    CGContextSetFillColorWithColor(context, self.clMinColor.CGColor);
    [self.nsMinPrice drawInRect:rcMinValue
                       withFont:normalFont
                  lineBreakMode:NSLineBreakByWordWrapping
                      alignment:NSTextAlignmentCenter];
}

-(void)drawFundflows:(CGContextRef)context rect_:(CGRect)rect
{
    CGRect  rcFrame = rect;
    rcFrame.origin.y += 10;
    rcFrame.size.height -= 20;
    rcFrame.origin.x += 10;
    rcFrame.size.width -= 20;
    
    CGFloat fHeight = CGRectGetHeight(rcFrame) / 3;
    UIColor *drawColor = [UIColor whiteColor];
    UIColor *rectColor = [UIColor colorWithTztRGBStr:@"48,48,48"];
    CGContextSetFillColorWithColor(context, self.clNewPriceColor.CGColor);
    
    UIFont *newFont = tztUIBaseViewTextBoldFont(30.0f);
    UIFont *normalFont = tztUIBaseViewTextFont(13.0f);
    CGFloat nFontHeignt = normalFont.lineHeight;
    //最新价
    CGRect rcNewPirce = CGRectMake(0,
                                   0,
                                   rcFrame.size.width * 0.4 + 10,
                                   fHeight * 2);
    [self.nsNewPrice drawInRect:rcNewPirce
                       withFont:newFont
                  lineBreakMode:NSLineBreakByWordWrapping
                      alignment:NSTextAlignmentCenter];
    
    CGRect rcRatio = CGRectMake(0,
                                rcNewPirce.origin.y + rcNewPirce.size.height + 10,
                                rcFrame.size.width * 0.4 + 10,
                                fHeight);
    //涨跌、幅度
    NSString* str = [NSString stringWithFormat:@"%@    %@",(self.nsRatio != NULL ? self.nsRatio : @""), (self.nsRange != NULL ? self.nsRange : @"")];
    [str drawInRect:rcRatio
           withFont:normalFont
      lineBreakMode:NSLineBreakByWordWrapping
          alignment:NSTextAlignmentCenter];
    
    //绘制分割线
    CGPoint ptStart = CGPointMake(rcFrame.size.width * 0.4 + 5, self.bounds.origin.y);
    CGPoint ptEnd   = CGPointMake(rcFrame.size.width * 0.4 + 5, self.bounds.origin.y + self.frame.size.height);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithTztRGBStr:@"31,31,31"].CGColor);
    CGContextMoveToPoint(context, ptStart.x, ptStart.y);
    CGContextAddLineToPoint(context, ptEnd.x, ptEnd.y);
    CGContextClosePath(context);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithTztRGBStr:@"38,38,38"].CGColor);
    CGContextMoveToPoint(context, ptStart.x+1, ptStart.y);
    CGContextAddLineToPoint(context, ptEnd.x+1, ptEnd.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    int nWidth = rcFrame.size.width * 0.6;
    fHeight = rcFrame.size.height;
    //换手
    CGRect rcChange = CGRectMake(rcFrame.origin.x + rcNewPirce.size.width,
                                 rcFrame.origin.y + (fHeight - nFontHeignt) / 2,
                                 nWidth / 3,
                                 fHeight);
    //绘制底色
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, rectColor.CGColor);
    CGContextFillRect(context, CGRectMake(rcChange.origin.x, rcChange.origin.y, rcChange.size.width, nFontHeignt));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    
    [self.nsFundflowTitle drawInRect:rcChange
                            withFont:normalFont
                       lineBreakMode:NSLineBreakByWordWrapping
                           alignment:NSTextAlignmentCenter];
    
    CGRect rcChangeValue = CGRectMake(rcChange.origin.x + rcChange.size.width,
                                      rcFrame.origin.y,
                                      nWidth * 2 / 3,
                                      fHeight);
    
    CGContextSetFillColorWithColor(context, self.clFundValue.CGColor);
    [self.nsFundflowValue drawInRect:rcChangeValue
                            withFont:newFont
                       lineBreakMode:NSLineBreakByWordWrapping
                           alignment:NSTextAlignmentCenter];
}

-(void)drawRect:(CGRect)rect
{
//    CAGradientLayer *shadow = [CAGradientLayer layer];
//    [shadow setStartPoint:CGPointMake(0.1, 1.0)];
//    [shadow setEndPoint:CGPointMake(0.1, 0.0)];
//    UIColor *color = [UIColor tztThemeHQHideGridColor];
//    shadow.colors = [NSArray arrayWithObjects:(id)[color CGColor], (id)[[UIColor clearColor] CGColor], nil];
//    shadow.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 1);
//    [self.layer insertSublayer:shadow atIndex:0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1);
    //填充背景
    CGContextSaveGState(context);
    UIColor* HideGridColor = [UIColor tztThemeHQHideGridColor];
    UIColor* BackgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGContextSetStrokeColorWithColor(context, HideGridColor.CGColor);
    CGContextSetFillColorWithColor(context, BackgroundColor.CGColor);
    CGContextFillRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
//    if (_tztBlockType == tztBlockIndexInfoType_Ex)
//    {
//        [self drawDataEx:context rect_:rect];
//    }
//    else
    if (_tztBlockType == tztReportFlowsBlockIndex)
    {
        [self drawFundflows:context rect_:rect];
    }
    else
    {
        [self drawDataNormal:context rect_:rect];
    }
}

-(void)tztBlockIndexInfo:(id)view updateInfo_:(NSMutableArray*)pArray
{
    if (self.pArrayValue == NULL)
        self.pArrayValue = NewObject(NSMutableArray);
    [self.pArrayValue removeAllObjects];
    
    [self initdata];
    NSInteger nCount = [pArray count];
    //==2,一行标题，一行数据
    if (nCount < 3)
    {
        [self setNeedsDisplay];
        return;
    }
    
    NSArray *ayTitle = [pArray objectAtIndex:0];
    if (ayTitle == NULL || ayTitle.count < 1)
    {
        [self setNeedsDisplay];
        return;
    }
    
    NSArray *ayContent = [pArray objectAtIndex:1];
    if (ayContent == NULL || ayContent.count < 1 || [ayContent count] != [ayTitle count])
    {
        [self setNeedsDisplay];
        return;
    }
    
    for (int i = 0; i < [ayTitle count]; i++)
    {
        TZTGridDataTitle *pTitle = [ayTitle objectAtIndex:i];
        if (pTitle == NULL || pTitle.text == NULL || pTitle.text.length < 1)
            continue;
        
        if ([pTitle.text hasPrefix:@"最新"])
        {
            TZTGridData* pData = [ayContent objectAtIndex:i];
            if (pData.text && pData.text.length > 0)
                self.nsNewPrice = [NSString stringWithFormat:@"%@", pData.text];
            if (pData.textColor)
                self.clNewPriceColor = pData.textColor;
        }
        else if ([pTitle.text hasPrefix:@"涨跌"])
        {
            TZTGridData *pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsRatio = [NSString stringWithFormat:@"%@", pData.text];
        }
        else if ([pTitle.text hasPrefix:@"幅度"])
        {
            TZTGridData *pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsRange = [NSString stringWithFormat:@"%@", pData.text];
        }
        else if ([pTitle.text hasPrefix:@"换手"])
        {
            TZTGridData *pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsChangeValue = [NSString stringWithFormat:@"%@", pData.text];
        }
        else if ([pTitle.text hasPrefix:@"开盘"])
        {
            TZTGridData* pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsOpenPrice = [NSString stringWithFormat:@"%@", pData.text];
            if (pData.textColor)
                self.clOpenColor = pData.textColor;
        }
        else if ([pTitle.text hasPrefix:@"最高"])
        {
            TZTGridData *pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsMaxPrice = [NSString stringWithFormat:@"%@", pData.text];
            if (pData.textColor)
                self.clMaxColor = pData.textColor;
        }
        else if ([pTitle.text hasPrefix:@"最低"])
        {
            TZTGridData *pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsMinPrice = [NSString stringWithFormat:@"%@", pData.text];
            if (pData.textColor)
                self.clMinColor = pData.textColor;
        }
        else if ([pTitle.text hasPrefix:@"昨收"])
        {
            TZTGridData *pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsClosePrice = [NSString stringWithFormat:@"%@", pData.text];
        }
        else if ([pTitle.text hasPrefix:@"名称"])
        {
            TZTGridData *pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
            {
                NSString *str = [NSString stringWithFormat:@"%@", pData.text];
                NSArray *ay = [str componentsSeparatedByString:@"."];
                if (ay && [ay count] > 1)
                    self.nsStockName = [NSString stringWithFormat:@"%@",[ay objectAtIndex:1]];
                else
                    self.nsStockName = [NSString stringWithFormat:@"%@", pData.text];
            }
        }
        else if ([pTitle.text hasPrefix:@"净流入"])
        {
            self.nsFundflowTitle = [NSString stringWithFormat:@"%@", pTitle.text];
            TZTGridData *pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsFundflowValue = [NSString stringWithFormat:@"%@", pData.text];
            if (pData.textColor)
                self.clFundValue = pData.textColor;
        }
        else if ([pTitle.text hasPrefix:@"增仓"])
        {
            self.nsFundflowTitle = [NSString stringWithFormat:@"%@", pTitle.text];
            TZTGridData *pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsFundflowValue = [NSString stringWithFormat:@"%@", pData.text];
            if (pData.textColor)
                self.clFundValue = pData.textColor;
        }
        
        if (i == [ayTitle count] - 1)
        {
            TZTGridData* pData = [ayContent objectAtIndex:i];
            if (ISNSStringValid(pData.text))
                self.nsStockCode = [NSString stringWithFormat:@"%@", pData.text];
        }
    }
    
    _nStockType = [[pArray objectAtIndex:2] intValue];
    
    if (nCount > 3)
    {
        self.nsUpStocks = [NSString stringWithFormat:@"%@", [pArray objectAtIndex:3]];
    }
    if (nCount > 4)
    {
        self.nsDownStocks = [NSString stringWithFormat:@"%@", [pArray objectAtIndex:4]];
    }
    if (nCount > 5)
    {
        self.nsDrawStocks = [NSString stringWithFormat:@"%@", [pArray objectAtIndex:5]];
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
    {
        tztStockInfo *pStockInfo = NewObject(tztStockInfo);
        pStockInfo.stockCode = [NSString stringWithFormat:@"%@", self.nsStockCode];
        pStockInfo.stockName = [NSString stringWithFormat:@"%@", self.nsStockName];
        pStockInfo.stockType = _nStockType;
        [_tztdelegate tzthqView:nil setStockCode:pStockInfo];
        DelObject(pStockInfo);
    }
}

@end
