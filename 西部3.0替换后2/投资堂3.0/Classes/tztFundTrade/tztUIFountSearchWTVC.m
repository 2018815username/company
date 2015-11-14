/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:       基金查询
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFountSearchWTVC.h"

@implementation tztUIFountSearchWTVC

@synthesize pSearchView = _pSearchView;
@synthesize nsBeginDate = _nsBeginDate;
@synthesize nsEndDate = _nsEndDate;

@synthesize nsJJCode = _nsJJCode;
@synthesize nsJJGSDM = _nsJJGSDM;
@synthesize nsJJKind =_nsJJKind;
@synthesize nsJJName = _nsJJName;
@synthesize nsJJState = _nsJJState;
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
#ifdef tzt_NewVersion
//    self.view.backgroundColor = [UIColor colorWithRed:29.0/255 green:29.0/255 blue:29.0/255 alpha:1.0];
#endif
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case MENU_QS_HTSC_ZJLC_QueryAccount:
                strTitle = @"紫金客户账号查询";
                break;
            case WT_JJINQUIREENTRUST:
            case MENU_JY_FUND_QueryDraw://当日委托
            case MENU_QS_HTSC_ZJLC_QueryDraw:
            case WT_DKRY_DRWT:
                //strTitle = @"当日委托";
                strTitle = @"委托查询";//modify by xyt 20130806 东莞iphone当日委托要改成 委托查询 
                break;
            case WT_JJINCHAXUNACCOUNT:
            case MENU_JY_FUND_QueryKaihu://基金账户（已开户基金）
                strTitle = @"开户基金";
                break;
            case WT_JJINQUIREGUFEN:
            case MENU_JY_FUND_QueryStock://基金份额（持仓基金）
            case WT_DKRY_CXCC:
                strTitle = @"持仓基金";
                break;
            case MENU_QS_HTSC_ZJLC_QueryStock:
                strTitle = @"持仓产品";
                break;
            case WT_JJWITHDRAW:
            case MENU_JY_FUND_Withdraw:
            case MENU_QS_HTSC_ZJLC_Withdraw:
            case WT_DKRY_WTCD:
            case MENU_JY_DKRY_Withdraw:
            case WT_FundPH_JJCD:
            case MENU_JY_FUND_PHWithdraw:
                strTitle = @"委托撤单";
                break;
            case MENU_JY_DKRY_DayQuery:
                strTitle = @"日版综合查询";
                break;
            case MENU_JY_DKRY_WeekQuery:
                strTitle = @"周版综合查询";
                break;
            case WT_FundPH_CXWT:
                strTitle = @"查询委托";
                break;
            case WT_FundPH_CXCJ:
                strTitle = @"查询成交";
                break;
            case WT_JJINQUIRECJ:
            case MENU_QS_HTSC_ZJLC_QueryVerifyHis:
            case MENU_JY_FUND_QueryVerifyHis://历史确认(历史成交？)
                strTitle = @"历史成交";
                break;
            case WT_JJINQUIREWT:
            case MENU_QS_HTSC_ZJLC_QueryWTHis:
            case WT_DKRY_LSWT:
            case MENU_JY_FUND_QueryWTHis://历史委托
                strTitle = @"历史委托";
                break;
            case WT_DKRY_WTQR:
                strTitle = @"委托确认";
                break;
            case WT_DKRY_ZCJB:
                strTitle = @"资产净比";
                break;
            case WT_JJINZHUCEACCOUNT://基金开户
                strTitle = @"基金开户";
                break;
            case WT_JJFHTypeChange:
            case MENU_QS_HTSC_ZJLC_FenHongSet:
                strTitle = @"分红设置";
                break;
            case WT_JJINQUIREDT:
                strTitle = @"已定投查询";
                break;
            case WT_JJSEARCHDT://
            case WT_JJWWInquire:
                strTitle = @"基金定投";
                break;
            case WT_JJGSINQUIRE:
            case MENU_JY_FUND_QueryAllCompany: //12825  基金公司查询
                strTitle = @"基金公司";
                break;
                /*LOF基金盘后业务*/ //add
            case WT_JJPHInquireCJ://基金盘后当日成交查询
                strTitle = @"LOF当日成交";
                break;
            case WT_JJPHInquireHisEntrust://基金盘后历史委托查
                strTitle = @"LOF历史委托";
                break;
            case WT_JJPHInquireEntrust://基金盘后当日委托
                strTitle = @"LOF当日委托";
                break;
            case WT_JJPHWithDraw://基金盘后业务撤单
                strTitle = @"LOF撤单";
                break;
            case WT_JJPHInquireHisCJ://LOF历史成交查询
                strTitle = @"LOF历史成交";
                break;
            case WT_JJInquireLevel://基金客户风险等级查询
            case MENU_JY_FUND_FengXianDengJIQuery://基金风险等级查询
                strTitle = @"基金客户风险等级";
                break;
            case WT_JJLCWithDraw:       //理财撤单
                strTitle = @"理财撤单";
                break;
            case WT_JJLCFEInquire:      //理财份额查询
                strTitle = @"理财份额查询";
                break;
            case WT_JJLCDRWTInquire:    //理财当日委托查询
                strTitle = @"理财当日委托查询";
                break;
            case WT_JJINQUIRETransCX://基金转换
                strTitle = @"基金转换";
                break;
            case WT_JJPCKM:         //评测可购买基金
                strTitle = @"评测可购买基金";
                break;
            case WT_JJLCCPDM://产品代码查询
                strTitle = @"产品代码查询";
                break;
            case WT_JJDRCJ:
                strTitle = @"当日成交";
                break;
            case WT_HBJJ_WT://查撤委托(华泰， 货币基金查撤委托)
            case MENU_JY_FUND_HBWithdraw:
            case WT_ETFWithDraw:
            case MENU_JY_ETFWX_Withdraw:
                strTitle = @"查撤委托";
                break;
            case WT_XJLC_CXZT:
            case MENU_JY_XJB_QueryState:
                strTitle = @"查询状态";
                break;
            case MENU_JY_FUND_XJBLEDSearch:
                strTitle = @"现金保留额度";
                break;
            case MENU_JY_FUND_KHCYZTSearch:
                strTitle = @"客户参与状态";
                break;
            case WT_INQUIREFUNDEX:
            case MENU_JY_FUND_QueryAllCode: // 基金代码查询
                strTitle = @"基金查询";
                break;
            case MENU_JY_TTY_MakeWithdraw: // 天天盈预约取款撤单 add by xyt 20131107
                strTitle = @"预约取款撤单";
                break;
            case MENU_JY_FUND_PHCancel: // 页面功能号可能不对 占时保留 wry  0805
                strTitle = @"基金撤单";
                break;
            case MENU_JY_FUND_PHQueryDraw: // 页面功能号可能不对 占时保留 wry  0805
                strTitle = @"当日委托";
                break;
            case MENU_JY_FUND_DTCancel:
                strTitle = @"基金定投取消";
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
        _pSearchView = [[tztUIFundSearchView alloc] init];
        _pSearchView.delegate = self;
        _pSearchView.nMsgType = _nMsgType;
        _pSearchView.frame = rcSearch;
        if (_nsBeginDate && [_nsBeginDate length] > 0)
            _pSearchView.nsBeginDate = _nsBeginDate;
        if (_nsEndDate && [_nsEndDate length] > 0)
            _pSearchView.nsEndDate = _nsEndDate;
        //zxl 20130718 添加了查询条件（基金净值查询需要以下条件去查）
        if (_nsJJCode && [_nsJJCode length] > 0)
            _pSearchView.nsJJCode = _nsJJCode;
        if (_nsJJGSDM && [_nsJJGSDM length] > 0)
            _pSearchView.nsJJGSDM = _nsJJGSDM;
        if (_nsJJKind && [_nsJJKind length] > 0)
            _pSearchView.nsJJKind = _nsJJKind;
        if (_nsJJName && [_nsJJName length] > 0)
            _pSearchView.nsJJName = _nsJJName;
        if (_nsJJState && [_nsJJState length] > 0)
            _pSearchView.nsJJState = _nsJJState;
        [_tztBaseView addSubview:_pSearchView];
        [_pSearchView release];
    }
    else
    {
        _pSearchView.frame = rcSearch;
    }
    
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
            [pAy addObject:@"卖出|3804"];
        }
            break;
        case WT_JJINQUIREGUFEN:
        case MENU_JY_FUND_QueryStock://基金份额（持仓基金）
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"赎回|4003"];
            [pAy addObject:@"申购|4002"];
        }
            break;

        case WT_INQUIREFUNDEX:
        case MENU_JY_FUND_QueryAllCode: // 基金代码查询
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"认购|4001"];
            [pAy addObject:@"申购|4002"];
        }
            break;

        case MENU_QS_HTSC_ZJLC_QueryStock:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"赎回|50124"];
            [pAy addObject:@"申购|50123"];
        }
            break;
        case WT_JJWITHDRAW:
        case MENU_JY_FUND_Withdraw:
        case MENU_QS_HTSC_ZJLC_Withdraw:
        case WT_JJINQUIREENTRUST:
        case MENU_JY_FUND_QueryDraw://当日委托
        case MENU_QS_HTSC_ZJLC_QueryDraw:
        case WT_JJLCWithDraw:
        case WT_JJLCDRWTInquire:
        case WT_JJPHWithDraw:
        case WT_ETFWithDraw:
        case MENU_JY_ETFWX_Withdraw:
        case WT_HBJJ_WT:
        case MENU_JY_FUND_HBWithdraw:
        case WT_DKRY_WTCD:
        case MENU_JY_DKRY_Withdraw:
        case WT_DKRY_DRWT:
        case MENU_JY_DKRY_QueryDraw:
        case WT_FundPH_CXWT:
        case WT_FundPH_JJCD:
        case MENU_JY_FUND_PHWithdraw:
        case MENU_JY_TTY_MakeWithdraw: // 天天盈预约取款撤单 add by xyt 20131107
        case MENU_JY_XJB_Withdraw: //19051  预约撤单(南京)
        case MENU_JY_FUND_PHQueryDraw://wry 基金盘后当日委托测单
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"撤单|6807"];
        }
            break;
