/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        tztBaseUIWebView.h
 * 文件标识:        webview基类
 * 摘要说明:        投资堂业务处理基类。
 *
 * 当前版本:        2.0
 * 作    者:       yangdl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/


#import <UIKit/UIKit.h>
//#import <tztMobileBase/tztHTTPWebView.h>b

@protocol tztHTTPWebViewDelegate;
@interface tztBaseUIWebView : tztHTTPWebView <UIWebViewDelegate>

//处理webmsg
-(tztHTTPWebViewLoadType)ontztWebURL:(UIWebView*)tztWebView strURL:(NSString *)strUrl WithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@end