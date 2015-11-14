/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztHTTPConnection.h
 * 文件标识：
 * 摘    要： http服务处理
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/


#import <Foundation/Foundation.h>
#import "tztHTTPServer.h"
#import "NSString+tztHttpPrivate.h"

//////////////////////////////////////////////////////////////////////////////////////////////////
//http请求应答返回 返回socket,请求头类型,数据更新时间,返回数据,数据类型,数据格式
FOUNDATION_EXPORT void (^responseBlock)(tztGCDAsyncSocket*,int,NSString*,NSDate *,NSData*,int,NSString*);

@protocol tztHTTPSendDataDelegate;
@interface tztHTTPSendData : NSObject <tztSocketDataDelegate>
{
    NSMutableDictionary* _sendData;
    id _tztdelegate;
    
    dispatch_source_t _sendTimer;
    tztMoblieStockComm *_mobilestock;
    int _nSendRecv; // 0 待发送 1 已发送 2已接收
}
@property (nonatomic,retain) NSMutableDictionary* sendData;
@property (nonatomic,assign) id<tztHTTPSendDataDelegate> tztdelegate;
- (id)initWithSendData:(NSMutableDictionary*)sendData;
- (NSUInteger)socketSendData:(tztMoblieStockComm *)mobilestock;
- (NSUInteger)socketSendData:(tztMoblieStockComm *)mobilestock withtimeout:(NSTimeInterval)fTimeOut;

+ (NSUInteger)socketSendData:(tztMoblieStockComm *)mobilestock action:(NSString *)strAction sendData:(NSMutableDictionary *)sendData tztdelegate:(id)tztdelegate;
+ (NSUInteger)socketSendData:(tztMoblieStockComm *)mobilestock withtimeout:(NSTimeInterval)fTimeOut action:(NSString *)strAction sendData:(NSMutableDictionary *)sendData tztdelegate:(id)tztdelegate;
@end

@protocol tztHTTPSendDataDelegate<NSObject>
@optional
- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam sendData:(NSMutableDictionary*)sendData;
@required
- (void)onSenddataError:(NSMutableDictionary*)sendData type:(int)nType;
- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam;
@end


@interface tztHTTPConfig : NSObject
{
	tztHTTPServer __unsafe_unretained *_server;
	dispatch_queue_t queue;
}

- (id)initWithServer:(tztHTTPServer *)server;
- (id)initWithServer:(tztHTTPServer *)server queue:(dispatch_queue_t)q;

@property (nonatomic, unsafe_unretained, readonly) tztHTTPServer *server;
@property (nonatomic, readonly) dispatch_queue_t queue;
- (int)getReqSession;
@end

@interface tztHTTPConnection : NSObject <tztHTTPSendDataDelegate
#if TARGET_OS_IPHONE
,UIDocumentInteractionControllerDelegate
#endif
>
{
    dispatch_queue_t connectionQueue;
	tztGCDAsyncSocket *asyncSocket; //服务通讯
    
    tztHTTPConfig *config;
    BOOL started;
    
	CFHTTPMessageRef request;       //请求串
	NSString *nonce;
	int lastNC;
    int _ntztReq;                   //后台请求序号
    //
    NSString* _nsFileType;
    NSString* _nsFileName;
}
@property(nonatomic,retain)NSString* nsFileType;
@property(nonatomic,retain)NSString* nsFileName;

- (id)initWithAsyncSocket:(tztGCDAsyncSocket *)newSocket configuration:(tztHTTPConfig *)aConfig;

- (void)start;
- (void)stop;

- (void)startConnection;

- (BOOL)isSecureServer;

- (NSArray *)sslIdentityAndCertificates;

- (BOOL)isPasswordProtected:(NSDictionary *)param;

- (NSString *)realm;
- (NSString *)passwordForUser:(NSString *)username;
- (void)dataFormethod:(NSString*)method url:(NSString *)path parame:(NSString*)paramvalue postData:(NSData*)postData encodeurl:(BOOL)bencode httptype:(tztHttpString) datatype;
- (void)dataFormethod:(NSString*)method url:(NSString *)path parame:(NSString*)paramvalue encodeurl:(BOOL)bencode httptype:(tztHttpString) datatype;
- (void)dataFormethod:(NSString*)method url:(NSString *)path encodeurl:(BOOL)bencode httptype:(tztHttpString) datatype;
- (void)doReplyDataToServer:(id)sender;
@end
