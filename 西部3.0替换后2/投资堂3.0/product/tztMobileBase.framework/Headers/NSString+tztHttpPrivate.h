/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：NSString+tztHttpPrivate.h
 * 文件标识：
 * 摘    要：NSString自定义扩展 http应用:下载文件、删除文件、文件crc、文件路径、文件是否加密、文件类型、文件是否存在
 *                           key=value转字典 属性字段分解
 *                           crc文件路径
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
#define TZTICONNAME @"tzticonname" //icon图标名称
#define TZTICONTITLE @"tzticontitle" //icon标题
#define TZTICONMSGTYPE @"tzticonmsgtype" //icon功能号
#define TZTICONCHILD @"tzticonchild" //icon子类
#define TZTICONVALUE @"tzticonvalue" //icon参数值
#define TZTICONINIT  @"tzticoninit"  //icon原始值

typedef NS_ENUM (NSInteger, tztHttpString)
{
    tztHttpMobileSocket = 1, //加密＋CRC
    tztHttpLocal = 1 << 1,  //本地数据
    tztHttpWWW = 1 << 2,    //外网数据
    
    khttpStaticData = 1 << 3, //静态数据
    khttpReqData = 1 << 4, //请求数据
    khttpdeflateData = 1 << 5,//defalte数据
    khttpNoCacheData = 1 << 6,//没有cache时间
};


@interface NSString (tztHttpPrivate)
//获取http文件内容  服务地址 端口 完成处理方法(文件修改日期,数据，数据类型)
- (void)tzthttpfiledownload:(NSString*)host withport:(int)hostport withtype:(tztHttpString)ntype session:(int)nSession complete:(void (^)(NSDate*,NSData*,NSString*,int))completion;

- (void)tzthttpfiledownloadEx:(NSString*)host withport:(int)hostport withtype:(tztHttpString)ntype session:(int)nSession bSSL:(BOOL)bSSL complete:(void (^)(NSDate*,NSData*,NSString*,int))completion;

- (void)tzthttpfilecomplete:(void (^)(NSDate*,NSData*,NSString*,int))completion;
//http文件 删除
- (BOOL)tzthttpfiledel;
//文件 删除
-(BOOL)tztfiledelete;
//http文件 crc值
- (int)tzthttpfilecrc;
- (int)tzthttpfilecrc:(int)nSession;
//返回http RAS文件完整路径
- (NSString*)tztHttpfilepathRSA;
//返回http文件完整路径
- (NSString*)tztHttpfilepath;
//http文件 是否加密
- (BOOL)tzthttpfileIsEnc;
//http文件 http数据类型
- (NSString*)tzthttpfileExptype;
//http参数转换成字典
- (NSMutableDictionary*)tztNSMutableDictionarySeparatedByString:(NSString *)separator decodeurl:(BOOL)bdecodeurl;
- (NSMutableDictionary*)tztNSMutableDictionarySeparatedByString:(NSString *)separator;
- (NSMutableDictionary*)tztPropertySeparatedByString:(NSString *)separator;
- (NSMutableData*)reqReadDataWithDecode:(BOOL)bDecode;
//判断文件是否存在
- (BOOL)FileExists;
- (void)tzthttpKeyValue:(NSString**)strKey value:(NSString**)strValue SeparatedByString:(NSString *)separator;
//http文件 crc保存文件路径
+ (NSString*)tzthttpcrcPath;
+ (NSString*)tzthttpcrcPath:(NSString*)strSession;
+ (NSString*)tztImagePath:(NSString*)strPath name:(NSString*)strName ofType:(NSString*)strExt;
- (NSString*)tztencodeURLString;
- (NSString*)tztdecodeURLString;
//用字典字段值替换对应字段($字段名) 字段名全大写
- (NSString*)tztReplaceWithDictionary:(NSDictionary*)repDictionary options:(NSStringCompareOptions)options;

- (NSString*)tztAppStringValue:(NSString*)strSys;
- (int)tztAppStringInt:(NSString*)strSys;
- (NSString*)tztAppStringValue:(NSString*)strSys value:(NSString*)strValue;
- (int)tztAppStringInt:(NSString*)strSys value:(int)nValue;
- (NSMutableArray *)tztSeparatedByString:(NSString *)separator;

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath;
//计算http缓存的文件大小返回MB
+ (CGFloat)getHTTPRootFloderSize;
//清除缓存文件
+(void)tztHttpFileDeleteAll;

+(NSString*)tztEncryptData:(NSString*)strData;
+(NSString*)tztDescryptData:(NSString*)strData;
@end

