//
//  tztStatusBar.h
//  tztbase
//
//  Created by King on 14-3-7.
//  Copyright (c) 2014年 yangares. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tztStatusBar;

/**tztStatusBar回调处理*/
@protocol tztStatusBarDelegate <NSObject>
@optional
/**tztStatusBar点击后的回调函数*/
-(void)tztStatusBarClicked:(tztStatusBar*)statusBar;
@end

/**状态栏位置修改显示，用作于消息提醒，可根据调整显示位置，并支持点击回调处理*/
@interface tztStatusBar : UIView<tztStatusBarDelegate>

/**显示状态栏数据，显示在顶部状态栏位置  nsString-显示内容 bgColor-背景色 txtColor-文本颜色 fTime-显示时间 delegate-回调处理 */
+(void)tztShowMessageInStatusBar:(NSString*)nsString
                        bgColor_:(UIColor*)bgColor
                       txtColor_:(UIColor*)txtColor
                       fTimeOut_:(CGFloat)fTime
                       delegate_:(id)delegate;

/**显示状态栏数据  nsString-显示内容 bgColor-背景色 txtColor-文本颜色 fTime-显示时间 delegate-回调处理 nPosition-默认0-顶部状态栏 1-底部显示*/
+(void)tztShowMessageInStatusBar:(NSString *)nsString
                        bgColor_:(UIColor *)bgColor
                       txtColor_:(UIColor *)txtColor
                       fTimeOut_:(CGFloat)fTime
                       delegate_:(id)delegate
                      nPosition_:(int)nPosition;//增加位置 default 0-顶部状态栏 1-底部显示（推送消息显示）

/**使用默认颜色等显示nsStatus内容*/
+(void)tztShowMessageInStatus:(NSString*)nsStatus;
@end
