//
//  tztOptionBuySellViewController.m
//  tztMobileApp_GTJA
//
//  Created by King on 15-2-11.
//  Copyright (c) 2015年 tzt. All rights reserved.
//

#import "tztOptionBuySellViewController.h"
#import "tztOptionBuySellView.h"

@interface tztOptionBuySellViewController ()

@property(nonatomic,retain)tztOptionBuySellView *tztTradeView;
@end

@implementation tztOptionBuySellViewController
@synthesize CurStockCode = _CurStockCode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    
    [self onSetTztTitleView:GetTitleByID(_nMsgType) type:TZTTitleReport];
    
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= _tztTitleView.frame.size.height;
    
    if (_tztTradeView == nil)
    {
        _tztTradeView = [[tztOptionBuySellView alloc] init];
        _tztTradeView.nMsgType = _nMsgType;
        _tztTradeView.frame = rcFrame;
        if (self.CurStockCode && self.CurStockCode.length > 0)
        {
            [_tztTradeView setStockCode:self.CurStockCode];
        }
        [_tztBaseView addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
        _tztTradeView.frame = rcFrame;
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    
}

@end
