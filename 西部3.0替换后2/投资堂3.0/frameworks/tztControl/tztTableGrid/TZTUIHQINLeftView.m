/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIHQINLeftView.m
 * 文件标识：
 * 摘    要：自定义Grid左侧固定列View
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


#import "TZTUIHQINLeftView.h"
#import "TZTUIImageDefine.h"

#define TitleInnerLabelTag		  0x107000

@interface TZTUIHQINLeftView (tztPrivate)
- (void)initdata;
- (void)DrawBackground:(CGContextRef)context;
- (void)CreateTextView;
- (void)DrawGridLine;
- (void)DrawGridData;
- (void)DrawSelectBG;
- (void)doSelectAtRow:(int)nCurRow DoubleTap:(BOOL)bDouble;
@end

@implementation TZTUIHQINLeftView

@synthesize ayFixGridData = _ayFixGridData;
@synthesize inScrollView = _inScrollView;

@synthesize cellWidth = _cellWidth;
@synthesize colCount = _colCount;

@synthesize rowCount = _rowCount;
@synthesize cellHeight = _cellHeight;

@synthesize indexStarPos = _indexStarPos;
@synthesize curIndexRow = _curIndexRow;
@synthesize haveIndex = _haveIndex;
@synthesize haveCode = _haveCode;
@synthesize nsBackBg = _nsBackBg;
@synthesize bGridLines = _bGridLines;
@synthesize nGridType = _nGridType;
@synthesize ayStockType = _ayStockType;
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
    if ((self = [super initWithFrame:frame]))
    {
        [self initdata];
	}
    return self;
}

- (void)dealloc
{
    self.ayFixGridData = nil;
    self.inScrollView = nil;
    [_ayUILabs removeAllObjects];
    DelObject(_ayUILabs);
    [super dealloc];
}

- (void)initdata
{
    self.ayFixGridData = nil;
    self.inScrollView = nil;
    
    self.cellWidth = self.frame.size.width;
    self.colCount = 1;
    _ayUILabs = NewObject(NSMutableArray);
    self.cellHeight = TZTTABLECELLHEIGHT;
    self.rowCount = 0;
    
    self.indexStarPos = 1;
    
    self.curIndexRow = -1;
    _preIndexRow = -1;
    
    
    self.haveIndex = 0;
    self.haveCode = 0;
    self.nsBackBg = @"0";
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(_colCount <= 0)
        _colCount = 1;
    self.cellWidth = self.frame.size.width / _colCount;
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self DrawBackground:context];
    [self CreateTextView];
    [self DrawSelectBG];
    [self DrawGridLine];
    [self DrawGridData];
}

-(void) DrawSelectBG
{
    if (_ayFixGridData == nil || _curIndexRow < 0 || _curIndexRow >= [_ayFixGridData count])
        return;
    
	UIImage* pImgSelected = [UIImage imageTztNamed:@"TZTReportContentSelect.png"];
	if (pImgSelected != NULL)
	{
		CGRect rcFirst = CGRectMake(0, 0, self.frame.size.width, _cellHeight-1);
        NSInteger nRow = _curIndexRow;
        if (_inScrollView != NULL && _inScrollView.curIndexRow != _curIndexRow)
        {
            _inScrollView.curIndexRow = _curIndexRow;
        }
        rcFirst.origin.y = _cellHeight*nRow;
        [pImgSelected drawInRect:rcFirst];
	}
	else
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		UIColor *pBackground = nil;
        if (_nGridType == 1)
            pBackground = [UIColor tztJYTableSelectColor];
//            pBackground = [UIColor tztThemeBackgroundColorSection];
        else
            pBackground = [UIColor tztThemeHQTableSelectColor];//		CGContextSetLineWidth(context, 1.0);
//		UIColor *pBackground = [UIColor tztThemeHQTableSelectColor];
        CGContextSetLineWidth(context, 1.0);
		CGContextSetStrokeColorWithColor(context, pBackground.CGColor);
		CGContextSetFillColorWithColor(context, pBackground.CGColor);
		CGRect rcFirst = CGRectMake(0, 0, self.frame.size.width, _cellHeight);
        NSInteger nRow = _curIndexRow;
        if (_inScrollView != NULL && _inScrollView.curIndexRow != _curIndexRow)
        {
            _inScrollView.curIndexRow = _curIndexRow;
        }
        rcFirst.origin.y = _cellHeight*nRow;
        CGContextAddRect(context, rcFirst);
		CGContextDrawPath(context, kCGPathFill);
	}
}

