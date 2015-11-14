/*
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztStockInfo.h
 * 文件标识：
 * 摘    要：股票信息
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
/**
 *  股票信息
 */
@interface tztStockInfo : NSObject
{
    NSString*   _stockCode;
    NSString*   _stockName; //股票名称
    int         _stockType; //市场类型
 
    //增加 开闭市时间，用于判断
}
/**
 *  股票名称
 */
@property(nonatomic, retain)NSString* stockCode;
/**z
 *  股票代码
 */
@property(nonatomic, retain)NSString* stockName;

@property(nonatomic, retain)NSString* tradeUnit; //交易单元（对方席位）
@property(nonatomic, retain)NSString* appointmentSerial; //约定序号

/**
 *  市场类型
 */
@property int   stockType;
/**
 *  检查是否是有效的股票信息
 *
 *  @return 是－TRUE，否－FALSE
 */
- (BOOL)isVaildStock;
/**
 *  获取当前股票信息，并且以字典形式返回
 *
 *  @return 股票信息字典
 */
- (NSMutableDictionary*)GetStockDict;
/**
 *  设置股票信息，以字典形式传入
 *
 *  @param stockDict 股票信息字典 key:Name(名称)， Code(代码) StockType(市场类型)，注意大小写
 */
- (void)setStockDict:(NSDictionary*)stockDict;
@end