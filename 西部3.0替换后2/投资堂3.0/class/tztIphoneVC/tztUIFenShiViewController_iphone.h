/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        iphone分时显示vc
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
#import "tztUIStockView.h"

@interface tztUIFenShiViewController_iphone : TZTUIBaseViewController<tztHqBaseViewDelegate, tztGridViewDelegate>
{
    tztUIStockView          *_pStockView;
    //把列表传递进来
    id                  _pListView;
    NSInteger                 _nCurrentIndex;
}
@property(nonatomic, retain)tztUIStockView      *pStockView;
@property(nonatomic, retain)id                  pListView;
@property(nonatomic, assign)NSInteger                nStockCodeIndex;
@property(nonatomic, assign)NSInteger                nStockNameIndex;
@property(nonatomic)BOOL hasNoAddBtn;
@property(nonatomic)BOOL hasNoSearch;

-(void)setStockInfo:(tztStockInfo*)pStockInfo nRequest_:(int)nRequest;
@end

extern id g_pFenShiViewController;
