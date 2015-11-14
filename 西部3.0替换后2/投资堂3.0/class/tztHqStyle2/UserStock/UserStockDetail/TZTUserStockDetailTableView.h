//
//  TZTUserStockDetailTableView.h
//  tztMobileApp_GJUserStock
//
//  Created by 在琦中 on 14-3-26.
//
//

#ifndef __TZTBOTTOMOPERATEVIEW_H__
#define __TZTBOTTOMOPERATEVIEW_H__

#import <UIKit/UIKit.h>
#import "TZTStockDetailTittleVeiw.h"
#import "TZTBottomOperateView.h"

@interface TZTUserStockDetailTableView : tztHqBaseView <UITableViewDataSource, UITableViewDelegate, tztHqBaseViewDelegate>

@property(nonatomic,retain)UITableView  *pTableView;
@property(nonatomic, retain)TZTStockDetailTittleVeiw *stockDetailTittleView;
@property(nonatomic, retain)TZTBottomOperateView     *bottomOperateView;

 /**
 *	@brief	设置默认显示（分时、新闻、资金）
 *
 *	@return	无
 */
-(void)SetDefaultSelect;
-(void)ClearData;
@end
#endif
