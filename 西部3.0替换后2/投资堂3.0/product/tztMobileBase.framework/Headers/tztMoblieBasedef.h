/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztSystemdef.h
 * 文件标识：
 * 摘    要：系统宏定义
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 *          1、整理修改，增加6，6p等的宏定义开关
            2、整理取消不使用、重复的宏定义
 *******************************************************************************/

#import <Foundation/Foundation.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#include <ctype.h>

// tolower
#include <stdlib.h>
// free

#include <stdio.h>
// sprintf

#include <memory.h>
// memset

#include <string.h>
// strcpy

#include <math.h>
// fabs
// pow
// sqrt
#include <time.h>
#include <stdarg.h>
#pragma mark -宏定义
/** GBK编码
 */
#define NSStringEncodingGBK 0x80000632
//2013协议标识
#define tztProtocol2013 2013
//使用SSL
//#define TZT_OPENSSL
#ifdef TZT_OPENSSL  //启用 OpenSLL 需要openssl动态库
#undef TZT_OPENSSL
#endif

#pragma mark -屏幕设备相关
//取设备屏幕宽度
#define TZTScreenWidth [[UIScreen mainScreen] bounds].size.width
//取设备屏幕高度
#define TZTScreenHeight [[UIScreen mainScreen] bounds].size.height
//导航栏高度
#define TZTNavbarHeight 44
//状态栏高度
#define TZTStatuBarHeight 20
//底部工具栏高度
#define TZTToolBarHeight 44
//不带底部工具栏界面表格的最大显示高度
#define TZTValidHeightNoToolBar (TZTScreenHeight - TZTStatuBarHeight - TZTNavbarHeight)
//带底部工具栏界面表格的最大显示高度
#define TZTValidHeightWithToolBar (TZTScreenHeight - TZTStatuBarHeight - TZTNavbarHeight - TZTToolBarHeight)

#if TARGET_OS_IPHONE

//IPAD判断标识
#define IS_TZTIPAD  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//模拟器判断标识
#define IS_TZTSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
//iOS版本判断
#define IS_TZTIOS(x) ([[UIDevice currentDevice].systemVersion intValue] >= x)
//iPhone4/4s判断
#define IS_TZTIphone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] bounds].size) : NO)

//iPhone5判断
#define IS_TZTIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhone6判断
#define IS_TZTIphone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size) : NO)
//iPhone6Plus判断
#define IS_TZTIphone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(414, 736), [UIScreen mainScreen].bounds.size)) : NO)
//CGSizeEqualToSize(CGSizeMake(375, 667), [UIScreen mainScreen].bounds.size) ||
#else

#define IS_TZTIPAD NO
#define IS_TZTSimulator NO
#define IS_TZTIOS(x) NO
#define IS_TZTIphone5 NO

#endif

//iPhone6p额外高度增加，用于适配
#define tzt_iphone6_6p_exheight (((IS_TZTIphone6P || IS_TZTIphone6) ? 10 : 0))
//iPhone6p字体统一放大，用于适配
#define tzt_iphone6_6p_exfontsize (((IS_TZTIphone6P || IS_TZTIphone6) ? .5f : 0))


#pragma mark -内存，对象创建相关
//自动释放池
#define	BegAutoReleaseObj()	NSAutoreleasePool* autoPool = NewObject(NSAutoreleasePool)
#define	EndAutoReleaseObj()	DelObject(autoPool)

//创建Obj对象
#define NewObject(x) [[x alloc]init];
/**创建对象，创建前判断是否为空，不为空不创建*/
#define NewObjIfNil(obj,class) {if(obj == nil){obj = NewObject(class);}}
//创建自动释放obj对象
#define NewObjectAutoD(x) [[[x alloc]init]autorelease];

//删除Obj对象
#define DelObject(x) {if (x) {[x release];x=nil;}}
//设置obj对象为空
#define NilObject(x) {if (x) {x=nil;}}
#define Obj_RELEASE(x)      [x release]
#define Obj_AUTORELEASE(x)  [x autorelease]


//NSString长度检查，
#define ISNSStringValid(x) (x != NULL && [x length] > 0)
//NSString转intValue，长度为空则返回－1
#define TZTStringToIndex(x,y){if(ISNSStringValid(x)) {y = [x intValue];} else { y = -1;} }
//手机号长度检查
#define ISMobileCodeValid(x) (x != NULL && [x length] == 11)
//电子邮箱检查
#define ISEmailValid(x) (x != NULL && [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] evaluateWithObject:x])

