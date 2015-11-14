/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztlocalHTTPServer.h
 * 文件标识：
 * 摘    要： http本地服务器
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

#import "tztHTTPServer.h"
#import "tztHTTPConnection.h"

extern int g_nDefaultSession;
@interface tztlocalHTTPServer : tztHTTPServer
//http初始化
+ (void)httpServerInit;
+ (tztlocalHTTPServer *)getShareInstance;
+ (tztlocalHTTPServer *)getShareInstance:(int)nSession;
+ (void)starShareInstance:(int)nSession;
+ (void)stopShareInstance:(int)nSession;
+ (void)freeShareInstance:(int)nSession;
//启动所有http
+ (void)starShareInstance;
//关闭所有http
+ (void)stopShareInstance;
//释放所有http
+ (void)freeShareInstance;
//获取本地服务完整路径
+ (NSString*)getLocalHttpUrl:(NSString*)strUrl;
+ (NSString*)getLocalHttpUrl:(NSString*)strUrl session:(int)nSession;
@end

@interface tztlocalHTTPConnection : tztHTTPConnection

@end