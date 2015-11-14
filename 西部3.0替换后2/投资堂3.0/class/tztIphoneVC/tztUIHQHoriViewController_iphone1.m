/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        iphone分时显示vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIHQHoriViewController_iphone.h"

#define TZTQuoteHeight 60
@implementation tztUIHQHoriViewController_iphone
@synthesize pTitleView = _pTitleView;
@synthesize pListView = _pListView;
@synthesize pMutilViews = _pMutilViews;
@synthesize pAyViews = _pAyViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
#ifdef TZT_ZYData
        _viewkind = HoriViewKind_Trend;
#endif
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)setViewKind:(TZTHoriViewKind)viewkind
{
    _viewkind = viewkind;
#ifdef TZT_ZYData
//    if(_trendView)
//    {
//        _trendView.hidden = !(_viewkind == HoriViewKind_Trend);
//    }
//    if(_techView)
//    {
//        _techView.hidden = !(_viewkind == HoriViewKind_Tech);
//    }
#endif
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#ifdef TZT_ZYData
    if (_trendView)
    {
        [_trendView onSetViewRequest:(_viewkind == HoriViewKind_Trend)];
        [_trendView onSetViewRequest:YES];
    }
#endif
    
    if (_techView)
    {
        [_techView onSetViewRequest:(_viewkind == HoriViewKind_Tech)];
#ifdef TZT_ZYData
        [_techView onSetViewRequest:YES];
#endif
    }
    
    [tztUIHelperImageView tztHelperViewDismiss];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(IS_TZTIOS(8))
    {
        int n = [UIDevice currentDevice].orientation;
        if (n != self.interfaceOrientation)
            [self willRotateToInterfaceOrientation:n duration:0.2];
    }
    
//    [self LoadLayoutView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
#ifdef TZT_ZYData
    if (_trendView)
    {
        [_trendView onSetViewRequest:NO];
    }
#endif
    
    if (_techView)
    {
        [_techView onSetViewRequest:NO];
    }
}

