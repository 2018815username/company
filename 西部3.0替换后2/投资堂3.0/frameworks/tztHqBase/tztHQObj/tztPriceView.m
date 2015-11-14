/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztPriceView.m
 * 文件标识：
 * 摘    要：报价视图
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

#import "tztPriceView.h"
#define tztLineHeight 15
#define tztMaxLineHeight 35

int g_nWPDetailPrice = 0;

@interface tztScrollWuKou : UIView<UIGestureRecognizerDelegate>
{
    TNewPriceData* _TrendpriceData; //报价数
    TNewPriceDataEx* _TrendpriceDataEx;//扩展6-10档
    UITapGestureRecognizer *tgr;
}
@property(nonatomic,retain)tztStockInfo *pStockInfo;
@property(nonatomic)int nAmount;
@property(nonatomic,assign)id tztDelegate;
//设置报价数据
- (void)setPriceData:(TNewPriceData*)priceData len:(int)nLen;
- (void)setPriceDataEx:(TNewPriceDataEx*)priceData len:(int)nLen;
@end

@implementation tztScrollWuKou
@synthesize pStockInfo = _pStockInfo;
@synthesize nAmount = _nAmount;
@synthesize tztDelegate = _tztDelegate;

-(id)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame])
    {
        [self initData];
    }
    return self;
}

-(void)initData
{
    if (_TrendpriceData == NULL)
        _TrendpriceData = malloc(sizeof(TNewPriceData));
    memset(_TrendpriceData, 0x00, sizeof(TNewPriceData));
    
    if (_TrendpriceDataEx == NULL)
        _TrendpriceDataEx = malloc(sizeof(TNewPriceData));
    memset(_TrendpriceDataEx, 0x00, sizeof(TNewPriceData));
    
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    if (tgr == NULL)
    {
        tgr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
//        tgr.numberOfTapsRequired = 1;
//        tgr.numberOfTouchesRequired = 1;
//        tgr.delegate = self;
        [self addGestureRecognizer:tgr];
    }
}

-(void)tapped:(UITapGestureRecognizer*)tap
{
    if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(OnSwitch)])
    {
        [_tztDelegate performSelector:@selector(OnSwitch) withObject:nil];
    }
}


//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

-(void)dealloc
{
    if(_TrendpriceData)
    {
        free(_TrendpriceData);
        _TrendpriceData = nil;
    }
    
    if (_TrendpriceDataEx)
    {
        free(_TrendpriceDataEx);
        _TrendpriceDataEx = nil;
    }
    
    [super dealloc];
}

-(void)setPriceData:(TNewPriceData *)priceData len:(int)nLen
{
    memset(_TrendpriceData, 0x00, sizeof(TNewPriceData));
    memcpy(_TrendpriceData, priceData, nLen);
}

- (void)setPriceDataEx:(TNewPriceDataEx*)priceData len:(int)nLen
{
    memset(_TrendpriceDataEx, 0x00, sizeof(TNewPriceDataEx));
    memcpy(_TrendpriceDataEx, priceData, nLen);
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1);
    [self onDrawPrice:context rect:rect];
}

-(void)onDrawPrice:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    UIColor* HideGridColor = [UIColor tztThemeBackgroundColorHQ];
    UIColor* BackgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGContextSetStrokeColorWithColor(context, HideGridColor.CGColor);
    CGContextSetFillColorWithColor(context, BackgroundColor.CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    
    UIFont* drawFont = [UIFont tztThemeHQWudangFont];// [tztTechSetting getInstance].drawTxtFont;
    CGPoint drawpoint = rect.origin;
    drawpoint.x += 2;
    
    NSString* strPrice = @"卖5|卖4|卖3|卖2|卖1|买1|买2|买3|买4|买5";
    NSArray* ay = [strPrice componentsSeparatedByString:@"|"];
    CGSize Fixsize = [@"卖10" sizeWithFont:drawFont];
    
    BOOL bHKStock = MakeHKMarketStock(self.pStockInfo.stockType);
    int  nHavRights = 0;
    
    //华泰港股通专用
    if (g_nHKShowTenPrice)
        nHavRights = tztHaveHKRight();
    CGFloat fHeight = CGRectGetHeight(rect)/([ay count])-0.2f;
    if(bHKStock)
    {
        fHeight = CGRectGetHeight(rect)/2/([ay count])-0.2f;
//        if (fHeight > tztLineHeight)
//        {
//            fHeight = tztLineHeight;
//        }
        strPrice = @"卖10|卖9|卖8|卖7|卖6|卖5|卖4|卖3|卖2|卖1|买1|买2|买3|买4|买5|买6|买7|买8|买9|买10";
        ay = [strPrice componentsSeparatedByString:@"|"];
    }
    
    
    if (fHeight > tztMaxLineHeight)
        fHeight = tztMaxLineHeight;
    
    CGFloat fDif = (fHeight - Fixsize.height) / 2;
    if(fDif < 0)
    {
        TZTLogError(@"%@",@"绘制区域不足");
    }
    
    
    
    int nXSep = 1;
    UIColor* drawColor = [UIColor tztThemeHQFixTextColor];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    if (IS_TZTIPAD)
        drawpoint.x = 10;
    drawpoint.y = rect.origin.y + fDif;
    for (int i = 0; i < [ay count]; i++)
    {
        NSString* strCaption = [ay objectAtIndex:i];
        if (bHKStock && (nHavRights < 1))
        {
            if (i != 9 && i != 10)
            {
                drawpoint.y += fHeight;
                continue;
            }
        }
        [strCaption drawAtPoint:drawpoint withFont:drawFont];
        drawpoint.y += fHeight;
#if 1
        if(i == (bHKStock ? 9 : 4))
        {
            drawpoint.y += 2;
            drawpoint.y += 2;
        }
#endif
    }
    drawpoint.y = rect.origin.y +fDif;
    Fixsize.width += 1.0f;
    
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minX = CGRectGetMinX(rect);
    if (IS_TZTIPAD)
    {
        maxX = CGRectGetMaxX(rect) - 10;
//        minX = Fixsize.width;
    }
    
    if (bHKStock)//港股个股，判断权限，绘制10档或者1档
    {
        if (_nAmount <= 0)
            _nAmount = 100;
        
        UIColor* VolColor = [UIColor tztThemeHQBalanceColor];
        NSString* strValue = @"";
        CGSize drawsize;
        
        float nWidth = (maxX - Fixsize.width) / 2 - 1;
        float nHeight = drawFont.lineHeight;
        
        CGRect rcDraw;
        rcDraw.size = CGSizeMake(nWidth, nHavRights);
        if (nHavRights > 0)
        {
            //卖10
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pSell5 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pSell5 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pSell5 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            rcDraw = CGRectMake(drawpoint.x, drawpoint.y, nWidth, nHeight);
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QSell5 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //卖9
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pSell4 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pSell4 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pSell4 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QSell4 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //卖8
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pSell3 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pSell3 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pSell3 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QSell3 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //卖7
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pSell2 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pSell2 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pSell2 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QSell2 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //卖6
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pSell1 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pSell1 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pSell1 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QSell1 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
        
        //卖五
            drawColor = balanceColor;
            if(_TrendpriceData->a.StockData.p10 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceData->a.StockData.p10 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p10 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceData->a.StockData.Q10 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            
            //卖四
            drawColor = balanceColor;
            if(_TrendpriceData->a.StockData.p9 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceData->a.StockData.p9 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p9 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceData->a.StockData.Q9 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //卖三
            drawColor = balanceColor;
            if(_TrendpriceData->a.StockData.P6 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceData->a.StockData.P6 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.P6 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceData->a.StockData.Q6 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //卖二
            drawColor = balanceColor;
            if(_TrendpriceData->a.StockData.P5 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceData->a.StockData.P5 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.P5 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceData->a.StockData.Q5 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            
        }
        else
        {
            drawpoint.y += 9 * fHeight;
        }
        
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        //卖一
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p4 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p4 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        rcDraw.origin.x = drawpoint.x;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p4 ,0,_TrendpriceData->nDecimal,1000);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q4 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
        //        drawpoint.x = maxX - drawsize.width - 1;
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
#if 1
        //当前价
        //    NSString* strNewPrice = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Last_p,0,_TrendpriceData->nDecimal,1000);
        drawColor = balanceColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, [UIColor tztThemeHQGridColor].CGColor);
        CGContextSetLineWidth(context, 1.0f);
        CGContextMoveToPoint(context, rect.origin.x, drawpoint.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, drawpoint.y);
        CGContextClosePath(context);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        //    NSString* nsNewPrice = [NSString stringWithFormat:@"当前价(元):%@", strNewPrice];
        //    CGRect rcFrame = CGRectMake(0, drawpoint.y, self.bounds.size.width, fHeight);
        //    [nsNewPrice drawInRect:rcFrame withFont:drawFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        drawpoint.y += 2;
        drawpoint.y += 2;
#endif
        rcDraw.origin.y = drawpoint.y;
        //    //－
        //    drawpoint.y += (Fixsize.height-fHeight)+Fixsize.height / 2;
        //
        //买一
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p1 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p1 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        rcDraw.origin.x = drawpoint.x;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p1 ,0,_TrendpriceData->nDecimal,1000);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q1 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
//        drawpoint.x = maxX - drawsize.width - 1;
        
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
        if (nHavRights > 0)
        {
            //买二
            drawColor = balanceColor;
            if(_TrendpriceData->a.StockData.p2 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceData->a.StockData.p2 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p2 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceData->a.StockData.Q2 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //买三
            drawColor = balanceColor;
            if(_TrendpriceData->a.StockData.p3 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceData->a.StockData.p3 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p3 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceData->a.StockData.Q3 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //买四
            drawColor = balanceColor;
            if(_TrendpriceData->a.StockData.p7 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceData->a.StockData.p7 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p7 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceData->a.StockData.Q7 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //买五
            drawColor = balanceColor;
            if(_TrendpriceData->a.StockData.p8 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceData->a.StockData.p8 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p8 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceData->a.StockData.Q8 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
        
            //买6
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pBuy1 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pBuy1 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pBuy1 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QBuy1 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //买7
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pBuy2 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pBuy2 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pBuy2 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QBuy2 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //买8
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pBuy3 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pBuy3 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pBuy3 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QBuy3 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //买9
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pBuy4 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pBuy4 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pBuy4 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QBuy4 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.origin.y = drawpoint.y;
            rcDraw.size.width = nWidth;
            
            //买10
            drawColor = balanceColor;
            if(_TrendpriceDataEx->pBuy5 > _TrendpriceData->Close_p)
                drawColor = upColor;
            else if(_TrendpriceDataEx->pBuy5 < _TrendpriceData->Close_p)
                drawColor = downColor;
            CGContextSetFillColorWithColor(context, drawColor.CGColor);
            drawpoint.x = minX + Fixsize.width;
            rcDraw.origin.x = drawpoint.x;
            strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceDataEx->pBuy5 ,0,_TrendpriceData->nDecimal,1000);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            
            strValue = NStringOfULong(_TrendpriceDataEx->QBuy5 / _nAmount);
            drawsize = [strValue sizeWithFont:drawFont];
//            drawpoint.x = maxX - drawsize.width - 1;
            
            if (drawsize.width > rcDraw.size.width)
            {
                rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
                rcDraw.size.width = drawsize.width;
            }
            else
                rcDraw.origin.x += rcDraw.size.width + nXSep;
            CGContextSetFillColorWithColor(context, VolColor.CGColor);
//            [strValue drawAtPoint:drawpoint withFont:drawFont];
            [strValue drawInRect:rcDraw
                        withFont:drawFont
                   lineBreakMode:NSLineBreakByCharWrapping
                       alignment:NSTextAlignmentRight];
            drawpoint.y += fHeight;
            rcDraw.size.width = nWidth;
        }
    
    }
    else
    {
        CGFloat nWidth = (maxX - Fixsize.width) / 2 - 1;
        CGFloat nHeight = drawFont.lineHeight;
        UIColor* VolColor = [UIColor tztThemeHQBalanceColor];
        //卖五
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p10 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p10 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        NSString* strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p10 ,0,_TrendpriceData->nDecimal,1000);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        CGRect rcDraw = CGRectMake(drawpoint.x, drawpoint.y, nWidth, nHeight);
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        if (_nAmount <= 0)
            _nAmount = 100;
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q10 / _nAmount);
        CGSize drawsize = [strValue sizeWithFont:drawFont];
        //        drawpoint.x = maxX - drawsize.width - 1;
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
//        rcDraw.origin.x = drawpoint.x;
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y  = drawpoint.y;
        rcDraw.size.width = nWidth;
        
        //卖四
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p9 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p9 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p9 ,0,_TrendpriceData->nDecimal,1000);
        rcDraw.origin.x = drawpoint.x;
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q9 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
        //        drawpoint.x = maxX - drawsize.width - 1;
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
        //卖三
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.P6 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.P6 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.P6 ,0,_TrendpriceData->nDecimal,1000);
        rcDraw.origin.x = drawpoint.x;
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q6 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
        //        drawpoint.x = maxX - drawsize.width - 1;
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
        //卖二
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.P5 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.P5 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        rcDraw.origin.x = drawpoint.x;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.P5 ,0,_TrendpriceData->nDecimal,1000);
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q5 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
//        drawpoint.x = maxX - drawsize.width - 1;
        
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
        //卖一
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p4 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p4 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        rcDraw.origin.x = drawpoint.x;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p4 ,0,_TrendpriceData->nDecimal,1000);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q4 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
//        drawpoint.x = maxX - drawsize.width - 1;
        
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
#if 1
        //当前价
        //    NSString* strNewPrice = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Last_p,0,_TrendpriceData->nDecimal,1000);
        drawColor = balanceColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, [UIColor tztThemeBorderColor].CGColor);
        CGContextSetLineWidth(context, 1.0f);
        CGContextMoveToPoint(context, rect.origin.x, drawpoint.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, drawpoint.y);
        CGContextClosePath(context);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
        //    NSString* nsNewPrice = [NSString stringWithFormat:@"当前价(元):%@", strNewPrice];
        //    CGRect rcFrame = CGRectMake(0, drawpoint.y, self.bounds.size.width, fHeight);
        //    [nsNewPrice drawInRect:rcFrame withFont:drawFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        drawpoint.y += 2;
        drawpoint.y += 2;
        rcDraw.origin.y = drawpoint.y;
