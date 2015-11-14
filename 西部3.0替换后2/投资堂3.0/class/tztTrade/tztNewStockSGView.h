/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        新股申购
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztBaseTradeView.h"
@interface tztNewStockSGView : tztBaseTradeView
{
    tztUIVCBaseView     *_tztTradeView;
    NSString *_CurStockCode;
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayTypeContent;
    NSMutableArray          *_ayStockNum;
    float                   _fMoveStep;
    int                     _nDotValid;
}
@property(nonatomic, retain)tztUIVCBaseView     *tztTradeView;
@property(nonatomic, retain)NSString            *CurStockCode;
@property(nonatomic, retain)NSMutableArray      *ayStockCode;
@property(nonatomic, retain)NSMutableArray      *ayAccount;
@property(nonatomic, retain)NSMutableArray      *ayType;
@property(nonatomic, retain)NSMutableArray      *ayStockNum;
@property(nonatomic, retain)NSMutableArray      *ayStockPrice;
-(void)setStockCode:(NSString*)nsCode;
@end
