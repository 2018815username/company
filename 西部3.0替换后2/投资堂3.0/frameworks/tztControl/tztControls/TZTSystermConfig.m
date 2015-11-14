/*************************************************************
 *	Copyright (c)2009, 杭州中焯信息技术有限公司
 *	All rights reserved.
 *
 *	文件名称：	TZTCSystermConfig.m
 *	文件标识：	
 *	摘	  要：	系统配置
 *
 *	当前版本：	2.0
 *	作	  者：	
 *	更新日期：	
 *
 ***************************************************************/
#import "TZTSystermConfig.h"


extern const char*	 g_szHQAddr;
extern int			 g_nHQPort;
extern const char*	 g_szJYAddr;
extern int			 g_nJYPort;
NSString *           g_nsInnVer = @"";

TZTCSystermConfig* g_pSystermConfig = NULL;

@implementation TZTCSystermConfig

@synthesize pDict = _pDict;
@synthesize strMainTitle = _strMainTitle;        // 标题文本(与公司有关的，比如：投资堂)
@synthesize strCompanyName = _strCompanyName;      // 显示公司名字
@synthesize strSysFrom = _strSysFrom;		   //合作商from

//dsw 九宫格背景色
@synthesize clNineCellBG = _clNineCellBG;

@synthesize bAddJYAccount = _bAddJYAccount;       // 添加交易用户是否提示风险提示
@synthesize bShowDuty = _bShowDuty;			// 是否显示免责条款

@synthesize bJYLoadMaskCode = _bJYLoadMaskCode;      //交易登录使用校验码
@synthesize nFlashSubmit = _nFlashSubmit;		// 闪电下单
//dsw 合并m_nFixedYYB，华泰采用固定营业部，南京虽然也是集中交易，营业部是需要下载的。
@synthesize cJiZhongJY = _cJiZhongJY;           //如华泰一样集中交易，不分营业部 
@synthesize sYYBCode = _sYYBCode;    //营业部号码
@synthesize sRZRQYYBCode = _sRZRQYYBCode;//融资融券营业部号
@synthesize strRegAction = _strRegAction;  //注册功能号
@synthesize strLoginAction = _strLoginAction;  //登录功能号 

//by dsw 2009.07.09 增加软件配置
@synthesize strDefWAPURL = _strDefWAPURL;         //默认wap连接地址
@synthesize strDefURLSTR = _strDefURLSTR;         //默认开始地址
@synthesize strKHURL     = _strKHURL;
@synthesize nJYServerPort = _nJYServerPort;      //默认交易端口"7778"
@synthesize nHQServerPort = _nHQServerPort;      //默认行情端口"8001"
@synthesize nZXServerPort = _nZXServerPort;      //默认资讯端口"7778"
@synthesize nKHServerPort = _nKHServerPort;      //默认开户端口

@synthesize cLocalPhoneInfo = _cLocalPhoneInfo;      //默认客户服务电话号码和提示，南京从服务器读取
@synthesize pPhoneArray = _pPhoneArray;

