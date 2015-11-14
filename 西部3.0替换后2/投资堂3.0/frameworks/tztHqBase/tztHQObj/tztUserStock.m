/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztUserStock.m
 * 文件标识：
 * 摘    要：自选股
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import "tztUserStock.h"
//#import "tztJYLoginInfo.h"
//#import "TZTUserInfoDeal.h"

#define tztRecentStockPlist @"tztRecentStock"
#define tztRecentStockPlistNew @"tztRecentStockNew"
#define tztUserStockPlist   @"tztUserStock"

tztUserStock* g_tztUserStock = nil;
static NSString* tztSystermConfig_TodayData = @"tztTodayData";
static NSString* tztSystermConfig_UserStockNeedHQ = @"tztUserStockNeedHQ";
static NSString* tztSystermConfig_UserStockClearAll = @"tztUserStockClearAll";
@implementation tztUserStock

@synthesize ntztReqno = _ntztReqno;
@synthesize nsAccount = _nsAccount;
@synthesize bUseNewUserStock = _bUseNewUserStock;
@synthesize nTokenType;
-(id)init
{
    self = [super init];
    if (self)
    {
        nTokenType = tztSession_ExchangeZX;//默认都从资讯服务器上取数据
        self.nsAccount = @"";
        self.ntztReqno = 1;
        self.bUseNewUserStock = YES;//
        NSString* strTokenType = [g_pSystermConfig.pDict tztObjectForKey:@"tztUserStockTokenType"];
        if (strTokenType.length > 0)
            nTokenType = [strTokenType intValue];
        [[tztMoblieStockComm getShareInstance:nTokenType] addObj:self];
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    self.ntztReqno = 0;
    [[tztMoblieStockComm getShareInstance:nTokenType] removeObj:self];
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

+(void)initShareClass
{
    if(g_tztUserStock == nil)
    {
        g_tztUserStock = NewObject(tztUserStock);
    }
}

+(void)freeShareClass
{
    DelObject(g_tztUserStock);
}

+(tztUserStock*)getShareClass
{
    [tztUserStock initShareClass];
    return g_tztUserStock;
}

+(NSMutableArray*)GetUserStockArray
{
    return [tztUserStock GetUserStockArray:NO];
}

+(NSMutableArray*)GetUserStockArray:(BOOL)bSecend
{
    NSMutableArray *ayStock = GetArrayByListName(tztUserStockPlist);
    if (bSecend)
        return ayStock;
    
    NSMutableArray *ayReturn = NewObjectAutoD(NSMutableArray);
    for (id data in ayStock)
    {
        [ayReturn insertObject:data atIndex:0];
    }
    return ayReturn;
    //    return GetArrayByListName(tztUserStockPlist);
}

+(void)SaveUserStockArray:(NSMutableArray *)ayStock
{
    [tztUserStock SaveUserStockArray:ayStock post:FALSE];
}

+(void)SaveUserStockArray:(NSMutableArray*)ayStock post:(BOOL)bPost
{
    if (ayStock)
    {
        if(!SetArrayByListName(ayStock,tztUserStockPlist))
        {
            TZTLogErrorUp(@"本地保存自选股失败:%@",ayStock);
        }
        
        NSString* str = [g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_TodayData];
        if (str.length > 0 && IS_TZTIOS(7))
        {
            NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:str];
            [sharedDefaults setObject:ayStock forKey:@"tztTodayUserStockData"];
            [sharedDefaults synchronize];
            [sharedDefaults release];
        }
    }
    if(bPost)
    {
        [tztUserStock postUserStockChange:nil direction:0];
    }
    
}

+(void)postUserStockChange:(tztStockInfo*)pStock direction:(int)nDirection
{
    NSMutableDictionary* dict = NewObject(NSMutableDictionary);
    if (pStock)//股票信息
        [dict setValue:pStock forKey:@"tztStockInfo"];
    [dict setValue:[NSString stringWithFormat:@"%d", nDirection] forKey:@"tztOperation"];//操作方式
    NSNotification* pNotifi = [NSNotification notificationWithName:tztUserStockNotificationName object:dict];
    [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
    DelObject(dict);
}
//加入自选
+(void)AddUserStock:(tztStockInfo*)pStock
{
    if(pStock == nil || ![pStock isVaildStock])
        return;
    
    NSMutableArray *pStockAy = [tztUserStock GetUserStockArray:YES];
    if (pStockAy == NULL)
    {
        pStockAy = NewObjectAutoD(NSMutableArray);
    }
    else
    {
        int iIndex = [tztUserStock IndexUserStock:pStock];
        if(iIndex >= 0 && iIndex < [pStockAy count])
        {
            [pStockAy removeObjectAtIndex:iIndex];
        }
    }
    
    NSMutableDictionary *pStockDict = [pStock GetStockDict];
    if(pStockDict)
        [pStockAy addObject:pStockDict];
    
    if(!SetArrayByListName(pStockAy,tztUserStockPlist))
    {
        TZTLogErrorUp(@"本地保存自选股失败:%@",pStockAy);
    }
    
    NSString* str = [g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_TodayData];
    if (str.length > 0 && IS_TZTIOS(7))
    {
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:str];
        [sharedDefaults setObject:pStockAy forKey:@"tztTodayUserStockData"];
        [sharedDefaults synchronize];
        [sharedDefaults release];
    }
    
    int bSendServer = [[g_pSystermConfig.pDict tztObjectForKey:@"UserStockAutoServer"] intValue];
    if (bSendServer <= 0)
    {
        [tztUserStock postUserStockChange:pStock direction:1];
        return;
    }
    
    if (bSendServer == 2)//
    {
        
    }
    //没有手机号或者设备号，只保存本地，不上传服务器(iPad使用)
    NSString* strLogMobile = [tztKeyChain load:tztLogMobile];
    if (strLogMobile && strLogMobile.length > 1)
    {
        if (g_tztUserStock.bUseNewUserStock)
        {
            //获取本地代码
            NSMutableData *pData = NewObject(NSMutableData);
            NSString *strCode = [NSString stringWithFormat:@"%@|%d", pStock.stockCode, pStock.stockType];
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            g_tztUserStock.ntztReqno++;
            if (g_tztUserStock.ntztReqno >= UINT16_MAX)
                g_tztUserStock.ntztReqno = 1;
            
            //strCode = [[NSString alloc] initWithData:pData encoding:NSASCIIStringEncoding];
            
            NSString* strReqno = tztKeyReqno((long)g_tztUserStock, g_tztUserStock.ntztReqno);
            [pDict setTztValue:strReqno forKey:@"Reqno"];
            [pDict setTztValue:@"0" forKey:@"Direction"];//0－新增 1－删除 2-覆盖
            [pDict setTztValue:@"999" forKey:@"Volume"];//插入位置0，或者很大，标识插入到最后
            [pDict setTztValue:@"0" forKey:@"ErrorNo"];
            [pDict setTztValue:@"10" forKey:@"AccountType"];
            if (g_tztUserStock.nsAccount.length > 0)
            {
                [pDict setTztValue:g_tztUserStock.nsAccount forKey:@"Account"];
            }
            else
            {
    //            if ([tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType] && [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount)
    //            {
    //                [pDict setTztValue:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount forKey:@"Account"];
    //            }
            }
            NSString* str = [pDict tztObjectForKey:@"Account"];
            if (str.length > 0)
            {
                NSString* strKey = [NSString stringWithFormat:@"%@-%@", tztPID, str];
                NSString* strValue = [tztKeyChain load:strKey];
                if (strValue)
                    [pDict setTztValue:strValue forKey:@"Price"];
            }

            
            if (strCode)
                [pDict setTztObject:strCode forKey:@"Grid"];
            
            [pDict setTztValue:@"QBI" forKey:@"Title"];
            
            [[tztMoblieStockComm getShareInstance:g_tztUserStock.nTokenType] onSendDataAction:@"55" withDictValue:pDict];
            [pData release];
            [pDict release];
        }
        else
        {
            [tztUserStock initShareClass];
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            g_tztUserStock.ntztReqno++;
            if (g_tztUserStock.ntztReqno >= UINT16_MAX)
                g_tztUserStock.ntztReqno = 1;
            
            NSString* strCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            NSString* strReqno = tztKeyReqno((long)g_tztUserStock, g_tztUserStock.ntztReqno);
            [pDict setTztValue:strReqno forKey:@"Reqno"];
            [pDict setTztValue:@"0" forKey:@"Direction"];//0－新增 1－删除
            [pDict setTztValue:@"999" forKey:@"Volume"];//插入位置0，或者很大，标识插入到最后
            [pDict setTztValue:strCode forKey:@"Grid"];
            [[tztMoblieStockComm getShareInstance:g_tztUserStock.nTokenType] onSendDataAction:@"47" withDictValue:pDict];
            [pDict release];
        }
    }
    [tztUserStock postUserStockChange:pStock direction:1];
}

//删除自选
+(void)DelUserStock:(tztStockInfo*)pStock
{
    if(pStock == nil || ![pStock isVaildStock])
        return;
    
    NSMutableArray *pStockAy = [tztUserStock GetUserStockArray:YES];
    if (pStockAy == NULL)
    {
        pStockAy = NewObjectAutoD(NSMutableArray);
    }
    else
    {
        int iIndex = [tztUserStock IndexUserStock:pStock];
        if(iIndex >= 0 && iIndex < [pStockAy count])
        {
            [pStockAy removeObjectAtIndex:iIndex];
        }
    }
    
    if(!SetArrayByListName(pStockAy,tztUserStockPlist))
    {
        TZTLogErrorUp(@"本地保存自选股失败:%@",pStockAy);
    }
    
    
    NSString* str = [g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_TodayData];
    if (str.length > 0 && IS_TZTIOS(7))
    {
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:str];
        [sharedDefaults setObject:pStockAy forKey:@"tztTodayUserStockData"];
        [sharedDefaults synchronize];
        [sharedDefaults release];
    }
    
    [tztUserStock postUserStockChange:pStock direction:2];
    
    int bSendServer = [[g_pSystermConfig.pDict tztObjectForKey:@"UserStockAutoServer"] intValue];
    if (bSendServer <= 0)
        return;
    
    [tztUserStock SendDelUserStockReq:pStock];
}

