/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易界面（iPad）右侧功能展示界面
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTradeRight_ipad.h"
#import "tztTradeSearchView_ipad.h"
#import "tztTradeAddSearchView_ipad.h"

#import "tztStockBuySellView.h"
#import "tztTradeSearchView.h"
#import "tztTradeWithDrawView.h"
#import "tztChangePWView.h"
#import "tztBankDealerView.h"
#import "tztTradeWithDrawView.h"
#import "tztTradeSearchDateView.h"
#import "tztTradeUserInfoView.h"
#import "tztWebViewController.h"

#ifdef Support_DFCG
#import "tztDFCGBankDealerView.h"
#import "tztDFCGSearchView.h"
#import "tztDFCGSearchWithDateView.h"
#endif

#ifdef Support_SBTrade
#import "tztSBTradeBuySellView.h"
#import "tztSBTradeHQSelectView.h"
#import "tztSBTradeSearchView.h"
#import "tztSBTradeWithDrawView.h"
#import "tztSBTradeHQView.h"
#endif

#ifdef Support_FundTrade
#import "tztUISearchStockView.h"
#import "tztFundSearchDateView.h"
#import "tztFundZHView.h"
#import "tztUIFundCNTradeView.h"
#import "tztUIFundTradeRGSGView.h"
#import "tztUIFundKHView.h"
#import "tztUIFundFHView.h"
#import "tztFundZHView.h"
#endif

#ifdef Support_TradeNew
#import "tztTradeTableView.h"
#endif

#ifdef Support_TradeETF
#import "tztETFCrashRGView.h"
#import "tztETFStockView.h"
#endif

#ifdef Support_RZRQ
#import "tztRZRQBuySellView.h"
#import "tztRZRQFundReturn.h"
#import "tztRZRQCrashRetuen.h"
#import "tztRZRQChangePWView.h"
#import "tztRZRQStockHzView.h"
#import "tztRZRQTradeWithDrawView.h"
#import "tztRZRQBankDealerView.h"
#import "tztRZRQVotingView.h"
#import "tztRZRQSearchDateView_iPad.h"
#import "tztRZRQNeedPTLoginView.h"
#endif

#import "tztETFApplyFundView.h"
#import "tztETFApplyWithDrawView.h"

#import "tztTradeWebView.h"

#import "tztUIBaseVCOtherMsg.h"

//新股申购
#import "tztNewStockSGView.h"

@implementation tztTradeRight_ipad
@synthesize topTabView = _topTabView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcContent = self.bounds;
    rcContent.origin.y = 33;
    rcContent.size.height -= 33;
    UIImageView * ImageViewBG = (UIImageView *)[self viewWithTag:0x20000];
    if (ImageViewBG == NULL)
    {
        ImageViewBG = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"tztTradeRightViewBG.png"]];
        ImageViewBG.frame = rcContent;
        [self addSubview:ImageViewBG];
        [ImageViewBG release];
    }else
        ImageViewBG.frame = rcContent;
    
    //上面的标签页
    if (_topTabView == NULL)
    {
        _topTabView = [[tztTabView alloc] initWithFrame:self.bounds];
        _topTabView.tztdelegate = self;
        [self addSubview:_topTabView];
        [_topTabView release];
    }
    else
    {
        _topTabView.frame = self.bounds;
        [self bringSubviewToFront:_topTabView];
    }
}

