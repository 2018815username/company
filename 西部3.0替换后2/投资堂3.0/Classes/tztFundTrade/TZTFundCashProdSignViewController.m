//
//  TZTFundCashProdSignViewController.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-18.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTFundCashProdSignViewController.h"

@implementation TZTFundCashProdSignViewController

@synthesize pFundTradeZH = _pFundTradeZH;
@synthesize nsGSDM = _nsGSDM;
@synthesize nsGSMC = _nsGSMC;
@synthesize nsCode = _nsCode;
@synthesize nsCodeName = _nsCodeName;
@synthesize nsPhone = _nsPhone;
@synthesize nsEmail = _nsEmail;
@synthesize nsLowmat = _nsLowmat;
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
        strTitle = @"现金产品账户签约";
    }
    else if(_nType == 1)
    {
        strTitle = @"最低留存金设置";
    }
    else
    {
        strTitle = @"现金产品账户解约";
    }
    
    [self onSetTztTitleView:strTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcBuySell.size.height -= _tztTitleView.frame.size.height;
    }else
    {
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    if (_pFundTradeZH == nil)
    {
        _pFundTradeZH = [[TZTFundCashProdSignView alloc] init];
        _pFundTradeZH.delegate = self;
        _pFundTradeZH.nsCode=_nsCode;
        _pFundTradeZH.nsCodeName=_nsCodeName;
        _pFundTradeZH.nsGSDM=_nsGSDM;
        _pFundTradeZH.nsGSMC=_nsGSMC;
        _pFundTradeZH.nType = _nType;
        _pFundTradeZH.nsPhone=_nsPhone;
        _pFundTradeZH.nsEmail=_nsEmail;
        _pFundTradeZH.nsLowmat = _nsLowmat;
        _pFundTradeZH.frame = rcBuySell;
        [_tztBaseView addSubview:_pFundTradeZH];
        [_pFundTradeZH release];
    }
    else
    {
        _pFundTradeZH.frame = rcBuySell;
    }
    
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeFundKH" delegate_:self forToolbar_:toolBar];
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pFundTradeZH)
    {
        bDeal = [_pFundTradeZH OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

@end
