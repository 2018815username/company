/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUISearchStockStockCodeVCEx
 * 文件标识：
 * 摘    要：   个股查询扩展
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-12
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztUISearchStockViewEx.h"

@interface tztUISearchStockCodeVCEx : TZTUIBaseViewController<tztHqBaseViewDelegate, UISearchBarDelegate, tztUIBaseViewTextDelegate>
{
    tztUISearchStockViewEx  *_pSearchStockView;
    NSString                *_nsURL;
    id                      _lParam;
    BOOL                    _bHidenAddBtn;
}

@property(nonatomic, retain)tztUISearchStockViewEx  *pSearchStockView;
@property(nonatomic, retain)NSString                *nsURL;
@property(nonatomic, assign)id                      lParam;
@property(nonatomic)BOOL                            bHidenAddBtn;
@end
