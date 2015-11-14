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

#import "tztTradeSearchView.h"

extern tztUserData *g_CurUserData;

@interface tztTradeSearchView (tztPrivate)
//处理索引数据
-(void)DealIndexData:(tztNewMSParse*)pParse;
@end

@implementation tztTradeSearchView
@synthesize pGridView = _pGridView;
@synthesize reqAction = _reqAction;
@synthesize nsEndDate = _nsEndDate;
@synthesize nsBeginDate = _nsBeginDate;
@synthesize ayTitle = _aytitle;

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    self.delegate = nil;
    if(_aytitle)
    {
        [_aytitle removeAllObjects];
        [_aytitle release];
        _aytitle = nil;
    }
    [super dealloc];
}

- (void)initdata
{
    _reqAction = @"";
    _nStartIndex = 0;
    _reqchange = 0;
    _nPageCount = 1;
    _nStockCodeIndex = -1;
    _nStockNameIndex = -1;
    _nAccountIndex = -1;
    _nDrawIndex = -1;
    _nContactIndex = -1;
    _seialnoindex=-1;
    _needreturnbalanceindex=-1;
    _nMarketIndexx = -1;
    self.marketArray = [NSMutableArray array];
    if(_aytitle == NULL)
        _aytitle = NewObject(NSMutableArray);
    [_aytitle removeAllObjects];
}

-(id)init
{
    if (self = [super init])
    {
        [self initdata];
        _reqAdd = 0;
        _nMaxCount = 10;

        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin.x += self.layer.borderWidth;
    rcFrame.origin.y += self.layer.borderWidth;
    rcFrame.size.width -= self.layer.borderWidth * 2;
    rcFrame.size.height -= self.layer.borderWidth * 2;
    
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_pGridView == nil)
    {
        _pGridView = [[TZTUIReportGridView alloc] init];
        if (!g_nJYBackBlackColor)
            _pGridView.nsBackBg = @"1";
        [self addSubview:_pGridView];
        [_pGridView release];
    }
    _pGridView.frame = rcFrame;
    _pGridView.nGridType = 1;
    _pGridView.bGridLines = YES;
    [_pGridView setNeedsDisplay]; // 刷新 byDBQ20130723
    _nMaxCount = _pGridView.rowCount;
    _reqAdd = _pGridView.reqAdd;
    _pGridView.delegate = self;
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
        case WT_QUERYDRWT:
        case MENU_JY_PT_QueryDraw:
            _reqAction = @"113";
            break;
        case WT_QUERYDRCJ:
        case MENU_JY_PT_QueryTradeDay:
            _reqAction = @"114";
            break;
        case MENU_JY_PT_QueryDeal:
            _reqAction = @"5017";
            break;
        case WT_QUERYGP://查询股票
        case MENU_JY_PT_QueryStock:
            _reqAction = @"117";
            break;
        case WT_QUERYGDZL://股东资料
        case MENU_JY_PT_QueryGdzl:
            _reqAction = @"122";
            break;
        case WT_QUERYFUNE://查询资金
        case MENU_JY_PT_QueryFunds:
            _reqAction = @"116";
            break;
        case WT_QUERYJG://查询交割：
        case MENU_JY_PT_QueryJG:
            _reqAction = @"121";
            break;
        case MENU_JY_PT_QueryHisTrade:
            _reqAction = @"5018";
            break;
        case WT_QUERYLS://资金明细
        case MENU_JY_PT_QueryZJMX:
            _reqAction = @"125";
            break;
        case WT_QUERYPH://查询配号
        case MENU_JY_PT_QueryPH:
            _reqAction = @"123";
            break;
        case WT_QUERYLSCJ://历史成交
        case MENU_JY_PT_QueryTransHis://历史成交 新功能号add by xyt 20131128
            _reqAction = @"115";
            break;
        case WT_WITHDRAW://委托撤单
        case MENU_JY_PT_Withdraw:
        {
//            if (g_pSystermConfig.sellAction.length > 0) {
//                _reqAction = g_pSystermConfig.sellAction;
//            }
//            else
//            {
                _reqAction = @"152";
//            }
        }
            break;
        case WT_TRANSHISTORY://转账流水
        case MENU_JY_PT_QueryBankHis://转账流水 //新功能号
            _reqAction = @"127";
            break;
        case Sys_Menu_QueryYXQ://产品有效期查询
            _reqAction = @"10125";
            break;
        case WT_LiShiDZD://查询对账单
            _reqAction = @"463";
            break;
        case WT_ZiChanZZ://资产总值
            _reqAction = @"631";
            break;
        case WT_DZJY_HQCX://大宗交易行情查询
        case MENU_JY_DZJY_HQ:
            _reqAction = @"5001";
            break;
        case MENU_JY_BJHG_HisQuery: //13848  历史委托查询389
            _reqAction = @"389";
            break;
        case WT_ETFInquireHisEntrust://货币基金历史委托查询
        case MENU_JY_FUND_HBQueryHis://货币基金历史委托
        case MENU_JY_FUND_XJBLEDSetting:
            _reqAction = @"652";
            break;
        case WT_DFQUERYNZLS://历史内转查询//zxl 20131128
            _reqAction = @"651";
            break;
        case WT_DFQUERYHISTORYEx://计划查询流水
            _reqAction = @"511";
            break;
        case MENU_JY_PT_QueryStockOut: //12365  证券出借查询
            _reqAction = @"7006";
            break;
        case MENU_JY_PT_QueryNewStockED: // 新股申购额度查询
            _reqAction = @"5013";
            break;
        case MENU_JY_PT_QueryXinGu://
            _reqAction = @"5014";
            break;
        case MENU_JY_PT_QueryWTXinGu://
            _reqAction = @"5016";
            break;
        case MENU_JY_PT_QueryNewStockZQ: //12384  查询新股中签
            _reqAction = @"349";
            break;
        case MENU_JY_FUND_PHQueryHisWT:
            _reqAction = @"636";
            break;
        default:
            break;
    }
    
    