#endif
        //    //－
        //    drawpoint.y += (Fixsize.height-fHeight)+Fixsize.height / 2;
        //
        //买一
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p1 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p1 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        rcDraw.origin.x = drawpoint.x;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p1 ,0,_TrendpriceData->nDecimal,1000);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q1 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
//        drawpoint.x = maxX - drawsize.width - 1;
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
        //买二
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p2 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p2 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        rcDraw.origin.x = drawpoint.x;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p2 ,0,_TrendpriceData->nDecimal,1000);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q2 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
//        drawpoint.x = maxX - drawsize.width - 1;
        
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
        //买三
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p3 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p3 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        rcDraw.origin.x = drawpoint.x;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p3 ,0,_TrendpriceData->nDecimal,1000);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q3 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
//        drawpoint.x = maxX - drawsize.width - 1;
        
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
        //买四
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p7 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p7 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        rcDraw.origin.x = drawpoint.x;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p7 ,0,_TrendpriceData->nDecimal,1000);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q7 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
//        drawpoint.x = maxX - drawsize.width - 1;
        
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.origin.y = drawpoint.y;
        rcDraw.size.width = nWidth;
        
        //买五
        drawColor = balanceColor;
        if(_TrendpriceData->a.StockData.p8 > _TrendpriceData->Close_p)
            drawColor = upColor;
        else if(_TrendpriceData->a.StockData.p8 < _TrendpriceData->Close_p)
            drawColor = downColor;
        CGContextSetFillColorWithColor(context, drawColor.CGColor);
        drawpoint.x = minX + Fixsize.width;
        rcDraw.origin.x = drawpoint.x;
        strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p8 ,0,_TrendpriceData->nDecimal,1000);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        
        strValue = NStringOfULong(_TrendpriceData->a.StockData.Q8 / _nAmount);
        drawsize = [strValue sizeWithFont:drawFont];
//        drawpoint.x = maxX - drawsize.width - 1;
        
        if (drawsize.width > rcDraw.size.width)
        {
            rcDraw.origin.x += rcDraw.size.width + (rcDraw.size.width - drawsize.width);
            rcDraw.size.width = drawsize.width;
        }
        else
            rcDraw.origin.x += rcDraw.size.width + nXSep;
        CGContextSetFillColorWithColor(context, VolColor.CGColor);
//        [strValue drawAtPoint:drawpoint withFont:drawFont];
        [strValue drawInRect:rcDraw
                    withFont:drawFont
               lineBreakMode:NSLineBreakByCharWrapping
                   alignment:NSTextAlignmentRight];
        drawpoint.y += fHeight;
        rcDraw.size.width = nWidth;
    }
}

@end

@interface tztPriceView ()
{
    tztUISwitch*  _btnPrice;  //报价
    tztUISwitch*  _btnWuKou;  //5口价
    BOOL          _bPrice;    //是否显示报价
    
    CGRect      _PriceDrawRect;     //报价区域
    CGRect      _WuKouDrawRect;     //5口价区域
    tztTrendPriceStyle _tztPriceStyle; //报价图状态
    
    CGRect      _NewPriceDrawRect;  //最新价、涨幅区域(iPad)
    BOOL        _bFrist;
}

