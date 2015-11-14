/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztMoblieStockComm.h
 * 文件标识：
 * 摘    要：通讯调度相关对象 加入通讯对象、删除通讯对象 发送请求
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

#import <Foundation/Foundation.h>
#import "tztGCDDataSocket.h"


//2011协议 读取通讯数据协议字典时使用
#define TZTFormatReq @"req"
#define TZTFormatAns @"ans"
#define TZTFormatUnicode   @"unicode"
#define TZTFormatGBKcode   @"gbk"

@interface tztMoblieStockComm :NSObject <tztSocketDataDelegate>
{
    tztGCDDataSocket* _tztGCDDataSocket;
    int _ntranstype; //服务器类别
    BOOL _bCanSend;
    NSMutableArray* _ayObjList;//对象列表
    NSDictionary* _reqAns; //2011协议 通讯数据协议字典
    
    dispatch_source_t _sendTimer;
    CGFloat  _fTimeCount;//计数
    int _recount;//重连次数
    BOOL _bOpenSSL;
}
//通讯管理静态对象
/**根据session获取通讯对象，session参考tztSessionType定义*/
+ (tztMoblieStockComm *)getShareInstance:(int)nSession;
+ (tztMoblieStockComm *)getInstance:(int)nSession;
+ (void)freeShareInstance:(int)nSession;

/**交易通讯*/
+ (tztMoblieStockComm *)getShareInstance;
+ (tztMoblieStockComm *)getInstance tzt_DEPRECATED;
+ (void)freeShareInstance;

/**行情通讯*/
+ (tztMoblieStockComm *)getSharehqInstance;
+ (tztMoblieStockComm *)gethqInstance tzt_DEPRECATED;
+ (void)freeSharehqInstance;

/**均衡通讯*/
+ (tztMoblieStockComm *)getSharejhInstance;
+ (tztMoblieStockComm *)getjhInstance tzt_DEPRECATED;
+ (void)freeSharejhInstance;

/**资讯通讯*/
+ (tztMoblieStockComm *)getSharezxInstance;
+ (tztMoblieStockComm *)getzxInstance tzt_DEPRECATED;
+ (void)freeSharezxInstance;

/**开户通讯*/
+ (tztMoblieStockComm *)getSharekhInstance;
+ (tztMoblieStockComm *)getkhInstance tzt_DEPRECATED;
+ (void)freeSharekhInstance;

/**清空所有连接*/
+ (void)freeAllInstanceSocket;
+ (void)freeAllCommInstance;
/**重连连接*/
+ (void)getAllInstance;

/**初始化链接*/
- (void)onInitGCDDataSocketWithBlock:(void (^)(void))completion;
/**初始化链接*/
- (void)onInitGCDDataSocket;
/**释放*/
- (void)freeSocketComm;
/**是否使用ssl ＝TRUE，使用*/
- (void)setOpenSSL:(BOOL)bSSL;
/**地址端口更改通知函数*/
- (void)onChangeHostPort:(NSNotification*)notifaction;
/***/
- (BOOL)setStockHostPort;
- (void)setStockHostPort:(NSString*)nsHost nPort_:(UInt32)nPort;
/**加入通讯调度列表,只有在调度列表中，才能响应tztSocketDataDelegate中的相关协议处理*/
- (void)addObj:(id<tztSocketDataDelegate>)obj;
/**从调度列表删除对象*/
- (void)removeObj:(id<tztSocketDataDelegate>)obj;
/**发送数据 参数:请求参数列\参数默认值\参数数据*/
- (NSUInteger)onSendDataAction:(NSString*)strAction withDictValue:(NSMutableDictionary *)sendvalue;
- (NSUInteger)onSendDataAction:(NSString*)strAction withDictValue:(NSMutableDictionary *)sendvalue bShowProcess:(BOOL)bShowProcess;
@end

