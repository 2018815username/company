/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTTabBarProfile
* 文件标识:
* 摘要说明:		
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <Foundation/Foundation.h>

/**
 *  tabbarprofile配置文件获取解析，配置文件名称：tztTabBarProfile.plist
 */

@interface TZTTabBarProfile : NSObject
{
    //tabBar项列表，包含顺序
	NSMutableArray	*_ayTabBarItem;
	
	//不显示配置名称，由图片提供
	int _nDrawName;
	int _nDrawNameColor;
    int _nDrawNameColorSel;
    
	//是否启用自动页面展示，显示不下的图标自动归集到列表中供用户选择
	int _nAutoLayout;
	
	//最大显示页面Item个数，默认-1不控制。
	int _nMaxDisplay;
	
	//Item高亮图片名称
	UIImage *_imgHight;
	
    //是否支持滑动
    int _nHandleMove;
    
    //固定宽度绘制图片
    int _nFixedIconWidth;
    
    //图片绘制风格：0 居中；1 置顶；2 沉底；
    int _nDrawIconStyle;
    int _nDrawSelectedStyle;
    int _nDrawMiddleLine;
    
    //两头留白
    int _nMarginHead;
    int _nMarginTail;
    
    //两头留白竖屏方式
    int _nMarginHeadEx;
    int _nMarginTailEx;
    
    //分割线
    int _nSeperator;
    unsigned long _nSeperatorColor;
}

/**
 *  tabBar项列表，包含顺序
 */
@property(nonatomic,retain) NSMutableArray	*ayTabBarItem;

/**
 *  是否需要绘制指定文字名称显示，1需要绘制，0-不需要
 */
@property int nDrawName;
/**
 *  绘制颜色，nDrawName＝1时有效
 */
@property int nDrawNameColor;
/**
 *  绘制选中颜色，nDrawName＝1时有效
 */
@property int nDrawNameColorSel;

/**
 *  是否启用自动页面展示，显示不下的图标自动归集到列表中供用户选择
 */
@property int nAutoLayout;

/**
 *  最大显示页面Item个数，默认-1不控制。
 */
@property int nMaxDisplay;

/**
 *  Item高亮图片名称
 */
@property(nonatomic,retain) UIImage *imgHight;

/**
 *  是否支持滑动(暂不支持)
 */
@property int nHandleMove;

/**
 *  固定宽度绘制图片
 */
@property int nFixedIconWidth;

/**
 *  图片绘制风格：0 居中；1 置顶；2 沉底；
 */
@property int nDrawIconStyle;
/**
 *  选中图片绘制风格：0 居中；1 置顶；2 沉底；
 */
@property int nDrawSelectedStyle;
@property int nDrawMiddleLine;

/**
 *  横屏左侧预留间距
 */
@property int nMarginHead;
/**
 *  横屏右侧预留间距
 */
@property int nMarginTail;

/**
 *  竖屏左侧预留间距
 */
@property int nMarginHeadEx;
/**
 *  竖屏右侧预留间距
 */
@property int nMarginTailEx;

/**
 *  是否绘制分割线
 */
@property int nSeperator;
/**
 *  分割线颜色
 */
@property unsigned long nSeperatorColor;

/**
 *  判断当前是否有TabBarItem
 *
 *  @return TRUE＝有，FALSE＝其他
 */
-(BOOL) HaveTabBarItem;

/**
 *  加载tabbarprofile配置文件解析
 */
-(void) LoadTabBarItem;

/**
 *  根据配置的名称获取对应的索引，用于跳转
 *
 *  @param nsName 名称
 *
 *  @return 对应索引位置
 */
-(int)GetTabItemIndexByName:(NSString*)nsName;

/**
 *  根据配置的ID获取对应的索引，用于跳转
 *
 *  @param nsID id
 *
 *  @return 对应索引位置
 */
-(int)GetTabItemIndexByID:(unsigned int)nsID;

@end

/**
 *  TZTTabBarProfile全局对象
 */
extern TZTTabBarProfile    *g_pTZTTabBarProfile;