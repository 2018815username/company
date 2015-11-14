/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		TZTCardBankTransform.m
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:	2.0
 * 作    者:	yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTCardBankTransform.h"

#define _delMapPtrObj(pMap) { if (pMap) { [pMap removeAllObjects]; [pMap release]; pMap = NULL; } }

tztCardBankTransform* g_pBDTranseInfo = NULL; //银证转账、多方存管信息

@implementation tztCardBankTransform
@synthesize saBankList = _saBankList;
@synthesize saMoneyType = _saMoneyType;
@synthesize saAccountList = _saAccountList;

//交易账号
@synthesize sAccount = _sAccount;
//交易密码
@synthesize sAccountPW = _sAccountPW;
//选择的资金账号
@synthesize sFundAccount = _sFundAccount;
//银行密码
@synthesize sBankPW = _sBankPW;
//资金密码
@synthesize sDealerPW = _sDealerPW;
//银行名称
@synthesize sBankName = _sBankName;
//银行编码
@synthesize sBankNo = _sBankNo;

//新增 银行密码标识，0标识不需要密码，1标识需要密码
@synthesize strBankPWFlag = _strBankPWFlag;
//币种名称
@synthesize sMoneyTypeName = _sMoneyTypeName;
//币种编码
@synthesize sMoneyTypeNo = _sMoneyTypeNo;
//Token
@synthesize sToken = _sToken;
//开始日期
@synthesize sStartDate = _sStartDate;
//结束日期
@synthesize sEndDate = _sEndDate;
//资金转入账号
@synthesize sInFundAccount = _sInFundAccount;
//资金转出账号
@synthesize sOutFundAccount = _sOutFundAccount;

-(id) init
{
    self = [super init];
    if (self != nil)
    {
        [self CardBankTransform_];
    }
    return self;
}

-(void) dealloc
{
    [self CardBankTransform__];
    [super dealloc];
}

-(void) CardBankTransform_
{
	_bGetBankInfoSuc = FALSE;
    //银行列表
    _saBankList = NewObject(NSMutableArray);
    //银行名称转代码
    _mapBankNameToNo = NewObject(NSMutableDictionary);
    //银行名称转密码标志
    _mapBankNameToPWFlag = NewObject(NSMutableDictionary);
	//银行转币种
	_mapBankToMoney = NewObject(NSMutableDictionary);
	//资金账号列表
	_saAccountList = NewObject(NSMutableArray);
	// 资金账号对应银行
	_mapAccountToBank = NewObject(NSMutableDictionary);
	// 资金账号对应可取金额
    _mapAccountToAvailableVolume = NewObject(NSMutableDictionary);
	// 资金账号对应可用金额
    _mapAccountToUseVolume = NewObject(NSMutableDictionary);
	// 资金账号对应币种
    _mapAccountToMoney = NewObject(NSMutableDictionary);
    //币种名称
    _saMoneyType = NewObject(NSMutableArray);
    //币种名称转代码
    _mapMoneyTypeToNo = NewObject(NSMutableDictionary);
	// 币种转银行
    _mapMoneyToBank = NewObject(NSMutableDictionary);
	//交易账号
	_sAccount = @"";
	//交易密码
    _sAccountPW = @"";
	//选择的资金账号
	_sFundAccount = @"";
	//银行密码
    _sBankPW = @"";
	//资金密码
    _sDealerPW = @"";
    //转账金额
    _fTranseVolume = 0.0f;
    //银行名称
    _sBankName = @"";
	//银行编码
    _sBankNo = @"";
    
    //新增 银行密码标识，0标识不需要密码，1标识需要密码
    _strBankPWFlag = @"";
    //币种名称
    _sMoneyTypeName = @"";
	//币种编码
    _sMoneyTypeNo = @"";
    //Token
    _sToken = @"";
    //开始日期
    _sStartDate = @"";
	//结束日期
	_sEndDate = @"";
	//资金转入账号
	_sInFundAccount = @"";
    //资金转出账号
	_sOutFundAccount = @"";
	//Key
    _nKey = 0;
	//功能号
	_nQuestType=0;
}

-(void) CardBankTransform__
{
	[self RemoveAllInfo];
	_bGetBankInfoSuc = FALSE;
	//银行列表
    //    _delArrayObj(_saBankList);
    DelObject(_saBankList);
    //银行名称转代码
    _delMapPtrObj(_mapBankNameToNo);
    //银行名称转密码标志
	_delMapPtrObj(_mapBankNameToPWFlag);
	//银行转币种
	_delMapPtrObj(_mapBankToMoney);
	//资金账号列表
    //	_delArrayObj(m_saAccountList);
    DelObject(_saAccountList);
	// 资金账号对应银行
	_delMapPtrObj(_mapAccountToBank);
	// 资金账号对应可取金额
	_delMapPtrObj(_mapAccountToAvailableVolume);
	// 资金账号对应可用金额
	_delMapPtrObj(_mapAccountToUseVolume);
	// 资金账号对应币种
	_delMapPtrObj(_mapAccountToMoney);
    //币种名称
    //	_delArrayObj(m_saMoneyType);
    DelObject(_saMoneyType);
    //币种名称转代码
	_delMapPtrObj(_mapMoneyTypeToNo);
	// 币种转银行
	_delMapPtrObj(_mapMoneyToBank);
    
	//Key
    _nKey = 0;
	_nQuestType=0;
}

