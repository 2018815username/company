/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * @brief 文件名称:
 * @brief 文件标识:
 * @brief 摘要说明:    自选股/沪深 的切换View
 *
 * @brief 当前版本:
 * @brief 作    者:       DBQ
 * @brief 更新日期:
 * @brief 整理修改:        yinjp 20140701
 *
 ***************************************************************/

#import <UIKit/UIKit.h>

@class TZTTagView;
@protocol tztTagViewDelegate <NSObject>

@optional
 /**
 *	@brief	tab按钮点击事件处理协议
 *
 *	@param 	tagView 	当前的tagview
 *	@param 	sender 	点击的buttin
 *	@param 	nIndex 	点击的位置
 *
 *	@return	无
 */
- (void)tztTagView:(TZTTagView*)tagView OnButtonClick:(UIButton*)sender AtIndex:(int)nIndex;

@end

@interface TZTTagView : UIView

 /**
 *	@brief	按钮数组  名称|功能号
 */
@property (nonatomic, retain) NSMutableArray    *ayData;

 /**
 *	@brief	背景色 or 背景图片
 */
@property (nonatomic, retain) UIColor          *clBackground;

 /**
 *	@brief	默认选中位置
 */
@property (nonatomic, assign) NSInteger               nDefaultSelectIndex;

@property (nonatomic, assign) id<tztTagViewDelegate>delegate;

- (void)tztTagView:(TZTTagView *)tagView setSelectIndex:(int)nIndex;

@end
