/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        现金增值计划修改
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

@interface tztTTYModifyView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTradeTable;
    //基金代码
    NSString                *_CurStockCode;
    //基金公司代码
    NSString                *_nsJJGSCode;
    
    NSMutableArray          *_ayData;
    NSMutableArray          *_ayType;
    
    int                     _nCurrentSelect;
    
    BOOL                    _bInquire;
}
@property(nonatomic,retain)tztUIVCBaseView  *tztTradeTable;
@property(nonatomic,retain)NSString         *CurStockCode;
@property(nonatomic,retain)NSString          *nsJJGSCode;

-(void)SetDefaultData;
-(void)DealWithStockCode:(NSString*)nsStockCode;
@end
