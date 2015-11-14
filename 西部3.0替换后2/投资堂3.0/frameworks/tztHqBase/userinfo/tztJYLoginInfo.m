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

#import "TZTJYLoginInfo.h"
#import "TZTUserInfoDeal.h"


NSString*    g_GgtRights = @"";
NSString*    g_GgtRightEndDate = @"";

#define TZTAccountType  @"TZTAccountType"
#define TZTAccount      @"TZTAccount"
#define TZTCellName     @"TZTCellName"
#define TZTCellIndex    @"TZTCellIndex"
#define TZTComPass      @"TZTComPass"
#define TZTComPassType  @"TZTComPassType"
#define TZTAccountName  @"TZTAccountName"
#define TZTAutoLogin    @"TZTAutoLogin"
#define TZTGgtRights    @"TZTGgtRights"
#define TZTGgtRightsEndDate    @"TZTGgtRightsEndDate"
#define TZTLogVolume    @"TZTLogVolume"

NSMutableArray* g_ayJYLoginInfo = NULL;//交易登录账号列表
NSInteger g_ayJYLoginIndex[TZTMaxAccountType];//交易登录账号序号

extern NSMutableArray  *g_ZJAccountArray;
extern NSInteger        g_ZjAccountArrayNum;
extern tztUserData*     g_CurUserData;
//当前使用的账号信息，多账号时记录
tztJYLoginInfo   *g_pCurJYLoginInfo = NULL;
NSString         *g_tztSysNodeID = NULL;

@implementation tztZJAccountInfo
@synthesize nsAccount = _nsAccount;
@synthesize nsPassword = _nsPassword;
@synthesize nsCellName = _nsCellName;
@synthesize nsCellIndex = _nsCellIndex;
@synthesize nsCustomID = _nsCustomID;
@synthesize nsAccountType = _nsAccountType;
@synthesize nNeedComPwd = _nNeedComPwd;
@synthesize nsComPwd = _nsComPwd;
@synthesize nsAccountName = _nsAccountName;
@synthesize nAutoLogin = _nAutoLogin;
@synthesize Ggt_rights = _Ggt_rights;
@synthesize Ggt_rightsEndDate = _Ggt_rightsEndDate;
@synthesize nLogVolume = _nLogVolume;
-(id)init
{
    if (self = [super init])
    {
        _nsAccountType = @"";
        _nsAccount = @"";
        _nsPassword = @"";
        _nsCellName = @"";
        _nsCellIndex = @"";
        _nsCustomID = @"";
        _nsComPwd = @"";
        _nNeedComPwd = 0;
        _nAutoLogin = 0;
        _nsAccountName = @"";
        self.Ggt_rights = @"";
        self.Ggt_rightsEndDate = @"";
        _nLogVolume = 0;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}


-(void)SetZJAccountInfo:(tztZJAccountInfo*)pAccount
{
    if (pAccount == NULL)
    {
        _nsAccountType = @"";
        _nsAccount = @"";
        _nsPassword = @"";
        _nsCellName = @"";
        _nsCellIndex = @"";
        _nsCustomID = @"";
        _nsComPwd = @"";
        _nNeedComPwd = 0;
        _nAutoLogin = 0;
        _nsAccountName = @"";
        self.Ggt_rights = @"";
        self.Ggt_rightsEndDate = @"";
        _nLogVolume = 0;
        return;
    }
    if (pAccount.nsAccount)
        self.nsAccount = [NSString stringWithFormat:@"%@", pAccount.nsAccount];
    if (pAccount.nsAccountType)
        self.nsAccountType = [NSString stringWithFormat:@"%@", pAccount.nsAccountType];
    if (pAccount.nsCellIndex)
        self.nsCellIndex = [NSString stringWithFormat:@"%@", pAccount.nsCellIndex];
    if (pAccount.nsCellName)
        self.nsCellName = [NSString stringWithFormat:@"%@", pAccount.nsCellName];
    if (pAccount.nsCustomID)
        self.nsCustomID = [NSString stringWithFormat:@"%@", pAccount.nsCustomID];
    if (pAccount.nsPassword)
        self.nsPassword = [NSString stringWithFormat:@"%@", pAccount.nsPassword];
    if (pAccount.nsComPwd)
        self.nsComPwd = [NSString stringWithFormat:@"%@", pAccount.nsComPwd];
    if (pAccount.nsAccountName)
        self.nsAccountName = [NSString stringWithFormat:@"%@", pAccount.nsAccountName];
    if (pAccount.Ggt_rights)
        self.Ggt_rights = [NSString stringWithFormat:@"%@",pAccount.Ggt_rights];
    if (pAccount.Ggt_rightsEndDate)
        self.Ggt_rightsEndDate = [NSString stringWithFormat:@"%@",pAccount.Ggt_rightsEndDate];
    _nLogVolume = pAccount.nLogVolume;
    _nNeedComPwd = pAccount.nNeedComPwd;
    _nAutoLogin = pAccount.nAutoLogin;
}

-(void)SaveCurrentData:(NSInteger)nLoginType
{
    [self SaveCurrentData:nLoginType withFileName_:@"tztRecentAccountEx"];
}

-(void)SaveCurrentData:(NSInteger)nLoginType withFileName_:(NSString *)nsFileName
{
    if (!ISNSStringValid(nsFileName))
        return;
    
    NSString* strPath = GetPathWithListName(nsFileName,TRUE);
    
    //先获取文件中保存的数据
    NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithContentsOfFile:strPath];
    
    if (pDict == NULL)
        pDict = NewObjectAutoD(NSMutableDictionary);
    
    NSMutableDictionary* pAccountDict = NewObject(NSMutableDictionary);
    NSString* strEncpty = base64StringFromText(_nsAccountType);
    if (strEncpty == NULL)
        strEncpty = _nsAccountType;
    [pAccountDict setTztValue:strEncpty forKey:TZTAccountType];
    
    strEncpty = base64StringFromText(_nsAccount);
    if (strEncpty == NULL)
        strEncpty = _nsAccount;
    [pAccountDict setTztValue:strEncpty forKey:TZTAccount];
    
    strEncpty = base64StringFromText(_nsCellName);
    if (strEncpty == NULL)
        strEncpty = _nsCellName;
    [pAccountDict setTztValue:strEncpty forKey:TZTCellName];
    
    strEncpty = base64StringFromText(_nsCellIndex);
    if (strEncpty == NULL)
        strEncpty = _nsCellIndex;
    [pAccountDict setTztValue:strEncpty forKey:TZTCellIndex];
    
    strEncpty = base64StringFromText([NSString stringWithFormat:@"%ld", (long)_nNeedComPwd]);
    if (strEncpty == NULL)
        strEncpty = [NSString stringWithFormat:@"%ld", (long)_nNeedComPwd];
    [pAccountDict setTztValue:strEncpty forKey:TZTComPassType];
    
    strEncpty = base64StringFromText([NSString stringWithFormat:@"%ld",(long)_nAutoLogin]);
    if (strEncpty == NULL)
        strEncpty = [NSString stringWithFormat:@"%ld", (long)_nAutoLogin];
    [pAccountDict setTztObject:strEncpty forKey:TZTAutoLogin];
    
    strEncpty = base64StringFromText(_nsComPwd);
    if (strEncpty == NULL)
        strEncpty = _nsComPwd;
    [pAccountDict setTztValue:strEncpty forKey:TZTComPass];
    
    strEncpty = base64StringFromText([NSString stringWithFormat:@"%@", _nsAccountName]);
    if (strEncpty == NULL)
        strEncpty = [NSString stringWithFormat:@"%@", _nsAccountName];
    [pAccountDict setTztValue:strEncpty forKey:TZTAccountName];
    
    strEncpty = base64StringFromText([NSString stringWithFormat:@"%@", _Ggt_rights]);
    if (strEncpty == NULL)
        strEncpty = [NSString stringWithFormat:@"%@",_Ggt_rights];
    [pAccountDict setTztValue:strEncpty forKey:TZTGgtRights];
    
    strEncpty = base64StringFromText([NSString stringWithFormat:@"%@", _Ggt_rightsEndDate]);
    if (strEncpty == NULL)
        strEncpty = [NSString stringWithFormat:@"%@",_Ggt_rightsEndDate];
    [pAccountDict setTztValue:strEncpty forKey:TZTGgtRightsEndDate];
    
    strEncpty = base64StringFromText([NSString stringWithFormat:@"%ld",(long)_nLogVolume]);
    if (strEncpty == NULL)
        strEncpty = [NSString stringWithFormat:@"%ld",(long)_nLogVolume];
    [pAccountDict setTztValue:strEncpty forKey:TZTLogVolume];
    
    if (nLoginType == TZTAccountPTType)
    {
        [pDict setTztObject:pAccountDict forKey:@"TZTAccountPTType"];
    }
    else if(nLoginType == TZTAccountRZRQType)
    {
        [pDict setTztObject:pAccountDict forKey:@"TZTAccountRZRQType"];
    }
    else if(nLoginType == TZTAccountHKType)
    {
        [pDict setTztObject:pAccountDict forKey:@"TZTAccountHKType"];
    }
    else if(nLoginType == TZTAccountQHType)
    {
        [pDict setTztObject:pAccountDict forKey:@"TZTAccountQHType"];
    }
    else if (nLoginType == TZTAccountCommLoginType)
    {
        [pDict setTztObject:pAccountDict forKey:@"TZTAccountCommLoginType"];
    }
    [pDict writeToFile:strPath atomically:YES];
    DelObject(pAccountDict);
}

-(void)ClearLastSaveData:(NSInteger)nLoginType
{
    [self ClearLastSaveData:nLoginType withFileName_:@"tztRecentAccountEx"];
}

-(void)ClearLastSaveData:(NSInteger)nLoginType withFileName_:(NSString *)nsFileName
{
    if (!ISNSStringValid(nsFileName))
        return;
    NSString* strPath = GetPathWithListName(nsFileName,TRUE);
    
    //先获取文件中保存的数据
    NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithContentsOfFile:strPath];
    
    if (pDict == NULL)
        pDict = NewObjectAutoD(NSMutableDictionary);
    [pDict removeAllObjects];
    [pDict writeToFile:strPath atomically:YES];
}


-(void)ReadLastSaveData:(NSInteger)nLoginType
{
    [self ReadLastSaveData:nLoginType withFileName_:@"tztRecentAccountEx"];
}