@property(nonatomic,retain)UIScrollView   *pScrollView;
@property(nonatomic,retain)tztScrollWuKou *pScrollViewIn;

//绘制报价图
- (void)onDrawPrice:(CGContextRef)context rect:(CGRect)rect;
- (void)drawBackGroundRect:(CGContextRef)context rect:(CGRect)rect;
//绘制股票报价图
- (void)onDrawStockPrice:(CGContextRef)context;
//绘制5口价图
- (void)onDrawStockWuKou:(CGContextRef)context;
//绘制指数报价图
- (void)onDrawIndexPrice:(CGContextRef)context;
//绘制港股报价图
- (void)onDrawHKPrice:(CGContextRef)context;
//绘制期货报价图
- (void)onDrawQHPrice:(CGContextRef)context;
//绘制外汇报价图
- (void)onDrawWHPrice:(CGContextRef)context;
//绘制外盘报价图
- (void)onDrawWPPrice:(CGContextRef)context;
//绘制最新价图（）
- (void)onDrawNewPrice:(CGContextRef)context;
@end

@implementation tztPriceView
@synthesize tztPriceStyle = _tztPriceStyle;
@synthesize nAmount = _nAmount;
@synthesize pScrollView = _pScrollView;
@synthesize pScrollViewIn = _pScrollViewIn;
@synthesize pDetailView = _pDetailView;

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
    if(_TrendpriceData)
    {
        free(_TrendpriceData);
        _TrendpriceData = nil;
    }
    
    if (_TrendpriceDataEx)
    {
        free(_TrendpriceDataEx);
        _TrendpriceDataEx = nil;
    }
    
    if(_techData)
    {
        free(_techData);
        _techData = nil;
    }
    [super dealloc];
}

- (void)initdata
{
    _TrendpriceData = malloc(sizeof(TNewPriceData));
    memset(_TrendpriceData, 0x00, sizeof(TNewPriceData));
    
    _TrendpriceDataEx = malloc(sizeof(TNewPriceData));
    memset(_TrendpriceDataEx, 0x00, sizeof(TNewPriceData));
    
    _techData = malloc(sizeof(TNewKLineHead));
    memset(_techData, 0x00, sizeof(TNewKLineHead));

    if(IS_TZTIPAD)
        _tztPriceStyle = TrendPriceTwo;
    else
        _tztPriceStyle = TrendPriceOne;
    
    _bPrice = NO;
    if (_btnPrice == NULL)
    {
        _btnPrice = [tztUISwitch buttonWithType:UIButtonTypeCustom];
        _btnPrice.yesImage = [UIImage imageTztNamed:@"TZTBtnYesSelect.png"];
        _btnPrice.noImage = [UIImage imageTztNamed:@"TZTBtnNoSelect.png"];
        _btnPrice.switched = NO;
        _btnPrice.yestitle = @"盘口";
        _btnPrice.notitle = @"盘口";
        [_btnPrice setChecked:_bPrice];
        _btnPrice.titleLabel.font = tztUIBaseViewTextFont(14.0f);

        _btnPrice.hidden = YES;
        [_btnPrice setTztTitleColor:[UIColor tztThemeHQFixTextColor]];
        [_btnPrice addTarget:self action:@selector(onClickPrice:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_btnPrice];
    }
    
    if (_btnWuKou == NULL)
    {
        _btnWuKou = [tztUISwitch buttonWithType:UIButtonTypeCustom];
        _btnWuKou.yesImage = [UIImage imageTztNamed:@"TZTBtnYesSelect.png"];
        _btnWuKou.noImage = [UIImage imageTztNamed:@"TZTBtnNoSelect.png"];
        _btnWuKou.switched = NO;
        _btnWuKou.yestitle = @"五档";
        _btnWuKou.notitle = @"五档";
        _btnWuKou.hidden = YES;
        [_btnWuKou setChecked:!_bPrice];
        _btnWuKou.titleLabel.font = tztUIBaseViewTextFont(14.0f);

        
        [_btnWuKou setTztTitleColor:[UIColor tztThemeHQFixTextColor]];
        [_btnWuKou addTarget:self action:@selector(onClickPrice:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_btnWuKou];
    }
    
    if (_pScrollView == NULL)
    {
        _pScrollView = [[UIScrollView alloc] init];
        [self addSubview:_pScrollView];
        [_pScrollView release];
    }
    _pScrollView.hidden = _bPrice;
    
    if (_pScrollViewIn == NULL)
    {
        _pScrollViewIn = [[tztScrollWuKou alloc] init];
        //增加手势操作
        _pScrollViewIn.tztDelegate = self;
        [_pScrollView addSubview:_pScrollViewIn];
        [_pScrollViewIn release];
        _bFrist = TRUE;
    }
    
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    
}

- (void)onClickPrice:(id)obj
{
    tztUISwitch* btn = (tztUISwitch *)obj;
    if(btn == _btnPrice)
    {
        _bPrice = TRUE;
    }
    else
    {
        _bPrice = FALSE;
    }
    [_btnPrice setChecked:_bPrice];
    [_btnWuKou setChecked:!_bPrice];
    _pScrollView.hidden = _bPrice;
    [self setNeedsDisplay];
}

#pragma 报价绘制处理
// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    if (MakeHKMarketStock(self.pStockInfo.stockType))
    {
        if (g_nHKShowTenPrice)
        {
            int nHavRights = 0;
            nHavRights = tztHaveHKRight();
            if (nHavRights > 0)
            {
                _btnWuKou.yestitle = @"十档";
                _btnWuKou.notitle = @"十档";
                [_btnWuKou setTztTitle:@"十档"];
            }
            else
            {
                _btnWuKou.yestitle = @"一档";
                _btnWuKou.notitle = @"一档";
                [_btnWuKou setTztTitle:@"一档"];
            }
        }
        else
        {
            _btnWuKou.yestitle = @"五档";
            _btnWuKou.notitle = @"五档";
            [_btnWuKou setTztTitle:@"五档"];
        }
    }
    else
    {
        _btnWuKou.yestitle = @"五档";
        _btnWuKou.notitle = @"五档";
        [_btnWuKou setTztTitle:@"五档"];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1);
    [self onDrawPrice:context rect:rect];
}

// An empty implementation adversely affects performance during animation.
- (void)drawBackGroundRect:(CGContextRef)context rect:(CGRect)rect
{
    _PriceDrawRect = rect;
    
    if (IS_TZTIPAD)
    {
        _NewPriceDrawRect = rect;
        _NewPriceDrawRect.size.height = 56;//(rect.size.height / 10 );
        _PriceDrawRect = rect;
        _PriceDrawRect.origin.y = _NewPriceDrawRect.origin.y + _NewPriceDrawRect.size.height;
        _PriceDrawRect.size.height -= _NewPriceDrawRect.size.height;
    }
    
    CGContextSaveGState(context);
    UIColor* HideGridColor = [UIColor tztThemeBackgroundColorHQ];
    UIColor* BackgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGContextSetStrokeColorWithColor(context, HideGridColor.CGColor);
    CGContextSetFillColorWithColor(context, BackgroundColor.CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);

    CGRect priceframe = CGRectZero;
    priceframe.size.width = CGRectGetWidth(_PriceDrawRect)/2;
    priceframe.origin.x += 1;
    priceframe.size.width -= 2;
    priceframe.size.height = 20;
    [_btnPrice setFrame:priceframe];
    
    CGRect wuframe = priceframe;
    wuframe.origin.x += priceframe.size.width+1;
    [_btnWuKou setFrame:wuframe];

}

- (void)onDrawStockPrice:(CGContextRef)context
{
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    
    UIFont* drawFont = [UIFont tztThemeHQWudangFont];//[tztTechSetting getInstance].drawTxtFont;
    CGPoint drawpoint = _PriceDrawRect.origin;
    int nHand = 100;
    NSString* strPrice = @"均价|现手|总手|换手|PE|净资产|总股本|流通盘|量比|委比|委差|外盘|内盘";
    NSArray* ay = [strPrice componentsSeparatedByString:@"|"];
    CGFloat fHeight = CGRectGetHeight(_PriceDrawRect) / [ay count];
    if (fHeight > tztMaxLineHeight)
        fHeight = tztMaxLineHeight;
    CGSize drawsize = [@"均价" sizeWithFont:drawFont];
    CGFloat fDif = (fHeight - drawsize.height) / 2;
    UIColor* drawColor = [UIColor tztThemeHQFixTextColor];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    if (IS_TZTIPAD)
        drawpoint.x = 10;
    drawpoint.y = _PriceDrawRect.origin.y +fDif;   
    for (int i = 0; i < [ay count]; i++)
    {
        NSString* strCaption = [ay objectAtIndex:i];
        [strCaption drawAtPoint:drawpoint withFont:drawFont];
        drawpoint.y += fHeight;
    }
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    
    CGFloat maxX = CGRectGetMaxX(_PriceDrawRect);
    if (IS_TZTIPAD)
        maxX = CGRectGetMaxX(_PriceDrawRect) - 10;
    //均价
    NSString* strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lAvgPrice,0,_TrendpriceData->nDecimal,1000);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->m_lAvgPrice > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->m_lAvgPrice < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    if (_nAmount <= 0)
        _nAmount = 100;
    //现手
    drawColor = [UIColor tztThemeHQBalanceColor];
    strValue = NStringOfULong(_TrendpriceData->a.StockData.Last_h / _nAmount);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //总手
    strValue = NStringOfULong(_TrendpriceData->Total_h / _nAmount);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //换手
    strValue = [NSString stringWithFormat:@"%.2f%%",_TrendpriceData->nHuanshoulv / 100.f];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //PE
    strValue = [NSString stringWithFormat:@"%.2f",_TrendpriceData->m_ldtsyl / 1000.f];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //净资产
    strValue = [NSString stringWithFormat:@"%.2f",_TrendpriceData->m_ljzc / 10000.f];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //总股本
    strValue = NStringOfULongLong((unsigned long long)_TrendpriceData->m_zgb*10000);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //流通盘
    strValue = NStringOfULongLong((unsigned long long)_TrendpriceData->m_ltb*10000);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //量比
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lLiangbi, 0, 2, 100);
    //NStringOfLong(_TrendpriceData->m_lLiangbi);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委比
