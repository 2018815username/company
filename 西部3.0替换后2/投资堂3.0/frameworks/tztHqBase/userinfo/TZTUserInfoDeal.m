/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTUserInfoDeal.m
 * 文件标识：
 * 摘    要：用户信息
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期： 2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import "TZTUserInfoDeal.h"
#import "tztJYLoginInfo.h"
unsigned long   g_nJYLoginFlag = 0;   //交易登录类型

extern id g_pTZTDelegate;

NSInteger g_AccountIndex = -1;

NSInteger g_ZjAccountArrayNum = 0;
NSInteger g_YYBListArrayNum = 0;
NSInteger g_ZQGSListArrayNum = 0;
NSInteger g_AcTypeArrayNum = 0;

NSMutableArray  *g_ZJAccountArray = nil;
NSMutableArray  *g_ZQGSListArray = nil;
NSMutableArray  *g_YYBListArray = nil;
NSMutableArray  *g_AccountTypeArray = nil;

extern NSString     *g_nsLogMobile; //登录手机号

tztUserData *g_CurUserData = NULL;
@implementation tztUserData
@synthesize nsMobileCode = _nsMobileCode;
@synthesize nsCheckKEY = _nsCheckKEY;
@synthesize nsPassword = _nsPassword;
@synthesize nMobileType = _nMobileType;
@synthesize nsDBPLoginToken = _nsDBPLoginToken;

@synthesize ayAccountToken = _ayAccountToken;

@synthesize isRegist = _isRegist;
@synthesize iUserType = _iUserType;
@synthesize nMZTKFlag = _nMZTKFlag;
@synthesize bRememberPWD = _bRememberPWD;
@synthesize nsLockTradeTime = _nsLockTradeTime;
@synthesize nsSecure = _nsSecure;
@synthesize bNeedShowLock =_bNeedShowLock;
@synthesize bCGFenXiang = _bCGFenXiang;
@synthesize nsGTJAXMLCrc = _nsGTJAXMLCrc;
-(id)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

- (void)reSetUserData
{
#ifndef Support_OpenUDID_for_MobileCode
//    [tztKeyChain save:tztLogMobile data:@""];
#endif
    self.nsMobileCode = @"";
    self.nsCheckKEY = @"";
    self.nsPassword = @"";
    self.nsDBPLoginToken = @"";
    self.isRegist = 1;
    self.iUserType = 0;
    self.bRememberPWD = 0;
    self.nsLockTradeTime = @"";
    self.nsSecure = @"";
    self.bNeedShowLock = FALSE;
    self.bCGFenXiang = TRUE;
    
    if(_ayAccountToken == nil)
    {
        _ayAccountToken = [[NSMutableArray alloc] initWithCapacity:TZTMaxAccountType];
    }
    [_ayAccountToken removeAllObjects];
    
    for (int i = 0; i < TZTMaxAccountType; i++)
    {
        NSMutableArray* ayToken = [[NSMutableArray alloc] initWithCapacity:TZTMaxAccount];
        for (int j = 0; j < TZTMaxAccount; j++)
        {
            [ayToken addObject:@""];
        }
        [_ayAccountToken addObject:ayToken];
        [ayToken release];
    }
    [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllServer_Log];
  }
-(void)clearAllSaveAccount{
    //清除保存的账号数据
    NSString* strPath = GetPathWithListName(@"tztAccountData", TRUE);
    //先获取文件中保存的数据
    NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithContentsOfFile:strPath];
    if (pDict) {
        [pDict removeAllObjects];
        [pDict writeToFile:strPath atomically:YES];
    }
  
}

-(void)initData
{
    [self reSetUserData];
    self.nMobileType = 3;
    self.nMZTKFlag = 0;
}

//清空某账号类型的token
- (void)delAccountToken:(NSInteger)nTokenKind
{
    if(nTokenKind >= 0 && nTokenKind < TZTMaxAccountType)
    {
        NSMutableArray* ayToken = [_ayAccountToken objectAtIndex:nTokenKind];
        for (int i = 0; i < [ayToken count]; i++)
        {
            [ayToken replaceObjectAtIndex:i withObject:@""];
        }
    }
}

