/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztNewOpenGHView
 * 文件标识:
 * 摘要说明:		天汇宝新开回购界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztBaseTradeView.h"
#import "tztUIVCBaseView.h"

@interface tztNewOpenGHView : tztBaseTradeView<tztUIDroplistViewDelegate>
{
    tztUIVCBaseView         *_tztTradeTable;
    NSString                *_nsCurStockCode;
    NSString        *_nsCurAccountType;
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayStockNum;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeTable;
@property(nonatomic,retain)NSString *nsCurStockCode;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSMutableArray       *ayStockNum;
@property(nonatomic,retain)NSString *nsCurAccountType;
@end