//    long BuyCount = _TrendpriceData->a.StockData.Q1+
//    _TrendpriceData->a.StockData.Q2 +
//    _TrendpriceData->a.StockData.Q3 +
//    _TrendpriceData->a.StockData.Q7 +
//    _TrendpriceData->a.StockData.Q8;
    
//    long SellCount = _TrendpriceData->a.StockData.Q4+
//    _TrendpriceData->a.StockData.Q5 +
//    _TrendpriceData->a.StockData.Q6 +
//    _TrendpriceData->a.StockData.Q9 +
//    _TrendpriceData->a.StockData.Q10;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
    long lBi= _TrendpriceData->m_nWB;
    drawColor = balanceColor;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
        if ( lBi> 0 )
        {
//            lBi = (long)(lWeiBi+0.5);
            drawColor = upColor;
        }
        else if (lBi == 0)
        {
        }
        else
        {
//            lBi = (long)(lWeiBi-0.5);
            drawColor = downColor;
        }
//    }
    
    strValue = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委差
    long lWeiCa = _TrendpriceData->m_nWC;// (A / nHand);
    strValue = [NSString stringWithFormat:@"%ld",lWeiCa];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //外盘
    drawColor = upColor;
    strValue = NStringOfLong(_TrendpriceData->m_lOutside/nHand);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //内盘
    drawColor = downColor;
    strValue = NStringOfLong(_TrendpriceData->m_lInside/nHand);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
}

- (void)onDrawStockWuKou:(CGContextRef)context
{
    
    _pScrollView.hidden = _bPrice;
//#ifdef Support_HKTrade
    _pScrollViewIn.pStockInfo = self.pStockInfo;
    _pScrollViewIn.nAmount = _nAmount;
    [_pScrollViewIn setPriceData:_TrendpriceData len:sizeof(TNewPriceData)];
    [_pScrollViewIn setPriceDataEx:_TrendpriceDataEx len:sizeof(TNewPriceDataEx)];
    _pScrollView.frame = _WuKouDrawRect;
    if(MakeHKMarketStock(self.pStockInfo.stockType))
    {
        if (g_nHKShowTenPrice)
        {
            _pScrollViewIn.nAmount = _TrendpriceData->m_nUnit;
            int nHavRights = 0;
            nHavRights = tztHaveHKRight();
            if (nHavRights > 0)
            {
                _btnWuKou.yestitle = @"十档";
                _btnWuKou.notitle = @"十档";
                [_btnWuKou setTztTitle:@"十档"];
            }
            else
            {
                _btnWuKou.yestitle = @"一档";
                _btnWuKou.notitle = @"一档";
                [_btnWuKou setTztTitle:@"一档"];
            }
    //        strPrice = @"卖10|卖9|卖8|卖7|卖6|卖5|卖4|卖3|卖2|卖1|买1|买2|买3|买4|买5|买6|买7|买8|买9|买10";
    //        ay = [strPrice componentsSeparatedByString:@"|"];
            if (_WuKouDrawRect.size.height >= tztLineHeight * 20)
            {
                _pScrollViewIn.frame = CGRectMake(0, 0, _WuKouDrawRect.size.width, _WuKouDrawRect.size.height);
            }
            else
                _pScrollViewIn.frame = CGRectMake(0, 0, _WuKouDrawRect.size.width, MIN(_WuKouDrawRect.size.height * 2, tztLineHeight * 20));
            _pScrollView.scrollEnabled = (nHavRights > 0);
            _pScrollView.contentSize = _pScrollViewIn.frame.size;
            if (_bFrist)
            {
                _bFrist = false;
                _pScrollView.contentOffset = CGPointMake(0, (_pScrollViewIn.frame.size.height - _WuKouDrawRect.size.height) / 2);
            }
        }
        else
        {
            _pScrollViewIn.nAmount = _TrendpriceData->m_nUnit;
            _btnWuKou.yestitle = @"五档";
            _btnWuKou.notitle = @"五档";
            [_btnWuKou setTztTitle:@"五档"];
            _pScrollViewIn.frame = CGRectMake(0, 0, _WuKouDrawRect.size.width, _WuKouDrawRect.size.height);
            _pScrollView.contentSize = _pScrollViewIn.frame.size;
            _pScrollView.contentOffset = CGPointMake(0, 0);
            [_pScrollViewIn setNeedsDisplay];
        }
    }
    else
    {
        _pScrollViewIn.nAmount = _TrendpriceData->m_nUnit;
        _btnWuKou.yestitle = @"五档";
        _btnWuKou.notitle = @"五档";
        [_btnWuKou setTztTitle:@"五档"];
        _pScrollViewIn.frame = CGRectMake(0, 0, _WuKouDrawRect.size.width, _WuKouDrawRect.size.height);
        _pScrollView.contentSize = _pScrollViewIn.frame.size;
        _pScrollView.contentOffset = CGPointMake(0, 0);
    }
    [_pScrollViewIn setNeedsDisplay];
    
    return;
}

- (void)onDrawIndexPrice:(CGContextRef)context
{
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    UIColor* axisColor = [UIColor tztThemeHQFixTextColor];// [tztTechSetting getInstance].axisTxtColor;
    
    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
    CGPoint drawpoint = _PriceDrawRect.origin;
    
    NSString* strPrice = @"昨收|开盘|振幅|成交额|委比|委差|委买手数|委卖手数|上涨家数|平盘家数|下跌家数";
    NSArray* ay = [strPrice componentsSeparatedByString:@"|"];
    CGFloat fHeight = (CGRectGetHeight(_PriceDrawRect)) / [ay count];
    if (fHeight > tztMaxLineHeight)
        fHeight = tztMaxLineHeight;
    CGSize drawsize = [@"昨收" sizeWithFont:drawFont];
    CGFloat fDif = (fHeight - drawsize.height) / 2;
    UIColor* drawColor = [UIColor tztThemeHQFixTextColor];// [tztTechSetting getInstance].fixTxtColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    if (IS_TZTIPAD)
        drawpoint.x = 10;
    for (int i = 0; i < [ay count]; i++)
    {
        NSString* strCaption = [ay objectAtIndex:i];
        [strCaption drawAtPoint:drawpoint withFont:drawFont];
        drawpoint.y += fHeight;
    }
    drawpoint.y = _PriceDrawRect.origin.y +fDif; 
    CGFloat maxX = CGRectGetMaxX(_PriceDrawRect);
    if (IS_TZTIPAD)
        maxX -= 10;
    //昨收
    NSString* strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Close_p,0,_TrendpriceData->nDecimal,1000);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //开盘
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Open_p,0,_TrendpriceData->nDecimal,1000);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Open_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Open_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    
    //振幅
    drawColor = axisColor;
    strValue = [NSString stringWithFormat:@"%.2f%%",_TrendpriceData->m_lMaxUpIndex / 100.f];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    
    //成交额
    strValue =  NStringOfFloat(_TrendpriceData->Total_m * 100);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委比
    long BuyCount = _TrendpriceData->a.indexData.buy_h;
    
    long SellCount = _TrendpriceData->a.indexData.sale_h;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
    long lBi= _TrendpriceData->m_nWB;
    drawColor = balanceColor;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
        if ( lBi> 0 )
        {
//            lBi = (long)(lWeiBi+0.5);
            drawColor = upColor;
        }
        else if (lBi == 0)
        {
        }
        else
        {
//            lBi = (long)(lWeiBi-0.5);
            drawColor = downColor;
        }
