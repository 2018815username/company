/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        个股详情界面
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
#import "TZTUIBottomSetView.h"

@interface TZTUIStockDetailView : TZTUIBaseView<tztHqBaseViewDelegate,tztInfoDelegate>
{
    NSString*       m_nsStockName;//股票名称
    //上方的名称，代码显示，按钮等统一放置按钮 
    UIView          *m_pTitleView;
//    tztQuoteView    *m_pTitleView;
    //分时界面
    tztTrendView    *m_pTrendView;//
    //k线界面
    tztTechView     *m_pTechView;
    
    tztDetailView   *m_pDetailView;
    //右侧的详情显示区域
    tztPriceView    *m_pRightView;
    
    //底下的info显示
    TZTUIBottomSetView  *m_pBottomView;
    
    //切换报价、成交明细、财务数据
    UISegmentedControl  *_segmentControl;
    //
    tztFinanceView      *_pFinanceView;
    
    //
    UIButton            *_pBtnYuJing;
    //
    UIButton            *_pBtnF9;
    //
    UIButton            *_pBtnF10;
    //
    UIButton            *_pBtnBuy;
    //
    UIButton            *_pBtnSell;
    //
    UIButton            *_pBtnKLine;
    //
    NSMutableArray      *_ayBtn;
}

//@property(nonatomic, retain)NSString* m_nsStockCode;
@property(nonatomic, retain)NSString* m_nsStockName;
//@property(nonatomic, retain)tztQuoteView  *m_pTitleView;
@property(nonatomic, retain)UIView      *m_pTitleView;
@property(nonatomic, retain)tztPriceView  *m_pRightView;
@property(nonatomic, retain)tztDetailView *m_pDetailView;
@property(nonatomic, retain)TZTUIBottomSetView  *m_pBottomView;

@property(nonatomic, retain)tztTrendView* m_pTrendView;
@property(nonatomic, retain)tztTechView*  m_pTechView;

@property(nonatomic, retain)UISegmentedControl *segmentControl;
@property(nonatomic, retain)tztFinanceView      *pFinanceView;
@property(nonatomic, retain)UIButton            *pBtnYuJing;
@property(nonatomic, retain)UIButton            *pBtnF9;
@property(nonatomic, retain)UIButton            *pBtnF10;
@property(nonatomic, retain)UIButton            *pBtnBuy;
@property(nonatomic, retain)UIButton            *pBtnSell;
@property(nonatomic, retain)UIButton            *pBtnKLine;
@property(nonatomic, retain)NSMutableArray      *ayBtn;

-(void)SetStockCode:(tztStockInfo*)pStock;
-(void)onSetViewRequest:(BOOL)bRequest;
@end
