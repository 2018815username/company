/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTBaseTableCellView
* 文件标识:
* 摘要说明:		自定义表格cell
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface TZTBaseTableCellView : UITableViewCell 
{
	BOOL	expanded;       //是否展开
	int		m_nCount;       //总共控件数
	BOOL	bHaveIcon;      //是否有图标显示
	BOOL	bHaveControl;   //是否包含控件
	BOOL	bHaveTitle;     //是否包含标题
	BOOL	bHaveImage;     //是否显示右侧图标
	NSInteger		m_nControl;     //包含的控件数
	int		m_nImage;       //包含的图片
	int		m_nTitleWidth;  //标题宽度
	int		m_nFirstControlWidth;   //第一个控件的宽度
	int		m_nCellMargin;	//间距
	int		m_nIconWidth;	//图标宽度
	NSMutableArray *m_pAyControl;   //控件数组
    NSString *m_nsIcon;
}

@property int		m_nTitleWidth;
@property (nonatomic,getter=isExpanded) BOOL expanded;
@property (nonatomic, retain)NSMutableArray  *m_pAyControl;
@property int		m_nFirstControlWidth;
@property int		m_nCellMargin;
@property int		m_nIconWidth;
@property (nonatomic,retain)NSString* m_nsIcon;

//创建
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
//设置间隔线，nsImg可以传入图片名称，若传空，则用颜色填充
-(void)setGridLine:(NSString*)nsImg;
//设置背景
-(void)setBackground:(NSString*)nsImg;
//设置内容
-(void) setContent:(NSString*)nsIcon nsTitle_:(NSString*)nsTitle pControl_:(NSMutableArray*)pAyControl nsImg_:(NSString*)nsImg;
-(void) setContent:(NSString*)nsIcon nsTitle_:(NSString*)nsTitle pControl_:(NSMutableArray*)pAyControl nsImg_:(NSString*)nsImg bHaveChild_:(BOOL)bHaveChild;
//设置标题
-(void)setTitleText:(NSString*)nsTitle;
-(void)setIconGray;
-(void)setIconNormal;
-(UIImage*)getGrayImage:(UIImage*)sourceImage;
@end

