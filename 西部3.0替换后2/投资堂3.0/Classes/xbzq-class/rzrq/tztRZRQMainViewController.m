//
//  tztRZRQMainViewController.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 15-3-5.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import "tztRZRQMainViewController.h"

@interface tztRZRQMainViewController ()

@end

@implementation tztRZRQMainViewController

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tztLoginStateChanged:)
                                                 name:TZTNotifi_ChangeLoginState
                                               object:nil];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([TZTUserInfoDeal IsHaveTradeLogin:RZRQTrade_Log])
    {
        self.tztTitleView.fourthBtn.hidden = NO;
        [self.tztTitleView.fourthBtn setTztBackgroundImage:nil];
        [self.tztTitleView.fourthBtn setTztImage:nil];
        [self.tztTitleView.fourthBtn setTztTitle:@"退出"];
        [self.tztTitleView.fourthBtn.titleLabel setFont:tztUIBaseViewTextFont(14)];
        [self.tztTitleView.fourthBtn removeTarget:self.tztTitleView action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.tztTitleView.fourthBtn addTarget:self
                                        action:@selector(OnRightItem:)
                              forControlEvents:UIControlEventTouchUpInside];
    }
    else
        self.tztTitleView.fourthBtn.hidden = YES;
    if (self.pWebView)
        [self.pWebView tztStringByEvaluatingJavaScriptFromString:@"GoBackOnLoad();"];
}

- (void)tztLoginStateChanged:(NSNotification*)note
{
    NSString* strType = (NSString*)note.object;
    NSArray *ay = [strType componentsSeparatedByString:@"|"];
    if ([ay count] <= 0)
        return;
    long lType = [[ay objectAtIndex:0] intValue];
    BOOL IsLogin = TRUE;
    if ([ay count] > 1)
    {
        IsLogin = [[ay objectAtIndex:1] boolValue];
    }
    if ([TZTUserInfoDeal IsHaveTradeLogin:lType])
    {
        if((RZRQTrade_Log & lType) == RZRQTrade_Log)//普通交易登出
        {
            if(!IsLogin)
                self.tztTitleView.fourthBtn.hidden = YES;
        }
    }
}


-(void)OnRightItem:(id)sender
{
    tztAfxMessageBlock(@"确定退出当前融资融券账户？", nil, nil, TZTBoxTypeButtonBoth, ^(NSInteger nIndex){
        [TZTUIBaseVCMsg OnMsg:MENU_SYS_RZRQOut wParam:0 lParam:0];
    });
}


-(void)OnChangeTheme
{
    [self.pWebView RefreshWebView:-1];
    [super OnChangeTheme];
}


@end
