/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztSystemFunction.h
 * 文件标识：
 * 摘    要：系统级函数
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2013.04.24
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/
#ifndef _TZTMOBILEBASE_tztSystemFunction_H
#define _TZTMOBILEBASE_tztSystemFunction_H

#import <Foundation/Foundation.h>

/**获取当前MobileBase库版本*/
FOUNDATION_EXPORT NSString* GetTztBaseSDKVer();
#pragma mark -压缩，解压，加解密
/**压缩方式*/
FOUNDATION_EXPORT BOOL tztcompress(const char* pZipData,unsigned long* ZipLen, char* pUnZipData,int lOrigLen);

/**压缩方式2，目前使用，若返回FALSE，说明压缩失败。pZipData-压缩后的数据，ZipLen-压缩后长度，pUnZipData-原文，lOrigLen-原文长度*/
FOUNDATION_EXPORT BOOL tztcompress2(const char* pZipData,unsigned long* ZipLen, char* pUnZipData,NSUInteger lOrigLen);

/**解压数据，返回FALSE，说明解压失败。pZipData-压缩数据，ZipLen-压缩数据长度，pUnZipData-原文数据，lOrigLen-原文长度*/
FOUNDATION_EXPORT BOOL tztUncompress(const char* pZipData,long ZipLen, char* pUnZipData,int lOrigLen);

/**Des加解密。key-秘钥，inp-传入数据，outp-处理完成后的数据，len-长度*/
FOUNDATION_EXPORT void DesConvert(const char* key,unsigned char* inp,unsigned char*outp, NSUInteger len);

#pragma mark -文件读写操作
/**g_nsBundlename指定bundle名称*/
/**获取Bundle中指定名称及类型的文件完整路径。fileName-名称，fileType-文件后缀，filedir-所属目录*/
FOUNDATION_EXPORT NSString* GetTztBundlePath(NSString* fileName,NSString* filetype, NSString* filedir);
/**获取g_nsBundlename指定bundle下plist文件夹中对应fileName名称的.plist文件路径*/
FOUNDATION_EXPORT NSString* GetTztBundlePlistPath(NSString* fileName);
/**获取Document中指定名称的文件路径,bCreate=TRUE,则不存在就自动创建*/
FOUNDATION_EXPORT NSString* GetDocumentPath(NSString* fileName,BOOL bCreate);
/**获取Document中指定名称的.plist文件路径,bCreate=TRUE,则不存在就自动创建*/
FOUNDATION_EXPORT NSString* GetPathWithListName(NSString* strFile,BOOL bCreate);
/**设置Document中指定名称的.plist文件内容data*/
FOUNDATION_EXPORT BOOL SetDictByListName(NSDictionary* data,NSString* strFile);
/**获取指定strFile文件中的数据，文件类型.plist*/
FOUNDATION_EXPORT NSMutableDictionary* GetDictByListName(NSString* strFile);
/**设置strFile文件数据*/
FOUNDATION_EXPORT BOOL SetArrayByListName(NSArray* data,NSString* strFile);
/**获取strFile文件数据*/
FOUNDATION_EXPORT NSMutableArray* GetArrayByListName(NSString* strFile);

/**写数据到document目录下的fileName文件中，覆盖原来数据*/
FOUNDATION_EXPORT BOOL writeApplicationDictData(NSDictionary* data,NSString* fileName);
/**从document目录下读取fileName文件内容*/
FOUNDATION_EXPORT NSDictionary* readApplicationDictData(NSString* fileName);

/**在列表ayList中查找对应数据strString，－1表示不存在，其他则返回对应列表中的位置*/
FOUNDATION_EXPORT int FindStringByArray(NSArray* ayList ,NSString* strString);
/**合并两个列表生成新列表 参数:第一个列表 Sencond:第二个列表 NewAy:新生成列表*/
FOUNDATION_EXPORT BOOL MargenStringArray(NSMutableArray* ayFirst,NSMutableArray* aySecond,NSMutableArray* ayNew);

