//
//  TZTFundSearchPlansTransVC.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-20.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTUIBaseViewController.h"
#import "TZTFundSearchPlansTransView.h"

@interface TZTFundSearchPlansTransVC : TZTUIBaseViewController
{
    TZTFundSearchPlansTransView *_pFundTrade;
    
    //公司代码
    NSString                    *_nsGSDM;
	//基金公司名称
	NSString                    *_nsGSMC;
	//当前基金代码
    NSString                    *_nsCode;
	//基金名称
	NSString                    *_nsCodeName;
	//页面类型（0－签约、1－最低留存金设置）
	int                         _nType;
    
}

@property(nonatomic,retain)TZTFundSearchPlansTransView  *pFundTrade;
@property(nonatomic,retain)NSString                     *nsGSDM;
@property(nonatomic,retain)NSString                     *nsGSMC;
@property(nonatomic,retain)NSString                     *nsCode;
@property(nonatomic,retain)NSString                     *nsCodeName;
@property int nType;

@end