-(void)ReadLastSaveData:(NSInteger)nLoginType withFileName_:(NSString *)nsFileName
{
    /*新的版本，使用加密*/
    NSString *strNew = GetPathWithListName(nsFileName, TRUE);
    NSMutableDictionary *pNewDict = [NSMutableDictionary dictionaryWithContentsOfFile:strNew];
    NSMutableDictionary* pAccountDict = NULL;
    if (nLoginType == TZTAccountPTType)
    {
        pAccountDict = [pNewDict tztObjectForKey:@"TZTAccountPTType"];
    }
    else if(nLoginType == TZTAccountRZRQType)
    {
        pAccountDict = [pNewDict tztObjectForKey:@"TZTAccountRZRQType"];
    }
    else if(nLoginType == TZTAccountHKType)
    {
        pAccountDict = [pNewDict tztObjectForKey:@"TZTAccountHKType"];
    }
    else if(nLoginType == TZTAccountQHType)
    {
        pAccountDict = [pNewDict tztObjectForKey:@"TZTAccountQHType"];
    }
    else if(nLoginType == TZTAccountCommLoginType)
    {
        pAccountDict = [pNewDict tztObjectForKey:@"TZTAccountCommLoginType"];
    }
    
    if (pAccountDict == NULL)//新版本中没有，则查找老的文件
    {
        
        NSString* strPath = GetPathWithListName(@"tztRecentAccount",TRUE);
        
        //先获取文件中保存的数据
        NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithContentsOfFile:strPath];
        NSMutableDictionary* pAccountDict = NULL;
        if (nLoginType == TZTAccountPTType)
        {
            pAccountDict = [pDict tztObjectForKey:@"TZTAccountPTType"];
        }
        else if(nLoginType == TZTAccountRZRQType)
        {
            pAccountDict = [pDict tztObjectForKey:@"TZTAccountRZRQType"];
        }
        else if(nLoginType == TZTAccountHKType)
        {
            pAccountDict = [pDict tztObjectForKey:@"TZTAccountHKType"];
        }
        else if(nLoginType == TZTAccountQHType)
        {
            pAccountDict = [pDict tztObjectForKey:@"TZTAccountQHType"];
        }
        else if(nLoginType == TZTAccountCommLoginType)
        {
            pAccountDict = [pDict tztObjectForKey:@"TZTAccountCommLoginType"];
        }
        
        if (pAccountDict == NULL)//获取老版本信息
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
                        if (strKey && [strKey compare:@"AccountJY"] == NSOrderedSame)
                        {
                            if (strValue)
                                self.nsAccount = [NSString stringWithFormat:@"%@", strValue];
                        }
                        if (strKey && [strKey compare:@"AccountComPwJY"] == NSOrderedSame)
                        {
                            if (strValue)
                                self.nsComPwd = [NSString stringWithFormat:@"%@", strValue];
                            
                        }
                        if (strKey && [strKey compare:@"dtPasswdOrNot"] == NSOrderedSame)
                        {
                            if (strValue)
                                self.nNeedComPwd = [strValue intValue] + 1;
                        }
                    }
                    
                    [self SaveCurrentData:TZTAccountPTType withFileName_:nsFileName];
                    return;
                }
            }
            
        }
        
        NSString* strAccountType = [pAccountDict tztValueForKey:TZTAccountType];
        if (strAccountType == NULL || strAccountType.length <= 0)
            _nsAccountType = @"";
        else
            self.nsAccountType = [NSString stringWithFormat:@"%@", strAccountType];
        
        NSString* strAccount = [pAccountDict tztValueForKey:TZTAccount];
        if (strAccount == NULL || strAccount.length <= 0)
            _nsAccount = @"";
        else
            self.nsAccount = [NSString stringWithFormat:@"%@", strAccount];
            
        NSString* strCellIndex = [pAccountDict tztValueForKey:TZTCellIndex];
        if (strCellIndex == NULL || strCellIndex.length <= 0)
            _nsCellIndex = @"";
        else
            self.nsCellIndex = [NSString stringWithFormat:@"%@", strCellIndex];
        
        NSString* strCellName = [pAccountDict tztValueForKey:TZTCellName];
        if (strCellName == NULL || strCellName.length <= 0)
            _nsCellName = @"";
        else
            self.nsCellName = [NSString stringWithFormat:@"%@", strCellName];
        
        NSString* strComPass = [pAccountDict tztValueForKey:TZTComPass];
        if (strComPass == NULL || strComPass.length <= 0)
            _nsComPwd = @"";
        else
            self.nsComPwd = [NSString stringWithFormat:@"%@", strComPass];
        
        NSString* strAccountName = [pAccountDict tztValueForKey:TZTAccountName];
        if (strAccountName == NULL || strAccountName.length <= 0)
            _nsAccountName = @"";
        else
            self.nsAccountName = [NSString stringWithFormat:@"%@", strAccountName];
        
        NSString* strComPassTye = [pAccountDict tztValueForKey:TZTComPassType];
        if (strComPassTye == NULL || strComPassTye.length <= 0)
            self.nNeedComPwd = 0;
        else
            self.nNeedComPwd = [strComPassTye intValue];
        
        NSString* strGgtRights = [pAccountDict tztValueForKey:TZTGgtRights];
        if (strGgtRights == NULL || strGgtRights.length <= 0)
            _Ggt_rights = @"";
        else
            _Ggt_rights = [NSString stringWithFormat:@"%@", strGgtRights];
        
        NSString* strGgtRightsEndDate = [pAccountDict tztValueForKey:TZTGgtRightsEndDate];
        if (strGgtRightsEndDate == NULL || strGgtRightsEndDate.length <= 0)
            _Ggt_rightsEndDate = @"";
        else
            _Ggt_rightsEndDate = [NSString stringWithFormat:@"%@", strGgtRightsEndDate];
        
        NSString* strLogVolume = [pAccountDict tztValueForKey:TZTLogVolume];
        if (strLogVolume == NULL || strLogVolume.length <= 0)
            self.nLogVolume = 0;
        else
            self.nLogVolume = [strLogVolume intValue];
        
        NSString* strAutoLogin = [pAccountDict tztValueForKey:TZTAutoLogin];
        if (strAutoLogin == NULL || strAutoLogin.length <= 0)
            self.nAutoLogin = 0;
        else
            self.nAutoLogin = [strAutoLogin intValue];
        
        //保存到另外一个文件中
        [self SaveCurrentData:nLoginType withFileName_:nsFileName];
        [strPath tztfiledelete];
    }
    else//读取自身
    {
        NSString* strAccountType = [pAccountDict tztValueForKey:TZTAccountType];
        strAccountType = textFromBase64String(strAccountType);
        if (strAccountType == NULL || strAccountType.length <= 0)
            _nsAccountType = @"";
        else
            self.nsAccountType = [NSString stringWithFormat:@"%@", strAccountType];
        
        NSString* strAccount = [pAccountDict tztValueForKey:TZTAccount];
        strAccount = textFromBase64String(strAccount);
        if (strAccount == NULL || strAccount.length <= 0)
            _nsAccount = @"";
        else
            self.nsAccount = [NSString stringWithFormat:@"%@", strAccount];
        
        NSString* strCellIndex = [pAccountDict tztValueForKey:TZTCellIndex];
        strCellIndex = textFromBase64String(strCellIndex);
        if (strCellIndex == NULL || strCellIndex.length <= 0)
            _nsCellIndex = @"";
        else
            self.nsCellIndex = [NSString stringWithFormat:@"%@", strCellIndex];
        
        NSString* strCellName = [pAccountDict tztValueForKey:TZTCellName];
        strCellName = textFromBase64String(strCellName);
        if (strCellName == NULL || strCellName.length <= 0)
            _nsCellName = @"";
        else
            self.nsCellName = [NSString stringWithFormat:@"%@", strCellName];
        
        NSString* strComPass = [pAccountDict tztValueForKey:TZTComPass];
        strComPass = textFromBase64String(strComPass);
        if (strComPass == NULL || strComPass.length <= 0)
            _nsComPwd = @"";
        else
            self.nsComPwd = [NSString stringWithFormat:@"%@", strComPass];
        
        NSString* strAccountName = [pAccountDict tztValueForKey:TZTAccountName];
        strAccountName = textFromBase64String(strAccountName);
        if (strAccountName == NULL || strAccountName.length <= 0)
            _nsAccountName = @"";
        else
            self.nsAccountName = [NSString stringWithFormat:@"%@", strAccountName];
        
        NSString* strComPassTye = [pAccountDict tztValueForKey:TZTComPassType];
        strComPassTye = textFromBase64String(strComPassTye);
        if (strComPassTye == NULL || strComPassTye.length <= 0)
            self.nNeedComPwd = 0;
        else
            self.nNeedComPwd = [strComPassTye intValue];
        
        NSString* strAutoLogin = [pAccountDict tztValueForKey:TZTAutoLogin];
        if (strAutoLogin == NULL || strAutoLogin.length <= 0)
            self.nAutoLogin = 0;
        else
            self.nAutoLogin = [strAutoLogin intValue];
        
        NSString* strGgtRights = [pAccountDict tztValueForKey:TZTGgtRights];
        strGgtRights = textFromBase64String(strGgtRights);
        if (strGgtRights == NULL || strGgtRights.length <= 0)
            self.Ggt_rights = @"";
        else
            self.Ggt_rights = [NSString stringWithFormat:@"%@", strGgtRights];
        
        
        NSString* strGgtRightsEndDate = [pAccountDict tztValueForKey:TZTGgtRightsEndDate];
        strGgtRightsEndDate = textFromBase64String(strGgtRightsEndDate);
        if (strGgtRightsEndDate == NULL || strGgtRightsEndDate.length <= 0)
            self.Ggt_rightsEndDate = @"";
        else
            self.Ggt_rightsEndDate = [NSString stringWithFormat:@"%@", strGgtRightsEndDate];
        
        NSString* strLogVolume = [pAccountDict tztValueForKey:TZTLogVolume];
        strLogVolume = textFromBase64String(strLogVolume);
        if (strLogVolume == NULL || strLogVolume.length <= 0)
            self.nLogVolume = 0;
        else
            self.nLogVolume = [strLogVolume intValue];
    }
    
}

+(tztZJAccountInfo*) GetCurAccount
{
	if(g_ZJAccountArray == NULL || g_AccountIndex < 0 || g_AccountIndex >= [g_ZJAccountArray count])
		return NULL;
	
	tztZJAccountInfo* pCurZJ = [g_ZJAccountArray objectAtIndex:g_AccountIndex];
	if(pCurZJ == NULL || pCurZJ.nsAccount == NULL || [pCurZJ.nsAccount length] <= 0)
	{
		return NULL;
	}
	return pCurZJ;
}

//删除账号
-(void)DeLAccount:(NSString*)nsAccount
{
    [self DeLAccount:nsAccount withFileName_:@"tztAccountData"];
}

-(void)DeLAccount:(NSString *)nsAccount withFileName_:(NSString *)nsFileName
{
    if (nsAccount == NULL || [nsAccount length] < 1)
        return;
    
    //保存账号的数组
    NSMutableArray* pAyAccount = NewObject(NSMutableArray);
    [pAyAccount removeAllObjects];
    
    NSString* strPath = GetPathWithListName(nsFileName, TRUE);
    //先获取文件中保存的数据
    NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithContentsOfFile:strPath];
    if (pDict)
    {
        NSMutableArray* pAyTemp = [pDict tztValueForKey:@"Grid"];
        if (pAyTemp != NULL)
        {
            //            [pAyAccount setArray:pAyTemp];
            for (int i = 0; i < [pAyTemp count]; ++i)
            {
                NSMutableDictionary* pDict = [pAyTemp objectAtIndex:i];
                if (pDict == NULL)
                    continue;
                
                //判断当前存的数据中,已经有了此账号的信息,则不在写入
                NSString* strAccount = [pDict tztObjectForKey:@"TZTAccount"];
                NSString* str = textFromBase64String(strAccount);
                if (str == NULL)
                    str = strAccount;
                if (str != NULL && [str compare:nsAccount] == NSOrderedSame)
                    continue;
                
                [pAyAccount addObject:pDict];
            }
            
        }
    }
    
    [pDict setTztObject:pAyAccount forKey:@"Grid"];
    
    
    tztZJAccountInfo *pLastZJAccount = NewObject(tztZJAccountInfo);
    [pLastZJAccount ReadLastSaveData:TZTAccountPTType];
    BOOL bLast = FALSE;
    
    
    NSMutableDictionary *pDictLast = [pDict tztValueForKey:@"TZTAccountCommLoginType"];
    if (pDictLast)
    {
        NSString *nsLast = [pDictLast tztObjectForKey:@"TZTAccount"];
        NSString* strLast = textFromBase64String(nsLast);
        if (strLast && [strLast caseInsensitiveCompare:nsAccount] == NSOrderedSame)
        {
            bLast = TRUE;
        }
    }
    
//    if (pLastZJAccount.nsAccount && [pLastZJAccount.nsAccount caseInsensitiveCompare:nsAccount] == NSOrderedSame)
//        bLast = TRUE;
    
    if ([pAyAccount count] < 1 || bLast)
    {
        [self ClearLastSaveData:TZTAccountPTType];
        [pDictLast removeAllObjects];
        [pDict setTztObject:pDictLast forKey:@"TZTAccountCommLoginType"];
    }
    [pDict writeToFile:strPath atomically:YES];
    DelObject(pAyAccount);
}

//保存账号,可能有多个账号
-(void)SaveAccountInfo
{
    [self SaveAccountInfo:@"tztAccountData"];
}

