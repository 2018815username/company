/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUITHBNewOpenGHViewController
 * 文件标识:
 * 摘要说明:		天汇宝新开回购界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "TZTUIBaseTitleView.h"
#import "tztNewOpenGHView.h"

@interface tztUITHBNewOpenGHViewController :TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztNewOpenGHView   *_pView;
    NSString        *_nsCurStockCode;
    NSString        *_nsCurAccountType;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztNewOpenGHView  *pView;
@property(nonatomic,retain)NSString *nsCurStockCode;
@property(nonatomic,retain)NSString *nsCurAccountType;
@end
