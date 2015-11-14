/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金盘后业务 合并、分拆
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

@interface tztFundPHTradeView : tztBaseTradeView
{
    tztUIVCBaseView     *_tztTradeView;
    
    NSMutableArray      *_ayCodeInfo;
    NSMutableArray      *_ayAccountInfo;
    int                 _nSelectAccount;
    NSString            *_CurStockCode;
  NSMutableArray      *_kyData;
}

@property(nonatomic, retain)tztUIVCBaseView *tztTradeView;
@property(nonatomic, retain)NSMutableArray  *ayCodeInfo;
@property(nonatomic, retain)NSMutableArray  *ayAccountInfo;
@property(nonatomic, retain)NSString        *CurStockCode;
 
@end
