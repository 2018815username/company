/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTGridDataObj.h
 * 文件标识：
 * 摘    要：自定义Grid数据 (标题、数据)
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <Foundation/Foundation.h>

/**
 *  自定义表哥标题数据对象
 */
@interface TZTGridDataTitle : NSObject
{
    NSInteger   _tag;//tag
    NSString*	_text;//名称
    UIColor*    _textColor;
    CGFloat     _width;//宽度
    BOOL        _enabled;//可排序
    NSInteger   _order;//当前排序方式 0 默认 1 正序 2 逆序
}
/**
 *  tag
 */
@property (nonatomic)         NSInteger tag;
/**
 *  显示名称
 */
@property (nonatomic, retain) NSString* text;
/**
 *  字体颜色
 */
@property (nonatomic, retain) UIColor*  textColor;
/**
 *  显示宽度
 */
@property CGFloat     width;
/**
 *  是否支持点击排序
 */
@property BOOL        enabled;
/**
 *  当前排序方式
 */
@property NSInteger   order;

/**
 *  设置tagValue //0涨幅1振幅2成交量3量比4总金额5委比6换手率7原序 8最新价 9不排序(Direction无效)
 */
- (void)setTagValue;
@end

/**
 *  自定义表哥内容数据对象
 */
@interface TZTGridData : NSObject {
    NSString        *_text;
    UIColor         *_textColor;
    char            _cChanged;
}
/**
 *  内容文本
 */
@property (nonatomic,retain) NSString *text;
/**
 *  显示颜色
 */
@property (nonatomic,retain) UIColor *textColor;
/**
 *  是否修改
 */
@property char cChanged;

@end