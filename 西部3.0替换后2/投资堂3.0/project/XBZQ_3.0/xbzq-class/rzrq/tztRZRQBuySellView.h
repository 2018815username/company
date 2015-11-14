/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        融资融券买卖
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztBaseTradeView.h"
#import "tztStockBuySellView.h"

@interface tztRZRQBuySellView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTradeView;
    NSString                *_CurStockCode;
    //
    NSString                *_CurStockName;
    //
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayAccountData;
    NSMutableArray          *_priceData;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayStockNum;
    
    NSMutableArray          *_ayData;
    int                     _nCurrentSel;
    
    float                   _fMoveStep;
    int                     _nDotValid;
    
    BOOL                    _bBuyFlag;
    
    //退市整理标识
    int                     _nLeadTSFlag;
    //退市提示信息
    NSString                *_nsTSInfo;
    
    //买券还券、现券还券，建议IOS版提供可供选择的代码列表定义一个BOOL
    BOOL                    _isShowDropList;
    

    
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeView;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic,retain)NSString             *CurStockName;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSMutableArray       *ayStockNum;
@property(nonatomic,retain)NSMutableArray       *ayData;
@property(nonatomic,retain)NSString             *nsTSInfo;
@property BOOL  bBuyFlag;

-(void)OnRefresh;
//买卖确定
-(void)OnSendBuySell;
-(void)setStockCode:(NSString*)nsCode;
@end
