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

#import "TZTInitViewController.h"
#import "TZTInitReportMarketMenu.h"
#import <tztControl/TZTSystermConfig.h>
#ifdef tzt_LocalStock
#import "tztInitStockCode.h"
#endif

@interface TZTInitViewController() <tztSocketDataDelegate>
{
    dispatch_source_t _sendTimer;
    __block BOOL _bJHLoop;
    __block int _nJHCount;
    __block int _nJHMax;
}
@end

@implementation TZTInitViewController
@synthesize nsUpdateURL = _nsUpdateURL;

- (id) init 
{
    if (self = [super init]) 
    {
		_nInitStep = TZTSysInit;
		_nStepCount = 0;
        self.nsUpdateURL = @"";
        [TZTAppObj getShareInstance];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnFinishAction:) name:TZTNotifi_OnInitFinish object:nil];
    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [tztUserStock readOldVersionUserStock];
    if(g_pSystermConfig && g_pSystermConfig.strCompanyName && [g_pSystermConfig.strCompanyName length] > 0)
        self.title = [NSString stringWithFormat:@"%@", g_pSystermConfig.strCompanyName];
    else {
        self.title = @"投资堂";
    }
    
	[[UIApplication sharedApplication] setStatusBarHidden:YES ];
	self.view.backgroundColor = [UIColor blackColor];
    CGRect rcFrame = CGRectZero;
    if (IS_TZTIPAD)
    {
        if (self.interfaceOrientation == UIDeviceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
        {
            rcFrame = self.view.frame;
        }
        else
        {
#ifdef __IPHONE_8_0
            if (IS_TZTIOS(8))
                rcFrame = self.view.frame;
            else
                rcFrame = CGRectMake(0, 0, TZTScreenHeight, TZTScreenWidth);
#else
                rcFrame = CGRectMake(0, 0, TZTScreenHeight, TZTScreenWidth);
#endif
        }
    }
    else
    {
        rcFrame = self.view.frame;
    }
//    if (IS_TZTIPAD && UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
//    {
//        rcFrame = CGRectMake(0, 0, TZTScreenHeight, TZTScreenWidth);
//    }else
//        rcFrame = self.view.frame;
    if (_pInitView == NULL)
    {
        _pInitView = [[tztInitView alloc]initWithFrame:rcFrame];
        _pInitView.backgroundColor = [UIColor blackColor];
        _pInitView.tztdelegate = self;
        _pInitView.alpha = 0;
        [self.view addSubview:_pInitView];
        [_pInitView release];
    }
	_pInitView.alpha = 1;
	[self.view bringSubviewToFront:_pInitView];
}

//没有工具条，继承下空实现即可
-(void)CreateToolBar
{
    
}

-(void)LoadLayoutView
{
    CGRect rcFrame = self.view.frame;
    if (_pInitView)
    {
        _pInitView.frame = rcFrame;
    }
}

//增加第一次打开的免责条款显示，该函数作出修改，外部调用，原先的界面设置放到viewDidLoad中
-(void) OpenInit:(BOOL)bShow
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

//免责返回处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //确定开始均衡处理
    {
        if (g_pSystermConfig.bJHOpen)
        {
            [self OnJhInit];
        }
        else
        {
            [self OnJHFinish];
        }
    }
//	else 
//    {
//		[self exitApplication];
//	}
}

//初始化
-(void)OnInit
{
    if(_pInitView)
    {
#ifndef tzt_GJSC
        [_pInitView setTipText:@"正在初始化数据..."];
#endif
    }
}

//动画结束退出程序
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {    
    if ([animationID compare:@"exitApplication"] == 0) {    
        exit(0);    
    }  
} 

//退出程序增加动画
- (void)exitApplication 
{    
//    [UIView beginAnimations:@"exitApplication" context:nil];    
//    [UIView setAnimationDuration:0.5];    
//    [UIView setAnimationDelegate:self];    
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];    
//    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];    
//    self.view.bounds = CGRectMake(0, 0, 0, 0);    
//    [UIView commitAnimations];    
}  



//均衡初始化
-(void) OnJhInit
{
	_nStepCount = 0;
	if(g_pSystermConfig.bJHOpen)
	{
        //判断是否启动均衡且配置了均衡服务器列表
        if(g_pSystermConfig.bJHOpen && [[[TZTServerListDeal getShareClass] GetJHAddress] length] > 0)
        {
            //是否已有均衡服务器地址
            if([TZTServerListDeal getShareClass].ayJHAddList == nil || [[TZTServerListDeal getShareClass].ayJHAddList count] <= 0)
            {
                [[TZTServerListDeal getShareClass] SetTztJHServer:g_pSystermConfig.tztJHServer];
            }
            //发送均衡功能
            [[TZTServerListDeal getShareClass] onSendJHAction:^
             {
                 //开户地址设置和交易分开
                 [tztMoblieStockComm freeAllInstanceSocket];
                 [[tztMoblieStockComm getSharekhInstance] onInitGCDDataSocket];
                 [[tztMoblieStockComm getSharezxInstance] onInitGCDDataSocket];
                 [[tztMoblieStockComm getShareInstance] onInitGCDDataSocket];
                  [[tztMoblieStockComm getSharehqInstance] onInitGCDDataSocket];
             }];
        }
        
        [self OnJHFinish];

//		[self OnGetTztJHAction];
	}
	else 
    {
		[self OnJHFinish];
	}
	return;
}

