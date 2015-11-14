/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF股票认购
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztETFStockView.h"

enum
{
    kTagETFCode = 1000,  //ETF代码
    kTagETFGDDm,         //股东代码
    kTagETFName,         //ETF名称
    kTagETFKYZJ,         //可用资金
    kTagCFGPDMDM,        //成份股票代码
    kTagCFG,             //成份股可用
    kTagNum,             //认购数量
    kTagETFOk,           //ETF确定
    kTagETFCannel,       //ETF取消
    kTagETFCFGGD = 2000,//成份股股东
    kTagOK = 2001,
    KTagCannel,         //返回 //add by xyt 20131114
};

@implementation tztETFStockView
@synthesize ptztStockTable = _ptztStockTable;
@synthesize CurStockName = _CurStockName;
@synthesize CurCFStockCode = _CurCFStockCode;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize ayData = _ayData;
@synthesize ayKYData = _ayKYData;
@synthesize ayAccountData = _ayAccountData;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayType);
    DelObject(_ayAccount);
    DelObject(_ayStockNum);
    DelObject(_ayData);
    DelObject(_ayKYData);
    DelObject(_ayAccountData);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)) 
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_ptztStockTable == nil)
    {
        _ptztStockTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _ptztStockTable.tztDelegate = self;
        _ptztStockTable.frame = rcFrame;
        if (_nMsgType == WT_ETF_SS_GFRG || _nMsgType == MENU_JY_ETFKS_SSStockBuy) //深市股份认购
        {
            [_ptztStockTable setTableConfig:@"tztTradeETFSS_StockRG"];
        }
        else
            [_ptztStockTable setTableConfig:@"tztTradeETF_StockRG"];
        [self addSubview:_ptztStockTable];
        [_ptztStockTable release];
    }
    else
    {
        _ptztStockTable.frame = rcFrame;
    }
    
}

//清空界面 //modify by xyt 20131114
-(void)ClearDataWithOutCode
{
    if (_ptztStockTable == NULL)
        return;
    [_ptztStockTable setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTagETFGDDm];
    [_ptztStockTable setLabelText:@"" withTag_:kTagETFName];
    [_ptztStockTable setLabelText:@"" withTag_:kTagETFKYZJ];
    [_ptztStockTable setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTagCFGPDMDM];
    [_ptztStockTable setLabelText:@"" withTag_:kTagCFG];
    [_ptztStockTable setEditorText:@"" nsPlaceholder_:nil withTag_:kTagNum];
    self.CurCFStockCode = @"";
}

-(void)OnClearData
{
    if (_ptztStockTable == NULL)
        return;
    [_ptztStockTable setEditorText:@"" nsPlaceholder_:nil withTag_:kTagETFCode];
   
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
}


- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagETFCode:
		{
			if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
                [self OnClearData];//modify by xyt 20131114
			}
            
//			if (inputField.text != NULL)
//			{
//                self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
//			}
            //modify by xyt 20131114
            if (inputField.text != NULL && inputField.text.length == 6)
			{
                if (self.CurStockCode && [self.CurStockCode compare:inputField.text] != NSOrderedSame)
                {
                    self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                    [self ClearDataWithOutCode];
                }
			}
            else
            {
                self.CurStockCode = @"";
                [self ClearDataWithOutCode];
            }
			
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
			}
		}
			break;
		default:
			break;
    }
}

-(void)inputFieldDidChangeValue:(tztUITextField *)inputField
{
    switch ([inputField.tzttagcode intValue])
	{
		case kTagETFCode:
		{
			if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
			}
            
			if (inputField.text != NULL)
			{
                self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
			}
            
			
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
                //[[NumberKeyboard sharedKeyboard] hide];		
			}
		}
			break;
		default:
			break;
	}
}

-(void)setStockCode:(NSString*)nsCode
{
    if (nsCode == NULL || [nsCode length] < 6)
        return;
    self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
    if (_ptztStockTable)
    {
        [_ptztStockTable setEditorText:nsCode nsPlaceholder_:NULL withTag_:kTagETFCode];
    }
}

