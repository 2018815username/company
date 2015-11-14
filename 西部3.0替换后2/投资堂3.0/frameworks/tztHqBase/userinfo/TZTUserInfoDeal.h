/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUserInfoDeal.h
 * 文件标识：
 * 摘    要：用户信息
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期： 2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <Foundation/Foundation.h>
#define     Trade_Login             1   //登录
#define     Trade_Logout            0   //登出
#define     StockTrade_Log          0x00000001  //股票交易登录
#define     FundTrade_Log           0x00000002  //基金交易登录
#define     FuturesTrade_Log        0x00000004  //期货交易登录
#define     RZRQTrade_Log			0x00000008  //融资融券交易登录
#define     HKTrade_Log             0x00000010  //港股交易登录
#define     GGQQTrade_Log           StockTrade_Log

#define     Systerm_Log             0x00010000  //系统验证登录
#define     Systerm_LogFail         0x00020000  //系统验证登录失败
#define     TestTrade_Log           0x00040000  //体验用户登录
#define     Trade_CommPassLog       0x00080000  //弱权限登录（通讯密码登录）
//|RZRQTrade_Log 修改地址时,融资融券登录也退出 by xyt 20131025
#define     AllTrade_Log          StockTrade_Log|FundTrade_Log|FuturesTrade_Log|RZRQTrade_Log
#define     AllServer_Log         AllTrade_Log|Systerm_Log|Trade_CommPassLog

#define def_SaveAccounts @"moreAccountt.plist"//多账号登录
#define def_RecentAccounts @"RecentAccount.plist"//保存最近登录的账号信息
#define def_JYAccounts @"JYAccounts.plist"//保存交易账号信息
#define def_GGAccounts @"GGAccountt.plist"//多账号登录
#define def_GetReturnAccounts @"GetReturnAccounts.plist"//保存返回的账号

#define def_PalcePoint @"PalcePoint.plist"//营业厅地址点
#define def_jyaccount  @"jyaccount.plist"//存储交易账号

#define def_YYBlistId @"YYBlistId.plist" //保存营业部 id
#define def_customAccount @"customAccount"
#define def_nowAccount @"nowAccount"//当前交易账号

#define tztTradeAccount         @"tztTradeAccount"      //账号
#define tztTradeAccountType     @"tztTradeAccountType"  //账号类型
#define tztTradeSaveType        @"tztTradeSaveType"     //保存类型
#define tztTradeDTPassFlag      @"tztTradeDTPassFlag"   //动态口令标识

@interface tztUserData : NSObject
{
    //类型：3
    NSInteger         _nMobileType;
    //激活手机号
    NSString    *_nsMobileCode;
    //激活密码
    NSString    *_nsCheckKEY;
    //账号密码
    NSString    *_nsPassword;

    //是否注册
    NSInteger         _isRegist;
//    question 1 莫非在这里判断 是否一键登录？？
    //用户类别 默认 0 激活账号 1 账号密码方式
    NSInteger         _iUserType;
    
    //token数组，当前登录账号列表 Token列表
    NSMutableArray  *_ayAccountToken;
    
    //担保划转普通账号token
    NSString    *_nsDBPLoginToken;
    
    //是否同意免责条款
    NSInteger         _nMZTKFlag;
    //
    BOOL        _bRememberPWD;
    NSString    *_nsLockTradeTime;//交易锁定时间设置
    NSString    *_nsSecure;//账号是否加密
    BOOL        _bNeedShowLock;
    BOOL        _bCGFenXiang;//zxl 20130802 炒跟分享默认值
    NSString    *_nsGTJAXMLCrc;
}
@property(nonatomic,retain)NSString *nsMobileCode;
@property(nonatomic,retain)NSString *nsCheckKEY;
@property(nonatomic,retain)NSString *nsPassword;
@property(nonatomic,retain)NSString *nsDBPLoginToken;
@property(nonatomic,retain)NSMutableArray *ayAccountToken;
@property(nonatomic) NSInteger nMobileType;
@property(nonatomic) NSInteger isRegist;
@property(nonatomic) NSInteger iUserType;
@property(nonatomic) NSInteger nMZTKFlag;
@property(nonatomic) BOOL  bRememberPWD;
@property(nonatomic,retain)NSString *nsLockTradeTime;
@property(nonatomic,retain)NSString *nsSecure;
@property(nonatomic,retain)NSString *nsGTJAXMLCrc;
@property BOOL bNeedShowLock;
@property BOOL bCGFenXiang;
- (void)initData;
- (void)reSetUserData;
-(void)clearAllSaveAccount;
//清空某账号类型的token
- (void)delAccountToken:(NSInteger)nTokenKind;
//设置Token 对应 账号类别 tokenIndex
- (void)setAccountToken:(NSString*)strToken tokenKind:(NSInteger)nTokenKind tokenIndex:(NSInteger)nTokenIndex;
//获取Token 对应账号类型 tokenIndex
- (NSString*)getAccountTokenOfKind:(NSInteger)nTokenKind tokenIndex:(NSInteger)nTokenIndex;
//获取Token空余的TokenIndex
- (int)getCanUseTokenOfKind:(NSInteger)nTokenKind;

//初始化系统登录状态
+(void)initShareClass;
//释放生成的数据
+(void)freeShareClass;
+(tztUserData*)getShareClass;
@end

@interface TZTUserInfoDeal : NSObject
//---------------静态函数-------------
//====读写配置文件，系统登录相关====
//读取或者保存系统登录账号
+(BOOL) SaveAndLoadLogin:(BOOL)bLoadLogin nFlag_:(int)nFlag;
//读取或者保存系统登录账号
+(BOOL) SaveAndLoadLoginAccount:(BOOL)bLoadLogin nFlag_:(int)nFlag strAccount_:(NSString*)strAccount;
//====读写配置文件，系统登录相关====
//是否交易已经登录
+(BOOL) IsTradeLogin:(long)lLoginType;
//设置交易登录状态
+(void) SetTradeLogState:(char)IsLogin lLoginType_:(long)lLoginType;
+(void) SetTradeLogState:(char)IsLogin lLoginType_:(long)lLoginType withNotifi:(BOOL)bSend;
//设置港股交易登录状态
//+(void) SetGGTradeLogState:(char)IsLogin lLoginType_:(long)lLoginType;
//是否存在登录
+(BOOL) IsHaveTradeLogin:(long)lLoginType;
//for save ip servers +++

//+++读写手动输入账号列表
+(NSInteger) SaveAddLoadJYAccountList:(BOOL)bSave ayList:(NSMutableArray*)ayList;

//====合并两个字符串数组
//+(BOOL)MargenStringArray:(NSMutableArray*)ayFirst Sencond:(NSMutableArray*)aySecond NewAy:(NSMutableArray *)ayNew;
//
//+(BOOL)MargenBufferArray:(NSMutableArray*)ayFirst Sencond:(NSMutableArray*)aySecond NewAy:(NSMutableArray *)ayNew;
////====合并两个字符串数组
//+(int) FindStringByArray:(NSMutableArray*)ayList string:(NSString*)nsString;
//+(int) FindBufferByArray:(NSMutableArray*)ayList string:(NSString*)nsString;

+(void) SetLoginState:(int)LoginState;
+(int) GetLoginState;

+(int) SaveAndLoadJYAccountList:(BOOL)bSave;
@end
//当前用户的数据信息
extern tztUserData *g_CurUserData;
extern unsigned long   g_nJYLoginFlag;
