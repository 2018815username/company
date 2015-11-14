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

@interface tztUIQuoteViewControllerStyle2 : TZTUIBaseViewController<tztHqBaseViewDelegate, tztUINewTitleViewDelegate, tztUITableListViewDelegate, tztHTTPWebViewDelegate, tztNineGridViewDelegate,UIGestureRecognizerDelegate>
{
    /*
     标题行及控件
     */
    tztUINewTitleView   *_pTitle;
    int                 _nReportType;
    int                 _nPreIndex;
    /*标题栏的seg选中索引*/
    int                 _nSegIndex;
    /*中间按钮的选择索引（UIFunctionView的选中索引）*/
    int                 _nFunctionViewIndex;
    
    //默认打开的市场
    UInt32              _nDefaultFunctionID;
}

@property(nonatomic, retain)tztUINewTitleView   *pTitle;
@property(nonatomic)int                         nReportType;
@end
