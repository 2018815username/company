//
//  tztFundFxVC.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-18.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztFundFxVC.h"
@implementation tztFundFxVC
@synthesize requestBody;
@synthesize requestID;
@synthesize m_nMsgID;
@synthesize m_nsUpdateAddr;
@synthesize m_nsCompanyDM;
@synthesize m_nsCompany;
@synthesize nChangeMsgID = _nChangMsgID;
-(id)init
{
	if(self = [super init])
	{
        [[tztMoblieStockComm getShareInstance] addObj:self];
		requestID = NULL;
        self.m_nsUpdateAddr = @"";
        self.m_nsCompanyDM = @"";
        self.m_nsCompany = @"";
        self.nChangeMsgID = 0;
        m_bRZ = FALSE;
	}
	return self;
}


-(void)Dorequest
{
	if(!requestID)
		return;
    [self MakeSimpleRequestStr];
}

//显示风险测评
-(void)DoShowFXCP
{
	if (g_navigationController == NULL)
		return;
    tztWebViewController *pVC = [[tztWebViewController alloc] init];
    pVC.ViewTag = 1122;
    pVC.tztDelegate = self;
    [pVC setTitle:@"风险问卷测评"];
    NSString* strUrl = @"http://www.gtja.com/preview/diaocha.html";
    [pVC setLocalWebURL:strUrl];
    [g_navigationController pushViewController:pVC animated:UseAnimated];
    [pVC release];
}

//显示风险揭示书
-(void)DoShowFXJSS
{
	if (g_navigationController == NULL)
		return;
    
    tztWebViewController *pVC = [[tztWebViewController alloc] init];
    pVC.ViewTag = 1123;
    pVC.tztDelegate = self;
    pVC.nWebType = tztWebSelect;
    [pVC setTitle:@"风险揭示书"];
    NSString* strUrl = @"http://www.gtja.com/preview/yyzFxjss.html";
    [pVC setLocalWebURL:strUrl];
    [g_navigationController pushViewController:pVC animated:UseAnimated];
    [pVC release];
}

//发送风险测评分数
-(void)DoSendFXCP:(int)nSocre
{
    requestID = @"560";
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:[NSString stringWithFormat:@"%d",nSocre] forKey:@"SCORE"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:requestID withDictValue:pDict];
    DelObject(pDict);
    
}

//签署风险揭示书
-(void)DoSendFXJSS
{
    requestID = @"510";
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:requestID withDictValue:pDict];
    DelObject(pDict);
}

//基金开户，传入基金代码，公司代码以及开户成功后回调的功能好nMsgType（都可为空）
-(void)doOpenAccount:(NSString*)nsCompany nsGSDM_:(NSString*)nsGSDM nType_:(int)nMsgType
{
    self.m_nsCompanyDM = nsGSDM;
    self.m_nsCompany = nsCompany;
    self.nChangeMsgID = nMsgType;
    //开户前，先弹出提示
    NSString *protocol = @"《互联网自助增设开放式基金账户协议书》\
	\r\n敬告客户，在您自助增设开放式基金账户之前，请您详细阅读以下条款：\
	\r\n一、当您点击本协议的【我理解并接受上述条款】之后，即视为签署本协议，您可以通过国泰君安证券互联网站（www.gtja.com）自助增设开放式基金账户。\
	\r\n二、凡使用您的账号和密码在国泰君安证券互联网站办理的开放式基金账户业务，均视为您本人亲自办理的有效行为，由此产生的一切后果由您本人承担。\
	\r\n三、您必须按照操作提示如实填写相关资料，并承诺所填写资料的准确、真实和完整。\
	\r\n四、国泰君安证券是您申请开放式基金业务的代理销售机构，负责将您的申请数据传送至基金管理公司，但申请数据的最终确认结果由基金管理公司及其过户登记机构负责。\
	\r\n五、在提交增设开放式基金账户申请之后，您可以通过国泰君安证券互联网站“基金账户资料查询”功能，确定开户状态，并获取账号资料。\
	\r\n六、对以下原因造成的后果，国泰君安证券不承担任何责任：\
	\r\n1. 您未完整、真实、准确地填妥各项申请内容，或未附上所需要的全部资料；\
	\r\n2. 因不符合证券投资基金契约和招募说明书规定的条件而使各类申请无效；\
	\r\n3. 由于基金管理公司的过失，造成损害结果的发生；\
	\r\n4. 其他非国泰君安证券股份有限公司过失造成的原因，如突发性的通讯、设备故障或自然灾害及其它不可抗力因素。\
	\r\n七、国泰君安证券慎重提醒您： \
	\r\n1. 基金以往的经营业绩，不代表基金的未来业绩，基金管理人除尽诚信的管理义务外，不负责基金的盈亏，也不保证基金的最低收益。请您详阅基金契约、招募说明书等法律文件，了解并自愿承担投资基金的风险。\
	\r\n2. 国泰君安证券股份有限公司对您投资基金的业绩不承担任何担保和其他经济责任。 \
	\r\n八、本协议书为国泰君安证券股份有限公司与您签署的证券交易开户文件的一部分，本协议未尽事宜受您签署的系列证券交易开户文件所共同约束。";
	
	[self showMessageBox:protocol
				  nType_:TZTBoxTypeButtonBoth
				   nTag_:WT_JJINZHUCEACCOUNTEx
			   delegate_:self
			  withTitle_:@"请阅读以下开户协议"
				   nsOK_:@"同意"
			   nsCancel_:@"不同意"];
}
-(void) MakeSimpleRequestStr
{
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"PMD" forKey:@"HsString"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:requestID withDictValue:pDict];
	DelObject(pDict);
}