//设置Token 对应 账号类别 tokenIndex
- (void)setAccountToken:(NSString*)strToken tokenKind:(NSInteger)nTokenKind tokenIndex:(NSInteger)nTokenIndex
{
    if(nTokenKind >= 0 && nTokenKind < TZTMaxAccountType && nTokenIndex >= 0 && nTokenIndex < TZTMaxAccount )
    {
        NSMutableArray* ayToken = [_ayAccountToken objectAtIndex:nTokenKind];
        [ayToken replaceObjectAtIndex:nTokenIndex withObject:strToken];
    }
}

//获取Token 对应账号类型 tokenIndex
- (NSString*)getAccountTokenOfKind:(NSInteger)nTokenKind tokenIndex:(NSInteger)nTokenIndex
{
    if(nTokenKind >= 0 && nTokenKind < TZTMaxAccountType && nTokenIndex >= 0 && nTokenIndex < TZTMaxAccount )
    {
        NSMutableArray* ayToken = [_ayAccountToken objectAtIndex:nTokenKind];
        if(nTokenIndex >= 0 && nTokenIndex < [ayToken count])
        {
            return [ayToken objectAtIndex:nTokenIndex];
        }
    }
    return @"";
}


//获取Token空余的TokenIndex
- (int)getCanUseTokenOfKind:(NSInteger)nTokenKind
{
    int tokenIndex = 1;
    if(nTokenKind >= 0 && nTokenKind < TZTMaxAccountType)
    {
        NSMutableArray* ayToken = [_ayAccountToken objectAtIndex:nTokenKind];
        for (int i = 1; i < [ayToken count]; i++)
        {
            NSString *strToken = [ayToken objectAtIndex:i];
            if (strToken == NULL || [strToken length] <= 0) //空余记录
            {
                tokenIndex = i;
                [ayToken replaceObjectAtIndex:tokenIndex withObject:@"1"];
                break;
            }
        }
    }
    return tokenIndex;
}


-(void)dealloc
{
    NilObject(self.nsDBPLoginToken);
    DelObject(_ayAccountToken);
    [super dealloc];
}

+(tztUserData*)getShareClass
{
    [tztUserData initShareClass];
    return g_CurUserData;
}

+(void)initShareClass
{
    if(g_CurUserData == nil)
    {
        g_CurUserData = NewObject(tztUserData);
    }
}

+(void)freeShareClass
{
    DelObject(g_CurUserData);
}
@end

@implementation TZTUserInfoDeal
//====读写配置文件，系统登录相关====
//读取或者保存系统登录账号
+(BOOL)SaveAndLoadLogin:(BOOL)bLoadLogin nFlag_:(int)nFLag
{
    [tztUserData getShareClass];
    //读取保存的用户信息
    if (bLoadLogin)
    {
       return [TZTUserInfoDeal readTztUserData];
    }
    else//保存用户信息
    {
        return [TZTUserInfoDeal writeTztUserData];
    }
    return TRUE;
}

