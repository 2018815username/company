/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易/融资融券登录
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztTradeLoginView.h"
#import "TZTUIBaseVCMsg.h"
#import "tztUIAddAccountViewController.h"

#define tztYZM  @"验证码"
#define tztDTKL @"动态口令"

@interface tztTradeLoginView(tztPrivate)
-(void)ChangeSegmentFont:(UIView *)aView;
//设置信息
-(void)OnSetPicker;
//删除账户
-(void)OnDelAccount;
//增加账户
-(void)OnAddAccount;
@end

@implementation tztTradeLoginView
@synthesize tztTableView = _tztTableView;
@synthesize pickerData = _pickerData;
@synthesize segmentControl = _segmentControl;
@synthesize pMsgInfo = _pMsgInfo;
@synthesize nLoginType = _nLoginType;
@synthesize bISHz = _bISHz;
@synthesize lParam = _lParam;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _bISHz = FALSE;
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_pickerData);
    if (_pMsgInfo)
    {
        [_pMsgInfo release];
        _pMsgInfo = nil;
    }
//    if (_lParam)
//    {
//        [_lParam release];
//        _lParam = nil;
//    }
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;

    CGRect rcSeg = rcFrame;
    rcSeg.size.height = TZTToolBarHeight;
    if (_pView == NULL)
    {
        _pView = [[UIToolbar alloc] initWithFrame:rcSeg];
        [self addSubview:_pView];
        [_pView release];
    }
    else
    {
        _pView.frame = rcSeg;
    }
    
    rcSeg.size.width = 200;
    rcSeg.origin.x = (rcFrame.size.width - rcSeg.size.width) / 2;
    rcSeg.size.height = 33;
    rcSeg.origin.y = rcSeg.origin.y + (TZTToolBarHeight - 33) / 2;
    if (_segmentControl == NULL)
    {
        NSArray *pAy = [NSArray arrayWithObjects:@"账号登录", @"预设账号", nil];
        _segmentControl = [[UISegmentedControl alloc] initWithItems:pAy];
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.segmentedControlStyle = UISegmentedControlStyleBordered;
        _segmentControl.frame = rcSeg;
        [_segmentControl addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segmentControl];
        [self ChangeSegmentFont:_segmentControl];
        [_segmentControl release];
    }
    else
    {
        _segmentControl.frame = rcSeg;
    }
    if (IS_TZTIPAD)
    {
        rcFrame = CGRectInset(rcFrame, 20, 5);
    }
    rcFrame.origin.y += TZTToolBarHeight;
    rcFrame.size.height = self.bounds.size.height - rcFrame.origin.y;
    if (_tztTableView == nil)
    {
        _tztTableView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTableView.tztDelegate = self;
        [_tztTableView setTableConfig:@"tztUITradeLogin"];
        [self addSubview:_tztTableView];
        [_tztTableView release];
    }
    else
    {
        _tztTableView.frame = rcFrame;
    }
    [self ShowTool:NO];
    
	[self SetHZ];
    
    if (_pickComPwdType == NULL)
        _pickComPwdType = NewObject(NSMutableArray);
    [_pickComPwdType removeAllObjects];
    [_pickComPwdType addObject:@"通讯密码"];
    [_pickComPwdType addObject:@"动态口令"];
    if (_tztTableView )
    {
        [_tztTableView setComBoxData:_pickComPwdType ayContent_:_pickComPwdType AndIndex_:0 withTag_:1001];
    }

}

//处理融资融券划转登录
-(void)SetHZ
{
    if (!_bISHz)
        return;
    
    if (g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < 1)
        return;
    //当前融资融券账号数据
    NSMutableArray* ayLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountRZRQType];
    if (ayLoginInfo == NULL || [ayLoginInfo count] < 1)
        return;
    
    tztJYLoginInfo* pJyLoginInfo = [ayLoginInfo objectAtIndex:0];
    if (pJyLoginInfo == NULL)
        return;
    
    
    //融资融券对应的普通账号
    NSString* strAccount = pJyLoginInfo.nsUserCode;
    if (strAccount == NULL || [strAccount length] < 1)
        return;
    
    //普通账号
    if (_pickPtData == NULL)
        _pickPtData = NewObject(NSMutableArray);
    [_pickPtData removeAllObjects];
    
    tztZJAccountInfo* pZJAccount = pJyLoginInfo.ZjAccountInfo;
    if (pZJAccount == nil)
        return;
    
    pZJAccount.nsAccount = strAccount;
    [_pickPtData addObject:pZJAccount];
    
    [self OnSetPicker];
}


