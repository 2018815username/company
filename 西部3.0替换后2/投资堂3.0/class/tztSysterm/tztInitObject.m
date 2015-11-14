//
//  tztInitObject.m
//  tztMobileApp_HTSC
//
//  Created by zztzt on 13-9-18.
//
//

#import "tztInitObject.h"
#import "TZTInitReportMarketMenu.h"
enum {
    TZTSysInitEx = 0, //初始化开始
	TZTSysJhActionEx, //均衡还是
	TZTSysJhFinishEx, //均衡结束
    TZTSysMarketInitEx,//市场列表开始
    TZTSysDownHomePageEx,//下载首页
    TZTSysRequestUrlEx,//请求公告url
	TZTSysInitEndEx,   //初始化结束
	TZTSysInitFinishEx,//初始化完成
};

@implementation tztInitObject
-(id)init
{
    if (self = [super init])
    {
        _nInitStep = TZTSysInitEx;
        _nStepCount = 0;
        [TZTAppObj getShareInstance];
        [tztUserStock readOldVersionUserStock];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(OnFinishAction:)
                                                     name:TZTNotifi_OnInitFinish
                                                   object:nil];
    }
    return self;
}

-(void)OpenInit:(BOOL)bShow
{
    if (bShow && g_pSystermConfig.bJHOpen)
    {
        [self OnJhInit];
    }
    else
    {
        [self OnJHFinish];
    }
}

-(void)OnJhInit
{
    _nStepCount = 0;
    if (g_pSystermConfig.bJHOpen)
    {
        [self OnGetTztJHAction];
    }
    else
    {
        [self OnJHFinish];
    }
}

//发送均衡请求
-(void)OnGetTztJHAction
{
	if(_nInitStep > TZTSysJhActionEx)
	{
		[self OnTimeOutAction];
		return;
	}
    
    _nInitStep = TZTSysJhActionEx;//发送均衡
	_nStepCount++;
    NSMutableArray* ayJhServer = [TZTServerListDeal getShareClass].ayJHAddList;
    if(ayJhServer == NULL || [ayJhServer count] <= 0 || _nStepCount > 2 * [ayJhServer count])
    {
        [self OnJHFinish];
        return;
    }
    [TZTServerListDeal getShareClass].nJHPort = [TZTCSystermConfig getShareClass].tztJHPort;
    if(_nStepCount > 1)
        [[TZTServerListDeal getShareClass] GetNextAddress:tztSession_ExchangeJH bRand_:FALSE];
    TZTNSLog(@"发送均衡 %d==%d",_nInitStep,_nStepCount);
    [tztMoblieStockComm freeSharejhInstance];
    [[tztMoblieStockComm getSharejhInstance] addObj:self];
    [[tztMoblieStockComm getSharejhInstance] onInitGCDDataSocket];
    return;
}

//均衡结束连接行情服务器
-(void)OnJHFinish
{
    if(_nInitStep > TZTSysJhFinishEx)
	{
		[self OnTimeOutAction];
		return ;
	}
    
    if (g_pSystermConfig && g_pSystermConfig.bJHOpen && [tztMoblieStockComm getjhInstance])
        [[tztMoblieStockComm getSharejhInstance] removeObj:self];
 	_nInitStep = TZTSysJhFinishEx;//均衡结束
	TZTNSLog(@"均衡结束 %d==%d",_nInitStep,_nStepCount);
    [TZTAppObj InitConnData];
    
	_nStepCount = 0;
	_nInitStep = TZTSysMarketInitEx;
	_nStepCount = 0;
    [self doRequestMarket];
}


//统一市场排名列表初始化
-(BOOL) doRequestMarket
{
	if (_nInitStep > TZTSysMarketInitEx)
    {
        [self OnTimeOutAction];
		return FALSE;
    }
    
	_nInitStep = TZTSysMarketInitEx;
	_nStepCount++;
	if (_nStepCount <= 1)
	{
		TZTNSLog(@"初始化排名列表 %d==%d", _nInitStep,_nStepCount);
		if (g_pReportMarket)
		{
            [self setupInitTimerWithTimeout:10];
			[g_pReportMarket RequestReportMarketMenu];
			return TRUE;
		}
	}
    _nInitStep = TZTSysDownHomePageEx;
    _nStepCount = 0;
    [self doDownloadHomePage];
	return FALSE;
}

