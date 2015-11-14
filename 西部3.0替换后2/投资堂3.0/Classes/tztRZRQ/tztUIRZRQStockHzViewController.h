/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券划转vc
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
#import "tztRZRQStockHzView.h"


@interface tztUIRZRQStockHzViewController : TZTUIBaseViewController
{
    tztRZRQStockHzView           *_pStockHzView;
}

@property(nonatomic, retain)tztRZRQStockHzView           *pStockHzView;
@end