@synthesize strAboutSoftName = _strAboutSoftName;     //关于中软件名称
@synthesize strAboutCopyright = _strAboutCopyright;    //关于中软件版权说明
@synthesize strMZTK = _strMZTK;//免责条款
@synthesize strfxts = _strfxts; //风险提示
@synthesize bNeedRegist = _bNeedRegist;
@synthesize bOpenAutoRegist = _bOpenAutoRegist;
@synthesize strRegistTips = _strRegistTips;
@synthesize strRegistHelp = _strRegistHelp;
@synthesize nOpenReportSplit = _nOpenReportSplit;
@synthesize nJycreditfund = _nJycreditfund; 
@synthesize nShowSysBlock = _nShowSysBlock;
@synthesize bJHOpen = _bJHOpen;
@synthesize tztiniturl = _tztiniturl;
@synthesize tztZXYWWebURL = _tztZXYWWebURL;
@synthesize tztJHPort = _tztJHPort;
@synthesize tztJHServer = _tztJHServer;
@synthesize biPadPureBg =  _biPadPureBg;
@synthesize bRZRQHZLogin = _bRZRQHZLogin;
@synthesize bSupportTBF10 = _bSupportTBF10;
@synthesize bNSupportInfoMine = _bNSupportInfoMine;
@synthesize bShowbottomTool = _bShowbottomTool;
@synthesize bOldDFCGPWShow = _bOldDFCGPWShow;
@synthesize bJJDTWithoutModify = _bJJDTWithoutModify;
@synthesize nsFundCode = _nsFundCode;
@synthesize nsFundGSDM = _nsFundGSDM;
@synthesize bUserStockNeedLogin = _bUserStockNeedLogin;
@synthesize bRegistSucToDownload = _bRegistSucToDownload;
@synthesize bSupportChangeFundPW = _bSupportChangeFundPW;//add
@synthesize bSupportChangeTXPW = _bSupportChangeTXPW;
@synthesize bZXYWisWeb = _bZXYWisWeb;
@synthesize bGPAndZJ = _bGPAndZJ;
@synthesize nToolBarHeight = _nToolBarHeight;
@synthesize nDefaultIndex = _nDefaultIndex;
@synthesize bFenShiSupportTrade = _bFenShiSupportTrade;
@synthesize bSBSpecialPriceType = _bSBSpecialPriceType;
@synthesize nsHelpTipsUrl = _nsHelpTipsUrl;
@synthesize bSelectFirstRow = _bSelectFirstRow;
@synthesize bKMKMNormal = _bKMKMNormal;
@synthesize bBuySellWithTrend = _bBuySellWithTrend;
@synthesize bNSearchFunc;
@synthesize bNSearchFuncJY;
@synthesize bSelectJYTabbar = _bSelectJYTabbar;
@synthesize bTransType2Content = _bTransType2Content;
@synthesize bHiddenOtherTool = _bHiddenOtherTool;
@synthesize rzrqDRLS = _rzrqDRLS;
@synthesize nSecLength = _nSecLength;
@synthesize nsOrderIconString = _nsOrderIconString;
-(id) init
{
    self = [super init];
    if (nil != self)
    {
        [self CSystermConfig_];
    }
    
    return self;
}

+(void)initShareClass
{
    if(g_pSystermConfig == nil)
    {
        g_pSystermConfig = NewObject(TZTCSystermConfig);
    }
}

+(void)freeShareClass
{
    if(g_pSystermConfig)
        DelObject(g_pSystermConfig);
}

+(TZTCSystermConfig*)getShareClass
{
    [TZTCSystermConfig initShareClass];
    return g_pSystermConfig;
}

-(void) dealloc
{   
    [self _CSystermConfig];
    [super dealloc];
}

-(void) CSystermConfig_
{
    [self _CSystermConfig];
//    [self InitPath:@"tztSystermSetting"];
        [self InitPath:@"tztSystermSetting_debug"];
}

-(void) _CSystermConfig
{
    NilObject(self.strMainTitle);
    NilObject(self.strCompanyName);
    NilObject(self.strSysFrom);
    NilObject(self.sYYBCode);
    NilObject(self.strRegAction);
    NilObject(self.strLoginAction);
    NilObject(self.strDefWAPURL);
    NilObject(self.strDefURLSTR);
    NilObject(self.strKHURL);
    NilObject(self.strMZTK);
    NilObject(self.strAboutSoftName);
    NilObject(self.strAboutCopyright);
    NilObject(self.pPhoneArray);
    NilObject(self.strRegistTips);
    NilObject(self.strRegistHelp);
    
    NilObject(self.tztJHServer); //均衡服务器
    NilObject(self.tztiniturl);
    NilObject(self.tztZXYWWebURL);
    NilObject(self.pDict);
    NilObject(self.nsHelpTipsUrl);
    
    self.nJYServerPort= 0;
	self.nHQServerPort= 0;
    self.nZXServerPort = 0;
    self.nKHServerPort = 0;
 //这是默认起始页面
    _nDefaultIndex = 0;
#ifdef kSUPPORT_FIRST
    _nDefaultIndex = 1;
#endif
    _nJycreditfund = 0;
	_tztJHPort = 0;      //均衡服务器端口
	_bJHOpen = 0;        //是否启用均衡
    _bRZRQHZLogin = TRUE;//
    _bSupportTBF10 = FALSE;//
    _bNSupportInfoMine = FALSE; // 是否不支持信息地雷 byDBQ20130805
    _bShowbottomTool = TRUE;
    _bOldDFCGPWShow = FALSE;
    _bJJDTWithoutModify = FALSE;
    _bSupportChangeFundPW = TRUE;
    _bSupportChangeTXPW = FALSE;
    _bZXYWisWeb = NO;
    _bGPAndZJ = NO;
    _nToolBarHeight = 0;
    _bKMKMNormal = NO;
    _bHiddenOtherTool = NO;
    _nSecLength = 0;
    self.nsOrderIconString = @"⋮";
}

