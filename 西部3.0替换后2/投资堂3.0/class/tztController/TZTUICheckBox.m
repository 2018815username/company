/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUICheckBox.m
* 文件标识:
* 摘要说明:		自定义选择框控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/

/*选择框控件，只能是文字或者图片的一种，不能两者同时存在*/
#import "TZTUICheckBox.h"

@interface TZTUICheckBox (TZTPrivate)
-(void)checkboxButton:(id)sender;
@end

@implementation TZTUICheckBox
@synthesize m_pButton;
@synthesize m_bChecked;
@synthesize m_pDelegate;
@synthesize m_nsTitle;
@synthesize m_nsTitleChecked;
@synthesize m_bNeedCheckValue;
@synthesize m_nsMsgInfo;

- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)nsTitle andCheckedTitle_:(NSString*)nsTitleChecked
{    
    self = [super initWithFrame:frame];
    if (self) 
	{
		//
		self.m_pButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.m_pButton.frame = frame;
		//文字按钮
		if (nsTitle && [nsTitle length] > 0)
		{
			//设置正常状态的文字
			[self.m_pButton setTitle:nsTitle forState:UIControlStateNormal];
//			//设置按下状态的文字
//			[self.m_pButton setTitle:nsTitleChecked forState:UIControlStateHighlighted];
			//记录文字
			self.m_nsTitle = [NSString stringWithFormat:@"%@",nsTitle];
			self.m_nsTitleChecked = [NSString stringWithFormat:@"%@",nsTitleChecked];
			//设置默认字体及颜色
			self.m_pButton.titleLabel.font = tztUIBaseViewTextFont(0);
			self.m_pButton.titleLabel.adjustsFontSizeToFitWidth = YES;
			[self.m_pButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		}
		else//图片按钮
		{
			[self.m_pButton setImage:[UIImage imageTztNamed:@"tztcheckbox.png"] forState:UIControlStateNormal];
			[self.m_pButton setImage:[UIImage imageTztNamed:@"tztcheckbox-pressed.png"] forState:UIControlStateHighlighted];
			[self.m_pButton setImage:[UIImage imageTztNamed:@"tztcheckbox-checked.png"] forState:UIControlStateSelected];
		}
		//添加事件响应
		[self.m_pButton addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.m_pButton];
		self.m_bChecked = FALSE;//默认不选中
		self.m_pDelegate = nil;
    }
    return self;
}

//重设区域位置调整
-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	self.m_pButton.frame = self.bounds;
}

//设置标题文字
-(void)setTitleText:(NSString*)nsTitle
{
	if (self.m_pButton && nsTitle)
	{
		[self.m_pButton setTitle:nsTitle forState:UIControlStateNormal];
	}
}

//设置选中状态，以及当前状态下的文字显示
-(void)setSelected:(BOOL)bSelect
{
	if (self.m_pButton)
	{
		[self.m_pButton setSelected:bSelect];
		if (bSelect)
		{
			[self.m_pButton setTitle:self.m_nsTitleChecked forState:UIControlStateSelected];
		}
		else
		{
			[self.m_pButton setTitle:self.m_nsTitle forState:UIControlStateNormal];
		}
	}
}

- (void)dealloc 
{
	self.m_pButton = nil;
	self.m_pDelegate = nil;
    [super dealloc];
}

-(void)checkboxButton:(id)sender
{
	self.m_bChecked = !self.m_bChecked;
	[self.m_pButton setSelected:self.m_bChecked];

	if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(TZTUICheckBoxClicked:bCheck_:)])
	{
		
		[m_pDelegate TZTUICheckBoxClicked:self bCheck_:self.m_bChecked];
	}
}

@end
