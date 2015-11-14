/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTPageInfoItem.h
 * 文件标识：
 * 摘    要：
 *
 * 当前版本：
 * 作    者：
 * 完成日期：
 *
 * 备	 注：
 *******************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  PageItemInfo结构位置定义
 */
typedef NS_ENUM(NSInteger, PageItemInfo){
    /**
     *  类型ID
     */
    PII_PageID,
    /**
     *  正常显示图片
     */
    PII_NormalImg,
    /**
     *  选中图片
     */
    PII_SelectedImg,
    /**
     *  页面名称
     */
    PII_PageName,
    /**
     *  保留字段1
     */
    PII_Rev1,
    /**
     *  保留字段2
     */
    PII_Rev2,
    /**
     *  底图
     */
    PII_BackgroundImg = PII_Rev2,
};

@class TZTUITabBarItem;
/**
 *  TabBar显示的Item页面配置项
 */
@interface TZTPageInfoItem : NSObject {

	unsigned int	_nPageID;			//ID
	UIImage			*_ImgNormal;		//正常显示图片
	UIImage			*_ImgSelected;		//选中图片
    UIImage			*_ImgBackground;
	NSString		*_nsPageName;		//名称
	
	NSString        *_pRev1;		//保留字段
	NSString        *_pRev2;	
}
/**
 *  配置的ID
 */
@property unsigned int	nPageID;
/**
 *  正常显示图片名称
 */
@property (nonatomic, retain) NSString          *nsImgNormal;
/**
 *  正常显示的图片
 */
@property (nonatomic, retain) UIImage			*ImgNormal;
/**
 *  选中显示图片名称
 */
@property (nonatomic, retain) NSString          *nsImgSelected;
/**
 *  选中显示的图片
 */
@property (nonatomic, retain) UIImage			*ImgSelected;
/**
 *  背景图片
 */
@property (nonatomic, retain) UIImage			*ImgBackground;
/**
 *  配置的名称
 */
@property (nonatomic, retain) NSString			*nsPageName;
/**
 *  状态字段（暂未使用）
 */
@property (nonatomic)int                        nStatus;
/**
 *  保留字段1
 */
@property (nonatomic, retain) NSString          *pRev1;
/**
 *  保留字段2
 */
@property (nonatomic, retain) NSString          *pRev2;	

/**
 *    @author yinjp
 *
 *    @brief  根据szInfo创建PageInfoItem对象
 *
 *    @param szInfo 格式参照上面PageItemInfo定义，中间以|分割;e.g:PII_PageID|PII_NormalImg|PII_SelectedImg|PII_PageName|PII_Rev1|PII_Rev2|
 *
 *    @return TZTPageInfoItem对象
 */
+(TZTPageInfoItem*) CreateByString:(NSString*)szInfo;
@end