-(void)dealloc
{
    NilObject(_pTitleView);
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
//    if (IS_TZTIOS(7))
//    {
//        rcFrame.origin.y += TZTStatuBarHeight;
//    }
//    _tztBaseView.frame = rcFrame; // 横屏强制_tztBaseView的frame byDBQ20130726
    //标题view
    CGRect rcTitle = rcFrame;
    rcTitle.size.height = TZTToolBarHeight + (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
    if (_pTitleView == nil)
    {
        _pTitleView = [[TZTUIBaseTitleView alloc] init];
        _pTitleView.nType = TZTTitleReturn | TZTTitleStock | TZTTitlePreNext;
        _pTitleView.pDelegate = self;
        _pTitleView.frame = rcTitle;
        if (self.pStockInfo && self.pStockInfo.stockCode)
        {
            [_pTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:self.pStockInfo.stockName];
        }
        else
        {
            [_pTitleView setCurrentStockInfo:@"" nsName_:@""];
        }
        [_tztBaseView addSubview:_pTitleView];
        [_pTitleView release];
    }
    else
    {
        _pTitleView.frame = rcTitle;
    }
    
    CGRect rcStock = rcFrame;
    rcStock.origin.y += rcTitle.size.height;
    rcStock.size.height = rcFrame.size.height - rcTitle.size.height;
#ifdef TZT_ZYData
    if (_pMutilViews == nil)
    {
        _pMutilViews = [[tztMutilScrollView alloc] init];
        _pMutilViews.bSupportLoop = NO;
        _pMutilViews.tztdelegate = self;
        _pMutilViews.frame = rcStock;
        _pMutilViews.frame = CGRectMake(0, 0, rcStock.size.width, rcStock.size.height);
        [_tztBaseView addSubview:_pMutilViews];
        [_pMutilViews release];
        
        if(_pAyViews == nil)
            _pAyViews = NewObject(NSMutableArray);
        [_pAyViews removeAllObjects];
    
        //分时
        if(_trendView == nil)
        {
            _trendView = [[tztTrendView alloc] init];
            [_trendView setStockInfo:self.pStockInfo Request:(_viewkind == HoriViewKind_Trend)];
            _trendView.tztdelegate = self;
            [_pAyViews addObject: _trendView];
            [_trendView release];
        }
#endif
    
        //k线
        if(_techView == nil)
        {
            _techView = [[tztTechView alloc] initWithFrame:rcStock];
            _techView.tztdelegate = self;
            _techView.bTechMoved = YES;
            _viewkind == HoriViewKind_Tech ? [_pAyViews insertObject:_techView atIndex:0] : [_pAyViews addObject: _techView];
            [_tztBaseView addSubview:_techView];
#ifdef TZT_ZYData
//            [_pAyViews addObject: _techView];
#endif
            [_techView release];
            [_techView setHisBtnShow:FALSE];
        }
        else
        {
            _techView.frame = rcStock;
        }
    
#ifdef TZT_ZYData
        _pMutilViews.pageViews = _pAyViews;
        _pMutilViews.nCurPage = 1;
    }
    _pMutilViews.frame = rcStock;
    
    [self setViewKind:_viewkind];
#endif
    [self setStockInfo:nil nRequest_:1];
}

-(void)tztMutilPageViewDidAppear:(NSInteger)CurrentViewIndex
{
    if (CurrentViewIndex < 0 || CurrentViewIndex >= [_pAyViews count])
        return;
    
    UIView* pView = [_pAyViews objectAtIndex:CurrentViewIndex];
    if (pView && [pView isKindOfClass:[tztHqBaseView class]])
    {
#ifdef TZT_ZYData
        if ([pView isKindOfClass:[tztTechView class]])
        {
            [self setViewKind:HoriViewKind_Tech];
            [_techView onSetViewRequest:YES];
            [_techView setStockInfo:self.pStockInfo Request:YES];
            [_trendView onSetViewRequest:NO];
        }
        else
#endif
        {
            [self setViewKind:HoriViewKind_Trend];
            [_trendView onSetViewRequest:YES];
            [_trendView setStockInfo:self.pStockInfo Request:YES];
            [_techView onSetViewRequest:NO];
        }
    }
}


-(void)tztMutilPageViewDidDisappear:(NSInteger)CurrentViewIndex
{
#ifdef TZT_ZYData
    [_trendView onSetViewRequest:NO];
#endif
    [_techView onSetViewRequest:NO];
}

-(void)CreateToolBar
{
}

//显示更多
-(void)OnMore
{
    
}


//更多中点击
-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation) && UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        //        TZTNSLog(@"%@",@"hori OnReturnBack");
        self.parentViewController.hidesBottomBarWhenPushed = NO;
        self.navigationController.hidesBottomBarWhenPushed = NO;
        g_navigationController.hidesBottomBarWhenPushed = NO;
        g_navigationController.topViewController.hidesBottomBarWhenPushed = NO;
        
        _techView.tztdelegate = nil;
        [super OnReturnBack];
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
//        {
//            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)toInterfaceOrientation];
//        }
    }
    else
    {
        int nToolBarHeight = TZTToolBarHeight + TZTStatuBarHeight / 2;
        if (g_pSystermConfig && g_pSystermConfig.nToolBarHeight != 0)
            nToolBarHeight = g_pSystermConfig.nToolBarHeight;
        
        if (IS_TZTIPAD)
            g_nScreenHeight = TZTScreenWidth - TZTStatuBarHeight - nToolBarHeight;
        else
            g_nScreenHeight = TZTScreenWidth - TZTStatuBarHeight/* - TZTToolBarHeight*/;
        g_nScreenWidth = TZTScreenHeight;
        if (IS_TZTIOS(7))
            self.view.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight + TZTStatuBarHeight);
        else
            self.view.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
        
        _tztBaseView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        CGRect rcFrame = self.view.bounds;
