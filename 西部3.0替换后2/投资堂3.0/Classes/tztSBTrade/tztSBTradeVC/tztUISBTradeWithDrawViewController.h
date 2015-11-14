/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUISBTradeWithDrawViewController
 * 文件标识:
 * 摘要说明:		股转系统撤单界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztSBTradeWithDrawView.h"
@interface tztUISBTradeWithDrawViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztSBTradeWithDrawView   *_pView;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztSBTradeWithDrawView  *pView;
@end