//读取用户信息
+(BOOL)readTztUserData
{
    [tztUserData getShareClass];
    //读取保存的用户信息
    TZTNSLog(@"%@",@"SaveAndLoadLogin -- Read");
    //读取前，先清空当前数据
    [g_CurUserData reSetUserData];
    //先读取当前保存的类型
    NSMutableDictionary *pDict = [tztKeyChain load:@"com.tzt.userinfo"];
    if(pDict == NULL)
        pDict = GetDictByListName(@"tztUserSysternInfo");
    if (pDict)
    {
        int nVersion = 0;
        NSString* strVersion = [pDict tztObjectForKey:@"tztUserDataVersion"];
        if(strVersion && [strVersion length] > 0 )
        {
            nVersion = [strVersion intValue];
        }
        //手机号码
        NSString *strMobileCode = [pDict tztObjectForKey:@"tztMobileCode"];
        //激活码
        NSString *strCheckKEY = [pDict tztObjectForKey:@"tztCheckKEY"];
        //用户密码
        NSString *strPassWord = [pDict tztObjectForKey:@"tztPassword"];
        //免责条款
        NSString *strMZTKFlag = [pDict tztObjectForKey:@"tztMZTKFLAG"];
        //用户类别 一键登录、账号登录
        NSString *strUserType = [pDict tztObjectForKey:@"tztUserType"];
        //记住密码，国联
        NSString *strRememberPWD = [pDict tztObjectForKey:@"tztRememberPWD"];
        //交易锁定时间
        NSString *strLockTradeTime = [pDict tztObjectForKey:@"tztLockTradeTime"];
        //账号是否加密
        NSString *strSecure = [pDict tztObjectForKey:@"tztSecure"];
        if(nVersion == 0)
        {
            
        }
        else if(nVersion == 1) //1 版本 数据加密 手机号|密码|免责|登录类型|激活码|
        {
            NSString* strUserDataValue = [pDict tztObjectForKey:@"tztUserDataValue"];
            if(strUserDataValue && [strUserDataValue length] > 0 )
            {
                strUserDataValue = textFromBase64String(strUserDataValue);
                if(strUserDataValue && [strUserDataValue length] > 0)
                {
                    NSArray* ayUserData = [strUserDataValue componentsSeparatedByString:@"|"];
                    if(ayUserData && [ayUserData count] > 3)
                    {
                        strMobileCode = [ayUserData objectAtIndex:0];
                        strCheckKEY = [ayUserData objectAtIndex:1];
                        strUserType = [ayUserData objectAtIndex:2];
                        strMZTKFlag = [ayUserData objectAtIndex:3];
                        if ([ayUserData count] > 4)
                            strRememberPWD = [ayUserData objectAtIndex:4];
                        if ([ayUserData count] > 5)
                            strPassWord = [ayUserData objectAtIndex:5];
                        if ([ayUserData count] > 6)
                            strLockTradeTime = [ayUserData objectAtIndex:6];
                        if ([ayUserData count] > 7)
                            strSecure = [ayUserData objectAtIndex:7];
                    }
                }
            }
        }
        
        if (strMobileCode)
            g_CurUserData.nsMobileCode = [NSString stringWithFormat:@"%@", strMobileCode];
        if (strCheckKEY)
            g_CurUserData.nsCheckKEY = [NSString stringWithFormat:@"%@",strCheckKEY];
        if (strPassWord)
            g_CurUserData.nsPassword = [NSString stringWithFormat:@"%@", strPassWord];
        
        if (strMZTKFlag  && [strMZTKFlag length] > 0)
            g_CurUserData.nMZTKFlag = [strMZTKFlag intValue];
        
        if (strUserType && [strUserType length] > 0)
            g_CurUserData.iUserType = [strUserType intValue];
                
        if (strRememberPWD && [strRememberPWD length] > 0)
            g_CurUserData.bRememberPWD = [strRememberPWD boolValue];
        
        if (strLockTradeTime && [strLockTradeTime length] > 0)
            g_CurUserData.nsLockTradeTime = [NSString stringWithFormat:@"%@",strLockTradeTime];
        else
            g_CurUserData.nsLockTradeTime = @"20";
        
        if (strSecure && [strSecure length] > 0)
            g_CurUserData.nsSecure = [NSString stringWithFormat:@"%@",strSecure];
        else
            g_CurUserData.nsSecure = @"1";
    }
    else
    {
        //若当前为空，则接着读取老版本下面保存的数据
        //＝＝＝＝＝＝＝＝＝＝＝＝＝先获取原先版本下的数据＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
        //获取文件路劲
        NSString* path = GetDocumentPath(@"TztData/Config/Systerm.cfg", FALSE);
        if(path && [path length] > 0)
        {
            NSData* reader = [NSData dataWithContentsOfFile:path];
            if (reader)
            {
                NSString* strData =  [[[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding] autorelease];
                
                NSArray *pAy = [strData componentsSeparatedByString:@"\r\n"];
                for (int i = 0; i < [pAy count]; i++)
                {
                    NSString *str = [pAy objectAtIndex:i];
                    if (str == NULL || [str length] <= 0)
                        continue;
                    
                    NSArray *pSubAy = [str componentsSeparatedByString:@"="];
                    if (pSubAy == NULL || [pSubAy count] <= 1)
                        continue;
                    
                    NSString* strKey = [pSubAy objectAtIndex:0];
                    NSString* strValue = [pSubAy objectAtIndex:1];
                    if (strKey && [strKey compare:@"SysAccount"] == NSOrderedSame)
                    {
                        g_CurUserData.nsMobileCode = [NSString stringWithFormat:@"%@", strValue];
                    }
                    if (strKey && [strKey compare:@"SysAccountPW"] == NSOrderedSame)
                    {
                        g_CurUserData.nsCheckKEY = [NSString stringWithFormat:@"%@", strValue];
                    }
                }
            }
        }
    }

    return TRUE;
}

//保存用户信息
+(BOOL)writeTztUserData
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:@"1" forKey:@"tztUserDataVersion"]; //版本号

    NSString* strMobileCode = g_CurUserData.nsMobileCode;
    if (strMobileCode == nil)
    {
        strMobileCode = @"";
        [TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllServer_Log];
    }
    
    NSString* strCheckKEY = g_CurUserData.nsCheckKEY;
    if (strCheckKEY == nil)
    {
        strCheckKEY = @"";
    }
    NSString *strPassWord = g_CurUserData.nsPassword;
    if (strPassWord == nil)
    {
        strPassWord = @"";
    }
    
    NSString* strMZTKFlag = [NSString stringWithFormat:@"%ld", (long)g_CurUserData.nMZTKFlag];
    NSString* strUserType = [NSString stringWithFormat:@"%ld", (long)g_CurUserData.iUserType];
    NSString* strRememberPWD = @"0";
    if (g_CurUserData.bRememberPWD)
        strRememberPWD = @"1";
   
    NSString * strLockTradeTime = g_CurUserData.nsLockTradeTime;
    if (strLockTradeTime == NULL)
    {
        strLockTradeTime = @"20";
    }
    
    NSString * strSecure = g_CurUserData.nsSecure;
    if (strSecure == NULL)
    {
        strSecure = @"1";
    }

    NSString* strUserDataValue = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|",strMobileCode,strCheckKEY,strUserType,strMZTKFlag, strRememberPWD, strPassWord,strLockTradeTime,strSecure];
    
    strUserDataValue = base64StringFromText(strUserDataValue);
    if(strUserDataValue && [strUserDataValue length] > 0)
    {
        [pDict setTztValue:[NSString stringWithFormat:@"%@",strUserDataValue] forKey:@"tztUserDataValue"];
    }
    else
    {
        [pDict setTztValue:@"0" forKey:@"tztUserDataVersion"]; //版本号
        [pDict setTztValue:[NSString stringWithFormat:@"%@",strMobileCode] forKey:@"tztMobileCode"];
        [pDict setTztValue:[NSString stringWithFormat:@"%@",strCheckKEY]  forKey:@"tztCheckKEY"];
        [pDict setTztValue:[NSString stringWithFormat:@"%@",strUserType] forKey:@"tztUserType"];
        [pDict setTztValue:[NSString stringWithFormat:@"%@",strMZTKFlag] forKey:@"TZTMZTKFLAG"];
        [pDict setTztObject:[NSString stringWithFormat:@"%@", strRememberPWD] forKey:@"tztRememberPWD"];
        [pDict setTztObject:[NSString stringWithFormat:@"%@", strPassWord] forKey:@"tztPassword"];
        [pDict setTztObject:[NSString stringWithFormat:@"%@", strLockTradeTime] forKey:@"tztLockTradeTime"];
        [pDict setTztObject:[NSString stringWithFormat:@"%@", strSecure] forKey:@"tztSecure"];
        
    }
    [tztKeyChain save:@"com.tzt.userinfo" data:pDict];
    if(!SetDictByListName(pDict,@"tztUserSysternInfo"))
    {
        TZTLogErrorUp(@"写入用户%@失败:%@",g_CurUserData.nsMobileCode,pDict);
    }
    DelObject(pDict);
    return TRUE;
}

