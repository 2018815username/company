/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券直接还款
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

@interface tztRZRQFundReturn : tztBaseTradeView
{
    tztUIVCBaseView     *_pFundReturn;
    
    /*索引*/
    int                 _nDBBLIndex;            //维持担保比例索引
    int                 _nFZZJEIndex;           //负债总金额索引
    int                 _nFZJEIndex;            //负债金额索引
    int                 _nFZLXIndex;            //负债利息索引
    int                 _nZJHKIndex;            //直接还款可用金额索引
    int                 _nRZRQIndex;            //融资融券可用金额索引
    int                 _nFareDebitIndex;       //费用负债(交易费用负债索引)
    int                 _nOtherDebitIndex;      //其他负债索引
    int                 _nCreditBalanceIndex;   //可用保证金索引
    int                 _nFinanceDebitIndex;    //融资负债索引
    int                 _nMoneyTypeIndex;        //币种类型
    int                 _nMoneyNameIndex;       //币种名称
    int                 _nKZCDBIndex;           //可转出资产担保
    
    int                 _nCurrentSelect;
    NSMutableArray      *_pAyData;
}

@property(nonatomic, retain)tztUIVCBaseView     *pFundReturn;
@property(nonatomic, retain)NSMutableArray      *pAyData;
@end
