/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金认购申购vc
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
#import "tztUIFundTradeRGSGView.h"

@interface tztUIFoundSGOrRG : TZTUIBaseViewController
{
    tztUIFundTradeRGSGView      *_pFundTradeRGSG;
    
    NSString                    *_CurStockCode;

}

@property(nonatomic,retain)tztUIFundTradeRGSGView   *pFundTradeRGSG;
@property(nonatomic,retain)NSString                 *CurStockCode;

@end
