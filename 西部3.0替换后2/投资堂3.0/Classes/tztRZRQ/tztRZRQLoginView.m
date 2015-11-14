/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券登录
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztRZRQLoginView.h"
#import "TZTUIBaseVCMsg.h"
#import "tztUIAddAccountViewController.h"

@interface tztTradeLoginView(tztPrivate)
-(void)ChangeSegmentFont:(UIView *)aView;
//设置信息
-(void)OnSetPicker;
//删除账户
-(void)OnDelAccount;
//增加账户
-(void)OnAddAccount;
@end

@implementation tztRZRQLoginView
@synthesize tztTableView = _tztTableView;
@synthesize pickerData = _pickerData;
@synthesize segmentControl = _segmentControl;
@synthesize pMsgInfo = _pMsgInfo;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        
        _nLoginType = RZRQTrade_Log;
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
    
    rcFrame.origin.y += TZTToolBarHeight;
    rcFrame.size.height = self.bounds.size.height - TZTToolBarHeight;
    if (_tztTableView == nil)
    {
        _tztTableView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTableView.tztDelegate = self;
        [_tztTableView setTableConfig:@"tztUITradeLogin"];
        [self addSubview:_tztTableView];
        [_tztTableView release];
//        _tztTableView = [[TZTUIBaseTableView alloc] initWithFrame:rcFrame style:UITableViewStylePlain bRoundRect:YES delegate_:self];
//        _tztTableView.m_bOnlyRead = YES;
//        _tztTableView.m_bScrollEnable = NO;
//        _tztTableView.m_nFirstControlWidth = 90;
//        _tztTableView.m_nTitleWidth = 70;
//        _tztTableView.m_nRowHeight = 50;
//        _tztTableView.m_nCellMargin = 5;
//        _tztTableView.m_nTableMaxHeight = rcFrame.size.height;
        if (g_nHQBackBlackColor)
        {
            [_tztTableView setBackgroundColor:[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.6 alpha:1.0]];//背景
        }
        else
        {
            [_tztTableView setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];//背景
            
        }
//        [_tztTableView setTableData:@"tztTradeLoginSetting"];
        [self addSubview:_tztTableView];
        [_tztTableView release];
    }
    else
    {
        _tztTableView.frame = rcFrame;
//        [_tztTableView ResetTableStatus];
    }
    [self ShowTool:NO];
}

