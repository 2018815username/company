/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUIBaseGridView.m
 * 文件标识：
 * 摘    要：自定义Grid基础功能 表格基本组成、表格基本功能
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
#import <QuartzCore/QuartzCore.h>
#import "TZTUIBaseGridView.h"
#import "TZTUIImageDefine.h"

#define ReqPageCount 3
@interface TZTUIScrollView ()
{
	BOOL _singleScroll; //单向滚动
    NSInteger _orientationScroll;//滚动方向
	CGPoint _starPointScroll;	//起始滚动点
}
@property BOOL singleScroll;
@property NSInteger orientationScroll;
- (void)SetStarPoint:(CGPoint)point;
- (void)CatchStarPoint;
- (void)ReleaseStarPoint;
@end

@implementation TZTUIScrollView

@synthesize singleScroll = _singleScroll;
@synthesize orientationScroll = _orientationScroll;
@synthesize tztDelegate = _tztDelegate;
- (id)init
{
    if(self = [super init])
    {
        self.directionalLockEnabled = YES;
        self.canCancelContentTouches = YES;
        self.delaysContentTouches = YES;
    }
    return self;
}

- (void)SetStarPoint:(CGPoint)point
{
//    if(IS_TZTIOS(7))
    {
        if (self.singleScroll) //单向滚动
        {
            int nXPos = abs(point.x - _starPointScroll.x);
            int nYPos = abs(point.y - _starPointScroll.y);

            if (_orientationScroll == -1)
            {
                if (nXPos > nYPos)
                {
                    _orientationScroll = 1; //左右滚动
                }
                else
                {
                    _orientationScroll = 2; //上下滚动
                }
            }
        }
    }

}

- (void)CatchStarPoint
{
//    if(IS_TZTIOS(7))
    {
        _orientationScroll = -1;
        _starPointScroll = self.contentOffset;
    }
}

- (void)ReleaseStarPoint
{
//    if(IS_TZTIOS(7))
    {
        _orientationScroll = 0;
        _starPointScroll = self.contentOffset;
    }
}

- (void)setContentOffset:(CGPoint)offset
{
//    if(IS_TZTIOS(7))
    {
        if (offset.x < 0)
            offset.x = 0;
        
        if (self.singleScroll) //单向滚动
        {
            if (_orientationScroll == -1) //双向滚动？
            {
                [self SetStarPoint:offset]; 
            }
            
            if (_orientationScroll == 1) 
            {
                offset.y = _starPointScroll.y;
            }
            else if (_orientationScroll == 2)
            {
                offset.x = _starPointScroll.x;
            }
        }
    }
	[super setContentOffset:offset];
}
@end

@interface TZTUIBaseGridView ()
{
    UILabel*    _labtip;
    BOOL    _bTopDraging;                    //上部view drag
    BOOL    _bLeftDraging;                   //左边view drag
    BOOL    _bCenterpDraging;                //中间view drag
}
//根据偏移量请求新数据
- (void)scrollviewDidRequest:(CGPoint)offSet;
//同时滚动
- (void)SetScrollViewContent:(UIScrollView*)ScrollView rect:(CGRect)ScrollRect flag:(BOOL)flag;
@end

@implementation TZTUIBaseGridView
@synthesize  topleftview = _topleftview;
@synthesize  topview = _topview;
@synthesize  leftview = _leftview;
@synthesize  centerview = _centerview;

@synthesize  nTopViewHeight = _nTopViewHeight;
@synthesize  nLeftCellWidth = _nLeftCellWidth;
@synthesize  nDefaultCellHeight = _nDefaultCellHeight;
@synthesize  nDefaultCellWidth = _nDefaultCellWidth;

@synthesize  szCenterViewSize = _szCenterViewSize;