-(void)SaveAccountInfo:(NSString *)nsFileName
{
    if (!ISNSStringValid(nsFileName))
        return;
    NSString* strPath = GetPathWithListName(nsFileName, TRUE);
    
    //保存账号的数组
    NSMutableArray* pAyAccount = NewObject(NSMutableArray);
    [pAyAccount removeAllObjects];
    
    //先获取文件中保存的数据
    NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithContentsOfFile:strPath];
    //有数据时候
    if (pDict)
    {
        NSMutableArray* pAyTemp = [pDict tztValueForKey:@"Grid"];
        if (pAyTemp != NULL)
        {
            //            [pAyAccount setArray:pAyTemp];
            for (int i = 0; i < [pAyTemp count]; ++i)
            {
                NSMutableDictionary* pDict = [pAyTemp objectAtIndex:i];
                if (pDict == NULL)
                    continue;
                
                //判断当前存的数据中,已经有了此账号的信息,则不在写入
                NSString* strAccount = [pDict tztObjectForKey:TZTAccount];
                NSString *str = textFromBase64String(strAccount);
                BOOL bEncrypt = TRUE;
                if (str == NULL)
                {
                    bEncrypt = FALSE;//没加密，需要重新处理
                    str = strAccount;
                }
                if (str != NULL && [str compare:_nsAccount] == NSOrderedSame)
                    continue;
                
                if (!bEncrypt)
                {
                    NSString* nsAccount = [pDict tztObjectForKey:TZTAccount];
                    NSString* nsAccountType = [pDict tztObjectForKey:TZTAccountType];
                    NSString* nsCellName = [pDict tztObjectForKey:TZTCellName];
                    NSString* nsCellIndex = [pDict tztObjectForKey:TZTCellIndex];
                    NSString* nsCompass = [pDict tztObjectForKey:TZTComPass];
                    NSString* nsAccountName = [pDict tztObjectForKey:TZTAccountName];
                    NSString* nsCompassType = [pDict tztObjectForKey:TZTComPassType];
                    NSString* nsAutoLogin = [pDict tztObjectForKey:TZTAutoLogin];
                    NSString* nsGgtRights = [pDict tztObjectForKey:TZTGgtRights];
                    NSString* nsGgtRightsEndDate = [pDict tztObjectForKey:TZTGgtRightsEndDate];
                    
                    NSString* strEncpty = base64StringFromText(nsAccount);
                    if (strEncpty == NULL)
                        strEncpty = nsAccount;
                    [pDict setTztObject:strEncpty forKey:TZTAccount];
                    
                    strEncpty = base64StringFromText(nsAccountType);
                    if (strEncpty == NULL)
                        strEncpty = nsAccountType;
                    [pDict setTztObject:strEncpty forKey:TZTAccountType];
                    
                    strEncpty = base64StringFromText(nsCellName);
                    if (strEncpty == NULL)
                        strEncpty = nsCellName;
                    [pDict setTztObject:strEncpty forKey:TZTCellName];
                    
                    strEncpty = base64StringFromText(nsCellIndex);
                    if (strEncpty == NULL)
                        strEncpty = nsCellIndex;
                    [pDict setTztObject:strEncpty forKey:TZTCellIndex];
                    
                    strEncpty = base64StringFromText(nsCompass);
                    if (strEncpty == NULL)
                        strEncpty = nsCompass;
                    [pDict setTztObject:strEncpty forKey:TZTComPass];
                    
                    strEncpty = base64StringFromText(nsAccountName);
                    if (strEncpty == NULL)
                        strEncpty = nsAccountName;
                    [pDict setTztObject:strEncpty forKey:TZTAccountName];
                    
                    strEncpty = base64StringFromText(nsCompassType);
                    if (strEncpty == NULL)
                        strEncpty = nsCompassType;
                    [pDict setTztObject:strEncpty forKey:TZTComPassType];
                    
                    strEncpty = base64StringFromText(nsAutoLogin);
                    if (strEncpty == NULL)
                        strEncpty = nsAutoLogin;
                    [pDict setTztObject:strEncpty forKey:TZTAutoLogin];
                    
                    strEncpty = base64StringFromText(nsGgtRights);
                    if (strEncpty == NULL)
                        strEncpty = nsGgtRights;
                    [pDict setTztObject:strEncpty forKey:TZTGgtRights];
                    
                    strEncpty = base64StringFromText(nsGgtRightsEndDate);
                    if (strEncpty == NULL)
                        strEncpty = nsGgtRightsEndDate;
                    [pDict setTztObject:strEncpty forKey:TZTGgtRightsEndDate];
                }
                [pAyAccount addObject:pDict];
            }
            
        }
    }
    
    if (pDict == NULL)
        pDict = NewObjectAutoD(NSMutableDictionary);
    
    NSMutableDictionary* pAccountDict = NewObject(NSMutableDictionary);
    
    NSString* strEncpryType = base64StringFromText(_nsAccountType);
    [pAccountDict setTztValue:strEncpryType forKey:TZTAccountType];
    
    strEncpryType = base64StringFromText(_nsAccount);
    [pAccountDict setTztValue:strEncpryType forKey:TZTAccount];
    
    strEncpryType = base64StringFromText(_nsCellName);
    [pAccountDict setTztValue:strEncpryType forKey:TZTCellName];
    
    strEncpryType = base64StringFromText(_nsCellIndex);
    [pAccountDict setTztValue:strEncpryType forKey:TZTCellIndex];
    
    strEncpryType = base64StringFromText(_nsComPwd);
    [pAccountDict setTztValue:strEncpryType forKey:TZTComPass];
    
    strEncpryType = base64StringFromText(_nsAccountName);
    [pAccountDict setTztValue:strEncpryType forKey:TZTAccountName];
    
    strEncpryType = base64StringFromText([NSString stringWithFormat:@"%ld", (long)_nNeedComPwd]);
    [pAccountDict setTztValue:strEncpryType forKey:TZTComPassType];
    
    strEncpryType = base64StringFromText([NSString stringWithFormat:@"%ld", (long)_nAutoLogin]);
    [pAccountDict setTztValue:strEncpryType forKey:TZTAutoLogin];
    
    strEncpryType = base64StringFromText(_Ggt_rights);
    [pAccountDict setTztValue:strEncpryType forKey:TZTGgtRights];
    
    strEncpryType = base64StringFromText(_Ggt_rightsEndDate);
    [pAccountDict setTztValue:strEncpryType forKey:TZTGgtRightsEndDate];
    
    strEncpryType = base64StringFromText([NSString stringWithFormat:@"%ld", (long)_nLogVolume]);
    [pAccountDict setTztValue:strEncpryType forKey:TZTLogVolume];
    
    [pAyAccount addObject:pAccountDict];
    
    [pDict setTztObject:pAyAccount forKey:@"Grid"];
    
    [pDict writeToFile:strPath atomically:YES];
    DelObject(pAccountDict);
    DelObject(pAyAccount);
}

//读取保存的账号数据
+(void)ReadAccountInfo
{
    if (g_ZJAccountArray == NULL)
        g_ZJAccountArray = NewObject(NSMutableArray);
    [g_ZJAccountArray removeAllObjects];
    g_ZjAccountArrayNum = 0;
    [tztZJAccountInfo ReadAccountInfo:@"tztAccountData" withAy_:g_ZJAccountArray];

    g_ZjAccountArrayNum = [g_ZJAccountArray  count];
}

+(void)ReadAccountInfo:(NSString*)nsFileName withAy_:(NSMutableArray*)ayReturn
{
    if (!ISNSStringValid(nsFileName))
        return;
    
    if (ayReturn == NULL)
        ayReturn = NewObject(NSMutableArray);
    [ayReturn removeAllObjects];
        
    NSString* strPath = GetPathWithListName(nsFileName,TRUE);
    //先获取文件中保存的数据
    NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithContentsOfFile:strPath];
    if (pDict == NULL)//获取老版本信息
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
                    if (strKey && [strKey compare:@"JYAccountList"] == NSOrderedSame)
                    {
                        NSArray* ayValue = [strValue componentsSeparatedByString:@"&"];
                        NSMutableArray *pAyAccount = NewObject(NSMutableArray);
                        for (int j = 0; j < [ayValue count]; j++)
                        {
                            NSString* strSubValue = [ayValue objectAtIndex:j];
                            if (strSubValue == NULL || strSubValue.length < 1)
                                continue;
                            
                            NSArray* aySub = [strSubValue componentsSeparatedByString:@"|"];
                            if (aySub == NULL || aySub.count < 1)
                                continue;
                            
                            NSString* nsAccount = [aySub objectAtIndex:0];
                            if (nsAccount == NULL || nsAccount.length < 1)
                                continue;
                            NSString* nsComPass = @"";
                            NSString* nsType = @"";
                            if ([aySub count] > 1)
                                nsComPass = [aySub objectAtIndex:1];
                            if ([aySub count] > 2)
                                nsType = [aySub objectAtIndex:2];
                            
                            NSMutableDictionary *pAccountDict = NewObject(NSMutableDictionary);
                            
                            NSString* strEncpty = base64StringFromText(nsAccount);
                            [pAccountDict setTztValue:strEncpty forKey:TZTAccount];
                            
                            [pAccountDict setTztValue:@"" forKey:TZTAccountType];
                            
                            strEncpty = base64StringFromText(nsComPass);
                            [pAccountDict setTztValue:strEncpty forKey:TZTComPass];
                            
                            strEncpty = base64StringFromText(nsType);
                            [pAccountDict setTztValue:strEncpty forKey:TZTComPassType];
                            
                            [pAyAccount addObject:pAccountDict];
                            DelObject(pAccountDict);
                        }
                        
                        if ([pAyAccount count] > 0)
                        {
                            if (pDict == NULL)
                                pDict = NewObjectAutoD(NSMutableDictionary);
                            [pDict setTztObject:pAyAccount forKey:@"Grid"];
                        }
                        
                        break;
                    }
                }
                
                [pDict writeToFile:strPath atomically:YES];
            }
        }
        
    }
    
    //文件中已经有数据
    if (pDict)
    {
        NSMutableArray* pAySave = [pDict tztObjectForKey:@"Grid"];
        if (pAySave == NULL || [pAySave count] < 1)
            return;
        for (int i = 0; i < [pAySave count]; ++i)
        {
            NSMutableDictionary* pDictTemp = [pAySave objectAtIndex:i];
            if (pDictTemp == NULL || [pDictTemp count] < 1)
                continue;
            
            tztZJAccountInfo *pZJ = NewObject(tztZJAccountInfo);
            NSString* strAccount = [pDictTemp tztObjectForKey:TZTAccount];
            if (strAccount)
            {
                NSString* str = textFromBase64String(strAccount);
                if (str == NULL && strAccount.length > 0)//没加密，老数据
                    pZJ.nsAccount = [NSString stringWithFormat:@"%@", strAccount];
                else
                    pZJ.nsAccount = [NSString stringWithFormat:@"%@", str];
            }
            
            NSString* strAccountType = [pDictTemp tztObjectForKey:TZTAccountType];
            if (strAccountType)
            {
                NSString *str = textFromBase64String(strAccountType);
                if (str == NULL && strAccountType.length > 0)
                    pZJ.nsAccountType = [NSString stringWithFormat:@"%@", strAccountType];
                else
                    pZJ.nsAccountType = [NSString stringWithFormat:@"%@", str];
            }
            
            NSString* strCellIndex = [pDictTemp tztValueForKey:TZTCellIndex];
            if (strCellIndex)
            {
                NSString* str = textFromBase64String(strCellIndex);
                if (str == NULL && strCellIndex.length > 0)
                    pZJ.nsCellIndex = [NSString stringWithFormat:@"%@", strCellIndex];
                else
                    pZJ.nsCellIndex = [NSString stringWithFormat:@"%@", str];
            }
            
            NSString* strCellName = [pDictTemp tztValueForKey:TZTCellName];
            if (strCellName)
            {
                NSString* str = textFromBase64String(strCellName);
                if (str == NULL && strCellName.length > 0)
                    pZJ.nsCellName = [NSString stringWithFormat:@"%@", strCellName];
                else
                    pZJ.nsCellName = [NSString stringWithFormat:@"%@", str];
            }
            
            NSString* strComPass = [pDictTemp tztValueForKey:TZTComPass];
            if (strComPass)
            {
                NSString* str = textFromBase64String(strComPass);
                if (str == NULL && strComPass.length > 0)
                    pZJ.nsComPwd = [NSString stringWithFormat:@"%@", strComPass];
                else
                    pZJ.nsComPwd = [NSString stringWithFormat:@"%@", str];
            }
            
            NSString* strAccountName = [pDictTemp tztValueForKey:TZTAccountName];
            if (strAccountName)
            {
                NSString* str = textFromBase64String(strAccountName);
                if (str == NULL && strAccountName.length > 0)
                    pZJ.nsAccountName = [NSString stringWithFormat:@"%@", strAccountName];
                else
                    pZJ.nsAccountName = [NSString stringWithFormat:@"%@", str];
            }
            
            NSString* strComPassType = [pDictTemp tztValueForKey:TZTComPassType];
            if (strComPassType)
            {
                NSString* str = textFromBase64String(strComPassType);
                if (str == NULL && strComPassType.length > 0)
                    pZJ.nNeedComPwd = [strComPassType intValue];
                else
                    pZJ.nNeedComPwd = [str intValue];
            }
            
            NSString* strAutoLogin = [pDictTemp tztValueForKey:TZTAutoLogin];
            if (strAccount)
            {
                NSString* str = textFromBase64String(strAutoLogin);
                if (str == NULL && strAutoLogin.length > 0)
                    pZJ.nAutoLogin = [strAutoLogin intValue];
                else
                    pZJ.nAutoLogin = [str intValue];
            }
            
            NSString *strGgtRights = [pDictTemp tztValueForKey:TZTGgtRights];
            if (strGgtRights)
            {
                NSString* str = textFromBase64String(strGgtRights);
                if (str == NULL && strGgtRights.length > 0)
                    pZJ.Ggt_rights = [NSString stringWithFormat:@"%@", strGgtRights];
                else
                    pZJ.Ggt_rights = [NSString stringWithFormat:@"%@", str];
            }
            
            NSString *strGgtRightsEndDate = [pDictTemp tztValueForKey:TZTGgtRightsEndDate];
            if (strGgtRightsEndDate)
            {
                NSString* str = textFromBase64String(strGgtRightsEndDate);
                if (str == NULL && strGgtRightsEndDate.length > 0)
                    pZJ.Ggt_rightsEndDate = [NSString stringWithFormat:@"%@", strGgtRightsEndDate];
                else
                    pZJ.Ggt_rightsEndDate = [NSString stringWithFormat:@"%@", str];
            }
            
            NSString* strLogVolume = [pDictTemp tztValueForKey:TZTLogVolume];
            if (strLogVolume)
            {
                NSString* str = textFromBase64String(strLogVolume);
                if (str && strLogVolume.length > 0)
                    pZJ.nLogVolume = [strLogVolume intValue];
                else
                    pZJ.nLogVolume = [str intValue];
                    
            }
            
            [ayReturn addObject:pZJ];
            [pZJ release];
        }
        
//        g_ZjAccountArrayNum = [g_ZJAccountArray count];
    }
}