+ (void)SendDelUserStockReq:(tztStockInfo *)pStock
{
    //没有手机号或者设备号，只保存本地，不上传服务器(iPad使用)
    NSString* strLogMobile = [tztKeyChain load:tztLogMobile];
    if (strLogMobile && strLogMobile.length > 0)
    {
        if (g_tztUserStock.bUseNewUserStock)
        {
            //获取本地代码
            NSMutableData *pData = NewObject(NSMutableData);
            NSString *strCode = [NSString stringWithFormat:@"%@|%d", pStock.stockCode, pStock.stockType];
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            g_tztUserStock.ntztReqno++;
            if (g_tztUserStock.ntztReqno >= UINT16_MAX)
                g_tztUserStock.ntztReqno = 1;
            
            NSString* strReqno = tztKeyReqno((long)g_tztUserStock, g_tztUserStock.ntztReqno);
            [pDict setTztValue:strReqno forKey:@"Reqno"];
            [pDict setTztValue:@"1" forKey:@"Direction"];//0－新增 1－删除 2-覆盖
            [pDict setTztValue:@"999" forKey:@"Volume"];//插入位置0，或者很大，标识插入到最后
            [pDict setTztValue:@"0" forKey:@"ErrorNo"];
            [pDict setTztValue:@"10" forKey:@"AccountType"];
            if (g_tztUserStock.nsAccount.length > 0)
            {
                [pDict setTztValue:g_tztUserStock.nsAccount forKey:@"Account"];
            }
            else
            {
    //            if ([tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType] && [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount)
    //            {
    //                [pDict setTztValue:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount forKey:@"Account"];
    //            }
            }
            NSString* str = [pDict tztObjectForKey:@"Account"];
            if (str.length > 0)
            {
                NSString* strKey = [NSString stringWithFormat:@"%@-%@", tztPID, str];
                NSString* strValue = [tztKeyChain load:strKey];
                
                if (strValue)
                    [pDict setTztValue:strValue forKey:@"Price"];
            }

            
            if (strCode)
                [pDict setTztObject:strCode forKey:@"Grid"];
            
            [pDict setTztValue:@"QBI" forKey:@"Title"];
            [[tztMoblieStockComm getShareInstance:g_tztUserStock.nTokenType] onSendDataAction:@"55" withDictValue:pDict];
            [pData release];
            [pDict release];
        }
        else
        {
            [tztUserStock initShareClass];
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            g_tztUserStock.ntztReqno++;
            if (g_tztUserStock.ntztReqno >= UINT16_MAX)
                g_tztUserStock.ntztReqno = 1;
            
            
            NSString* strCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
            
            NSString* strReqno = tztKeyReqno((long)g_tztUserStock, g_tztUserStock.ntztReqno);
            [pDict setTztValue:strReqno forKey:@"Reqno"];
            [pDict setTztValue:@"1" forKey:@"Direction"];//0－新增 1－删除
            [pDict setTztValue:@"0" forKey:@"Volume"];//插入位置0，或者很大，标识插入到最后
            [pDict setTztValue:strCode forKey:@"Grid"];
            
            [[tztMoblieStockComm getShareInstance:g_tztUserStock.nTokenType] onSendDataAction:@"47" withDictValue:pDict];
            [pDict release];
        }
    }
}

