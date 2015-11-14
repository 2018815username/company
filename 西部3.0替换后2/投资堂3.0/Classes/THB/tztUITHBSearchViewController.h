/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUITHBSearchViewController
 * 文件标识:
 * 摘要说明:		天汇宝查询界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "TZTUIBaseTitleView.h"
#import "tztTHBSearchView.h"

@interface tztUITHBSearchViewController : TZTUIBaseViewController<tztTHBSearchViewDelegate>
{
    TZTUIBaseTitleView      *_pTitleView;
    tztTHBSearchView   *_pView;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztTHBSearchView  *pView;
@end
