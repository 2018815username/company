/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztHqBaseView.h
 * 文件标识：
 * 摘    要：行情基类视图 通讯 通用参数定义
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期： 2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "tztTechObjBase.h"
#import "tztUserStock.h"
#import "tztAutoPushObj.h"

extern int g_nHQBackBlackColor;//
extern int g_nHKShowTenPrice;//港股十档显示，默认关闭
extern int g_nHKHasRight;//港股强制拥有权限，默认没有
extern BOOL g_bUseHQAutoPush;//行情主推，默认关闭
 /**
 *	@brief	默认报价显示高度
 */
#define tztQuoteViewHeight 60



 /**
 *	@brief	快速买入btn tag值
 */
#define tztBtnTradeBuyTag 0x4000

 /**
 *	@brief	快速卖出btn tag值
 */
#define tztBtnTradeSellTag 0x4001

 /**
 *	@brief	快速撤单btn tag值
 */
#define tztBtnTradeDrawTag 0x4002

 /**
 *	@brief	预警btn tag值
 */
#define tztBtnWarningTag 0x4003

 /**
 *	@brief	持仓btn tag值
 */
#define tztBtnStockTag 0x4004


@class tztSocketDataDelegate;
 /**
 *	@brief	行情协议
 */
@protocol tztHqBaseViewDelegate<NSObject>

@optional
 /**
 *	@brief	更新数据
 *
 *	@param 	obj 	id，根据不同类型处理
 *
 *	@return	NULL
 */
-(void)UpdateData:(id)obj;

 /**
 *	@brief	行情view刷新显示
 *
 *	@param 	hqview 	需要刷新显示的行情view
 *
 *	@return	NULL
 */
-(void)tzthqViewNeedsDisplay:(id)hqview;

 /**
 *	@brief	设置股票代码
 *
 *	@param 	hqView 	获取代码的view
 *	@param 	pStock 	获取到的代码，tztStockInfo类型
 *
 *	@return	NULL
 */
-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo*)pStock;

 /**
 *	@brief	添加或删除自选股
 *
 *	@param 	hqView 	获取代码的view
 *	@param 	pStock 	获取到的代码，tztStockInfo类型
 *
 *	@return	NULL
 */
-(void)tzthqView:(id)hqView AddOrDelStockCode:(tztStockInfo*)pStock;

 /**
 *	@brief	请求历史分时数据
 *
 *	@param 	hqView 	当前的view
 *	@param 	pStock 	获取到的代码，tztStockInfo类型
 *	@param 	nsHisDate 	获取历史分时数据的日期
 *
 *	@return	NULL
 */
-(void)tzthqView:(id)hqView RequestHisTrend:(tztStockInfo*)pStock nsHisDate:(NSString*)nsHisDate;

 /**
 *	@brief	//获取历史分时时的日期
 *
 *	@param 	hqView 	行情view
 *	@param 	nDirection 	方向，0-向前取一天，1-向后取一天
 *
 *	@return	历史分时的日期，20141010类型格式
 */
-(NSString*)GetHisDate:(id)hqView direction:(UInt16)nDirection;

 /**
 *	@brief	历史分时左右滑动切换
 *
 *	@param 	nDirection 	滑动方向，0-前一天，1-后一天
 *
 *	@return	NULL
 */
-(void)tztUIHisTrendChanged:(UInt16)nDirection;

//IPAD 
-(void)tzthqView:(id)hqView MaxCount:(int)maxcount LeftWidth:(int)width;
-(void)ShowZJLXCurLine:(BOOL)show Point:(CGPoint)point;
-(void)MoveZJLXCurLine:(CGPoint)point;
-(void)ShowFenshiCurLine:(BOOL)show Point:(CGPoint)point;
-(void)MoveFenshiCurLine:(CGPoint)point;

 /**
 *	@brief	 // 显示横屏分时（国金适用）
 *
 *	@param 	view 	当前view
 *
 *	@return	NULL
 */
- (BOOL)showHorizenView:(UIView*)view;

 /**
 *	@brief	 // 横屏分时标题Seg选择
 *
 *	@param 	index 	选择位置
 *
 *	@return	NULL
 */
- (void)selectedSeg:(NSInteger)index;

 /**
 *	@brief	更新报价显示（国金适用）
 *
 *	@param 	hide 	是否显示
 *
 *	@return	NULL
 */
- (void)upDateUserStockTitleContent:(BOOL)hide;

 /**
 *	@brief	//快速买卖
 *
 *	@param 	send
 *	@param 	nType 	类型， 见顶部的tztBtnxxxxTag定义
 *
 *	@return	NULL
 */
-(void)tztQuickBuySell:(id)send nType_:(NSInteger)nType;

 /**
 *	@brief	//关闭自动刷新  ipad打开历史分时时候，关闭自动刷新功能，否则会有问题
 *
 *	@param 	bStop 	是否关闭
 *
 *	@return	NULL
 */
