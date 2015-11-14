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

#import "tztBankDealerView.h"

@interface tztBankDealerView(tztPrivate)
//加载下拉框数据
-(void)LoadListData:(int)nType;
-(NSString*)GetFundAccount:(NSString*)nsSrc;
-(void)ShowOrHiddenPassControl:(BOOL)bDefault;
//更新可用余额显示
-(void)updateAvailableVolume;
-(void)Check;
@end

extern tztCardBankTransform *g_pBDTranseInfo;

#define BankList_Flag   0
#define MoneyType_Flag  1
#define InAccount_Flag  5
#define OutAccount_Flag  6

#define ZhuanZhuangPwd_Tag 0x01;
#define ZiJinPwd_Tag 0x02;
#define BankPwd_Tag 0x03;
#define ZiJInAccount_Tag 0x04;

@implementation tztBankDealerView
@synthesize tztTableView = _tztTableView;
@synthesize ayBank = _ayBank;
@synthesize ayMoney = _ayMoney;
@synthesize ayAccount = _ayAccount;
@synthesize nsKYMoney = _nsKYMoney;

-(id)init
{
    if (self = [super init])
    {
        //默认银行转证券
        _nMsgType = WT_BANKTODEALER;
        _bNeedBankPW = -1;
        _bNeedFundPW = -1;
        _nMoneyTypeIndex = -1;
        _nBankTypeIndex = -1;
        
        _ayBank = NewObject(NSMutableArray);
        _ayMoney = NewObject(NSMutableArray);
        _ayAccount = NewObject(NSMutableArray);
        self.nsKYMoney = @"";
        
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayMoney);
    DelObject(_ayBank);
    DelObject(_ayAccount);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    
    if(_pTradeToolBar && !_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_nMsgType == WT_QUERYBALANCE
        || _nMsgType == MENU_JY_PT_BankYue
        || _nMsgType == WT_BANKTODEALER
        || _nMsgType == MENU_JY_PT_Bank2Card
        || _nMsgType == WT_DEALERTOBANK
        || _nMsgType == MENU_JY_PT_Card2Bank)
    {
        g_pBDTranseInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].pBDTranseInfo;
    }
    if(_nMsgType == WT_RZRQQUERYBALANCE
            || _nMsgType == MENU_JY_RZRQ_BankYue
            || _nMsgType == WT_RZRQBANKTODEALER
            || _nMsgType == MENU_JY_RZRQ_Bank2Card
            || _nMsgType == WT_RZRQDEALERTOBANK
            || _nMsgType == MENU_JY_RZRQ_Card2Bank)
    {
        g_pBDTranseInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountRZRQType].pBDTranseInfo;
    }
    if (_nMsgType == WT_DFQUERYBALANCE
        || _nMsgType == WT_DFBANKTODEALER
        || _nMsgType == WT_DFDEALERTOBANK
        || _nMsgType == WT_NeiZhuan
        || _nMsgType == MENU_JY_DFBANK_Card2Bank
        || _nMsgType == MENU_JY_DFBANK_Bank2Card
        || _nMsgType == MENU_JY_DFBANK_BankYue
        || _nMsgType == MENU_JY_DFBANK_Transit)
    {
        g_pBDTranseInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].pMoreAccountTranseInfo;
        if (g_pBDTranseInfo == NULL || ![g_pBDTranseInfo HaveBankInfo])//多存管为空，取但银行
        {
            g_pBDTranseInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].pBDTranseInfo;
        }
    }
    if (_tztTableView == NULL)
    {
        _tztTableView = NewObject(tztUIVCBaseView);
        _tztTableView.tztDelegate = self;
        if (_nMsgType == WT_QUERYBALANCE || _nMsgType == MENU_JY_PT_BankYue || _nMsgType == WT_RZRQQUERYBALANCE || _nMsgType == MENU_JY_RZRQ_BankYue || _nMsgType == WT_DFQUERYBALANCE || _nMsgType == MENU_JY_DFBANK_BankYue)  //查询余额
        {
#ifdef tzt_NewVersion // 新版配置 by20130718
            _tztTableView.tableConfig = @"tztUITradeBankMoney_NewVersion";
#else
            _tztTableView.tableConfig = @"tztUITradeBankMoney";
#endif
        }
        else if(_nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Transit)//资金内转
        {
#ifdef tzt_NewVersion
            _tztTableView.tableConfig = @"tztUITradeBankNeiZhuan_NewVersion";
#else
            _tztTableView.tableConfig = @"tztUITradeBankNeiZhuan";
#endif
        }
        else if(_nMsgType == WT_BANKTODEALER || _nMsgType == MENU_JY_PT_Bank2Card || _nMsgType == WT_DFBANKTODEALER || _nMsgType == WT_RZRQBANKTODEALER || _nMsgType == MENU_JY_RZRQ_Bank2Card || _nMsgType == MENU_JY_DFBANK_Bank2Card)
        {
#ifdef tzt_NewVersion // 新版配置 by20130718
            _tztTableView.tableConfig = @"tztUITradeBankDealer_NewVersion";
#else
            _tztTableView.tableConfig = @"tztUITradeBankDealer";
#endif
        }
        else if(_nMsgType == WT_DEALERTOBANK || _nMsgType == MENU_JY_PT_Card2Bank || _nMsgType == WT_DFDEALERTOBANK || _nMsgType == WT_RZRQDEALERTOBANK || _nMsgType == MENU_JY_RZRQ_Card2Bank || _nMsgType == MENU_JY_DFBANK_Card2Bank)
        {
#ifdef tzt_NewVersion // 新版配置 by20130718
            _tztTableView.tableConfig = @"tztUITradeDealerBank_NewVersion";
#else
            _tztTableView.tableConfig = @"tztUITradeDealerBank";
#endif
        }
        _tztTableView.frame = rcFrame;
        [self addSubview:_tztTableView];
        [_tztTableView release];
        //设置数据
        [self SetDefaultData];
        //查余额
        if (_nMsgType == WT_DFDEALERTOBANK
            || _nMsgType == WT_DFBANKTODEALER
            || _nMsgType == WT_NeiZhuan
            || _nMsgType == WT_RZRQDEALERTOBANK
            || _nMsgType == MENU_JY_RZRQ_Card2Bank
            || _nMsgType == MENU_JY_DFBANK_Bank2Card
            || _nMsgType == MENU_JY_DFBANK_Card2Bank
            || _nMsgType == MENU_JY_DFBANK_Transit)
        {
            [self doQueryBalance];
        }
        //首次根据设置的银行调整界面
        NSString* strBank = [g_pBDTranseInfo GetBankName];
        BOOL bChange = [g_pBDTranseInfo IsShowBankPW:strBank nType_:_nMsgType];
        BOOL bChangeFund = [g_pBDTranseInfo IsShowFundPW:strBank nType_:_nMsgType];
        if (_bNeedBankPW != bChange || _bNeedFundPW != bChangeFund)
        {
            _bNeedBankPW = bChange;
            _bNeedFundPW = bChangeFund;
            [self ShowOrHiddenPassControl:TRUE];
        }
    }else
        _tztTableView.frame = rcFrame;
}

