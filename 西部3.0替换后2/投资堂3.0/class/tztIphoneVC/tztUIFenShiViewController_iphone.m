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

#import "tztUIFenShiViewController_iphone.h"

id g_pFenShiViewController = nil;

#define TZTQuoteHeight 60
@implementation tztUIFenShiViewController_iphone
@synthesize pStockView = _pStockView;
@synthesize pListView = _pListView;
@synthesize hasNoAddBtn = _hasNoAddBtn;
@synthesize hasNoSearch = _hasNoSearch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        _nStockNameIndex = -1;
        _nStockCodeIndex = -1;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_pStockView)
        [_pStockView onSetViewRequest:YES];
    
    int n = self.interfaceOrientation;
    if (IS_TZTIOS(8))
        n = [UIDevice currentDevice].orientation;
    if(UIInterfaceOrientationIsLandscape(n))
    {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
        {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIInterfaceOrientationPortrait];
        }
    }
//    [self LoadLayoutView];
//    if (_pStockView)
//    {
////        CGRect rc = _pStockView.frame;
//        [_pStockView onSetViewRequest:YES];
////        _pStockView.frame = rc;
//    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self LoadLayoutView]; // 只能load一次，查询股票点分时这里闪退，去掉viewDidLoad里的 byDBQ20140109
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_pStockView)
        [_pStockView onSetViewRequest:NO];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    if (self.hasNoSearch)
        [self onSetTztTitleView:@"" type:TZTTitleReturn | TZTTitleStock | TZTTitlePreNext];
    else
        [self onSetTztTitleView:@"" type:TZTTitleDetail];
    
    if (self.pStockInfo && self.pStockInfo.stockCode && [self.pStockInfo.stockCode length] > 0)
    {
        if (self.pStockInfo.stockName)
            [_tztTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:self.pStockInfo.stockName];
        else
            [_tztTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:@""];
    }
    
    CGRect rcFrame = _tztBounds;
    CGRect rcStock = _tztBounds;
    rcStock.origin.y += _tztTitleView.frame.size.height;
#ifdef tzt_NewVersion // 去toolBar高度 byDBQ20130716
    rcStock.size.height = rcFrame.size.height - _tztTitleView.frame.size.height + 10; // 10是调整值 byDBQ20130716
#else
    if (g_pSystermConfig && !g_pSystermConfig.bShowbottomTool)
        rcStock.size.height = rcFrame.size.height - _tztTitleView.frame.size.height;
    else
        rcStock.size.height = rcFrame.size.height - _tztTitleView.frame.size.height - TZTToolBarHeight;
#endif
#ifdef tzt_NewVersion
    rcStock.size.height -= TZTStatuBarHeight / 2;
#endif

    if (_pStockView == NULL)
    {
        _pStockView = [[tztUIStockView alloc] init];
        _pStockView.tztdelegate = self;
        [_tztBaseView addSubview:_pStockView];
        [_pStockView release];
    }
    _pStockView.hasNoAddBtn = self.hasNoAddBtn;
    _pStockView.frame = rcStock;
    if (self.pStockInfo && self.pStockInfo.stockCode && [self.pStockInfo.stockCode length] > 0)
    {
        [_pStockView setStockInfo:self.pStockInfo Request:0];
    }
#ifdef tzt_NewVersion // 去toolBar byDBQ20130716
#else
    [self CreateToolBar];
#endif
}


-(void)CreateToolBar
{
    if (g_pSystermConfig && !g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:nil delegate_:self forToolbar_:toolBar];
}


//显示更多
-(void)OnMore
{
    //首先获取更多需要显示的东西
    if ([TZTCSystermConfig getShareClass] == NULL || [TZTCSystermConfig getShareClass].pDict == NULL)
        return;
    
    NSArray* pAy = [[TZTCSystermConfig getShareClass].pDict objectForKey:@"TZTToolbarMoreHQ"];
    tztToolbarMoreView *pMoreView = (tztToolbarMoreView*)[self.view viewWithTag:0x7878]; // 避免分时界面点更多重复出现 byDBQ20130725
    if (pMoreView == NULL)
    {
        pMoreView = [[tztToolbarMoreView alloc] init];
        pMoreView.nPosition = tztToolbarMoreViewPositionBottom;
        [pMoreView SetAyGridCell:pAy];
        pMoreView.pDelegate = self;
        pMoreView.tag = 0x7878;
        pMoreView.frame = _tztBaseView.frame;
        [self.view addSubview:pMoreView];
        [pMoreView release];
    }
    else
    {
        [pMoreView removeFromSuperview];
    }
}


//更多中点击
-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    if (self.pStockView)
    {
        tztStockInfo *pStock = [self.pStockView GetCurrentStock];
        [TZTUIBaseVCMsg OnMsg:cellData.cmdid wParam:(NSUInteger)pStock lParam:0];
    }
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
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        int nMsgType = HQ_MENU_HoriTech;
#ifdef TZT_ZYData
        nMsgType = HQ_MENU_HoriTrend;
        if(_pStockView && [_pStockView isTechView])
            nMsgType = HQ_MENU_HoriTech;
