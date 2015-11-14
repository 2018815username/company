/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金转换
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
#import "tztFundZHView.h"

@interface tztUIFundZHVC : TZTUIBaseViewController
{
    
    tztFundZHView               *_pFundTradeZH;
    
    int                         _nFlag;
    
    NSString                    *_CurStockCode;
    
    NSMutableDictionary         *_pDict;
    
}
@property(nonatomic,retain)tztFundZHView            *pFundTradeZH;
@property(nonatomic,retain)NSString                 *CurStockCode;
@property(nonatomic,retain)NSMutableDictionary      *pDict;
@property int nFlag;

@end
