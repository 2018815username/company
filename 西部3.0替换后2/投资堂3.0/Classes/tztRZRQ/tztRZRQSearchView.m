/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券查询
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztRZRQSearchView.h"
#ifdef kSUPPORT_XBSC
#import "RZRQMacro.h"
#endif

@implementation tztRZRQSearchView



-(NSString*)GetReqAction:(NSInteger)nMsgID
{
#if 1
    NSString* strAction = GetActionByID(nMsgID);
    if (strAction.length > 0)
    {
        self.reqAction = [NSString stringWithFormat:@"%@", strAction];
        return self.reqAction;
    }
#endif

    
    //456
    
    switch (nMsgID)
    {
        //ruyi add
        case MENU_JY_RZRQ_QueryKRZQ://融券标的查询
            _reqAction = @"416";
            break;
        case MENU_JY_RZRQ_QueryBail:
            _reqAction = @"456";
            break;
        
        case WT_RZRQQUERYBDQ://标的券
        case MENU_JY_RZRQ_QueryBDZQ://标的证券查询
            _reqAction = @"448";
            break;
            //资金查询
        case WT_RZRQQUERYFUNE:
        case MENU_JY_RZRQ_QueryFunds://查询资金
            _reqAction = @"402";
            break;
        case WT_RZRQQUERYGP://查询股票(股份查询)
        case MENU_JY_RZRQ_QueryStock://查询股票（查询持仓）
            _reqAction = @"403";
            break;
        case WT_RZRQQUERYWITHDRAW:
        case WT_RZRQQUERYDRWT://查询当日委托
        case MENU_JY_RZRQ_QueryDraw://当日委托 //新功能 add by xyt 20131018
        case MENU_JY_RZRQ_Withdraw://委托撤单
            _reqAction = @"404";
            break;
        case WT_RZRQQUERYDRCJ://当日成交
        case MENU_JY_RZRQ_QUeryTransDay://当日成交
            _reqAction = @"405";
            break;
        case WT_RZRQQUERYZCFZ://资产负债/担保品比率/信用负债
        case MENU_JY_RZRQ_QueryZCFZQK://资产负债查询 查询资产 信用负债
            _reqAction = @"406";
            break;
        case WT_RZRQQUERYRZQK://融资情况查询/融资负债明细
        case MENU_JY_RZRQ_QueryRZQK://融资情况查询  融资债细 融资明细 //新功能 add by xyt 20131021
                _reqAction = @"407";
            break;
        case WT_RZRQQUERYRQQK://融券情况
        case MENU_JY_RZRQ_QueryRQQK://融券情况查询  融券债细 融券明细 //新功能 add by xyt 20131021
                _reqAction = @"408";
            break;
        case WT_RZRQQUERYLS://资金流水
        case MENU_JY_RZRQ_QueryFundsDayHis: //资金流水
        case WT_RZRQQUERYDRLS://当日资金流水
        case MENU_JY_RZRQ_QueryFundsDay: //当日资金流水
        {
            if (g_pSystermConfig.rzrqDRLS.length > 0 && _nMsgType == MENU_JY_RZRQ_QueryFundsDay) {
                _reqAction = g_pSystermConfig.rzrqDRLS;
            }
            else
            {
                _reqAction = @"411";
            }
        }
            break;
        case WT_RZRQQUERYJG://查询交割
        case MENU_JY_RZRQ_QueryJG://交割单查询
            _reqAction = @"412";
            break;
        case WT_RZRQQUERYHZLS://划转流水
        case MENU_JY_RZRQ_TransQueryDraw://划转流水 add by xyt 20131021
        case WT_RZRQWITHDRAWHZ://划转撤单
        case MENU_JY_RZRQ_TransWithdraw://划转撤单
            _reqAction = @"413";
            break;
        case WT_RZRQQUERYDBP://查询担保品
        case MENU_JY_RZRQ_QueryDBZQ:// 担保证券查询 查询担保品
            _reqAction = @"414";
            break;
        case WT_RZRQQUERYCANBUY://可融资买入标的券查询
        case MENU_JY_RZRQ_QueryCANBUY://委托查询可融资买入标的券  融资标的查询  add by xyt 20131021
        case MENU_JY_RZRQ_QueryRZBD:
            _reqAction = @"415";
            break;
        case WT_RZRQQUERYCANSALE://可融券卖出标的券查询
        case MENU_JY_RZRQ_QueryCANSALE://委托查询可融券卖出标的券  融券标的查询
        case MENU_JY_RZRQ_QueryRQBD:
            _reqAction = @"416";
            break;
        case WT_RZRQQUERYRZFZ://融资负债明细
        case MENU_JY_RZRQ_QueryRZFZQK://融资负债查询 融资合约 add by xyt 20131021
#ifdef kSUPPORT_XBSC
        case kMENU_JY_RZRQ_ZDHYHK: //融资融券 指定合约还款信息 15444
        case kMENU_JY_RZRQ_ZDMQHK: // 融资融券 指定卖券还款信息 15445
#endif
        {
            if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
            {
                _reqAction = @"407"; // xinlan 一创后台功能号 为407   金元
            }
            else
            {
                // 源代码
                _reqAction = @"417";
            }
        }
            break;


        case WT_RZRQQUERYRQFZ://融券负债明细
        case MENU_JY_RZRQ_QueryRQFZQK://融券负债查询 融券合约 add by xyt 20131021
        {
            if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"] )
            {
                _reqAction = @"408"; // xinlan 一创后台功能号 为408  金元
            }
            else
            {
                // 源代码
                _reqAction = @"418";
            }
        }
            break;
        case WT_RZRQQUERYFZLS://资产负债变动流水
        case MENU_JY_RZRQ_QueryFZQKHis:// 负债变动 负债变动流水
            _reqAction = @"419";
            break;
        case WT_RZRQQUERYNOJY://非交易过户委托查询
        case MENU_JY_RZRQ_NoTradeQueryDraw://非交易过户委托 add by xyt 20131021
#ifdef IsZYSC
            _reqAction = @"413";
#else
            _reqAction = @"420";
#endif
            break;
        case WT_RZRQTRANSHISTORY://查询银行流水
        case MENU_JY_RZRQ_QueryBankHis://转账流水 //新功能号 add by xyt 20131021
            _reqAction = @"426";
            break;
        case WT_RZRQQUERYLSCJ://历史成交
        case MENU_JY_RZRQ_QueryTransHis://历史成交
            _reqAction = @"433";
            break;
        case WT_RZRQZJLSHis:
        case MENU_JY_RZRQ_QueryFundsHis://资金流水历史
#ifdef IsZYSC
            _reqAction = @"411";
#else
            _reqAction = @"434";
#endif
            break;
//        case MENU_JY_RZRQ_QueryXYZC:
        case WT_RZRQQUERYXYZC://信用资产
        case MENU_JY_RZRQ_QueryXYZC:
            _reqAction = @"437";
            break;
        case WT_RZRQQUERYXYGF://信用股份
            _reqAction = @"438";
            break;
        case WT_RZRQGDLB://股东列表
            _reqAction = @"441";
            break;
        case WT_RZRQQUERYXYSX://信用上限查询
        case MENU_JY_RZRQ_QueryXYShangXian://信用上限
            _reqAction = @"442";
            break;
        case WT_RZRQQUERYLSWT://历史委托
        case MENU_JY_RZRQ_QueryWTHis://历史委托
            _reqAction = @"446";
            break;
        case WT_RZRQQUERYDZD://对账单
        case MENU_JY_RZRQ_QueryDZD://对账单查询
            _reqAction = @"463";
            break;
        case WT_RZRQYPC://已平仓
        case MENU_JY_RZRQ_QueryDealOver:
            _reqAction = @"445";
            break;
        case MENU_JY_RZRQ_QueryHeYue:
            _reqAction = @"7113";
            break;
//        case MENU_JY_RZRQ_QueryWEiPingCang:
        case WT_RZRQWPC://未平仓
            _reqAction = @"407";
            break;
        case WT_RZRQDBPBL:      //担保品比率查询
            _reqAction = @"472";
            break;
        case WT_RZRQQUERYDRFZLS://当日负债流水
            _reqAction = @"454";
            break;
        case WT_RZRQQUERYContract://合同查询
            _reqAction = @"455";
            break;
        case WT_RZRQQUERYBZJ://保证金查询
            _reqAction = @"456";
            break;

        case MENU_JY_RZRQ_RZFZHis: //15306  已偿还融资负债 474
            _reqAction = @"474";
            break;
        case MENU_JY_RZRQ_RQFZHis: //15307  已偿还融券负债 475
            _reqAction = @"475";
            break;

        case MENU_JY_RZRQ_NoTradeTransHis://历史非交易过户委托
            _reqAction = @"465";
            break;
        case MENU_JY_RZRQ_QueryNewStockED: //15220  新股申购额度查询
            _reqAction = @"7101";
            break;
        case MENU_JY_RZRQ_NewStockPH: //15309  新股配号查询
            _reqAction = @"7102";
            break;
        case MENU_JY_RZRQ_NewStockZQ: //15310  新股中签查询
            _reqAction = @"7103";
            break;
        case MENU_JY_RZRQ_QueryWTXinGu:
            _reqAction = @"7107";
            break;


        default:
            break;
    }
    
    return _reqAction;
}

