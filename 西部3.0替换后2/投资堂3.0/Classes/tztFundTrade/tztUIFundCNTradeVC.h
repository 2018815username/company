//
//  tztUIFundCNTradeVC.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-14.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTUIBaseViewController.h"
#import "tztUIFundCNTradeView.h"

@interface tztUIFundCNTradeVC : TZTUIBaseViewController
{
    tztUIFundCNTradeView        *_pFundTradeCN;
    
    NSString                    *_CurStockCode;
    
}

@property(nonatomic,retain)tztUIFundCNTradeView     *pFundTradeCN;
@property(nonatomic,retain)NSString                 *CurStockCode;
@end
