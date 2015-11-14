//
//  tztUITextField.h
//  tztMobileApp
//
//  Created by yangdl on 13-2-22.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tztUIBaseViewDelegate.h"

@protocol tztUITextFieldDelegate;
@protocol tztUIBaseViewDelegate;
/**
 *  自定义输入框控件，参数详见tztUIControlsProperty说明
 */
@interface tztUITextField : UITextField <tztUIBaseViewDelegate>
{
    BOOL _tztcheckdate;
    BOOL _tztsendaction;
    NSInteger _maxlen;
    id _tztdelegate;
    BOOL _tztalignment;
    BOOL _tztBPlaceChange; // change placeholder's color and rect, leftAlignment only
    int _tztKeyboardType;
    NSInteger _tztdotvalue;
    NSString* _tzttagcode;
}
/**
 *  提示文字颜色
 */
@property (nonatomic,retain) UIColor * clPlaceHolder;
/**
 *  自定义控件tag值
 */
@property (nonatomic,retain) NSString* tzttagcode;
/**
 *  最大输入长度
 */
@property NSInteger maxlen;
/**
 *  检测数据有效性
 */
@property BOOL tztcheckdate;
/**
 *  输入满最大长度是否触发maxlen对应事件
 */
@property BOOL tztsendaction;
/**
 *  文字对齐方式
 */
@property BOOL tztalignment;
/**
 *  palceholder是否修改（未使用）
 */
@property (nonatomic) BOOL tztBPlaceChange;
/**
 *  输入过程中是否有提示（未使用）
 */
@property (nonatomic) BOOL tztHasTips;
/**
 *  输入键盘类型，参见自定义键盘类型定义
 */
@property int  tztKeyboardType;
/**
 *  小数点位数
 */
@property NSInteger  tztdotvalue;
/**
 *  代理
 */
@property (nonatomic, assign) id<tztUIBaseViewTextDelegate> tztdelegate;

/**
 *  初始化创建自定义输入框
 *
 *  @param strProperty 属性字符串
 *
 *  @return tztUITextField对象
 */
- (id)initWithProperty:(NSString*)strProperty;

/**
 *  设置属性
 *
 *  @param strProperty 属性字符串
 */
- (void)setProperty:(NSString*)strProperty;

/**
 *  检测数据
 *
 *  @return TRUE＝成功
 */
- (BOOL)onCheckdata;
@end

@class TZTUITextField;
@protocol tztSysKeyboardDelegate;
/**
 *  派生tztUITextField,该控件已经不再使用，此处派生只为兼容原先程序代码
 */
@interface	TZTUITextField:tztUITextField<UITextFieldDelegate>
{
	BOOL bNeedCheck;
	NSInteger  nNumberofRow;
	id	m_pDelegate;
}
@property  BOOL bNeedCheck;
@property	NSInteger nNumberofRow;
@property (nonatomic,retain)id<tztSysKeyboardDelegate> m_pDelegate;
@end