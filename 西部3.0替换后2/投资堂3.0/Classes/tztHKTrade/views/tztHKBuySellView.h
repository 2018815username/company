//
//  tztHKBuySellView.h
//  tztMobileApp_HTSC
//
//  Created by King on 14-9-16.
//
//

#import "tztBaseTradeView.h"

 /**
 *	@brief	港股通买卖view
 */
@interface tztHKBuySellView : tztBaseTradeView

 /**
 *	@brief	买卖表示区分，FALSE-卖出 TRUE-买入，默认TRUE
 */
@property(nonatomic)BOOL bBuyFlag;



 /**
 *	@brief	外部直接传入设置股票代码
 *
 *	@param 	strCode 	代码
 *
 *	@return	无
 */
-(void)setStockCode:(NSString*)strCode;

@end
