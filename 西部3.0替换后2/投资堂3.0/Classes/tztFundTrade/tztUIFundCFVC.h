//
//  tztUIFundCFVC.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-14.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTUIBaseViewController.h"
#import "tztUIFundFCView.h"

@interface tztUIFundCFVC : TZTUIBaseViewController
{
    tztUIFundFCView             *_pFundTradeCF;
    
    NSString                    *_CurStockCode;
    
}
@property(nonatomic,retain)tztUIFundFCView          *pFundTradeCF;
@property(nonatomic,retain)NSString                 *CurStockCode;

@end