#endif
        [TZTUIBaseVCMsg OnMsg:nMsgType wParam:(NSUInteger)self.pStockInfo lParam:(NSUInteger)_pListView];
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
//        {
//            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)toInterfaceOrientation];
//        }
    }
    else
    {
        if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation) && UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            CGRect frame = self.view.frame;
            if(frame.size.width > frame.size.height)
                self.view.frame = CGRectMake(frame.origin.y, frame.origin.x, frame.size.height+TZTStatuBarHeight, frame.size.width-TZTStatuBarHeight);
            [self LoadLayoutView];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (UIInterfaceOrientationPortrait == interfaceOrientation);
    
//    TZTNSLog(@"shouldAutorotateToInterfaceOrientation=%d=%d",interfaceOrientation,self.interfaceOrientation);
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation) && UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        int nMsgType = HQ_MENU_HoriTech;
#ifdef TZT_ZYData
        nMsgType = HQ_MENU_HoriTrend;
        if(_pStockView && [_pStockView isTechView])
            nMsgType = HQ_MENU_HoriTech;
#endif
//         TZTNSLog(@"TZTUIBaseVCMsg OnMsg%d",nMsgType);
        [TZTUIBaseVCMsg OnMsg:nMsgType wParam:(NSUInteger)self.pStockInfo lParam:(NSUInteger)_pListView];
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
        {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)interfaceOrientation];
        }
    }
    return (UIInterfaceOrientationPortrait == interfaceOrientation);
}

//后一个股票
-(void)OnBtnPreStock:(id)sender
{
    if (_pListView && [_pListView isKindOfClass:[tztReportListView class]])
    {
        NSArray *pAy = [(tztReportListView*)_pListView tztGetPreStock];
        if(pAy == NULL)
            return;
        NSUInteger nCount = [pAy count];
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
        [tztUserStock AddRecentStock:pStock];
        [self setStockInfo:pStock nRequest_:1];
    }
    else if ([_pListView isKindOfClass:[TZTUIReportGridView class]])
    {
        NSArray *pAy = [(tztReportListView*)_pListView tztGetPreStock];
        if(pAy == NULL)
            return;
        NSInteger nCount = [pAy count];
        if (nCount < 1)
            return;
        TZTGridData* valuedata;
        if (_nStockCodeIndex >= 0) {
            valuedata= [pAy objectAtIndex:_nStockCodeIndex];
        }
        else
        {
            valuedata= [pAy objectAtIndex:0];
        }
        NSString* strCode = valuedata.text;
        
        TZTGridData* namedata;
        if (_nStockNameIndex >= 0) {
            namedata= [pAy objectAtIndex:_nStockNameIndex];
        }
        else
        {
            namedata= [pAy objectAtIndex:1];
        }
        NSString* strName = namedata.text;
        
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
        
//        [tztUserStock AddRecentStock:pStock];
        [self setStockInfo:pStock nRequest_:1];
    }
    else if ([_pListView isKindOfClass:[NSMutableArray class]])//数组传入
    {
        NSMutableArray *ay = (NSMutableArray *)_pListView;
        _nCurrentIndex++;
        if (_nCurrentIndex >= [ay count])
            _nCurrentIndex = 0;
        
        id data = [ay objectAtIndex:_nCurrentIndex];
        if (data && [data isKindOfClass:[tztStockInfo class]])
        {
            [self setStockInfo:data nRequest_:1];
        }
        else if (data && [data isKindOfClass:[NSDictionary class]])
        {
            tztStockInfo *pStock = NewObject(tztStockInfo);
            NSString* strCode = [[data tztObjectForKey:@"Code"] tztObjectForKey:@"value"];
            NSString* strName = [[data tztObjectForKey:@"Name"] tztObjectForKey:@"value"];
            int nStockType = [[data tztObjectForKey:@"StockType"] intValue];
            
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            pStock.stockName = [NSString stringWithFormat:@"%@", strName];
            pStock.stockType = nStockType;
            [self setStockInfo:pStock nRequest_:1];
            DelObject(pStock);
        }
    }
}

