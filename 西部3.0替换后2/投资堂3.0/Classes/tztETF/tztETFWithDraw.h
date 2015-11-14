/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF撤单
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

@interface tztETFWithDraw : tztBaseTradeView
{
    tztUIVCBaseView         *_ptztCrashTable;
    
    NSString                *_CurStockCode;
    NSString                *_CurStockName;
    
    NSMutableArray          *_ayAccount;    //股东代码
    NSMutableArray          *_ayType;       //账号类别
    NSMutableArray          *_ayStockNum;   //ETF可撤数量
    NSMutableArray          *_ayName;       //ETF名称
    NSMutableArray          *_ayCompCode;   //成份股代码
    NSMutableArray          *_ayCompName;   //成份股名称
    NSMutableArray          *_ayCompAccount;//成股份账号
    
    NSMutableArray          *_ayData;       //保存持仓数据
    int                     _nCurrentSel;
    
}

@property(nonatomic, retain)tztUIVCBaseView *ptztCrashTable;
@property(nonatomic, retain)NSString        *CurStockCode;
@property(nonatomic,retain)NSString         *CurStockName;
@property(nonatomic,retain)NSMutableArray   *ayAccount;
@property(nonatomic,retain)NSMutableArray   *ayType;
@property(nonatomic,retain)NSMutableArray   *ayStockNum;
@property(nonatomic,retain)NSMutableArray   *ayName;
@property(nonatomic,retain)NSMutableArray   *ayCompCode;
@property(nonatomic,retain)NSMutableArray   *ayCompName;
@property(nonatomic,retain)NSMutableArray   *ayCompAccount;

//买卖确认
-(void)OnSendBuySell;
@end

