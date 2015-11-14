/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        各个券商特有功能自己处理
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <Foundation/Foundation.h>

@interface tztUIBaseVCOtherMsg : NSObject
+(tztUIBaseVCOtherMsg*)getShareInstance;
-(void)freeShareInstance;
+(int) OnMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
+(int)CheckSysAndTradeLogin:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam;
+ (UIViewController*)GetTabBarViewController:(NSInteger)nType wParam_:(NSUInteger)wParam lParam_:(NSUInteger)lParam;
+ (BOOL)addViewController:(TZTPageInfoItem *)pItem withNav:(UINavigationController *)viewController;
@end