-(BOOL) doDownloadHomePage
{
#ifdef tzt_DownloadHomePage
    if (_nInitStep > TZTSysDownHomePage)
    {
        [self OnTimeOutAction];
        return FALSE;
    }
    
    _nInitStep = TZTSysDownHomePage;
    _nStepCount++;
    if (_nStepCount <= 1)
    {
        TZTNSLog(@"初始化首页数据 %d==%d", _nInitStep, _nStepCount);
        if (g_pReportMarket)
        {
            [self setupInitTimerWithTimeout:10];
            [g_pReportMarket RequestHomePageData];
        }
        
        return TRUE;
    }
#else
    //请求公告url
    _nInitStep = TZTSysRequestUrlEx;
    _nStepCount = 0;
    [self  doRequestUrl];
    
#endif
    return FALSE;
}

-(BOOL) doRequestUrl
{
#ifdef tzt_RequestUrl
    if (_nInitStep > TZTSysRequestUrl)
    {
        [self OnTimeOutAction];
        return FALSE;
    }
    
    _nInitStep = TZTSysRequestUrl;
    _nStepCount++;
    if (_nStepCount <= 1)
    {
        TZTNSLog(@"请求公告url %d==%d", _nInitStep, _nStepCount);
        if (g_pReportMarket)
        {
            [self setupInitTimerWithTimeout:10];
            [g_pReportMarket RequestInfoUrl];
        }
        return TRUE;
    }
    
    _nInitStep = TZTSysInitEnd;
    [self OnFinish];
    return FALSE;
#endif
    _nInitStep = TZTSysInitEndEx;
    [self OnFinish];
    return FALSE;
}

//初始化完成
-(void)OnFinish
{
	if(_nInitStep == TZTSysInitFinishEx)
		return;
	_nInitStep = TZTSysInitEndEx;
	_nInitStep = TZTSysInitFinishEx;//均衡和初始化结束
	_nStepCount = 0;
	TZTNSLog(@"均衡和初始化结束 %d==%d",_nInitStep,_nStepCount);
    [[TZTAppObj getShareInstance] tztAppObjCallAppViewControl];
}

//初始化消息处理
-(void)OnFinishAction:(NSNotification*)notifaction
{
	if(notifaction && [notifaction.name compare:TZTNotifi_OnInitFinish]==NSOrderedSame)
	{
		NSString* nsFinish = (NSString*)notifaction.object;
        if([nsFinish compare:TZTOnInitReportMarketInfo] == NSOrderedSame)
        {
            _nStepCount = 0;
            [self doDownloadHomePage];
        }
        else if([nsFinish compare:TZTOnInitDownloadHomePage] == NSOrderedSame)
        {
            _nStepCount = 0;
            [self doRequestUrl];
        }
        else if([nsFinish compare:TZTOnInitRequestUrl] == NSOrderedSame)
        {
            _nStepCount = 0;
            [self OnFinish];
        }
        else if ([nsFinish compare:TZTOnInitStockCode] == NSOrderedSame)
        {
            [self OnFinish];
        }
        else if([nsFinish hasPrefix:TZTNotifi_OnConnectFail]) //是联网失败
        {
            int nexchange = [nsFinish intValue];
            NSArray *ay = [nsFinish componentsSeparatedByString:@"_"];
            if (ay && [ay count] > 1)
            {
                nexchange = [[ay objectAtIndex:1] intValue];
            }
            if(tztSessionType_IS(nexchange,tztSession_ExchangeJH))
            {
                if(_nInitStep == TZTSysJhActionEx)
                {
                    [self OnTimeOutAction];
                }
            }
            else if( _nInitStep > TZTSysJhFinishEx && _nInitStep < TZTSysInitEndEx)
            {
                [self OnTimeOutAction];
            }
        }
	}
}

