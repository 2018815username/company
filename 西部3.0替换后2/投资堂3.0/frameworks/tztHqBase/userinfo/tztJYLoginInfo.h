/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易账号信息
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <Foundation/Foundation.h>
#import "TZTCardBankTransform.h"

#define Key_UserCode      @"Key_UserCode"
#define Key_KHBranch      @"Key_KHBranch"
#define Key_FundAccount   @"Key_FundAccount"
#define Key_UserName      @"Key_UserName"
#define Key_Score         @"Key_Score"
#define Key_UserLevel     @"Key_UserLevel"
#define Key_AccountList   @"Key_AccountList"
#define Key_Token         @"Key_Token"
#define Key_CreditFund    @"Key_CreditFund"
#define TZTMaxAccount 11

@interface tztZJAccountInfo : NSObject 
{
    NSString        *_nsAccount;        //账号
    NSString        *_nsAccountType;    //账号类型
    NSString        *_nsCellIndex;      //营业部号
    NSString        *_nsCellName;       //营业部名称
    NSString        *_nsPassword;       //密码
    NSInteger             _nNeedComPwd;       //是否需要通讯密码  1-通讯密码 2-动态口令
    NSString        *_nsCustomID;       //客户号
    NSString        *_nsComPwd;         //通讯密码
    NSString        *_nsAccountName;    //用户姓名
    NSInteger             _nAutoLogin;        //自动登录
    NSString        *_Ggt_rights;       /*记录内存中，暂时不处理*/
    NSString        *_Ggt_rightsEndDate;/*记录内存中，暂时不处理*/
    NSInteger             _nLogVolume;        //最近一次登录volume记录
}
@property(nonatomic, retain)NSString    *nsAccount;
@property(nonatomic, retain)NSString    *nsAccountType;
@property(nonatomic, retain)NSString    *nsCellIndex;
@property(nonatomic, retain)NSString    *nsCellName;
@property(nonatomic, retain)NSString    *nsCustomID;
@property(nonatomic, retain)NSString    *nsPassword;
@property(nonatomic, retain)NSString    *nsComPwd;
@property(nonatomic, retain)NSString    *nsAccountName;
@property(nonatomic, retain)NSString    *Ggt_rights;
@property(nonatomic, retain)NSString    *Ggt_rightsEndDate;
@property NSInteger nNeedComPwd;
@property NSInteger nAutoLogin;
@property NSInteger nLogVolume;

-(void)SetZJAccountInfo:(tztZJAccountInfo*)pAccount;
//保存当前账号信息到文件
-(void)SaveCurrentData:(NSInteger)nLoginType;
-(void)SaveCurrentData:(NSInteger)nLoginType withFileName_:(NSString*)nsFileName;
//读取文件中最后保存的账号信息
-(void)ReadLastSaveData:(NSInteger)nLoginType;
-(void)ReadLastSaveData:(NSInteger)nLoginType withFileName_:(NSString*)nsFileName;
//清除最后登录纪录的账号信息
-(void)ClearLastSaveData:(NSInteger)nLoginType;
-(void)ClearLastSaveData:(NSInteger)nLoginType withFileName_:(NSString*)nsFileName;

+(tztZJAccountInfo*) GetCurAccount;
//+(tztZJAccountInfo*) GetCurAccount:(NSString*)nsfileName;
//删除账号
-(void)DeLAccount:(NSString*)nsAccount;
-(void)DeLAccount:(NSString *)nsAccount withFileName_:(NSString*)nsFileName;
//保存账号,可能有多个账号
-(void)SaveAccountInfo;
-(void)SaveAccountInfo:(NSString*)nsFileName;
//读取保存的账号数据
+(void)ReadAccountInfo;
+(void)ReadAccountInfo:(NSString*)nsFileName withAy_:(NSMutableArray*)ayReturn;

//与Web交互用
//读取账号列表信息
+(NSString *)GetWebAccountList;
@end

@interface tztJYLoginInfo: NSObject
{
	BOOL            _bGetInfoSuc;	//是否已登录
	NSString        *_nsAccount;	//交易账号
	NSString        *_nsPassword;	//交易账号密码
	NSString        *_nsFundAccount;//资金账号
	tztZJAccountInfo *_ZjAccountInfo; //账号信息 
	NSString        *_nsUserCode;//UserCode 客户号
	NSString        *_nsKHBranch;//KHBranch 真实营业部号
	NSString        *_nsUserName;//UserName 用户名
	NSString        *_nsScore;//Score		   
	NSString        *_nsUserLevel;//UserLevel  等级

