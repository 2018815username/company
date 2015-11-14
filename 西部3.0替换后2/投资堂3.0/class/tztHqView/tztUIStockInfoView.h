/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        个股资讯
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztInfoTableView.h"
#import "tztWebView.h"

#define tztInfoBtnTag 0x1111
@interface tztUIStockInfoView : tztHqBaseView<tztInfoDelegate,tztHqBaseViewDelegate>
{
    tztFinanceView      *_pFinanceView;
    tztInfoTableView    *_pInfoTableView;
    tztWebView          *_pF10View;
    
    NSMutableArray      *_pAyButton;
    
    UIButton            *_pBtnF10;
    UIButton            *_pBtnTBF10;
    UIButton            *_pBtnXXDL;
    UIButton            *_pBtnFinance;
}

@property(nonatomic, retain)tztFinanceView      *pFinanceView;
@property(nonatomic, retain)tztInfoTableView    *pInfoTableView;
@property(nonatomic, retain)NSMutableArray      *pAyButton;
@property(nonatomic, retain)UIButton            *pBtnF10;
@property(nonatomic, retain)UIButton            *pBtnXXDL;
@property(nonatomic, retain)UIButton            *pBtnFinance;

@end