+(void) SetLoginState:(int)LoginState
{
    
}

+(int) GetLoginState
{
    return 0;
}

//读取或者保存系统登录账号
+(BOOL) SaveAndLoadLoginAccount:(BOOL)bLoadLogin nFlag_:(int)nFlag strAccount_:(NSString*)strAccount
{
    
    return TRUE;
}

+(BOOL) IsTradeLogin:(long)lLoginType
{
    if ((lLoginType & g_nJYLoginFlag) == lLoginType)
        return TRUE;
    
    return FALSE;
}

+(BOOL) IsHaveTradeLogin:(long)lLoginType
{
    if (lLoginType & g_nJYLoginFlag)
        return TRUE;
    return FALSE;
}

+(void) SetTradeLogState:(char)IsLogin lLoginType_:(long)lLoginType withNotifi:(BOOL)bSend
{
    if (IsLogin == Trade_Login)
    {
        if (bSend)
        {
            /*发出消息通知，处理交易状态更改后，界面的显示处理*/
            NSString* str = [NSString stringWithFormat:@"%ld|%d", lLoginType,IsLogin];
            NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_ChangeLoginState object:str];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            /*add by yinjp 20131026*/
            g_nJYLoginFlag = g_nJYLoginFlag | lLoginType;
        }
    }
    else
    {
        if (bSend && [TZTUserInfoDeal IsHaveTradeLogin:lLoginType])
        {
            /*发出消息通知，处理交易状态更改后，界面的显示处理*/
            NSString* str = [NSString stringWithFormat:@"%ld|%d", lLoginType,IsLogin];
            NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_ChangeLoginState object:str];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            /*add by yinjp 20131026*/
            
            /*发出消息通知，处理交易状态更改后，界面的显示处理*/
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:@"1" forKey:@"ShowAll"];
            NSNotification* pNotifi1 = [NSNotification notificationWithName:TZTNotifi_CheckTradeGrid object:pDict];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi1];
            DelObject(pDict);
            /*add by yinjp 20131026*/
        }
        
        g_nJYLoginFlag = g_nJYLoginFlag & (~lLoginType);
        
        if( g_pTZTDelegate && [g_pTZTDelegate respondsToSelector:@selector(callback:withParams:)]
           && ((StockTrade_Log &lLoginType) == StockTrade_Log ) )
		{
			if( [TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log] )
			{
				TZTNSLog(@"StockTrade_Log Exist ISBUG");
			}
			else
			{
				TZTNSLog(@"StockTrade_Log NO Exist ISOK!");
			}
			
			NSArray* pArry = [NSArray arrayWithObjects:@"0",nil];
			NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:pArry,@"JYLOGOUT",nil];
            if (g_pTZTDelegate && [g_pTZTDelegate respondsToSelector:@selector(callback:withParams:)])
                [g_pTZTDelegate callback:self withParams:params];
		}
    }
    if (lLoginType == StockTrade_Log)
    {
        NSString* strGoBackOnLoad = [NSString stringWithFormat:@"%@",@"LoginOnLoad();"];
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_ChangeShortCut object:strGoBackOnLoad];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
    }
}

