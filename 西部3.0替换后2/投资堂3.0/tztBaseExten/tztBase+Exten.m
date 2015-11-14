//
//  NSObject+tztBase_Exten.m
//  tztMobileApp
//
//  Created by yangares on 13-6-18.
//
//

#import <tztMobileBase/tztNSLocation.h>
#import "tztBase+Exten.h"
#import "sys/utsname.h"
#import <tztControl/TZTSystermConfig.h>
#import <tztHqBase/tztJYLoginInfo.h>
#import <tztHqBase/TZTUserInfoDeal.h>
#import <tztHqBase/tztUserStock.h>


@implementation tztMoblieStockComm (tztBaseExten)
- (void)addTztCommHead:(NSMutableDictionary*)sendValue
{
    [tztMoblieStockComm AddCommHead:sendValue];
}

- (void)addTztCommJYHead:(NSMutableDictionary*)sendValue
{
    [tztMoblieStockComm AddCommJYHead:sendValue];
}

+ (void)AddCommHead:(NSMutableDictionary*)sendValue
{
    NSString* strTemp = [sendValue tztObjectForKey:@"MobileCode"];
    if (!ISNSStringValid(strTemp))
    {
        NSString* strlogMobile = [tztKeyChain load:tztLogMobile];
        if (strlogMobile && strlogMobile.length > 0 && validateMobile(strlogMobile))
            [sendValue setTztObject:strlogMobile forKey:@"MobileCode"];
    }
    
    
#ifdef tzt_FixCFrom
    [sendValue setTztObject:tzt_FixCFrom forKey:@"Cfrom"];
#else
    if (g_pSystermConfig && g_pSystermConfig.strSysFrom && g_pSystermConfig.strSysFrom.length > 0)
        [sendValue setTztObject:g_pSystermConfig.strSysFrom forKey:@"Cfrom"];
    else
        [sendValue setTztObject:@"tzt.iphone" forKey:@"Cfrom"];
#endif
    
#ifdef Has_From
#ifdef tzt_FixCFrom
    [sendValue setTztObject:tzt_FixCFrom forKey:@"from"];
#else
    if (g_pSystermConfig && g_pSystermConfig.strSysFrom && g_pSystermConfig.strSysFrom.length > 0)
        [sendValue setTztObject:g_pSystermConfig.strSysFrom forKey:@"from"];
    else
        [sendValue setTztObject:@"tzt.iphone" forKey:@"from"];
#endif
#endif
    
#ifdef tzt_TFrom
    [sendValue setTztObject:tzt_TFrom forKey:@"TFrom"];
#else
#if TARGET_OS_IPHONE
    [sendValue setTztObject:(IS_TZTIPAD ? @"ipad":@"iphone") forKey:@"TFrom"];
#else
    [sendValue setTztObject:@"macos" forKey:@"TFrom"];
#endif
#endif
    //    [sendValue setTztObject:(IS_TZTIPAD ? @"ipad":@"iphone") forKey:@"Tfrom"];
//    
//    if(g_ntztProtocol == tztProtocol2011)
//    {
//        [sendValue setTztObject:@"3" forKey:@"ZLib"];
//    }
//    [sendValue setTztObject:@"1" forKey:@"newindex"];
    //add by xyt 20130718
    NSString* strReqNo = [sendValue tztValueForKey:@"Reqno"];
    tztNewReqno* tztReqNo = [tztNewReqno reqnoWithString:strReqNo];
    
    NSString* strIphoneKey = [NSString stringWithFormat:@"%ld", [tztReqNo getIphoneKey]];
    [sendValue setTztValue:strIphoneKey forKey:@"IphoneKey"];
    
    [tztMoblieStockComm AddClientInfo:sendValue];
}

//目前仅仅设置token和reqno
+ (void)AddCommJYHead:(NSMutableDictionary*)sendValue
{
    int nAccountType = TZTAccountPTType;
    NSString* strAccountType = [sendValue tztObjectForKey:tztTokenType];
    if (strAccountType && [strAccountType length] > 0)
        nAccountType = [strAccountType intValue];
    [tztMoblieStockComm AddCommJYHead:sendValue withTokenType:nAccountType];
}

