/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztTabView
 * 文件标识：
 * 摘    要：   标签页显示
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/
#import "tztTabView.h"

@class tztBaseTradeView;
#define tztKOCOLOR_TAB_TITLE [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define tztKOCOLOR_TAB_TITLE_SHADOW [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] /*#ffffff*/
#define tztKOCOLOR_TAB_TITLE_ACTIVE [UIColor whiteColor] /*#6c593d*/
#define tztKOCOLOR_TAB_TITLE_ACTIVE_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:0.55] /*#ffffff*/
#define tztKOFONT_TAB_TITLE [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]
#define tztKOFONT_TAB_TITLE_ACTIVE [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]

#define tztOVERKILL 2048
#define tztSearchButtonWidth 40

@interface tztTabView()
{
    NSMutableArray      *_ayTabViews;
    
    NSMutableArray      *_ayButtonViews;
    
    UIScrollView        *_tabbedBar;
    UIView              *_shadowView;
    UIView              *_tabbedView;
    UIImageView         *_leftCanc;
    UIImageView         *_rightCanc;
    
    NSInteger                 _nActiveBarIndex;
    NSInteger                 _nActiveViewIndex;
}

@end

@implementation tztTabView
@synthesize tztdelegate = _tztdelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    
    _tabbedBar = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    if (g_pSystermConfig.biPadPureBg) {
        [_tabbedBar setBackgroundColor:[UIColor colorWithTztRGBStr:@"66, 66, 66"]];
    }
    else
    {
        [_tabbedBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageTztNamed:@"filetab-bg"]]];
    }
    
    [_tabbedBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_tabbedBar setClipsToBounds:YES];
    [_tabbedBar setAlwaysBounceHorizontal:YES];
    [_tabbedBar setShowsVerticalScrollIndicator:NO];
    [_tabbedBar setShowsHorizontalScrollIndicator:NO];
    
    CGRect rect = _tabbedBar.frame;
    rect.size.height = 33;
    _tabbedBar.frame = rect;
    
    _shadowView = [[UIView alloc] initWithFrame:rect];
    [_shadowView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    rect = _shadowView.bounds;
    rect.size.width = 1024;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:rect];
    _shadowView.layer.masksToBounds = NO;
    _shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _shadowView.layer.shadowOpacity = 0.5f;
    _shadowView.layer.shadowRadius = 6.0f;
    _shadowView.layer.shadowPath = shadowPath.CGPath;
    
    _tabbedView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIView *pp = [[UIView alloc] init];
    [_tabbedView addSubview:pp];
    [pp release];
    
    rect = self.bounds;
    rect.size.height -= 33;
    rect.origin.y += 33;
    _tabbedView.frame = rect;
    
    [_tabbedView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [self addSubview:_tabbedView];
    [self addSubview:_shadowView];
    [self addSubview:_tabbedBar];
    
    [_tabbedView release];
    [_shadowView release];
    [_tabbedBar release];
    
    if (_ayButtonViews == NULL)
        _ayButtonViews = NewObject(NSMutableArray);
    
    if (_ayTabViews == NULL)
        _ayTabViews = NewObject(NSMutableArray);
        
    _nActiveBarIndex = 0;
}

-(void)dealloc
{
    DelObject(_ayTabViews);
    DelObject(_ayButtonViews);
    [super dealloc];
}

-(int)GetViewIndex:(UIView*)pView
{
    int nIndex = -1;
    for (int i = 0; i < [_ayTabViews count]; i++)
    {
        UIView *p = [_ayTabViews objectAtIndex:i];
        if (p == NULL)
            continue;
        if (p == pView)
        {
            nIndex = i;
            break;
        }
    }
    return nIndex;
}

-(BOOL)IsExistType:(NSInteger)nMsgType
{
    BOOL bExist = FALSE;
    int nIndex = -1;
    UIView *pView = NULL;
    for (int i = 0; i < [_ayTabViews count]; i++)
    {
        pView = [_ayTabViews objectAtIndex:i];
        if (pView == NULL)
            continue;
        
        if ([pView isKindOfClass:[tztBaseTradeView class]])
        {
            if ([pView isEqualMsgType:nMsgType])
            {
                bExist = TRUE;
                nIndex = i;
                break;
            }
        }
    }
    
    //跳转到存在的标签页
    if (pView &&  nIndex > -1 && nIndex < [_ayButtonViews count])
    {
        UIView *pBtn = [_ayButtonViews objectAtIndex:nIndex];
        if (_nActiveBarIndex != [pBtn getTztIndex])
        {
            [self setActiveBarIndex:[pBtn getTztIndex]];
            [self setActiveViewIndex:[pView getTztIndex]];
        }
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztTabView:didSwitchItem:)])
            [_tztdelegate tztTabView:self didSwitchItem:nil];
    }
    
    return bExist;
}

