/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页-资讯界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIHomePageInfoView.h"
//上小拉动超过此高度即翻页
#define PageReflushBaseHeight	(60.0)
//提示信息Lable的宽高
#define PageReflushLabelWidth	(300.0)
#define PageReflushLableHeight	(40.0)
//提示的箭头图片的宽高
#define PageReflushArrowWidth	(23.0)
#define PageReflushArrowHeight	(60.0)

//提示箭头旋转时间
#define FLIP_ANIMATION_DURATION 0.18f

@implementation tztUIInfoView
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

//创建界面
-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	
	CGRect rcFrame = self.frame;
	rcFrame.origin = CGPointZero;
	rcFrame.size.width = rcFrame.size.width - 40;
	
	//标题
	UIFont *font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:19.0f];
	CGRect rcTemp = CGRectMake(rcFrame.origin.x +40, rcFrame.origin.y , rcFrame.size.width, 40);
	if (_pTitle == NULL)
	{
		_pTitle = [[UILabel alloc] initWithFrame:rcTemp];
		_pTitle.text = @"";
		_pTitle.font = font;
		_pTitle.textAlignment = UITextAlignmentLeft;
		_pTitle.backgroundColor = [UIColor clearColor];
		_pTitle.textColor = [UIColor colorWithTztRGBStr:@"30,130,252"];
		[self addSubview:_pTitle];		
	}
	else 
	{
		_pTitle.frame = rcTemp;
	}
	
	//内容
	rcTemp.origin.y += 40;
	rcTemp = CGRectMake(rcTemp.origin.x, rcTemp.origin.y, rcFrame.size.width - 20, 80);
	if (_pContent == NULL)
	{
		_pContent = [[UILabel alloc] initWithFrame:rcTemp];
		_pContent.font = [UIFont systemFontOfSize:17.0f];
		_pContent.text = @"";
		_pContent.textAlignment = UITextAlignmentLeft;
		_pContent.backgroundColor = [UIColor clearColor];
        _pContent.textColor = [UIColor blackColor];
		_pContent.numberOfLines = 3;
		_pContent.lineBreakMode= UILineBreakModeTailTruncation;
		[self addSubview:_pContent];
	}
	else
	{
		_pContent.frame = rcTemp;
	}
	
	//按钮
	if (_pBtContent == NULL)
	{
		_pBtContent = [UIButton buttonWithType:UIButtonTypeCustom];	
		[_pBtContent setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
		[_pBtContent setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
		[_pBtContent addTarget:self action:@selector(ShowInfoDetail:) forControlEvents:UIControlEventTouchUpInside];
		_pBtContent.frame = rcFrame;
		[self addSubview:_pBtContent];	
	}
	else 
	{
		_pBtContent.frame = rcFrame;
	}
	
}

//设置标题和内容
-(void) SetInformation:(tztInfoItem *) newItem
{
	if (newItem == NULL)
		return;
	
	//保持每个view的值
	_pItem = newItem;
    
    if (_pItem == NULL)
		return;
	
	if (_pTitle != NULL)
	{
		_pTitle.text = newItem.InfoTitle;
	}
	
	if (_pContent != NULL)
	{
		_pContent.text = newItem.InfoContent;
	}
}
-(void)ShowInfoDetail:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == _pBtContent)
    {
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Content wParam:(NSUInteger)_pItem lParam:(NSUInteger)NULL];
    }
}
@end

