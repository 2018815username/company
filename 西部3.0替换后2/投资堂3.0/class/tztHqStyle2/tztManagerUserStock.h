//
//  tztManagerUserStock.h
//  tztMobileApp_HTSC
//
//  Created by King on 14-9-16.
//
//

#import <UIKit/UIKit.h>

@interface tztManagerUserStock : UIView

@property(nonatomic,assign)id  tztDelegate;
 /**
 *	@brief	选中设置
 *
 *	@param 	nIndex 	位置
 *
 *	@return	0-自选股设置 1-指数设置
 */
-(void)setSelectIndex:(int)nIndex;


@end