+(NSString*)deviceString
{
    // 需要 #import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"VerizoniPhone4";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5s";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPodTouch1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPodTouch2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPodTouch3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPodTouch4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad1";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad2(WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad2(GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad2(CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}

+ (void)AddCommJYHead:(NSMutableDictionary*)sendValue withTokenType:(int)nTokenType
{
    NSString* strImei = [tztOpenUDID value];
    if (validateMobile(strImei))
    {
        [sendValue setTztValue:strImei forKey:@"IMEI"];
        NSString* strMobile = [sendValue tztValueForKey:@"MobileCode"];
        if(strMobile == nil || [strMobile length] <= 0)
        {
            [sendValue setTztObject:strImei forKey:@"MobileCode"];
        }
    }
    
    UIDevice *device = [UIDevice currentDevice];
    NSString* strModel = device.model;
    NSString* strVersion = device.systemVersion;
    NSString* strMobileKind = @"";
    
    strModel = [tztMoblieStockComm deviceString];
    
    if (strModel)
        strMobileKind = [NSString stringWithFormat:@"%@", strModel];
    if (strVersion)
        strMobileKind = [NSString stringWithFormat:@"%@-%@",strMobileKind, strVersion];
    
    [sendValue setTztValue:strMobileKind forKey:@"mobilekind"];
    
    
    NSString* strToken = [sendValue tztValueForKey:@"Token"];
    if(strToken == nil) //设置token 必须已经设置了reqno
    {
        NSString* strReqNo = [sendValue tztValueForKey:@"Reqno"];
        tztNewReqno* tztReqNo = [tztNewReqno reqnoWithString:strReqNo];
        NSInteger nTokenIndex = 0;
#ifndef tzt_NoTrade
        tztJYLoginInfo* pCurInfo = [tztJYLoginInfo GetCurJYLoginInfo:nTokenType];
        if(pCurInfo)
            nTokenIndex = [pCurInfo GetTokenIndex];
        if(nTokenIndex < 0)
            nTokenIndex = 0;
#endif
        [tztReqNo setTokenKind:nTokenType];
        [tztReqNo setTokenIndex:(int)nTokenIndex];
        NSString* strNew = [tztReqNo getReqnoValue];
        [sendValue setTztValue:strNew forKey:@"Reqno"];
        
        BOOL bNeedToken = YES;
        NSString* strNeedToken = [sendValue tztValueForKey:@"needToken"];
        if (ISNSStringValid(strNeedToken))
            bNeedToken = [strNeedToken boolValue];
        
        if (bNeedToken)
        {
            strToken = [[tztUserData getShareClass] getAccountTokenOfKind:[tztReqNo getTokenKind] tokenIndex:[tztReqNo getTokenIndex]];
            if(strToken)
                [sendValue setTztValue:strToken forKey:@"Token"];
            else
                [sendValue setTztValue:@"" forKey:@"Token"];
        }
    }
    
    NSString* strAccount = [sendValue tztValueForKey:@"Account"];
    if (strAccount == nil)
    {
        NSString* nsAction = [sendValue tztValueForKey:@"action"];
        NSString* nsAccount = [tztJYLoginInfo GetCurJYLoginInfo:nTokenType].nsAccount;
        if (nsAccount && ([nsAction intValue] != 20106))//20106下载文件，不能发送account，否则无法下载，报获取权限失败
        {
            [sendValue setTztValue:nsAccount forKey:@"Account"];
        }
    }
    
    /*第三方调用时，外部接口可自定义替换，添加*/
    if ([tztHTTPData getShareInstance] && [[tztHTTPData getShareInstance] respondsToSelector:@selector(AddJYCommHeaderEx:withLoginType:)])
    {
        [[tztHTTPData getShareInstance] tztperformSelector:@"AddJYCommHeaderEx:withTokenType:" withObject:sendValue withObject:[NSString stringWithFormat:@"%d", nTokenType]];
    }
    
    //    // test for loginAction
    //    if ([[sendValue tztValueForKey:@"Action"] intValue] == 150)
    //    {
    //
    //        [sendValue setTztValue:@"123456" forKey:@"Token"];
    //    }
}

+(void)AddClientInfo:(NSMutableDictionary*)sendValue
{
#ifdef SendClientInfo
    UIDevice *device = [UIDevice currentDevice];
    //获取当前ip
    NSString* hostIP = [[TZTServerListDeal getShareClass] GetJYAddress];
    NSString* hostName = @"Z01";
    if ([hostIP isEqualToString:@"61.152.107.12"])
        hostName = @"Z01";
    else if([hostIP isEqualToString:@"58.63.247.36"])
        hostName = @"Z02";
    else if ([hostIP isEqualToString:@"113.240.251.17"])
        hostName = @"Z03";
    else if ([hostIP isEqualToString:@"211.136.109.27"])
        hostName = @"Z04";
    else if ([hostIP isEqualToString:@"202.108.196.74"])
        hostName = @"Z05";
    else
        hostName = @"Z01";
    
    //手机号
    NSString* strlogMobile = [tztKeyChain load:tztLogMobile];
    if (strlogMobile == NULL)
        strlogMobile = @"";
    //唯一ID
    NSString* MAC_sid = @"";
    
    //设备厂家
    NSString* deviceManufacturer = @"Apple";
    
    //设备型号类型// e.g. @"iPhone", @"iPod touch"
    NSString* strModel = device.model;
    if (strModel == NULL)
        strModel = @"";
    
    //固件版本
    NSString* deviceFirmwareVersion = @"";
    
    ///操作系统版本号
    NSString* sysVersion = device.systemVersion;
    if (sysVersion == NULL)
        sysVersion = @"";
    
    //客户端更新版本号
    
    
    NSString* str = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@",
                     hostName,
                     strlogMobile,
                     MAC_sid,
                     deviceManufacturer,
                     strModel,
                     deviceFirmwareVersion,
                     sysVersion,
                     g_nsUpVersion,
                     tzt_Inner_Version];
    
    [sendValue setTztObject:str forKey:@"ClientInfo"];
#endif
}