@implementation tztUIHomePageInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _pInfoArray = NewObject(NSMutableArray);
        _pViewArray = NewObject(NSMutableArray);
        _pInfoBase = [[tztInfoBase alloc] init];
        _pInfoBase.pDelegate = self;
        _fCellHeigth = 0;
        _fCellWidth = 0;
        _fContentHeight = 0;
        _fContentWidth = 0;
    }
    return self;
}
- (void)dealloc 
{
    [super dealloc];
    DelObject(_pInfoArray);
    DelObject(_pViewArray);
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    
    if (_pImageBG == NULL)
    {
        _pImageBG = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTUIHomePageZiXun.png"]];
        _pImageBG.frame = rcFrame;
        [self addSubview:_pImageBG];
        [_pImageBG release];
    }else
        _pImageBG.frame = rcFrame;
    
    CGRect rcTemp = CGRectMake( rcFrame.origin.x, rcFrame.origin.y + 5, 100, 40);
	if (_pTitle == NULL)
	{
		_pTitle = [[UILabel alloc] initWithFrame:rcTemp];
		_pTitle.font = [UIFont systemFontOfSize:19];
		_pTitle.textAlignment = UITextAlignmentCenter;
		_pTitle.textColor = [UIColor whiteColor];
		_pTitle.backgroundColor = [UIColor clearColor];
		[_pTitle setText:@"最新要闻"];
		[self addSubview:_pTitle];
        [_pTitle release];
	}
	else 
	{
		_pTitle.frame = rcTemp;
	}
	//总宽度
	_fContentWidth = rcFrame.size.width;
	_fCellWidth = _fContentWidth / 2 ;
	_fCellHeigth = (rcFrame.size.height - 65) / 2;
	//总长度
	_fContentHeight = _fCellHeigth * 10;
	
	rcTemp = CGRectMake(rcTemp.origin.x , rcTemp.origin.y, _fContentWidth,_fContentHeight + 5);
	if (_pContentView == NULL)
	{
		_pContentView = [[UIView alloc] initWithFrame:rcTemp];
		_pContentView.backgroundColor = [UIColor clearColor];
	}
	else 
	{
		_pContentView.frame = rcTemp;
	}
	
	//滚动界面
	rcTemp = CGRectMake(rcTemp.origin.x, rcTemp.origin.y + 50, _fContentWidth, rcFrame.size.height - 60);
	if (_pScorllInfoView == NULL)
	{
		_pScorllInfoView = [[UIScrollView alloc] initWithFrame:rcTemp];
		_pScorllInfoView.backgroundColor = [UIColor clearColor];
		_pScorllInfoView.delegate = self;
		[_pScorllInfoView addSubview:_pContentView];
		_pScorllInfoView.contentSize = CGSizeMake(_fContentWidth, _fContentHeight);
		[self addSubview:_pScorllInfoView];
	}
	else
	{
		_pScorllInfoView.frame = rcTemp;
	}
	
	CGRect bFrame = CGRectMake((_pScorllInfoView.frame.size.width - PageReflushLabelWidth)/ 2.0, 
							   -(PageReflushArrowHeight/2 + PageReflushLableHeight/2),
							   PageReflushLabelWidth, PageReflushLableHeight);
	if (bFrame.origin.x < 0) 
	{
		bFrame.origin.x = 0;
		bFrame.size.width = _pScorllInfoView.frame.size.width;
	}
	
	if (_pBackPage == NULL)
	{
		_pBackPage = [[[UILabel alloc] initWithFrame:bFrame] autorelease];
		_pBackPage.textAlignment = UITextAlignmentCenter;
		_pBackPage.adjustsFontSizeToFitWidth = TRUE;
		_pBackPage.textColor = [UIColor blackColor];
		_pBackPage.text = @"下拉向前翻页";
		_pBackPage.backgroundColor = [UIColor clearColor];
		_pBackPage.hidden = NO;
		[_pScorllInfoView addSubview:_pBackPage];
	}
	else
	{
		_pBackPage.frame = bFrame;
	}
	
	bFrame = CGRectMake(bFrame.origin.x - PageReflushArrowWidth, -PageReflushArrowHeight, 
						PageReflushArrowWidth, PageReflushArrowHeight);
	
	if (_pArrowImageUP == NULL) 
	{
		_pArrowImageUP = [[CALayer alloc] init];
		_pArrowImageUP.contentsGravity = kCAGravityResizeAspect;
		_pArrowImageUP.contents = (id)[UIImage imageNamed:@"blackArrow.png"].CGImage;
	}
	_pArrowImageUP.frame = bFrame;
	[_pArrowImageUP removeFromSuperlayer];
	[[_pScorllInfoView layer] addSublayer:_pArrowImageUP];
	
	bFrame = _pBackPage.frame;
	bFrame.origin.y = _pScorllInfoView.contentSize.height + (PageReflushArrowHeight - PageReflushLableHeight)/2;
	if (_pNextPage == NULL)
	{
		_pNextPage = [[[UILabel alloc] initWithFrame:bFrame] autorelease];
		_pNextPage.textAlignment = UITextAlignmentCenter;
		_pNextPage.adjustsFontSizeToFitWidth = TRUE;
		_pNextPage.textColor = [UIColor blackColor];
		_pNextPage.text = @"上拉向后翻页";
		_pNextPage.backgroundColor = [UIColor clearColor];
		_pNextPage.hidden = NO;	
		[_pScorllInfoView addSubview:_pNextPage];
	}
	else
	{
		_pNextPage.frame = bFrame;
	}
	
	bFrame = CGRectMake(bFrame.origin.x - PageReflushArrowWidth, _pScorllInfoView.contentSize.height, PageReflushArrowWidth, PageReflushArrowHeight);
	if (_pArrowImageDown == NULL)
	{
		_pArrowImageDown = [[CALayer alloc] init];
		_pArrowImageDown.contentsGravity = kCAGravityResizeAspect;
		_pArrowImageDown.contents = (id)[UIImage imageNamed:@"blackArrow.png"].CGImage;
		_pArrowImageDown.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
	}
	_pArrowImageDown.frame = bFrame;
	[_pArrowImageDown removeFromSuperlayer];
	[[_pScorllInfoView layer] addSublayer:_pArrowImageDown];
}

