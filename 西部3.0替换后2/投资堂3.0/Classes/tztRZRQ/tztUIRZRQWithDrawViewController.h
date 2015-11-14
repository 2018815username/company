/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券委托撤单
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
#import "tztRZRQTradeWithDrawView.h"

@interface tztUIRZRQWithDrawViewController : TZTUIBaseViewController
{
    tztRZRQTradeWithDrawView    *_pWithDrawView;
}
@property(nonatomic, retain)tztRZRQTradeWithDrawView    *pWithDrawView;
@end
