//
//  tztUIFundCNTradeView.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-14.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztBaseTradeView.h"
#import "TZTUIBaseTableView.h"

@interface tztUIFundCNTradeView : tztBaseTradeView<TZTUIBaseTableViewDelegate>
{
    tztUIVCBaseView         *_tztTradeTable;
    //
    NSString                *_CurStockCode;
    //
    NSString                *_CurStockName;
    //
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayStockNum;
    
    float                   _fMoveStep;
    float                   _nDotValid;
    
    int                     _nselectAccount;
    
    //退市整理标识
    int                     _nLeadTSFlag;
    //退市提示信息
    NSString                *_nsTSInfo;
    
    tztUIBaseControlsView   *_pBaseControls;
    tztStockInfo            *_pStock;
    
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeTable;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic,retain)NSString             *CurStockName;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSMutableArray       *ayStockNum;
@property(nonatomic,retain)NSString             *nsTSInfo;
@property(nonatomic,retain)tztStockInfo         *pStock;
@property(nonatomic, retain)NSString            *pCurSetStr;


-(void)OnSend;
@end