/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztAddAccountView.h"
#import "TZTUIBaseVCMsg.h"
#import "tztUITradeLogindViewController.h"
#import "tztUISysLoginViewController.h"
//#define tztCode @"tztCode"
//#define tztName @"tztName"

enum{
    ADDACCOUNT_COM_NONE = 0,
    ADDACCOUNT_COM_ZQGS = 1,
    ADDACCOUNT_COM_YYB,
    ADDACCOUNT_COM_TYPE,
};


@interface tztAddAccountView(tztPrivate)
-(void)ChangeSegmentFont:(UIView *)aView;
@end


@implementation tztAddAccountView

@synthesize tztTableView = _tztTableView;
@synthesize ayZQGS = _ayZQGS;
@synthesize ayYYB = _ayYYB;
@synthesize ayType = _ayType;
@synthesize segmentControl = _segmentControl;
@synthesize pMsgInfo = _pMsgInfo;
@synthesize nLoginType = _nLoginType;

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    if (_pMsgInfo)
        [_pMsgInfo release];
    DelObject(_ayZQGS);
    DelObject(_ayYYB);
    DelObject(_ayType);
    DelObject(_ZJTypeDict);
    [super dealloc];
}

-(id)init
{
    if (self = [super init])
    {
        _nZQGSIndex = -1;
        _nYYBIndex = -1;
        _nTypeIndex = -1;
        _bNeedComPass = FALSE;
        _ZJTypeDict = NewObject(NSMutableDictionary);
        [_ZJTypeDict setObject:@"ZJACCOUNT" forKey:@"资金号"];
        [_ZJTypeDict setObject:@"SHACCOUNT" forKey:@"上海A股"];
        [_ZJTypeDict setObject:@"SZACCOUNT" forKey:@"深圳A股"];
        [_ZJTypeDict setObject:@"SHBACCOUNT" forKey:@"上海B股"];
        [_ZJTypeDict setObject:@"SZBAccount" forKey:@"深圳B股"];
        
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    
//    CGRect rcSeg = rcFrame;
//    rcSeg.size.height = TZTToolBarHeight;
//    if (_pView == NULL)
//    {
//        _pView = [[UIToolbar alloc] initWithFrame:rcSeg];
//        [self addSubview:_pView];
//        [_pView release];
//    }
//    else
//    {
//        _pView.frame = rcSeg;
//    }
    
//    rcSeg.size.width = 200;
//    rcSeg.origin.x = (rcFrame.size.width - rcSeg.size.width) / 2;
//    rcSeg.size.height = 33;
//    rcSeg.origin.y = rcSeg.origin.y + (TZTToolBarHeight - 33) / 2;
//    if (_segmentControl == NULL)
//    {
//        NSArray *pAy = [NSArray arrayWithObjects:@"账号登录", @"账号管理", nil];
//        _segmentControl = [[UISegmentedControl alloc] initWithItems:pAy];
//        _segmentControl.selectedSegmentIndex = 1;
//        _segmentControl.segmentedControlStyle = UISegmentedControlStyleBordered;
//        _segmentControl.frame = rcSeg;
//        [_segmentControl addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventValueChanged];
//        [_pView addSubview:_segmentControl];
//        [self ChangeSegmentFont:_segmentControl];
//        [_segmentControl release];
//    }
//    else
//    {
//        _segmentControl.frame = rcSeg;
//    }
//    
    if (IS_TZTIPAD)
    {
        rcFrame = CGRectInset(rcFrame, 20, 5);
    }
    rcFrame.origin.y =0;
    rcFrame.size.height = self.bounds.size.height;
    if (_tztTableView == nil)
    {
        _tztTableView = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTableView.tztDelegate = self;
        [_tztTableView setTableConfig:@"tztUITradeLogin_AddCount"];
        [self addSubview:_tztTableView];
        [_tztTableView release];
    }
    else
    {
        _tztTableView.frame = rcFrame;
    }
    
//    [self ShowTool:NO];
//    [self bringSubviewToFront:_pView];
    
    NSMutableArray *ayData = NewObject(NSMutableArray);
    [ayData addObject:@"普通委托"];
    [ayData addObject:@"融资融券"];
    
    [_tztTableView setComBoxData:ayData ayContent_:ayData AndIndex_:(_nLoginType == TZTAccountRZRQType)?1:0 withTag_:998];
    
    NSMutableArray *ayDataT = NewObject(NSMutableArray);
    [ayDataT addObject:@"通讯密码"];
    [ayDataT addObject:@"动态口令"];
    [_tztTableView setComBoxData:ayDataT ayContent_:ayDataT AndIndex_:0 withTag_:1002];
    

}

-(void)reloadSubViews{
    CGRect rcFrame = self.bounds;
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
        [_tztTableView setTableConfig:_segmentControl.selectedSegmentIndex==1?@"tztUIAddAccount":@"tztUITradeLogin_AddCount"];//tztUIAddAccount
        [self addSubview:_tztTableView];
        [_tztTableView release];
    }
    else
    {
        [_tztTableView setTableConfig:_segmentControl.selectedSegmentIndex==1?@"tztUIAddAccount":@"tztUITradeLogin_AddCount"];
        _tztTableView.frame = rcFrame;
    }

}
#pragma mark UISegmentedControl delegate
-(void)ChangeSegmentFont:(UIView *)aView
{
    [self reloadSubViews];
    if (_segmentControl.selectedSegmentIndex==1) {

        [self OnRefreshData];
    }
    else{
        NSMutableArray *ayData = NewObject(NSMutableArray);
        [ayData addObject:@"普通委托"];
        [ayData addObject:@"融资融券"];
        
        [_tztTableView setComBoxData:ayData ayContent_:ayData AndIndex_:(_nLoginType == TZTAccountRZRQType)?1:0 withTag_:998];
        
        NSMutableArray *ayDataT = NewObject(NSMutableArray);
        [ayDataT addObject:@"通讯密码"];
        [ayDataT addObject:@"动态口令"];
        [_tztTableView setComBoxData:ayDataT ayContent_:ayDataT AndIndex_:0 withTag_:1002];
        
        [self OnLoadYYB];//获取账号信息
    }
//    if ([aView isKindOfClass:[UILabel class]])
//    {
//        UILabel *lb = (UILabel*)aView;
//        [lb setTextAlignment:NSTextAlignmentCenter];
//        [lb setFont:tztUIBaseViewTextFont(14.0f)];
//    }
//    NSArray *na = [aView subviews];
//    NSEnumerator *ne = [na objectEnumerator];
//    UIView *subView;
//    while (subView = [ne nextObject]) 
//    {
//        [self ChangeSegmentFont:subView];
//    }
}
#pragma mark 选择登录还是预设
-(void)doSelect:(id)sender
{
	UISegmentedControl *control = (UISegmentedControl*)sender;
    [self ChangeSegmentFont:control];
	switch (control.selectedSegmentIndex) 
	{
		case 0://点击的时预设账号
		{
#ifdef tzt_NewVersion
//            if (self.delegate && [self.delegate respondsToSelector:@selector(OnPopSelf)])
//            {
//                [self.delegate OnPopSelf];
//            }
#else
            [g_navigationController popViewControllerAnimated:NO];
            tztUITradeLogindViewController* pVC = (tztUITradeLogindViewController*)[TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUITradeLogindViewController class]];
            if (pVC == NULL)
            {
                pVC = [[tztUITradeLogindViewController alloc] init];
                pVC.nLoginType = _nLoginType;//添加类型
                [pVC setMsgID:_nMsgID MsgInfo:(void*)_pMsgInfo LPARAM:(NSUInteger)_lParam];
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
                    [g_navigationController pushViewController:pVC animated:NO];
                }
                [pVC release];
            }
            else
            {
                pVC.nLoginType = _nLoginType;
                [pVC setMsgID:_nMsgID MsgInfo:(void*)_pMsgInfo LPARAM:(NSUInteger)_lParam];
            }
#endif
		}
			break;
		default:
			break;
	}
	return;
}