@end

@implementation tztNewMSParse (tztBaseExten)
- (void)SetCommToken
{
    NSString* strToken = [self GetByName:@"Token"];
    if (strToken == NULL || [strToken length] <= 0)
        return;
    
    //交易登录此处不设置
    if ([self IsAllJyLogin])
        return;
    NSString* strNewReqno = [self GetByName:@"Reqno"];
    if(strNewReqno && [strNewReqno length] > 0)
    {
        tztNewReqno *newReqno = [tztNewReqno  reqnoWithString:strNewReqno];
        //设置token
        [[tztUserData getShareClass] setAccountToken:strToken tokenKind:[newReqno getTokenKind] tokenIndex:[newReqno getTokenIndex]];
    }
}
@end

/****** reqxml ********************************************************
 mobilecode     手机号码
 checkkey       行情登录密码
 from
 cfrom
 tfrom
 devicemodel    设备型号
 upversion      升级版本号
 localversion	内部版本号
 account        账号
 accounttype	账号类型
 password       客户账号密码(华泰电子合同使用)
 fund_account	资金账号(华泰电子合同)
 yybcode        营业部号
 token          交易token
 rzrqtoken      融资融券token
 qhtoken        期货token
 usercode       华西，补齐地址使用
 khbranch       华西，补齐地址使用
 oskey          华西，补齐地址使用
 maxcount       请求一页记录条数
 stockcode      股票代码
 stockname      股票名称
 selfstocklist	本地自选股列表
 
 Reqlinktype	 联网地址类型
 0行情链接，1交易链接
 2资讯链接，3均衡链接
 这个变量不需补齐，是要告诉客户端用哪个地址和端口请求数据,
 scrolltotop	值为1告诉WebView滑动到最顶端，用于翻页界面的功能
 
 ***************************************************************/

/****** reqlocal ************************************************
 username	华西，客户姓名
 lastnetaddr	华西，上次登录IP位置
 ***************************************************************/

@implementation tztHTTPData (tztBaseExten)

//下列字段过滤
- (BOOL)isHttpFilterKey:(NSString*)strKey
{
    if(strKey == NULL || [strKey length] <= 0)
        return TRUE;
    if ([strKey caseInsensitiveCompare:tztIphoneREQUSTPARAM] == NSOrderedSame
        || [strKey caseInsensitiveCompare:tztIphoneREQUSTURL] == NSOrderedSame
        || [strKey caseInsensitiveCompare:tztIphoneREQUSTCRC] == NSOrderedSame
        || [strKey caseInsensitiveCompare:tztIphoneReSend] == NSOrderedSame
        || [strKey caseInsensitiveCompare:@"MOBILECODE"] == NSOrderedSame
        || [strKey caseInsensitiveCompare:@"FROM"] == NSOrderedSame
        || [strKey caseInsensitiveCompare:@"CFROM"] == NSOrderedSame
        || [strKey caseInsensitiveCompare:@"TFROM"] == NSOrderedSame
        //        || [strKey caseInsensitiveCompare:@"VERSION"] == NSOrderedSame
        || [strKey caseInsensitiveCompare:@"REQNO"] == NSOrderedSame
        || [strKey caseInsensitiveCompare:@"ZLIB"] == NSOrderedSame
        //        || [strKey caseInsensitiveCompare:@"MOBILETYPE"] == NSOrderedSame
        || [strKey caseInsensitiveCompare:@"TOKEN"] == NSOrderedSame
        )
    {
        return TRUE;
    }
    return FALSE;
}

- (id)getHTTPJYLoginInfo:(int)nTokenType;
{
#ifndef tzt_NoTrade
    id idReturn = [tztJYLoginInfo GetCurJYLoginInfo:nTokenType];
    
    //返回
    if (idReturn == nil)
    {
        NSString* strPath = GetPathWithListName(@"tztLoginFlag", TRUE);
        NSString* strLoginFlag = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
        
        int nLoginFlag = -1;
        if (strLoginFlag && strLoginFlag.length > 0)
        {
            nLoginFlag = [strLoginFlag intValue];
        }
        if (nLoginFlag <= 0)
            return NULL;
        idReturn = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountCommLoginType];
    }
    return idReturn;
#else
    return nil;
#endif
}

