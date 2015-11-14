/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztNewMSParse.h
 * 文件标识：
 * 摘    要：数据处理
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
/**tztNewMSParse 数据解析对象*/
@interface tztNewMSParse : NSObject

/**接收到的数据，解析后的字典*/
@property(nonatomic,retain) NSMutableDictionary     *dictvalue;

/**设置字典内容*/
- (void)setActionAns2013:(NSData*)recvdata;
/**直接获取二进制数据*/
- (NSData*)GetNSData:(NSString*)strKey;
/**通过base64解码获取数据*/
- (NSData*)GetNSDataBase64:(NSString*)strKey;
/**通过字段名称获取相应的值*/
- (NSString *)GetValueData:(NSString*)strKey;
/**通过字段名称获取相应的值*/
- (int)GetIntByName:(NSString*)strKey;
/**通过字段名称获取相应的值*/
- (NSString*)GetByName:(NSString*)strKey;
/**通过字段名称获取相应的Unicode编码数据*/
- (NSString*)GetByNameUnicode:(NSString*)strKey;
/**通过字段名称获取相应的GBK编码数据*/
- (NSString*)GetByNameGBK:(NSString*)strKey;
/**通过字段名称获取相应数组数据*/
- (NSArray*)GetArrayByName:(NSString *)strKey;

/**获取请求号Reqno*/
- (int)GetReqno;
/**获取Token值*/
- (NSString*)GetToken;
/**获取错误号ErrorNo ,通常情况下，errno < 0 认为失败， >= 0 成功；特殊约定除外*/
- (int)GetErrorNo;
/**获取错误信息*/
- (NSString *)GetErrorMessage;
/**获取功能号*/
- (int)GetAction;
/**判断是否是某一功能号*/
- (int)IsAction:(NSString*)strAction;
/**是交易登录, 目前只判断了普通登录和融资融券登录*/
- (int)IsAllJyLogin;
/**判断是否是数据当前界面*/
- (int)IsIphoneKey:(long)nKey reqno:(int)nReqno;
/**将接收到的数据转换成json格式*/
- (NSDictionary*)GetJsonData;

/**上传日志信息*/
+(void)UpLoadLogInfo:(NSString*)strLog;
/**将接收到的数据存储到指定路径*/
- (BOOL)WriteParse:(NSString *)strPath;
/**从指定路径读取存储的数据*/
- (void)ReadParse:(NSString *)strPath;
@end
