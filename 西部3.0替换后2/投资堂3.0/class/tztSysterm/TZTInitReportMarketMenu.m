    /*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		TZTInitReportMarketMenu.m
 * 文件标识:
 * 摘要说明:		从MobileStock下载统一市场排名列表菜单
 *
 * 当前版本:	2.0
 * 作    者:	yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/


#import "TZTInitReportMarketMenu.h"

TZTInitReportMarketMenu* g_pReportMarket = NULL;

@interface TZTInitReportMarketMenu(TZTPrivate)
-(NSMutableDictionary*)GetParent:(NSMutableArray*)pAy nsParent_:(NSString*)nsParent nLevel_:(NSInteger*)nLevel;
-(void)initMarketData:(NSMutableDictionary*)pDict;
@end

@implementation TZTInitReportMarketMenu
@synthesize pReportMenu = _pReportMenu;
@synthesize pOutlineCell = _pOutlineCell;
@synthesize pOutlineList = _pOutlineList;
@synthesize strFileName = _strFileName;
@synthesize strGridDate = _strGridDate;
@synthesize strVersion = _strVersion;
@synthesize strVolume = _strVolume;
@synthesize strPushInfo = _strPushInfo;

//初始化对象
-(id)init
{
	self = [super init];
	if (nil != self)
	{
        //获取
		self.pReportMenu = GetDictByListName(@"tztMarketMenu");
        
		self.strGridDate = @"";
		self.strVolume = [self.pReportMenu objectForKey:@"Volume"];
		self.strVersion = [self.pReportMenu objectForKey:@"BankIndent"];
        if (self.strVersion == NULL || [self.strVersion length] <= 0)
        {
            self.strVersion = @"0.00";
        }
        [self initMarketData:self.pReportMenu];
		_nNewMenu = -1;
		
		_nMarketIndex = -1;
		_nMenuIDIndex = -1;
		_nMenuNameIndex = -1;
		_nParentIDIndex = -1;
		_nMenuType = -1;
		_nMenuPaixu = -1;
        _nSearchStockType = -1;
        _ntztReqNo = UINT16_MAX;
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
        [[tztMoblieStockComm getShareInstance] addObj:self];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tztCheckLogVolume:) name:@"tztCheckLogVolume" object:nil];
	}
	
	return self;
}

- (void)removeFromSuperview
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super removeFromSuperview];
}

-(void)dealloc
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NilObject(self.pReportMenu);
    NilObject(self.strVolume);
    NilObject(self.strVersion);
    NilObject(self.strGridDate);
    NilObject(self.strFileName);
	[super dealloc];
}

//请求市场菜单
-(int) RequestReportMarketMenu
{
    NSString* strVersion = @"";
    NSString* strVolume = @"";
    if (self.strVersion && [self.strVersion length] > 0)
        strVersion = self.strVersion;
    if (self.strVolume && [self.strVolume length] > 0) 
        strVolume = self.strVolume;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
//    _ntztReqNo++;
//    if (_ntztReqNo >= UINT16_MAX)
//        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:strVolume forKey:@"Volume"];
    [pDict setTztObject:strVersion forKey:@"BankIndent"];
    [pDict setTztObject:@"1" forKey:@"AccountType"];
    [pDict setTztObject:@"1" forKey:tztIphoneReSend];//重发
    
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20190" withDictValue:pDict];
    DelObject(pDict);
    return 0;
}

-(int) RequestHomePageData
{
    NSString* strCrc = @"";
    //读取配置文件
    NSMutableDictionary* pDataDict =  GetDictByListName(@"tztHomePagePlist");
    
    if (pDataDict && [pDataDict count] > 0 )
    {
        strCrc = [pDataDict tztObjectForKey:@"crc"];
    }
    
    //获取屏幕数据
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    //调试
    int nWidth = size_screen.width * scale_screen;
    int nHeight = size_screen.height * scale_screen;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
//    _ntztReqNo++;
//    if (_ntztReqNo >= UINT16_MAX)
//        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    if (strCrc)
        [pDict setTztObject:strCrc forKey:@"Crc"];
    
    [pDict setTztObject:[NSString stringWithFormat:@"%d",nWidth] forKey:@"Width"];
    [pDict setTztObject:[NSString stringWithFormat:@"%d",nHeight] forKey:@"Height"];
    
    [pDict setTztObject:@"1" forKey:tztIphoneReSend];//重发
    
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"28001" withDictValue:pDict];
    DelObject(pDict);
    return 0;
}

//请求公告信息url
/*
 ;东莞证券获取公告提示URL
 [44001]
 req=Reqno|MobileCode|MobileType|from|Cfrom|Tfrom|Token|ZLib|
 */
-(void)RequestInfoUrl
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
//    _ntztReqNo++;
//    if (_ntztReqNo >= UINT16_MAX)
//        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    
    [pDict setTztObject:@"1" forKey:tztIphoneReSend];//重发
    
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"44001" withDictValue:pDict];
    DelObject(pDict);
}

