/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        自定义tabbar绘制，事件响应处理
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
#import "TZTPageInfoItem.h"

/**
 *    @author yinjp, 15-01-29 15:01:09
 *
 *    @brief  自定义tabbaritem
 */
@interface TZTUITabBarItem : UITabBarItem
{
    SEL         action;             
    id          target;
    
    int         defaultWidth;
    UIImage     *selectedImage;
    UIImage     *hightImage;
    UIImage     *unselectedImage;
    UIColor     *selectedColor;
    UIColor     *unselectedColor;
    UIImage     *backgroundImage;
    
    BOOL        drawText;
    int         selectFont;
    int         unselectFont;
    
    CGRect      drawRect;
}

/**
 *  响应事件
 */
@property(nonatomic)	SEL			action;
/**
 *  响应对象
 */
@property(nonatomic,assign)	id			target;

/**
 *  默认宽度
 */
@property	int			defaultWidth;
/**
 *  选中图片，默认nil
 */
@property(nonatomic,retain)	UIImage     *selectedImage;
/**
 *  高亮图片，默认nil
 */
@property(nonatomic,retain)	UIImage		*hightImage;
/**
 *  正常图片，默认nil
 */
@property(nonatomic,retain)	UIImage     *unselectedImage;
/**
 *  选中颜色
 */
@property(nonatomic,retain)	UIColor		*selectedColor;
/**
 *  非选中颜色
 */
@property(nonatomic,retain)	UIColor		*unselectedColor;
/**
 *  背景底图
 */
@property(nonatomic,retain)	UIImage     *backgroundImage;
/**
 *  是否绘制文字
 */
@property BOOL		drawText;
/**
 *  选中字体大小
 */
@property int			selectFont;
/**
 *  非选中字体大小
 */
@property int			unselectFont;
/**
 *  绘制区域
 */
@property (nonatomic,readwrite) CGRect		drawRect;

/**
 *  初始化创建tabbarItem
 *
 *  @param title    标题文字
 *  @param image    图片
 *  @param delegate 代理
 *  @param action   事件响应
 *
 *  @return TZTUITabBarItem对象
 */
-(id)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)delegate action:(SEL)action;
/**
 *  绘制显示
 *
 *  @param nMovr  nMovr
 *  @param rect   绘制区域
 *  @param select 是否选中
 */
-(void)DrawInRect:(int)nMovr rect:(CGRect)rect selected:(int)select;
@end

/**
 *  TZTPageInfoItem扩展
 */
@interface TZTPageInfoItem(TZTTabBarItem)
/**
 *  创建TZTUITabBarItem对象
 *
 *  @return TZTUITabBarItem对象
 */
-(TZTUITabBarItem*)CreateTabBarItem;
@end

/**
 *  tabBar协议扩展
 */
@protocol UITabBarDelegateEx <NSObject>

@optional
/**
 *  点击事件处理
 *
 *  @param item 点击的TabBarItem对象
 */
-(void)tabBarItemClicked:(UITabBarItem*)item;
/**
 *  点击事件处理
 *
 *  @param index 点击的位置
 */
-(void)tabBarItemClickedIndex:(NSUInteger)index;
/**
 *  交换两个item位置
 *
 *  @param nIndex1 第一个item
 *  @param nIndex2 第二个item
 */
-(void)tabBarItemExchangeObjectAtIndex:(int)nIndex1 withObjtctAtIndex:(int)nIndex2;

@end

/**
 *  自定义TabBar控件
 */
@interface TZTUITabBar : UITabBar 
{
    NSInteger     preSelIndex;
    NSInteger     selectIndex;
    
    NSMutableArray      *ayItemList;
    CGPoint             movingPoint;
    BOOL                bMoveing;
    BOOL                bDragged;
    NSInteger                 maxDisplay;
    CGRect              rectLogo;
    NSInteger                 m_nCount;
    
    //
    BOOL                bMovie;
    NSInteger                 moveClick;
    NSInteger                 moveOffset;
    NSTimer             *movieTimer;
}

/**
 *  需要显示的tabbarItem数组
 */
@property(nonatomic,retain)NSMutableArray   *ayItemList;
/**
 *  代理
 */
@property(nonatomic,assign)id<UITabBarDelegate, UITabBarDelegateEx>delegate;
/**
 *  最大显示个数
 */
@property NSInteger   maxDisplay;
/**
 *  动画显示定时器（未使用）
 */
@property(nonatomic,assign)NSTimer *movieTimer;

/**
 *  设置显示的tabbarItem数组内容
 *
 *  @param itemList tabbarItem数组内容
 */
-(void)SetItemList:(NSMutableArray *)itemList;

/**
 *  取消前面的选中操作
 */
-(void)UndoSelect;

/**
 *  切换到指定位置选中
 *
 *  @param nIndex 需要选中的位置
 */
-(void)ChangeSelect:(NSInteger)nIndex;

/**
 *  是否选中的和上次一样
 *
 *  @return TRUE＝相同的选中操作
 */
-(BOOL)IsSelectTheSameItem;

/**
 *  开始定时器动画效果（未使用）
 */
-(void)StartMovieTimer;

/**
 *  结束动画定时器（未使用）
 */
-(void)EndMovieTimer;

/**
 *  动画具体处理（未使用）
 */
-(void)OnMoved;




@end