-(void) RemoveAllInfo
{
    //银行列表
    [_saBankList removeAllObjects];
    //银行名称转代码
    [_mapBankNameToNo removeAllObjects];
    
    //银行名称转密码标志
    [_mapBankNameToPWFlag removeAllObjects];
    
    _bGetBankInfoSuc = FALSE;
    
    //币种名称
    [_saMoneyType removeAllObjects];
    
    //币种名称转代码
    [_mapMoneyTypeToNo removeAllObjects];
	
	//资金账号列表
    [_saAccountList removeAllObjects];
    
    _sAccount = @"";
    _sAccountPW = @"";
    _sFundAccount = @"";
    _sBankPW = @"";
    _sDealerPW = @"";
    _fTranseVolume = 0.0f;
    _sBankName = @"";
    _sBankNo = @"";
    //新增 银行密码标识，0标识不需要密码，1标识需要密码
    _strBankPWFlag = @"";
    _sMoneyTypeName = @"";
    _sMoneyTypeNo = @"";
    _sInFundAccount = @"";
    _sOutFundAccount = @"";
    _sToken = @"";
    _sStartDate = @"";
    _sEndDate = @"";
    [_mapBankToMoney removeAllObjects];
    [_mapMoneyToBank removeAllObjects];
    [_mapAccountToBank removeAllObjects];
    [_mapAccountToUseVolume removeAllObjects];
    [_mapAccountToAvailableVolume removeAllObjects];
    [_mapAccountToMoney removeAllObjects];
}

//加入银行信息以及币种信息
-(BOOL) AddBank:(NSString*)sBankName sBankNo_:(NSString*)sBankNo
{
    return [self AddBank:sBankName sBankNo_:sBankNo BankPW_:nil];
}