-(void) InitPath:(NSString*)strFileName
{
    if (strFileName == NULL || [strFileName length] < 1)
        return;
    
	static char cInit = 0;
	if (cInit && self.pDict != nil)
		return;
	cInit = 1;
    //读取配置的xml文件
//    NSMutableDictionary * dictconf = GetDictByListName(@"tztSystermSetting");
    NSMutableDictionary * dictconf = GetDictByListName(@"tztSystermSetting_debug");
    if (dictconf == NULL)
        return;
    self.pDict = dictconf;
    self.nDefaultIndex = [[dictconf objectForKey:@"DefaultIndex"] intValue];
    self.strMainTitle = [dictconf objectForKey:@"MainTitle"];
    self.strCompanyName = [dictconf objectForKey:@"CompanyName"];
    self.strSysFrom = [dictconf objectForKey:@"CFrom"];
    if (self.strSysFrom == nil || [self.strSysFrom length] < 1)
        self.strSysFrom = @"tzt.iphone";
    NSString *strFromVer = [dictconf objectForKey:@"SysFromVer"]; //升级版本号
    if (ISNSStringValid(strFromVer))
    {
        g_nsUpVersion = [[NSString alloc] initWithFormat:@"%@", strFromVer];
    }
    else
    {
        if(g_nsUpVersion == NULL || g_nsUpVersion.length <= 0)
        {
            g_nsUpVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        }
    }
    _clNineCellBG = 0x00091023;
    
    _bAddJYAccount = 0;
    _bShowDuty = 0;
    _bJYLoadMaskCode = 0;//交易登录使用校验码
    _bAddLoginJY = 0;//添加交易账号成功就登录
    _nFlashSubmit = 0;
    //如华泰一样集中交易，不分营业部,
    //dsw 合并m_nFixedYYB，华泰采用固定营业部，南京虽然也是集中交易，营业部是需要下载的。
    _cJiZhongJY = [[dictconf objectForKey:@"JiZhongJY"] intValue];
    self.sYYBCode = [dictconf objectForKey:@"YYBCode"];
    self.sRZRQYYBCode = [dictconf objectForKey:@"RZRQYYBCode"];
    
    NSString* strRZRQHZ = [dictconf objectForKey:@"RZRQHZLogin"];
    if (strRZRQHZ && [strRZRQHZ length] > 0)
    {
        self.bRZRQHZLogin = [strRZRQHZ boolValue];
    }
    
    NSString* striPadPureBg = [dictconf objectForKey:@"iPadPureBg"];
    if (striPadPureBg && [striPadPureBg length] > 0)
    {
        self.biPadPureBg = [striPadPureBg boolValue];
    }
    
    // 当前的注册功能号有三种，newuser，sj_getcommpw,sj_reg_msg.。
    // 1.newuser （华泰证券，实现自动注册功能，无需返回短信）
    // 2.sj_getcommpw (广州证券，国金证券，国泰君安，国联证券，实现注册，密码以短信形式发送到手机，并可以短信形式取回密码。)
    // 3.sj_reg_msg (华林证券，投资堂，实现注册，密码以短信形式发送到手机，并可以短信形式重置密码。)
	self.strRegAction = [dictconf objectForKey:@"RegAction"];  //注册功能号 
	self.strLoginAction = [dictconf objectForKey:@"LoginAction"];   //登录功能号 

    //by dsw 2009.07.09 增加软件配置
    self.strDefWAPURL = [dictconf objectForKey:@"DefWAPURL"];//默认wap连接地址
    self.strDefURLSTR = [dictconf objectForKey:@"DefURLSTR"];//默认开始地址
    self.strKHURL = [dictconf objectForKey:@"KHURL"];//默认开户地址
    _nJYServerPort = [[dictconf objectForKey:@"JYServerPort"] intValue];//默认交易端口"7778"
    NSString * strPort = [dictconf objectForKey:@"HQServerPort"];
    if (strPort.length > 0) // 中原要配置行情端口 byDBQ20130912
    {
        _nHQServerPort = [strPort intValue];//默认行情端口"8001"
    }
    else
    {
        _nHQServerPort = _nJYServerPort;
    }
    _nZXServerPort = [[dictconf objectForKey:@"ZXServerPort"] intValue];
    if (_nZXServerPort <= 0)
        _nZXServerPort = 7778;
    
    _nKHServerPort = [[dictconf objectForKey:@"KHServerPort"] intValue];
    if (_nKHServerPort <= 0)
        _nKHServerPort = 7778;
    
    _cLocalPhoneInfo = 1;      //默认客户服务电话号码和提示，南京从服务器读取
    
    NSString* strPhone = [dictconf objectForKey:@"PhoneList"];
    if (strPhone && [strPhone length] > 0)
    {
        NSArray *pAy = [strPhone componentsSeparatedByString:@"&"];
        self.pPhoneArray = NewObjectAutoD(NSMutableArray);
        [self.pPhoneArray setArray:pAy];
    }
	
    self.strAboutSoftName = [dictconf objectForKey:@"AboutSoftName"];//[m_pProfile GetFileString:"SystemSetting" szItem:"AboutSoftName" szValue:"当前版本[-sysver-]"];     //关于中软件名称
    self.strAboutCopyright = [dictconf objectForKey:@"AboutCopyright"];   //关于中软件版权说明
    
    NSString* strSystemVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.strAboutCopyright = [self.strAboutCopyright stringByReplacingOccurrencesOfString:@"[-SysVersion-]" withString:strSystemVer];
    self.strAboutCopyright = [self.strAboutCopyright stringByReplacingOccurrencesOfString:@"[-InVersion-]" withString:g_nsInnVer.length > 0 ? g_nsInnVer : @"未指定内部版本号"];
    
    self.strMZTK = [dictconf objectForKey:@"Disclaimer"];
    self.strfxts = [dictconf objectForKey:@"fxts"];
    
    _bNeedRegist = [[dictconf objectForKey:@"NeedRegist"] intValue];//1需要激活登录， 0－无需激活登录
    _bOpenAutoRegist = [[dictconf objectForKey:@"OpenAutoRegist"] intValue];//     // 用户登录界面方式 0 通讯密码登录 1激活登录 2 湘财体验登录 3 手机号 获取激活码 4 手机号 获取激活码 激活码 激活
    
    _bUserStockNeedLogin = [[dictconf objectForKey:@"UserStockNeedLogin"] intValue];//1需要登录 0不登录
    
    _bRegistSucToDownload = [[dictconf objectForKey:@"RegistSucToDownload"] intValue];// 激活成功后是否去下载自选股  0不下载,1下载
    
    NSString* strRegistNo = [dictconf objectForKey:@"Registnumber"];
    if(strRegistNo == nil)
    {
        strRegistNo = @"106901601050";
        [dictconf setObject:strRegistNo forKey:@"Registnumber"];
    }
    
    NSString* strRegistTips = [dictconf objectForKey:@"RegistTips"];
    strRegistTips = [strRegistTips stringByReplacingOccurrencesOfString:@"[-RegistNumber-]" withString:strRegistNo];
    
    self.strRegistTips  = [strRegistTips stringByReplacingOccurrencesOfString:@"[-RegistPhone-]" withString:@"未指定注册手机号"];
    
    NSString* strRegistHelp = [dictconf objectForKey:@"RegistHelp"];
    strRegistHelp = [strRegistHelp stringByReplacingOccurrencesOfString:@"[-RegistNumber-]" withString:strRegistNo];
    
    self.strRegistHelp  = [strRegistHelp stringByReplacingOccurrencesOfString:@"[-RegistPhone-]" withString:@"未指定拨打手机号"];
    
    self.tztJHServer = [dictconf objectForKey:@"tztJHServer"];//均衡服务器地址
    self.tztJHPort = [[dictconf objectForKey:@"tztJHPort"] intValue];	//均衡服务器端口
    self.bJHOpen = [[dictconf objectForKey:@"tztJHOpen"] intValue];//是否开启均衡功能
	
    if (IS_TZTIPAD)
    {
        self.tztiniturl = [dictconf objectForKey:@"tztiniturlipad"];
    }
    else
        self.tztiniturl = [dictconf objectForKey:@"tztiniturl"];
    self.tztiniturl5 = [dictconf objectForKey:@"tztiniturl5"];
    
    //帮助引导页url
    self.nsHelpTipsUrl = [dictconf objectForKey:@"tzttipsurl"];
    
    self.tztZXYWWebURL = [dictconf objectForKey:@"ZXYWWebURL"];
    _nOpenReportSplit = [[dictconf objectForKey:@"ReportSplit"] intValue]; //是否开启分屏展示报价
    
    _nShowSysBlock = [[dictconf objectForKey:@"ShowSysBlock"] intValue]; // 系统板块功能
    	
	_nJycreditfund = [[dictconf objectForKey:@"Jycreditfund"] intValue];// 融资融券功能
    
    _bSupportTBF10 = [[dictconf objectForKey:@"SupportTBF10"] boolValue];//是否支持图表f10
    _bNSupportInfoMine = [[dictconf objectForKey:@"NSupportInfoMine"] boolValue];//是否不支持信息地雷
    
    NSString* strHiddenOther = [dictconf objectForKey:@"HiddenOtherTool"];
    if (strHiddenOther && strHiddenOther.length > 0)
        _bHiddenOtherTool = [strHiddenOther boolValue];
    
    NSString* strShowTool = [dictconf objectForKey:@"ShowbottomTool"];
    if (strShowTool && strShowTool.length > 0)
        _bShowbottomTool = [strShowTool boolValue];//是否显示交易里面底部工具条
    else
        _bShowbottomTool = FALSE;
    NSString* strOldDFCGPW = [dictconf objectForKey:@"OldDFCGPWShow"];
    if (strOldDFCGPW && strOldDFCGPW.length > 0)
        _bOldDFCGPWShow = [strOldDFCGPW boolValue];//是否支持老的多存管银行密码，资金密码显示判断方式
    NSString* strJJDTWithoutModify = [dictconf objectForKey:@"JJDTWithoutModify"];
    if (strJJDTWithoutModify && strJJDTWithoutModify.length > 0)
        _bJJDTWithoutModify = [strJJDTWithoutModify boolValue]; // 基金定投不要修改功能 byDBQ20130923
    
    self.nsFundGSDM = [dictconf objectForKey:@"FundGSDM"];
    self.nsFundCode = [dictconf objectForKey:@"FundCode"];
    self.defDownColor = [dictconf objectForKey:@"DefDownColor"];
    self.sellAction = [dictconf objectForKey:@"SellAction"];
    
    _bSupportChangeFundPW = TRUE;//默认支持
    NSString* strValue = [dictconf objectForKey:@"SupportChangeFundPW"];
    if (strValue)
    {
        _bSupportChangeFundPW = [strValue boolValue];
    }
    
    _bSupportChangeTXPW = FALSE;//默认不支持
    NSString* strTXPW = [dictconf objectForKey:@"SupportChangeTXPW"];
    if (strTXPW)
    {
        _bSupportChangeTXPW = [strTXPW boolValue];
    }
    
    
    // iPad最新要闻是否是网页
    NSString* strbZXYWisWeb = [dictconf objectForKey:@"ZXYWisWeb"];
    if (strbZXYWisWeb)
    {
        _bZXYWisWeb = [strbZXYWisWeb boolValue];
    }
    
    NSString* strbGPAndZJ = [dictconf objectForKey:@"GPAndZJ"];
    if (strbGPAndZJ)
    {
        _bGPAndZJ = [strbGPAndZJ boolValue];
    }
    
    //底部ToolBarView 高度,没有配置用默认的
    _nToolBarHeight = [[dictconf objectForKey:@"ToolBarHeight"] intValue];
    
    if (_nToolBarHeight <= 0)
        _nToolBarHeight = 49;
    
    //分时界面是否支持快速买卖
    _bFenShiSupportTrade = [[dictconf objectForKey:@"FenShiSupportTrade"] intValue];//1 不支持 0支持，默认0
    _bSBSpecialPriceType = [[dictconf objectForKey:@"SBSpecialPriceType"] intValue];//1需要支持 0不支持
    
    //查询是否选中第一行 默认不选中
    _bSelectFirstRow = [[dictconf objectForKey:@"SelectFirstRow"] intValue];//1需要支持 0不支持
    
    self.bBuySellWithTrend = [[dictconf objectForKey:@"BuySellWithTrend"] intValue];
    
    self.bNSearchFunc = [[dictconf objectForKey:@"NSearchFunc"] boolValue];
    
    self.bNSearchFuncJY = [[dictconf objectForKey:@"NSearchFuncJY"] boolValue];
    //选择交易tabbar，是否需要弹出登录界面 0 不需要, 1需要
    _bSelectJYTabbar = [[dictconf objectForKey:@"SelectJYTabbar"] intValue];
    
    self.bTransType2Content = [[dictconf objectForKey:@"TransType2Content"] boolValue];
    
    self.bNStockNeedHQ = [[dictconf objectForKey:@"NStockNeedHQ"] boolValue];
    
    self.bWudangOnly = [[dictconf objectForKey:@"WudangOnly"] boolValue];
    
    self.etfWithdrawAction = [dictconf objectForKey:@"ETFWithdrawAction"];
    self.rzrqDRLS = [dictconf objectForKey:@"RZRQDRLS"];
    self.nineBackColor = [dictconf objectForKey:@"NineBackColor"];
    self.themeColor = [dictconf objectForKey:@"ThemeColor"];
    self.hasServiceTool = [dictconf objectForKey:@"HasServiceTool"];
    
    strValue = [dictconf objectForKey:@"tztShowOrderIcon"];
    if (strValue != NULL)
        self.nsOrderIconString = [NSString stringWithFormat:@"%@", strValue];
    _nSecLength = [[dictconf objectForKey:@"SecLength"] intValue];
}

