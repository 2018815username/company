/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金转换view
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

@interface tztFundZHView : tztBaseTradeView<tztUIDroplistViewDelegate>
{
    tztUIVCBaseView         *_tztTradeTable;
    NSMutableDictionary     *_ayZHCompany;
    NSMutableArray          *_ayZRCode;//转入基金
    NSMutableArray          *_ayZHCode;
    NSMutableArray          *_ayAllZRCode;//
    NSString *              _nsCurStock;
    BOOL                    bsecond;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeTable;
@property(nonatomic,retain)NSMutableArray       *ayZRCode;
@property(nonatomic,retain)NSMutableArray       *ayAllZRCode;
@property(nonatomic,retain)NSMutableArray       *ayZHCode;
@property(nonatomic,retain)NSMutableDictionary       *ayZHCompany;
@property (nonatomic,retain)NSString * nsCurStock;
//-(void)OnRequestData;
@end