-(void)doGetReturnBackData:(tztNewMSParse*)pParse
{
	//风险测评，揭示书签署
	if ([pParse IsAction:@"188"])
	{
		NSString *strData = [pParse GetByName:@"Signed"];
		if (strData && [strData length] > 0)
		{
			int nType = [strData intValue];
			//未测评
			if (nType == 0)
			{
                if (m_nMsgID == WT_JJRiskSign)
                {
                    //未测评，直接打开测评页面
                    [self DoShowFXCP];
                }else
                {
                    //未测评，给出提示再测评
                    NSString* nsMsg = @"您未做过风险测评所以无法进行此操作，是否进行测评？";
                    [self showMessageBox:nsMsg
                                  nType_:TZTBoxTypeButtonBoth
                                   nTag_:0x1111
                               delegate_:self
                              withTitle_:@"风险测评"
                                   nsOK_:@"评测"
                               nsCancel_:@"返回"];
                }
                
				return;
			}
			//未签署
			else if(nType == 1)
			{
                //未签署，给出提示再签署
                NSString* nsMsg = @"您未签署风险风险揭示书所以无法进行此操作，是否进行签署？";
                [self showMessageBox:nsMsg
                              nType_:TZTBoxTypeButtonBoth
                               nTag_:0x2222
                           delegate_:self
                          withTitle_:@"风险揭示书"
                               nsOK_:@"签署"
                           nsCancel_:@"返回"];
                return;
			}
			//已测评，已签署
			else if(nType == 2)
			{
                //获取测评分数登记
                NSString * nsfxdjMC = [pParse GetByNameGBK:@"levname"];
                if (nsfxdjMC == nil || [nsfxdjMC length] < 1)
                {
                    nsfxdjMC = @"";
                }
                NSString *nsfxdj = [pParse GetByNameGBK:@"LEVID"];
                if (nsfxdj == nil || [nsfxdj length] < 1)
                {
                    nsfxdj = @"";
                }
                tztJYLoginInfo * userInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
                if (userInfo)
                {
                    userInfo.FundTradefxmc = [NSString stringWithFormat:@"%@",nsfxdjMC];
                    userInfo.FundTradefxjb = [nsfxdj intValue];
                    userInfo.bCheckFXCP = TRUE;
                }
				if (self.nChangeMsgID == 0)
				{
					if (m_nMsgID == WT_JJRiskSign)
					{
                        NSString* nsMsg = [NSString stringWithFormat:@"您已经做过风险测评了,当前风险等级为:%@。是否要重新进行测评？",nsfxdjMC];
                        [self showMessageBox:nsMsg
                                      nType_:TZTBoxTypeButtonBoth
                                       nTag_:0x3333
                                   delegate_:self
                                  withTitle_:@"风险测评"
                                       nsOK_:@"评测"
                                   nsCancel_:@"返回"];
					}
					else if (m_nMsgID == WT_JJRevealsSign)
					{
                        [self showMessageBox:@"您已经签署过风险揭示书了!" nType_:TZTBoxTypeNoButton nTag_:0];
					}
				}else
                {
                    [TZTUIBaseVCMsg OnMsg:self.nChangeMsgID wParam:(NSUInteger)0 lParam:(NSUInteger)0];
                }
			}
		}
		return;
	}
    
    if ([pParse IsAction:@"560"])
    {
        NSString *strMsg = [pParse GetErrorMessage];
        strMsg = [NSString stringWithFormat:@"%@  请返回继续操作。",strMsg];
        if (strMsg)
            [self showMessageBox:strMsg nType_:TZTBoxTypeNoButton nTag_:0];
    }
    
    if ([pParse IsAction:@"510"])
    {
        NSString *strMsg = [pParse GetErrorMessage];
        if (strMsg)
            [self showMessageBox:strMsg nType_:TZTBoxTypeNoButton nTag_:0];
        else
            [self showMessageBox:@"签署成功请继续操作！" nType_:TZTBoxTypeNoButton nTag_:0];
    }
	
}


