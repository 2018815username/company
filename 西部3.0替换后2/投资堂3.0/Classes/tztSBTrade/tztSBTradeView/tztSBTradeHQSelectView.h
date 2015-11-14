/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztSBTradeHQSelectView
 * 文件标识:
 * 摘要说明:		股转系统行情选择界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

@interface tztSBTradeHQSelectView : TZTUIBaseView<TZTUIBaseViewDelegate>
{
    tztUIVCBaseView         *_tztTradeView;
    NSMutableArray         *_ayType;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeView;
@property(nonatomic,retain)NSMutableArray   *ayType;
@end