-(void)RequestLocation
{
#ifdef tzt_SendLocation
    //40128
    /*Longitude(经度) Latitude(纬度)    Height(高度)*/
    [tztNSLocation getShareClass].bHiddenTips = YES;
    [[tztNSLocation getShareClass] getLocation:^(NSString *strGpsX, NSString *strGpsY) {
        if (strGpsX == NULL)
            strGpsX = @"";
        if (strGpsY == NULL)
            strGpsY = @"";
        
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztObject:strReqno forKey:@"Reqno"];
        [pDict setTztObject:strGpsX forKey:@"Longitude"];
        [pDict setTztObject:strGpsY forKey:@"Latitude"];
        
        [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"40128" withDictValue:pDict];
        DelObject(pDict);
        
        [NSTimer scheduledTimerWithTimeInterval:10
                                         target:g_pReportMarket
                                       selector:@selector(RequestLocation)
                                       userInfo:nil
                                        repeats:NO];
    }];
#endif
}

-(NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    [self RequestUserBlockStock:_nStockNum];
    return 0;
}
/**/
-(void)RequestUserBlockStock:(int)nNum
{
    _nStockNum = nNum;
    //获取本地代码
    if (_nStockNum < 1)
        return;
    NSMutableArray *pStockAy = [tztUserStock GetUserStockArray];
    if(pStockAy == NULL || [pStockAy count] <= 0)
    {
        pStockAy = (NSMutableArray*)[g_pSystermConfig ayDefaultUserStock];
        [tztUserStock SaveUserStockArray:pStockAy];
    }
    if (pStockAy == NULL || [pStockAy count] <= 0)
        return;
    
    NSInteger nSize = MIN(nNum, [pStockAy count]);
    NSString* strReturn = @"";
    for (int i = 0; i < nSize; i++)
    {
        NSMutableDictionary* pDict = [pStockAy objectAtIndex:i];
        if (pDict == NULL || [pDict count] <= 0)
            continue;
        if ([strReturn length] <= 0)
        {
            if ([tztUserStock getShareClass].bUseNewUserStock)
                strReturn = [NSString stringWithFormat:@"%@|%@", [pDict tztObjectForKey:@"Code"], [pDict tztObjectForKey:@"StockType"]];
            else
                strReturn = [NSString stringWithFormat:@"%@",[pDict tztObjectForKey:@"Code"]];
        }
        else
        {
            if ([tztUserStock getShareClass].bUseNewUserStock)
                strReturn = [NSString stringWithFormat:@"%@,%@|%@",strReturn, [pDict tztObjectForKey:@"Code"], [pDict tztObjectForKey:@"StockType"]];
            else
                strReturn = [NSString stringWithFormat:@"%@,%@",strReturn, [pDict tztObjectForKey:@"Code"]];
        }
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
//    _ntztReqNo++;
//    if (_ntztReqNo >= UINT16_MAX)
//        _ntztReqNo = 1;
    
    _nSearchStockType = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztValue:strReturn forKey:@"Grid"];
    [pDict setTztValue:@"1" forKey:@"StockIndex"];
    [pDict setTztValue:@"1" forKey:@"NewMarketNo"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:[NSString stringWithFormat:@"%ld", (long)nSize] forKey:@"MaxCount"];
    [pDict setTztValue:@"9" forKey:@"AccountIndex"];
    [pDict setTztValue:@"0" forKey:@"Direction"];
    [pDict setTztValue:@"1" forKey:@"Lead"];
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"60" withDictValue:pDict];
    DelObject(pDict);
}

-(void)tztCheckLogVolume:(NSNotification*)noti
{
    [NSTimer scheduledTimerWithTimeInterval:0.2f
                                     target:self
                                   selector:@selector(RequestLogVolumeValid)
                                   userInfo:nil
                                    repeats:NO];
}

-(BOOL)RequestLogVolumeValid
{
    //获取账号，没有账号不处理
    tztZJAccountInfo *pZJAccount = tztGetCurrentAccountHKRight();
    if(pZJAccount == NULL || pZJAccount.nsAccount.length < 1)
    {
        //接收成功，发送条通知消息
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTNotifi_RequestLogVolume];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        return FALSE;
    }
    
    NSString* strAccount = pZJAccount.nsAccount;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:strAccount forKey:@"Account"];
    [pDict setTztObject:[NSString stringWithFormat:@"%ld",(long)pZJAccount.nLogVolume] forKey:@"CheckKEY"];
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"41081" withDictValue:pDict];
    DelObject(pDict);
    return TRUE;
}

//查询交易持仓
-(void)RequestTradeCCData
{
    if (![TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])
        return;
    tztJYLoginInfo *pJYLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (pJYLoginInfo == NULL)
        return;
    NSString* strAccount = pJYLoginInfo.ZjAccountInfo.nsAccount;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:strAccount forKey:@"Account"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"117" withDictValue:pDict];
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
//    if ([pParse GetErrorNo] < 0 && ![pParse IsAction:@"32"])
//    {
//        if ([pParse IsAction:@"20190"])//即使请求不成功，也要发送设备串
//        {
//            _bSendDeviceTokenSucc = FALSE;
//            [self sendDeviceToken];
//        }
//        return 0;
//    }
    if ([pParse IsAction:@"41081"])
    {
        
        //接收成功，发送条通知消息
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTNotifi_RequestLogVolume];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        
        if ([pParse GetErrorNo] < 0)
        {
            tztAfxMessageBox([pParse GetErrorMessage]);
        }
        
        NSString* strVolume = [pParse GetByName:@"Volume"];
        
        if (strVolume && [strVolume intValue] == 1)//还是最近登录，没有被踢，则不清空原来的logvolume
        {
            
        }
        else
        {
            tztZJAccountInfo *pZJAccount = tztGetCurrentAccountHKRight();
            if(pZJAccount == NULL || pZJAccount.nsAccount.length < 1)
                return 0;
            //清掉信息
            pZJAccount.nLogVolume = 0;
            //重新保存数据
            [pZJAccount SaveAccountInfo];
            [pZJAccount SaveCurrentData:TZTAccountCommLoginType withFileName_:@"tztCustomerFile"];
            [pZJAccount ReadLastSaveData:TZTAccountCommLoginType withFileName_:@"tztCustomerFile"];
        }
    }
    if ([pParse IsAction:@"28001"])
    {
        NSString* strCrc = [pParse GetByName:@"Crc"];
        NSString* strBgImage = [pParse GetByName:@"Bg_image"];
        NSArray* pGridAy = [pParse GetArrayByName:@"Grid"];
        
        //
        if (pGridAy == NULL || [pGridAy count] < 1)
        {
            //接收成功，发送条通知消息
            NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTOnInitDownloadHomePage];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            return 0;
        }
        
        //删除原有文件
