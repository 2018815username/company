/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        服务器设置
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztServerSettingView.h"
@implementation tztServerSettingView

-(id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    [self onSetTableConfig:@"tztUIServerSetting"];
}

- (void)onReadWriteSettingValue:(BOOL)bRead
{
    if(bRead)
    {
        [_tztTableView setCheckBoxValue:[TZTServerListDeal getShareClass].bForce withTag_:7000];
        //
        [_tztTableView setComBoxData:[[TZTServerListDeal getShareClass] GetAddressList:tztSession_Exchange] ayContent_:[[TZTServerListDeal getShareClass] GetAddressList:tztSession_Exchange] AndIndex_:0 withTag_:3000];
        [_tztTableView setComBoxText:[[TZTServerListDeal getShareClass] GetJYAddress] withTag_:3000];
        
        [_tztTableView setComBoxData:[TZTServerListDeal getShareClass].ayPortList ayContent_:[TZTServerListDeal getShareClass].ayPortList AndIndex_:0 withTag_:3001];
        [_tztTableView setComBoxText:[NSString stringWithFormat:@"%d", [[TZTServerListDeal getShareClass] GetJyPort]] withTag_:3001];
        [_tztTableView setComBoxData:[[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeHQ] ayContent_:[[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeHQ] AndIndex_:0 withTag_:3002];
        [_tztTableView setComBoxText:[[TZTServerListDeal getShareClass] GetHQAddress] withTag_:3002];
        
        [_tztTableView setComBoxData:[TZTServerListDeal getShareClass].ayPortList ayContent_:[TZTServerListDeal getShareClass].ayPortList AndIndex_:0 withTag_:3003];
        [_tztTableView setComBoxText:[NSString stringWithFormat:@"%d", [[TZTServerListDeal getShareClass] GetHQPort]] withTag_:3003];
        
        [_tztTableView setComBoxData:[[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeZX] ayContent_:[[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeZX] AndIndex_:0 withTag_:3012];
        [_tztTableView setComBoxText:[[TZTServerListDeal getShareClass] GetZXAddress] withTag_:3012];
    }
}

-(void)OnButtonClick:(id)sender
{
    if (_tztTableView == NULL)
        return;
    BOOL bFouce = [_tztTableView getCheckBoxValue:7000];
    [TZTServerListDeal getShareClass].bForce = bFouce;

    //获取地址端口数据
    NSInteger nIndex = -1;
    NSString *nsJYAddress = [_tztTableView getComBoxText:3000];
    nIndex = [_tztTableView getComBoxSelctedIndex:3000];
    
    if (nsJYAddress == nil || [nsJYAddress length] < 1 || nIndex < 0)
        return;
    
//    NSString *nsJYPort = [_tztTableView getComBoxText:3001];
//    nIndex = [_tztTableView getComBoxSelctedIndex:3001];
//    if (nsJYPort == nil || [nsJYPort length] < 1 || nIndex < 0)
//        return;
    
    NSString *nsHQAddress = [_tztTableView getComBoxText:3002];
    if (nsHQAddress == NULL || nsHQAddress.length < 1)
        nsHQAddress = nsJYAddress;
//    NSString *nsHQPort = [_tztTableView getComBoxText:3003];
//    if (nsHQPort == NULL || nsHQPort.length < 1)
//        nsHQPort = nsHQPort;
    
    NSString *nsZXAddress = [_tztTableView getComBoxText:3012];
    if (nsZXAddress.length < 1)
        nsZXAddress = nsJYAddress;
    
    [[TZTServerListDeal getShareClass] SetJYAddress:nsJYAddress];
    [[TZTServerListDeal getShareClass] SetHQAddress:nsHQAddress];
#ifdef tzt_ZSSC
    [[TZTServerListDeal getShareClass] SetZXAddress:nsHQAddress];
//    [[TZTServerListDeal getShareClass] SetZXPort:[nsHQPort intValue]];
#else
    [[TZTServerListDeal getShareClass] SetZXAddress:nsZXAddress];
//    [[TZTServerListDeal getShareClass] SetZXPort:[nsJYPort intValue]];
#endif
    [[TZTServerListDeal getShareClass] SetRZAddress:nsJYAddress];
    
//    [[TZTServerListDeal getShareClass] SetJYPort:[nsJYPort intValue]];
//    [[TZTServerListDeal getShareClass] SetHQPort:[nsHQPort intValue]];
//    [[TZTServerListDeal getShareClass] SetRZPort:[nsJYPort intValue]];
    

    
	[TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllServer_Log];
    [[TZTServerListDeal getShareClass] SaveAndLoadServerList:TRUE];//保存
    [tztJYLoginInfo SetLoginAllOut];//zxl 20131128 清掉所有的账号
    //释放当前的网络,并使用新地址重连
    [[TZTServerListDeal getShareClass] SetServerOK:tztSession_ALL];
    
    [self showMessageBox:@"服务器地址设置成功！" nType_:TZTBoxTypeNoButton nTag_:0];
}
@end
