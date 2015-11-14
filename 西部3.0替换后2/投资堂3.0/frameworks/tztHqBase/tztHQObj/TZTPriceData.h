//
//  TZTPriceData.h
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 3/31/14.
//
//

#import <Foundation/Foundation.h>
@interface TZTPriceData : NSObject

NSMutableDictionary* GetDictWithValue(NSString* nsValue, int fValue, int fCompare);
 /**
 *	@brief	解析（沪深指数） pNewPriceData并将解析结果以字典形式放到pReturnDict返回使用
 *
 *	@param 	pNewPriceData 	报价数据结构
 *	@param 	pReturnDict 	解析后的数据key－value形式
 *
 *	@return	无
 */
+ (void)dealWithIndexPrice:(TNewPriceData*)pNewPriceData pDict_:(NSMutableDictionary*)pReturnDict;

 /**
 *	@brief	解析（沪深个股） pNewPriceData并将解析结果以字典形式放到pReturnDict返回使用
 *
 *	@param 	pNewPriceData 	报价结构数据
 *	@param 	pReturnDict 	解析后的数据
 *
 *	@return	无
 */
+ (void)dealWithStockPrice:(TNewPriceData*)pNewPriceData andType_:(int)nType pDict_:(NSMutableDictionary*)pReturnDict;

 /**
 *	@brief	解析（港股数据）
 *
 *	@param 	pNewPriceData 	报价结构数据
 *  @param  nUnit           单位
 *	@param 	pReturnDict 	解析后的数据
 *
 *	@return	无
 */
+ (void)dealWithHKStockPrice:(TNewPriceData*)pNewPriceData andUnit_:(int)nUnit pDict_:(NSMutableDictionary*)pReturnDict;

 /**
 *	@brief	解析板块指数报价数据
 *
 *	@param 	pNewPriceData 	报价结构
 *	@param 	pReturnDict 	字典返回
 *
 *	@return	无
 */
+(void)DealWithBlockIndexPice:(TNewPriceData*)pNewPriceData pDict_:(NSMutableDictionary*)pReturnDict;

 /**
 *	@brief	解析期货数据
 *
 *	@param 	pNewPriceData 	报价结构
 *	@param 	pReturnDict 	字典返回
 *
 *	@return	无
 */
+(void)dealWithQHStockPrice:(TNewPriceData*)pNewPriceData andHand_:(int)nHand pDict_:(NSMutableDictionary*)pReturnDict;

 /**
 *	@brief	解析外盘数据
 *
 *	@param 	pNewPriceData 	报价结构
 *	@param 	pReturnDict 	字典返回
 *
 *	@return	无
 */
+(void)dealwithWPStockPrice:(TNewPriceData*)pNewPriceData pDict_:(NSMutableDictionary*)pReturnDict;


+ (NSMutableDictionary *)stockDic;
+ (void)setStockDic:(NSMutableDictionary *)dic;

@end