-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
    switch (_nMsgType) {
        case WT_RZRQQUERYWITHDRAW:
        case WT_RZRQWITHDRAWHZ:
        case MENU_JY_RZRQ_Withdraw://委托撤单
        {
            [pDict setTztObject:@"1" forKey:@"Direction"];
        }
            break;
            
        default:
            break;
    }
}

-(void)OnRequestData
{
    [self GetReqAction:_nMsgType];
    if (_reqAction == NULL || [_reqAction length] < 1)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nMaxCount] forKey:@"MaxCount"];
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nStartIndex] forKey:@"StartPos"];
    
    if (_nsBeginDate && [_nsBeginDate length] > 0)
        [pDict setTztValue:_nsBeginDate forKey:@"BeginDate"];
    if (_nsEndDate && [_nsEndDate length] > 0)
        [pDict setTztValue:_nsEndDate forKey:@"EndDate"];
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX) 
        _ntztReqNo = 1;
    NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReq forKey:@"Reqno"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    [self AddSearchInfo:pDict];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:_reqAction withDictValue:pDict];
    DelObject(pDict);
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_Detail: //详细
        {
           
            return [self OnDetail:_pGridView ayTitle_:_aytitle];
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRequestData];
            return TRUE;
        }
            break;
        case WT_RZRQSALE://卖出
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
                return TRUE;//标识已经处理过了
            
            NSString* strCode = @"";
            TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            
            tztStockInfo *pStock = NewObject(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            //获取当前的股票代码传递过去
            [TZTUIBaseVCMsg OnMsg:WT_RZRQSALE wParam:(NSUInteger)pStock lParam:0];
            [pStock release];
            return TRUE;
        }
            break;
