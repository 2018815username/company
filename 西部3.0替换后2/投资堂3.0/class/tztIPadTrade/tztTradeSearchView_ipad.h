/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ipad查询界面（在新的ipad查询界面上添加一个工具条界面上面放置刷新、撤单等 除去那些有时间查询的界面）
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

@interface tztTradeSearchView_ipad : tztBaseTradeView
{
    NSMutableArray * _aySearchButtons;
    tztBaseTradeView * _pSearchView;
}
@property(nonatomic,retain)tztBaseTradeView * pSearchView;
@property(nonatomic,retain)NSMutableArray * aySearchButtons;
-(tztBaseTradeView *)GetBaseViewByMsgType;
-(void)SetDefaultData;
-(void)OnRefresh;
-(void)OnRequestData;
@end
