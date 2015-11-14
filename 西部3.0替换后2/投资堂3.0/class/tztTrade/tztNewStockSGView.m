/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        新股申购
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztNewStockSGView.h"

@implementation tztNewStockSGView
@synthesize tztTradeView = _tztTradeView;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize ayStockCode = _ayStockCode;
@synthesize ayStockPrice = _ayStockPrice;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        self.CurStockCode = @"";
        _ayAccount = NewObject(NSMutableArray);
        _ayType = NewObject(NSMutableArray);
        _ayStockNum = NewObject(NSMutableArray);
        _ayStockPrice = NewObject(NSMutableArray);
        _nDotValid = 2;
        _fMoveStep = 1.0f / pow(10.0f, _nDotValid);
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    if (_tztTradeView == NULL)
    {
        _tztTradeView = [[tztUIVCBaseView alloc] initWithFrame:self.bounds];
        _tztTradeView.tztDelegate = self;
        //wry type=listEdit
        if (_nMsgType == MENU_JY_RZRQ_NewStockSG)
            [_tztTradeView setTableConfig:@"tztUITradeNewStockSGSetting"];//tztUITradeNewStockRZRQSGSetting
        else
            [_tztTradeView setTableConfig:@"tztUITradeNewStockSGSetting"];
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
    {
        _tztTradeView.frame = self.bounds;
    }
//wry 0610 新股申购 取消用户输入
    UIView* sgsl= [_tztTradeView getCellWithFlag:@"TZTTradeName"];
    sgsl.userInteractionEnabled = NO;

    UIView* TZTCanBuy= [_tztTradeView getCellWithFlag:@"TZTCanBuy"];
    TZTCanBuy.userInteractionEnabled = NO;
    

    UIView* TZTSGED= [_tztTradeView getCellWithFlag:@"TZTSGED"];
    TZTSGED.userInteractionEnabled = NO;

    //申购价格
    UIView* TZTPrice= [_tztTradeView getCellWithFlag:@"TZTPrice"];
    TZTPrice.userInteractionEnabled = YES;

   
    
}
- (void)ClearDataWithCode:(BOOL)withCode
{
    if (withCode)
    {
        self.CurStockCode = @"";
        [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:1000];
        [_tztTradeView setComBoxText:@"" withTag_:1000];
    }
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:1001];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:1002];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2000];
    [_tztTradeView setLabelText:@"" withTag_:2001];

    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2002];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2003];
    [_tztTradeView setLabelText:@"" withTag_:2004];
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:4000];
}
- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case 1000:
        {
            if (text == NULL || text.length <= 0)
            {
                [self ClearDataWithCode:NO];
                return;
            }
            if (text.length < 6)
            {
                [self ClearDataWithCode:NO];
                return;
            }
            if (text != NULL && text.length == 6)
            {
                if (self.CurStockCode && [self.CurStockCode caseInsensitiveCompare:text] != NSOrderedSame)
                {
                    self.CurStockCode = [NSString stringWithFormat:@"%@", text];
                }
            }
            if (text.length == 6)
            {
                if (_nMsgType == MENU_JY_RZRQ_NewStockSG)
                    [self OnRequestDataRZRQ];
                else
                    [self OnRequestDataPT];
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
    if (_tztTradeView )
    {
        if ([_tztTradeView getViewWithTag:1000])
        {
            [_tztTradeView setEditorText:nsCode nsPlaceholder_:NULL withTag_:1000];
            self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
        }
        //        else if ([_tztTradeView getViewWithTag:kTagStockCode])
        //        {
        //            self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
        //            [_tztTradeView setComBoxText:nsCode withTag_:kTagStockCode];
        //            [self OnRefresh];
        //        }
    }
    
}


-(void)OnRequestDataPT
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"3" forKey:@"PriceType"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"UpdateSign"];
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    //wry -- AccountIndex -- 
    [pDict setTztObject:@"1" forKey:@"AccountIndex"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"150" withDictValue:pDict];
    DelObject(pDict);
}

