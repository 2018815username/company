//
//  TZTFundCashProdSignViewController.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-18.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTUIBaseViewController.h"
#import "TZTFundCashProdSignView.h"

@interface TZTFundCashProdSignViewController : TZTUIBaseViewController
{
    TZTFundCashProdSignView     *_pFundTradeZH;
    
    //公司代码
    NSString                    *_nsGSDM;
	//基金公司名称
	NSString                    *_nsGSMC;
	//当前基金代码
    NSString                    *_nsCode;
	//基金名称
	NSString                    *_nsCodeName;
    //电话
    NSString                    *_nsPhone;
    //email
    NSString                    *_nsEmail;
    //最低金额
    NSString                    *_nsLowmat;
    
	//页面类型（0－签约、1－最低留存金设置）
	int                         _nType;
    
}

@property(nonatomic,retain)TZTFundCashProdSignView  *pFundTradeZH;
@property(nonatomic,retain)NSString                 *nsGSDM;
@property(nonatomic,retain)NSString                 *nsGSMC;
@property(nonatomic,retain)NSString                 *nsCode;
@property(nonatomic,retain)NSString                 *nsCodeName;
@property(nonatomic,retain)NSString                 *nsPhone;
@property(nonatomic,retain)NSString                 *nsEmail;
@property(nonatomic,retain)NSString                 *nsLowmat;
@property int nType;

@end
