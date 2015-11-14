/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金转换
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundZHVC.h"

@implementation tztUIFundZHVC
@synthesize pFundTradeZH = _pFundTradeZH;
@synthesize nFlag = _nFlag;
@synthesize CurStockCode = _CurStockCode;
@synthesize pDict = _pDict;

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
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"基金转换";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:@"基金转换" type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    if (!g_pSystermConfig.bShowbottomTool)
        rcBuySell.size.height -= _tztTitleView.frame.size.height;
    else
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    
    if (_pFundTradeZH == nil)
    {
        _pFundTradeZH = [[tztFundZHView alloc] init];
        _pFundTradeZH.delegate = self;
//        _pFundTradeZH.pDefaultDataDict = self.pDict;
        _pFundTradeZH.frame = rcBuySell;
        if (self.CurStockCode && [self.CurStockCode length] > 0)
            _pFundTradeZH.nsCurStock = [NSString stringWithFormat:@"%@",self.CurStockCode];
        
        if (_pFundTradeZH && [_pFundTradeZH respondsToSelector:@selector(SetDefaultData)]) {
            [_pFundTradeZH SetDefaultData];
        }        
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