//        case MENU_JY_FUND_PHQueryDraw:{
//            [pAy addObject:@"详细|6808"];
//            [pAy addObject:@"刷新|6802"];
//            [pAy addObject:@"撤单|6807"];
//        }
//            break;
        case WT_JJINQUIRETransCX://基金转换
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"转换|4021"];
        }
            break;
        case WT_JJINZHUCEACCOUNT://基金开户
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"开户|6811"];
            break;
        case WT_JJFHTypeChange: 
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"设置|6812"];
            break;
        case WT_JJINQUIREDT:
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"编辑|4039"];
            [pAy addObject:@"删除|6813"];
            break;
        case WT_JJSEARCHDT://
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"申请|4024"];
            [pAy addObject:@"已定投|4023"];
        }
            break;
        case WT_JJWWInquire:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"申请|4058"];
            if (!g_pSystermConfig.bJJDTWithoutModify)
                [pAy addObject:@"修改|4060"];
            [pAy addObject:@"撤销|6813"];
        }
            break;
        case WT_JJInquireLevel:
        case MENU_JY_FUND_FengXianDengJIQuery://基金风险等级查询
        {
            
        }
            break;
        case MENU_JY_FUND_XJBLEDSearch: // 现金保留额度
        case MENU_JY_FUND_KHCYZTSearch: // 客户参与状态
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"设置|6801"];
            break;
            
        case WT_JJWWCancel://定投取消
        case MENU_JY_FUND_DTCancel:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"取消|6813"];
        }
            break;
        case WT_JJJingZhi:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"开户|6811"];
            [pAy addObject:@"认购|4001"];
            [pAy addObject:@"申购|4002"];
        }
            break;
        case 12752://ruyi add
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"撤销|6807"];
        }
            break;
        default:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
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
//基金代码 下条点击 上条 详细 撤单
-(void)OnToolbarMenuClick:(id)sender
{    
    BOOL bDeal = FALSE;
    if (_pSearchView)
    {
        bDeal = [_pSearchView OnToolbarMenuClick:sender];
    }
//  源代码
    UIButton *pBtn = (UIButton*)sender;
    
    if (!bDeal || (pBtn.tag == TZTToolbar_Fuction_WithDraw))
        [super OnToolbarMenuClick:sender];
}

-(void)OnBtnNextStock:(id)sender
{
    if (_pSearchView)
        [_pSearchView OnGridNextStock:_pSearchView.pGridView ayTitle_:_pSearchView.aytitle];
}

-(void)OnBtnPreStock:(id)sender
{
    if (_pSearchView)
        [_pSearchView OnGridPreStock:_pSearchView.pGridView ayTitle_:_pSearchView.aytitle];
}
 
@end

