/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券直接还券
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztBaseTradeView.h"
@interface tztRZRQCrashRetuen : tztBaseTradeView
{
    tztUIVCBaseView     *_pCrashReturn;
    NSString                *_CurStockCode;
    //
    NSString                *_CurStockName;
    //
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayStockNum;
    
    int                 _nZJHKIndex;
    int                 _nFZJEIndex;
    int                 _nCount;
    NSString *          _nsMaxReturn;
}

@property(nonatomic, retain)tztUIVCBaseView     *pCrashReturn;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic,retain)NSString             *CurStockName;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSMutableArray       *ayStockNum;
@property(nonatomic,retain)NSString             *nsMaxReturn;
@end