//是否已经存在
+(int)IndexUserStock:(tztStockInfo*)pStock
{
    if(pStock == nil || ![pStock isVaildStock])
        return -1;
    NSArray *pStockAy = (NSArray*)GetArrayByListName(tztUserStockPlist);
    if (pStockAy == nil || [pStockAy count] <= 0)
        return -1;
    int iIndex = -1;
    for (int i = 0; i < [pStockAy count]; i++)
    {
        NSMutableDictionary* pSubDict = [pStockAy objectAtIndex:i];
        if (pSubDict == NULL || [pSubDict count] <= 0)
            continue;
        
        NSString* strCode = pStock.stockCode;
        strCode = [strCode stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString* strCurrent = [pSubDict tztObjectForKey:@"Code"];
        strCurrent = [strCurrent stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (g_tztUserStock.bUseNewUserStock)
        {
            if (([strCode compare:strCurrent] == NSOrderedSame)
                && (pStock.stockType == [[pSubDict tztObjectForKey:@"StockType"] intValue]
                    || [[pSubDict tztObjectForKey:@"StockType"] intValue] == 0) )
            {
                iIndex = i;
                break;
            }
        }
        else
        {
            if ([strCode compare:strCurrent] == NSOrderedSame)
            {
                iIndex = i;
                break;
            }
        }
        
    }
    return iIndex;
}


+(void)UploadUserStock
{
    [self UploadUserStock:FALSE];
}

//上传至服务器
+(void)UploadUserStock:(BOOL)bShowBox
{
    [tztUserStock initShareClass];
    if (bShowBox)
    {
        TZTUIMessageBox *pBox = [[TZTUIMessageBox alloc] initWithFrame:[UIScreen mainScreen].bounds nBoxType_:TZTBoxTypeButtonBoth delegate_:g_tztUserStock];
        pBox.m_nsTitle = @"自选股云同步";
        pBox.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        pBox.m_nsContent = @"确定要将手机本地自选股上传至服务器，且覆盖服务器原有自选股?";
        pBox.tag = 0x1213;
        [pBox showForView:nil];
        if (!IS_TZTIPAD)
            [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:pBox];
        [pBox release];
    }
    else
    {
        [g_tztUserStock Upload];  
    }
}

//下载自选股
+(void)DownloadUserStock
{
    [tztUserStock initShareClass];
    TZTUIMessageBox *pBox = [[TZTUIMessageBox alloc] initWithFrame:[UIScreen mainScreen].bounds nBoxType_:TZTBoxTypeButtonBoth delegate_:g_tztUserStock];
    pBox.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    pBox.m_nsTitle = @"自选股云同步";
    pBox.m_nsContent = @"确定将服务器中自选股下载至手机，且覆盖手机本地自选股?";
    pBox.tag = 0x1212;
    [pBox showForView:nil];
    if (!IS_TZTIPAD)
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:pBox];
    [pBox release];
}

//合并自选
+(void)MergerUserStock
{
    [tztUserStock initShareClass];
    TZTUIMessageBox *pBox = [[TZTUIMessageBox alloc] initWithFrame:[UIScreen mainScreen].bounds nBoxType_:TZTBoxTypeButtonBoth delegate_:g_tztUserStock];
    pBox.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    pBox.m_nsTitle = @"自选股云同步";
    pBox.m_nsContent = @"确定将手机本地自选股和服务器自选股进行合并?";
    pBox.tag = 0x1214;
    [pBox showForView:nil];
    if (!IS_TZTIPAD)
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:pBox];
    [pBox release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1212://下载自选
            {
                [self Download];
            }
                break;
            case 0x1213://上传自选
            {
                [self Upload];
            }
                break;
            case 0x1214://合并自选
            {
                [self Merger];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1212://下载自选
            {
                [self Download];
            }
                break;
            case 0x1213://上传自选
            {
                [self Upload];
            }
                break;
            case 0x1214://合并自选
            {
                [self Merger];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)Upload
{
    _bShowTips = YES;
    if (g_tztUserStock.bUseNewUserStock)
    {
        //获取本地代码
        NSMutableData *pData = NewObject(NSMutableData);
        NSString *strCode = [tztUserStock GetNSUserStock];
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqno++;
        if (_ntztReqno >= UINT16_MAX)
            _ntztReqno = 1;
        
        //strCode = [[NSString alloc] initWithData:pData encoding:NSASCIIStringEncoding];
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqno);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        [pDict setTztValue:@"2" forKey:@"Direction"];//0－新增 1－删除 2-覆盖
        [pDict setTztValue:@"999" forKey:@"Volume"];//插入位置0，或者很大，标识插入到最后
        [pDict setTztValue:@"0" forKey:@"ErrorNo"];
        [pDict setTztValue:@"10" forKey:@"AccountType"];
        if (self.nsAccount.length > 0)
        {
            [pDict setTztValue:self.nsAccount forKey:@"Account"];
        }
        else
        {
    //        if ([tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType] && [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount)
    //        {
    //            [pDict setTztValue:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount forKey:@"Account"];
    //        }
        }
        NSString* str = [pDict tztObjectForKey:@"Account"];
        if (str.length > 0)
        {
            NSString* strKey = [NSString stringWithFormat:@"%@-%@", tztPID, str];
            NSString* strValue = [tztKeyChain load:strKey];
            
            if (strValue)
                [pDict setTztValue:strValue forKey:@"Price"];
        }
        
        if (strCode)
            [pDict setTztObject:strCode forKey:@"Grid"];
        
        [pDict setTztValue:@"QBI" forKey:@"Title"];
        
        [[tztMoblieStockComm getShareInstance:nTokenType] onSendDataAction:@"55" withDictValue:pDict];
        [pData release];
        [pDict release];
    }
    else
    {
        //获取本地代码
        NSArray *pAy = [tztUserStock GetUserStockArray];
        NSMutableData *pData = NewObject(NSMutableData);
        NSString *strCode = @"";
        for (int i = 0; i < [pAy count]; i++)
        {
            NSMutableDictionary *pStock = [pAy objectAtIndex:i];
            if (pStock == NULL || [pStock tztObjectForKey:@"Code"] == NULL)
                continue;
            NSString* strCode = [pStock tztObjectForKey:@"Code"];
            NSInteger nCodeLen = MIN(6,[strCode length]);
            [pData appendBytes:[strCode UTF8String] length:nCodeLen];
            if(nCodeLen < 6)
               [pData appendBytes:[@"            " UTF8String] length:(6-nCodeLen)];
        }
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqno++;
        if (_ntztReqno >= UINT16_MAX)
            _ntztReqno = 1;
        
        //strCode = [[NSString alloc] initWithData:pData encoding:NSASCIIStringEncoding];
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqno);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        [pDict setTztValue:@"0" forKey:@"Direction"];//0－新增 1－删除
        [pDict setTztValue:@"999" forKey:@"Volume"];//插入位置0，或者很大，标识插入到最后
        [pDict setTztObject:pData forKey:@"Grid"];
        [[tztMoblieStockComm getShareInstance:nTokenType] onSendDataAction:@"41" withDictValue:pDict];
        [pData release];
        [strCode release];
        [pDict release];
    }
}

-(void)Download
{
    [self Download:YES];
}

-(void)Download:(BOOL)bShowTips
{
    _bShowTips = bShowTips;
    //若当前没有手机号，或者没有account(华泰)不下载，直接读取配置文件默认配置
    NSString* strLogMobile = [tztKeyChain load:tztLogMobile];
    if (strLogMobile == NULL || strLogMobile.length < 1)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqno++;
    if (_ntztReqno >= UINT16_MAX)
        _ntztReqno = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqno);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"ErrorNo"];//分组号
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"200" forKey:@"MaxCount"];
    