//选中list
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagCFGPDMDM)
    {
        NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztObject:strReqno forKey:@"Reqno"];
        [pDict setTztObject:@"0" forKey:@"StartPos"];
        [pDict setTztObject:@"1000" forKey:@"MaxCount"];
        [pDict setTztObject:@"" forKey:@"Stockcode"];
        
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"117" withDictValue:pDict];
        DelObject(pDict);
    }
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTagCFGPDMDM)
    {
        _nCurrentSel = index;
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            self.CurCFStockCode = [NSString stringWithFormat:@"%@", strCode];
                        
            //当前选中的可用
            NSString *strKY =[_ayKYData objectAtIndex:_nCurrentSel];
            if (strKY != NULL)
            {
                [_ptztStockTable setLabelText:strKY withTag_:kTagCFG];
            }
            
            //当前的成分股东代码
            NSString *strAccount = [_ayAccountData objectAtIndex:_nCurrentSel];
            if (strAccount != NULL) 
            {
                [_ptztStockTable setLabelText:strAccount withTag_:kTagETFCFGGD];
            }
            
        }
    }
}

-(void)OnRequestData
{
    
}

//请求股票信息
-(void)OnRefresh
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"3" forKey:@"MobileType"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
    
    DelObject(pDict);
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo]) 
        return 0;
    
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];
    
    if ([tztBaseTradeView IsExitError:nErrNo])
    {
        [self OnNeedLoginOut];
        if (strError)
            tztAfxMessageBox(strError);
        return 0;
    }
    
    if (nErrNo < 0)
    {
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"669"] || [pParse IsAction:@"660"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self OnClearData];
        return 0;
    }
    
    if ([pParse IsAction:@"117"]) 
    {
        int nStockName = -1;
        int nStockCodeIndex = -1;
        int nKYIndex = -1;
        int nAccountIndex = -1;
        
        NSString *strIndex = [pParse GetByName:@"STOCKNAMEINDEX"];
        TZTStringToIndex(strIndex, nStockName);
        
        strIndex = [pParse GetByName:@"StockIndex"];
        TZTStringToIndex(strIndex, nStockCodeIndex);
        
        strIndex = [pParse GetByName:@"KYIndex"];
        TZTStringToIndex(strIndex, nKYIndex);
        
        strIndex = [pParse GetByName:@"AccountIndex"];
        TZTStringToIndex(strIndex, nAccountIndex);
        
        if (nStockName < 0)
            return 0;
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        
        if (_ayData == NULL)
            _ayData = NewObject(NSMutableArray);
        [_ayData removeAllObjects];
        
        if (_ayKYData == NULL) 
            _ayKYData = NewObject(NSMutableArray);
        [_ayKYData removeAllObjects];
        
        if (_ayAccountData == NULL)
            _ayAccountData = NewObject(NSMutableArray);
        [_ayAccountData removeAllObjects];
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSString* strCode = @"";
        NSString* strName = @"";
        NSString* strKY = @"";
        NSString* strAccount = @"";
        for (int i = 1; i < [pGridAy count]; i++)
        {
            NSArray* pAy = [pGridAy objectAtIndex:i];
            
            if(nStockCodeIndex >= 0 && nStockCodeIndex < [pAy count])
                strCode = [pAy objectAtIndex:nStockCodeIndex];
            if (strCode == NULL || [strCode length] <= 0)
                continue;
            
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strCode forKey:@""];
            
            if (nStockName >= 0 && nStockName < [pAy count])
                strName = [pAy objectAtIndex:nStockName];
            if (strName == NULL)
                strName = @"";
            [pDict setTztObject:strName forKey:@""];
            
            [_ayData addObject:pDict];
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
            [pAyTitle addObject:strTitle];
            
            if (nKYIndex >= 0 && nKYIndex < [pAy count]) 
                strKY = [pAy objectAtIndex:nKYIndex];
            if (strKY == NULL)
                strKY = @"";
            [_ayKYData addObject:strKY];
            
            if (nAccountIndex >= 0 && nAccountIndex < [pAy count])
                strAccount = [pAy objectAtIndex:nAccountIndex];
            if (strAccount == NULL)
                strAccount = @"";
            [_ayAccountData addObject:strAccount];
            
            DelObject(pDict);
        }
        
        if (_ptztStockTable && [pAyTitle count] > 0)
        {
            if (_nCurrentSel < 0 || _nCurrentSel >= [pAyTitle count])
                _nCurrentSel = 0;
            //默认不行选中
            [_ptztStockTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTagCFGPDMDM bDrop_:YES];
        }
        
        if ([pAyTitle count] < 1)
        {
            [self showMessageBox:@"查无相关数据!" nType_:TZTBoxTypeNoButton delegate_:nil];
        }
        DelObject(pAyTitle);
    }
    
    if ([pParse IsAction:@"150"])
    {   
        NSString* strCode = [pParse GetByName:@"StockCode"];
        if (strCode == NULL || [strCode length] <= 0)//错误
            return 0;
        //返回的跟当前的代码不一致
        if ([strCode compare:self.CurStockCode] != NSOrderedSame)
        {
            return 0;
        }
        
//        //股票名称
        NSString* strName = [pParse GetByNameUnicode:@"Title"];
        if (strName && [strName length] > 0)
        {
            self.CurStockName = [NSString stringWithFormat:@"%@",strName];
            if (_ptztStockTable)
            {
                [_ptztStockTable setLabelText:strName withTag_:kTagETFName];
            }
        }
//        else
//        {
//            [self showMessageBox:@"该股票代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
//            return 0;
//        }
        
        
        if (_ayAccount == nil)
            _ayAccount = NewObject(NSMutableArray);
        if (_ayType == nil)
            _ayType = NewObject(NSMutableArray);
        if (_ayStockNum == nil)
            _ayStockNum = NewObject(NSMutableArray);
        
        [_ayAccount removeAllObjects];
        [_ayType removeAllObjects];
        [_ayStockNum removeAllObjects];
        
        //股东账号及可卖可买
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                NSString* strAccount = [ayData objectAtIndex:0];
                if (strAccount == NULL || [strAccount length] <= 0)
                    continue;
                
                [_ayAccount addObject:strAccount];
                
                NSString* strType = [ayData objectAtIndex:1];
                if (strType == NULL || [strType length] <= 0)
                    strType = @"";
                
                [_ayType addObject:strType];
                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayStockNum addObject:strNum];
            }
        }
        
        [_ptztStockTable setComBoxData:_ayAccount ayContent_:_ayAccount AndIndex_:0 withTag_:kTagETFGDDm];
        
        //可买、可卖显示