- (NSArray*)ayDefaultUserStock
{
   return [_pDict objectForKey:@"tztDefaultUserStock"];
#if 0
    if(ay == nil || [ay count] <= 0 )
        return [NSString stringWithFormat:@"%@",@"1A0001,2A01"];
    
    NSString* strReturn = @"";
    for (int i = 0; i < [ay count]; i++)
    {
        NSMutableDictionary* pDict = [ay objectAtIndex:i];
        if (pDict == NULL || [pDict count] <= 0)
            continue;
        NSString* strCode = [pDict objectForKey:@"Code"];
        if(strCode == NULL || [strCode length] <= 0)
            continue;
        
        if ([strReturn length] <= 0)
        {
            strReturn = [NSString stringWithFormat:@"%@", strCode];
        }
        else
            strReturn = [NSString stringWithFormat:@"%@,%@",strReturn, strCode];
    }
    return [NSString stringWithFormat:@"%@",strReturn];
#endif
}

//判断过滤相应基金公司
-(BOOL)IsFundCompany:(NSString*)nsGSDM
{
    if (nsGSDM == NULL || nsGSDM.length < 1)
        return FALSE;
 
    if (self.nsFundGSDM == NULL || self.nsFundGSDM.length < 1)
        return TRUE;
    
    NSArray* ayCode = [self.nsFundGSDM componentsSeparatedByString:@"&"];
    BOOL bFund = FALSE;
    for (int i = 0; i < [ayCode count]; i++)
    {
        NSString* nsPre = [ayCode objectAtIndex:i];
        if (nsPre == NULL || nsPre.length < 1)
            continue;
        
        if ([nsGSDM hasPrefix:nsPre])
        {
            bFund = TRUE;
            break;
        }
    }
    return bFund;
}