//        
//        //读取配置文件
//        NSMutableDictionary* pDataDict =  GetDictByListName(@"/tztHomePage/tztHomePagePlist");
//        NSString* strFilePath = GetDocumentPath(@"/tztHomePage/tztHomePage.png", NO);
//        
        //获取路径对象
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"/tztHomePage/"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (plistPath && [plistPath length] > 0 && [plistPath FileExists])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            [fileManager removeItemAtPath:plistPath error:nil];
        }
        
        //不存在需要创建
        BOOL isDir = NO;
        BOOL existed = [fileManager fileExistsAtPath:plistPath isDirectory:&isDir];
        if ( !(isDir == YES && existed == YES) )
        {
            [fileManager createDirectoryAtPath:plistPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        plistPath = [documentsDirectory stringByAppendingPathComponent:@"/tztHomePage/tztHomePagePlist.plist"];
        
        //保存本地信息
        NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
        if (strCrc)
            [pDict setTztObject:strCrc forKey:@"crc"];
        if (strBgImage)
            [pDict setTztObject:strBgImage forKey:@"Bg_image"];
        if (pGridAy)
            [pDict setTztObject:pGridAy forKey:@"Grid"];
        
        //下载背景图
        UIImageView *pBGImageView = NewObjectAutoD(UIImageView);
        [pBGImageView setImageFromUrlEx:strBgImage atFile:@"/tztHomePage/tztHomePage.png"];
        
        NSMutableArray* pAyFuction = NewObject(NSMutableArray);
        //解析，下载文件数据
        for (int i = 0; i < [pGridAy count]; i++)
        {
            NSArray* pAy = [pGridAy objectAtIndex:i];
            if (pAy == NULL || [pAy count] < 3)
                continue;
//            //对应功能
            NSString* strFuction = [pAy objectAtIndex:0];
            //对应图片
            NSString* strPic = [pAy objectAtIndex:2];
            UIImageView *pImageView = NewObject(UIImageView);
            [pImageView setImageFromUrl:[NSString stringWithFormat:@"%@.png",strPic] atFile:[NSString stringWithFormat:@"/tztHomePage/%@.png", strFuction]];
            DelObject(pImageView);
            
        }
        
        [pDict setTztObject:pAyFuction forKey:@"Function"];
        
        [pDict writeToFile:plistPath atomically:YES];
        DelObject(pDict);
        //接收成功，发送条通知消息
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTOnInitDownloadHomePage];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            
        return 0;
    }
    if ([pParse IsAction:@"20190"] && [pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
    {
        NSString* nsVolume = [pParse GetByName:@"Volume"];
        NSString* nsVersion = [pParse GetByName:@"BankIndent"];
        //获取返回字段ErrorNo,用来判断是否要重新读取菜单,0-不返回(客户端菜单已是最新) 1-返回
        _nNewMenu = 0;
        _nNewMenu = [pParse GetErrorNo];
        
        //解析数据,目前返回没有索引，直接取默认的位置
        //若返回索引，需要相应解析
        _nMenuIDIndex = 0;		//菜单号
        _nParentIDIndex = 1;	//父类编号
        _nMenuNameIndex = 2;		//显示名称
        _nMarketIndex = 4;			//市场类型
        _nMenuType = 3;				//类型 排名还是板块 20191-排名 20192－板块 20193－自选
        _nMenuPaixu = 5;			//新增,默认排序顺序
        _nShowFlag = 8;             //新增，在排名列表中是否显示该菜单
        
        int nFirstMarket = 6;
        int nParentMarket = 7;
        //保存文件
        //存为plist文件格式
        NSMutableDictionary *pDictFile = NewObjectAutoD(NSMutableDictionary);
        NSMutableArray      *pAyTradeList = NewObjectAutoD(NSMutableArray);
        NSMutableArray      *pAySystemList = NewObjectAutoD(NSMutableArray);
        
        NSMutableArray  *pAy = nil;
//        NSMutableArray* pAyNext = nil;
//        
//        NSData *pGridData = [pParse GetNSData:@"Grid"];
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        if (pGridAy == NULL || [pGridAy count] < 1)
        {
            //接收成功，发送条通知消息
            NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTOnInitReportMarketInfo];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            return 1;
        }
        if (pGridAy)
        {
//            NSArray *pAyNext = nil;
            for (int i = 0; i < [pGridAy count]; i++)
            {
                pAy = [pGridAy objectAtIndex:i];
//                if (i < [pGridAy count] - 1)
//                    pAyNext = [pGridAy objectAtIndex:i+1];
                
                NSInteger nCount = [pAy count];
                if (pAy == NULL || nCount < 1)
                    continue;
                //判断索引有效性
                if ( _nMenuIDIndex < 0 || _nMenuIDIndex >= nCount
                    || _nMenuNameIndex < 0 || _nMenuNameIndex >= nCount
                    || _nParentIDIndex < 0 || _nParentIDIndex >= nCount
                    || _nMarketIndex < 0 || _nMarketIndex >= nCount
                    || _nMenuType < 0 || _nMenuType >= nCount
                    /*|| _nMenuPaixu < 0 || _nMenuPaixu >= nCount*/)
                    continue;
                
                NSMutableDictionary *pDictRow = NewObjectAutoD(NSMutableDictionary);
                NSString* strMenuID = [pAy objectAtIndex:_nMenuIDIndex];
                NSString* strMenuName = [pAy objectAtIndex:_nMenuNameIndex];
                NSString* strParentID = [pAy objectAtIndex:_nParentIDIndex];
                NSString* strMarket = [pAy objectAtIndex:_nMarketIndex];
                NSString* strType = [pAy objectAtIndex:_nMenuType];
                NSString* strPaixu = @"";
                NSString* strShowFlag = @"";
                if (_nMenuPaixu >= 0 && _nMenuPaixu < nCount)
                    strPaixu = [pAy objectAtIndex:_nMenuPaixu];
                if (_nShowFlag >= 0 && _nShowFlag < nCount)
                    strShowFlag = [pAy objectAtIndex:_nShowFlag];
                
                NSString* strFirst = @"";
                //子项默认进入的第一个市场编号
                if (nFirstMarket >= 0 && nFirstMarket < nCount)
                {
                    strFirst = [pAy objectAtIndex:nFirstMarket];
                }
                NSString* strParentMarket = @"";
                if (nParentMarket >= 0 && nParentMarket < nCount)
                {
                    strParentMarket = [pAy objectAtIndex:nParentMarket];
                }
//                NSString* strPaixu = [pAy objectAtIndex:_nMenuPaixu];
                NSString *nsFunction = [NSString stringWithFormat:@"%d", HQ_MENU_Report];
                
                switch ([strType intValue])
                {
                    case 20193:
                    {
                        strMarket = [NSString stringWithFormat:@"%d#%@", HQ_MENU_UserStock, strType];
                        if (strPaixu.length <= 0)
                            strPaixu = @"18";
                    }
                        break;
                    case 20198:
                    {
                        strMarket = [NSString stringWithFormat:@"%d#%@",HQ_MENU_IndexTrend, strType];
                        if (strPaixu.length <= 0)
                            strPaixu = @"18";
                    }
                        break;
                    case 60:
                    {
                        strMarket = [NSString stringWithFormat:@"%d#%@",HQ_MENU_RecentBrowse, strType];
                        if (strPaixu.length <= 0)
                            strPaixu = @"18";
                    }
                        break;
                    default:
                        strMarket = [NSString stringWithFormat:@"%@#%@", strMarket, strType];
                        break;
                }
                
                [pDictRow setValue:strMenuID forKey:@"Image"];
                [pDictRow setValue:@"1" forKey:@"Show"];
                [pDictRow setValue:@"0" forKey:@"Expanded"];
                
                //
                if ([strParentID intValue] != 0)
                {
                    NSInteger nLevel = 1;
                    NSMutableDictionary *pDict = [self GetParent:pAyTradeList nsParent_:strParentID nLevel_:&nLevel];
                    if (pDict)
                    {
                        NSMutableArray *pAyTemp = [pDict objectForKey:@"children"];
                        if (pAyTemp == nil)
                            pAyTemp = NewObjectAutoD(NSMutableArray);
                        [pDictRow setValue:[NSString stringWithFormat:@"%ld", (long)nLevel] forKey:@"Level"];
                        [pAyTemp addObject:pDictRow];
                        [pDict setValue:pAyTemp forKey:@"children"];
                    }
                }
                else
                {
                    [pAyTradeList addObject:pDictRow];
                }
                NSString* ns = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|||||TZTMenuCellColor.png|TZTMenuSelect.png|%@|%@|%@", strMenuID, strMenuName, nsFunction, strMarket,strPaixu, strFirst, strParentMarket, strShowFlag];
                if (!IS_TZTIPAD)
                    ns = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|||||26,26,26||%@|%@|%@", strMenuID, strMenuName, nsFunction, strMarket,strPaixu,strFirst, strParentMarket, strShowFlag];
                
                [pDictRow setValue:ns forKey:@"MenuData"];
                [pAySystemList addObject:ns];
            }
        }
        [pDictFile setValue:pAyTradeList forKey:@"tradelist"];
        [pDictFile setValue:pAySystemList forKey:@"system"];
        
        [pDictFile setValue:nsVolume forKey:@"Volume"];
        [pDictFile setValue:nsVersion forKey:@"BankIndent"];
        
        //获取路径对象
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"tztMarketMenu.plist"];
        [pDictFile writeToFile:plistPath atomically:YES];
        
        //刷新数据
		self.pReportMenu = GetDictByListName(@"tztMarketMenu");
		self.strGridDate = @"";
		self.strVolume = [self.pReportMenu objectForKey:@"Volume"];
		self.strVersion = [self.pReportMenu objectForKey:@"BankIndent"];
        [self initMarketData:self.pReportMenu];
        //接收成功，发送条通知消息
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTOnInitReportMarketInfo];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
    }
    if ([pParse IsAction:@"44001"])
    {
        NSString* nsUrl = [pParse GetByName:@"url"];
        if (nsUrl == NULL || [nsUrl length] < 1)
        {
            //接收成功，发送条通知消息
            NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTOnInitRequestUrl];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            return 0;
        }
        
        //获取当天日期
        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
        [outputFormat setDateFormat:@"yyyyMMdd"];
        
        NSDate *CurrentDate = [NSDate date];
        NSString* nsCurrentDate = [outputFormat stringFromDate:CurrentDate];
        int nCurrentDate = [nsCurrentDate intValue];
        [outputFormat release];
        if (nsCurrentDate == NULL || [nsCurrentDate length] < 1)
        {
            nsCurrentDate = @"";
        }
        
        NSString* nsCrc = [NSString stringWithFormat:@"%d",1];
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        [pDict setValue:nsUrl forKey:@"tztUrl"];
        [pDict setValue:nsCurrentDate forKey:@"date"];
        
        //读取配置文件
        NSMutableDictionary* pDataDict =  GetDictByListName(@"tztInfoTest");
        if (pDataDict)
        {
            nsCrc = [pDataDict objectForKey:@"crc"];
            NSString *nsTemp = [pDataDict objectForKey:@"tztUrl"];
            if (nsTemp && [nsUrl length] >1 && [nsTemp compare:nsUrl] != NSOrderedSame)
            {//如果链接有更新,弹出窗口
                nsCrc = [NSString stringWithFormat:@"%d",1];
            }
            
            //判断日期 大于保存的日期,设置弹出窗口
            NSString* nsSaveDate = [pDataDict objectForKey:@"date"];
            int nSaveDate = [nsSaveDate intValue];
            if (nCurrentDate > nSaveDate)
            {
                nsCrc = [NSString stringWithFormat:@"%d",1];
            }
        }
        [pDict setValue:nsCrc forKey:@"crc"];
        
        //获取路径对象
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //获取完整路径
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"tztInfoTest.plist"];
        
        [pDict writeToFile:plistPath atomically:YES];
        DelObject(pDict);
        
        //接收成功，发送条通知消息
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTOnInitRequestUrl];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        
        return 0;
    }
    if ([pParse IsAction:@"60"])
    {
        NSArray *ayGridVol = [pParse GetArrayByName:@"Grid"];
        NSInteger nNameIndex = 0;
        NSInteger nCodeIndex = -1;
        NSInteger nNewPriceIndex = 2;
        NSInteger nUpIndex = 1;
        
        if ([ayGridVol count] > 0)
        {
            NSArray *ayTitle = [ayGridVol objectAtIndex:0];
            for (NSInteger i = 0; i < [ayTitle count]; i++)
            {
                NSString* strColName = [ayTitle objectAtIndex:i];
                if (strColName && [strColName caseInsensitiveCompare:@"名称"] == NSOrderedSame)
                    nNameIndex = i;
                if (strColName && [strColName caseInsensitiveCompare:@"代码"] == NSOrderedSame)
                    nCodeIndex = i;
                if (strColName && [strColName caseInsensitiveCompare:@"最新"] == NSOrderedSame)
                    nNewPriceIndex = i;
                if (strColName && [strColName caseInsensitiveCompare:@"幅度"] == NSOrderedSame)
                    nUpIndex = i;
            }
        }
        
        NSMutableArray *pReturnAy = NewObject(NSMutableArray);
        
        NSString* strGridType = [pParse GetByName:@"NewMarketNo"];
        if (strGridType == NULL || strGridType.length < 1)
            strGridType = [pParse GetByName:@"DeviceType"];
        NSArray* ayGridType = [strGridType componentsSeparatedByString:@"|"];
        
        for (NSInteger i = 1; i < [ayGridVol count] ; i++)
        {
            NSArray *ayData = [ayGridVol objectAtIndex:i];
            if (nNameIndex < 0)
                nNameIndex = 0;
            if (nCodeIndex < 0)
                nCodeIndex = [ayData count] - 1;
            NSMutableArray *ayStock = NewObject(NSMutableArray);
            
            if ([ayGridType count] > i)
            {
//                NSString* nsType = [ayGridType objectAtIndex:i];
                [ayStock addObject:[ayGridType objectAtIndex:i]];
            }
            else
            {
                [ayStock addObject:@"0"];
            }
            
            NSString* nsName  =  @"";
            NSString* nsCode  =  @"";
            NSString* nsNewPrice = @"";
            NSString* nsUpValue = @"";
            for (NSInteger j = 0; j < [ayData count]; j++)
            {
                if (j == nNameIndex)
                {
                    nsName = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                    NSArray* pAy = [nsName componentsSeparatedByString:@"."];
                    if ([pAy count] > 1)
                    {
                        nsName = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
                    }
                    else
                    {
                        nsName = [NSString stringWithFormat:@"%@", nsName];
                    }
                }
                if (j == nCodeIndex)
                    nsCode = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (j == nNewPriceIndex)
                    nsNewPrice = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
                if (j == nUpIndex)
                    nsUpValue = [NSString stringWithFormat:@"%@", [ayData objectAtIndex:j]];
            }
            
            [ayStock addObject:nsCode];
            [ayStock addObject:nsName];
            [ayStock addObject:nsNewPrice];
            [ayStock addObject:nsUpValue];
            
            [pReturnAy addObject:ayStock];
            DelObject(ayStock);
        }
        
        NSDictionary *UserStockParams = [NSDictionary dictionaryWithObjectsAndKeys:pReturnAy, @"USERSTOCK", nil];
        if (g_pTZTDelegate && [g_pTZTDelegate respondsToSelector:@selector(callback:withParams:)])
        {
            [g_pTZTDelegate callback:self withParams:UserStockParams];
        }
        DelObject(pReturnAy);
    }
    if ([pParse IsAction:@"117"])
    {
        NSInteger nIndexCode = -1;//代码
        NSInteger nIndexCBJ = -1;//成本价
        NSInteger nIndexAmount = -1;//持仓数量
        
        NSString* strIndex = [pParse GetByName:@"STOCKINDEX"];
        TZTStringToIndex(strIndex, nIndexCode);
        
        strIndex = [pParse GetByName:@"KeepIndex"];
        TZTStringToIndex(strIndex, nIndexCBJ);
        
        strIndex = [pParse GetByName:@"STOCKNUMINDEX"];
        TZTStringToIndex(strIndex, nIndexAmount);
        
        NSInteger nMin = MIN(nIndexAmount, MIN(nIndexCBJ, nIndexCode));
        if (nMin < 0)
            return 0;
        
        NSMutableArray *ayGridData = NewObject(NSMutableArray);
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (NSInteger i = 0; i < ayGrid.count; i++)
        {
            NSArray* ayValue = [ayGrid objectAtIndex:i];
            NSString* strCode = [ayValue objectAtIndex:nIndexCode];
            if (!ISNSStringValid(strCode))//没有代码
                continue;
            
            NSString* strAmount = [ayValue objectAtIndex:nIndexAmount];
            if (!ISNSStringValid(strAmount))
                continue;
            NSString* strPrice = [ayValue objectAtIndex:nIndexCBJ];
            if (!ISNSStringValid(strPrice))
                continue;
            
            NSMutableDictionary* dict = NewObject(NSMutableDictionary);
            [dict setTztObject:strCode forKey:tztCode];
            [dict setTztObject:strAmount forKey:tztNowVolume];
            [dict setTztObject:strPrice forKey:tztNewPrice];
            [ayGridData addObject:dict];
            DelObject(dict);
        }
        
        [tztJYLoginInfo setTradeStockData:ayGridData];
    }
    
    return 0;
}

