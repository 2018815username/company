
#import <AudioToolbox/AudioServices.h>
//#import <tztMobileBase/tztStatusBar.h>
#import "tztPushDataObj.h"

tztPushDataObj  *g_tztPushDataObj;

@interface tztPushDataObj()<tztStatusBarDelegate, tztSocketDataDelegate>
{
    int          _nFlag;
    BOOL         _bOpenPush;
    BOOL         _bSendDeviceTokenSucc;
    BOOL         _bSendUniqueId;
    UInt16       _ntztReqNo;
}

@property(nonatomic,retain)NSString* strPushInfo;

-(void)didBecomActive;
-(void)didEnterBakground;
-(void)willEnterForeground;
@end

@implementation tztPushDataObj
@synthesize strPushInfo = _strPushInfo;
@synthesize pushInfo = _pushInfo;


+(tztPushDataObj*)getShareInstance
{
    if (g_tztPushDataObj == NULL)
    {
        g_tztPushDataObj = NewObject(tztPushDataObj);
    }
    return g_tztPushDataObj;
}

-(void)freeShareInstance
{
    DelObject(g_tztPushDataObj);
}

-(id)init
{
    if (self = [super init])
    {
        _nFlag = 1;
        //增加通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didBecomActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didEnterBakground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(OnGetDeviceToken:)
                                                     name:@"TZT_OnSendDeviceToken"
                                                   object:nil];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)didBecomActive
{
    if (_nFlag == 1)
    {
        _bOpenPush = FALSE;
        _nFlag = 0;
    }
    else
        _bOpenPush = TRUE;
}

-(void)willEnterForeground
{
    _bOpenPush = TRUE;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"tztGetPushMessage" object:nil];
}

-(void)didEnterBakground
{
    _nFlag = 1;
}

-(void)tztRegistPush
{
    //注册启用 push
    if(!IS_TZTSimulator)
    {
#ifdef __IPHONE_8_0
        if (IS_TZTIOS(8))
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
        }
#else
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
#endif
    }
    else
    {
        TZTNSLog(@"%@", @"模拟器不支持推送!");
    }
}

//注册成功，获取devicetoken
-(void)tztRegistPushSucc:(NSData *)deviceToken
{
	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	NSString *results = [NSString stringWithFormat:@"Badge: %@, Alert:%@, Sound: %@",
						 (rntypes & UIRemoteNotificationTypeBadge) ? @"Yes" : @"No",
						 (rntypes & UIRemoteNotificationTypeAlert) ? @"Yes" : @"No",
						 (rntypes & UIRemoteNotificationTypeSound) ? @"Yes" : @"No"];
	TZTNSLog(@"results: %@", results);
	NSString* strToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	
	g_nsdeviceToken = [strToken retain];
	TZTLogInfo(@"deviceToken: %@", g_nsdeviceToken);
    //收到devicetoken不马上发送，等待均衡完成后，通过消息通知后再发送
//    [self OnGetDeviceToken:nil];
}

-(void)OnGetDeviceToken:(NSNotification*)notification
{
    [self tztSendDeviceToken];
    [self tztSendUniqueIdWithDeviceToken];
}


