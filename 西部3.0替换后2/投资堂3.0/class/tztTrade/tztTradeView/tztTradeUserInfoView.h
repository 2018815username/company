/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        用户信息修改
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

@interface tztTradeUserInfoView : tztBaseTradeView
{
    //显示界面
    tztUIVCBaseView     *_pUserInfoView;
    //省份
    NSMutableArray      *_ayProvinceAndCity;
    
    int                 _nSelectIndex;
}

@property(nonatomic,retain)tztUIVCBaseView  *pUserInfoView;
@property(nonatomic,retain)NSMutableArray   *ayProvinceAndCity;
@end
