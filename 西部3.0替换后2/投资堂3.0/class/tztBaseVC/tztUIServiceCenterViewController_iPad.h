/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        服务中心（iPad）
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
#import "TZTUIBaseTableView.h"
#import "tztUISysLoginViewController.h"

@interface tztUIServiceCenterViewController_iPad : TZTUIBaseViewController<TZTUIBaseTableViewDelegate, tztUISysLoginViewControllerDelegate, tztUITableListViewDelegate>
{
    tztUITableListView      *_pTableView;
    
    UIView                  *_pContentView;
    NSInteger                     m_nType;//保存选中的功能号
    NSString                *_nsMenuID;
}
@property(nonatomic, retain)tztUITableListView  *pTableView;
@property(nonatomic, retain)UIView              *pContentView;
@property(nonatomic, retain)NSString*           nsMenuID;
@end
