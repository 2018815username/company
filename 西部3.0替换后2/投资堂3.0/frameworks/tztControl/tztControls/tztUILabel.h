//
//  tztUILable.h
//  tztMobileApp
//
//  Created by yangdl on 13-2-22.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tztUIBaseViewDelegate.h"

@protocol tztUIBaseViewDelegate;

/**
 *  自定义label控件
 */
@interface tztUILabel : UILabel<tztUIBaseViewDelegate>
{
    NSString* _tzttagcode;//
    float     _fCellWidth;//整行的宽度，用于百分比配置界面 一行多个控件
    float     _fCellHeight;
    UIEdgeInsets _insets;
}
/**
 *  自定义控件tag值
 */
@property (nonatomic,retain) NSString* tzttagcode;
/**
 *  显示高度
 */
@property (nonatomic,assign) float     fCellHeight;

/**
 *  初始化创建label控件
 *
 *  @param strProperty 属性字符串，详见tztUIControlsProperty.h中说明
 *  @param fWidth      显示宽度
 *  @param fHeight     显示高度
 *
 *  @return tztUILabel对象
 */
- (id)initWithProperty:(NSString*)strProperty withCellWidth_:(float)fWidth CellHeight_:(float)fHeight;

/**
 *  初始化创建label控件
 *
 *  @param strProperty 属性字符串，详见tztUIControlsProperty.h中说明
 *
 *  @return tztUILabel对象
 */
- (id)initWithProperty:(NSString*)strProperty;

/**
 *  设置属性
 *
 *  @param strProperty 属性字符串
 */
- (void)setProperty:(NSString*)strProperty;

/**
 *  设置UIEdgeInsets
 *
 *  @param insets UIEdgeInsets
 */
- (void)setUIEdgeInsets:(UIEdgeInsets)insets;

/**
 *  设置背景颜色
 *
 */
- (void)setLabelBackgroundColor:(NSString*)strColor andMyBackGroundImage:(NSString*)imageName;
@end