//加入银行信息以及币种信息
-(BOOL) AddBank:(NSString*)sBankName sBankNo_:(NSString*)sBankNo BankPW_:(NSString*)strBankPWFlag
{
    if (sBankName == NULL || [sBankName length] <= 0)
        return FALSE;
    
	NSString* strFindKey = [sBankName uppercaseString];
    
	NSString* strTemp = [_mapBankNameToNo objectForKey:strFindKey];
    //已经存在不再添加
    if (strTemp && [strTemp length] > 0)
    {
        return TRUE;
    }
    
    //加入
    [_saBankList addObject:sBankName];
    [_mapBankNameToNo setObject:sBankNo forKey:strFindKey];
	
	if(strBankPWFlag && [strBankPWFlag length] > 0)
	{
        [_mapBankNameToPWFlag setObject:strBankPWFlag forKey:strFindKey];
	}
    return TRUE;
}
//币种类别
-(BOOL) AddMoneyType:(NSString*)sMoneyType sMoneyNo_:(NSString*)sMoneyNo
{
    if (sMoneyType == NULL || [sMoneyType length] <= 0)
        return FALSE;
    
	NSString* strFindKey = [sMoneyType uppercaseString];
    
	NSString* strTemp = [_mapMoneyTypeToNo objectForKey:strFindKey];
    //已经存在不再添加
    if (strTemp && [strTemp length] > 0)
    {
        return TRUE;
    }
    
    //加入
    [_saMoneyType addObject:sMoneyType];
    [_mapMoneyTypeToNo setObject:sMoneyNo forKey:strFindKey];
	return TRUE;
}
//加入资金账号信息及银行信息，币种信息
-(BOOL) AddAccount:(NSString*)sAccount sBankName_:(NSString*)sBankName sMoneyName_:(NSString*)sMoneyName
{
	if (sAccount == NULL || [sAccount length] <= 0 || sBankName == NULL || [sBankName length] <= 0 || sMoneyName == NULL || [sMoneyName length] <= 0)
        return FALSE;
    
	NSString* strFindKey = [sAccount uppercaseString];
	NSString* strTemp = [_mapAccountToBank objectForKey:strFindKey];
    //已经存在不再添加
    if (strTemp && [strTemp length] > 0)
    {
        return TRUE;
    }
	
	//加入
    [_saAccountList addObject:sAccount];
    [_mapAccountToBank setObject:sBankName forKey:strFindKey];
    [_mapAccountToMoney setObject:sMoneyName forKey:strFindKey];
	return TRUE;
}
//加入资金账号可用金额信息
-(BOOL) AddUseVolume:(NSString*)sAccount strMoney_:(NSString*)strMoney  sUseValume_:(NSString*)sUseValume;
{
	if (sAccount == NULL || [sAccount length] <= 0 || sUseValume == NULL || [sUseValume length] <= 0)
        return FALSE;
	
	NSString* strKey = sAccount;
	if (strKey == NULL)
		return FALSE;
	
	if (strMoney && [strMoney length] > 0)
    {
		strKey = [NSString stringWithFormat:@"%@|%@",sAccount,strMoney];
	}
	
	NSString* strFindKey = [strKey uppercaseString];
	NSString* strTemp = [_mapAccountToUseVolume objectForKey:strFindKey];
    //已经存在不再添加
    if (strTemp && [strTemp length] > 0)
    {
        return TRUE;
    }
	
	//加入
    [_mapAccountToUseVolume setObject:sUseValume forKey:strFindKey];
	return TRUE;
}
//加入资金账号可取金额信息
-(BOOL) AddAvailableVolume:(NSString*)sAccount strMoney_:(NSString*)strMoney  sAvailableValume_:(NSString*)sAvailableValume
{
	if (sAccount == NULL || [sAccount length] <= 0 || sAvailableValume == NULL || [sAvailableValume length] <= 0)
        return FALSE;
	NSString* strKey = sAccount;
	if (strKey == NULL)
		return FALSE;
	
	if (strMoney && [strMoney length] > 0) {
		strKey = [NSString stringWithFormat:@"%@|%@",sAccount, strMoney];
	}
	
	//NSString* strFindKey = [strKey uppercaseString];
    
	NSString* strTemp = [_mapAccountToAvailableVolume objectForKey:strKey];
    //已经存在不再添加
    if (strTemp && [strTemp length] > 0)
    {
        return TRUE;
    }
    [_mapAccountToAvailableVolume setObject:sAvailableValume forKey:strKey];
	return TRUE;
}
//银行－币种对应关系
-(void) AddBankToMoney:(NSString*)strBank strMoney_:(NSString*)strMoney
{
    if (strBank == NULL || [strBank length] <= 0 ||
        strMoney == NULL || [strMoney length] <= 0)
        return;
    
	NSString* strFindKey = [strBank uppercaseString];
    
    NSMutableArray *payMoney = NewObject(NSMutableArray);
	if([_mapBankToMoney objectForKey:strFindKey] != NULL)
		[payMoney setArray:[_mapBankToMoney objectForKey:strFindKey]];
	
    [payMoney addObject:strMoney];
    [_mapBankToMoney setObject:payMoney forKey:strFindKey];
	[payMoney release];
    return;
}
//币种-银行对应关系
-(void) AddMoneyToBank:(NSString*)strMoney strBank_:(NSString*)strBank
{
    if (strBank == NULL || [strBank length] <= 0 ||
        strMoney == NULL || [strMoney length] <= 0)
        return;
    
	NSString* strFindKey = [strMoney uppercaseString];
    
	NSMutableArray *payMoney = NewObject(NSMutableArray);
	if([_mapMoneyToBank objectForKey:strFindKey] != NULL)
		[payMoney setArray:[_mapMoneyToBank objectForKey:strFindKey]];
    
    [payMoney addObject:strBank];
    [_mapMoneyToBank setObject:payMoney forKey:strFindKey];
    [payMoney release];
    return;
}
//三方存管银行数
-(NSInteger) GetBankCount
{
    return [_saBankList count];
}
//币种数
-(NSInteger) GetMoneyTypeCount
{
    return [_saMoneyType count];
}
//账号数
-(NSInteger) GetAccountCount
{
	return [_saAccountList count];
}
//获取指定下标的银行名称和币种名称
-(NSString*) GetBankName:(int)nIdx
{
	if ( nIdx < 0 || nIdx >= [_saBankList count] )
	{
		return NULL;
	}
	return [_saBankList objectAtIndex:nIdx];
}

-(NSString*) GetMoneyType
{
	return self.sMoneyTypeNo;
}

-(NSString*) GetMoneyType:(int)nIdx
{
	if ( nIdx < 0 || nIdx >= [_saMoneyType count] )
	{
		return NULL;
	}
	return [_saMoneyType objectAtIndex:nIdx];
}
//获取制定下标的资金账号
- (NSString*) GetAccount:(int)nIdx
{
	if ( nIdx < 0 || nIdx >= [_saAccountList count] )
	{
		return NULL;
	}
	return [_saAccountList objectAtIndex:nIdx];
}

-(NSString*) GetBankNameByAccount:(NSString*)strAccount
{
    if (strAccount == NULL || [strAccount length] <= 0)
        return NULL;
    if (_mapAccountToBank == NULL)
        return NULL;
    
    return [_mapAccountToBank objectForKey:strAccount];
}

