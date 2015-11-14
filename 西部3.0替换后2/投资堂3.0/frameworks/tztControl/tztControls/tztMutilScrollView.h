/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        多view滚动切换基类
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
#import "tztPageControl.h"
/**
 *  多view滚动切换view协议
 */
@protocol tztMutilScrollViewDelegate<NSObject>
@optional
/**
 *  滚动后显示
 *
 *  @param CurrentViewIndex 当前view的索引
 */
-(void)tztMutilPageViewDidAppear:(NSInteger)CurrentViewIndex;

/**
 *  滚动后隐藏
 *
 *  @param CurrentViewIndex 当前view索引
 */
-(void)tztMutilPageViewDidDisappear:(NSInteger)CurrentViewIndex;
@end

/**
 *  多个view滚动切换显示基类 ，>=3个支持循环滚动
 */
@interface tztMutilScrollView : UIView<UIScrollViewDelegate,tztPageControlDelegate>
{
    UIScrollView        *_mutilScrollView;
    tztPageControl      *_pageControl;
    
    UIPageControl       *_sysPageControl;
    NSInteger                 _nCurPage;
    NSInteger                 _nPageCount; //总页数
    
    BOOL                _bSet;
    NSMutableArray*     _ayViews;
    
    BOOL                _bSupportLoop;
    id<tztMutilScrollViewDelegate>                  _tztdelegate;
    NSInteger                 _nMaxCount;
}
/**
 *  当前位置
 */
@property NSInteger nCurPage;
/**
 *  需要显示的view数组
 */
@property(nonatomic, retain)NSMutableArray  *pageViews;
/**
 *  是否隐藏底部pagecotrol显示
 */
@property(nonatomic, assign)BOOL  hidePagecontrol;
/**
 *  是否支持系统bounces
 */
@property(nonatomic, assign)BOOL  bounces;
/**
 *  自定义pagecontrol对象
 */
@property(nonatomic, retain)tztPageControl  *pageControl;
/**
 *  系统pagecontrol对象
 */
@property(nonatomic, retain)UIPageControl       *sysPageControl;
/**
 *  代理
 */
@property(nonatomic, assign)id<tztMutilScrollViewDelegate>              tztdelegate;
/**
 *  是否支持循环滚动，若pageViews.count<3,默认不支持
 */
@property BOOL bSupportLoop;
/**
 *  是否使用系统的pagecontrol
 */
@property BOOL bUseSysPageControl;
/**
 *  最大view个数，非循环滚动使用
 */
@property (nonatomic)NSInteger  nMaxCount;
/**
 *  同上SupportLoop
 */
@property (nonatomic)BOOL bLoopScroll;
/**
 *  滚动到指定view显示
 *
 *  @param aIndex   指定view的位置索引
 *  @param animated 是否使用动画效果
 */
- (void)scrollToIndex:(NSInteger)aIndex animated:(BOOL)animated;
/**
 *  滚动到指定view
 *
 *  @param pView    指定的view
 *  @param animated 是否需要动画
 */
- (void)scrollToView:(UIView*)pView animated:(BOOL)animated;
/**
 *  是否允许滚动
 *
 *  @param bScroll TRUE－允许滚动，控件默认是TRUE
 */
- (void)setScrollEnabled:(BOOL)bScroll;
@end
