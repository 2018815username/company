//
//  tztSystemdefine.h
//  tztMobileApp
//
//  Created by yangares on 13-6-20.
//
//

#import <Foundation/Foundation.h>

#import <tztMobileBase/tztMobileBase.h>
#import <tztMobileBase/tztBase.h>

#import "tztBase+Exten.h"

#import "tztNotification.h"

#ifndef tztProtocol
#define tzt2013Protocol
#endif

#define tzt_Inner_Version @"20150505[001]"

#ifndef TZTDailPhoneNUM

#define TZTDailPhoneNUM @"0571-56696192"

#endif

#define COMM_ERR_NO_EXIT1      -204007  //时间戳错误
#define COMM_ERR_NO_EXIT2      -204009  //超时
#define COMM_ERR_NO_EXIT3      -207001  //密码错误
#define COMM_ERR_NO_EXIT4      -204001  //无效在线客户号
#define COMM_ERR_NO_SAMECODE   -206010  //


#define TZTMaxAccountType 11 //普通交易 融资融券交易

#define TZTMaxAccount 11 //多账号最大账号数

//
//#define L_(s) NSLocalizedString(s, nil)
//#define L_2(s, c) NSLocalizedString(s, c)

#define KDGREED(x) ((x)  * M_PI * 2)

#ifdef Support_EXE_VERSION
#define UseAnimated 0
#else
#define UseAnimated 0
#endif

#define Support_tztTradeList 0

#define TZTUIBaseInterfaceUsePNG        (1)     //是否使用图片作为界面素材 < 0 标示不使用PNG素材

//#define tztXMargin  (5)
//#define tztYMargin  (5)


//设置基类配置值
FOUNDATION_EXPORT void tztSetBasedef();

/**
 *	用于计算指定字符串nsValue，并保留nNumber位有效小数
 *
 *	@param 	nsValue 	source
 *	@param 	nNumber 	指定保留的有效小数位
 *
 *	@return	返回格式化后的字符串
 */
FOUNDATION_EXPORT NSString* tztdecimalNumberByDividingBy(NSString* nsValue,int nNumber);


FOUNDATION_EXPORT UIViewController* gettztHaveViewContrller(Class vcClass,int nVcKind,NSString* nVcType, BOOL* bPush,BOOL bCreate);
FOUNDATION_EXPORT UIViewController* gettztHaveViewContrllerEx(Class vcClass,int nVcKind,NSString* nVcType, BOOL* bPush,BOOL bCreate, UIViewController* vcControl);

/**
 *	校验手机号码有效性
 *
 *	@param 	mobile 	手机号码
 *
 *	@return	有效返回TRUE，否则返回FALSE
 */
FOUNDATION_EXPORT BOOL validateMobile(NSString* mobile);


#ifdef Support_GJKHHTTPData
FOUNDATION_EXPORT NSString* deviceIPAdress();
#endif

/**
 *	屏幕有效显示宽度
 */
extern int         g_nScreenWidth;

/**
 *	屏幕有效显示高度
 */
extern int         g_nScreenHeight;

/**
 *	底部工具栏高度
 */
extern int         g_nToolbarHeight;


extern int         g_nJYBackBlackColor;
extern int         g_nHQBackBlackColor;
extern int         g_nThemeColor;
extern NSString     *g_nsdeviceToken;
extern int          g_nTradeListType;//zxl 20130719 当前交易列表类型（国泰用户不同的交易界面查看用户信息后返回当前交易类型界面）
extern NSString     *g_nsPeople;
extern NSString     *g_nsContact;
extern BOOL        g_bShowLock;
extern BOOL         g_nHaveDtPassword;
extern NSMutableDictionary *g_pDictLoginInfo;

extern NSString* g_nsUserCardID;        //资金理财身份证号码
extern NSString* g_nsUserInquiryPW;     //资金理财查询密码
extern NSInteger      g_nJyTypeCount;//zxl 20131012 交易界面中类型数量用户不同的交易界面区分展示不同
extern NSMutableArray      *g_ayTradeRights;

extern NSString*    g_GgtRights;
extern NSString*    g_GgtRightEndDate;
