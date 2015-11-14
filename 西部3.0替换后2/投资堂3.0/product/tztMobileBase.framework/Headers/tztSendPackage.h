/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztSendPackage.h
 * 文件标识：
 * 摘    要：通讯类 重发数据包
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.09.20
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <Foundation/Foundation.h>
#import "tztGCDDataSocket.h"

@interface tztSendPackage : NSObject
{
    NSData *_buffer;//发送数据
    long tag;//数据标识
    long    type; //0x11 可取消 需重发
    CFIndex count;//已发送次数
}
//数据 数据标识 重发次数
- (id)initWithData:(NSData *)sendData tag:(long)nTag;
- (id)initWithData:(NSData *)sendData tag:(long)nTag type:(long)nType;
- (long)getTag;
- (BOOL)OnCheckPackage:(long)nTag;
- (CFIndex)OnSendPackage:(long)nTag;
- (long)ReSendData:(tztGCDDataSocket*)sock;
@end
