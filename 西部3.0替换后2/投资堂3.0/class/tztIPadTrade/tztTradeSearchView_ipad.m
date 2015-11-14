/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ipad查询界面（在新的ipad查询界面上添加一个工具条界面上面放置刷新、撤单等）
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztTradeSearchView_ipad.h"
#import "tztTradeSearchView.h"
#import "tztTradeWithDrawView.h"

#ifdef Support_RZRQ
#import "tztRZRQTradeWithDrawView.h"
#endif

#ifdef Support_DFCG
#import "tztDFCGSearchView.h"
#endif

#import "tztUIFundSearchView.h"

#ifdef Support_SBTrade
#import "tztSBTradeWithDrawView.h"
#endif
#ifdef  Support_TradeETF
#import "tztETFWithDrawView.h"
#endif
#import "tztETFApplyWithDrawView.h"

#import "tztUIBaseVCOtherMsg.h"

@implementation tztTradeSearchView_ipad
@synthesize pSearchView = _pSearchView;
@synthesize aySearchButtons = _aySearchButtons;
#define tztToolViewHeight 40
#define tztBtnTag 0x10000
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)dealloc
{
    DelObject(_pSearchView);
    DelObject(_aySearchButtons);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin.x = 0;
    rcFrame.origin.y = tztToolViewHeight;
    rcFrame.size.height -= tztToolViewHeight;
    if (_pSearchView == NULL)
    {
        _pSearchView = [self GetBaseViewByMsgType];
        if (_pSearchView)
        {
            if (!_pSearchView.nMsgType) {
                _pSearchView.nMsgType = _nMsgType;
            }
            
            _pSearchView.frame = rcFrame;
            _pSearchView.delegate = self;
            [self addSubview:_pSearchView];
            [_pSearchView release];
        }
    }else
        _pSearchView.frame = rcFrame;
    
    
    rcFrame = self.bounds;
    rcFrame.origin.x = 0;
    rcFrame.origin.y = 0;
    rcFrame.size.height = tztToolViewHeight;
    
    //查询界面上面的工具条背景
    UIView * SearchTool = [self viewWithTag:0x10000];
    if (SearchTool == NULL)
    {
        SearchTool = [[UIView alloc] initWithFrame:rcFrame];
        SearchTool.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"tztTradeSegmentBg.png"]];
        [self addSubview:SearchTool];
        [SearchTool release];
    }else
        SearchTool.frame = rcFrame;
    
    [self SetSearchButtons];
    
    CGRect rcButton = CGRectMake(rcFrame.size.width - 80, 5, 70, 30);
    
    //根据不同的查询界面显示不同的按钮
    for (NSInteger i = [_aySearchButtons count] - 1; i >= 0; i--)
    {
        NSString * strValue = [_aySearchButtons objectAtIndex:i];
        NSArray* pSubAy = [strValue componentsSeparatedByString:@"|"];
        if (pSubAy == NULL || [pSubAy count] < 2)
            continue;
        
        NSString* nsName = [pSubAy objectAtIndex:0]; // 名字
        int nAction = [[pSubAy objectAtIndex:1] intValue]; // 功能号
        //一直有重复的nAction tag 出现所有加上tztBtnTag 在处理功能的时候去掉tztBtnTag 然后再加上tztBtnTag
        UIButton * button = (UIButton *)[self viewWithTag:nAction+tztBtnTag];
        if (button == nil)
        {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBackSmall.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = nAction + tztBtnTag;
            [button setTztTitle:nsName];
            [button setTztTitleColor:[UIColor whiteColor]];
            button.frame = rcButton;
            [self addSubview: button];
        }else
            button.frame = rcButton; 
        
        [self bringSubviewToFront:button];
        
        rcButton.origin.x -= 80;
    }
}
-(void)OnButtonClick:(id)sender
{
    UIButton* button = (UIButton *)sender;
    button.tag -= tztBtnTag;
    if (sender && _pSearchView)
    {
        [_pSearchView OnToolbarMenuClick:sender];
    }
    button.tag += tztBtnTag;
}
-(void)SetDefaultData
{
    if (_pSearchView)
    {
        [_pSearchView SetDefaultData];
    }
}
-(void)OnRequestData
{
    if (_pSearchView)
    {
        [_pSearchView OnRequestData];
    }
}
-(void)OnRefresh
{
    if (_pSearchView)
    {
        [_pSearchView OnRefresh];
    }
}
//设置不同界面的按钮数组
-(void)SetSearchButtons
{
    if(_aySearchButtons == NULL)
        _aySearchButtons = NewObject(NSMutableArray);
    
    if (_aySearchButtons && [_aySearchButtons count] > 0)
        [_aySearchButtons removeAllObjects];
    
    switch (_nMsgType)
    {
        case WT_QUERYDRWT:
        case MENU_JY_PT_QueryDraw:
        case WT_WITHDRAW:
        case MENU_JY_PT_Withdraw :
            /*三板查询*/
        case WT_SBWITHDRAW:
        case MENU_JY_SB_Withdraw:
        case WT_QUERYSBDRWT:
        case MENU_JY_SB_QueryDraw:
            /*基金查询*/
        case WT_JJINQUIREENTRUST:  //当日委托
        case MENU_JY_FUND_QueryDraw://当日委托
        case WT_JJWITHDRAW:        //委托撤单
        case MENU_JY_FUND_Withdraw:
            /*ETF*/
        case WT_ETFWithDraw://etf查撤委托
        case MENU_JY_ETFWX_Withdraw:
            /*报价回购*/
        case WT_BJHG_XXZZ://续作终止
            /*货币基金*/
        case WT_HBJJ_WT://查撤委托
        
            /*多空如弈*/
        case WT_DKRY_WTCD://委托撤单
        case WT_DKRY_DRWT://当日委托
            /*基金盘后业务*/
        case WT_FundPH_JJCD://基金撤单
            /*紫金理财功能*/
        case MENU_QS_HTSC_ZJLC_QueryDraw://紫金当日委托
        case MENU_QS_HTSC_ZJLC_Withdraw:  //紫金撤销委托
        case WT_RZRQWITHDRAW:   //查询撤单
        case WT_RZRQQUERYWITHDRAW: //融资融券撤单查询
        case WT_RZRQWITHDRAWHZ://划转撤单
        case WT_RZRQQUERYDRWT:  //当日委托
        case WT_RZRQQUERYHZLS:  //划转查询
        case WT_RZRQQUERYNOJY: //	委托查询非交易过户委托
        case MENU_JY_BJHG_YYZZWithdraw: //13847  预约终止撤单392
        case MENU_JY_BJHG_Withdraw: //13846  委托撤单393
        case MENU_JY_BJHG_QueryDraw: //13840  委托查询
            //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_QueryDraw://当日委托
        case MENU_JY_RZRQ_Withdraw://委托撤单
        case MENU_JY_RZRQ_TransWithdraw://划转撤单
        case MENU_JY_RZRQ_TransQueryDraw://划转流水 add by xyt 20131021
        case MENU_JY_RZRQ_NoTradeQueryDraw://非交易过户委托 add by xyt 20131021
        case MENU_JY_FUND_HBWithdraw://货币基金委托撤单
        case WT_JJPHWithDraw://基金盘后撤单 add by xyt 20131226
        case MENU_JY_ZYHG_Withdraw:
        {
            [_aySearchButtons addObject:@"撤单|6807"];
            [_aySearchButtons addObject:@"刷新|6802"];
        }
            break;
        case WT_JJWWInquire://基金定投撤销 add by xyt 20131008
        {
            [_aySearchButtons addObject:@"撤销|6813"];
            [_aySearchButtons addObject:@"刷新|6802"];
        }
            break;
        case WT_QUERYDRCJ://当日成交
        case MENU_JY_PT_QueryDeal:
        case MENU_JY_PT_QueryTradeDay:
        case WT_QUERYGP://查询股票
        case MENU_JY_PT_QueryStock:
        case WT_QUERYGDZL://股东资料
        case MENU_JY_PT_QueryGdzl:
        case WT_QUERYFUNE://查询资金
        case MENU_JY_PT_QueryFunds:
        case WT_TRANSHISTORY://转账流水
        case MENU_JY_PT_QueryBankHis://转账流水 //新功能号
        case WT_QUERYJG://查询交割
        case MENU_JY_PT_QueryJG:
        case MENU_JY_PT_QueryHisTrade:
        case WT_QUERYPH://查询配号
        case MENU_JY_PT_QueryPH:
        case WT_QUERYLS://资金明细
        case MENU_JY_PT_QueryZJMX:
            /*多方存管*/
        case WT_DFQUERYNZLS://历史内转查询
        case WT_DFQUERYHISTORYEx://计划查询流水
        case WT_DFQUERYDRNZ://当日内转查询
        case WT_NeiZhuanResult://查询流水
        case WT_DFTRANSHISTORY://调拨流水
        case MENU_JY_DFBANK_QueryBankHis://查询流水
        case MENU_JY_DFBANK_QueryTransitHis://调拨流水
            /*基金查询*/
        case WT_QUERYSBHQ:
        case MENU_JY_SB_HQ:
        case WT_JJINCHAXUNACCOUNT:
        case MENU_JY_FUND_QueryKaihu://基金帐户（已开户基金）
        case WT_JJINZHUCEACCOUNT:   //基金开户
        case WT_JJINQUIREDT:
        case WT_JJWWContactInquire://电子合同签署
        case WT_JJWWCashProdAccInquire:
        case WT_JJWWPlansTransQuery:
        case WT_JJSEARCHDT:
        case WT_JJINQUIRECJ:    //历史成交
        case MENU_JY_FUND_QueryVerifyHis://历史确认(历史成交？)
        case WT_JJINQUIREWT:    //历史委托
        case MENU_JY_FUND_QueryWTHis://历史委托
        case WT_XJLC_CXZT:   // 查询状态
        case WT_XJLC_CXYYQK: // 查询预约取款
        case WT_BJHG_WTCX://委托查询
        case WT_BJHG_WDQ://未到期
        case WT_BJHG_ZYMX://质押明细
        case MENU_JY_BJHG_MakeAn:
        case MENU_JY_BJHG_QueryNoDue:
        case MENU_JY_BJHG_QueryInfo:
            // 中信报价回购功能 byDBQ20131011
        case MENU_JY_BJHG_AllInfo:  //13844  所有信息查询380
        case WT_ZYHG_ZYMX://质押明细查询
        case WT_ZYHG_WDQHG://未到期回购查询
        case WT_ZYHG_BZQMX://标准券明细查询
        case WT_DKRY_CXCC://查询持仓
        case WT_DKRY_ZCJB://资产净比
        case WT_DKRY_LSWT://历史委托
        case WT_DKRY_WTQR://委托确认
        case WT_DZJY_HQCX://行情查询
        case WT_FundPH_CXCJ://查询成交
        case WT_FundPH_CXWT://查询委托
            /*融资融券*/
        case WT_RZRQQUERYFUNE:  //查询资金
        case WT_RZRQQUERYGP:    //查询股票
        case WT_RZRQQUERYDRCJ:  //当日成交
        case WT_RZRQQUERYLS:    //资金流水
        case WT_RZRQQUERYRZQK:  //融资负债
        case WT_RZRQQUERYRQQK:  //融券负债
        case WT_RZRQQUERYRZFZ:  //融资明细
        case WT_RZRQQUERYRQFZ:  //融券明细
        case WT_RZRQQUERYXYSX:  //信用上限
        case WT_RZRQQUERYZCFZ:  //信用负债
        case WT_RZRQQUERYCANBUY://融资标的查询
        case WT_RZRQQUERYCANSALE://融券标的查询
        case WT_RZRQQUERYDBP:   //查询担保品
        case WT_RZRQQUERYXYGF:  //信用股份
        case WT_RZRQQUERYXYZC:  //信用资产
        case WT_RZRQGDLB:       //股东列表
        case WT_RZRQWPC:        //信用合约未平仓
        case WT_RZRQTRANSHISTORY://转账流水
        case MENU_JY_RZRQ_QueryBankHis:
        case WT_RZRQQUERYBDQ://标的券查询
        case MENU_JY_RZRQ_QueryBDZQ://标的证券查询
        case WT_RZRQDBPBL:
        case WT_RZRQQUERYContract://合同查询
        case WT_RZRQQUERYBZJ://保证金查询
        case WT_RZRQQUERYDRLS://当日资金流水
        case MENU_JY_RZRQ_QueryFundsDay: //当日资金流水
        case WT_RZRQQUERYDRFZLS://当日负债流水
            //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_QueryFunds://查询资金
        case MENU_JY_RZRQ_QueryStock://查询股票（查询持仓）
        case MENU_JY_RZRQ_QUeryTransDay://当日成交
        case MENU_JY_RZRQ_QueryRZFZQK://融资负债查询 融资合约
        case MENU_JY_RZRQ_QueryRQFZQK://融券负债查询 融券合约
        case MENU_JY_RZRQ_QueryRZQK://融资情况查询  融资债细 融资明细
        case MENU_JY_RZRQ_QueryRQQK://融券情况查询  融券债细 融券明细
        case MENU_JY_RZRQ_QueryZCFZQK://资产负债查询 查询资产 信用负债
        case MENU_JY_RZRQ_QueryDBZQ:// 担保证券查询 查询担保品
        case MENU_JY_RZRQ_QueryCANBUY://委托查询可融资买入标的券   融资标的查询
        case MENU_JY_RZRQ_QueryCANSALE://委托查询可融券卖出标的券  融券标的查询
        case WT_ETFInquireEntrust://货币基金(ETF)当日委托查询 
        case MENU_JY_FUND_HBQueryDraw://货币基金当日委托
            /*基金盘后业务*/
        case WT_JJPHInquireCJ://基金盘后查询成交
        case WT_JJPHInquireEntrust://基金盘后当日成交
        case MENU_JY_PT_QueryNewStockED: // 新股申购额度查询
        case MENU_JY_RZRQ_QueryNewStockED: //15220  新股申购额度查询
        case MENU_JY_FUND_FengXianDengJIQuery:
        case MENU_JY_ZYHG_QueryStanda:  // 标志券明细查询
        case MENU_JY_ZYHG_QueryNoDue: // 质押出入库查询
        case MENU_JY_FUND_QueryAllCode: // 基金代码查询
        case MENU_JY_FUND_QueryAllCompany: //12825  基金公司查询
        {
            [_aySearchButtons addObject:@"刷新|6802"];
        }
            break;
        case WT_GuiJiResult://资金归集
        case MENU_JY_DFBANK_Input://资金归集
        {
            [_aySearchButtons addObject:@"归集|6817"];
            [_aySearchButtons addObject:@"刷新|6802"];
        }
            break;
            
        case WT_JJINQUIREGUFEN:
        case MENU_JY_FUND_QueryStock://基金份额（持仓基金）
        {
            [_aySearchButtons addObject:@"赎回|4003"];
            [_aySearchButtons addObject:@"申购|4002"];
            [_aySearchButtons addObject:@"刷新|6802"];
        }
            break;
        case MENU_QS_HTSC_ZJLC_QueryStock://紫金持仓产品
        {
            [_aySearchButtons addObject:@"赎回|50124"];
            [_aySearchButtons addObject:@"申购|50123"];
            [_aySearchButtons addObject:@"刷新|6802"];
        }
            break;
        default:
            break;
    }
}
//根据不同的界面类型创建不同的查询界面
-(tztBaseTradeView *)GetBaseViewByMsgType
{
    tztBaseTradeView * BaseView = NULL;
    
    //券商的界面类型创建不同的查询界面
    if (BaseView == NULL)
    {
        BaseView = [tztUIBaseVCOtherMsg GetBaseViewByMsgType:_nMsgType];
        if (BaseView)
            return BaseView;
    }
    
    switch (_nMsgType)
    {
        case WT_QUERYDRCJ://当日成交
        case MENU_JY_PT_QueryDeal:
        case MENU_JY_PT_QueryTradeDay:
        case WT_QUERYGP://查询股票
        case MENU_JY_PT_QueryStock:
        case WT_QUERYGDZL://股东资料
        case MENU_JY_PT_QueryGdzl:
        case WT_QUERYFUNE://查询资金
        case MENU_JY_PT_QueryFunds:
        case WT_TRANSHISTORY://转账流水
        case MENU_JY_PT_QueryBankHis://转账流水 //新功能号
        case WT_DZJY_HQCX://行情查询
        case MENU_JY_PT_QueryNewStockED: // 新股申购额度查询
        {
            BaseView = [[tztTradeSearchView alloc] init];
        }
            break;
        case WT_QUERYDRWT:
        case MENU_JY_PT_QueryDraw:
        case WT_WITHDRAW:
        case MENU_JY_PT_Withdraw:
        {
            BaseView = [[tztTradeWithDrawView alloc] init];
        }
            break;
        case WT_ETFInquireEntrust://货币基金(ETF)当日委托查询  add by xyt 20131206
        case MENU_JY_FUND_HBQueryDraw://货币基金当日委托
        case MENU_JY_FUND_HBWithdraw://货币基金委托撤单
        {
            BaseView = [[tztETFApplyWithDrawView alloc] init];
        }
            break;
#ifdef Support_DFCG/*多方存管*/
        case WT_GuiJiResult://资金归集
        case WT_DFQUERYDRNZ://当日内转查询
        case WT_NeiZhuanResult://查询流水
        case WT_DFTRANSHISTORY://调拨流水
        case MENU_JY_DFBANK_Input://资金归集
        case MENU_JY_DFBANK_QueryBankHis://查询流水
        case MENU_JY_DFBANK_QueryTransitHis://调拨流水
        {
            BaseView = [[tztDFCGSearchView alloc] init];
        }
            break;
#endif
            
#ifdef Support_FundTrade
        case WT_JJINQUIREENTRUST:
        case MENU_JY_FUND_QueryDraw://当日委托
        case WT_JJINCHAXUNACCOUNT:
        case MENU_JY_FUND_QueryKaihu://基金帐户（已开户基金）
        case WT_JJINQUIREGUFEN:
        case MENU_JY_FUND_QueryStock://基金份额（持仓基金）
        case WT_INQUIREFUNDEX: // 基金查询
        case MENU_JY_FUND_QueryAllCode: // 基金代码查询
        case WT_JJWITHDRAW:
        case MENU_JY_FUND_Withdraw:
        case WT_JJINZHUCEACCOUNT://基金开户
        case WT_JJINQUIREDT:
        case WT_JJWWContactInquire://电子合同签署
        case WT_JJWWCashProdAccInquire:
        case WT_JJWWPlansTransQuery:
        case WT_JJSEARCHDT:
        case WT_XJLC_CXZT:   // 查询状态
        case WT_JJWWInquire:
        case MENU_JY_FUND_QueryAllCompany: //12825  基金公司查询
        {
            BaseView = [[tztUIFundSearchView alloc] init];
        }
            break;
#endif
            
#ifdef  Support_TradeETF
        case WT_ETFWithDraw://etf查撤委托
        {
            //zxl  20131016 修改了etf查撤委托
            BaseView = [[tztETFWithDrawView alloc] init];
        }
            break;
#endif
        case WT_HBJJ_WT://查撤委托
        case MENU_JY_ETFWX_Withdraw:
        {
            BaseView = [[tztUIFundSearchView alloc] init];
        }
            break;
        case WT_DKRY_WTCD://委托撤单
        case WT_DKRY_CXCC://查询持仓
        case WT_DKRY_ZCJB://资产净比
        case WT_DKRY_DRWT://当日委托
        {
            BaseView = [[tztUIFundSearchView alloc] init];
        }
            break;
        case WT_FundPH_CXCJ://查询成交
        case WT_FundPH_JJCD://基金撤单
        case WT_FundPH_CXWT://查询委托
        {
            BaseView = [[tztUIFundSearchView alloc] init];
        }
            break;
        case MENU_QS_HTSC_ZJLC_QueryDraw://紫金当日委托
        case MENU_QS_HTSC_ZJLC_Withdraw://紫金撤销委托
        case MENU_QS_HTSC_ZJLC_QueryStock://紫金持仓产品
        {
            BaseView = [[tztUIFundSearchView alloc] init];
        }
            break;
#ifdef Support_SBTrade            
        case WT_SBWITHDRAW:
        case MENU_JY_SB_Withdraw:
        case WT_QUERYSBDRWT:
        case MENU_JY_SB_QueryDraw:
        {
            BaseView = [[tztSBTradeWithDrawView alloc] init];
        }
            break;
#endif
            
#ifdef Support_RZRQ
        case WT_RZRQQUERYFUNE:  //查询资金
        case WT_RZRQQUERYGP:    //查询股票
        case WT_RZRQQUERYDRCJ:  //当日成交
        case WT_RZRQQUERYLS:    //资金流水
        case WT_RZRQQUERYRZQK:  //融资负债
        case WT_RZRQQUERYRQQK:  //融券负债
        case WT_RZRQQUERYRZFZ:  //融资明细
        case WT_RZRQQUERYRQFZ:  //融券明细
        case WT_RZRQQUERYXYSX:  //信用上限
        case WT_RZRQQUERYZCFZ:  //信用负债
        case WT_RZRQQUERYCANBUY://融资标的查询
        case WT_RZRQQUERYCANSALE://融券标的查询
        case WT_RZRQQUERYDBP:   //查询担保品
        case WT_RZRQQUERYXYGF:  //信用股份
        case WT_RZRQQUERYXYZC:  //信用资产
        case WT_RZRQGDLB:       //股东列表
        case WT_RZRQWPC:        //信用合约未平仓
        case WT_RZRQTRANSHISTORY://转账流水
        case MENU_JY_RZRQ_QueryBankHis:
        case WT_RZRQQUERYBDQ://标的券查询
        case MENU_JY_RZRQ_QueryBDZQ://标的证券查询
        case WT_RZRQDBPBL:
            //zxl 20130718 添加以下功能请求
        case WT_RZRQQUERYContract://合同查询
        case WT_RZRQQUERYBZJ://保证金查询
        case WT_RZRQQUERYDRLS://当日资金流水
        case MENU_JY_RZRQ_QueryFundsDay: //当日资金流水
        case WT_RZRQQUERYDRFZLS://当日负债流水
            //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_QueryFunds://查询资金
        case MENU_JY_RZRQ_QueryStock://查询股票（查询持仓）
        case MENU_JY_RZRQ_QUeryTransDay://当日成交
        case MENU_JY_RZRQ_QueryRZFZQK://融资负债查询 融资合约
        case MENU_JY_RZRQ_QueryRQFZQK://融券负债查询 融券合约
        case MENU_JY_RZRQ_QueryRZQK://融资情况查询  融资债细 融资明细
        case MENU_JY_RZRQ_QueryRQQK://融券情况查询  融券债细 融券明细
        case MENU_JY_RZRQ_QueryZCFZQK://资产负债查询 查询资产 信用负债
        case MENU_JY_RZRQ_QueryDBZQ:// 担保证券查询 查询担保品
        case MENU_JY_RZRQ_QueryCANBUY://委托查询可融资买入标的券   融资标的查询
        case MENU_JY_RZRQ_QueryCANSALE://委托查询可融券卖出标的券  融券标的查询
        case MENU_JY_RZRQ_QueryNewStockED: //15220  新股申购额度查询
        {
            BaseView = [[tztRZRQSearchView alloc] init];
        }
            break;
            
        case WT_RZRQQUERYDRWT:  //当日委托
        case WT_RZRQQUERYHZLS:  //划转查询
        case WT_RZRQWITHDRAW:   //查询撤单
        case WT_RZRQQUERYWITHDRAW: //融资融券撤单查询
        case WT_RZRQQUERYNOJY: //	委托查询非交易过户委托
        case WT_RZRQWITHDRAWHZ://划转撤单
            //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_QueryDraw://当日委托
        case MENU_JY_RZRQ_Withdraw://委托撤单
        case MENU_JY_RZRQ_TransWithdraw://划转撤单
        case MENU_JY_RZRQ_TransQueryDraw://划转流水 add by xyt 20131021
        case MENU_JY_RZRQ_NoTradeQueryDraw://非交易过户委托 add by xyt 20131021
        {
            BaseView = [[tztRZRQTradeWithDrawView alloc] init];
        }
            break;
#endif
            
        default:
            break;
    }
    
    return BaseView;
}

//交易中边下面股票选择设置上面股票
-(void)DealSelectRow:(NSArray *)gridData StockCodeIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DealSelectRow:StockCodeIndex:)])
    {
        [self.delegate DealSelectRow:gridData StockCodeIndex:index];
    }
}
@end
