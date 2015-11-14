//
//  SevenSwitch
//
//  Created by Benjamin Vogelzang on 6/10/13.
//  Copyright (c) 2013 Ben Vogelzang. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>
/**
 *  第三方定义switch控件协议
 */
@protocol tztSevenSwitchDelegate <NSObject>
/**
 *  switch控件状态变更事件
 *
 *  @param sender tztSevenSwitch
 *  @param bOn    当前状态
 */
-(void)tztSevenSwitchChanged:(id)sender status_:(BOOL)bOn;

@end

/**
 *  第三方switch控件
 */
@interface TZTSevenSwitch : UIControl
/**
 *  代理
 */
@property (nonatomic, assign)id tztDelegate;
/**
 *  设置switch开或者关，没有动画效果
 */
@property (nonatomic, assign) BOOL on;

/**
 *  设置关闭时的背景颜色，默认clear color
 */
@property (nonatomic, retain) UIColor *inactiveColor;

/**
 *  设置关闭时点击的背景色，默认light gray
 */
@property (nonatomic, retain) UIColor *activeColor;

/**
 *  设置开启时的背景色，默认green
 */
@property (nonatomic, retain) UIColor *onColor;

/**
 *  设置关闭时的border颜色，默认light gray
 */
@property (nonatomic, retain) UIColor *borderColor;

/**
 *  设置knob颜色，默认白色
 */
@property (nonatomic, retain) UIColor *knobColor;

/**
 *  设置knob阴影颜色，默认gray
 */
@property (nonatomic, retain) UIColor *shadowColor;

/**
 *  设置是否圆角显示，默认YES
 */
@property (nonatomic, assign) BOOL isRounded;

/**
 *  设置开启时的图片显示，图片大小和显示区域一致
 */
@property (nonatomic, retain) UIImage *onImage;

/**
 *  设置关闭时的图片显示
 */
@property (nonatomic, retain) UIImage *offImage;

/**
 *  设置switch开或者关
 *
 *  @param on       YES＝开，NO＝关
 *  @param animated 动画显示
 */
- (void)setOn:(BOOL)on animated:(BOOL)animated;

/**
 *  获取当前switch是开还是关
 *
 *  @return YES＝on， NO＝off
 */
- (BOOL)isOn;

@end
