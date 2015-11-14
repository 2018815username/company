/*字体
 Marion,
 Copperplate,
 HeitiSC,
 IowanOldStyle,
 CourierNew,
 AppleSDGothicNeo,
 HeitiTC,
 GillSans,
 MarkerFelt,
 Thonburi,
 AvenirNextCondensed,
 TamilSangamMN,
 HelveticaNeue,
 GurmukhiMN,
 TimesNewRoman,
 Georgia,
 AppleColorEmoji,
 ArialRoundedMTBold,
 Kailasa,
 KohinoorDevanagari,
 SinhalaSangamMN,
 ChalkboardSE,
 Superclarendon,
 GujaratiSangamMN,
 Damascus,
 Noteworthy,
 GeezaPro,
 Avenir,
 AcademyEngravedLET,
 Mishafi,
 Futura,
 Farah,
 KannadaSangamMN,
 ArialHebrew,
 Arial,
 PartyLET,
 Chalkduster,
 HiraginoKakuGothicProN,
 HoeflerText,
 Optima,
 Palatino,
 MalayalamSangamMN,
 LaoSangamMN,
 AlNile,
 BradleyHand,
 HiraginoMinchoProN,
 TrebuchetMS,
 Helvetica,
 Courier,
 Cochin,
 DevanagariSangamMN,
 OriyaSangamMN,
 SnellRoundhand,
 ZapfDingbats,
 Bodoni72,
 Verdana,
 AmericanTypewriter,
 AvenirNext,
 Baskerville,
 KhmerSangamMN,
 Didot,
 SavoyeLET,
 BodoniOrnaments,
 Symbol,
 Menlo,
 Bodoni72Smallcaps,
 DINAlternate,
 Papyrus,
 EuphemiaUCAS,
 TeluguSangamMN,
 BanglaSangamMN,
 Zapfino,
 Bodoni72Oldstyle,
 DINCondensed
 */

#import "tztSystemdef.h"

void tztSetBasedef()
{
//    short g_ntztProtocol = 2013;//通讯协议
//    BOOL  g_btztEncode = TRUE;
//    NSString *g_nsBundlename = @"tzt_iphone";
//    
//    NSString    *g_nsJhAction = @"2"; //均衡功能 25026//测速功能(目前就华西使用)
//    NSString    *g_nsOnLineAction = @"46"; //心跳功能  20401//校验用户有效性
    g_nsInnVer = tzt_Inner_Version;
//    g_nsFontName = @"Didot";
//    g_nsFontNameBold = @"Didot-Bold";
#ifdef DEBUG
    g_tztLogLevel = TZTLOG_LEVEL_VERBOSE; //日志打印级别
#else
    g_tztLogLevel = TZTLOG_LEVEL_ERROR; //日志打印级别
#endif
 //   g_tztLogLevel = TZTLOG_LEVEL_ERROR;

    //    g_nOpenAccountType = 0;
//    
//#ifdef Support_GJKHHTTPData
//    g_nOpenAccountType = 1;
//#endif
    
    g_nSupportLeftSide = 1;
    g_nSupportRightSide = 0;
    
    g_nSkinType = 1;
    
#ifdef Support_HXSC//华西专用25026请求服务器列表
    g_nUsePNGInTableGrid = 1;
    g_nsJhAction = @"25026";
#endif
    
#ifdef tzt_GJSC
    g_nTime = 3;
    
    [tztTechSetting getInstance].nRequestTimer = 3;
    [[tztTechSetting getInstance] SaveData];
    [[tztTechSetting getInstance] setValue:@"3" forKeyPath:@"_nRequestTimer"];
    
    g_nHKShowTenPrice = 1;//显示港股
    g_nHKHasRight = 1;//默认拥有港股十档权限
    g_nWPDetailPrice = 1;//外盘显示不一样
    g_bUseHQAutoPush = 1;//使用主推
    
    g_nSkinType = 1;
#endif
    
#ifdef tzt_ZSSC
    NSString* str = [[tztUserSaveDataObj getShareInstance] getUserDataValueForKey:@"tztuserstocksyn"];
    if (str.length <= 0)
        [[tztUserSaveDataObj getShareInstance] setUserDataValue:@"1" ForKey:@"tztuserstocksyn"];
    NSString* str1= [[tztUserSaveDataObj getShareInstance] getUserDataValueForKey:@"tzttradestockshow"];
    if (str1.length <= 0)
        [[tztUserSaveDataObj getShareInstance] setUserDataValue:@"1" ForKey:@"tzttradestockshow"];
    
#endif
    
#ifdef  tzt_bundlename
    g_nsBundlename = tzt_bundlename;
#endif
    
#ifdef tzt_CheckUserLogin
    g_nsOnLineAction = @"20401";
#endif
    
#ifndef tzt2013Protocol
    g_ntztProtocol = 2011;//通讯协议
#endif

#ifdef Support_OpenUDID_for_MobileCode
    NSString* strOpenUDID = [tztOpenUDID value];
    if(validateMobile(strOpenUDID))
    {
        [tztKeyChain save:tztLogMobile data:strOpenUDID];
    }
    else
    {
        tztAfxMessageBox(@"获取标识码错误!");
    }
#else
//    [tztKeyChain save:tztLogMobile data:@""];
#endif
    
    if (IS_TZTIOS(6))
    {
#ifdef UILineBreakModeWordWrap
#undef UILineBreakModeWordWrap
#endif
#define UILineBreakModeWordWrap NSLineBreakModeWordWrap
        
    }
}

