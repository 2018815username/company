/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：NSObject+TZTSub.h
 * 文件标识：
 * 摘    要：按钮
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.02.29
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "tztUIBaseViewDelegate.h"

@protocol tztUIBaseViewDelegate;
/**
 *  自定义swtich控件，参数详见tztUIControlsProperty.h
 */
@interface tztUISwitch : UIButton<tztUIBaseViewDelegate>
{
    BOOL _switched;
    //状态记录
	BOOL _checked;
    BOOL _tztcheckdate;
    NSString *_yestitle;
    NSString *_notitle;
    UIImage   *_noImage; //否 图片
    UIImage   *_yesImage;//是 图片
    NSString* _tzttagcode;
    id _tztdelegate;
    CGFloat _fontSize;
    id      _tzttarget;
    SEL     _tztaction;
    BOOL    _bUnderLine;
    NSString *_nsUnderLinseColor;
    UIColor  *_pUnCheckedColor;
}
/**
 *  代理
 */
@property (nonatomic,assign) id<tztUIBaseViewCheckDelegate> tztdelegate;
/**
 *  自定义控件tag
 */
@property (nonatomic,retain) NSString* tzttagcode;
/**
 *  是否可以switch
 */
@property (nonatomic) BOOL switched;
/**
 *  当前状态，选中－非选中
 */
@property (nonatomic) BOOL checked;
/**
 *  选中标题文字
 */
@property (nonatomic,retain) NSString* yestitle;
/**
 *  非选中标题文字
 */
@property (nonatomic,retain) NSString* notitle;
/**
 *  非选中图片
 */
@property (nonatomic,retain) UIImage* noImage;
/**
 *  选中图片
 */
@property (nonatomic,retain) UIImage* yesImage;
/**
 *  是否需要检测数据有效性
 */
@property BOOL tztcheckdate;
/**
 *  字体大小
 */
@property (nonatomic) CGFloat fontSize;
/**
 *
 */
@property (nonatomic, assign) id tzttarget;
/**
 *  点击事件
 */
@property (nonatomic) SEL tztaction;
/**
 *  是否下划线
 */
@property BOOL bUnderLine;
/**
 *  正常显示颜色
 */
@property(nonatomic,retain)UIColor *pNormalColor;
/**
 *  下划线颜色
 */
@property (nonatomic, retain)NSString* nsUnderLineColor;
/**
 *  非选中时颜色
 */
@property (nonatomic, retain)UIColor* pUnCheckedColor;

/**
 *  初始化创建switch控件
 *
 *  @param strProperty 属性字符串
 *
 *  @return tztUISwitch控件
 */
- (id)initWithProperty:(NSString*)strProperty;

/**
 *  设置属性字符串
 *
 *  @param strProperty 属性字符串
 */
- (void)setProperty:(NSString*)strProperty;

/**
 *  检测数据
 *
 *  @return 成功＝TRUE
 */
- (BOOL)onCheckdata;
/**
 *  点击事件处理
 *
 *  @param sender sender
 */
- (void)checkboxButton:(id)sender;
@end

