/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券划转view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztRZRQStockHzView.h"

//登录数据
extern NSMutableArray*  g_ayJYLoginInfo;
extern tztUserData*     g_CurUserData;
extern NSInteger g_ayJYLoginIndex[TZTMaxAccountType];//交易登录账号序号

enum
{
    kTag_ZQDM = 1000,   //证券代码
    kTag_XYZH,          //信用账户
    kTag_PTZH,          //普通账户
    kTag_HZFX,          //划转方向
    kTag_ZQMC,          //证券名称
    kTag_KYYE,          //可用余额
    kTag_GHSL,          //过户数量
    
    kTag_OK = 5000,
    kTag_Clear,
    kTag_Refresh,
};
@implementation tztRZRQStockHzView
@synthesize CurStockCode = _CurStockCode;
@synthesize CurStockName = _CurStockName;
@synthesize pStockHz = _pStockHz;
@synthesize CurAccount = _CurAccount;
@synthesize CurPTAccount = _CurPTAccount;
@synthesize ayData = _ayData;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _pAyPicker = NewObject(NSMutableArray);
        [_pAyPicker addObject:@"普通->信用"];
        [_pAyPicker addObject:@"信用->普通"];
        
        _nSelectPT = -1;
        _nSelectXY = -1;
        _nSelectType = 0;
        
        _bInquireCC = FALSE;
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_pAyPicker);
    DelObject(_ayPTAccount);
    DelObject(_ayXYAccount);
    DelObject(_ayPTStockNum);
    DelObject(_ayXYStockNum);
    DelObject(_ayPTType);
    DelObject(_ayXYType);
    DelObject(_ayData);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)) 
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    
    if (IS_TZTIPAD)
    {
//        rcFrame.size.width = rcFrame.size.width / 5 * 3;
    }
    else
        rcFrame.size.height = rcFrame.size.height;
    
    if (_pStockHz == nil)
    {
        _pStockHz = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _pStockHz.tztDelegate = self;
        [_pStockHz setTableConfig:@"tztRZRQTradeStockHZ"];
        [self addSubview:_pStockHz];
        [_pStockHz release];
    }
    else
    {
        _pStockHz.frame = rcFrame;
    }
    
    [self SetDefaultData];
}

-(void)SetDefaultData
{
    if (_pStockHz == NULL)
        return;
    [_pStockHz setComBoxData:_pAyPicker ayContent_:_pAyPicker AndIndex_:0 withTag_:kTag_HZFX];
}

//清空界面数据
-(void) ClearData
{   
    if (_pStockHz == NULL)
        return;
    [_pStockHz setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTag_ZQDM];
    [_pStockHz setEditorText:@"" nsPlaceholder_:NULL withTag_:kTag_ZQDM];
    [_pStockHz setComBoxText:@"" withTag_:kTag_ZQDM];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
}

-(void)ClearDataWithOutCode
{
    [_pStockHz setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTag_PTZH];
    [_pStockHz setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTag_XYZH];
    [_pStockHz setLabelText:@"" withTag_:kTag_ZQMC];
    [_pStockHz setLabelText:@"" withTag_:kTag_KYYE];
    [_pStockHz setEditorText:@"" nsPlaceholder_:nil withTag_:kTag_GHSL];
}

//选中list
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTag_ZQDM)
    {
        [self onInquireCCData];        
    }
    
    if ([droplistview.tzttagcode intValue] == kTag_HZFX) 
    {
        //选择普通到信用 或 信用到普通
        NSInteger nKind = [_pStockHz getComBoxSelctedIndex:kTag_HZFX];
        //[_pStockHz setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTag_ZQDM];
        [self ClearData];
        if (nKind == 0)
        {
            
        }
        else
        {
            
        }
    }
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    if (nTag == kTag_ZQDM)
    {
        NSString *strCode = inputField.text;
        if (strCode == NULL || strCode.length <= 0)
        {
            [self ClearData];
            return;
        }
        
        if (inputField.text != NULL && inputField.text.length == 6)
        {
            if (self.CurStockCode && [self.CurStockCode caseInsensitiveCompare:inputField.text] != NSOrderedSame)
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
        
        if (strCode && [strCode length] == 6)
        {
            [self OnRefresh];
        }
    }
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTag_ZQDM)
    {
        _nCurrentSel = index;
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            self.CurStockCode = [NSString stringWithFormat:@"%@", strCode];
            [self OnRefresh];
        }
    }
    
    if ([droplistview.tzttagcode intValue] == kTag_HZFX) 
    {
        NSString* nsCode = [_pStockHz GetEidtorText:kTag_ZQDM];
        [self ClearData];
        [_pStockHz setEditorText:nsCode nsPlaceholder_:NULL withTag_:kTag_ZQDM];
        if (nsCode.length == 6)
            [self OnRefresh];
    }
}

