/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztUINineGridView.m
 * 文件标识：
 * 摘    要：九宫格
 *          tztNineCellData 宫格对象
 *          tztNineCellView 宫格视图
 *          tztUINineGridView 九宫格视图
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

#import "tztUINineGridView.h"

NSMutableArray  *g_ayTradeRights = NULL;//交易权限，没有权限的菜单需要隐藏

@interface tztNineCellData(tztPrivate)
@end

@implementation tztNineCellData
@synthesize image = _image;
@synthesize highimage = _highimage;
@synthesize text = _text;
@synthesize cmdid = _cmdid;
@synthesize cmdparam = _cmdparam;
- (id)init
{
    self = [super init];
    if(self)
    {
        self.image = @"Icon.png";
        self.highimage =  @"Icon.png";
        self.text = @"";
        self.cmdid = 0;
        self.cmdparam = @"";
    }
    return self;
}

- (id)initwithCellData:(NSString*)celldata
{
    self = [super init];
    if(self)
    {
        [self setCellData:celldata];
    }
    return self;
}

- (void)dealloc
{
//    self.image = nil;
//    self.highimage =  nil;
//    self.text = nil;
//    self.cmdid = 0;
//    self.cmdparam = nil;
    [super dealloc];
}

//image|标题|功能号|功能参数|
- (void)setCellData:(NSString*)celldata
{
    if (celldata && [celldata length] > 0)
    {
        NSArray* aycell = [celldata componentsSeparatedByString:@"|"];
        if (aycell && [aycell count] > 2) 
        {
            self.image = [aycell objectAtIndex:0];
            self.highimage = _image;
            self.text = [aycell objectAtIndex:1];
            _cmdid = [[aycell objectAtIndex:2]intValue];
            _cmdparam = celldata;
        }
    }
}
@end

@interface tztNineCellView(tztPrivate)
- (void)initdata;
- (void)initsubframe:(CGRect)frame;
- (void)onClicked;
@end

@implementation tztNineCellView
@synthesize tztdelegate = _tztdelegate;
@synthesize cellData = _cellData;
@synthesize clText = _clText;
@synthesize fCellSize = _fCellSize;
- (id)init
{
    self = [super init];
    if(self)
    {
        [self initdata];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initdata]; 
        [self initsubframe:frame];
    }
    return self;
}

- (void)initdata
{
    if(_cellbtn == nil)
    {
        _cellbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cellbtn addTarget:self action:@selector(onClicked) forControlEvents:UIControlEventTouchUpInside];
        _cellbtn.showsTouchWhenHighlighted = YES;
        [self addSubview:_cellbtn];
    }
    
    if(_celllab == nil)
    {
        _celllab = [[UILabel alloc] init];
        [_celllab setTextAlignment:NSTextAlignmentCenter];
        [_celllab setFont:tztUIBaseViewTextBoldFont(11.0f)];
        [_celllab setBackgroundColor:[UIColor clearColor]];
        [_celllab setContentMode:UIViewContentModeCenter];
        _celllab.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_celllab];
        [_celllab release];
    }
}

- (void)setCellData:(tztNineCellData *)cellData
{
    _cellData = cellData;
   if(_celllab)
   {
       NSString* nsTitle = GetTitleByID(_cellData.cmdid);
       if (ISNSStringValid(nsTitle))
           [_celllab setText:nsTitle];
       else
           [_celllab setText:_cellData.text];
       
       if (_clText == nil)
           [_celllab setTextColor:[UIColor whiteColor]];
       else
           [_celllab setTextColor:_clText];
   }

    if (_cellbtn == NULL || CGRectIsEmpty(_cellbtn.frame) || CGRectIsNull(_cellbtn.frame))
        return;
    
   if(_cellbtn)
   {
       CGRect rcFrame = _cellbtn.frame;
       CGFloat showSize = _fCellSize;
       if(showSize <= 0) //按照图片的大小显示
       {
           //区域调整,默认按照a*a(正方形)的大小格式进行处理
           UIImage *image = [UIImage imageTztNamed:_cellData.image];
           //获取最小值 本身区域、图片大小
           CGSize sz = image.size;
           showSize = MIN(rcFrame.size.width, rcFrame.size.height);
           showSize = MIN(showSize, sz.width);
           showSize = MIN(showSize, sz.height);
           if(showSize < 46)
               showSize = 46;
       }
       CGRect rc = rcFrame;
       
       if (_cellData.image == NULL || _cellData.image.length < 1)
       {
           _cellbtn.frame = rc;
           _celllab.hidden = YES;
           _celllab.contentMode = UIViewContentModeCenter;
           
           CGSize sz = [_cellData.text sizeWithFont:_cellbtn.titleLabel.font constrainedToSize:rc.size lineBreakMode:NSLineBreakByWordWrapping];
           
           _cellbtn.titleEdgeInsets = UIEdgeInsetsMake(-((rc.size.height - sz.height) / 2), ((rc.size.width - sz.width) / 2) , 0, (rc.size.width - sz.width) / 2);
           [_cellbtn setTztTitle:_cellData.text];
       }
       else
       {
           rc.size = CGSizeMake(showSize, showSize);
           rc.origin.x = rcFrame.origin.x + (_cellbtn.frame.size.width - showSize) / 2;
           rc.origin.y = rcFrame.origin.y + (_cellbtn.frame.size.height - showSize) / 2;

           if(_celllab)
           {
               CGRect rcLabel = _celllab.frame;
               rcLabel.origin.y -= MAX(0,(rcFrame.size.height - showSize)) / 2;
               _celllab.frame = rcLabel;
           }
           _cellbtn.frame = rc;
           [_cellbtn setImage:[UIImage imageTztNamed:_cellData.image] forState:UIControlStateNormal];
       }
   }
}

