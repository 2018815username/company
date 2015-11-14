/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        功能列表界面vc
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

@interface tztUIFuctionListViewController : TZTUIBaseViewController<tztUITableListViewDelegate>
{
    tztUITableListView      *_pMenuView;
    NSString*               _nsProfileName;
    NSMutableDictionary     *_pDict;
}

@property(nonatomic,retain)tztUITableListView   *pMenuView;
@property(nonatomic,retain)NSString*            nsProfileName;
@property(nonatomic,retain)NSMutableDictionary* pDict;
@property(nonatomic)int nFixBackColor;

-(void)SetTitle:(NSString*)strTitle;

-(void)setProfileName:(NSString*)strProfileName;
@end
