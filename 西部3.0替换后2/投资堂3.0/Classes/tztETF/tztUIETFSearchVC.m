/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF股票查询vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUIETFSearchVC.h"

@implementation tztUIETFSearchVC
@synthesize pTitleView = _pTitleView;
@synthesize pSearchView = _pSearchView;
@synthesize nsEndDate = _nsEndDate;
@synthesize nsBeginDate = _nsBeginDate;

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
    if (_pSearchView) 
        [_pSearchView OnRequestData];
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
        switch (_nMsgType)
        {
            case WT_ETFCrashRGQuery:
            case  MENU_JY_ETFWX_QueryFund: //14041  现金认购查询
                strTitle = @"网下现金认购查询";
                break;
            case WT_ETFStockRGQuery:
            case MENU_JY_ETFWX_QueryStock: //14042  股票认购查询
                strTitle = @"网下股票认购查询";
                break;
            case WT_ETF_HS_CrashQUery:
            case MENU_JY_ETFKS_HSQueryFund: //14081  沪市现金查询
                strTitle = @"沪市现金查询";
                break;
            case WT_ETF_HS_StockQuery:
            case MENU_JY_ETFKS_HSQueryStock: //14082  沪市股票查询
                strTitle = @"沪市股票查询";
                break;
            case WT_ETF_SS_RGQuery:
            case MENU_JY_ETFKS_SSRGQuery: //14083  深市认购查询
                strTitle = @"深市认购查询";
                break;
            case WT_ETFInquireEntrust:
            case MENU_JY_FUND_HBQueryDraw:
                strTitle = @"货币基金当日委托";
                break;
            case WT_ETFInquireHisEntrust:
            case MENU_JY_FUND_HBQueryHis://货币基金历史委托
                strTitle = @"货币基金历史委托";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pSearchView == nil)
    {
        _pSearchView = [[tztETFSearchView alloc] init];
        _pSearchView.delegate = self;
        _pSearchView.nMsgType = _nMsgType;
        _pSearchView.frame = rcBuySell;
        
        if (_nsBeginDate && [_nsBeginDate length] > 0)
            _pSearchView.nsBeginDate = [NSString stringWithFormat:@"%@", _nsBeginDate];
        if (_nsEndDate && [_nsEndDate length] > 0)
            _pSearchView.nsEndDate = [NSString stringWithFormat:@"%@", _nsEndDate];
        
        [_tztBaseView addSubview:_pSearchView];
        [_pSearchView release];
    }
    else
    {
        _pSearchView.frame = rcBuySell;
    }
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"详细|6808"];
    [pAy addObject:@"刷新|6802"];
    
#ifdef tzt_NewVersion
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}


-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pSearchView)
    {
        bDeal = [_pSearchView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
