/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易界面（iPad）右侧功能展示界面(zxl  20131011 右边的界面中去掉了下面的 界面直接保留一个大的界面)
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#ifndef __TZTTRADERIGHT_IPAD_H__
#define __TZTTRADERIGHT_IPAD_H__
#import "tztBaseTradeView.h"
@interface tztTradeRight_ipad : tztBaseTradeView<tztTabViewDelegate>
{
    tztTabView              *_topTabView;
}
@property(nonatomic, retain)tztTabView      *topTabView;
-(void)DealWithMenu:(NSInteger)nMsgType nsParam_:(NSString *)nsParam;
@end

#endif