//根据返回内容创建每个界面
-(void) CreateInfoView
{
	if (_pInfoArray == NULL && [_pInfoArray count] < 1)
		return;
	
	if (_pInfoArray == NULL)
		return;
	
	NSInteger nCountArray = [_pInfoArray count];
	NSInteger nCountView = [_pViewArray count];
	
	tztUIInfoView *pTempView ;
	
	//数组大于界面
	if (nCountArray > nCountView)
	{
		NSInteger nTemp = nCountArray - nCountView;
		for (int i = 0; i < nTemp; i++)
		{
			pTempView = [[tztUIInfoView alloc] init];
			[_pViewArray addObject:pTempView];
			[_pContentView addSubview:pTempView];
			[pTempView release];
		}
		
	}
	else if(nCountArray < nCountView)//返回数据小于显示View,删除多余的
	{
		NSInteger nTemp = nCountView - nCountArray;
		for (int i = 0; i < nTemp; i++)
		{
			pTempView = [_pViewArray objectAtIndex:(nCountView - 1 -i)];
			[_pViewArray removeLastObject];
			[pTempView removeFromSuperview];
		}
		
	}
	else if(nCountArray == nCountView)//返回数据和显示view相同,直接赋值
	{
		[self SetInfoViewValue];
		return;
	}
	
	//设置每条资讯的坐标
	CGRect rcFrame = _pContentView.frame; 
	CGRect rcTemp  =  CGRectMake(rcFrame.origin.x , rcFrame.origin.y , _fCellWidth, _fCellHeigth);
	rcFrame.origin.x += _fCellWidth;
	CGRect rcTemp2 =  CGRectMake(rcFrame.origin.x, rcFrame.origin.y, _fCellWidth, _fCellHeigth);
	
	NSInteger nCount = [_pInfoArray count];
	tztUIInfoView *InfoView;
	
	//给每个view设置坐标
	for (int i = 0; i < nCount; i++)
	{
		InfoView = [_pViewArray objectAtIndex:i];
		if (i % 2 == 0)
		{
			InfoView.frame = rcTemp;
			rcTemp.origin.y += _fCellHeigth;
		}else
		{
			InfoView.frame = rcTemp2;
			rcTemp2.origin.y += _fCellHeigth;
		}
	}
	
	[self SetInfoViewValue];
}

