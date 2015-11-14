/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztZQTradeBuySellView
 * 文件标识:
 * 摘要说明:		债转股,债券回售VC
 *
 * 当前版本:      2.0
 * 作    者:     xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztZQTradeBuySellView.h"

@interface tztUIZQTradeBuysellViewController : TZTUIBaseViewController<tztStockBuySellViewDelegate>
{
    tztZQTradeBuySellView *_pView;
    BOOL                   _bBuyFlag;
    NSString                *_CurStockCode;
}

@property(nonatomic,retain)tztZQTradeBuySellView  *pView;
@property(nonatomic,retain)NSString               *CurStockCode;
@property BOOL bBuyFlag;
@end
