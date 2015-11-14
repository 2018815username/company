/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金盘后 分拆，合并
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
#import "tztFundPHTradeView.h"

@interface tztUITradeFundPHViewController : TZTUIBaseViewController
{
    tztFundPHTradeView      *_tztTradeView;
}
@property(nonatomic, retain)tztFundPHTradeView  *tztTradeView;
@end