//    [pDict setTztValue:@"1" forKey:@"Direction"];//0－逆序 1－正序
//    [pDict setTztValue:@"56" forKey:@"StockIndex"];
//    [pDict setTztObject:@"9" forKey:@"AccountIndex"];
    [pDict setTztObject:@"10" forKey:@"AccountType"];
    if (self.nsAccount > 0)
    {
        [pDict setTztValue:self.nsAccount forKey:@"Account"];
    }
    else
    {
//        if ([tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType] && [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount)
//        {
//            [pDict setTztValue:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount forKey:@"Account"];
//        }
    }
    NSString* str = [pDict tztObjectForKey:@"Account"];
    if (str.length > 0)
    {
        NSString* strKey = [NSString stringWithFormat:@"%@-%@", tztPID, str];
        NSString* strValue = [tztKeyChain load:strKey];
        
        if (strValue)
            [pDict setTztValue:strValue forKey:@"Price"];
    }

    
    [pDict setTztValue:@"QBI" forKey:@"Title"];
    
    [[tztMoblieStockComm getShareInstance:nTokenType] onSendDataAction:@"56" withDictValue:pDict];
    [pDict release];
}

-(void)Merger
{
    [self Merger:YES];
}

-(void)Merger:(BOOL)bShowTips //自选股合并
{
    _bShowTips = bShowTips;
    if (g_tztUserStock.bUseNewUserStock)
    {
        //获取本地代码
        NSMutableData *pData = NewObject(NSMutableData);
        NSString *strCode = [tztUserStock GetNSUserStock];
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqno++;
        if (_ntztReqno >= UINT16_MAX)
            _ntztReqno = 1;
        
        //strCode = [[NSString alloc] initWithData:pData encoding:NSASCIIStringEncoding];
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqno);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        [pDict setTztValue:@"3" forKey:@"Direction"];//0－新增 1－删除 2-覆盖 3-合并
        [pDict setTztValue:@"999" forKey:@"Volume"];//插入位置0，或者很大，标识插入到最后
        [pDict setTztValue:@"0" forKey:@"ErrorNo"];
        [pDict setTztValue:@"10" forKey:@"AccountType"];
        [pDict setTztObject:@"1000" forKey:@"MaxCount"];
        if (self.nsAccount.length > 0)
        {
            [pDict setTztValue:self.nsAccount forKey:@"Account"];
        }
        else
        {
    //        if ([tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType] && [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount)
    //        {
    //            [pDict setTztValue:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount forKey:@"Account"];
    //        }
        }
        NSString* str = [pDict tztObjectForKey:@"Account"];
        if (str.length > 0)
        {
            NSString* strKey = [NSString stringWithFormat:@"%@-%@", tztPID, str];
            NSString* strValue = [tztKeyChain load:strKey];
            
            if (strValue)
                [pDict setTztValue:strValue forKey:@"Price"];
        }

        if (strCode)
            [pDict setTztObject:strCode forKey:@"Grid"];
        
        [pDict setTztValue:@"QBI" forKey:@"Title"];
        
        [[tztMoblieStockComm getShareInstance:nTokenType] onSendDataAction:@"55" withDictValue:pDict];
        [pData release];
        [pDict release];
    }
    else
    {
        //获取本地代码
        NSString *strCode =[tztUserStock GetNSUserStock];
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqno++;
        if (_ntztReqno >= UINT16_MAX)
            _ntztReqno = 1;
        
        NSString* strReqno = tztKeyReqno((long)self, _ntztReqno);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        [pDict setTztValue:@"0" forKey:@"Direction"];//0－新增 1－删除
        [pDict setTztValue:@"0" forKey:@"Volume"];//插入位置0，或者很大，标识插入到最后
        [pDict setTztObject:strCode forKey:@"Grid"];
        [[tztMoblieStockComm getShareInstance:nTokenType] onSendDataAction:@"47" withDictValue:pDict];
        [pDict release];
    }
}

