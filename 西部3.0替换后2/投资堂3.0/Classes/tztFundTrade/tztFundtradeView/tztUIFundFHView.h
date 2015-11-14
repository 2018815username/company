/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        分红设置view
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

@interface tztUIFundFHView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTradeTable;
    NSMutableArray          *_ayFundData;//基金信息
    //
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayTypeData;
    NSString                *_pCurSetStr;//当前分红设置
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeTable;
@property(nonatomic,retain)NSMutableArray       *ayFundData;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSMutableArray       *ayTypeData;
@property(nonatomic, retain)NSString            *pCurSetStr;

@end