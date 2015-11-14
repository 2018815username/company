//
//  tztUIFountSearchWTVC.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-11.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTUIBaseViewController.h"
#import "tztUIFundSearchView.h"

@interface tztUIFountSearchWTVC : TZTUIBaseViewController
{
    tztUIFundSearchView         *_pSearchView;

    NSString                    *_nsBeginDate;
    NSString                    *_nsEndDate;
    //基金公司代码    
	NSString	*_nsJJGSDM;
	//基金状态
	NSString	*_nsJJState;
	//基金类型
	NSString	*_nsJJKind;
	//基金代码
	NSString	*_nsJJCode;
	//基金名称
	NSString	*_nsJJName;
}

@property(nonatomic, retain)tztUIFundSearchView     *pSearchView;
@property(nonatomic, retain)NSString                *nsBeginDate;
@property(nonatomic, retain)NSString                *nsEndDate;
@property(nonatomic, retain)NSString                *nsJJGSDM;
@property(nonatomic, retain)NSString                *nsJJState;
@property(nonatomic, retain)NSString                *nsJJKind;
@property(nonatomic, retain)NSString                *nsJJCode;
@property(nonatomic, retain)NSString                *nsJJName;
@end

