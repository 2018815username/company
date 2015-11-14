/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        排名界面vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:        2012－12－13
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIReportViewController.h"

@interface TZTUIReportViewController(TZTPrivate)
-(void)LoadLayoutReportView:(CGRect)rcFrame;
-(void)LoadLayoutDetaiView:(CGRect)rcFrame;
@end

@implementation TZTUIReportViewController
@synthesize pReportGrid = _pReportGrid;
@synthesize pMenuView = _pMenuView;
@synthesize nTransType = _nTranseType;
@synthesize pStockDetailView = _pStockDetailView;
@synthesize nPageType = _nPageType;
@synthesize bFlag = _bFlag;
@synthesize pStrMenID = _pStrMenuID;
@synthesize nCurTranseType = _nCurTranseType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _bFlag = TRUE;
        _pStrMenuID = @"";
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
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //取消界面的刷新
    if (_pReportGrid)
    {
        [_pReportGrid onSetViewRequest:NO];
    }
    if (_pStockDetailView)
    {
        [_pStockDetailView onSetViewRequest:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //恢复界面显示
    if (_nCurTranseType != _nTranseType)
    {
        _nCurTranseType = _nTranseType;
    }
    
    [self LoadLayoutView];
    
    if (_pReportGrid)
    {
        [_pReportGrid onSetViewRequest:YES];
    }
    if (_pStockDetailView)
    {
        [_pStockDetailView onSetViewRequest:YES];
    }
    
    if (_pMenuView)
    {
        TZTLogInfo(@"%d = %@",_nPageType,_pStrMenuID);
        switch (_nPageType)
        {
            case ReportUserStPage://自选
            {
                [_pMenuView setCurrentMenu:@"1"/*@"我的自选"*/];
            }
                break;
            case ReportDPIndexPage://大盘
            {
                [_pMenuView setCurrentMenu:@"12"/*@"大盘指数"*/];
            }
                break;
            case ReportQHMarketPage://期货 byDBQ20130802
            {
                [_pMenuView setCurrentMenu:@"70101"/*@"期货市场"*/];
                _pStrMenuID = @"";
            }
                break;
            case ReportWPMarketPage://外盘 byDBQ20130802
            {
                [_pMenuView setCurrentMenu:@"902"/*@"外盘市场"*/];
                _pStrMenuID = @"";
            }
                break;
            default:
            {
                if (_pStrMenuID && _pStrMenuID.length > 0)
                {
                    [_pMenuView setCurrentMenu:_pStrMenuID];
                    _pStrMenuID = @"";
                }
                else
                {
                    [_pMenuView setCurrentMenu:@"302"/*@"沪深A股"*/];
                    _pStrMenuID = @"";
                }
            }
                break;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    if (CGRectIsNull(rcFrame) || CGRectIsEmpty(rcFrame))
        return;
    if (_tztTitleView == nil)
    {
        [self onSetTztTitleView:g_pSystermConfig.strMainTitle type:TZTTitleReport_iPad];
    }
    else
    {
        [self onSetTztTitleViewFrame:rcFrame];
    }
    _tztTitleView.nLeftViewWidth = 210; //注意
    
    //根据当前页面加载不通
    switch (_nCurTranseType)
    {
        case TZTUIReportViewType://排名显示
        {
            [self LoadLayoutReportView:rcFrame];
        }
            break;
        case TZTUIReportDetailType://详情显示
        {
            [self LoadLayoutDetaiView:rcFrame];
        }
            break;
            
        default:
            break;
    }
    
    if (_pBtHidden == NULL)
    {
        _pBtHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtHidden setTztBackgroundImage:[UIImage imageTztNamed:@"TZTHiddenMenu.png"]];
        [_pBtHidden addTarget:self action:@selector(OnHiddenMenu:) forControlEvents:UIControlEventTouchUpInside];
        _pBtHidden.frame = CGRectMake(0, (self.view.frame.size.height - 70)/2, 29, 70);
        [_tztBaseView addSubview:_pBtHidden];
    }
    else
        _pBtHidden.frame = CGRectMake(0, (self.view.frame.size.height - 70)/2, 29, 70);
    
    if (_nCurTranseType == TZTUIReportViewType)
        _pBtHidden.hidden = YES;
    [_tztBaseView bringSubviewToFront:_pBtHidden];
}

-(void)OnHiddenMenu:(id)sender
{
    CGRect rcFrame = _pReportGrid.frame;
    if (_pReportGrid.frame.origin.x >= 0)
    {
        rcFrame.origin.x -= rcFrame.size.width;
        _pReportGrid.frame = rcFrame;
        
        rcFrame = _pStockDetailView.frame;
        rcFrame.origin.x = 0;
        rcFrame.size.width += _pReportGrid.frame.size.width;
        _pStockDetailView.frame = rcFrame;
        [_pBtHidden setTztBackgroundImage:[UIImage imageTztNamed:@"TZTOpenMenu.png"]];
    }else
    {
        rcFrame.origin.x += rcFrame.size.width;
        _pReportGrid.frame = rcFrame;
        
        rcFrame = _pStockDetailView.frame;
        rcFrame.origin.x = _pReportGrid.frame.size.width;
        rcFrame.size.width -= _pReportGrid.frame.size.width;
        _pStockDetailView.frame = rcFrame;
        [_pBtHidden setTztBackgroundImage:[UIImage imageTztNamed:@"TZTHiddenMenu.png"]];
    }
}


-(void)LoadLayoutReportView:(CGRect)rcFrame
{
    _tztTitleView.nType = TZTTitleReport_iPad;
    [_tztTitleView setFrame:_tztTitleView.frame];
    
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= _tztTitleView.frame.size.height;
    //左侧菜单列表view
    int nLeft = 210;
    rcFrame.size.width = nLeft;
    if (_pMenuView == nil)
    {
        _pMenuView = [[TZTUIMenuView alloc] initWithFrame:rcFrame];
        _pMenuView.pDelegate = self;
        [_tztBaseView addSubview:_pMenuView];
        [_pMenuView release];
    }
    else
    {
        _pMenuView.frame = rcFrame;
    }
    
    //右侧数据显示view
    rcFrame.origin.x += nLeft;
    rcFrame.size.width = self.view.frame.size.width - nLeft;
    if (_pReportGrid == nil)
    {
        _pReportGrid = [[tztReportListView alloc] init];
        _pReportGrid.tztdelegate = self;
        _pReportGrid.bFlag = _bFlag;
        _pReportGrid.frame = rcFrame;
        [_tztBaseView addSubview:_pReportGrid];
        [_pReportGrid release];
    }
    else
    {
        _pReportGrid.frame = rcFrame;
    }
    
    //    rcFrame.origin.x += 20;
    //    rcFrame.size.width -= 20;
    //
    if (_pStockDetailView == nil)
    {
        _pStockDetailView = [[TZTUIStockDetailView alloc] init];
        _pStockDetailView.pDelegate = self;
        _pStockDetailView.frame = rcFrame;
        [_tztBaseView addSubview:_pStockDetailView];
        [_pStockDetailView release];
    }
    else
    {
        _pStockDetailView.frame = rcFrame;
    }
    
    _pStockDetailView.hidden = YES;
}


-(void)LoadLayoutDetaiView:(CGRect)rcFrame
{
    if(_nPageType == ReportUserStPage)
        _tztTitleView.nType = TZTTitleDetail_iPad_User;
    else
        _tztTitleView.nType = TZTTitleDetail_iPad;
    [_tztTitleView setFrame:_tztTitleView.frame];
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= _tztTitleView.frame.size.height;
    //左侧菜单列表view
    int nLeft = 210;
    rcFrame.size.width = nLeft;// + 20;
    rcFrame.origin.x -= rcFrame.size.width;
    if (_pMenuView == nil)
    {
        _pMenuView = [[TZTUIMenuView alloc] initWithFrame:rcFrame];
        _pMenuView.pDelegate = self;
        [_tztBaseView addSubview:_pMenuView];
        [_pMenuView release];
    }
    else
    {
        _pMenuView.frame = rcFrame;
    }
    
    //右侧数据显示view
    rcFrame.origin.x  = 0;
    rcFrame.size.width = nLeft;
    if (_pReportGrid == nil)
    {
        _pReportGrid = [[tztReportListView alloc] init];
        _pReportGrid.tztdelegate = self;
        //zxl 20131016  刷新界面的时候是否选中首个的标志赋值
        _pReportGrid.bFlag = _bFlag;
        _pReportGrid.frame = rcFrame;
        [_tztBaseView addSubview:_pReportGrid];
        [_pReportGrid release];
    }
    else
    {
        _pReportGrid.frame = rcFrame;
    }
    
    rcFrame.origin.x += rcFrame.size.width;
    rcFrame.size.width = self.view.frame.size.width - rcFrame.size.width;
    if (_pStockDetailView == nil)
    {
        _pStockDetailView = [[TZTUIStockDetailView alloc] init];
        _pStockDetailView.pDelegate = self;
        _pStockDetailView.frame = rcFrame;
        [_tztBaseView addSubview:_pStockDetailView];
        [_pStockDetailView release];
    }
    else
    {
        _pStockDetailView.frame = rcFrame;
    }
    _pStockDetailView.hidden = NO;
}
//zxl 20130801 添加了排序方向的参数
-(void)RequestData:(int)nAction withParam_:(NSString*)nsParam Direction_:(NSString*)direction
{
    NSMutableArray *pAy = (NSMutableArray*)[nsParam componentsSeparatedByString:@"#"];
    if (pAy == NULL || [pAy count] < 2)
    {
        TZTNSLog(@"TZTUIBaseSearchGridView--%@", @"请求数据参数错误");
        return;
    }
    
    int nOrder = [direction intValue];
    int accountIndex = nOrder / 2;
    int nDirection = nOrder % 10;
    
    if(nOrder == 0)
        nDirection = 1;
    
    _pReportGrid.reqAction = [pAy objectAtIndex:1];
    _pReportGrid.direction = nDirection;
    _pReportGrid.accountIndex = accountIndex;
    _pReportGrid.startindex = 0;
    [_pReportGrid.reportView.centerview setContentOffset:CGPointMake(0, 0)];
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@",[pAy objectAtIndex:0]];
    [_pReportGrid tztShowNewType];
    [_pReportGrid setStockInfo:pStock Request:1];
}

-(void)DealWithMenu:(int)nMsgType nsParam_:(NSString*)nsParam pAy_:(NSArray *)pAy
{
    NSString* nsTitle = @"";
    if (_pMenuView)
        nsTitle = [_pMenuView GetCurrentMenuTitle];
    if (nsTitle && _tztTitleView)
    {
        [_tztTitleView setTitle:nsTitle];
    }
    
    NSArray *pAyParam = [nsParam componentsSeparatedByString:@"#"];
    if (pAyParam == NULL || [pAyParam count] < 2)
        return;
    
    int nAction = [[pAyParam objectAtIndex:1] intValue];
    
    if (nAction == 60)
    {
        NSString* str = [tztUserStock GetNSRecentStock];
        if (str == nil || [str length] < 1)
        {
            [self showMessageBox:@"最近浏览列表为空!" nType_:TZTBoxTypeNoButton nTag_:0];
            return;
        }
        nsParam = [NSString stringWithFormat:@"%@#%d",str,nAction];
        //        nsParam = [NSString stringWithFormat:@"%@",str];
    }
    //zxl 20130927 添加了资金流向的3个自选股的请求
    else if(nAction == 20193 || nAction == 20610 || nAction == 20611 || nAction == 20612)
    {
        //取得本地自选
        NSString* str = [tztUserStock GetNSUserStock];
//        NSString* strAction = @"60";
        if (str.length <= 0)
        {
            //iPad取配置的默认自选，因为首页显示的时候，用户可能还没有进行过系统登录，需要用户自己手动去下载
            [tztUserStock SaveUserStockArray:(NSMutableArray*)[g_pSystermConfig ayDefaultUserStock]];
            str = [tztUserStock GetNSUserStock];
            //[[tztUserStock getShareClass] Download];
        }
        if (nAction == 20193)
        {
            nsParam = [NSString stringWithFormat:@"%@#%d",str, 60];
        }
        else
        {
            nsParam = [NSString stringWithFormat:@"%@#%d",str, nAction];
        }
    }
    //zxl 20130801 ipad 添加排序方向
    NSString* nsOrder = @"";
    if ([pAy count] > 4)
    {
        nsOrder = [pAy objectAtIndex:4];
    }
    
    if (nsOrder == NULL || nsOrder.length < 1)
    {
        if(_nPageType == ReportUserStPage || _nPageType == ReportDPIndexPage || _nPageType == ReportRecentPage)
            nsOrder = @"18";
        else
            nsOrder = @"0";
    }
    //zxl 20131017 在切换列表的时候先给 nDefaultCellWidth 默认宽度
    _pReportGrid.reportView.nDefaultCellWidth = TZTTABLECELLWIDTH;
    
    [self RequestData:nMsgType withParam_:nsParam Direction_:nsOrder];
}

-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo *)pStock
{
    if (_bFlag)
    {
        [self OnSelectHQData:pStock];
    }
    else
    {
        [self OnSelectHQData:_pStockInfo];
        _bFlag = TRUE;
        _pReportGrid.bFlag = _bFlag;
    }
}

//行情选中，返回股票代码和名称
-(void)OnSelectHQData:(tztStockInfo*)pStock
{
    if (pStock == NULL)
        return;
    TZTNSLog(@"OnSelectHQData :code:%@ name:%@", pStock.stockCode, pStock.stockName);
    if (_pStockDetailView)
    {
        [_pStockDetailView SetStockCode:pStock];
        [self LoadLayoutView];//?????
        if (_nCurTranseType != TZTUIReportDetailType)
        {
            _nCurTranseType = TZTUIReportDetailType;
            CGRect rcMenuFrame = _pMenuView.frame;
            CGRect rcReportView = _pReportGrid.frame;
            CGRect rcDetailView = _pStockDetailView.frame;
            CGRect rcTemp = rcDetailView;
            
            rcMenuFrame.origin.x -= rcMenuFrame.size.width;
            rcReportView.origin.x -= rcMenuFrame.size.width;
            rcReportView.size.width = rcMenuFrame.size.width + 20;
            rcDetailView.origin.x += rcDetailView.size.width;
            _pStockDetailView.frame = rcDetailView;
            _pStockDetailView.hidden = NO;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            
            _pMenuView.frame = rcMenuFrame;
            _pReportGrid.frame = rcReportView;
            _pStockDetailView.frame = rcTemp;
            [UIView commitAnimations];
        }
        
        if (_nPageType == ReportUserStPage)
        {
            _tztTitleView.nType = TZTTitleDetail_iPad_User;
        }
        else
        {
            _tztTitleView.nType = TZTTitleDetail_iPad;
        }
        [_tztTitleView setCurrentStockInfo:pStock.stockCode nsName_:pStock.stockName];
    }
    _pBtHidden.hidden = NO;
}

//全屏
-(void)OnBtnFullScreen:(id)sender
{
    if (_nCurTranseType == TZTUIReportViewType)
        return;
    
    [self LoadLayoutView];//?????????
    _nCurTranseType = TZTUIReportViewType;
    _tztTitleView.nType = TZTTitleReport_iPad;
    [_tztTitleView setCurrentStockInfo:@"" nsName_:@""];
    
    //当前的显示区域
    CGRect rcMenuFrame = _pMenuView.frame;
    CGRect rcReportView = _pReportGrid.frame;
    CGRect rcDetailView = _pStockDetailView.frame;
    
    //左侧菜单右移
    rcMenuFrame.origin.x += rcMenuFrame.size.width;
    //排名列表右移，并重设宽度
    rcReportView.origin.x += rcMenuFrame.size.width;
    rcReportView.size.width = self.view.frame.size.width - rcMenuFrame.size.width;
    //详情界面右移
    rcDetailView.origin.x += rcDetailView.size.width;
    _pStockDetailView.hidden = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    _pMenuView.frame = rcMenuFrame;
    _pReportGrid.frame = rcReportView;
    _pStockDetailView.frame = rcDetailView;
    [UIView commitAnimations];
    _pStockDetailView.frame = rcReportView;
    _pStockDetailView.hidden = YES;
    _pBtHidden.hidden = YES;
}

//上一个股票
-(void)OnBtnPreStock:(id)sender
{
    if (self.pReportGrid)
    {
        NSArray *pAy = [self.pReportGrid tztGetPreStock];
        if (pAy == NULL || [pAy count] < 1)
            return;
        NSInteger nCount = [pAy count];
        TZTGridData* valuedata = [pAy objectAtIndex:nCount-1];
        NSString* strCode = valuedata.text;
        TZTGridData* namedata = [pAy objectAtIndex:0];
        NSString* strName = namedata.text;
        TZTGridData* typedata = [pAy objectAtIndex:1];
        NSString* strType = typedata.text;
        
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
        pStock.stockType = [strType intValue];
        
        [self OnSelectHQData:pStock];
        DelObject(pStock);
    }
}

//下一个股票
-(void)OnBtnNextStock:(id)sender
{
    if (self.pReportGrid)
    {
        NSArray *pAy = [self.pReportGrid tztGetNextStock];
        if (pAy == NULL || [pAy count] < 1)
            return;
        NSInteger nCount = [pAy count];
        TZTGridData* valuedata = [pAy objectAtIndex:nCount-1];
        NSString* strCode = valuedata.text;
        TZTGridData* namedata = [pAy objectAtIndex:0];
        NSString* strName = namedata.text;
        TZTGridData* typedata = [pAy objectAtIndex:1];
        NSString* strType = typedata.text;
        
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
        pStock.stockType = [strType intValue];
        
        [self OnSelectHQData:pStock];
        DelObject(pStock);
    }
}

-(void)OnUserStockChanged:(NSNotification*)notification
{
    if(notification && _pReportGrid)
    {
        if (([notification.name compare:tztUserStockNotificationName]==NSOrderedSame && _nPageType == ReportUserStPage) || ([notification.name compare:tztRectStockNotificationName]==NSOrderedSame && _nPageType == ReportRecentPage) )//当前是属于自选界面 或最近浏览
        {
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@",
                                (_nPageType == ReportUserStPage ? [tztUserStock GetNSUserStock] : [tztUserStock GetNSRecentStock])
                                ];
            _pReportGrid.reqAction = @"60";
            [_pReportGrid setStockInfo:pStock Request:1];
        }
    }
    
}
//zxl  20131012 添加历史分时
-(void)tzthqView:(id)hqView RequestHisTrend:(tztStockInfo *)pStock nsHisDate:(NSString *)nsHisDate
{
    NSMutableDictionary* pDict = [[NSMutableDictionary alloc] init];
    [pDict setTztObject:hqView forKey:@"tztDelegate"];
    [pDict setTztObject:pStock forKey:@"tztStock"];
    [pDict setTztObject:nsHisDate forKey:@"tztHisDate"];
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_HisTrend wParam:(NSUInteger)pDict lParam:0];
    DelObject(pDict);
}

- (void)CreateToolBar // iPad版本底部无toolBar byDBQ20130713
{
    
}

-(BOOL)isEqualType:(NSInteger)nType
{
    return (nType == _nCurTranseType);
}

@end
