/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合赎回
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
#import "tztUIFundZHSHView.h"

@interface tztUIFundZHSHViewController : TZTUIBaseViewController<tztUIFundZHSHViewDelegate>
{
    tztUIVCBaseView         *_pView;
    tztUIFundZHSHView       *_pZHSHView;
    
    int                     _nCurrentSelect;
    NSMutableArray          *_ayFundCode;
    
    int                     _nProductIndex;
    int                     _nGroupCodeIndex;
    int                     _nGroupNameIndex;
    int                     _nGroupStockIndex;
    int                     _nLatestIndex;
    int                     _nGroupTypeIndex;
    int                     _nInitDateIndex;
    int                     _nUpdateDateIndex;
    int                     _nRiskWarningIndex;
    int                     _nAmountIndex;
}

@property(nonatomic,retain)tztUIVCBaseView      *pView;
@property(nonatomic,retain)tztUIFundZHSHView    *pZHSHView;
@property(nonatomic,retain)NSMutableArray  *ayFundCode;
@end
