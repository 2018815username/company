/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztTrendFundView
 * 文件标识：    资金流向
 * 摘    要：
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/

#import "tztHqBaseView.h"
 /**
 *	@brief	资金流向view 圆形图展示
    @brief  yinjp
    @brief
 */
@interface tztTrendFundView : tztHqBaseView

 /**
 *	@brief	获取报价数据，具体查看TNewPriceData结构
 *
 *	@return	返回TNewPriceData结构
 */
-(TNewPriceData*)GetNewPriceData;

 /**
 *	@brief	刷新饼图显示
 *
 *	@return	NULL
 */
-(void)OnRefreshPieView;

@end