-(void)tztStopRequest:(BOOL)bStop;



/**
 *	@brief	详情报价点击事件处理
 *
 *	@param 	sender 	当前view
 *	@param 	bClose 	展开还是收缩
 *
 *	@return	无
 */
-(void)tztDetailHeader:(id)sender OnTapClicked:(BOOL)bExpand;

 /**
 *	@brief	点击时间，包括双击，上层处理
 *
 *	@param 	hqView 	当前点击的view
 *	@param 	nClickTimes 	点击次数
 *
 *	@return	null
 */
-(void)tztHqView:(id)hqView clickAction:(NSInteger)nClickTimes;

/**
 *  板块点击事件处理
 *
 *  @param hqView hqview
 *  @param info   板块信息，字典形式返回 tztAction:发送功能号，tztParams:发送参数
 */
-(void)tztHqView:(id)hqView OnBlcokClick:(NSDictionary*)info;

-(void)tztHqView:(id)hqView setTitleStatus:(NSInteger)nStatus andStockType_:(NSInteger)nType;

-(void)tztHqView:(id)hqView SetCursorData:(id)pData;

-(void)tztHqView:(id)hqView ShowCursorTipsView:(BOOL)bShow;

-(void)tztBlockIndexInfo:(id)view updateInfo_:(NSMutableArray*)pArray;

-(void)tztSearchStockBeginScroll;
@end


 /**
 *	@brief	行情处理view基类
 */
@interface tztHqBaseView : UIView <tztSocketDataDelegate, tztAutoPushDelegate>
{
     /**
     *	@brief	请求序号
     */
    UInt16 _ntztHqReq;

     /**
     *	@brief	是否刷新请求数据
     */
    BOOL _bRequest;

     /**
     *	@brief	代理
     */
    id<tztHqBaseViewDelegate> _tztdelegate;

     /**
     *	@brief	当前的股票代码
     */
    tztStockInfo    *_pStockInfo;
    
     /**
     *	@brief	请求数据时的背景（表格时有用）
     */
    NSString*   _nsBackColor;//

}
@property (nonatomic, assign) id<tztHqBaseViewDelegate> tztdelegate; //回调接口
@property (nonatomic, retain) NSString* nsBackColor; //底色
@property (nonatomic) BOOL bRequest; //是否自动刷新
@property (nonatomic, retain) tztStockInfo* pStockInfo;
@property (nonatomic, assign) BOOL  bAutoPush;//是否主推。默认关闭
 /**
 *	@brief	是否需要添加手势处理
 */
@property (nonatomic)BOOL bAddSwipe;

 /**
 *	@brief	设置是否自动刷新请求数据
 *
 *	@param 	bRequest 	bRequest; TRUE-自动刷新数据 FALSE－不刷新
 *
 *	@return	NULL
 */
- (void)onSetViewRequest:(BOOL)bRequest;

 /**
 *	@brief	初始化页面数据
 *
 *	@return	NULL
 */
- (void)initdata;

 /**
 *	@brief	清空数据
 *
 *	@return	NULL
 */
- (void)onClearData;

 /**
 *	@brief	设置代码并请求数据
 *
 *	@param 	pStockInfo 	股票代码结构 具体查看tztStockInfo
 *	@param 	nRequest 	是否发起请求 0-只设置代码，不请求数据 1-设置代码，并请求数据
 *
 *	@return	NULL
 */
-(void)setStockInfo:(tztStockInfo*)pStockInfo Request:(int)nRequest;

 /**
 *	@brief	设置代码并请求数据
 *
 *	@param 	strStockCode 	股票代码，NSString类型
 *	@param 	nRequest 	是否发起请求 0-只设置代码，不请求数据 1-设置代码，并请求数据
 *
 *	@return	NULL
 */
-(void)setStockCode:(NSString*)strStockCode Request:(int)nRequest;

 /**
 *	@brief	请求数据
 *
 *	@param 	bShowProcess 	是否显示进度条，或者网络加载标识（暂时忽略）
 *
 *	@return	NULL
 */
- (void)onRequestData:(BOOL)bShowProcess;

- (void)onRequestDataAutoPush;
 /**
 *	@brief	获取当前股票
 *
 *	@return	tztStockInfo结构
 */
-(tztStockInfo*)GetCurrentStock;

@end

 /**
 *	@brief	数据内容
 */
#define tztValue                @"tztValue"

 /**
 *	@brief	内容颜色
 */
#define tztColor                @"tztColor"
 /**
 *	@brief	代码
 */
