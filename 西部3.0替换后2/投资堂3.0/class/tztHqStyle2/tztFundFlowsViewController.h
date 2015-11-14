/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIQuoteViewController
 * 文件标识：
 * 摘    要：   华泰资金流向菜单列表显示
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2014-09-18
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztUIMarketView.h"
#import "tztUINewMarketView.h"

@interface tztFundFlowsViewController : TZTUIBaseViewController<tztHqBaseViewDelegate,tztUIMarketDelegate, tztUITableListViewDelegate, tztHTTPWebViewDelegate, tztNineGridViewDelegate,UIGestureRecognizerDelegate>
{
    /*
     中间功能操作区：自选的功能按钮，市场的菜单列表按钮
     */
    tztUINewMarketView     *_pMarketView;
    
    tztUINewMarketView     *_pSubMarketView;
    
    tztReportListView      *_pReportList;
    /*
     contentView,具体内容展示view
     1、行情列表界面
     2、web展示界面
     3、行情菜单列表
     4、行情分屏分时显示
     */
//    tztUITableListView  *_pMenuView;
    NSString            *_nsMenuID;//当前菜单索引id
    NSMutableDictionary        *_pMenuDict;
    NSString            *_nsOrdered;
    
}

@property(nonatomic, retain)tztUINewMarketView  *pMarketView;
@property(nonatomic, retain)tztUINewMarketView  *pSubMarketView;
@property(nonatomic, retain)tztReportListView   *pReportList;
//@property(nonatomic, retain)tztUITableListView  *pMenuView;
@property(nonatomic, retain)NSString            *nsMenuID;
@property(nonatomic, retain)NSMutableDictionary *pMenuDict;
@property(nonatomic, retain)NSString            *nsFirstID;

-(void)SetMenuID:(NSString*)nsID;
//根据设置的nsMenuID得到菜单列表字典，然后取字典第一个作为默认显示
@end
