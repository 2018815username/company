//
//  AccountHelpViewController.m
//  tzt_xbzq_3.0
//
//  Created by wry on 15/6/11.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import "AccountHelpViewController.h"
#import "AccountAddView.h"




@interface AccountHelpViewController ()
{
 
}
@property (nonatomic,strong)     AccountAddView*accountView;
@end

@implementation AccountHelpViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [_accountView performSelector:@selector(getZHxinxi) withObject:nil afterDelay:0.1];
}

-(void)initTableView{
    //标题view
    if (IS_TZTIPAD)
    {
        _tztTitleView.nType = TZTTitleNormal;
        _tztTitleView.bHasCloseBtn = YES;
        _tztTitleView.bShowSearchBar = FALSE;
        [self onSetTztTitleView:@"账号管理" type:TZTTitleReturn];
    }
    else
    {
        [self onSetTztTitleView:@"账号管理" type:TZTTitleReturn];
    }
    
    CGRect rcLogin = _tztBaseView.frame;
    rcLogin.origin.y += self.tztTitleView.frame.size.height;
    rcLogin.size.height -= (self.tztTitleView.frame.size.height /*+ TZTToolBarHeight*/);
    if (_accountView==nil) {
        _accountView = [[AccountAddView alloc] initWithFrame:rcLogin];
    }else {
        _accountView.frame =rcLogin;
    }
    [_tztBaseView addSubview:_accountView];
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    
}

@end
