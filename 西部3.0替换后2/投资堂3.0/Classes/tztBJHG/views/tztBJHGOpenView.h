/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        报价回购买入(新开回购)
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

@interface tztBJHGOpenView : tztBaseTradeView
{
    tztUIVCBaseView     *_tztTableView;
    
    NSMutableArray      *_ayAccountInfo;
    
    NSString            *_CurStockCode;
}
@property(nonatomic, retain)tztUIVCBaseView *tztTableView;
@property(nonatomic, retain)NSMutableArray  *ayAccountInfo;
@property(nonatomic, retain)NSString        *CurStockCode;

-(void)SetStockCode:(NSString*)nsStockCode;
@end
