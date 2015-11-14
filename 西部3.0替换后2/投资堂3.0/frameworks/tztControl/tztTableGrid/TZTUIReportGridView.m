/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIReportGridView.h
 * 文件标识：
 * 摘    要：自定义Grid
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

#import "TZTUIReportGridView.h"
@interface TZTUIReportGridView (tztPrivate)
-(void) setShowColNum:(NSInteger)nColNum;
@end

@implementation TZTUIReportGridView
@synthesize delegate = _delegate;
@synthesize ayFixTitle = _ayFixTitle;
@synthesize ayFixData = _ayFixData;
@synthesize ayGridTitle = _ayGridTitle;
@synthesize ayGriddata = _ayGriddata;
@synthesize ayData = _ayData;
@synthesize nsBackBg = _nsBackBg;
@synthesize reportType = _reportType;
@synthesize curIndexRow = _curIndexRow;
@synthesize nMaxColNum = _nMaxColNum;
@synthesize pDrawFont = _pDrawFont;
@synthesize bGridLines = _bGridLines;
@synthesize nGridType = _nGridType;
@synthesize ayStockType = _ayStockType;
@synthesize bLeftTop = _bLeftTop;

- (id)init
{
    if ((self = [super init])) 
    {
    }
    return self; 
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
    }
    return self;
}

-(void) initdata
{
    [super initdata];

    self.delegate = nil;
    self.ayData = nil;
    [self setBackgroundColor:[UIColor clearColor]];
    
    _inLeftTopView = nil;
    _inTopView = nil;
    _inLeftView = nil;
    _inCenterView = nil;
    
	_reportType = FALSE;
    
	self.indexStarPos = 1;
	_curIndexRow = -1;
	_preIndexRow = -1;
    _ayFixTitle = NewObject(NSMutableArray);
    _ayFixData = NewObject(NSMutableArray);
    _ayGridTitle = NewObject(NSMutableArray);
    _ayGriddata = NewObject(NSMutableArray);
    self.nsBackBg = @"0";
    _nMaxColNum = -1;
}

- (void)dealloc {
    self.ayData = nil;
    self.delegate = nil;
    DelObject(_ayFixTitle);
    DelObject(_ayFixData);
    DelObject(_ayGridTitle);
    DelObject(_ayGriddata);
    [super dealloc];
}

//修改设置ViewSize大小返回值，避免因为父类处理成功后，子类无法判断设置大小的问题。
-(BOOL) SetCenterViewSize:(CGSize)szSize
{
    if (_inLeftTopView)
    {
        _inLeftTopView.rowCount = self.fixRowCount;
        _inLeftTopView.cellHeight = self.nDefaultCellHeight;
        _inLeftTopView.hidden = (self.fixColCount < 1);
    }
    
    if (_inTopView)
    {
        _inTopView.rowCount = self.fixRowCount;
        _inTopView.cellHeight = self.nDefaultCellHeight;
    }
    
    if (![super SetCenterViewSize:szSize])
		return FALSE;
    
    CGFloat centerWidth = MAX(_szCenterViewSize.width ,self.centerview.frame.size.width);
	if (_inLeftTopView)
    {
        _inLeftTopView.frame = CGRectMake(0, 0, self.nLeftCellWidth* MAX(1,self.fixColCount), self.nTopViewHeight);
        _inLeftTopView.rowCount = self.fixRowCount;
        _inLeftTopView.cellHeight = self.nDefaultCellHeight;
        
    }
	
    if (_inTopView)
    {
        _inTopView.frame = CGRectMake(0, 0, centerWidth, self.nTopViewHeight);
        _inTopView.rowCount = self.fixRowCount;
        _inTopView.cellHeight = self.nDefaultCellHeight;
    }
    
    if (_inLeftView)
    {
        _inLeftView.frame = CGRectMake(0, 0, self.nLeftCellWidth* MAX(1,self.fixColCount), self.szCenterViewSize.height);
        _inLeftView.hidden = (self.fixColCount < 1);
    }
    
    if (_inCenterView)
    {
        _inCenterView.frame = CGRectMake(0, 0, centerWidth, self.szCenterViewSize.height);
    }
    
	return TRUE;
}