//    TZTNSLog(@"=============================================");
//    TZTNSLog(@"nMsgType                 :%ld", (long)_nMsgType);
//    TZTNSLog(@"GetActionByIDWithFuction :%@", strAction);
//    TZTNSLog(@"GetActionByMsgType       :%@", _reqAction);
//    TZTNSLog(@"=============================================");
    return  _reqAction;
}

- (void)setNMsgType:(NSInteger)nMsgType
{
    if(_nMsgType != nMsgType)
    {
        [self initdata];
    }
    _nMsgType = nMsgType;
}

-(void)OnRequestData
{
    [self GetReqAction:_nMsgType];
    if (_reqAction == NULL || [_reqAction length] < 1)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    if (IsNeedFilterQuest(_nMsgType))   //  对于需要过滤的请求，直接请求全部数据
        [pDict setTztValue:@"1000" forKey:@"MaxCount"];
    else
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
    
    [self AddSearchInfo:pDict];
    
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountPTType] forKey:tztTokenType];
    if (_nRZRQHZStock == 1)
    {
        if (g_CurUserData.nsDBPLoginToken && [g_CurUserData.nsDBPLoginToken length] > 0)
            [pDict setTztValue:g_CurUserData.nsDBPLoginToken forKey:@"Token"];
    }
    [[tztMoblieStockComm getShareInstance] onSendDataAction:_reqAction withDictValue:pDict];
    DelObject(pDict);
}

