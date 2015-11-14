/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUITHBDLWTSetYLJEViewController
 * 文件标识:
 * 摘要说明:		天汇宝代理委托-预留金额设置界面、开通界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "TZTUIBaseTitleView.h"
#import "tztDLWTSetYLJEView.h"

@interface tztUITHBDLWTSetYLJEViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztDLWTSetYLJEView   *_pView;
    int _nShowType;
//    NSString *_nsStcokCode;
//    NSString *_nsStockName;
      NSString *_nsNowYLJE;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztDLWTSetYLJEView  *pView;
//@property(nonatomic,retain) NSString *nsStcokCode;
//@property(nonatomic,retain) NSString *nsStockName;
@property(nonatomic,retain) NSString *nsNowYLJE;
@property int nShowType;
@end
