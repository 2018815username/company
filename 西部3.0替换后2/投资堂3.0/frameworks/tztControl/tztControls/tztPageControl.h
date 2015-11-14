/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:     tztPageControl
 * 文件标识:
 * 摘要说明:     自定义PageControl
 *
 * 当前版本:     1.0
 * 作   者:     yinjp
 * 更新日期:     20140116
 * 整理修改:
 *
 ***************************************************************/


#import <UIKit/UIKit.h>

@protocol tztPageControlDelegate;

/**
 *  自定义pagecontrol
 */
@interface tztPageControl : UILabel

/**
 *  设置显示图片信息
 *
 *  @param normalImage      正常显示图片
 *  @param highlightedImage 选中后图片
 *  @param key              对应key值，目前只支持一个字符
 */
-(void)setImage:(UIImage*)normalImage highlightedImage_:(UIImage*)highlightedImage forKey:(NSString*)key;
/**
 *  移除所有控件
 */
-(void)removeAllObjects;
/**
 *  当前位置
 */
@property (nonatomic,assign) NSInteger page;
/**
 *  总共个数
 */
@property (nonatomic,readonly)NSInteger numberOfPages;
/**
 *  setImage中key组成的字符串，多个图片就多个key，组成字符串
    e.g:FKL-表示F、K、L分别对应三个不同的图片显示
 */
@property (nonatomic,copy) NSString *pattern;
/**
 *  代理
 */
@property (nonatomic,assign) id<tztPageControlDelegate>delegate;
@end

/**
 *  自定义pagecontrol协议
 */
@protocol tztPageControlDelegate <NSObject>
@optional
/**
 *  是否更新当前pagecontrol显示（暂未处理）
 *
 *  @param pageControl pagecontrol对象
 *  @param newPage     需要的page
 *
 *  @return 布尔值
 */
-(BOOL)tztPageControl:(tztPageControl*)pageControl shouldUpdateToPage:(NSInteger)newPage;
/**
 *  更新当前pagecontrol显示
 *
 *  @param pageControl pagecontrol对象
 *  @param newPage     需要更新的page
 */
-(void)tztPageControl:(tztPageControl*)pageControl didUpdateTpPage:(NSInteger)newPage;

@end