//各个不同的请求增加个字特定的请求数据字段
-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
    switch (self.nMsgType)
    {
        case WT_WITHDRAW://委托撤单Direction 发 0
        case MENU_JY_PT_Withdraw:
            [pDict setTztValue:@"0" forKey:@"Direction"];
            break;
        case MENU_SYS_UserWarningList:
        {
            NSString* strUniqueId = [tztKeyChain load:tztUniqueID];
            if (strUniqueId)
            {
                [pDict setTztObject:strUniqueId forKey:@"Mobile_tel"];
                [pDict setTztObject:strUniqueId forKey:@"MobileCode"];
            }
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
        NSString* strErrMsg = [pParse GetErrorMessage];
        [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        if ([tztBaseTradeView IsExitError:[pParse GetErrorNo]])
        {
            [self OnNeedLoginOut];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"111"]
        || [pParse IsAction:@"120"]//撤单成功后提示，并刷新界面数据
        || [pParse IsAction:@"537"]//预约取款取消537，天天盈撤单
        || [pParse IsAction:@"343"]//多存管归集
        || [pParse IsAction:@"198"]//三板撤单
        || [pParse IsAction:@"401"]//zxl 20130719 添加融资融券撤单成功返回信息显示
        || [pParse IsAction:@"431"]
        || [pParse IsAction:@"383"]
        || [pParse IsAction:@"384"]
        || [pParse IsAction:@"385"]
        || [pParse IsAction:@"640"]
        || [pParse IsAction:@"386"]//不在续作终止
        || [pParse IsAction:@"7017"]//申请展期
        || [pParse IsAction:@"20270"]//删除预警
        )
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        
        if (strErrMsg)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        
        [self OnRequestData];
        return 0;
    }
    
    if ([pParse IsAction:@"376"])//代理委托查询权限请求返回特殊处理
    {
        [self DealOtherRequest:pParse];
        return 0;
    }
    
    if ([pParse IsAction:@"377"])//代理委托取消请求返回处理
    {
        NSString* strErrMsg = [pParse GetErrorMessage];
        
        if (strErrMsg)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton nTag_:0];
        
        [self SendOtherRequest];
        return 0;
    }
    if (IS_TZTIPAD && [pParse IsAction:@"387"])
    {
        [self SendOtherRequest];
    }
    
    if ([pParse GetAction] == [_reqAction intValue])
    {
        if ([pParse IsAction:@"199"])
        {
            NSString* strErrMsg = [pParse GetErrorMessage];
            if (strErrMsg)
                [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        }
        //基础索引，所以放在此处
        NSString* strIndex = [pParse GetByName:@"StockIndex"];
        TZTStringToIndex(strIndex, _nStockCodeIndex);
        
        if (_nStockCodeIndex < 0)
        {
            strIndex = [pParse GetByName:@"StockCodeIndex"];
            TZTStringToIndex(strIndex, _nStockCodeIndex);
        }
    
        strIndex = [pParse GetByName:@"StockNameIndex"];
        TZTStringToIndex(strIndex, _nStockNameIndex);
        
        strIndex = [pParse GetByName:@"MARKETINDEX"];
        TZTStringToIndex(strIndex, _nMarketIndexx);
        
        //可撤标识
        strIndex = [pParse GetByName:@"DrawIndex"];
        TZTStringToIndex(strIndex, _nDrawIndex);
        
        //
        strIndex = [pParse GetByName:@"AccountIndex"];
        TZTStringToIndex(strIndex, _nAccountIndex);
        
        //盈亏
        strIndex = [pParse GetByName:@"YKIndex"];
        TZTStringToIndex(strIndex, _nYKIndex);
        
        // 合同号
        strIndex = [pParse GetByName:@"ContactIndex"];
        TZTStringToIndex(strIndex, _nContactIndex);
        //合约编号
        strIndex = [pParse GetByName:@"SERIALNOINDEX"];
        TZTStringToIndex(strIndex, _seialnoindex);
        //需还款数量（需还款金额）
        strIndex = [pParse GetByName:@"NEEDRETURNBALANCEINDEX"];
        TZTStringToIndex(strIndex, _needreturnbalanceindex);
        // 到货日期
        strIndex = [pParse GetByName:@"BACKDATEINDEX"];
        TZTStringToIndex(strIndex, _backdateindex);
        //负债金额（费用负债）
        strIndex = [pParse GetByName:@"DEBITBALANCEINDEX"];
        TZTStringToIndex(strIndex, _debitbalanceindex);
        //预计利息
        strIndex = [pParse GetByName:@"DEBITINTERESTINDEX"];
        TZTStringToIndex(strIndex, _debitinterestindex);
        //负债类型
        strIndex = [pParse GetByName:@"DEBITTYPEINDEX"];
        TZTStringToIndex(strIndex, _debittypeindex);


        
        //处理特殊索引，到各自的view中单独处理
        [self DealIndexData:pParse];
        
        NSMutableArray *ayGridData = NewObject(NSMutableArray);
        if(_nStartIndex == 0)
            [_aytitle removeAllObjects];
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        
        for (int i = 0; i < [ayGrid count]; i++)
        {
            //第0行标题
            if (i == 0 && _nStartIndex == 0)
            {
                NSArray* ayValue = [ayGrid objectAtIndex:i];
                for (int j = 0; j < [ayValue count]; j++)
                {
                    TZTGridDataTitle *obj = NewObject(TZTGridDataTitle);
                    NSString* str = [ayValue objectAtIndex:j];
                    obj.text = str;
                    if (g_nJYBackBlackColor)
                    {
                        obj.textColor = [UIColor lightTextColor];
                    }
                    else
                    {
                        obj.textColor = [UIColor blackColor];
                    }
                    
                    [_aytitle addObject:obj];
                    [obj release];
                }
            }
            else
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                NSMutableArray *ayGridValue = NewObject(NSMutableArray);
                UIColor *pColor = [UIColor tztThemeHQBalanceColor];
                if (_nMsgType == WT_WITHDRAW || _nMsgType == MENU_JY_PT_Withdraw)//委托撤单
                {
                    if (ayData && _nDrawIndex > 0 && [ayData count] > _nDrawIndex ) 
                    {
                        NSString* nsValue = [ayData objectAtIndex:_nDrawIndex];
                        if (nsValue == NULL || [nsValue length] <= 0)
                            continue;
                    }
                }
                else if(_nMsgType == WT_QUERYGP || _nMsgType == MENU_JY_PT_QueryStock
                        || _nMsgType == MENU_JY_RZRQ_QueryStock || _nMsgType == WT_RZRQQUERYGP)
                {
                    if (ayData && _nYKIndex > 0 && [ayData count] > _nYKIndex) 
                    {
                        NSString* nsYK = [ayData objectAtIndex:_nYKIndex];
                        if ([nsYK hasPrefix:@"-"]) 
                        {
                            if (g_pSystermConfig.defDownColor.length>0) {
                                pColor = [UIColor colorWithTztRGBStr:g_pSystermConfig.defDownColor];
                            }
                            else
                            {
                                pColor = [UIColor tztThemeHQDownColor];
                            }
                        }
                        else
                            pColor = [UIColor tztThemeHQUpColor];
                    }
                }
                
                [self.marketArray removeAllObjects];
                for ( int k = 0; k < [ayData count]; k++)
                {
                    TZTGridData *GridData = NewObject(TZTGridData);
                    if (k == _nDrawIndex)
                    {
                        NSString* strWithDraw = [ayData objectAtIndex:k];
                        if (_nMarketIndexx>=0) {
                            NSString* market = [ayData objectAtIndex:_nMarketIndexx];
                            [self.marketArray addObject:market];
                        }
                        int nCanWithDraw = [strWithDraw intValue];
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
                        //ruyi >0 可测单
                        if(nCanWithDraw)
                            GridData.text = tztCanWithDraw;
                        else
                            GridData.text = tztCannotWithDraw;
                    }
                    else
                        GridData.text = [ayData objectAtIndex:k];
                    
                    if ((_nMsgType == WT_QUERYGP || _nMsgType == MENU_JY_PT_QueryStock || _nMsgType == MENU_JY_RZRQ_QueryStock || _nMsgType == WT_RZRQQUERYGP) && k > 0/* && k == _nYKIndex*/)
                    {
                        GridData.textColor = pColor;//[UIColor whiteColor];   
                    }
                    else
                    {
                        if (g_nJYBackBlackColor)
                        {
                            GridData.textColor = [UIColor whiteColor];   
                        }
                        else
                        {
                            GridData.textColor = [UIColor blackColor];
                        }
                        
                        if (_nMsgType == MENU_SYS_UserWarningList)
                        {
                            GridData.textColor = [UIColor colorWithTztRGBStr:@"48,48,48"];
                        }
                    }
                    [ayGridValue addObject:GridData];
                    DelObject(GridData);
                }
                [ayGridData addObject:ayGridValue];
                DelObject(ayGridValue);
            }
        }
        
        if(_pGridView)
        {
            NSString* strMaxCount = [pParse GetByName:@"MaxCount"];
            _valuecount = [strMaxCount intValue];
            NSInteger pagecount = 1;
            if (_nMaxCount != 0)
                pagecount = _valuecount * 3 / _nMaxCount + ((_valuecount * 3) % _nMaxCount ? 1 : 0);
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
            if (_nMaxCount != 0) // Avoid potential leak.  byDBQ20131031
            {
                _pGridView.nCurPage = startpos / (_nMaxCount / 3) + (startpos % (_nMaxCount/ 3) ? 1 : 0);
            }
            _pGridView.indexStarPos = startpos;
            [_pGridView CreatePageData:ayGridData title:_aytitle type:_reqchange];
            _reqchange = 0;
            
            if (g_pSystermConfig.bSelectFirstRow)
            {
                //选中第一行数据
                [_pGridView setSelectRow:0];
            }
        }
        [ayGridData release];
//        [_aytitle release];
    }
    
    
    
    return 0;
}