@synthesize  reqAdd = _reqAdd;
@synthesize  colCount = _colCount;
@synthesize  rowCount = _rowCount;
@synthesize  fixColCount = _fixColCount;
@synthesize  fixRowCount = _fixRowCount;
@synthesize  haveCode = _haveCode;
@synthesize  nCurPage = _nCurPage;
@synthesize  nValueCount = _nValueCount;
@synthesize  nPageCount = _nPageCount;
@synthesize  nReqPage = _nReqPage;
@synthesize  indexStarPos = _indexStarPos;
@synthesize  nReportType = _nReportType;
- (id)init
{
    self = [super init];
    if(self)
    {
        [self initdata];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) 
    {
        [self initdata];
        [self onSetSubViewFrame:self.frame];
    }
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self onSetSubViewFrame:frame];
}

- (void)initdata
{
    _bTopDraging = FALSE;
    _bLeftDraging = FALSE;
    _bCenterpDraging = FALSE;
    
    _colCount = tztJYScrollGrid_Min_Col;
    _fixColCount = 1;
    _fixRowCount = 0;
    _haveCode = FALSE;
    
    _nCurPage = 1;
    _nPageCount = 1;
    _nReqPage = ReqPageCount;
    
    
//    _nDefaultCellHeight = TZTTABLECELLHEIGHT;
//    _nDefaultCellWidth = TZTTABLECELLWIDTH;
//
//    _nLeftCellWidth = TZTTABLECELLWIDTH;
    _nDefaultCellHeight = TZTTABLECELLHEIGHT + (IS_TZTIPAD? 6 : 0);
    _nDefaultCellWidth = TZTTABLECELLWIDTH + (IS_TZTIPAD? 25 : 0);
    _nLeftCellWidth = TZTTABLECELLWIDTH + (IS_TZTIPAD? 40 : 0);
//#ifdef tzt_GJSC
    _nTopViewHeight = TZTTABLECELLHEIGHT - 10 + _nDefaultCellHeight * _fixRowCount;
//#else
//    _nTopViewHeight = TZTTABLECELLHEIGHT + _nDefaultCellHeight * _fixRowCount;
//#endif

}

