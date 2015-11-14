//
//  tztAutoPushObj.h
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-12-29.
//
//

#import <Foundation/Foundation.h>

@class tztAutoPushObj;

@protocol tztAutoPushDelegate <NSObject>

@optional
 /**
 *	@brief	收到主推数据，通知具体的页面进行主推处理
 *
 *	@param 	sender 	具体数据
 *
 *	@return	无
 */
-(void)didReceiveAutoPushData:(id)sender;


@end
 /**
 *	@brief	行情主推处理，单例模式，iPhone下每个窗口都有一个主推请求，通过添加具体的窗口句柄来进行处理
 */
@interface tztAutoPushObj : NSObject

 /**
 *	@brief	获取单例对象，不存在则自动创建
 *
 *	@return	tztAutoPushObj对象
 */
+(tztAutoPushObj*)getShareInstance;

 /**
 *	@brief	释放数据
 *
 *	@return	无
 */
+(void)freeInstance;

 /**
 *	@brief	设置主推数据
 *
 *	@param 	nsData 	需要主推的股票和市场类型，e.g:600600|4353,000001|4609
 *  股票代码和市场之间用竖线分割，多个代码之间用逗号分割
 *
 *	@return	无
 */
-(void)setAutoPushDataWithString:(NSString*)nsData andDelegate_:(id<tztAutoPushDelegate>)delegate;


 /**
 *	@brief	设置主推数据
 *
 *	@param 	ayData 	股票数据数组，tztStockInfo类型 或者 字典 Code＝代码，Market=市场
 *
 *	@return	无
 */
-(void)setAutoPushDataWithArray:(NSArray *)ayData andDelegate_:(id<tztAutoPushDelegate>)delegate;


 /**
 *	@brief	取消当前主推
 *
 *	@return	无
 */
-(void)cancelAutoPush:(id<tztAutoPushDelegate>)delegate;


@end