+(NSString*)GetNSUserStock:(BOOL)bStockType
{
    NSMutableArray *pStockAy = (NSMutableArray*)[tztUserStock GetUserStockArray];
    if(pStockAy == NULL || [pStockAy count] <= 0)
    {
        BOOL bClearAll = FALSE;
        
        NSString* str = [g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_UserStockClearAll];
        if (ISNSStringValid(str))
        {
            bClearAll = ([str intValue] > 0);
        }
        if (bClearAll)
            return @"";
        //        NSString* strLogMobile = [tztKeyChain load:tztLogMobile];
        //        if ((strLogMobile < 1) && [TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
        {
            pStockAy = (NSMutableArray*)[g_pSystermConfig ayDefaultUserStock];
            [tztUserStock SaveUserStockArray:pStockAy];
        }
        
        if ([pStockAy count] < 1)
            return @"";
    }
    
    [pStockAy retain];
    NSString* strReturn = @"";
    for (int i = 0; i < [pStockAy count]; i++)
    {
        NSMutableDictionary* pDict = [pStockAy objectAtIndex:i];
        if (pDict == NULL || [pDict count] <= 0)
            continue;
        if ([strReturn length] <= 0)
        {
            if (g_tztUserStock.bUseNewUserStock)
            {
                if (bStockType)
                    strReturn = [NSString stringWithFormat:@"%@|%@", [pDict tztObjectForKey:@"Code"], [pDict tztObjectForKey:@"StockType"]];
                else
                    strReturn = [NSString stringWithFormat:@"%@",[pDict tztObjectForKey:@"Code"]];
            }
            else
                strReturn = [NSString stringWithFormat:@"%@",[pDict tztObjectForKey:@"Code"]];
        }
        else
        {
            if (g_tztUserStock.bUseNewUserStock)
            {
                if (bStockType)
                    strReturn = [NSString stringWithFormat:@"%@,%@|%@",strReturn, [pDict tztObjectForKey:@"Code"], [pDict tztObjectForKey:@"StockType"]];
                else
                    strReturn = [NSString stringWithFormat:@"%@,%@",strReturn, [pDict tztObjectForKey:@"Code"]];
            }
            else
                strReturn = [NSString stringWithFormat:@"%@,%@",strReturn, [pDict tztObjectForKey:@"Code"]];
        }
    }
    [pStockAy release];
    return strReturn;
    
}