- (void)onSetSubViewFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame) || CGRectIsNull(self.frame) || CGRectIsEmpty(self.frame))
    {
        return;
    }
    
    if(_nDefaultCellHeight < TZTTABLECELLMINHEIGHT)
		_nDefaultCellHeight = TZTTABLECELLMINHEIGHT;
    
    if (_nTopViewHeight <= 0)
    {
        //顶部页面高度
        _nTopViewHeight = (TZTTABLECELLHEIGHT - 10) + _nDefaultCellHeight * _fixRowCount;
    }
    
    //内容显示页面高度
    CGFloat fShowHeight = self.frame.size.height - _nTopViewHeight;
    
    //显示数据数
    _nPageRow = (int)(fShowHeight / _nDefaultCellHeight);
    BOOL bFlag = FALSE;
    if (_rowCount > 0)
    {
        bFlag = TRUE;
        if (_nReqPage != 0)
            _reqAdd = _rowCount / 3;
        else
            _reqAdd = 0;
        
        if (_rowCount <= _nPageRow && ((int)fShowHeight % (int)_nDefaultCellHeight) != 0)
        {
            _rowCount += 1;
        }
        
        CGSize szNewViewSize = CGSizeMake(_nDefaultCellWidth * _colCount,_nDefaultCellHeight * _rowCount);
        
        [self SetCenterViewSize:szNewViewSize];
    }
    else
    {
        if(_nReqPage != 0)
        {
            _rowCount = (_nPageRow-_fixRowCount) * _nReqPage;
            _reqAdd = _rowCount / 3;
        }
        else
        {
            _rowCount = _nPageRow - _fixRowCount;
            _reqAdd = 0;
        }
        _szCenterViewSize = CGSizeMake(_nDefaultCellWidth * _colCount, _nDefaultCellHeight * _rowCount);
        if (_szCenterViewSize.width < frame.size.width)
        {
            _szCenterViewSize.width = frame.size.width;
        }
    }
    
    
    if (_topleftview == nil)
    {
        _topleftview = [[UIView alloc] init];
        _topleftview.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_topleftview];
        [_topleftview release];
    }
    
    if (_topview == NULL)
    {
        _topview = [[TZTUIScrollView alloc] init];
        _topview.scrollEnabled = NO;
        _topview.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_topview];
        [_topview release];
    }
    
    
    if (_leftview == NULL)
    {
        _leftview = [[TZTUIScrollView alloc] init];
		_leftview.singleScroll = TRUE;
        _leftview.showsHorizontalScrollIndicator = NO;
        _leftview.showsVerticalScrollIndicator = NO;
        _leftview.bounces = FALSE;
        _leftview.delegate = self;
        _leftview.backgroundColor = [UIColor clearColor];
        
        _leftview.scrollEnabled = YES;
        _leftview.delaysContentTouches = YES;
		_leftview.directionalLockEnabled = YES;
        [self addSubview:_leftview];
        [_leftview release];
    }
    
    if (_centerview == NULL)
    {
        _centerview = [[TZTUIScrollView alloc] init];
		_centerview.singleScroll = TRUE;
        _centerview.bounces = FALSE;
        _centerview.delegate = self;
        _centerview.tztDelegate = self;
        _centerview.backgroundColor = [UIColor clearColor];
        _centerview.delaysContentTouches = YES;
		_centerview.directionalLockEnabled = YES;
        _centerview.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [self addSubview:_centerview];
        [_centerview release];
    }

    _topleftview.frame = CGRectMake(0, 0, _nLeftCellWidth * _fixColCount-1, _nTopViewHeight);
    CGRect rcFrame = frame;
    rcFrame.origin = CGPointZero;
    rcFrame.size.height = _nTopViewHeight;
    rcFrame.size.width = _nLeftCellWidth * _fixColCount-1;
    
    //Top View
    rcFrame.origin.y = 0;
    rcFrame.origin.x = _topleftview.frame.size.width;
    rcFrame.size.height = _topleftview.frame.size.height;
    rcFrame.size.width = frame.size.width - _topleftview.frame.size.width;
    if (rcFrame.size.width < 0)
        rcFrame.size.width = 0;
    _topview.frame = rcFrame;
    _topview.contentSize = CGSizeMake(_szCenterViewSize.width, rcFrame.size.height);
    
    
    //Left View
    rcFrame.origin.x = 0;
    rcFrame.origin.y = _topleftview.frame.size.height;
    rcFrame.size.height = frame.size.height - _topleftview.frame.size.height;
    rcFrame.size.width = _topleftview.frame.size.width;
    if (rcFrame.size.height < 0)
        rcFrame.size.height = 0;
    _leftview.frame = rcFrame;
    _leftview.contentSize = CGSizeMake(rcFrame.size.width, _szCenterViewSize.height);
    
    //Center View
    rcFrame.origin.x = _topleftview.frame.size.width;
    rcFrame.origin.y = _topleftview.frame.size.height;
    rcFrame.size.height = frame.size.height - _topleftview.frame.size.height;
    rcFrame.size.width = frame.size.width - _topleftview.frame.size.width;
    if (rcFrame.size.width < 0)
        rcFrame.size.width = 0;
    if (rcFrame.size.height < 0)
        rcFrame.size.height = 0;
    _centerview.frame = rcFrame;
    _centerview.contentSize = _szCenterViewSize;
    
}
- (void)setNDefaultCellHeight:(CGFloat)nDefaultCellHeight
{
    _nDefaultCellHeight = nDefaultCellHeight;
    [self onSetSubViewFrame:self.frame];
}


//修改设置ViewSize大小返回值，避免因为父类处理成功后，子类无法判断设置大小的问题。
-(BOOL) SetCenterViewSize:(CGSize)szSize
{
    if(_centerview == nil)
        return FALSE;

    if (CGSizeEqualToSize(szSize, _szCenterViewSize))
        return FALSE;
    
    _szCenterViewSize = szSize;
    
    if (_centerview)
    {
        CGSize size = _szCenterViewSize;
        _centerview.contentSize = size;
    }
    
    if (_topview)
    {
        CGSize size = _topview.contentSize;
        size.width = _szCenterViewSize.width;
        _topview.contentSize = size;
    }
    
    if (_leftview)
    {
        CGSize size = _leftview.contentSize;
        size.height = _szCenterViewSize.height;
        _leftview.contentSize = size;
    }
	return TRUE;
}