//设置下拉框数据
-(void)OnSetPicker:(int)nType pParse_:(tztNewMSParse*)pParse
{
    if (pParse == NULL)
        return;
    switch (nType)
    {
            //设置证券公司
        case ADDACCOUNT_COM_ZQGS:
        {
            if (_ayZQGS == NULL)
                _ayZQGS = NewObject(NSMutableArray);
            
            [_ayZQGS removeAllObjects];
            
            //加载数据
            NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
            NSMutableArray  *ayCom = NewObject(NSMutableArray);
            NSMutableArray  *ayComCode = NewObject(NSMutableArray);
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *pAy = [ayGrid objectAtIndex:i];
                if ([pAy count] < 2)
                    continue;
                //证券公司代码
                NSString* nsCode = [pAy objectAtIndex:0];

                if (nsCode == NULL || [nsCode length] < 1)
                    continue;
                //公司名称
                NSString* nsName = [pAy objectAtIndex:1];
                
                //过滤融资融券
                if (_nLoginType == TZTAccountRZRQType)
                {
                    if (g_pSystermConfig && g_pSystermConfig.sRZRQYYBCode.length > 0)
                    {
                        NSString* strCode = [nsCode lowercaseString];
                        if ([[g_pSystermConfig.sRZRQYYBCode lowercaseString] compare:strCode] != NSOrderedSame)
                            continue;
                    }
                }
                if (_nLoginType == TZTAccountPTType)
                {
                    if (g_pSystermConfig && g_pSystermConfig.sRZRQYYBCode.length > 0)
                    {
                        NSString* strCode = [nsCode lowercaseString];
                        if ([[g_pSystermConfig.sRZRQYYBCode lowercaseString] compare:strCode] == NSOrderedSame)
                            continue;
                    }
                }
                
                NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
                [pDict setTztValue:nsCode forKey:tztCode];
                if (nsName == NULL )
                    nsName = @"";
                [pDict setTztValue:nsName forKey:tztName];
                
                [ayCom addObject:nsName];
                [ayComCode addObject:nsCode];
                
                [_ayZQGS addObject:pDict];
                [pDict release];
            }
            
            if ([ayCom count] > 0)
            {
//                [_tztTableView setComBoxData:ayCom ayContent_:ayComCode AndIndex_:0 withTag_:5000];
                //加载营业部
                _nZQGSIndex = 0;
                [self OnLoadYYB];
            }
            DelObject(ayCom);
            DelObject(ayComCode);
        }
            break;
            //设置营业部
        case ADDACCOUNT_COM_YYB:
        {
            if (_ayYYB == NULL)
                _ayYYB = NewObject(NSMutableArray);
            [_ayYYB removeAllObjects];
            
            NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
            NSMutableArray *ayYYB = NewObject(NSMutableArray);
            NSMutableArray *ayYYBCode = NewObject(NSMutableArray);
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *pAy = [ayGrid objectAtIndex:i];
                if ([pAy count] < 2)
                    continue;
                //证券公司代码
                NSString* nsCode = [pAy objectAtIndex:0];
                if (nsCode == NULL || [nsCode length] < 1)
                    continue;
                //公司名称
                NSString* nsName = [pAy objectAtIndex:1];
                NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
                [pDict setTztValue:nsCode forKey:tztCode];
                if (nsName == NULL )
                    nsName = @"";
                [pDict setTztValue:nsName forKey:tztName];
                
                [ayYYB addObject:nsName];
                [ayYYBCode addObject:nsCode];
                
                [_ayYYB addObject:pDict];
                [pDict release];
            }
            
            if ([ayYYB count] > 0)
            {
                [_tztTableView setComBoxData:ayYYB ayContent_:ayYYBCode AndIndex_:0 withTag_:1000];
                //加载营业部
                _nYYBIndex = 0;
            }
            DelObject(ayYYB);
            DelObject(ayYYBCode);
        }
            break;
            //设置账号类型
        case ADDACCOUNT_COM_TYPE:
        {
            if (_ayType == NULL)
                _ayType = NewObject(NSMutableArray);
            
            [_ayType removeAllObjects];
            //账号类型
            NSString* strData = [pParse GetByNameUnicode:@"accounttype"];
            
            strData = [strData stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            
            NSMutableArray *ayAccountType = NewObject(NSMutableArray);
            NSMutableArray *ayAccountName = NewObject(NSMutableArray);
            if (strData && [strData length] > 0)
            {
                NSArray *pAyType = [strData componentsSeparatedByString:@"|"];
                NSInteger nCount = [pAyType count] / 2;
                for ( NSInteger i = 0; i < nCount; i++)
                {
                    //
                    NSString* strType = [pAyType objectAtIndex:i*2];
                    //
                    if (i*2+1 >= [pAyType count])
                        break;
                    NSString* strName = [pAyType objectAtIndex:i*2+1];
                    if (_nLoginType == TZTAccountRZRQType)
                    {
                        strType = [strType uppercaseString];
                        if (!([strType hasPrefix:@"RZRQ"] ||[strName isEqualToString:@"融资融券"]))
                            continue;
                    }
                    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
                    [pDict setTztValue:strType forKey:tztCode];
                    [pDict setTztValue:strName forKey:tztName];
                    [ayAccountName addObject:strName];
                    [ayAccountType addObject:strType];
                    [_ayType addObject:pDict];
                    [pDict release];
                }
                
                if ([ayAccountType count] > 0)
                {
                    [_tztTableView setComBoxData:ayAccountName ayContent_:ayAccountType AndIndex_:0 withTag_:2000];
                    _nTypeIndex = 0;
                }
            }
            DelObject(ayAccountName);
            DelObject(ayAccountType);
        }
            break;
            
        default:
            break;
    }
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
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"200" withDictValue:pDict];
    DelObject(pDict);
}