-(NSMutableDictionary*)GetParent:(NSMutableArray*)pAy nsParent_:(NSString*)nsParent nLevel_:(NSInteger*)nLevel
{
    if (pAy == NULL || [pAy count] < 1 || nsParent == NULL || [nsParent length] < 1)
        return NULL;
    
    if ([nsParent intValue] == 0)
        return NULL;
    
    NSMutableDictionary *pDictReturn = NULL;
    for (NSInteger i = 0; i < [pAy count]; i++)
    {
        NSMutableDictionary *pDict = [pAy objectAtIndex:i];
        NSString *nsComParent = [pDict objectForKey:@"Image"];
        NSMutableArray  *pSubAry = [pDict objectForKey:@"children"];
        if ([nsParent compare:nsComParent] == NSOrderedSame)
        {
            pDictReturn = pDict;
            *nLevel = 1;
            return pDictReturn;
        }
        else if(pSubAry)
        {
            NSInteger nCount = 0;
            pDictReturn = [self GetParent:pSubAry nsParent_:nsParent nLevel_:&nCount];
            *nLevel += nCount;
            if (pDictReturn)
            {
                return pDictReturn;
            }
        }
//        else
//            
    }
    return pDictReturn;
}

-(NSMutableArray*)GetSubMenuByParent:(NSInteger)nParentID start_:(NSInteger)nStart nPos_:(NSInteger*)nPos aySource_:(NSMutableArray*)aySource
{
    if (aySource == NULL || [aySource count] < 1 || [aySource count] < nStart) 
    {
        return NULL;
    }
    
    NSMutableArray* pAyReturn = NewObjectAutoD(NSMutableArray);
    
//    NSMutableArray *pParentAy = [aySource objectAtIndex:nStart];
    NSInteger nMenuCount = 0;//偏移计数
    
    for (NSInteger i = nStart; i < [aySource count]; i++)
    {
        NSMutableArray *pSubAy = [aySource objectAtIndex:i];
        
        if (pSubAy == NULL || [pSubAy count] < 1)
            continue;
        
        NSInteger nCount = [pSubAy count];
        if (nCount < 1)
            continue;
        
        //判断索引有效性
        if ( _nMenuIDIndex < 0 || _nMenuIDIndex >= nCount
            || _nMenuNameIndex < 0 || _nMenuNameIndex >= nCount
            || _nParentIDIndex < 0 || _nParentIDIndex >= nCount
            || _nMarketIndex < 0 || _nMarketIndex >= nCount
            || _nMenuType < 0 || _nMenuType >= nCount
            || _nMenuPaixu < 0 || _nMenuPaixu >= nCount)
            continue;
        
//        NSMutableArray *pNextAy = nil;
//        if ((i + 1) < [aySource count])
//        {
//            pNextAy = [aySource objectAtIndex:i+1];
//        }
        
        NSString* strParentID = [pSubAy objectAtIndex:_nParentIDIndex];
        int nSubParentID = -1;
        if (strParentID && [strParentID length] > 0)
            nSubParentID = [strParentID intValue];
        
        if (nSubParentID == nParentID)//属于统一个父类菜单，添加
        {
            nMenuCount++;
            //获取相关信息
            NSMutableDictionary *pDictRow = NewObjectAutoD(NSMutableDictionary);
            /*菜单ID*/
            NSString* strMenuID = [pSubAy objectAtIndex:_nMenuIDIndex];
            /*菜单显示名称*/
//            NSString* strMenuName = [pSubAy objectAtIndex:_nMenuNameIndex];
            /*父菜单ID*/
//            NSString* strParentID = [pSubAy objectAtIndex:_nParentIDIndex];
            /*市场类型／板块名称*/
//            NSString* strMarket = [pSubAy objectAtIndex:_nMarketIndex];
            
            NSString* nsMenuID = ((strMenuID && [strMenuID length] > 0) ? strMenuID :  @"");
            
            [pDictRow setValue:nsMenuID forKey:@"Image"];
            [pDictRow setValue:@"1" forKey:@"Show"];
            [pDictRow setValue:@"0" forKey:@"Expanded"];
            [pDictRow setValue:@"1" forKey:@"Level"];
            
            [pAyReturn addObject:pDictRow];
        }
        else
        {
            if (nSubParentID > nParentID)//不为0，可能是属于再下级的子菜单，继续遍历
            {
                nMenuCount++;
                NSInteger nCount = 0;
                NSMutableArray* pParentAy = [aySource objectAtIndex:i-1];
                
                //获取相关信息
                NSMutableDictionary *pDictRow = NewObjectAutoD(NSMutableDictionary);
                /*菜单ID*/
                NSString* strMenuID = [pParentAy objectAtIndex:_nMenuIDIndex];
                /*菜单显示名称*/
//                NSString* strMenuName = [pParentAy objectAtIndex:_nMenuNameIndex];
                /*父菜单ID*/
//                NSString* strParentID = [pParentAy objectAtIndex:_nParentIDIndex];
                /*市场类型／板块名称*/
//                NSString* strMarket = [pParentAy objectAtIndex:_nMarketIndex];
                NSString* nsMenuID = ((strMenuID && [strMenuID length] > 0) ? strMenuID :  @"");
                
                
                [pDictRow setValue:nsMenuID forKey:@"Image"];
                [pDictRow setValue:@"1" forKey:@"Show"];
                [pDictRow setValue:@"0" forKey:@"Expanded"];
                [pDictRow setValue:@"1" forKey:@"Level"];

                //遍历多级菜单
                NSMutableArray* pSubSubAy = [self GetSubMenuByParent:nSubParentID start_:i nPos_:&nCount aySource_:aySource];
                
                if (pSubSubAy && [pSubSubAy count] > 0)
                {
                    [pDictRow setValue:pSubSubAy forKey:@"children"];
                }
                if (nCount > 0)
                {
                    nMenuCount += nCount -1;
                    i+=nCount-1;
                }
                
                [pAyReturn addObject:pDictRow];
            }
        }   
    }
    *nPos  = nMenuCount;
    return pAyReturn;
}

