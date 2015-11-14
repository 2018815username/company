/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUICheckBox
* 文件标识:
* 摘要说明:		选择框控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <UIKit/UIKit.h>

@class TZTUICheckBox;

//选择框事件协议
@protocol TZTUICheckBoxDelegate
@optional
-(void) TZTUICheckBoxClicked:(id)sender bCheck_:(BOOL)bCheck;
@end


@interface TZTUICheckBox : UIView 
{
	//按钮
	UIButton	*m_pButton;
	//状态记录
	BOOL		m_bChecked;
	//
	id			m_pDelegate;
	//默认文本
	NSString	*m_nsTitle;
	//选中后的文本
	NSString	*m_nsTitleChecked;
	//是否需要进行校验，判断必须选择
	BOOL		m_bNeedCheckValue;
	//提示信息
	NSString	*m_nsMsgInfo;
}

@property (nonatomic, retain)UIButton*	m_pButton;
@property BOOL m_bChecked;
@property (nonatomic, assign) id m_pDelegate;
@property (nonatomic, retain)NSString*	m_nsTitle;
@property (nonatomic, retain)NSString*  m_nsTitleChecked;
@property BOOL m_bNeedCheckValue;
@property (nonatomic, retain)NSString*  m_nsMsgInfo;

//设置显示文字
-(void)setTitleText:(NSString*)nsTitle;
//设置是否选中状态
-(void)setSelected:(BOOL)bSelect;
//创建函数
- (id)initWithFrame:(CGRect)frame withTitle:(NSString*)nsTitle andCheckedTitle_:(NSString*)nsTitleChecked;
@end