- (void)initsubframe:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect btnframe = frame;
    //
    BOOL bShow = TRUE;
    if ((_cellData.text == NULL) || (_cellData.text.length <= 0))
        bShow = FALSE;
    
    if (bShow)
    {
        btnframe = CGRectMake(10, 2, btnframe.size.width - 20, btnframe.size.height - 18);
    }
    else
    {
        btnframe = CGRectMake(10, 2, btnframe.size.width - 20, btnframe.size.height - 2);
    }
    if(_cellbtn)
    {
        [_cellbtn setFrame:btnframe];   
    }
    
    if (bShow)
    {
        btnframe.origin.y += btnframe.size.height+2;
        btnframe.size.height = 13;
        if(_celllab)
        {
            [_celllab setFrame:btnframe];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_cellData.image == NULL || _cellData.image.length < 1)
    {
        [_cellbtn setTztTitle:_cellData.text];
        [_cellbtn setTztTitleColor:[UIColor tztThemeTextColorButton]];
    }
    else
    {
        [_cellbtn setImage:[UIImage imageTztNamed:_cellData.image] forState:UIControlStateNormal];
    }
    if (_celllab)
    {
        if (self.clText)
        {
            _celllab.textColor = self.clText;
        }
        else
        _celllab.textColor = [UIColor tztThemeTextColorLabel];// _clText;// [UIColor tztThemeTextColorLabel];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initsubframe:frame];
}

- (void)onClicked
{
    if(_tztdelegate && [_tztdelegate conformsToProtocol:@protocol(tztNineGridViewDelegate)])
    {
        [_tztdelegate tztNineGridView:nil clickCellData:_cellData];
    }
}

- (void)dealloc
{
    self.tztdelegate = nil;
    self.cellData = nil;
    [super dealloc];
}
@end

@interface tztUINineGridView(tztPrivate)
- (void)initdata;
- (void)initsubframe:(CGRect)frame;
@end

#define tagtztninegrid 0x110000

@implementation tztUINineGridView
@synthesize pScrollView = _pScrollView;
@synthesize tztdelegate = _tztdelegate;
@synthesize rowCount = _rowCount;
@synthesize colCount = _colCount;
@synthesize clText = _clText;
@synthesize nsBackImage = _nsBackImage;
@synthesize bIsMoreView = _bIsMoreView;
@synthesize fCellSize = _fCellSize;
@synthesize nFixCol = _nFixCol;
@synthesize bgColor = _bgColor;
- (id)init
{
    self = [super init];
    if(self)
    {
        [self initdata]; 
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initdata]; 
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tztdelegate = nil;
    DelObject(_aycelldata);
    DelObject(_aycell);
    DelObject(_aycelldataAll);
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initdata
{
    self.tztdelegate = nil;
//    self.pagingEnabled = YES;
    _rowCount = 3;
    _colCount = 3;
    _aycell = NewObject(NSMutableArray);
    _aycelldata = NewObject(NSMutableArray);
    _aycelldataAll = NewObject(NSMutableArray);
    _fCellSize = 0;
    self.nsBackImage = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(OnCheckTradeGrid:)
                                                 name:TZTNotifi_CheckTradeGrid
                                               object:nil];
}

-(void)OnCheckTradeGrid:(NSNotification*)nofi
{
    NSDictionary *pDict = (NSDictionary*)nofi.object;//类型，是否显示
    
    if (pDict == NULL)
        return;
    
    NSString* nsType = [pDict tztObjectForKey:@"FunctionID"];
    int nShow = [[pDict tztObjectForKey:@"Show"] intValue];
    
    int nShowAll = [[pDict tztObjectForKey:@"ShowAll"] intValue];
    
    if (g_ayTradeRights == NULL)
        g_ayTradeRights = NewObject(NSMutableArray);
    
    if (nShowAll)//显示全部
        [g_ayTradeRights removeAllObjects];
    else
        [g_ayTradeRights addObject:pDict];
    
    [_aycelldata removeAllObjects];
    for (int i = 0; i < [_aycelldataAll count]; i++)
    {
        tztNineCellData* celldata = [_aycelldataAll objectAtIndex:i];
        
        if (!nShowAll)
        {
            if ((celldata == NULL) || ((celldata.cmdid == [nsType intValue]) && nShow < 1))
                continue;
        }
        [_aycelldata addObject:celldata];
    }
    
    [self initsubframe:self.frame];
//    if (nShow)
//    {
//        [_ayHideData removeObject:nsType];
//    }
//    else
//    {
//        [_ayHideData addObject:nsType];
//    }
    
    
}

- (void)setAyCellData:(NSArray*)ayCellData;
{
    [_aycelldata removeAllObjects];
    for (int i = 0; i < [ayCellData count]; i++)
    {
        NSString* strCell = [ayCellData objectAtIndex:i];
        if(strCell && [strCell length] > 0)
        {
            tztNineCellData* cellData = NewObject(tztNineCellData);
            [cellData setCellData:strCell];
            
            BOOL bHiden = FALSE;
            for (int j = 0; j < [g_ayTradeRights count]; j++)
            {
                NSDictionary *pDict = [g_ayTradeRights objectAtIndex:j];
                NSString* nsType = [pDict tztObjectForKey:@"FunctionID"];
                int nShow = [[pDict tztObjectForKey:@"Show"] intValue];
                if ((cellData == NULL) || ((cellData.cmdid == [nsType intValue]) && nShow < 1))
                {
                    bHiden = TRUE;
                    break;
                }
            }
            
            
            if (!bHiden)
                [_aycelldata addObject:cellData];
            [cellData release];
        }
    }
    [self initsubframe:self.frame];
}

- (void)setAyCellDataAll:(NSArray*)ayCellData;
{
    [_aycelldataAll removeAllObjects];
    for (int i = 0; i < [ayCellData count]; i++)
    {
        NSString* strCell = [ayCellData objectAtIndex:i];
        if(strCell && [strCell length] > 0)
        {
            tztNineCellData* cellData = NewObject(tztNineCellData);
            [cellData setCellData:strCell];
            [_aycelldataAll addObject:cellData];
            [cellData release];
        }
    }
}


- (void)setColCount:(NSInteger)colCount
{
    _colCount = colCount;
    _nFixCol = _colCount;
    [self initsubframe:self.frame];
}

- (void)setRowCount:(NSInteger)rowCount
{
    _rowCount = rowCount;
    [self initsubframe:self.frame];
}

- (void)initsubframe:(CGRect)frame
{
    CGRect cellframe = frame;
    if(_colCount <= 0)
        _colCount = 3;
    if(_rowCount <=0 )
        _rowCount = 3;
    if (_nFixCol <= 0)
        _nFixCol = _colCount;
    
    if (_pScrollView == NULL)
    {
        _pScrollView = [[UIScrollView alloc] init];
        _pScrollView.pagingEnabled = NO;
        _pScrollView.showsHorizontalScrollIndicator = NO;
        _pScrollView.bounces = NO;
        _pScrollView.showsVerticalScrollIndicator = NO;
        _pScrollView.delegate = self;
        [self addSubview:_pScrollView];
        [_pScrollView release];
//        源代码
       _pScrollView.contentSize = self.bounds.size;
        //        xinlan 首页九宫格上下不滚动
        if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
        {
            _pScrollView.contentSize=CGSizeMake(0, 0);
        }

    }

    _pScrollView.frame = self.bounds;

//    self.contentSize = frame.size;
    CGFloat cellwidth = CGRectGetWidth(cellframe)/_nFixCol;
    CGFloat cellhight = CGRectGetHeight(cellframe)/_rowCount;
    if (cellhight > 90)
        cellhight = 90;
    if (cellhight < _fCellSize && !_bIsMoreView)
    {
        cellhight = _fCellSize;
        _pScrollView.contentSize = CGSizeMake(frame.size.width, cellhight * _rowCount);
//        self.contentSize = CGSizeMake(frame.size.width, cellhight * _rowCount);
    }
    if (_nFixCol < _colCount)
    {
        _pScrollView.contentSize = CGSizeMake(cellwidth * _colCount, (_pScrollView.contentSize.height < frame.size.height ? frame.size.height : _pScrollView.contentSize.height));
    }
    
    for (int i = 0; i < [_aycell count]; i++)
    {
        tztNineCellView* cell = (tztNineCellView*)[_aycell objectAtIndex:i];
        if(cell)
            cell.hidden = YES;
    }
    for (NSInteger i = 0; i < _rowCount; i++)
    {
        for (NSInteger j = 0; j < _colCount; j++)
        {            
            NSInteger nPos = i * _colCount + j;
            CGRect viewframe = CGRectMake(cellwidth * j,cellhight * i,cellwidth,cellhight);
            NSInteger nTag = tagtztninegrid+ nPos;
            tztNineCellView* cell = (tztNineCellView*)[self viewWithTag:nTag];
            if(_aycelldata && nPos < [_aycelldata count])
            {
                if(cell == nil)
                {
                    cell = [[tztNineCellView alloc] init];
                    cell.tztdelegate = self;
                    cell.tag = nTag;
                    [_aycell addObject:cell];
                    cell.hidden = YES;
                    [_pScrollView addSubview:cell];
                    [cell release];
                }
                cell.fCellSize = _fCellSize;
                cell.clText = (_clText == NULL ? [UIColor whiteColor] : _clText);
                cell.hidden = NO;
                [cell setFrame:viewframe];
                cell.cellData = [_aycelldata objectAtIndex:nPos];
//                [cell setFrame:viewframe];
            }
        }
    }
    
    CGRect rcFrame = self.bounds;
    CGRect rcPage = rcFrame;
    rcPage.size = CGSizeMake(110, 10);
    rcPage.origin.x = (rcFrame.size.width - rcPage.size.width) / 2;
    rcPage.origin.y = rcFrame.size.height - rcPage.size.height;
    if (_pageControl == NULL && _nFixCol < _colCount && _nFixCol > 0)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        
        // for iPad index NS_AVAILABLE_IOS(6_0) byDBQ20130828
        if (IS_TZTIPAD && IS_TZTIOS(6)) {
            _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
            _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        }
        [self addSubview:_pageControl];
        [_pageControl release];
        _pageControl.numberOfPages = (_colCount / _nFixCol) + ((_colCount % _nFixCol) ? 1 : 0);
        _pageControl.currentPage = 0;
    }
    _pageControl.frame = rcPage;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.nsBackImage.length > 0)
    {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:self.nsBackImage]];
    }
    else
    {
        if (self.bgColor)
        {
            self.backgroundColor = self.bgColor;
            _pScrollView.backgroundColor = self.bgColor;
        }
        else
        {
            self.backgroundColor = [UIColor tztThemeBackgroundColorJY];
            _pScrollView.backgroundColor = [UIColor tztThemeBackgroundColorJY];
        }
    }
    _pageControl.backgroundColor = [UIColor clearColor];
}

