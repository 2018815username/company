/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztMutilScrollView.h"
#import "tztPageControl.h"

#define tztPageControlWidth		(110)
#define tztPageControlHeight	(15)
#define tztcontentViewBaseTag	(0x10001)

@interface tztMutilScrollView ()
{
    NSInteger  nCurCountIndex;//当前计数
}
-(void)setLeftViewFrame:(CGRect)nFrame;
-(void)setCurrentViewFrame:(CGRect)nFrame;
-(void)setRightViewFrame:(CGRect)nFrame;
//滚动结束
- (void)setScrollViewEnd:(UIScrollView *)scrollView;
-(void)initdata;
-(void)initsubframe;
@end

@implementation tztMutilScrollView
@synthesize nCurPage = _nCurPage;
@synthesize pageViews = _pageViews;
@synthesize pageControl = _pageControl;
@synthesize bSupportLoop = _bSupportLoop;
@synthesize tztdelegate = _tztdelegate;
@synthesize bUseSysPageControl = _bUseSysPageControl;
@synthesize sysPageControl = _sysPageControl;
@synthesize bounces = _bounces;
@synthesize nMaxCount = _nMaxCount;
@synthesize bLoopScroll = _bLoopScroll;
-(id)init
{
    if (self = [super init])
    {
        _bUseSysPageControl = TRUE;
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
        [self initsubframe];
    }
    return self;
}

-(void)dealloc
{
    if(_pageViews)
    {
        [_pageViews removeAllObjects];
        [_pageViews release];
        _pageViews = nil;
    }
    NilObject(self.tztdelegate);
    [super dealloc];
}

-(void)initdata
{
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
	self.tztdelegate = nil;
    if (_pageViews == nil)
        _pageViews = NewObject(NSMutableArray);
    _nCurPage = 0;
    _bSet = FALSE;
    _bLoopScroll = YES;
    if (_mutilScrollView == nil)
    {
        _mutilScrollView = [[UIScrollView alloc] init];
        _mutilScrollView.delegate = self;
        _mutilScrollView.pagingEnabled = YES;
        _mutilScrollView.showsHorizontalScrollIndicator = NO;
        _mutilScrollView.showsVerticalScrollIndicator = NO;
        _mutilScrollView.canCancelContentTouches = NO;
        _mutilScrollView.bounces = NO;
        _mutilScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_mutilScrollView];
        [_mutilScrollView release];
    }
    
