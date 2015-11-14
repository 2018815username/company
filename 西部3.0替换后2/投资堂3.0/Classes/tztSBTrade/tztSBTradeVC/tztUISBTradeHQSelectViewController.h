/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUISBTradeHQSelectViewController
 * 文件标识:
 * 摘要说明:		股转系统行情选择界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "TZTUIBaseViewController.h"
#import "tztSBTradeHQSelectView.h"
@interface tztUISBTradeHQSelectViewController : TZTUIBaseViewController<TZTUIBaseViewDelegate>
{
    TZTUIBaseTitleView      *_pTitleView;
    tztSBTradeHQSelectView   *_pView;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztSBTradeHQSelectView  *pView;

-(void)OnOK;
@end