- (void)setFrame:(CGRect)frame
{
//    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
//        return;
//    self.backgroundColor = [UIColor tztThemeBackgroundColorJY];
    [super setFrame:frame];
    [self initsubframe:frame];
}


- (void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    if(_tztdelegate && [_tztdelegate conformsToProtocol:@protocol(tztNineGridViewDelegate)])
    {
        [_tztdelegate tztNineGridView:self clickCellData:cellData];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{   
    int nOffSet = _pScrollView.contentOffset.x;
    int nPage = (nOffSet / self.frame.size.width) + (((int)nOffSet) % ((int)self.frame.size.width) ? 1 : 0);
    if (_pageControl)
        _pageControl.currentPage = nPage;
//    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztNineGridView:clickCellData:)]) {
//        <#statements#>
//    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    int nOffSet = _pScrollView.contentOffset.x;
    int nPage = (nOffSet / self.frame.size.width) + (((int)nOffSet) % ((int)self.frame.size.width) ? 1 : 0);
    if (_pageControl)
        _pageControl.currentPage = nPage;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int nOffSet = _pScrollView.contentOffset.x;
    int nPage = (nOffSet / self.frame.size.width) + (((int)nOffSet) % ((int)self.frame.size.width) ? 1 : 0);
    if (_pageControl)
        _pageControl.currentPage = nPage;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
