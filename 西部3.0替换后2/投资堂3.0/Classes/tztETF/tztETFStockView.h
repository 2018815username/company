/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF股票认购
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

@interface tztETFStockView : tztBaseTradeView
{
    tztUIVCBaseView         *_ptztStockTable;
    NSString                *_CurStockCode;
    NSString                *_CurCFStockCode;//成份股票
    NSMutableArray          *_ayData;   //保存持仓数据
    NSMutableArray          *_ayKYData; //可用
    NSMutableArray          *_ayAccountData;   //保存成份股东代码
    int                     _nCurrentSel;
    //
    NSString                *_CurStockName;
    //
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayStockNum;
}
@property(nonatomic, retain)tztUIVCBaseView *ptztStockTable;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic,retain)NSString             *CurCFStockCode;
@property(nonatomic,retain)NSString             *CurStockName;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSMutableArray       *ayStockNum;
@property(nonatomic,retain)NSMutableArray       *ayData;
@property(nonatomic,retain)NSMutableArray       *ayKYData;
@property(nonatomic,retain)NSMutableArray       *ayAccountData;
@end