#ifdef __IPHONE_7_0
        if (IS_TZTIOS(7))
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            if (([self getVcShowKind] == tztvckind_Pop) && IS_TZTIPAD)
            {
            }
            else
            {
//                rcFrame.origin.y += TZTStatuBarHeight;
//                rcFrame.size.height -= TZTStatuBarHeight;
            }
        }
#endif
        _tztBaseView.frame = rcFrame;
        if ([self getVcShowKind] == tztvckind_Pop)
        {
            if (IS_TZTIPAD)
            {
                _tztFrame = self.view.frame;
                _tztBounds = self.view.bounds;
            }
            else
            {
                _tztBounds = _tztBaseView.bounds;
                _tztFrame = _tztBaseView.frame;
            }
        }
        else
        {
            _tztBounds = _tztBaseView.bounds;
            _tztFrame = _tztBaseView.frame;
        }
        
        [self LoadLayoutView];
    }
//    return  UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    TZTNSLog(@"hori shouldAutorotateToInterfaceOrientation=%d=%d",interfaceOrientation,self.interfaceOrientation);
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation) && UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        //        TZTNSLog(@"%@",@"hori OnReturnBack");
        _techView.tztdelegate = nil;
        [self OnReturnBack];
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
        {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIInterfaceOrientationPortrait];
        }
    }
    return  UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//前一个股票
-(void)OnBtnPreStock:(id)sender
{
    if (_pListView && [_pListView isKindOfClass:[tztReportListView class]])
    {
        NSArray *pAy = [(tztReportListView*)_pListView tztGetPreStock];
        if(pAy == NULL)
            return;
        NSInteger nCount = [pAy count];
        if (nCount < 1)
            return;
        
        TZTGridData* valuedata = [pAy objectAtIndex:nCount-1];
        NSString* strCode = valuedata.text;
        TZTGridData* namedata = [pAy objectAtIndex:0];
        NSString* strName = namedata.text;
        TZTGridData* typedata = [pAy objectAtIndex:1];
        NSString* strType = typedata.text;
 
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
        pStock.stockType = [strType intValue];
        [self setStockInfo:pStock nRequest_:1];
    }
}

//后一个股票
-(void)OnBtnNextStock:(id)sender
{
    if (_pListView && [_pListView isKindOfClass:[tztReportListView class]])
    {
        NSArray *pAy = [(tztReportListView*)_pListView tztGetNextStock];
        if(pAy == NULL)
            return;
        NSInteger nCount = [pAy count];
        if (nCount < 1)
            return;
        TZTGridData* valuedata = [pAy objectAtIndex:nCount-1];
        NSString* strCode = valuedata.text;
        TZTGridData* namedata = [pAy objectAtIndex:0];
        NSString* strName = namedata.text;
        TZTGridData* typedata = [pAy objectAtIndex:1];
        NSString* strType = typedata.text;
        
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
        pStock.stockType = [strType intValue];
        
        [self setStockInfo:pStock nRequest_:1];
    }
}

-(void)setStockInfo:(tztStockInfo *)pStock nRequest_:(int)nRequest
{
    if(pStock)
    {
        self.pStockInfo = pStock;
    }
    if (self.pStockInfo && self.pStockInfo.stockCode)
    {
        if (self.pTitleView)
        {
            [self.pTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:self.pStockInfo.stockName];
        }
        
#ifdef TZT_ZYData
        if (_trendView && _viewkind == HoriViewKind_Trend)
        {
            [_trendView onSetViewRequest:YES];
            [_techView onSetViewRequest: NO];
            [_trendView setStockInfo:self.pStockInfo Request:YES];
        }
#endif
//
        if( _techView && _viewkind == HoriViewKind_Tech)
        {
            [_techView onSetViewRequest:YES];
            [_trendView onSetViewRequest:NO];
            [_techView setStockInfo:self.pStockInfo Request:YES];
        }
    }
}

@end