-(void)OnRequestDataRZRQ
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"0" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    [pDict setTztValue:@"3" forKey:@"PriceType"];
    [pDict setTztValue:@"" forKey:@"Price"];
    [pDict setTztValue:@"1" forKey:@"CREDITTYPE"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"UpdateSign"];
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"B" forKey:@"Direction"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"428" withDictValue:pDict];
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
    
    if ([pParse GetErrorNo] < 0)
    {
        NSString* strMsg = [pParse GetErrorMessage];
        
        if (strMsg)
            tztAfxMessageBox(strMsg);
        
        if ([tztBaseTradeView IsExitError:nErrNo]!= 0)
        {
            [self OnNeedLoginOut];
            return 0;
        }
        return 0;
    }
    
    if ([pParse IsAction:@"5014"] || [pParse IsAction:@"7104"]) {
        int nStockCodeIndex = -1;   // 证券代码
        int nStockNameIndex = -1;   // 证券名称
        int nPriceIndex = -1;       //价格索引
        
        NSString* strIndex = [pParse GetByName:@"StockCodeIndex"];
        TZTStringToIndex(strIndex, nStockCodeIndex);
        
        strIndex = [pParse GetByName:@"StockNameIndex"];
        TZTStringToIndex(strIndex, nStockNameIndex);
        
        strIndex = [pParse GetByName:@"PRICEINDEX"];
        TZTStringToIndex(strIndex, nPriceIndex);
        
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if ([ayGrid count] <= 1)
        {
            tztAfxMessageBox(@"查无可申购新股!");
        }
        int nMin = MIN(nStockNameIndex, nStockCodeIndex);
        int nMax = MAX(nStockNameIndex, nStockCodeIndex);
        if (nMin < 0)
            return 0;
        
        if (_ayStockCode == nil)
            _ayStockCode = NewObject(NSMutableArray);
        [_ayStockCode removeAllObjects];
        
        for (int i = 1; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == nil || [ayData count] <= nMax)
                continue;
            
            NSString* nsStockCode = [ayData objectAtIndex:nStockCodeIndex];
            if (nsStockCode == nil)
                nsStockCode = @"";
            
            NSString* nsStockName = [ayData objectAtIndex:nStockNameIndex];
            if (nsStockName == nil)
                nsStockName = @"";
            
            if (ayData.count>nPriceIndex) {
                NSString *nsStockPrice = [ayData objectAtIndex:nPriceIndex];
                [self.ayStockPrice addObject:nsStockPrice];
            }
            NSString *data = [NSString stringWithFormat:@"%@(%@)", nsStockCode, nsStockName];
            
            [_ayStockCode addObject:data];
        }
//        if ([_ayStockCode count] < 1)
//        {
//            tztAfxMessageBox(@"查无可申购新股!");
////            return 1;
//        }
        [_tztTradeView setComBoxData:_ayStockCode ayContent_:_ayStockCode AndIndex_:-1 withTag_:1000 bDrop_:YES];
    }
    
    if ([pParse IsAction:@"110"] || [pParse IsAction:@"400"])
    {
        NSString* strMsg = [pParse GetErrorMessage];
        [self showMessageBox:strMsg nType_:TZTBoxTypeNoButton nTag_:0];
        [self ClearDataWithCode:YES];
        return 1;
    }
    if ([pParse IsAction:@"150"] || [pParse IsAction:@"428"])
    {
        // 增加newshare的判断 是否是新股.如果代码不正常，则没有newshare返回    Tjf
        NSString *strNewShares = [pParse GetByName:@"NewShares"];
        if ([strNewShares isEqualToString:@"0"]) {
            tztAfxMessageBox(@"申购代码无效，请输入正确的新股申购代码！");
        }
        
        NSString* strCode = [pParse GetByName:@"StockCode"];
        if (strCode && [strCode compare:self.CurStockCode] != NSOrderedSame)
        {
            return 0;
        }
        NSString* strName = [pParse GetByNameUnicode:@"Title"];
        if (strName && [strName length] > 0)
        {
            if (_tztTradeView)
            {

                [_tztTradeView setEditorText:strName nsPlaceholder_:@"" withTag_:2000];
            }
        }
        NSString * AvailableAmt = [pParse GetByName:@"AvailableAmt"];
        if (AvailableAmt && [AvailableAmt length] > 0)
        {
            if (_tztTradeView)
            {
                [_tztTradeView setEditorText:AvailableAmt nsPlaceholder_:@"" withTag_:2002];
            }
        }
        else
            [_tztTradeView setEditorText:@"0" nsPlaceholder_:@"" withTag_:2002];
        
        [_ayAccount removeAllObjects];
        [_ayType removeAllObjects];
        [_ayStockNum removeAllObjects];
        
        if (_ayTypeContent == nil)
            _ayTypeContent = NewObject(NSMutableArray);
        [_ayTypeContent removeAllObjects];
        
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
                
                [_ayTypeContent addObject:[self transType2Content:strType]];
                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayStockNum addObject:strNum];
            }
        }
        if (g_pSystermConfig.bTransType2Content)
        {
            [_tztTradeView setComBoxData:_ayTypeContent ayContent_:_ayType AndIndex_:0 withTag_:4000];
        }
        else
        {
            [_tztTradeView setComBoxData:_ayAccount ayContent_:_ayType AndIndex_:0 withTag_:4000];
        }
        
        //可买、可卖显示
        if ([_ayStockNum count] > 0)
        {
            NSString* nsValue = tztdecimalNumberByDividingBy([_ayStockNum objectAtIndex:0], 2);
            [_tztTradeView setEditorText:nsValue nsPlaceholder_:@"" withTag_:2003];
        }
        
        //有效小数位
        NSString *nsDot = [pParse GetByName:@"Volume"];
        if (ISNSStringValid(nsDot))
            _nDotValid = [nsDot intValue];
        [_tztTradeView setEditorDotValue:[nsDot intValue] withTag_:1001];
        _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
        
        //最新价格
        NSString *nsPrcie = [pParse GetByName:@"Price"];
        [_tztTradeView setEditorText:nsPrcie nsPlaceholder_:@"" withTag_:1001];
    
        //wry----
        if (nsPrcie.length<=0) {
            NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
            if (nIndex>=0 && nIndex <self.ayStockPrice.count) {
            [_tztTradeView setEditorText:self.ayStockPrice[nIndex] nsPlaceholder_:@"" withTag_:1001];
            }

        }
        
        if (_nMsgType == MENU_JY_RZRQ_NewStockSG)
            [self onRequestPercent];
    }
    if ([pParse IsAction:@"406"])
    {
        int dbblindex = -1;//负债总金额
        
        NSString *strIndex = [pParse GetByName:@"dbblindex"];
        TZTStringToIndex(strIndex, dbblindex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                if (dbblindex >= 0 && [ayData count] > dbblindex)
                {
                    NSString *str = tztdecimalNumberByDividingBy([ayData objectAtIndex:dbblindex], 2);
                    if (str != NULL && [str length]>0)
                    {
                        [_tztTradeView setLabelText:str withTag_:2004];
                    }
                    else
                    {
                        [_tztTradeView setLabelText:@"0" withTag_:2004];
                    }
                }
            }
        }
    }
    return 1;
}

