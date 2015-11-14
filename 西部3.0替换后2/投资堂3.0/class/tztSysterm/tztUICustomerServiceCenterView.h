/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        服务中心菜单列表
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

@interface tztUICustomerServiceCenterView : TZTUIBaseView<tztUITableListViewDelegate>
{
    tztUITableListView      *_pMenuView;
    NSString                *_nsProfileName;
}

@property(nonatomic,retain)tztUITableListView   *pMenuView;
@property(nonatomic,retain)NSString             *nsProfileName;

@end
