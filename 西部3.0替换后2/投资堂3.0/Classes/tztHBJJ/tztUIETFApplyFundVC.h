/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        货币基金(ETF) 认购/申购/赎回 VC
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztETFApplyFundView.h"

@interface tztUIETFApplyFundVC : TZTUIBaseViewController
{
    tztETFApplyFundView         *_pApplyFundView;
}

@property(nonatomic, retain)tztETFApplyFundView        *pApplyFundView;
@end
