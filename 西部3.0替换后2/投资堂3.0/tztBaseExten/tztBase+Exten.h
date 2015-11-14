//
//  NSObject+tztBase_Exten.h
//  tztMobileApp
//
//  Created by yangares on 13-6-18.
//
//
#ifndef tztMobileApp_tztBase_Exten_h
#define tztMobileApp_tztBase_Exten_h

#import <Foundation/Foundation.h>
#import <tztMobileBase/tztBase.h>

@interface tztMoblieStockComm (tztBaseExten)
- (void)addTztCommHead:(NSMutableDictionary*)sendValue;
- (void)addTztCommJYHead:(NSMutableDictionary*)sendValue;
+ (void)AddCommHead:(NSMutableDictionary*)sendValue;
+ (void)AddCommJYHead:(NSMutableDictionary*)sendValue;
+ (void)AddCommJYHead:(NSMutableDictionary*)sendValue withTokenType:(int)nTokenType;
@end

@interface tztNewMSParse (tztBaseExten)
- (void)SetCommToken;
@end


@interface tztHTTPData (tztBaseExten)
- (BOOL)isHttpFilterKey:(NSString*)strKey;
- (id)getHTTPJYLoginInfo:(int)nTokenType;
- (NSString *)getlocalValueExten:(NSString*)strKey withJyLoginInfo:(id)logininfo;
- (BOOL)setlocalValueExten:(NSMutableDictionary*)dictValue;
@end


@interface TZTServerListDeal (tztBaseExten)
//设置配置服务器地址
- (void)setSysConfigServerAdd;
//设置配置服务器端口
- (void)setSysConfigServerPort;
//设置均衡服务器地址
- (void)setSysConfigJHServerAdd;
@end
#endif