/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        分时显示view(带报价)
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#define tztTrendButtonHeight 32
#define tztTrendSpace 6

#define tztTrendBtnTag 0x3333

@interface tztUITrendView_iphone : tztHqBaseView<tztHqBaseViewDelegate>
{
    //分时
    tztTrendView    *_pTrendView;
    //顶部报价
    tztQuoteView    *_pQuoteView;
    //明细
    tztDetailView   *_pDetailView;
    //龙虎
    tztLargeMonitorView *_pLargeInfoView;
    //分价
    tztFenJiaView       *_pFenJiaView;
    
    NSMutableArray  *_pAyBtn;
    tztTrendFundView   *_pTrendFundView;
}


@property(nonatomic, retain)tztTrendView *pTrendView;
@property(nonatomic, retain)tztQuoteView *pQuoteView;
@property(nonatomic, retain)tztDetailView *pDetailView;
@property(nonatomic, retain)tztLargeMonitorView *pLargInfoView;
@property(nonatomic, retain)tztFenJiaView   *pFenJiaView;
@property(nonatomic)BOOL hasNoAddBtn;

@property(nonatomic, retain)tztTrendFundView   *pTrendFundView;
@property int nStockType;

//-(void)setStock:(tztStockInfo *)pStockCode Request:(int)nRequest;
//-(void)setStockCode:(NSString *)strCode stockType_:(NSInteger)stockType;
@end