#pragma mark UISegmentedControl delegate
-(void)ChangeSegmentFont:(UIView *)aView
{
    if ([aView isKindOfClass:[UILabel class]])
    {
        UILabel *lb = (UILabel*)aView;
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setFont:tztUIBaseViewTextFont(14.f)];
    }
    NSArray *na = [aView subviews];
    NSEnumerator *ne = [na objectEnumerator];
    UIView *subView;
    while (subView = [ne nextObject]) 
    {
        [self ChangeSegmentFont:subView];
    }
}
#pragma mark 选择登录还是预设
-(void)doSelect:(id)sender
{
	UISegmentedControl *control = (UISegmentedControl*)sender;
	switch (control.selectedSegmentIndex) 
	{
		case 1://点击的时预设账号
		{
            [self OnAddAccount];
            control.selectedSegmentIndex = 0;
		}
			break;
		case 0:
        {
            
        }
            break;
		default:
			break;
	}	
    [self ChangeSegmentFont:control];
	return;
}


-(void)OnAddAccount
{
    
    BOOL bPush = FALSE;
    tztUIAddAccountViewController *pVC = (tztUIAddAccountViewController *)gettztHaveViewContrller([tztUIAddAccountViewController class], tztvckind_Pop,[NSString stringWithFormat:@"%d", MENU_SYS_JYLogin], &bPush,TRUE);
    
    [pVC retain];
    
//    [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIAddAccountViewController class]];
//    tztUIAddAccountViewController *pVC = [[tztUIAddAccountViewController alloc] init];
    pVC.nLoginType = _nLoginType;
    [pVC setMsgID:_nMsgID MsgInfo:(void*)self.pMsgInfo LPARAM:(NSUInteger)_lParam];
    
    if (IS_TZTIPAD)
    {
        TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
        if (!pBottomVC)
            pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
        CGRect rcFrom = CGRectZero;
        rcFrom.origin = pBottomVC.view.center;
        rcFrom.size = CGSizeMake(500, 500);
        [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
    }
    else
    {
#ifdef tzt_NewVersion
        pVC.pParentVC = self.delegate;
        [TZTUIBaseVCMsg IPadPushViewController:self.delegate pop:pVC];
#else
        [g_navigationController popViewControllerAnimated:NO];
        [g_navigationController pushViewController:pVC animated:NO];
#endif
    }
    
    [pVC release];
}

//记录页面功能，用于页面跳转
-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(void*)lParam
{
    _nMsgID = nID;
    _pMsgInfo = pMsgInfo;
    if (_pMsgInfo)
        [_pMsgInfo retain];
    self.lParam = lParam;
//    if (_lParam)
//        [_lParam retain];
}

//获取用户预设账号信息
-(void)OnRefreshData
{
    if (_bISHz)
        return;
    
    //发送数据时候,清空下拉框内容,避免只有一条数据时,删除后,显示错误的问题 modify by xyt 20132024
    [_tztTableView setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:1000];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"207" withDictValue:pDict];
    DelObject(pDict);
}