-(NSString*) getAccountByBank:(NSString*)strBank strMoney_:(NSString*)strMoney
{
	if (strBank == NULL || [strBank length] <= 0 || strMoney == NULL || [strMoney length] <= 0)
        return NULL;
	for (NSString* accountData in _saAccountList)
	{
		if(accountData == NULL || [accountData length] <= 0)
			continue;
		NSString* bank = [_mapAccountToBank objectForKey:accountData];
		NSString* moneyType = [_mapAccountToMoney objectForKey:accountData];
		if(bank == NULL || [bank length] <= 0 || moneyType == NULL || [moneyType length] <= 0)
			continue;
        strBank = [strBank uppercaseString];
        strMoney = [strMoney uppercaseString];
        if ([strBank compare:bank] == NSOrderedSame && [strMoney compare:moneyType] == NSOrderedSame)
        {
            return accountData;
        }
	}
	return NULL;
}

//根据资金账号获取可用资金
-(NSString*) getUseVolumeByAccount:(NSString*)sAccount strMoney_:(NSString*)strMoney
{
	if (sAccount == NULL || [sAccount length] <= 0)
        return NULL;
	
	NSString* strKey = sAccount;
	if (strKey == NULL)
		return FALSE;
	
	if (strMoney && [strMoney length] > 0)
    {
		strKey = [NSString stringWithFormat:@"%@|%@", sAccount, strMoney];
	}
	
	NSString* strFindKey = [strKey uppercaseString];
	
	NSString* useVolume = [_mapAccountToUseVolume objectForKey:strFindKey];
	if (useVolume == NULL || [useVolume length] <= 0)
		return NULL;
	return useVolume;
}

//根据资金账号获取可取资金
-(NSString*) getAvailableVolumeByAccount:(NSString*)sAccount strMoney_:(NSString*)strMoney
{
	if (sAccount == NULL || [sAccount length] <= 0)
        return NULL;
	NSString* strKey = sAccount;
	if (strKey == NULL)
		return FALSE;
	
	if (strMoney && [strMoney length] > 0)
    {
		strKey = [NSString stringWithFormat:@"%@|%@",sAccount, strMoney];
	}
	
	NSString* strFindKey = [strKey uppercaseString];
	NSString* availableVolume = [_mapAccountToAvailableVolume objectForKey:strFindKey];
	if (availableVolume == NULL || [availableVolume length] <= 0)
		return NULL;
	return availableVolume;
}


//填入账号以及账号密码
-(void) SetAccount:(NSString*)sAccount
{
    self.sAccount = [NSString stringWithFormat:@"%@", sAccount];
}

-(void) SetAccountPassword:(NSString*)sPassword
{
    self.sAccountPW = [NSString stringWithFormat:@"%@", sPassword];
}

-(void) setFundAccount:(NSString*)sFundAccount
{
    self.sFundAccount = [NSString stringWithFormat:@"%@", sFundAccount];
}

-(NSString*) GetFundAccount
{
	return self.sFundAccount;
}
//填入银行以及币种
-(void) SetBank:(NSString*)sBankName
{
    _sBankName = @"";
    _sBankNo = @"";
    _strBankPWFlag = @"";
    if (sBankName == NULL || [sBankName length] <= 0)
        return;
	NSString* strFindKey = [sBankName uppercaseString];
    
    self.sBankName = [NSString stringWithFormat:@"%@", sBankName];
    NSString* sBankNo = [_mapBankNameToNo objectForKey:strFindKey];
    self.sBankNo = [NSString stringWithFormat:@"%@", sBankNo];
    
    NSString* sBankFlag = [_mapBankNameToPWFlag objectForKey:strFindKey];
    if (sBankFlag && [sBankFlag length] > 0)
        self.strBankPWFlag = [NSString stringWithFormat:@"%@", sBankFlag];
}

-(void) SetMoneyType:(NSString*)sMoneyType
{
    _sMoneyTypeName = @"";
    _sMoneyTypeNo = @"";
    
    if (sMoneyType == NULL || [sMoneyType length] <= 0)
        return;
    
	NSString* strFindKey = [sMoneyType uppercaseString];
    
    self.sMoneyTypeName = [NSString stringWithFormat:@"%@", sMoneyType];
    
    NSString* strNo = [_mapMoneyTypeToNo objectForKey:strFindKey];
    self.sMoneyTypeNo = [NSString stringWithFormat:@"%@", strNo];
}

-(NSString*) GetBankName
{
	return self.sBankName;
}

