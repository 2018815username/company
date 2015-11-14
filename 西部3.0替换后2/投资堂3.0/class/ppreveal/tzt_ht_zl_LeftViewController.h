//
//  LeftViewController.h
//  EasySample
//
//  Created by Marian PAUL on 12/06/12.
//  Copyright (c) 2012 Marian PAUL aka ipodishima — iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef tzt_SideWidthRight
#define tzt_SideWidthRight 270
#endif

#ifndef tzt_SideWitdhLeft
#define tzt_SideWidthLeft 30
#endif

@interface tzt_ht_zl_LeftViewController : UIViewController<tztHTTPWebViewDelegate>
{
    BOOL _bLeftView;
    BOOL _bShowed;
}
@property BOOL bLeftView;
@property BOOL bShowed;

-(void)LoadWebURL:(NSString*)strURL;
-(void)tztTradeLogOut;
-(void)tztTradeLogIn;
-(void)tztPushViewController:(UIViewController*)pVC animated:(BOOL)animated;
-(void)OnReturnBack;
-(void)OnReturnBack:(BOOL)useanimated;
-(void)OnWebReturnBack;
-(void)tztScrollToTop;
-(void)RefreshWebView:(int)nIndex;
@end
