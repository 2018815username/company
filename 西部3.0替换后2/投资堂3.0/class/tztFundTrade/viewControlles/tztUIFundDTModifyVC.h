/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金定投申请,修改,删除
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztFundDTModifyView.h"

@interface tztUIFundDTModifyVC :  TZTUIBaseViewController
{    
    tztFundDTModifyView           *_pFundTradeDTKH;
    
    NSString                    *_CurStockCode;
    
    NSMutableDictionary         *_pDefaultDataDict;
    
}

@property(nonatomic,retain)tztFundDTModifyView        *pFundTradeDTKH;
@property(nonatomic,retain)NSString                 *CurStockCode;
@property(nonatomic,retain)NSMutableDictionary      *pDefaultDateDict;
@end