-(NSString*) GetMoneyTypeName
{
	return self.sMoneyTypeName;
}
//资金转入账号
-(void) SetInFundAccount:(NSString*)inFundAccount
{
    _sInFundAccount = @"";
    if (inFundAccount == NULL || [inFundAccount length] <= 0)
        return;
    self.sInFundAccount = [NSString stringWithFormat:@"%@", inFundAccount];
}

-(NSString*) GetInFundAccount
{
	return self.sInFundAccount;
}

//资金转出账号
-(void) SetOutFundAccount:(NSString*)outFundAccount
{
    _sOutFundAccount = @"";
    if (outFundAccount == NULL || [outFundAccount length] <= 0)
        return;
    
    self.sOutFundAccount = [NSString stringWithFormat:@"%@", outFundAccount];
}

-(NSString*) GetOutFundAccount
{
	return self.sOutFundAccount;
}

//银行密码标识
-(BOOL) IsShowBankPW:(NSString*)strBankName
{
    if (strBankName == NULL || [strBankName length] <= 0)
        return TRUE;
    
	NSString* strFindKey = [strBankName uppercaseString];
    
    NSString* strBankPW = [_mapBankNameToPWFlag objectForKey:strFindKey];
    if (strBankPW == NULL || [strBankPW length] <= 0)
        return TRUE;
    
    BOOL bShow = ([strBankPW compare:@"0"] != NSOrderedSame);
    return bShow;
}

//银行密码标识 dengwei 20120828
-(BOOL) IsShowBankPW:(NSString*)strBank nType_:(NSInteger)nType
{
    
#if 1
    //	return [self IsShowBankPW:strBank];
	//
	if(strBank == NULL || [strBank length] <= 0)
		return FALSE;
	NSString* nsCode = [strBank uppercaseString];
    NSString* strBankPWFlag = [_mapBankNameToPWFlag objectForKey:nsCode];
    
    if (g_pSystermConfig.bOldDFCGPWShow)
    {
        
        if (strBankPWFlag && [strBankPWFlag length] > 0)
        {
            if(nType == WT_BANKTODEALER || nType == MENU_JY_PT_Bank2Card || nType == WT_RZRQBANKTODEALER || nType == MENU_JY_RZRQ_Bank2Card || nType == WT_DFBANKTODEALER || nType == MENU_JY_DFBANK_Bank2Card || nType == WT_DFQUERYBALANCE || nType == MENU_JY_DFBANK_BankYue || nType == MENU_JY_DFBANK_Card2Bank)
            {
                if ([strBankPWFlag intValue] == 0)
                {
                    return FALSE;
                }else if ([strBankPWFlag intValue] == 1)
                {
                    return TRUE;
                }
                else
                    return TRUE;
            }
            else
            {
                return TRUE;
            }
        }
        else
        {
            return TRUE;
        }
    }
    if (strBankPWFlag == NULL || [strBankPWFlag length] <= 0)
    {
        if (nType == WT_BANKTODEALER || nType == MENU_JY_PT_Bank2Card || nType == WT_DFBANKTODEALER || nType == WT_RZRQBANKTODEALER || nType == MENU_JY_RZRQ_Bank2Card
            || nType == WT_QUERYBALANCE || nType == MENU_JY_PT_BankYue || nType == WT_DFQUERYBALANCE || nType == WT_RZRQQUERYBALANCE || nType == MENU_JY_RZRQ_BankYue || nType == MENU_JY_DFBANK_Bank2Card || nType == MENU_JY_DFBANK_BankYue)
            return TRUE;
        else
            return FALSE;
        
    }
	//    return ![strBankPWFlag Compare:"0"];
    NSRange range;
	if (nType == WT_DEALERTOBANK || nType == MENU_JY_PT_Card2Bank || nType == WT_RZRQDEALERTOBANK || nType == MENU_JY_RZRQ_Card2Bank || nType == WT_DFDEALERTOBANK || nType == MENU_JY_DFBANK_Card2Bank)
	{
        range = [strBankPWFlag rangeOfString:@"1"];
        if (range.length > 0)
            return TRUE;
        else
            return FALSE;
	}
	else if(nType == WT_BANKTODEALER || nType == MENU_JY_PT_Bank2Card || nType == WT_RZRQBANKTODEALER || nType == MENU_JY_RZRQ_Bank2Card || nType == WT_DFBANKTODEALER || nType == MENU_JY_DFBANK_Bank2Card)
	{
        range = [strBankPWFlag rangeOfString:@"3"];
        if (range.length > 0)
            return TRUE;
        else
            return FALSE;
	}
	else if(nType == WT_QUERYBALANCE || nType == MENU_JY_PT_BankYue || nType == WT_RZRQQUERYBALANCE || nType == MENU_JY_RZRQ_BankYue || nType == WT_DFQUERYBALANCE || nType == MENU_JY_DFBANK_BankYue)
	{
        range = [strBankPWFlag rangeOfString:@"5"];
        if (range.length > 0)
            return TRUE;
        else
            return FALSE;
	}
	else
	{
		return TRUE;
	}
#endif
}


