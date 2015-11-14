/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        质押回购交易界面
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztBaseTradeView.h"

@interface tztZYHGTradeView : tztBaseTradeView
{
    tztUIVCBaseView     *_tztTradeView; //界面显示view
    NSMutableArray      *_ayAccountInfo;//账号信息
    NSString            *_CurStockCode;
}

@property(nonatomic, retain)tztUIVCBaseView *tztTradeView;
@property(nonatomic, retain)NSMutableArray  *ayAccountInfo;
@property(nonatomic, retain)NSString        *CurStockCode;
@end
