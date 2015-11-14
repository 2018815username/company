//
//  CUCustomSwitch.h
//  自定义Switch
//
//  
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
/**
 *  自定义Switch控件
 */
@interface CUCustomSwitch : UIControl {
    BOOL    on;
    
    NSString* onText;
    NSString* offText;
    
    UIColor* textColor;
    UIColor* sliderTextColor;
    
    UIImageView *imgViewBG;
    UIImageView *imgSlider;
    
    UILabel *lblOn;
    UILabel *lblOff;
}
/**
 *  当前状态
 */
@property (nonatomic) BOOL on;
/**
 *  on=TRUE时，显示的文本
 */
@property(nonatomic,retain) NSString* onText;
/**
 *  on=FALSE时，显示的文本
 */
@property(nonatomic,retain) NSString* offText;
/**
 *  文本颜色
 */
@property(nonatomic,retain) UIColor* textColor;
/**
 *  选中颜色
 */
@property(nonatomic,retain) UIColor* sliderTextColor;

/**
 *  修改当前switch状态
 *
 *  @param on       TRUE－选中
 *  @param animated 是否动画效果
 */
- (void)setOn:(BOOL)on animated:(BOOL)animated;
/**
 *  修改switch状态
 *
 *  @param onoff 是否选中
 */
- (void)setOn:(BOOL)onoff;
/**
 *  初始化
 *
 *  @param frame 显示frame
 */
- (void)InitFrame:(CGRect)frame;
@end