-(void)DealWithMenu:(NSInteger)nMsgType nsParam_:(NSString *)nsParam
{
    CGRect rcFrame = _topTabView.frame;
    rcFrame.size.width = self.frame.size.width;
    rcFrame.size.height -= 33;
    
    /*不存在于上下列表中才创建，否则直接跳转到相应界面显示*/
    if (![_topTabView IsExistType:nMsgType])
    {
        tztBaseTradeView *pTradeView = [self GetBaseView:nMsgType];
        pTradeView.delegate = self;
        if (_topTabView)
            [_topTabView AddViewToTab:pTradeView nsName_:GetTitleByID(nMsgType)];
        
        [pTradeView SetDefaultData];
        //传递股票代码
        if (nsParam && [nsParam length] == 6)
        {
            [pTradeView setStockCode:nsParam];
        }
        
        [pTradeView release];
    }else
    {
        tztBaseTradeView *pTradeView = (tztBaseTradeView *)[_topTabView GetActiveTabView];
        //传递股票代码
        if (pTradeView && nsParam && [nsParam length] == 6)
        {
            [pTradeView setStockCode:nsParam];
        }
        
    }
}

//底部显示查询界面
-(BOOL)IsShowSearchView:(int)nMsgType
{
    if (nMsgType == WT_BUY ||
        nMsgType == MENU_JY_PT_Buy ||
        nMsgType == WT_SALE ||
        nMsgType == MENU_JY_PT_Sell ||
        nMsgType == WT_RZRQBUY ||
        nMsgType == WT_RZRQRZBUY ||
        nMsgType == WT_RZRQBUYRETURN ||
        nMsgType == WT_RZRQSALE ||
        nMsgType == WT_RZRQRQSALE ||
        nMsgType == WT_RZRQSALERETURN||
        //新功能号 add by xyt 20131018
        nMsgType == MENU_JY_RZRQ_PTBuy||//普通买入（信用买入）
        nMsgType == MENU_JY_RZRQ_PTSell||//普通卖出（信用卖出）
        nMsgType == MENU_JY_RZRQ_XYBuy||// 融资买入
        nMsgType == MENU_JY_RZRQ_XYSell||//融券卖出
        nMsgType == MENU_JY_RZRQ_BuyReturn||//买券还券
        nMsgType == MENU_JY_RZRQ_SellReturn||//卖券还款
        nMsgType == WT_DZJY_YXMR||
        nMsgType == WT_DZJY_YXMC||
        nMsgType == WT_DZJY_DJMR||
        nMsgType == WT_DZJY_DJMC||
        nMsgType == WT_DZJY_QRMR||
        nMsgType == WT_DZJY_QRMC||
        nMsgType == WT_SBDJBUY||
        nMsgType == MENU_JY_SB_DJBuy||
        nMsgType == WT_SBQRBUY||
        nMsgType == MENU_JY_SB_QRBuy||
        nMsgType == WT_SBYXBUY||
        nMsgType == MENU_JY_SB_YXBuy||
        nMsgType == WT_SBDJSALE||
        nMsgType == MENU_JY_SB_DJSell||
        nMsgType == WT_SBQRSALE||
        nMsgType == MENU_JY_SB_QRSell||
        nMsgType == WT_SBYXSALE||
        nMsgType == MENU_JY_SB_YXSell )
    {
        return TRUE;
    }
    return FALSE;
}
-(tztBaseTradeView *)GetBaseView:(NSInteger)nMsgType
{
    tztBaseTradeView * BaseView = NULL;
    
    //券商特有功能到OtherMsg里处理
    if (BaseView == NULL)
    {
        BaseView = [tztUIBaseVCOtherMsg GetBaseView:nMsgType];
        if (BaseView)
            return BaseView;
    }
    
    switch (nMsgType)
    {
        case WT_BUY:
        case MENU_JY_PT_Buy:
        case WT_SALE:
        case MENU_JY_PT_Sell:
        {
            BaseView = [[tztTradeAddSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case MENU_JY_PT_XinGuShenGou:
        {
            BaseView = [[tztNewStockSGView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_BANKTODEALER://卡转证券
        case MENU_JY_PT_Bank2Card:
        case WT_DEALERTOBANK://证券转卡
        case MENU_JY_PT_Card2Bank:
        case WT_QUERYBALANCE://查询余额
        case MENU_JY_PT_BankYue:
        {
            BaseView = [[tztBankDealerView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_QUERYDRWT:
        case MENU_JY_PT_QueryDraw:
        case WT_WITHDRAW:
        case MENU_JY_PT_Withdraw:
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
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
        case MENU_JY_PT_QueryNewStockED: // 新股申购额度查询
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
            
        case WT_QUERYJG://查询交割
        case MENU_JY_PT_QueryJG:
        case MENU_JY_PT_QueryHisTrade:
        case WT_QUERYPH://查询配号
        case MENU_JY_PT_QueryPH:
        case WT_QUERYLS://资金明细
        case MENU_JY_PT_QueryZJMX:
        case MENU_JY_BJHG_HisQuery: //13848  历史委托查询389
        case MENU_JY_PT_QueryTransHis:// 历史成交
        case MENU_JY_PT_QueryNewStockZQ: //12384  查询新股中签
        {
            BaseView = [[tztTradeSearchDateView alloc] init];
            ((tztTradeSearchDateView*)BaseView).nMsgType = nMsgType;
            ((tztTradeSearchDateView*)BaseView).pSearchView.nMsgType = nMsgType;
        }
            break;
            
            /*多方存管*/
        case WT_DFDEALERTOBANK://证券转卡
        case WT_DFBANKTODEALER://卡转证券
        case WT_DFQUERYBALANCE://查询金额
        case WT_NeiZhuan://资金内转
        case MENU_JY_DFBANK_Bank2Card://证券转卡
        case MENU_JY_DFBANK_Card2Bank://卡转证券
        case MENU_JY_DFBANK_BankYue://查询金额
        case MENU_JY_DFBANK_Transit: // 资金调拨
        {
            BaseView = [[tztBankDealerView alloc] init];
            BaseView.nMsgType = nMsgType;
            
        }
            break;
        case WT_PWD://修改密码
        case MENU_JY_PT_Password:
        {
            BaseView = [[tztChangePWView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_ModifySelfInfo://个人信息修改
        {
            BaseView = [[tztTradeUserInfoView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
//        case WT_OUT://退出交易
//        case MENU_SYS_JYLogout:
//        {
//            DelObject(_topTabView);
//            [TZTUIBaseVCMsg OnMsg:MENU_SYS_JYLogout wParam:0 lParam:1];
//            return NULL;
//        }
//            break;
            /*货币基金*/ //add by xyt 20131025
        case WT_ETFApplyFundRG://货币基金认购
        case WT_ETFApplyFundSG://货币基金(ETF)申购
        case MENU_JY_FUND_HBShenGou://货币基金申购
        case WT_ETFApplyFundSH://货币基金(ETF)赎回
        case MENU_JY_FUND_HBShuHui://货币基金赎回
        {
            BaseView = [[tztETFApplyFundView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_ETFInquireEntrust://货币基金(ETF)当日委托查询 
        case MENU_JY_FUND_HBQueryDraw://货币基金当日委托
        case MENU_JY_FUND_HBWithdraw://货币基金委托撤单
        {//修改货币基金委托查询 modify by xyt 20131029
//            BaseView = [[tztETFApplyWithDrawView alloc] init];
//            BaseView.nMsgType = nMsgType;
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;            
#ifdef Support_DFCG/*多方存管*/
            //        case WT_DFDEALERTOBANK://证券转卡
            //        case WT_DFBANKTODEALER://卡转证券
            //        case WT_DFQUERYBALANCE://查询金额
            //        case WT_NeiZhuan://资金内转
            //        {
            //            BaseView = [[tztDFCGBankDealerView alloc] init];
            //            BaseView.nMsgType = nMsgType;
            //            ((tztDFCGBankDealerView*)BaseView).nMsgType = nMsgType;
            //        }
            //            break;
        case WT_GuiJiResult://资金归集
        case WT_DFQUERYDRNZ://当日内转查询
        case WT_NeiZhuanResult://查询流水
        case WT_DFTRANSHISTORY://调拨流水
        case MENU_JY_DFBANK_Input://资金归集
        case MENU_JY_DFBANK_QueryBankHis://查询流水
        case MENU_JY_DFBANK_QueryTransitHis://调拨流水
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_DFQUERYNZLS://历史内转查询
        case WT_DFQUERYHISTORYEx://计划查询流水
        {
            BaseView = [[tztDFCGSearchWithDateView alloc] init];
            ((tztTradeSearchDateView*)BaseView).nMsgType = nMsgType;
            ((tztTradeSearchDateView*)BaseView).pSearchView.nMsgType = nMsgType;
        }
            break;
#endif
#ifdef Support_SBTrade
        case MENU_JY_SB_DJBuy://定价买入
        case WT_SBDJBUY://三板定价买入
        case MENU_JY_SB_QRBuy://确认买入
        case WT_SBQRBUY://三板确认买入
        case MENU_JY_SB_YXBuy://意向买入
        case WT_SBYXBUY://三板意向买入
        case MENU_JY_SB_DJSell://定价卖出
        case WT_SBDJSALE://三板定价卖出
        case MENU_JY_SB_QRSell://确认卖出
        case WT_SBQRSALE://三板确认卖出
        case MENU_JY_SB_YXSell://意向卖出
        case WT_SBYXSALE://三板意向卖出
        {
            BaseView = [[tztSBTradeBuySellView alloc] init];
            BaseView.nMsgType = nMsgType;
            ((tztSBTradeBuySellView*)BaseView).bBuyFlag = (nMsgType == WT_SBDJBUY||nMsgType == WT_SBQRBUY||nMsgType == WT_SBYXBUY || nMsgType == MENU_JY_SB_DJBuy || nMsgType ==MENU_JY_SB_QRBuy || nMsgType == MENU_JY_SB_YXBuy);
        }
            break;
        case MENU_JY_SB_Withdraw://委托撤单
        case WT_SBWITHDRAW:
        case MENU_JY_SB_QueryDraw://当日委托
        case WT_QUERYSBDRWT:
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            ((tztTradeSearchView_ipad*)BaseView).nMsgType = nMsgType;
        }
            break;
        case WT_QUERYSBHQ:
        case MENU_JY_SB_HQ://三板行情
        {
            BaseView = [[tztSBTradeHQView alloc] init];
            ((tztSBTradeHQView*)BaseView).nMsgType = nMsgType;
        }
            break;
#endif
#ifdef Support_FundTrade
            /*基金交易*/
        case WT_JJRGFUND://基金认购
        case MENU_JY_FUND_RenGou:
        case WT_JJAPPLYFUND: //基金申购
        case MENU_JY_FUND_ShenGou:
        case WT_JJREDEEMFUND: //基金赎回
        case MENU_JY_FUND_ShuHui:
        {
            
            BaseView = [[tztUIFundTradeRGSGView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_JJRGFUNDEX: //场内认购
        case MENU_JY_FUNDIN_RenGou:
        case WT_JJAPPLYFUNDEX://场内申购
        case MENU_JY_FUNDIN_ShenGou:
        case WT_JJREDEEMFUNDEX://场内赎回
        case MENU_JY_FUNDIN_ShuHui:
            
        {
            BaseView = [[tztUIFundCNTradeView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_JJINQUIREENTRUST:
        case MENU_JY_FUND_QueryDraw://当日委托
        case WT_JJINCHAXUNACCOUNT:
        case MENU_JY_FUND_QueryKaihu://基金帐户（已开户基金）
        case WT_JJINQUIREGUFEN:
        case MENU_JY_FUND_QueryStock://基金份额（持仓基金）
        case WT_INQUIREFUNDEX: // 基金查询
        case MENU_JY_FUND_QueryAllCode: // 基金代码查询
        case WT_JJWITHDRAW:
        case MENU_JY_FUND_QueryAllCompany: //12825  基金公司查询
        case MENU_JY_FUND_Withdraw:
        case WT_JJINZHUCEACCOUNT://基金开户
        case WT_JJINQUIREDT:
        case WT_JJWWContactInquire://电子合同签署
        case WT_JJWWCashProdAccInquire:
        case WT_JJWWPlansTransQuery:
        case WT_JJSEARCHDT:
        case WT_XJLC_CXZT:   // 查询状态
        case WT_JJWWInquire://基金外围定投查询553
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_JJINQUIRECJ://历史成交
        case MENU_JY_FUND_QueryVerifyHis://历史确认(历史成交？)
        case WT_JJINQUIREWT://历史委托
        case MENU_JY_FUND_QueryWTHis://历史委托
        case WT_XJLC_CXYYQK: // 查询预约取款
        {
            BaseView = NewObject(tztFundSearchDateView);
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_JJFHTypeChange://分红设置
        case MENU_JY_FUND_FenHongSet://基金分红设置
        {
            BaseView = [[tztUIFundFHView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_JJINZHUCEACCOUNTEx://基金开户
        case MENU_JY_FUND_Kaihu:
        {
            BaseView = [[tztUIFundKHView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_JJINQUIRETrans:
        case MENU_JY_FUND_Change://基金转换
        {
            BaseView = [[tztFundZHView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        
#endif
#ifdef  Support_TradeETF
        case WT_ETFCrashRG://网下现金认购
        case MENU_JY_ETFWX_FundBuy: //14010  现金认购
        {
            BaseView = [[tztETFCrashRGView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_ETFStockRG://网下股票认购
        {
            BaseView = [[tztETFStockView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_ETFWithDraw://etf查撤委托
        case MENU_JY_ETFWX_Withdraw:
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
#endif
        case WT_BJHG_WTCX://委托查询
        case WT_BJHG_XXZZ://续作终止
        case WT_BJHG_TQGH://提前购回
        case WT_BJHG_YYTG://预约提前购回
        case WT_BJHG_WDQ://未到期
        case WT_BJHG_ZYMX://质押明细
        case MENU_JY_BJHG_QueryDraw:
        case MENU_JY_BJHG_Stop:
        case MENU_JY_BJHG_Ahead:
        case MENU_JY_BJHG_MakeAn:
        case MENU_JY_BJHG_QueryNoDue:
        case MENU_JY_BJHG_QueryInfo:
            // 中信报价回购功能 byDBQ20131011
        case MENU_JY_BJHG_AllInfo:  //13844  所有信息查询380
        case MENU_JY_BJHG_DEYYZZ:   //13845  大额预约中止391
        case MENU_JY_BJHG_Withdraw: //13846  委托撤单393
        case MENU_JY_BJHG_YYZZWithdraw: //13847  预约终止撤单392
        case MENU_JY_ZYHG_QueryStanda:  // 标志券明细查询
        case MENU_JY_ZYHG_QueryNoDue: // 质押出入库查询
        case MENU_JY_ZYHG_Withdraw:
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
#ifdef Support_FundTrade
            /*货币基金*/
        case WT_HBJJ_RG://认购 （同场内认购）
        case WT_HBJJ_SG://申购 （同场内申购）
        case WT_HBJJ_SH://赎回 （同场内赎回）
        {
            BaseView = [[tztUIFundCNTradeView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_DKRY_LSWT://历史委托
        case WT_DKRY_WTQR://委托确认
        {
            BaseView = NewObject(tztFundSearchDateView);
            BaseView.nMsgType = nMsgType;
        }
            break;
            /*紫金理财功能*/
        case MENU_QS_HTSC_ZJLC_RenGou://紫金产品认购
        case MENU_QS_HTSC_ZJLC_ShenGou://紫金产品申购
        case MENU_QS_HTSC_ZJLC_ShuHui://紫金产品赎回
        {
            BaseView = [[tztUIFundTradeRGSGView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case MENU_QS_HTSC_ZJLC_QueryVerifyHis://紫金历史成交
        case MENU_QS_HTSC_ZJLC_QueryWTHis://紫金历史委托
        {
            BaseView = NewObject(tztFundSearchDateView);
            BaseView.nMsgType = nMsgType;
        }
            break;
        case MENU_QS_HTSC_ZJLC_FenHongSet://紫金理财分红方式设置
        {
            BaseView = [[tztUIFundFHView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case MENU_QS_HTSC_ZJLC_Kaihu://紫金开户
        {
            BaseView = [[tztUIFundKHView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
#endif
        case WT_HBJJ_WT://查撤委托
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
            
        case WT_DKRY_WTCD://委托撤单
        case WT_DKRY_CXCC://查询持仓
        case WT_DKRY_ZCJB://资产净比
        case WT_DKRY_DRWT://当日委托
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
            /*大宗交易*/
        case WT_DZJY_YXMR://意向买入
        case WT_DZJY_YXMC://意向卖出
        case WT_DZJY_DJMR://定价买入
        case WT_DZJY_DJMC://定价卖出
        case WT_DZJY_QRMR://确认买入
        case WT_DZJY_QRMC://确认卖出
        {
            BaseView = [[tztTradeAddSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_DZJY_HQCX://行情查询
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case MENU_QS_HTSC_ZJLC_QueryDraw://紫金当日委托
        case MENU_QS_HTSC_ZJLC_Withdraw://紫金撤销委托
        case MENU_QS_HTSC_ZJLC_QueryStock://紫金持仓产品
        {
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
#ifdef Support_RZRQ
        case WT_RZRQBUY://普通买入
        case WT_RZRQRZBUY:  //融资买入
        case WT_RZRQBUYRETURN: //融资融券买券还券 3926
        case WT_RZRQSALE: //融资融券普通卖出 3923
        case WT_RZRQRQSALE: //融资融券融券卖出 3925
        case WT_RZRQSALERETURN: //融资融券卖券还款 3927
            //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
        case MENU_JY_RZRQ_XYBuy:// 融资买入
        case MENU_JY_RZRQ_XYSell://融券卖出
        case MENU_JY_RZRQ_BuyReturn://买券还券
        case MENU_JY_RZRQ_SellReturn://卖券还款
        {
            BaseView = [[tztTradeAddSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_RZRQFUNDRETURN://直接还款
        case MENU_JY_RZRQ_ReturnFunds://直接还款 //新功能号 add by xyt 20131018
        {
            BaseView = [[tztRZRQFundReturn alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_RZRQSTOCKRETURN://直接还券
        case MENU_JY_RZRQ_ReturnStock://现券还券（直接还券）//新功能号 add by xyt 20131018
        {
            BaseView = [[tztRZRQCrashRetuen alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_RZRQSTOCKHZ://担保品划转
        case MENU_JY_RZRQ_Transit://担保划转 //新功能号 add by xyt 20131018
        {
            if (g_pSystermConfig.bRZRQHZLogin)
            {
                if (g_CurUserData.nsDBPLoginToken == NULL || [g_CurUserData.nsDBPLoginToken length] <= 0)
                {
                    BaseView = [[tztRZRQNeedPTLoginView alloc] init];
                    BaseView.nMsgType = nMsgType;
                    return BaseView;
                }
            }
            BaseView = [[tztRZRQStockHzView alloc] init];
            BaseView.nMsgType = nMsgType;         
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
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
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
            BaseView = [[tztTradeSearchView_ipad alloc] init];
            BaseView.nMsgType = nMsgType;
            
        }
            break;
        case WT_RZRQQUERYLSCJ://历史成交
        case WT_RZRQQUERYLSWT://历史委托
        case WT_RZRQQUERYJG://查询交割
        case WT_RZRQQUERYDZD://对账单
        case WT_RZRQYPC:        //信用合约已平仓
        case MENU_JY_RZRQ_QueryDealOver:
        case WT_RZRQQUERYFZLS: //	委托查询负债变动流水
        case WT_RZRQZJLSHis: //资金流水历史
            //新功能号 add by xyt 20131018
        case MENU_JY_RZRQ_QueryTransHis://历史成交
        //case MENU_JY_RZRQ_QueryFundsHis://资金流水历史
        case MENU_JY_RZRQ_QueryJG://交割单查询
        case MENU_JY_RZRQ_QueryDZD://对账单查询
        case MENU_JY_RZRQ_QueryFZQKHis:// 负债变动 负债变动流水
        case MENU_JY_RZRQ_QueryFundsDayHis://资金流水 //add by xyt 20131218
        case MENU_JY_RZRQ_QueryWTHis://历史委托
        
        {
            BaseView = [[tztRZRQSearchDateView_iPad alloc] init];
            ((tztRZRQSearchDateView_iPad*)BaseView).nMsgType = nMsgType;
            ((tztRZRQSearchDateView_iPad*)BaseView).pSearchView.nMsgType = nMsgType;
        }
            break;
        case WT_RZRQChangePW://修改密码
        case MENU_JY_RZRQ_Password://修改密码 //新功能号 add by xyt 20131018
        {
            BaseView = [[tztRZRQChangePWView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case WT_RZRQBANKTODEALER: //银行转证券
        case MENU_JY_RZRQ_Bank2Card:
        case WT_RZRQDEALERTOBANK: //证券转银行
        case MENU_JY_RZRQ_Card2Bank:
        case WT_RZRQQUERYBALANCE: //查询余额
        case MENU_JY_RZRQ_BankYue:
        {
            BaseView = [[tztRZRQBankDealerView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
            //zxl 20130718 添加客户投票功能
        case WT_RZRQVOTING: //客户投票
        case MENU_JY_RZRQ_Vote://客户投票 //新功能号 add by xyt 20131018
        {
            BaseView = [[tztRZRQVotingView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
        case MENU_JY_RZRQ_NewStockSG:
        {
            BaseView = [[tztNewStockSGView alloc] init];
            BaseView.nMsgType = nMsgType;
        }
            break;
//        case WT_RZRQOut://退出交易
//        {
//            DelObject(_topTabView);
//            [TZTUIBaseVCMsg OnMsg:WT_RZRQOut wParam:0 lParam:1];
//            return NULL;
//        }
//            break;
#endif
            
        default:
            break;
    }
    return BaseView;
}

//打开担保品划转界面 add by xyt 20131029
-(void)OpenDBPHZView
{
    if (_topTabView)
    {
        tztBaseTradeView * pView = (tztBaseTradeView *)[_topTabView GetActiveTabView];
        if (pView && (pView.nMsgType == WT_RZRQSTOCKHZ || pView.nMsgType == MENU_JY_RZRQ_Transit))
        {
            [_topTabView RemoveViewAtIndex:[_topTabView GetViewIndex:pView]];
//            tztBaseTradeView *pTradeView = [[tztRZRQStockHzView alloc] init];
//            pTradeView.nMsgType = WT_RZRQSTOCKHZ;
//            [_topTabView AddViewToTab:pTradeView nsName_:GetTitleByID(WT_RZRQSTOCKHZ)];
//            [pTradeView SetDefaultData];
//            [pTradeView release];
            [self DealWithMenu:MENU_JY_RZRQ_Transit nsParam_:nil];
        }
    }
}

// zxl 20131022 删除当前WEB页面
-(void)CloseAllWebView
{
    if (_topTabView)
    {
        [_topTabView RemoveViewAtIndex:[_topTabView GetViewIndex:[_topTabView GetActiveTabView]]];
    }
}
-(void)OnMsg:(NSInteger)nMsgType wParam:(NSUInteger)wParam lParam:(NSUInteger)lParam
{
    [self DealWithMenu:nMsgType nsParam_:nil];
}
@end
