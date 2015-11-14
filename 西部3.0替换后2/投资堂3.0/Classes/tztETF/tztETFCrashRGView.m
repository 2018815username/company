/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF 网下现金认购
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztETFCrashRGView.h"



@implementation tztETFCrashRGView
@synthesize ptztCrashTable = _ptztCrashTable;
@synthesize CurStockName = _CurStockName;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;

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
    
    if (_ptztCrashTable == NULL)
    {
        _ptztCrashTable = NewObject(tztUIVCBaseView);
        _ptztCrashTable.tztDelegate = self;
        _ptztCrashTable.tableConfig = @"tztTradeETF_CrashRG";
        _ptztCrashTable.frame = rcFrame;
        [self addSubview:_ptztCrashTable];
        [_ptztCrashTable release];
    }else
        _ptztCrashTable.frame = rcFrame;    
}

-(void)ClearDataWithOutCode
{
    if (_ptztCrashTable == NULL)
        return;
    [_ptztCrashTable setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTagETFGDDm];
    [_ptztCrashTable setLabelText:@"" withTag_:kTagETFName];
    [_ptztCrashTable setLabelText:@"" withTag_:kTagETFKYZJ];
    [_ptztCrashTable setLabelText:@"" withTag_:kTagETFRGSX];
    [_ptztCrashTable setEditorText:@"" nsPlaceholder_:nil withTag_:kTagETFRGFE];
    
    if (_ayType)
        [_ayType removeAllObjects];
    if (_ayAccount)
        [_ayAccount removeAllObjects];
    if (_ayStockNum)
        [_ayStockNum removeAllObjects];
}

-(void)OnClearData
{
    if (_ptztCrashTable == NULL) 
        return;
    
    [_ptztCrashTable setEditorText:@"" nsPlaceholder_:nil withTag_:kTagETFCode];
    [self ClearDataWithOutCode];
    //修改清空 modify by xyt 20131114
    self.CurStockCode = @"";
    self.CurStockName = @"";
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
                [self ClearData];//修改清空 modify by xyt 20131114
			}
            
//			if (inputField.text != NULL)
//			{
//                self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
//			}
            //修改清空 modify by xyt 20131114
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
    if (_ptztCrashTable)
    {
        [_ptztCrashTable setEditorText:nsCode nsPlaceholder_:NULL withTag_:2000];
    }
}

//请求数据
-(void)OnRefresh
{
    if (_ptztCrashTable == NULL) 
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    //[pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX) 
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
    DelObject(pDict);
}


-(BOOL)CheckInput
{
    if (_ptztCrashTable == NULL)
        return FALSE;
    
    NSInteger nIndex = [_ptztCrashTable getComBoxSelctedIndex:kTagETFGDDm];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    
    NSString *nsCode = [_ptztCrashTable GetEidtorText:kTagETFCode];
    if (nsCode == nil || [nsCode length] < 1) 
    {
        [self showMessageBox:@"请输入ETF代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //委托数量
    NSString* nsAmount = [_ptztCrashTable GetEidtorText:kTagETFRGFE];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"认购份额输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString *nsName = [_ptztCrashTable GetLabelText:kTagETFName];
    if (nsName == NULL)
        nsName = @"";
    
    NSString* strInfo = @"";
    NSString *typestr = @"认购";
    //modify by xyt 20131114
    switch (_nMsgType) {
        case MENU_JY_ETFWX_ShenGou://ETF申购
            typestr = @"申购";
            break;
        case MENU_JY_ETFWX_ShuHui://ETF赎回
            typestr = @"赎回";
            break;
        default:
            break;
    }
    strInfo = [NSString stringWithFormat:@"委托账号: %@\r\nETF代码: %@\r\nETF名称: %@\r\n委托数量: %@\r\n\r\n确认%@该证券？", nsAccount, nsCode, nsName, nsAmount, typestr];
    
    
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
            if (_ptztCrashTable)
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

//认购
-(void)OnSendBuySell
{
    if (_ptztCrashTable == nil)
        return;
    
    NSInteger nIndex = [_ptztCrashTable getComBoxSelctedIndex:kTagETFGDDm];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return ;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    
    //ETF代码
    NSString *nsCode = [_ptztCrashTable GetEidtorText:kTagETFCode];
    if (nsCode == NULL || [nsCode length] < 1)
        return;
    
    //委托数量
    NSString* nsAmount = [_ptztCrashTable GetEidtorText:kTagETFRGFE];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"认购份额输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }
    //NSString *nsPrice = [_ptztCrashTable GetLabelText:kTagETFKYZJ];
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
    [pDict setTztValue:nsAmount forKey:@"VOLUME"];
    //[pDict setTztValue:nsPrice forKey:@"PRICE"];
    [pDict setTztValue:@"B" forKey:@"DIRECTION"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"667" withDictValue:pDict];
    
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
    
    if ([pParse IsAction:@"667"] || [pParse IsAction:@"110"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self OnClearData];
        return 0;
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
        
        //股票名称
        NSString* strName = [pParse GetByNameUnicode:@"Title"];
        if (strName && [strName length] > 0)
        {
            self.CurStockName = [NSString stringWithFormat:@"%@",strName];
            if (_ptztCrashTable)
            {
                [_ptztCrashTable setLabelText:strName withTag_:kTagETFName];
                //[_tztTradeView setEditorText:self.CurStockCode nsPlaceholder_:NULL withTag_:2000];
            }
        }
//        else
//        {
//            [self showMessageBox:@"该股票代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
//            return 0;
//        }       
        
//        NSString* strTSInfo = [pParse GetByName:@"BankMoney"];
//        if (strTSInfo)
//        {
//            self.nsTSInfo = [NSString stringWithFormat:@"%@", strTSInfo];
//        }
//        else
//            self.nsTSInfo = @"";
        //
        
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
        
        [_ptztCrashTable setComBoxData:_ayAccount ayContent_:_ayAccount AndIndex_:0 withTag_:kTagETFGDDm];
        
        //可买、可卖显示
        if ([_ayStockNum count] > 0)
        {
            unsigned long dCanCount = (unsigned long)[[_ayStockNum objectAtIndex:0] longLongValue];
            NSString* nsValue = @"";
            if (dCanCount > 100000000) 
                nsValue = [NSString stringWithFormat:@"%.4f亿", (float)(dCanCount/100000000)];
            else
                nsValue = [NSString stringWithFormat:@"%ld", dCanCount];
            
            [_ptztCrashTable setLabelText:nsValue withTag_:kTagETFRGSX];
        }
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
        
        [_ptztCrashTable setLabelText:nsMoney withTag_:kTagETFKYZJ];
    }
    
    return 1;
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case kTagOK:
        {
            //[self OnSendBuySell];
            if (_ptztCrashTable)
            {
                [self CheckInput];
            }
        }
            break;
        case kTagCannel://返回
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