#pragma mark UISegmentedControl delegate
-(void)ChangeSegmentFont:(UIView *)aView
{
    if ([aView isKindOfClass:[UILabel class]])
    {
        UILabel *lb = (UILabel*)aView;
        [lb setTextAlignment:UITextAlignmentCenter];
        [lb setFont:tztUIBaseViewTextFont(14)];
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
    [pVC setMsgID:_nMsgID MsgInfo:(void*)self.pMsgInfo LPARAM:(NSUInteger)_lParam];
    
    if (IS_TZTIPAD)
    {
        TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
        if (!pBottomVC)
            pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
        CGRect rcFrom = CGRectZero;
        rcFrom.origin = pBottomVC.view.center;
        rcFrom.size = CGSizeMake(500, 600);
        [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
    }
    else
        [g_navigationController pushViewController:pVC animated:UseAnimated];
    
    [pVC release];
}

//记录页面功能，用于页面跳转
-(void)setMsgID:(NSInteger)nID MsgInfo:(void*)pMsgInfo LPARAM:(NSUInteger)lParam
{
    _nMsgID = nID;
    _pMsgInfo = pMsgInfo;
    if (_pMsgInfo)
        [_pMsgInfo retain];
    _lParam = lParam;
}

//获取用户预设账号信息
-(void)OnRefreshData
{
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
    [tztJYLoginInfo SetDefaultAccount:view.text nType_:TZTAccountRZRQType];
    
    tztZJAccountInfo *pCurZJ = [g_ZJAccountArray objectAtIndex:index];
    
    if (_bNeedCommPass != pCurZJ.nNeedComPwd)
    {
        _bNeedCommPass = pCurZJ.nNeedComPwd;
        if (pCurZJ.nNeedComPwd)
        {
            [_tztTableView setRowShow:YES withRowNum_:2];
        }
        else
            [_tztTableView setRowShow:NO withRowNum_:2];
        
        [_tztTableView reloadTableData];
        [_tztTableView ResetTableStatus];
        
        
        //        [NSTimer scheduledTimerWithTimeInterval:0.5
        //                                         target:self
        //                                       selector:@selector(OnDealData)
        //                                       userInfo:nil
        //                                        repeats:NO];
    }
    else
        [_tztTableView SetSysEditorText:@"" withTag:2000];
}

//删除预设账户
-(void)OnDealAccount
{
    
}

-(void)OnButton:(id)sender
{
    [self OnLogin];
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
    
    //当前选择的账号索引
    tztUIDroplistView* SliderDown = (tztUIDroplistView*)[self viewWithTag:1000];
    if (SliderDown == NULL)
        return;
    
    g_AccountIndex = SliderDown.selectindex;
    
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
#ifdef kSUPPORT_FIRST
    UIDevice *device = [UIDevice currentDevice];
    NSString* strModel = device.model;
    NSString* strVersion = device.systemVersion;
    NSString* strMobileKind = @"";
    
    strModel = [tztMoblieStockComm deviceString];
    
    if (strModel)
        strMobileKind = [NSString stringWithFormat:@"%@", strModel];
    if (strVersion)
        strMobileKind = [NSString stringWithFormat:@"%@-%@",strMobileKind, strVersion];
     NSString* strSystemVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
     NSString* strImei = [tztOpenUDID value];
    NSString* clientinfo=[@"yccft/" stringByAppendingString:strMobileKind];
    clientinfo=[clientinfo stringByAppendingString:strSystemVer];
    clientinfo=[clientinfo stringByAppendingString:strImei];
//    [pDict setTztValue:@"8" forKey:@"operway"];
     [pDict setTztValue:clientinfo forKey:@"clientinfo"];
#endif
    if (nsCommPass)
        [pDict setTztValue:nsCommPass forKey:@"ComPassword"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"104" withDictValue:pDict];
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
        NSString* nsPass = [_tztTableView GetSysEditorTextWithTag:2000];
        int nAccountType = TZTAccountPTType;
        if([pParse IsAction:@"104"])
            nAccountType = TZTAccountRZRQType;
        
		[tztJYLoginInfo SetLoginInAccount:pParse Pass_:nsPass AccountInfo_:pCurZJ AccountType:nAccountType];
		SEL doOkLogin;
        //判断登录类型
		if([tztJYLoginInfo getcreditfund] == 1)
		{
			doOkLogin = @selector(OnCreditOK);
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
    if ([TZTUserInfoDeal IsTradeLogin:StockTrade_Log] || [TZTUserInfoDeal IsTradeLogin:RZRQTrade_Log])
    {
        if (IS_TZTIPAD)
        {
            [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
            if (_nMsgID != -1)
            {
                [TZTUIBaseVCMsg OnMsg:_nMsgID wParam:(NSUInteger)self.pMsgInfo lParam:_lParam];
            }
        }
        else
        {
            
#ifdef tzt_NewVersion
            [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
#else
            [g_navigationController popViewControllerAnimated:UseAnimated];
            //返回，取消风火轮显示
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIViewController* pTop = g_navigationController.topViewController;
            if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
            {
                g_navigationController.navigationBar.hidden = NO;
                [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
            }
#endif
            //            [g_navigationController popViewControllerAnimated:NO];
            //            _lParam = 0;
            
            if (_nMsgID != -1)
            {
                [TZTUIBaseVCMsg OnMsg:_nMsgID wParam:(NSUInteger)self.pMsgInfo lParam:_lParam];
            }
        }
    }
    else
    {
#ifdef tzt_NewVersion
        [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
#else
        [g_navigationController popViewControllerAnimated:UseAnimated];
        //返回，取消风火轮显示
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        UIViewController* pTop = g_navigationController.topViewController;
        if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
        {
            g_navigationController.navigationBar.hidden = NO;
            [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
        }
#endif
    }
    
}

-(NSMutableArray*)getCurrentAccountAy
{
    NSMutableArray *tempAy = nil;
    //当前登录类型是普通交易
    if (_nLoginType == StockTrade_Log) 
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
        
        NSString* strAccountType = pZJAccount.nsAccountType;
        strAccountType = [strAccountType uppercaseString];
        if (strAccountType != NULL && [strAccountType hasPrefix:@"RZRQ"])
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
    
    g_AccountIndex = -1;
//	NSMutableArray * pAyCellData = NewObjectAutoD(NSMutableArray);
//	[pAyCellData removeAllObjects];
	NSString* nsfault = @"";
	//获取默认
	nsfault = [tztJYLoginInfo GetDefaultAccount:TRUE];
    
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
        //		[pAyCellData addObject:pZJAccount.nsAccount];
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
	tztUIDroplistView* SliderDown = (tztUIDroplistView*)[self viewWithTag:1000];
	if (SliderDown && [SliderDown isKindOfClass:[tztUIDroplistView class]])
	{
        SliderDown.ayData = _pickerData;
        SliderDown.ayValue = _pickerData;
		SliderDown.droplistViewType |= tztDroplistSecure;
        SliderDown.title = @"交易账号";
		//设置默认的
		if(_pickerData && [_pickerData count] > g_AccountIndex)
		{
			SliderDown.selectindex = g_AccountIndex;
            SliderDown.text = [_pickerData objectAtIndex:g_AccountIndex];
		}
		else 
		{
			g_AccountIndex = -1;
			SliderDown.selectindex = -1;
			SliderDown.text = @"";
		}
		[SliderDown.listView reloadData];
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
                if([_tztTableView CheckInput:_tztTableView])
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
