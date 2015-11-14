/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztReportPage.h
 * 文件标识：
 * 摘    要：首页－国际指数列表 
 *
 * 当前版本： 2.0
 * 作    者：yangdl
 * 完成日期： 2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import <Foundation/Foundation.h>
@interface tztReportPage : tztHqBaseView
{
    int _cellCount;     //显示(请求)个数
    int _curindex;      //起始序号
}
- (void)setCellCount:(int)cellCount;
@end
