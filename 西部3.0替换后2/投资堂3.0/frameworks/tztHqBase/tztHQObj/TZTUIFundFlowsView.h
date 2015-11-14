/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资金流向界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztHqBaseView.h"

@interface TZTUIFundFlowsView : tztHqBaseView

@property (nonatomic ,retain) NSMutableArray * ayFundFlowsValues;
@property (nonatomic ,retain) NSString*        pPreStockCode;
@property int nMaxCount;
@property float fLeftWidth;
@property CGPoint pCurPoint;
@property BOOL bCursorLine;
- (void)onRequestData:(BOOL)bShowProcess;
//str 转 float
- (float)NSstringChangFloat:(NSString *)Value;
//截取字符
-(NSString *)ValueSubstring:(NSString *)Value;
//绘制2点之间的线
-(void)DrawLine:(CGContextRef)context FirstPoint_:(CGPoint)firstpoint SecondPoint_:(CGPoint)secondpoint Color_:(UIColor *)color;
-(float)GetLeftMargin;
@end