//获取营业部信息
-(void)OnLoadYYB
{
    if (_nZQGSIndex < 0 || [_ayZQGS count] < 1 || _nZQGSIndex >= [_ayZQGS count])
        return;
    
    //
    NSMutableDictionary *pZQGS = [_ayZQGS objectAtIndex:_nZQGSIndex];
    if (pZQGS == NULL)
        return;
    NSString* nsZQGS = [pZQGS tztObjectForKey:tztCode];
    if (nsZQGS == NULL || [nsZQGS length] < 1)
        return;
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsZQGS forKey:@"YybCode"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"201" withDictValue:pDict];
    DelObject(pDict);
}

//增加账号
-(void)AddAccount
{
    //获取数据
    
    //营业部号
    _nYYBIndex = [_tztTableView getComBoxSelctedIndex:5000];
    NSString* strYYBCode = @"";
    
    if (_nYYBIndex >= 0 && _nYYBIndex < [yyBCode count])
    {
        strYYBCode= [yyBCode objectAtIndex:_nYYBIndex];
//        strYYBCode = [pDictYYB tztValueForKey:tztCode];
    }
    
    if (strYYBCode == NULL || [strYYBCode length] <= 0 )
    {
        //选择营业部为空，需要界面刷新数据
        [self showMessageBox:@"营业部数据错误，请重新刷新数据!" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    //获取输入账号
    NSString* strAccount = [_tztTableView GetEidtorText:1000];
    if (strAccount == NULL || [strAccount length] < 1)
    {
        //提示输入用户账号
        [self showMessageBox:@"账号数据错误，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    //获取密码
    NSString* strPass = [_tztTableView GetEidtorText:1001];
    if (strPass == NULL || [strPass length] < 1)
    {
        //提示输入密码
        [self showMessageBox:@"密码数据错误，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
//    //通讯密码
//    NSString* strCommPass = [_tztTableView GetEidtorText:4001];
    
    //获取账号类型
    _nTypeIndex = [_tztTableView getComBoxSelctedIndex:999];
    NSString* strType = @"";
    if (_nTypeIndex >= 0 && _nTypeIndex < [_pickerTypeData count])
    {
      strType  = [_pickerTypeData objectAtIndex:_nTypeIndex];

    }
//
//    if (strType == NULL || [strType length] < 1)
//    {
//        //选择资金账号类型
//        [self showMessageBox:@"账号类型数据错误，请重新刷新数据!" nType_:TZTBoxTypeNoButton nTag_:0];
//        return;
//    }
//    
    NSMutableDictionary *sendvalue = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [sendvalue setTztValue:strReqno forKey:@"Reqno"];
    
    [sendvalue setTztValue:strAccount forKey:@"account"];
    [sendvalue setTztValue:strPass forKey:@"password"];
    [sendvalue setTztValue:strType forKey:@"accounttype"];
    [sendvalue setTztValue:strYYBCode forKey:@"yybcode"];
//    if (strCommPass)
//        [sendvalue setTztValue:strCommPass forKey:@"ComPassword"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"208" withDictValue:sendvalue];
    
    [sendvalue release];
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pButton = (tztUIButton*)sender;
    if ([pButton.tzttagcode intValue] == 6000)
    {
        [self AddAccount];
    }
    if ([pButton.tzttagcode intValue] == 6001)
    {
                [self AddAccount];
//        [self OnLogin];
//        //登录
 
    }
    if ([pButton.tzttagcode intValue] ==6002) {
        //wry 保存账号信息
        if (self.delegate && [self.delegate respondsToSelector:@selector(OnPopSelf)])
        {
            [self.delegate OnPopSelf];
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
    
    if ([pParse GetErrorNo] < 0)
    {
        NSString* strMsg = [pParse GetErrorMessage];
        [self showMessageBox:strMsg nType_:TZTBoxTypeNoButton nTag_:0];
        return 0;
    }
    if ([pParse IsAction:@"200"])
    {
        [self OnSetPicker:ADDACCOUNT_COM_ZQGS pParse_:pParse];
    }
    else if([pParse IsAction:@"201"])
    {
         [self  dealAccount:pParse];
        
//        //通讯密码
//        NSString* strCommPass = [pParse GetByName:@"ComPassword"];
//        int bNeedComm = [strCommPass intValue];
//        
//        if (bNeedComm != _bNeedComPass)
//        {
//            _bNeedComPass = bNeedComm;
//            if (bNeedComm)
//            {
//                [_tztTableView SetImageHidenFlag:@"TZTTXMM" bShow_:TRUE];
//            }
//            else
//            {
//                [_tztTableView SetImageHidenFlag:@"TZTTXMM" bShow_:FALSE];
//            }
//            [self OnSetPicker:ADDACCOUNT_COM_YYB pParse_:pParse];
//            [self OnSetPicker:ADDACCOUNT_COM_TYPE pParse_:pParse];
//            //重新设置表格显示区域
//            [_tztTableView OnRefreshTableView];
//        }
//        else
//        {
//            [self OnSetPicker:ADDACCOUNT_COM_YYB pParse_:pParse];
//            [self OnSetPicker:ADDACCOUNT_COM_TYPE pParse_:pParse];
//        }
    }
//    else if ([pParse IsAction:@"201"] && _segmentControl.selectedSegmentIndex ==0){
//        [self  dealAccount:pParse];
//    }
    else if([pParse IsAction:@"208"])
    {
        NSString* strMsg = [pParse GetErrorMessage];
        [self showMessageBox:strMsg nType_:TZTBoxTypeNoButton nTag_:0];
        //清空界面数据
        [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:1000];
        [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:1001];
    }
    if ([pParse IsAction:@"207"]) {
        if (_nLoginType == TZTAccountPTType || _nLoginType == TZTAccountRZRQType) {
            [tztJYLoginInfo SetAccountList:pParse];
            if (_pickerData == NULL)
                _pickerData = NewObject(NSMutableArray);
            [_pickerData removeAllObjects];

            BOOL isAccout = NO;
            for (tztZJAccountInfo* account in g_ZJAccountArray) {
                //普通交易登录
                if (_nLoginType ==TZTAccountPTType) {
                    if ([account.nsAccountType rangeOfString:@"RZRQ"].length>0) {
                        isAccout = NO;
                    }else {
                        isAccout = YES;
                    }
                }else{
                    /**
                     *  融券融券登录
                     */
                    if ([account.nsAccountType rangeOfString:@"RZRQ"].length>0) {
                        isAccout = YES;
                    }else {
                        isAccout = NO;
                    }
                }
     
                if (isAccout) {
                    [_pickerData addObject:account.nsAccount];
                }
            }
            if (_pickerData.count<=0) {
            [_tztTableView setComBoxData:nil ayContent_:nil AndIndex_:0 withTag_:1000];
            }else{
            [_tztTableView setComBoxData:_pickerData ayContent_:_pickerData AndIndex_:0 withTag_:1000];
            }
            

            
        }
        
        
    }
#pragma mark 登录处理
    if ([pParse IsAction:@"100"] || [pParse IsAction:@"104"])
    {
        //wry 保存账号信息
        if (self.delegate && [self.delegate respondsToSelector:@selector(OnPopSelf)])
        {
            [self.delegate OnPopSelf];
        }
    }
    return 0;
}

#pragma mark 处理账号管理发送请求
-(void)dealAccount:(tztNewMSParse *)pParse{
    NSString* nsAccountType = [pParse GetByNameUnicode:@"AccountType"];
    if (nsAccountType && nsAccountType.length > 0)
    {
        NSArray* pAyType = [nsAccountType componentsSeparatedByString:@"\r\n"];
        
        if (_pickerTypeData == NULL)
            _pickerTypeData = NewObject(NSMutableArray);
        
        [_pickerTypeData removeAllObjects];
        
        NSMutableArray* pAyName = NewObjectAutoD(NSMutableArray);
        for (int i = 0; i < [pAyType  count]; i++)
        {
            NSString* strData = [pAyType objectAtIndex:i];
            if (strData == NULL || [strData length] < 1)
                continue;
            
            NSArray* pAy = [strData componentsSeparatedByString:@"|"];
            if (pAy == NULL || [pAy count] < 2)
                continue;
            NSString* nsType = [pAy objectAtIndex:0];
            NSString* nsName = [pAy objectAtIndex:1];
            if (nsType == NULL)
                continue;
            nsType = [nsType uppercaseString];
            if (_nLoginType ==TZTAccountPTType) {
                if ([nsType hasPrefix:@"RZRQ"]) {
                    continue;
                }
            }else if (_nLoginType ==TZTAccountRZRQType) {
                if (![nsType hasPrefix:@"RZRQ"]) {
                    continue;
                }
            }
            [_pickerTypeData addObject:nsType];
            [pAyName addObject:nsName];
            
        }
        //设置下拉框的账号选择数据
        [_tztTableView setComBoxData:pAyName ayContent_:pAyName AndIndex_:0 withTag_:999];
 
        if (yyBCode == NULL)
            yyBCode = NewObject(NSMutableArray);
        [yyBCode removeAllObjects];

        if (yybCodeName == NULL) {
            yybCodeName = NewObject(NSMutableArray);
            [yybCodeName removeAllObjects];
        }
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];

        for (int i = 0; i < [ayGrid count]; i++)
        {
            NSArray *pAy = [ayGrid objectAtIndex:i];
            if ([pAy count] < 2)
                continue;
            NSString*yybcode = [pAy objectAtIndex:0];
            [yyBCode addObject:yybcode];

            //公司名称
            NSString* name = [pAy objectAtIndex:1];
            [yybCodeName addObject:name];
            
        }
        if ([yybCodeName count]>0) {
            [_tztTableView setComBoxData:yybCodeName ayContent_:yybCodeName AndIndex_:0 withTag_:5000];
        }
        
        //获取账号信息
//        [self getZHxinxi];
    }

}
#pragma mark 请求账号
-(void)getZHxinxi
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    NSString* mobil = [tztKeyChain load:tztLogMobile];
    if (mobil) {
        [pDict setValue:mobil forKey:@"MobileCode"];
    }
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"207" withDictValue:pDict];
    DelObject(pDict);
}
-(void)SetDefaultData
{
    [self OnDealWithData];
}

-(void)OnDealWithData
{
    NSMutableArray  *ayCom = NewObject(NSMutableArray);
    NSMutableArray  *ayComCode = NewObject(NSMutableArray);
    for (int i = 0; i < [_ayZQGS count]; i++)
    {
        NSMutableDictionary *pDict = [_ayZQGS objectAtIndex:i];
        if (pDict == NULL)
            continue;
        NSString* nsCode = [pDict tztValueForKey:tztCode];
        if (nsCode == NULL || [nsCode length] < 1)
            continue;
        
        NSString* nsName = [pDict tztValueForKey:tztName];
        if (nsName == NULL)
            nsName = @"";
        [ayCom addObject:nsName];
        [ayComCode addObject:nsCode];
    }
    if ([ayCom count] > _nZQGSIndex)
        [_tztTableView setComBoxData:ayCom ayContent_:ayComCode AndIndex_:_nZQGSIndex withTag_:5000];
    DelObject(ayCom);
    DelObject(ayComCode);
    
    NSMutableArray *ayYYB = NewObject(NSMutableArray);
    NSMutableArray *ayYYBCode = NewObject(NSMutableArray);
    for (int i = 0 ; i < [_ayYYB count]; i++)
    {
        NSMutableDictionary *pDict = [_ayYYB objectAtIndex:i];
        if (pDict == NULL)
            continue;
        NSString* nsCode = [pDict tztValueForKey:tztCode];
        if (nsCode == NULL || [nsCode length] < 1)
            continue;
        NSString* nsName = [pDict tztValueForKey:tztName];
        if (nsName == NULL)
            nsName = @"";
        [ayYYB addObject:nsName];
        [ayYYBCode addObject:nsCode];
    }
    if ([ayYYB count] > _nYYBIndex)
        [_tztTableView setComBoxData:ayYYB ayContent_:ayYYBCode AndIndex_:_nYYBIndex withTag_:1000];
    DelObject(ayYYB);
    DelObject(ayYYBCode);
    
    NSMutableArray *ayAccountType = NewObject(NSMutableArray);
    NSMutableArray *ayAccountName = NewObject(NSMutableArray);
    for (int i = 0; i < [_ayType count]; i++)
    {
        NSMutableDictionary *pDict = [_ayType objectAtIndex:i];
        if (pDict == NULL)
            continue;
        
        NSString* nsName = [pDict tztValueForKey:tztName];
        if (nsName == NULL)
            nsName = @"";
        NSString* nsCode = [pDict tztValueForKey:tztCode];
        if (nsCode == NULL)
            nsCode = @"";
        
        [ayAccountType addObject:nsCode];
        [ayAccountName addObject:nsName];
    }
    if ([ayAccountType count] > _nTypeIndex)
        [_tztTableView setComBoxData:ayAccountName ayContent_:ayAccountType AndIndex_:_nTypeIndex withTag_:2000];
    DelObject(ayAccountType);
    DelObject(ayAccountName);
}

- (void)tztDroplistView:(tztUIDroplistView *)view didSelectIndex:(int)index//选中
{
    switch ([view.tzttagcode intValue])
    {
        case 5000://选择券商（区域）
        {
            //清空输入框
            [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:4000];
            [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:3000];
            _nZQGSIndex = index;
            [self OnLoadYYB];
        }
            break;
        case 998://选择普通或者融资融券
        {
            _nLoginType = index;
            [self OnLoadYYB];
        }
            break;
        default:
            break;
    }
}

#pragma mark 用户登录
//用户登录
-(void)OnLogin
{
    //交易类别
    NSString* jyAccountType=nil;
    if (_nLoginType == TZTAccountPTType)
    {
        
        jyAccountType = @"0";
    }
    else if (_nLoginType == TZTAccountRZRQType)
    {
        jyAccountType = @"1";
    }else{
        jyAccountType = @"2";//addAccount
    }
    
    NSString* nsAccountType = nil;//委托类别
    NSInteger accoutInde = [_tztTableView getComBoxSelctedIndex:999];
    nsAccountType =[_pickerTypeData objectAtIndex:accoutInde];
    
    
    
    //账号
    NSString* nsAccount = @"";
    nsAccount = [_tztTableView getComBoxText:1000];
    if (nsAccount.length <= 0)
    {
        tztAfxMessageBoxAnimated(@"输入的账号不能为空!", YES);
        return;
    }
    
    //交易密码
    NSString* nsPass = [_tztTableView GetEidtorText:1001];
    if (nsPass.length < 6)
    {
        [self showMessageBox:@"请输入正确的交易密码!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    //输入通讯密码
    NSInteger txmmIndex = [_tztTableView getComBoxSelctedIndex:1002];
    NSString* nsYZM = @"";
    if (!txmmIndex) {
        nsYZM = [_tztTableView GetEidtorText:2000];
    }
    
    
    if (nsYZM == NULL || [nsYZM length] < 1)
    {
        NSString* errorMessage ;
        if (txmmIndex==0) {
            errorMessage = @"请输入正确的通讯密码！";
        }else{
            errorMessage = @"请输入正确的口令！";
        }
        [self showMessageBox:errorMessage nType_:TZTBoxTypeNoButton nTag_:0];
        
        return;
    }
    //通讯密码Drection 是0 动态口令 是1
    NSString* direction = 0;
    if (txmmIndex ==0 ) {
        direction = @"0";
    }else if (txmmIndex ==1){
        direction = @"1";
    }
    if (![self CheckSysLogin])
        return;
    
    NSString* nsYYB = @"";
    nsYYB = [NSString stringWithFormat:@"%@", g_pSystermConfig.sYYBCode];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [pDict setTztValue:nsAccountType forKey:@"accounttype"];
    
    [pDict setTztValue:nsYYB forKey:@"YybCode"];
    
    [pDict setTztValue:nsAccount forKey:@"account"];
    [pDict setTztValue:nsPass forKey:@"password"];
    [pDict setTztValue:@"10" forKey:@"Maxcount"];
    [pDict setValue:direction forKey:@"direction"];
    [pDict setValue:nsYZM forKey:@"compassword"];
    //增加账号类型获取token
    // [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountPTType] forKey:tztTokenType];
    [pDict setTztObject:jyAccountType forKey:tztTokenType];
    
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
-(BOOL)CheckSysLogin
{
    [tztUserData getShareClass];
    if (g_pSystermConfig && g_pSystermConfig.bNeedRegist)
    {
        g_nsLogMobile = [tztKeyChain load:tztLogMobile];
        if ([g_nsLogMobile length] < 11 || ![TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
        {
            //系统登录
            BOOL bPush = FALSE;
            tztUISysLoginViewController *pVC = (tztUISysLoginViewController *)gettztHaveViewContrller([tztUISysLoginViewController class], tztvckind_Pop,[NSString stringWithFormat:@"%d", MENU_SYS_JYLogin], &bPush,TRUE);
            [pVC retain];
            if (IS_TZTIPAD)
            {
                TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
                CGRect rcFrom = CGRectZero;
                rcFrom.origin = pBottomVC.view.center;
                rcFrom.size = CGSizeMake(500, 500);
                [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
            }
            else if (bPush)
            {

                [pVC SetHidesBottomBarWhenPushed:YES];
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
            return FALSE;
        }
    }
    return TRUE;
}

@end
