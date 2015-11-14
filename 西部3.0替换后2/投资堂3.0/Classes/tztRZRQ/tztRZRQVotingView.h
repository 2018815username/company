/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券投票
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

@interface tztRZRQVotingView : tztBaseTradeView<TZTUIMessageBoxDelegate>
{
    tztUIVCBaseView      *_tztTableView;
    
    float                   _fMoveStep;
    int                     _nDotValid;
    NSString                *_CurStockCode;
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTableView;
@property(nonatomic,retain)NSString * CurStockCode;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSMutableArray       *ayType;
@end