-(void)DealIndexData:(tztNewMSParse*)pParse
{
}

/*函数功能：子类实现请求的特殊处理
 入参：请求返回数据
 出参：无
 */
-(void)DealOtherRequest:(tztNewMSParse*)pParse
{
    
}
/*函数功能：子类实现当查询请求返回时需要另发送一个请求
 入参：无
 出参：无
 */
-(void)SendOtherRequest
{
    
}
-(void)tztGridView:(TZTUIBaseGridView *)gridView didSelectRowAtIndex:(NSInteger)index clicknum:(NSInteger)num gridData:(NSArray *)gridData
{
    if (num == 1 /*|| IS_TZTIPAD*/)
    {
        if (self.bDetailNew)
        {
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:[NSString stringWithFormat:@"%d", (int)_nStockCodeIndex] forKey:@"StockCodeIndex"];
            [pDict setTztObject:[NSString stringWithFormat:@"%d", (int)_nStockNameIndex] forKey:@"StockNameIndex"];
            [self OnDetail:_pGridView ayTitle_:_aytitle dictIndex_:pDict];
            DelObject(pDict);
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(DealSelectRow:StockCodeIndex:)])
            {
                [_delegate DealSelectRow:gridData StockCodeIndex:_nStockCodeIndex];
            }
        }
    }
    else if (num == 2/*&&!IS_TZTIPAD*/)
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        [pDict setTztObject:[NSString stringWithFormat:@"%d", (int)_nStockCodeIndex] forKey:@"StockCodeIndex"];
        [pDict setTztObject:[NSString stringWithFormat:@"%d", (int)_nStockNameIndex] forKey:@"StockNameIndex"];
        [self OnDetail:_pGridView ayTitle_:_aytitle dictIndex_:pDict];
        DelObject(pDict);
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
    if(_reqchange != 0)
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
        _reqchange = (reqIndex <= 1 ? 1 : reqIndex) - (_nStartIndex <= 1 ? 1 : _nStartIndex);
        _nStartIndex = reqIndex;
    }
    if(_reqchange != 0)
        [self OnRequestData];
    return _nStartIndex;
}

