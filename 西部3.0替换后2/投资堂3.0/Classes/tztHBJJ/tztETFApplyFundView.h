/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        货币基金(ETF) 认购/申购/赎回 
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztBaseTradeView.h"

@interface tztETFApplyFundView : tztBaseTradeView
{
    tztUIVCBaseView         *_ptztApplyFund;
    
    NSString                *_CurStockCode;
    NSString                *_CurStockName;
    
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayTypeContent;
    NSMutableArray          *_ayStockNum;
    int                     _nCurrentSel;
    NSMutableArray          *_ayData;
    
}

@property(nonatomic, retain)tztUIVCBaseView *ptztApplyFund;
@property(nonatomic, retain)NSString        *CurStockCode;
@property(nonatomic,retain)NSString         *CurStockName;
@property(nonatomic,retain)NSMutableArray   *ayAccount;
@property(nonatomic,retain)NSMutableArray   *ayType;
@property(nonatomic,retain)NSMutableArray   *ayStockNum;
@property(nonatomic,retain)NSMutableArray   *ayData;

-(void)SetDefaultData;
//-(void)DealWithStockCode:(NSString*)nsStockCode;
//买卖确认
-(void)OnSendBuySell;
@end
