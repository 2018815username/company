/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztReportListView.h
 * 文件标识：
 * 摘    要：报价排名列表
 *
 * 当前版本： 2.0
 * 作    者：yangdl
 * 完成日期： 2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "tztBlockIndexInfo.h"

@class TZTUIReportGridView;
@protocol tztGridViewDelegate;
#ifndef __TZTREPORTLISTVIEW_H__
#define __TZTREPORTLISTVIEW_H__
@interface tztReportListView : tztHqBaseView <tztGridViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,retain) TZTUIReportGridView    *reportView;
@property (nonatomic,retain) NSString* reqAction; //功能号
@property (nonatomic,retain) NSString* nsDefautlOrderType;//默认排序方式
@property (nonatomic)int           fixRowCount;
@property NSInteger           startindex; //起始序号
@property NSInteger           reqchange;  //请求变更数
@property NSInteger           accountIndex; //排序字段
@property BOOL          direction; // YES涨 NO跌
@property BOOL          bFlag;
@property (nonatomic) NSInteger           nReportType;//
@property (nonatomic,retain) NSMutableArray *ayStockData;

-(void) setCurrentIndex:(NSInteger)nIndex;
-(void)tztShowNewType; //设置新类型请求，重新设置各类请求参数
-(NSArray*)tztGetPreStock;  //取上一股票
-(NSArray*)tztGetCurStock;  //取当前股票
-(NSArray*)tztGetNextStock; //取下一股票

-(CGRect)getLeftTopViewFrame;
@end
#endif