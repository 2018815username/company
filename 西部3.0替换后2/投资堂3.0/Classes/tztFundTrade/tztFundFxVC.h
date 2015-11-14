//
//  tztFundFxVC.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-18.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztBaseTradeView.h"
#import "tztWebViewController.h"

@interface tztFundFxVC :  tztBaseTradeView<tztWebViewDelegate> {
	NSString *requestID;
	id requestBody;
	NSInteger	m_nMsgID;
    NSString* m_nsUpdateAddr;
    NSString* m_nsCompanyDM;
    NSString* m_nsCompany;
    BOOL    m_bRZ;
    NSInteger _nChangMsgID;
}

@property(nonatomic,retain)id requestBody;
@property(nonatomic,retain)NSString *requestID;
@property NSInteger m_nMsgID;
@property(nonatomic,retain)NSString *m_nsUpdateAddr;
@property(nonatomic,retain)NSString *m_nsCompanyDM;
@property(nonatomic,retain)NSString *m_nsCompany;
@property NSInteger nChangeMsgID;
-(void) MakeSimpleRequestStr;
-(void)Dorequest;
-(void)DoShowFXCP;//显示风险测评
-(void)DoSendFXCP:(int)nSocre;//发送测评分数
-(void)DoShowFXJSS;
//基金开户，传入基金代码，公司代码以及开户成功后回调的功能好nMsgType（都可为空）
-(void)doOpenAccount:(NSString*)nsCompany nsGSDM_:(NSString*)nsGSDM nType_:(int)nMsgType;

+(void)ShowMessageBox:(NSString*)nsTitle nsContent_:(NSString*)nsContent;
@end