//add by xyt 判断是否有新的菜单返回
-(BOOL) IsNewMenu
{
	if (_nNewMenu != 0) 
	{
		return TRUE;
	}
	return FALSE;
}

-(void)initMarketData:(NSMutableDictionary*)pDict
{
    if (pDict == NULL)
        return;
    
    if ([pDict objectForKey:@"tradelist"])
        _pOutlineList = [[NSArray alloc] initWithArray:[pDict objectForKey:@"tradelist"]];
    
    if ([pDict objectForKey:@"system"])
    {
        _pOutlineCell = NewObject(NSMutableDictionary);
        NSArray* aycell = [[[NSMutableArray alloc] initWithArray:[self.pReportMenu objectForKey:@"system"]] autorelease];
        for (int i = 0; i < [aycell count]; i++)
        {
            NSString* strcelldata = [aycell objectAtIndex:i];
            NSArray *aycelldate = [strcelldata componentsSeparatedByString:@"|"];
            if (aycelldate && [aycelldate count] > 0)
                [_pOutlineCell setObject:aycelldate forKey:[aycelldate objectAtIndex:0]];
        }
//        [aycell release];
    }
}

-(NSMutableDictionary*)GetSubMenuById:(NSMutableDictionary *)pMenuDict nsID_:(NSString *)nsID
{
    if (nsID == NULL || [nsID length] < 1)
    {
        return self.pReportMenu;
    }
    NSMutableDictionary *pCurrenctDict = pMenuDict;
    if (pMenuDict == nil)
    {
        if (self.pReportMenu == NULL)
        {
            self.pReportMenu = GetDictByListName(@"tztMarketMenu");
        }
        [self initMarketData:self.pReportMenu];
    }
    else
        [self initMarketData:pCurrenctDict];
    
    if (_pOutlineCell == NULL || _pOutlineList == NULL || [_pOutlineList count] < 1)
        return NULL;
    
    NSArray *pAyData = nil;
    NSMutableArray *pAyMenu = nil;
    nsID = [nsID lowercaseString];
    
    NSMutableDictionary *pDictReturn = NULL;
    for (int i = 0; i < [_pOutlineList count]; i++)
    {
        NSDictionary *pDict = [_pOutlineList objectAtIndex:i];
        if (pDict == NULL)
            continue;
        
        NSString* strCell = [pDict objectForKey:@"Image"];
        strCell = [strCell lowercaseString];
                
        if (strCell && [strCell caseInsensitiveCompare:nsID] == NSOrderedSame)//得到菜单
        {
            //得到子菜单
            if ([pDict objectForKey:@"children"]) 
            {
                pAyData = [[[NSArray alloc] initWithArray:[pDict objectForKey:@"children"]] autorelease];
            }
            
            if (pAyData && [pAyData count] > 0)
                pAyMenu = [[[NSMutableArray alloc] init] autorelease];
            else
            {
                NSMutableArray* pp = [[[NSMutableArray alloc] init] autorelease];
                [pp addObject:pDict];
                pAyData = [[[NSArray alloc] initWithArray:pp] autorelease];
                
                NSString* strMenuData = [pDict objectForKey:@"MenuData"];
                pAyMenu = [[[NSMutableArray alloc] init] autorelease];
                [pAyMenu addObject:strMenuData];
            }
         
            
            [self SetMenuData:pAyMenu _pDict:pDict];
            
            pDictReturn = [[[NSMutableDictionary alloc] init] autorelease];
            if (pAyData)
                [pDictReturn setObject:pAyData forKey:@"tradelist"];
            if (pAyMenu)
                [pDictReturn setObject:pAyMenu forKey:@"system"];
            if ([pDict objectForKey:@"MenuData"])
                [pDictReturn setObject:[pDict objectForKey:@"MenuData"] forKey:@"MenuData"];
            return pDictReturn;
        }
        else
        {
            if ([pDict objectForKey:@"children"]) 
            {
                NSDictionary * pSubDict = NULL;
                [self GetMenuData:&pSubDict _pDict:pDict nsID_:nsID];
                
                if (pSubDict)
                {
                    pAyData = [[[NSArray alloc] initWithArray:[pSubDict objectForKey:@"children"]] autorelease];
                    
                    if (pAyData && [pAyData count] > 0)
                        pAyMenu = [[[NSMutableArray alloc] init] autorelease];
                    else
                    {
                        NSMutableArray* pp = [[[NSMutableArray alloc] init] autorelease];
                        [pp addObject:pSubDict];
                        pAyData = [[[NSArray alloc] initWithArray:pp] autorelease];
                        
                        NSString* strMenuData = [pSubDict objectForKey:@"MenuData"];
                        pAyMenu = [[[NSMutableArray alloc] init] autorelease];
                        [pAyMenu addObject:strMenuData];
                    }
                    [self SetMenuData:pAyMenu _pDict:pDict];
                    
                    pDictReturn = [[[NSMutableDictionary alloc] init] autorelease];
                    if (pAyData)
                        [pDictReturn setObject:pAyData forKey:@"tradelist"];
                    if (pAyMenu)
                        [pDictReturn setObject:pAyMenu forKey:@"system"];
                    if ([pDict objectForKey:@"MenuData"])
                        [pDictReturn setObject:[pSubDict objectForKey:@"MenuData"] forKey:@"MenuData"];
                    return pDictReturn;
                }
            }
        }
    }
    
    return NULL;
}

