/*************************************************************
 *	Copyright (c)2009, 杭州中焯信息技术有限公司
 *	All rights reserved.
 *
 *	文件名称：	TZTServerListDeal.h
 *	文件标识：	
 *	摘	  要：	服务器地址
 *              增加了服务器类型扩展功能
 *	当前版本：	3.0
 *	作	  者：	yangdl
 *	更新日期：	
 *
 ***************************************************************/

#import <Foundation/Foundation.h>
/**服务器地址管理类，单例模式使用*/
@interface TZTServerListDeal : NSObject

/**交易地址*/
@property (nonatomic, retain) NSString*     strJYAdd;
/**行情地址*/
@property (nonatomic, retain) NSString*     strHQAdd;
/**认证地址*/
@property (nonatomic, retain) NSString*     strRZAdd;
/**均衡地址*/
@property (nonatomic, retain) NSString*     strJHAdd;
/**资讯地址*/
@property (nonatomic, retain) NSString*     strZXAdd;
/**开户地址*/
@property (nonatomic, retain) NSString*     strKHAdd;
/**交易端口*/
@property (nonatomic) int                   nJYPort;
/**行情端口*/
@property (nonatomic) int                   nHQPort;
/**认证端口*/
@property (nonatomic) int                   nRZPort;
/**均衡端口*/
@property (nonatomic) int                   nJHPort;
/**均衡端口*/
@property (nonatomic) int                   nZXPort;
/**开户端口*/
@property (nonatomic) int                   nKHPort;
/**是否强制地址*/
@property BOOL                              bForce;
/**本地列表*/
@property (nonatomic, retain) NSMutableDictionary* ayLocList;
/**服务器列表*/
@property (nonatomic, retain) NSMutableDictionary* ayList;
/**服务器地址列表*/
@property (nonatomic, retain) NSMutableArray* ayAddList;
/**端口列表*/
@property (nonatomic, retain) NSMutableArray* ayPortList;
/**用户自定义服务器列表*/
@property (nonatomic, retain) NSMutableArray* ayUserAddList;
/**用户自定义端口列表*/
@property (nonatomic, retain) NSMutableArray* ayUserPortList;
/**均衡服务器列表*/
@property (nonatomic, retain) NSMutableArray* ayJHAddList;
/**升级地址*/
@property (nonatomic, retain) NSString* strUpdateAdd;
/**升级提示信息*/
@property (nonatomic, retain) NSString* strUpdateMsg;
/**升级类型*/
@property int       nUpdateSign;
@property (nonatomic, retain) NSMutableDictionary   *pDict;//

+(void)initShareClass;
+(void)freeShareClass;
+(TZTServerListDeal*)getShareClass;

/**系统初始化数据*/
-(void) SystemDefault;

/**保存或读取服务器地址信息*/
-(BOOL) SaveAndLoadServerList:(BOOL) bSave;

/**根据session，设置服务器地址和端口  服务器类型 地址  端口，session类型参见tztSessionType定义*/
- (void)SetServerInfo:(int)nSession address:(NSString*)strAdd port:(int)nPort;
/**根据session，设置服务器地址 服务器类型  地址，session类型参见tztSessionType定义*/
- (void)SetAddressInfo:(int)nSession address:(NSString*)strAdd;
/**获取服务器地址  服务器类型,session类型参见tztSessionType定义*/
- (NSString*)GetAddressInfo:(int)nSession;
/**设置服务器端口 服务器类型 端口,session类型参见tztSessionType定义*/
- (void)SetPortInfo:(int)nSession port:(int)nPort;
/**获取服务器端口,session类型参见tztSessionType定义*/
- (int)GetPortInfo:(int)nSession;

/**设置为下一个服务器地址 服务器类型  TRUE 随机 FALSE 取下一个,session类型参见tztSessionType定义*/
- (BOOL)GetNextAddress:(int)nSession bRand_:(BOOL)bRand;
/**设置统一的服务器地址*/
- (void)SetAllAddress:(NSString*)strAdd;
/**设置统一的端口*/
- (void)SetAllPort:(int)nPort;

