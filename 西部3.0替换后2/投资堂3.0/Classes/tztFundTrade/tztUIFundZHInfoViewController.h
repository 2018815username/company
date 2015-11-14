/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合说明
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
#import "tztUIFundZHInfoView.h"

@interface tztUIFundZHInfoViewController : TZTUIBaseViewController
{
    tztUIFundZHInfoView         *_tztTradeTable;
    NSInteger _nCurrentIndex;
    BOOL                    _bShowAll;
}

@property(nonatomic,retain)tztUIFundZHInfoView      *tztTradeTable;
@property NSInteger nCurrentIndex;
@property BOOL bShowAll;

@end
