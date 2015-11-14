/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        个股查询vc
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
#import "tztUISearchStockView.h"

@interface tztUISearchStockViewController : TZTUIBaseViewController<tztHqBaseViewDelegate>
{
    tztUISearchStockView    *_pSearchStockView;
    BOOL                    _bShowSearchView;
    NSString                *_nsURL;
}
@property(nonatomic, retain)tztUISearchStockView    *pSearchStockView;
@property(nonatomic, retain)NSString                *nsURL;
@property(nonatomic)BOOL                            bShowSearchView;
@property(nonatomic)BOOL                            bUsePush;
@end
