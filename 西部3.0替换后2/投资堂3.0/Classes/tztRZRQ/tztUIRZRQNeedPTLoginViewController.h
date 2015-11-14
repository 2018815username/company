/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券担保品需要普通登录界面
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "TZTUIBaseViewController.h"
#import "tztRZRQNeedPTLoginView.h"
@interface tztUIRZRQNeedPTLoginViewController : TZTUIBaseViewController
{
    tztRZRQNeedPTLoginView      *_pLoginView;
}
@property(nonatomic,retain)tztRZRQNeedPTLoginView * pLoginView;

-(void)setMsgID:(NSInteger)nMsgID wParam:(id)wParam lParam:(id)lParam;
@end