//    }
    
    strValue = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委差
    long lWeiCa = _TrendpriceData->m_nWC;// A;
    strValue = [NSString stringWithFormat:@"%ld",lWeiCa];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委买手数
    strValue =  NStringOfULong(BuyCount);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, upColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委卖手数
    strValue =  NStringOfULong(SellCount);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, downColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //上涨家数
    strValue =  NStringOfULong(_TrendpriceData->a.indexData.ups);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, upColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    //平盘家数
    if (_TrendpriceData->a.indexData.totals -
        _TrendpriceData->a.indexData.ups -
        _TrendpriceData->a.indexData.downs > 0)
    {
        strValue =  NStringOfULong(_TrendpriceData->a.indexData.totals -
                               _TrendpriceData->a.indexData.ups -
                               _TrendpriceData->a.indexData.downs );
    }
    else
    {
        strValue = @"-";
    }
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, balanceColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    //下跌家数
    strValue =  NStringOfULong(_TrendpriceData->a.indexData.downs);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, downColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
}

- (void)onDrawHKPrice:(CGContextRef)context
{
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    
    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
    CGPoint drawpoint = _PriceDrawRect.origin;
    int nHand = 1;//100000;
    int nUnit = 1000;
    if (self.pStockInfo)
    {
        if (self.pStockInfo.stockType == HK_INDEX_BOURSE)
            nUnit = 1000;
    }
    else
    {
        return;
//        if (_stockType == HK_INDEX_BOURSE)
//            nUnit = 1000;
    }
    NSString* strPrice = @"均价|现量|总量|量比|委比|委差|IEP|IEV";
    NSArray* ay = [strPrice componentsSeparatedByString:@"|"];
    CGFloat fHeight = CGRectGetHeight(_PriceDrawRect) / [ay count];
    if (fHeight > tztMaxLineHeight)
        fHeight = tztMaxLineHeight;
    CGSize drawsize = [@"均价" sizeWithFont:drawFont];
    CGFloat fDif = (fHeight - drawsize.height) / 2;
    UIColor* drawColor = [UIColor tztThemeHQFixTextColor];// [tztTechSetting getInstance].fixTxtColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    if (IS_TZTIPAD)
        drawpoint.x = 10;
    drawpoint.y = _PriceDrawRect.origin.y;
    for (int i = 0; i < [ay count]; i++)
    {
        drawpoint.y += fDif;
        NSString* strCaption = [ay objectAtIndex:i];
        [strCaption drawAtPoint:drawpoint withFont:drawFont];
        drawpoint.y += fHeight - fDif;
    }
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    CGFloat maxX = CGRectGetMaxX(_PriceDrawRect);
    if (IS_TZTIPAD)
        maxX -= 10;
    //均价
    NSString* strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lAvgPrice,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->m_lAvgPrice > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->m_lAvgPrice < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //现手
    drawColor = [UIColor tztThemeHQBalanceColor];// [tztTechSetting getInstance].axisTxtColor;
    strValue = NStringOfULong(_TrendpriceData->a.StockData.Last_h / nHand);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //总手
    strValue = NStringOfULong(_TrendpriceData->Total_h / nHand);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //量比
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lLiangbi, 0, 2, 100);//
    //NStringOfLong(_TrendpriceData->m_lLiangbi);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委比
//    long BuyCount = _TrendpriceData->a.StockData.Q1+
//    _TrendpriceData->a.StockData.Q2 +
//    _TrendpriceData->a.StockData.Q3 +
//    _TrendpriceData->a.StockData.Q7 +
//    _TrendpriceData->a.StockData.Q8;
//    
//    long SellCount = _TrendpriceData->a.StockData.Q4+
//    _TrendpriceData->a.StockData.Q5 +
//    _TrendpriceData->a.StockData.Q6 +
//    _TrendpriceData->a.StockData.Q9 +
//    _TrendpriceData->a.StockData.Q10;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
    long lBi= _TrendpriceData->m_nWB;
    drawColor = balanceColor;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
        if ( lBi> 0 )
        {
//            lBi = (long)(lWeiBi+0.5);
            drawColor = upColor;
        }
        else if (lBi == 0)
        {
        }
        else
        {
//            lBi = (long)(lWeiBi-0.5);
            drawColor = downColor;
        }
//    }
    
    strValue = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委差
    long lWeiCa = _TrendpriceData->m_nWC;// (A / nHand);
    strValue = [NSString stringWithFormat:@"%ld",lWeiCa];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //IEP
    drawColor = upColor;
    strValue = NStringOfULong(_TrendpriceData->m_lOutside);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //IEV
    drawColor = downColor;
    strValue = NStringOfULong(_TrendpriceData->m_lInside);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
}

- (void)onDrawQHPrice:(CGContextRef)context
{
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    UIColor* axisColor = [UIColor tztThemeHQAxisTextColor];// [tztTechSetting getInstance].axisTxtColor;
    
    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
    CGPoint drawpoint = _PriceDrawRect.origin;
    int nUnit = 1000;
    NSString* strPrice = @"前结|开盘|最高|最低|委比|委差|卖价|买价|总手|现手|日增|持仓|内盘|外盘|";
//    NSString* strPrice = @"前结|结算|开盘|最高|最低|总手|日增|涨停|外盘|内盘|持仓|仓差";
    NSArray* ay = [strPrice componentsSeparatedByString:@"|"];
    CGFloat fHeight = (CGRectGetHeight(_PriceDrawRect)) / [ay count];
    if (fHeight > tztMaxLineHeight)
        fHeight = tztMaxLineHeight;
    CGSize drawsize = [@"前结" sizeWithFont:drawFont];
    CGFloat fDif = (fHeight - drawsize.height) / 2;
    UIColor* drawColor = [UIColor tztThemeHQFixTextColor];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    if (IS_TZTIPAD)
        drawpoint.x = 10;
    for (int i = 0; i < [ay count]; i++)
    {
        NSString* strCaption = [ay objectAtIndex:i];
        [strCaption drawAtPoint:drawpoint withFont:drawFont];
        drawpoint.y += fHeight;
    }
    drawpoint.y = _PriceDrawRect.origin.y +fDif; 
    
    //前结
    NSString* strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p8,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->a.StockData.p8 > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->a.StockData.p8 < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    int nHand = 100;
    
    if (MakeWPMarket(self.pStockInfo.stockType))
    {
        nHand = 10000;
    }
#if 0
    //结算
    
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lAvgPrice,0,_TrendpriceData->nDecimal,nUnit);
    drawColor = balanceColor;
    if(_TrendpriceData->m_lAvgPrice > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->m_lAvgPrice < _TrendpriceData->Close_p)
        drawColor = downColor;
    if(MakeWPMarket(self.pStockInfo.stockType))
    {
        drawColor = balanceColor;
        strValue = @"-";
    }
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
#endif
    
    //开盘
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Open_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Open_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Open_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    
    //最高
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->High_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->High_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->High_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    
    //最低
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Low_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Low_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Low_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委比
//    long BuyCount = _TrendpriceData->a.StockData.Q1;
    
//    long SellCount = _TrendpriceData->a.StockData.Q4;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
    long lBi= _TrendpriceData->m_nWB;
    drawColor = balanceColor;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
        if ( lBi> 0 )
        {
//            lBi = (long)(lWeiBi+0.5);
            drawColor = upColor;
        }
        else if (lBi == 0)
        {
        }
        else
        {
//            lBi = (long)(lWeiBi-0.5);
            drawColor = downColor;
        }
//    }
    
    strValue = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    drawsize = [strValue sizeWithFont:drawFont];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委差
    long lWeiCa = _TrendpriceData->m_nWC;// (A / nHand);
    strValue = [NSString stringWithFormat:@"%ld",lWeiCa];
    drawsize = [strValue sizeWithFont:drawFont];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //卖价
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p4,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Low_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Low_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //买价
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p1,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Low_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Low_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //总手
    drawColor = [UIColor tztThemeHQBalanceColor];
    strValue = NStringOfULong(_TrendpriceData->Total_h / nHand);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //现手
    strValue = NStringOfULong(_TrendpriceData->a.StockData.Last_h/nHand);
    drawColor = axisColor;
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //日增
//    drawColor = [tztTechSetting getInstance].axisTxtColor;
    strValue = NStringOfLong(_TrendpriceData->a.StockData.p7/nHand);
    drawColor = balanceColor;
    if(_TrendpriceData->a.StockData.p7 > 0)
        drawColor = upColor;
    else if(_TrendpriceData->a.StockData.p7 < 0)
        drawColor = downColor;
    
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //总持
    strValue = NStringOfULong(_TrendpriceData->a.StockData.p2/nHand);
    drawColor = axisColor;
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
#if 0
    //仓差
    strValue = NStringOfLong((_TrendpriceData->a.StockData.p2 - _TrendpriceData->a.StockData.p3)/nHand);
    drawColor = balanceColor;
    if(_TrendpriceData->a.StockData.p2 > _TrendpriceData->a.StockData.p3)
        drawColor = upColor;
    else if(_TrendpriceData->a.StockData.p2 < _TrendpriceData->a.StockData.p3)
        drawColor = downColor;
    
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;

    //涨停
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.Q8,0,_TrendpriceData->nDecimal,nUnit);
    drawColor = balanceColor;
    if(_TrendpriceData->a.StockData.Q8 > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->a.StockData.Q8 < _TrendpriceData->Close_p)
        drawColor = downColor;
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
#endif
    
    //内盘
    strValue = NStringOfULong(_TrendpriceData->a.StockData.P5/nHand);
    drawColor = downColor;
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //外盘
    strValue = NStringOfULong(_TrendpriceData->a.StockData.P6/nHand);
    drawColor = upColor;
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
}