-(void)AddViewToTab:(UIView*)pView nsName_:(NSString*)nsName
{
    if (pView == NULL)
        return;
    
    int nIndex = [self GetViewIndex:pView];
    if (nIndex > -1)
    {
        UIView *pBtn = [_ayButtonViews objectAtIndex:nIndex];
        UIView *pViewEx = [_ayTabViews objectAtIndex:nIndex];
        if (_nActiveBarIndex != [pBtn getTztIndex])
        {
            [self setActiveBarIndex:[pBtn getTztIndex]];
            [self setActiveViewIndex:[pViewEx getTztIndex]];
        }
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztTabView:didSwitchItem:)])
            [_tztdelegate tztTabView:self didSwitchItem:nil];
        return;
    }
    
    [_ayTabViews addObject:pView];
    
    NSInteger index = [_ayTabViews count] - 1;
    
    [pView setFrame:_tabbedView.bounds];
    [pView setTztIndex:index];
    if (nsName == NULL || [nsName length] < 1)
        nsName = [NSString stringWithFormat:@"标签%d",(int)[pView getTztIndex]] ;
    [pView setTztName:nsName];
    
    [pView setAutoresizesSubviews:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    CGSize size = [[pView getTztName] sizeWithFont:[UIFont boldSystemFontOfSize:12]];
    CGFloat lastButtonViewMaxX = 0;
    
    if ([_ayButtonViews count])
        lastButtonViewMaxX = CGRectGetMaxX([[_ayButtonViews lastObject] frame]);
    
    UIView * buttonView = [[UIView alloc] init];
    if (index == 0)
        [buttonView setFrame:CGRectMake(lastButtonViewMaxX, 0, size.width + 45, 28)];
    else
        [buttonView setFrame:CGRectMake(lastButtonViewMaxX + 45, 0, size.width + 45, 28)];
    [buttonView setTztIndex:index];
    
    [_tabbedBar addSubview:buttonView];
    [_ayButtonViews addObject:buttonView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 1, 28, 28)];
    [closeButton setBackgroundImage:[UIImage imageTztNamed:@"close-on"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageTztNamed:@"close-off"] forState:UIControlStateHighlighted];
    [closeButton setBackgroundImage:[UIImage imageTztNamed:@"close-off"] forState:UIControlStateSelected];
    [closeButton setTztIndex:index];
    [closeButton addTarget:self action:@selector(closeButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:closeButton];
    
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setFrame:CGRectMake(23, 1, size.width + 16, 28)];
    [titleButton setTztIndex:index];
    
    [titleButton.titleLabel setFont:tztKOFONT_TAB_TITLE_ACTIVE];
    [titleButton setTitleColor:tztKOCOLOR_TAB_TITLE_ACTIVE forState:UIControlStateNormal];
    [titleButton setTitleShadowColor:tztKOCOLOR_TAB_TITLE_ACTIVE_SHADOW forState:UIControlStateNormal];
    [titleButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
    [titleButton setTitle:[pView getTztName] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(selectButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:titleButton];
    
    size = _tabbedBar.contentSize; //=
    size.width = CGRectGetMaxX(buttonView.frame);
    _tabbedBar.contentSize = size;
    [buttonView release];
    
    if ([_ayTabViews count] == 1)
    {
        if (_leftCanc == NULL)
        {
            _leftCanc = [[UIImageView alloc] initWithImage:[[UIImage imageTztNamed:@"filetab-gradient-left"]stretchableImageWithLeftCapWidth:-44 topCapHeight:0]];
            
	
            CGRect rect = _leftCanc.frame;
            rect.size.width = 45;
            rect.origin.x = -45;
            _leftCanc.frame = rect;
            
            [_tabbedBar insertSubview:_leftCanc atIndex:0];
            [_leftCanc release];
        }else
        {
            _leftCanc.hidden = NO;
        }
        
        if (_rightCanc == NULL)
        {
            _rightCanc = [[UIImageView alloc] initWithImage:[[UIImage imageTztNamed:@"filetab-gradient-right"] stretchableImageWithLeftCapWidth:44 topCapHeight:0]];
        
            CGRect rect = _rightCanc.frame;
            rect.origin.x = 45;
            _rightCanc.frame = rect;
            
            [_rightCanc setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [_tabbedBar insertSubview:_rightCanc atIndex:0];
            [_rightCanc release];
        }else
        {
            _rightCanc.hidden = NO;
        }
    }
    
    if ([_ayTabViews count] > 0)
    {
        [self setActiveViewIndex:[_ayTabViews count] - 1];
        [self setActiveBarIndex:[_ayButtonViews count] - 1];
    }
}

-(void)RemoveAllViews
{
    while ([_ayButtonViews count] > 0)
    {
        UIView *view = [_ayButtonViews objectAtIndex:[_ayButtonViews count] - 1];
        UIButton *closeButton = [[view subviews] objectAtIndex:0];
        
        [self closeButtonAtIndex:closeButton];
        
    }
	
    [_ayButtonViews removeAllObjects];
    [_ayTabViews removeAllObjects];
}

-(void)setActiveBarIndex:(NSInteger)nIndex
{
    if ([_ayButtonViews count] <= nIndex)
        return;
    _nActiveBarIndex = nIndex;
	UIView *buttonView = (UIView *)[_ayButtonViews objectAtIndex:_nActiveBarIndex];
	
	for (UIView *view in _ayButtonViews)
    {
		UIButton *closeButton = [[view subviews] objectAtIndex:0];
		[closeButton setBackgroundImage:[UIImage imageTztNamed:@"close-off"] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageTztNamed:@"close-on"] forState:UIControlStateHighlighted];
		[closeButton setBackgroundImage:[UIImage imageTztNamed:@"close-on"] forState:UIControlStateSelected];
        
		UIButton *titleButton = [[view subviews] objectAtIndex:1];
		[titleButton setTitleColor:tztKOCOLOR_TAB_TITLE forState:UIControlStateNormal];
		[titleButton setTitleShadowColor:tztKOCOLOR_TAB_TITLE_SHADOW forState:UIControlStateNormal];
	}
	
	UIButton *closeButton = [[buttonView subviews] objectAtIndex:0];
	[closeButton setBackgroundImage:[UIImage imageTztNamed:@"close-on"] forState:UIControlStateNormal];
	[closeButton setBackgroundImage:[UIImage imageTztNamed:@"close-off"] forState:UIControlStateHighlighted];
	[closeButton setBackgroundImage:[UIImage imageTztNamed:@"close-off"] forState:UIControlStateSelected];
	
	
	UIButton *titleButton = [[buttonView subviews] objectAtIndex:1];
	[titleButton setTitleColor:tztKOCOLOR_TAB_TITLE_ACTIVE forState:UIControlStateNormal];
	[titleButton setTitleShadowColor:tztKOCOLOR_TAB_TITLE_ACTIVE_SHADOW forState:UIControlStateNormal];
	
	
	CGRect rectLeftCanc = _leftCanc.frame;
    rectLeftCanc.origin.x = -tztOVERKILL;
	rectLeftCanc.size.width = CGRectGetMinX(buttonView.frame) - rectLeftCanc.origin.x;
	
	CGRect rectRightCanc = _rightCanc.frame;
    int rightX = _tabbedBar.contentSize.width + tztOVERKILL;
    rectRightCanc.origin.x = CGRectGetMaxX(buttonView.frame);
	rectRightCanc.size.width = rightX - self.frame.size.width;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	_leftCanc.frame = rectLeftCanc;
	_rightCanc.frame = rectRightCanc;
    // zxl 20130927 计算宽度 不以界面的宽度为标准，以工具条的宽度为标准（查询界面右侧放置功能按钮）
    if (rectRightCanc.origin.x > (_tabbedBar.frame.size.width + _tabbedBar.contentOffset.x))
    {
        _tabbedBar.contentOffset = CGPointMake(rectRightCanc.origin.x - _tabbedBar.frame.size.width, 0);
    }
    // zxl 20130927 展示的功能按钮小于当前的位子 时移动到展示的按钮位置
    if (rectRightCanc.origin.x < _tabbedBar.contentOffset.x)
    {
         _tabbedBar.contentOffset = CGPointMake(rectRightCanc.origin.x - buttonView.frame.size.width, 0);
    }
    
	[UIView commitAnimations];
}

-(void)setActiveViewIndex:(NSInteger)nIndex
{
    if (nIndex >= [_ayTabViews count])
        nIndex = [_ayTabViews count] - 1;
    _nActiveViewIndex = nIndex;
    
	[[_ayTabViews objectAtIndex:_nActiveViewIndex] setAlpha:0];
	[_tabbedView addSubview:[_ayTabViews objectAtIndex:_nActiveViewIndex]];
    [[_ayTabViews objectAtIndex:_nActiveViewIndex] setFrame:_tabbedView.bounds];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    if ([[_tabbedView subviews] count] <= 1)
    {
        [[[_tabbedView subviews] objectAtIndex:0] setAlpha:0];
        [[[_tabbedView subviews] objectAtIndex:0] setAlpha:1];
        [UIView commitAnimations];
    }
    else
    {
        [[[_tabbedView subviews] objectAtIndex:0] setAlpha:0];
        if ([[_tabbedView subviews] count] > 1)
            [[[_tabbedView subviews] objectAtIndex:1] setAlpha:1];
        
        [UIView commitAnimations];
        
        [[[_tabbedView subviews] objectAtIndex:0] removeFromSuperview];
    }
    //zxl 20131011界面刷新
    UIView * pView = [_ayTabViews objectAtIndex:_nActiveViewIndex];
//    if (pView && [pView isKindOfClass:[tztBaseTradeView class]])
//    {
        [pView tztperformSelector:@"OnRequestData"];
//    }
}

//zxl 20131022 删除指定索引的界面
-(void)RemoveViewAtIndex:(NSInteger)index
{
    if (index >= [_ayButtonViews count] ||
        index >= [_ayTabViews count])
    {
        return;
    }
    
    NSInteger newActiveBarIndex;
	
	if (_nActiveBarIndex == index && [_ayTabViews count] > 1)
    {
		if (index == 0)
        {
			[self setActiveViewIndex:(index + 1)];
			newActiveBarIndex = 0;
		}
        else
        {
			[self setActiveViewIndex:(index - 1)];
			newActiveBarIndex = index - 1;
		}
	}
    else if (_nActiveBarIndex > index)
    {
		newActiveBarIndex = _nActiveBarIndex - 1;
	}
    else
    {
		newActiveBarIndex = _nActiveBarIndex;
	}
    //zxl 20131016 删除View和按钮
	UIView * view = [_ayButtonViews objectAtIndex:index];
    if (view)
        [view removeFromSuperview];
    
    view = [_ayTabViews objectAtIndex:index];
    if (view)
        [view removeFromSuperview];
    
	[_ayButtonViews removeObjectAtIndex:index];
	[_ayTabViews removeObjectAtIndex:index];
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView commitAnimations];
	
    //zxl 20131016 当没有功能界面的时候直接返回 _leftCanc 和_rightCanc 隐藏
    if ([_ayButtonViews count] == 0 || [_ayButtonViews count] == 0)
    {
        _leftCanc.hidden = YES;
        _rightCanc.hidden = YES;
        return;
    }
    
	CGRect rect = CGRectMake(0, 0, 0, 29);
	
	UIView *lastButtonView = nil;
	
	NSInteger i = 0;
	
	for (UIView *buttonView in _ayButtonViews)
    {
        //zxl 20131011 关闭界面的同时重新设置所有button 的index;
        [buttonView setTztIndex:i];
		[(UIButton *)[[buttonView subviews] objectAtIndex:0] setTztIndex:i];
		[(UIButton *)[[buttonView subviews] objectAtIndex:1] setTztIndex:i];
		rect.size.width = buttonView.frame.size.width;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[buttonView setFrame:rect];
		[UIView commitAnimations];
		rect.origin.x = CGRectGetMaxX(rect) + 45;
		lastButtonView = buttonView;
		i++;
	}
    //zxl 20131011 关闭界面的同时重新设置所有view 的index;
    i = 0;
    for (UIView *pview in _ayTabViews)
    {
        [pview setTztIndex:i];
        i++;
    }
	
	CGSize size = _tabbedBar.contentSize;
	size.width = CGRectGetMaxX(lastButtonView.frame);
	_tabbedBar.contentSize = size;
	
    [self setActiveViewIndex:newActiveBarIndex];
	[self setActiveBarIndex:newActiveBarIndex];
	
	if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztTabView:didSwitchItem:)])
        [_tztdelegate tztTabView:self didSwitchItem:nil];
}
- (void)closeButtonAtIndex:(id)sender
{
	if ([_ayButtonViews count] < 1)
		return;
	
	UIButton *closeButton = sender;
	if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztTabView:didCloseItem:)])
        [_tztdelegate tztTabView:self didCloseItem:nil];
    
	[self RemoveViewAtIndex:[closeButton getTztIndex]];
}

- (void)selectButtonAtIndex:(id)sender
{
	if (_nActiveBarIndex != [(UIButton *)sender getTztIndex])
    {
		[self setActiveBarIndex:[(UIButton *)sender getTztIndex]];
		[self setActiveViewIndex:[(UIButton *)sender getTztIndex]];
	}
	
	if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztTabView:didSwitchItem:)])
		[_tztdelegate tztTabView:self didSwitchItem:nil];
}

-(UIView*)GetActiveTabView
{
    if ([_ayTabViews count] < 1 && [_ayTabViews count] <= _nActiveBarIndex)
        return NULL;
    
    return [_ayTabViews objectAtIndex:_nActiveBarIndex];
}
@end
