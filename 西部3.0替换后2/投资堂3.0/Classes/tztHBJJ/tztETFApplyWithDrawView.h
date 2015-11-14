/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        货币基金(ETF)内部撤单
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztETFSearchView.h"

@interface tztETFApplyWithDrawView : tztETFSearchView
{
    int     _nContactIDIndex;   //委托合同索引
    
    int     _nMarketIndex;  //
}
@property int nContactIDIndex;
@end