//        if ([_ayStockNum count] > 0)
//        {
//            unsigned long dCanCount = (unsigned long)[[_ayStockNum objectAtIndex:0] longLongValue];
//            NSString* nsValue = @"";
//            if (dCanCount > 100000000) 
//                nsValue = [NSString stringWithFormat:@"%.4f亿", (float)(dCanCount/100000000)];
//            else
//                nsValue = [NSString stringWithFormat:@"%ld", dCanCount];
//            
//            [_ptztStockTable setButtonTitle:nsValue clText_:[UIColor redColor] forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
//        }
        
        //可用资金
        NSString* nsMoney = [pParse GetByName:@"Banklsh"];//bankvolume
        if (nsMoney == NULL || [nsMoney length] < 1)
        {
            nsMoney = [pParse GetByName:@"Usable"];
            if (nsMoney == NULL || [nsMoney length] < 1)
            {
                nsMoney = [pParse GetByName:@"BankVolume"];
                if (nsMoney == NULL || [nsMoney length] < 1)
                    nsMoney = @"";
            }
        }
        
        [_ptztStockTable setLabelText:nsMoney withTag_:kTagETFKYZJ];

    }
    return 1;
}
-(BOOL)CheckInput
{
    if (_ptztStockTable == NULL)
        return FALSE;
    
    NSInteger nIndex = [_ptztStockTable getComBoxSelctedIndex:kTagETFGDDm];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString *nsCode = [_ptztStockTable GetEidtorText:kTagETFCode];
    if (nsCode == nil || [nsCode length] < 1) 
    {
        [self showMessageBox:@"请输入ETF代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //委托数量
    NSString* nsAmount = [_ptztStockTable GetEidtorText:kTagNum];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"认购数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //成份股
    NSString *strCompCode = [NSString stringWithFormat:@"%@",self.CurCFStockCode];
    if (self.CurCFStockCode == NULL || strCompCode == NULL || [strCompCode length] < 1)
    {
        [self showMessageBox:@"请选择成份股代码!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //成份股股东
    NSString *strCFWTAccount = @"";
    if (_nMsgType == WT_ETF_SS_GFRG || _nMsgType == MENU_JY_ETFKS_SSStockBuy) //深市股份认购
    {
        strCFWTAccount = [_ptztStockTable GetLabelText:kTagETFCFGGD];
        if (strCFWTAccount == NULL || [strCFWTAccount length] < 1)
            return FALSE;    
    }
    
    NSString *nsName = @"";
    nsName = [_ptztStockTable GetLabelText:kTagETFName];
    
    NSString* strInfo = @"";
    NSString *typestr = @"股票认购";
    
    switch (_nMsgType) {
        case WT_ETF_SS_GFRG:
        case MENU_JY_ETFKS_SSStockBuy:
            strInfo = [NSString stringWithFormat:@"委托账号: %@\r\nETF代码: %@\r\nETF名称: %@\r\n委托数量: %@\r\n成份股代码: %@\r\n成份股股东: %@\r\n\r\n确认%@该证券？", nsAccount, nsCode, nsName, nsAmount, strCompCode, strCFWTAccount,typestr];
            break;
        default:
            strInfo = [NSString stringWithFormat:@"委托账号: %@\r\nETF代码: %@\r\nETF名称: %@\r\n委托数量: %@\r\n成份股代码: %@\r\n\r\n确认%@该证券？", nsAccount, nsCode, nsName, nsAmount, strCompCode, typestr];
            break;
    }
    
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:typestr
                   nsOK_:typestr
               nsCancel_:@"取消"];
    
    return TRUE;
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRefresh];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_OK:
        {
            if (_ptztStockTable)
            {
                if ([self CheckInput])
                {
                    return TRUE;
                }
            }
        }
            break;
        case TZTToolbar_Fuction_Clear:
        {
            [self OnClearData];
            return TRUE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnSendBuySell];
            }
                break;
                
            default:
                break;
        }
    }
}

