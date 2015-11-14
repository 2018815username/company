/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合赎回view
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
#import "tztUIFundZHSGSearchView.h"

@protocol tztUIFundZHSHViewDelegate <NSObject>

-(void)OnSetViewData:(tztNewMSParse*)pParse;

@end

@interface tztUIFundZHSHView : tztUIFundZHSGSearchView
{
    int _nKYIndex;
}
-(void)OnRequestFundList;
-(void)OnZHSH;

- (void)OnRequestFundListEx:(NSString*)strGroupCode;
-(void)OnDetail;
@end
