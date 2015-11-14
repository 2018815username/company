//
//  F10View.h
//  tztMobileApp_GJUserStock
//
//  Created by wry on 15-4-2.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tztWebView.h"
@interface F10View : UIView

@property(nonatomic,strong)tztWebView* webView;

@property(nonatomic,strong)UILabel* lable;

-(void)stockInfo:(int)pStockInfo andUrl:(NSString* )url;
@end
