/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztDLWTSetYLJEView
 * 文件标识:
 * 摘要说明:		天汇宝代理委托-预留金额设置界面、开通界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztBaseTradeView.h"
#import "tztUIVCBaseView.h"

@interface tztDLWTSetYLJEView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTradeTable;
    int _nShowType;//区分界面类型
    NSString *_nsStcokCode;
    NSString *_nsStockName;
    NSString *_nsNowYLJE;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeTable;
@property int nShowType;
@property(nonatomic,retain) NSString *nsStcokCode;
@property(nonatomic,retain) NSString *nsStockName;
@property(nonatomic,retain) NSString *nsNowYLJE;
@end