-(void)OnTimeOutAction
{
	TZTNSLog(@"初始化超时处理 %d==%d",_nInitStep,_nStepCount);
	if(_nInitStep == TZTSysJhActionEx)//均衡状态
	{
		[self OnGetTztJHAction];
		return;
	}
	
	if (_nInitStep == TZTSysJhFinishEx) //均衡结束
	{
		[self OnJHFinish];
		return;
	}
	if(_nInitStep >= TZTSysInitEndEx) //初始化结束
	{
		[self OnFinish];
		return;
	}
    if (_nInitStep == TZTSysMarketInitEx)//统一市场列表
    {
        [self doRequestMarket];
        return;
    }
    if (_nInitStep == TZTSysDownHomePageEx)
    {
        [self doDownloadHomePage];
        return;
    }
    if (_nInitStep == TZTSysRequestUrlEx)
    {
        [self doRequestUrl];
        return;
    }
}

-(NSUInteger) OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if(_nInitStep >= TZTSysJhFinishEx)//均衡结束不再接收消息
        return 0;
    
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if ([pParse IsAction:@"25026"])//华西专用获取服务器地址，并进行测速计算排序
    {
        if ([pParse GetErrorNo] < 0)
        {
            [self OnJHFinish];
            return 0;
        }
        
        NSString* strServer = [pParse GetByName:@"Server"];
        if (strServer && [strServer length] > 0)
        {
            
        }
        [self OnJHFinish];
    }
    if ([pParse IsAction:@"2"] )
    {
        if ([pParse GetErrorNo] < 0)
        {
            [self OnJHFinish];
            return 0;
        }
        
        NSString* strServer = [pParse GetByName:@"Server"];
        if (strServer && [strServer length] > 0)
        {
            [[TZTServerListDeal getShareClass] SetServerList:strServer];
        }
        
        NSString* strJHServer = [pParse GetByName:@"ServerMr"];
        if (strJHServer && [strJHServer length] > 0)
            [[TZTServerListDeal getShareClass] SetTztJHServer:strJHServer];
        
        NSString* strDate = [pParse GetByName:@"BeginDate"];
        if (strDate && [strDate length] > 0)
        {
            [TZTServerListDeal SetJHSysDate:(int)[strDate longLongValue]];
        }
        
        NSString *strUpdateURL = [pParse GetByName:@"UpdateAddr"];
        if (strUpdateURL == NULL || [strUpdateURL length] <= 0)
        {
            strUpdateURL = @"";
        }
        //zxl 20130718 添加了均衡服务器处理
        NSString * strUpdateSign = [pParse GetByName:@"UpdateSign"];
        
        if (g_pTztUpdate == NULL)
            g_pTztUpdate = NewObject(tztUpdate);
        
        /*初始化界面能直接进入主界面，不在阻塞，所以纪录当前的信息用于升级使用*/
        NSString* pErrMsg = [pParse GetErrorMessage];
        g_pTztUpdate.nUpdateSin = [strUpdateSign intValue];
        g_pTztUpdate.nsTips = [NSString stringWithFormat:@"%@", pErrMsg];
        g_pTztUpdate.nsUpdateURL = [NSString stringWithFormat:@"%@", strUpdateURL];
        
        [self OnJHFinish];
    }
    return 1;
}


- (void)setupInitTimerWithTimeout:(NSTimeInterval)timeout
{
	if (_initTimer)
	{
		dispatch_source_cancel(_initTimer);
		_initTimer = NULL;
	}
	if (timeout >= 0.0)
	{
		_initTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
		dispatch_source_set_event_handler(_initTimer, ^{ @autoreleasepool {
            //超时----------------------------------------
            [self initTimeOut];
            //---------------------------------------------------
            
		}});
		
		dispatch_source_t theInitTimer = _initTimer;
		dispatch_source_set_cancel_handler(_initTimer, ^{
			dispatch_release(theInitTimer);
		});
		
		dispatch_time_t tt = dispatch_time(DISPATCH_TIME_NOW, (timeout * NSEC_PER_SEC));
		
		dispatch_source_set_timer(_initTimer, tt, DISPATCH_TIME_FOREVER, timeout/10);
		dispatch_resume(_initTimer);
	}
}

- (void)initTimeOut
{
    dispatch_block_t block = ^{ @autoreleasepool
        {
            [self OnTimeOutAction];
        }};
    
    if (dispatch_get_current_queue() == dispatch_get_main_queue())
        block();
    else
        dispatch_sync(dispatch_get_main_queue(), block);
}
@end