- (BOOL) setlocalValueExten:(NSMutableDictionary*)dictValue
{
    NSArray *aykey = [dictValue allKeys];
    
    NSString* nsKey = @"";
    NSString* nsValue = @"";
    for (int i = 0; i < [aykey count]; i++)
    {
        nsKey = [aykey objectAtIndex:i];
        if (nsKey == NULL || nsKey.length < 1)
            continue;
        
        if ([nsKey caseInsensitiveCompare:@"savesharesetting"] == NSOrderedSame)
        {
            nsValue = [dictValue objectForKey:nsKey];
            // 0不分享 1分享 2开通炒跟    Tjf
            if (nsValue.length > 0)
            {
                //                if ([nsValue intValue] == 2)
                //                {
                //                    [[tztUserSaveDataObj getShareInstance] setUserDataValue:@"1" ForKey:tztIsChaogenRegist];
                //                }
                //                else
                //                {
                //                    [[tztUserSaveDataObj getShareInstance] setUserDataValue:nsValue ForKey:tztIsOpenChaogenShare];
                //                }
                //                g_CurUserData.bCGFenXiang = [nsValue intValue];
            }
        }
        else if([nsKey caseInsensitiveCompare:@"tztdeletejyaccount"] == NSOrderedSame)
        {
            nsValue = [dictValue objectForKey:nsKey];
            tztZJAccountInfo* pAccount = NewObjectAutoD(tztZJAccountInfo);
            [pAccount DeLAccount:nsValue];
        }
        else if ([nsKey caseInsensitiveCompare:@"tzttraderight"] == NSOrderedSame
                 || [nsKey caseInsensitiveCompare:@"tzttraderights"] == NSOrderedSame)
        {
            tztJYLoginInfo *pJyLoginInfo = [self getHTTPJYLoginInfo:TZTAccountPTType];
            if (pJyLoginInfo && pJyLoginInfo.nsRights && [pJyLoginInfo.nsRights length] > 0)
            {
                pJyLoginInfo.nsRights = nsValue;
            }
        }
        else if ([nsKey caseInsensitiveCompare:@"tztdeljyaccount"] == NSOrderedSame)
        {
            nsValue = [dictValue objectForKey:nsKey];
            dispatch_block_t block = ^{ @autoreleasepool {
                tztZJAccountInfo* pAccount = NewObjectAutoD(tztZJAccountInfo);
                [pAccount DeLAccount:nsValue];
                [TZTUIBaseVCMsg OnMsg:MENU_SYS_UserLogout wParam:(NSUInteger)nsValue lParam:0];
            }};
            if (dispatch_get_current_queue() == dispatch_get_main_queue())
                block();
            else
                dispatch_sync(dispatch_get_main_queue(), block);
        }
        else if ([nsKey caseInsensitiveCompare:@"tztdellcaccount"] == NSOrderedSame)
        {
            //tztdellcaccount=理财账号
            //删除账号
            nsValue = [dictValue objectForKey:nsKey];
            dispatch_block_t block = ^{ @autoreleasepool {
                tztZJAccountInfo* pAccount = NewObjectAutoD(tztZJAccountInfo);
                [pAccount DeLAccount:nsValue withFileName_:@"tztCustomerFile"];
                [TZTUIBaseVCMsg OnMsg:MENU_SYS_UserLogout wParam:0 lParam:0];
            }};
            if (dispatch_get_current_queue() == dispatch_get_main_queue())
                block();
            else
                dispatch_sync(dispatch_get_main_queue(), block);
            //            [tztJYLoginInfo SetLoginAllOut];
        }
        else if (([nsKey caseInsensitiveCompare:@"tztuserstocksyn"] == NSOrderedSame)
                 || ([nsKey caseInsensitiveCompare:@"tzttradestockshow"] == NSOrderedSame)
                 || ([nsKey caseInsensitiveCompare:@"tztcachesize"] == NSOrderedSame))//是否需要自选同步
        {
            nsValue = [dictValue objectForKey:nsKey];
            //            [[tztUserSaveDataObj getShareInstance] setUserDataValue:nsValue ForKey:nsKey];
        }
    }
    return TRUE;
}

