/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "TZTUIBaseViewController.h"
#import "tztUIHomePageLeftView.h"
#import "tztUIHomePageReportGridView.h"
#import "tztUIHomePageInfoView.h"
#import "tztUIHomePageFenShiView.h"
#import "tztUIHomePageScrollView.h"
@interface tztUIHomePageViewController : TZTUIBaseViewController
{
    tztUIHomePageLeftView * _pLeftView;
    tztUIHomePageInfoView * _pInfoView;
    tztUIHomePageFenShiView * _pFenShiView;
    tztUIHomePageReportGridView * _pReportGridView;
    tztUIHomePageScrollView *_pScrollView;
    UIImageView * _pImageBG;
}
@property(nonatomic ,retain)tztUIHomePageLeftView * pLeftView;
@property(nonatomic ,retain)tztUIHomePageInfoView * pInfoView;
@property(nonatomic ,retain)tztUIHomePageFenShiView * pFenShiView;
@property(nonatomic ,retain)tztUIHomePageReportGridView * pReportGridView;
@property(nonatomic ,retain)tztUIHomePageScrollView * pScrollView;
-(void)SelectStock:(tztStockInfo *)pStock;
@end