+(void) SetTradeLogState:(char)IsLogin lLoginType_:(long)lLoginType
{
    [TZTUserInfoDeal SetTradeLogState:IsLogin lLoginType_:lLoginType withNotifi:YES];
}

+(int) SaveAndLoadJYAccountList:(BOOL)bSave lLoginType_:(long)lLoginType
{
    return 0;
}
//读取保存本地交易账号列表 参数:TRUE:保存;FALSE:读取
+(int) SaveAndLoadJYAccountList:(BOOL)bSave
{
    //zxl 20130719 添加了 读取保存本地交易账号列表
    if (bSave)
    {
        NSMutableArray *Arry = NewObject(NSMutableArray);
        for (int i = 0;i < [g_ZJAccountArray count]; i++)
        {
            tztZJAccountInfo * accountInfo = [g_ZJAccountArray objectAtIndex:i];
            if (accountInfo == NULL)
                continue;
            NSMutableDictionary *pDictAccout = NewObject(NSMutableDictionary);
            [pDictAccout setTztValue: accountInfo.nsAccount forKey:@"nsAccount"];
            [pDictAccout setTztValue: accountInfo.nsAccountType forKey:@"nsAccountType"];
            [pDictAccout setTztValue: accountInfo.nsCellIndex forKey:@"nsCellIndex"];
            [pDictAccout setTztValue: accountInfo.nsCellName forKey:@"nsCellName"];
            [pDictAccout setTztValue: accountInfo.nsCustomID forKey:@"nsCustomID"];
            [pDictAccout setTztValue: accountInfo.nsPassword forKey:@"nsPassword"];
            [pDictAccout setTztValue: [NSString stringWithFormat:@"%ld",(long)accountInfo.nNeedComPwd] forKey:@"nNeedComPwd"];
            [Arry addObject:pDictAccout];
            DelObject(pDictAccout);
        }
        SetArrayByListName(Arry, @"tztLoginUserList");
        DelObject(Arry);
    }else
    {
        NSMutableArray *Arry = GetArrayByListName(@"tztLoginUserList");
        if (g_ZJAccountArray == NULL)
            g_ZJAccountArray = NewObject(NSMutableArray);
        
        [g_ZJAccountArray removeAllObjects];
        for (int i = 0; i < [Arry count]; i++)
        {
            NSMutableDictionary *pDictAccout = [Arry objectAtIndex:i];
            if (pDictAccout)
            {
                tztZJAccountInfo * accountInfo = NewObject(tztZJAccountInfo);
                NSString *Value = [pDictAccout tztObjectForKey:@"nsAccount"];
                accountInfo.nsAccount = [NSString stringWithFormat:@"%@",Value];
                
                Value = [pDictAccout tztObjectForKey:@"nsAccountType"];
                accountInfo.nsAccountType = [NSString stringWithFormat:@"%@",Value];
                
                Value = [pDictAccout tztObjectForKey:@"nsCellIndex"];
                accountInfo.nsCellIndex = [NSString stringWithFormat:@"%@",Value];
                
                Value = [pDictAccout tztObjectForKey:@"nsCellName"];
                accountInfo.nsCellName = [NSString stringWithFormat:@"%@",Value];
                
                
                Value = [pDictAccout tztObjectForKey:@"nsCustomID"];
                accountInfo.nsCustomID = [NSString stringWithFormat:@"%@",Value];
                
                Value = [pDictAccout tztObjectForKey:@"nsPassword"];
                accountInfo.nsPassword = [NSString stringWithFormat:@"%@",Value];
                
                Value  = [pDictAccout tztObjectForKey:@"nNeedComPwd"];
                accountInfo.nNeedComPwd = [Value intValue];
                
                [g_ZJAccountArray addObject:accountInfo];
                DelObject(accountInfo);
            }
        }
    }
    return 0;
}

//+++读写手动输入账号列表
+(NSInteger) SaveAddLoadJYAccountList:(BOOL)bSave ayList:(NSMutableArray*)ayList
{
    if (ayList == NULL || [ayList count] <= 0)
        return 0;
    [tztUserData getShareClass];
    
    ayList = GetArrayByListName(@"tztTradeAccountInfo");
//    NSMutableArray *pArray = GetArrayByListName(@"tztTradeAccountInfo");
    //读取保存的用户信息
    if (!bSave)
    {
        return [ayList count];
    }
    else//保存用户信息
    {
        SetArrayByListName(ayList, @"tztTradeAccountInfo");
        return [ayList count];
    }
}
@end