//读取账号列表信息
+(NSString *)GetWebAccountList
{
    [tztZJAccountInfo ReadAccountInfo];
    NSString* strAccount = @"";
    for (int i = 0; i < [g_ZJAccountArray count]; i++)
    {
        tztZJAccountInfo *pZJ = [g_ZJAccountArray objectAtIndex:i];
        if(strAccount.length > 0)
        {
            strAccount = [NSString stringWithFormat:@"%@|%@=%@",strAccount,pZJ.nsAccount,pZJ.nsAccountName];
        }
        else
        {
            strAccount = [NSString stringWithFormat:@"%@=%@",pZJ.nsAccount,pZJ.nsAccountName];
        }
    }
    return [NSString stringWithFormat:@"%@",strAccount];
}
@end


@implementation tztJYLoginInfo

@synthesize		bGetInfoSuc = _bGetInfoSuc;
@synthesize     nsAccount = _nsAccount;
@synthesize     nsPassword = _nsPassword;
@synthesize     nsFundAccount = _nsFundAccount;
@synthesize		ZjAccountInfo = _ZjAccountInfo;
@synthesize     nsUserCode = _nsUserCode;
@synthesize     nsKHBranch = _nsKHBranch;
@synthesize     nsUserName = _nsUserName;
@synthesize     nsManagerName = _nsManagerName;
@synthesize     nsManagerMobile = _nsManagerMobile;
@synthesize     nsLastAddr = _nsLastAddr;
@synthesize     nsLastTime = _nsLastTime;
@synthesize     nsYLXX = _nsYLXX;
@synthesize     nsLoginEcho = _nsLoginEcho;
@synthesize     nsOsKey = _nsOskey;
@synthesize     nsScore = _nsScore;
@synthesize     nsOtherInfo = _nsOtherInfo;
@synthesize     nsUserLevel = _nsUserLevel;
@synthesize		ayAccountList = _ayAccountList;
@synthesize		FundTradefxjb = _FundTradefxjb;
@synthesize     FundTradefxmc = _FundTradefxmc;
@synthesize	    pBDTranseInfo = _pBDTranseInfo;
@synthesize     pMoreAccountTranseInfo = _pMoreAccountTranseInfo;
@synthesize		tokenType = _tokenType;
@synthesize		tokenIndex = _tokenIndex;
@synthesize     otherType = _otherType;
@synthesize     bCheckFXCP = _bCheckFXCP;
@synthesize     nsRights = _nsRights;
@synthesize     haveZRTRight = _haveZRTRight;
@synthesize     nLoginType = _nLoginType;
@synthesize     dictLoginInfo = _dictLoginInfo;

-(id) init
{
    self = [super init];
    if (self != nil)
    {
        [self JYLoginInfo_];
    }
    return self;
}

-(void) dealloc
{
    [self JYLoginInfo__];
    [super dealloc];
}

-(void) JYLoginInfo_
{
	_bGetInfoSuc = FALSE; //是否已登录

    NilObject(_nsAccount); //交易账号
    NilObject(_nsPassword); //交易账号密码
    NilObject(_nsFundAccount); //资金账号
    
    NilObject(_nsUserCode); //UserCode 客户号
    NilObject(_nsKHBranch); //KHBranch 真实营业部号
    NilObject(_nsUserName); //UserName 用户名
	NilObject(_nsScore); //Score 积分信息
    NilObject(_nsUserLevel); //UserLevel  等级
    NilObject(_nsOtherInfo); //扩展信息 key0=value0|key1=value1

    NilObject(_nsManagerMobile);
    NilObject(_nsManagerName);
    NilObject(_nsLastTime);
    NilObject(_nsLastAddr);
    NilObject(_nsYLXX);
    NilObject(_nsLoginEcho);

	_ZjAccountInfo = NewObject(tztZJAccountInfo); //账号信息
    
    _FundTradefxjb = -1; //基金风险级别
	_FundTradefxmc = @""; //基金风险名称
    _nsRights = @"";
    
	_ayAccountList = NewObject(NSMutableArray);//股东账号列表
    
	_pBDTranseInfo = NewObject(tztCardBankTransform);//银证转账信息
    _pMoreAccountTranseInfo = NewObject(tztCardBankTransform);
    _ayTradeStockData = NewObject(NSMutableArray);
	
    _dictLoginInfo = NewObject(NSMutableDictionary);
    _tokenType = TZTAccountPTType;//账号类别
    _otherType = 0;
	_tokenIndex = -1;
}

-(void) JYLoginInfo__
{
	[self RemoveAllInfo];
	_bGetInfoSuc = FALSE;
}

-(void) RemoveAllInfo
{
	_bGetInfoSuc = FALSE; //是否已登录
	
    NilObject(_nsAccount); //交易账号
    NilObject(_nsPassword); //交易账号密码
    NilObject(_nsFundAccount); //资金账号
    
    NilObject(_nsUserCode); //UserCode 客户号
    NilObject(_nsKHBranch); //KHBranch 真实营业部号
    NilObject(_nsUserName); //UserName 用户名
	NilObject(_nsScore); //Score 积分信息
    NilObject(_nsUserLevel); //UserLevel  等级
    NilObject(_nsOtherInfo); //扩展信息 key0=value0|key1=value1
    
    NilObject(_nsManagerMobile);
    NilObject(_nsManagerName);
    NilObject(_nsLastTime);
    NilObject(_nsLastAddr);
    NilObject(_nsYLXX);
    NilObject(_nsLoginEcho);
    
    DelObject(_dictLoginInfo);
	DelObject(_ZjAccountInfo);//账号信息

    if (_ayAccountList) //股东账号列表
        [_ayAccountList removeAllObjects];
    DelObject(_ayAccountList);
    
    if (_ayTradeStockData)
        [_ayTradeStockData removeAllObjects];
    DelObject(_ayTradeStockData);
	
	_FundTradefxjb = -1;
	_FundTradefxmc = @"";
	
	DelObject(_pBDTranseInfo);//银证转账
    DelObject(_pMoreAccountTranseInfo);
    
    if (g_CurUserData && _tokenIndex > 0) //清空当前数据
    {
        [g_CurUserData setAccountToken:@"" tokenKind:_tokenType tokenIndex:_tokenIndex];
    }
	_tokenIndex = 0;// 通讯Token序号
	_tokenType = TZTAccountPTType;//账号类别
}

//获取可用序号
-(NSInteger)GetTokenIndex
{
	if(_tokenIndex > 0 && _tokenIndex < TZTMaxAccount)
		return _tokenIndex;
    if (g_CurUserData)
    {
        _tokenIndex = [g_CurUserData getCanUseTokenOfKind:_tokenType];
    }
    return _tokenIndex;
}

//设置账号信息
-(BOOL)SetAccountInfo:(tztZJAccountInfo*)pZJAccountInfo
{
    [_ZjAccountInfo SetZJAccountInfo:pZJAccountInfo];
    
	if(pZJAccountInfo)
	{
		self.nsAccount = [NSString stringWithFormat:@"%@",pZJAccountInfo.nsAccount];
		return TRUE;
	}
	else 
    {
		_nsAccount = @"";
	}
	return FALSE;
}

