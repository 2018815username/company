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

#import "TZTInitReportMarketMenu.h"
#import "tztUIReportViewController_iphone.h"
#import "tztMainViewController.h"
#import "tztBlockHeaderView.h"

@interface tztUIReportViewController_iphone ()<tztUITableListViewDelegate>

@property(nonatomic,retain)tztUITableListView* pMenuView;
@property(nonatomic,retain)tztBlockHeaderView      *pBlockHeaderEx;
//获取同级市场列表
-(NSMutableDictionary*)GetMarketMenu;
@end

@implementation tztUIReportViewController_iphone
@synthesize pReportGrid = _pReportGrid;
@synthesize nsReqAction = _nsReqAction;
@synthesize nsReqParam  = _nsReqParam;
@synthesize nReportType = _nReportType;
@synthesize nsMenuID = _nsMenuID;
@synthesize pMenuDict = _pMenuDict;
@synthesize pMarketView = _pMarketView;
@synthesize nsOrdered = _nsOrdered;
@synthesize nsCurrentID = _nsCurrentID;
@synthesize pQuoteView = _pQuoteView;
@synthesize nsDirection = _nsDirection;
@synthesize nMarketPosition = _nMarketPosition;
@synthesize pMenuView = _pMenuView;

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUserStockChanged:) name:tztUserStockNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUserStockChanged:) name:tztRectStockNotificationName object:nil];
    
    
    [self LoadLayoutView];
    [_tztBaseView bringSubviewToFront:toolBar];
    
    if (self.nsReqAction && [self.nsReqAction length] > 0)
    {
        _bFirst = TRUE;
        [self RequestData:[self.nsReqAction intValue] nsParam_:self.nsReqParam];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_pReportGrid)
    {
        [_pReportGrid onSetViewRequest:YES];
        if(_nReportType == tztReportRecentBrowse    //当前是属于 最近浏览
           || _nReportType == tztReportUserStock)   //当前是属于 我的自选
        {
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@",
                                (_nReportType == tztReportUserStock ? [tztUserStock GetNSUserStock] : [tztUserStock GetNSRecentStock])
                                ];
            _pReportGrid.reqAction = @"60";
            [_pReportGrid setStockInfo:pStock Request:1];
        }
        else
        {
            if (!_bFirst)
                [_pReportGrid onRequestData:YES];
            _bFirst = FALSE;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_pReportGrid)
        [_pReportGrid onSetViewRequest:NO];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)SetMenuID:(NSString *)nsID
{
    [self.pMenuDict removeAllObjects];
    self.nsMenuID = [NSString stringWithFormat:@"%@", nsID];
    if([nsID compare:@"1"] == NSOrderedSame)
    {
        self.nReportType = tztReportUserStock;
    }
    else if([nsID compare:@"2"] == NSOrderedSame)
    {
        self.nReportType = tztReportRecentBrowse;
    }
    else if([nsID compare:@"12"] == NSOrderedSame)
    {
        self.nReportType = tztReportDAPANIndex;
    }
    self.pMenuDict = [self GetMarketMenu];
}

