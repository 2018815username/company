/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztTechObj.h
 * 文件标识：
 * 摘    要：K线图单元
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

typedef enum
{
    KLineOutFundNo = 0, //非开放式基金
    KLineOutFund = 1, //开放式基金
    KLineOutFundHB = 1 << 1,//货币基金
}tztKLineOutFund;//开放式基金


@protocol tztTechObjDelegate;
@class tzttechParamSet;
@interface tztTechObj : tztHqBaseView
{
    CGRect      _KLineDrawRect;//数据绘制区域
    CGRect      _KLineParamRect;//参数区域
    NSInteger           _KLineZhibiao;//指标 PKLine VOL MACD
    BOOL  _bIsDrawParams;//zxl 20130730 是否绘制参数数据
    CGFloat  _fKLineViewChangeHeight;//zxl 20130730 K线界面高度调整
    tztKLineOutFund   _kLineOutFund;//场外基金类型
    BOOL _bIsShowCheDan;//zxl 20131223 炒跟不显示撤单控制
}
@property (nonatomic, assign) id<tztTechObjDelegate>  techView;
@property NSInteger  KLineWidth;//K线宽度
@property CGFloat       YAxisWidth;

@property (nonatomic, retain) NSString*   techName;
@property (nonatomic, retain) tzttechParamSet*     techParamSet;
@property (nonatomic, retain) NSMutableArray*      ayParamsValue;
@property (nonatomic, retain) NSMutableArray*      ayTimeAndRect;
@property (nonatomic) CGPoint KLineCursor;
@property double MaxValue;
@property double MinValue;

@property tztKLineAxisStyle KLineAxisStyle; //坐标绘制类型
@property (nonatomic, readonly) NSInteger  KLineZhibiao;//指标 PKLine VOL MACD
@property tztKLineCycle KLineCycleStyle;//周期类型
@property NSInteger       KLineStart;
@property BOOL     bIsDrawParams;
@property CGFloat fKLineViewChangeHeight;
@property tztKLineOutFund kLineOutFund;
@property BOOL     bIsShowCheDan;
@property BOOL     bShowLeftInSide;
@property BOOL     bShowMaxMin;
@property BOOL     bShowObj;
//计算数据
- (void)CalculateValue;
- (BOOL)setDrawcursor:(BOOL)bDrawCursor cursorPoint:(CGPoint)cursor curIndex:(NSInteger)curIndex startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;
//绘制底图
- (BOOL)drawBackGround:(CGRect)rect alpha:(CGFloat)alpha context_:(CGContextRef)context;
- (BOOL)drawBackGround:(CGRect)rect alpha:(CGFloat)alpha;
//绘制
- (void)drawKLine:(CGFloat)alpha;
//设置除数和小数位
- (void)setDiv:(NSInteger)lDiv Decimal:(NSInteger)lDecimal;
//设置指标
- (void)setKLineZhibiao:(NSInteger)nKLineZhiBiao;
//设置K线单元宽度
//需要最少请求数
- (int)getNeedNumber;
//指标初始化
- (void)initZhibiaoData;
//值转字符串
- (NSString*)getValueString:(double)lValue;
//触摸点是否在参数区域
- (BOOL)ParamRectContainsPoint:(CGPoint)touchPoint;
- (CGRect)getDrawRect;
- (void)setKLineCellWidth:(NSInteger)nKLineCellWidth;
//zxl  20130927 ipad 场外基金 Params 显示特殊处理
-(void)onDrawOutFundParams_ipadAdd:(TNewPriceData*)PriceData  KLineHead:(TNewKLineHead *)techHead isHB:(BOOL)isFundHB;

//绘制K线数据图
- (void)onDrawKLineValues:(CGContextRef)context;
//绘制Param线
- (void)onDrawParamLines:(CGContextRef)context;
//绘制坐标
- (void)onDrawAxis:(CGContextRef)context;
//获取数据对应位置
-(CGFloat) ValueToVertPos:(CGRect)drawRect value:(double)lValue;

//时间转字符串
-(NSString*)getTimeString:(long)lTime;
//再次设置各个View的区域
-(void)SetDrawBackGroundRect;
@end

@protocol tztTechObjDelegate <NSObject>
@required
//返回编辑结果
- (NSMutableArray*)tztTechObjAyValue:(tztTechObj *)techObj;
- (NSMutableDictionary*)tztTechObjAyValueTime:(tztTechObj *)techObj;
@end