    NSString        *_nsOtherInfo; //扩展信息 key0=value0|key1=value1

    NSString        *_nsManagerMobile;//客户经理手机号码
    NSString        *_nsManagerName;//客户经理姓名
    NSString        *_nsLastTime;//上次登录时间
    NSString        *_nsLastAddr;//上次登录地址
    NSString        *_nsLoginEcho;//齐鲁登录回显 add by xyt 20130926
    NSString        *_nsYLXX;//预留信息
    NSString        *_nsOskey;//华西oskey
	
	NSMutableArray  *_ayAccountList;//股东账号列表
	
	NSInteger             _FundTradefxjb; //基金风险等级
    NSString        *_FundTradefxmc;//风险等级名称
	
	tztCardBankTransform* _pBDTranseInfo; //银证转账信息
    tztCardBankTransform* _pMoreAccountTranseInfo;//多银行存管信息
    
	NSInteger                   _tokenIndex; //Token数组序号
	NSInteger                   _tokenType;//账号类别 0 普通股票交易 1 融资融券
    NSInteger                   _otherType; //0 无, 1 有融资融券账号
    NSString        *_OtherToken;//
    //用户风险测评
    BOOL                  _bCheckFXCP;
    BOOL                  _haveZRTRight;
    NSMutableArray  *_ayTradeStockData;
}
@property					BOOL			 bGetInfoSuc;
@property(nonatomic,retain) NSString*        nsAccount;
@property(nonatomic,retain) NSString*        nsPassword;
@property(nonatomic,retain) NSString*        nsFundAccount;
@property(nonatomic,retain) tztZJAccountInfo*   ZjAccountInfo;
@property(nonatomic,retain) NSString*        nsUserCode;
@property(nonatomic,retain) NSString*        nsKHBranch;
@property(nonatomic,retain) NSString*        nsUserName;
@property(nonatomic,retain) NSString*        nsScore;
@property(nonatomic,retain) NSString*        nsOtherInfo;//扩展信息 key0=value0|key1=value1
@property(nonatomic,retain) NSString*        nsUserLevel;
@property(nonatomic,retain) NSString*        nsOsKey;

@property(nonatomic,retain) NSString*        nsManagerMobile;
@property(nonatomic,retain) NSString*        nsManagerName;
@property(nonatomic,retain) NSString*        nsLastTime;
@property(nonatomic,retain) NSString*        nsLastAddr;
@property(nonatomic,retain) NSString*        nsYLXX;
@property(nonatomic,retain) NSString*        nsLoginEcho;
@property(nonatomic,retain) NSString*        nsRights; // 权限
@property(nonatomic,retain) NSString*        tzttraderights; //权限

@property(nonatomic,retain) NSMutableArray*  ayAccountList;
@property					NSInteger				 FundTradefxjb;
@property(nonatomic,retain) NSString*        FundTradefxmc;

@property(nonatomic,retain) tztCardBankTransform* pBDTranseInfo; //银证
@property(nonatomic,retain) tztCardBankTransform* pMoreAccountTranseInfo;//多银行存管信息
@property					NSInteger				 tokenIndex;
@property					NSInteger				 tokenType;
@property					NSInteger				 otherType;//0 无, 1 有融资融券账号
@property                   BOOL             bCheckFXCP;
@property                   BOOL             haveZRTRight;
@property                   NSInteger              nLoginType;
@property(nonatomic,retain) NSMutableArray  *ayTradeStockData;
@property(nonatomic,retain) NSMutableDictionary *dictLoginInfo;
-(void) JYLoginInfo_;
-(void) JYLoginInfo__;
//清空数据
-(void) RemoveAllInfo;

//获取 设置Token序号
-(NSInteger)GetTokenIndex;
//设置账号信息
-(BOOL)SetAccountInfo:(tztZJAccountInfo*)pZJAccountInfo;

//账号登录 账号列表序号 登录信息 密码 登录类型
+(BOOL)SetLoginInAccount:(tztNewMSParse*) pParse Pass_:(NSString*) nsPassword AccountInfo_:(tztZJAccountInfo*)pZJAccountInfo AccountType:(NSInteger)nAccountType;

#pragma tztNewMSParse 银证信息
//保存银证信息
-(void)saveBankToDealerInfo:(tztNewMSParse*)pInfo;
//存储多个资金账号信息
-(void)saveMoreAccountToDealerInfo:(tztNewMSParse*)pInfo;
+(void)saveMoreAccountToDealerInfoWithData:(tztNewMSParse*)pInfo;

