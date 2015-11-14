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
#import "tztBaseTradeView.h"

//zxl 20131029 登录成功跳转担保品界面协议添加
@protocol tztRZRQNeedPTLoginViewDelegate <NSObject>
@optional
-(void)OpenDBPHZView;
@end

@interface tztRZRQNeedPTLoginView : tztBaseTradeView
{
    tztUIVCBaseView      *_tztTableView;
    tztJYLoginInfo*   _pAccount;
}

@property(nonatomic,retain)tztUIVCBaseView *tztTableView;

-(void)setMsgID:(NSInteger)nMsgID wParam:(id)wParam lParam:(id)lParam;
@end
