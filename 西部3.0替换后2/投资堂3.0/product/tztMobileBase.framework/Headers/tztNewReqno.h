/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztNewReqno.h
 * 文件标识：
 * 摘    要：Reqno组成 
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

/**Reqno对象，格式：句柄=请求序号=token类型=token序号=自定义属性
    token类型和tztTradeAccountType定义对应*/
@interface tztNewReqno : NSObject
{
    /**句柄*/
    long _iphonekey;
    /**序号*/
    int _reqno;
    /**token类型*/
    int _tokenkind;
    /**token序号*/
    int _tokenindex;
    /**自定义reqno属性*/
    int _reqdefone;
}
/**根据string生成tztNewReqno对象*/
- (id)initwithString:(NSString *)strNewReqno;
/**根据string生成tztNewReqno对象*/
+ (tztNewReqno *)reqnoWithString:(NSString *)strNewReqno;
/*设置句柄*/
- (void)setIphoneKey:(long)nkey;
/**获取句柄key*/
- (long)getIphoneKey;
/**设置序号*/
- (void)setReqno:(int)nreqo;
/**获取序号*/
- (int)getReqno;
/**设置token类型*/
- (void)setTokenKind:(int)nkind;
/**获取token类型*/
- (int)getTokenKind;
/**设置token序号*/
- (void)setTokenIndex:(int)nindex;
/**获取token序号*/
- (int)getTokenIndex;
/**设置自定义属性*/
- (void)setReqdefOne:(int)nreqdefone;
/**获取自定义属性值*/
- (int)getReqdefOne;
/**获取Reqno NSString*/
- (NSString *)getReqnoValue;

/**转换成reqno NSString*/
+ (NSString *)key:(long)nkey reqno:(int)nreqo;
/**转换成reqno NSString*/
+ (NSString *)key:(long)nkey reqno:(int)nreqo tokenkind:(int)nkind tokenindex:(int)nindex;
/**转换成reqno NSString*/
+ (NSString *)key:(long)nkey reqno:(int)nreqo tokenkind:(int)nkind tokenindex:(int)nindex reqdefone:(int)nreqdefone;

@end

/**通过句柄和请求序号，生成reqno*/
FOUNDATION_EXPORT NSString* tztKeyReqno(long nKey,int nReqno);
/**通过句柄，请求序号，token类型，token序号生成reqno*/
FOUNDATION_EXPORT NSString* tztKeyReqnoToken(long nKey,int nReqno,int tokenkind,int tokenindex);
/**通过句柄，请求序号，token类型，token序号,自定义属性生成reqno*/
FOUNDATION_EXPORT NSString* tztKeyReqnoTokenOne(long nKey,int nReqno,int tokenkind,int tokenindex, int reqdefone);
/**获取请求序号*/
FOUNDATION_EXPORT int tztGetReqno(NSString* strReqno);
/**获取句柄*/
FOUNDATION_EXPORT long tztGetIphoneKey(NSString* strReqno);