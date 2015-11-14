/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTReachability.h
 * 文件标识：
 * 摘    要：Reachability.h
 *
 * 当前版本：
 * 作    者：
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum {
	TZTNotReachable = 0,
	TZTReachableViaWiFi,
	TZTReachableViaWWAN,
    TZTReachableViable,
} TZTNetworkStatus;
#define kTZTReachabilityChangedNotification @"kTZTNetworkReachabilityChangedNotification"

@interface TZTReachability: NSObject
{
	BOOL localWiFiRef;
	SCNetworkReachabilityRef reachabilityRef;
}

//reachabilityWithHostName- Use to check the reachability of a particular host name. 
+ (TZTReachability*) reachabilityWithHostName: (NSString*) hostName;

//reachabilityWithAddress- Use to check the reachability of a particular IP address. 
+ (TZTReachability*) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;

//reachabilityForInternetConnection- checks whether the default route is available.  
//  Should be used by applications that do not connect to a particular host
+ (TZTReachability*) reachabilityForInternetConnection;

//reachabilityForLocalWiFi- checks whether a local wifi connection is available.
+ (TZTReachability*) reachabilityForLocalWiFi;

//Start listening for reachability notifications on the current run loop
- (BOOL) startNotifer;
- (void) stopNotifer;

- (TZTNetworkStatus) currentReachabilityStatus;
//WWAN may be available, but not active until a connection has been established.
//WiFi may require a connection for VPN on Demand.
- (BOOL) connectionRequired;
@end

extern TZTReachability*  g_tztreachability;