- (void)endsendTimer
{
	if (_sendTimer)
	{
		dispatch_source_cancel(_sendTimer);
		_sendTimer = nil;
	}
}


- (void)SendJHActionWithTime:(NSTimeInterval)timesend
{
    [self endsendTimer];
	if (timesend >= 0.0 /*&& _bJHLoop*/)
	{
        [self OnGetTztJHAction];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
		_sendTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
		dispatch_source_set_event_handler(_sendTimer, ^{ @autoreleasepool
            {
                [self OnGetTztJHAction];
            }
        });
		
		dispatch_source_t thesendTimer = _sendTimer;
		dispatch_source_set_cancel_handler(_sendTimer, ^{
			dispatch_release(thesendTimer);
		});
		dispatch_time_t tt = dispatch_time(DISPATCH_TIME_NOW, (timesend * NSEC_PER_SEC));
		dispatch_source_set_timer(_sendTimer, tt, timesend * NSEC_PER_SEC, timesend/10);
		dispatch_resume(_sendTimer);
	}
}

//发送均衡请求
-(void)OnGetTztJHAction
{
	if(_nInitStep > TZTSysJhAction)
	{
		[self OnTimeOutAction];
		return;
	}
    
    _nInitStep = TZTSysJhAction;//发送均衡
	_nStepCount++;
    NSMutableArray* ayJhServer = [TZTServerListDeal getShareClass].ayJHAddList;
    if(ayJhServer == NULL || [ayJhServer count] <= 0 || _nStepCount > /*2 **/ [ayJhServer count])
    {
        [self OnJHFinish];
        return;
    }
    [TZTServerListDeal getShareClass].nJHPort = [TZTCSystermConfig getShareClass].tztJHPort;
    if(_nStepCount > 1)
        [[TZTServerListDeal getShareClass] GetNextAddress:tztSession_ExchangeJH bRand_:FALSE];
#ifndef tzt_GJSC
    [_pInitView setTipText:@"正在连接均衡服务器..."];
#endif
    [_pInitView setupInitTimerWithTimeout:8];
    TZTLogInfo(@"发送均衡 %d==%d",_nInitStep,_nStepCount);
    
    [tztMoblieStockComm freeSharejhInstance];
    [[tztMoblieStockComm getSharejhInstance] addObj:self];
    [[tztMoblieStockComm getSharejhInstance] onInitGCDDataSocket];
    return;
}

//均衡结束连接行情服务器
-(void)OnJHFinish
{
    if(_nInitStep > TZTSysJhFinish)
	{
		[self OnTimeOutAction];
		return ;
	}
    
    _bJHLoop = FALSE;
    [self endsendTimer];
    
    if (g_pSystermConfig && g_pSystermConfig.bJHOpen && [tztMoblieStockComm getjhInstance])
        [[tztMoblieStockComm getSharejhInstance] removeObj:self];
 	_nInitStep = TZTSysJhFinish;//均衡结束
#ifndef tzt_GJSC
    [_pInitView setTipText:@"均衡完成.开始连接服务器..."];
#endif
	TZTNSLog(@"均衡结束 %d==%d",_nInitStep,_nStepCount);
    [TZTAppObj InitConnData];
    
	_nStepCount = 0;
	_nInitStep = TZTSysMarketInit;
	_nStepCount = 0;
    [self doRequestMarket];
}


//统一市场排名列表初始化 
-(BOOL) doRequestMarket
{
#ifndef NRequestMarket
	if (_nInitStep > TZTSysMarketInit)
    {
        [self OnTimeOutAction];
		return FALSE;
    }
    
	_nInitStep = TZTSysMarketInit;
	_nStepCount++;
	if (_nStepCount <= 1)
	{
		TZTNSLog(@"初始化排名列表 %d==%d", _nInitStep,_nStepCount);
#ifndef tzt_GJSC
        [_pInitView setTipText:@"正在初始化排名列表数据..."];
#endif
		if (g_pReportMarket)
		{
            [_pInitView setupInitTimerWithTimeout:1];
			[g_pReportMarket RequestReportMarketMenu];
			return TRUE;
		}
	}
    
    _nInitStep = TZTSysDownHomePage;
    _nStepCount = 0;
    [self doDownloadHomePage];
    
	return FALSE;
    
#endif
    _nInitStep = TZTSysDownHomePage;
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
        [_pInitView setTipText:@"正在初始化首页数据..."];
        if (g_pReportMarket)
        {
            [_pInitView setupInitTimerWithTimeout:20];
            [g_pReportMarket RequestHomePageData];
        }
        
        return TRUE;
    }
