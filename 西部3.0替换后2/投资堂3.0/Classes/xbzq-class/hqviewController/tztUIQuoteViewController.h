/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIQuoteViewController
 * 文件标识：
 * 摘    要：   华泰新行情首页显示
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-02
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztUIMarketView.h"
#import "tztWebView.h"
#import "tztUINewMarketView.h"
#import "tztTrendView_scroll.h"
#import "tztUIStockEditButtonView.h"


@interface tztUIQuoteViewController : TZTUIBaseViewController<tztHqBaseViewDelegate,tztUIMarketDelegate, tztUINewTitleViewDelegate, tztUITableListViewDelegate, tztHTTPWebViewDelegate, tztNineGridViewDelegate,UIGestureRecognizerDelegate>
{
    /*
     标题行及控件
     */
    tztUINewTitleView   *_pTitle;
    /*
     中间功能操作区：自选的功能按钮，市场的菜单列表按钮
     */
    tztUIFunctionView      *_btnView;
    tztUINewMarketView     *_pMarketView;
    
    /*
     contentView,具体内容展示view
     1、行情列表界面
     2、web展示界面
     3、行情菜单列表
     4、行情分屏分时显示
     */
//    tztUIFunctionView      *_pUserStockHeader;
    tztUIStockEditButtonView *_pNineGridView;//编辑自选股按钮
    tztReportListView *_pReportList;//行情列表界面
//    tztWebView        *_pWebView;
    tztUITableListView  *_pMenuView;
    tztTrendView_scroll *_pIndexTrendScroll; //显示分时图的view
    UIButton            *_pBtnHiden;
    
    NSString            *_nsReqAction;
    NSString            *_nsReqParam;
    int                 _nReportType;
    NSString            *_nsMenuID;//当前菜单索引id
    NSMutableDictionary        *_pMenuDict;
    NSString            *_nsOrdered;
    
    int                 _nPreIndex;
    /*标题栏的seg选中索引*/
    int                 _nSegIndex;
    /*中间按钮的选择索引（UIFunctionView的选中索引）*/
    int                 _nFunctionViewIndex;
    
    //默认打开的市场
    UInt32              _nDefaultFunctionID;
    
    BOOL                _bHiddenTrendScroll;
}

@property(nonatomic, retain)tztUINewTitleView   *pTitle;
@property(nonatomic, retain)tztUIFunctionView   *btnView;
@property(nonatomic, retain)tztUINewMarketView  *pMarketView;
@property(nonatomic, retain)tztReportListView   *pReportList;
@property(nonatomic, retain)tztWebView          *pWebView;
@property(nonatomic, retain)tztUITableListView  *pMenuView;
@property(nonatomic, retain)tztTrendView_scroll *pIndexTrendScroll;
@property(nonatomic, retain)UIButton            *pBtnHiden;
@property(nonatomic, retain)NSString            *nsReqAction;
@property(nonatomic, retain)NSString            *nsReqParam;
@property(nonatomic, retain)NSString            *nsMenuID;
@property(nonatomic, retain)NSMutableDictionary *pMenuDict;
@property(nonatomic, retain)NSString            *nsOrdered;

@property(nonatomic)int                         nReportType;

-(void)RequestData:(int)nAction nsParam_:(NSString*)nsParam;
-(void)SetMenuID:(NSString*)nsID;
//根据设置的nsMenuID得到菜单列表字典，然后取字典第一个作为默认显示
-(BOOL)RequestDefaultMenuData:(NSString*)nsID;

-(void)RequestUserStockData;
//直接打开大盘指数
-(void)RequestIndexData;
//直接打开排名
-(void)RequestReportData;
//直接打开板块
-(void)RequestBlockData;
//直接打开资金流向
-(void)RequestFundFlowData;

 @end
