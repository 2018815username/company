//
//  tztUIFundCFVC.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-14.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztUIFundCFVC.h"

@implementation tztUIFundCFVC
@synthesize pFundTradeCF = _pFundTradeCF;
@synthesize CurStockCode = _CurStockCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return YES;
    }
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    NSString *nsTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(nsTitle))
        nsTitle = @"基金合并拆分";
    //标题view
    [self onSetTztTitleView:nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    //zxl 20130718 修改了不需要底部工具条Frame 高度修改
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcBuySell.size.height -= _tztTitleView.frame.size.height;
    }else
    {
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    if (_pFundTradeCF == nil)
    {
        _pFundTradeCF = [[tztUIFundFCView alloc] init];
        _pFundTradeCF.nMsgType = _nMsgType;
        _pFundTradeCF.delegate = self;
        _pFundTradeCF.frame = rcBuySell;
        if (self.CurStockCode && [self.CurStockCode length] > 0)
            _pFundTradeCF.CurStockCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
        [_tztBaseView addSubview:_pFundTradeCF];
        [_pFundTradeCF release];
    }
    else
    {
        _pFundTradeCF.frame = rcBuySell;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    //zxl 20130718 修改了不需要底部工具条直接返回
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeFundKH" delegate_:self forToolbar_:toolBar];
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pFundTradeCF)
    {
        bDeal = [_pFundTradeCF OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

@end