#else
    //请求公告url
    _nInitStep = TZTSysRequestUrl;
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
        [_pInitView setTipText:@"正在初始化公告数据..."];
        if (g_pReportMarket)
        {
            [_pInitView setupInitTimerWithTimeout:10];
            [g_pReportMarket RequestInfoUrl];
        }
        return TRUE;
    }
    
    _nInitStep = TZTSysReqUniqueID;
    [self OnFinish];
    return FALSE;
#endif
    _nInitStep = TZTSysReqUniqueID;
    _nStepCount = 0;
    [self doRequeUniqueId];
//    [self OnFinish];
    return FALSE;
}

-(BOOL) doRequeUniqueId
{
#ifdef tzt_SupportUniqueId
    //先读取本地是否已经存在
    if (_nInitStep > TZTSysReqUniqueID)
    {
        [self OnTimeOutAction];
        return FALSE;
    }
    
    _nInitStep = TZTSysReqUniqueID;
    _nStepCount++;
    if (_nStepCount <= 1)
    {
        TZTNSLog(@"请求设备唯一标识url %d==%d", _nInitStep, _nStepCount);
        [_pInitView setTipText:@"正在初始化数据..."];
        {
            [_pInitView setupInitTimerWithTimeout:10];
            [[tztPushDataObj getShareInstance] tztRequestUniqueId];
        }
        return TRUE;
    }
    _nInitStep = TZTSysInitEnd;
    [self OnFinish];
    return FALSE;
#endif
    _nInitStep = TZTSysInitEnd;
    [self OnFinish];
    return FALSE;
}

//初始化完成
-(void)OnFinish
{
    [self endsendTimer];
	if(_nInitStep == TZTSysInitFinish)
		return;
	_nInitStep = TZTSysInitEnd;
    [_pInitView endInitTimer];
	_nInitStep = TZTSysInitFinish;//均衡和初始化结束
	_nStepCount = 0;
	TZTNSLog(@"均衡和初始化结束 %d==%d",_nInitStep,_nStepCount);
	//均衡完成，发送通知，通知要想服务器发送设备串号
	NSNotification* pNotifi = [NSNotification notificationWithName:@"TZT_OnSendDeviceToken" object:@"FinishInit"];
	[[NSNotificationCenter defaultCenter] postNotification:pNotifi];
    _pInitView.tztdelegate = nil;
//
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
            [self doRequeUniqueId];
        }
        else if ([nsFinish compare:TZTOnInitReqUniqueId] == NSOrderedSame)
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
                if(_nInitStep == TZTSysJhAction)
                {
                    [self SendJHActionWithTime:6];
//                    [self OnTimeOutAction];
                }
            }
            else if( _nInitStep > TZTSysJhFinish && _nInitStep < TZTSysInitEnd)
            {
                [self OnTimeOutAction];
            }
        }
	}
}

- (void)tztInitViewTimeOut:(tztInitView *)initview
{
    if(initview && initview == _pInitView)
    {
        [self OnTimeOutAction];
    }
}

-(void)OnTimeOutAction
{
	[_pInitView endInitTimer];
	TZTNSLog(@"初始化超时处理 %d==%d",_nInitStep,_nStepCount);
	if(_nInitStep == TZTSysInit)//初始化状态
	{
		[self OnInit];
		return;
	}
	 
	if(_nInitStep == TZTSysJhAction)//均衡状态
	{
		[self OnGetTztJHAction];
		return;
	}
	
	if (_nInitStep == TZTSysJhFinish) //均衡结束
	{
		[self OnJHFinish];
		return;
	} 
	if(_nInitStep >= TZTSysInitEnd) //初始化结束
	{
		[self OnFinish];
		return;
	}
    if (_nInitStep == TZTSysMarketInit)//统一市场列表
    {
        [self doRequestMarket];
        return;
    }
    if (_nInitStep == TZTSysDownHomePage)
    {
        [self doDownloadHomePage];
        return;
    }
    if (_nInitStep == TZTSysRequestUrl)
    {
        [self doRequestUrl];
        return;
    }
    if (_nInitStep == TZTSysReqUniqueID)
    {
        [self doRequeUniqueId];
        return;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 }


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

//zxl 20130930 ipad 最开始界面默认是竖屏 initViewController 作为根视图控制器 要支持自动旋转
-(BOOL)shouldAutorotate
{
    if (IS_TZTIPAD)
        return YES;
    
    return NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft
                || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}
//zxl 20131022 修改了启动页
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (IS_TZTIPAD)
    {
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)//横屏显示
        {
#ifdef __IPHONE_8_0
            if (IS_TZTIOS(8))
            {
                g_nScreenWidth = TZTScreenWidth;
                g_nScreenHeight =  TZTScreenHeight;
            }
            else
            {
                g_nScreenWidth = TZTScreenHeight;
                g_nScreenHeight =  TZTScreenWidth;
            }
#else
                g_nScreenWidth = TZTScreenHeight;
                g_nScreenHeight =  TZTScreenWidth;
#endif
            [self LoadLayoutView];
        }
    }
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver:self name:TZTNotifi_OnInitFinish object:nil];
    [tztMoblieStockComm freeSharejhInstance];
    [super dealloc];
}