//    if (_bUseSysPageControl)
    {
        if (_pageControl == NULL)
        {
            _pageControl = [[tztPageControl alloc] init];
            _pageControl.userInteractionEnabled = NO;
            _pageControl.backgroundColor = [UIColor clearColor];
            _pageControl.delegate = self;
            // for iPad index NS_AVAILABLE_IOS(6_0) byDBQ20130828
            if (IS_TZTIPAD && IS_TZTIOS(6)) {
    //            _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    //            _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            }
            [self addSubview:_pageControl];
            [_pageControl release];
        }
    }
//    else
    {
        if (_sysPageControl == NULL)
        {
            _sysPageControl = [[UIPageControl alloc] init];
            _sysPageControl.backgroundColor = [UIColor clearColor];
            _sysPageControl.userInteractionEnabled = FALSE;
            [self addSubview:_sysPageControl];
            [_sysPageControl release];
        }
    }
    
    if (IS_TZTIOS(6))
    {
        if (g_nSkinType >= 1)
        {
            _sysPageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
            _sysPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        }
        else
        {
            _sysPageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
            _sysPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    _pageControl.backgroundColor = [UIColor tztThemeBackgroundColor];
    self.backgroundColor =  [UIColor tztThemeBackgroundColorHQ];
    _sysPageControl.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    if (IS_TZTIOS(6))
    {
        if (g_nSkinType >= 1)
        {
            _sysPageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
            _sysPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        }
        else
        {
            _sysPageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
            _sysPageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5];
        }
    }
}

-(void)initsubframe
{
    CGRect rcFrame = self.bounds;
    CGRect rcPage = rcFrame;
    rcPage.size = CGSizeMake(tztPageControlWidth, tztPageControlHeight);
    if (self.hidePagecontrol)
        rcPage.size.height = 0;
    rcPage.origin.x = (rcFrame.size.width - rcPage.size.width) / 2;
    rcPage.origin.y = rcFrame.size.height - rcPage.size.height;
    if (_mutilScrollView)
    {
        _mutilScrollView.bounces = _bounces;
        _mutilScrollView.frame = rcFrame;
        _nPageCount = [_pageViews count];

        _mutilScrollView.contentSize = CGSizeMake(rcFrame.size.width * MIN(3,_nPageCount), rcFrame.size.height);
        
        
        if (!_bSupportLoop || !_bLoopScroll)
        {
            _mutilScrollView.contentOffset = CGPointMake(rcFrame.size.width * _nCurPage, 0);
        }
        else
            _mutilScrollView.contentOffset = CGPointMake(rcFrame.size.width, 0);
            
        
        if ((!_bSupportLoop || !_bLoopScroll) && _nPageCount < 3)
        {
            CGRect rcLeft = CGRectMake(0, 0, rcFrame.size.width, rcFrame.size.height - rcPage.size.height);
            [self setLeftViewFrame:rcLeft];
            
            CGRect rcRigth = CGRectMake(rcFrame.size.width, 0, rcFrame.size
                                        .width, rcFrame.size.height - rcPage.size.height);
            [self setRightViewFrame:rcRigth];
            
            CGRect rcCenter = CGRectMake(rcFrame.size.width * _nCurPage, 0, rcFrame.size
                                         .width, rcFrame.size.height - rcPage.size.height);
            [self setCurrentViewFrame:rcCenter];
        }
        else
        {
            CGRect rcLeft = CGRectMake(0, 0, rcFrame.size.width, rcFrame.size.height - rcPage.size.height);
            [self setLeftViewFrame:rcLeft];
            
            CGRect rcRigth = CGRectMake(rcFrame.size.width * 2, 0, rcFrame.size
                                        .width, rcFrame.size.height - rcPage.size.height);
            [self setRightViewFrame:rcRigth];
            
            CGRect rcCenter = CGRectMake(rcFrame.size.width, 0, rcFrame.size
                                         .width, rcFrame.size.height - rcPage.size.height);
            [self setCurrentViewFrame:rcCenter];
        }

        //
        [self setOtherViewFrame];
    
        if (_bUseSysPageControl)
        {
            _sysPageControl.numberOfPages = _nPageCount;
            _sysPageControl.currentPage = (_bSupportLoop ? _nCurPage : (_nCurPage - 1 >= 0 ? _nCurPage - 1 : 0));
            _sysPageControl.frame = rcPage;
            if (self.hidePagecontrol) {
                _pageControl.hidden = YES;
                _sysPageControl.hidden = YES;
            }
            else
            {
                _pageControl.hidden = YES;
                _sysPageControl.hidden = NO;
            }
        }
        else
        {
            if (self.hidePagecontrol) {
                _pageControl.hidden = YES;
                _sysPageControl.hidden = YES;
            }
            else
            {
                _sysPageControl.hidden = YES;
                _pageControl.hidden = NO;
            }
            if (_pageControl)
            {
                //            _pageControl.numberOfPages = _nPageCount;
                _pageControl.page = (_bSupportLoop ? _nCurPage : (_nCurPage - 1 >= 0 ? _nCurPage - 1 : 0));
                _pageControl.frame = rcPage;
            }
        }
        
    }
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    [self initsubframe];
}

- (void)setScrollEnabled:(BOOL)bScroll
{
    if (_mutilScrollView)
    {
        _mutilScrollView.scrollEnabled = bScroll;
        _mutilScrollView.pagingEnabled = bScroll;
    }
}

-(NSMutableArray*) getPageViews
{
    return _pageViews;
}

-(void)setPageViews:(NSMutableArray *)pageViews
{
    if (_pageViews)
    {
        for (int i = 0; i < [_pageViews count]; i++)
        {
            UIView* temp = [_pageViews objectAtIndex:i];
            [temp removeFromSuperview];
        }
        [_pageViews removeAllObjects];
    }
    
    if (pageViews && [pageViews count] > 0)
    {
        for (int i = 0; i < [pageViews count]; i++)
        {
            UIView *pView = [pageViews objectAtIndex:i];
            [_pageViews addObject:pView];
            [_mutilScrollView addSubview:[pageViews objectAtIndex:i]];
        }
    }
}

-(void)setLeftViewFrame:(CGRect)nFrame
{
    NSInteger nLeft = _nCurPage -1;
    if (nLeft < 0)
    {
        if (_bSupportLoop)
            nLeft = _nPageCount - 1;
        else
            return;
    }
    if (nLeft >= [_pageViews count])
        return;
    UIView *pView = [_pageViews objectAtIndex:nLeft];
    pView.frame = nFrame;
}

-(void)setCurrentViewFrame:(CGRect)nFrame
{
    if (_nCurPage < 0 || _nCurPage >= _nPageCount)
        _nCurPage = 0;
    
    if (_nCurPage >= [_pageViews count])
        return;
    UIView *pView = [_pageViews objectAtIndex:_nCurPage];
    pView.frame = nFrame;
}


-(void)setRightViewFrame:(CGRect)nFrame
{
    NSInteger nRight = _nCurPage + 1;
    if (nRight >= _nPageCount)
    {
        if (_bSupportLoop)
            nRight = 0;
        else
            return;
    }
    if (nRight >= [_pageViews count])
        return;
    UIView *pView = [_pageViews objectAtIndex:nRight];
    pView.frame = nFrame;
}

/*
 循环滚动的时候，超过3个循环的时候，需要将除了当前的、左侧的、右侧的view之外的，设置到其他区域，
 因为这些view可能在滚动的时候已经设置过偏移了，导致跟其他要显示的view的区域重叠，界面会先显示该view，然后再显示正确的view
 by yinjp
 */
-(void)setOtherViewFrame
{
    if ([_pageViews count] <= 3 || !_bSupportLoop)
        return;
    
    NSInteger nLeft = _nCurPage -1;
    if (nLeft < 0)
        nLeft = _nPageCount - 1;
    NSInteger nRight = _nCurPage + 1;
    if (nRight >= _nPageCount)
        nRight = 0;
    
    for (int i = 0; i < [_pageViews count]; i++)
    {
        if (i == _nCurPage || i == nLeft || i == nRight)
            continue;
        UIView *pView = [_pageViews objectAtIndex:i];
        CGRect rcFrame = pView.frame;
        rcFrame.origin.x = -320;
        pView.frame = rcFrame;
    }
}

-(void)setScrollViewFrame
{
    if (_mutilScrollView)
    {
        CGFloat offx = _mutilScrollView.contentOffset.x;
        CGRect rcFrame = self.bounds;
        
        if (!_bSupportLoop)
        {
            if (rcFrame.size.width <= 0)
                return;
            _nCurPage = offx / rcFrame.size.width;
        }
        else
        {
            if (offx < rcFrame.size.width  / 2 )
            {
                if(!_bSupportLoop && _nCurPage <= 0)
                    return;
                if (!_bLoopScroll)
                {
                    nCurCountIndex--;
                    if (nCurCountIndex <= 0)
                    {
                        nCurCountIndex = 0;
                        return;
                    }
                }
                offx += rcFrame.size.width;
                _nCurPage--;
                if (_nCurPage < 0)
                {
                    _nCurPage = _nPageCount - 1;
                }
            }
            else if (offx > rcFrame.size.width * 3 / 2)
            {
                if(!_bSupportLoop && _nCurPage >= _nPageCount - 1)
                    return;
                if (!_bLoopScroll)
                {
                    nCurCountIndex++;
                    if (nCurCountIndex >= _nMaxCount)
                    {
                        nCurCountIndex = _nMaxCount;
                        return;
                    }
                }
                _nCurPage++;
                if (_nCurPage >= _nPageCount)
                {
                    _nCurPage = 0;
                }
                offx -= rcFrame.size.width;
            }
            else
            {
                return;
            }
            float fPageSizeHeight = tztPageControlHeight;
            if (_hidePagecontrol)
                fPageSizeHeight = 0;
            _mutilScrollView.contentSize = CGSizeMake(rcFrame.size.width * MIN(_nPageCount,3), rcFrame.size.height);
            
            CGRect rcCenter = CGRectMake(rcFrame.size.width, 0, rcFrame.size.width, rcFrame.size.height - fPageSizeHeight);
            [self setCurrentViewFrame:rcCenter];
            
            CGRect rcLeft = CGRectMake(0, 0, rcFrame.size.width, rcFrame.size.height - fPageSizeHeight);
            [self setLeftViewFrame:rcLeft];
            
            CGRect rcRight = CGRectMake(rcFrame.size.width * 2, 0, rcFrame.size.width, rcFrame.size.height - fPageSizeHeight);
            [self setRightViewFrame:rcRight];
            
            [self setOtherViewFrame];
            
            _mutilScrollView.contentOffset = CGPointMake(offx, 0);
        }
        
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztMutilPageViewDidAppear:)])
        {
            [_tztdelegate tztMutilPageViewDidAppear:_nCurPage];
        }
    }
    
    if (_bUseSysPageControl)
    {
        _sysPageControl.currentPage = _nCurPage;
    }
    else
        _pageControl.page = _nCurPage;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidScroll %f",scrollView.contentOffset.x);
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewWillBeginDragging %f",scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self setScrollViewFrame];
    }
}