#pragma mark -字体相关
//HelveticaNeue
//DIN Alternate
//统一加粗字体，根据字体大小创建，字体由g_nsFontNameBold制定，默认HelveticaNeue-Bold
#define tztUIBaseViewTextBoldFont(fontsize) [UIFont fontWithName:g_nsFontNameBold size:((fontsize > 0)?fontsize:g_fDefaultFontSize) + tzt_iphone6_6p_exfontsize]
//统一不加粗字体，根据字体大小创建，字体由g_nsFontName指定，默认HelveticaNeue
#define tztUIBaseViewTextFont(fontsize) [UIFont fontWithName:g_nsFontName size:((fontsize > 0)?fontsize:g_fDefaultFontSize) + tzt_iphone6_6p_exfontsize]
//根据字体名称，大小创建字体
#define tztUIBaseViewTextFontWithName(name, fontsize) [UIFont fontWithName:name size:(fontsize > 0 ? fontsize : g_fDefaultFontSize) + tzt_iphone6_6p_exfontsize]
//根据大小创建默认字体，字体刻有g_nsFontName指定，默认HelveticaNeue
#define tztUIBaseViewTextFontWithDefaultName(fontsize) tztUIBaseViewTextFontWithName(g_nsFontName,fontsize)

//像素转换成字体
#define tztUIBaseViewTextFontWithPx(pxsize) tztUIBaseViewTextFont((pxsize*72/96))


//特殊标识 是否重发请求
#define tztIphoneReSend  @"tztIphoneReSend"
//特殊标识 交易类型
#define tztTokenType   @"tokentype"
//请求URL标识
#define tztIphoneREQUSTURL @"TZTREQUESTURL"
//请求URL参数 标识
#define tztIphoneREQUSTPARAM @"TZTREQUESTPARAM"
//请求URL 校验标识
#define tztIphoneREQUSTCRC @"TZTREQUESTCRC"
//签名数据
#define tztIphoneSignature @"signature"
//文件数据
#define tztIphonefiledata @"tztfiledata"
//原文数据
#define tztIphoneOriginal  @"original"

#pragma mark -通知定义
//Notification 定义
//均衡初始化
#define TZTNotifi_OnInitFinish          @"TZT_OnInitFinish"
//均衡链接失败
#define TZTNotifi_OnConnectFail         @"TZTSysOnConnectFail"
//均衡失败
#define TZTNotifi_OnJhActionFail        @"TZTSysJhActionFail"
//初始化完成
#define TZTNotifi_OnFinishLoad          @"TZTNotifi_OnFinishLoad"

//用户校验失败
#define TZTNotifi_CheckUserLoginFail        @"TZTNotifi_CheckUserLoginFail"
//设置服务器地址和端口
#define TZTNotifi_OnSetServerAddPort        @"TZTNotifi_OnSetServerAddPort"
//获取服务器地址和端口
#define TZTNotifi_OnGetServerAddPort        @"TZTNotifi_OnGetServerAddPort"
//打开文档
#define TZTNotifi_OpenDocument              @"TZTNotifi_OpenDocument"
//登录状态变更
#define TZTNotifi_ChangeLoginState          @"TZTNotifi_ChangeLoginState"
//快捷键设置通知
#define TZTNotifi_ChangeShortCut            @"TZTNotifi_ChangeShortCut"
//修改底部tabbar显示状态
#define TZTNotifi_ChangeTabBarStatus        @"TZTNotifi_ChangeTabBarStatus"
//登录帐号类型变更
#define TZTNotifi_ChangeAccountType         @"TZTNotifi_ChangeAccountType"

//底部TabBar状态变更文件名称
#define tztTabbarStatusFile             @"tztTabbarStatusFile"
//服务器配置文件名
#define tztappstringserver @"tztappserver"
//系统配置文件名
#define tztappstringssys @"tztappsys"
//http网页显示配置
#define tztappstringshttp @"tztapphttp"
//http交互头
#define tztHTTPAction @"http://action:"
//
#define tztHTTPStrSep tztAppStringValue(tztappstringshttp,@"tztapp_httpsep",@"&&")

//Session
#define tztSession_ALL  (tztSession_Exchange|tztSession_ExchangeRZ|tztSession_ExchangeJH|tztSession_ExchangeZX|tztSession_ExchangeKH)
//判断session类型
#define tztSessionType_IS(x,y) ((x & y) == y)

//版本控制
#define tzt_DEPRECATED __attribute__((deprecated))
//#if !defined(tzt_DEPRECATED)
//#   define tzt_DEPRECATED(version)
//#   if (version < 1)
//#       undef tzt_DEPRECATED
//#       define tzt_DEPRECATED(version) __attribute__((deprecated))
////#   else
////#       define tzt_DEPRECATED(version)  /* still available */
//#   endif
//#endif



