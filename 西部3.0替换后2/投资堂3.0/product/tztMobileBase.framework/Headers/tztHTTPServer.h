/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztHTTPServer.h
 * 文件标识：
 * 摘    要：tztHTTPServer http服务器
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
#import "tztGCDDataSocket.h"

#define HTTPConnectionDidDieNotification  @"HTTPConnectionDidDie"

@interface tztHTTPServer : NSObject<NSNetServiceDelegate,tztSocketDataDelegate>
{
	tztGCDAsyncSocket *asyncSocket;
    // Dispatch queues
	dispatch_queue_t serverQueue;
	dispatch_queue_t connectionQueue;
	void *IsOnServerQueueKey;
	void *IsOnConnectionQueueKey;
    
    Class connectionClass;
	UInt16 port;
    
	NSMutableArray *connections;
    NSLock *connectionsLock;
    
    BOOL isRunning;
    int _nSession;
	id delegate;
}
- (id)initWithSession:(int)nSession;

- (id)delegate;
- (void)setDelegate:(id)newDelegate;
- (void)setSession:(int)nSession;
- (int)getSession;
- (Class)connectionClass;
- (void)setConnectionClass:(Class)value;

- (UInt16)port;
- (UInt16)listeningPort;
- (void)setPort:(UInt16)value;

- (BOOL)start:(NSError **)error;
- (void)stop;
- (void)stop:(BOOL)keepExistingConnections;
- (BOOL)isRunning;

- (NSUInteger)numberOfHTTPConnections;

+ (NSString *)MD5:(NSString *)str;
- (void)onInitData;
@end
