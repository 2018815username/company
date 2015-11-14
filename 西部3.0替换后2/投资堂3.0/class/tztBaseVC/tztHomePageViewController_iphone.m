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

#import "tztHomePageViewController_iphone.h"

#define tztReportPageHeight 48
#define tztNineGridViewHeight 150
@implementation tztHomePageViewController_iphone

@synthesize pNineGridView = _pNineGridView;
@synthesize pReportPageView = _pReportPageView;
@synthesize pInfoTableView = _pInfoTableView;
@synthesize pMutilViews = _pMutilViews;
@synthesize pAyViews = _pAyViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [super dealloc];
}
#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_pInfoTableView && !_bLoad)
        [_pInfoTableView RequestData];
    if (_pReportPageView)
        [_pReportPageView onSetViewRequest:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _bLoad = FALSE;
    if (_pReportPageView)
        [_pReportPageView onSetViewRequest:NO];
}

-(void)CreateSigleView
{
    CGRect rcInit = _tztBounds;
    
#ifdef Support_EXE_VERSION
    [self onSetTztTitleView:g_pSystermConfig.strMainTitle type:TZTTitleIcon];
//    [self.tztTitleView.firstBtn setBackgroundImage:[UIImage imageNamed:@"Icon"] forState:UIControlStateNormal];
//    
#else
    if (self.nsTitle.length < 1)
        self.nsTitle = [NSString stringWithFormat:@"%@", g_pSystermConfig.strMainTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleName];
#endif
    //顶部国际指数
    CGRect rcFrame = rcInit;
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height = tztReportPageHeight;
    if (_pReportPageView == nil)
    {
        _pReportPageView = [[tztReportPage alloc] init];
        _pReportPageView.tztdelegate = self;
        _pReportPageView.frame = rcFrame;
        [_tztBaseView addSubview:_pReportPageView];
        [_pReportPageView release];
    }
    else
    {
        _pReportPageView.frame = rcFrame;
    }
    
    [_pReportPageView setStockInfo:nil Request:1];
    
    rcFrame.origin.y += rcFrame.size.height;
    rcFrame.size.height = tztNineGridViewHeight;
    
#ifndef Support_HomePageScroll
    NSArray *pAy = NULL;
    if (g_pSystermConfig)
       pAy = [g_pSystermConfig.pDict objectForKey:@"TZTMainGrid"];
    //中间的两行功能按钮
    if (_pNineGridView == nil)
    {
        _pNineGridView = [[tztUINineGridView alloc] init];
        _pNineGridView.rowCount = 2;
        _pNineGridView.colCount = [pAy count] / 2 + ([pAy count] % 2 ? 1 : 0);
        _pNineGridView.nFixCol = 4;
        _pNineGridView.bIsMoreView = NO;
        _pNineGridView.tztdelegate = self;
        _pNineGridView.fCellSize = 46;
        _pNineGridView.frame = rcFrame;
        [_pNineGridView setAyCellDataAll:pAy];
        [_pNineGridView setAyCellData:pAy];
        [_tztBaseView addSubview:_pNineGridView];
        [_pNineGridView release];
    }
    else
    {
        _pNineGridView.frame = rcFrame;
    }
    
#else
    if (_pMutilViews == NULL)
    {
        _pMutilViews = [[tztMutilScrollView alloc] init];
        _pMutilViews.bSupportLoop = NO;
        _pMutilViews.tztdelegate = self;
        [_tztBaseView addSubview:_pMutilViews];
        [_pMutilViews release];
        
        if(_pAyViews == nil)
            _pAyViews = NewObject(NSMutableArray);
        [_pAyViews removeAllObjects];
        
        tztUINineGridView *pFirstNine = [[tztUINineGridView alloc] initWithFrame:rcFrame];
        pFirstNine.rowCount = 2;
        pFirstNine.colCount = 4;
        pFirstNine.bIsMoreView = YES;
        pFirstNine.tztdelegate = self;
        
        tztUINineGridView *pSecondNine = [[tztUINineGridView alloc] initWithFrame:rcFrame];
        pSecondNine.rowCount = 2;
        pSecondNine.colCount = 4;
        pSecondNine.bIsMoreView = YES;
        pSecondNine.tztdelegate = self;
        
        if (g_pSystermConfig)
        {
            NSArray* pAy = [g_pSystermConfig.pDict objectForKey:@"TZTMainGrid"];
            if (pAy && [pAy count] > 0)
            {
                [pFirstNine setAyCellDataAll:pAy];
                [pFirstNine setAyCellData:pAy];
            }
            
            NSArray* pAyEx = [g_pSystermConfig.pDict objectForKey:@"TZTMainGridEx"];
            if (pAyEx && [pAyEx count] > 0)
            {
                [pSecondNine setAyCellDataAll:pAyEx];
                [pSecondNine setAyCellData:pAyEx];
            }
        }
        
        [_pAyViews addObject:pFirstNine];
        [_pAyViews addObject:pSecondNine];
        
        _pMutilViews.pageViews = _pAyViews;
        _pMutilViews.nCurPage = 0;
        
        _pMutilViews.frame = rcFrame;
        [pFirstNine release];
        [pSecondNine release];
        
    }
#endif
    rcFrame.origin.y += rcFrame.size.height;
    
#ifdef tzt_NewVersion
    rcFrame.size.height = rcInit.size.height - rcFrame.origin.y;
#else
    rcFrame.size.height = rcInit.size.height - rcFrame.origin.y - TZTToolBarHeight;
#endif
    //资讯列表
    if (_pInfoTableView == nil)
    {
        _pInfoTableView = [[tztHomePageInfoView alloc] initWithFrame:rcFrame];
        _bLoad = TRUE;
        _pInfoTableView.tztHomePageInfodelegate = self;
        [_tztBaseView addSubview:_pInfoTableView];
        [_pInfoTableView release];
        [_pInfoTableView RequestData];
    }
    else
    {
        _pInfoTableView.frame =  rcFrame;
    }

    [self CreateToolBar];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreateSigleView];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
  //  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//创建toolbar