//获取同级市场列表
-(NSMutableDictionary*)GetMarketMenu
{
    if (self.nsMenuID == NULL || [self.nsMenuID length] <= 0)
        return NULL;
    return [g_pReportMarket GetSubMenuById:nil nsID_:self.nsMenuID];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;

    //现在没有用到TZTTitleReportMarket了 modify by xyt 20131113
//    NSArray *ayVC = g_navigationController.viewControllers;
//    if ([ayVC count] <= 1)
//    {
//        [self onSetTztTitleView:self.nsTitle type:TZTTitleReportMarket];
//    }
//    else
    {
        if (_nReportType == tztReportUserStock)//我的自选界面增加编辑按钮
        {
            [self onSetTztTitleView:self.nsTitle type:TZTTitleUserStock];
        }
        else
        {
            [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
        }
    }
    
    CGRect rcQuote = CGRectZero;
    rcQuote = rcFrame;
    rcQuote.origin.y += _tztTitleView.frame.size.height;
    if (_nReportType == tztReportBlockIndex || _nReportType == tztReportFlowsBlockIndex)
    {
        int bNewBlockTitle = [[g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_ReportBlockType] intValue];
        if (bNewBlockTitle == 2)
        {
            rcQuote.size.height = tztQuoteViewHeight;
        }
        else if (bNewBlockTitle > 0)
        {
            rcQuote.size.height = tztQuoteViewHeight + 40;
        }
        else
            rcQuote.size.height = tztQuoteViewHeight;
    }
    else
        rcQuote.size.height = 0;
    
    rcFrame.origin.y += rcQuote.origin.y + rcQuote.size.height;// _tztTitleView.frame.size.height;
#ifdef tzt_NewVersion // 去toolBar byDBQ20130715
    rcFrame.size.height -= (_tztTitleView.frame.size.height + 0);
#else
    rcFrame.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
#endif
    rcFrame.size.height -= rcQuote.size.height;
    if (_pReportGrid == nil)
    {
        _pReportGrid = [[tztReportListView alloc] init];
        _pReportGrid.tztdelegate = self;
        _pReportGrid.frame = rcFrame;
        _pReportGrid.nsDefautlOrderType = [NSString stringWithFormat:@"%d", [self.nsOrdered intValue] / 2];
        [_tztBaseView addSubview:_pReportGrid];
        [_pReportGrid release];
    }
    else
    {
        _pReportGrid.frame = rcFrame;
    }
    
    
    if (_pMenuView == nil)
    {
        _pMenuView = [[tztUITableListView alloc] initWithFrame:rcFrame];
        _pMenuView.backgroundColor = [UIColor blackColor];
        _pMenuView.tztdelegate = self;
        _pMenuView.bLocalTitle = NO;
        _pMenuView.hidden = YES;
        [_tztBaseView addSubview:_pMenuView];
        [_pMenuView release];
    }
    else
    {
        _pMenuView.frame = rcFrame;
    }
    
    
    int nNewBlockTitle = [[g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_ReportBlockType] intValue];
    if (nNewBlockTitle)
    {
        if (nNewBlockTitle == 2)
        {
            if (_pBlockHeaderEx == nil)
            {
                _pBlockHeaderEx = [[tztBlockHeaderView alloc] init];
                _pBlockHeaderEx.tztdelegate = self;
                _pBlockHeaderEx.frame = rcQuote;
                [_tztBaseView addSubview:_pBlockHeaderEx];
                [_pBlockHeaderEx release];
            }
            else
            {
                _pBlockHeaderEx.frame = rcQuote;
            }
        }
        else
        {
            if (_pBlockHeader == nil)
            {
                _pBlockHeader = [[TZTUIStockDetailHeaderView alloc] init];
                _pBlockHeader.tztdelegate = self;
                self.pBlockHeader.bBlockReportHeader = YES;
                self.pBlockHeader.frame = rcQuote;
                [_tztBaseView addSubview:_pBlockHeader];
                [_pBlockHeader release];
            }
            else
            {
                _pBlockHeader.frame = rcQuote;
            }
        }
    }
    else
    {
        if (_pQuoteView == NULL)
        {
            _pQuoteView = [[tztBlockIndexInfo alloc] initWithFrame:rcQuote];
            _pQuoteView.tztdelegate = self;
            [_tztBaseView addSubview:_pQuoteView];
            [_pQuoteView release];
        }
        else
        {
            _pQuoteView.frame = rcQuote;
        }
        
        _pQuoteView.tztBlockType = _nReportType;
    }
    
    if (rcQuote.size.height > 0)
    {
        _pReportGrid.layer.shadowOffset = CGSizeMake(0, -5);
        _pReportGrid.layer.shadowColor = [UIColor redColor].CGColor;
    }
    
    
    CGRect rcMenu = _tztBounds;
    rcMenu.origin = CGPointZero;
    
    if (TZT_MarketView_SP)
    {
        rcMenu.origin.y += _tztTitleView.frame.size.height;
        rcMenu.origin.x = rcMenu.size.width - 100;
        rcMenu.size.width = 100;
#ifdef tzt_NewVersion // 竖屏适配TabBar高度 byDBQ20130715
        rcMenu.size.height = rcMenu.size.height - _tztTitleView.frame.size.height  - 0;
#else
        rcMenu.size.height = rcMenu.size.height - _tztTitleView.frame.size.height  - TZTToolBarHeight;
#endif
    }
    else
    {
        rcMenu.origin.x = 0;
        if (_nMarketPosition >= 1)
            rcMenu.origin.y = self.tztTitleView.frame.size.height + self.tztTitleView.frame.origin.y;
        else
        {
#ifdef tzt_NewVersion // 竖屏适配TabBar高度 byDBQ20130715
            rcMenu.origin.y = rcMenu.size.height - 0 - 35;
#else
            rcMenu.origin.y = rcMenu.size.height - TZTToolBarHeight - 35;
#endif
        }
        rcMenu.size.height = 35;
    }
    
    
    if (_pMarketView == NULL)
    {
        _pMarketView = [[tztUIMarketView alloc] init];
        _pMarketView.frame = rcMenu;
        _pMarketView.pDelegate = self;
        [_tztBaseView addSubview:_pMarketView];
        _pMarketView.hidden = YES;
        [_pMarketView release];
    }
   
    
    if (self.pMenuDict && [self.pMenuDict count] > 0
        && [[self.pMenuDict objectForKey:@"tradelist"] count] > 1 )
    {
        _pMarketView.hidden = NO;
        CGRect rcNew = _pReportGrid.frame;
        if (TZT_MarketView_SP)
        {
            rcNew.size.width -= _pMarketView.frame.size.width;
        }
        else
        {
            rcNew.size.height -= _pMarketView.frame.size.height;
            if (_nMarketPosition >= 1)
                rcNew.origin.y = rcMenu.origin.y + rcMenu.size.height;
            
        }
        _pReportGrid.frame = rcNew;
        _pMenuView.frame = rcNew;
        [_pMarketView SetMarketData:self.pMenuDict];
    }
    else
    {
        _pMarketView.hidden = YES;
    }
    _pMarketView.frame = rcMenu;
#ifdef tzt_NewVersion // 去toolBar byDBQ20130715
#else
    [self CreateToolBar];
#endif
}

-(void)OnUserStockChanged:(NSNotification*)notification
{
    if(_pReportGrid && notification)
    {
        if (([notification.name compare:tztUserStockNotificationName]==NSOrderedSame && _nReportType == tztReportUserStock) || ([notification.name compare:tztRectStockNotificationName]==NSOrderedSame && _nReportType == tztReportRecentBrowse) )//当前是属于自选界面 或最近浏览
        {
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@",
                                (_nReportType == tztReportUserStock ? [tztUserStock GetNSUserStock] : [tztUserStock GetNSRecentStock])
                                ];
            _pReportGrid.reqAction = @"60";
            [_pReportGrid setStockInfo:pStock Request:1];
        }
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)CreateToolBar
{
    [super CreateToolBar];
    //加载默认
    if (_nReportType == tztReportUserStock)//自选
    {
        [tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolUserStock" delegate_:self forToolbar_:toolBar];
    }
    else
        [tztUIBarButtonItem GetToolBarItemByKey:nil delegate_:self forToolbar_:toolBar];
}

//显示更多
-(void)OnMore
{
    //首先获取更多需要显示的东西
    if (g_pSystermConfig == NULL || g_pSystermConfig.pDict == NULL)
        return;
    
    NSArray *pAy = nil;
    if (_nReportType == tztReportUserStock)
    {
        pAy = [g_pSystermConfig.pDict objectForKey:@"TZTToolbarMoreUserStock"];
    }
    else
    {
        pAy = [g_pSystermConfig.pDict objectForKey:@"TZTToolbarMoreHQ"];
    }
    if (pAy == nil)
        return;
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

-(void)setTitle:(NSString *)title
{
    if (title == NULL)
        return;
    self.nsTitle = [NSString stringWithFormat:@"%@", title];
    if (_tztTitleView)
    {
        [_tztTitleView setTitle:title];
    }
}

-(void)RequestData:(int)nAction nsParam_:(NSString*)nsParam
{
    if (nAction <= 0 )
    {
        nAction = [self.nsReqAction intValue];
    }
    
    
    if (nsParam == NULL)
    {
        nsParam = [NSString stringWithFormat:@"%@",self.nsReqParam];
    }
    
    _pReportGrid.nReportType = _nReportType;
    if (_nReportType == tztReportBlockIndex)
    {
//        _pReportGrid.fixRowCount = 1;
        [self setVcShowType:[NSString stringWithFormat:@"%d", tztReportShowBlockInfo]];
    }
    else if (_nReportType == tztReportFlowsBlockIndex)
    {
//        _pReportGrid.fixRowCount = 1;
        [self setVcShowType:[NSString stringWithFormat:@"%d", tztReportShowBlockInfo]];
    }
    else
    {
        _pReportGrid.fixRowCount = 0;
    }
    
    int nOrder = [self.nsOrdered intValue];
    int accountIndex = nOrder / 2;
    int nDirection = nOrder % 10;
    if (nOrder == 0)
    {
        nDirection = 1;
    }
    _pReportGrid.accountIndex = accountIndex;// [self.nsOrdered intValue];
    
    if (self.nsDirection.length > 0)
        _pReportGrid.direction = [self.nsDirection boolValue];
    else
        _pReportGrid.direction = nDirection;
    
    
    if(nAction == 60  || nAction == 89 || nAction == 20193)
    {
        self.nsReqAction = @"60";
        nAction = 60;
        if (_nReportType == tztReportUserStock)//自选
        {
            //激活登录成功后进入界面,判断是否直接下载自选股 add by xyt 20131008
            NSString* strLogMobile = [tztKeyChain load:tztLogMobile];
            if (g_pSystermConfig && g_pSystermConfig.bRegistSucToDownload && strLogMobile &&
                [strLogMobile length] > 1 && [TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
            {
                NSArray *pAy = [tztUserStock GetUserStockArray];
                if([pAy count] <= 0) //无自选股数据，从服务器下载请求
                {
                    [[tztUserStock getShareClass] Download];
                }
            }
            else
            {
                nsParam = [NSString stringWithFormat:@"%@",[tztUserStock GetNSUserStock]];
                if(nsParam.length <= 0) //无自选股数据，从服务器下载请求
                {
                    [[tztUserStock getShareClass] Download];
                }
            }
        }
        else if(_nReportType == tztReportRecentBrowse)
        {
            nsParam = [NSString stringWithFormat:@"%@",[tztUserStock GetNSRecentStock]];
        }
    }
    else if(nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
    {
        nsParam = [NSString stringWithFormat:@"%@",[tztUserStock GetNSUserStock]];
        if(nsParam.length <= 0) //无自选股数据，从服务器下载请求
        {
            [[tztUserStock getShareClass] Download];
        }
    }

    NSArray *pAy = [nsParam componentsSeparatedByString:@"#"];
    if ([pAy count] < 1)
        return;
    
    NSString* param = [pAy objectAtIndex:0];
    
    if (_pMarketView)
    {
        NSString *nsdata = [NSString stringWithFormat:@"%@#%d#%@",param,nAction, self.nsCurrentID];
        if (nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
        {
            nsdata = [NSString stringWithFormat:@"#%d#%@", nAction, self.nsCurrentID];
        }
        [_pMarketView setSelBtIndex:nsdata];
    }
    if (_pReportGrid)
    {
        _pReportGrid.reqAction =[NSString stringWithFormat:@"%d", nAction];
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", param];
        [_pReportGrid tztShowNewType];
        [_pReportGrid setStockInfo:pStock Request:1];
    }
}

//选中行
-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo *)pStock
{
//    if (hqView == _pReportGrid)
    {
        if ([_pReportGrid.reqAction compare:@"20196"] == NSOrderedSame
            || [_pReportGrid.reqAction compare:@"20640"] == NSOrderedSame
            || [_pReportGrid.reqAction compare:@"20641"] == NSOrderedSame
            || [_pReportGrid.reqAction compare:@"20642"] == NSOrderedSame
            || [_pReportGrid.reqAction compare:@"20643"] == NSOrderedSame
            )
        {
            BOOL bPush = FALSE;
            int nType = tztReportBlockIndex;
            
            if ([_pReportGrid.reqAction compare:@"20640"] == NSOrderedSame
                || [_pReportGrid.reqAction compare:@"20641"] == NSOrderedSame
                || [_pReportGrid.reqAction compare:@"20642"] == NSOrderedSame
                || [_pReportGrid.reqAction compare:@"20643"] == NSOrderedSame)
            {
//                nType = 0;
                nType = tztReportFlowsBlockIndex;
            }
            
           [TZTUIBaseVCMsg CheckCurrentViewContrllers:[tztUIReportViewController_iphone class]];
            
            tztUIReportViewController_iphone *pVC = (tztUIReportViewController_iphone *)gettztHaveViewContrller([tztUIReportViewController_iphone class], tztvckind_HQ, [NSString stringWithFormat:@"%d",tztReportShowBlockInfo], &bPush,FALSE);
            [pVC retain];
            pVC.nReportType = nType;
            pVC.pStockInfo = pStock;
            if ([_pReportGrid.reqAction compare:@"20640"] == NSOrderedSame)
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20650"];
            else if ([_pReportGrid.reqAction compare:@"20641"] == NSOrderedSame)
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20651"];
            else if ([_pReportGrid.reqAction compare:@"20642"] == NSOrderedSame)
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20652"];
            else if ([_pReportGrid.reqAction compare:@"20643"] == NSOrderedSame)
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20653"];
            else
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20199"];
            pVC.nsReqParam = [NSString stringWithFormat:@"%@", pStock.stockCode];
            [pVC setTitle:pStock.stockName];
            if(bPush)
            {
#ifdef Support_HTSC
                [pVC SetHidesBottomBarWhenPushed:YES];
#endif
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            }
            [pVC release];
        }
        else
        {
            if (hqView)
            {
//                NSMutableDictionary *dic = nil;
//                dic = [NSMutableDictionary dictionaryWithObject:hqView forKey:@"View"];
                [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)hqView];
            }
            else
            {
                
                NSMutableArray *ayStock = NewObject(NSMutableArray);
                if (pStock.stockName == NULL)
                    pStock.stockName = @"";
                NSMutableDictionary* dict = NewObject(NSMutableDictionary);
                
                NSMutableDictionary* dictCode = NewObject(NSMutableDictionary);
                [dictCode setObject:pStock.stockCode forKey:@"value"];
                [dict setObject:dictCode forKey:@"Code"];
                
                NSMutableDictionary* dictName = NewObject(NSMutableDictionary);
                [dictName setObject:pStock.stockName forKey:@"value"];
                [dict setObject:dictName forKey:@"Name"];
                
                [dict setObject:[NSString stringWithFormat:@"%d", pStock.stockType] forKey:@"StockType"];
                [ayStock addObject:dict];
                [dict release];
                [dictName release];
                [dictCode release];
                [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)ayStock];
                [ayStock release];
            }
        }
    }
}

-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    //获取当前选中行数据
    if (cellData == NULL)
        return;
    if (_pReportGrid == nil)
        return;
    
    tztStockInfo* pStock = NewObject(tztStockInfo);
    NSArray* pAy = [_pReportGrid tztGetCurStock];
    if (pAy && [pAy count] > 0)
    {
        TZTGridData *code = [pAy objectAtIndex:[pAy count] -1];
        if (code && code.text)
        {
            pStock.stockCode = [NSString stringWithFormat:@"%@", code.text];
        }
    }
    
    [TZTUIBaseVCMsg OnMsg:cellData.cmdid wParam:(NSUInteger)pStock lParam:0];
    [pStock release];
}


-(BOOL)tztUITableListView:(tztUITableListView*)tableView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString*)strMsgValue
{
    NSString* nsMenuID = @"0";
    NSArray* pAy = [strMsgValue componentsSeparatedByString:@"|"];
    if(pAy && [pAy count] > 3)
        nsMenuID = [pAy objectAtIndex:0];
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)[NSString stringWithFormat:@"%@", nsMenuID] lParam:(NSUInteger)strMsgValue];
    return TRUE;
}

