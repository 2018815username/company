/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIHQINCenterView.m
 * 文件标识：
 * 摘    要：自定义Grid中间View
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


#import "TZTUIHQINCenterView.h"
#import "TZTUIImageDefine.h"
#import "TZTGridDataObj.h"
@interface TZTUIHQINCenterView (tztPrivate)
//初始化数据
- (void)initdata;
- (void)DrawSelectBG;
- (void)DrawBackground:(CGContextRef)context;
- (void)DrawGridLine;
- (void)DrawString;
@end

@implementation TZTUIHQINCenterView
@synthesize pDrawFont = _pDrawFont;

@synthesize delegate = _delegate;

@synthesize cellWidth = _cellWidth;
@synthesize cellHeight = _cellHeight;
@synthesize colCount = _colCount;
@synthesize rowCount = _rowCount;

@synthesize curIndexRow = _curIndexRow;

@synthesize ayGridData = _ayGridData;

@synthesize haveButton = _haveButton;
@synthesize btnImage = _btnImage;
@synthesize btnImageUp = _btnImageUp;
@synthesize btnImageDown = _btnImageDown;
@synthesize nsBackBg = _nsBackBg;
@synthesize bGridLines = _bGridLines;
@synthesize nGridType = _nGridType;
@synthesize bFirstColLeft = _bFirstColLeft;

- (id)init
{
    if(self = [super init])
    {
        [self initdata];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame])
    {
        [self initdata];
    }
    return self;
}

- (void)dealloc 
{
    self.delegate = nil;
    self.ayGridData = nil;
    
//	self.btnImage = nil;
//    self.btnImageUp = nil;
//    self.btnImageDown = nil;
    [super dealloc];
}

- (void)initdata
{
    self.backgroundColor = [UIColor clearColor];
    self.delegate = nil;
    
    self.ayGridData = nil;
    
    self.cellWidth = 0;
    self.cellHeight = 0;
    
    self.colCount = 0;
    self.rowCount = 0;
    
    self.curIndexRow = -1;
    _preIndexRow = -1;
    
    _zcDoubleClick = TRUE;
    
    self.cellWidth = TZTTABLECELLWIDTH;
    self.cellHeight = TZTTABLECELLHEIGHT;
    
    self.haveButton = FALSE;
    _btnImage = [UIImage imageTztNamed:@"TZTReportSort.png"];
    
    //增加排名涨跌背景图片
    _btnImageUp = [UIImage imageTztNamed:@"ZXJTReportUp.png"];
    _btnImageDown = [UIImage imageTztNamed:@"ZXJTReportDown.png"];
    self.nsBackBg = @"0";
}

//绘制
- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self DrawBackground:context];
    [self DrawSelectBG];
    [self DrawGridLine];
	[self DrawString];
}

