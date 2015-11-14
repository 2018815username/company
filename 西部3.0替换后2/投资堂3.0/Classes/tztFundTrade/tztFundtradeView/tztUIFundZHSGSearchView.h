/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合基金查询
 * 文件标识:
 * 摘要说明:    批量查询基金信息
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundSearchView.h"


@interface tztUIFundZHSGSearchView : tztUIFundSearchView
{
    NSMutableArray*   _ayFundCode;//
    int               _nOpenAccountFlag;
    
    NSMutableArray          *_pAyData;
    int               _nErrorNO;
}
@property(nonatomic,retain)NSMutableArray* ayFundCode;
@property(nonatomic,retain)NSMutableArray   *pAyData;
@property int nOpenAccountFlag;

-(void)OnZHSG;
-(void)OnOpenAccount;
@end
