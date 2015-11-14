/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		tztUIControlsProperty
* 文件标识:
* 摘要说明:		投资堂控件属性
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <Foundation/Foundation.h>
@interface NSMutableDictionary (tztUIControlsProperty)
-(void) settztProperty:(NSString*)strproperty;
@end
/************************************************************
 TZTLabel TZTTextView TZTEdit TZTTextField TZTButton TZTCheckBox TZTComBox TZTSwitch
 //tag tztcodetag   默认 nil
 //rect 区域
 //lines 行数      默认 系统自定
 //text  文本      默认 系统自定
 //textcolor 文本颜色 R,G,B 默认 系统自定
 //textAlignment 文本对齐方式 默认 系统自定
 //font 字体大小    默认系统自定
 //enabled         默认系统自定
 //adjustsFontSizeToFitWidth 默认系统自定
 //password  加密显示
 //keyboardtype  number 数字键盘
 //type      控件类型
 //checkdata 检测数据
 //maxlen    最大长度
 //maxaction 输入满触发事件
 //placeholder 提示文本
 //backimage
 
 //maxlines //最大行数
 //minlines //最小行数
 //title    
 //image       btn image
 //messageinfo //checkbtn messageinfo
 //yestitle     //checkbtn,switch yestitle
 //notitle      //checkbtn,switch notitle
 //yesimage    //switch yesimage
 //noimage     //switch noimage
 //valueimage  //带图标按钮图标名
 //dropbtn     
 //dropdelete
 
 //radius  半径 默认10
 //cellheight cell高度 默认44
 //autocalcul 自动添加控件间隔，表格间隔 默认 1
 //gridline  表格线 默认 1
 **************************************************************/
