/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合申购view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztBaseTradeView.h"

@interface tztUIFundZHSGView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTradeTable;
    
    NSMutableArray          *_pAyData;
    
    //当前选中行
    NSInteger                     _nCurrentIndex;
    
    NSInteger                     _nProductIndex;
    NSInteger                     _nGroupCodeIndex;
    NSInteger                     _nGroupNameIndex;
    NSInteger                     _nGroupStockIndex;
    NSInteger                     _nLatestIndex;
    NSInteger                     _nGroupTypeIndex;
    NSInteger                     _nInitDateIndex;
    NSInteger                     _nUpdateDateIndex;
    NSInteger                     _nRiskWarningIndex;
    NSInteger                     _nAmountIndex;
    
    //是否下拉显示所有
    BOOL                    _bShowAll;
}

@property(nonatomic,retain)tztUIVCBaseView  *tztTradeTable;
@property(nonatomic,retain)NSMutableArray   *pAyData;
@property NSInteger   nCurrentIndex;
@property BOOL  bShowAll;

-(NSMutableArray*)GetFundCode:(NSString*)strData;
@end
