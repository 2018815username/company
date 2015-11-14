/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        tztNotification.h 消息通知定义
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#ifndef tztMobileApp_tztNotification_h
#define tztMobileApp_tztNotification_h

#define tztTabbarStatusFile     @"tztTabbarStatusFile"
/**
 *	键盘显示通知响应事件
 */
#define TZTUIKeyboardDidShowNotification @"TZT_ShowKeyBoard"

/**
 *	键盘隐藏通知响应事件
 */
#define TZTUIKeyboardDidHideNotification @"TZT_HideKeyBoard"

//用户登录
#define TZTNotifi_UserLogin             @"TZTNotifi_UserLogin"
//初始化市场菜单
#define TZTOnInitReportMarketInfo          @"TZTOnInitReportMarketInfo"
//
#define TZTOnInitDownloadHomePage           @"TZTOnInitDownloadHomePage"
//
#define TZTOnInitRequestUrl                 @"TZTOnInitRequestUrl"
//
#define TZTOnInitReqUniqueId                @"TZTOnInitReqUniqueId"
//
#define TZTOnInitStockCode                  @"TZTOnInitStockCode"
//用户登录校验
#define TZTNotifi_CheckUserLogin            @"TZTNotifi_CheckUserLogin"

#define TZTNotifi_GetDeviceToken            @"TZTNotifi_GetDeviceToken"

#define TZTNotifi_HiddenMoreView            @"TZTNotifi_HiddenMoreView"

#define TZTNotifi_UpdateInfo                @"TZTNotifi_UpdateInfo"

//主题切换
#define TZTNotifi_ChangeTheme               @"TZTNotifi_ChangeTheme"

#define TZTNotifi_RequestLogVolume          @"TZTNotifi_RequestLogVolume"
#endif