//给界面赋值
-(void) SetInfoViewValue
{
	if (_pInfoArray == NULL && [_pInfoArray count] < 1)
		return;
	
	if (_pViewArray == NULL && [_pViewArray count] < 1)
		return;
	
    tztInfoItem* newItem;
	NSInteger nCount = [_pInfoArray count];
	
	tztUIInfoView *InfoView;
	
	for (int i = 0; i < nCount; i++)
	{
		InfoView = [_pViewArray objectAtIndex:i];
		newItem = [_pInfoArray objectAtIndex:i];
		[InfoView SetInformation:newItem];
	}
	
}

#pragma mark -收到数据，处理显示
-(void)SetInfoData:(NSMutableArray*)ayData
{
	if (_pInfoBase == NULL)
		return;
	
	tztInfoItem * newItem;
	
	if (_pInfoArray == NULL)
		return;	
	[_pInfoArray removeAllObjects];
	
	for (int i = 0; i < [ayData count]; i++)
	{
		newItem = [ayData objectAtIndex:i];
		[_pInfoArray addObject:newItem];
	}
	
	//创建界面
	[self CreateInfoView];
	return;
}
//请求资讯概要数据
-(void) OnRequestData
{
    if (_pInfoBase == NULL)
        return;
    
    _pInfoBase.nMaxCount = 20;
//    _pInfoBase.nIsMenu = 0;
    _pInfoBase.hSString = @"2015";
    [_pInfoBase GetInfo];
}

#pragma mark -刷新数据
-(void) OnReflush
{
    [self OnRequestData];
}
#pragma mark -翻页（下页）处理
-(void) OnPageNext
{
  	if (_pInfoBase && [_pInfoBase NextPage])
		[self OnReflush];
     [_pScorllInfoView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark -翻页（上页）处理
-(void) OnPageBack
{
	if (_pInfoBase && [_pInfoBase BackPage])
		[self OnReflush];
}


#pragma mark 滚动事件处理
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView == _pScorllInfoView)
	{
		CGRect rc;
		rc.origin = _pScorllInfoView.contentOffset;
		rc.size = _pScorllInfoView.frame.size;
		
		CGRect bFrame = _pBackPage.frame;
		if ((_pScorllInfoView.frame.size.width - PageReflushLabelWidth)/ 2.0 < 0)
		{
			bFrame.origin.x = rc.origin.x;
		}
		else
		{
			bFrame.origin.x = (_pScorllInfoView.frame.size.width - PageReflushLabelWidth)/ 2.0 + rc.origin.x;
		}
		_pBackPage.frame = bFrame;
		
		//m_pCenterView显示不下，说明显示在m_pLeftView上就不再调整位置
		if (bFrame.origin.x - PageReflushArrowWidth >= rc.origin.x)
		{
			bFrame = CGRectMake(bFrame.origin.x - PageReflushArrowWidth, -PageReflushArrowHeight, PageReflushArrowWidth, PageReflushArrowHeight);
			_pArrowImageUP.frame = bFrame;
		}
		
		bFrame = _pNextPage.frame;
		bFrame.origin.x = _pBackPage.frame.origin.x;
		bFrame.origin.y = _pScorllInfoView.contentSize.height + (PageReflushArrowHeight - PageReflushLableHeight)/2;
		_pNextPage.frame = bFrame;
		
		if (bFrame.origin.x - PageReflushArrowWidth >= rc.origin.x) 
		{
			bFrame = CGRectMake(bFrame.origin.x - PageReflushArrowWidth, bFrame.origin.y, PageReflushArrowWidth, PageReflushArrowHeight);
			_pArrowImageDown.frame = bFrame;
		}
		
		
		int baseHeight = _pScorllInfoView.contentSize.height - _pScorllInfoView.frame.size.height;
		
		//更改显示说明
		if ( scrollView.contentOffset.y <= -PageReflushBaseHeight)
		{
			[self setState:InfoEGOOPullRefreshPullingUp];
			return;
		}
		else if(scrollView.contentOffset.y > -PageReflushBaseHeight && scrollView.contentOffset.y < 0)
		{
			[self setState:InfoEGOOPullRefreshNormalUp];
			return;
		}
		else if(scrollView.contentOffset.y - baseHeight >= PageReflushBaseHeight)
		{
			[self setState:InfoEGOOPullRefreshPullingDown];
			return;
		}else
		{
			[self setState:InfoEGOOPullRefreshNormalDown];
			return;
		}
		
	}
}