-(void)setNGridType:(NSInteger)nType
{
    _nGridType = nType;
    if (_inLeftTopView)
        _inLeftTopView.nGridType = _nGridType;
    if (_inTopView)
        _inTopView.nGridType = _nGridType;
    if (_inLeftView)
        _inLeftView.nGridType = _nGridType;
    if (_inCenterView)
        _inCenterView.nGridType = _nGridType;
}

-(void)setBLeftTop:(BOOL)bFlag
{
    _bLeftTop = bFlag;
    if (_inLeftTopView)
        _inLeftTopView.bLeftTop = bFlag;
    if (_inTopView)
        _inTopView.bLeftTop = bFlag;
}

-(void)setBackBg:(NSString*)nsBackBg
{
    self.nsBackBg = nsBackBg;
    if (_inLeftTopView)
        _inLeftTopView.nsBlackBg = nsBackBg;
    if (_inTopView)
        _inTopView.nsBlackBg = nsBackBg;
    if (_inLeftView)
        _inLeftView.nsBackBg = nsBackBg;
    if (_inCenterView)
        _inCenterView.nsBackBg = nsBackBg;
}

-(void)setBGridLines:(BOOL)bLines
{
    _bGridLines = bLines;
    if (_inLeftTopView)
        _inLeftTopView.bGridLines = bLines;
    if (_inTopView)
        _inTopView.bGridLines = bLines;
    if (_inLeftView)
        _inLeftView.bGridLines = bLines;
    if (_inCenterView)
        _inCenterView.bGridLines = bLines;
}

-(void)setSelectRow:(NSInteger)nSel
{
    if (_inCenterView)
    {
        [_inCenterView doSelectAtRow:nSel DoubleTap:FALSE];
    }
}

