/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金定投view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztBaseTradeView.h"

@interface tztUIFundDTKHView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTradeTable;
    //
    NSString                *_CurStockCode;
    NSMutableArray          *_ayZq;//定投周期发送日
    NSMutableArray          *_ayZqData;
    
    NSString                *_nsCompanyCode;//基金公司代码
    NSMutableDictionary     *_pDefaultDataDict;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeTable;
@property(nonatomic,retain)NSMutableArray       *ayZq;
@property(nonatomic,retain)NSMutableArray       *ayZqData;
@property(nonatomic,retain)NSString             *nsCompanyCode;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic,retain)NSMutableDictionary  *pDefaultDataDict;

//设置数据
-(void)SetData:(NSMutableDictionary*)pDict;

-(void)SetDefaultData;
-(void)OnSend;
@end