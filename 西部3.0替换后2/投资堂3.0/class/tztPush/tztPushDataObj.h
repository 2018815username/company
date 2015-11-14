
#import <Foundation/Foundation.h>

 /**
 *	@brief	推送相关处理，单例模式
 */
@interface tztPushDataObj : NSObject
@property(nonatomic,retain)NSDictionary *pushInfo;

/**/
+(tztPushDataObj*)getShareInstance;
-(void)freeShareInstance;


 /**
 *	@brief	推送注册
 *
 *	@return	NULL
 */
-(void)tztRegistPush;

 /**
 *	@brief	注册成功处理，获取deviceToken
 *
 *	@param 	deviceToken 	收到的deviceToken
 *
 *	@return	NULL
 */
-(void)tztRegistPushSucc:(NSData*)deviceToken;

 /**
 *	@brief	收到推送数据
 *
 *	@param 	userInfo 	推送数据
 *
 *	@return	NULL
 */
-(void)tztDidRecivePushData:(NSDictionary *)userInfo;

 /**
 *	@brief	记录devicetoken
 *
 *	@return	NULL
 */
-(void)tztSendDeviceToken;

/**
 *	@brief	获取唯一号
 *
 *	@return	NULL
 */
-(void)tztRequestUniqueId;

 /**
 *	@brief	纪录客户端信息
 *
 *	@return	NULL
 */
-(void)tztSendUniqueIdWithDeviceToken;

 /**
 *	@brief	交易登录后，关联唯一号
 *
 *	@param 	dict 	交易账户相关信息
 *
 *	@return	NULL
 */
-(void)tztSendUniqueIdWithAccount:(NSDictionary*)dict;

 /**
 *	@brief	交易登出，注销唯一号登录
 *
 *	@param 	nsAccount 	要注销的账号
 *
 *	@return	NULL
 */
-(void)tztRequestSignOutTrade:(NSString*)nsAccount;

 /**
 *	@brief	获取具体的推送消息
 *
 *	@param 	nsPushInfo 	收到的推送数据摘要
 *
 *	@return	NULL
 */
-(void)tztRequestDetailOfPushInfo:(NSString*)nsPushInfo;





@end
