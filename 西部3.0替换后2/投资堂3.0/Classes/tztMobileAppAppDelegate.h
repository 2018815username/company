//
//  tztMobileAppAppDelegate.h
//  tztMobileApp
//
//  Created by yangdl on 12-11-30.
//  Copyright 2012 投资堂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZTInitViewController.h"
#import "TZTUIBaseTabBarViewController.h"
#import "TztViewController.h"

@interface tztMobileAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate, UINavigationControllerDelegate,tztSocketDataDelegate> 
{    
    UIWindow *window;
    TZTUIBaseTabBarViewController  *rootTabBarController;
    TZTInitViewController* pVC;
    TztViewController* testVC;
    
    NSDictionary *_pushOptions;
    
    BOOL         _bShowAlert;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet TZTUIBaseTabBarViewController    *rootTabBarController;
@property (nonatomic, retain) NSDictionary *pushOptions;
//@property (nonatomic, retain) TZTInitViewController* vc;
-(void)CallAppViewControl;
-(void)OnReturnBack;
-(void)didSelectItemByPageType:(int)nType options_:(NSDictionary*)options;
-(void)didSelectItemByIndex:(int)nIndex options_:(NSDictionary*)options;
@end