//收到推送消息
-(void)tztDidRecivePushData:(NSDictionary *)userInfo
{
    self.pushInfo = userInfo;
	NSString* nsalert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString* nsbadge = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [nsbadge intValue];
    
    NSLog(@"%@", userInfo);
    //
    NSString* strData = [[userInfo objectForKey:@"aps"] objectForKey:@"att"];
    
    BOOL bDeal = FALSE;
    //判断数据，如果收到的是成交回报，并且当前界面为当日成交，或当日委托界面，刷新数据，其他暂不做处理
    
    NSArray* ayPush = [strData componentsSeparatedByString:@"|"];
    if (ayPush.count > 4)//0-socid 1-type 2-代码 3-消息未读数(badge) 4-小的分类（22表示成交回报）
    {
        NSString* strType = [ayPush objectAtIndex:4];
        if (strType && strType.length > 0)
        {
            switch ([strType intValue])
            {
                case 22://成交回报，判断当前界面是否是当日委托界面
                {
                    UIViewController* pVC = [TZTAppObj getTopViewController];
                    if ([pVC isKindOfClass:[[NSBundle mainBundle] classNamed:@"tztWebTradeWithDrawViewController"]]
                        || [pVC isKindOfClass:[[NSBundle mainBundle] classNamed:@"tztUIStockBuySellViewController"]])
                    {
                        //发出通知更新界面
                        if (pVC && [pVC respondsToSelector:@selector(tztRefreshData)])
                        {
                            [pVC tztperformSelector:@"tztRefreshData"];
                            bDeal = TRUE;
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    if (_bOpenPush)
    {
        [[TZTAppObj getShareInstance] tztGetPushDetailInfo:strData];
    }
    else
    {
        [tztStatusBar tztShowMessageInStatusBar:nsalert
                                       bgColor_:[UIColor colorWithTztRGBStr:@"67,148,255"]
                                      txtColor_:[UIColor whiteColor]
                                      fTimeOut_:-1.0f
                                      delegate_:(bDeal ? nil : self)
                                     nPosition_:1];
    }
    
    _bOpenPush = FALSE;
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"tztGetPushMessage" object:nil];
    //    [tztStatusBar tztShowMessageInStatus:nsalert];
    
    
    CFShow([userInfo description]);
    //
	//接收到push  打开程序以后设置badge的值
    
	//接收到push  打开程序以后会震动
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)tztStatusBarClicked:(tztStatusBar *)statusBar
{
    if (self.pushInfo)
    {
//        [self tztRequestDetailOfPushInfo:[[self.pushInfo objectForKey:@"aps"] objectForKey:@"att"]];
        [[TZTAppObj getShareInstance] tztGetPushDetailInfo:[[self.pushInfo objectForKey:@"aps"] objectForKey:@"att"]];
    }
}

-(void)tztSendDeviceToken
{
    //已经发送过了，不重复发送
    if (_bSendDeviceTokenSucc)
        return;
    //设备串号没取到，不发送
    if (g_nsdeviceToken == NULL || [g_nsdeviceToken length] < 1)
        return;
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    if (g_nsdeviceToken)
        [pDict setTztObject:g_nsdeviceToken forKey:@"devicetoken"];
    [pDict setTztObject:(IS_TZTIPAD ? @"1":@"0") forKey:@"devicetype"];//IPHONE - 0 ; IPAD - 1
#ifdef DEBUG
    if (!IS_TZTIPAD)
        [pDict setTztObject:@"0" forKey:@"certtype"];//证书类型 测试－0 iphone
    else
        [pDict setTztObject:@"2" forKey:@"certtype"];//证书类型 测试－2 iPad
#else
    if (!IS_TZTIPAD)
    {
        NSString* strBundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        if (strBundleID && ([strBundleID caseInsensitiveCompare:@"zlcft2"] == NSOrderedSame
                            || [strBundleID caseInsensitiveCompare:@"cn.com.gjzq.yjb.jy.qy"] == NSOrderedSame))
        {
            [pDict setTztObject:@"4" forKey:@"certtype"];
        }
        else
        {
            [pDict setTztObject:@"1" forKey:@"certtype"];//证书类型 发布－1 iPhone
        }
    }
    else
        [pDict setTztObject:@"3" forKey:@"certtype"];//证书类型 发布－3 iPad
#endif
    [pDict setTztObject:strReqNo forKey:@"ReqNo"];
    [pDict setTztObject:@"1" forKey:tztIphoneReSend];//重发
    
    NSString* strUniqueId = [tztKeyChain load:tztUniqueID];
    if (strUniqueId && strUniqueId.length > 0)
        [pDict setTztObject:strUniqueId forKey:@"uniqueid"];
    [tztHTTPSendData socketSendData:[tztMoblieStockComm getShareInstance] action:@"10120" sendData:pDict tztdelegate:self];
    [pDict release];
}

-(void)tztRequestUniqueId
{
    //先获取下本地是否已经有唯一标示
    NSString* strUniqueId = [tztKeyChain load:tztUniqueID];
    if (strUniqueId && strUniqueId.length > 0)//已经存在，直接跳过
    {
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTOnInitReqUniqueId];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        return;
    }
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    
    [pDict setTztObject:@"1" forKey:tztIphoneReSend];//重发
    
    [tztHTTPSendData socketSendData:[tztMoblieStockComm getShareInstance] action:@"44802" sendData:pDict tztdelegate:self];
    DelObject(pDict);
}

//纪录客户端信息
/*
 uniqueid	string	用户ID(客户端唯一标识)
 version	string	涨乐财富通软件版本(软件升级版本号)
 cfrom	string	软件来源
 tfrom	string	软件平台
 mobilecode	string	手机号
 imei	string	手机国际移动设备身份码
 resolution	string	手机分辨率
 platform	string	手机平台(IOS、Android、WP7、WP8、WIN8)
 mobileversion	string	手机系统版本(7.0、8.0、4.2...)
 model	string	手机型号(IPHONE 5S...)
 nettype	string	网络类型(WIFI、3G...)
 ip	string	IP地址(MS添加，客户端不需要发送)
 carriername	string	运营商名称(联通、电信、移动)
 mac	string	MAC地址
 devicetoken	string	Apple设备号(ios系统为必要字段，其它系统可不送)
 */
-(void)tztSendUniqueIdWithDeviceToken
{
    if (_bSendUniqueId)
        return;
    if (g_nsdeviceToken == NULL || g_nsdeviceToken.length < 1)
        return;
    
    NSString *nsUniqueid = [tztKeyChain load:tztUniqueID];
    if (nsUniqueid == NULL || nsUniqueid.length < 1)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    //    _ntztReqNo++;
    //    if (_ntztReqNo >= UINT16_MAX)
    //        _ntztReqNo = 1;
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqNo forKey:@"Reqno"];
    
    [pDict setTztObject:nsUniqueid forKey:@"uniqueid"];
    if (g_nsUpVersion)
        [pDict setTztObject:g_nsUpVersion forKey:@"version"];
    
    [pDict setTztObject:g_nsdeviceToken forKey:@"devicetoken"];
    [pDict setTztObject:(IS_TZTIPAD ? @"1":@"0") forKey:@"devicetype"];//IPHONE - 0 ; IPAD - 1
#ifdef DEBUG
    if (!IS_TZTIPAD)
        [pDict setTztObject:@"0" forKey:@"certtype"];//证书类型 测试－0 iphone
    else
        [pDict setTztObject:@"2" forKey:@"certtype"];//证书类型 测试－2 iPad
#else
    if (!IS_TZTIPAD)
    {
        NSString* strBundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        if (strBundleID && ([strBundleID caseInsensitiveCompare:@"zlcft2"] == NSOrderedSame
                            || [strBundleID caseInsensitiveCompare:@"cn.com.gjzq.yjb.jy.qy"] == NSOrderedSame))
        {
            [pDict setTztObject:@"4" forKey:@"certtype"];
        }
        else
        {
            [pDict setTztObject:@"1" forKey:@"certtype"];//证书类型 发布－1 iPhone
        }
    }
    else
        [pDict setTztObject:@"3" forKey:@"certtype"];//证书类型 发布－3 iPad
#endif
    NSMutableDictionary *pDeviceInfo = [UIDevice tztDeviceInfo];
    
    [pDict setTztObject:[pDeviceInfo tztObjectForKey:@"devicemodel"] forKey:@"platform"];
    [pDict setTztObject:[pDeviceInfo tztObjectForKey:@"systemnameex"] forKey:@"model"];
    [pDict setTztObject:[pDeviceInfo tztObjectForKey:@"systemversion"] forKey:@"mobileversion"];
    [pDict setTztObject:[pDeviceInfo tztObjectForKey:@"screensize"] forKey:@"resolution"];
    [tztHTTPSendData socketSendData:[tztMoblieStockComm getShareInstance] action:@"44804" sendData:pDict tztdelegate:self];
    DelObject(pDict);
}

-(void)tztSendUniqueIdWithAccount:(NSDictionary*)dict
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    NSString* strAccount = [dict objectForKey:@"account"];
    if (strAccount)
        [pDict setTztObject:strAccount forKey:@"account"];
    
    if (g_nsUpVersion)
        [pDict setTztObject:g_nsUpVersion forKey:@"version"];
    
    NSString* strKHBranch = [dict objectForKey:@"khbranch"];
    if (strKHBranch)
        [pDict setTztObject:strKHBranch forKey:@"khbranch"];
    
    NSString *str = [tztKeyChain load:tztUniqueID];
    if (str)
        [pDict setTztObject:str forKey:@"uniqueid"];
    
    [tztHTTPSendData socketSendData:[tztMoblieStockComm getShareInstance] action:@"44800" sendData:pDict tztdelegate:self];
    DelObject(pDict);
}

-(void)tztRequestSignOutTrade:(NSString *)nsAccount
{
    if (nsAccount == NULL || nsAccount.length < 1)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    
    NSString* strUniqued = [tztKeyChain load:tztUniqueID];
    [pDict setTztObject:nsAccount forKey:@"Account"];
    if (strUniqued)
        [pDict setTztObject:strUniqued forKey:@"uniqueid"];
    
    if (g_nsUpVersion)
        [pDict setTztObject:g_nsUpVersion forKey:@"version"];
    
    tztJYLoginInfo *pLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
    if (pLoginInfo && pLoginInfo.nsKHBranch)
    {
        [pDict setTztObject:pLoginInfo.nsKHBranch forKey:@"khbranch"];
    }
    
    [tztHTTPSendData socketSendData:[tztMoblieStockComm getShareInstance] action:@"44801" sendData:pDict tztdelegate:self];
    DelObject(pDict);
}

-(void)tztRequestDetailOfPushInfo:(NSString *)nsPushInfo
{
    if (!ISNSStringValid(nsPushInfo))
        return;
    
    NSArray* ayPush = [nsPushInfo componentsSeparatedByString:@"|"];
    if (ayPush.count < 2)
        return;
    
    //根据文档，type是必须字段，socid非必须，对type进行判断
    if (ayPush == NULL || ayPush.count < 2)
        return;
    
    NSString *nsSocId = [ayPush objectAtIndex:0];
    NSString *nsType = [ayPush objectAtIndex:1];
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    
    NSString* strUniqued = [tztKeyChain load:tztUniqueID];
    if (strUniqued)
        [pDict setTztObject:strUniqued forKey:@"uniqueid"];
    
    self.strPushInfo = [NSString stringWithFormat:@"%@", nsPushInfo];
    if (nsSocId)
    {
        [pDict setTztObject:nsSocId forKey:@"socid"];
    }
    
    [pDict setTztObject:nsType forKey:@"type"];
    
    [tztHTTPSendData socketSendData:[tztMoblieStockComm getShareInstance] action:@"41048" sendData:pDict tztdelegate:self];
    DelObject(pDict);
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    if ([pParse IsAction:@"44800"])
    {
        tztJYLoginInfo *pLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];
        if ([pParse GetErrorNo] >= 0 && pLoginInfo && pLoginInfo.ZjAccountInfo && pLoginInfo.nsAccount)
        {
            NSString* strPID = [pParse GetByName:@"PID"];
            if (strPID && strPID.length > 0)
            {
                NSString* strID = [NSString stringWithFormat:@"%@-%@", tztPID, pLoginInfo.ZjAccountInfo.nsAccount];
                [tztKeyChain save:strID data:strPID];
            }
        }
        return 0;
    }
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
    if ([pParse IsAction:@"41048"])
    {
        if ([pParse GetErrorNo] < 0)
        {
            NSString *strMsg = [pParse GetErrorMessage];
            tztAfxMessageBox(strMsg);
            return 0;
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        /*
         oper操作类型:
         1、网页跳转(URL在message字段里);
         2、文本展示;
         3、弹窗展示;
         4、不显示任何内容，直接跳转到modify对应的页面即可;
         
         modify=21、(华泰专用)资讯类，客户端根据<GRID0>中的内容调用华泰的接口取资讯内容并显示 <GRID0>type=123&id=152&</GRID0>
         modify=22、(华泰专用)成交回报 成交内容，点击进入当日成交页面
         modify=23、(华泰专用)资金变动 资金变动内容，点紧进入转账流水页面
         modify=24、(华泰专用)持仓股涨跌停板 涨跌停内容，点击进入相关个股详情页面
         modify=26、(华泰专用)升级提示 启动程序，判断是否升级(建议升级、强制升级)
         */
        //获取oper
        NSString* nsOper = [pParse GetByName:@"oper"];
        NSString* nsModify = [pParse GetByName:@"modify"];
        NSString* nsStockCode= [pParse GetByName:@"stockcode"];
        
        BOOL bDeal = FALSE;
        switch ([nsOper intValue])
        {
            case 4:
            {
                switch ([nsModify intValue])
                {
                    case 21://资讯类
                    {
                        
                    }
                        break;
                    case 22://当日成交
                    {
#ifdef tzt_GJSC
                        [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_QueryDraw wParam:0 lParam:0];
#else
                        [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_QueryTradeDay wParam:0 lParam:0];
#endif
                        bDeal = TRUE;
                    }
                        break;
                    case 23://转账流水
                    {
                        [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_QueryBankHis wParam:0 lParam:0];
                        bDeal = TRUE;
                    }
                        break;
                    case 24://个股详情
                    {
                        tztStockInfo* pStock = NewObject(tztStockInfo);
                        pStock.stockCode = [NSString stringWithFormat:@"%@", nsStockCode];
                        [TZTUIBaseVCMsg OnMsg:MENU_HQ_Trend wParam:(NSUInteger)pStock lParam:0];
                        [pStock release];
                        bDeal = TRUE;
                    }
                        break;
                    case 26://升级提示
                    {
                        
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 1:
            case 2:
            case 3:
            default:
                break;
        }
        
        if (!bDeal)//重新调用网页进行处理
        {
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_TztPushInfo wParam:(NSUInteger)self.strPushInfo lParam:[self.strPushInfo length]];
        }
        
        return 0;
    }
    if ([pParse IsAction:@"10120"])
    {
        //        NSString* strMessage = [pParse GetErrorMessage];
        //        TZTNSLog(@"%@", strMessage);
        _bSendUniqueId = FALSE;
        [self tztSendUniqueIdWithDeviceToken];
        return 0;
    }
    if ([pParse IsAction:@"44802"])
    {
        NSString* nsUniqueId = [pParse GetByName:@"uniqueid"];
        if (nsUniqueId == NULL || [nsUniqueId length] < 1)
        {
            //接收成功，发送条通知消息
            NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTOnInitReqUniqueId];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
            return 0;
        }
        
        [tztKeyChain save:tztUniqueID data:nsUniqueId];//得到设备唯一号，单独使用
        
        //和devicetoken绑定
        _bSendUniqueId = FALSE;
        [self tztSendUniqueIdWithDeviceToken];
        //接收成功，发送条通知消息
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_OnInitFinish object:TZTOnInitReqUniqueId];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        
        return 0;
    }
    return 0;
}
@end