-(void) DrawBackground:(CGContextRef)context
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
            if (_cellHeight <= 0)
            {
                _cellHeight = pImgBackground.size.height;
            }
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
    CGContextSetLineWidth(context, 1.0);
    if (_nGridType == 1)
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
//        if (_nGridType == 0/* || Support_tztTradeList*/)
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

-(void) CreateTextView
{
    NSInteger nIndex = 0;
	NSInteger nHeight = 0;
    NSInteger nColCount = _colCount + 2;
    NSInteger nMargin = 2;
    
    
	if (_haveCode) 
    {
		nHeight = (_cellHeight - nMargin * 2) / 3;
	}
	if (_haveIndex)
    {
		nIndex = 17;
	}
    else
        nIndex = 5; // 左列防止顶格 byDBQ20130725
    
    for (int i = 0; i < [_ayUILabs count]; i++)
    {
        UIView* lab = (UIView *)[_ayUILabs objectAtIndex:i];
        if(lab)
        {
            lab.hidden = YES;
            if([lab isKindOfClass:[UILabel class]])
            {
                [(UILabel *)lab setText:@""];
            }
        }
    }

    CGRect rclblName = CGRectMake(nIndex+2, nMargin, _cellWidth-nIndex-2, _cellHeight - nHeight - nMargin );
    CGRect rclblCode = CGRectMake(nIndex+2, nMargin + nHeight * 2,  _cellWidth - nIndex - 2, nHeight);
	CGRect rclblIndex = CGRectMake(0, 0, nIndex, _cellHeight);
    UIColor *pLableText = [UIColor whiteColor];
//    if ([self.nsBackBg intValue])
//    {
//        pLableText = [UIColor blackColor];
//    }

	for (int i = 0; i < _rowCount; i++)
	{
        //序号
        NSInteger nTag = (TitleInnerLabelTag + i* nColCount);
        UILabel *lable = (UILabel*)[self viewWithTag:nTag];
        if (_haveIndex)
        {
            if(lable == NULL)
            {
                lable = [[UILabel alloc]initWithFrame:rclblIndex];//序号
                lable.tag = nTag;
                [_ayUILabs addObject:lable];
                [self addSubview:lable];
                [lable release];
            }
            lable.hidden = YES;
            lable.textColor = pLableText;
            lable.backgroundColor = [UIColor clearColor];
            lable.adjustsFontSizeToFitWidth = YES;
            lable.font = tztUIBaseViewTextFont([tztTechSetting getInstance].reportTxtSize + 3.0f);
            lable.textAlignment = NSTextAlignmentLeft;
            lable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            [lable setFrame:rclblIndex];
        }
        else
        {
            UIImageView *image = (UIImageView*)[self viewWithTag:nTag+1000];
            CGRect rcImage = rclblIndex;
            rcImage.size = CGSizeMake(12, 9);
            rcImage.origin.x += (rclblIndex.size.width - rcImage.size.width);
            rcImage.origin.y += (rclblName.size.height - rcImage.size.height)/2 + nMargin;
            if (image == NULL)
            {
                image = [[UIImageView alloc] initWithFrame:rcImage];
                image.tag = nTag+1000;
                [_ayUILabs addObject:image];
                [self addSubview:image];
                [image release];
            }
            else
                image.frame = rcImage;
            image.hidden = YES;
        }
		
        //代码
        nTag = (TitleInnerLabelTag + i* nColCount + 1);
        lable = (UILabel*)[self viewWithTag:nTag];
        if(lable == nil)
        {
            lable = [[UILabel alloc]initWithFrame:rclblCode]; //代码
            lable.tag = nTag;
            [_ayUILabs addObject:lable];
            [self addSubview:lable];
            [lable release];
        }
        lable.hidden = YES;
        lable.textColor = pLableText;
        lable.backgroundColor = [UIColor clearColor];
        lable.adjustsFontSizeToFitWidth = YES;
        lable.font = tztUIBaseViewTextFont([tztTechSetting getInstance].reportTxtSize-4.5f);
        lable.textAlignment = NSTextAlignmentLeft;
        lable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [lable setFrame:rclblCode];
        
        //名称
        nTag = (TitleInnerLabelTag + i* nColCount + 2);
        lable = (UILabel*)[self viewWithTag:nTag];
        if(lable == nil)
        {
            lable = [[UILabel alloc]initWithFrame:rclblName]; //代码
            lable.tag = nTag;
            [_ayUILabs addObject:lable];
            [self addSubview:lable];
            [lable release];
        }
        lable.hidden = YES;
        lable.textColor = pLableText;
        lable.backgroundColor = [UIColor clearColor];
        lable.adjustsFontSizeToFitWidth = YES;
        lable.font = tztUIBaseViewTextFontWithDefaultName([tztTechSetting getInstance].reportTxtSize);
        lable.textAlignment = NSTextAlignmentLeft;
        lable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [lable setFrame:rclblName];
		
        
        for (int j = 1; j < _colCount; j++)
        {
            CGRect rctext = CGRectMake(_cellWidth*j, _cellHeight * i, _cellWidth, _cellHeight);
            nTag = (TitleInnerLabelTag + i*nColCount + 2 + j);
            lable = (UILabel*)[self viewWithTag:nTag];
            if(lable == NULL)
            {
                lable = [[UILabel alloc]initWithFrame:rctext];
                lable.tag = nTag;
                [_ayUILabs addObject:lable];
                [self addSubview:lable];
                [lable release];
            }
            lable.hidden = YES;
            lable.backgroundColor = [UIColor clearColor];
            lable.textColor = pLableText;
            lable.font = tztUIBaseViewTextFont([tztTechSetting getInstance].reportTxtSize);
            lable.textAlignment = NSTextAlignmentCenter;
            lable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            [lable setFrame:rctext];
        }
        rclblIndex.origin.y += _cellHeight;
        rclblName.origin.y += _cellHeight;
        rclblCode.origin.y += _cellHeight;
	}
}