- (void)setColCount:(NSInteger)colCount
{
    if(_colCount != colCount)
    {
        _colCount = colCount;
        [self onSetSubViewFrame:self.frame];
    }
}

- (void)setFixColCount:(NSInteger)fixColCount
{
    if(fixColCount != _fixColCount)
    {
        _fixColCount = fixColCount;
        [self onSetSubViewFrame:self.frame];
    }
}

- (void)setFixRowCount:(NSInteger)fixRowCount
{
    if(_fixRowCount != fixRowCount)
    {
        _fixRowCount = fixRowCount;
        [self onSetSubViewFrame:self.frame];
    }
}

//设置总页数 是否显示翻页
- (void)setNPageCount:(NSInteger)nPageCount
{
    _nPageCount = nPageCount;
}

- (void)SetScrollViewContent:(UIScrollView*)ScrollView rect:(CGRect)ScrollRect flag:(BOOL)flag
{
    if (ScrollView == _topview && ScrollRect.origin.x != _topview.contentOffset.x)
    {
        CGPoint ptContent = ScrollView.contentOffset;

        ptContent.x = ScrollView.frame.size.width * ScrollRect.origin.x / ScrollRect.size.width;
        
        [ScrollView setContentOffset:ptContent animated:NO];
        
        if (flag)
        {
            [ScrollView flashScrollIndicators];
        }
    }
    else if (ScrollView == _centerview && ScrollRect.origin.y != _centerview.contentOffset.y)
    {
        CGPoint ptContent = ScrollView.contentOffset;
        
        ptContent.y = ScrollView.frame.size.height * ScrollRect.origin.y / ScrollRect.size.height;
        
        [ScrollView setContentOffset:ptContent animated:NO];
        
        if (flag)
        {
            [ScrollView flashScrollIndicators];
        }
    }
    else if (ScrollView == _leftview && ScrollRect.origin.y != _leftview.contentOffset.y)
    {
        CGPoint ptContent = ScrollView.contentOffset;
        
        ptContent.y = ScrollView.frame.size.height * ScrollRect.origin.y / ScrollRect.size.height;
        
        [ScrollView setContentOffset:ptContent animated:NO];
        
        if (flag)
        {
            [ScrollView flashScrollIndicators];
        }
    }
}

- (NSInteger)OnPageBack
{
	return 1;
}

- (NSInteger)OnPageNext
{
	return 1;
}

- (NSInteger)OnPageRefresh
{
    return 1;
}