//登录成功处理 返回信息 密码 登录账号 账号登录类别
+(BOOL)SetLoginInAccount:(tztNewMSParse*) pParse Pass_:(NSString*) nsPassword AccountInfo_:(tztZJAccountInfo*)pZJAccountInfo AccountType:(NSInteger)nAccountType
{
    if(g_ayJYLoginInfo == NULL)
	{
		g_ayJYLoginInfo = [[NSMutableArray alloc] initWithCapacity:TZTMaxAccountType];
        [g_ayJYLoginInfo removeAllObjects];
        for (NSInteger i = 0; i < TZTMaxAccountType; i ++)
        {
            NSMutableArray* ayJYLoginInfo = NewObject(NSMutableArray);
            g_ayJYLoginIndex[i] = -1;
            [g_ayJYLoginInfo addObject:ayJYLoginInfo];
            [ayJYLoginInfo release];
        }
	}
    
    NSMutableArray* ayJYLoginInfo = [g_ayJYLoginInfo objectAtIndex:nAccountType];
    tztJYLoginInfo* pJyLoginInfo = NULL;
    NSInteger nLoginIndex = -1;
    //资金账号
    NSString*  strFundAccount = [pParse GetByName:@"FundAccount"];
	if(strFundAccount && [strFundAccount length] > 0)
	{
		NSInteger ngetAccontType = -1;
//        nLoginIndex = [tztJYLoginInfo GetLoginIndexOfAyJYLogin:strFundAccount forType:&ngetAccontType];
        nLoginIndex = [tztJYLoginInfo GetLoginIndexOfAyJYLoginEx:strFundAccount andLoginType:nAccountType forType:&ngetAccontType];
        if(nLoginIndex >= 0 && ngetAccontType == nAccountType)
        {
            pJyLoginInfo = [[ayJYLoginInfo objectAtIndex:nLoginIndex] retain];
        }
    }
    if(pJyLoginInfo == NULL)
    {
        pJyLoginInfo = NewObject(tztJYLoginInfo);
    }
    pJyLoginInfo.tokenType = nAccountType;
	pJyLoginInfo.nsPassword = [NSString stringWithFormat:@"%@",nsPassword];
    pJyLoginInfo.nsFundAccount = [NSString stringWithFormat:@"%@", strFundAccount];
    pJyLoginInfo.nLoginType = nAccountType;

    if (pJyLoginInfo.dictLoginInfo == NULL)
        pJyLoginInfo.dictLoginInfo = NewObject(NSMutableDictionary);
    
    [pJyLoginInfo.dictLoginInfo removeAllObjects];

	//登录设置Token
	NSString* strTemp = [pParse GetByName:@"Token"];
	if(strTemp && [strTemp length] > 0)
	{
		NSInteger nIndex = [pJyLoginInfo GetTokenIndex];
        if (g_CurUserData && nIndex >= 0 && nIndex < TZTMaxAccount)
        {
            [g_CurUserData setAccountToken:strTemp tokenKind:pJyLoginInfo.tokenType tokenIndex:pJyLoginInfo.tokenIndex];
        }
	}
	BOOL isCredit = [tztJYLoginInfo iscreditfund:pParse];
    if(isCredit)
        pJyLoginInfo.otherType = TZTAccountRZRQType; //带融资融券账号
    
    long lLoginType = 0;
    switch (nAccountType)
    {
        case TZTAccountPTType:
            lLoginType = StockTrade_Log;
            break;
        case TZTAccountRZRQType:
            lLoginType = RZRQTrade_Log;
            break;
        default:
            break;
    }
    [TZTUserInfoDeal SetTradeLogState:Trade_Login lLoginType_:lLoginType];

    //客户名称
    NSString* pValue = nil;
    //UserCode 客户号
    pValue = [pParse GetByName:@"UserCode"];
    if (pValue && [pValue length] > 0)
    {
        pJyLoginInfo.nsUserCode = [NSString stringWithFormat:@"%@", pValue];
    }
    
    //KHBranch 真实营业部号
    pValue = [pParse GetByName:@"KHBranch"];
    if (pValue && [pValue length] > 0)
    {
        pJyLoginInfo.nsKHBranch = [NSString stringWithFormat:@"%@", pValue];
    }
    // nsRights 权限
    pValue = [pParse GetByNameGBK:@"CLIENT_RIGHTS"];
    if(pValue && [pValue length] > 0)
    {
        pJyLoginInfo.nsRights = [NSString stringWithFormat:@"%@",pValue];
        pJyLoginInfo.tzttraderights=[NSString stringWithFormat:@"%@",pValue];
//        pZJAccountInfo.nsAccountName = [NSString stringWithFormat:@"%@",pValue];
    }

    //UserName 用户名
    pValue = [pParse GetByNameGBK:@"UserName"];
	if(pValue && [pValue length] > 0)
	{
		pJyLoginInfo.nsUserName = [NSString stringWithFormat:@"%@",pValue];
        pZJAccountInfo.nsAccountName = [NSString stringWithFormat:@"%@",pValue];
	}
    
    //Score 积分信息
    pValue = [pParse GetByName:@"Score"];
	if(pValue && [pValue length] > 0)
	{
		pJyLoginInfo.nsScore = [NSString stringWithFormat:@"%@",pValue];
	}
    
    
    //UserLevel 等级
    pValue = [pParse GetByName:@"UserLevel"];
	if(pValue && [pValue length] > 0)
	{
		pJyLoginInfo.nsUserLevel = [NSString stringWithFormat:@"%@",pValue];
	}
    
    //lastlogintime 最近登录时间
    pValue = [pParse GetByName:@"LastLoginTime"];
    if (pValue && [pValue length] > 0)
    {
        pJyLoginInfo.nsLastTime = [NSString stringWithFormat:@"%@", pValue];
    }
    //lastloginAddr 最近登录地址
    pValue = [pParse GetByName:@"lastnetAddr"];
    if (pValue && [pValue length] > 0)
        pJyLoginInfo.nsLastAddr = [NSString stringWithFormat:@"%@", pValue];
    
    //预留信息
    pValue = [pParse GetByName:@"YLXX"];
    if (pValue && [pValue length] > 0)
    {
        pJyLoginInfo.nsYLXX = [NSString stringWithFormat:@"%@",pValue];
    }
    
    //齐鲁预留消息回显
    pValue = [pParse GetByName:@"LoginEcho"];
    if (pValue && [pValue length] > 0)
    {
        pJyLoginInfo.nsLoginEcho = [NSString stringWithFormat:@"%@",pValue];
    }

    //华西OsKey
    pValue = [pParse GetByName:@"OsKey"];
    if (pValue && [pValue length] > 0)
    {
        pJyLoginInfo.nsOsKey = [NSString stringWithFormat:@"%@", pValue];
    }

    pValue = [pParse GetByName:@"sysnodeid"];
    if (pValue && [pValue length] > 0)
    {
        if (g_tztSysNodeID != NULL)
            DelObject(g_tztSysNodeID);
        
        g_tztSysNodeID = [[NSString alloc] initWithFormat:@"%@", pValue];
    }
    
	//设置账号信息
	[pJyLoginInfo SetAccountInfo:pZJAccountInfo];
	[pJyLoginInfo saveBankToDealerInfo:pParse];//保存银证信息
    //如果有多资金账号银行信息 请在此处加入处理函数 yangdl 20130411
    
	pJyLoginInfo.bGetInfoSuc = TRUE; //登录账号信息设置成功
    if(nLoginIndex < 0)
    {
        [ayJYLoginInfo addObject:pJyLoginInfo];
        g_ayJYLoginIndex[nAccountType] = [ayJYLoginInfo count] - 1 ; //当前序号
        nLoginIndex = [ayJYLoginInfo count] - 1;
    }
    else if(nLoginIndex >= 0 && nLoginIndex < [ayJYLoginInfo count])
    {
        g_ayJYLoginIndex[nAccountType] = nLoginIndex ; //当前序号
        [ayJYLoginInfo replaceObjectAtIndex:nLoginIndex withObject:pJyLoginInfo];
    }
    //zxl 20131128 设置当前账号
    [tztJYLoginInfo SetCurJYLoginInfo:nAccountType _nIndex:nLoginIndex];
    
    [tztJYLoginInfo SaveRectAccount:pJyLoginInfo]; //保存最近登录交易账号
    [pJyLoginInfo release];
    
	return TRUE;
}

#pragma tztNewMSParse 银证信息
//保存银证信息
-(void) saveBankToDealerInfo:(tztNewMSParse*)pInfo
{
    if (pInfo == NULL)
        return;
	
	if (self.pBDTranseInfo == NULL)
	{
		self.pBDTranseInfo = NewObjectAutoD(tztCardBankTransform);
	}
	
	tztCardBankTransform *pBDTranseInfo = self.pBDTranseInfo;
    //删除原来的信息
    [pBDTranseInfo RemoveAllInfo];
    [pBDTranseInfo SetToken:[pInfo GetToken]];
	
    BOOL bHavePWFlag = FALSE;
    NSArray *pBankAy = [pInfo GetArrayByName:@"Grid"];
    
    //索引 　zxl　20131203　　添加索引
    NSInteger nBankIndex = 0;
    NSInteger nBankNameIndex = 1;
    NSInteger nCurrencyCodeIndex = 2;
    NSInteger nCurrencyIndex = 3;
    NSInteger nFundaccountIndex = 5;
    NSInteger nPasswordIdentifyIndex = 4;
    
    NSString * strValue = [pInfo GetByName:@"bankIndex"];
    if (strValue && [strValue length] > 0)
        TZTStringToIndex(strValue, nBankIndex);
    
    strValue = [pInfo GetByName:@"banknameIndex"];
    if (strValue && [strValue length] > 0)
        TZTStringToIndex(strValue, nBankNameIndex);
    
    strValue = [pInfo GetByName:@"CurrencyCodeIndex"];
    if (strValue && [strValue length] > 0)
        TZTStringToIndex(strValue, nCurrencyCodeIndex);
    
    strValue = [pInfo GetByName:@"CurrencyIndex"];
    if (strValue && [strValue length] > 0)
        TZTStringToIndex(strValue, nCurrencyIndex);
    
    strValue = [pInfo GetByName:@"fundaccountIndex"];
    if (strValue && [strValue length] > 0)
        TZTStringToIndex(strValue, nFundaccountIndex);
    
    strValue = [pInfo GetByName:@"PasswordIdentifyIndex"];
    if (strValue && [strValue length] > 0)
        TZTStringToIndex(strValue, nPasswordIdentifyIndex);
    
    //银行编号|银行名称|币种代码|币种名称|银行账号|密码标识
    if ((!bHavePWFlag) && [pBankAy count] > 0)
    {
        NSInteger nCount = [pBankAy count];
        
        for (NSInteger i = 1; i < nCount; i++)
        {
            NSArray *pSubAy = [pBankAy objectAtIndex:i];
            
            if (pSubAy == NULL || [pSubAy count] < 4)
                continue;
            
            NSString* strItem = [pSubAy objectAtIndex:0];
            if (i == 1)
            {
                if (strItem == NULL || [strItem length] <= 0)
                    [pBDTranseInfo ReceiveBankInfoSuc:FALSE];
                else
                    [pBDTranseInfo ReceiveBankInfoSuc:TRUE];
            }
            
            NSString* strBankNo = [pSubAy objectAtIndex:nBankIndex];
            NSString* strBankName = [pSubAy objectAtIndex:nBankNameIndex];
            NSString* strMoneyNo = [pSubAy objectAtIndex:nCurrencyCodeIndex];
            NSString* strMoneyName = [pSubAy objectAtIndex:nCurrencyIndex];
            
            NSString* strPWFlag = nil;
            if ([pSubAy count] > nPasswordIdentifyIndex)
            {
                strPWFlag = [pSubAy objectAtIndex:nPasswordIdentifyIndex];
            }
            
            //银行编号，名称，密码标识
            [pBDTranseInfo AddBank:strBankName sBankNo_:strBankNo BankPW_:strPWFlag];
            //
//            bHavePWFlag = TRUE;
            //币种列表
            [pBDTranseInfo AddMoneyType:strMoneyName sMoneyNo_:strMoneyNo];
            
            //银行对应币种
            [pBDTranseInfo AddBankToMoney:strBankName strMoney_:strMoneyName];
            
            //币种对应银行
            [pBDTranseInfo AddMoneyToBank:strMoneyName strBank_:strBankName];
        }
        
        if(self.nsPassword && [self.nsPassword length] > 0)
        {
            [pBDTranseInfo SetAccountPassword:_nsPassword];
        }
    }	
}

