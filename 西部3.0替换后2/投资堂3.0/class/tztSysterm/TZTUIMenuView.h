/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        行情菜单显示
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "TZTUIBaseTableView.h"

@interface TZTUIMenuView : UIView <tztUITableListViewDelegate>
{
    tztUITableListView  *_pTableView;
    id                  _pDelegate;
}

@property(nonatomic, retain)tztUITableListView  *pTableView;
@property(nonatomic, assign)id                  pDelegate;
-(void)setCurrentMenu:(NSString*)nsMenu;
-(NSString*)GetCurrentMenuTitle;
@end