+(NSString *)get_filename:(NSString *)name
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
            stringByAppendingPathComponent:name];
}

+(BOOL)is_file_exist:(NSString *)name
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[tztFundFxVC get_filename:name]];
}



- (void)dealloc {
	DelObject(requestBody);
	//DelObject(requestID);
	requestID = NULL;
    [[tztMoblieStockComm getShareInstance] removeObj:self];
	
    [super dealloc];
}

#pragma mark receiveData

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
	tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];
    
    if ([tztBaseTradeView IsExitError:nErrNo])
    {
        [self OnNeedLoginOut];
        if (strError)
            tztAfxMessageBox(strError);
        return 0;
    }
	if (nErrNo < 0)
    {
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        return 0;
    }
	if([pParse IsAction:requestID])
	{
		if((requestBody)&&([requestBody respondsToSelector:@selector(doGetReturnBackData:)]))
			[requestBody doGetReturnBackData:pParse];
	}
	
	return 1;
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (TZTUIMessageBox.tag)
    {
        case 0x1111:
        case 0x3333:
        {
            if (buttonIndex == 0)
            {
                [self DoShowFXCP];
            }
        }
            break;
        case 0x2222:
        {
            if (buttonIndex == 0)
            {
                //直接打开风险签署界面
                [self DoShowFXJSS];
            }
        }
        case WT_JJINZHUCEACCOUNTEx:
        case MENU_JY_FUND_Kaihu:
        {
            if (buttonIndex == 0)
            {
                NSString *strValue = [NSString stringWithFormat:@"%@|%@|%ld",self.m_nsCompanyDM,self.m_nsCompany,(long)self.nChangeMsgID];
                [TZTUIBaseVCMsg OnMsg:WT_JJINZHUCEACCOUNTEx wParam:(NSUInteger)strValue lParam:0];
            }
        }
            break;
        default:
            break;
    }
    return;
}

-(void)DealToolClick:(id)Sender
{
    tztWebView *web = (tztWebView *)Sender;
    if (web.tag == 1123)
    {
        [self DoSendFXJSS];
    }
}

+(void)ShowMessageBox:(NSString*)nsTitle nsContent_:(NSString*)nsContent
{
	CGRect appRect = [[UIScreen mainScreen] bounds];
	TZTUIMessageBox *pMessage = [[[TZTUIMessageBox alloc] initWithFrame:appRect nBoxType_:TZTBoxTypeNoButton delegate_:nil] autorelease];;
	pMessage.tag = 0;
	//需要组织字符串
	pMessage.m_nsContent = [NSString stringWithString:nsContent];
	pMessage.m_nsTitle = nsTitle;
	
	[pMessage showForView:g_navigationController.topViewController.view];
}
@end