-(BOOL)GetMenuData:(NSDictionary**)pReturnDict _pDict:(NSDictionary*)pDict nsID_:(NSString*)nsID
{
    if (pReturnDict == NULL || pDict == NULL || nsID == NULL)
        return FALSE;
    
    NSArray *pSubMenu = [[[NSArray alloc] initWithArray:[pDict objectForKey:@"children"]] autorelease];
    for (int i = 0; i < [pSubMenu count]; i++)
    {
        NSDictionary *pSubDict = [pSubMenu objectAtIndex:i];
        NSString* strKey = [pSubDict objectForKey:@"Image"];
        if ([nsID caseInsensitiveCompare:strKey] == NSOrderedSame)//找到相关菜单
        {
            *pReturnDict = pSubDict;
            return TRUE;
        }
        else
        {
            [self GetMenuData:pReturnDict _pDict:pSubDict nsID_:nsID];
        }
    }
    return FALSE;
}

-(void)SetMenuData:(NSMutableArray*)pAyMenu _pDict:(NSDictionary*)pDict
{
    if (pAyMenu == NULL)
        return;
    if ([pDict objectForKey:@"children"] == NULL)
        return;
    
    NSMutableArray *pAyData = [[[NSMutableArray alloc] initWithArray:[pDict objectForKey:@"children"]] autorelease];
    for (int i = 0; i < [pAyData count]; i++)
    {
        NSDictionary *pSubDict = [pAyData objectAtIndex:i];
        NSString* strKey = [pSubDict objectForKey:@"MenuData"];
        [pAyMenu addObject:strKey];
        if ([pSubDict objectForKey:@"children"])
        {
            [self SetMenuData:pAyMenu _pDict:pSubDict];
        }
    }
    
}

@end
