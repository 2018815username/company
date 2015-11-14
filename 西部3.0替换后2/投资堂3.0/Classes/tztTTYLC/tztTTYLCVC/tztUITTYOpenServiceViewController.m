/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        现金增值计划登记vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUITTYOpenServiceViewController.h"

@implementation tztUITTYOpenServiceViewController
@synthesize pTradeView = _pTradeView;
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
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        strTitle = @"现金增值计划登记";
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    if (!g_pSystermConfig.bShowbottomTool)
        rcBuySell.size.height -= (_tztTitleView.frame.size.height);
    else
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
        
    if (_pTradeView == nil)
    {
        _pTradeView = [[tztTTYOpenServiceView alloc] init];
        _pTradeView.nMsgType = _nMsgType;
        _pTradeView.delegate = self;
        _pTradeView.frame = rcBuySell;
        if (self.CurStockCode && [self.CurStockCode length] > 0)
            _pTradeView.CurStockCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
        if (_pTradeView && [_pTradeView respondsToSelector:@selector(SetDefaultData)]) {
            [_pTradeView SetDefaultData];
        }
        [_tztBaseView addSubview:_pTradeView];
        [_pTradeView release];
    }
    else
    {
        _pTradeView.frame = rcBuySell;
    }
    
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"取消|3599"];
    
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pTradeView)
    {
        bDeal = [_pTradeView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

@end