/**添加服务器地址,session类型参见tztSessionType定义*/
- (void)AddAddressInfo:(int)nSession address:(NSString*)strAdd;
/**删除服务器地址,session类型参见tztSessionType定义*/
- (BOOL)RemoveAddressInfo:(int)nSession address:(NSString*)strAdd;
/**服务器列表数,session类型参见tztSessionType定义*/
- (NSUInteger)AddressInfoCount:(int)nSession;
/**获取服务器地址列表,session类型参见tztSessionType定义*/
- (NSMutableArray*)GetAddressList:(int)nSession;

/**下面的设置地址端口，获取地址端口的函数，统一使用上面列举的通过session来设置指定通道的地址，后续下面函数将删除*/
/** 设置交易地址*/
-(void) SetJYAddress:(NSString*)strJyAdd tzt_DEPRECATED;
/**获取当前交易地址*/
-(NSString*) GetJYAddress tzt_DEPRECATED;
/**设置行情地址*/
-(void) SetHQAddress:(NSString*)strHQAdd tzt_DEPRECATED;
/**获取当前行情地址*/
-(NSString*) GetHQAddress tzt_DEPRECATED;
/**设置认证地址*/
-(void) SetRZAddress:(NSString*)strRZAdd tzt_DEPRECATED;
/**设置资讯地址*/
-(void) SetZXAddress:(NSString*)strZXAdd tzt_DEPRECATED;
/**设置均衡地址*/
-(void) SetJHAddress:(NSString*)strJHAdd tzt_DEPRECATED;
/**设置开户地址 */
-(void) SetKHAddress:(NSString*)strKHAdd tzt_DEPRECATED;
/**获取开户地址*/
-(NSString*) GetKHAddress tzt_DEPRECATED;
/**获取认证地址*/
-(NSString*) GetRZAddress tzt_DEPRECATED;
/**获取当前均衡地址*/
-(NSString*) GetJHAddress tzt_DEPRECATED;
/**获取资讯地址*/
-(NSString*) GetZXAddress tzt_DEPRECATED;
/**设置交易端口*/
-(void) SetJYPort:(int)nPort tzt_DEPRECATED;
/**获取当前交易端口*/
-(int) GetJyPort tzt_DEPRECATED;
/**设置行情端口*/
-(void) SetHQPort:(int)nPort tzt_DEPRECATED;
/**获取当前行情端口*/
-(int) GetHQPort tzt_DEPRECATED;
/**设置认证端口*/
-(void) SetRZPort:(int)nPort tzt_DEPRECATED;
/**获取认证端口*/
-(int) GetRZPort tzt_DEPRECATED;
/**获取当前均衡端口*/
-(int) GetJHPort tzt_DEPRECATED;
/**获取资讯端口*/
-(int) GetZXPort tzt_DEPRECATED;
/**设置资讯端口*/
-(void)SetZXPort:(int)nPort tzt_DEPRECATED;
/**获取开户端口*/
-(int) GetKHPort tzt_DEPRECATED;
/**设置开户端口*/
-(void)SetKHPort:(int)nPort tzt_DEPRECATED;
/**将服务器地址添加服务器列表*/
-(void) AddAddress:(NSString*)strAdd;
/**删除服务器地址*/
-(BOOL) RemoveAddress:(NSString*)strAdd;
/**服务器列表数*/
-(NSUInteger)GetListCount;

/**添加端口*/
- (void)AddPort:(int)strPort;
/**删除端口*/
- (BOOL)RemovePort:(int)strPort;
/**端口列表数*/
-(NSUInteger)GetPortCount;


-(void) SetServerList:(NSString*)strServerList;
-(void) SetLocList:(NSString*)strLocList;
-(void) SetServerList:(NSString *)strServerList LocList:(NSString*)strLocList;
-(void) SetServerList:(NSString *)strServerList LocList:(NSString*)strLocList nSession:(int)nSession;
/**设置均衡服务器列表*/
-(void)SetTztJHServer:(NSString*)tztJhServer;

+(void) SetJHSysDate:(NSInteger)nSysDate;
+(NSInteger) GetJHSysDate;
-(BOOL) DealServerList:(NSString*)strServerList Aydict:(NSMutableDictionary*)aydict;

//服务器设置确认
- (BOOL)SetServerOK;
//服务器设置确认 服务器类型
- (BOOL)SetServerOK:(int)ntranstype;
/**调用均衡功能*/
- (void)onSendJHAction:(void (^)(void))completion;

@end


