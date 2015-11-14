/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易界面右边是查询股票界面（买卖界面）
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztBaseTradeView.h"
#import "tztTradeSearchView.h"
#import "tztStockBuySellView.h"
#import "tztBankDealerView.h"

@interface tztUIRightSearchView : tztBaseTradeView//<tztSearchDelegate,tztStockBuySellViewDelegate>
{
    tztTradeSearchView * _pSearchView;
    tztBaseTradeView   * _pBaseView;
    float           _pLeftWidth;
}
@property(nonatomic,retain)tztTradeSearchView * pSearchView;
@property(nonatomic,retain)tztBaseTradeView * pBaseView;
-(void)SetLeftViewByPageType;
@end
