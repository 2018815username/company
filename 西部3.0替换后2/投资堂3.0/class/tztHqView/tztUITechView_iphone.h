/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        k线显示（带报价）
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

@interface tztUITechView_iphone : tztHqBaseView<tztHqBaseViewDelegate>
{
    UIScrollView    *_pScrollView;
    tztQuoteView    *_pQuoteView;
    tztTechView     *_pTechView;
    int             _nStockType;
    NSMutableArray  *_pAyBtnData;
}

@property(nonatomic, retain)UIScrollView    *pScrollView;
@property(nonatomic, retain)tztQuoteView    *pQuoteView;
@property(nonatomic, retain)tztTechView     *pTechView;
@property(nonatomic, retain)NSMutableArray  *pAyBtnData;
@property(nonatomic)BOOL hasNoAddBtn;

@property   int nStockType;

//-(void)setStockCode:(tztStockInfo *)pStockCode Request:(int)nRequest;
//-(void)setStockCode:(NSString *)strCode stockType_:(NSInteger)stockType;
@end
