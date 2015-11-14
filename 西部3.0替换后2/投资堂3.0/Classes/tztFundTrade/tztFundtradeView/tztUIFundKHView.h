/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金开户view
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
#import "TZTUIBaseTableView.h"

@interface tztUIFundKHView : tztBaseTradeView<TZTUIBaseTableViewDelegate>
{
    tztUIVCBaseView         *_tztTradeTable;
    NSMutableArray          *_ayCompanyData;
    int     _nReturn;//基金开户成功后跳转界面类型
    NSMutableArray          *_ayKHType;//开户类型 新开、增加
    NSString * _nsAddress;//地址
    NSString * _nsPost;//邮编
    NSString * _nsTelPhone;//电话
    NSString * _nsPhone;//手机
    NSString * _nsEmail;//Email
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTradeTable;
@property(nonatomic,retain)NSMutableArray    *ayCompanyData;
@property(nonatomic,retain)NSMutableArray    *ayKHType;
@property(nonatomic,retain)NSString *nsAddress;
@property(nonatomic,retain)NSString *nsPost;
@property(nonatomic,retain)NSString *nsTelPhone;
@property(nonatomic,retain)NSString *nsPhone;
@property(nonatomic,retain)NSString *nsEmail;
@property int nReturn;
//开户
-(void)OnSendKH;
-(void)SetShowMSG:(NSString *)nsJJGSMC NSFundDM:(NSString *)nsJJGSDM Return:(int)MsgType;
-(void)GetUserInfo;
@end

