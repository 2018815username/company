/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		tztUIButton
* 文件标识:
* 摘要说明:		自定义按钮控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "tztUIBaseViewDelegate.h"

@class tztUIButton;
/**
 *  自定义button协议
 */
@protocol tztUIButtonDelegate
@optional
/**
 *  button点击事件处理
 *
 *  @param sender tztUIButton对象
 */
-(void)OnButtonClick:(id)sender;
/**
 *  检测数据
 *
 *  @param sender tztUIButton对象
 *
 *  @return 检测成功TRUE
 */
-(BOOL)OnCheckData:(id)sender;
@end

@protocol tztUIBaseViewDelegate;
/**
 *  自定义button对象，
    可以直接通过NSString进行创建，key=value形式，多个参数中间以|分割
    tag|按钮类型|区域|title|textAlignment|font|backimage|image|需检测数据|valueimage|imageAlignment|
 */
@interface tztUIButton : UIButton <tztUIBaseViewDelegate>
{
    UIButton* _imagebtn;
    UIButton* _valuebtn;
    
    NSString* _imagebtnname;
    int  _image;
    CGFloat _fontsize;
	//是否需要对页面数据进行校验
	BOOL	 _tztcheckdate;
	//代理
	id	_tztdelegate;
    NSString* _tzttagcode;
    float    _fCellWidth;
    float    _nHeight;
}
/**
 *  自定义tag值
 */
@property (nonatomic,retain) NSString* tzttagcode;
/**
 *  图片名称
 */
@property (nonatomic,retain)NSString* imagebtnname;
/**
 *
 */
@property (nonatomic, retain)UIButton* valuebtn;
/**
 *  代理
 */
@property (nonatomic,assign)id<tztUIButtonDelegate> tztdelegate;
/**
 *  是否检测数据
 */
@property BOOL	tztcheckdate;

/**
 *  初始化创建自定义button
 *
 *  @param strProperty 属性字符串，见tztUIButton说明
 *  @param fWidth      宽度
 *
 *  @return tztUIButton对象
 */
- (id)initWithProperty:(NSString*)strProperty withCellWidth_:(float)fWidth;

/**
 *  初始化创建自定义button
 *
 *  @param strProperty 属性字符串，见tztUIButton说明
 *
 *  @return tztUIButton对象
 */
- (id)initWithProperty:(NSString*)strProperty;

/**
 *  设置tztUIButton属性
 *
 *  @param strProperty 属性字符串，见tztUIButton说明
 */
- (void)setProperty:(NSString*)strProperty;

/**
 *  检测数据
 *
 *  @return 成功返回TRUE，其他返回FALSE
 */
- (BOOL)onCheckdata;

-(void)setBackgroundColor:(UIColor *)backgroundColor;


@end
