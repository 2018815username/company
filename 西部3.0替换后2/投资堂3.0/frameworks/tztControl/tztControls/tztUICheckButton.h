/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUICheckButton
* 文件标识:
* 摘要说明:		选择框控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <UIKit/UIKit.h>
#import "tztUIBaseViewDelegate.h"
@class tztUICheckButton;

@protocol tztUIBaseViewDelegate;
/**
 *  自定义选择框控件
 可以直接通过NSString进行创建，key=value形式，多个参数中间以|分割
 tag|区域|value|textAlignment|font|控件类型|未选中信息|选中信息|提示信息|是否必须选中|
 */
@interface tztUICheckButton : UIButton <tztUIBaseViewDelegate> 
{
    UIButton*   _checkbtn;//选择框
//    UIButton*   _infobtn; //信息
    UILabel*    _infolab;
    //是否需要进行校验，判断必须选择
	BOOL		 _tztcheckdate;
    BOOL         _checkleft;
	id			 _tztdelegate;
    //提示信息
    NSString    *_yestitle;
    NSString    *_notitle;
	NSString	*_messageinfo;
    NSString* _tzttagcode;
}
/**
 *  自定义控件tag值
 */
@property (nonatomic,retain) NSString* tzttagcode;
/**
 *  代理
 */
@property (nonatomic, assign) id<tztUIBaseViewCheckDelegate> tztdelegate;
/**
 *  选中文字
 */
@property (nonatomic, retain)NSString*  yestitle;
/**
 *  非选中文字
 */
@property (nonatomic, retain)NSString*  notitle;
/**
 *  提示信息
 */
@property (nonatomic, retain)NSString*  messageinfo;
/**
 *  是否检测数据
 */
@property BOOL tztcheckdate;

/**
 *  初始化创建tztUICheckButton
 *
 *  @param strProperty 属性字符串
 *
 *  @return tztUICheckButton对象
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
 *  @return 成功＝TRUE
 */
- (BOOL)onCheckdata;

/**
 *  设置checkbutton图片
 *
 *  @param image 图片
 *  @param state 状态
 */
- (void)setCheckButtonImage:(UIImage*)image forState:(UIControlState)state;

/**
 *  设置checkbutton状态
 *
 *  @param bSelect 是否选中
 */
- (void)setCheckButtonState:(BOOL)bSelect;
@end

