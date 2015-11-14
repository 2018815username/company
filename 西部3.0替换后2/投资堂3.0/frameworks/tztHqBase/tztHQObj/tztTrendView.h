/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztTrendView.h
 * 文件标识：
 * 摘    要：分时视图
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
#import "tztPriceView.h"
#import "TZTUIFundFlowsView.h"


//通讯类别
typedef enum tztTrendReqType
{
    tztTrendFirst = 1 << 0, //首次
    tztTrendAdd = 1 << 1, //增量
}tztTrendReqType;

//分时数据
@interface tztTrendValue:NSObject
@property unsigned long ulClosePrice;      //最新价，单位：厘
@property unsigned long ulAvgPrice;      //均价，单位：厘
@property int32_t nTotal_h;     //分钟成交量
@property int nLead;
@property int nChiCangL;
- (BOOL)isVaild;
@end

@interface tztTrendView :tztHqBaseView<tztHqBaseViewDelegate>
{
    tztPriceView* _tztPriceView; //报价图    
}

@property (nonatomic, retain) NSString*   trendEndDate;

@property int         nMaxCount;      //最大数据数

@property CGFloat     fYAxisWidth;    //Y轴宽度

@property TNewTrendHead* TrendHead;   //分时头数据

@property int32_t     nMaxVol;        //量

@property int32_t     nMaxChiCangL;   //持仓量

@property int32_t     nMinChiCangL;   //持仓量 （期货才有）

@property TNewPriceData *PriceData;  //报价数据
@property TNewPriceDataEx *PriceDataEx;

@property (nonatomic, retain) NSString*   trendTimes;

@property (nonatomic,retain) UIButton      *pBtnNoRights;//无权限时显示
@property (nonatomic,retain) tztUISwitch   *pBtnDetail;//港股委托队列
@property BOOL          bHide;        //是否隐藏报价图
@property (nonatomic,retain) tztPriceView   *tztPriceView;
@property BOOL          bPercent;     //是否百分比

@property CGRect      TrendDrawRect;  //分时图区域
@property CGRect      VolParamRect;   //量图参数区域
@property CGRect      VolDrawRect;    //量图区域
@property CGRect      PriceDrawRect;  //报价图区域

@property CGRect      FundFlowsRect; //资金流向区域

@property NSInteger         TrendCurIndex;  //当前序号

@property(nonatomic,retain)TZTUIFundFlowsView * tztFundFlows;//ipone的资金流向 上证BBD 深圳BBD在分时界面上添加

 /**
 *	@brief	分时数据
 */
@property (nonatomic, retain) NSMutableArray*     ayTrendValues;

 /**
 *	@brief	信息地雷
 */
@property (nonatomic, retain) NSMutableArray*     ayTrendInfo;

 /**
 *	@brief	分时图 带报价图状态,具体见tztTrendPriceStyle定义
 */
@property (nonatomic) tztTrendPriceStyle   tztPriceStyle;

 /**
 *	@brief	是否显示分时量，默认FALSE
 */
@property BOOL bHideVolume;

 /**
 *	@brief	是否隐藏资金流向，默认隐藏YES
 */
@property BOOL bHideFundFlows;

 /**
 *	@brief	是否绘制光标
 */
@property BOOL bTrendDrawCursor;

 /**
 *	@brief	是否支持绘制光标
 */
@property BOOL bSupportTrendCursor;

 /**
 *	@brief	<#Description#>
 */
@property BOOL bShowMaxMinPrice;

 /**
 *	@brief  是否显示指数领先指标
 */
@property BOOL bShowLeadLine;

 /**
 *	@brief	是否显示均价线
 */
@property BOOL bShowAvgPriceLine;

 /**
 *	@brief	是否显示右侧涨跌幅
 */
@property BOOL bShowRightRatio;

 /**
 *	@brief	左侧价格宽度
 */
@property int  nPriceViewWidth;

 /**
 *	@brief 是否在分时图内显示左侧价格数据
 */
@property BOOL bShowLeftPriceInSide;

 /**
 *	@brief	是否显示光标所在位置数据框
 */
@property BOOL bShowTips;

@property BOOL bIgnorTouch;
 /**
 *	@brief	隐藏时间轴
 */
@property BOOL bHiddenTime;

@property (nonatomic)BOOL bHoriShow;


-(TNewPriceData*)GetNewPriceData;
-(TNewTrendHead*)GetNewTrendHead;
//和资金流向界面交互用
-(void)ShowFenshiCurLine:(BOOL)show Point:(CGPoint)point;
- (void)onClearData;
- (NSString*)getValueString:(long)lValue;

//绘制坐标
- (void)onDrawXAxis:(CGContextRef)context;
- (void)onDrawYAxis:(CGContextRef)context;


-(void)trendTouchMoved:(CGPoint)point bShowCursor_:(BOOL)bShowCursor;
@end
