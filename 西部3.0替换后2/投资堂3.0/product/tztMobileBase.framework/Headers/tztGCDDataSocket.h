/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztGCDAsyncSocket.h
 * 文件标识：
 * 摘    要：通讯类 连接 发送 接收 断开 断开重连
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.02.29
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#if !defined(AFX_GCDDATASOCK_H__72A00C43_42F4_11D1_82CD_0000210E2661__INCLUDED_)
#define AFX_GCDDATASOCK_H__72A00C43_42F4_11D1_82CD_0000210E2661__INCLUDED_

#import <Foundation/Foundation.h>
#import "tztGCDAsyncSocket.h"

#pragma	pack(1)

#define CEV_START_CONNECT	0x0001		//开始连接服务器
#define CEV_CONNECT_PROMPT	0x0100
#define CEV_CONNECT_FAIL	0x0002		//服务器连接失败
#define CEV_CONNECT_SUCC	0x0004		//服务器连接成功
#define CEV_DISCONNECTED	0x0008		//服务器断开连接
#define CEV_ALLCLOSED		0x0010		//关闭所有
#define CEV_RECEIVE_DATA	0x0020		//接收到数据
#define CEV_SEND_DATA		0x0040		//发送数据
#define CEV_IDLE			0x0200
#define CEV_ASK_DATA		0x0400		//DLL ask User for some data.

#define CLX_TS_START	0x0001
#define CLX_TS_MIDDLE   0x0002
#define CLX_TS_END      0x0004
#define CLX_TS_ERROR    0x0008
#define CLX_TS_CANCEL	0x0010

typedef struct CNI_General
{
	NSInteger	 m_nSize;	//
	long m_lCommID;	//
	NSInteger	 m_nEvent;	//
	long m_nLoginSrvType;//
}CNI_General;


typedef struct CNI_ReceiveData
{
	struct CNI_General m_hd;	//
	NSInteger m_nStatus;				//
	BOOL m_bFile;				//
	long m_lDataTotal;			//
	long m_lDataTransmited;		//
	const char* m_pszData;		//if m_bFile is TRUE, m_pszData points to file name
}CNI_ReceiveData,CNI_SendData;


typedef struct CNI_ConnectStatus
{
	struct CNI_General m_hd;	//
	NSInteger m_nStatus;				//
	const char *m_pszText;//
}CNI_ConnectStatus;

#pragma	pack()

//通讯类别
typedef NS_ENUM (NSInteger, tztConnectType)
{
    TZTConnectNo = 0, //无连接
    TZTConnectSocket = 1 << 0, //Socket协议
    TZTConnectHttp = 1 << 1,//http协议
   
};

/**通讯代理*/
@protocol tztSocketDataDelegate<NSObject>
@optional
/**接收到服务器应答数据*/
- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam;//
/**定时请求*/
- (NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam;//
- (NSUInteger)OnNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam;//
- (NSUInteger)OnRequestOnline;
@end

@class tztSendPackage;
@interface tztGCDDataSocket:NSObject<tztGCDAsyncSocketDelegate,NSURLConnectionDelegate>
{
    tztGCDAsyncSocket* _tztAsyncSocket;
    
    __block NSMutableData*  _recedata; //接收数据
    __block NSUInteger _recelen;
    __block NSUInteger _receMax;
    __block long _sendtag;//发送tag
    __block uint32_t _sessionflag;//对话状态

    dispatch_queue_t dataSocketQueue;
    
	NSString* _hostname;//服务器地址
	int _hostport;//服务器端口
	
	tztSendPackage* _sendpack; //当前发送包
	int _ntranstype; //服务器类别
    BOOL _bssl;
    
	id<tztSocketDataDelegate> _delegate;
	int _recount;//重连次数
    
    dispatch_source_t _onlineTimer;
    __block NSTimeInterval theOnlineDate;  //心跳包
    NSLock      *_lock;
}
@property(nonatomic,retain) NSString* hostname;//服务器地址
@property(nonatomic,retain) NSLock  *lock;
@property int hostport;
/***************初始化设置***********************/
- (void)freeDataSocket;
//回调对象
- (id)initWithdelegate:(id<tztSocketDataDelegate>)delegate;
//服务器地址 withPort:端口 TransType:服务器属性 delegate:回调对象
- (id)initwithHost:(NSString*)strAdd withPort:(int)nPort TransType:(int)nTransType delegate:(id<tztSocketDataDelegate>)delegate;
//服务器地址 withPort:端口
- (void)setHost:(NSString*)strAdd withPort:(int)nPort;
//开启SSL
- (void)setSSL:(BOOL)bSSL;
//服务器性质
- (void)setTransType:(int)nTransType;
//回调对象
- (void)setDelegate:(id<tztSocketDataDelegate>)delegate;
/***************判断****************************/
- (int)getnTranstype;
//是交易服务器
- (BOOL)IsExchange;
//已连接服务器
- (BOOL)isConnected;
- (BOOL)isDisConnected;
/***************事件***********************/
//连接
- (BOOL)onConnect;
//断开重连
- (BOOL)onDisReconnect;

//断开连接
- (void)onDisConnect;
//取消请求
- (long)onCancelSendData;
/**************************************/

- (NSUInteger)onSendData:(NSString*)strReq strdefault:(NSString*)strdefault dictValue:(NSMutableDictionary *)sendvalue;

- (long)onSendHostData:(NSData *)hostData withTag:(long)nSendTag;

+ (NSData *)JYData2003; //2003
+ (NSData *)JYData;		// 2011
+ (NSData *)HQData;     // '2003'
+ (NSData *)JYData2013;		// 2003
+ (NSData *)HQData2013;     // 2013
+ (long)HqReqVer;
@end

FOUNDATION_EXPORT BOOL GetHTTPSProxySetting(char *host, size_t hostSize, UInt16 *port);
FOUNDATION_EXPORT void CheckNetStatus();

extern NSMutableDictionary* g_tztintactToServer;
extern tztConnectType   g_nConnectType;
#endif 