// 将市场类型转换成中文
- (NSString *)transType2Content:(NSString *)string
{
    if ([string isEqualToString:@"SHACCOUNT"]) {
        return @"上海市场A股";
    }
    else if ([string isEqualToString:@"SZACCOUNT"]) {
        return @"深圳市场A股";
    }
    else if ([string isEqualToString:@"SHBACCOUNT"]) {
        return @"上海市场B股";
    }
    else if ([string isEqualToString:@"SZBACCOUNT"]) {
        return @"深圳市场B股";
    }
    else if ([string isEqualToString:@"SBACCOUNT"]) {
        return @"三板市场";
    }
    else if ([string isEqualToString:@"SBBACCOUNT"]) {
        return @"三板市场B股";
    }
    else
        return string;
}

- (void)onRequestPercent
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"406" withDictValue:pDict];
    DelObject(pDict);
}

//选中list
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == 1000)
    {
        [self onRequestStockData];
    }
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if (_tztTradeView == NULL)
        return;
    //[self ClearDataWithCode:NO];
    
    switch ([droplistview.tzttagcode intValue])
    {
        case 4000:
        {
            if (index < [_ayStockNum count])
            {
                NSString* nsValue = tztdecimalNumberByDividingBy([_ayStockNum objectAtIndex:index], 2);
                [_tztTradeView setEditorText:nsValue nsPlaceholder_:@"" withTag_:2003];
            }
        }
            break;
        case 1000:
        {
            NSString* strTitle = [_ayStockCode objectAtIndex:index];
            
            if (strTitle == nil || [strTitle length] < 1)
                return;
            NSRange rangeLeft = [strTitle rangeOfString:@"("];
            NSRange rangeRight = [strTitle rangeOfString:@")"];
            NSInteger length = rangeRight.location - rangeLeft.location - 1;
            NSRange rangName;
            rangName.location = rangeLeft.location + 1;
            rangName.length = length;
            
            if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
            {
                NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
                NSString *strName = [strTitle substringWithRange:rangName];
                
                //设置股票代码
                [_tztTradeView setComBoxText:strCode withTag_:1000];
                [_tztTradeView setEditorText:strName nsPlaceholder_:@"" withTag_:2000];
                self.CurStockCode = strCode;
                if (_nMsgType == MENU_JY_RZRQ_NewStockSG)
                    [self OnRequestDataRZRQ];
                else
                    [self OnRequestDataPT];
            }
        }
            break;
            
            break;
        default:
            break;
    }
}

-(void)onRequestStockData
{
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
    
    if (_nMsgType == MENU_JY_RZRQ_NewStockSG){
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"7104" withDictValue:pDict];
    }
    else
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5014" withDictValue:pDict];
    DelObject(pDict);
}