-(void) setState:(int)aState
{
    NSInteger pagecount = _pInfoBase.nHaveMax/_pInfoBase.nMaxCount;
    if (_pInfoBase.nHaveMax%_pInfoBase.nMaxCount > 0)
        pagecount += 1;
    NSInteger pageCur = _pInfoBase.nStartPos /_pInfoBase.nMaxCount + 1;
    
    NSString *pageInfo = [NSString stringWithFormat:@"%ld页/%ld页",(long)pageCur,(long)pagecount];
	switch (aState)
    {
		case InfoEGOOPullRefreshLoadingUp:
		{	[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			[CATransaction commit];
		}
			break;
		case InfoEGOOPullRefreshPullingUp:
		{
			_pBackPage.text = [NSString stringWithFormat:@"释放立即翻页 %@",pageInfo];
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_pArrowImageUP.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];			
		}
			break;
		case InfoEGOOPullRefreshNormalUp:
		{
			if (_nState == InfoEGOOPullRefreshPullingUp)
			{
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_pArrowImageUP.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			_pBackPage.text = [NSString stringWithFormat:@"下拉向前翻页 %@", pageInfo];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_pArrowImageUP.hidden = NO;
			_pArrowImageUP.transform = CATransform3DIdentity;
			[CATransaction commit];			
		}
			break;
		case InfoEGOOPullRefreshNormalDown:
		{
			if (_nState == InfoEGOOPullRefreshPullingDown) 
            {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_pArrowImageDown.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
				[CATransaction commit];
			}
			_pNextPage.text =  [NSString stringWithFormat:@"上拉向后翻页 %@", pageInfo];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_pArrowImageDown.hidden = NO;
			_pArrowImageDown.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];			
		}
			break;
		case InfoEGOOPullRefreshPullingDown:
		{
			_pNextPage.text = [NSString stringWithFormat:@"释放立即翻页 %@", pageInfo];
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_pArrowImageDown.transform = CATransform3DIdentity;
			[CATransaction commit];
			
		}
			break;
		case InfoEGOOPullRefreshLoadingDown:
		{
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			[CATransaction commit];
		}
			break;
		default:
			break;
	}
	
	_nState = aState;
}

-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	if (scrollView == _pScorllInfoView)
	{
		CGRect rc;
        rc.origin = _pScorllInfoView.contentOffset;
        rc.size = _pScorllInfoView.frame.size;
		int baseHeight = _pScorllInfoView.contentSize.height - _pScorllInfoView.frame.size.height;
		
		if (rc.origin.y <= -PageReflushBaseHeight )
		{
			[NSTimer scheduledTimerWithTimeInterval:0.3
											 target:self
										   selector:@selector(OnPageBack) 
										   userInfo:nil
											repeats:NO];
		}
		else if (rc.origin.y - baseHeight >= PageReflushBaseHeight)
		{
			[NSTimer scheduledTimerWithTimeInterval:0.3
											 target:self
										   selector:@selector(OnPageNext) 
										   userInfo:nil
											repeats:NO];	
		}
		
	}
	
}
@end