#define tztCode                 @"Stock_Code"
#define tztName                 @"Stock_Name"               //名称
#define tztYesTodayPrice        @"Stock_YesTodayPrice"      //昨收价，期货昨结算
#define tztQhYesTodayPrice      @"Stock_QhYesTodayPrice"    //期货昨收价
#define tztNewPrice             @"Stock_NewPrice"           //最新价
#define tztMaxPrice             @"Stock_MaxPrice"           //最高价
#define tztTradingPrice         @"Stock_TradingPrice"       //涨停价
#define tztLimitPrice           @"Stock_LimitPrice"         //跌停价
#define tztDTK                  @"Stock_DTK"                //多头开
#define tztKTK                  @"Stock_KTK"                //空头开
#define tztNowVolume            @"Stock_NowVolume"          //现手
#define tztHuanShou             @"Stock_HuanShou"           //换手率
#define tztNeiPan               @"Stock_NeiPan"             //内盘
#define tztVolumeRatio          @"Stock_VolumeRatio"        //量比
#define tztWaiPan               @"Stock_WaiPan"             //外盘
#define tztMinPrice             @"Stock_MinPrice"           //最低价
#define tztStartPrice           @"Stock_StartPrice"         //开盘价
#define tztTime                 @"Stock_Time"               //时间
#define tztUpDown               @"Stock_UpDown"             //涨跌
#define tztPriceRange           @"Stock_PriceRange"         //涨跌幅
#define tztTransactionAmount    @"Stock_TransactionAmount"  //成交额
#define tztTradingVolume        @"Stock_TradingVolume"      //成交量
#define tztYestodayVolume       @"Stock_YestodayVolume"     //昨持
#define tztZCVolume             @"Stock_ZCVolume"           //总持
#define tztWBuy                 @"Stock_WBuy"               //委买
#define tztWSell                @"Stock_WSell"              //委卖
#define tztWRange               @"Stock_WRange"             //委比
#define tztWCha                 @"Stock_WCha"               //委差
#define tztUpStocks             @"Stock_UpStocks"           //上涨数
#define tztFlatStocks           @"Stock_FlatStocks"         //平盘数
#define tztDayADD               @"Stock_DayADD"             //日增
#define tztVibrationAmplitude   @"Stock_VibrationAmplitude" //振幅
#define tztAveragePrice         @"Stock_AveragePrice"       //均价
#define tztDownStocks           @"Stock_DownStocks"         //下跌数
#define tztIndustryCode         @"Stock_IndustryCode"       //行业代码
#define tztIndustryName         @"Stock_IndustryName"       //行业名称
#define tztIndustryPriceRange   @"Stock_IndustryPriceRange" //行业涨跌幅
#define tztJsj                  @"Stock_Jsj"                //期货结算价
#define tztPE                   @"Stock_PE"                 //动态市盈率
#define tztPEStatic             @"Stock_PEStatic"           //静态市盈率
#define tztSeason               @"Stock_Season"             //季度 3-1，6=2，9=3，12=4
#define tztSeasonValue          @"Stock_SeasonValu"         //每股净收益
#define tztZTPrice              @"Stock_ZTPrice"            //涨停价
#define tztDTPrice              @"Stock_DTPrice"            //跌停价
#define tztMeiGuJingZiChan      @"Stock_MeiGuJingZiChan"    //每股净资产(元／股)
#define tztSJL                  @"Stock_SJL"                //市净率
#define tztZongGuBen            @"Stock_ZongGuBen"          //总股本
#define tztZongGuBenMoney       @"Stock_ZongGuBenMoney"     //总市值
#define tztLiuTongPan           @"Stock_LiuTongPan"         //流通盘
#define tztLiuTongPanMoney      @"Stock_LiuTongPanMoney"    //流通市值
#define tztBuy1                 @"Stock_Buy1"               //买一价
#define tztBuy2                 @"Stock_Buy2"               //买二价
#define tztBuy3                 @"Stock_Buy3"               //买三价
#define tztBuy4                 @"Stock_Buy4"               //买四价
#define tztBuy5                 @"Stock_Buy5"               //买五价
#define tztBuy1Vol              @"Stock_Buy1Vol"            //买一量
#define tztBuy2Vol              @"Stock_Buy2Vol"            //买二量
#define tztBuy3Vol              @"Stock_Buy3Vol"            //买三量
#define tztBuy4Vol              @"Stock_Buy4Vol"            //买四量
#define tztBuy5Vol              @"Stock_Buy5Vol"            //买五量
#define tztSell1                @"Stock_Sell1"              //卖一价
#define tztSell2                @"Stock_Sell2"              //卖二价
#define tztSell3                @"Stock_Sell3"              //卖三价
#define tztSell4                @"Stock_Sell4"              //卖四价
#define tztSell5                @"Stock_Sell5"              //卖五价
#define tztSell1Vol             @"Stock_Sell1Vol"           //卖一量
#define tztSell2Vol             @"Stock_Sell2Vol"           //卖二量
#define tztSell3Vol             @"Stock_Sell3Vol"           //卖三量
#define tztSell4Vol             @"Stock_Sell4Vol"           //卖四量
#define tztSell5Vol             @"Stock_Sell5Vol"           //卖五量
#define tztIEP                  @"Stock_HK_IEP"             //IEP
#define tztIEV                  @"Stock_HK_IEV"             //IEV
#define tztStockProp            @"Stock_Prop"               