-(void) DrawGridLine
{
    if (g_nUsePNGInTableGrid && ![self.nsBackBg intValue])
    {
        return;
    }
    if (!_bGridLines)
        return;
    NSInteger  nRows = _rowCount;
    
    NSInteger nMaxWidth = self.frame.size.width;
    NSInteger nMaxHeight = nRows*_cellHeight;
    
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
    CGContextSetLineWidth(context, .5);
    //标题
    CGRect rcFirst = CGRectZero;
    
    //绘制格线
    CGContextSetStrokeColorWithColor(context, pGridColor.CGColor);
    CGContextSetFillColorWithColor(context, pGridColor.CGColor);
    
    //横线
    UIImage *pImgContentLine = [UIImage imageTztNamed:TZTUIBaseGridContentLinePNG];
    if (pImgContentLine)
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

- (void) DrawGridData
{
    if (_ayFixGridData == nil || [_ayFixGridData count] <= 0)
    {
        return;
    }
    NSInteger nColCount = _colCount + 2;
    NSInteger count = [_ayFixGridData count];
	for (NSInteger i = 0; i < _rowCount; i++)
	{
        if(i >= count)
            continue;
        NSArray* ayData = [_ayFixGridData objectAtIndex:i];
        if (ayData && [ayData count] > 0)
        {
            UILabel *pLabel = NULL;
            if (_haveIndex) 
            {
                NSInteger nTag = TitleInnerLabelTag + i*nColCount;
                pLabel = (UILabel*)[self viewWithTag:nTag];
                if (pLabel) 
                {
                    pLabel.text = [NSString stringWithFormat:@"%3ld", (long)(i+_indexStarPos)];
                    pLabel.hidden = NO;
                }
            }
            else
            {
                if (g_pSystermConfig && [[g_pSystermConfig.pDict objectForKey:@"MarketIcon"] boolValue])
                {
                    NSInteger nTag = TitleInnerLabelTag + i*nColCount + 1000;
                    UIImageView* image = (UIImageView*)[self viewWithTag:nTag];
                    int nType = [[self.ayStockType objectAtIndex:i] intValue];
                    if (image)
                    {
                        image.hidden = NO;
                        if (MakeUSMarket(nType))
                            [image setImage:[UIImage imageTztNamed:@"TZTUSIcon@2x.png"]];
                        else if (MakeHKMarket(nType))
                            [image setImage:[UIImage imageTztNamed:@"TZTHKIcon@2x.png"]];
                        else
                            image.hidden = YES;
                    }
                }
            }
            
            if (_haveCode && [ayData count] > 0) 
            {
                NSInteger nTag = TitleInnerLabelTag + i*nColCount + 1;
                pLabel = (UILabel*)[self viewWithTag:nTag];
                TZTGridData * pData = [ayData objectAtIndex:0];
                if (pLabel && pData)
                {
                    pLabel.text = [NSString stringWithFormat:@"%@",pData.text];
//                    if ([self.nsBackBg intValue])
//                    {
//                        pLabel.textColor = [UIColor blackColor];
//                    }
//                    else
                    {
                        if (pData.textColor)
                        {
                            pLabel.textColor = pData.textColor;
                        }
                        else
                            pLabel.textColor = [UIColor tztThemeHQFixTextColor];
                    }
                    pLabel.hidden = NO;
                }    
            }
            
            int nStart = (_haveCode ? 1 : 0);
            for (int j = 0; j < _colCount; j++) 
            {
                if( j+nStart >= [ayData count])
                    continue;
                NSInteger nTag = TitleInnerLabelTag + i*nColCount + 2 + j;
                pLabel = (UILabel*)[self viewWithTag:nTag];
                TZTGridData * pData = [ayData objectAtIndex:(j+nStart)];
                if (pLabel && pData)
                {
                    pLabel.text = pData.text;
//                    if ([self.nsBackBg intValue])
//                    {
//                        pLabel.textColor = [UIColor blackColor];
//                    }
//                    else
                    {
                        if (pData.textColor)
                        {
                            pLabel.textColor = pData.textColor;
                        }
                        else
                            pLabel.textColor = [UIColor tztThemeHQFixTextColor];
                    }	
                    pLabel.hidden = NO;
                } 
                
            }
        }
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_cellHeight <= 0)
        return;
    CGPoint lastPoint = [[touches anyObject] locationInView:self];
    int index = lastPoint.y / _cellHeight;
    if(index >= 0 && index < [_ayFixGridData count])
    {
        _preIndexRow = _curIndexRow;
        _curIndexRow = index;
        [_inScrollView tztperformSelector:@"doSelectAtRow:" withObject:(id)index];
        [self setNeedsDisplay];
    }
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
 
    if (_nGridType == 1)
        return;
    if (_inScrollView && [_inScrollView respondsToSelector:@selector(doSelectAtRow:DoubleTap:)])
    {
        [_inScrollView doSelectAtRow:-1 DoubleTap:NO];
    }
    
    if(!IS_TZTIPAD)
    {
        _curIndexRow = -1;
    }
    [self setNeedsDisplay];
}

//点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_cellHeight <= 0)
        return;
	UITouch *touch = [touches anyObject];
	NSUInteger numTaps = [touch tapCount];
	CGPoint lastPoint = [[touches anyObject] locationInView:self];
	int index = lastPoint.y / _cellHeight;
    if(index >= 0 && index < [_ayFixGridData count])
    {
        if(numTaps >= 2)
        {
            [self doSelectAtRow:index DoubleTap:TRUE];
        }
        else
        {
            [self doSelectAtRow:index DoubleTap:FALSE];
        }
        return; 
    }
}