- (void)onDrawWHPrice:(CGContextRef)context
{
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    UIColor* axisColor = [UIColor tztThemeHQAxisTextColor];//
    
    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
    CGPoint drawpoint = _PriceDrawRect.origin;
    int nUnit = 10000;
    
    NSString* strPrice = @"昨收|开盘|最高|最低|振幅|卖价|买价";
//    NSString* strPrice = @"最新|涨跌|涨幅|最高|最低|开盘|昨收|振幅|卖价|买价";//最高|最低|开盘|昨收|振幅
    NSArray* ay = [strPrice componentsSeparatedByString:@"|"];
    CGFloat fHeight = (CGRectGetHeight(_PriceDrawRect)) / [ay count];
    if (fHeight > tztMaxLineHeight)
        fHeight = tztMaxLineHeight;
    CGSize drawsize = [@"最新" sizeWithFont:drawFont];
    CGFloat fDif = (fHeight - drawsize.height) / 2;
    UIColor* drawColor = [UIColor tztThemeHQFixTextColor];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    if (IS_TZTIPAD)
        drawpoint.x = 10;
    for (int i = 0; i < [ay count]; i++)
    {
        NSString* strCaption = [ay objectAtIndex:i];
        [strCaption drawAtPoint:drawpoint withFont:drawFont];
        drawpoint.y += fHeight;
    }
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    
    CGFloat maxX = CGRectGetMaxX(_PriceDrawRect);
    if (IS_TZTIPAD)
        maxX -= 10;
    
    //昨收
    NSString* strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Close_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //开盘
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Open_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Open_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Open_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    
    //最高
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->High_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->High_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->High_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //最低
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Low_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Low_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Low_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    
    
    //振幅
    drawColor = axisColor;
    strValue = [NSString stringWithFormat:@"%.2f%%",_TrendpriceData->m_lMaxUpIndex / 100.f];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //卖价
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p4,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->a.StockData.p4 > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->a.StockData.p4 < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //买价
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p1,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->a.StockData.p1 > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->a.StockData.p1 < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;

#if 0
    //最新
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Last_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Last_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Last_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight; 
    
    //涨跌
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Last_p - _TrendpriceData->Close_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //涨幅
    if(_TrendpriceData->Close_p != 0)
        strValue = [NSString stringWithFormat:@"%.2f%%",(_TrendpriceData->Last_p - _TrendpriceData->Close_p) * 100.f / _TrendpriceData->Close_p];
    else 
        strValue = @"-";
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
#endif
}

- (void)onDrawWPPrice:(CGContextRef)context
{
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    UIColor* axisColor = [UIColor tztThemeHQAxisTextColor];
    
    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
    CGPoint drawpoint = _PriceDrawRect.origin;
    int nUnit = 1000;
    
    int nHand = 10000;
    
    NSString* strPrice = @"昨收|开盘|振幅|成交|委比|委差|委买手数|委卖手数|上涨家数|平盘家数|下跌家数";
    NSArray* ay = [strPrice componentsSeparatedByString:@"|"];
    CGFloat fHeight = (CGRectGetHeight(_PriceDrawRect)) / [ay count];
    if (fHeight > tztMaxLineHeight)
        fHeight = tztMaxLineHeight;
    CGSize drawsize = [@"昨收" sizeWithFont:drawFont];
    CGFloat fDif = (fHeight - drawsize.height) / 2;
    UIColor* drawColor = [UIColor tztThemeHQFixTextColor];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    if (IS_TZTIPAD)
        drawpoint.x = 10;
    for (int i = 0; i < [ay count]; i++)
    {
        NSString* strCaption = [ay objectAtIndex:i];
        [strCaption drawAtPoint:drawpoint withFont:drawFont];
        drawpoint.y += fHeight;
    }
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    CGFloat maxX = CGRectGetMaxX(_PriceDrawRect);
    if (IS_TZTIPAD)
        maxX -= 10;
    
    //昨收
    NSString* strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Close_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //开盘
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Open_p,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Open_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Open_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //振幅
    drawColor = axisColor;
    strValue = [NSString stringWithFormat:@"%.2f%%",_TrendpriceData->m_lMaxUpIndex / 100.f];
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //成交
    strValue = NStringOfULong(_TrendpriceData->Total_h / nHand);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委比
    long BuyCount = _TrendpriceData->a.indexData.buy_h;
    long SellCount = _TrendpriceData->a.indexData.sale_h;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
    long lBi= _TrendpriceData->m_nWB;
    drawColor = balanceColor;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
        if ( lBi> 0 )
        {
//            lBi = (long)(lWeiBi+0.5);
            drawColor = upColor;
        }
        else if (lBi == 0)
        {
        }
        else
        {
//            lBi = (long)(lWeiBi-0.5);
            drawColor = downColor;
        }
//    }
    
    strValue = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    drawsize = [strValue sizeWithFont:drawFont];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委差
    long lWeiCa = _TrendpriceData->m_nWC;// (A / nHand);
    strValue = [NSString stringWithFormat:@"%ld",lWeiCa];
    drawsize = [strValue sizeWithFont:drawFont];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委买手数
    strValue =  NStringOfULong(BuyCount);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, upColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //委卖手数
    strValue =  NStringOfULong(SellCount);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, downColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    
    //上涨家数
    strValue =  NStringOfULong(_TrendpriceData->a.indexData.ups);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, upColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    //平盘家数
    if (_TrendpriceData->a.indexData.totals -
        _TrendpriceData->a.indexData.ups -
        _TrendpriceData->a.indexData.downs > 0)
    {
        strValue =  NStringOfULong(_TrendpriceData->a.indexData.totals -
                                   _TrendpriceData->a.indexData.ups -
                                   _TrendpriceData->a.indexData.downs );
    }
    else
    {
        strValue = @"-";
    }
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, balanceColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
    //下跌家数
    strValue =  NStringOfULong(_TrendpriceData->a.indexData.downs);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = maxX - drawsize.width - 1;
    CGContextSetFillColorWithColor(context, downColor.CGColor);
    [strValue drawAtPoint:drawpoint withFont:drawFont];
    drawpoint.y += fHeight;
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    [super onSetViewRequest:bRequest];
    if (_pDetailView)
        [_pDetailView onSetViewRequest:bRequest];
}

-(void)setBHoriShow:(BOOL)bHoriShow
{
    _bHoriShow = bHoriShow;
    if (self.pDetailView)
        self.pDetailView.bShowSeconds = bHoriShow;
}

-(void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    [_pStockInfo release];
    _pStockInfo = [pStockInfo retain];
    
    if (MakeUSMarket(pStockInfo.stockType))
    {
        if (_pDetailView == NULL)
        {
            _pDetailView = [[tztDetailView alloc] init];
            _pDetailView.bGridLines = NO;
            _pDetailView.pDrawFont = tztUIBaseViewTextFont(9.f);
            _pDetailView.fCellHeight = 10;
            _pDetailView.fTopCellHeight = 18;
            if (g_bUseHQAutoPush)
                _pDetailView.bAutoPush = YES;
            _pDetailView.hidden = YES;
            [self addSubview:_pDetailView];
            [_pDetailView release];
        }
        self.pDetailView.hidden = NO;
    }
    else
    {
        self.pDetailView.hidden = YES;
    }
    
    self.pDetailView.bShowSeconds = (_bHoriShow ? YES:NO);
    if (self.pDetailView)
    {
        if ([pStockInfo.stockCode caseInsensitiveCompare:self.pDetailView.pStockInfo.stockCode] != NSOrderedSame)
        {
            [self.pDetailView ClearGridData];
        }
        [self.pDetailView setStockInfo:pStockInfo Request:!self.pDetailView.hidden];
    }
    
}

