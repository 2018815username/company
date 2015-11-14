/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金普通查询基类
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundSearchView.h"
//xinlan
#import "tztUIFuctionListViewController.h"
@interface tztUIFundSearchView (tztPrivate)
//处理索引数据
-(void)DealIndexData:(tztNewMSParse*)pParse;
@end

@implementation tztUIFundSearchView
@synthesize pGridView = _pGridView;
@synthesize reqAction = _reqAction;
@synthesize nsEndDate = _nsEndDate;
@synthesize nsBeginDate = _nsBeginDate;

@synthesize nsJJCode = _nsJJCode;
@synthesize nsJJGSDM = _nsJJGSDM;
@synthesize nsJJKind =_nsJJKind;
@synthesize nsJJName = _nsJJName;
@synthesize nsJJState = _nsJJState;
@synthesize aytitle = _aytitle;
-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    if(_aytitle)
    {
        [_aytitle removeAllObjects];
        [_aytitle release];
        _aytitle = nil;
    }
    [super dealloc];
}

-(id)init
{
    if (self = [super init])
    {
        _reqAction = @"";
        _nStartIndex = 0;
        _nMaxCount = 10;
        _nPageCount = 1;
        _reqchange = 0;
        _reqAdd = 0;
        _nStockCodeIndex = -1;
        _nStockNameIndex = -1;
        _nAccountIndex = -1;
        _nDrawIndex = -1;
        _nJJGSDM = -1;
        _nJJGSMC = -1;
        _nDateIndex = -1;
        _nCONTACTINDEX = -1;
        _nCURRENTSET = -1;
        _nFundAccountIndex = -1;
        _nAccountTypeIndex = -1;
        _nExpDateIndex = -1;
        _nInitDateIndex = -1;
        _nSerialNoIndex = -1;
        _aytitle = NewObject(NSMutableArray);
        
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _nMarketIndexx = -1;
       self.marketArray = [NSMutableArray array];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_pGridView == nil)
    {
        _pGridView = [[TZTUIReportGridView alloc] init];
        if (!g_nJYBackBlackColor)
        {
            _pGridView.nsBackBg = @"1"; //基金选择背景颜色白色
//            _pGridView.nsBackBg = @"0"; //黑色
        }
        _pGridView.frame = rcFrame;
        _pGridView.nGridType = 1;
        _nMaxCount = _pGridView.rowCount;
        _reqAdd = _pGridView.reqAdd;
        _pGridView.delegate = self;
        [self addSubview:_pGridView];
        [_pGridView release];
    }
    else
    {
        _pGridView.frame = rcFrame;
    }
}

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
    switch (nMsgID)
    {
        case MENU_JY_FUND_RecommandFund:
            _reqAction = @"6020";
            break;
        case MENU_QS_HTSC_ZJLC_QueryAccount:
            _reqAction = @"10";
            break;
        case WT_JJINQUIREENTRUST:
        case MENU_JY_FUND_QueryDraw://当日委托
        case MENU_QS_HTSC_ZJLC_QueryDraw:
        case WT_DKRY_DRWT:
            _reqAction = @"134";
            break;
        case WT_JJWITHDRAW:
        case MENU_JY_FUND_Withdraw:
        case MENU_QS_HTSC_ZJLC_Withdraw:
        case WT_DKRY_WTCD:
        case MENU_JY_DKRY_Withdraw:
            _reqAction = @"157";
            break;
        case WT_JJINCHAXUNACCOUNT:
        case MENU_JY_FUND_QueryKaihu://基金账号（已开户基金）
            _reqAction = @"149";
            break;
        case WT_JJINQUIREGUFEN:
        case MENU_JY_FUND_QueryStock://基金份额（持仓基金）
        case MENU_QS_HTSC_ZJLC_QueryStock:
        case WT_JJFHTypeChange:
        case MENU_QS_HTSC_ZJLC_FenHongSet:
        case WT_JJINQUIRETransCX://基金转换先查持仓
        case WT_DKRY_CXCC:
            _reqAction = @"137";
            break;
        case WT_JJINQUIRECJ:
        case MENU_QS_HTSC_ZJLC_QueryVerifyHis:
        case WT_DKRY_WTQR:
        case MENU_JY_FUND_QueryVerifyHis://历史确认(历史成交？)
            _reqAction = @"136";
            break;
        case WT_JJINQUIREWT:
        case MENU_QS_HTSC_ZJLC_QueryWTHis:
        case WT_DKRY_LSWT:
        case MENU_JY_FUND_QueryWTHis://历史委托
            _reqAction = @"135";
            break;
        case WT_JJINZHUCEACCOUNT://基金开户
        case WT_JJGSINQUIRE://基金公司查询
        case MENU_JY_FUND_QueryAllCompany: //12825  基金公司查询
            _reqAction = @"154";
            break;
        case WT_JJSEARCHDT:
            _reqAction = @"616";
            break;
        case WT_JJINQUIREDT:
        case WT_JJWWInquire:
            _reqAction = @"553";
            break;
        case WT_JJWWContactInquire:
            _reqAction = @"556";
            break;
        case WT_JJWWCashProdAccInquire:
            _reqAction = @"554";
            break;
        case WT_JJWWPlansTransQuery:
            _reqAction = @"558";
            break;
        case WT_FundPH_JJCD:
        case MENU_JY_FUND_PHWithdraw:
            _reqAction = @"637";//@"522";
            break;
        case WT_FundPH_CXWT:
        case MENU_JY_FUND_PHQueryDraw:
            _reqAction = @"637";
            break;
        case WT_FundPH_CXCJ:
        case MENU_JY_FUND_PHQueryTrade:
            _reqAction = @"635";
            break;

        case WT_JJPHInquireCJ://基金盘后当日成交查询
            _reqAction = @"635";
            break;
        case WT_JJPHInquireHisEntrust://基金盘后历史委托查
            _reqAction = @"636";
            break;
        case WT_JJPHInquireHisCJ://LOF历史成交
            _reqAction = @"634";
            break;
        case WT_JJPHInquireEntrust: //基金盘后当日委托
        case WT_JJPHWithDraw:       //基金盘后业务撤单
            _reqAction = @"637";
            break;
        case WT_JJInquireLevel:     //基金客户风险等级查询
        case MENU_JY_FUND_FengXianDengJIQuery://基金风险等级查询
            _reqAction = @"189";
            break;
        case WT_JJLCWithDraw:       //理财撤单
            _reqAction = @"356";
            break;
        case WT_JJLCFEInquire:      //理财份额查询
            _reqAction = @"355";
            break;
        case WT_JJLCDRWTInquire:    //理财当日委托查询
            _reqAction = @"356";
            break;
        case WT_JJPCKM:         //评测可购买基金
            _reqAction = @"191";
            break;
        case WT_JJLCCPDM://产品代码查询
            _reqAction = @"352";
            break;
        case WT_JJDRCJ://当日成交
            _reqAction = @"639";
            break;
        case WT_QUERYGP://查询股票
        case MENU_JY_PT_QueryStock:
            _reqAction = @"117";
            break;
        case WT_JJInquireRGFund://查询可认购基金信息
            _reqAction = @"664";
            break;
        case WT_JJInquireSGFund://查询可申购基金信息
            _reqAction = @"665";
            break;
        case WT_JJJingZhi://基金净值
            _reqAction = @"10213";
            break;
        case WT_HBJJ_WT://华泰 ，货币基金 查撤委托
        case MENU_JY_FUND_HBWithdraw:
            _reqAction = @"593";
            break;
        case WT_ETFWithDraw://etf查撤委托
        case MENU_JY_ETFWX_Withdraw:
        {
            if (g_pSystermConfig.etfWithdrawAction.length > 0) {
                _reqAction = g_pSystermConfig.etfWithdrawAction;
            }
            else
            {
                _reqAction = @"522";
            }
        }
            break;
        case WT_DKRY_ZCJB:
            _reqAction = @"674";
            break;
        case MENU_JY_XJB_QueryState:
        case WT_XJLC_CXZT://现金理财查询状态
        case MENU_JY_FUND_XJBLEDSearch: // 现金保留额度
        case MENU_JY_TTY_QueryLog: // 天天盈登记查询
        case MENU_JY_TTY_QueryFE: // 天天盈份额查询  //modify by xyt 20131120
            _reqAction = @"530";
            break;
        case WT_XJLC_CXYYQK: // 查询预约取款
        case MENU_JY_XJB_MakeTake:
        case MENU_JY_XJB_QueryMake: // 查询预约取款
        case WT_XJLC_QXYYQK:
        case WT_XJLC_SZYYQK:
        case MENU_JY_TTY_MakeWithdraw: // 天天盈预约取款撤单
            _reqAction = @"536";
            break;
        case MENU_JY_FUND_KHCYZTSearch: // 客户参与状态
            _reqAction = @"541";
            break;
        case WT_INQUIREFUNDEX: // strTitle = @"基金查询";
        case MENU_JY_FUND_QueryAllCode: // 基金代码查询
            _reqAction = @"145";
            break;
        case WT_JJWWCancel://定投取消
        case MENU_JY_FUND_DTCancel:
            _reqAction = @"553";
            break;
        case MENU_JY_DKRY_DayQuery:
            _reqAction = @"677";
            break;
        case MENU_JY_DKRY_WeekQuery:
            _reqAction = @"678";
            break;
        case MENU_JY_DKRY_QuerySQDK: //13461  查询本期多空比
            _reqAction = @"6016";
            break;
        case MENU_JY_DKRY_QuerySLWT: //13462  查询受理委托
            _reqAction = @"6015";
            break;
        case MENU_JY_DKRY_QueryWSLWT: //13463  查询未受理委托
            _reqAction = @"6015";
            break;
        case MENU_JY_DKRY_QueryYGYK: //13464  查询预估盈亏
            _reqAction = @"6017";
            break;
        case MENU_JY_XJB_Withdraw: //19051  预约撤单(南京)
            _reqAction = @"581";
            break;
        case MENU_JY_XJB_QueryContract: //19052  合同查询(南京)
            _reqAction = @"571";
            break;
        case MENU_JY_XJB_QueryDraw: //19053  委托查询(南京)
            _reqAction = @"137";
            break;
        case MENU_JY_FUND_PHCancel:
            _reqAction = @"637";
            break;
        
        default:
            break;
    }
    