- (NSString *)getlocalValueExten:(NSString*)strKey withJyLoginInfo:(id)logininfo
{
#ifndef tzt_NoTrade
    tztJYLoginInfo* pJyLoginInfo =  nil;
    if(logininfo)
        pJyLoginInfo = (tztJYLoginInfo*)logininfo;
#endif
    NSString* strValue = nil;
    
    /*第三方调用时，外部接口可自定义*/
    if ([tztHTTPData getShareInstance] && [[tztHTTPData getShareInstance] respondsToSelector:@selector(getlocalOtherValue:withJyLoginInfo:)])
    {
        strValue = [[tztHTTPData getShareInstance] tztperformSelector:@"getlocalOtherValue:withJyLoginInfo:" withObject:strKey withObject:logininfo];
    }
    if (strValue != nil)
        return strValue;
    /*end*/
    if ([strKey caseInsensitiveCompare:@"mobilecode"] == NSOrderedSame )
    {
        strValue = [tztKeyChain load:tztLogMobile];
    }
    else if ([strKey caseInsensitiveCompare:@"tztuniqueid"] == NSOrderedSame)
    {
        strValue = [tztKeyChain load:tztUniqueID];
    }
    //强权限交易登录标示
    else if([strKey caseInsensitiveCompare:@"jyloginflag"] == NSOrderedSame)
    {
        //获取最近一次登录的交易账号,作为弱权限账号。若存在，则认为若权限已经登陆
        tztZJAccountInfo *pZJAccount = NewObjectAutoD(tztZJAccountInfo);
        [pZJAccount ReadLastSaveData:TZTAccountCommLoginType withFileName_:@"tztCustomerFile"];
        BOOL bFlag = FALSE;
        if (pZJAccount && pZJAccount.nsAccount && pZJAccount.nsAccount.length > 0)
            bFlag = TRUE;
        
        if ([TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])
            strValue = @"2";
        //        else if ([TZTUserInfoDeal IsHaveTradeLogin:Trade_CommPassLog] || bFlag)
        //            strValue = @"1";
        else
            strValue = @"0";
    }
    else if ([strKey caseInsensitiveCompare:@"tztrzrqloginflag"] == NSOrderedSame)
    {
        tztZJAccountInfo *pZJAccount = NewObjectAutoD(tztZJAccountInfo);
        [pZJAccount ReadLastSaveData:TZTAccountRZRQType withFileName_:@"tztCustomerFile"];
        BOOL bFlag = FALSE;
        if (pZJAccount && pZJAccount.nsAccount && pZJAccount.nsAccount.length > 0)
            bFlag = TRUE;
        
        if ([TZTUserInfoDeal IsHaveTradeLogin:RZRQTrade_Log])
            strValue = @"1";
        else
            strValue = @"0";
    }
    else if ([strKey caseInsensitiveCompare:@"tztnettype"] == NSOrderedSame)
    {
        TZTNetworkStatus status = [g_tztreachability currentReachabilityStatus];
        if (status == TZTReachableViaWiFi)
        {
            strValue = @"wifi";
        }
        else
        {
            if (g_nConnectType == TZTConnectHttp)
            {
                strValue = @"wap";
            }
            else
            {
                strValue = @"net";
            }
        }
    }
    else if([strKey caseInsensitiveCompare:@"surfMethod"] == NSOrderedSame)
    {
        TZTNetworkStatus status = [g_tztreachability currentReachabilityStatus];
        strValue = @"unknown";
        if (status == TZTReachableViaWiFi)
        {
            strValue = @"wifi";
        }
        else if(status == TZTReachableViaWWAN)
        {
            //            if (g_nConnectType == TZTConnectHttp)
            //            {
            //                strValue = @"wap";
            //            }
            //            else
            //            {
            strValue = @"3g";
            //            }
        }
    }
    else if ( [strKey caseInsensitiveCompare:@"localversion"] == NSOrderedSame )
    {
        strValue = tzt_Inner_Version;
    }
    else if([strKey caseInsensitiveCompare:@"softversion"] == NSOrderedSame)
    {
        strValue = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    else if ( [strKey caseInsensitiveCompare:@"appname"] == NSOrderedSame )
    {
        if (g_pSystermConfig && g_pSystermConfig.strMainTitle && g_pSystermConfig.strMainTitle.length > 0)
            strValue = g_pSystermConfig.strMainTitle;
    }
    else if ( [strKey compare:@"stockcode" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        strValue = @"600000";
    }
    else if ( [strKey compare:@"stockname" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        strValue = @"浦发银行";
    }
    else if ( [strKey caseInsensitiveCompare:@"checkkey"] == NSOrderedSame )
    {
        if ([tztUserData getShareClass].nsCheckKEY)
            strValue = [tztUserData getShareClass].nsCheckKEY;
    }
    else if( [strKey caseInsensitiveCompare:@"cfrom"] == NSOrderedSame ||
            [strKey caseInsensitiveCompare:@"from"] == NSOrderedSame )
    {
        if (g_pSystermConfig && g_pSystermConfig.strSysFrom && g_pSystermConfig.strSysFrom.length > 0)
            strValue = g_pSystermConfig.strSysFrom;
    }
    else if( [strKey caseInsensitiveCompare:@"tfrom"] == NSOrderedSame)
    {
#ifdef tzt_TFrom
        strValue = tzt_TFrom;
#else
#if TARGET_OS_IPHONE
        strValue  = (IS_TZTIPAD ? @"ipad":@"iphone");
#else
        strValue = @"mac";
#endif
#endif
    }
    else if ( [strKey caseInsensitiveCompare:@"upversion"] == NSOrderedSame )
    {
        strValue = g_nsUpVersion;
    }
    else if ( [strKey caseInsensitiveCompare:@"selfstocklist"] == NSOrderedSame )
    {
        strValue = [tztUserStock GetNSUserStock];
    }
    else if( [strKey caseInsensitiveCompare:@"jyaccountlist"] == NSOrderedSame)
    {
        strValue = [tztZJAccountInfo GetWebAccountList];
    }
    else if( [strKey caseInsensitiveCompare:@"tztgpsx"] == NSOrderedSame)
    {
        if([tztNSLocation getShareClass].bGetOk)
        {
            strValue = [tztNSLocation getShareClass].strGpsX;
        }
        else
        {
            strValue = @"";
        }
    }
    else if( [strKey caseInsensitiveCompare:@"tztgpsy"] == NSOrderedSame)
    {
        if([tztNSLocation getShareClass].bGetOk)
        {
            strValue = [tztNSLocation getShareClass].strGpsY;
        }
        else
        {
            strValue = @"";
        }
    }
#ifndef tzt_NoTrade
    else if ([strKey caseInsensitiveCompare:@"tztpid"] == NSOrderedSame)
    {
        if(pJyLoginInfo && pJyLoginInfo.ZjAccountInfo)
        {
            tztZJAccountInfo *pCurZJ = pJyLoginInfo.ZjAccountInfo;
            if (pCurZJ && pCurZJ.nsAccount && [pCurZJ.nsAccount length] > 0)
            {
                NSString* str = [NSString stringWithFormat:@"%@-%@", tztPID, pCurZJ.nsAccount];
                strValue = [tztKeyChain load:str];
            }
        }
    }
    else if ( [strKey caseInsensitiveCompare:@"account"] == NSOrderedSame )
    {
        if(pJyLoginInfo && pJyLoginInfo.ZjAccountInfo)
        {
            tztZJAccountInfo *pCurZJ = pJyLoginInfo.ZjAccountInfo;
            if (pCurZJ && pCurZJ.nsAccount && [pCurZJ.nsAccount length] > 0)
            {
                strValue = pCurZJ.nsAccount;
            }
        }
    }
    else if ([strKey caseInsensitiveCompare:@"tztcurlcaccount"] == NSOrderedSame)
    {
        if (pJyLoginInfo && pJyLoginInfo.ZjAccountInfo)
        {
            tztZJAccountInfo *pCurZJ = pJyLoginInfo.ZjAccountInfo;
            BOOL bFlag = FALSE;
            if ([TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])
                bFlag = TRUE;
            if (bFlag)
            {
                if (pCurZJ && pCurZJ.nsAccount && [pCurZJ.nsAccount length] > 0)
                {
                    strValue = pCurZJ.nsAccount;
                }
            }
        }
    }
    else if ( [strKey caseInsensitiveCompare:@"accounttype"] == NSOrderedSame )
    {
        if(pJyLoginInfo && pJyLoginInfo.ZjAccountInfo)
        {
            tztZJAccountInfo *pCurZJ = pJyLoginInfo.ZjAccountInfo;
            if (pCurZJ && pCurZJ.nsAccount && [pCurZJ.nsAccount length] > 0)
            {
                if (pCurZJ.nsAccountType)
                    strValue = pCurZJ.nsAccountType;
            }
        }
    }
    else if ( [strKey caseInsensitiveCompare:@"yybcode"] == NSOrderedSame )
    {
        if(pJyLoginInfo && pJyLoginInfo.ZjAccountInfo)
        {
            tztZJAccountInfo *pCurZJ = pJyLoginInfo.ZjAccountInfo;
            if (pCurZJ && pCurZJ.nsAccount && [pCurZJ.nsAccount length] > 0)
            {
                if (pCurZJ.nsCellIndex)
                    strValue = pCurZJ.nsCellIndex;
            }
        }
    }
    else if ( [strKey caseInsensitiveCompare:@"cellindex"] == NSOrderedSame )
    {
        if(pJyLoginInfo && pJyLoginInfo.ZjAccountInfo)
        {
            tztZJAccountInfo *pCurZJ = pJyLoginInfo.ZjAccountInfo;
            if (pCurZJ && pCurZJ.nsAccount && [pCurZJ.nsAccount length] > 0)
            {
                if (pCurZJ.nsCellIndex)
                    strValue = pCurZJ.nsCellIndex;
            }
        }
    }
    else if ([strKey caseInsensitiveCompare:@"yyb"] == NSOrderedSame )
    {
        if(pJyLoginInfo && pJyLoginInfo.ZjAccountInfo)
        {
            tztZJAccountInfo *pCurZJ = pJyLoginInfo.ZjAccountInfo;
            if (pCurZJ && pCurZJ.nsAccount && [pCurZJ.nsAccount length] > 0)
            {
                if (pCurZJ.nsCellIndex)
                    strValue = pCurZJ.nsCellIndex;
            }
        }
    }
    else if ( [strKey caseInsensitiveCompare:@"password"] == NSOrderedSame )
    {
        if (pJyLoginInfo && pJyLoginInfo.nsPassword && [pJyLoginInfo.nsPassword length] > 0)
        {
            strValue = pJyLoginInfo.nsPassword;
        }
    }
    else if ( [strKey caseInsensitiveCompare:@"fund_account"] == NSOrderedSame )
    {
        if (pJyLoginInfo && pJyLoginInfo.nsFundAccount && [pJyLoginInfo.nsFundAccount length] > 0)
        {
            strValue = pJyLoginInfo.nsFundAccount;
        }
    }
    else if ( [strKey caseInsensitiveCompare:@"token"] == NSOrderedSame )
    {
        if (pJyLoginInfo)
        {
            strValue = [[tztUserData getShareClass] getAccountTokenOfKind:pJyLoginInfo.tokenType tokenIndex:pJyLoginInfo.tokenIndex];
        }
    }
    else if ( [strKey caseInsensitiveCompare:@"usercode"] == NSOrderedSame )
    {
        if (pJyLoginInfo && pJyLoginInfo.nsUserCode && [pJyLoginInfo.nsUserCode length] > 0)
        {
            strValue = pJyLoginInfo.nsUserCode;
        }
    }
    else if ( [strKey compare:@"khbranch" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        if (pJyLoginInfo && pJyLoginInfo.nsKHBranch && [pJyLoginInfo.nsKHBranch length] > 0)
        {
            strValue = pJyLoginInfo.nsKHBranch;
        }
    }
    else if ( [strKey compare:@"oskey" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        if (pJyLoginInfo && pJyLoginInfo.nsOsKey && [pJyLoginInfo.nsOsKey length] > 0)
        {
            strValue = pJyLoginInfo.nsOsKey;
        }
    } //华西证券oskey参数
    else if ( [strKey compare:@"username" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        if (pJyLoginInfo && pJyLoginInfo.nsUserName && [pJyLoginInfo.nsUserName length] > 0)
        {
            strValue = pJyLoginInfo.nsUserName;
        }
    }//lastnetaddr
    else if ( [strKey compare:@"lastnetaddr" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        if (pJyLoginInfo && pJyLoginInfo.nsLastAddr && [pJyLoginInfo.nsLastAddr length] > 0)
        {
            strValue = pJyLoginInfo.nsLastAddr;
        }
    }
    //显示皮肤//0或空，默认 1-蓝白 2-红白
    else if ( [strKey caseInsensitiveCompare:@"tztskintype"] == NSOrderedSame)
    {
        strValue = [NSString stringWithFormat:@"%d", g_nSkinType];
    }
    //获取交易账号列表
    else if ([strKey caseInsensitiveCompare:@"tztjyaccountlist"] == NSOrderedSame)
    {
        //获取保存的所有账号
        strValue = [tztZJAccountInfo GetWebAccountList];
    }
    else if ([strKey caseInsensitiveCompare:@"tztlcaccountlist"] == NSOrderedSame)
    {
        //账号=姓名|账号登录类型(0；1：自动登录)。账号之间用|分隔，账号信息之间用;分隔
        NSMutableArray *ayAccount = NewObjectAutoD(NSMutableArray);
        [tztZJAccountInfo ReadAccountInfo:@"tztCustomerFile" withAy_:ayAccount];
        NSString * strList = @"";
        for (int i = 0; i < [ayAccount count]; i++)
        {
            tztZJAccountInfo *pZJAccount = [ayAccount objectAtIndex:i];
            if (pZJAccount == NULL || pZJAccount.nsAccount == NULL || pZJAccount.nsAccount.length < 1)
                continue;
            NSString* strAccount = pZJAccount.nsAccount;
            NSString* strName = pZJAccount.nsAccountName;
            if (strName == NULL || strName.length < 1)
                strName = @"";
            
            if (i == 0)
                strList = [NSString stringWithFormat:@"%@=%@;%@|",strAccount, strName, [NSString stringWithFormat:@"%ld",(long)pZJAccount.nAutoLogin]];
            else
                strList = [NSString stringWithFormat:@"%@%@=%@;%@|",strList, strAccount, strName, [NSString stringWithFormat:@"%ld",(long)pZJAccount.nAutoLogin]];
        }
        strValue = strList;
    }
    else if ([strKey caseInsensitiveCompare:@"tzttraderights"] == NSOrderedSame)
    {
        if (pJyLoginInfo && pJyLoginInfo.nsRights && [pJyLoginInfo.nsRights length] > 0)
        {
            strValue = pJyLoginInfo.nsRights;
        }
    }
    else if ([strKey caseInsensitiveCompare:@"tztrzrqright"] == NSOrderedSame)
    {
        NSString* strRight = @"0";
        if ([tztJYLoginInfo getcreditfund] == 1)
        {
            strRight = @"1";
            //只有有融资融券的权限，才会有转融通权限
            if ([tztJYLoginInfo getZRTRight])
                strRight = @"2";
        }
        return strRight;
        //        return (([tztJYLoginInfo getcreditfund] == 1) ? @"1" : @"0");
    }
    else if([strKey caseInsensitiveCompare:@"tztsysnodeid"] == NSOrderedSame)
    {
        //wry
        //        if (pJyLoginInfo && pJyLoginInfo.nsSysNodeID.length > 0)
        //            strValue = pJyLoginInfo.nsSysNodeID;
    }
#endif
    else if ([strKey caseInsensitiveCompare:@"tztbadgenumber"] == NSOrderedSame)
    {
        strValue = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
    }
    else if ([strKey caseInsensitiveCompare:@"tztuserstocksyn"] == NSOrderedSame)//是否需要自选同步
    {
        NSString* strStockSyn = [[NSUserDefaults standardUserDefaults] stringForKey:@"tztuserstocksyn"];
        if (strStockSyn.length <= 0)
            strValue = @"0";
        else
            strValue = strStockSyn;
    }
    else if ([strKey caseInsensitiveCompare:@"tzttradestockshow"] == NSOrderedSame)//是否需要显示持仓
    {
        NSString* strStockSyn = [[NSUserDefaults standardUserDefaults] stringForKey:@"tzttradestockshow"];
        if (strStockSyn.length <= 0)
            strValue = @"0";
        else
            strValue = strStockSyn;
    }
    else if ([strKey caseInsensitiveCompare:@"tztcachesize"] == NSOrderedSame)//缓存数量
    {
        CGFloat fSize = [NSString getHTTPRootFloderSize];
        strValue = [NSString stringWithFormat:@"%.2f", fSize];
    }
#ifdef Support_GJKHHTTPData
    
#if defined(__GNUC__) && !TARGET_IPHONE_SIMULATOR && ( defined(__APPLE_CPP__) || defined(__APPLE_CC__) || defined(__MACOS_CLASSIC__) )
    
    else if ([strKey caseInsensitiveCompare:@"tztudid"] == NSOrderedSame)
    {
        NSString* strMob = [[[tztHTTPData getShareInstance] getMapValue] tztValueForKey:@"MobileNo"];
        if(strMob == nil)
            strMob = @"";
        NSString* strIP = [[tztHTTPData getShareInstance] getlocalValue:@"deviceIPAdress"];
        if(strIP == nil || strIP.length <= 0)
        {
            strIP = deviceIPAdress();
            [[tztHTTPData getShareInstance] setlocalValue:@"deviceIPAdress" withValue:strIP];
        }
        if ([tztkhAppSetting getShareInstance].strTerminal && [[tztkhAppSetting getShareInstance].strTerminal length] > 0)
        {
            strValue = [NSString stringWithFormat:@"%@;%@;%@;;;",[tztkhAppSetting getShareInstance].strTerminal,strMob,strIP];
        }else
        {
            strValue = [NSString stringWithFormat:@"ZAI;%@;%@;;;",strMob,strIP];
        }
    }
#endif
#endif
    else
    {
#ifndef tzt_NoTrade
        for (NSString* strKeyTemp in pJyLoginInfo.dictLoginInfo.allKeys)
        {
            if ([strKey caseInsensitiveCompare:strKeyTemp] == NSOrderedSame)
            {
                strValue = [pJyLoginInfo.dictLoginInfo objectForKey:strKeyTemp];
                break;
            }
        }
#endif
    }
    
    if(strValue == nil)
        return nil;
    return [[[NSString alloc] initWithString:strValue] autorelease];
}

@end


@implementation TZTServerListDeal (tztBaseExten)
- (void)setSysConfigServerAdd
{
    [TZTCSystermConfig initShareClass];
    return;
    [self SetLocList:g_pSystermConfig.strDefWAPURL];
    [self SetJYAddress:g_pSystermConfig.strDefURLSTR];
    //
    NSString* strHQAddr = [g_pSystermConfig.pDict tztObjectForKey:@"HQURL"];
    if (strHQAddr.length > 0)
        [self SetHQAddress:strHQAddr];
    else
        [self SetHQAddress:g_pSystermConfig.strDefURLSTR];
    [self SetRZAddress:g_pSystermConfig.strDefURLSTR];
    [self SetZXAddress:g_pSystermConfig.strDefURLSTR];
    
    //    if (g_nOpenAccountType == 1 )//若开户使用单独通道，指定开户地址，否则使用默认
    {
        [self SetKHAddress:g_pSystermConfig.strKHURL];
    }
}

- (void)setSysConfigServerPort
{
    [TZTCSystermConfig initShareClass];
    int nPortHQ = tztAppStringInt(tztappstringserver, @"tztserver_port_0", g_pSystermConfig.nHQServerPort);
    int nPortJY = tztAppStringInt(tztappstringserver, @"tztserver_port_1", g_pSystermConfig.nJYServerPort);
    int nPortZX = tztAppStringInt(tztappstringserver, @"tztserver_port_2", g_pSystermConfig.nZXServerPort);
    int nPortJH = tztAppStringInt(tztappstringserver, @"tztserver_port_3", g_pSystermConfig.tztJHPort);
    
    [self SetJYPort:nPortJY];
    [self SetHQPort:nPortHQ];
    [self SetZXPort:nPortZX];
    [self SetPortInfo:tztSession_ExchangeJH port:nPortJH];
    
    //    if (g_nOpenAccountType == 1)
    {
        int nPortKH = tztAppStringInt(tztappstringserver, @"tztserver_port_5", g_pSystermConfig.nKHServerPort);
        [self SetKHPort:nPortKH];
    }
}

- (void)setSysConfigJHServerAdd
{
    [TZTCSystermConfig initShareClass];
    return;
    [self SetTztJHServer:g_pSystermConfig.tztJHServer];
}
@end