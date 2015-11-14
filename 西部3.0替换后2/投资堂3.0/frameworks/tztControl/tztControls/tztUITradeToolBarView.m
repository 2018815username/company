/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易界面中间的工具条
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUITradeToolBarView.h"

@implementation tztUITradeToolBarView
@synthesize pBtnArray = _pBtnArray;
#define ToolBtnTag 100
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _pBtnArray = NewObject(NSMutableArray);
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rcFrame = CGRectZero;
    rcFrame.size = frame.size;
    if (_pBGimage == nil)
    {
        _pBGimage = [[UIImageView alloc] initWithFrame:rcFrame];
//        _pBGimage.image = [UIImage imageTztNamed:@"TZTBottomBG.png"];
        _pBGimage.backgroundColor = [UIColor clearColor]; // 改变底部样式 byDBQ20130722
        [self addSubview:_pBGimage];
        [_pBGimage release];
    }else
        _pBGimage.frame = rcFrame;
}
-(void)GreatBtnArray
{
    if (_pBtnArray == NULL &&[_pBtnArray count] < 1)
        return;
    
    //先删除上面的所有button
    for (int y = 0; y < [self.subviews count]; y++)
    {
        UIView *view = [self.subviews objectAtIndex:y];
        if (view && [view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
            y = 0;
        }
    }
    
    int btnWidth = 60;//按钮宽度
    int SpaceWidth = 20;//2个按钮间隔宽度
    int FirstBtnX = (self.bounds.size.width - btnWidth*[_pBtnArray count] - SpaceWidth * ([_pBtnArray count] - 1))/2;
    CGRect rcFrame = CGRectMake(FirstBtnX,4, btnWidth, 28); // 总高度是28+4，使底部对齐 byDBQ20130723
    for (int i = 0; i < [_pBtnArray count]; i++)
    {
        NSString *btnName = [_pBtnArray objectAtIndex:i];
        if (btnName == NULL||[btnName length] < 1)
            continue;
        NSArray* pSubAy = [btnName componentsSeparatedByString:@"|"];
        if (pSubAy == NULL || [pSubAy count] < 2)
            continue;
        rcFrame.origin.x = FirstBtnX + i*(btnWidth + SpaceWidth);
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[pSubAy objectAtIndex:0] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageTztNamed:@"TZTButton.png"] forState:UIControlStateNormal]; // 改变按钮样式 byDBQ20130722
        button.tag = [[pSubAy objectAtIndex:1] intValue];
        button.frame = rcFrame;
        [self addSubview:button];
    }
}