//前一个股票
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
        
        [tztUserStock AddRecentStock:pStock];
        [self setStockInfo:pStock nRequest_:1];
    }
    else if ([_pListView isKindOfClass:[TZTUIReportGridView class]])
    {
        NSArray *pAy = [(tztReportListView*)_pListView tztGetNextStock];
        if(pAy == NULL)
            return;
        NSInteger nCount = [pAy count];
        if (nCount < 1)
            return;
        TZTGridData* valuedata;
        if (_nStockCodeIndex >= 0) {
            valuedata= [pAy objectAtIndex:_nStockCodeIndex];
        }
        else
        {
            valuedata= [pAy objectAtIndex:0];
        }
        NSString* strCode = valuedata.text;
        
        TZTGridData* namedata;
        if (_nStockNameIndex >= 0) {
            namedata= [pAy objectAtIndex:_nStockNameIndex];
        }
        else
        {
            namedata= [pAy objectAtIndex:1];
        }
        NSString* strName = namedata.text;

        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
        
//        [tztUserStock AddRecentStock:pStock];
        [self setStockInfo:pStock nRequest_:1];
    }
    else if ([_pListView isKindOfClass:[NSMutableArray class]])
    {
        NSMutableArray *ay = (NSMutableArray *)_pListView;
        _nCurrentIndex--;
        if (_nCurrentIndex < 0)
            _nCurrentIndex = [ay count] - 1;
        
        id data = [ay objectAtIndex:_nCurrentIndex];
        if (data && [data isKindOfClass:[tztStockInfo class]])
        {
            [self setStockInfo:data nRequest_:1];
        }
        else if (data && [data isKindOfClass:[NSDictionary class]])
        {
            tztStockInfo *pStock = NewObject(tztStockInfo);
            NSString* strCode = [[data tztObjectForKey:@"Code"] tztObjectForKey:@"value"];
            NSString* strName = [[data tztObjectForKey:@"Name"] tztObjectForKey:@"value"];
            int nStockType = [[data tztObjectForKey:@"StockType"] intValue];
            
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            pStock.stockName = [NSString stringWithFormat:@"%@", strName];
            pStock.stockType = nStockType;
            [self setStockInfo:pStock nRequest_:1];
            DelObject(pStock);
        }
        
    }

}

-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo*)pStock
{
    self.pStockInfo = pStock;
    if (self.pStockInfo && self.pStockInfo.stockCode)
    {
        if (_tztTitleView)
        {
            [_tztTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:self.pStockInfo.stockName];
        }
    }
}

-(void)setStockInfo:(tztStockInfo *)pStock nRequest_:(int)nRequest
{
    self.pStockInfo = pStock;
    if (self.pStockInfo && self.pStockInfo.stockCode)
    {
        if (_tztTitleView)
        {
            [_tztTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:self.pStockInfo.stockName];
        }
        if (self.pStockView)
        {
            [self.pStockView setStockInfo:self.pStockInfo Request:1];
        }
//        if (self.pQuoteView)
//        {
//            [self.pQuoteView setStockCode:strCode Request:nRequest];
//        }
//        if (self.pTrendView)
//        {
//            [self.pTrendView setStockCode:strCode Request:nRequest];
//        }
    }
}

-(void)tzthqView:(id)hqView RequestHisTrend:(tztStockInfo *)pStock nsHisDate:(NSString *)nsHisDate
{
    NSMutableDictionary* pDict = [[NSMutableDictionary alloc] init];
    [pDict setTztObject:hqView forKey:@"tztDelegate"];
    [pDict setTztObject:pStock forKey:@"tztStock"];
    [pDict setTztObject:nsHisDate forKey:@"tztHisDate"];
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_HisTrend wParam:(NSUInteger)pDict lParam:0];
    DelObject(pDict);
}

-(void)tztQuickBuySell:(id)send nType_:(NSInteger)nType
{
    //获取当前的股票代码
    tztStockInfo *pStock = NULL;
    if ([send isKindOfClass:[tztHqBaseView class]])
    {
       pStock = ((tztHqBaseView*)send).pStockInfo;
    }
    
    NSMutableDictionary * dict = GetDictByListName(@"KMKM");
    BOOL bKMKMNormal = [[dict objectForKey:@"KMKMNormal"] boolValue];
    
    switch (nType)
    {
        case tztBtnStockTag://持仓
        {
            if (bKMKMNormal) {
                [TZTUIBaseVCMsg OnMsg:WT_RZRQQUERYGP wParam:0 lParam:1];
            }
            else {
                [TZTUIBaseVCMsg OnMsg:WT_QUERYGP wParam:(NSUInteger)pStock lParam:1];
            }
            
        }
            break;
        case tztBtnTradeBuyTag://快买
        {
            if (bKMKMNormal) {
                [TZTUIBaseVCMsg OnMsg:WT_RZRQBUY wParam:0 lParam:1];
            }
            else {
                [TZTUIBaseVCMsg OnMsg:WT_BUY wParam:(NSUInteger)pStock lParam:1];
            }
        }
            break;
        case tztBtnTradeSellTag://快卖
        {
            if (bKMKMNormal) {
                [TZTUIBaseVCMsg OnMsg:WT_RZRQSALE wParam:0 lParam:1];
            }
            else {
                [TZTUIBaseVCMsg OnMsg:WT_SALE wParam:(NSUInteger)pStock lParam:1];
            }
        }
            break;
        case tztBtnTradeDrawTag://快撤
        {
            if (bKMKMNormal) {
                [TZTUIBaseVCMsg OnMsg:WT_RZRQQUERYWITHDRAW wParam:0 lParam:1];
            }
            else {
                [TZTUIBaseVCMsg OnMsg:WT_WITHDRAW wParam:0 lParam:1];
            }
        }
            break;
        case tztBtnWarningTag://预警
        {
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_YUJING wParam:(NSUInteger)pStock lParam:0];
        }
            break;
        default:
            break;
    }
}
@end