//判断过滤相应基金代码
-(BOOL)IsFundCode:(NSString*)nsCode
{
    if (nsCode == NULL || nsCode.length < 1)
        return FALSE;
    
    if (self.nsFundCode == NULL || self.nsFundCode.length < 1)
        return TRUE;
    
    NSArray* ayCode = [self.nsFundCode componentsSeparatedByString:@"&"];
    BOOL bFund = FALSE;
    for (int i = 0; i < [ayCode count]; i++)
    {
        NSString* nsPre = [ayCode objectAtIndex:i];
        if (nsPre == NULL || nsPre.length < 1)
            continue;
        
        if ([nsCode hasPrefix:nsPre])
        {
            bFund = TRUE;
            break;
        }
    }
    return bFund;
}

-(NSInteger)CheckValidRow:(NSMutableArray*)ayRowData nRowIndex_:(NSInteger)nRowIndex nComIndex_:(NSInteger)nComIndex nMsgType_:(NSInteger)nMsgType bCodeCheck_:(BOOL)bCodeCheck
{
    if ( nRowIndex <= 0 || !IsNeedFilterQuest(nMsgType))
        return 1;
    
    if (ayRowData == NULL)
        return 1;
    
    if (nComIndex < 0 || nComIndex >= [ayRowData count])
        return 1;
    
    NSString* nsData = [ayRowData objectAtIndex:nComIndex];
    BOOL bIsNeedFilter = FALSE;
    
    if (bCodeCheck)
    {
        bIsNeedFilter = [self IsFundCode:nsData];
    }
    else
    {
        bIsNeedFilter = [self IsFundCompany:nsData];
    }
    
    if (nsData == NULL || [nsData length] < 1 || !bIsNeedFilter)
    {
        return 0;
    }
    
    return 1;
}

@end