#pragma mark -数据转换
/**double转换成long*/
FOUNDATION_EXPORT long doubletolong(double fValue);
/**时间转换成strin，若NsFormat＝NULL，自动转成ymdhms格式，否则以NsFormat格式转换*/
FOUNDATION_EXPORT NSString* TimeToFormatString(NSString* NsFormat,NSTimeInterval time);
/**获取当前时间，格式：hhmmss*/
FOUNDATION_EXPORT int TZTGetCurrentTime();
/**获取当前日期，格式：yymmdd*/
FOUNDATION_EXPORT int TZTGetCurrentDate();
/**string转换成time，格式y－m－d H：M：S*/
FOUNDATION_EXPORT NSTimeInterval tztStringToTime(int nYear,int nMonth, int nDay,int nHour, int nMin,int nSec, int  nDST);
/**根据time转换成int型时间格式ymdhms*/
FOUNDATION_EXPORT int GetFormatTime(NSString* NsFormat,NSTimeInterval time);
/**写日志文件 若bLog＝FALSE，则不记录*/
FOUNDATION_EXPORT void tztWriteLog(NSString* strlog,BOOL bLog);
/**获取array中指定位置数据*/
FOUNDATION_EXPORT id tztGetDataInArrayByIndex(NSArray* data, int index);
/**拷贝ajax文件，从bundleName的nsFloder下拷贝到对应ajax文件目录*/
FOUNDATION_EXPORT void tztCopyAjaxDataFromBundle(NSString* bundleName, NSString* nsFloder);
/**获取tztCopyAjaxDataFromBundle拷贝后的文件的crc*/
FOUNDATION_EXPORT void tztGetAjaxFileCrc(NSString* strPath, NSMutableDictionary* ayFileCrc);

FOUNDATION_EXPORT NSString *tztExtractFileNameWithoutExtension(const char *filePath, BOOL copy);
FOUNDATION_EXPORT NSComparisonResult compareServerDateCount(NSMutableDictionary *firstValue, NSMutableDictionary *secondValue, void *context);

/**最大网络连接数*/
FOUNDATION_EXPORT int tztSessionMaxIndex();
/**获取对应nSession的索引*/
FOUNDATION_EXPORT int tztIndexOfSession(int nSession);
/**根据nIndex索引获取session*/
FOUNDATION_EXPORT int tztSessionOfIndex(int nIndex);
/**根据session生成对应的key*/
FOUNDATION_EXPORT NSString* tztSessionKey(int nSession);

/**更新bundle*/
FOUNDATION_EXPORT void tztUpdateBundle(void (^block)(NSInteger,NSInteger));
/**下载压缩文件*/
FOUNDATION_EXPORT BOOL onDownLoadZipFile(NSString* strZip ,NSString* strPath);
/**读取appstrings的配置*/
FOUNDATION_EXPORT void tztAppInitStrings(BOOL reload);

FOUNDATION_EXPORT void tztSetUserData(NSString* strKey,NSString* strValue);
FOUNDATION_EXPORT NSString* tztGetUserData(NSString* strKey);
FOUNDATION_EXPORT NSBundle* tztAppStringBundle(NSString* strSys);
FOUNDATION_EXPORT NSString* tztAppStringValue(NSString* strSys,NSString* strKey,NSString* strDefault);
FOUNDATION_EXPORT int tztAppStringInt(NSString* strSys,NSString* strKey,int nDefault);
FOUNDATION_EXPORT NSString* tztAppSysValueWithDefault(NSString* strKey,NSString* strDefault);
FOUNDATION_EXPORT int tztAppSysIntValueWithDefault(NSString* strKey,int nDefault);
FOUNDATION_EXPORT NSString* tztAppSysValue(NSString* strKey);
FOUNDATION_EXPORT int tztAppSysIntValue(NSString* strKey);

#if TARGET_OS_IPHONE
FOUNDATION_EXPORT UIInterfaceOrientation tztInterfaceOrientation(void);
FOUNDATION_EXPORT CGRect tztScreenBounds(void);
FOUNDATION_EXPORT CGSize tztScreenModeSize(void);
FOUNDATION_EXPORT NSString* tztScreenModeStrSize(void);
FOUNDATION_EXPORT CGFloat tztStatusBarHeight(void);
#endif

#endif