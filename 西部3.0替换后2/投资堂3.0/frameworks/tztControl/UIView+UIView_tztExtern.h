//
//  UIView+UIView_tztExtern.h
//  tztControl
//
//  Created by yangares on 15/10/14.
//  Copyright (c) 2015年 tzt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_tztExtern)
/**提示对话框*/
-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType delegate_:(id)delegate;
-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag;
-(TZTUIMessageBox*) showMessageBox:(NSString*)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate;
-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle;
-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle nsOK_:(NSString*)nsOK nsCancel_:(NSString*)nsCacel;
//增加是否采用动画效果，默认使用
-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle nsOK_:(NSString*)nsOK nsCancel_:(NSString*)nsCacel UseAnimated:(BOOL)bUseAnimated;
@end


@interface UIWebView(UIWebView_tztExtern)

-(void)tztWebViewShowAlert:(NSString*)message option:(id)optionData;
-(BOOL)tztWebViewConfirm:(NSString*)message option:(id)optionData;

@end