- (void)setScrollViewEnd:(UIScrollView *)scrollView
{
    [self setScrollViewFrame];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setScrollViewEnd:scrollView];
}

//zxl 20130930 直接设置index 界面 和设置的时候是后有动画效果
- (void)scrollToIndex:(NSInteger)aIndex animated:(BOOL)animated
{
    if (aIndex < 0 || aIndex >= _nPageCount)
        return;
    
    [_mutilScrollView setContentOffset:CGPointMake(aIndex * self.frame.size.width, 0) animated:animated];
}

- (void)scrollToView:(UIView*)pView animated:(BOOL)animated
{
    int nIndex = -1;
    for (int i = 0; i < [self.pageViews count]; i++)
    {
        UIView *pSubView = [self.pageViews objectAtIndex:i];
        if (pSubView == NULL)
            continue;
        if (pView == pSubView)
        {
            nIndex = i;
            break;
        }
    }
    
    if (nIndex < 0)
        return;
    if (_nCurPage == nIndex)
        return;
    
    _nCurPage = nIndex;
    
    CGFloat offx = _mutilScrollView.contentOffset.x;
    CGRect rcFrame = self.bounds;
    
    float fPageSizeHeight = tztPageControlHeight;
    if (_hidePagecontrol)
        fPageSizeHeight = 0;
    _mutilScrollView.contentSize = CGSizeMake(rcFrame.size.width * MIN(_nPageCount,3), rcFrame.size.height);
    
    
    if ((!_bSupportLoop || !_bLoopScroll) && _nPageCount < 3)
    {
        CGRect rcLeft = CGRectMake(0, 0, rcFrame.size.width, rcFrame.size.height - fPageSizeHeight);
        [self setLeftViewFrame:rcLeft];
        
        CGRect rcRigth = CGRectMake(rcFrame.size.width, 0, rcFrame.size
                                    .width, rcFrame.size.height - fPageSizeHeight);
        [self setRightViewFrame:rcRigth];
        
        CGRect rcCenter = CGRectMake(rcFrame.size.width * _nCurPage, 0, rcFrame.size
                                     .width, rcFrame.size.height - fPageSizeHeight);
        [self setCurrentViewFrame:rcCenter];
        offx = rcCenter.size.width * _nCurPage;
    }
    else
    {
        CGRect rcCenter = CGRectMake(rcFrame.size.width, 0, rcFrame.size.width, rcFrame.size.height - fPageSizeHeight);
        [self setCurrentViewFrame:rcCenter];
        
        CGRect rcLeft = CGRectMake(0, 0, rcFrame.size.width, rcFrame.size.height - fPageSizeHeight);
        [self setLeftViewFrame:rcLeft];
        
        CGRect rcRight = CGRectMake(rcFrame.size.width * 2, 0, rcFrame.size.width, rcFrame.size.height - fPageSizeHeight);
        [self setRightViewFrame:rcRight];
    }
    
    [self setOtherViewFrame];
    
    _mutilScrollView.contentOffset = CGPointMake(offx, 0);
    
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztMutilPageViewDidAppear:)])
    {
        [_tztdelegate tztMutilPageViewDidAppear:_nCurPage];
    }
}
@end