-(void)setCurIndexRow:(NSInteger)nIndex
{
    _curIndexRow = nIndex;
    if (_inLeftView)
        _inLeftView.curIndexRow = nIndex;
    if (_inCenterView)
        _inCenterView.curIndexRow = nIndex;
    
}
-(void) onSetSubViewFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame))
    {
        return;
    }
    [super onSetSubViewFrame:frame];
  
	CGFloat centerWidth = MAX(_szCenterViewSize.width ,self.centerview.frame.size.width);
    if (_inLeftTopView == NULL)
    {
        _inLeftTopView = [[TZTUIHQINTopView alloc] initWithFrame:self.topleftview.frame];
        _inLeftTopView.backgroundColor = [UIColor clearColor];
        _inLeftTopView.cellWidth = self.nLeftCellWidth;
        _inLeftTopView.cellHeight = self.nDefaultCellHeight;
        _inLeftTopView.rowCount = self.fixRowCount;
        _inLeftTopView.colCount = self.fixColCount;
        _inLeftTopView.delegate = self;
        _inLeftTopView.nsBlackBg = self.nsBackBg;
        _inLeftTopView.bLeftTop = YES;
        [self.topleftview addSubview:_inLeftTopView];
        [_inLeftTopView release];
    }
    else
    {
        _inLeftTopView.frame = self.topleftview.frame;
        _inLeftTopView.nsBlackBg = self.nsBackBg;
        _inLeftTopView.cellHeight = self.nDefaultCellHeight;
        _inLeftTopView.rowCount = self.fixRowCount;
        _inLeftTopView.cellWidth = self.nLeftCellWidth;
        _inLeftTopView.colCount = self.fixColCount;
        [_inLeftTopView setNeedsDisplay];//zxl  20130916 添加了界面刷新
    }
    
    if (_inTopView == NULL)
    {
        _inTopView = [[TZTUIHQINTopView alloc]initWithFrame:CGRectMake(0, 0, centerWidth, self.nTopViewHeight)];
        _inTopView.backgroundColor = [UIColor clearColor];
        _inTopView.delegate = self;
        _inTopView.nsBlackBg = self.nsBackBg;
        _inTopView.cellWidth = self.nDefaultCellWidth;
        _inTopView.cellHeight = self.nDefaultCellHeight;
        _inTopView.rowCount = self.fixRowCount;
        _inTopView.colCount = self.colCount;
        [self.topview addSubview:_inTopView];
        [_inTopView release];
    }
    else
    {
        _inTopView.bLeftTop = (self.fixColCount < 1);
        _inTopView.cellWidth = self.nDefaultCellWidth;
        _inTopView.cellHeight = self.nDefaultCellHeight;
        _inTopView.rowCount = self.fixRowCount;
        _inTopView.colCount = self.colCount;
        _inTopView.nsBlackBg = self.nsBackBg;
        _inTopView.frame = CGRectMake(0, 0, centerWidth, self.nTopViewHeight);
        [_inTopView setNeedsDisplay];//zxl  20130916 添加了界面刷新
    }
    
    if (_inLeftView == NULL)
    {
        _inLeftView = [[TZTUIHQINLeftView alloc]initWithFrame:CGRectMake(0, 0, self.nLeftCellWidth * self.fixColCount, _szCenterViewSize.height)];
        _inLeftView.nsBackBg = self.nsBackBg;
        _inLeftView.backgroundColor = [UIColor clearColor];
        _inLeftView.cellWidth = self.nLeftCellWidth;
        _inLeftView.colCount = self.fixColCount;
        _inLeftView.cellHeight = self.nDefaultCellHeight;
        _inLeftView.rowCount = self.rowCount;
        [self.leftview addSubview:_inLeftView];
        [_inLeftView release];
    }
    else
    {
        _inLeftView.cellWidth = self.nLeftCellWidth;
        _inLeftView.nsBackBg = self.nsBackBg;
        _inLeftView.cellHeight = self.nDefaultCellHeight;
         _inLeftView.colCount = self.fixColCount;
        _inLeftView.frame = CGRectMake(0, 0,self.nLeftCellWidth*self.fixColCount,_szCenterViewSize.height);
        [_inLeftView setNeedsDisplay];//zxl  20130916 添加了界面刷新
    }
    
	if (_inCenterView == NULL)
	{
	    _inCenterView = [[TZTUIHQINCenterView alloc]initWithFrame:CGRectMake(0, 0, centerWidth, _szCenterViewSize.height)];
        _inCenterView.nsBackBg = self.nsBackBg;
		_inCenterView.delegate = self;
		_inCenterView.backgroundColor = [UIColor clearColor];

        _inCenterView.cellWidth = self.nDefaultCellWidth;
        _inCenterView.cellHeight = self.nDefaultCellHeight;
        
        _inCenterView.colCount = self.colCount;
        _inCenterView.rowCount = self.rowCount;
		[self.centerview addSubview:_inCenterView];
		_inLeftView.inScrollView =  _inCenterView;
        [_inCenterView release];
    }
	else
	{
        _inCenterView.bFirstColLeft = (self.fixColCount < 1);
        _inCenterView.nsBackBg = self.nsBackBg;
        _inCenterView.cellWidth = self.nDefaultCellWidth;
        _inCenterView.cellHeight = self.nDefaultCellHeight;
		_inCenterView.frame = CGRectMake(0, 0, centerWidth, _szCenterViewSize.height);
        [_inCenterView setNeedsDisplay];//zxl  20130916 添加了界面刷新
	}
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}

-(void) setNeedsDisplay
{
    [super setNeedsDisplay];
    if (_inLeftTopView)
    {
        _inLeftTopView.pDrawFont = self.pDrawFont;
        [_inLeftTopView setNeedsDisplay];
    }
    
    if (_inTopView)
    {
        _inTopView.pDrawFont = self.pDrawFont;
        [_inTopView setNeedsDisplay];
    }
    
    if (_inLeftView)
    {
        [_inLeftView setNeedsDisplay];
    }
    
    if (_inCenterView)
    {
        _inCenterView.pDrawFont = self.pDrawFont;
        [_inCenterView setNeedsDisplay];
    }
}

