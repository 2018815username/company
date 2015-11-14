/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        iphone首页vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztInfoTableView.h"
#import "tztHomePageInfoView.h"

@interface tztHomePageViewController_iphone : TZTUIBaseViewController<tztNineGridViewDelegate,tztHqBaseViewDelegate,tztHomePageInfoViewDelegate,tztMutilScrollViewDelegate,TZTUIBaseViewDelegate>
{
    //顶部国际指数显示
    tztReportPage       *_pReportPageView;
    //九宫格显示
    tztUINineGridView   *_pNineGridView;
    //底部的资讯显示
    tztHomePageInfoView    *_pInfoTableView;
    BOOL        _bLoad;
//    tztInfoTableView        *_pInfoTableView;
    // 划动页
    tztMutilScrollView *_pMutilViews;
    // 划动页数组
    NSMutableArray *_pAyViews;
    
    BOOL        _bIsFull;//用来判断当前是否全屏显示
}

@property(nonatomic, retain)tztReportPage *pReportPageView;
@property(nonatomic, retain)tztUINineGridView *pNineGridView;
//@property(nonatomic, retain)tztInfoTableView *pInfoTableView;
@property(nonatomic, retain)tztHomePageInfoView *pInfoTableView;
@property(nonatomic, retain)tztMutilScrollView *pMutilViews;
@property(nonatomic, retain)NSMutableArray *pAyViews;

//设置首页资讯不全屏显示
-(void)setInfoViewFrame;
@end
