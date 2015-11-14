/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUIButtonView.m
* 文件标识:
* 摘要说明:		自定义按钮控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/

#import "TZTUIButtonView.h"

@interface TZTUIButtonView(TZTPrivate)
-(void)OnClickBtn:(id)sender;
-(void)OnClickBtnDown:(id)sender;
-(void)OnClickBtnUp:(id)sender;
@end


@implementation TZTUIButtonView
@synthesize m_pButton;
@synthesize	m_nsImgBack;
@synthesize m_nsImage;
@synthesize m_nsTitle;
@synthesize m_pColor;
@synthesize m_nFontSize;
@synthesize m_pDelegate;
@synthesize bNeedCheck;
@synthesize m_pLabel;
@synthesize m_nNumberOfRow;

- (id)initWithFrame:(CGRect)frame 
{    
    self = [super initWithFrame:frame];
    if (self) 
	{
    }
    return self;
}

//创建控件
/*
 参数： frame － 显示区域 nsImageBack 背景图 nsImage 按钮上的小图
	   nsTitle 按钮文字
 */
-(id)CreateButtonViewWithFrame:(CGRect)frame nsImgBack_:(NSString*)nsImageBack nsImage_:(NSString*)nsImage nsTitle_:(NSString*)nsTitle
{
    
    //默认不校验
    self.bNeedCheck = FALSE;
    //默认字体大小
    self.m_nFontSize = 15;
    //默认按钮文本颜色
    self.m_pColor = [UIColor grayColor];
	self = [self initWithFrame:frame];
	if (self)
	{
//		[self addSubview:self.m_pButton];
		//保存下图片及标题名称
        self.m_nsImgBack = [NSString stringWithFormat:@"%@", nsImageBack];
		self.m_nsTitle = [NSString stringWithFormat:@"%@",nsTitle];
		self.m_nsImage = [NSString stringWithFormat:@"%@",nsImage];
        self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

//重设置显示区域
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
	//设置自身区域
	[super setFrame:frame];
    CGRect rcXX = self.bounds;
    CGRect rcFrame = rcXX;
//    rcFrame.origin = CGPointZero;
	//重设包含的各个控件区域
    if (self.m_pButton == NULL)
    {
		//创建一个按钮贴在上面
		self.m_pButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.m_nsImgBack && [self.m_nsImgBack length] > 0)
            [self.m_pButton setBackgroundImage:[UIImage imageTztNamed:self.m_nsImgBack] forState:UIControlStateNormal];
		[self.m_pButton addTarget:self action:@selector(OnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.m_pButton.frame = rcFrame;
        [self addSubview:self.m_pButton];
    }
    else
        self.m_pButton.frame = rcFrame;
	//判断是否有小图
	BOOL bHaveImage = FALSE;
//	//标题是否存在
//	BOOL bHaveTitle = FALSE;
	if (self.m_nsImage != nil && [self.m_nsImage length] > 0 )
		bHaveImage = TRUE;
	
	//计算小图+标题文字需要的显示宽度，计算居中显示
	CGSize szText = CGSizeZero;
	CGSize szImg = CGSizeZero;
	UIImage *image = nil;
	if (self.m_nsTitle && [self.m_nsTitle length] > 0)
	{
//		bHaveTitle = TRUE;
		szText = [self.m_nsTitle sizeWithFont:tztUIBaseViewTextFont(m_nFontSize)];
	}
	if (bHaveImage)
	{
		image = [UIImage imageTztNamed:self.m_nsImage];
		if (image)
		{
			szImg = image.size;
		}
		else
		{
			bHaveImage = NO;
		}

	}
	
	int nLength = szText.width + szImg.width;
	
	//都不存在的话，默认就按自身区域绘制
	if (nLength <= 0)
		nLength = self.bounds.size.width;
	
	//小图+标题view
	UIButton* pView = (UIButton*)[self viewWithTag:0x7788];
	if (pView == NULL)
	{
		pView = [UIButton buttonWithType:UIButtonTypeCustom];
		pView.tag = 0x7788;
		[self.m_pButton addSubview:pView];
		[pView addTarget:self action:@selector(OnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
	}
    int nLeft = (rcFrame.size.width - nLength) / 2;
    int nHeight = rcFrame.size.height;
    CGRect rcView = CGRectMake(nLeft, 0, nLength, nHeight);
	pView.frame = rcView;// CGRectMake((rcFrame.size.width - nLength) / 2, 0, nLength, rcFrame.size.height);

	//小图view
	if (bHaveImage)
	{
		UIButton *pButton = (UIButton*)[self viewWithTag:0x8899];
		if (pButton == nil )
		{
			pButton = [UIButton buttonWithType:UIButtonTypeCustom];
			pButton.tag = 0x8899;
			[pView addSubview:pButton];
			[pButton addTarget:self action:@selector(OnClickBtnDown:) forControlEvents:UIControlEventTouchDown];
            [pButton addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchDragOutside];
			[pButton addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchCancel];
			[pButton addTarget:self action:@selector(OnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
		}
		[pButton setBackgroundImage:image forState:UIControlStateNormal];
		CGRect rcSub = pView.bounds;
        rcSub.origin = CGPointZero;
		rcSub.origin.y = (rcFrame.size.width - szImg.height) / 2;
		rcSub.size = szImg;
		pButton.frame = rcSub;
	}
	
	//标题view
	UIButton* pLabel = (UIButton*)[self viewWithTag:0x9977];
	if (pLabel == NULL)
	{
		pLabel = [UIButton buttonWithType:UIButtonTypeCustom];
		pLabel.tag = 0x9977;
		pLabel.titleLabel.textColor = [UIColor redColor];
		pLabel.titleLabel.font = tztUIBaseViewTextFont(self.m_nFontSize);
		pLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
		[pView addSubview:pLabel];
		[pLabel addTarget:self action:@selector(OnClickBtnDown:) forControlEvents:UIControlEventTouchDown];
        [pLabel addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchDragOutside];
		[pLabel addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchCancel];
		[pLabel addTarget:self action:@selector(OnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
	}
	[pLabel setTitle:self.m_nsTitle forState:UIControlStateNormal];
	[pLabel setTitleColor:self.m_pColor forState:UIControlStateNormal];
	CGRect rcSub = pView.bounds;
    rcSub.origin = CGPointZero;
	rcSub.origin.x += szImg.width;
	pLabel.frame = rcSub;
}

- (void)dealloc 
{
	self.m_pButton = nil;
	self.m_nsImgBack = nil;
	self.m_nsImage = nil;
	self.m_nsTitle = nil;
	self.m_pColor = nil;
    [super dealloc];
}

//按钮点击事件相应，调用delegate的按钮事件处理函数
-(void)OnClickBtn:(id)sender
{
	[self.m_pButton setHighlighted:NO];
	if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(OnButton:)]) 
	{
		[m_pDelegate OnButton:self];
	}
}

//按钮按下，相应的整个控件都显示为highlighted状态
-(void) OnClickBtnDown:(id)sender
{
	[self.m_pButton setHighlighted:YES];
}

//松开，或者移出按钮区域，取消当前的highlight状态
-(void) OnClickBtnUp:(id)sender
{
	[self.m_pButton setHighlighted:NO];
}

//重载设置标题函数
-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
	UIButton* pButton = (UIButton*)[self viewWithTag:0x9977];
	if (pButton)
	{
		[pButton setTitle:title forState:state];
	}
}

//重载设置标题颜色函数
-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
	UIButton* pButton = (UIButton*)[self viewWithTag:0x9977];
	if (pButton)
	{
		[pButton setTitleColor:color forState:state];
	}
}

-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
	if (self.m_pButton)
	{
		[self.m_pButton setBackgroundImage:image forState:UIControlStateNormal];
	}
}

-(void)setBackgroundImageView:(NSString*)nsImage
{
	if (nsImage && [nsImage length] > 0)
	{
		self.m_nsImage = [NSString stringWithFormat:@"%@",nsImage];
	}
	UIButton *pButton = (UIButton*)[self viewWithTag:0x8899];
	if (pButton)
	{
		[pButton setBackgroundImage:[UIImage imageTztNamed:nsImage] forState:UIControlStateNormal];
	}
}

//重载获取标题内容函数
-(NSString*)titleForState:(UIControlState)state
{
	UIButton* pButton = (UIButton*)[self viewWithTag:0x9977];
	if (pButton)
	{
		return [pButton titleForState:state];
	}
	return nil;
}
@end
