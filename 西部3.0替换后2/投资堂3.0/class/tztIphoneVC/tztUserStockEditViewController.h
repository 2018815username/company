/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        自选股编辑vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztUserStockEditView.h"

@interface tztUserStockEditViewController : TZTUIBaseViewController
{
    tztUserStockEditView    *_pEditView;
}
@property(nonatomic, retain)tztUserStockEditView *pEditView;
@end
