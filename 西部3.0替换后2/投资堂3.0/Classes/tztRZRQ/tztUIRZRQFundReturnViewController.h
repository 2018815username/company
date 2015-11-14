/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券直接还款vc
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
#import "tztRZRQFundReturn.h"
#import "tztRZRQBuySellView.h"

@interface tztUIRZRQFundReturnViewController : TZTUIBaseViewController
{
    tztRZRQFundReturn           *_pFundReturn;
   
    tztRZRQBuySellView     *_pRZRQBuySell;
        
    BOOL                    _bBuyFlag;
        
    NSString                *_CurStockCode;
        
    NSMutableArray      *_ayTitle; //获取信息
 
    
}
@property(nonatomic,retain)tztRZRQFundReturn           *pFundReturn;
@property(nonatomic,retain)tztRZRQBuySellView   *pRZRQBuySell;
@property(nonatomic, retain)NSString* contractNumber; //合约编号
@property(nonatomic, retain)NSString* repaymentAmount; //需还款数量 (需还款金额 )
@property(nonatomic, retain)NSString* backDate; //到货日期
@property(nonatomic, retain)NSString* debitBalance; //负载金额（费用负债）
@property(nonatomic, retain)NSString* debitInterest;//预计利息
@property(nonatomic, retain)NSString* debitType; //负债类型

@property(nonatomic,retain)NSString*CurStockCode; //股票代码
@property(nonatomic,retain)NSString*CurStockName; //股票名称
@property BOOL bBuyFlag;


/*@property(nonatomic, retain)tztRZRQFundReturn           *pFundReturn;
@property(nonatomic, retain)NSString*                   CurStockCode;
@property(nonatomic, retain)NSString*                   CurStockName;
@property(nonatomic, retain)NSString*                   contractNumber;
@property(nonatomic, retain)NSString*                   repaymentAmount;
@property(nonatomic, retain)NSString*                   backDate;
@property(nonatomic, retain)NSString*                   debitBalance;
@property(nonatomic, retain)NSString*                   debitInterest;
@property(nonatomic, retain)NSString*                   debitType;
 */
@end