+(NSString*)GetNSUserStock
{
    return [tztUserStock GetNSUserStock:YES];
}

+(NSString*)GetNSRecentStock
{
    NSMutableArray *pStockAy = GetArrayByListName(tztRecentStockPlistNew);
    if (pStockAy == NULL)
    {
        //读取老版本
        NSMutableArray *pArray = GetArrayByListName(tztRecentStockPlist);
        pStockAy = NewObjectAutoD(NSMutableArray);
        
        for (int i = 0; i < [pArray count]; i++)
        {
            NSString* strStockCode = [pArray objectAtIndex:i];
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strStockCode forKey:@"Code"];
            [pStockAy addObject:pDict];
            DelObject(pDict);
        }
        
        NSString *tztPath = GetPathWithListName(tztRecentStockPlist,NO);
        [tztPath tztfiledelete];
        SetArrayByListName(pStockAy,tztRecentStockPlistNew);
    }
    [pStockAy retain];
    NSString* strReturn = @"";
    for (int i = 0; i < [pStockAy count]; i++)
    {
        NSMutableDictionary* pDict = [pStockAy objectAtIndex:i];
        if (pDict == NULL || [pDict count] <= 0)
            continue;
        if ([strReturn length] <= 0)
        {
            if (g_tztUserStock.bUseNewUserStock)
                strReturn = [NSString stringWithFormat:@"%@|%@", [pDict tztObjectForKey:@"Code"], [pDict tztObjectForKey:@"StockType"]];
            else
                strReturn = [NSString stringWithFormat:@"%@", [pDict tztObjectForKey:@"Code"]];
        }
        else
        {
            if (g_tztUserStock.bUseNewUserStock)
                strReturn = [NSString stringWithFormat:@"%@,%@|%@",strReturn, [pDict tztObjectForKey:@"Code"], [pDict tztObjectForKey:@"StockType"]];
            else
                strReturn = [NSString stringWithFormat:@"%@,%@",strReturn, [pDict tztObjectForKey:@"Code"]];
        }
    }
    [pStockAy release];
    
    return strReturn;
}

+(void)postRecentStockChange
{
    if (!IS_TZTIPAD)
        return;
    NSNotification* pNotifi = [NSNotification notificationWithName:tztRectStockNotificationName object:nil];
	[[NSNotificationCenter defaultCenter] postNotification:pNotifi];
}

//加入最近浏览
+(void)AddRecentStock:(tztStockInfo*)pStock
{
    if(pStock == nil || ![pStock isVaildStock])
        return;
    
    NSMutableArray *pStockAy = GetArrayByListName(tztRecentStockPlistNew);
    if (pStockAy == NULL)//新的没有取道数据，取老版本的文件
    {
        //读取老版本
        NSMutableArray *pArray = GetArrayByListName(tztRecentStockPlist);
        pStockAy = NewObjectAutoD(NSMutableArray);
        
        for (int i = 0; i < [pArray count]; i++)
        {
            NSString* strStockCode = [pArray objectAtIndex:i];
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strStockCode forKey:@"Code"];
            [pStockAy addObject:pDict];
            DelObject(pDict);
        }
        
        NSString *tztPath = GetPathWithListName(tztRecentStockPlist,NO);
        [tztPath tztfiledelete];
    }
    
    {
        int nIndex = -1;
        for (int i = 0; i < [pStockAy count]; i++)
        {
            NSMutableDictionary* pSubDict = [pStockAy objectAtIndex:i];
            if (pSubDict == NULL || [pSubDict count] <= 0)
                continue;
            
            NSString* strType = [pSubDict tztObjectForKey:@"StockType"];
            if ([pStock.stockCode compare:[pSubDict tztObjectForKey:@"Code"]] == NSOrderedSame && ([strType intValue] == 0 || ( strType == NULL) || ( pStock.stockType == [strType intValue])))
            {
                nIndex = i;
                break;
            }
        }
        if (nIndex >= 0 && nIndex < [pStockAy count])
        {
            [pStockAy removeObjectAtIndex:nIndex];
        }
    }
    NSMutableDictionary *pStockDict = [pStock GetStockDict];
    [pStockAy insertObject:pStockDict atIndex:0];
    SetArrayByListName(pStockAy,tztRecentStockPlistNew);
    [tztUserStock postRecentStockChange];
	
}

