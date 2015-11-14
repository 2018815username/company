/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        成交明细
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztHqBaseView.h"

@protocol tztGridViewDelegate;
@interface tztDetailView : tztHqBaseView <tztGridViewDelegate>

@property(nonatomic,retain)UIFont *pDrawFont;
@property(nonatomic,assign)float  fCellHeight;
@property(nonatomic,assign)float  fTopCellHeight;
@property(nonatomic)BOOL bGridLines;
@property(nonatomic)BOOL bShowSeconds;
@property(nonatomic)BOOL bShowTitle;
@property(nonatomic)BOOL bScrollEnabled;
//获取报价数据
- (TNewPriceData*)GetNewPriceData;
- (void)ClearGridData;
@end
