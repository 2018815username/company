//
//  tztUIHKBuySellViewController.h
//  tztMobileApp_HTSC
//
//  Created by King on 14-9-16.
//
//

#import "TZTUIBaseViewController.h"

 /**
 *	@brief	港股通买卖vc
 */
@interface tztUIHKBuySellViewController : TZTUIBaseViewController


 /**
 *	@brief	买卖区分标识，默认TRUE－买入
 */
@property(nonatomic)BOOL    bBuyFlag;

 /**
 *	@brief	可直接传入代码操作，默认为@"";
 */
@property(nonatomic,retain)NSString*    CurStockCode;

-(void)OnRequestData;
@end