- (void)scrollviewDidRequest:(CGPoint)offSet
{
    if(_nReqPage == 0)
        return;
#ifndef Support_HTSC
    CGRect tipframe = CGRectMake((self.frame.size.width - 150) / 2, self.frame.size.height - 35, 150, 30);
    if (_labtip == nil)
    {
        _labtip = [[UILabel alloc] initWithFrame:tipframe];
        _labtip.layer.cornerRadius = 5;
        _labtip.layer.borderWidth = .5f;
        _labtip.font = tztUIBaseViewTextFont(14.f);
        
        _labtip.layer.borderColor = [UIColor tztThemeBorderColor].CGColor;
        _labtip.backgroundColor = [UIColor tztThemeBackgroundColor];
        _labtip.textColor = [UIColor tztThemeTextColorLabel];
        _labtip.hidden = YES;
        _labtip.adjustsFontSizeToFitWidth = YES;
        [_labtip setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_labtip];
        [self bringSubviewToFront:_labtip];
        [_labtip release];
    }
    else
    {
        _labtip.frame = tipframe;
    }
#endif
    
    CGFloat fheight = _centerview.frame.size.height;
    BOOL bTip = FALSE;
    NSInteger nReqCurPage = _nCurPage;
    
    NSInteger nStartPos = 0;
    if (offSet.y > (_centerview.contentSize.height - fheight) * 2 / 3 )//滚动一屏
    {
        nStartPos = [self OnPageNext];
        bTip = TRUE;
        nReqCurPage++;
        
    }
    else if(offSet.y < (_centerview.contentSize.height - fheight) / 3 && (_indexStarPos > 1 || _nPageCount == 0))
    {
        nStartPos = [self OnPageBack];
        bTip = TRUE;
        nReqCurPage--;
    }
    
    //显示第一页
    if(offSet.y <= 0 && _indexStarPos<=1)
    {
        if(_labtip)
        {
            [self bringSubviewToFront:_labtip];
            _labtip.text = @"第一页";
            CATransition *animation = [CATransition animation];//初始化动画
            animation.delegate = self;
            animation.duration = 0.6f;//间隔的时间
            animation.timingFunction = UIViewAnimationCurveEaseInOut;//过渡效果
            animation.type = kCATransitionPush;//设置上面4种动画效果
            animation.subtype = kCATransitionFromTop;//设置动画的方向，有四种
            [_labtip.layer addAnimation:animation forKey:@"animationTipID"];
        }
    }
    /*
    else if(_nValueCount > 0 && _indexStarPos+_rowCount >= _nValueCount && _nReportType == tztReportUserStock ) //最后一页
    {
        if (_nReportType == tztReportUserStock)
        {
            CGSize szNewViewSize = CGSizeMake(self.nDefaultCellWidth * self.colCount,self.nDefaultCellHeight * self.rowCount);
            szNewViewSize.height += 150;// _pAddSynsView.frame.size.height;
            [self SetCenterViewSize:szNewViewSize];
            [self setNeedsDisplay];
        }
        else
        {
            
            [self bringSubviewToFront:_labtip];
            _labtip.text = @"最后一页";
            CATransition *animation = [CATransition animation];//初始化动画
            animation.delegate = self;
            animation.duration = 0.6f;//间隔的时间
            animation.timingFunction = UIViewAnimationCurveEaseInOut;//过渡效果
            animation.type = kCATransitionPush;//设置上面4种动画效果
            animation.subtype = kCATransitionFromTop;//设置动画的方向，有四种
            [_labtip.layer addAnimation:animation forKey:@"animationTipID"];
        }
    }
     */
    else if(_nValueCount > 0 && offSet.y >= _centerview.contentSize.height - fheight && _indexStarPos+_rowCount >= _nValueCount /*&& _nReportType != tztReportUserStock*/ ) //最后一页
    {
        [self bringSubviewToFront:_labtip];
        _labtip.text = @"最后一页";
        CATransition *animation = [CATransition animation];//初始化动画
        animation.delegate = self;
        animation.duration = 0.6f;//间隔的时间
        animation.timingFunction = UIViewAnimationCurveEaseInOut;//过渡效果
        animation.type = kCATransitionPush;//设置上面4种动画效果
        animation.subtype = kCATransitionFromTop;//设置动画的方向，有四种
        [_labtip.layer addAnimation:animation forKey:@"animationTipID"];
    }
    else if(_rowCount > 0 && _nPageCount > 1)
    {
        if(bTip)
        {
            NSString* strTip = @"";
            if (nStartPos <= 0)
                nStartPos = 1;
            strTip = [NSString stringWithFormat:@"当前第%ld～%ld,共%ld条",  (long)nStartPos, (long)((nStartPos + _rowCount - _reqAdd) > _nValueCount ? _nValueCount :(nStartPos + _rowCount - _reqAdd)), (long)_nValueCount];
            [self bringSubviewToFront:_labtip];
            _labtip.text = strTip;
            CATransition *animation = [CATransition animation];//初始化动画
            animation.delegate = self;
            animation.duration = 0.6f;//间隔的时间
            animation.timingFunction = UIViewAnimationCurveEaseInOut;//过渡效果
            animation.type = kCATransitionPush;//设置上面4种动画效果
            animation.subtype = kCATransitionFromTop;//设置动画的方向，有四种
            [_labtip.layer addAnimation:animation forKey:@"animationTipID"];
        }
    }
    
   
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if(_labtip)
        _labtip.hidden = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(_labtip)
        _labtip.hidden = YES;
}

// any zoom scale changes
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
}

