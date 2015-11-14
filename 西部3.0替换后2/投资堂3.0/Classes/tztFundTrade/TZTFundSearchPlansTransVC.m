//
//  TZTFundSearchPlansTransVC.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-20.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTFundSearchPlansTransVC.h"

@implementation TZTFundSearchPlansTransVC

@synthesize pFundTrade = _pFundTrade;
@synthesize nsGSDM = _nsGSDM;
@synthesize nsGSMC = _nsGSMC;
@synthesize nsCode = _nsCode;
@synthesize nsCodeName = _nsCodeName;
@synthesize nType = _nType;

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
    //标题view
    NSString *strTitle = @"基金转换";
    if (_nType == 0)
    {
        strTitle = @"定时定额转账参与签约";
    }
    else if(_nType == 1)
    {
        strTitle = @"最低留存金设置";
    }
    else
    {
        strTitle = @"定时定额转账参与解约";
    }
    
    [self onSetTztTitleView:strTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    //zxl 20130718 修改了不需要底部工具条Frame 高度修改
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcBuySell.size.height -= _tztTitleView.frame.size.height ;
    }else
    {
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    if (_pFundTrade == nil)
    {
        _pFundTrade = [[TZTFundSearchPlansTransView alloc] init];
        _pFundTrade.delegate = self;
        _pFundTrade.nsCode=_nsCode;
        _pFundTrade.nsCodeName=_nsCodeName;
        _pFundTrade.nsGSDM=_nsGSDM;
        _pFundTrade.nsGSMC=_nsGSMC;
        _pFundTrade.nType = _nType;
        _pFundTrade.frame = rcBuySell;
        [_tztBaseView addSubview:_pFundTrade];
        [_pFundTrade release];
    }
    else
    {
        _pFundTrade.frame = rcBuySell;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
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
    if (_pFundTrade)
    {
        bDeal = [_pFundTrade OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

@end