#if 0
//    TZTNSLog(@"=============================================");
//    TZTNSLog(@"nMsgType                 :%ld", (long)_nMsgType);
//    TZTNSLog(@"GetActionByIDWithFuction :%@", strAction);
//    TZTNSLog(@"GetActionByMsgType       :%@", _reqAction);
//    TZTNSLog(@"=============================================");
#endif
    return  _reqAction;
}

-(void)OnRequestData
{
 
  
    [self GetReqAction:_nMsgType];
    if (_reqAction == NULL || [_reqAction length] < 1)
        return;
    //question 3 NSMutableDictionary查看问题
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    if (IsNeedFilterQuest(_nMsgType)) //是否需要过滤返回数据
    {
        _nMaxCount = 200;
        [pDict setTztValue:@"200" forKey:@"MaxCount"];
        _pGridView.nPageCount = 0;
    }
    else
        [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nMaxCount] forKey:@"MaxCount"];
    [pDict setTztValue:[NSString stringWithFormat:@"%d", (int)_nStartIndex] forKey:@"StartPos"];
    
    if (_nsBeginDate && [_nsBeginDate length] > 0)
        [pDict setTztValue:_nsBeginDate forKey:@"BeginDate"];
    if (_nsEndDate && [_nsEndDate length] > 0)
        [pDict setTztValue:_nsEndDate forKey:@"EndDate"];
    
     //zxl 20130718 基金净值条件请求
    if (_nMsgType == WT_JJJingZhi)
    {
        [pDict setTztValue:_nsJJGSDM forKey:@"jjgsdm"];
        
        if (_nsJJCode && [_nsJJCode length] > 0)
            [pDict setTztValue:_nsJJCode forKey:@"jjdm"];
        if (_nsJJKind && [_nsJJKind length] > 0)
            [pDict setTztValue:_nsJJKind forKey:@"jjtype"];
        if (_nsJJName && [_nsJJName length] > 0)
            [pDict setTztValue:_nsJJName forKey:@"jjmc"];
        if (_nsJJState && [_nsJJState length] > 0)
            [pDict setTztValue:_nsJJState forKey:@"jjstate"];
    }
//  问题2  这个_ntztReqNo的作用是什么啊 为什么要＋＋ 9.4
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX) 
        _ntztReqNo = 1;
    //问题 三 下面的这个方法是干啥用的 9.4
    NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReq forKey:@"Reqno"];
    
    [self AddSearchInfo:pDict];
   //pdict 各个键值对象代表什么
    [[tztMoblieStockComm getShareInstance] onSendDataAction:_reqAction withDictValue:pDict];
    DelObject(pDict);
}