BOOL validateMobile(NSString* mobile)
{
    if(mobile == nil || [mobile length] <= 0)
        return FALSE;
#ifdef tzt_ZFXF_LOGIN
    return TRUE;
#endif
//#ifdef Support_OpenUDID_for_MobileCode
    NSString *mobileRegex = @"[A-Z0-9a-z]{11,40}";
//#else
//    NSString *mobileRegex = @"[1]{1}+[0-9]{10}";
//#endif
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}


NSString* tztdecimalNumberByDividingBy(NSString* nsValue,int nNumber)
{
    if (nsValue == NULL)
        return @"";
    if (nNumber < 0)
        nNumber = 0;
    double dValue = [nsValue doubleValue];
    
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:nsValue];
    NSDecimalNumber *multiplierNumber;
    NSString* nsUnit = @"";
    if (dValue >= 100000000)
    {
        multiplierNumber = [NSDecimalNumber decimalNumberWithString:@"100000000"];
        nsUnit = @"亿";
    }
    else if(dValue >= 10000 * 1000)
    {
        multiplierNumber = [NSDecimalNumber decimalNumberWithString:@"10000"];
        nsUnit = @"万";
    }
    else if (dValue > 100000)
    {
        multiplierNumber = [NSDecimalNumber decimalNumberWithString:@"10000"];
        nsUnit = @"万";
    }
    else
    {
        return nsValue;
    }
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByDividingBy:multiplierNumber];
    NSString* strNew = [product stringValue];
    
    NSString* strValueReturn = @"";
    
    NSRange range = [strNew rangeOfString:@"."];
    
    if (range.location > 0 && range.location < [strNew length])
    {
        NSString *strFirst = [strNew substringToIndex:range.location];
        NSString *strSecond = [strNew substringFromIndex:range.location+1];
        
        if (strSecond.length < nNumber)
        {
            for (NSInteger i = strSecond.length; i < nNumber; i++)
            {
                strSecond = [NSString stringWithFormat:@"%@0",strSecond];
            }
        }
        else
        {
            strSecond = [strSecond substringToIndex:nNumber];
        }
        if (nNumber > 0)
        {
            strValueReturn = [NSString stringWithFormat:@"%@.%@%@", strFirst, strSecond, nsUnit];
        }
        else
        {
            strValueReturn = [NSString stringWithFormat:@"%@%@", strFirst, nsUnit];
        }
    }
    else
    {
        NSString* strValid = @"";
        for (int i = 0; i < nNumber; i++)
        {
            strValid = [NSString stringWithFormat:@"%@0",strValid];
        }
        
        if (nNumber > 0)
        {
            strValueReturn = [NSString stringWithFormat:@"%@.%@%@", strNew, strValid, nsUnit];
        }
        else
            strValueReturn = [NSString stringWithFormat:@"%@%@", strNew, nsUnit];
    }
    
    return strValueReturn;
    
}

#ifdef Support_GJKHHTTPData

#if defined(__GNUC__) && !TARGET_IPHONE_SIMULATOR && ( defined(__APPLE_CPP__) || defined(__APPLE_CC__) || defined(__MACOS_CLASSIC__) )
#import <tztkhgjscSDK/IPAddress.h>
NSString* deviceIPAdress()
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    NSString* deviceIPAddress = @"";
    NSString* str = [NSString stringWithFormat:@"%s", ip_names[1]];
    NSArray* ayIP = [str componentsSeparatedByString:@"."];
    if(ayIP && [ayIP count] >= 4)
    {
        deviceIPAddress = [NSString stringWithFormat:@"%03d%03d%03d%03d",[[ayIP objectAtIndex:0] intValue],[[ayIP objectAtIndex:1] intValue],[[ayIP objectAtIndex:2] intValue],[[ayIP objectAtIndex:3] intValue]];
    }
    return deviceIPAddress;
}
#endif
#endif

int         g_nScreenWidth = 0;//[UIScreen mainScreen].bounds.size.width;
int         g_nScreenHeight = 0;//[UIScreen mainScreen].bounds.size.height;
int         g_nToolbarHeight = 0;
//int         g_nJYBackBlackColor = 1;
//int         g_nHQBackBlackColor = 1;
int         g_nThemeColor = 0; // 0 -- black, 1 -- blue, 2 -- red
NSString    *g_nsdeviceToken = NULL;
int         g_nTradeListType = 0;
NSString    *g_nsPeople = NULL;
NSString    *g_nsContact = NULL;
BOOL        g_bShowLock = FALSE;
//是否显示动态口令（涨乐理财）
BOOL        g_nHaveDtPassword = FALSE;
//记录传递进来的登录账号信息
NSMutableDictionary *g_pDictLoginInfo = NULL;

NSString* g_nsUserCardID = NULL;        //资金理财身份证号码
NSString* g_nsUserInquiryPW = NULL;     //资金理财查询密码
NSInteger           g_nJyTypeCount = 1;//交易界面中类型数量
//NSMutableArray      *g_ayTradeRights = NULL;//交易权限，没有权限的菜单需要隐藏
