//
//  WZGuideViewController.h
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  帮助引导页 ，tztStartForIPhone5， tztStartForIPhone，分别定义启动引导图图片字符串，中间以逗号(,)分割
 */
@interface WZGuideViewController : UIViewController<UIScrollViewDelegate>

/**
 *  显示引导页，内部会根据info.plist中的版本号进行判断，如果已经显示过，则不再显示,该函数废弃不再使用，请使用下面的block函数
 */
+ (void)show;

/**
 *  显示引导页，同上，增加完成后的bolck处理
 *
 *  @param completion 完成后的block
 */
+ (void)showWithcompletion_:(void(^)(void))completion;

/**
 *  隐藏
 */
+ (void)hide;
@end
