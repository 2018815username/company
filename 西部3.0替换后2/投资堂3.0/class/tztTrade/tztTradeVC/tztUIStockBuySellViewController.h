/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        股票买卖vc
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
#import "tztStockBuySellView.h"

@interface tztUIStockBuySellViewController : TZTUIBaseViewController <tztStockBuySellViewDelegate>
{
    tztStockBuySellView     *_pStockBuySell;
    
    BOOL                    _bBuyFlag;
    
    NSString                *_CurStockCode;
}
@property(nonatomic,retain)tztStockBuySellView  *pStockBuySell;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic) BOOL bBuyFlag;

-(void)OnRequestData;
-(void)tztRefreshData;
@end