//绘制底图
- (void)DrawBackground:(CGContextRef)context
{
    NSInteger nRows = _rowCount;
    if (_colCount < 1)
        return;
    
    CGRect rcFirstCol = CGRectZero;
    
    rcFirstCol.size = self.frame.size;
    if (g_nUsePNGInTableGrid && ![self.nsBackBg intValue])
    {
        UIImage* pImgBackground = [UIImage imageTztNamed:TZTUIHQReportContentPNG];
        if (pImgBackground)
        {
//            if (_cellHeight <= 0)
//            {
//                _cellHeight = pImgBackground.size.height;
//            }
            if (_cellHeight <= 0)
            {
                _cellHeight = TZTTABLECELLHEIGHT;
            }
            rcFirstCol.origin.x = 0;
            rcFirstCol.origin.y = 0;
            rcFirstCol.size.height = _cellHeight;
            rcFirstCol.size.width = self.frame.size.width;
            for (int i = 0; i < (nRows+1); i++, rcFirstCol.origin.y += _cellHeight)
            {
                [pImgBackground drawInRect:rcFirstCol];
            }
            return;
        }
    }

    UIColor *pGridCellBGEx = NULL;
    if (_cellHeight <= 0)
    {
        _cellHeight = TZTTABLECELLHEIGHT;
    }
    rcFirstCol.origin.x = 0;
    rcFirstCol.origin.y = 0;
    rcFirstCol.size.height = _cellHeight;
    rcFirstCol.size.width = self.frame.size.width;
    CGContextSetLineWidth(context, .5f);
    if (_nGridType)
        pGridCellBGEx = [UIColor tztThemeBackgroundColorJY];
    else
        pGridCellBGEx = [UIColor tztThemeBackgroundColorHQ];
//    if (![self.nsBackBg intValue])
//    {
//        pGridCellBGEx = [UIColor blackColor];
//    }
//    else
//    {
//        pGridCellBGEx = [UIColor colorWithTztRGBStr:@"240,240,240"];
    //    }
    UIColor *pColor = [UIColor tztThemeHQReportCellColor];
    UIColor *pColor2 = [UIColor tztThemeHQReportCellColorEx];
    
    if (_nGridType)
    {
        pColor = [UIColor tztThemeJYReportCellColor];
        pColor2 = [UIColor tztThemeJYReportCellColorEx];
    }
    CGContextSetStrokeColorWithColor(context, pGridCellBGEx.CGColor);
    CGContextSetFillColorWithColor(context, pGridCellBGEx.CGColor);
    for (int i = 0; i < nRows; i++, rcFirstCol.origin.y += _cellHeight)
    {
//        int n = Support_tztTradeList;
//        if (_nGridType == 0 /*|| Support_tztTradeList*/)
        {
            pGridCellBGEx = ((i % 2 == 0) ? pColor : pColor2);
        }
        CGContextSetStrokeColorWithColor(context, pGridCellBGEx.CGColor);
        CGContextSetFillColorWithColor(context, pGridCellBGEx.CGColor);
        CGContextAddRect(context, rcFirstCol);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    return;
}


//绘制选中行
- (void)DrawSelectBG
{
    if (_ayGridData == NULL || [_ayGridData count] < 1 || _curIndexRow < 0 || _curIndexRow >= [_ayGridData count])
        return;
    
    if (_colCount < 1)
        return;
    
//	_cellWidth = MAX(TZTTABLECELLWIDTH,self.frame.size.width / _colCount);
    int nMaxWidth = MAX(_cellWidth*_colCount,self.frame.size.width);
    
	UIImage* pImgSelected = [UIImage imageTztNamed:@"TZTReportContentSelect.png"];
	if (pImgSelected != NULL)
	{
		CGRect rcFirst = CGRectMake(0, 0, nMaxWidth, _cellHeight-1);
        NSInteger nRow = _curIndexRow;
        rcFirst.origin.y = _cellHeight * nRow;
        [pImgSelected drawInRect:rcFirst];
	}
	else
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		UIColor *pBackground = nil;
        if (_nGridType == 1)
//            在这里设置 基金交易选中的的背景颜色
               pBackground = [UIColor tztJYTableSelectColor];
//            pBackground = [UIColor tztThemeBackgroundColorSection];
        else
            pBackground = [UIColor tztThemeHQTableSelectColor];//		CGContextSetLineWidth(context, 1.0);
		CGContextSetStrokeColorWithColor(context, pBackground.CGColor);
		CGContextSetFillColorWithColor(context, pBackground.CGColor);
        
		CGRect rcFirst = CGRectMake(0, 0, nMaxWidth, _cellHeight);
        NSInteger nRow = _curIndexRow;
        rcFirst.origin.y = _cellHeight * nRow;
        
        CGContextAddRect(context, rcFirst);
		CGContextDrawPath(context, kCGPathFill);
	}
}


