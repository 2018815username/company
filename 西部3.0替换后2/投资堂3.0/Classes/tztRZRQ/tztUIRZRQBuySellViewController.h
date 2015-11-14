/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券买卖vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztRZRQBuySellView.h"
#import "tztStockBuySellView.h"

@interface tztUIRZRQBuySellViewController : TZTUIBaseViewController
{
    tztRZRQBuySellView     *_pRZRQBuySell;
    
    BOOL                    _bBuyFlag;
    
    NSString                *_CurStockCode;
    
    NSMutableArray      *_ayTitle; //获取信息
}

@property(nonatomic,retain)tztRZRQBuySellView   *pRZRQBuySell;
@property(nonatomic, retain)NSString* contractNumber; //合约编号
@property(nonatomic, retain)NSString* repaymentAmount; //需还款数量
@property(nonatomic,retain)NSString *CurStockCode;
@property BOOL bBuyFlag;
@property(nonatomic,retain)NSString* nsSeraialNo;

-(void)tztChangeMsgType:(int)nType bBuyFlag_:(BOOL)bFlag;
-(void)OnRequestData;
-(void)tztRefreshData;
@end