//查询持仓
-(void)onInquireCCData
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
    _bInquireCC = TRUE;
    
    //选择普通到信用 或 信用到普通
    NSInteger nKind = [_pStockHz getComBoxSelctedIndex:kTag_HZFX];
    
    if (nKind == 0)
    {
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountPTType] forKey:tztTokenType];
        if (g_CurUserData.nsDBPLoginToken && [g_CurUserData.nsDBPLoginToken length] > 0)
            [pDict setTztValue:g_CurUserData.nsDBPLoginToken forKey:@"Token"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"117" withDictValue:pDict];
    }
    else
    {
        //增加帐号类型获取token
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"403" withDictValue:pDict];
    }
    DelObject(pDict);
}

//请求股票信息   //查询股票信息(信用)
-(void)OnRefresh
{
    if (self.CurStockCode == nil)
        return;
    
    if ([self.CurStockCode length] != 6)
    {
        [self showMessageBox:@"请输入证券代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    
    [pDict setTztValue:@"2" forKey:@"CREDITTYPE"];
    //增加帐号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"429" withDictValue:pDict];
    
    DelObject(pDict);
}

////查询股票信息(信用)
-(void)OnRequestData
{
    if (self.CurStockCode == nil)
        return;
    
    if ([self.CurStockCode length] != 6)
    {
        [self showMessageBox:@"请输入证券代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:@"S" forKey:@"Direction"];
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"2" forKey:@"CREDITTYPE"];
    [pDict setTztValue:@"0" forKey:@"NeedCheck"];
    
    //选择普通到信用 或 信用到普通
    //增加帐号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountPTType] forKey:tztTokenType];
    if (g_CurUserData.nsDBPLoginToken && [g_CurUserData.nsDBPLoginToken length] > 0)
        [pDict setTztValue:g_CurUserData.nsDBPLoginToken forKey:@"Token"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"151" withDictValue:pDict];
    DelObject(pDict);
}

//查询持仓
-(void)OnSendCCQuertStock
{
    if (self.CurStockCode == nil)
        return;
    
    if ([self.CurStockCode length] != 6)
    {
        [self showMessageBox:@"请输入证券代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    [pDict setTztValue:@"100" forKey:@"Volume"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];

    //选择普通到信用 或 信用到普通
    NSInteger nKind = [_pStockHz getComBoxSelctedIndex:kTag_HZFX];
    
    if (nKind == 0)
    {
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountPTType] forKey:tztTokenType];
        if (g_CurUserData.nsDBPLoginToken && [g_CurUserData.nsDBPLoginToken length] > 0)
            [pDict setTztValue:g_CurUserData.nsDBPLoginToken forKey:@"Token"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"117" withDictValue:pDict];
    }
    else
    {
        //增加帐号类型获取token
        [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"403" withDictValue:pDict];
    }
    DelObject(pDict);
}

-(BOOL)CheckInput
{
    if (_pStockHz == NULL)
        return FALSE;
    
    NSInteger nIndex = [_pStockHz getComBoxSelctedIndex:kTag_PTZH];
    
    if (nIndex < 0 || nIndex >= [_ayPTAccount count] || nIndex >= [_ayPTType count])
        return FALSE;
    NSString* nsPTAccount = [_ayPTAccount objectAtIndex:nIndex];
    
    NSInteger nXYIndex = [_pStockHz getComBoxSelctedIndex:kTag_XYZH];
    if (nXYIndex < 0 || nXYIndex >= [_ayXYAccount count] || nXYIndex >= [_ayXYAccount count])
        return FALSE;
    NSString *nsXYAccount = [_ayXYAccount objectAtIndex:nXYIndex];
    
    //股票代码
    NSString* nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    if (self.CurStockCode == NULL || nsCode == NULL || [nsCode length] < 1)
    {
        [self showMessageBox:@"请选择证券代码!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //股票名称
    NSString* nsName = [_pStockHz GetLabelText:kTag_ZQMC];
    if (nsName == NULL)
        nsName = @"";
    
    //过户数量
    NSString* nsAmount = [_pStockHz GetEidtorText:kTag_GHSL];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"过户数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString* strInfo = @"";
    strInfo = [NSString stringWithFormat:@"信用账户: %@\r\n普通账号: %@\r\n证券代码: %@\r\n证券名称: %@\r\n过户数量: %@\r\n\r\n确认%@该证券？", nsXYAccount, nsPTAccount, nsCode, nsName, nsAmount, @"划转"];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:(@"划转")
                   nsOK_:(@"划转")
               nsCancel_:@"取消"];
    return TRUE;
    
}

-(void)getAccountInfo
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
    
    tztJYLoginInfo* pJyLoginInfo = [ayLoginInfo objectAtIndex:nLoginIndex];
    if (pJyLoginInfo == NULL)
        return;
    
//    //融资融券当前资金账号
//    self.CurAccount = pJyLoginInfo.nsFundAccount;
//    
//    
//    pJyLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
//    //融资融券对应的普通账号
//    self.CurPTAccount = pJyLoginInfo.nsFundAccount;
    
    
    //融资融券对应的普通账号
    self.CurPTAccount = pJyLoginInfo.nsUserCode;
    //融资融券当前资金账号
    self.CurAccount = pJyLoginInfo.nsFundAccount;
}

//划转发送
-(void)OnSend
{    
    if (_pStockHz == nil)
        return;
    
    if (_ayXYType == NULL || [_ayXYType count] < 1
		|| _ayXYAccount == NULL || [_ayXYAccount count] < 1
		|| _ayPTAccount == NULL || [_ayPTAccount count] < 1)
	{
        [self showMessageBox:@"帐户信息出错，请重试！" nType_:TZTBoxTypeNoButton nTag_:0];
		return;
	}
 
    //获取当前登录账号信息
    [self getAccountInfo];
    
    //股票代码
    NSString* nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    if (self.CurStockCode == NULL ||nsCode == NULL || [nsCode length] != 6)
        return;
    
    //融资融券对应的普通账号
    NSString* strPTAccount = [NSString stringWithFormat:@"%@",self.CurPTAccount];
    if (self.CurPTAccount == NULL || strPTAccount == NULL || [strPTAccount length] < 1)
    {
        return;
    }
    
    //当前融资融券账号
    NSString *strAccount = [NSString stringWithFormat:@"%@",self.CurAccount];
    if (self.CurAccount == NULL || strAccount == NULL || [strAccount length] < 1)
        return;
    
    //普通账户和类型
    NSInteger nIndex = [_pStockHz getComBoxSelctedIndex:kTag_PTZH];
    if (nIndex < 0 || nIndex >= [_ayPTAccount count] || nIndex >= [_ayPTType count])
        return ;
    NSString* nsPTAccount = [_ayPTAccount objectAtIndex:nIndex];
//    NSString* nsPTType = [_ayPTType objectAtIndex:nIndex];
    
    //信用账户和类型
    NSInteger nXYIndex = [_pStockHz getComBoxSelctedIndex:kTag_XYZH];
    if (nXYIndex < 0 || nXYIndex >= [_ayXYAccount count] || nXYIndex >= [_ayXYAccount count])
        return ;
    NSString *nsXYAccount = [_ayXYAccount objectAtIndex:nXYIndex];
    NSString *nsXYType = [_ayXYType objectAtIndex:nXYIndex];
    
    //过户数量
    NSString* nsAmount = [_pStockHz GetEidtorText:kTag_GHSL];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"过户数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return ;
    }
    //划转方向
    NSInteger nKind = [_pStockHz getComBoxSelctedIndex:kTag_HZFX];
    if (nKind < 0)
        return;
    NSString* nsKind = [NSString stringWithFormat:@"%d",(int)(nKind + 1)];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:strAccount forKey:@"Account"];   //融资融券账号
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [pDict setTztValue:nsAmount forKey:@"Volume"];
    [pDict setTztValue:nsKind forKey:@"Direction"];
    [pDict setTztValue:nsXYType forKey:@"WTACCOUNTTYPE"];    //信用账户类型
    [pDict setTztValue:nsXYAccount forKey:@"WTACCOUNT"];     //信用账户
    
    [pDict setTztValue:strPTAccount forKey:@"PFUNDACCOUNT"];//普通资金账户
    [pDict setTztValue:nsPTAccount forKey:@"PWTACCOUNT"];   //普通账户
    [pDict setTztValue:strPTAccount forKey:@"Lead"];    //普通账号
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    //增加帐号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"430" withDictValue:pDict];
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
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        [self OnNeedLoginOut];
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
    
    if ([pParse IsAction:@"430"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
        return 0;
    }
    
    if (_bInquireCC && [pParse IsAction:@"403"]) 
    {
        _bInquireCC = FALSE;
        
        int nSTOCKCODEINDEX = -1;
        int nSTOCKNAME = -1;
        
        NSString *strIdnex = [pParse GetByName:@"STOCKCODEINDEX"];
        TZTStringToIndex(strIdnex,nSTOCKCODEINDEX);
        
        strIdnex = [pParse GetByName:@"STOCKNAME"];
        TZTStringToIndex(strIdnex,nSTOCKNAME);
        if (nSTOCKNAME<0) { //索引有些是STOCKNAME 有些取的是STOCKNAMEINDEX add by wry 0619
            strIdnex = [pParse GetByName:@"STOCKNAMEINDEX"];
            TZTStringToIndex(strIdnex,nSTOCKNAME);
        }
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSString *nsStockName = @"";
        NSString *nsStockCode = @"";
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 1; i < [ayGrid count]; i++) 
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL || [ayData count] < 3)
                continue;
            
            if (nSTOCKCODEINDEX >= 0 && nSTOCKCODEINDEX < [ayData count])
                nsStockCode = [ayData objectAtIndex:nSTOCKCODEINDEX];
            if (nsStockCode == NULL) 
                nsStockCode = @"";
            
            if (nSTOCKNAME >= 0 && nSTOCKNAME < [ayData count])
                nsStockName = [ayData objectAtIndex:nSTOCKNAME];
            if (nsStockName == NULL)
                nsStockName = @"";
            
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", nsStockCode, nsStockName];
            [pAyTitle addObject:strTitle];
        }
        
        if (_pStockHz && [pAyTitle count] > 0) 
        {
            if (_nCurrentSel < 0 || _nCurrentSel >= [pAyTitle count])
                _nCurrentSel = 0;
            [_pStockHz setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSel withTag_:kTag_ZQDM bDrop_:YES];
            [_pStockHz setComBoxText:@"" withTag_:kTag_ZQDM];
            [_pStockHz setComBoxTextField:kTag_ZQDM];
        }
        if ([pAyTitle count] < 1)
        {
            [self showMessageBox:@"查无相关数据!" nType_:TZTBoxTypeNoButton delegate_:nil];
        }
        DelObject(pAyTitle);        
    }
    else if (_bInquireCC && [pParse IsAction:@"117"]) 
    {
        NSString* strTemp = [pParse GetByName:@"Token"];
        if (strTemp && [strTemp length] > 0)
        {
            g_CurUserData.nsDBPLoginToken = [NSString stringWithFormat:@"%@", strTemp];
        }
        _bInquireCC = FALSE;
        int nStockIndex = -1;
        int nStockName = -1;
        int nKYIndex = -1;
        int nStockNumIndex = -1;
        
        NSString *strIdnex = [pParse GetByName:@"StockIndex"];
        TZTStringToIndex(strIdnex,nStockIndex);
        
        strIdnex = [pParse GetByName:@"STOCKNAME"];
        TZTStringToIndex(strIdnex,nStockName);
        if (nStockName<0) { //索引有些是STOCKNAME 有些取的是STOCKNAMEINDEX add by wry 0618
            strIdnex = [pParse GetByName:@"STOCKNAMEINDEX"];
            TZTStringToIndex(strIdnex,nStockName);
        }
        
        strIdnex = [pParse GetByName:@"KYIndex"];
        TZTStringToIndex(strIdnex,nKYIndex);
                
        strIdnex = [pParse GetByName:@"StockNumIndex"];
        TZTStringToIndex(strIdnex,nStockNumIndex);
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSString *nsStockName = @"";
        NSString *nsStockCode = @"";
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 1; i < [ayGrid count]; i++) 
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL || [ayData count] < 3)
                continue;
            
            if (nStockIndex >= 0 && nStockIndex < [ayData count])
                nsStockCode = [ayData objectAtIndex:nStockIndex];
            if (nsStockCode == NULL) 
                nsStockCode = @"";
            
            if (nStockName >= 0 && nStockName < [ayData count])
                nsStockName = [ayData objectAtIndex:nStockName];
            if (nsStockName == NULL)
                nsStockName = @"";
            
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", nsStockCode, nsStockName];
            [pAyTitle addObject:strTitle];
        }
        
        if (_pStockHz && [pAyTitle count] > 0) 
        {
            if (_nCurrentSel < 0 || _nCurrentSel >= [pAyTitle count])
                _nCurrentSel = 0;
            [_pStockHz setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTag_ZQDM bDrop_:YES];
            //
            [_pStockHz setComBoxText:@"" withTag_:kTag_ZQDM];
            [_pStockHz setComBoxTextField:kTag_ZQDM];
        }
        if ([pAyTitle count] < 1)
        {
            [self showMessageBox:@"查无相关数据!" nType_:TZTBoxTypeNoButton delegate_:nil];
        }
        DelObject(pAyTitle);
    }
    else if ([pParse IsAction:@"429"])//普通账户
    {
        int nKind = 0;
        if ([pParse IsAction:@"429"])
            nKind = 2;
        
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
            if (_pStockHz)
            {
                [_pStockHz setLabelText:strName withTag_:kTag_ZQMC];
                //[_pStockHz setEditorText:strName nsPlaceholder_:nil withTag_:kTag_ZQMC];
            }
        }
        else
        {
            [self showMessageBox:@"该证券代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
        
        if (_ayXYAccount == nil)
            _ayXYAccount = NewObject(NSMutableArray);
        if (_ayXYStockNum == nil) 
            _ayXYStockNum = NewObject(NSMutableArray);
        if (_ayXYType == nil)
            _ayXYType = NewObject(NSMutableArray);
        
        [_ayXYAccount removeAllObjects];
        [_ayXYStockNum removeAllObjects];
        [_ayXYType removeAllObjects];
        
        //股东账号及可卖可买
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                NSString* strAccount = [ayData objectAtIndex:0];
                if (strAccount == NULL || [strAccount length] <= 0)
                    continue;
                
                [_ayXYAccount addObject:strAccount];
                
                NSString* strType = [ayData objectAtIndex:1];
                if (strType == NULL || [strType length] <= 0)
                    strType = @"";
                
                [_ayXYType addObject:strType];
                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayXYStockNum addObject:strNum];
            }
        }
        
        _nSelectXY = 0;
        //设置信用账户
        [_pStockHz setComBoxData:_ayXYAccount ayContent_:_ayXYType AndIndex_:_nSelectXY withTag_:kTag_XYZH];
        
        if (nKind == 2)
        {
            [self OnRequestData];
        }
        
        if (nKind != 2)
        {
            NSString *nsValue = [_ayXYStockNum objectAtIndex:0];
            [_pStockHz setLabelText:nsValue withTag_:kTag_KYYE];
        }
    }
    else if([pParse IsAction:@"151"])//信用账户
    {
        NSString* strTemp = [pParse GetByName:@"Token"];
        if (strTemp && [strTemp length] > 0)
        {
            g_CurUserData.nsDBPLoginToken = [NSString stringWithFormat:@"%@", strTemp];
        }
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
            if (_pStockHz)
            {
                [_pStockHz setLabelText:strName withTag_:kTag_ZQMC];
            }
        }
        else
        {
            [self showMessageBox:@"该证券代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
        
        if (_ayPTAccount == nil)
            _ayPTAccount = NewObject(NSMutableArray);
        if (_ayPTStockNum == nil) 
            _ayPTStockNum = NewObject(NSMutableArray);
        if (_ayPTType == nil)
            _ayPTType = NewObject(NSMutableArray);
        
        [_ayPTAccount removeAllObjects];
        [_ayPTStockNum removeAllObjects];
        [_ayPTType removeAllObjects];
        
        //股东账号及可卖可买
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                NSString* strAccount = [ayData objectAtIndex:0];
                if (strAccount == NULL || [strAccount length] <= 0)
                    continue;
                
                [_ayPTAccount addObject:strAccount];
                
                NSString* strType = [ayData objectAtIndex:1];
                if (strType == NULL || [strType length] <= 0)
                    strType = @"";
                
                [_ayPTType addObject:strType];
                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayPTStockNum addObject:strNum];
            }
        }
        
        _nSelectPT = 0;
        [_pStockHz setComBoxData:_ayPTAccount ayContent_:_ayPTType AndIndex_:_nSelectPT withTag_:kTag_PTZH];
    
        //查询持仓
       [self OnSendCCQuertStock];
    }
    else if([pParse IsAction:@"117"] || [pParse IsAction:@"403"])//资金
    {
        int nStockIndex = -1;
        int nKYIndex = -1;
        int nStockNumIndex = -1;
//        int nNumIndex = -1;
        
        NSString *strIdnex = [pParse GetByName:@"StockIndex"];
        TZTStringToIndex(strIdnex,nStockIndex);
        if (nStockIndex<0) { //索引有些是STOCKNAME 有些取的是STOCKNAMEINDEX add by wry 0619
            strIdnex = [pParse GetByName:@"STOCKCODEINDEX"];
            TZTStringToIndex(strIdnex,nStockIndex);
        }

        
        strIdnex = [pParse GetByName:@"KYIndex"];
        TZTStringToIndex(strIdnex,nKYIndex);
        if (nKYIndex < 0)
        {
            strIdnex = [pParse GetByName:@"StockNumIndex"];
            TZTStringToIndex(strIdnex, nKYIndex);
        }
        
        strIdnex = [pParse GetByName:@"StockNumIndex"];
        TZTStringToIndex(strIdnex,nStockNumIndex);
        
        NSString *nsValue = @"0";
        
         NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        int nMin = MIN(nStockIndex, nKYIndex);
        if (nMin < 0)
            return 0;
        int nMax = MAX(nStockIndex, nKYIndex);
        for (int i = 1; i < [ayGrid count]; i++) 
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL || [ayData count] < nMax)
                continue;
            
            NSString* nsCode = [ayData objectAtIndex:nStockIndex];
            if (nsCode == NULL || [nsCode compare:self.CurStockCode] != NSOrderedSame)
                continue;
            
            if (nKYIndex >= 0 && [ayData count] > nKYIndex) 
            {
                nsValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:nKYIndex]];//  tztdecimalNumberByDividingBy([ayData objectAtIndex:nKYIndex], 2);
                break;
            }
        }
        [_pStockHz setLabelText:nsValue withTag_:kTag_KYYE];
    }
    
    return 1;
}

-(void)inputFieldDidChangeValue:(tztUITextField *)inputField
{
    switch ([inputField.tzttagcode intValue])
	{
		case kTag_ZQDM:
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

//工具栏点击事件
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if (_pStockHz)
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
            [self ClearData];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRefresh];
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
                [self OnSend];
            }
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
                [self OnSend];
                break;
                
            default:
                break;
        }
    }
}
-(void)OnButtonClick:(id)sender
{
    tztUIButton *pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case kTag_OK:
        {
            if (_pStockHz)
            {
                if ([self CheckInput])
                {
                    return;
                }
            }
        }
            break;
        case kTag_Clear:
        {
            [self ClearData];
        }
            break;
        case kTag_Refresh:
        {
            [self OnRefresh];
        }
            break;
        default:
            break;
    }
}

@end
