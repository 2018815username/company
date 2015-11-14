/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        F10显示(iPad)
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
#import "tztInfoTableView.h"
#import "tztInfoContentView.h"

@interface tztStockF10ViewController : TZTUIBaseViewController<tztInfoDelegate,tztHqBaseViewDelegate>
{
    //一级菜单
    tztInfoTableView    *_tztTableInfoView;
    //二级菜单
    tztInfoTableView    *_tztSecondInfoView;
    //内容显示
    tztInfoContentView  *_tztContentInfoView;
    
    int                 _nLevel;
}
@property(nonatomic, retain)tztInfoTableView    *tztTableInfoView;
@property(nonatomic, retain)tztInfoTableView    *tztSecondInfoView;
@property(nonatomic, retain)tztInfoContentView  *tztContentInfoView;
@property(nonatomic)int nLevel;

-(void)OnRefreshData;
@end
