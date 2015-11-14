/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIHQINTopView.m
 * 文件标识：
 * 摘    要：自定义Grid标题列View
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

#import "TZTUIHQINTopView.h"
#import "TZTUIImageDefine.h"

#define TitleInnerLabelTag		  0x105000

@interface TZTUIHQINTopView (tztPrivate)
- (void)initdata;
- (void)DrawBackground; //绘制底图
- (void)CreateTextView;
- (void)DrawGridLine;   //绘制间隔线
- (void)DrawString;     //绘制数据
//判断点击处是否支持排序，支持即排序
- (void)clickedAt:(NSInteger)index;
@end

@implementation TZTUIHQINTopView
@synthesize delegate = _delegate;
@synthesize cellWidth = _cellWidth;
@synthesize cellHeight = _cellHeight;
@synthesize colCount = _colCount;
@synthesize rowCount = _rowCount;
@synthesize ayTitle = _ayTitle;
@synthesize haveCode = _haveCode;
@synthesize nsBlackBg = _nsBlackBg;
@synthesize bGridLines = _bGridLines;
@synthesize nGridType = _nGridType;
@synthesize pDrawFont = _pDrawFont;
@synthesize bLeftTop = _bLeftTop;
- (id)init
{
    if(self = [super init])
    {
       [self initdata]; 
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
    {
        [self initdata];
    }
    return self;
}

- (void)initdata
{
    self.delegate = nil;
    self.cellWidth = 0;
    self.cellHeight = 0;
    self.colCount = 0;
    self.rowCount = 0;
    self.haveCode = 0;
    self.ayTitle = nil;
    self.nsBlackBg = @"0";//
    _ayUILabs = NewObject(NSMutableArray);
}

- (void)drawRect:(CGRect)rect {
    [self DrawBackground];
    [self CreateTextView];
    if ([self.nsBlackBg intValue] || _bGridLines)
        [self DrawGridLine];
    [self DrawString];
//    
//    
//    if (/*_rowCount > 0 &&*/ _bGridLines)
//    {
//        CGRect rcGrid = CGRectMake(0, self.frame.size.height - 5, self.frame.size.width, 5.f);
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        UIColor * pGridCellBG = [UIColor tztThemeHQReportCellColor];// [UIColor colorWithRGBULong:0xFF2b2b2b];   //第一行背景色
//        UIColor * pGridCellBGEx = [UIColor tztThemeHQReportCellColorEx];   //第一行背景色
//        if (_nGridType == 1)
//        {
//            pGridCellBG = [UIColor tztThemeJYReportCellColor];
//            pGridCellBGEx = [UIColor tztThemeJYReportCellColorEx];
//        }
//        
//        CGContextSetLineWidth(context, 5.f);
//        
//        CGContextSetStrokeColorWithColor(context, pGridCellBG.CGColor);
//        CGContextSetFillColorWithColor(context, pGridCellBG.CGColor);
//        
//        CGContextAddRect(context, rcGrid);
//        
//        CGContextDrawPath(context, kCGPathFill);
//        CGContextSetStrokeColorWithColor(context, pGridCellBGEx.CGColor);
//        CGContextSetFillColorWithColor(context, pGridCellBGEx.CGColor);
//
////        CGContextSetStrokeColorWithColor(context, pGridCellBG.CGColor);
////        CGContextSetFillColorWithColor(context, pGridCellBG.CGColor);
////        CGContextAddRect(context, rcGrid);
////        CGContextDrawPath(context, kCGPathFillStroke);
////        
////        rcGrid = CGRectMake(0, self.frame.size.height - .5f, self.frame.size.width, .5f);
////        CGContextSetStrokeColorWithColor(context, pGridCellBGEx.CGColor);
////        CGContextSetFillColorWithColor(context, pGridCellBGEx.CGColor);
////        CGContextAddRect(context, rcGrid);
////        CGContextDrawPath(context, kCGPathFillStroke);
//    }
}


- (void)dealloc 
{
    self.delegate = nil;
    self.ayTitle = nil;
    [_ayUILabs removeAllObjects];
    DelObject(_ayUILabs);
    [super dealloc];
}

-(void) DrawBackground
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *pImgTitle = [UIImage imageTztNamed:TZTUIHQReportTitlePNG];
    CGContextSetLineWidth(context, 1.0);
    //标题
    CGRect rcFirst = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / (_rowCount+1));
    if (g_nUsePNGInTableGrid && pImgTitle && ![self.nsBlackBg intValue])
    {
        [pImgTitle drawInRect:rcFirst];
    }
    else
    {
		UIColor * pGridCellBG = nil;
        if (_nGridType == 1)
            pGridCellBG = [UIColor tztThemeJYTitleBackColor];
        else
            pGridCellBG = [UIColor tztThemeHQTitleBackColor];// [UIColor colorWithRGBULong:0xE4E4E4];   //第一行背景色
        CGContextSetStrokeColorWithColor(context, pGridCellBG.CGColor);
        CGContextSetFillColorWithColor(context, pGridCellBG.CGColor);
        CGContextAddRect(context, rcFirst);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    for (int row = 0; row < _rowCount; row++)
    {
        rcFirst.origin.y += rcFirst.size.height;
        if (g_nUsePNGInTableGrid && ![self.nsBlackBg intValue])
        {
            UIImage* pImgBackground = [UIImage imageTztNamed:TZTUIHQReportContentPNG];
            [pImgBackground drawInRect:rcFirst];
        }
        else
        {
            UIColor * pGridCellBG = [UIColor colorWithRGBULong:0x000000];   //第一行背景色
            CGContextSetStrokeColorWithColor(context, pGridCellBG.CGColor);
            CGContextSetFillColorWithColor(context, pGridCellBG.CGColor);
            CGContextAddRect(context, rcFirst);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    
    return;
}

-(void) CreateTextView
{
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
    
    if (_colCount < 1)
        return;
    
    CGRect rcTitle = CGRectMake(0, 0, (_cellWidth - 5), self.frame.size.height - (_cellHeight * _rowCount));
    UIColor *titlecolor = [UIColor whiteColor];
    for (int row = 0; row < _rowCount + 1; row++)
    {
        if( row > 0 )
        {
            rcTitle.origin.x = 0;
            rcTitle.origin.y += rcTitle.size.height;
            if (row == _rowCount)
                rcTitle.size.height = _cellHeight - 2;
            else
                rcTitle.size.height = _cellHeight;
        }
        
        for (int i = 0; i < _colCount; i++)
        {
            UILabel *lable = (UILabel*)[self viewWithTag:TitleInnerLabelTag + i + row * _colCount];
            if(lable == NULL)
            {
                lable = [[UILabel alloc]initWithFrame:rcTitle];
                lable.tag = TitleInnerLabelTag + i + row * _colCount;
                lable.hidden = YES;
                lable.clipsToBounds = YES;
                lable.textColor = titlecolor;
                lable.backgroundColor = [UIColor clearColor];
                lable.adjustsFontSizeToFitWidth = YES;
                if (self.pDrawFont)
                    lable.font = self.pDrawFont;
                else
                    lable.font = tztUIBaseViewTextFont([tztTechSetting getInstance].reportTxtSize);
                lable.textAlignment = NSTextAlignmentCenter;
                lable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
                [_ayUILabs addObject:lable];
                [self addSubview:lable];
                [lable release];
            }
            else 
            {
                [lable setFrame:rcTitle];
                lable.hidden = YES;
            }
            rcTitle.origin.x += _cellWidth;
        }
    }
}

-(void) DrawGridLine
{
    if (_colCount < 1)
        return;
    int nMaxHeight = self.frame.size.height-1;
	int nMaxWidth = self.frame.size.width;
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *pGridColorVor = nil;
    if (_nGridType == 1)
    {
        pGridColorVor = [UIColor tztThemeJYGridColor];
    }
    else
    {
        pGridColorVor = [UIColor tztThemeHQGridColor];// [UIColor colorWithTztRGBStr:TZTUIBaseGridLineColorVor];//竖
    }
    [UIColor colorWithTztRGBStr:TZTUIBaseGridLineColorVor];//竖
    CGContextSetLineWidth(context, .05f);
    //标题
    CGRect rcFirst = CGRectZero;
    //绘制格线
    CGContextSetStrokeColorWithColor(context, pGridColorVor.CGColor);
    CGContextSetFillColorWithColor(context, pGridColorVor.CGColor);
	//横线
	UIImage *pImgContentLine = [UIImage imageTztNamed:TZTUIBaseGridContentLinePNG];
	if (g_nUsePNGInTableGrid && pImgContentLine)
	{
		rcFirst.origin.x = 0;
		rcFirst.origin.y = nMaxHeight;
		rcFirst.size.height = 2;
		rcFirst.size.width = nMaxWidth;
		[pImgContentLine drawInRect:rcFirst];    
	}
	else
	{
		rcFirst.origin.x = 0;
		rcFirst.origin.y = nMaxHeight;
		rcFirst.size.height = .5f;
		rcFirst.size.width = nMaxWidth;
		CGContextAddRect(context, rcFirst);
		CGContextDrawPath(context, kCGPathFill);  
	}
    //绘制格线
    CGContextSetStrokeColorWithColor(context, pGridColorVor.CGColor);
    CGContextSetFillColorWithColor(context, pGridColorVor.CGColor);
    
    return;
}

- (void)DrawString
{
	if (_ayTitle == nil || ([_ayTitle count] < 1))
        return;
    NSArray* ayShowTitle = [_ayTitle objectAtIndex:0];
    NSInteger dataRow = [ayShowTitle count];
//    UIColor *clTitle =  [UIColor colorWithTztRGBStr:@"128,128,128"];

    UIColor *clTitle = nil;
    
    if (_nGridType == 1)
        clTitle = [UIColor tztThemeTextColorLabel];
    else
        clTitle =  [UIColor tztThemeHQFixTextColor];
//    if ([self.nsBlackBg intValue] == 1)
//    {
//        clTitle = [UIColor colorWithTztRGBStr:@"48,48,48"];
//    }
    for (int i = 0 ; i < dataRow; i++)
    {
        TZTGridDataTitle *nsHead = [ayShowTitle objectAtIndex:i];
		NSString* nsItem = @"";
		if(nsHead)
		{
			nsItem = [NSString stringWithFormat:@"%@" ,nsHead.text];
            UILabel *lable = (UILabel*)[self viewWithTag:TitleInnerLabelTag + i];
            if(lable)
            {
//                if(nsHead.enabled)
//                    [lable setTextColor:[UIColor yellowColor]]; //可排序字段
//                else
#ifdef kSUPPORT_FIRST
                if(nsHead.textColor)
                {
                    [lable setTextColor:nsHead.textColor]; //设置标题颜色
                }
                else
#endif
                {
                    [lable setTextColor:clTitle];
                }
                
                UILabel *label1 = (UILabel*)[lable viewWithTag:TitleInnerLabelTag*5+i];
                CGRect rc = lable.bounds;
                CGSize sz = [nsItem sizeWithFont:lable.font];
                if (_bLeftTop && i == 0)
                {
                    CGRect rctemp = rc;
                    rctemp.origin.x += 5;
                    rctemp.size.width -= 5;
                    lable.frame = rctemp;
                    
                    rc = rctemp;
//                    rc.origin.x = 0;
                    
                    rc.origin.x = sz.width - 3;
                }
                else
                {
                    rc.origin.x = rc.size.width - 5;
                }
//                rc.origin.x += rc.size.width / 2;
//                rc.origin.x += sz.width / 2;
                if (label1 == NULL)
                {
                    label1 = [[UILabel alloc] initWithFrame:rc];
                    label1.textColor =  [UIColor colorWithTztRGBStr:@"68,68,68"];
                    label1.backgroundColor = [UIColor clearColor];
                    label1.tag = TitleInnerLabelTag*5+i;
                    label1.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
                    [lable addSubview:label1];
                    [label1 release];
                }
                else
                {
                    label1.frame = rc;
                }
                
                if (nsHead.enabled)//可排序
                {
                    if ([nsItem hasSuffix:@"↓"] || [nsItem hasSuffix:@"↑"])
                    {
                        label1.hidden = YES;
                    }
                    else
                    {
                        if (g_pSystermConfig && g_pSystermConfig.nsOrderIconString)
                            label1.text = g_pSystermConfig.nsOrderIconString;
                        else
                            label1.text = @"";
                        label1.hidden = NO;
                    }
                }
                else
                {
                    label1.text = @"";
                    label1.hidden = YES;
                }
                
                
                if (_bLeftTop && i == 0 && !IS_TZTIPAD)
                {
                    nsItem = [NSString stringWithFormat:@"%@    ", nsItem];
                    [lable setTextAlignment:NSTextAlignmentCenter]; //wry 居中对齐 NSTextAlignmentRight
                }
                else
                {
                    nsItem = [NSString stringWithFormat:@"%@", nsItem];
                    [lable setTextAlignment:NSTextAlignmentCenter];//wry NSTextAlignmentRight
                }
                
                lable.backgroundColor = [UIColor clearColor];
                [lable setText:nsItem];
                lable.hidden = NO;
            }
		}
    }
    
    if(_rowCount > 0 && [_ayTitle count] > _rowCount)
    {
        for (int row = 1; row < _rowCount+1; row ++)
        {
            NSArray* ayData = [_ayTitle objectAtIndex:row];
            NSInteger nDataCount = MIN([ayData count],_colCount);
            for (int i = 0 ; i < nDataCount; i++)
            {
                TZTGridData *pGridData = [ayData objectAtIndex:i];
                if(_haveCode && i + 1 < [ayData count])
                    pGridData = [ayData objectAtIndex:i + 1];
                if (pGridData == NULL)
                    continue;
                
                
                NSString *nsName = [NSString stringWithFormat:@"%@", pGridData.text];
                if (nsName == NULL)
                    return;
                
                UILabel *lable = (UILabel*)[self viewWithTag:TitleInnerLabelTag + i + row * _colCount];
                
                if (_bLeftTop && i == 0)
                {
                    
                    [lable setTextAlignment:NSTextAlignmentLeft];
                }
                else
                {
                    [lable setTextAlignment:NSTextAlignmentRight];
                }
                
                if(lable)
                {
                    if(pGridData.textColor)
                        [lable setTextColor:pGridData.textColor]; //可排序字段
                    else
                        [lable setTextColor:clTitle];
                    
                    if (g_nUsePNGInTableGrid && ![self.nsBlackBg intValue])
                    {
                        UIImage* pImgBackground = [UIImage imageTztNamed:TZTUIHQReportContentPNG];
                        [lable setBackgroundColor:[UIColor colorWithPatternImage:pImgBackground]];
                    }
                    
                    [lable setText:nsName];
                    lable.hidden = NO;
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//排名点击标题处理
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
    CGFloat locationy = location.y + _cellHeight * _rowCount - self.bounds.size.height;
    if(locationy > 0 && _cellHeight > 0 && _rowCount > 0)
    {
        int iRow = locationy / _cellHeight;
        if(iRow >= 0)
        {
            if( _delegate && [_delegate conformsToProtocol:@protocol(tztGridViewDelegate)])
            {
                [_delegate tztGridView:nil didSelectRowAtIndex:iRow clicknum:3 gridData:nil];
            }
            return;
        }
    }
    
    if(_cellWidth > 0)
    {
        int index = location.x / _cellWidth;
        [self clickedAt:index];
    }
}

//判断点击处是否支持排序，支持即排序
-(void)clickedAt:(NSInteger)index
{
    if(_ayTitle && index >= 0 && [_ayTitle count] > 0)
    {
        NSArray* aytitle = [_ayTitle objectAtIndex:0];
        if(aytitle && index < [aytitle count])
        {
            TZTGridDataTitle *gridDataTitle = [aytitle objectAtIndex:index];
            if(gridDataTitle && gridDataTitle.enabled)
            {
                if( _delegate && [_delegate conformsToProtocol:@protocol(tztGridViewDelegate)])
                {
                    [_delegate tztGridView:nil didClickTitle:index gridDataTitle:gridDataTitle];
                }
            }
        }
    }
}
@end