-(NSUInteger) OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if(_nInitStep >= TZTSysJhFinish)//均衡结束不再接收消息
        return 0;
    
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if ([pParse IsAction:@"25026"])//华西专用获取服务器地址，并进行测速计算排序
    {
        if ([pParse GetErrorNo] < 0)
        {
            if (_pInitView)
                [_pInitView endInitTimer];
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
            if (_pInitView)
                [_pInitView endInitTimer];
            [self OnJHFinish];
            return 0;
        }
        
        NSString* strServer = [pParse GetByName:@"Server"];
        if (strServer && [strServer length] > 0)
        {
            [[TZTServerListDeal getShareClass] SetServerList:strServer];
        }
        
        NSString* strServerHQ = [pParse GetByName:@"ServerHQ"];
        if (strServerHQ && [strServerHQ length] > 0)
        {
            [[TZTServerListDeal getShareClass] SetServerList:strServerHQ LocList:nil nSession:tztSession_ExchangeHQ];
        }
        
        NSString* strServerJY = [pParse GetByName:@"ServerJY"];
        if (strServerJY && [strServerJY length] > 0)
        {
            [[TZTServerListDeal getShareClass] SetServerList:strServerJY LocList:nil nSession:tztSession_Exchange];
        }
        
        NSString* strServerZX = [pParse GetByName:@"ServerZX"];
        if (strServerZX && strServerZX.length > 0)
        {
            [[TZTServerListDeal getShareClass] SetServerList:strServerZX LocList:nil nSession:tztSession_ExchangeZX];
        }
        
        NSString* strJHServer = [pParse GetByName:@"ServerMr"];
        if (strJHServer && [strJHServer length] > 0)
            [[TZTServerListDeal getShareClass] SetTztJHServer:strJHServer];
        
        NSString* strDate = [pParse GetByName:@"BeginDate"];
        if (strDate && [strDate length] > 0)
        {
            [TZTServerListDeal SetJHSysDate:(NSInteger)[strDate longLongValue]];
        }
        
        NSString *strUpdateURL = [pParse GetByName:@"UpdateAddr"];
        if (strUpdateURL && [strUpdateURL length] > 0)
        {
            self.nsUpdateURL = [NSString stringWithFormat:@"%@",strUpdateURL];
        }
        
        //zxl 20130718 添加了均衡服务器处理
        NSString * strUpdateSign = [pParse GetByName:@"UpdateSign"];
        
        if (g_pTztUpdate == NULL)
            g_pTztUpdate = NewObject(tztUpdate);
        
        /*初始化界面能直接进入主界面，不在阻塞，所以纪录当前的信息用于升级使用*/
        NSString* pErrMsg = [pParse GetErrorMessage];
        g_pTztUpdate.nUpdateSin = [strUpdateSign intValue];
        g_pTztUpdate.nsTips = [NSString stringWithFormat:@"%@", pErrMsg];
        g_pTztUpdate.nsUpdateURL = [NSString stringWithFormat:@"%@", self.nsUpdateURL];
        
        [self OnJHFinish];
    }
    return 1;
}
-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x9999:
            case 0x8888:
            {
                //用户确认升级，打开升级地址
                if (self.nsUpdateURL && [self.nsUpdateURL length] > 0)
                {
                    //跳转升级下载界面
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nsUpdateURL]];
                    //退出程序
                    exit(0);
                }
            }
                break;
                
            default:
                break;
        }
    }
    if(buttonIndex == 1)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x9999:
            {
                //建议升级，不升级，继续使用
                [self OnJHFinish];
            }
                break;
            case 0x8888:
            {
                //强制升级，返回就退出
                exit(0);
            }
                
            default:
                break;
        }
    }
}

@end