- (void)tztDroplistView:(tztUIDroplistView *)view didSelectIndex:(int)index//选中
{
    //切换通讯密码和动态口令不清空密码输入
    if ([view.tzttagcode intValue] == 1001)
    {
        [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
        return;
    }
    

    [tztJYLoginInfo SetDefaultAccount:view.text nType_:_nLoginType];
    
    tztZJAccountInfo *pCurZJ = [g_ZJAccountArray objectAtIndex:index];
    
    if (_bNeedCommPass != pCurZJ.nNeedComPwd)
    {
        _bNeedCommPass = pCurZJ.nNeedComPwd;
        [_tztTableView SetImageHidenFlag:@"TZTTXMM" bShow_:_bNeedCommPass];
        [_tztTableView OnRefreshTableView];
    }
    else
    {
        [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:2000];
        [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
    }
}

//删除预设账户
-(void)OnDealAccount
{
    
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton *btn = (tztUIButton*)sender;
    if ([btn.tzttagcode intValue] == 4000)
    {
        if(_tztTableView)
        {
            if([_tztTableView CheckInput])
                [self OnLogin];
        }
    }
    else if ([btn.tzttagcode intValue] == 4001)
    {
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_MNJY wParam:(NSUInteger)self.delegate lParam:0];
    }
}

//用户登录
-(void)OnLogin
{
    //最大用户数判断
    //    if (g_ayJYLoginInfo && [g_ayJYLoginInfo count] >= TZTMaxAccount - 1)
    //    {
    //        char str[200];
    //        sprintf(str, "最多只能同时登录%d个交易账号!\r\n", TZTMaxAccount - 1);
    //        AfxMessageBox(str);
    //        return;
    //    }
    
    g_AccountIndex = [_tztTableView getComBoxSelctedIndex:1000];
    
    NSMutableArray *tempAy = [self getCurrentAccountAy];
    if (tempAy == NULL || [tempAy count] < 1)
        return;
    
    if (g_AccountIndex < 0 || g_AccountIndex >= [tempAy count])
        return;
    
    //获取当前账号信息
    tztZJAccountInfo *pCurZJ = [tempAy objectAtIndex:g_AccountIndex];//[tztZJAccountInfo GetCurAccount];
    if (pCurZJ == NULL || pCurZJ.nsAccount == NULL || [pCurZJ.nsAccount length] <= 0)
    {
        //        AfxMessageBox(@"账号不能为空!");
        return;
    }
    
    NSString* nsPass = [_tztTableView GetEidtorText:2000];
    if (nsPass == NULL || [nsPass length] <= 0)
    {
        nsPass = [_tztTableView GetEidtorText:2000];
        if (nsPass == NULL || [nsPass length] <= 0) 
            return;
    }
    
    NSString* nsCommPass = [_tztTableView GetEidtorText:2001];
    
    NSInteger nType = [_tztTableView getComBoxSelctedIndex:1001];
    NSString *nsType = @"";
    if (nType >= 0 && nType < [_pickComPwdType count])
    {
        nsType = [NSString stringWithFormat:@"%ld",(long)nType];
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    if (pCurZJ.nsAccountType)
        [pDict setTztValue:pCurZJ.nsAccountType forKey:@"accounttype"];
    if (pCurZJ.nsCellIndex)
        [pDict setTztValue:pCurZJ.nsCellIndex forKey:@"YybCode"];
    
    [pDict setTztValue:pCurZJ.nsAccount forKey:@"account"];
    [pDict setTztValue:nsPass forKey:@"password"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    if (nsType && nsType.length > 0)
        [pDict setTztValue:nsType forKey:@"Direction"];
    
    if (nsCommPass)
        [pDict setTztValue:nsCommPass forKey:@"ComPassword"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    
    if (_nLoginType == TZTAccountPTType)
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"100" withDictValue:pDict];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"104" withDictValue:pDict];
    }
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    if ([pParse GetErrorNo] < 0)
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        if ([pParse IsAction:@"340"])//多银行请求，虽然失败，但仍然可以使用
        {
            [self OnOK];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"207"])
    {
        g_AccountIndex = -1;
        [tztJYLoginInfo SetAccountList:pParse];
        [self setAccountWithType];
        [self OnSetPicker];
        [TZTUserInfoDeal SaveAndLoadJYAccountList:TRUE];
    }
    if ([pParse IsAction:@"100"] || [pParse IsAction:@"104"]) 
    {
		tztZJAccountInfo* pCurZJ =  NULL;
		if(g_ZJAccountArray && g_AccountIndex >= 0 && g_AccountIndex < [g_ZJAccountArray count])//数组越界
			pCurZJ = [g_ZJAccountArray objectAtIndex:g_AccountIndex];
        NSString* nsPass = [_tztTableView GetEidtorText:2000];
        int nAccountType = TZTAccountPTType;
        if([pParse IsAction:@"104"])
            nAccountType = TZTAccountRZRQType;
        
		[tztJYLoginInfo SetLoginInAccount:pParse Pass_:nsPass AccountInfo_:pCurZJ AccountType:nAccountType];
		SEL doOkLogin;
        //判断登录类型
		if([tztJYLoginInfo getcreditfund] == 1 || nAccountType == TZTAccountRZRQType)
		{
			doOkLogin = @selector(OnOK);
		}
		else//非融资融券账户，请求多账户信息
		{
            //doOkLogin = @selector(OnOK);
            doOkLogin = @selector(doInquireMoreAccount);
		}
		[NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self 
                                       selector:doOkLogin
                                       userInfo:nil
                                        repeats:NO];
        
    }
    if ([pParse IsAction:@"340"])
    {
        tztJYLoginInfo *pJyLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
        [pJyLoginInfo saveMoreAccountToDealerInfo:pParse];
        [self OnOK];
    }
    
    if ([pParse IsAction:@"209"])
    {
        NSString* strMsg = [pParse GetErrorMessage];
        [self showMessageBox:strMsg nType_:TZTBoxTypeNoButton nTag_:0 delegate_:self withTitle_:@"删除账号"];
        //重新刷新界面数据
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self 
                                       selector:@selector(OnRefreshData)
                                       userInfo:nil
                                        repeats:NO];
    }
    return 0;
}