-(void) saveMoreAccountToDealerInfo:(tztNewMSParse*)pInfo
{
    if (pInfo == NULL)
        return;
    
	if (self.pMoreAccountTranseInfo == NULL)
	{
		self.pMoreAccountTranseInfo = NewObject(tztCardBankTransform);
	}
	
	tztCardBankTransform *pBDTranseInfo = self.pMoreAccountTranseInfo;
	//删除原来的信息
    [pBDTranseInfo RemoveAllInfo];
    
    [pBDTranseInfo SetToken:[pInfo GetToken]];
	
    //填入账号及密码 使用Cmb取账号 对于单个账号使用Edit，修改时请注意
    [pBDTranseInfo SetAccount:_nsAccount];
    [pBDTranseInfo SetAccountPassword:_nsPassword];
    NSString* nsFundAccount = [pInfo GetByName:@"FundAccount"];
    if (nsFundAccount && [nsFundAccount length] > 0)
    {
        [pBDTranseInfo setFundAccount:nsFundAccount];
    }
    else
    {
        [pBDTranseInfo setFundAccount:_nsFundAccount];
    }
	//BOOL bHavePWFlag = FALSE;
	//柜台资金账号|银行代码|银行名称|币种类别编码|币种类别|
    //齐鲁证券
    /*
     <GRID0>资金账号|账号类别|币种代码|币种类别|余额|可用|三方存管银行代码|银行名称|
     15032809|B|0|人民币|82849.14|4553.51|1003|建行三方|
     53391009351|T|0|人民币|.01|.01|1006|兴业三方|
     </GRID0>
     */
	
    NSArray* pGridAy = [pInfo GetArrayByName:@"Grid"];
    if (pGridAy && [pGridAy count] > 0)
    {
        NSInteger nLineCount = [pGridAy count];
        NSInteger fundaccountIndex = 0;       //资金账号索引
        NSInteger bankIndex = 1;              //银行代码索引
        NSInteger banknameIndex = 2;          //银行名称索引
        NSInteger currencyCodeIndex = 3;      //币种代码索引
        NSInteger currencyIndex = 4;          //币种名称索引
        NSInteger passwordIndentifyIndex = -1;//密码标示
        
        NSString* nsValue = [pInfo GetByName:@"fundaccountIndex"];
        TZTStringToIndex(nsValue, fundaccountIndex);
        
        nsValue = [pInfo GetByName:@"bankIndex"];
        TZTStringToIndex(nsValue, bankIndex);
        
        nsValue = [pInfo GetByName:@"banknameIndex"];
        TZTStringToIndex(nsValue, banknameIndex);
        
        nsValue = [pInfo GetByName:@"CurrencyCodeIndex"];
        TZTStringToIndex(nsValue, currencyCodeIndex);
        
        nsValue = [pInfo GetByName:@"CurrencyIndex"];
        TZTStringToIndex(nsValue, currencyIndex);
        
        nsValue = [pInfo GetByName:@"PasswordIdentifyIndex"];
        TZTStringToIndex(nsValue, passwordIndentifyIndex);
        
        for (NSInteger i = 1; i < nLineCount; i++)
        {
            NSArray* pGrid = [pGridAy objectAtIndex:i];
            NSInteger nCount = [pGrid count];
            if (nCount < 5)
                continue;
            NSString* strPW = nil;
            if (passwordIndentifyIndex >= 0 && passwordIndentifyIndex < nCount)
            {
                strPW = [pGrid objectAtIndex:passwordIndentifyIndex];
            }
            NSString* strItem = [pGrid objectAtIndex:0];
            if (i == 1)
            {
                if (strItem == NULL || [strItem length] < 1)
                    [pBDTranseInfo ReceiveBankInfoSuc:FALSE];
                else
                    [pBDTranseInfo ReceiveBankInfoSuc:TRUE];
            }
            
            //资金账号关联银行币种
            [pBDTranseInfo AddAccount:[pGrid objectAtIndex:fundaccountIndex]
                           sBankName_:[pGrid objectAtIndex:banknameIndex]
                          sMoneyName_:[pGrid objectAtIndex:currencyIndex]];
            //币种信息
            [pBDTranseInfo AddMoneyType:[pGrid objectAtIndex: currencyIndex]
                              sMoneyNo_:[pGrid objectAtIndex:currencyCodeIndex]];
            
            //银行列表
            [pBDTranseInfo AddBank:[pGrid objectAtIndex:banknameIndex]
                          sBankNo_:[pGrid objectAtIndex:bankIndex]
                           BankPW_:strPW];
            //银行对应币种
            [pBDTranseInfo AddBankToMoney:[pGrid objectAtIndex:banknameIndex]
                                strMoney_:[pGrid objectAtIndex:currencyIndex]];
            //币种对应银行
            [pBDTranseInfo AddMoneyToBank:[pGrid objectAtIndex:currencyIndex]
                                 strBank_:[pGrid objectAtIndex:banknameIndex]];
            
        }
        
    }
	self.pMoreAccountTranseInfo = pBDTranseInfo;
}

+(void)saveMoreAccountToDealerInfoWithData:(tztNewMSParse*)pInfo
{
    if(g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < TZTAccountPTType)
        return;
    
    NSInteger nIndex = g_ayJYLoginIndex[TZTAccountPTType];
    if(nIndex < 0 )
        return;
    
    NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountPTType];
    if(nIndex >= [ayJyLoginInfo count])
        return;
    tztJYLoginInfo* pCurJyLoginInfo = [ayJyLoginInfo objectAtIndex:nIndex];
    
    if(pCurJyLoginInfo && pCurJyLoginInfo.bGetInfoSuc)
    {
        [pCurJyLoginInfo saveMoreAccountToDealerInfo:pInfo];
        [ayJyLoginInfo replaceObjectAtIndex:nIndex withObject:pCurJyLoginInfo];
    }
}

#pragma tztNewMSParse 当前普通登录用户信息处理
//判断是否有信用账号
+(BOOL)iscreditfund:(tztNewMSParse*)jydataPhase
{
	if( jydataPhase == NULL )
		return FALSE;
    NSString* str = [jydataPhase GetByName:@"creditfund"];
	if(str == NULL || [str length] <= 0)
		return FALSE;
	if([str intValue] == 1)
		return TRUE;
	else
		return FALSE;
}


//设置当前交易账号信息积分 用户等级
+(void)SetCurJyLoginInfoScore:(tztNewMSParse*)pParse
{
    if(g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < TZTAccountPTType)
        return;
    
    NSInteger nIndex = g_ayJYLoginIndex[TZTAccountPTType];
    if(nIndex < 0 )
        return;
    
    NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountPTType];
    if(nIndex >= [ayJyLoginInfo count])
        return;
    tztJYLoginInfo* pCurJyLoginInfo = [ayJyLoginInfo objectAtIndex:nIndex];
    
    if(pCurJyLoginInfo && pCurJyLoginInfo.bGetInfoSuc)
    {
        NSString* strValue = [pParse GetByName:@"Score"];
		if(strValue)
		{
		    pCurJyLoginInfo.nsScore = strValue;
		}
        
        strValue = [pParse GetByName:@"UserLevel"];
		if(strValue)
		{
			pCurJyLoginInfo.nsUserLevel = strValue;
		}
        [ayJyLoginInfo replaceObjectAtIndex:nIndex withObject:pCurJyLoginInfo];
    }
}

//设置当前交易账号基金风险等级 风险等级名称
+(void)SetCurJyLoginInfoFundFxdj:(NSInteger)nFxdj DJMC:(NSString*)nsDJMC
{
    if(g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < TZTAccountPTType)
        return;
    
    NSInteger nIndex = g_ayJYLoginIndex[TZTAccountPTType];
    if(nIndex < 0 )
        return;
    
    NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountPTType];
    if(nIndex >= [ayJyLoginInfo count])
        return;
    tztJYLoginInfo* pCurJyLoginInfo = [ayJyLoginInfo objectAtIndex:nIndex];
    
    if(pCurJyLoginInfo && pCurJyLoginInfo.bGetInfoSuc)
    {
        pCurJyLoginInfo.FundTradefxjb = nFxdj;
        pCurJyLoginInfo.FundTradefxmc = nsDJMC;
        [ayJyLoginInfo replaceObjectAtIndex:nIndex withObject:pCurJyLoginInfo];
    }
    
}

//账号类别 0 普通 1信用
+(NSInteger)getcreditfund
{
    if(g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < TZTAccountPTType)
        return 0;
    
    NSInteger nIndex = g_ayJYLoginIndex[TZTAccountPTType];
    if(nIndex < 0 )
        return 0;
    
    NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountPTType];
    if(nIndex >= [ayJyLoginInfo count])
        return 0;
    tztJYLoginInfo* pCurJyLoginInfo = [ayJyLoginInfo objectAtIndex:nIndex];
	if(pCurJyLoginInfo && pCurJyLoginInfo.bGetInfoSuc)
	{
		return pCurJyLoginInfo.otherType;
	}
	return 0;
}

//转融通权限 注：只有在账户具有融资融券权限的情况下才有用
+(NSInteger)getZRTRight
{
    if(g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < TZTAccountPTType)
        return 0;
    
    NSInteger nIndex = g_ayJYLoginIndex[TZTAccountPTType];
    if(nIndex < 0 )
        return 0;
    
    NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountPTType];
    if(nIndex >= [ayJyLoginInfo count])
        return 0;
    tztJYLoginInfo* pCurJyLoginInfo = [ayJyLoginInfo objectAtIndex:nIndex];
	if(pCurJyLoginInfo && pCurJyLoginInfo.bGetInfoSuc && pCurJyLoginInfo.otherType)
	{
		return pCurJyLoginInfo.haveZRTRight;
	}
	return 0;
}

//当前普通交易账号是否支持多存管
+(BOOL)IsSupportMoreBank
{
    if(g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < TZTAccountPTType)
        return FALSE;
    
    NSInteger nIndex = g_ayJYLoginIndex[TZTAccountPTType];
    if(nIndex < 0 )
        return FALSE;
    
    NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:TZTAccountPTType];
    if(nIndex >= [ayJyLoginInfo count])
        return FALSE;
    tztJYLoginInfo* pCurJyLoginInfo = [ayJyLoginInfo objectAtIndex:nIndex];
	if(pCurJyLoginInfo && pCurJyLoginInfo.bGetInfoSuc)
	{
		if (pCurJyLoginInfo.pMoreAccountTranseInfo && [pCurJyLoginInfo.pMoreAccountTranseInfo HaveBankInfo])
		{
			return TRUE;
		}
	}
	return FALSE;
}
//这里不是太懂 需要多看看 xinlan
#pragma 已登录交易账号处理
//获取当前登录交易账号 账号类型 登录信息
+(tztJYLoginInfo *)GetCurJYLoginInfo:(NSInteger)nAccountType
{
	if(g_ayJYLoginInfo && nAccountType >= 0 && nAccountType < [g_ayJYLoginInfo count])
	{
        NSInteger nIndex = g_ayJYLoginIndex[nAccountType];
        if(nIndex < 0 )
            return NULL;
        NSMutableArray* aytztJYLoginInfo = [g_ayJYLoginInfo objectAtIndex:nAccountType];
        if(aytztJYLoginInfo && nIndex < [aytztJYLoginInfo count])
            return [aytztJYLoginInfo objectAtIndex:nIndex];
        else
        {
            if (nAccountType == TZTAccountCommLoginType)
            {
                //
                tztZJAccountInfo *pZJAccount = NewObjectAutoD(tztZJAccountInfo);
                [pZJAccount ReadLastSaveData:TZTAccountCommLoginType withFileName_:@"tztCustomerFile"];
                tztJYLoginInfo *pJyLoginInfo = NewObjectAutoD(tztJYLoginInfo);
                [pJyLoginInfo setZjAccountInfo:pZJAccount];
                return pJyLoginInfo;
            }
        }
	}
    else
    {
        if (nAccountType == TZTAccountCommLoginType)
        {
            //
            tztZJAccountInfo *pZJAccount = NewObjectAutoD(tztZJAccountInfo);
            [pZJAccount ReadLastSaveData:TZTAccountCommLoginType withFileName_:@"tztCustomerFile"];
            tztJYLoginInfo *pJyLoginInfo = NewObjectAutoD(tztJYLoginInfo);
            [pJyLoginInfo setZjAccountInfo:pZJAccount];
            return pJyLoginInfo;
        }
    }
    return NULL;
}

+(BOOL)SetCurJYLoginInfo:(NSInteger)nAccountType _nIndex:(NSInteger)nIndex account_:(tztZJAccountInfo*)pZJAccount
{
    if(g_ayJYLoginInfo == NULL)
	{
		g_ayJYLoginInfo = [[NSMutableArray alloc] initWithCapacity:TZTMaxAccountType];
        [g_ayJYLoginInfo removeAllObjects];
        for (int i = 0; i < TZTMaxAccountType; i ++)
        {
            NSMutableArray* ayJYLoginInfo = NewObject(NSMutableArray);
            g_ayJYLoginIndex[i] = -1;
            [g_ayJYLoginInfo addObject:ayJYLoginInfo];
            [ayJYLoginInfo release];
        }
	}
    tztJYLoginInfo* pJyLoginInfo = NewObject(tztJYLoginInfo);
    pJyLoginInfo.tokenType = nAccountType;
	//设置账号信息
	[pJyLoginInfo SetAccountInfo:pZJAccount];
    
    NSMutableArray* ayJYLoginInfo = [g_ayJYLoginInfo objectAtIndex:nAccountType];
    [ayJYLoginInfo addObject:pJyLoginInfo];
    g_ayJYLoginIndex[nAccountType] = nIndex;
    [g_ayJYLoginInfo addObject:ayJYLoginInfo];
    [pJyLoginInfo release];
    return FALSE;
}

