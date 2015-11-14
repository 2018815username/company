/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:       质押回购交易操作(质押债券入库，质押债券出库，融资回购，融券回购)
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
#import "tztZYHGTradeView.h"

@interface tztUITradeZYHGTradeViewController : TZTUIBaseViewController
{
    tztZYHGTradeView        *_tztTradeView;
}

@property(nonatomic, retain)tztZYHGTradeView    *tztTradeView;
@end