//绘制报价图
- (void)onDrawPrice:(CGContextRef)context rect:(CGRect)rect
{
    _pScrollView.hidden = YES;
    _pDetailView.hidden = YES;
    CGContextSaveGState(context);
    [self drawBackGroundRect:(CGContextRef)context rect:rect];
    if (IS_TZTIPAD)
        [self onDrawNewPrice:context];
    if(MakeIndexMarket(self.pStockInfo.stockType))
    {
        _btnPrice.hidden = YES;
        _btnWuKou.hidden = YES;
        [self onDrawIndexPrice:context];
    }
    else if(MakeStockMarket(self.pStockInfo.stockType))
    {
        if(_tztPriceStyle == TrendPriceTwo)
        {
            _btnPrice.hidden = YES;
            _btnWuKou.hidden = YES;
//            _PriceDrawRect.size.height = _PriceDrawRect.size.height / 2;
//            _WuKouDrawRect = _PriceDrawRect;
//            _PriceDrawRect.origin.y += _PriceDrawRect.size.height;
            _PriceDrawRect.size.height = _PriceDrawRect.size.height / 5 * 2;
            _WuKouDrawRect = _PriceDrawRect;
            _PriceDrawRect.origin.y += _PriceDrawRect.size.height;
            _PriceDrawRect.size.height = _PriceDrawRect.size.height / 2 * 3;
            
            CGContextSaveGState(context);
            UIColor* HideGridColor = [UIColor tztThemeHQHideGridColor];
            UIColor* backgroundColor = [UIColor tztThemeBackgroundColorHQ];
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextSetStrokeColorWithColor(context, HideGridColor.CGColor);
            CGContextAddRect(context, _PriceDrawRect);
            CGContextAddRect(context, _WuKouDrawRect);
            CGContextDrawPath(context, kCGPathFillStroke);
            CGContextStrokePath(context); 
            CGContextRestoreGState(context);
            
            [self onDrawStockWuKou:context];
            [self onDrawStockPrice:context];
            _pScrollView.layer.borderWidth = .5f;
            _pScrollView.layer.borderColor = HideGridColor.CGColor;
        }
        else
        {
            if (g_pSystermConfig.bWudangOnly) {
                _btnPrice.hidden = YES;
                _btnWuKou.hidden = YES;
                _bPrice = NO;
            }
            else {
                _btnPrice.hidden = NO;
                _btnWuKou.hidden = NO;
                _PriceDrawRect.origin.y += _btnPrice.frame.size.height;
                _PriceDrawRect.size.height -= _btnPrice.frame.size.height;
            }
            _WuKouDrawRect = _PriceDrawRect;
            if(_bPrice)
            {
                [self onDrawStockPrice:context];
            }
            else
            {
                [self onDrawStockWuKou:context];
            }
        }
        
    }
    else if(MakeHKMarket(self.pStockInfo.stockType))
    {
        if(_tztPriceStyle == TrendPriceTwo)
        {
            _btnPrice.hidden = YES;
            _btnWuKou.hidden = YES;
            _PriceDrawRect.size.height = _PriceDrawRect.size.height / 5 * 2 - 2;
            _WuKouDrawRect = _PriceDrawRect;
            _PriceDrawRect.origin.y += _PriceDrawRect.size.height + 2;
            _PriceDrawRect.size.height = _PriceDrawRect.size.height / 2 * 3;
            
            
            CGContextSaveGState(context);
            UIColor* HideGridColor = [UIColor tztThemeHQHideGridColor];
            UIColor* backgroundColor = [UIColor tztThemeBackgroundColorHQ];
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextSetStrokeColorWithColor(context, HideGridColor.CGColor);
            CGContextAddRect(context, _PriceDrawRect);
            CGContextDrawPath(context, kCGPathFillStroke);
            CGContextStrokePath(context); 
            CGContextRestoreGState(context);
            
            if (MakeHKMarketStock(self.pStockInfo.stockType))
                [self onDrawStockWuKou:context];
            [self onDrawHKPrice:context];
            
        }
        else
        {
//            if (g_pSystermConfig.bWudangOnly) {
//                _btnPrice.hidden = YES;
//                _btnWuKou.hidden = YES;
//                _bPrice = NO;
//            }
//            else
            
            if (!MakeHKMarketStock(self.pStockInfo.stockType)
                || g_pSystermConfig.bWudangOnly)//港股个股
            {
                _btnPrice.hidden = YES;
                _btnWuKou.hidden = YES;
                _bPrice = NO;
            }
            else
            {
                _btnPrice.hidden = NO;
                _btnWuKou.hidden = NO;
                _PriceDrawRect.origin.y += _btnPrice.frame.size.height;
                _PriceDrawRect.size.height -= _btnPrice.frame.size.height;
            }
            _WuKouDrawRect = _PriceDrawRect;
            if(_bPrice)
            {
                [self onDrawHKPrice:context];
            }
            else
            {
                [self onDrawStockWuKou:context];
            }
        }
    }
    else if(MakeQHMarket(self.pStockInfo.stockType))
    {
        _btnPrice.hidden = YES;
        _btnWuKou.hidden = YES;
        if (MakeMainMarket(self.pStockInfo.stockType) == (HQ_FUTURES_MARKET|HQ_SELF_BOURSE|0x0060))
        {
            [self onDrawStockPrice:context];
        }
        else
            [self onDrawQHPrice:context];
    }
    else if(MakeWPMarket(self.pStockInfo.stockType))
    {
        _btnPrice.hidden = YES;
        _btnWuKou.hidden = YES;
        if ((self.pStockInfo.stockType == WP_INDEX)
            || (MakeMidMarket(self.pStockInfo.stockType) == HQ_WP_INDEX)
            )
        {
            [self onDrawWPPrice:context];
        }
        else
        {
            //国金的需要显示美股个股的买卖价和明细数据，增加宏定义控制，后续其他券商需要增加直接开启定义即可
            if (g_nWPDetailPrice)
                [self onDrawWPStockData:context];
            else
                [self onDrawQHPrice:context];
        }
    }
    else if(MakeWHMarket(self.pStockInfo.stockType))
    {
        _btnPrice.hidden = YES;
        _btnWuKou.hidden = YES;
        [self onDrawWHPrice:context];
    }
    CGContextRestoreGState(context);
}

