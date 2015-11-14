/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUISBTradeBuySellViewController
 * 文件标识:
 * 摘要说明:		股转系统买卖界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "TZTUIBaseViewController.h"
#import "tztSBTradeBuySellView.h"
@interface tztUISBTradeBuySellViewController : TZTUIBaseViewController<tztStockBuySellViewDelegate>
{
    tztSBTradeBuySellView   *_pView;
    BOOL                    _bBuyFlag;
    NSString                *_CurStockCode;
}
@property(nonatomic,retain)tztSBTradeBuySellView  *pView;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic,retain)NSString             *CurtradeUnit; //交易单元（对方席位)
@property(nonatomic,retain)NSString             *CurAppointmentSerial; //约定序号
@property BOOL bBuyFlag;
@end
