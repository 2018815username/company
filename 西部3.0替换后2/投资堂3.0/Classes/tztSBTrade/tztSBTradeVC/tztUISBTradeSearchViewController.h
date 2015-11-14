/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUISBTradeSearchViewController
 * 文件标识:
 * 摘要说明:		股转系统查询界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztSBTradeSearchView.h"
@interface tztUISBTradeSearchViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztSBTradeSearchView   *_pView;
    NSString * _nsStock;
    NSString * _nsType;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztSBTradeSearchView  *pView;
@property(nonatomic,retain)NSString * nsStock;
@property(nonatomic,retain)NSString * nsType;
@end