-(void)CreateToolBar
{
#ifdef tzt_NewVersion  // 新版不要toolBar byDBQ20130715  直接跳出该方法
    return;
#endif
    [super CreateToolBar];
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolbarHomePage" delegate_:self forToolbar_:toolBar];
}

//设置首页资讯不全屏显示
-(void)setInfoViewFrame
{
    if (_pInfoTableView == NULL)
        return;
    
    if (_bIsFull && _pInfoTableView)
    {
        [_pInfoTableView tztperformSelector:@"OnBtnFullScreen:" withObject:nil];
    }
}

//显示更多 该工程没走？
-(void)OnMore
{
    //首先获取更多需要显示的东西
    if (g_pSystermConfig == NULL || g_pSystermConfig.pDict == NULL)
        return;
    
    NSArray* pAy = [g_pSystermConfig.pDict objectForKey:@"TZTToolbarMoreSys"];
    tztToolbarMoreView *pMoreView = (tztToolbarMoreView*)[self.view viewWithTag:0x7878];
    if (pMoreView == NULL)
    {
        pMoreView = [[tztToolbarMoreView alloc] init];
        pMoreView.tag = 0x7878;
        pMoreView.nPosition = tztToolbarMoreViewPositionBottom;
        [pMoreView SetAyGridCell:pAy];
        pMoreView.pDelegate = self;
        pMoreView.frame = _tztBaseView.frame;
        [self.view addSubview:pMoreView];
        [pMoreView release];
    }
    else
    {
        [pMoreView removeFromSuperview];
    }
}
//资讯全屏按钮
-(void)tztHomePageInfoView:(id)tztInfoView fullscreen:(BOOL)bfull
{
    UIView* pView = _pNineGridView;
#ifdef Support_HomePageScroll
    pView = _pMutilViews;
#endif
    if (_pInfoTableView && _tztTitleView && _pReportPageView && pView)
    {
        CGRect rcFrame = _tztBounds;
        rcFrame.origin = CGPointZero;
        _bIsFull = bfull;
        
        if (bfull)//非全屏
        {
            rcFrame.origin.y +=  _tztTitleView.frame.size.height;
#ifdef tzt_NewVersion
            rcFrame.size.height = rcFrame.size.height - _tztTitleView.frame.size.height;
#else
            rcFrame.size.height = rcFrame.size.height - _tztTitleView.frame.size.height - TZTToolBarHeight;
#endif
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationDuration:0.15];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationDelegate:_pInfoTableView];
            [UIView setAnimationDidStopSelector:@selector(reloadAllData)];
            _pInfoTableView.frame = rcFrame;
            [UIView commitAnimations];
        }
        else
        {
            rcFrame.origin.y += _tztTitleView.frame.size.height + pView.frame.size.height + _pReportPageView.frame.size.height;
#ifdef tzt_NewVersion
            rcFrame.size.height = rcFrame.size.height - _tztTitleView.frame.size.height - pView.frame.size.height - _pReportPageView.frame.size.height;
#else
            rcFrame.size.height = rcFrame.size.height - _tztTitleView.frame.size.height - pView.frame.size.height - _pReportPageView.frame.size.height - TZTToolBarHeight;
#endif
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationDuration:0.15];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationDelegate:_pInfoTableView];
            [UIView setAnimationDidStopSelector:@selector(reloadAllData)];
            _pInfoTableView.frame = rcFrame;
            [UIView commitAnimations];
            
        }
    } 
}

//九宫格点击
-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    [TZTUIBaseVCMsg OnMsg:cellData.cmdid wParam:0 lParam:0];
}


//国际指数点击
-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo *)pStock
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:0];
}

@end
