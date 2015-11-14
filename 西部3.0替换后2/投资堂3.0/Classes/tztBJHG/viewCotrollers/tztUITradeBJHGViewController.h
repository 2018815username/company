/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        报价回购买入（新开回购）vc
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
#import "tztBJHGOpenView.h"

@interface tztUITradeBJHGViewController : TZTUIBaseViewController
{
    //界面信息显示
    tztBJHGOpenView     *_tztTableView;
    //股票代码（传入值）
    NSString            *_nsStockCode;
}

@property(nonatomic,retain)tztBJHGOpenView  *tztTableView;
@property(nonatomic,retain)NSString         *nsStockCode;
@end
