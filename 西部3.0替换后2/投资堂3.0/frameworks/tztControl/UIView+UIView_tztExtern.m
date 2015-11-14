//
//  UIView+UIView_tztExtern.m
//  tztControl
//
//  Created by yangares on 15/10/14.
//  Copyright (c) 2015年 tzt. All rights reserved.
//

#import "UIView+UIView_tztExtern.h"

@implementation UIView (UIView_tztExtern)

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType delegate_:(id)delegate
{
    return [self showMessageBox:nsString nType_:nType nTag_:0 delegate_:delegate];
}

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag
{
    return [self showMessageBox:nsString nType_:nType nTag_:nTag delegate_:nil];
}

-(TZTUIMessageBox*) showMessageBox:(NSString*)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate
{
    return [self showMessageBox:nsString nType_:nType nTag_:nTag delegate_:delegate withTitle_:nil];
}

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle
{
    return [self showMessageBox:nsString nType_:nType nTag_:nTag delegate_:delegate withTitle_:nsTitle nsOK_:nil nsCancel_:nil];
}

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle nsOK_:(NSString*)nsOK nsCancel_:(NSString*)nsCacel
{
    return [self showMessageBox:nsString nType_:nType nTag_:nTag delegate_:delegate withTitle_:nsTitle nsOK_:nsOK nsCancel_:nsCacel UseAnimated:TRUE];
}

-(TZTUIMessageBox*) showMessageBox:(NSString *)nsString nType_:(int)nType nTag_:(int)nTag delegate_:(id)delegate withTitle_:(NSString*)nsTitle nsOK_:(NSString*)nsOK nsCancel_:(NSString*)nsCacel UseAnimated:(BOOL)bUseAnimated
{
    if (nsString == NULL || [nsString length] < 1)
        return NULL;
    
    //    if (!IS_TZTIPAD)//自定义的弹出提示，只对iphone使用，ipad还是使用系统的弹出
    {
        if (nsTitle == nil || [nsTitle length] < 1)
        {
            nsTitle = [NSString stringWithFormat:@"%@", g_nsMessageBoxTitle];
        }
        if (nsOK == nil || [nsOK length] < 1)
            nsOK = @"确定";
        if (nsCacel == nil || [nsCacel length] < 1)
            nsCacel = @"取消";
        
        
        if (nType == TZTBoxTypeNoButton && g_ntztHaveBtnOK)
            nType = TZTBoxTypeButtonOK;
        CGRect appRect = [[UIScreen mainScreen] bounds];
        TZTUIMessageBox *pMessage = [[[TZTUIMessageBox alloc] initWithFrame:appRect nBoxType_:nType delegate_:delegate] autorelease];
        pMessage.tag = nTag;
        //需要组织字符串
        pMessage.m_nsContent = [NSString stringWithString:nsString];
        [pMessage setButtonText:nsOK cancel_:nsCacel];
        pMessage.m_nsTitle = nsTitle;
        
        [pMessage showForView:g_navigationController.topViewController.view animated:bUseAnimated];
        
        return pMessage;
    }
    
    return NULL;
}

@end

@implementation UIWebView (UIWebView_tztExtern)

-(void)tztWebViewShowAlert:(NSString *)message option:(id)optionData
{
    tztAfxMessageBox(message);
}

-(BOOL)tztWebViewConfirm:(NSString*)message option:(id)optionData
{
    __block BOOL ret = NO;
    __block BOOL bLoop = YES;
    TZTUIMessageBox* pMessage = tztAfxMessageBlock(message,g_nsMessageBoxTitle,nil,TZTBoxTypeButtonBoth,^(NSInteger buttonIndex)
                                                   {
                                                       ret = NO;
                                                       if(buttonIndex == 0)
                                                       {
                                                           ret = YES;
                                                       }
                                                       bLoop = NO;
                                                   }
                                                   );
    
    if (pMessage && [pMessage isKindOfClass:[UIAlertView class]])
    {
        while (((UIAlertView*)pMessage).visible)
        {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
        }
    }
    else
    {
        while( pMessage && (!pMessage.bDismiss))//弹出显示
        {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
        }
    }
    return ret;
    
}

@end