//清空页面数据
-(void)ClearData
{
    if (_tztTableView)
    {
        [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:2000];
        [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
        [_tztTableView setEditorText:@"" nsPlaceholder_:NULL withTag_:2002];
    }
}

//表格加载完毕后回调
-(void)SetDefaultData
{
    //币种
    [self LoadListData:MoneyType_Flag];
    NSString *nsMoney = [_tztTableView getComBoxText:1000];
    if (nsMoney && [nsMoney length] > 0)
    {
        [g_pBDTranseInfo SetMoneyType:nsMoney];
    }
    
    //银行
    [self LoadListData:BankList_Flag];
    NSString *nsBank = [_tztTableView getComBoxText:1001];
    
    
    if (nsBank && [nsBank length] > 0)
    {
        [g_pBDTranseInfo SetBank:nsBank];
        
        _bNeedBankPW = [g_pBDTranseInfo IsShowBankPW:nsBank nType_:_nMsgType];
        _bNeedFundPW = [g_pBDTranseInfo IsShowFundPW:nsBank nType_:_nMsgType];
        [self ShowOrHiddenPassControl:FALSE];
    }
    
    if (_nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Transit)
    {
        [self LoadListData:InAccount_Flag];
        [self LoadListData:OutAccount_Flag];
    }
    
    NSString* strAccount = [g_pBDTranseInfo getAccountByBank:nsBank strMoney_:nsMoney];
    if (strAccount && [strAccount length] > 0)
    {
        //选择的资金账号赋值
        g_pBDTranseInfo.sFundAccount = [NSString stringWithFormat:@"%@",strAccount];
        [_tztTableView setLabelText:strAccount withTag_:3001];
    }
    else
    {
        [_tztTableView setLabelText:@"" withTag_:3001];
    }
}

-(NSString*)GetFundAccount:(NSString*)nsSrc
{
	if (nsSrc == nil || [nsSrc length] < 1)
		return nil;
	
	NSString* nsDst = nsSrc;
	NSRange rangeLeft = [nsSrc rangeOfString:@"("];
	NSRange rangeRight = [nsSrc rangeOfString:@")"];
	
	NSInteger nLength = rangeRight.location - rangeLeft.location;
	rangeLeft.length = nLength-1;
	rangeLeft.location += 1;
	
	if (rangeLeft.location > 0 && rangeLeft.location < [nsSrc length] && rangeLeft.length > 0 && rangeLeft.length < [nsSrc length])
	{
		nsDst = [nsSrc substringWithRange:rangeLeft];
	}
	
	return nsDst;
}

//加载下拉框数据
-(void)LoadListData:(int)nType
{
    if (g_pBDTranseInfo == NULL || ![g_pBDTranseInfo HaveBankInfo])
        return;
    NSMutableArray  *aySrc = NULL;
    NSMutableArray  *ayDst = NULL;
    
    int nSliderTag = 0;
    NSInteger nSelect = 0;
    //获取币种列表
    if(nType == MoneyType_Flag)
    {
        aySrc = g_pBDTranseInfo.saMoneyType;
        ayDst = _ayMoney;
        nSelect = _nMoneyTypeIndex;
        nSliderTag = 1000;
    }
    //获取银行列表
    else if (nType == BankList_Flag)
    {
        NSString* strMoney = [g_pBDTranseInfo GetMoneyTypeName];
        NSMutableArray  *ayTemp = [g_pBDTranseInfo GetBankListByMoney:strMoney];;
        if (ayTemp)
            aySrc = ayTemp;
        else
            aySrc = g_pBDTranseInfo.saBankList;
        
        ayDst = _ayBank;
        nSelect = _nBankTypeIndex;
        nSliderTag = 1001;
    }
    //获取转入账户列表
    else if(nType == InAccount_Flag)
    {
        //得到币种
        NSString* strMoney = [g_pBDTranseInfo GetMoneyTypeName];
        //根据币种获取银行
        NSMutableArray  *ayTemp = nil;
        ayTemp = [g_pBDTranseInfo GetBankListByMoney:strMoney];
        aySrc = NewObjectAutoD(NSMutableArray);
        if (ayTemp)
        {
            for (int i = 0; i < [ayTemp count]; i++)
            {
                NSString* strBank = [ayTemp objectAtIndex:i];
                NSString* strAccount = [g_pBDTranseInfo getAccountByBank:strBank strMoney_:strMoney];
                if (strAccount)
                    [aySrc addObject:strAccount];
            }
            ayDst = _ayAccount;
        }
        else
        {
            aySrc = g_pBDTranseInfo.saAccountList;
            ayDst = _ayAccount;
        }
        nSliderTag = 1002;
        
    }
    //获取转出账户列表
    else if(nType == OutAccount_Flag)
    {
        //获取币种
        NSString* strMoney = [g_pBDTranseInfo GetMoneyTypeName];
        //根据币种获取银行
        NSMutableArray *ayTemp = nil;
        ayTemp = [g_pBDTranseInfo GetBankListByMoney:strMoney];
        aySrc = NewObjectAutoD(NSMutableArray);
        if (ayTemp)
        {
            for (int i = 0; i < [ayTemp count]; i++)
            {
                NSString* strBank = [ayTemp objectAtIndex:i];
                NSString* strAccount = [g_pBDTranseInfo getAccountByBank:strBank strMoney_:strMoney];
                if (strAccount)
                    [aySrc addObject:strAccount];
            }
            ayDst = _ayAccount;
        }
        else
        {
            aySrc = g_pBDTranseInfo.saAccountList;
            ayDst = _ayAccount;
        }
        nSliderTag = 1003;
    }
    
    
    if (aySrc == NULL || ayDst == NULL)
        return;
    
    //先清空
    [ayDst removeAllObjects];
    //取第一个有效数据作为默认显示
    BOOL bFirst = TRUE;
    //总数
    NSInteger nCount = [aySrc count];
    
    //获取当前银行名字
    NSString* strBank = [g_pBDTranseInfo GetBankName];
    for (NSInteger i = 0; i < nCount; i++)
    {
        NSString* strData = [aySrc objectAtIndex:i];
        if (strData == NULL || [strData length] < 1)
            continue;
        if (nType == OutAccount_Flag || nType == InAccount_Flag)
        {
            NSString* strMoney = [g_pBDTranseInfo GetMoneyTypeName];
            NSMutableArray *ayTemp = [g_pBDTranseInfo GetBankListByMoney:strMoney];
            if (ayTemp)
            {
                for (int i = 0; i < [ayTemp count]; i++)
                {
                    NSString* strTemp = [ayTemp objectAtIndex:i];
                    NSString* strAccount = [g_pBDTranseInfo getAccountByBank:strTemp strMoney_:strMoney];
                    if ([strData compare:strAccount] == NSOrderedSame)
                    {
                        strData = [NSString stringWithFormat:@"(%@)%@",strAccount,strTemp];
                    }
                }
            }
        }
        
        [ayDst addObject:strData];
        
        if (strBank && [strBank length] > 0)
        {
            bFirst = FALSE;
            if ([strBank compare:strData] == NSOrderedSame && nSliderTag == 1001)
            {
                [_tztTableView setComBoxText:strData withTag_:(int)nSliderTag];
                //根据银行币种，得到资金账号
                NSString* strAccount = [g_pBDTranseInfo getAccountByBank:strBank strMoney_:[g_pBDTranseInfo GetMoneyTypeName]];
                [g_pBDTranseInfo SetBank:strData];
                //显示银行可用余额
                NSString* strMoney = @"";
                if (strAccount)
                {
                    g_pBDTranseInfo.sFundAccount = [NSString stringWithFormat:@"%@",strAccount];
                    [_tztTableView setLabelText:strAccount withTag_:3001];
                    strMoney = [g_pBDTranseInfo getAvailableVolumeByAccount:strAccount strMoney_:[g_pBDTranseInfo GetMoneyTypeName]];
                }
                if (strMoney == nil || [strMoney length] <= 0)
                    strMoney = @"0";
                
                if (_nMsgType == WT_RZRQDEALERTOBANK || _nMsgType == MENU_JY_RZRQ_Card2Bank)
                {
                    [_tztTableView setLabelText:self.nsKYMoney withTag_:3000];
                }
                else
                    [_tztTableView setLabelText:strMoney withTag_:3000];
            }
        }else
        {
            if (_nBankTypeIndex >= 0 && _nBankTypeIndex == i && nSliderTag == 1001)
            {
                bFirst = FALSE;
                [_tztTableView setComBoxText:strData withTag_:(int)nSliderTag];
                [g_pBDTranseInfo SetBank:strData];
               
                strBank = strData;
            }
        }
        
        //选中的币种
        if (_nMoneyTypeIndex >= 0 && _nMoneyTypeIndex == i && nSliderTag == 1000 && bFirst)
        {
            bFirst = FALSE;
            [_tztTableView setComBoxText:strData withTag_:nSliderTag];
        }
        
        if (bFirst && nType == OutAccount_Flag)
        {
             bFirst = FALSE;
            [_tztTableView setComBoxText:strData withTag_:nSliderTag];
            [g_pBDTranseInfo SetOutFundAccount:[self GetFundAccount:strData]];
        }
        //界面默认显示
        if (bFirst)
        {
            _nBankTypeIndex = 0;
            _nMoneyTypeIndex = 0;
            nSelect = 0;
            [_tztTableView setComBoxText:strData withTag_:nSliderTag];
            bFirst = FALSE;
        }
    }
    if (nSelect< 0)
        nSelect = 0;
    [_tztTableView setComBoxData:ayDst ayContent_:ayDst AndIndex_:nSelect withTag_:nSliderTag];
    if (ayDst.count <= 0)
    {
        [_tztTableView setComBoxText:@"" withTag_:nSliderTag];
    }
}

-(void)ShowOrHiddenPassControl:(BOOL)bDefault
{
    if (_nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Transit)
        return;
    
    if (_nMsgType == WT_QUERYBALANCE || _nMsgType == MENU_JY_PT_BankYue || _nMsgType == WT_RZRQQUERYBALANCE || _nMsgType == MENU_JY_RZRQ_BankYue || _nMsgType == WT_DFQUERYBALANCE || _nMsgType == MENU_JY_DFBANK_BankYue) //查询余额
    {
        /*
         //配置文件排序
         转账币种、转账银行、资金账号、银行密码、资金密码
         */
        
        if (_nMsgType == WT_QUERYBALANCE || _nMsgType == MENU_JY_PT_BankYue || _nMsgType == WT_RZRQQUERYBALANCE || _nMsgType == MENU_JY_RZRQ_BankYue)
        {
            [_tztTableView SetImageHidenFlag:@"TZTZJZH" bShow_:NO];
        }
    }
    else if(_nMsgType == WT_BANKTODEALER || _nMsgType == MENU_JY_PT_Bank2Card || _nMsgType == WT_DFBANKTODEALER || _nMsgType == WT_RZRQBANKTODEALER || _nMsgType == MENU_JY_RZRQ_Bank2Card || _nMsgType == MENU_JY_DFBANK_Bank2Card)
    {   /*
         //配置文件排序
         转账币种、转账银行、资金账号、可取金额、转账金额、银行密码、资金密码
         */
        if (_nMsgType == WT_BANKTODEALER || _nMsgType == MENU_JY_PT_Bank2Card || _nMsgType == WT_RZRQBANKTODEALER || _nMsgType == MENU_JY_RZRQ_Bank2Card)
        {
            [_tztTableView SetImageHidenFlag:@"TZTZJZH" bShow_:NO];
            [_tztTableView SetImageHidenFlag:@"TZTKYJE" bShow_:NO];
        }
    }
    else if(_nMsgType == WT_DEALERTOBANK || _nMsgType == MENU_JY_PT_Card2Bank || _nMsgType == WT_DFDEALERTOBANK || _nMsgType == WT_RZRQDEALERTOBANK || _nMsgType == MENU_JY_RZRQ_Card2Bank || _nMsgType == MENU_JY_DFBANK_Card2Bank)
    {  /*
        //配置文件排序
        转账币种、转账银行、资金账号、可取金额、转账金额、银行密码、资金密码
        */
        if (_nMsgType == WT_DEALERTOBANK || _nMsgType == MENU_JY_PT_Card2Bank || _nMsgType == WT_RZRQDEALERTOBANK || _nMsgType == MENU_JY_RZRQ_Card2Bank)
        {
            [_tztTableView SetImageHidenFlag:@"TZTZJZH" bShow_:NO];
            if (_nMsgType != WT_DEALERTOBANK && _nMsgType != MENU_JY_PT_Card2Bank)
            {
                [_tztTableView SetImageHidenFlag:@"TZTKYJE" bShow_:NO];
            }
        }
    }
    
    if (_bNeedBankPW)
        [_tztTableView SetImageHidenFlag:@"TZTYHMM" bShow_:YES];
    else
        [_tztTableView SetImageHidenFlag:@"TZTYHMM" bShow_:NO];
    
    if (_bNeedFundPW)
        [_tztTableView SetImageHidenFlag:@"TZTZJMM" bShow_:YES];
    else
        [_tztTableView SetImageHidenFlag:@"TZTZJMM" bShow_:NO];
	//重新设置表格显示区域
	[_tztTableView OnRefreshTableView];
    if (bDefault)
        [self SetDefaultData];
}

- (void)tztDroplistView:(tztUIDroplistView *)view didSelectIndex:(int)index//选中
{
    switch ([view.tzttagcode intValue])
    {
        case 1000://币种
        {
            _nMoneyTypeIndex = index;
            [g_pBDTranseInfo SetMoneyType:view.text];
            
            [self SetDefaultData];
#pragma  mark 刷新数据 wry
            [self updateAvailableVolume];
            return;
            //重新设置表格显示区域
            [self ShowOrHiddenPassControl:TRUE];
        }
            break;
        case 1001://选择银行
        {
            _nBankTypeIndex = index;
            [g_pBDTranseInfo SetBank:view.text];
            _bNeedBankPW = [g_pBDTranseInfo IsShowBankPW:view.text nType_:_nMsgType];
            _bNeedFundPW = [g_pBDTranseInfo IsShowFundPW:view.text nType_:_nMsgType];
            [self ShowOrHiddenPassControl:TRUE];
#pragma  mark 刷新数据 wry
            [self updateAvailableVolume];
        }
            break;
        case 1002:
        {
            NSString* nsTemp = [self GetFundAccount:view.text];
            [g_pBDTranseInfo SetInFundAccount:nsTemp];
        }
            break;
        case 1003:
        {
            NSString* nsTemp = [self GetFundAccount:view.text];
            [g_pBDTranseInfo SetOutFundAccount:nsTemp];
            [self updateAvailableVolume];
        }
            break;
        default:
            break;
    }
}


//更新可用余额显示
-(void) updateAvailableVolume
{
    NSString* account = [g_pBDTranseInfo GetFundAccount];
	NSString* strMoney = [g_pBDTranseInfo GetMoneyTypeName];
    if (_nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Transit)
	{
		account = [g_pBDTranseInfo GetOutFundAccount];
        if (account == NULL || [account length] <= 0)
        {
            [g_pBDTranseInfo SetOutFundAccount:[g_pBDTranseInfo GetFundAccount]];
        }
        account = [g_pBDTranseInfo GetOutFundAccount];
        
        NSString* strBank = [g_pBDTranseInfo GetBankNameByAccount:account];
        NSString* strData = [NSString stringWithFormat:@"(%@)%@",account,strBank];
        
        [_tztTableView setComBoxText:strData withTag_:1003];
	}
	NSString* availableVolume = [g_pBDTranseInfo getAvailableVolumeByAccount:account strMoney_:strMoney];
	if (availableVolume == NULL || [availableVolume length] < 1)
		return;
	[_tztTableView setLabelText:availableVolume withTag_:3000];
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case 6801:
        case 4000:
        {
            [self Check];
        }
            break;
        case 6802:
        {
            [g_navigationController popViewControllerAnimated:UseAnimated];
            //返回，取消风火轮显示
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIViewController* pTop = g_navigationController.topViewController;
            if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
            {
                g_navigationController.navigationBar.hidden = NO;
                [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

-(void)Check
{
    if (!g_pBDTranseInfo || _tztTableView == NULL)
        return;
    
    
    NSString* nsString = @"";
    NSString* nsBank = @"";
    NSString* nsMoney = @"";
    NSString* nsAmount = @"";
    NSString* nsOutAccount = @"";
    NSString* nsInAccount = @"";
    
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (strTitle.length < 1)
    {
        switch (_nMsgType)
        {
            case WT_NeiZhuan:
            {
                strTitle = @"资金内转";
            }
                break;
            case WT_TRANSHISTORY:
            case MENU_JY_PT_QueryBankHis:
            {
                strTitle = @"转账流水";
            }
                break;
            case WT_BANKTODEALER:
            case MENU_JY_PT_Bank2Card:
            case WT_DFBANKTODEALER:
            case MENU_JY_DFBANK_Bank2Card:
            case WT_RZRQBANKTODEALER:
            case MENU_JY_RZRQ_Bank2Card:
            {
                strTitle = @"银行转证券";
            }
                break;
            case WT_DEALERTOBANK:
            case MENU_JY_PT_Card2Bank:
            case WT_DFDEALERTOBANK:
            case MENU_JY_DFBANK_Card2Bank:
            case WT_RZRQDEALERTOBANK:
            case MENU_JY_RZRQ_Card2Bank:
            {
                strTitle = @"证券转银行";
            }
                break;
                
            default:
                break;
        }
    }
    
    if (_nMsgType != WT_NeiZhuan && _nMsgType != MENU_JY_DFBANK_Transit)
    {
        nsBank = [_tztTableView getComBoxText:1001];
    }
    if ((_nMsgType != WT_TRANSHISTORY && _nMsgType !=MENU_JY_PT_QueryBankHis) && (_nMsgType != WT_DFTRANSHISTORY))
    {
        nsMoney = [_tztTableView getComBoxText:1000];
    }
    
    //转账金额
    nsAmount = [_tztTableView GetEidtorText:2000];
    if (_nMsgType == WT_BANKTODEALER || _nMsgType == MENU_JY_PT_Bank2Card || _nMsgType == WT_DFBANKTODEALER || _nMsgType == WT_RZRQBANKTODEALER  || _nMsgType == MENU_JY_RZRQ_Bank2Card
        || _nMsgType == WT_DEALERTOBANK || _nMsgType == MENU_JY_PT_Card2Bank || _nMsgType == WT_DFDEALERTOBANK || _nMsgType == WT_RZRQDEALERTOBANK || _nMsgType == MENU_JY_RZRQ_Card2Bank
        || _nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Card2Bank || _nMsgType == MENU_JY_DFBANK_Bank2Card || _nMsgType == MENU_JY_DFBANK_Transit)
    {
        if (nsAmount == NULL || [nsAmount floatValue] <= 0.001f)
        {
            [self showMessageBox:@"输入金额无效，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
            return;
        }
    }
    
    if (_nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Transit)
    {
        nsOutAccount = [_tztTableView getComBoxText:1003];
        nsInAccount = [_tztTableView getComBoxText:1002];
    }
    
    if (_nMsgType != WT_NeiZhuan && _nMsgType != MENU_JY_DFBANK_Transit)
    {
        if (_nMsgType == WT_QUERYBALANCE || _nMsgType == MENU_JY_PT_BankYue || _nMsgType == WT_DFQUERYBALANCE || _nMsgType == WT_RZRQQUERYBALANCE || _nMsgType == MENU_JY_RZRQ_BankYue || _nMsgType == MENU_JY_DFBANK_BankYue)
        {
            nsString = [NSString stringWithFormat:@"查询币种: %@\r\n查询银行: %@\r\n\r\n确认操作？",nsMoney,nsBank];
        }
        else
        {
            if(nsAmount == nil || [nsAmount length] <= 0 || ([nsAmount floatValue] <= 0.000001f))
            {
                
                [self showMessageBox:@"输入金额不正确，请重新输入" nType_:0 nTag_:0];
                return;
            }
            nsString = [NSString stringWithFormat:@"转账币种: %@\r\n转账银行: %@\r\n转账金额: %@\r\n\r\n确认操作？", nsMoney, nsBank, nsAmount];
        }
    }
    else
    {
        nsString = [NSString stringWithFormat:@"转账币种: %@\r\n转出账号: %@\r\n转入账号: %@\r\n转账金额: %@\r\n\r\n确认操作？",nsMoney,nsOutAccount, nsInAccount, nsAmount];
    }
    
    [self showMessageBox:nsString nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self withTitle_:strTitle];
}

-(void)doOK
{
    if (!g_pBDTranseInfo)
        return;
    
    NSString* strBank = @"";
    if (_nMsgType != WT_NeiZhuan && _nMsgType != MENU_JY_DFBANK_Transit)
    {
        strBank = [_tztTableView getComBoxText:1001];
        if (strBank == NULL || [strBank length] < 1)
            return;
        [g_pBDTranseInfo SetBank:strBank];
    }
    
    if ((_nMsgType != WT_TRANSHISTORY && _nMsgType !=MENU_JY_PT_QueryBankHis) && (_nMsgType != WT_DFTRANSHISTORY))
    {
        NSString* strMoney = [_tztTableView  getComBoxText:1000];
        if (strMoney == NULL | [strMoney length] < 1)
            return;
        [g_pBDTranseInfo SetMoneyType:strMoney];
    }
    else
        [g_pBDTranseInfo SetMoneyType:@""];
    
    [g_pBDTranseInfo SetTransferType:_nMsgType];
    
    NSString* nsMoney = [_tztTableView GetEidtorText:2000];
    NSString* nsBankPW = [_tztTableView GetEidtorText:2001];
    NSString* nsFundPW = [_tztTableView GetEidtorText:2002];
    if (_nMsgType == WT_BANKTODEALER || _nMsgType == MENU_JY_PT_Bank2Card || _nMsgType == WT_DFBANKTODEALER || _nMsgType == WT_RZRQBANKTODEALER || _nMsgType == MENU_JY_RZRQ_Bank2Card
        || _nMsgType == WT_DEALERTOBANK || _nMsgType == MENU_JY_PT_Card2Bank || _nMsgType == WT_DFDEALERTOBANK || _nMsgType == WT_RZRQDEALERTOBANK || _nMsgType == MENU_JY_RZRQ_Card2Bank
        || _nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Card2Bank || _nMsgType == MENU_JY_DFBANK_Bank2Card || _nMsgType == MENU_JY_DFBANK_Transit)
    {
        if (nsMoney == NULL || [nsMoney floatValue] <= 0.001f)
        {
            [self showMessageBox:@"输入金额无效，请重新输入!" nType_:TZTBoxTypeNoButton nTag_:0];
            return;
        }
    }
    [g_pBDTranseInfo SetTransferVolume:[nsMoney floatValue]];
    if (nsBankPW == NULL)
        nsBankPW = @"";
    [g_pBDTranseInfo SetBankPassword:nsBankPW];
    
    if (nsFundPW == NULL)
        nsFundPW = @"";
    [g_pBDTranseInfo SetDealerPassword:nsFundPW];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    NSString *strAction = @"";
    if (_nMsgType == WT_BANKTODEALER || _nMsgType == MENU_JY_PT_Bank2Card || _nMsgType == WT_DFBANKTODEALER || _nMsgType == WT_RZRQBANKTODEALER || _nMsgType == MENU_JY_RZRQ_Bank2Card || _nMsgType == MENU_JY_DFBANK_Bank2Card)
    {
        if (![g_pBDTranseInfo IsShowBankPW:strBank])
        {
            nsBankPW = @"";
            [g_pBDTranseInfo SetBankPassword:nsBankPW];
        }
        strAction = [g_pBDTranseInfo MakeStrBankToDealer:pDict];
    }
    else if(_nMsgType == WT_DEALERTOBANK || _nMsgType == MENU_JY_PT_Card2Bank || _nMsgType == WT_DFDEALERTOBANK || _nMsgType == WT_RZRQDEALERTOBANK || _nMsgType == MENU_JY_RZRQ_Card2Bank || _nMsgType == MENU_JY_DFBANK_Card2Bank)
    {
        strAction = [g_pBDTranseInfo MakeStrDealerToBank:pDict];
    }
    else if(_nMsgType == WT_QUERYBALANCE || _nMsgType == MENU_JY_PT_BankYue || _nMsgType == WT_DFQUERYBALANCE || _nMsgType == WT_RZRQQUERYBALANCE || _nMsgType == MENU_JY_RZRQ_BankYue || _nMsgType == MENU_JY_DFBANK_BankYue)
    {
        strAction = [g_pBDTranseInfo MakeStrQueryBalance:pDict];
    }
    else if(_nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Transit)
    {
        NSString* nsOutAccount = [_tztTableView getComBoxText:1003];
        if (nsOutAccount == NULL || [nsOutAccount length] < 1)
        {
            [self showMessageBox:@"转出账号不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
            DelObject(pDict);
			return;
        }
        //保存资金转出账号
		NSString* nsTemp = [self GetFundAccount:nsOutAccount];
		if (nsTemp && [nsTemp length] > 0)
		{
			[g_pBDTranseInfo SetOutFundAccount:nsTemp];
		}
		
		NSString *nsInAccount = [_tztTableView getComBoxText:1002];//m_textInAccount.text;
		if (nsInAccount == nil || nsInAccount.length < 1)
		{
            [self showMessageBox:@"转入账号不能为空！" nType_:TZTBoxTypeNoButton nTag_:0];
            DelObject(pDict);
			return;
		}
		//保存资金转入账号
		nsTemp = [self GetFundAccount:nsInAccount];
        if (nsTemp && [nsTemp length] > 0)
		{
			[g_pBDTranseInfo SetInFundAccount:nsTemp];
		}
		strAction = [g_pBDTranseInfo MakeStrZiJinNeiZhuan:pDict];
    }
    else if(_nMsgType == WT_TRANSHISTORY || _nMsgType ==MENU_JY_PT_QueryBankHis || _nMsgType == WT_DFTRANSHISTORY || _nMsgType == WT_RZRQTRANSHISTORY || _nMsgType == MENU_JY_RZRQ_QueryBankHis)
    {
        
    }
    else
    {
        DelObject(pDict);
        return;
    }
    if (_nMsgType == WT_RZRQDEALERTOBANK || _nMsgType == MENU_JY_RZRQ_Card2Bank || _nMsgType == WT_RZRQBANKTODEALER || _nMsgType == MENU_JY_RZRQ_Bank2Card || _nMsgType == WT_RZRQQUERYBALANCE || _nMsgType == MENU_JY_RZRQ_BankYue)
    {
        //增加账号类型获取token
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    }
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
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
    
    BOOL isForce = YES;
    //
    if ([pParse IsAction:@"406"])
    {
        NSString *strIndex = [pParse GetByName:@"ZJKYINDEX"];
        int nIndex = -1;
        TZTStringToIndex(strIndex, nIndex);
        if (nIndex < 0 )
        {
            [_tztTableView setLabelText:@"0.0" withTag_:3000];
            return 0;
        }
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] <= nIndex)
                    continue;
                
                NSString* str = [ayData objectAtIndex:nIndex];
                self.nsKYMoney = [NSString stringWithFormat:@"%@", str];
                [_tztTableView setLabelText:str withTag_:3000];
            }
        }
    }
    //查询可用余额
    if ([pParse IsAction:@"194"])
    {
        [g_pBDTranseInfo ClearAvailableVolumeData];
        NSMutableArray *pAy = nil;
        int availableVolumeIndex = -1;
        int accountIndex = -1;
        int CurrencyIndex = -1;
        
        NSString* strTemp;
        if (_nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Transit)
        {
            strTemp = [pParse GetByName:@"USABLEINDEX"];
//            strTemp = [pParse GetByName:@"AVAILABLEINDEX"];
        }
        else
        {
            strTemp = [pParse GetByName:@"AVAILABLEINDEX"];
            if (!ISNSStringValid(strTemp))
            {
                strTemp = [pParse GetByName:@"USABLEINDEX"];
            }
        }
        TZTStringToIndex(strTemp, availableVolumeIndex);
        
        strTemp = [pParse GetByName:@"FUNDACCOUNTINDEX"];
        TZTStringToIndex(strTemp, accountIndex);
        
        strTemp = [pParse GetByName:@"CURRENCYINDEX"];
        TZTStringToIndex(strTemp, CurrencyIndex);
        
        if (accountIndex < 0 || availableVolumeIndex < 0 || CurrencyIndex <0)
            return 0;
        
        NSArray *pGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 1; i < [pGrid count]; i++)
        {
            pAy = [pGrid objectAtIndex:i];
            if (pAy == NULL || [pAy count] <= accountIndex || [pAy count] <= availableVolumeIndex || [pAy count] <= CurrencyIndex
                || accountIndex < 0 || availableVolumeIndex < 0 || CurrencyIndex < 0)
            {
                continue;
            }
            
            NSString* account = [pAy objectAtIndex:accountIndex];
            NSString* availableVolume = [pAy objectAtIndex:availableVolumeIndex];
            NSString* strMoney = [pAy objectAtIndex:CurrencyIndex];
            
            if (account == NULL || availableVolume == NULL || strMoney == NULL)
                continue;
            [g_pBDTranseInfo AddAvailableVolume:account strMoney_:strMoney sAvailableValume_:availableVolume];
        }
        isForce = NO;
        [self updateAvailableVolume];
    }
    if (![pParse IsAction:@"194"])
    {
        TZTLogInfo(@"=======----- %d", [pParse GetAction]);
        if (strErrMsg)
        {
            TZTLogInfo(@"%@", strErrMsg);
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        }
        [self ClearData];
    }
    if (isForce && (_nMsgType == WT_DFDEALERTOBANK || _nMsgType == WT_DFBANKTODEALER || _nMsgType == WT_NeiZhuan || _nMsgType == MENU_JY_DFBANK_Card2Bank || _nMsgType == MENU_JY_DFBANK_Bank2Card || _nMsgType == MENU_JY_DFBANK_Transit))
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1
										 target:self
								       selector:@selector(doQueryBalance)
								       userInfo:nil
									    repeats:NO];
    }
    return 1;
}

//查询银行余额
-(void) doQueryBalance
{
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"10" forKey:@"MaxCount"];
    [pDict setTztValue:@"10" forKey:@"Volume"];
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    if (_nMsgType == WT_RZRQDEALERTOBANK || _nMsgType == MENU_JY_RZRQ_Card2Bank)
    {
        //增加账号类型获取token
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"406" withDictValue:pDict];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"194" withDictValue:pDict];
    }
    [pDict release];
	return;
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
                [self doOK];
                break;
                
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
                [self doOK];
                break;
                
            default:
                break;
        }
    }
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            [self Check];
            return TRUE;
        }
            break;
            
        default:
            break;
    }
    return FALSE;
}

@end