//添加ipad确定响应方法 //add by xyt 20131114
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnSendBuySell];
            }
                break;
                
            default:
                break;
        }
    }
}

//买卖确认
-(void)OnSendBuySell
{
    if (_ptztStockTable == nil)
        return;
    
    NSInteger nIndex = [_ptztStockTable getComBoxSelctedIndex:kTagETFGDDm];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return ;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];    
    //ETF代码
    NSString *nsCode = [_ptztStockTable GetEidtorText:kTagETFCode];
    if (nsCode == NULL || [nsCode length] < 1)
        return;
    
    
    //委托数量
    NSString* nsAmount = [_ptztStockTable GetEidtorText:kTagNum];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"认购份额输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }
    
    //成份股
    NSString *strCompCode = [NSString stringWithFormat:@"%@",self.CurCFStockCode];
    if (self.CurCFStockCode == NULL || strCompCode == NULL || [strCompCode length] < 1)
    {
        [self showMessageBox:@"请选择成份股代码!" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }
    
    //成份股股东
    NSString *strCFWTAccount = @"";
    if (_nMsgType == WT_ETF_SS_GFRG || _nMsgType == MENU_JY_ETFKS_SSStockBuy) //深市股份认购
    {
        strCFWTAccount = [_ptztStockTable GetLabelText:kTagETFCFGGD];
        if (strCFWTAccount == NULL || [strCFWTAccount length] < 1)
            return ;
    }

    
    //NSString *nsPrice = [_ptztStockTable GetLabelText:kTagETFKYZJ];
    self.CurStockCode = nsCode;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"WTAccount"];
    [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [pDict setTztValue:nsAmount forKey:@"Volume"];
    //[pDict setTztValue:nsPrice forKey:@"Price"];
    [pDict setTztValue:strCompCode forKey:@"CompCode"];
    [pDict setTztValue:@"B" forKey:@"Direction"];
    
    if (_nMsgType == WT_ETF_SS_GFRG || _nMsgType == MENU_JY_ETFKS_SSStockBuy) //深市股份认购
    {
        [pDict setTztValue:strCFWTAccount forKey:@"JWTACCOUNT"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"660" withDictValue:pDict];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"669" withDictValue:pDict];
    }
    
    DelObject(pDict);
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case kTagOK:
        {
            //[self OnSendBuySell];
            if (_ptztStockTable)
            {
                [self CheckInput];
            }
        }
            break;
        case KTagCannel://返回
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

@end