//资金密码标识
-(BOOL) IsShowFundPW:(NSString*)strBank nType_:(NSInteger)nType
{
    if (g_pSystermConfig.bOldDFCGPWShow)
    {
        if (nType == WT_DEALERTOBANK || nType == MENU_JY_PT_Card2Bank || nType == WT_RZRQDEALERTOBANK || nType == MENU_JY_RZRQ_Card2Bank || nType == WT_DFDEALERTOBANK || nType == MENU_JY_DFBANK_Card2Bank)
            return TRUE;
        else
            return FALSE;
    }
	if(strBank == NULL || [strBank length] <= 0)
		return TRUE;
	NSString* nsCode = [strBank uppercaseString];
    NSString* strBankPWFlag = [_mapBankNameToPWFlag objectForKey:nsCode];
    
    if (strBankPWFlag == NULL || [strBankPWFlag length] <= 0)
    {
        if (nType == WT_DEALERTOBANK || nType == MENU_JY_PT_Card2Bank || nType == WT_RZRQDEALERTOBANK || nType == MENU_JY_RZRQ_Card2Bank || nType == WT_DFDEALERTOBANK || nType == MENU_JY_DFBANK_Card2Bank)
            return TRUE;
        else
            return FALSE;
    }
    NSRange range;
	if (nType == WT_DEALERTOBANK || nType == MENU_JY_PT_Card2Bank || nType == WT_RZRQDEALERTOBANK || nType == MENU_JY_RZRQ_Card2Bank || nType == WT_DFDEALERTOBANK || nType == MENU_JY_DFBANK_Card2Bank)
	{
        range = [strBankPWFlag rangeOfString:@"2"];
        if (range.length > 0)
            return TRUE;
        else
            return FALSE;
	}
	else if(nType == WT_BANKTODEALER || nType == MENU_JY_PT_Bank2Card || nType == WT_RZRQBANKTODEALER || nType == MENU_JY_RZRQ_Bank2Card || nType == WT_DFBANKTODEALER || nType == MENU_JY_DFBANK_Bank2Card)
	{
        range = [strBankPWFlag rangeOfString:@"4"];
        if (range.length > 0)
            return TRUE;
        else
            return FALSE;
	}
	else if(nType == WT_QUERYBALANCE || nType == MENU_JY_PT_BankYue || nType == WT_RZRQQUERYBALANCE || nType == MENU_JY_RZRQ_BankYue || nType == WT_DFQUERYBALANCE  || nType == MENU_JY_DFBANK_BankYue)
	{
        range = [strBankPWFlag rangeOfString:@"6"];
        if (range.length > 0)
            return TRUE;
        else
            return FALSE;
	}
	else
	{
		return TRUE;
	}
	
}
//填入银行密码
-(void) SetBankPassword:(NSString*)sPassword
{
    self.sBankPW = [NSString stringWithFormat:@"%@", sPassword];
}
//设置资金密码
-(void) SetDealerPassword:(NSString*)sPassword
{
    self.sDealerPW = [NSString stringWithFormat:@"%@", sPassword];
}

//设定转账数量
-(void) SetTransferVolume:(float)fMoney
{
    _fTranseVolume = fMoney;
}

//银行转券商请求
-(NSString*) MakeStrBankToDealer:(NSMutableDictionary*) pDict
{
    if (pDict == NULL)
        return NULL;
    
    NSString* strAction = @"";
    if (IsRZRQMsgType(_nQuestType))//融资融券
    {
        strAction = @"425";
    }
    else if( IsDFBankJYMsgType(_nQuestType))//多银行
    {
        strAction = @"345";
        if (_sFundAccount && [_sFundAccount length] > 0)
        {
            [pDict setTztValue:_sFundAccount forKey:@"FUNDACCOUNT"];
        }
    }
    else
        strAction = @"126";
    
    [pDict setTztValue:@"B" forKey:@"Direction"];
    [pDict setTztValue:@"ZJACCOUNT" forKey:@"ACCOUNTYPE"];
    if (_sAccount)
        [pDict setTztValue:_sAccount forKey:@"ACCOUNT"];
    [pDict setTztValue:@"1" forKey:@"ENCRYPT"];
    if (_sAccountPW)
        [pDict setTztValue:_sAccountPW forKey:@"PASSWORD"];
    [pDict setTztValue:@"0" forKey:@"BANKDIRECTION"];
    if (_sBankPW)
        [pDict setTztValue:_sBankPW forKey:@"BANKPASSWORD"];
    
    if (_sDealerPW)
        [pDict setTztValue:_sDealerPW forKey:@"FETCHPASSWORD"];
    
    [pDict setTztValue:[NSString stringWithFormat:@"%f", _fTranseVolume] forKey:@"BANKVOLUME"];
    
    if (_sBankNo)
        [pDict setTztValue:_sBankNo forKey:@"BANKINDENT"];
    if (_sMoneyTypeNo)
        [pDict setTztValue:_sMoneyTypeNo forKey:@"MONEYTYPE"];
    if (_strBankPWFlag)
        [pDict setTztValue:_strBankPWFlag forKey:@"BANKPWDFLAG"];
	return strAction;
}

