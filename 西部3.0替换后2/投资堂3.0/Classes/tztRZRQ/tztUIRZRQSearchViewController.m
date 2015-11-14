/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券查询vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:
 *
 ***************************************************************/
#import "tztUIRZRQSearchViewController.h"

@implementation tztUIRZRQSearchViewController
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


-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
#ifdef kSUPPORT_XBSC
    if (_nMsgType==15445||_nMsgType==15444)
    {
        strTitle=@"融资融券合约信息";
    }
#endif
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_RZRQGDLB:
                strTitle = @"股东列表";
                break;
            case WT_RZRQWITHDRAW:
                strTitle = @"撤单查询";
                break;
            case WT_RZRQQUERYXYZC:
            case MENU_JY_RZRQ_QueryXYZC:
                strTitle = @"查询资产";
                break;
            case WT_RZRQQUERYXYGF:
                strTitle = @"信用股份";
                break;
            case WT_RZRQQUERYFUNE:
            case MENU_JY_RZRQ_QueryFunds://查询资金 //新功能号 add by xyt 20131018
                strTitle = @"查询资金";
                break;
            case WT_RZRQQUERYGP:
            case MENU_JY_RZRQ_QueryStock://查询股票（查询持仓）
                strTitle = @"查询持仓";
                break;
            case WT_RZRQQUERYDRWT:
            case MENU_JY_RZRQ_QueryDraw://当日委托
                strTitle = @"当日委托";
                break;
            case WT_RZRQQUERYDRCJ:
            case MENU_JY_RZRQ_QUeryTransDay://当日成交
                strTitle = @"当日成交";
                break;
            case WT_RZRQQUERYZCFZ:
            case MENU_JY_RZRQ_QueryZCFZQK://资产负债查询 查询资产 信用负债
            case MENU_JY_RZRQ_QueryHeYue:
                //strTitle = @"资产负债";
                strTitle = @"信用负债";
                break;
            case WT_RZRQQUERYRZQK:
            case MENU_JY_RZRQ_QueryRZQK://融资情况查询  融资债细 融资明细 //新功能 add by xyt 20131021
                //strTitle = @"融资情况";
                strTitle = @"融资负债";
                break;
            case WT_RZRQQUERYRQQK:
            case MENU_JY_RZRQ_QueryRQQK://融券情况查询  融券债细 融券明细 //新功能 add by xyt 20131021
                strTitle = @"融券负债";
                break;
            case WT_RZRQQUERYLS:
            case MENU_JY_RZRQ_QueryFundsDayHis: //资金流水
                strTitle = @"资金流水";
                break;
            case WT_RZRQQUERYJG:
            case MENU_JY_RZRQ_QueryJG://交割单查询
                strTitle = @"查询交割";
                break;
            case WT_RZRQQUERYHZLS:
            case MENU_JY_RZRQ_TransQueryDraw://划转流水 add by xyt 20131021
                strTitle = @"划转流水";
                break;
            case WT_RZRQQUERYDBP:
            case MENU_JY_RZRQ_QueryDBZQ:// 担保证券查询 查询担保品
                strTitle = @"担保证券查询";
                break;
            case WT_RZRQQUERYXYSX://信用上限查询
            case MENU_JY_RZRQ_QueryXYShangXian://信用上限
                strTitle = @"额度上限查询";
                break;
            case WT_RZRQQUERYCANBUY:
            case MENU_JY_RZRQ_QueryCANBUY://委托查询可融资买入标的券  融资标的查询  add by xyt 20131021
            case MENU_JY_RZRQ_QueryRZBD:
                strTitle = @"可融资买入标的";
                break;
            case WT_RZRQQUERYCANSALE:
            case MENU_JY_RZRQ_QueryCANSALE://委托查询可融券卖出标的券  融券标的查询
            case MENU_JY_RZRQ_QueryRQBD:
                strTitle = @"可融券卖出标的";
                break;
            case WT_RZRQQUERYRZFZ:
            case MENU_JY_RZRQ_QueryRZFZQK://融资负债查询 融资合约 add by xyt 20131021
                strTitle = @"融资明细";
                break;
            case WT_RZRQQUERYRQFZ:
            case MENU_JY_RZRQ_QueryRQFZQK://融券负债查询 融券合约 add by xyt 20131021
                strTitle = @"融券明细";
                break;
            case WT_RZRQQUERYFZLS:
            case MENU_JY_RZRQ_QueryFZQKHis:// 负债变动 负债变动流水
                strTitle = @"负债变动流水";
                break;
            case WT_RZRQQUERYNOJY:
            case MENU_JY_RZRQ_NoTradeQueryDraw://非交易过户委托 add by xyt 20131021
                strTitle = @"非交易过户委托";
                break;
            case WT_RZRQSTOCKXQ:
                strTitle = @"行权";
                break;
            case WT_RZRQQUERYContract:
                strTitle = @"合同查询";
                break;
            case WT_RZRQQUERYBZJ:
                strTitle = @"保证金查询";
                break;
            case WT_RZRQQUERYBDQ:
            case MENU_JY_RZRQ_QueryBDZQ://标的证券查询
                strTitle = @"融资标的";
                break;
            case WT_RZRQQUERYDRLS:
            case MENU_JY_RZRQ_QueryFundsDay: //当日资金流水
                strTitle = @"资金流水历史";
                break;
            case WT_RZRQQUERYDRFZLS:
                strTitle = @"当日负债流";
                break;
            case WT_RZRQQUERYLSWT:
            case MENU_JY_RZRQ_QueryWTHis://历史委托
                strTitle = @"历史委托";
                break;
            case WT_RZRQQUERYLSCJ:
            case MENU_JY_RZRQ_QueryTransHis://历史成交
                strTitle = @"历史成交";
                break;
            case WT_RZRQQUERYDZD:
            case MENU_JY_RZRQ_QueryDZD://对账单查询
                strTitle = @"对账单";
                break;
            case WT_RZRQQUERYWITHDRAW:
                strTitle = @"委托撤单";
                break;
            case WT_RZRQYPC:
            case MENU_JY_RZRQ_QueryDealOver:
                strTitle = @"已平仓";
                break;
            case WT_RZRQWPC:
                strTitle = @"未平仓";
                break;
            case WT_RZRQTRANSHISTORY://转账流水
            case MENU_JY_RZRQ_QueryBankHis://转账流水 //新功能号 add by xyt 20131021
                strTitle = @"转账流水";
                break;
            case WT_RZRQDBPBL:
                strTitle = @"担保品比率";
                break;
            case WT_RZRQZJLSHis://
            case MENU_JY_RZRQ_QueryFundsHis://资金流水历史
                strTitle = @"资金流水历史";
                break;
            case WT_RZRQWITHDRAWHZ:
                strTitle = @"划转撤单";
                break;

            case MENU_JY_RZRQ_RZFZHis: //15306  已偿还融资负债 474
                strTitle = @"已偿还融资负债";
                break;
            case MENU_JY_RZRQ_RQFZHis: //15307  已偿还融券负债 475
                strTitle = @"已偿还融券负债";
                break;

            case MENU_JY_RZRQ_NoTradeTransHis://
                strTitle = @"历史非交易过户委托";
                break;

            case MENU_JY_RZRQ_NewStockPH:
                strTitle = @"新股配号查询";
                break;
            case MENU_JY_RZRQ_QueryNewStockED:
                strTitle = @"新股额度查询";
                break;
            case MENU_JY_RZRQ_NewStockZQ:
                strTitle = @"新股中签查询";
                break;
            case MENU_JY_RZRQ_QueryWTXinGu:
                strTitle = @"委托查询";
                break;
            case MENU_JY_RZRQ_QueryKRZQ:
                strTitle =@"融券标的";
                break;
            case MENU_JY_RZRQ_QueryBail:
                strTitle =@"查询保证金";
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
        _pSearchView = [[tztRZRQSearchView alloc] init];
        _pSearchView.delegate = self;
        _pSearchView.nMsgType = _nMsgType;
        _pSearchView.frame = rcSearch;
        if (_nsBeginDate && [_nsBeginDate length] > 0)
            _pSearchView.nsBeginDate = _nsBeginDate;
        if (_nsEndDate && [_nsEndDate length] > 0)
            _pSearchView.nsEndDate = _nsEndDate;
        [_tztBaseView addSubview:_pSearchView];
        [_pSearchView release];
    }
    else
    {
        _pSearchView.frame = rcSearch;
    }
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{   
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    //加载默认
    switch (_nMsgType)
    {
        case WT_RZRQQUERYGP://查询股票(股份查询)
        case MENU_JY_RZRQ_QueryStock://查询股票（查询持仓）
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            if (g_pSystermConfig.bGPAndZJ)
            {
                [pAy addObject:@"资金|3932"];
            }
            [pAy addObject:@"卖出|3923"];
            
        }
            break;
        case WT_RZRQQUERYFUNE:
        case MENU_JY_RZRQ_QueryFunds://查询资金
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            if (g_pSystermConfig.bGPAndZJ)
            {
                [pAy addObject:@"股票|3933"];
            }
        }
            break;
        case WT_RZRQQUERYHZLS://划转流水
        case MENU_JY_RZRQ_TransQueryDraw://划转流水 add by xyt 20131021
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"撤单|6807"];
            [pAy addObject:@"刷新|6802"];
        }
            break;
                   break;
        default:
        {
            if ([g_pSystermConfig.strMainTitle isEqualToString:@"西部信天游"])
            {
#define kMENU_JY_RZRQ_ZDHYHK 15444
#define kMENU_JY_RZRQ_ZDMQHK 15445
                
                 switch (_nMsgType)
                {
                    case kMENU_JY_RZRQ_ZDHYHK: //15444 指定合约还款
                    case kMENU_JY_RZRQ_ZDMQHK:  //15445 指定卖券还款
                    {
                        [pAy addObject:@"确定|6808"];
                        [pAy addObject:@"取消|3599"];
                    }
                        break;
                    default:
                    {
                        [pAy addObject:@"详细|6808"];
                        [pAy addObject:@"刷新|6802"];
                    }
                        break;

                }
                

                
            }
            else
            {
                [pAy addObject:@"详细|6808"];
                [pAy addObject:@"刷新|6802"];
            }
            
        }
            break;
    }
    
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
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case WT_RZRQQUERYGP:
        {
            _pSearchView.nMsgType = WT_RZRQQUERYGP;
            self.nMsgType = WT_RZRQQUERYGP;
            [_pSearchView OnRequestData];
            [self CreateToolBar];
            [self onSetTztTitleView:@"查询股票" type:TZTTitleReport];
            return ;
        }
            break;
        case WT_RZRQQUERYFUNE:
        {
            _pSearchView.nMsgType = WT_RZRQQUERYFUNE;
            self.nMsgType = WT_RZRQQUERYFUNE;
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
