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

#import "tztUITradeSearchViewController.h"

@implementation tztUITradeSearchViewController
@synthesize pSearchView = _pSearchView;
@synthesize nsBeginDate = _nsBeginDate;
@synthesize nsEndDate = _nsEndDate;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_pSearchView.pGridView setSelectRow:_pSearchView.pGridView.curIndexRow];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;

    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_QUERYDRCJ:
            case MENU_JY_PT_QueryTradeDay:
                strTitle = @"当日成交";
                break;
            case MENU_JY_PT_QueryDeal:
                strTitle = @"成交汇总";
                break;
            case WT_QUERYDRWT:
            case MENU_JY_PT_QueryDraw:
                strTitle = @"当日委托";
                break;
            case WT_QUERYGP://查询股票
            case MENU_JY_PT_QueryStock:
                strTitle = @"查询股票";
                break;
            case WT_QUERYGDZL://股东资料
            case MENU_JY_PT_QueryGdzl:
                strTitle = @"股东资料";
                break;
            case WT_QUERYFUNE://查询资金
            case MENU_JY_PT_QueryFunds:
                strTitle = @"查询资金";
                break;
            case WT_QUERYJG://查询交割
            case MENU_JY_PT_QueryJG:
                strTitle = @"查询交割";
                break;
            case MENU_JY_PT_QueryHisTrade:
                strTitle = @"查询历史委托";
                break;
            case WT_QUERYLS://资金明细
            case MENU_JY_PT_QueryZJMX:
                strTitle = @"资金明细";
                break;
            case WT_QUERYLSCJ://历史成交
            case MENU_JY_PT_QueryTransHis://历史成交 新功能号add by xyt 20131128
                strTitle = @"历史成交";
                break;
            case WT_QUERYPH://查询配号
            case MENU_JY_PT_QueryPH:
                strTitle = @"查询配号";
                break;
            case WT_WITHDRAW://委托撤单
            case MENU_JY_PT_Withdraw:
                strTitle = @"委托撤单";
                break;
            case WT_TRANSHISTORY://转账流水
            case MENU_JY_PT_QueryBankHis://转账流水 //新功能号
                strTitle = @"转账流水";
                break;
            case WT_LiShiDZD:
                strTitle = @"对账单查询";
                break;
            case WT_ZiChanZZ:
                strTitle = @"资产总值";
                break;
            case WT_DZJY_HQCX:
            case MENU_JY_DZJY_HQ:
                strTitle = @"行情查询";
                break;
            case MENU_QS_ZYSC_ClientManager: // 客户经理
                strTitle = @"客户经理";
                break;
            case MENU_JY_BJHG_HisQuery: //13848  历史委托查询389 byDBQ20131011
                strTitle = @"历史委托";
                break;
            case MENU_JY_PT_QueryStockOut: //12365 证券出借查询
                strTitle = @"证券出借查询";
                break;
            case MENU_JY_FUND_XJBLEDSetting:
            case MENU_JY_FUND_PHQueryHisWT:
                strTitle = @"历史委托";
                break;
            case MENU_JY_PT_QueryNewStockED:
                strTitle =@"查询新股申购额度";
                break;
            case MENU_JY_PT_QueryNewStockZQ:
                strTitle =@"查询新股中签";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];

    CGRect rcSearch = rcFrame;
    rcSearch.origin.y += _tztTitleView.frame.size.height;
    rcSearch.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pSearchView == nil)
    {
        _pSearchView = [[tztTradeSearchView alloc] init];
        _pSearchView.delegate = self;
        if (_nsBeginDate && [_nsBeginDate length] > 0)
            _pSearchView.nsBeginDate = _nsBeginDate;
        if (_nsEndDate && [_nsEndDate length] > 0)
            _pSearchView.nsEndDate = _nsEndDate;
        [_tztBaseView addSubview:_pSearchView];
        [_pSearchView release];
    }
    _pSearchView.nMsgType = _nMsgType;
    _pSearchView.frame = rcSearch;
    [self CreateToolBar];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    //加载默认
    switch (_nMsgType)
    {
        case WT_QUERYGP:
        case MENU_JY_PT_QueryStock:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            if (g_pSystermConfig.bGPAndZJ)
            {
                [pAy addObject:@"资金|3821"];
            }
            else
            {
                if (!g_pSystermConfig.bNStockNeedHQ) {
                    [pAy addObject:@"行情|3300"];
                }
            }
            [pAy addObject:@"卖出|3804"];
        }
            break;
        case WT_QUERYFUNE:
        case MENU_JY_PT_QueryFunds:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            if (g_pSystermConfig.bGPAndZJ)
            {
                [pAy addObject:@"股票|3822"];
            }
        }
            break;
            
        default:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
        }
            break;
    }
    
    
#ifdef tzt_NewVersion // 新版本改变样式 byDBQ20130716
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case WT_QUERYGP:
        {
            _pSearchView.nMsgType = WT_QUERYGP;
            self.nMsgType = WT_QUERYGP;
            [_pSearchView OnRequestData];
            [self CreateToolBar];
            [self onSetTztTitleView:@"查询股票" type:TZTTitleReport];
            return ;
        }
            break;
        case WT_QUERYFUNE:
        {
            _pSearchView.nMsgType = WT_QUERYFUNE;
            self.nMsgType = WT_QUERYFUNE;
            [_pSearchView OnRequestData];
            [self CreateToolBar];
            [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
            [self onSetTztTitleView:@"查询资金" type:TZTTitleReport];
            return ;
        }
            break;
        default:
            break;
    }
    BOOL bDeal = FALSE;
    if (_pSearchView)
    {
        bDeal = [_pSearchView OnToolbarMenuClick:sender];
    }
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

-(void)OnBtnNextStock:(id)sender
{
    if (_pSearchView)
        [_pSearchView OnGridNextStock:_pSearchView.pGridView ayTitle_:_pSearchView.ayTitle];
}

-(void)OnBtnPreStock:(id)sender
{
    if (_pSearchView)
        [_pSearchView OnGridPreStock:_pSearchView.pGridView ayTitle_:_pSearchView.ayTitle];
}

@end