-(void) doInquireMoreAccount
{
#ifdef Support_DFCG//支持多存管
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    tztZJAccountInfo *pCurZJ = [tztZJAccountInfo GetCurAccount];
    if (pCurZJ.nsAccount)
        [pDict setTztValue:pCurZJ.nsAccount forKey:@"account"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"340" withDictValue:pDict];
    DelObject(pDict);
#else//不支持，直接跳转
    [self OnOK];
#endif
}

-(void)OnOK
{
// cs
    NSData  *pData = [_pMsgInfo retain];
//      UInt32  nMsgInfo=(UInt32)self.pMsgInfo;
//      UInt32  nParam=(UInt32)self.lParam;
//
    
    if ([TZTUserInfoDeal IsTradeLogin:StockTrade_Log] || [TZTUserInfoDeal IsTradeLogin:RZRQTrade_Log])
    {
        if (IS_TZTIPAD)
        {
            [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
            if (_nMsgID != -1)
            {
                [TZTUIBaseVCMsg OnMsg:_nMsgID wParam:(NSUInteger)self.pMsgInfo lParam:self.lParam];
            }
        }
        else
        {
            
#ifdef tzt_NewVersion
            [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
#else
            [g_navigationController popViewControllerAnimated:NO];
#endif
//            _lParam = 0;
          
            if (_nMsgID != -1)
            {
                //			UIViewController *pVC = [g_navigationController topViewController];
                //			if ([pVC isKindOfClass:[TZTFundTradeViewController class]]) 
                //			{
                //				[(TZTFundTradeViewController*)pVC sendActionFromId:m_nMsgID];
                //				return;
                //			}
 //    cs "TZTUIBaseVCMsg OnMsg:_nMsgID wParam:(UInt32)self.pMsgInfo lParam:self.lParam];"  ios 7 崩溃
                [TZTUIBaseVCMsg OnMsg:_nMsgID wParam:(NSUInteger)pData lParam:_lParam];
            }
        }
		
    }
    else
    {
#ifdef tzt_NewVersion
        [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
#else
        [g_navigationController popViewControllerAnimated:UseAnimated];
#endif
    }
    
    [pData release];
    
}

-(NSMutableArray*)getCurrentAccountAy
{
    NSMutableArray *tempAy = nil;
    //当前登录类型是普通交易
    if (_nLoginType == TZTAccountPTType) 
    {
        if ([_pickPtData count] > 0) 
        {
            tempAy = [NSMutableArray arrayWithArray:_pickPtData];
        }
    }
    else
    {
        if ([_pickRZRQData count] > 0)
        {
            tempAy = [NSMutableArray arrayWithArray:_pickRZRQData];
        }
    }
    
    return tempAy;
}

-(void)setAccountWithType
{
    //普通账号
    if (_pickPtData == NULL)
        _pickPtData = NewObject(NSMutableArray);
    [_pickPtData removeAllObjects];
    
    //融资融券账号
    if (_pickRZRQData == NULL)
        _pickRZRQData = NewObject(NSMutableArray);
    [_pickRZRQData removeAllObjects];
    
    if (g_ZJAccountArray == NULL || [g_ZJAccountArray count] <1) 
        return;
    
    for (int i = 0; i < [g_ZJAccountArray count]; i++) 
    {
        tztZJAccountInfo* pZJAccount = [g_ZJAccountArray objectAtIndex:i];
        if (pZJAccount == nil)
            continue;
        NSString* strType = [NSString stringWithFormat:@"%@", pZJAccount.nsAccountType];
        if (strType == NULL)
            continue;
        strType = [strType uppercaseString];
        if (strType != NULL && [strType hasPrefix:@"RZRQ"])
        {
            [_pickRZRQData addObject:pZJAccount];
        }
        else
        {
            [_pickPtData addObject:pZJAccount];
        }
        
    }
}

//设置信息
-(void)OnSetPicker
{
    if (_pickerData == NULL)
        _pickerData = NewObject(NSMutableArray);
    [_pickerData removeAllObjects];
    
    //根据登录的类型获取
    NSMutableArray *tempAy = [self getCurrentAccountAy];
    if (tempAy == NULL || [tempAy count] < 1)
        return;
    
    //清空账号数据,重新设置
    [g_ZJAccountArray removeAllObjects];
    [g_ZJAccountArray setArray:tempAy];
    
    g_AccountIndex = -1;
	NSString* nsfault = @"";
	//获取默认
	nsfault = [tztJYLoginInfo GetDefaultAccount:YES nType_:_nLoginType];
    
	for (int i = 0; i < [tempAy count]/*g_ZjAccountArrayNum*/; i++)
	{
		tztZJAccountInfo* pZJAccount = [tempAy objectAtIndex:i];//[g_ZJAccountArray objectAtIndex:i];
        if (pZJAccount == nil)
            continue;
		if(nsfault && [nsfault length] > 0)
		{
			if ([nsfault compare:pZJAccount.nsAccount] == NSOrderedSame )
			{
				g_AccountIndex = i;
			}
		}
		[_pickerData addObject:pZJAccount.nsAccount];
	}
    
    if (g_AccountIndex < 0 || g_AccountIndex >= [tempAy count]/*g_ZjAccountArrayNum*/)
    {
        g_AccountIndex = 0;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(OnDealData)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)SetDefaultData
{
    [self OnDealData];
}

-(void)OnDealData
{
	//设置下拉框的账号选择数据
    if(_pickerData && [_pickerData count] > g_AccountIndex)
    {
        [_tztTableView setComBoxData:_pickerData ayContent_:_pickerData AndIndex_:g_AccountIndex withTag_:1000];
    }
    else
    {
        g_AccountIndex = -1;
        [_tztTableView setComBoxData:_pickerData ayContent_:_pickerData AndIndex_:g_AccountIndex withTag_:1000];
    }
}


//删除账号
- (BOOL)tztDroplistView:(tztUIDroplistView *)droplistview didDeleteIndex:(int)index
{
    g_AccountIndex = index;
    [self OnDelAccount];
    return TRUE;
}

-(void)OnDelAccount
{
    //检查有效性
    if (g_AccountIndex < 0 || g_AccountIndex >= [g_ZJAccountArray count]) 
    {
		[self showMessageBox:@"没有账号可以操作!" nType_:TZTBoxTypeNoButton delegate_:self];
        return;
    }
    
    //得到账户
    tztZJAccountInfo *pZJAccount = [g_ZJAccountArray objectAtIndex:g_AccountIndex];
    //本地手动添加的
    if (pZJAccount.nsCellName == NULL || [pZJAccount.nsCellName length] < 1)
    {
        [g_ZJAccountArray removeObject:pZJAccount];
        g_ZjAccountArrayNum = [g_ZJAccountArray count];
        //重新保存
        //重新设置下拉列表的显示数据
        return;
    }
    
    
    //
    if (pZJAccount.nsCellIndex == NULL || [pZJAccount.nsCellIndex length] < 1)
        return;
    if (pZJAccount.nsAccount == NULL || [pZJAccount.nsAccount length] < 1)
        return;
    if (pZJAccount.nsAccountType == NULL || [pZJAccount.nsAccountType length] < 1)
        return;
    //向服务器发送删除账号请求
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [pDict setTztValue:pZJAccount.nsCellIndex forKey:@"YybCode"];
    [pDict setTztValue:pZJAccount.nsAccount forKey:@"account"];
    [pDict setTztValue:pZJAccount.nsAccountType forKey:@"accounttype"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"209" withDictValue:pDict];
    DelObject(pDict);
}


-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if(_tztTableView)
            {                
                if([_tztTableView CheckInput])
                    [self OnLogin];
            }
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRefreshData];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Add:
        {
            [self OnAddAccount];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Del:
        {
            [self OnDelAccount];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Clear://
        {
            return TRUE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}

@end