- (void)SetContentScrollView:(UIScrollView *)scrollView flag:(BOOL)flag
{
    if (scrollView == _centerview
        || scrollView == _leftview
        )
    {
        TZTUIScrollView* tztScrollView = (TZTUIScrollView *)scrollView;
        CGRect rc;
        rc.origin = tztScrollView.contentOffset;
        rc.size = _centerview.frame.size;
        if(tztScrollView == _centerview)
            [self SetScrollViewContent:_topview rect:rc flag:flag];
        [self SetScrollViewContent:(tztScrollView == _centerview ? _leftview : _centerview) rect:rc flag:flag];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self SetContentScrollView:scrollView flag:FALSE];
}

// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self SetContentScrollView:scrollView flag:FALSE];
}

//// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _centerview
        || scrollView == _leftview
        )
    {
        TZTUIScrollView* tztScrollView = (TZTUIScrollView *)scrollView;
		_bCenterpDraging = TRUE;
		[tztScrollView CatchStarPoint];
        [self SetContentScrollView:scrollView flag:FALSE];
    }
}

- (void)setScrollViewEnd:(UIScrollView *)scrollView flag:(BOOL)bFlag
{
    if (scrollView == _centerview
        || scrollView == _leftview
        )
    {
        TZTUIScrollView* tztScrollView = (TZTUIScrollView *)scrollView;
        [self SetContentScrollView:scrollView flag:bFlag];
        CGRect rc;
        rc.origin = tztScrollView.contentOffset;
        rc.size = _centerview.frame.size;
        
        if(_labtip)
            _labtip.hidden = YES;
//        if(tztScrollView.orientationScroll == 2)
        {
            [self scrollviewDidRequest:rc.origin];
        }
        _bCenterpDraging = FALSE;
        [tztScrollView ReleaseStarPoint];
    }
}

//// called on finger up if user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    TZTLogInfo(@"scrollViewDidEndDragging");
    if (scrollView == _centerview
        || scrollView == _leftview
        )
    {
        if(!decelerate)
        {
            [self setScrollViewEnd:scrollView flag:TRUE];
        }
    }
}
//
//// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _centerview
        || scrollView == _leftview
        )
    {
        TZTUIScrollView* tztScrollView = (TZTUIScrollView *)scrollView;
		[tztScrollView CatchStarPoint];
        [self SetContentScrollView:scrollView flag:FALSE];
    }
}

//// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    TZTLogInfo(@"scrollViewDidEndDecelerating");
    if (scrollView == _centerview
        || scrollView == _leftview
        )
    {
        [self setScrollViewEnd:scrollView flag:FALSE];
    }
}

- (void)dataupdataOffset:(NSInteger)nChangeRow //数据偏移量
{
    if(_nReqPage == 0)
        return;
    CGRect rc;
    CGFloat rcBottom = _centerview.contentSize.height - _centerview.frame.size.height;
    rc.origin = _centerview.contentOffset;
    rc.size = _centerview.frame.size;
    if (nChangeRow < -_rowCount) //滚动到最前面
    {
        rc.origin.y = 0;
    }
    else if(nChangeRow > _rowCount) //滚动到最后
    {
        rc.origin.y = rcBottom;
    }
    else //根据数据变化量滚动
        rc.origin.y -= (nChangeRow * _nDefaultCellHeight);
    
    if(rc.origin.y < 0 )
        rc.origin.y = 0;
    
    if(rc.origin.y > rcBottom)
        rc.origin.y = rcBottom;
    
    _bCenterpDraging = FALSE;
    [_centerview ReleaseStarPoint];
    [self SetScrollViewContent:_topview rect:rc flag:FALSE];
    [self SetScrollViewContent:_centerview rect:rc flag:FALSE];
    [self SetScrollViewContent:_leftview rect:rc flag:FALSE];
//    _centerview.contentOffset = rc.origin;
}

-(BOOL)IsLastPage
{
    return (_indexStarPos + _rowCount >= _nValueCount);
}

-(void)setBScrollEnable:(BOOL)bScrollEnable
{
    _bScrollEnable = bScrollEnable;
    _leftview.scrollEnabled = _bScrollEnable;
    _centerview.scrollEnabled = _bScrollEnable;
}
@end
