//
//  ShangChengViewController.m
//  tzt_xbzq_3.0
//
//  Created by wry on 15/6/9.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import "ShangChengViewController.h"

@interface ShangChengViewController ()

@end

@implementation ShangChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.pWebView canReturnBack]) {
    [self.tztTitleView setTitleType:TZTTitleReturn];
    }else{
    [self.tztTitleView setTitleType:TZTTitleLogo];
    }

}

-(void)tztWebView:(tztBaseUIWebView *)webView withTitle:(NSString *)title
{
    
    if ([self.pWebView canReturnBack]) {
        [self.tztTitleView setTitleType:TZTTitleReturn];
    }else{
        [self.tztTitleView setTitleType:TZTTitleLogo];
    }

    if(_pWebView && webView == _pWebView)
    {
        if(title && [title length] > 0)
        {
            self.nsTitle = [NSString stringWithFormat:@"%@",title];
            if (_tztTitleView)
            {
                [_tztTitleView setTitle:title];
            }
        }
        else
        {
            [_tztTitleView setTitle:g_pSystermConfig.strMainTitle]; // important and good for title corrected
#ifdef TZT_JYSC
            [_tztTitleView setTitle:self.nsTitle];
#endif
        }

    }
}

-(void)OnContactUS:(id)sender
{
    if (self.pWebView && [self.pWebView OnReturnBack]) {
        [super OnReturnBack];
        return;
    }
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}

@end
