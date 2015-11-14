/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztBase.h
 * 文件标识：
 * 摘    要：tztBase头文件集-可实现扩展函数 详见tztBase+Exten
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

#ifndef tztMobileBase_tztBase_h
#define tztMobileBase_tztBase_h
#if TARGET_OS_IPHONE

#import <tztMobileBase/tztNewReqno.h>
#import <tztMobileBase/tztMoblieStockComm.h>
#import <tztMobileBase/tztNewMSParse.h>

#import <tztMobileBase/tztHTTPData.h>
#import <tztMobileBase/TZTServerListDeal.h>
#import <tztMobileBase/tztOpenUDID.h>
#import <tztMobileBase/tztDataBase.h>
#import <tztMobileBase/tztCachingURLProtocol.h>
#else

#import <tztMacOSBase/tztNewReqno.h>
#import <tztMacOSBase/tztMoblieStockComm.h>
#import <tztMacOSBase/tztNewMSParse.h>

#import <tztMacOSBase/tztHTTPData.h>
#import <tztMacOSBase/TZTServerListDeal.h>
#import <tztMacOSBase/tztOpenUDID.h>
#import <tztMACOSBase/tztSystemFunction.h>
#endif

#endif