//券商转银行请求
-(NSString*) MakeStrDealerToBank:(NSMutableDictionary*) pDict
{
    if (pDict == NULL)
        return NULL;
    
    NSString *strAction = @"";
    if (IsRZRQMsgType(_nQuestType))
    {
        strAction = @"425";
    }
    else if(IsDFBankJYMsgType(_nQuestType))
    {
        strAction = @"345";
        if (_sFundAccount)
            [pDict setTztValue:_sFundAccount forKey:@"FUNDACCOUNT"];
    }
    else
        strAction = @"126";
    
    [pDict setTztValue:@"B" forKey:@"Direction"];
    [pDict setTztValue:@"ZJACCOUNT" forKey:@"ACCOUNTTYPE"];
    if(_sAccount)
        [pDict setTztValue:_sAccount forKey:@"ACCOUNT"];
    
    [pDict setTztValue:@"1" forKey:@"ENCRYPT"];
    if (_sAccountPW)
        [pDict setTztValue:_sAccountPW forKey:@"PASSWORD"];
    [pDict setTztValue:@"1" forKey:@"BANKDIRECTION"];
    if (_sDealerPW)
        [pDict setTztValue:_sDealerPW forKey:@"FETCHPASSWORD"];
    
    [pDict setTztValue:[NSString stringWithFormat:@"%f", _fTranseVolume] forKey:@"BANKVOLUME"];
    if (_sBankNo)
        [pDict setTztValue:_sBankNo forKey:@"BANKINDENT"];
    if (_sMoneyTypeNo)
        [pDict setTztValue:_sMoneyTypeNo forKey:@"MONEYTYPE"];
    
    return strAction;
}

//银证转账流水请求
-(NSString*) MakeStrQueryHistroy:(BOOL)isMoneyNotify sNO_:(NSString*)sNo strSend_:(NSMutableDictionary*) pDict
{
    if (pDict == NULL)
        return NULL;
    
    NSString* strAction = @"";
    if (isMoneyNotify)
    {
        if ( IsRZRQMsgType(_nQuestType))
        {
            strAction = @"427";
        }
        else
            strAction = @"182";
        
        if (sNo)
            [pDict setTztValue:sNo forKey:@"errorno"];
    }
    else
    {
        if (IsRZRQMsgType(_nQuestType))
        {
            strAction = @"426";
        }
        else if(IsDFBankJYMsgType(_nQuestType))
        {
            strAction = @"341";
            if (_sFundAccount)
                [pDict setTztValue:_sFundAccount forKey:@"FUNDACCOUNT"];
        }
        else
            strAction = @"127";
    }
    
    [pDict setTztValue:@"B" forKey:@"Diretction"];
    [pDict setTztValue:@"ZJACCOUNT" forKey:@"ACCOUNTTYPE"];
    
    if (_sAccount && _nQuestType != WT_TRANSHISTORY && _nQuestType != MENU_JY_PT_QueryBankHis)//转账流水不发
    {
        [pDict setTztValue:_sAccount forKey:@"ACCOUNT"];
    }
    
    [pDict setTztValue:@"1" forKey:@"ENCRYPT"];
    if(_sAccountPW)
        [pDict setTztValue:_sAccountPW forKey:@"PASSWORD"];
    if(_sDealerPW)
        [pDict setTztValue:_sDealerPW forKey:@"BANKPASSWORD"];
    if(_sStartDate)
        [pDict setTztValue:_sStartDate forKey:@"BANKBEGINDATE"];
    if(_sEndDate)
        [pDict setTztValue:_sEndDate forKey:@"BANKENDDATE"];
    if(_sBankNo)
        [pDict setTztValue:_sBankNo forKey:@"BANKINDENT"];
    if(_sMoneyTypeNo)
        [pDict setTztValue:_sMoneyTypeNo forKey:@"MONEYTYPE"];
    
	return strAction;
}

