/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        财务数据
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztFinanceView.h"

#define		MaxFinaceDataCount	40
#define		MaxFinaceDrawHeight	30

@interface tztFinaceInView : UIView
{
    NSArray  *_ayData;
    BOOL     _bHaveFinace;
}
@property(nonatomic, retain)NSArray  *ayData;
@property BOOL bHaveFinace;
- (void)setFinaceData:(NSArray*)ayValue;
@end

@implementation tztFinaceInView
@synthesize ayData = _ayData;
@synthesize bHaveFinace = _bHaveFinace;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        self.ayData = nil;
        _bHaveFinace = FALSE;
    }
    return self;
}

-(void)dealloc
{
    self.ayData = nil;
    [super dealloc];
}

- (void)setFinaceData:(NSArray*)ayValue;
{
    self.ayData = ayValue;
    if (_ayData && [_ayData count] > 0)
    {
        _bHaveFinace = TRUE;
    }
}

//绘制底图
- (void)DrawBackground:(CGContextRef)context
{
    CGRect rcFirstCol = CGRectZero;
    rcFirstCol.size = self.frame.size;
    CGFloat _cellHeight = MaxFinaceDrawHeight;
    NSInteger nRows = 0;
    if(_ayData)
       nRows = [_ayData count];
    if (g_nUsePNGInTableGrid)
    {
        UIImage* pImgBackground = [UIImage imageTztNamed:TZTUIHQReportContentPNG];
        if (pImgBackground)
        {
            if (_cellHeight <= 0)
            {
                _cellHeight = pImgBackground.size.height;
            }
            if (_cellHeight <= 0)
            {
                _cellHeight = MaxFinaceDrawHeight;
            }
            rcFirstCol.origin.x = 0;
            rcFirstCol.origin.y = 0;
            rcFirstCol.size.height = _cellHeight;
            rcFirstCol.size.width = self.frame.size.width;
            for (int i = 0; i < nRows; i++)
            {
                [pImgBackground drawInRect:rcFirstCol];
                rcFirstCol.origin.y += _cellHeight;
            }
            return;
        }
    }
    
    UIColor *pGridCellBGEx = NULL;
    if (_cellHeight <= 0)
    {
        _cellHeight = MaxFinaceDrawHeight;
    }
    rcFirstCol.origin.x = 0;
    rcFirstCol.origin.y = 0;
    rcFirstCol.size.height = _cellHeight;
    rcFirstCol.size.width = self.frame.size.width;
    CGContextSetLineWidth(context, 1.0);
    pGridCellBGEx = [UIColor tztThemeBackgroundColorHQ];
    CGContextSetStrokeColorWithColor(context, pGridCellBGEx.CGColor);
    CGContextSetFillColorWithColor(context, pGridCellBGEx.CGColor);
    for (int i = 0; i < nRows; i++, rcFirstCol.origin.y += _cellHeight)
    {
        pGridCellBGEx = [UIColor tztThemeBackgroundColorHQ];
        CGContextSetStrokeColorWithColor(context, pGridCellBGEx.CGColor);
        CGContextSetFillColorWithColor(context, pGridCellBGEx.CGColor);
        CGContextAddRect(context, rcFirstCol);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    return;
}

//绘制财务数据
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetAlpha(context, 1);
//    CGContextSetLineWidth(context, 3.0);
    [self DrawBackground:context];
    
    UIFont *pFont = tztUIBaseViewTextFont(14.0f);// [tztTechSetting getInstance].drawTxtFont;
    NSString *text = @"暂无资讯内容";
    UIColor *textColor = [UIColor tztThemeHQFixTextColor];
    CGContextSetStrokeColorWithColor(context, textColor.CGColor);
    CGContextSetFillColorWithColor(context, textColor.CGColor);
    //计算输出高度
    CGSize szDrawSize;
    //调整输出位置
    int nBaseLine = 0;
    
    if (_bHaveFinace == FALSE || _ayData == nil || [_ayData count] < 1)
    {
        CGRect drawrect = rect;
        drawrect.origin.y += 5;
        drawrect.origin.x += 5;
        [text drawInRect:drawrect
                             withFont:pFont
                        lineBreakMode:NSLineBreakByCharWrapping
                            alignment:NSTextAlignmentLeft];
        drawrect.origin.y -= nBaseLine;
        return;
    }
    
    CGRect rcData = rect;
    rcData.size.height = MaxFinaceDrawHeight;
    
    //计算输出高度
    szDrawSize = [text sizeWithFont:pFont
                  constrainedToSize:rcData.size
                      lineBreakMode:NSLineBreakByCharWrapping/* UILineBreakModeCharacterWrap*/];
    nBaseLine = (rcData.size.height - szDrawSize.height) / 2.0 + 0.5;

//    rcData.origin.x += tztXMargin;
//    rcData.size.width -= 2 * tztXMargin;
    rcData.origin.x += 5;
    rcData.size.width -= 2 * 5;
    for (int i = 0; (i + 2) < MaxFinaceDataCount && i < [_ayData count]; i++)
    {
        NSArray *data = [_ayData objectAtIndex:i];
        NSString* strValue = [data objectAtIndex:0];
        if (strValue == nil || [strValue length] <= 0)
            continue;
        
        NSArray *ayRow = [strValue componentsSeparatedByString:@":"];
        if (ayRow == nil || [ayRow count] < 1)
            continue;
        
        text = [ayRow objectAtIndex:0];
        rcData.origin.y += nBaseLine;
        [text drawInRect:rcData
                withFont:pFont
           lineBreakMode:NSLineBreakByCharWrapping// UILineBreakModeCharacterWrap
               alignment:NSTextAlignmentLeft];
        
        text = @"";
        if ([ayRow count] > 1)
        {
            text = [ayRow objectAtIndex:1];
        }
        [text drawInRect:rcData
                withFont:pFont
           lineBreakMode:NSLineBreakByCharWrapping//UILineBreakModeCharacterWrap
               alignment:NSTextAlignmentRight];
        
        rcData.origin.y -= nBaseLine;
        rcData.origin.y += MaxFinaceDrawHeight;
    }
    
    CGContextSetStrokeColorWithColor(context, textColor.CGColor);
    CGContextSetFillColorWithColor(context, textColor.CGColor);
}
@end