//买确认
-(void)OnSendBuySell
{
    if (_tztTradeView == nil)
    {
        return;
    }
    //股东账户
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:4000];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    
    //股票代码
    NSString* nsCode = @"";
    if ([_tztTradeView getViewWithTag:1000])
    {
        nsCode = [_tztTradeView GetEidtorText:1000];
        if (nsCode.length == 0) {
            nsCode = [_tztTradeView getComBoxText:1000];
        }
    }
    else
    {
        nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    }
    if (nsCode == NULL || [nsCode length] < 1)
    {
        return;
    }
    
    //委托加个
    NSString* nsPrice = [_tztTradeView GetEidtorText:1001];
    if (nsPrice == NULL || [nsPrice length] < 1)
    {
        [self showMessageBox:@"委托价格输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* nsAmount = [_tztTradeView GetEidtorText:1002];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] <= 0)
    {
        [self showMessageBox:@"委托数量输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"WTAccount"];
    [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
    [pDict setTztValue:nsPrice forKey:@"Price"];
    [pDict setTztValue:nsAmount forKey:@"Volume"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    
    [pDict setTztValue:nsPrice forKey:@"Price"];
    [pDict setTztValue:@"0" forKey:@"PriceType"];
    [pDict setTztValue:@"B" forKey:@"Direction"];
    
    if (_nMsgType == MENU_JY_RZRQ_NewStockSG)
        [pDict setTztValue:@"1" forKey:@"CREDITTYPE"];
    else
        [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    
    if (_nMsgType == MENU_JY_RZRQ_NewStockSG)
    {
        //增加账号类型获取token
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"400" withDictValue:pDict];
    
    }else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"110" withDictValue:pDict];
    }
    DelObject(pDict);
}
-(void)OnButtonClick:(id)sender
{
    [self OnButton:sender];
}

-(void)OnButton:(id)sender
{
    if (sender == NULL)
        return;
    
	tztUIButton * pButton = (tztUIButton*)sender;
	int nTag = [pButton.tzttagcode intValue];
    switch (nTag)
    {
        case 3000:
        case 3001:
        {
            NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
            //获取当前价格
            NSString* nsPrice = [_tztTradeView GetEidtorText:1001];
            
            float fPrice = [nsPrice floatValue];
            if (nTag == 3001)
                fPrice += _fMoveStep;
            else if(nTag == 3000)
                fPrice -= _fMoveStep;
            if (fPrice < _fMoveStep)
                fPrice = 0.0;
            
            nsPrice = [NSString stringWithFormat:strPriceformat, fPrice];
            [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:1001];
            
//            //获取当前价格
//            NSString* nsPrice = [_tztTradeView GetEidtorText:1001];
//            float fPrice = [nsPrice floatValue];
//            if (nTag == 3001)
//                fPrice += 1.0f/pow(10.0f, 2);
//            else if(nTag == 3000)
//                fPrice -= 1.0f/pow(10.0f, 2);
//            if (fPrice < 1.0f/pow(10.0f, 2))
//                fPrice = 0.0;
//            
//            nsPrice = [NSString stringWithFormat:@"%.2f", fPrice];
//            [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:1001];
        }
            break;
        case 5000:
        {
            [self CheckInput];
        }
            break;
        default:
            break;
    }
}
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

-(BOOL)CheckInput
{
    if (_tztTradeView == NULL || ![_tztTradeView CheckInput])
        return FALSE;
    
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:4000];
    
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    
    //股票代码
    NSString* nsCode = @"";
    if ([_tztTradeView getViewWithTag:1000])
    {
        nsCode = [_tztTradeView GetEidtorText:1000];
        if (nsCode.length == 0) {
            nsCode = [_tztTradeView getComBoxText:1000];
        }
    }
    else
    {
        nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    }
    if (nsCode == NULL || [nsCode length] < 1)
        return FALSE;
    
    //委托价格
    NSString* nsPrice = [_tztTradeView GetEidtorText:1001];
    if (nsPrice == NULL || [nsPrice length] < 1)
    {
        [self showMessageBox:@"委托价格输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //委托数量
    NSString* nsAmount = [_tztTradeView GetEidtorText:1002];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"委托数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    //股票名称
    NSString* nsName = [_tztTradeView GetLabelText:3000];
    if (nsName == NULL)
        nsName = @"";
    
    NSString* strInfo = @"";
    
    strInfo = [NSString stringWithFormat:@"委托账号: %@\r\n证券代码: %@\r\n证券名称: %@\r\n委托价格: %@\r\n委托数量: %@\r\n\r\n确认申购该证券？", nsAccount, nsCode, nsName, nsPrice, nsAmount];

    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"系统提示"
                   nsOK_:@"确定"
               nsCancel_:@"取消"];
    return TRUE;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayType);
    DelObject(_ayAccount);
    DelObject(_ayStockNum);
    [super dealloc];
}


@end
