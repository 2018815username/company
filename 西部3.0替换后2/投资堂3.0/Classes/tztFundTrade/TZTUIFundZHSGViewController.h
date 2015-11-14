/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        华西组合申购vc
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
#import "tztUIFundZHSGView.h"

@interface TZTUIFundZHSGViewController : TZTUIBaseViewController
{
    tztUIFundZHSGView       *_pZHSGView;
    int                     _nCurrentIndex;
    BOOL                    _bShowAll;
}

@property(nonatomic,retain)tztUIFundZHSGView    *pZHSGView;
@property int nCurrentIndex;
@property BOOL bShowAll;
@end
