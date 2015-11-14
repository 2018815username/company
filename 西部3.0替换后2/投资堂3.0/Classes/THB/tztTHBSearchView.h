/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztTHBSearchView
 * 文件标识:
 * 摘要说明:		天汇宝查询界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTradeSearchView.h"
@protocol tztTHBSearchViewDelegate<NSObject>
@optional
-(void)ChangeTool:(int)type;
@end
@interface tztTHBSearchView : tztTradeSearchView
{
    int _nRequestType;
    int _nDateIndex;
    int _nContactIDIndex;
    int _nFlagIndex;
    int _nAmountIndex;
    int _nMarketIndex;
}
@property int nRequestType;
@property int nDateIndex;
@property int nContactIDIndex;
@property int nFlagIndex;
@property int nAmountIndex;
@property int nMarketIndex;
-(void)CheckDLWT;
@end