//绘制间隔线
-(void) DrawGridLine
{
    if (g_nUsePNGInTableGrid && ![self.nsBackBg intValue])
    {
        return;
    }
    if (!_bGridLines)
        return;
    NSInteger nRows = _rowCount;
    if (_colCount < 1)
        return;
    
    int nMaxWidth = _cellWidth*_colCount;
    int nMaxHeight = nRows*_cellHeight;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *pGridColor = nil;
    UIColor *pGridColorVor = nil;
    if (_nGridType == 1)
    {
        pGridColor = [UIColor tztThemeJYGridColor];
        pGridColorVor = [UIColor tztThemeJYGridColor];
    }
    else
    {
        pGridColor = [UIColor tztThemeHQGridColor];// [UIColor colorWithTztRGBStr:TZTUIBaseGridLineColor];//边框
        pGridColorVor = [UIColor tztThemeHQGridColor];// [UIColor colorWithTztRGBStr:TZTUIBaseGridLineColorVor];//竖
    }
    
    CGContextSetLineWidth(context, .5f);
    //标题
    CGRect rcFirst = CGRectZero;
    //绘制格线
    CGContextSetStrokeColorWithColor(context, pGridColor.CGColor);
    CGContextSetFillColorWithColor(context, pGridColor.CGColor);
    //横线
	UIImage *pImgContentLine = [UIImage imageTztNamed:TZTUIBaseGridContentLinePNG];
	if (g_nUsePNGInTableGrid && pImgContentLine && ![self.nsBackBg intValue])
	{
		rcFirst.origin.x = 0;
		rcFirst.origin.y = -1;
		rcFirst.size.height = 2;
		rcFirst.size.width = nMaxWidth;
		for (int i = 0; i < nRows + 1; i++, rcFirst.origin.y += _cellHeight)
		{
			[pImgContentLine drawInRect:rcFirst];    
		}
	}
	else
	{
		rcFirst.origin.x = 0;
		rcFirst.origin.y = -1;
		rcFirst.size.height = .5f;
		rcFirst.size.width = nMaxWidth;
		CGContextAddRect(context, rcFirst);
		for (int i = 1; i < nRows + 1; i++)
		{
			rcFirst.origin.y += _cellHeight;
			CGContextAddRect(context, rcFirst);
		}
		CGContextDrawPath(context, kCGPathFill);  
	}
    //绘制格线
    CGContextSetStrokeColorWithColor(context, pGridColorVor.CGColor);
    CGContextSetFillColorWithColor(context, pGridColorVor.CGColor);
    return;
}

//绘制数据
- (void)DrawString
{
	if(_ayGridData==nil || ([_ayGridData count] < 1))//增加storeTaps数组判断
        return;
	BegAutoReleaseObj();
    TZTGridData *pGridData = NULL;
	NSMutableArray *subarray = NULL;

	UIFont *pFont = tztUIBaseViewTextFont([tztTechSetting getInstance].reportTxtSize);
    if (_pDrawFont)
        pFont = _pDrawFont;
    CGRect rcText = CGRectZero;
    
    rcText.size.width = _cellWidth;
    rcText.size.height = _cellHeight;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    
	NSInteger nRow = _curIndexRow;
	NSTextAlignment uAlign = NSTextAlignmentCenter;
    NSInteger ndataCount = [_ayGridData count];
    NSInteger nRowCount = MIN(ndataCount,_rowCount);
    if(nRow >= nRowCount)
        nRow = 0;
	for (int i = 0; i < nRowCount; i++, rcText.origin.y += _cellHeight)
	{
		subarray = [_ayGridData objectAtIndex:i];
        if (subarray == NULL)
            continue;
        
        CGRect rcTemp = rcText;
        CGFloat nHeight = rcTemp.size.height;
        //计算输出高度
        CGFloat n = pFont.lineHeight;
        CGFloat nBaseLine = (nHeight - n )/ 2.0;
        if (nBaseLine < 0)
        {
            nBaseLine = 0;
        }
        
        NSInteger nColCount = _colCount;
		for (int j = 0 ; j < nColCount; j++, rcTemp.origin.x += _cellWidth)
		{
			if (_haveButton && self.btnImage && j == 2)
			{
				if (nRow == i)
				{
					[self.btnImage drawInRect:rcTemp blendMode:kCGBlendModeHardLight alpha:1.0];
				}
				else
				{
					[self.btnImage drawInRect:rcTemp];
				}
			}
            
            if (j >= [subarray count])
                break;
            pGridData = [subarray objectAtIndex:j];
            if (pGridData == NULL)
                continue;
			
            
			if (pGridData.textColor)
            {
//                if ([self.nsBackBg intValue])
//                {
//                    pGridData.textColor = [UIColor blackColor];
//                }
                
                CGContextSetStrokeColorWithColor(context, pGridData.textColor.CGColor);
                CGContextSetFillColorWithColor(context, pGridData.textColor.CGColor);
            }
            
			NSString *nsName = [NSString stringWithFormat:@"%@", pGridData.text];
            if (nsName == NULL)
                return;

            CGRect rc = CGRectMake(rcTemp.origin.x, rcTemp.origin.y + nBaseLine, (_cellWidth - 2), rcTemp.size.height - 2 * nBaseLine);
            
         	CGContextSetStrokeColorWithColor(context, pGridData.textColor.CGColor);
			CGContextSetFillColorWithColor(context, pGridData.textColor.CGColor);
//            [nsName drawAtPoint:drawpoint forWidth:_cellWidth withFont:pFont fontSize:[tztTechSetting getInstance].reportTxtSize
//                  lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//            if (j == nColCount - 1 && !IS_TZTIPAD)
//            {
//                if (nColCount <= 1)
//                    rc.size.width -= 20;
//                else
//                    rc.size.width -= 5;
//                uAlign = NSTextAlignmentRight;
//            }
//            else
            if (_bFirstColLeft && j == 0)
            {
                nsName = [NSString stringWithFormat:@" %@", nsName];
                uAlign = NSTextAlignmentLeft;// wry NSTextAlignmentLeft
            }
            else
            {
                uAlign = NSTextAlignmentCenter;//wry NSTextAlignmentRight
            }
            
            [nsName drawInRect:rc
                                   withFont:pFont
                              lineBreakMode:NSLineBreakByTruncatingTail
                                  alignment:uAlign];			
		}
	}
	EndAutoReleaseObj();
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_cellHeight <= 0)
        return;
    UITouch *touch = [touches anyObject];
    CGPoint lastPoint = [touch locationInView:self];
    int index = lastPoint.y / _cellHeight;
    _preIndexRow = _curIndexRow;
    _curIndexRow = index;
    [self setNeedsDisplay];
    if (_delegate && [_delegate respondsToSelector:@selector(tztGridView:shouldSelectRowAtIndex:)])
    {
        [_delegate tztGridView:nil shouldSelectRowAtIndex:index];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (_nGridType == 1)
        return;
    if(!IS_TZTIPAD)
    {
        _curIndexRow = -1;
    }
    [self setNeedsDisplay];
    if (_delegate && [_delegate respondsToSelector:@selector(tztGridView:shouldSelectRowAtIndex:)])
    {
        [_delegate tztGridView:nil shouldSelectRowAtIndex:_curIndexRow];
    }
}

