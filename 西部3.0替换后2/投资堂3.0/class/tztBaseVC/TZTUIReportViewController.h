/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        排名列表显示view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
#import "TZTUIBaseViewController.h"
#import "TZTUIMenuView.h"
#import "TZTUIStockDetailView.h"


enum TZTUIReportType
{
    TZTUIReportViewType = 0,    //排名列表界面类型
    TZTUIReportDetailType       //个股详情界面类型
};


@interface TZTUIReportViewController : TZTUIBaseViewController<tztHqBaseViewDelegate>
{
    //左侧的菜单列表(可隐藏)
    TZTUIMenuView           *_pMenuView;
    //右侧数据显示
    tztReportListView       *_pReportGrid;
    //详情显示view
    TZTUIStockDetailView    *_pStockDetailView;
    //页面显示类型(详情显示，列表显示)
    int                     _nTranseType;
    //当前页面类型
    int                     _nCurTranseType;
    //页面类型（自选，大盘，排名）
    int                     _nPageType;
    //个股界面隐藏排名列表
    UIButton *              _pBtHidden;
    //其他界面跳转到排名界面的时候传递的 MENUID 用
    NSString *              _pStrMenuID;
    //
    NSString *              _nsReqAction;
}

@property(nonatomic,retain)TZTUIMenuView    *pMenuView;
@property(nonatomic,retain)tztReportListView  *pReportGrid;
@property(nonatomic,retain)TZTUIStockDetailView    *pStockDetailView;
@property(nonatomic, retain)NSString *pStrMenID;
@property(nonatomic, retain)NSString *nsReqAction;
@property BOOL              bFlag;
@property int               nTransType;
@property int               nPageType;
@property int               nCurTranseType;



-(void)OnSelectHQData:(tztStockInfo*)pStock;

-(BOOL)isEqualType:(NSInteger)nType;
@end
