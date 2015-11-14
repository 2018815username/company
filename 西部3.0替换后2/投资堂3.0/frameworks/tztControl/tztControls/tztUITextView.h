//
//  tztUITextView.h
//  tztMobileApp
//
//  Created by yangdl on 13-2-22.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tztUIBaseViewDelegate.h"

@protocol tztUITextViewDelegate;
@protocol tztUIBaseViewDelegate;
/**
 *  自定义textview控件显示，并可动态计算高度显示
 */
@interface tztUITextView : UITextView<tztUIBaseViewDelegate>
{
    CGFloat _minHeight;
	CGFloat _maxHeight;
	
	int _maxNumberOfLines;
	int _minNumberOfLines;
	
	BOOL _animateHeightChange;
    
    BOOL _tztcheckdate;
    BOOL _tztsendaction;
    int _maxlen;
    id _tztdelegate;
    NSString* _tzttagcode;
    int _tztKeyboardType;
}
/**
 *  自定义控件tag值
 */
@property (nonatomic,retain) NSString* tzttagcode;
/**
 *  最大行数
 */
@property (nonatomic) int maxNumberOfLines;
/**
 *  最小显示行数
 */
@property (nonatomic) int minNumberOfLines;
/**
 *  最大长度
 */
@property int maxlen;
/**
 *  是否检测数据
 */
@property BOOL tztcheckdate;
/**
 *  输入满maxlen后是否触发相应事件
 */
@property BOOL tztsendaction;
/**
 *  键盘类型，见自定义键盘说明
 */
@property int  tztKeyboardType;
/**
 *  代理
 */
@property (nonatomic, assign) id<tztUIBaseViewTextDelegate> tztdelegate;

/**
 *  初始化创建自定义TextView
 *
 *  @param strProperty 属性字符串
 *
 *  @return tztUITextView对象
 */
- (id)initWithProperty:(NSString*)strProperty;

/**
 *  设置属性
 *
 *  @param strProperty 属性字符串
 */
- (void)setProperty:(NSString*)strProperty;

/**
 *  数据检测
 *
 *  @return TRUE＝成功
 */
- (BOOL)onCheckdata;
@end