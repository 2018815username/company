/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUISearchStockViewController.h"

@implementation tztUISearchStockViewController
@synthesize pSearchStockView = _pSearchStockView;
@synthesize nsURL = _nsURL;
@synthesize bShowSearchView = _bShowSearchView;

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
    self.hidesBottomBarWhenPushed = YES;
    [super viewDidLoad];
    [self LoadLayoutView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self LoadLayoutView];
}

-(void)dealloc
{
    DelObject(_pSearchStockView);
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"个股查询";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn];
    _tztTitleView.bShowSearchBar = FALSE;
    
    CGRect rcStock = rcFrame;
    rcStock.origin.y += _tztTitleView.frame.size.height;
#ifdef tzt_NewVersion
    rcStock.size.height = rcFrame.size.height -  _tztTitleView.frame.size.height;
#else
    if (g_pSystermConfig.bShowbottomTool)
        rcStock.size.height = rcFrame.size.height -  _tztTitleView.frame.size.height - TZTToolBarHeight;
    else
        rcStock.size.height = rcFrame.size.height -  _tztTitleView.frame.size.height;
#endif
    if(_pSearchStockView == nil)
    {
        _pSearchStockView = [[tztUISearchStockView alloc] init];
        if (self.nsURL)
            _pSearchStockView.nsURL = [NSString stringWithFormat:@"%@", self.nsURL];
        _pSearchStockView.bShowSearchView = _bShowSearchView;
        _pSearchStockView.tztdelegate = self;
        _pSearchStockView.frame = rcStock;
        [_tztBaseView addSubview:_pSearchStockView];
    }
    else
    {
        _pSearchStockView.frame = rcStock;
    }
    
#ifndef tzt_NewVersion
    [self CreateToolBar];
#endif
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
#ifdef tzt_NewVersion
    return;
#endif
    
    [super CreateToolBar];
    if(![super toolBarItemForContainService])
    {   
        [tztUIBarButtonItem GetToolBarItemByKey:nil delegate_:self forToolbar_:toolBar];
    }
}

-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo *)pStock
{
    if (pStock == NULL || pStock.stockCode == NULL || [pStock.stockCode length] <= 0)
        return;
    
    if(hqView == _pSearchStockView)
    {
#ifndef tzt_NewVersion
        [g_navigationController popViewControllerAnimated:NO];
#endif
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)self.pSearchStockView.pStockArray];
    }
}

-(void)OnReturnBack
{
#ifdef tzt_NewVersion
    [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
#else
    [super OnReturnBack];
#endif
}
@end