- (void)doSelectAtRow:(int)nCurRow DoubleTap:(BOOL)bDouble
{
    _preIndexRow = _curIndexRow;
    _curIndexRow = nCurRow;
//    if (_curIndexRow != _preIndexRow)
    {
        if (_inScrollView && [_inScrollView respondsToSelector:@selector(doSelectAtRow:DoubleTap:)])
      	{
			[_inScrollView doSelectAtRow:nCurRow DoubleTap:bDouble];
		}
        
        if(!IS_TZTIPAD && (_nGridType != 1))
        {
            _curIndexRow = -1;
        }
		[self setNeedsDisplay];
    }
}

- (void)doSelectAtRow:(NSInteger)nCurRow
{
    _preIndexRow = _curIndexRow;
    _curIndexRow = nCurRow;
    if (_curIndexRow != _preIndexRow)
        [self setNeedsDisplay];
}

//是否显示序号
-(void) setHaveIndex:(NSInteger)nHaveIndex
{
	if (_haveIndex != nHaveIndex)
    {
		_haveIndex = nHaveIndex;
	}
}

//是否显示代码
-(void) setHaveCode:(NSInteger)nHaveCode
{
	if (_haveCode != nHaveCode) 
    {
		_haveCode = nHaveCode;
	}
    [self CreateTextView];
}

-(void) ChangeMaxRowCount:(int)nNewRowCount
{
	if (nNewRowCount < 1)
	{
		nNewRowCount = 20;
	}
	if (nNewRowCount == _rowCount)
	{
		return;
	}
	_rowCount = nNewRowCount;
}

@end