@interface tztFinanceView ()
{
    UIScrollView        *_scrollView;
    tztFinaceInView     *_tztFinaceInView;
}
@property(nonatomic, retain)UIScrollView    *scrollView;
@property(nonatomic, retain)tztFinaceInView *tztFinaceInView;
@property(nonatomic,assign)BOOL bInsertToScroll;
- (void)initsubframe;
@end

@implementation tztFinanceView
@synthesize scrollView = _scrollView;
@synthesize tztFinaceInView = _tztFinaceInView;
@synthesize bInsertToScroll = _bInsertToScroll;

-(id)initWithFrame:(CGRect)frame andScroll:(BOOL)bScroll
{
    _bInsertToScroll = bScroll;
    self = [self initWithFrame:frame];
    return self;
}

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
    [super dealloc];
}

-(void)initdata
{
    [super initdata];
    if (_scrollView == NULL && !_bInsertToScroll)
    {
        _scrollView = NewObject(UIScrollView);
        _scrollView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//        _scrollView.bounces = FALSE;
        [self addSubview:_scrollView];
        [_scrollView release];
    }
    
    if (_tztFinaceInView == NULL)
    {
        _tztFinaceInView = NewObject(tztFinaceInView);
        if (!_bInsertToScroll)
            [_scrollView addSubview:_tztFinaceInView];
        else
            [self addSubview:_tztFinaceInView];
        [_tztFinaceInView release];
    }
    [self initsubframe]; 
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
}

-(void)onClearData
{
    [super onClearData];
    if (_tztFinaceInView)
    {
        [_tztFinaceInView setFinaceData:nil];
    }
}

- (void)initsubframe
{
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointMake(1, 1);
    rcFrame.size.height -= 2;
    rcFrame.size.width -= 2;
    NSInteger nDataCount = 0;
    if(_tztFinaceInView.ayData)
        nDataCount = [_tztFinaceInView.ayData count];
    if (nDataCount <= 0)
        nDataCount = 1;
    _scrollView.frame = rcFrame;
    _scrollView.contentSize = CGSizeMake(rcFrame.size.width, nDataCount*MaxFinaceDrawHeight - 2);
    rcFrame.size = CGSizeMake(rcFrame.size.width, nDataCount*MaxFinaceDrawHeight - 2);
    _tztFinaceInView.frame =rcFrame;
}

-(float)GetFinaceViewHeight
{
    return _tztFinaceInView.frame.size.height;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initsubframe];   
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    if (!IS_TZTIPAD)
        return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1);
    CGContextSaveGState(context);
    UIColor* HideGridColor = [UIColor tztThemeHQHideGridColor];
    UIColor* BackgroundColor = [UIColor tztThemeBackgroundColorHQ];
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

-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    if (_tztFinaceInView)
        [_tztFinaceInView setNeedsDisplay];
}

#pragma 请求数据
-(void)onRequestData:(BOOL)bShowProcess
{
     TZTNSLog(@"%@", @"请求财务数据");
    if (_bRequest)
    {
        if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil ||[self.pStockInfo.stockCode length] <= 0)
        {
            TZTNSLog(@"%@", @"报价请求－－－股票代码有误！！！");
            return;
        }      
        //Reqno|MobileCode|MobileType|Cfrom|Tfrom|Token|ZLib|StartPos|MaxCount|StockCode|Level|AccountIndex|
        NSMutableDictionary* sendvalue = NewObject(NSMutableDictionary);
        [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"StockCode"];
        [sendvalue setTztObject:@"0" forKey:@"StartPos"];
        [sendvalue setTztObject:@"30" forKey:@"MaxCount"];

        _ntztHqReq++;
        if(_ntztHqReq >= UINT16_MAX)
            _ntztHqReq = 1;
        NSString* strReqno = tztKeyReqno((long)self, _ntztHqReq);
        [sendvalue setTztObject:strReqno forKey:@"Reqno"];
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"37" withDictValue:sendvalue];
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
    if([parse GetAction] == 37)
    {
        if(![parse IsIphoneKey:(long)self reqno:_ntztHqReq])
        {
            return 0;
        }
        //Reqno|ErrorNo|ErrorMessage|Token|OnLineMessage|HsString|stocktype|BinData|Grid|
        if ( _tztFinaceInView)
        {
            NSArray* ayGrid = [parse GetArrayByName:@"Grid"];
            [_tztFinaceInView setFinaceData:ayGrid];
            [self initsubframe]; 
            [self setNeedsDisplay];
        }
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tzthqViewNeedsDisplay:)])
        {
            [self.tztdelegate tzthqViewNeedsDisplay:self];
        }
    }
    return 0;
}

@end
