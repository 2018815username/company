/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF 网下现金认购
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

enum
{
    kTagETFCode = 1000,  //ETF代码
    kTagETFGDDm,         //股东代码
    kTagETFName,         //ETF名称
    kTagETFKYZJ,         //可用资金
    kTagETFRGSX,         //ETF认购上限
    kTagETFRGFE,         //ETF认购份额
    kTagOK,              //确认
    kTagCannel,          //返回 //modify by xyt 20131114
};

@interface tztETFCrashRGView : tztBaseTradeView
{
    tztUIVCBaseView         *_ptztCrashTable;
    
    NSString                *_CurStockCode;
    NSString                *_CurStockName;
    
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayStockNum;
    
}

@property(nonatomic, retain)tztUIVCBaseView *ptztCrashTable;
@property(nonatomic, retain)NSString        *CurStockCode;
@property(nonatomic,retain)NSString         *CurStockName;
@property(nonatomic,retain)NSMutableArray   *ayAccount;
@property(nonatomic,retain)NSMutableArray   *ayType;
@property(nonatomic,retain)NSMutableArray   *ayStockNum;

//买卖确认
-(void)OnSendBuySell;
@end