-(void)tztUIMarket:(id)sender DidSelectMarket:(NSMutableDictionary *)pDict marketMenu:(NSDictionary *)pMenu
{
    if(sender == _pMarketView)
    {
        if (pDict == NULL || [pDict count] <= 0)
            return;
        [_pReportGrid setCurrentIndex:-1];
        NSString* strTitle = [pDict tztObjectForKey:@"tztTitle"];
        NSString* strParam = [pDict tztObjectForKey:@"tztParam"];
        NSString* strMenuData = [pDict tztObjectForKey:@"tztMenuData"];
//        int nMsgType = [[pDict tztObjectForKey:@"tztMsgType"] intValue];
        _pReportGrid.startindex = 1;//切换市场，回到第一条
        _pReportGrid.reqchange = INT16_MIN;
        NSArray *pAyParam = [strParam componentsSeparatedByString:@"#"];
        if (pAyParam == NULL || [pAyParam count] < 2)
            return;
        
        NSArray *pAyMenuData = [strMenuData componentsSeparatedByString:@"|"];
        if (pAyMenuData.count < 2)
            return;
        
        
        /*
         此处需要增加判断，下级是不是可以直接请求数据，还是要列表展示菜单
         */
        NSString* nsMenuID  = @"";
        NSString* nsID      = @"";
        NSString* nsType    = @"";
        NSString* nsParam   = @"";
        
        if ([pAyMenuData count] > 3)
            nsParam = [pAyMenuData objectAtIndex:3];
        
        if ([pAyMenuData count] >= 3)
        {
            nsMenuID = [pAyMenuData objectAtIndex:0];
            nsID     = [NSString stringWithFormat:@"%@", [pAyMenuData objectAtIndex:[pAyMenuData count] - 2]];
            nsType   = [NSString stringWithFormat:@"%@", [pAyMenuData objectAtIndex:[pAyMenuData count] - 3]];
        }
        
        BOOL bSubMenu = FALSE;
        int nAction = 0;
        if (nsParam && [nsParam length] > 0)
        {
            NSArray *ayParam = [nsParam componentsSeparatedByString:@"#"];
            if (ayParam && [ayParam count] > 1)
            {
                nAction = [[ayParam objectAtIndex:1] intValue];
                bSubMenu = (/*(nsID == NULL || [nsID length] <= 0)*/ (nAction <= 0));
            }
        }
        
        //还是菜单
        if ([nsType caseInsensitiveCompare:@"s"] == NSOrderedSame
            || bSubMenu)
        {
            if (_pMarketView)
            {
                NSString *nsdata = [NSString stringWithFormat:@"%@#%@",nsParam,nsMenuID];
                if (nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
                {
                    nsdata = [NSString stringWithFormat:@"#%d#%@", nAction, nsMenuID];
                }
                [_pMarketView setSelBtIndex:nsdata];
            }
            
            NSMutableDictionary *pDictValue = [g_pReportMarket GetSubMenuById:nil nsID_:nsMenuID];
            _pMenuView.hidden = NO;
            _pMenuView.frame = _pMenuView.frame;
            [_pMenuView setAyListInfo:[pDictValue objectForKey:@"tradelist"]];
            [_pMenuView reloadData];
            return;
        }
        /*判断处理结束*/
        
        self.nsCurrentID = @"";
        if ([pAyMenuData count] > 4)
        {
            self.nsCurrentID = [pAyMenuData objectAtIndex:0];
            self.nsOrdered = [NSString stringWithFormat:@"%@",[pAyMenuData objectAtIndex:4]];
            int nOrder = [self.nsOrdered intValue];
            int accountIndex = nOrder / 2;
            int nDirection = nOrder % 10;
            _pReportGrid.accountIndex = accountIndex;// [self.nsOrdered intValue];
            _pReportGrid.direction = nDirection;
        }
        [self setTitle:strTitle];
        
        self.nsReqAction = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:1]];
        self.nsReqParam = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:0]];
        [self RequestData:[self.nsReqAction intValue] nsParam_:self.nsReqParam];
        
        _pMenuView.hidden = YES;
    }
}