//设置当前账号 账号类别 账号索引
+(BOOL)SetCurJYLoginInfo:(NSInteger)nAccountType _nIndex:(NSInteger)nIndex
{
    if (g_ayJYLoginInfo && nAccountType >= 0 && nAccountType < [g_ayJYLoginInfo count])
    {
        NSMutableArray *ayJYLoginInfo = [g_ayJYLoginInfo objectAtIndex:nAccountType];
        if (ayJYLoginInfo && nIndex < [ayJYLoginInfo count])
        {
            g_pCurJYLoginInfo = [ayJYLoginInfo objectAtIndex:nIndex];
            g_ayJYLoginIndex[nAccountType] = nIndex;
            return TRUE;
        }
    }
    return FALSE;
}

//保存最近登录账号信息
+(BOOL) SaveRectAccount:(tztJYLoginInfo* )pRecenJYLoginInfo
{
	if (pRecenJYLoginInfo == NULL)
		return FALSE;
	
    NSDictionary* dicAddrList = [[NSDictionary alloc] initWithObjectsAndKeys:pRecenJYLoginInfo,@"RecentAccount",nil];
    [dicAddrList writeToFile:def_RecentAccounts atomically:YES];
	[dicAddrList release];
    return TRUE;
}

//读取最近登录账号信息
+(tztJYLoginInfo*) GetRecentAccount
{
	NSDictionary* dicAddrList = GetDictByListName(def_RecentAccounts);// [TZTCMacFilePath readApplicationData:def_RecentAccounts];
	if(dicAddrList && [dicAddrList count] > 0)
	{
		return (tztJYLoginInfo*)[dicAddrList objectForKey:@"RecentAccount"];
	}
	return NULL;
}


//读取登录用户名 － 账号列表
+(BOOL)GetJyAccountList:(NSMutableArray*)ayJyAccount
{
    if(ayJyAccount == nil)
        return FALSE;
    
	if(ayJyAccount)
        [ayJyAccount removeAllObjects];
	if(g_ayJYLoginInfo == NULL)
		return TRUE;
    
    NSString* strKind = @"";
	for(int i = 0;i < [g_ayJYLoginInfo count] ; i++)
	{
        switch (i) {
            case 0:
                strKind = @"";
                break;
            case 1:
                strKind = @"--信用账号";
                break;
            case 2:
                strKind = @"--期货账号";
                break;
            case 3:
                strKind = @"--港股账号";
                break;
            default:
                break;
        }
        NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:i];
        for (int j = 0; j < [ayJyLoginInfo count]; j++)
        {
            tztJYLoginInfo* pJyLoginInfo = [ayJyLoginInfo objectAtIndex:j];
            if(pJyLoginInfo && pJyLoginInfo.bGetInfoSuc)
            {
                NSString *fundaccount = pJyLoginInfo.nsFundAccount;
                NSString *UserName = pJyLoginInfo.nsUserName;
                if(UserName == NULL)
                    UserName = @"     ";
                NSString *tempStr = [NSString stringWithFormat:@"%@--%@%@",UserName,fundaccount,strKind];
                if(tempStr && ayJyAccount)
                    [ayJyAccount addObject:tempStr];
            }
        }
	}
	return TRUE;
}


//账号全部登出
+(BOOL)SetLoginAllOut:(BOOL)bFlag
{
    g_GgtRightEndDate = @"";
    g_GgtRights = @"";
    
	[TZTUserInfoDeal SetTradeLogState:Trade_Logout lLoginType_:AllTrade_Log];
	if(g_ayJYLoginInfo && [g_ayJYLoginInfo count] > 0)
	{
        for (int i = 0; i < [g_ayJYLoginInfo count]; i++)
        {
            NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:i];
            [ayJyLoginInfo removeAllObjects];
        }
	}
    
    if(g_CurUserData)
    {
        for (int i = 0; i < TZTMaxAccountType; i++)
        {
            [g_CurUserData delAccountToken:i];
        }
    }
    g_CurUserData.nsDBPLoginToken = @"";
//    if (bFlag)
//        [TZTUIBaseVCMsg OnMsg:MENU_SYS_UserLogout wParam:0 lParam:1];
	return TRUE;
    
}

+(BOOL)SetLoginAllOut
{
    return [tztJYLoginInfo SetLoginAllOut:YES];
}

//账号登出
+(BOOL)SetLoginOutAccount:(NSString *)strFundAccount
{
	if(g_ayJYLoginInfo == NULL  || [g_ayJYLoginInfo count] <= 0)
	{
		return FALSE;
	}
    NSInteger ngetAccontType = -1;
    NSInteger nLoginIndex = [tztJYLoginInfo GetLoginIndexOfAyJYLogin:strFundAccount forType:&ngetAccontType];
    if(nLoginIndex >= 0 && ngetAccontType >= 0 && ngetAccontType < TZTMaxAccountType )
    {
        BOOL bRestIndex = (nLoginIndex == g_ayJYLoginIndex[ngetAccontType]);
        if(bRestIndex)
        {
            g_ayJYLoginIndex[ngetAccontType] = -1;
        }
        
        NSMutableArray* ayJYLoginInfo = [g_ayJYLoginInfo objectAtIndex:ngetAccontType];
        tztJYLoginInfo* pDelJyLongInfo = [ayJYLoginInfo objectAtIndex:nLoginIndex];
        if(g_CurUserData && pDelJyLongInfo) //账号登出 设置对应token为空
        {
            [g_CurUserData setAccountToken:@"" tokenKind:ngetAccontType tokenIndex:pDelJyLongInfo.tokenIndex];
        }
        [ayJYLoginInfo removeObjectAtIndex:nLoginIndex];
        
        if(nLoginIndex == 0)
            nLoginIndex = [ayJYLoginInfo count] -1;
        else
            nLoginIndex--;
        if(bRestIndex)
        {
            g_ayJYLoginIndex[ngetAccontType] = nLoginIndex;
            if(nLoginIndex >= 0)
            {
                tztJYLoginInfo* pJyLoginInfo = [ayJYLoginInfo objectAtIndex:nLoginIndex];
                [tztJYLoginInfo SaveRectAccount:pJyLoginInfo];
            }
        }
        return TRUE;
    }
    return FALSE;
}

+(NSInteger)GetLoginIndexOfAyJYLoginEx:(NSString *)strFundAccount andLoginType:(NSInteger)nLoginType forType:(NSInteger *)nAccountType
{
	NSInteger iRet = -1;
    *nAccountType = -1;
	if(g_ayJYLoginInfo == NULL)
	{
		return iRet;
	}
	//根据账号信息查找
	for(NSInteger i = 0 ; i < [g_ayJYLoginInfo count]; i++)
	{
        NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:i];
		for (NSInteger j = 0 ; j < [ayJyLoginInfo count]; j++)
        {
            tztJYLoginInfo* pJYLoginInfo = [ayJyLoginInfo objectAtIndex:j];
            if(pJYLoginInfo && pJYLoginInfo.bGetInfoSuc)
            {
                NSString* pJYFundAccount = pJYLoginInfo.nsFundAccount;
                if(pJYFundAccount && [pJYFundAccount length] > 0)
                {
                    if(strFundAccount && [strFundAccount compare:pJYFundAccount] == NSOrderedSame
                       && pJYLoginInfo.nLoginType == nLoginType)
                    {
                        *nAccountType = i;
                        return j;
                    }
                }
            }
        }
	}
	return -1;//没有相应记录
}

//资金账号 查找已登录账号
+(NSInteger)GetLoginIndexOfAyJYLogin:(NSString *)strFundAccount forType:(NSInteger *)nAccountType
{
	NSInteger iRet = -1;
    *nAccountType = -1;
	if(g_ayJYLoginInfo == NULL)
	{
		return iRet;
	}
	//根据账号信息查找
	for(NSInteger i = 0 ; i < [g_ayJYLoginInfo count]; i++)
	{
        NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:i];
		for (NSInteger j = 0 ; j < [ayJyLoginInfo count]; j++)
        {
            tztJYLoginInfo* pJYLoginInfo = [ayJyLoginInfo objectAtIndex:j];
            if(pJYLoginInfo && pJYLoginInfo.bGetInfoSuc)
            {
                NSString* pJYFundAccount = pJYLoginInfo.nsFundAccount;
                if(pJYFundAccount && [pJYFundAccount length] > 0)
                {
                    if(strFundAccount && [strFundAccount compare:pJYFundAccount] == NSOrderedSame)
                    {
                        *nAccountType = i;
                        return j;
                    }
                }
            }
        }
	}
	return -1;//没有相应记录
}

//当前是否有账号登录着
+(BOOL)HaveLoginAccount
{
    if ( g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < 1)
        return FALSE;
    
    for (int i = 0; i < TZTMaxAccountType; i++)
    {
        if(g_ayJYLoginIndex[i] >= 0)
            return TRUE;
    }
    return FALSE;
}

#pragma 交易账号
//获取当前默认账号 bLoginIn 未登录账号
+(NSString*)GetDefaultAccount:(BOOL)bLoginIn nType_:(NSInteger)nLoginType
{
	NSString *nsDefault = NULL;
    NSString* strPath = GetPathWithListName(@"tztDefalutAccount",TRUE);
    //先获取文件中保存的数据
    NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithContentsOfFile:strPath];
    
    if (nLoginType == TZTAccountPTType)
    {
        nsDefault = [pDict tztObjectForKey:@"TZTAccountPTType"];
    }
    else if(nLoginType == TZTAccountRZRQType)
    {
        nsDefault = [pDict tztObjectForKey:@"TZTAccountRZRQType"];
    }
    else if(nLoginType == TZTAccountHKType)
    {
        nsDefault = [pDict tztObjectForKey:@"TZTAccountHKType"];
    }
    else if(nLoginType == TZTAccountQHType)
    {
        nsDefault = [pDict tztObjectForKey:@"TZTAccountQHType"];
    }
    
    nsDefault = textFromBase64String(nsDefault);
//	NSUserDefaults *JyAccountDefault = [NSUserDefaults standardUserDefaults];
//	if (JyAccountDefault)
//    {
//		nsDefault = [JyAccountDefault stringForKey:@"defalutAccount"];
//	}
    
//    if (nLoginType < 0)
//        nLoginType =  TZTAccountPTType;
//    if(g_ayJYLoginInfo == NULL || [g_ayJYLoginInfo count] < nLoginType)
//        return nsDefault;
//    
//    int nIndex = g_ayJYLoginIndex[nLoginType];
//    if(nIndex < 0 )
//        return nsDefault;
//    
//    NSMutableArray* ayJyLoginInfo = [g_ayJYLoginInfo objectAtIndex:nLoginType];
//    
//    if (bLoginIn && nsDefault)
//    {
//        //获取当前登录的账号
//        if (ayJyLoginInfo != NULL && [ayJyLoginInfo count] > 0)
//        {
//            BOOL bExist = FALSE;
//            NSMutableArray *pArray = [[NSMutableArray alloc] initWithArray:g_ZJAccountArray];
//            for (int i = 0; i < [ayJyLoginInfo count]; i++)
//            {
//                NSMutableArray* ayJYLoginInfo = [ayJyLoginInfo objectAtIndex:i];
//                for (int j = 0 ; j < [ayJYLoginInfo count]; j++)
//                {
//                    tztJYLoginInfo* pJyLoginInfo = [ayJYLoginInfo objectAtIndex:j];
//                    if (pJyLoginInfo == NULL)
//                        continue;
//                    if ([nsDefault compare:pJyLoginInfo.nsAccount] == NSOrderedSame)
//                    {
//                        bExist = TRUE;
//                        for (int j = 0; j < [pArray count]; j++)
//                        {
//                            tztZJAccountInfo* pZJ = [pArray objectAtIndex:j];
//                            if (pZJ == NULL)
//                                continue;
//                            NSString* nsAccount = pZJ.nsAccount;
//                            if (nsAccount && [nsAccount length] > 0 && pJyLoginInfo.nsAccount && [pJyLoginInfo.nsAccount length] > 0)
//                            {
//                                if ([nsAccount compare:pJyLoginInfo.nsAccount] != NSOrderedSame)
//                                {
//                                    [pArray removeObject:pZJ];
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            if (bExist)
//            {
//                if (pArray && [pArray count] > 0)
//                {
//                    tztZJAccountInfo* pZJ = [pArray objectAtIndex:0];
//                    if (pZJ)
//                        nsDefault = pZJ.nsAccount;
//                }
//            }
//            [pArray release];
//        }
//    }
	return nsDefault;
}