#pragma mark --事务类别SessionType
//事务类别
typedef NS_ENUM (NSInteger, tztSessionType)
{
    tztSession_ExchangeHQ = 1 <<  0,        // mob行情服务器
    tztSession_Exchange = 1 << 1,           // 交易
    tztSession_ExchangeZX = 1 <<  2,        // 资讯
    tztSession_ExchangeJH = 1 <<  3,        // 均衡
    tztSession_ExchangeRZ = 1 <<  4,        // 认证
    tztSession_ExchangeKH = 1 <<  5,        // 开户
};

#pragma mark --交易类别TradeAccountType
//交易类别
typedef NS_ENUM (NSInteger, tztTradeAccountType)
{
    TZTAccountPTType = 0, //普通交易
    TZTAccountRZRQType = 1,//融资融券交易
    TZTAccountQHType = 2, //期货交易
    TZTAccountHKType = 3,//港股交易
    
    TZTAccountGGQQType = 8,//个股期权
    TZTAccountDBPPTLogin = 9,//担保品的普通登录
    TZTAccountCommLoginType = 10,//通讯密码登录
    
    TZTAccountLoginPTOrRZRQ = 16,//普通＋融资融券 任一
};

#import "NSData+Base64.h"
#import "NSObject+TZTPrivate.h"
#import "tztSystemFunction.h"
#import "NSString+tztHttpPrivate.h"
#import "tztBase.h"

#pragma mark -常用全局变量
extern short g_ntztProtocol; //通讯数据协议 目前支持2011、2013两种协议 ,默认2013
extern BOOL  g_btztEncode; //新加密方式，默认TRUE
extern NSString *g_nsJhAction; //均衡功能号，默认@"2"
extern NSString *g_nsUpVersion; //升级版本号
extern NSString *g_nsOnLineAction;//心跳功能号，默认@"46"
extern NSString *g_nsBundlename; //自定义bundle名称，默认@"tzt_iphone"
extern BOOL  g_bEncodeHttp;//本地服务读写数据是否加密，默认加密
extern int g_tztLogLevel;//日志打印级别，参考tztNSLog.h文件
extern int g_newHeartBeat;//新的心跳发送方式，只发包头＋功能号，默认0，不使用
extern NSString     *g_nsLogMobile; //登录手机号
extern int          g_nLogVolume;   //登录号，用于唯一登录校验判断
extern int   g_ntztHaveBtnOK;//网页alert是否带确定按钮,默认TRUE
extern NSString*   g_nsMessageBoxTitle;//对话框标题，默认@"系统提示"
extern int   g_Http_MAX_AGE;//http有效期，默认1800s
extern int   g_nSkinType;//0或空－默认 1-蓝白 2-红白
extern int   g_nOpenAccountType;//开户单独通道，不使用，后续废气，暂时保留，默认0
extern int   g_nTime;//定时刷新间隔时长，默认5s
extern int   g_nCurrentLoginType;//当前登录的账号类型，默认0

extern CGFloat  g_fDefaultFontSize; //默认字体大小，默认15
extern NSString *g_nsFontName;      //默认正常字体名称，默认HelveticaNeue
extern NSString *g_nsFontNameBold;  //默认加粗字体名称，默认HelveticaNeue-Bold
#if TARGET_OS_IPHONE
extern BOOL g_bChangeNav;//当前是否切换了nav
extern tztUINavigationController*  g_navigationController;//全局，当前使用的navigationcontroller
extern tztUINavigationController*  g_CallNavigationController;//第三方调用时，外部传入，用于后退返回
#endif

FOUNDATION_EXPORT void tztMobileBaseInit();
@interface tztMobileInitParams : NSObject
{
//    short g_ntztProtocol; //通讯数据协议 目前支持2011、2013两种协议
//    BOOL  g_btztEncode; //新加密方式
    NSString *g_nsJhAction; //均衡功能号
    NSString *g_nsUpVersion; //升级版本号
    NSString *g_nsOnLineAction;//心跳功能号
    NSString *g_nsBundlename; //自定义bundle名称
    NSString     *g_nsLogMobile; //登录手机号
    NSString*   g_nsMessageBoxTitle;//对话框标题
}
@property (nonatomic,retain) NSString *g_nsJhAction;
@property (nonatomic,retain) NSString *g_nsUpVersion;
@property (nonatomic,retain) NSString *g_nsOnLineAction;
@property (nonatomic,retain) NSString *g_nsBundlename;
@property (nonatomic,retain) NSString *g_nsLogMobile;
@property (nonatomic,retain) NSString *g_nsMessageBoxTitle;
+ (tztMobileInitParams *)getShareInstance;
+ (void)freeShareInstance;

@end