-(void)RequestDefaultMenuData:(NSString *)nsMarket andShowID:(NSString *)nsID
{
    if (nsMarket == NULL)
        return;
    
    [self SetMenuID:nsMarket];
    if (self.pMenuDict)
    {
        NSMutableArray *pData = [self.pMenuDict objectForKey:@"tradelist"];
        if (pData == NULL || [pData count] <= 0)
            return;
        
        NSDictionary *pDict = nil;
        if (nsID.length <= 0 || [nsMarket caseInsensitiveCompare:nsID] == NSOrderedSame)
        {
            for (int i = 0; i < [pData count]; i++)
            {
                pDict = [pData objectAtIndex:i];
                if (pDict == NULL)
                    continue;
                NSString* strMenuData = [pDict objectForKey:@"MenuData"];
                if (strMenuData == NULL || [strMenuData length] < 1)
                    return;
                NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
                if (pAy == NULL || [pAy count] < 3)
                    return;
                NSString *strLast = [pAy lastObject];
                if (strLast && [strLast caseInsensitiveCompare:@"F"] == NSOrderedSame)
                    continue;
                else
                    break;
            }
        }
        else//获取制定筛选过滤
        {
            for (int i = 0; i < [pData count]; i++)
            {
                NSDictionary *subDic = [pData objectAtIndex:i];
                if (subDic == NULL)
                    continue;
                NSString* strMenuData = [subDic objectForKey:@"MenuData"];
                if (strMenuData == NULL || [strMenuData length] < 1)
                    return;
                NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
                if (pAy == NULL || [pAy count] < 3)
                    return;
                NSString *strLast = [pAy lastObject];
                if (strLast && [strLast caseInsensitiveCompare:@"F"] == NSOrderedSame)
                    continue;
                NSString* strID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
                if (strID && [strID caseInsensitiveCompare:nsID] == NSOrderedSame)
                {
                    pDict = subDic;
                    break;
                }
            }
        }
        if (pDict == NULL)
            return;
        NSString* strMenuData = [pDict objectForKey:@"MenuData"];
        if (strMenuData == NULL || [strMenuData length] < 1)
            return;
        NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
        if (pAy == NULL || [pAy count] < 3)
            return;
        
        
        
        self.nsCurrentID = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:0]];
        if ([pAy count] > 4)
        {
            self.nsOrdered = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:4]];
        }
        
        if (self.nsOrdered == NULL || self.nsOrdered.length <= 0 )
        {
            if (_nReportType == tztReportBlockIndex || _nReportType == tztReportUserStock)
                self.nsOrdered = @"18";//18 ＝ 9 ＊ 2
            else
                self.nsOrdered = @"0";
        }
        
        NSString* strParam = [pAy objectAtIndex:3];
        NSArray *pAyParam = [strParam componentsSeparatedByString:@"#"];
        NSString* strTitle = [pAy objectAtIndex:1];
        [self setTitle:strTitle];
        self.nsReqAction = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:1]];
        self.nsReqParam = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:0]];
    }

}

