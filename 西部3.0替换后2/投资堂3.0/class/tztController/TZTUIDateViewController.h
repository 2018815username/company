/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUIDateViewController
* 文件标识:
* 摘要说明:		日期选择控件
* 
* 当前版本:	2.0
* 作    者:	Dengwei
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <UIKit/UIKit.h>
#import "tztUIDateView.h"
#import "TZTUIBaseViewController.h"
@interface TZTUIDateViewController : TZTUIBaseViewController
{
	int                 _nID;
	NSInteger			_vcType; //页面类型 
	
    tztUIDateView       *_pDateView;
}
@property(nonatomic) NSInteger vcType;
@property(nonatomic,retain)tztUIDateView        *pDateView;
//zxl 20130718 添加设置默认最大和最小时间
-(void)SetMaxDate:(NSDate *)MaxDate;
-(void)SetMinDate:(NSDate *)MinDate;
@end
