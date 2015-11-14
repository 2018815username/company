/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    InitStockCode
 * 文件标识：
 * 摘    要：   下载本地代码表
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：    20130829
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/

#import <UIKit/UIKit.h>

@interface tztInitStockCode : TZTUIBaseView
{
    tztDataBase             *_tztDB;
}
-(void)RequestInitStockCode;
-(NSMutableArray*)SearchStockLocal:(NSString*)nsText;
@end

extern tztInitStockCode     *g_pInitStockCode;