-(void)RequestDefaultMenuData:(NSString*)nsID
{
    [self RequestDefaultMenuData:nsID andShowID:nil];
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
//    if (_pReportGrid)
//    {
//        bDeal = [_pReportGrid OnToolbarMenuClick:sender];
//    }
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}


-(void)OnBtnEditUserStock:(id)sender
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_EditUserStock wParam:0 lParam:0];
}

-(void)tztBlockIndexInfo:(id)view updateInfo_:(NSMutableArray *)pDict
{
    if (self.pBlockHeader || self.pBlockHeaderEx)
    {
        
        NSInteger nCount = [pDict count];
        //==2,一行标题，一行数据
        if (nCount < 3)
        {
            return;
        }
        
        NSArray *ayTitle = [pDict objectAtIndex:0];
        if (ayTitle == NULL || ayTitle.count < 1)
        {
            return;
        }
        
        NSArray *ayContent = [pDict objectAtIndex:1];
        if (ayContent == NULL || ayContent.count < 1 || [ayContent count] != [ayTitle count])
        {
            return;
        }
        
        NSMutableDictionary *pDictData = NewObject(NSMutableDictionary);
        
        for (NSInteger i = 0; i < [ayTitle count]; i++)
        {
            TZTGridDataTitle *pTitle = [ayTitle objectAtIndex:i];
            if (pTitle == NULL || pTitle.text == NULL || pTitle.text.length < 1)
                continue;
            
            NSString *strKey = nil;
            if ([pTitle.text hasPrefix:@"最新"])
            {
                strKey = tztNewPrice;
            }
            else if ([pTitle.text hasPrefix:@"涨跌"])
            {
                strKey = tztUpDown;
            }
            else if ([pTitle.text hasPrefix:@"幅度"])
            {
                strKey = tztPriceRange;
            }
            else if ([pTitle.text hasPrefix:@"换手"])
            {
                strKey = tztHuanShou;
            }
            else if ([pTitle.text hasPrefix:@"开盘"])
            {
                strKey = tztStartPrice;
            }
            else if ([pTitle.text hasPrefix:@"最高"])
            {
                strKey = tztMaxPrice;
            }
            else if ([pTitle.text hasPrefix:@"最低"])
            {
                strKey = tztMinPrice;
            }
            else if ([pTitle.text hasPrefix:@"昨收"])
            {
                strKey = tztYesTodayPrice;
            }
            else if ([pTitle.text hasPrefix:@"名称"])
            {
                strKey = tztName;
            }
            
            if (i == [ayTitle count] - 1)
            {
                strKey = tztCode;
            }
            
            if (strKey == NULL)
                continue;
            
            NSString* strData = @"--";
            UIColor * pColor = [UIColor tztThemeHQBalanceColor];
            
            NSMutableDictionary *pSub = NewObject(NSMutableDictionary);
            TZTGridData* pData = [ayContent objectAtIndex:i];
            strData = [NSString stringWithFormat:@"%@", pData.text];
            if (pData.textColor)
                pColor = pData.textColor;
            
            [pSub setObject:strData forKey:tztValue];
            [pSub setObject:pColor forKey:tztColor];
            
            [pDictData setObject:pSub forKey:strKey];
            [pSub release];
        }
        
        int nStockType = 0;
        if (pDict.count > 2)
            nStockType = [[pDict objectAtIndex:2] intValue];
        for (NSInteger i = 3; i < 6; i++)
        {
            NSString* strData = @"--";
            if (i >= pDict.count)
                break;
            NSMutableDictionary *pSub = NewObject(NSMutableDictionary);
            NSString* strText = [pDict objectAtIndex:i];
            strData = [NSString stringWithFormat:@"%@", strText];
            
            [pSub setObject:strData forKey:tztValue];
            if (i == 3)
            {
                [pSub setObject:[UIColor tztThemeHQUpColor] forKey:tztColor];
                [pDictData setObject:pSub forKey:tztUpStocks];
            }
            else if (i == 4)
            {
                [pSub setObject:[UIColor tztThemeHQDownColor] forKey:tztColor];
                [pDictData setObject:pSub forKey:tztDownStocks];
            }
            else if (i == 5)
            {
                [pSub setObject:[UIColor tztThemeHQBalanceColor] forKey:tztColor];
                [pDictData setObject:pSub forKey:tztFlatStocks];
            }
            [pSub release];
        }
        if (nStockType > 0)
            self.pStockInfo.stockType = nStockType;
        if (self.pBlockHeader)
        {
            [self.pBlockHeader setStockInfo:self.pStockInfo Request:0];
            [TZTPriceData setStockDic:pDictData];
            
            [self.pBlockHeader updateContent];
        }
        if (self.pBlockHeaderEx)
        {
            [self.pBlockHeaderEx setStockInfo:self.pStockInfo Request:0];
            [TZTPriceData setStockDic:pDictData];
            
            [self.pBlockHeaderEx updateContent];
        }
    }
    if (self.pQuoteView)
    {
        [self.pQuoteView tztBlockIndexInfo:self.pQuoteView updateInfo_:pDict];
    }
}
@end