-(void)OnSendGuiJi
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:@"0" forKey:@"MONEYTYPE"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"343" withDictValue:pDict];
    DelObject(pDict);
}

//工具栏点击
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
  
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_BankGuiJi: //资金归集
        {
            [self OnSendGuiJi];
            return TRUE;
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
        case HQ_MENU_Trend://分时 行情
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
            if (_nStockNameIndex >= 0 && _nStockNameIndex < [pAy count])
            {
                pGridData = [pAy objectAtIndex:_nStockNameIndex];
                if (pGridData && pGridData.text)
                {
                    pStock.stockName = [NSString stringWithFormat:@"%@", pGridData.text];
                }
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:_pGridView forKey:@"View"];
            [dic setObject:[NSString stringWithFormat:@"%d", (int)_nStockCodeIndex] forKey:@"CodeIndex"];
            [dic setObject:[NSString stringWithFormat:@"%d", (int)_nStockNameIndex] forKey:@"NameIndex"];
            //获取当前的股票代码传递过去
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)dic];
            [pStock release];
            return TRUE;
        }
            break;
        case WT_SALE://卖出
        case MENU_JY_PT_Sell: //委托卖出
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
            [TZTUIBaseVCMsg OnMsg:WT_SALE wParam:(NSUInteger)pStock lParam:0];
            [pStock release];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_WithDraw://撤单
        {
            
        }
            break;
        case TZTToolbar_Fuction_Pre://上页
        {
            if (IS_TZTIPAD)
                [self tztGridView:NULL pageBackAtPage:0];
            else
                [self OnGridPreStock:self.pGridView ayTitle_:self.ayTitle];
        }
            break;
        case TZTToolbar_Fuction_Next://下页
        {
            if (IS_TZTIPAD)
                [self tztGridView:NULL pageNextAtPage:0];
            else
                [self OnGridNextStock:self.pGridView ayTitle_:self.ayTitle];
        }
            break;
        case MENU_JY_RZRQ_ZRT_YYSQ: //转融券预约申请
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
            [TZTUIBaseVCMsg OnMsg:MENU_JY_RZRQ_ZRT_YYSQ wParam:(NSUInteger)strCode lParam:0];
            return TRUE;
        }
            break;
        case 3333: // 申请展期
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nContactIndex < 0 || _nContactIndex >= [pAy count])
                return TRUE;//标识已经处理过了
            
            NSString* str = @"";
            TZTGridData *pGridData = [pAy objectAtIndex:_nContactIndex];
            if (pGridData)
            {
                str = pGridData.text;
            }
            [self onRequestZQ: str];
            return TRUE;
        }
            break;
        case MENU_JY_SB_QRBuy:
        case MENU_JY_SB_QRSell: // 成交确认卖出
        {
            NSArray* pAy = [_pGridView tztGetCurrent];
            if (pAy == NULL || [pAy count] <= 0 || _nStockCodeIndex < 0 || _nStockCodeIndex >= [pAy count])
                return TRUE;//标识已经处理过了
            
            NSString* strCode = @"";
             tztStockInfo *pStock = NewObject(tztStockInfo);
            //获取当前的股票代码传递过去
            TZTGridData *pGridData = [pAy objectAtIndex:_nStockCodeIndex];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
           
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            
            //获取当前的交易单元（对手席位）传递过去
            pGridData = [pAy objectAtIndex:2];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
           
            pStock.tradeUnit = [NSString stringWithFormat:@"%@", strCode];
            //获取当前的约定序号（成交约定号）传递过去
            pGridData = [pAy objectAtIndex:6];
            if (pGridData)
            {
                strCode = pGridData.text;
            }
           
            pStock.appointmentSerial = [NSString stringWithFormat:@"%@", strCode];

            
            [TZTUIBaseVCMsg OnMsg:pBtn.tag wParam:(NSUInteger)pStock lParam:0];
            return TRUE;
        }
            break;
     
        default:
            break;
    }
    
    return FALSE;
}

- (void)onRequestZQ:(NSString *)str
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReq forKey:@"Reqno"];
     [pDict setTztValue:str forKey:@"ContactID"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"7017" withDictValue:pDict];
    DelObject(pDict);
}

@end