//点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_cellHeight <= 0)
        return;
	UITouch *touch = [touches anyObject];
	NSUInteger numTaps = [touch tapCount];
	CGPoint lastPoint = [touch locationInView:self];
	int index = lastPoint.y / _cellHeight;
    if(index >= 0 && index < [_ayGridData count])
    {
        if(numTaps >= 2)
        {
            if(abs(_preClickPoint.y - lastPoint.y) < 5)
                [self doSelectAtRow:index DoubleTap:TRUE];
            else
                [self doSelectAtRow:index DoubleTap:FALSE];
        }
        else
        {
            [self doSelectAtRow:index DoubleTap:FALSE];
        }
    }
    _preClickPoint = lastPoint;
}
//选中行
- (void)doSelectAtRow:(NSInteger)nCurRow DoubleTap:(BOOL)bDouble
{
    _preIndexRow = _curIndexRow;
    _curIndexRow = nCurRow;
    if( _delegate && [_delegate conformsToProtocol:@protocol(tztGridViewDelegate)])
    {
        [_delegate tztGridView:nil didSelectRowAtIndex:_curIndexRow clicknum:(bDouble ? 2 : 1) gridData:nil];
    }
    
    if(!IS_TZTIPAD && (_nGridType != 1))
    {
        _curIndexRow = -1;
    }
    if (_curIndexRow != _preIndexRow)
    {
        [self setNeedsDisplay];
        if (_delegate && [_delegate respondsToSelector:@selector(tztGridView:shouldSelectRowAtIndex:)])
        {
            [_delegate tztGridView:nil shouldSelectRowAtIndex:_curIndexRow];
        }
    }
}

- (void)doSelectAtRow:(NSInteger)nCurRow
{
    _preIndexRow = _curIndexRow;
    _curIndexRow = nCurRow;
    [self setNeedsDisplay];
}
@end