#pragma tztNewMSParse 当前普通登录用户信息处理
//判断是否支持信用账号
+(BOOL)iscreditfund:(tztNewMSParse*)jydataPhase;

//设置当前普通交易账号信息积分 用户等级
+(void)SetCurJyLoginInfoScore:(tztNewMSParse*)pParse;
//设置当前普通交易账号基金风险等级 风险等级名称
+(void)SetCurJyLoginInfoFundFxdj:(NSInteger)nFxdj DJMC:(NSString*)nsDJMC;
//账号类别 当前普通交易账号是否支持信用账号
+(NSInteger)getcreditfund;
+(NSInteger)getZRTRight;
//当前普通交易账号是否支持多存管
+(BOOL)IsSupportMoreBank;

#pragma 已登录交易账号处理
//获取当前登录交易账号 账号类型
+(tztJYLoginInfo *)GetCurJYLoginInfo:(NSInteger)nAccountType;
//根据账号类型，以及数组中的索引设置账号
+(BOOL)SetCurJYLoginInfo:(NSInteger)nAccountType _nIndex:(NSInteger)nIndex;
//
+(BOOL)SetCurJYLoginInfo:(NSInteger)nAccountType _nIndex:(NSInteger)nIndex account_:(tztZJAccountInfo*)pZJAccunt;
//设置最近登录交易账号信息
+ (BOOL)SaveRectAccount:(tztJYLoginInfo* )pRecenJYLoginInfo;
//获取最近登录交易账号信息
+(tztJYLoginInfo*) GetRecentAccount;

//读取已登录用户名 － 账号列表
+(BOOL)GetJyAccountList:(NSMutableArray*)ayJyAccount;

//账号全部登出
+(BOOL)SetLoginAllOut:(BOOL)bFlag;
+(BOOL)SetLoginAllOut;
//账号登出 登出交易账号资金账号
+(BOOL)SetLoginOutAccount:(NSString *)strFundAccount;

//资金账号 查找已登录账号
+(NSInteger)GetLoginIndexOfAyJYLogin:(NSString *)strFundAccount forType:(NSInteger *)nAccountType;
+(NSInteger)GetLoginIndexOfAyJYLoginEx:(NSString *)strFundAccount andLoginType:(NSInteger)nLoginType forType:(NSInteger *)nAccountType;
//当前是否有账号登录着
+(BOOL)HaveLoginAccount;

#pragma 交易账号
//获取当前默认账号 bLoginIn 未登录账号
+(NSString*)GetDefaultAccount:(BOOL)bLoginIn nType_:(NSInteger)nLoginType;

//设置默认交易账号
+(void)SetDefaultAccount:(NSString*)nsDefault nType_:(NSInteger)nLoginType;
//获取默认交易账号
+(NSString*)GetDefaultAccount:(NSInteger)nLoginType;

//隐藏账号
+(NSString*)HideFund:(NSString*)str;
//设置账号列表 账号列表信息
+(BOOL)SetAccountList:(tztNewMSParse*) pParse;
//添加账号到列表
+(void)AddAccountToList:(tztZJAccountInfo*)pAccountData;
+(BOOL)DelAccountIndex:(NSInteger)iIndex;

+(BOOL)IsTradeCCShow;
+(void)setTradeStockData:(NSMutableArray*)ayData;
+(BOOL)IsTradeStockInfo:(tztStockInfo*)pStock;
+(NSDictionary*)GetTradeStockData:(tztStockInfo*)pStock;

@end


//港股通权限
/*0-没权限 1-有权限 －1登录被踢*/
FOUNDATION_EXPORT int tztHaveHKRight();
FOUNDATION_EXPORT tztZJAccountInfo* tztGetCurrentAccountHKRight();
FOUNDATION_EXPORT void tztSaveCurrentHKRight(tztZJAccountInfo* pAccount);

extern NSMutableArray* g_ayJYLoginInfo;//交易登录账号列表
extern NSInteger g_AccountIndex;    //交易登录选择索引
extern NSInteger g_ZjAccountArrayNum;
extern NSInteger g_YYBListArrayNum;
extern NSInteger g_ZQGSListArrayNum;
extern NSInteger g_AcTypeArrayNum;
extern NSString *g_tztSysNodeID;//路由

extern NSMutableArray  *g_ZJAccountArray;
extern NSMutableArray  *g_ZQGSListArray;
extern NSMutableArray  *g_YYBListArray;
extern NSMutableArray  *g_AccountTypeArray;

//当前使用的账号信息，多账号时记录
extern tztJYLoginInfo        *g_pCurJYLoginInfo;