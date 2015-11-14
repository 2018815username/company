/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztPriceView.h
 * 文件标识：
 * 摘    要：报价视图
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


#import <UIKit/UIKit.h>
#import "tztHqBaseView.h"
#import "tztDetailView.h"
@interface tztPriceView : tztHqBaseView
{
    TNewPriceData* _TrendpriceData; //报价数据
    TNewPriceDataEx* _TrendpriceDataEx;//报价数据扩展
    TNewKLineHead* _techData;
}
//报价图类型
@property tztTrendPriceStyle   tztPriceStyle;
@property int                  nAmount;
@property (nonatomic)BOOL                 bHoriShow;
@property(nonatomic,retain)tztDetailView  *pDetailView;
//设置报价数据
- (void)setPriceData:(TNewPriceData*)priceData len:(int)nLen;
- (void)setPriceDataEx:(TNewPriceDataEx*)priceDataEx len:(int)nLen;
//
- (void)setTechHeadData:(TNewKLineHead*)techData len:(int)nLen;
//获取报价数据
- (TNewPriceData*)getPriceData;
//获取扩展数据
- (TNewPriceDataEx*)getPriceDataEx;
@end
