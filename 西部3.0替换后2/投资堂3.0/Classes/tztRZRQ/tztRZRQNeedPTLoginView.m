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

#import "tztRZRQNeedPTLoginView.h"
#import "tztUIRZRQStockHzViewController.h"
extern tztUserData*     g_CurUserData;
extern NSInteger g_ayJYLoginIndex[TZTMaxAccountType];//交易登录账号序号

@interface tztRZRQNeedPTLoginView()

@property(nonatomic)NSInteger   nMsgID;
@property(nonatomic,assign)id   pMsgInfo;
@property(nonatomic,assign)id   lParamInfo;
@end

@implementation tztRZRQNeedPTLoginView
@synthesize tztTableView =_tztTableView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}
-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    if (_pMsgInfo)
        [_pMsgInfo release];
    [super dealloc];
}

-(void)setMsgID:(NSInteger)nMsgID wParam:(id)wParam lParam:(id)lParam
{
    _nMsgID = nMsgID;
    _pMsgInfo = wParam;
    if (_pMsgInfo)
        [_pMsgInfo retain];
    _lParamInfo = lParam;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    if (_tztTableView == NULL)
    {
        _tztTableView = NewObject(tztUIVCBaseView);
        _tztTableView.tztDelegate = self;
        _tztTableView.tableConfig = @"tztRZRQPTJYLoginSetting";
        _tztTableView.frame = rcFrame;
        [self addSubview:_tztTableView];
        [_tztTableView release];
        [self SetAccountInfo];
    }else
        _tztTableView.frame = rcFrame;
}
-(void)SetAccountInfo
{
    if (g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < 1)
        return;
    //当前融资融券账号数据
    NSMutableArray* ayLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountRZRQType];
    if (ayLoginInfo == NULL || [ayLoginInfo count] < 1)
        return;
    
    NSInteger nLoginIndex = g_ayJYLoginIndex[TZTAccountRZRQType]; //当前序号
    if(nLoginIndex < 0 )
        return;
    
    _pAccount = [ayLoginInfo objectAtIndex:nLoginIndex];
    if (_pAccount == NULL)
        return;
    
    //融资融券对应的普通账号
    if (_pAccount.nsUserCode &&  [_pAccount.nsUserCode length] > 0)
    {
        [_tztTableView setLabelText:_pAccount.nsUserCode withTag_:3000];
    }
}
-(BOOL)CheckInput
{
    NSString * StrValue = [_tztTableView GetEidtorText:2000];
    if (StrValue && [StrValue length] > 0)
    {
        return TRUE;
    }
    return FALSE;
}

-(void)Login
{
    NSString* nsPass = [_tztTableView GetEidtorText:2000];
    if (nsPass == NULL || [nsPass length] <= 0)
        return;
    NSString* nsAccount = [_tztTableView GetLabelText:3000];
    if (nsAccount == NULL || [nsAccount length] <= 0)
        return;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:@"ZJACCOUNT" forKey:@"accounttype"];
    if (_pAccount.ZjAccountInfo.nsCellIndex)
        [pDict setTztValue:_pAccount.ZjAccountInfo.nsCellIndex forKey:@"YybCode"];
    
    [pDict setTztValue:nsAccount forKey:@"account"];
    [pDict setTztValue:nsPass forKey:@"password"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    //增加账号类型获取token
   // [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountDBPPTLogin] forKey:tztTokenType];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"100" withDictValue:pDict];
    DelObject(pDict);
}
//-(void)OnOK
//{   //新功能号 by xyt
//    if (_nMsgType == WT_RZRQSTOCKHZ || _nMsgType == MENU_JY_RZRQ_Transit)
//    {
//        [g_navigationController popViewControllerAnimated:NO];
//        tztUIRZRQStockHzViewController *pVC = [[tztUIRZRQStockHzViewController alloc] init];
//        pVC.nMsgType = _nMsgType;
//        [g_navigationController pushViewController:pVC animated:UseAnimated];
//        [pVC release];
//    }
//}
-(void)OnOK
{
    //zxl 20131029 ipad 担保品划转登录后跳转特殊处理
    if (IS_TZTIPAD)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(OpenDBPHZView)])
        {
            [self.delegate OpenDBPHZView];
        }
    }
    else
    {
        if (_nMsgID > 0)//页面打开
        {
            [g_navigationController popViewControllerAnimated:NO];
            [TZTUIBaseVCMsg OnMsg:_nMsgID wParam:(NSUInteger)self.pMsgInfo lParam:self.lParamInfo];
        }
        else
        {
            //新功能号 by xyt
            if (_nMsgType == WT_RZRQSTOCKHZ || _nMsgType == MENU_JY_RZRQ_Transit)
            {
                [g_navigationController popViewControllerAnimated:NO];
                tztUIRZRQStockHzViewController *pVC = [[tztUIRZRQStockHzViewController alloc] init];
                pVC.nMsgType = _nMsgType;
                [g_navigationController pushViewController:pVC animated:UseAnimated];
                [pVC release];
            }
        }
    }
}
-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    NSString* strErrMsg = [pParse GetErrorMessage];
    if ([pParse GetErrorNo] < 0)
    {
        if ([tztBaseTradeView IsExitError:[pParse GetErrorNo]])
            [self OnNeedLoginOut];
        if (strErrMsg)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        return 0;
    }
    if ([pParse IsAction:@"100"])
    {
        
        /* wry 不知道谁改的这个做什么
        NSString* nsPass = [_tztTableView GetEidtorText:2000];
        NSString* nsAccount = [_tztTableView GetEidtorText:3000];
        tztZJAccountInfo * pZJAccountInfo = NewObject(tztZJAccountInfo);
        pZJAccountInfo.nsAccount = [NSString stringWithFormat:@"%@", nsAccount];
        pZJAccountInfo.nsAccountType = @"ZJAccountType";
         */
      //  [tztJYLoginInfo SetLoginInAccount:pParse Pass_:nsPass AccountInfo_:pZJAccountInfo AccountType:TZTAccountDBPPTLogin];
        NSString* strTemp = [pParse GetByName:@"Token"];
        if(strTemp && [strTemp length] > 0)
        {
            g_CurUserData.nsDBPLoginToken = [NSString stringWithFormat:@"%@", strTemp];
        }
        [self OnOK];
    }
    
    return 0;
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if ([self CheckInput])
            {
                [self Login];
                return TRUE;
            }
            else
                return FALSE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}

//确定按钮 add by xyt 20131029
-(void)OnButtonClick:(id)sender
{
    tztUIButton *pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case 5000:
        {
            if ([self CheckInput])
            {
                [self Login];
            }
        }
            break;
        default:
            break;
    }
}

@end