-(void)ClearGridData
{
    if (_ayFixTitle)
    {
        [_ayFixTitle removeAllObjects];
    }
    if (_ayFixData)
    {
        [_ayFixData removeAllObjects];
    }
    if (_ayGridTitle)
    {
        [_ayGridTitle removeAllObjects];
    }
    if (_ayGriddata)
    {
        [_ayGriddata removeAllObjects];
    }
    
    if (_inLeftTopView)
    {
        _inLeftTopView.ayTitle = _ayFixTitle;
        _inLeftTopView.colCount = self.fixColCount;
    }
    
    if (_inLeftView)
    {
        _inLeftView.ayFixGridData = _ayFixData;
        _inLeftView.colCount = self.fixColCount;
        _inLeftView.rowCount = self.rowCount;
    }
    
    if (_inCenterView)
    {
        _inCenterView.ayGridData = _ayGriddata;
        _inCenterView.rowCount = self.rowCount;
        _inCenterView.colCount = self.colCount;
    }
    
	CGSize szNewViewSize = CGSizeMake(self.nDefaultCellWidth*self.colCount, self.nDefaultCellHeight*self.rowCount);
    
	[self SetCenterViewSize:szNewViewSize];
	
	self.centerview.contentOffset = CGPointMake(0, 0);
	_curIndexRow = -1;
}

-(void)setNReportType:(NSInteger)nType
{
    _nReportType = nType;
}

-(void) CreatePageData:(NSMutableArray*)pGridData title:(NSMutableArray*)ayTitle type:(NSInteger)nType
{
    if (pGridData == nil || ayTitle == nil)
        return;
    
//    if ([ayTitle count] < 1)
//        return;

    if (_ayFixTitle == nil || _ayFixData == nil ||
        _ayGridTitle == nil || _ayGriddata == nil)
    {
        return;
    }
    [_ayFixTitle removeAllObjects];
	[_ayFixData removeAllObjects];
	[_ayGridTitle removeAllObjects];
	[_ayGriddata removeAllObjects];
	
//    if (IS_TZTIPAD)
//        self.nDefaultCellWidth = TZTTABLECELLWIDTH;
    NSInteger nCount = [ayTitle count];
	NSInteger nCodeIndex = -1;
    NSInteger nAdd = 0;
    //havecode 有代码列 代码列是什么意思
    if(self.haveCode)
    {
       nAdd += 1;
       nCodeIndex = nCount - 1;//代码列
    }
    
    NSMutableArray* fixTitle = NewObject(NSMutableArray);
    for (NSInteger i = 0; i < self.fixColCount; i++)
    {
        if(i != nCodeIndex && i < nCount) //固定列标题
        {
           [fixTitle addObject:[ayTitle objectAtIndex:i]]; 
        }
    }
    [_ayFixTitle addObject:fixTitle];
    [fixTitle release];

    
    NSMutableArray* gridTitle = NewObject(NSMutableArray);
    for (NSInteger k = self.fixColCount; k < nCount; k++)//数据标题
    {
        if(k != nCodeIndex)
            [gridTitle addObject:[ayTitle objectAtIndex:k]];
    }
	[_ayGridTitle addObject:gridTitle];
    [gridTitle release];
    

    self.ayData = pGridData;
    NSInteger nGridCount = [_ayData count];
    for (NSInteger i = 0; i < nGridCount; i++)
    {
        NSArray* ayData = [_ayData objectAtIndex:i];
        NSMutableArray* ayfix = NewObject(NSMutableArray);
        NSMutableArray* ayGrid = NewObject(NSMutableArray);
        if(ayData && [ayData count] > 0)
        {
            if(nCodeIndex >=0 && nCodeIndex < [ayData count])
            {
                //zxl 20130719 股票代码颜色修改
                TZTGridData * GridData = [ayData objectAtIndex:nCodeIndex];
                GridData.textColor = [UIColor grayColor];
                [ayfix addObject:GridData];
            }
            for (NSInteger k = 0; k < self.fixColCount; k++)
            {
                if(k < [ayData count] && k != nCodeIndex)
                {
                    [ayfix addObject:[ayData objectAtIndex:k]];
                }
            }
            for (NSInteger j = self.fixColCount; j < [ayData count]; j++)
            {
                if(j != nCodeIndex)
                {
                    [ayGrid addObject:[ayData objectAtIndex:j]];
                }
            }
        }
        
        if(i < self.fixRowCount)
        {
            [_ayFixTitle addObject:ayfix];
        }
        else
        {
            [_ayFixData addObject:ayfix];
        }
        [ayfix release];
        
        if(i < self.fixRowCount)
        {
            [_ayGridTitle addObject:ayGrid];
        }
        else
        {
            [_ayGriddata addObject:ayGrid];
        }
        [ayGrid release];
    }

    if (_inLeftTopView)
    {
        _inLeftTopView.ayTitle = _ayFixTitle;
        _inLeftTopView.haveCode = self.haveCode;
    }
	
    if (_inTopView)
    {
        _inTopView.ayTitle = _ayGridTitle;
    }
    [self setShowColNum:(nCount-self.fixColCount - nAdd)];
    
    if(self.nPageCount <= self.nReqPage || self.nReqPage == 0)//总页数少于请求页数
    {
        self.rowCount = MAX(nGridCount,_nPageRow+1);
    }
    
    if (_inLeftView)
    {
		_inLeftView.indexStarPos = self.indexStarPos;
        _inLeftView.ayFixGridData = _ayFixData;
        _inLeftView.cellHeight = self.nDefaultCellHeight;
        _inLeftView.rowCount = self.rowCount;
        _inLeftView.haveCode = self.haveCode;
        _inLeftView.ayStockType = self.ayStockType;
    }
    
    if (_inCenterView)
    {
		_inCenterView.haveButton = _reportType;
        _inCenterView.ayGridData = _ayGriddata;
        _inCenterView.cellHeight = self.nDefaultCellHeight;
        _inCenterView.cellWidth = self.nDefaultCellWidth;
        _inCenterView.colCount = self.colCount;
        _inCenterView.rowCount = self.rowCount;
    }
    
    if(!IS_TZTIPAD && nType)
    {
        _curIndexRow = -1;
        if(_inLeftView)
            [_inLeftView doSelectAtRow:_curIndexRow];
        if(_inCenterView)
            _inCenterView.curIndexRow = _curIndexRow;
    }
    
    /*
    //
    BOOL bNeedChange = FALSE;
    _inCenterView.bShowAddSynsView = FALSE;
    if (_nReportType == tztReportUserStock)
    {
        //最后一页
        if ((nGridCount < self.rowCount) || [self IsLastPage])
        {
            bNeedChange = TRUE;
            _inCenterView.bShowAddSynsView = TRUE;
        }
    }
    */
    CGSize szNewViewSize = CGSizeMake(self.nDefaultCellWidth * self.colCount,self.nDefaultCellHeight * self.rowCount);
    /*
    if (bNeedChange)
    {
        szNewViewSize.height += 150;    
     }
     */
    
	[self SetCenterViewSize:szNewViewSize];
    
    [self setNeedsDisplay];
    if (nType) //滚动到首列
	{
        [self dataupdataOffset:nType];
	}
    return;
}

