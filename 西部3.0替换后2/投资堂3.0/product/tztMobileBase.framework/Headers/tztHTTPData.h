/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztHTTPData.h
 * 文件标识：
 * 摘    要：tztHTTPData 替换数据
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

@interface tztHTTPData : NSObject
{
    NSMutableDictionary* _httplocalvalue;//本地保存扩展
    NSMutableDictionary* _httpmapvalue; //web要求保存字段
}
+ (tztHTTPData *)getShareInstance;
+ (void)freeShareInstance;
+ (BOOL)isHttpUseAddKey:(NSString*)strKey;
//
- (void)setLocalValue:(NSMutableDictionary*)dictValue;
- (void)setlocalValue:(NSString*)strKey withValue:(NSString *)strValue;
- (NSString *)getlocalValue:(NSString*)strKey;
//
- (void)setMapValue:(NSMutableDictionary*)dictValue;
- (NSMutableDictionary *)getMapValue;
- (NSString *)getmapValue:(NSString*)strKey;

+ (BOOL)getlocalValue:(NSMutableDictionary*)value withValue:(NSMutableDictionary*)orgValue AtTokenType:(int)nTokenType;
+ (BOOL)replaceValue:(NSMutableDictionary*)replacevalue withValue:(NSMutableDictionary*)orgValue AtTokenType:(int)nTokenType;
@end

/*httpdelegate*/
@protocol tztHTTPData <NSObject>
@optional

/*
 第三方库使用自定义替换使用
 */
//httpserver替换本地数据扩展，可自定义
- (id)getlocalOtherValue:(NSString*)strKey withJyLoginInfo:(id)logininfo;
//发送请求统一数据头添加，可自定义
- (void)AddJYCommHeaderEx:(NSMutableDictionary*)sendValue withTokenType_:(NSString*)nsTokenType;

@end