#ifdef kSUPPORT_XBSC
        case kRZRQ_ZDHYHK: //指定合约还款
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
                return TRUE;//标识已经处理过了
            //获取当前的股票代码传递过去
            NSString* strCode = @"";
            TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            
            tztStockInfo *pStock = NewObject(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            //获取当前的股票名称传递过去
            pGridData = [pAy objectAtIndex:_nStockNameIndex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            pStock.stockName = [NSString stringWithFormat:@"%@", strCode];
            //获取当前的合约编号传递过去
            pGridData= [pAy objectAtIndex:_seialnoindex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            pStock.contractNumber=[NSString stringWithFormat:@"%@", strCode];
            //获取当前的需还款数量（需还款金额）传递过去
            pGridData= [pAy objectAtIndex:_needreturnbalanceindex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            pStock.repaymentAmount=[NSString stringWithFormat:@"%@", strCode];
            //获取当前到货日期传递过去
            pGridData= [pAy objectAtIndex:_backdateindex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            pStock.backDate=[NSString stringWithFormat:@"%@", strCode];
            
           //获取负债金额 （费用负债）传递过去
            pGridData= [pAy objectAtIndex:_debitbalanceindex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            pStock.debitBalance=[NSString stringWithFormat:@"%@", strCode];

           //获取预计利息 传递过去
            pGridData= [pAy objectAtIndex:_debitinterestindex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            pStock.debitInterest=[NSString stringWithFormat:@"%@", strCode];

          // 获取负债类型 传递过去
            pGridData= [pAy objectAtIndex:_debittypeindex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            pStock.debitType=[NSString stringWithFormat:@"%@", strCode];

            
            
            [TZTUIBaseVCMsg OnMsg:kRZRQ_ZDHYHK wParam:(NSUInteger)pStock lParam:0];
            return TRUE;
        }
            
            break;
        case kRZRQ_ZDMQHK: //指定卖券还款
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
                return TRUE;//标识已经处理过了
            
            NSString* strCode = @"";
            TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            
            tztStockInfo *pStock = NewObject(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            //获取当前的合约编号传递过去
            pGridData= [pAy objectAtIndex:_seialnoindex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            pStock.contractNumber=[NSString stringWithFormat:@"%@", strCode];
            //获取当前的需还款数量传递过去
            pGridData= [pAy objectAtIndex:_needreturnbalanceindex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            pStock.repaymentAmount=[NSString stringWithFormat:@"%@", strCode];

            
             [TZTUIBaseVCMsg OnMsg:kRZRQ_ZDMQHK wParam:(NSUInteger)pStock lParam:0];
             return TRUE;
        }
            break;
#endif
            
        default:
            break;
    }
    return [super OnToolbarMenuClick:sender];
}
@end