- (NSInteger)nPageCount
{
    return _nPageCount;
}

- (void)setShowColNum:(NSInteger)nColNum
{
	if (nColNum <= 0 )
	{
		nColNum = 3;
	}
    
    if(self.colCount == nColNum && !IS_TZTIPAD)
        return;

    self.colCount = nColNum;
	if(self.colCount > 0 && self.colCount < 3 && !IS_TZTIPAD)
	{
		self.nDefaultCellWidth = (TZTTABLECELLWIDTH * 3 / self.colCount);
		if(_inTopView)
			_inTopView.cellWidth = self.nDefaultCellWidth;
	}
    
    if (_nMaxColNum > 0)
        self.colCount = _nMaxColNum - 1;
    
//    if (self.nDefaultCellWidth*self.colCount < self.centerview.frame.size.width)
//    {
//        self.nDefaultCellWidth = self.centerview.frame.size.width/self.colCount;
//    }
    if(_inTopView)
        _inTopView.cellWidth = self.nDefaultCellWidth;
    if(_inTopView)
        _inTopView.colCount = self.colCount;    
    if(_inCenterView)
        _inCenterView.colCount = self.colCount;
}

//点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//	UITouch *touch = [touches anyObject];
//	NSUInteger numTaps = [touch tapCount];
//	CGPoint lastPoint = [[touches anyObject] locationInView:self];
//    TZTNSLog(@"%d,%.2f",numTaps,lastPoint.y);
	return;
}

