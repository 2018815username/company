//
//  RootViewController.h
//  tztMobileApp
//
//  Created by yangdl on 12-11-30.
//  Copyright 2012 投资堂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tztBaseUIWebView.h"

@interface TztViewController : UIViewController<tztHTTPWebViewDelegate>
{
    UILabel* _weblable;
    UITextField* _textview;
    TZTUIBaseTitleView* _tztTitleView;
    tztBaseUIWebView* _webView;
}
@end
