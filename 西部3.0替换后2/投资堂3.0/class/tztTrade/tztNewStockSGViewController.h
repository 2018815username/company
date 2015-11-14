/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        新股申购
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztNewStockSGView.h"


@interface tztNewStockSGViewController : TZTUIBaseViewController
{
    tztNewStockSGView                 *_pView;
}

@property(nonatomic, retain)tztNewStockSGView             *pView;
@end