-(void)tztGridView:(TZTUIBaseGridView*)gridView shouldSelectRowAtIndex:(NSInteger)index
{
    if(_inLeftView )
    {
        [_inLeftView doSelectAtRow:index];
    }
}

//选中行
- (void)tztGridView:(TZTUIBaseGridView *)gridView didSelectRowAtIndex:(NSInteger)index clicknum:(NSInteger)num gridData:(NSArray*)gridData
{
    if(num == 3)
    {
        num = 1;
        _curIndexRow = index;
    }
    else
    {
        if(_inLeftView )
        {
            [_inLeftView doSelectAtRow:index];
        }
        _curIndexRow = index + self.fixRowCount;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(tztGridView:didSelectRowAtIndex:clicknum:gridData:)])
    {
        if(_ayData && _curIndexRow >= 0 && _curIndexRow < [_ayData count])
        {
            [_delegate tztGridView:self didSelectRowAtIndex:_curIndexRow clicknum:num gridData:[_ayData objectAtIndex:_curIndexRow]];
        }
        else
        {
            [_delegate tztGridView:self didSelectRowAtIndex:_curIndexRow clicknum:num gridData:nil];
        }
    }

}

- (NSInteger)OnPageRefresh
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tztGridView:pageRefreshAtPage:)])
	{
        return [self.delegate tztGridView:self pageRefreshAtPage:self.nCurPage];
	}
    return  -1;
}

- (NSInteger)OnPageBack
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(tztGridView:pageBackAtPage:)])
	{
        return [self.delegate tztGridView:self pageBackAtPage:self.nCurPage];
	}
    return -1;
}

- (NSInteger)OnPageNext
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tztGridView:pageNextAtPage:)])
	{
        return [self.delegate tztGridView:self pageNextAtPage:self.nCurPage];
	}
    return -1;
}

//点击标题头
- (void)tztGridView:(TZTUIBaseGridView *)gridView didClickTitle:(NSInteger)index gridDataTitle:(TZTGridDataTitle*)gridDataTitle
{
    if (_delegate && [_delegate respondsToSelector:@selector(tztGridView:didClickTitle:gridDataTitle:)])
    {
        [_delegate tztGridView:self didClickTitle:index gridDataTitle:gridDataTitle];
    }
}

-(NSArray*)tztGetPreStock
{
    if (_ayData == NULL)
        return NULL;
    _curIndexRow--;
    if (_curIndexRow < 0)
        _curIndexRow = [_ayData count] - 1;
     if(_ayData && _curIndexRow >= 0 && _curIndexRow < [_ayData count])
     {
         return [_ayData objectAtIndex:_curIndexRow];
     }
    return NULL;
}

-(NSArray*)tztGetCurStock
{
    if (_ayData == NULL)
        return NULL;
    if (_curIndexRow < 0)
        _curIndexRow = [_ayData count] - 1;
    if(_ayData && _curIndexRow >= 0 && _curIndexRow < [_ayData count])
    {
        return [_ayData objectAtIndex:_curIndexRow];
    }
    return NULL;
}

-(NSArray*)tztGetNextStock
{
    if (_ayData == NULL)
        return NULL;
    _curIndexRow++;
    if (_curIndexRow >= [_ayData count])
        _curIndexRow = 0;
    if(_ayData && _curIndexRow >= 0 && _curIndexRow < [_ayData count])
    {
        return [_ayData objectAtIndex:_curIndexRow];
    }
    return NULL;
}

-(NSArray*)tztGetCurrent
{
    if (_ayData == NULL)
        return NULL;
    if (_curIndexRow < 0 || _curIndexRow >= [_ayData count])
        return NULL;
    return [_ayData objectAtIndex:_curIndexRow];
    return NULL;
}

-(CGRect)getLeftTopViewFrame
{
    if (_inLeftTopView)
        return _inLeftTopView.frame;
    return CGRectZero;
}

@end
