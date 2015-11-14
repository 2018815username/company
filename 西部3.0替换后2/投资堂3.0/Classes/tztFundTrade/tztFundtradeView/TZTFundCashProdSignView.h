//
//  TZTFundCashProdSignView.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-18.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztBaseTradeView.h"

@interface TZTFundCashProdSignView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTradeTable;
    //公司代码
    NSString                    *_nsGSDM;
	//基金公司名称
	NSString                    *_nsGSMC;
	//当前基金代码
    NSString                    *_nsCode;
	//基金名称
	NSString                    *_nsCodeName;
    NSString                    *_nsPhone;
    NSString                    *_nsEmail;
    NSString                    *_nsLowmat;
	//页面类型（0－签约、1－最低留存金设置）
	int                         _nType;
    tztUIBaseControlsView       *_pBaseControls;
    
}
@property(nonatomic,retain)tztUIVCBaseView          *tztTradeTable;
@property(nonatomic,retain)NSString                 *nsGSDM;
@property(nonatomic,retain)NSString                 *nsGSMC;
@property(nonatomic,retain)NSString                 *nsCode;
@property(nonatomic,retain)NSString                 *nsCodeName;
@property(nonatomic,retain)NSString                 *nsPhone;
@property(nonatomic,retain)NSString                 *nsEmail;
@property(nonatomic,retain)NSString                 *nsLowmat;
@property int nType;
-(void)OnSend;
@end

