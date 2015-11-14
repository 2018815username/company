//
//  tztUIFundFCView.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-14.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztBaseTradeView.h"

@interface tztUIFundFCView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTradeTable;
    //
    NSString                *_CurStockCode;
    //
    NSString                *_CurStockName;
    //
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayAccountType;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayTypeData;
    NSMutableArray          *_ayStockNum;
    
    float                   _fMoveStep;
    float                   _nDotValid;
    
    int                     _nselectAccount;
    int                     _nselecttype;
    
    
    //退市整理标识
    int                     _nLeadTSFlag;
    //退市提示信息
    NSString                *_nsTSInfo;
    
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeTable;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic,retain)NSString             *CurStockName;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSMutableArray       *ayTypeData;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSMutableArray       *ayAccountType;
@property(nonatomic,retain)NSString             *nsTSInfo;


-(void)OnSend;
@end