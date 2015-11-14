/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合基金查询
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
#import "tztUIFundZHSGSearchView.h"

@interface tztUIFundZHSGSearchViewController : TZTUIBaseViewController
{
    tztUIVCBaseView     *_pView;
    
    tztUIFundZHSGSearchView *_pSearchView;
    
    NSMutableArray*     _ayFundCode;
    int                     _nOpenAccountFlag;
}
@property(nonatomic,retain)tztUIFundZHSGSearchView  *pSearchView;
@property(nonatomic,retain)tztUIVCBaseView                   *pView;
@property(nonatomic,retain)NSMutableArray           *ayFundCode;
@property int nOpenAccountFlag;
-(void)setOpenAccountFlag:(int)nFlag;
-(void)setDefaultData:(NSMutableArray*)pAy;
@end
