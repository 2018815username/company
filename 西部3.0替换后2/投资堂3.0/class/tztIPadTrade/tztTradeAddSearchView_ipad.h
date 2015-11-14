/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ipad交易界面中（底部有查询界面的主界面，例如：委托买卖界面等）
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
#import "tztBaseTradeView.h"

@interface tztTradeAddSearchView_ipad : tztBaseTradeView
{
    tztBaseTradeView * _pTradeView;
    tztBaseTradeView * _pSearchView;
}
@property(nonatomic,retain)tztBaseTradeView * pTradeView;
@property(nonatomic,retain)tztBaseTradeView * pSearchView;
-(tztBaseTradeView *)GetTradeBaseViewByMsgType;
-(tztBaseTradeView *)GetSearchBaseViewByMsgType;
-(void)SetDefaultData;
-(void)OnRefresh;
-(void)OnRequestData;
@end
