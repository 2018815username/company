/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

@interface tztUIStockView : tztHqBaseView<tztMutilScrollViewDelegate,tztHqBaseViewDelegate>
{
    int                 _nCurrentSelect;
    NSMutableArray      *_pAyViews;
    tztMutilScrollView  *_pMutilViews;
    UIView              *_pBaseView;
    NSInteger                 _nCurrentIndex;
    tztScrollIndexView  *_pScrollIndex;
}

@property(nonatomic, retain)NSMutableArray *pAyViews;
@property(nonatomic, retain)tztMutilScrollView *pMutilViews;
@property(nonatomic, retain)UIView      *pBaseView;
@property(nonatomic,retain)tztScrollIndexView *pScrollIndex;
@property(nonatomic)BOOL hasNoAddBtn;

- (BOOL)isTechView;
-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest;
@end
