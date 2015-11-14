/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金认购申购赎回
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

@interface tztUIFundTradeRGSGView : tztBaseTradeView
{
    
    tztUIVCBaseView         *_tztTradeTable;
    //基金代码
    NSString                *_CurStockCode;
    //基金公司代码
    NSString                *_nsJJGSCode;
    
    NSMutableArray          *_ayFundData;
    
    int                     _nCurrentSelect;

}

@property(nonatomic,retain)tztUIVCBaseView   *tztTradeTable;
@property(nonatomic,retain)NSString          *CurStockCode;
@property(nonatomic,retain)NSString          *nsJJGSCode;
@property(nonatomic,retain)NSMutableArray    *ayFundData;
@property BOOL isFullWidth; // 是否是frame的width的全部

@property(nonatomic,retain)NSString          *RiskLevel; //基金风险等级
@property(nonatomic,retain)NSString          *KHFXJB; //客户风险测评
@property(nonatomic)float nKHFXJB; //客户风险测评
@property(nonatomic)float nRiskLevel; //基金风险等级



//买卖确定
-(void)OnSendBuySell;
-(void)setStockCode:(NSString*)nsCode;
-(void)fundCustomerInqireLevel;
@end
