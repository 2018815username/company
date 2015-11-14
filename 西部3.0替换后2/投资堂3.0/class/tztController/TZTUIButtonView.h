/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUIButtonView
* 文件标识:
* 摘要说明:		自定义按钮控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class TZTUIButtonView;
@protocol TZTUIButtonViewDelegate
-(void)OnButton:(id)sender;
@end


@interface TZTUIButtonView : UIButton
{
	//按钮
	UIButton *m_pButton;
	//背景图
	NSString *m_nsImgBack;
	//小图
	NSString *m_nsIamge;
	//标题文字
	NSString *m_nsTitle;
	//颜色
	UIColor	 *m_pColor;
	//字体
	int		 m_nFontSize;
	//是否需要对页面数据进行校验
	BOOL	 bNeedCheck;
	//代理
	id		 m_pDelegate;
    
    NSInteger       m_nNumberOfRow;
}

@property (nonatomic,retain)UIButton *m_pButton;
@property (nonatomic,retain)NSString *m_nsImgBack;
@property (nonatomic,retain)NSString *m_nsImage;
@property (nonatomic,retain)NSString *m_nsTitle;
@property (nonatomic,retain)UIColor  *m_pColor;
@property (nonatomic,retain)UILabel	 *m_pLabel;
@property int	m_nFontSize;
@property (nonatomic,assign)id m_pDelegate;
@property BOOL	bNeedCheck;
@property NSInteger m_nNumberOfRow;

-(id)CreateButtonViewWithFrame:(CGRect)frame nsImgBack_:(NSString*)nsImageBace nsImage_:(NSString*)nsImage nsTitle_:(NSString*)nsTitle;
-(void)setBackgroundImageView:(NSString*)nsImage;
@end