-(void)onDrawWPStockData:(CGContextRef)context
{
    self.pDetailView.hidden = NO;
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
//    UIColor* axisColor = [UIColor tztThemeHQAxisTextColor];// [tztTechSetting getInstance].axisTxtColor;
    
//    UIFont* drawFont = [tztTechSetting getInstance].drawTxtFont;
    UIFont* drawFont = [UIFont tztThemeHQWudangFont];// [tztTechSetting getInstance].drawTxtFont;
    CGPoint drawpoint = _PriceDrawRect.origin;
    int nUnit = 1000;
    NSString* strPrice = @" 卖1| 买1|";
    NSArray* ay = [strPrice componentsSeparatedByString:@"|"];
    CGFloat fHeight = (CGRectGetHeight(_PriceDrawRect)) / [ay count];
    if (fHeight > drawFont.lineHeight + 2)
        fHeight = drawFont.lineHeight + 2;
    CGSize drawsize = [@" 卖1" sizeWithFont:drawFont];
    CGFloat fDif =2;// (fHeight - drawsize.height) / 2;
    UIColor* drawColor = [UIColor tztThemeHQFixTextColor];
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    drawpoint.x = 2;
    if (IS_TZTIPAD)
        drawpoint.x = 10;
    for (int i = 0; i < [ay count]; i++)
    {
        NSString* strCaption = [ay objectAtIndex:i];
        [strCaption drawAtPoint:drawpoint withFont:drawFont];
        drawpoint.y += fHeight;
    }
    drawpoint.y = _PriceDrawRect.origin.y +fDif;
    
    int nHand = 1;
    
//    if (MakeWPMarket(self.pStockInfo.stockType))
//    {
//        nHand = 10000;
//    }
    
    CGSize Fixsize = [@"卖5" sizeWithFont:drawFont];
    
    CGFloat maxX = CGRectGetMaxX(_PriceDrawRect);
    CGFloat minX = CGRectGetMinX(_PriceDrawRect);
    
    
    int nWidth = (maxX - Fixsize.width) / 2 - 3;
    int nHeight = drawFont.lineHeight;
    
    UIColor* VolColor = [UIColor tztThemeHQBalanceColor];
    CGRect rcDraw;

        
    //卖价
    NSString* strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p4,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = CGRectGetMaxX(_PriceDrawRect) - drawsize.width - 1;
    drawColor = balanceColor;
    if(_TrendpriceData->Low_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Low_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    drawpoint.x = minX + Fixsize.width;
    rcDraw = CGRectMake(drawpoint.x, drawpoint.y, nWidth, nHeight);
    [strValue drawInRect:rcDraw
                withFont:drawFont
           lineBreakMode:NSLineBreakByCharWrapping
               alignment:NSTextAlignmentRight];
    
    strValue = NStringOfULong(_TrendpriceData->a.StockData.Q4 / nHand);
    drawsize = [strValue sizeWithFont:drawFont];
    rcDraw.origin.x += rcDraw.size.width + 3;
    CGContextSetFillColorWithColor(context, VolColor.CGColor);
    [strValue drawInRect:rcDraw
                withFont:drawFont
           lineBreakMode:NSLineBreakByCharWrapping
               alignment:NSTextAlignmentRight];
    drawpoint.y += fHeight;
    rcDraw.origin.y = drawpoint.y;
    
    
    //买价
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->a.StockData.p1,0,_TrendpriceData->nDecimal,nUnit);
    drawsize = [strValue sizeWithFont:drawFont];
    drawpoint.x = minX + Fixsize.width;
    drawColor = balanceColor;
    if(_TrendpriceData->Low_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Low_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    rcDraw.origin.x = drawpoint.x;
    [strValue drawInRect:rcDraw
                withFont:drawFont
           lineBreakMode:NSLineBreakByCharWrapping
               alignment:NSTextAlignmentRight];
    
    strValue = NStringOfULong(_TrendpriceData->a.StockData.Q1 / nHand);
    drawsize = [strValue sizeWithFont:drawFont];
    rcDraw.origin.x += rcDraw.size.width + 3;
    CGContextSetFillColorWithColor(context, VolColor.CGColor);
    [strValue drawInRect:rcDraw
                withFont:drawFont
           lineBreakMode:NSLineBreakByCharWrapping
               alignment:NSTextAlignmentRight];
    drawpoint.y += fHeight;
    rcDraw.origin.y = drawpoint.y;
    
    //下面是明细数据
    
    CGRect rcDetail = self.bounds;
    rcDetail.origin.y = drawpoint.y + fDif;
    rcDetail.size.height -= (drawpoint.y + fDif);
    self.pDetailView.frame = rcDetail;
}

//绘制最新价
-(void)onDrawNewPrice:(CGContextRef)context
{
    UIColor *upColor = [UIColor tztThemeHQUpColor];
    UIColor *downColor = [UIColor tztThemeHQDownColor];
    UIColor *balanceColor = [UIColor tztThemeHQBalanceColor];
    UIColor *drawColor;
    
    int nUnit = 1000;
    if (MakeHKMarket(self.pStockInfo.stockType))
    {
//        nUnit = 10; // 不除10 byDBQ20130922
        if (self.pStockInfo.stockType == HK_INDEX_BOURSE)
            nUnit = 1000;
    }
    else if(MakeWHMarket(self.pStockInfo.stockType))
    {
        nUnit = 10000;
    }
    
    //最新价
    NSString* strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->Last_p,0,_TrendpriceData->nDecimal,nUnit);
    drawColor = balanceColor;
    if(_TrendpriceData->Last_p > _TrendpriceData->Close_p)
        drawColor = upColor;
    else if(_TrendpriceData->Last_p < _TrendpriceData->Close_p)
        drawColor = downColor;
    CGContextSetFillColorWithColor(context, drawColor.CGColor);
    [strValue drawAtPoint:CGPointZero withFont:tztUIBaseViewTextFont(40.f)];
    
    //涨跌
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lUpPrice,0,_TrendpriceData->nDecimal,nUnit);
    [strValue drawAtPoint:CGPointMake(185, 0) withFont:tztUIBaseViewTextFont(15.0f)];
    
    //涨跌幅
    strValue = NSStringOfVal_Ref_Dec_Div(_TrendpriceData->m_lUpIndex,0,_TrendpriceData->nDecimal,100);
    strValue = [strValue stringByAppendingString:@"%"];
    [strValue drawAtPoint:CGPointMake(175, 20) withFont:tztUIBaseViewTextFont(18.0f)];
    
    CGContextSetStrokeColorWithColor(context,[UIColor tztThemeHQGridColor].CGColor);
    CGContextMoveToPoint(context, _NewPriceDrawRect.origin.x, _NewPriceDrawRect.origin.y +_NewPriceDrawRect.size.height);
    CGContextAddLineToPoint(context, CGRectGetMaxX(_NewPriceDrawRect)-1,_NewPriceDrawRect.origin.y +_NewPriceDrawRect.size.height);
    CGContextStrokePath(context);
}

#pragma 报价数据处理
- (void)onClearData
{
    [super onClearData];
    memset(_TrendpriceData, 0x00, sizeof(TNewPriceData));
}

- (void)setPriceData:(TNewPriceData*)priceData len:(int)nLen
{
    memset(_TrendpriceData, 0x00, sizeof(TNewPriceData));
    memcpy(_TrendpriceData, priceData, nLen);
}


- (void)setPriceDataEx:(TNewPriceDataEx*)priceDataEx len:(int)nLen
{
    memset(_TrendpriceDataEx, 0x00, sizeof(TNewPriceDataEx));
    memcpy(_TrendpriceDataEx, priceDataEx, nLen);
    
}

- (void)setTechHeadData:(TNewKLineHead*)techHead len:(int)nLen
{
    memset(_techData, 0x00, sizeof(TNewKLineHead));
    memcpy(_techData, techHead, nLen);
}


- (TNewPriceData*)getPriceData
{
    return _TrendpriceData;
}

- (TNewPriceDataEx*)getPriceDataEx
{
    return _TrendpriceDataEx;
}

#pragma 请求数据
- (void)onRequestData:(BOOL)bShowProcess
{
    if (_bRequest)
    {
        if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
        {
            TZTNSLog(@"%@", @"报价请求－－－股票代码有误！！！");
            return;
//            self.stockCode = @"600570";
        }
//        Reqno|MobileCode|MobileType|Cfrom|Tfrom|Token|ZLib|StockCode|Level|AccountIndex|        
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        [sendvalue setTztObject:@"2" forKey:@"AccountIndex"];
        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
        [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
        
        if (MakeHKMarketStock(self.pStockInfo.stockType))
        {
            [sendvalue setTztObject:@"2" forKey:@"level"];
//            //华泰港股通专用
//#ifdef Support_HKHQTen
//            self.nsAccount = @"";
//            tztZJAccountInfo *pZJAccount = tztGetCurrentAccountHKRight();
//            if (pZJAccount)
//            {
//                if (pZJAccount.nsAccount && pZJAccount.nsAccount.length > 0)
//                {
//                    self.nsAccount = [NSString stringWithFormat:@"%@", pZJAccount.nsAccount];//记录下请求的账号和接收回来的账号进行比较，对权限要根据账号区分
//                    [sendvalue setTztObject:pZJAccount.nsAccount forKey:@"Account"];
//                }
//                if (pZJAccount.Ggt_rights && pZJAccount.Ggt_rights.length > 0)
//                    [sendvalue setTztObject:pZJAccount.Ggt_rights forKey:@"Ggt_rights"];
//                if (pZJAccount.Ggt_rightsEndDate && pZJAccount.Ggt_rightsEndDate.length > 0)
//                    [sendvalue setTztObject:pZJAccount.Ggt_rightsEndDate forKey:@"Ggt_rightsEndDate"];
//            }
//#endif
            
        }
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"43" withDictValue:sendvalue];
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
    if([parse GetAction] == 43)
    {
        if(![parse IsIphoneKey:(long)self reqno:_ntztHqReq])
        {
            return 0;
        }
//        self.pStockInfo.stockType =  0;
        NSString* DataStockType = [parse GetValueData:@"NewMarketNo"];
        if (DataStockType == NULL || DataStockType.length < 1)
            DataStockType = [parse GetValueData:@"stocktype"];
        if(DataStockType && [DataStockType length] > 0)
        {
            self.pStockInfo.stockType = [DataStockType intValue];
        }
        
        NSData* DataGrid = [parse GetNSData:@"BinData"];
        NSInteger nDataLen = [DataGrid length];
        if (DataGrid && nDataLen > 0)
        {
            TNewPriceData pPriceData;
            NSString* strBase = [parse GetByName:@"BinData"];
            setTNewPriceData(&pPriceData,strBase);
            [self setPriceData:&pPriceData len:sizeof(TNewPriceData)];
        }
        
        NSString* strLevel2Bin = [parse GetByName:@"Level2Bin"];
        TNewPriceDataEx pPriceDataEx;
        setTNewPriceDataEx(&pPriceDataEx, strLevel2Bin);
        [self setPriceDataEx:&pPriceDataEx len:sizeof(TNewPriceDataEx)];

        [self setNeedsDisplay];
    }
    return 0;
}

-(void)OnSwitch
{
    //不可切换
    if (_tztPriceStyle == TrendPriceNon || _tztPriceStyle == TrendPricePriceOnly || _tztPriceStyle == TrendPriceTwo)
        return;
    
    BOOL bDeal =  FALSE;
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(OnSwitch)])
    {
        bDeal = (BOOL)[self.tztdelegate OnSwitch];
    }
    if (bDeal)
        return;
    
    _bPrice = !_bPrice;
    [_btnPrice setChecked:_bPrice];
    [_btnWuKou setChecked:!_bPrice];
    _pScrollView.hidden = _bPrice;
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self OnSwitch];
}
@end