//银行余额请求
-(NSString*) MakeStrQueryBalance:(NSMutableDictionary*) pDict
{
    if (pDict == NULL)
        return NULL;
    
    NSString* strAction = @"";
    if (IsRZRQMsgType(_nQuestType))
    {
        strAction = @"427";
    }
    else if(IsDFBankJYMsgType(_nQuestType))
    {
        strAction = @"346";
        if (_sFundAccount)
            [pDict setTztValue:_sFundAccount forKey:@"FUNDACCOUNT"];
    }
    else
        strAction = @"128";
    
    [pDict setTztValue:@"B" forKey:@"Direction"];
    [pDict setTztValue:@"1" forKey:@"ENCRYPT"];
    if (_sAccountPW)
        [pDict setTztValue:_sAccountPW forKey:@"PASSWORD"];
    if (_sBankPW)
        [pDict setTztValue:_sBankPW forKey:@"BANKPASSWORD"];
    if (_sBankNo)
        [pDict setTztValue:_sBankNo forKey:@"BANKINDENT"];
    if (_sMoneyTypeNo)
        [pDict setTztValue:_sMoneyTypeNo forKey:@"MONEYTYPE"];
    return strAction;
}

//资金内转请求
-(NSString*) MakeStrZiJinNeiZhuan:(NSMutableDictionary*) pDict
{
    if (pDict == NULL)
        return NULL;
    NSString *strAction = @"344";
    
    [pDict setTztValue:@"B" forKey:@"DIRECTION"];
    [pDict setTztValue:@"ZJACCOUNT" forKey:@"ACCOUNTTYPE"];
    [pDict setTztValue:@"1" forKey:@"ENCRYPT"];
    
    if (_sAccount)
        [pDict setTztValue:_sAccount forKey:@"ACCOUNT"];
    if (_sAccountPW)
        [pDict setTztValue:_sAccountPW forKey:@"PASSWORD"];
    
    
    [pDict setTztValue:@"1" forKey:@"BANKDIRECTION"];
    if(_sDealerPW)
        [pDict setTztValue:_sDealerPW forKey:@"FETCHPASSWORD"];
    
    [pDict setTztValue:[NSString stringWithFormat:@"%f",_fTranseVolume] forKey:@"BANKVOLUME"];
    
    if (_sMoneyTypeNo)
        [pDict setTztValue:_sMoneyTypeNo forKey:@"MONEYTYPE"];
    if (_sOutFundAccount)
        [pDict setTztValue:_sOutFundAccount forKey:@"OUTFUNDACCOUNT"];
    if (_sInFundAccount)
        [pDict setTztValue:_sInFundAccount forKey:@"INFUNDACCOUNT"];
    return strAction;
}


//查询银行列表请求
-(NSString*) MakeStrGetBankList:(NSMutableDictionary*) pDict
{
    if (pDict == NULL)
        return NULL;
    NSString* strAction = @"";
    
    [pDict setTztValue:@"10" forKey:@"Maxcount"];
	return strAction;
}

-(void) SetToken:(NSString*)sToken
{
    self.sToken = [NSString stringWithFormat:@"%@", sToken];
}

-(void) SetStartDate:(NSString*)sStartDate
{
    self.sStartDate = [NSString stringWithFormat:@"%@", sStartDate];
}

-(void) SetEndDate:(NSString*)sEndDate
{
    self.sEndDate = [NSString stringWithFormat:@"%@", sEndDate];
}
//币种－银行列表
-(NSMutableArray*) GetBankListByMoney:(NSString*)strMoney
{
    if (strMoney == NULL || [strMoney length] <= 0)
        return NULL;
    
	NSString* strFindKey = [strMoney uppercaseString];
    
    return [_mapMoneyToBank objectForKey:strFindKey];
}
//银行－币种列表
-(NSMutableArray*) GetMoneyListByBank:(NSString*)strBank
{
    if (strBank == NULL || [strBank length] <= 0)
        return NULL;
    
	NSString* strFindKey = [strBank uppercaseString];
    
    return [_mapBankToMoney objectForKey:strFindKey];
}
//获取银行列表信息
-(void) GetBankList:(NSMutableArray*)ayBank
{
    [ayBank addObjectsFromArray:_saBankList];
    return;
}
//获取币种列表信息
-(void) GetMoneyList:(NSMutableArray*)ayMoney;
{
    [ayMoney addObjectsFromArray:_saMoneyType];
    return;
}
-(void) ReceiveBankInfoSuc:(BOOL)bSuc
{
    _bGetBankInfoSuc = bSuc;
}
//是否有银证转账银行
-(BOOL) HaveBankInfo
{
    return _bGetBankInfoSuc;
}
//清空可用资金
-(void) ClearUseVolumeData
{
	//NSArray *array = [m_mapAccountToUseVolume GetAllValue];
	[_mapAccountToUseVolume removeAllObjects];
}
//清空可取资金
-(void) ClearAvailableVolumeData
{
	//NSArray *array = [m_mapAccountToAvailableVolume GetAllValue];
	[_mapAccountToAvailableVolume removeAllObjects];
}
-(void) SetKey:(int)nKey
{
    _nKey = nKey;
}
-(void) SetTransferType:(NSInteger)nTransferType;
{
    _nQuestType = nTransferType;
}
@end