//各个不同的请求增加个字特定的请求数据字段
-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
    switch (_nMsgType) {
        case WT_JJLCWithDraw://理财撤单  Direction=1查询可撤
        case WT_JJWITHDRAW://委托撤单
        case MENU_JY_FUND_Withdraw:
        case MENU_QS_HTSC_ZJLC_Withdraw://紫金理财委托撤单
        case WT_DKRY_WTCD:
        case MENU_JY_DKRY_Withdraw:
        case WT_FundPH_JJCD:
            [pDict setTztValue:@"1" forKey:@"Direction"];
            break;
        case MENU_QS_HTSC_ZJLC_QueryAccount:
        {
            if (g_nsUserCardID)
                [pDict setTztValue:g_nsUserCardID forKey:@"Account"];
            if (g_nsUserInquiryPW)
                [pDict setTztValue:g_nsUserInquiryPW forKey:@"password"];
        }
            break;
        case MENU_JY_DKRY_QuerySLWT:
            [pDict setTztValue:@"0" forKey:@"OPERATION"];
            break;
        case MENU_JY_DKRY_QueryWSLWT:
            [pDict setTztValue:@"1" forKey:@"OPERATION"];
            break;
        case MENU_JY_XJB_Withdraw: //19051  预约撤单(南京)
        {
            if (g_nsUserCardID)
                [pDict setTztValue:g_nsUserCardID forKey:@"Account"];
        }
            break;
        case MENU_JY_XJB_QueryContract: //19052  合同查询(南京)
        {
            [pDict setTztValue:@"" forKey:@"FUNDCODE"];
            [pDict setTztValue:@"" forKey:@"JJDJGSDM"];
        }
            break;
        default:
            break;
    }
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    if ([pParse GetErrorNo] < 0)
    {
        if ([tztBaseTradeView IsExitError:[pParse GetErrorNo]])
            [self OnNeedLoginOut];
        
        NSString* strErrMsg = [pParse GetErrorMessage];
        if (strErrMsg)
            tztAfxMessageBox(strErrMsg);
        return 0;
    }
    if ([pParse IsAction:@"138"])
    {
    
    }
    if ([pParse IsAction:@"141"] || [pParse IsAction:@"638"] || [pParse IsAction:@"5213"])//撤单成功后提示，并刷新界面数据
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        
        [self OnRequestData];
        return 0;
    }
    if ([pParse IsAction:@"189"])
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeButtonOK nTag_:0x2222 delegate_:self];
        return 0;
    }
    if ([pParse IsAction:@"552"] || [pParse IsAction:@"592"])
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        //销户成功，重新刷新界面数据
        [self OnRequestData];
        return 0;
    }
    if (([pParse GetAction] == [_reqAction intValue]) && ![pParse IsAction:@"624"] && ![pParse IsAction:@"625"])
    {
        //基础索引，所以放在此处
        NSString* strIndex = [pParse GetByName:@"JJDMINDEX"];
        TZTStringToIndex(strIndex, _nStockCodeIndex);
        
        if (_nStockCodeIndex < 0)
        {
            strIndex = [pParse GetByName:@"CONTACTINDEX"];
            TZTStringToIndex(strIndex, _nStockCodeIndex);
        }
        if (_nStockCodeIndex<0) {
            strIndex = [pParse GetByName:@"FUNDCODEINDEX"];
            TZTStringToIndex(strIndex, _nStockCodeIndex);

        }
        //基金名称
        strIndex = [pParse GetByName:@"JJMCINDEX"];
        TZTStringToIndex(strIndex, _nStockNameIndex);
        //可撤标识
        strIndex = [pParse GetByName:@"DrawIndex"];
        TZTStringToIndex(strIndex, _nDrawIndex);
        //基金账号
        strIndex = [pParse GetByName:@"JJACCOUNTINDEX"];
        TZTStringToIndex(strIndex, _nAccountIndex);
        
        strIndex = [pParse GetByName:@"AccountIndex"];
        TZTStringToIndex(strIndex, _nFundAccountIndex);
        
        strIndex = [pParse GetByName:@"MarketIndex"];
        TZTStringToIndex(strIndex, _nAccountTypeIndex);
        //公司代码
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, _nJJGSDM);
        if (_nJJGSDM < 0)
        {
            //zxl 20130718 添加了不同券商的索引配置有可能不一样
            strIndex = [pParse GetByName:@"JJGSDMINDEX"];
            TZTStringToIndex(strIndex, _nJJGSDM);
        }
        //公司名称
        strIndex = [pParse GetByName:@"JJGSMC"];
        TZTStringToIndex(strIndex, _nJJGSMC);
        if (_nJJGSMC < 0)
        {
             //zxl 20130718 添加了不同券商的索引配置有可能不一样
            strIndex = [pParse GetByName:@"JJGSMCINDEX"];
            TZTStringToIndex(strIndex, _nJJGSMC);
        }
        //日期
        strIndex = [pParse GetByName:@"DATEINDEX"];
        TZTStringToIndex(strIndex, _nDateIndex);
        if (_nDateIndex < 0)
        {
             //zxl 20130718 添加了不同券商的索引配置有可能不一样
            strIndex = [pParse GetByName:@"ORDERDATEINDEX"];
            TZTStringToIndex(strIndex, _nDateIndex);
        }
        
        //金额
        strIndex = [pParse GetByName:@"balanceindex"];
        TZTStringToIndex(strIndex, _balanceindex);
        
        //币种代码
        strIndex = [pParse GetByName:@"currencycodeindex"];
        TZTStringToIndex(strIndex, _currencycodeindex);
        
        //银行
        strIndex = [pParse GetByName:@"bankindex"];
        TZTStringToIndex(strIndex, _bankindex);
        
        //币种
        strIndex = [pParse GetByName:@"currencyindex"];
        TZTStringToIndex(strIndex, _currencyindex);
        
        
        
        //合同号
        strIndex = [pParse GetByName:@"CONTACTINDEX"];
        TZTStringToIndex(strIndex, _nCONTACTINDEX);
        //当前设置
        strIndex = [pParse GetByName:@"CURRENTSET"];
        TZTStringToIndex(strIndex, _nCURRENTSET);
        
        strIndex = [pParse GetByName:@"SignIndex"];
        TZTStringToIndex(strIndex, _nSignIndex);
        
        strIndex = [pParse GetByName:@"SendSNIndex"];
        TZTStringToIndex(strIndex, _nSendSNIndex);
        
        strIndex = [pParse GetByName:@"SNoIndex"];
        TZTStringToIndex(strIndex, _nSNoIndex);
        //开始日期
        strIndex = [pParse GetByName:@"BeginDateIndex"];
        TZTStringToIndex(strIndex, _nBeginDateIndex);
        //结束日期
        strIndex = [pParse GetByName:@"EndDateIndex"];
        TZTStringToIndex(strIndex, _nEndDateIndex);
        //投资金额
        strIndex = [pParse GetByName:@"TZJEIndex"];
        TZTStringToIndex(strIndex, _nTZJEIndex);
        //投资用途
        strIndex = [pParse GetByName:@"TZYTIndex"];
        TZTStringToIndex(strIndex, _nTZYTIndex);
        //扣款周期
        strIndex = [pParse GetByName:@"KGZQIndex"];
        TZTStringToIndex(strIndex, _nKgzqIndex);
        //扣款日期
        strIndex = [pParse GetByName:@"KGRQIndex"];
        TZTStringToIndex(strIndex, _nKgrqIndex);
        //
        strIndex = [pParse GetByName:@"PRODUCTTYPEINDEX"];
        TZTStringToIndex(strIndex, _nProductType);
        //
        strIndex = [pParse GetByName:@"JJKYINDEX"];
        TZTStringToIndex(strIndex, _nJJKYINDEX);
        
        // 保留额度有效期 -- 保留额度设置
        strIndex = [pParse GetByName:@"EXPDATEINDEX"];
        TZTStringToIndex(strIndex, _nExpDateIndex);
        
        // 发生日期
        strIndex = [pParse GetByName:@"INITDATE"];
        TZTStringToIndex(strIndex, _nInitDateIndex);
        
        // 流水号
        strIndex = [pParse GetByName:@"SERIALNO"];
        TZTStringToIndex(strIndex, _nSerialNoIndex);
        
        //新增加
        strIndex = [pParse GetByName:@"MARKETINDEX"];
        TZTStringToIndex(strIndex, _nMarketIndexx);
        
        //处理特殊索引，到各自的view中单独处理
        [self DealIndexData:pParse];
        
        NSMutableArray *ayGridData = NewObject(NSMutableArray);
        if(_nStartIndex == 0)
            [_aytitle removeAllObjects];
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        
        if (ayGrid.count <= 0)
            ayGrid = [pParse GetArrayByName:@"Grid0"];
        
        for (NSInteger i = 0; i < [ayGrid count]; i++)
        {
            //question 3 nret 是什么意思
            NSInteger nRet = [g_pSystermConfig CheckValidRow:[ayGrid objectAtIndex:i]
                                            nRowIndex_:i
                                            nComIndex_:_nStockCodeIndex
                                             nMsgType_:_nMsgType
                                           bCodeCheck_:YES];
            if (nRet < 0)
                break;
            if (nRet == 0)
                continue;
            //第0行标题
            if (i == 0 && _nStartIndex == 0)
            {
                NSArray* ayValue = [ayGrid objectAtIndex:i];
                for (NSInteger j = 0; j < [ayValue count]; j++)
                {
                    TZTGridDataTitle *obj = NewObject(TZTGridDataTitle);
                    NSString* str = [ayValue objectAtIndex:j];
                    obj.text = str;
                    
                    //zxl 20130718 添加了基金查询白底和黑底 文字颜色区分
                    if (g_nJYBackBlackColor)
                    {
                        obj.textColor = [UIColor whiteColor];
                    }
                    else
                    {
                        obj.textColor = [UIColor blackColor];
#ifdef kSUPPORT_FIRST
                        if([_pGridView.nsBackBg isEqual:@"1"])
                            obj.textColor = [UIColor blackColor];
                        else if ([_pGridView.nsBackBg isEqual:@"0"])
                            obj.textColor = [UIColor whiteColor];
#endif
//                      obj.textColor = [UIColor whiteColor];
                    }
                    [_aytitle addObject:obj];
                    [obj release];
                }
            }
            else
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                NSMutableArray *ayGridValue = NewObjectAutoD(NSMutableArray);
                if (_nMsgType == WT_WITHDRAW || _nMsgType == MENU_JY_PT_Withdraw)//委托撤单
                {
                    if (ayData && _nDrawIndex > 0 && [ayData count] > _nDrawIndex ) 
                    {
                        int nValue = [[ayData objectAtIndex:_nDrawIndex] intValue];
                        if (nValue <= 0)
                            continue;
                    }
            }
//      内容设置
                [self.marketArray removeAllObjects];
                for ( int k = 0; k < [ayData count]; k++)
                {
                    TZTGridData *GridData = NewObject(TZTGridData);
                    
                    if (k == _nDrawIndex && _nMsgType != WT_JJWWCashProdAccInquire)
                    {
                        NSString* strWithDraw = [ayData objectAtIndex:k];
                        int nCanWithDraw = [strWithDraw intValue];
                        if (_nMarketIndexx>=0) {
                            NSString* market = [ayData objectAtIndex:_nMarketIndexx];
                            [self.marketArray addObject:market];
                        }
                        if(nCanWithDraw == 0)
                        {
                            if([strWithDraw compare:@"0" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                                nCanWithDraw = 0;
                            else if([strWithDraw compare:@"否" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                                nCanWithDraw = 0;
                            else if([strWithDraw compare:@"f" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                                nCanWithDraw = 0;
                            else if([strWithDraw compare:@"false" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                                nCanWithDraw = 0;
                            else if([strWithDraw compare:@"no" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                                nCanWithDraw = 0;
                            else if([strWithDraw compare:@"n" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                                nCanWithDraw = 0;
                            else if([strWithDraw compare:@"not" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                                nCanWithDraw = 0;
                            else if([strWithDraw compare:@"不可撤" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                                nCanWithDraw = 0;
                            else
                                nCanWithDraw = 1;
                        }
                        if(nCanWithDraw)
                            GridData.text = tztCanWithDraw;
                        else
                            GridData.text = tztCannotWithDraw;
                    }
                    else
                        GridData.text = [ayData objectAtIndex:k];
                    //zxl 20130718 添加了基金查询白底和黑底 文字颜色区分
                    if (g_nJYBackBlackColor)
                    {
                        GridData.textColor = [UIColor whiteColor];
                    }
                    else
                    {
                        if([_pGridView.nsBackBg isEqual:@"1"])
                        GridData.textColor = [UIColor blackColor];
                        else if ([_pGridView.nsBackBg isEqual:@"0"])
                         GridData.textColor = [UIColor whiteColor];
                    }
                    [ayGridValue addObject:GridData];
                    DelObject(GridData);
                }
                [ayGridData addObject:ayGridValue];
            }
        }
        
        
        if(_pGridView)
        {
            NSString* strMaxCount = [pParse GetByName:@"MaxCount"];
            _valuecount = [strMaxCount intValue];
            if (!IsNeedFilterQuest(_nMsgType))
            {
                NSInteger pagecount = _valuecount * 3 / _nMaxCount + ((_valuecount * 3) % _nMaxCount ? 1 : 0);
                _pGridView.nValueCount = _valuecount;
                _pGridView.nPageCount = pagecount;
                
                NSInteger startpos = _nStartIndex;
                if(startpos == 0)
                    startpos = 1;
                NSString* strHideSegmentIndex = [pParse GetByName:@"HideSegmentIndex"];
                if (strHideSegmentIndex && strHideSegmentIndex.length > 0)
                {
                    _pGridView.nMaxColNum = [strHideSegmentIndex intValue];
                }
                _pGridView.nCurPage = startpos / (_nMaxCount / 3) + (startpos % (_nMaxCount/ 3) ? 1 : 0);
                _pGridView.indexStarPos = startpos;
                [_pGridView CreatePageData:ayGridData title:_aytitle type:_reqchange];
                _reqchange = 0;
            }
            else
            {
                _nStartIndex = 0;
                _pGridView.nReqPage = 0;
                NSString* strHideSegmentIndex = [pParse GetByName:@"HideSegmentIndex"];
                if (strHideSegmentIndex && strHideSegmentIndex.length > 0)
                {
                    _pGridView.nMaxColNum = [strHideSegmentIndex intValue];
                }
                [_pGridView CreatePageData:ayGridData title:_aytitle type:_reqchange];
                _reqchange = 0;
            }
            
            if (g_pSystermConfig.bSelectFirstRow)
            {
                //选中第一行数据
                [_pGridView setSelectRow:0];
            }
        }
        [ayGridData release];
        //        [_aytitle release];
    }
    
    [self OnDealOtherData:pParse];
    
    
    return 0;
}

-(void)OnDealOtherData:(tztNewMSParse*)pParse
{
    
}

-(void) onHBJJWithDraw:(BOOL)bSend
{
    NSArray* pAy = [_pGridView tztGetCurrent];
    if (pAy == NULL || [pAy count] <= 0)
        return;
    
    
    NSInteger nMax = MAX(_nCONTACTINDEX, MAX(_nFundAccountIndex,MAX(_nAccountTypeIndex, _nStockCodeIndex)));
    NSInteger nMin = MIN(_nCONTACTINDEX, MIN(_nFundAccountIndex,MIN(_nAccountTypeIndex, _nStockCodeIndex)));
    
    if (nMin < 0 ||nMax >= [pAy count])
        return;
    
    if (_nDrawIndex >= 0 && _nDrawIndex < [pAy count])
    {
        TZTGridData *pGrid = [pAy objectAtIndex:_nDrawIndex];
        if (pGrid && [pGrid.text compare:tztCanWithDraw] != NSOrderedSame)
        {
            [self showMessageBox:@"该委托不可撤!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"撤单提示"];
            return;
        }
    }
    
    TZTGridData* pGridData = [pAy objectAtIndex:_nCONTACTINDEX];
    if (pGridData == NULL || pGridData.text == NULL)
        return;
    
    if (!bSend)
    {
        if (pGridData && pGridData.text)
        {
            [self showMessageBox:@"确定要对该委托进行撤单处理么?" nType_:TZTBoxTypeButtonBoth nTag_:0x3333 delegate_:self withTitle_:@"撤单提示"];
            return;
        }
    }
    
    NSString* strCode = @"";
    pGridData = [pAy objectAtIndex:_nStockCodeIndex];
    if (pGridData)
    {
        strCode = pGridData.text;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:strCode forKey:@"FUNDCODE"];
    pGridData = [pAy objectAtIndex:_nCONTACTINDEX];
    if(pGridData && pGridData.text)
    {
        [pDict setTztValue:pGridData.text forKey:@"ContactID"];
    }
    
    if (_nDateIndex >= 0 && _nDateIndex < [pAy count])
    {
        pGridData = [pAy objectAtIndex:_nDateIndex];
        if(pGridData && pGridData.text)
        {
            [pDict setTztValue:pGridData.text forKey:@"ENTRUSTDATE"];
        }
    }
    
    pGridData = [pAy objectAtIndex:_nFundAccountIndex];
    if (pGridData && pGridData.text)
    {
        [pDict setTztValue:pGridData.text forKey:@"FundAccount"];
    }
    
    pGridData = [pAy objectAtIndex:_nAccountTypeIndex];
    if (pGridData && pGridData.text)
    {
        [pDict setTztValue:pGridData.text forKey:@"WTAccountType"];
    }
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"592" withDictValue:pDict];
    DelObject(pDict);
    
}

-(void)OnWithDraw
{
    NSArray* pAy = [_pGridView tztGetCurrent];
    if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
    {
        [self showMessageBox:@"无可撤单委托！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* strCode = @"";
    TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
    if (pGridData)
    {
        strCode = pGridData.text;
    }
    
    tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];

    if (_pGridView == nil)
        return;
    if (pStock.stockCode == nil || [pStock.stockCode length] < 1)
    {
        [self showMessageBox:@"无可撤单委托！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
//    TZTGridData *pDrawIndex = [pAy objectAtIndex:_nDrawIndex];
//    if ([pDrawIndex.text compare:tztCannotWithDraw] == NSOrderedSame)
//    {
//        [self showMessageBox:@"该委托不可撤单！" nType_:TZTBoxTypeNoButton nTag_:0];
//        return;
//    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
        
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    //wry 基金 基金盘后的 的撤单 -- 添加发送参数
    if (_pGridView.curIndexRow>=0 && (self.marketArray.count>_pGridView.curIndexRow)) {
        [pDict setTztValue:self.marketArray[_pGridView.curIndexRow] forKey:@"WTACCOUNTTYPE"];//
    }
    
    if (_nMsgType == MENU_JY_XJB_Withdraw)
    {
        //银行
        if (_nJJGSDM >= 0 && _nJJGSDM < [pAy count])
        {
            TZTGridData *nsGridData = [pAy objectAtIndex:_bankindex];
            if (nsGridData && nsGridData.text)
                [pDict setTztObject:nsGridData.text forKey:@"BankIndent"];
        }
        //币种
        if (_nInitDateIndex >= 0 && _nInitDateIndex < [pAy count])
        {
            TZTGridData *nsGridData = [pAy objectAtIndex:_currencycodeindex];
            if (nsGridData && nsGridData.text)
                [pDict setTztObject:nsGridData.text forKey:@"MONEYTYPE"];
        }
        //金额
        if (_nSerialNoIndex >= 0 && _nSerialNoIndex < [pAy count])
        {
            TZTGridData *nsGridData = [pAy objectAtIndex:_balanceindex];
            if (nsGridData && nsGridData.text)
                [pDict setTztObject:nsGridData.text forKey:@"Balance"];
        }
        //日期
        if (_nSerialNoIndex >= 0 && _nSerialNoIndex < [pAy count])
        {
            TZTGridData *nsGridData = [pAy objectAtIndex:_nDateIndex];
            if (nsGridData && nsGridData.text)
                [pDict setTztObject:nsGridData.text forKey:@"DealDate"];
        }
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"576" withDictValue:pDict];
        DelObject(pDict);
        return;
    }
    
    
    [pDict setTztValue:pStock.stockCode forKey:@"FUNDCODE"];
    
    if (_nMsgType == MENU_JY_TTY_MakeWithdraw)
    {
        //基金公司代码
        if (_nJJGSDM >= 0 && _nJJGSDM < [pAy count])
        {
            TZTGridData *nsGridData = [pAy objectAtIndex:_nJJGSDM];
            if (nsGridData && nsGridData.text)
                [pDict setTztObject:nsGridData.text forKey:@"JJDJGSDM"];
        }
        //基金公司代码
        if (_nInitDateIndex >= 0 && _nInitDateIndex < [pAy count])
        {
            TZTGridData *nsGridData = [pAy objectAtIndex:_nInitDateIndex];
            if (nsGridData && nsGridData.text)
                [pDict setTztObject:nsGridData.text forKey:@"INITDATE"];
        }
        //基金公司代码
        if (_nSerialNoIndex >= 0 && _nSerialNoIndex < [pAy count])
        {
            TZTGridData *nsGridData = [pAy objectAtIndex:_nSerialNoIndex];
            if (nsGridData && nsGridData.text)
                [pDict setTztObject:nsGridData.text forKey:@"SERIALNO"];
        }
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"537" withDictValue:pDict];
        DelObject(pDict);
        return;
    }
    
    
    
    pGridData = [pAy objectAtIndex:_nCONTACTINDEX];
    if(pGridData)
    {
        [pDict setTztValue:pGridData.text forKey:@"ContactID"];
    }
    if (_nDateIndex && _nDateIndex >=0) {
        pGridData = [pAy objectAtIndex:_nDateIndex];
        if(pGridData)
        {
            [pDict setTztValue:pGridData.text forKey:@"ENTRUSTDATE"];
        }
    }

    if ([_reqAction isEqualToString:@"668"]) {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5019" withDictValue:pDict];
    }
    else
    {
        //基金公司代码
        if (_nJJGSDM >= 0 && _nJJGSDM < [pAy count])
        {
            TZTGridData *nsGridData = [pAy objectAtIndex:_nJJGSDM];
            if (nsGridData && nsGridData.text)
                [pDict setTztObject:nsGridData.text forKey:@"JJDJGSDM"];
        }
    

        if (_nMsgType == MENU_JY_FUND_PHCancel || _nMsgType == MENU_JY_FUND_PHQueryDraw) {
                [[tztMoblieStockComm getShareInstance] onSendDataAction:@"638" withDictValue:pDict];
        }else{
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"141" withDictValue:pDict];
        }
        
    }
    
    DelObject(pDict);

}

-(void)OnDTXH:(BOOL)bCheck
{
    NSArray* pAy = [_pGridView tztGetCurrent];
    if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count] || [pAy count] == 1)
    {
        [self showMessageBox:@"无可销户委托！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* strCode = @"";
    TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
    if (pGridData)
    {
        strCode = pGridData.text;
    }
    
    if (_pGridView == nil)
        return;
    if (strCode == nil || [strCode length] < 1)
    {
        [self showMessageBox:@"无可销户委托！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    if (_nDrawIndex >= 0 && _nDrawIndex < [pAy count])
    {
        TZTGridData *pDrawIndex = [pAy objectAtIndex:_nDrawIndex];
        if ([pDrawIndex.text compare:tztCannotWithDraw] == NSOrderedSame)
        {
            [self showMessageBox:@"该委托不可销户！" nType_:TZTBoxTypeNoButton nTag_:0];
            return;
        }
    }
    
    NSString* strSendSN = @"";
    
    if (_nSendSNIndex >= 0 && _nSendSNIndex < [pAy count])
    {
        TZTGridData *pSendSN = [pAy objectAtIndex:_nSendSNIndex];
        if (pSendSN && [pSendSN.text length] > 0)
        {
            strSendSN = [NSString stringWithFormat:@"%@", pSendSN.text];
        }
    }
    
    NSString* strSNO = @"";
    if (_nSNoIndex >= 0 && _nSNoIndex < [pAy count])
    {
        TZTGridData *pSNo = [pAy objectAtIndex:_nSNoIndex];
        if (pSNo && [pSNo.text length] > 0)
        {
            strSNO = [NSString stringWithFormat:@"%@", pSNo.text];
        }
    }
    NSString* strDate = @"";
    if (_nDateIndex >= 0 && _nDateIndex < [pAy count])
    {
        pGridData = [pAy objectAtIndex:_nDateIndex];
        if(pGridData)
        {
            strDate = [NSString stringWithFormat:@"%@", pGridData.text];
        }
    }
    
    if (bCheck)
    {
//        NSString* strInfo = [NSString stringWithFormat:@"基金代码:%@\r\nTA流水号:%@\r\n委托流水号:%@\r\n委托日期:%@\r\n是否同意发出请求？", strCode, strSendSN, strSNO, strDate];
        NSString* strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n申请编号:%@\r\n是否同意发出请求？", strCode, strSendSN];
        
        [self showMessageBox:strInfo nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self withTitle_:@"销户信息确认"];
        return;
    }
    
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:strCode forKey:@"FUNDCODE"];
    
    [pDict setTztObject:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsFundAccount forKey:@"FUNDACCOUNT"];
    
    
    [pDict setTztObject:strSendSN forKey:@"SENDSN"];
    [pDict setTztObject:strSNO forKey:@"SNO"];
    [pDict setTztValue:strDate forKey:@"ENTRUSTDATE"];
    
    if (_nJJGSDM >= 0 && _nJJGSDM < [pAy count])
    {
        pGridData = [pAy objectAtIndex:_nJJGSDM];
        if (pGridData && pGridData.text)
        {
            [pDict setTztObject:pGridData.text forKey:@"JJDJGSDM"];
        }
    }
    
    if (_nProductType >= 0 && _nProductType < [pAy count])
    {
        pGridData = [pAy objectAtIndex:_nProductType];
        if (pGridData && pGridData.text)
        {
            [pDict setTztObject:pGridData.text forKey:@"ProductType"];
        }
    }
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"552" withDictValue:pDict];
    DelObject(pDict);

}


-(void)DealIndexData:(tztNewMSParse*)pParse
{
}
//tztGridView点击事件
-(void)tztGridView:(TZTUIBaseGridView *)gridView didSelectRowAtIndex:(NSInteger)index clicknum:(NSInteger)num gridData:(NSArray *)gridData
{
    
// 通过 num＝＝1 ？2 判断单击还是双击
// 通过 
    
////    以下是源代码
    if (num == 1 /*|| IS_TZTIPAD*/)
    {
        if (self.nMsgType==12830||([self.reqAction isEqual:@"145"]&&self.nMsgType==1)) {
        
        //   新增 xinlan 基金申购 认购点击事件 gridData count]==6
        if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
        {
            if (self.nMsgType==12830) //判断是否是基金交易返回的数据
            {
                _pGridView.backgroundColor=[UIColor blueColor];
                // gridDate是服务区发送回来的数据 index 是行  num是列
                TZTGridData *fundCode=gridData[0]; //基金代码
                NSString* strCode = fundCode.text; //基金代码
                tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
                if (strCode && strCode.length > 0)
                {
                    pStock.stockCode = [NSString stringWithFormat:@"%@", strCode]; //基金代码 类型转换
                }
                
                TZTGridData *fundState=gridData[5]; //基金状态
                NSString* State = fundState.text;   //基金状态
                if ([State isEqual:@"0"])
                {
                    [TZTUIBaseVCMsg OnMsg:MENU_JY_FUND_ShenGou wParam:(NSUInteger)pStock lParam:0]; //基金申购
                    return;
                }
                else if([State isEqual:@"1"])
                {
                    [TZTUIBaseVCMsg OnTradeFundMsg:MENU_JY_FUND_RenGou wParam:(NSUInteger)pStock lParam:0];
//                    [TZTUIBaseVCMsg OnMsg:MENU_JY_FUND_RenGou wParam:(NSUInteger)pStock lParam:0];  //基金认购
                    return;
                }
            }
        
        }
        }

        if (_delegate && [_delegate respondsToSelector:@selector(DealSelectRow:StockCodeIndex:)])
        {
            
            [_delegate DealSelectRow:gridData StockCodeIndex:_nStockCodeIndex];
        }
    }
    //修改基金查询ipad的详情 modify by xyt 20131121
    if (num == 2)
    {
//        if (IS_TZTIPAD)
//        {
//            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
//            [pDict setTztObject:_pGridView.ayGriddata forKey:@"GridDATA"];
//            [pDict setTztObject:_aytitle forKey:@"TitleData"];
//            [pDict setTztObject:[NSString stringWithFormat:@"%d",index] forKey:@"CurIndex"];
//            [TZTUIBaseVCMsg OnMsg:TZTToolbar_Fuction_Detail wParam:pDict lParam:0];
//            [pDict release];
//        }
//        else
        {
            
            //   新增 xinlan 基金申购 认购点击事件 gridData count]==6
                    if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
                    {
                        if ([gridData count]==6) //判断是否是基金交易返回的数据
                        {
                            _pGridView.backgroundColor=[UIColor blueColor];
                            // gridDate是服务区发送回来的数据 index 是行  num是列
                            TZTGridData *fundCode=gridData[0]; //基金代码
                            NSString* strCode = fundCode.text; //基金代码
                            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
                            if (strCode && strCode.length > 0)
                            {
                                pStock.stockCode = [NSString stringWithFormat:@"%@", strCode]; //基金代码 类型转换
                            }
            
                            TZTGridData *fundState=gridData[5]; //基金状态
                            NSString* State = fundState.text;   //基金状态
                            if ([State isEqual:@"0"])
                            {
                                [TZTUIBaseVCMsg OnMsg:MENU_JY_FUND_ShenGou wParam:(NSUInteger)pStock lParam:0]; //基金申购
                                return;
                            }
                            else if([State isEqual:@"1"])
                            {
                                [TZTUIBaseVCMsg OnTradeFundMsg:MENU_JY_FUND_RenGou wParam:(NSUInteger)pStock lParam:0];
            //                    [TZTUIBaseVCMsg OnMsg:MENU_JY_FUND_RenGou wParam:(NSUInteger)pStock lParam:0];  //基金认购
                                return;
                            }
                            else
                            {
                                return;
                            }
                        }
            
                    }

            [self OnDetail:_pGridView ayTitle_:_aytitle];
        }
    }
}


//刷新页面
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageRefreshAtPage:(NSInteger)page
{
    [self OnRequestData];
    return _nStartIndex;
}


//前翻页
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageBackAtPage:(NSInteger)page
{
    if(_reqchange == 0) //不累加翻页 返回请求数据后置为0后 翻页有效 yangdl 2013.03.15
    {
        NSInteger reqIndex  = (_nStartIndex <= 1 ? 1 : _nStartIndex) - _reqAdd;
        if(reqIndex <= 1)
            reqIndex = 0;
        
        _reqchange = (reqIndex <= 1 ? 1 : reqIndex) - (_nStartIndex <= 1 ? 1 : _nStartIndex);
        _nStartIndex = reqIndex;
    }
    [self OnRequestData];
    return _nStartIndex;
}

//后翻页
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageNextAtPage:(NSInteger)page
{
    if(_reqchange == 0) //不累加翻页 返回请求数据后置为0后 翻页有效 yangdl 2013.03.15
    {
        NSInteger reqIndex  = (_nStartIndex <= 1 ? 1 : _nStartIndex) + _reqAdd;
        if(reqIndex > _valuecount - _nMaxCount)
            reqIndex = _valuecount - _nMaxCount+1;
        if(reqIndex <= 1)
            reqIndex = 0;
        _reqchange = (reqIndex <= 1 ? 1 : reqIndex)  - (_nStartIndex <= 1 ? 1 : _nStartIndex);
        _nStartIndex = reqIndex;
    }
    [self OnRequestData];
    return _nStartIndex;
}
//工具栏点击
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_Pre://上页
        {
            if (IS_TZTIPAD)
                [self tztGridView:NULL pageBackAtPage:0];
            else
                [self OnGridPreStock:self.pGridView ayTitle_:self.aytitle];
        }
            break;
        case TZTToolbar_Fuction_Next://下页
        {
            if (IS_TZTIPAD)
                [self tztGridView:NULL pageNextAtPage:0];
            else
                [self OnGridNextStock:self.pGridView ayTitle_:self.aytitle];
        }
            break;
        case TZTToolbar_Fuction_Detail://详细
        {
            return [self OnDetail:_pGridView ayTitle_:_aytitle];
        }
            break;
        case TZTToolbar_Fuction_Refresh://刷新
        {
            [self OnRequestData];
            return TRUE;
        }
            break;
        case WT_JJREDEEMFUND://赎回
        case MENU_JY_FUND_ShuHui:
        case MENU_QS_HTSC_ZJLC_ShuHui:
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 1 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
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
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:(NSUInteger)pStock lParam:0];
            [pStock release];
            return TRUE;
        }
            break;
        case WT_JJAPPLYFUND://申购
        case MENU_QS_HTSC_ZJLC_ShenGou:
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 1 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
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
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:(NSUInteger)pStock lParam:0];
            [pStock release];
            return TRUE;
        }
            break;
        case WT_JJRGFUND://认购
        case MENU_JY_FUND_RenGou:
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 1 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
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
            [TZTUIBaseVCMsg OnMsg:WT_JJRGFUND wParam:(NSUInteger)pStock lParam:0];
            [pStock release];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_WithDraw://撤单
        {
            //获取当前的选中行信息
//            if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
//            {
//                if(_pGridView.curIndexRow >=0)
//                {
//                    _nStockCodeIndex=_pGridView.curIndexRow;
//                    _nDrawIndex=_pGridView.curIndexRow;
//                }
//            }
            NSArray* pAy = [_pGridView tztGetCurrent];
            
            if (pAy == NULL || [pAy count] <= 0)
                return TRUE;
            
            if (_nMsgType == WT_HBJJ_WT || _nMsgType == MENU_JY_FUND_HBWithdraw)
            {
                [self onHBJJWithDraw:FALSE];
                return TRUE;
            }
            if (_nCONTACTINDEX < 0 ||_nCONTACTINDEX >= [pAy count])
                return TRUE;
            
            if (_nDrawIndex >= 0 && _nDrawIndex < [pAy count])
            {
                TZTGridData *pGrid = [pAy objectAtIndex:_nDrawIndex];
                if (pGrid && [pGrid.text compare:tztCanWithDraw] != NSOrderedSame)
                {
                    [self showMessageBox:@"该委托不可撤!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:nil withTitle_:@"撤单提示"];
                    return TRUE;
                }
            }
            
            TZTGridData* pGrid = [pAy objectAtIndex:_nCONTACTINDEX];
            if (pGrid && pGrid.text)
            {
                [self showMessageBox:@"确定要对该委托进行撤单处理么?" nType_:TZTBoxTypeButtonBoth nTag_:0x3333 delegate_:self withTitle_:@"撤单提示"];
                return TRUE;
            }
//            [self OnWithDraw];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_FundFH://分红设置TZTToolbar_Fuction_FundDTXH
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
                return TRUE;//标识已经处理过了
            
            NSString* strCode = @"";
            NSString* strName = @"";
            TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
            
            tztStockInfo *pStock = NewObject(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            
            if (_nStockNameIndex > -1 && _nStockNameIndex < [pAy count])
            {
                pGridData = [pAy objectAtIndex:_nStockNameIndex];
                if (pGridData)
                {
                    strName = pGridData.text;
                }
                pStock.stockName = [NSString stringWithFormat:@"%@", strName];
            }
            
            NSString *CURRENTSETStr = nil;
            if (_nCURRENTSET > -1 && _nCURRENTSET < [pAy count])
            {
                pGridData = [pAy objectAtIndex:_nCURRENTSET];
                if (pGridData)
                {
                    CURRENTSETStr = [NSString stringWithFormat:@"%@", pGridData.text];
                }
            }
            
            //获取当前的股票代码传递过去
            [TZTUIBaseVCMsg OnMsg:WT_JJFHTypeChangeD wParam:(NSUInteger)pStock lParam:(NSUInteger)CURRENTSETStr];
            [pStock release];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_FundDTXH://基金定投销户
        {
            [self OnDTXH:YES];
            return TRUE;
        }
            break;
        case WT_JJDTModify://编辑
        case WT_JJZHUCEACCOUNTDT://定投开户
        {
            //获取选中的信息
            NSArray *pAy = [_pGridView tztGetCurStock];
            if (pAy == NULL || [pAy count] <= 0)
                return TRUE;
            if (_nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
                return TRUE;
            
            TZTGridData* nsCode = [pAy objectAtIndex:_nStockCodeIndex];
            if (nsCode == NULL || [nsCode.text length] < 1)
                return TRUE;
            
            //此处修改，不传递股票结构，因为编辑的时候需要传递当前信息过去,改传递字典
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:nsCode.text forKey:@"tztJJDM"];
            if (_nStockNameIndex >= 0 && _nStockNameIndex < [pAy count])
            {
                TZTGridData* nsName = [pAy objectAtIndex:_nStockNameIndex];
                if (nsName && nsName.text)
                    [pDict setTztObject:nsName.text forKey:@"tztJJMC"];
            }
            
            if (_nDateIndex >= 0 && _nDateIndex < [pAy count])
            {
                TZTGridData* nsName = [pAy objectAtIndex:_nDateIndex];
                if (nsName && nsName.text)
                    [pDict setTztObject:nsName.text forKey:@"tztENTRUSTDATE"];
            }
            
            if (_nSendSNIndex >= 0 && _nSendSNIndex < [pAy count])
            {
                TZTGridData* nsName = [pAy objectAtIndex:_nSendSNIndex];
                if (nsName && nsName.text)
                    [pDict setTztObject:nsName.text forKey:@"tztSENDSN"];
            }
            
            if (_nSNoIndex >= 0 && _nSNoIndex < [pAy count])
            {
                TZTGridData* nsName = [pAy objectAtIndex:_nSNoIndex];
                if (nsName && nsName.text)
                    [pDict setTztObject:nsName.text forKey:@"tztSNO"];
            }
            
            if (_nJJGSMC >= 0 && _nJJGSMC < [pAy count])
            {
                TZTGridData *nsJJGSMC = [pAy objectAtIndex:_nJJGSMC];
                if (nsJJGSMC && nsJJGSMC.text)
                    [pDict setTztObject:nsJJGSMC.text forKey:@"tztJJGSMC"];
            }
            
            if (_nJJGSDM >= 0 && _nJJGSDM < [pAy count])
            {
                TZTGridData *nsJJGSDM = [pAy objectAtIndex:_nJJGSDM];
                if (nsJJGSDM && nsJJGSDM.text)
                    [pDict setTztObject:nsJJGSDM.text forKey:@"tztJJGSDM"];
            }
            
            if (_nKgzqIndex >= 0 && _nKgzqIndex < [pAy count])
            {
                TZTGridData * nsKgzq = [pAy objectAtIndex:_nKgzqIndex];
                if (nsKgzq && nsKgzq.text)
                    [pDict setTztObject:nsKgzq.text forKey:@"tztKKZQ"];
            }
            
            if (_nKgrqIndex >= 0 && _nKgrqIndex < [pAy count])
            {
                TZTGridData *nsKgrq = [pAy objectAtIndex:_nKgrqIndex];
                if (nsKgrq && nsKgrq.text)
                    [pDict setTztObject:nsKgrq.text forKey:@"tztKKRQ"];
            }
            
            if (_nBeginDateIndex >= 0 && _nBeginDateIndex < [pAy count])
            {
                TZTGridData *nsBeginDate = [pAy objectAtIndex:_nBeginDateIndex];
                if (nsBeginDate && nsBeginDate.text)
                    [pDict setTztObject:nsBeginDate.text forKey:@"tztBeginDate"];
            }
            
            if (_nEndDateIndex >= 0 && _nEndDateIndex < [pAy count])
            {
                TZTGridData *nsEndDate = [pAy objectAtIndex:_nEndDateIndex];
                if (nsEndDate && nsEndDate.text)
                    [pDict setTztObject:nsEndDate.text forKey:@"tztEndDate"];
            }
            
            if (_nTZJEIndex >= 0 && _nTZJEIndex < [pAy count])
            {
                TZTGridData *nsTZJE = [pAy objectAtIndex:_nTZJEIndex];
                if (nsTZJE && nsTZJE.text)
                    [pDict setTztObject:nsTZJE.text forKey:@"tztTZJE"];
            }
            
            if (_nTZYTIndex >= 0 && _nTZYTIndex < [pAy count])
            {
                TZTGridData *nsTZYT = [pAy objectAtIndex:_nTZYTIndex];
                if (nsTZYT && nsTZYT.text)
                    [pDict setTztObject:nsTZYT.text forKey:@"tztTZYT"];
            }
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:(NSUInteger)pDict lParam:0];
            DelObject(pDict);
            return TRUE;
            
        }
            break;
        case WT_JJINQUIRETrans://基金转换
        case MENU_JY_FUND_Change://基金转换
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
                return TRUE;//标识已经处理过了
            
            TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
            if (pGridData == NULL || [pGridData.text length] < 1)
                return TRUE;
            
            //基金代码
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:pGridData.text forKey:@"tztJJDM"];
            
            //基金公司代码
            if (_nJJGSDM >= 0 && _nJJGSDM < [pAy count])
            {
                TZTGridData *nsJJGSDM = [pAy objectAtIndex:_nJJGSDM];
                if (nsJJGSDM && nsJJGSDM.text)
                    [pDict setTztObject:nsJJGSDM.text forKey:@"tztJJGSDM"];
            }
            
            //基金可用数量
            if (_nJJKYINDEX >= 0 && _nJJKYINDEX < [pAy count])
            {
                TZTGridData *nsJJKY = [pAy objectAtIndex:_nJJKYINDEX];
                if (nsJJKY && nsJJKY.text)
                    [pDict setTztObject:nsJJKY.text forKey:@"tztJJKY"];
            }
            
            //获取当前的股票代码传递过去
            [TZTUIBaseVCMsg OnMsg:WT_JJINQUIRETrans wParam:(NSUInteger)pDict lParam:0];
            DelObject(pDict);
            return TRUE;
        }
            break;
        case WT_JJWWOpen:
        case MENU_JY_FUND_DTReq:
        {
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:0 lParam:0];
            return TRUE;
        }
            break;
        case WT_JJWWModify:
        case MENU_JY_FUND_DTChange:
        {
            //获取选中的信息
            NSArray *pAy = [_pGridView tztGetCurStock];
            if (pAy == NULL || [pAy count] <= 0)
                return TRUE;
            if (_nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
                return TRUE;
            
            TZTGridData* nsCode = [pAy objectAtIndex:_nStockCodeIndex];
            if (nsCode == NULL || [nsCode.text length] < 1)
                return TRUE;
            
            //此处修改，不传递股票结构，因为编辑的时候需要传递当前信息过去,改传递字典
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:nsCode.text forKey:@"tztJJDM"];
            if (_nStockNameIndex >= 0 && _nStockNameIndex < [pAy count])
            {
                TZTGridData* nsName = [pAy objectAtIndex:_nStockNameIndex];
                if (nsName && nsName.text)
                    [pDict setTztObject:nsName.text forKey:@"tztJJMC"];
            }
            
            if (_nJJGSMC >= 0 && _nJJGSMC < [pAy count])
            {
                TZTGridData *nsJJGSMC = [pAy objectAtIndex:_nJJGSMC];
                if (nsJJGSMC && nsJJGSMC.text)
                    [pDict setTztObject:nsJJGSMC.text forKey:@"tztJJGSMC"];
            }
            
            if (_nJJGSDM >= 0 && _nJJGSDM < [pAy count])
            {
                TZTGridData *nsJJGSDM = [pAy objectAtIndex:_nJJGSDM];
                if (nsJJGSDM && nsJJGSDM.text)
                    [pDict setTztObject:nsJJGSDM.text forKey:@"tztJJGSDM"];
            }
            
            if (_nKgzqIndex >= 0 && _nKgzqIndex < [pAy count])
            {
                TZTGridData * nsKgzq = [pAy objectAtIndex:_nKgzqIndex];
                if (nsKgzq && nsKgzq.text)
                    [pDict setTztObject:nsKgzq.text forKey:@"tztKKZQ"];
            }
            
            if (_nKgrqIndex >= 0 && _nKgrqIndex < [pAy count])
            {
                TZTGridData *nsKgrq = [pAy objectAtIndex:_nKgrqIndex];
                if (nsKgrq && nsKgrq.text)
                    [pDict setTztObject:nsKgrq.text forKey:@"tztKKRQ"];
            }
            
            if (_nBeginDateIndex >= 0 && _nBeginDateIndex < [pAy count])
            {
                TZTGridData *nsBeginDate = [pAy objectAtIndex:_nBeginDateIndex];
                if (nsBeginDate && nsBeginDate.text)
                    [pDict setTztObject:nsBeginDate.text forKey:@"tztBeginDate"];
            }
            
            if (_nEndDateIndex >= 0 && _nEndDateIndex < [pAy count])
            {
                TZTGridData *nsEndDate = [pAy objectAtIndex:_nEndDateIndex];
                if (nsEndDate && nsEndDate.text)
                    [pDict setTztObject:nsEndDate.text forKey:@"tztEndDate"];
            }
            
            if (_nTZJEIndex >= 0 && _nTZJEIndex < [pAy count])
            {
                TZTGridData *nsTZJE = [pAy objectAtIndex:_nTZJEIndex];
                if (nsTZJE && nsTZJE.text)
                    [pDict setTztObject:nsTZJE.text forKey:@"tztTZJE"];
            }
            
            if (_nTZYTIndex >= 0 && _nTZYTIndex < [pAy count])
            {
                TZTGridData *nsTZYT = [pAy objectAtIndex:_nTZYTIndex];
                if (nsTZYT && nsTZYT.text)
                    [pDict setTztObject:nsTZYT.text forKey:@"tztTZYT"];
            }
            
            if (_nSendSNIndex >= 0 && _nSendSNIndex < [pAy count])
            {
                TZTGridData *nsSN = [pAy objectAtIndex:_nSendSNIndex];
                if (nsSN && nsSN.text)
                    [pDict setTztObject:nsSN.text forKey:@"tztSendSN"];
            }
            
            if (_nProductType >= 0 && _nProductType < [pAy count])
            {
                TZTGridData *nsPt = [pAy objectAtIndex:_nProductType];
                if (nsPt && nsPt.text)
                    [pDict setTztObject:nsPt.text forKey:@"ProductType"];
            }
            
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:(NSUInteger)pDict lParam:0];
            DelObject(pDict);
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_OK:
        {
            //获取选中的信息
            NSArray *pAy = [_pGridView tztGetCurStock];
            if (pAy == NULL || [pAy count] <= 0)
                return NO;
            if (_nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
                return NO;
            
            TZTGridData* nsCode = [pAy objectAtIndex:_nStockCodeIndex];
            if (nsCode == NULL || [nsCode.text length] < 1)
                return NO;
            
            //此处修改，不传递股票结构，因为编辑的时候需要传递当前信息过去,改传递字典
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:nsCode.text forKey:@"tztJJDM"];
            if (_nStockNameIndex >= 0 && _nStockNameIndex < [pAy count])
            {
                TZTGridData* nsName = [pAy objectAtIndex:_nStockNameIndex];
                if (nsName && nsName.text)
                    [pDict setTztObject:nsName.text forKey:@"tztJJMC"];
            }
            
            
            if (self.nMsgType == MENU_JY_FUND_XJBLEDSearch) // 现金保留额度
            {
                //判断代码和名称索引，避免只返回查无记录也能到设置界面
                if (_nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count] || _nStockNameIndex < 0 || _nStockNameIndex >= [pAy count])
                {
                    DelObject(pDict);
                    return NO;
                }
                
                if (_nExpDateIndex >= 0 && _nExpDateIndex < [pAy count])
                {
                    TZTGridData *nsExpDat = [pAy objectAtIndex:_nExpDateIndex];
                    if (nsExpDat && nsExpDat.text)
                        [pDict setTztObject:nsExpDat.text forKey:@"tztExpDate"];
                }
                
                if (_nJJGSDM >= 0 && _nJJGSDM < [pAy count])
                {
                    TZTGridData *nsJJGSDM = [pAy objectAtIndex:_nJJGSDM];
                    if (nsJJGSDM && nsJJGSDM.text)
                        [pDict setTztObject:nsJJGSDM.text forKey:@"tztJJGSDM"];
                }
                
                //获取当前的股票代码传递过去
                [TZTUIBaseVCMsg OnMsg:MENU_JY_FUND_XJBLEDSetting wParam:(NSUInteger)pDict lParam:0];
            }
            else if (self.nMsgType == MENU_JY_FUND_KHCYZTSearch) // 客户参与状态
            {
                //判断代码和名称索引，避免只返回查无记录也能到设置界面
                if (_nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count] || _nStockNameIndex < 0 || _nStockNameIndex >= [pAy count])
                {
                    [pDict release];
                    return NO;
                }
                
                //获取当前的股票代码传递过去
                [TZTUIBaseVCMsg OnMsg:MENU_JY_FUND_KHCYZTSetting wParam:(NSUInteger)pDict lParam:0];
            }
            [pDict release];
            return TRUE;
        }
            break;
        default:
            break;
    }
    
    return FALSE;
}


- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnDTXH:FALSE];
            }
                break;
            case 0x2222:
            {
                [g_navigationController popViewControllerAnimated:UseAnimated];
                //返回，取消风火轮显示
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                UIViewController* pTop = g_navigationController.topViewController;
                if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
                {
                    g_navigationController.navigationBar.hidden = NO;
                    [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
                }
            }
                break;
                
            case 0x3333:
            {
                if (_nMsgType == WT_HBJJ_WT || _nMsgType == MENU_JY_FUND_HBWithdraw)
                {
                    [self onHBJJWithDraw:TRUE];
                }
                else
                {
                    [self OnWithDraw];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnDTXH:FALSE];
            }
                break;
                
            case 0x3333:
            {
                [self OnWithDraw];
            }
                break;
                
            default:
                break;
        }
    }
}

@end