//清空最近浏览
+(void)ClearRecentStock
{
    NSMutableArray *pDict = GetArrayByListName(tztRecentStockPlistNew);
    if (pDict == NULL)
    {
        return;
    }
    [pDict removeAllObjects];
    SetArrayByListName(pDict,tztRecentStockPlist);
    
	[tztUserStock postRecentStockChange];
}

-(void)OnRequestUserHQData:(NSString*)strCode andCount_:(NSInteger)nCount
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqno++;
    if (_ntztReqno >= UINT16_MAX)
        _ntztReqno = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqno);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"9" forKey:@"AccountIndex"];
    [pDict setTztObject:@"0" forKey:@"DeviceType"];
    [pDict setTztObject:@"1" forKey:@"Direction"];
    [pDict setTztObject:@"1" forKey:@"NewMarketNo"];
    [pDict setTztObject:@"1" forKey:@"Lead"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1" forKey:@"StockIndex"];
    [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)nCount] forKey:@"MaxCount"];
    [pDict setTztObject:strCode forKey:@"Grid"];
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"60" withDictValue:pDict];
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL || ![pParse IsIphoneKey:(long)self reqno:_ntztReqno])
    {
        return 0;
    }
    
    if ([pParse GetErrorNo] < 0)//处理出错
    {
        return 0;
    }
    //提示信息
    if ([pParse GetAction] == 60)
    {
        NSInteger nCodeIndex = -1;
        NSInteger nNameIndex = -1;
        NSArray *ayGridVol = [pParse GetArrayByName:@"Grid"];
        NSString* strIndex = [pParse GetByName:@"stockcodeindex"];
        TZTStringToIndex(strIndex, nCodeIndex);
        
        strIndex = [pParse GetByName:@"stocknameindex"];
        TZTStringToIndex(strIndex, nNameIndex);
        
        NSString* strGridType = [pParse GetByName:@"NewMarketNo"];
        if (strGridType == NULL || strGridType.length < 1)
            strGridType = [pParse GetByName:@"DeviceType"];
        NSArray* ayGridType = [strGridType componentsSeparatedByString:@"|"];
        
        NSMutableArray *ayStockData = NewObject(NSMutableArray);
        for (int i = 1; i < [ayGridVol count]; i++)
        {
            NSArray* ayData = [ayGridVol objectAtIndex:i];
            if (nNameIndex < 0)
                nNameIndex = 0;
            if (nCodeIndex < 0)
                nCodeIndex = [ayData count] -1;
            
            NSString* strCode = @"";
            NSString* strName = @"";
            NSString* strStockType = @"0";
            if (i - 1 >= 0 && i-1<[ayGridType count])
                strStockType = [NSString stringWithFormat:@"%@", [ayGridType objectAtIndex:(i-1)]];
            
            for (int j = 0; j < ayData.count; j++)
            {
                if (j == nCodeIndex)
                {
                    strCode = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                }
                if (j == nNameIndex)
                {
                    strName = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    NSArray *ay = [strName componentsSeparatedByString:@"."];
                    if (ay.count > 1)
                        strName = [ay objectAtIndex:1];
                }
            }
            
            if (strCode.length <= 0)
                continue;
            NSMutableDictionary* pStockDict = NewObject(NSMutableDictionary);
            [pStockDict setTztObject:strCode forKey:@"Code"];
            if (strName == nil || strName.length <= 0)
                strName = strCode;
            [pStockDict setTztObject:strName forKey:@"Name"];
            if (strStockType)
                [pStockDict setTztObject:strStockType forKey:@"StockType"];
            
            [ayStockData addObject:pStockDict];
            DelObject(pStockDict);
        }
        
        [tztUserStock SaveUserStockArray:ayStockData post:YES];
    }
    if ([pParse GetAction] == 56 || [pParse GetAction] == 55)
    {
        int nCodeIndex = -1;
        int nNameIndex = -1;
        int nStockType = -1;
        
        NSDictionary* dict = @{tztLabelTextColor:[UIColor whiteColor]};
        NSArray* ayGridVol = [pParse GetArrayByName:@"Grid"];
        NSString *strIndex = [pParse GetByName:@"stocknameindex"];
        TZTStringToIndex(strIndex, nNameIndex);
        strIndex = [pParse GetByName:@"stockcodeindex"];
        TZTStringToIndex(strIndex, nCodeIndex);
        
        if ([pParse GetAction] == 55 && [ayGridVol count] <= 0)
        {
            if (_bShowTips)
            {
                if ([pParse GetErrorMessage].length > 0)
                    tztAfxMessageLabelWithArrtibutes([pParse GetErrorMessage], dict);
                else
                    tztAfxMessageLabelWithArrtibutes(@"操作成功", dict);
            }
            return 1;
        }
        NSMutableArray *ayStockData = NewObject(NSMutableArray);
        
        NSString* strCode = @"";
        for (NSInteger i = [ayGridVol count] - 1; i >= 0; i--)
        {
            NSArray *ayData = [ayGridVol objectAtIndex:i];
            if (nNameIndex < 0)
                nNameIndex = 0;
            if (nCodeIndex < 0)
            {
                nCodeIndex = 1;
                nStockType = 2;
            }
            NSMutableDictionary* pStockDict = NewObject(NSMutableDictionary);
            
            for (int j = 0; j < [ayData count]; j++)
            {
                if (j == nNameIndex)
                {
                    NSString* nsName = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    NSArray* pAy = [nsName componentsSeparatedByString:@"."];
                    if ([pAy count] > 1)
                    {
                        nsName = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
                    }
                    else
                    {
                        nsName = [NSString stringWithFormat:@"%@", nsName];
                    }
                    [pStockDict setTztValue:nsName forKey:@"Name"];
                }
                if (j == nCodeIndex)
                {
                    NSString* strCode = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    [pStockDict setTztValue:strCode forKey:@"Code"];
                }
                if (j == nStockType)
                {
                    NSString *strType = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    [pStockDict setTztValue:strType forKey:@"StockType"];
                }
            }
            [ayStockData addObject:pStockDict];
            
            if (g_tztUserStock.bUseNewUserStock && [[pStockDict tztObjectForKey:@"StockType"] intValue] > 0)
            {
                if (strCode.length <= 0)
                    strCode = [NSString stringWithFormat:@"%@|%@", [pStockDict tztObjectForKey:@"Code"], [pStockDict tztObjectForKey:@"StockType"]];
                else
                    strCode = [NSString stringWithFormat:@"%@,%@|%@", strCode, [pStockDict tztObjectForKey:@"Code"], [pStockDict tztObjectForKey:@"StockType"]];
            }
            else
            {
                if (strCode.length <= 0)
                    strCode = [NSString stringWithFormat:@"%@",[pStockDict tztObjectForKey:@"Code"]];
                else
                    strCode = [NSString stringWithFormat:@"%@,%@",strCode, [pStockDict tztObjectForKey:@"Code"]];
            }
            
            [pStockDict release];
        }
        
        NSString* strNeedHQData = [g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_UserStockNeedHQ];
        if ([strNeedHQData intValue] > 0)
            [self OnRequestUserHQData:strCode andCount_:ayStockData.count];
        else
            [tztUserStock SaveUserStockArray:ayStockData post:YES];
        [ayStockData release];
        
        if (_bShowTips)
        {
            if ([pParse GetErrorMessage].length > 0)
                tztAfxMessageLabelWithArrtibutes([pParse GetErrorMessage], dict);
            else
                tztAfxMessageLabelWithArrtibutes(@"操作成功", dict);
        }
    }
