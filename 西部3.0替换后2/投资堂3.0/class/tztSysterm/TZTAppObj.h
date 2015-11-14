/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#ifndef __TZTAPPOBJ_H__
#define __TZTAPPOBJ_H__

@class TZTAppObj;
@class TZTUIBaseTabBarViewController;
@class TZTUIBaseViewController;
@class tztInitObject;
@class PPRevealSideViewController;
@class tztCommRequestView;
extern NSTimer	*g_pJYLockTimer;
extern BOOL     g_bShowLock;
@interface TZTUIWindow : UIWindow
{
	
}

@end

@protocol tztAppObjDelegate
@optional
-(void)tztAppObjCallAppViewControl;
-(void)tztAppObjOnReturnBack;
-(void)tztAppObj:(id)sender didSelectItemByPageType:(int)nType options_:(NSMutableDictionary*)options;
-(void)tztAppObj:(id)sender didSelectItemByIndex:(int)nIndex options_:(NSMutableDictionary*)options;
@end

@protocol UINavigationControllerDelegate;
@protocol TZTUIMessageBoxDelegate;
@protocol UIAlertViewDelegate;
#ifdef tzt_StartPage
@protocol StartVC;
@interface TZTAppObj :NSObject<UINavigationControllerDelegate, UITabBarControllerDelegate, tztAppObjDelegate, TZTUIMessageBoxDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate, StartVC>
#else
@interface TZTAppObj :NSObject<UINavigationControllerDelegate, UITabBarControllerDelegate, tztAppObjDelegate, TZTUIMessageBoxDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>
#endif
{
    TZTUIBaseTabBarViewController   *_rootTabBarController;
    tztUINavigationController       *_rootNav;
    TZTUIWindow                     *_window;
    NSDictionary                    *_dictCallParam;
    NSString                        *_nsOrder_nsJyAccount;
    
    tztInitObject                   *_initObj;
    //华泰理财传入底部的menubar，控制隐藏，显示
    UIView                          *_pMenuBarView;
    
    tztCommRequestView              *_pCommRequest;
    
    /*文档打开使用*/
    UIDocumentInteractionController *_pDocumentVC;
    BOOL                _bRefresh;
    NSString            *_nsFilePath;
    
    
    UInt32                          _nStartType;
    BOOL                            _bInit;
    PPRevealSideViewController      *_revealSideViewController;
    /*第三方应用直接调应用新增*/
    BOOL                            _bInitApplication;
    NSURL                           *_nsTztURL;
}
@property(nonatomic,retain)TZTUIBaseTabBarViewController    *rootTabBarController;
@property(nonatomic, retain) tztUINavigationController      *rootNav;
@property(nonatomic,retain)TZTUIWindow                      *window;
@property(nonatomic,retain)NSDictionary                     *dictCallParam;
@property(nonatomic,retain)NSString                         *nsOrder_nsJyAccount;
@property(nonatomic,retain)tztInitObject                    *initObj;
@property(nonatomic,retain)UIView                           *pMenuBarView;
@property(nonatomic,retain)tztCommRequestView               *pCommRequest;
@property(nonatomic,retain)UIDocumentInteractionController  *pDocumentVC;
@property(nonatomic,retain)NSString                         *nsFilePath;
@property(nonatomic)BOOL                                    bInit;
@property(nonatomic)UInt32                                  nStartType;
@property(nonatomic)BOOL                                    bInitApplication;
@property(nonatomic,retain)NSURL*                            nsTztURL;
@property(nonatomic,retain)PPRevealSideViewController      *revealSideViewController;

-(void)setInitFlag:(BOOL)bFlag;
-(BOOL)getInitFlag;
- (NSInteger)callService:(NSDictionary*)params withDelegate:(id)delegate;
//- (NSInteger)callback:(id)caller withParams:(NSDictionary *)params;
- (NSInteger)InitWithApp:(NSDictionary*)params withDelegate:(id)delegate;
- (void)deleteTztObj;
- (void)setMenuBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)tztMainInit;
-(void)tztGetUserStockData:(int)nStockNum;

-(void)tztDownloadFile:(NSString*)strParam;
//#ifndef Support_EXE_VERSION
//zxl 显示查询界面
-(void)ShowStockQueryVC:(UIViewController*)pPopVC  Rect:(CGRect)rect;
//#endif

-(BOOL)tztHandleOpenURL:(NSURL*)url;
-(void)tztGetPushDetailInfo:(NSString*)strData;
//通讯状态回调
- (void)reachabilityChanged:(NSNotification *)note;
//单一实例
+(TZTAppObj*)getShareInstance;
+(void)freeShareInstance;
+(TZTUIBaseViewController*)getTopViewController;

+(int)getDefaultStartIndex;
+(void) InitData;
+(void) InitConnData;
+(void) InitServerList;
-(void)showvc;

+(NSMutableArray*)makeTabBarViewController;
+(UIViewController*) GetTabBarViewController:(NSInteger)nType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam;

/*3401 - 查询股票信息*/
-(void)tztSearchStockInfo:(tztStockInfo*)pStock withList_:(NSMutableArray*)ayList;
/*3404-我的自选*/
-(void)tztOpenMyStock;
/*3408 － 个股查询*/
-(void)tztSearchCode;
/*3410-大盘指数*/
-(void)tztOpenIndexTrend;
/*3411 - 综合排名*/
-(void)tztOpenZHPM;
/*3430 － 行情设置*/
-(void)tztHqSetting;
/*3431 － 服务器设置*/
-(void)tztSetServer;
/*3453 - 场外基金*/
-(void)tztOpenOutFund;
//系统配置
-(void)tztOpenSysConfig;
//版本信息
-(void)tztSoftVersion;
//资讯中心
-(void)tztInfoCenter;
-(void)tztResetComPass:(NSString*)nsAccount;
/*3702 － 银证转账*/
-(void)tztBankCard;
/*3703 － 紫金理财*/
-(void)tztOpenZJLC;
-(void)tztTTF;
/*3801 － 交易登录*/
-(void)tztTradeLogin;
/*3802 － 交易登出*/
-(void)tztTradeLogOut;
-(void)tztQueryCC;
/*3831 - 修改密码*/
-(void)tztChangPW;
/*3834 - 个人信息修改*/
-(void)tztUserInfoModify;
/*3829 - 交割单业务*/
-(void)tztQueryJG;
/*4018 - 紫金账号查询*/
-(void)tztAccount_ZJLC;
/*4011 － 基金资产查询，持仓基金*/
-(void)tztFundQuery;
/*4013 － 场外基金开户*/
-(void)tztFundOpenAccount;
/*4015 － 基金分红方式修改*/
-(void)tztFenHongSet;
//紫金理财认购
-(void)tztFundRG_ZJLC;
//紫金理财申购
-(void)tztFundSG_ZJLC;
/*4019 － 紫金理财查询密码修改*/
-(void)tztFundChangeFindPWD;
/*4065 － 紫金理财分红方式修改*/
-(void)tztFHSet_ZJLC;
-(void)tztFundSH_ZJLC;

@end

extern TZTAppObj    *g_pTZTAppObj;
extern id           g_pTZTDelegate;
extern UIViewController *g_pTZTTopVC;
#endif