-(void)SetBtnArrayByPageType:(NSInteger)pagetype
{
    if ([_pBtnArray count] > 0)
        [_pBtnArray removeAllObjects];

    switch (pagetype)
    {
        case WT_BUY:
        case MENU_JY_PT_Buy:
        case WT_SALE:
        case MENU_JY_PT_Sell:
            /*三板*/
        case WT_SBDJBUY:
        case MENU_JY_SB_DJBuy:
        case WT_SBDJSALE:
        case MENU_JY_SB_DJSell:
        case WT_SBQRBUY:
        case MENU_JY_SB_QRBuy:
        case WT_SBQRSALE:
        case MENU_JY_SB_QRSell:
        case WT_SBYXBUY:
        case MENU_JY_SB_YXBuy:
        case WT_SBYXSALE:
        case MENU_JY_SB_YXSell:
            /*基金*/
        case WT_JJRGFUND:       //基金认购
        case MENU_JY_FUND_RenGou:
        case WT_JJAPPLYFUND:    //基金申购
        case MENU_JY_FUND_ShenGou:
        case WT_JJREDEEMFUND:   //基金赎回
        case MENU_JY_FUND_ShuHui:
        case WT_JJRGFUNDEX: //场内认购
        case MENU_JY_FUNDIN_RenGou:
        case WT_JJAPPLYFUNDEX://场内申购
        case MENU_JY_FUNDIN_ShenGou:
        case WT_JJREDEEMFUNDEX://场内赎回
        case MENU_JY_FUNDIN_ShuHui:
            /*ETF*/
        case WT_ETFCrashRG://网下现金认购
        case WT_ETFStockRG://网下股票认购
        case MENU_JY_ETFWX_StockBuy: //14011  股票认购
            /*报价回购*/
         case WT_BJHG_Buy://报价回购委托买入
            /*货币基金*/
        case WT_HBJJ_RG://认购 （同场内认购）
        case WT_HBJJ_SG://申购 （同场内申购）
        case WT_HBJJ_SH://赎回 （同场内赎回）
        case WT_JJINQUIRETrans://基金转换
            /*质押回购功能*/
        case WT_ZYHG_ZQCK://债券出库
        case WT_ZYHG_ZQRK://债券入库
        case WT_ZYHG_RQHG://融券回购
        case WT_ZYHG_RZHG://融资回购
            /*基金盘后业务*/
        case WT_FundPH_JJFC://基金分拆
        case WT_FundPH_JJHB://基金合并
            /*融资融券*/
        case WT_RZRQBUY://普通买入
        case WT_RZRQRZBUY:  //融资买入
        case WT_RZRQBUYRETURN: //融资融券买券还券 3926
        case WT_RZRQSALE: //融资融券普通卖出 3923
        case WT_RZRQRQSALE: //融资融券融券卖出 3925
        case WT_RZRQSALERETURN: //融资融券卖券还款 3927
        case WT_RZRQSTOCKRETURN://直接还券
        case WT_RZRQSTOCKHZ://担保品划转
            /*大宗交易*/
        case WT_DZJY_QRMR://大宗交易确认买入
        case WT_DZJY_YXMR:
        case WT_DZJY_DJMR:
        case WT_DZJY_QRMC://大宗交易确认卖出
        case WT_DZJY_YXMC:
        case WT_DZJY_DJMC:
            
            /*转融通*/
        case WT_ZRT_RZMR: // 融资买入
        case WT_ZRT_RQMC: // 融券卖出
        case WT_ZRT_MQHK: // 买券还款
        case WT_ZRT_MQHQ: // 买券还券
        case WT_ZRT_ZJHK: // 直接还款
        case WT_ZRT_ZJHQ: // 直接还券
            /*理财*/
        case WT_JJLCRGFUND://理财认购 //add by xyt 20131108
        case WT_JJLCAPPLYFUND://理财申购
        case WT_JJLCREDEEMFUND://理财赎回  理财退出
        {
            [_pBtnArray addObject:@"确定|6801"];
            [_pBtnArray addObject:@"刷新|6802"];
            [_pBtnArray addObject:@"清空|6803"];
        }
            break;
        case WT_JJWWInquire://定投查询 //add by xyt 20131108
        case WT_QUERYDRWT:
        case MENU_JY_PT_QueryDraw:
        case WT_WITHDRAW:
        case MENU_JY_PT_Withdraw:
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
            /*报价回购*/
        case WT_BJHG_XXZZ://续作终止
            /*货币基金*/
        case WT_HBJJ_WT://查撤委托
        case MENU_JY_FUND_HBWithdraw:
             /*多空如弈*/
        case WT_DKRY_WTCD://委托撤单
        case MENU_JY_DKRY_Withdraw:
        case WT_DKRY_DRWT://当日委托
              /*基金盘后业务*/
        case WT_FundPH_JJCD://基金撤单
            /*紫金理财功能*/
        case MENU_QS_HTSC_ZJLC_QueryDraw://紫金当日委托
        case MENU_QS_HTSC_ZJLC_Withdraw:  //紫金撤销委托
#ifdef Support_RZRQ
        case WT_RZRQWITHDRAW:   //查询撤单
        case WT_RZRQQUERYWITHDRAW: //融资融券撤单查询
        case WT_RZRQWITHDRAWHZ://划转撤单
#endif
        {
            [_pBtnArray addObject:@"刷新|6802"];
//            [_pBtnArray addObject:@"上页|6809"];
//            [_pBtnArray addObject:@"下页|6810"];
            [_pBtnArray addObject:@"撤单|6807"];
        }
            break;
        case WT_JJLCFEInquire://理财份额查询 //add by xyt 20131108
        case WT_JJLCCPDM://理财产品查询
        case MENU_JY_FUND_XJBLEDSearch://现金保留额度设置
        case MENU_JY_FUND_KHCYZTSearch://客户参与状态设置
        case WT_QUERYLSCJ://历史成交
        case MENU_JY_PT_QueryTransHis://历史成交 新功能号add by xyt 20131128
        case WT_QUERYDRCJ://当日成交
        case MENU_JY_PT_QueryTradeDay:
        case WT_QUERYGP://查询股票
        case MENU_JY_PT_QueryStock:
        case WT_QUERYGDZL://股东资料
        case MENU_JY_PT_QueryGdzl:
        case WT_QUERYFUNE://查询资金
        case MENU_JY_PT_QueryFunds:
        case WT_TRANSHISTORY://转账流水
        case WT_QUERYJG://查询交割
        case MENU_JY_PT_QueryJG:
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
            /*基金查询*/
        case WT_QUERYSBHQ:
        case MENU_JY_SB_HQ:
        case WT_JJINCHAXUNACCOUNT:
        case MENU_JY_FUND_QueryKaihu://基金账号（已开户基金）
        case WT_JJINQUIREGUFEN:
        case MENU_JY_FUND_QueryStock://基金份额（持仓基金）
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
        case WT_JJInquireRGFund:
        case WT_JJInquireSGFund:
        case WT_LiShiDZD:
        case WT_ZiChanZZ:
        case WT_XJLC_CXZT:   // 查询状态
        case MENU_JY_XJB_QueryState:
        case WT_XJLC_CXYYQK: // 查询预约取款
        case WT_BJHG_WTCX://委托查询
        case WT_BJHG_WDQ://未到期
        case WT_BJHG_ZYMX://质押明细
        case WT_ZYHG_ZYMX://质押明细查询
        case WT_ZYHG_WDQHG://未到期回购查询
        case WT_ZYHG_BZQMX://标准券明细查询
        case WT_DKRY_CXCC://查询持仓
        case WT_DKRY_ZCJB://资产净比
        case WT_DKRY_LSWT://历史委托
        case WT_DKRY_WTQR://委托确认
        case WT_DZJY_HQCX://行情查询
        case MENU_JY_DZJY_HQ:
        case WT_FundPH_CXCJ://查询成交
        case WT_FundPH_CXWT://查询委托
        case MENU_QS_HTSC_ZJLC_QueryStock://紫金持仓产品
        case MENU_QS_HTSC_ZJLC_QueryVerifyHis: //紫金历史成交
        case MENU_QS_HTSC_ZJLC_QueryWTHis: //紫金历史委托
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
        case MENU_JY_RZRQ_QueryXYShangXian: // 信用上限
        case WT_RZRQQUERYZCFZ:  //信用负债
        case MENU_JY_RZRQ_QueryHeYue:
        case WT_RZRQQUERYCANBUY://融资标的查询
        case WT_RZRQQUERYCANSALE://融券标的查询
        case WT_RZRQQUERYDBP:   //查询担保品
        case WT_RZRQQUERYXYGF:  //信用股份
        case WT_RZRQQUERYXYZC:  //信用资产
        case MENU_JY_RZRQ_QueryXYZC:
        case WT_RZRQGDLB:       //股东列表
        case WT_RZRQWPC:        //信用合约未平仓
        case WT_RZRQTRANSHISTORY://转账流水
        case MENU_JY_RZRQ_QueryBankHis:
        case WT_RZRQQUERYBDQ://标的券查询
        case MENU_JY_RZRQ_QueryBDZQ: // 标的证券
        case WT_RZRQDBPBL:
            //zxl 20130718 添加以下功能请求
        case WT_RZRQQUERYContract://合同查询
        case WT_RZRQQUERYBZJ://保证金查询
        case WT_RZRQQUERYDRLS://当日资金流水
        case WT_RZRQQUERYDRFZLS://当日负债流水
        case WT_RZRQQUERYLSCJ://历史成交
        case WT_RZRQQUERYLSWT://历史委托
        case MENU_JY_RZRQ_QueryWTHis: // 历史委托
        case WT_RZRQQUERYJG://查询交割
        case WT_RZRQQUERYDZD://对账单
        case WT_RZRQYPC:        //信用合约已平仓
        case WT_RZRQQUERYFZLS: //	委托查询负债变动流水
        case WT_RZRQZJLSHis: //资金流水历史
        case WT_ZRT_GPTC: // 股票头寸
        case WT_ZRT_ZJTC: // 资金头寸
        case MENU_JY_PT_QueryNewStockED: // 新股申购额度查询
        case MENU_JY_PT_QueryXinGu://新股列表查询
        {
            [_pBtnArray addObject:@"刷新|6802"];
//            [_pBtnArray addObject:@"上页|6809"];
//            [_pBtnArray addObject:@"下页|6810"];
        }
            break;
        case TZT_MENU_JY_LCCP_FH: // 18002  理财产品分红//add by xyt 20131108
        case TZT_MENU_JY_LCCP_GL_LIST:
        case WT_BANKTODEALER://卡转证券
        case MENU_JY_PT_Bank2Card:
        case WT_DEALERTOBANK://证券转卡
        case MENU_JY_PT_Card2Bank:
        case WT_QUERYBALANCE://查询余额
        case MENU_JY_PT_BankYue:
//        case WT_PWD://修改密码
            /*多方存管*/
        case WT_DFDEALERTOBANK://证券转卡
        case WT_DFBANKTODEALER://卡转证券
        case WT_DFQUERYBALANCE://查询金额
        case WT_NeiZhuan://资金内转
            /*紫金理财功能*/
        case MENU_QS_HTSC_ZJLC_RenGou:  //紫金产品认购
        case MENU_QS_HTSC_ZJLC_ShenGou: //紫金产品申购
        case MENU_QS_HTSC_ZJLC_ShuHui:  //紫金产品赎回
        case MENU_QS_HTSC_ZJLC_FenHongSet://紫金理财分红方式设置
        case MENU_QS_HTSC_ZJLC_Kaihu:   //紫金开户
        case WT_JJFHTypeChange:     //分红设置
        case WT_JJINZHUCEACCOUNTEx: //基金开户
        case MENU_JY_FUND_Kaihu:
        
        case WT_JJWWOpen://定投开户
        case MENU_JY_FUND_DTReq:
        case WT_JJWWModify://定投变约
        case MENU_JY_FUND_DTChange:
        case WT_JJWWCancel://定投取消
        case MENU_JY_FUND_DTCancel:
        //zxl
        case WT_XJLC_KTXJLC: // 开通现金理财
        case WT_XJLC_QXXJLC: // 取消现金理财
        case WT_XJLC_FWCL:   // 服务策略
        case WT_XJLC_BLJE:   // 保留金额
#ifdef Support_RZRQ
        case WT_RZRQBANKTODEALER: //银行转证券
        case MENU_JY_RZRQ_Bank2Card:
        case WT_RZRQDEALERTOBANK: //证券转银行
        case MENU_JY_RZRQ_Card2Bank:
        case WT_RZRQQUERYBALANCE: //查询余额
        case MENU_JY_RZRQ_BankYue:
#endif
        {
            [_pBtnArray addObject:@"确定|6801"];
        }
            break;
        case WT_GuiJiResult://资金归集
        {
            [_pBtnArray addObject:@"刷新|6802"];
//            [_pBtnArray addObject:@"上页|6809"];
//            [_pBtnArray addObject:@"下页|6810"];
            [_pBtnArray addObject:@"归集|6817"];
        }
            break;
        
            /*报价回购*/
        case WT_BJHG_TQGH://提前购回
        case WT_BJHG_YYTG://预约提前购回
        {
             [_pBtnArray addObject:@"购回|6807"];
        }
            break;
            /*多空如弈*/
        case WT_DKRY_SG://申购
        case WT_DKRY_SH://赎回
        case WT_DKRY_MZKD://母转看跌
        case WT_DKRY_MZKZ://母转看涨
#ifdef Support_RZRQ
        case WT_RZRQFUNDRETURN://直接还款
#endif
        {
            [_pBtnArray addObject:@"确定|6801"];
            [_pBtnArray addObject:@"刷新|6802"];
        }
            break;
        default:
            break;
    }
    [self GreatBtnArray];
}


-(void)OnButton:(id)sender
{
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnToolbarMenuClick:)])
    {
        [_pDelegate tztperformSelector:@"OnToolbarMenuClick:" withObject:sender];
    }
}
-(void)dealloc
{
    DelObject(_pBtnArray);
    [super dealloc];
}
@end