//    NSString* str = [pParse GetErrorMessage];
    
#if 0
    UIAlertView* MacAlertView =
    [[UIAlertView alloc] initWithTitle:@"操作成功"
                               message:str
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    
    
    // Name field
    NSArray *subviews = MacAlertView.subviews;
    for(int i = 1 ; i < [subviews count]; i++)
    {
        UIView* pView = [subviews objectAtIndex:i];
        if ( [pView isKindOfClass:[UILabel class]])
            ((UILabel *)pView).textAlignment = NSTextAlignmentCenter;
    }
    [MacAlertView show];
    [MacAlertView release];
    
    return 0;
#else
//    TZTUIMessageBox *pBox = [[TZTUIMessageBox alloc] initWithFrame:[UIScreen mainScreen].bounds nBoxType_:TZTBoxTypeNoButton delegate_:self];
//    pBox.m_nsTitle = @"系统提示";
//    pBox.m_nsContent = @"操作成功";
//    [pBox showForView:nil];
//    if (!IS_TZTIPAD)
//        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:pBox];
//    [pBox release];
    return 1;
#endif
}

+ (void)readOldVersionUserStock
{
    NSMutableArray* ayUserStock = [tztUserStock GetUserStockArray];
    if(ayUserStock && [ayUserStock count] > 0)
        return;
#pragma	pack(1)
    typedef struct HQStockUserInfo
    {
        short	m_cCodeType;
        char		m_cCode[6];
        char		m_cStockName[16];
        char		m_cStockPYJC[16];
        long		m_lPrevClose;
        unsigned long		m_l5DayVol;
    }HQStockUserInfo;
    
    NSString* stockfile = GetDocumentPath(@"TztData/Block/UserStock.blk", FALSE);
    if(stockfile == nil || [stockfile length] <= 0)
    {
        return;
    }
    ayUserStock = NewObject(NSMutableArray);
    NSData* stockData = [NSData dataWithContentsOfFile:stockfile];
    HQStockUserInfo* pHQStock = (HQStockUserInfo *)[stockData bytes];
    NSInteger nCount = [stockData length] / sizeof(HQStockUserInfo);
    for (NSInteger i = 0; i < nCount && pHQStock; i++)
    {
        tztStockInfo* pStock = NewObject(tztStockInfo);
        NSString* strCode = [[NSString alloc] initWithBytes:pHQStock->m_cCode length:MIN(strlen(pHQStock->m_cCode),6) encoding:NSASCIIStringEncoding];
        pStock.stockCode = strCode;
        [strCode release];
        
        NSString* strName = [[NSString alloc] initWithBytes:pHQStock->m_cStockName length:MIN(strlen(pHQStock->m_cStockName),16) encoding:NSStringEncodingGBK];
        pStock.stockName = strName;
        [strName release];
        
        [ayUserStock addObject:[pStock GetStockDict]];
        [pStock release];
        pHQStock++;
    }
    if([ayUserStock count] > 0)
    {
        [tztUserStock SaveUserStockArray:ayUserStock];
    }
    [ayUserStock release];
    [stockfile tztfiledelete];
#pragma pack()
}

@end