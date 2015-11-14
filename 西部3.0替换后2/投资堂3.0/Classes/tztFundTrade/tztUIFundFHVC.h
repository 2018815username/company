//
//  tztUIFundFHVC.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-12.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTUIBaseViewController.h"
#import "tztUIFundFHView.h"

@interface tztUIFundFHVC : TZTUIBaseViewController
{
    tztUIFundFHView             *_pFundFhView;
    
    tztStockInfo                *_pStock;
}

@property(nonatomic, retain)tztUIFundFHView         *pFundFhView;
@property(nonatomic, retain)tztStockInfo            *pStock;
@end
