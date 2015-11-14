/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金开户
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
#import "tztUIFundKHView.h"

@interface tztUIFoundHKVC : TZTUIBaseViewController
{
    tztUIFundKHView             *_pFundKhView;
    
    NSString * _nsJJGSDM;//基金公司代码
    NSString * _nsJJGMMC;//基金公司名称
    int     _nReturn;//基金开户成功后跳转界面类型
}

@property(nonatomic, retain)tztUIFundKHView         *pFundKhView;
@property(nonatomic,retain)NSString     *nsJJGSDM;
@property(nonatomic,retain)NSString     *nsJJGSMC;
@property int nReturn;
@end