/*
 根据登录类型，分开存储各个最后登录成功的账号
 */
+(void)SetDefaultAccount:(NSString*) nsDefault nType_:(NSInteger)nLoginType
{
    if (nsDefault == NULL)
        return;
    NSString* strPath = GetPathWithListName(@"tztDefalutAccount",TRUE);
    //先获取文件中保存的数据
    NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithContentsOfFile:strPath];
    
    NSString* strDefault = base64StringFromText(nsDefault);
    if (pDict == NULL)
        pDict = NewObjectAutoD(NSMutableDictionary);
    
    if (nLoginType == TZTAccountPTType)
    {
        [pDict setTztObject:strDefault forKey:@"TZTAccountPTType"];
    }
    else if(nLoginType == TZTAccountRZRQType)
    {
        [pDict setTztObject:strDefault forKey:@"TZTAccountRZRQType"];
    }
    else if(nLoginType == TZTAccountHKType)
    {
        [pDict setTztObject:strDefault forKey:@"TZTAccountHKType"];
    }
    else if(nLoginType == TZTAccountQHType)
    {
        [pDict setTztObject:strDefault forKey:@"TZTAccountQHType"];
    }
    
    [pDict writeToFile:strPath atomically:YES];
}

+(NSString*)GetDefaultAccount:(NSInteger)nLoginType
{
    return [tztJYLoginInfo GetDefaultAccount:FALSE nType_:nLoginType];
}

//隐藏交易账号
+(NSString*)HideFund:(NSString*)str
{
	NSString* ns = str;
	if(!str)
		return @"";
    if([str length] < 4)
		return ns;
	NSInteger length = [str length];
#ifdef QLSC_SUPPORT
	ns = [str stringByReplacingCharactersInRange:NSMakeRange(length/2-2, MIN(4,length/2+2) ) withString:@"****"];
#else
	NSString *Fstr;
	NSString *Bstr;
	NSString *Mstr = @"*";
	Fstr = [str substringToIndex:2];
	Bstr = [str substringFromIndex:length-2];
	for(int i = 1;i < length-4; i++)
	{
		Mstr = [NSString stringWithFormat:@"*%@",Mstr];
	}
	ns = [NSString stringWithFormat:@"%@%@%@",Fstr,Mstr,Bstr];
#endif
	TZTNSLog(@"HideFund:%@",ns);
    return ns;
}

//设置账号列表
+(BOOL)SetAccountList:(tztNewMSParse*) pParse
{
    if (g_ZJAccountArray == NULL)
        g_ZJAccountArray = NewObject(NSMutableArray);
    [g_ZJAccountArray removeAllObjects];
    //	_FREE_NSMUTABLEARRAY_POINT_(g_ZJAccountArray);//删除交易账号列表
	g_ZjAccountArrayNum = 0;
    
    NSArray *pGrid = [pParse GetArrayByName:@"Grid"];
    if (pGrid == NULL || [pGrid count] < 1)
        return FALSE;
    
    for (int i = 0; i < [pGrid count]; i++)
    {
        NSArray *pAy = [pGrid objectAtIndex:i];
        if (pAy == NULL || [pAy count] < 4)
            continue;
        
        tztZJAccountInfo *pZJ = NewObject(tztZJAccountInfo);
        NSString* strAccount = [pAy objectAtIndex:0];
        if (strAccount)
            pZJ.nsAccount = [NSString stringWithFormat:@"%@", strAccount];
        
        NSString* strAccountType = [pAy objectAtIndex:1];
        if (strAccountType)
            pZJ.nsAccountType = [NSString stringWithFormat:@"%@", strAccountType];
        
        NSString* strCellIndex = [pAy objectAtIndex:2];
        if (strCellIndex)
            pZJ.nsCellIndex = [NSString stringWithFormat:@"%@", strCellIndex];
        
        NSString* strCellName = [pAy objectAtIndex:3];
        if (strCellName)
            pZJ.nsCellName = [NSString stringWithFormat:@"%@", strCellName];
        
        if ([pAy count] > 4)
        {
            NSString* strComPwd = [pAy objectAtIndex:4];
            pZJ.nNeedComPwd = [strComPwd intValue];
        }
        if ([pAy count] > 5)
        {
            NSString* strCustid = [pAy objectAtIndex:[pAy count] - 2];
            if (strCustid)
                pZJ.nsCustomID = [NSString stringWithFormat:@"%@", strCustid];
        }
        
        [g_ZJAccountArray addObject:pZJ];
        [pZJ release];
    }
	g_ZjAccountArrayNum = [g_ZJAccountArray count];
	return TRUE;
}

+(void)AddAccountToList:(tztZJAccountInfo*)pAccountData
{
	if (pAccountData == NULL)
		return;
	//判断账号是不是已经存在了
	
	for (int i = 0; i < [g_ZJAccountArray count]; i++)
	{
        tztZJAccountInfo *pAccount = [g_ZJAccountArray objectAtIndex:i];
		if (pAccount == NULL)
			continue;
		
        NSString* strSource = pAccount.nsAccount;
        strSource = [strSource uppercaseString];
        NSString* strDest = pAccountData.nsAccount;
        strDest = [strDest uppercaseString];
        
        if ([strSource compare:strDest] == NSOrderedSame)//账号已经存在
            return;
	}
    tztZJAccountInfo *pZJ = NewObject(tztZJAccountInfo);
    [pZJ SetZJAccountInfo:pAccountData];
	[g_ZJAccountArray addObject:[NSValue valueWithPointer:pZJ]];
	g_ZjAccountArrayNum = [g_ZJAccountArray count];
    DelObject(pZJ);
}

//账号列表
+(BOOL)DelAccountIndex:(NSInteger)iIndex
{
	if(iIndex < 0 || iIndex >= [g_ZJAccountArray count])//数组越界
		return FALSE;
    
    //    tztZJAccountInfo *pCurZJ = [g_ZJAccountArray objectAtIndex:iIndex];
	[g_ZJAccountArray removeObjectAtIndex:iIndex];
    return TRUE;
}

+(void)setTradeStockData:(NSMutableArray*)ayData
{
    if (![TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])//交易未登录，不处理
        return;
    
    //获取当前登录账号
    tztJYLoginInfo* pJYLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (pJYLoginInfo == NULL)
        return;
    if (pJYLoginInfo.ayTradeStockData == NULL)
        pJYLoginInfo.ayTradeStockData = NewObject(NSMutableArray);
    
    //不应该直接删除的
    [pJYLoginInfo.ayTradeStockData removeAllObjects];
    
    for (NSInteger i = 0; i < ayData.count; i++)
    {
        [pJYLoginInfo.ayTradeStockData addObject:[ayData objectAtIndex:i]];
    }
    
    NSNotification* pNotifi1 = [NSNotification notificationWithName:@"tztRefreshTradeData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:pNotifi1];
}

+(BOOL)IsTradeCCShow
{
    if (![TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])//交易未登录，不处理
        return FALSE;
    BOOL bShowCC = ([[[tztUserSaveDataObj getShareInstance] getUserDataValueForKey:@"tzttradestockshow"] intValue] > 0);
    
    if (!bShowCC)
        return FALSE;
    return YES;
}

+(BOOL)IsTradeStockInfo:(tztStockInfo*)pStock
{
    if (pStock == nil || pStock.stockCode.length < 1)
        return NO;
    if (![tztJYLoginInfo IsTradeCCShow])
        return NO;
    
    tztJYLoginInfo* pJYLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (pJYLoginInfo == NULL)
        return NO;
    
    for (NSDictionary* dict in pJYLoginInfo.ayTradeStockData)
    {
        NSString* strCode = [dict tztObjectForKey:tztCode];
        if ([strCode caseInsensitiveCompare:pStock.stockCode] == NSOrderedSame)
            return YES;
    }
    return NO;
}

+(NSDictionary*)GetTradeStockData:(tztStockInfo*)pStock
{
    if (pStock == nil || pStock.stockCode.length < 1)
        return nil;
    if (![tztJYLoginInfo IsTradeCCShow])
        return nil;
    tztJYLoginInfo* pJYLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (pJYLoginInfo == NULL)
        return nil;
    
    for (NSDictionary* dict in pJYLoginInfo.ayTradeStockData)
    {
        NSString* strCode = [dict tztObjectForKey:tztCode];
        if ([strCode caseInsensitiveCompare:pStock.stockCode] == NSOrderedSame)
            return dict;
    }
    return nil;
}

@end

int tztHaveHKRight()
{
    if (g_nHKHasRight)
        return 1;
    NSString* strPath = GetPathWithListName(@"tztLoginFlag", TRUE);
    NSString* strLoginFlag = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    
    int nLoginFlag = -1;
    if (strLoginFlag && strLoginFlag.length > 0)
    {
        nLoginFlag = [strLoginFlag intValue];
    }
    if (nLoginFlag <= 0)
        return 0;
    
    tztZJAccountInfo *pZJAccount = NewObjectAutoD(tztZJAccountInfo);
    [pZJAccount ReadLastSaveData:TZTAccountCommLoginType withFileName_:@"tztCustomerFile"];
    
    int nRight = [g_GgtRights intValue];
    
    if (pZJAccount.nLogVolume > 0 && nRight > 0)//登录有效，并且有权限
    {
        return 1;
    }
    else if (pZJAccount.nLogVolume <= 0 && nRight > 0)//登录已经被踢，但有权限
        return -1;
    else
        return 0;
//    return ([g_GgtRights intValue] > 0);
//    if (pZJAccount && pZJAccount.Ggt_rights && pZJAccount.Ggt_rights.length > 0)
//    {
//        if ([pZJAccount.Ggt_rights intValue] > 0)
//        {
//            return TRUE;
//        }
//    }
//    return FALSE;
}

tztZJAccountInfo* tztGetCurrentAccountHKRight()
{
    NSString* strPath = GetPathWithListName(@"tztLoginFlag", TRUE);
    NSString* strLoginFlag = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    
    int nLoginFlag = -1;
    if (strLoginFlag && strLoginFlag.length > 0)
    {
        nLoginFlag = [strLoginFlag intValue];
    }
    if (nLoginFlag <= 0)
        return NULL;
    
    tztZJAccountInfo *pZJAccount = NewObjectAutoD(tztZJAccountInfo);
    [pZJAccount ReadLastSaveData:TZTAccountCommLoginType withFileName_:@"tztCustomerFile"];
    pZJAccount.Ggt_rights = [NSString stringWithFormat:@"%@", g_GgtRights];
    pZJAccount.Ggt_rightsEndDate = [NSString stringWithFormat:@"%@", g_GgtRightEndDate];
    return pZJAccount;
}

void tztSaveCurrentHKRight(tztZJAccountInfo *pAccount)
{
    if (pAccount == NULL)
        return;
    
    if (g_GgtRights)
        [g_GgtRights release];
    if (g_GgtRightEndDate)
        [g_GgtRightEndDate release];
    
    g_GgtRights = [[NSString alloc] initWithFormat:@"%@", pAccount.Ggt_rights];
    g_GgtRightEndDate = [[NSString alloc] initWithFormat:@"%@",pAccount.Ggt_rightsEndDate];
    
    return;
    //保存账号信息
    [pAccount SaveAccountInfo];
    
    [pAccount SaveAccountInfo:@"tztCustomerFile"];
    [pAccount SaveCurrentData:TZTAccountCommLoginType withFileName_:@"tztCustomerFile"];
    [pAccount SaveCurrentData:TZTAccountPTType];
}




