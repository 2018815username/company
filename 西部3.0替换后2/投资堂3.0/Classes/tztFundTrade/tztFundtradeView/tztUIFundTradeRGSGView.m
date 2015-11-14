/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金认购申购赎回
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundTradeRGSGView.h"
#import "TZTUIBaseViewController.h"
#import "TZTAppObj.h"
#define tztJJCode   @"tztJJCode"
#define tztJJName   @"tztJJName"
/*tag值，与配置文件中对应*/
enum  {
	kTagCode = 1000,
    kTagUsable = 1010,//修改可用资金label显示
    kTagName = 2000,//基金名称
    KTagState = 3000,//基金状态
    kTagJJJZ = 4000,//基金净值
    kTagKYJJ = 5000,//可用基金
    kTagKYZJ = 6000,//可用资金
    KTagtradel = 7000,//交易金额label（认购 申购 赎回）
    KTagtradet = 8000,//交易金额textfeild（认购 申购 赎回）
	KTagFXJB  = 9000,//风险级别
	kTagYourDJ = 10000,//您的风险等级
};

@interface tztUIFundTradeRGSGView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
@end

@implementation tztUIFundTradeRGSGView

@synthesize tztTradeTable = _tztTradeTable;
@synthesize CurStockCode = _CurStockCode;
@synthesize nsJJGSCode = _nsJJGSCode;
@synthesize ayFundData = _ayFundData;
@synthesize isFullWidth = _isFullWidth;

-(id)init
{
    _nRiskLevel=-1;
    _nKHFXJB=-1;
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)) 
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        if (_isFullWidth)
            [_tztTradeTable setTableConfig:@"tztUITradeFundRGSGFull"];
        else
            [_tztTradeTable setTableConfig:@"tztUITradeFundRGSG"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
        
        switch (_nMsgType)
        {
            case WT_JJRGFUND:
            case MENU_JY_FUND_RenGou: //基金认购 //新功能号add by xyt 20131018
            {
                [_tztTradeTable setLabelText:@"查可认购基金" withTag_:kTagKYJJ+1];
                [_tztTradeTable setLabelText:@"认购金额" withTag_:KTagtradel];
                [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入认购金额" withTag_:KTagtradet];
                [_tztTradeTable setComBoxPlaceholder:@"查询可以认购基金" withTag_:kTagKYJJ];
            }
                break;
            case MENU_QS_HTSC_ZJLC_RenGou:
            {
                [_tztTradeTable setLabelText:@"查可认购产品" withTag_:kTagKYJJ+1];
                [_tztTradeTable setLabelText:@"认购金额" withTag_:KTagtradel];
                [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入认购金额" withTag_:KTagtradet];
                [_tztTradeTable setComBoxPlaceholder:@"查询可以认购产品" withTag_:kTagKYJJ];
            }
                break;
            case WT_JJAPPLYFUND:
            case MENU_JY_FUND_ShenGou://基金申购
            {
                [_tztTradeTable setLabelText:@"查可申购基金" withTag_:kTagKYJJ+1];
                [_tztTradeTable setLabelText:@"申购金额" withTag_:KTagtradel];
                [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入申购金额" withTag_:KTagtradet];
                [_tztTradeTable setComBoxPlaceholder:@"查询可以申购基金" withTag_:kTagKYJJ];
            }
                break;
            case MENU_QS_HTSC_ZJLC_ShenGou:
            {
                [_tztTradeTable setLabelText:@"查可申购产品" withTag_:kTagKYJJ+1];
                [_tztTradeTable setLabelText:@"申购金额" withTag_:KTagtradel];
                [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入申购金额" withTag_:KTagtradet];
                [_tztTradeTable setComBoxPlaceholder:@"查询可以申购产品" withTag_:kTagKYJJ];
            }
                break;
            case WT_JJREDEEMFUND:
            case MENU_JY_FUND_ShuHui://基金赎回
            {
                [_tztTradeTable SetImageHidenFlag:@"TZTJJJZ" bShow_:NO];
                [_tztTradeTable SetImageHidenFlag:@"TZTJJState" bShow_:NO];
                [_tztTradeTable OnRefreshTableView];
                
                [_tztTradeTable setLabelText:@"查可赎回基金" withTag_:kTagKYJJ+1];
                [_tztTradeTable setLabelText:@"赎回份额" withTag_:KTagtradel];
                [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入赎回份额" withTag_:KTagtradet];
                [_tztTradeTable setComBoxPlaceholder:@"查询可以赎回基金" withTag_:kTagKYJJ];
                //修改基金赎回显示label
                [_tztTradeTable setLabelText:@"可用份额" withTag_:kTagUsable];
            }
                break;
            case MENU_QS_HTSC_ZJLC_ShuHui:
            {
                [_tztTradeTable SetImageHidenFlag:@"TZTJJJZ" bShow_:NO];
                [_tztTradeTable SetImageHidenFlag:@"TZTJJState" bShow_:NO];
                [_tztTradeTable OnRefreshTableView];
                
                [_tztTradeTable setLabelText:@"查可赎回产品" withTag_:kTagKYJJ+1];
                [_tztTradeTable setLabelText:@"赎回份额" withTag_:KTagtradel];
                [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入赎回份额" withTag_:KTagtradet];
                [_tztTradeTable setComBoxPlaceholder:@"查询可以赎回产品" withTag_:kTagKYJJ];
                //修改基金赎回显示label
                [_tztTradeTable setLabelText:@"可用份额" withTag_:kTagUsable];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
    
}

-(void)SetDefaultData
{
    if (_tztTradeTable == NULL)
        return;
    [_tztTradeTable setEditorText:self.CurStockCode nsPlaceholder_:nil withTag_:kTagCode];
    [self DealWithStockCode:self.CurStockCode];
}

-(void)setStockCode:(NSString*)nsCode
{
    if (nsCode == NULL || [nsCode length] < 6)
        return;
    self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
    if (_tztTradeTable)
    {
        [_tztTradeTable setEditorText:nsCode nsPlaceholder_:NULL withTag_:kTagCode];
    }
}

//清空界面数据
-(void) ClearData
{
    if (_tztTradeTable == NULL)
        return;
    
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:nil withTag_:KTagtradet];
    if ([[_tztTradeTable GetEidtorText:kTagCode] length] > 0)
        [_tztTradeTable setEditorText:@"" nsPlaceholder_:nil withTag_:kTagCode];
    self.CurStockCode = @"";
    [_tztTradeTable setComBoxText:nil withTag_:kTagKYJJ];
}

-(void)ClearDataEx
{
    [_tztTradeTable setLabelText:@"" withTag_:kTagName];
    [_tztTradeTable setLabelText:@"" withTag_:KTagState];
    [_tztTradeTable setLabelText:@"" withTag_:kTagJJJZ];
    [_tztTradeTable setLabelText:@"" withTag_:kTagKYJJ];
    [_tztTradeTable setLabelText:@"" withTag_:kTagKYZJ];
    [_tztTradeTable setLabelText:@"" withTag_:KTagFXJB];
    [_tztTradeTable setLabelText:@"" withTag_:kTagYourDJ];
}

-(void)DealWithSysTextField:(TZTUITextField *)inputField
{
    if (inputField.tag == kTagCode)
    {
        self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
        [self OnRefresh];
    }
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView && [tztUIBaseView isKindOfClass:[tztUITextField class]])
    {
        tztUITextField* pField = (tztUITextField*)tztUIBaseView;
        switch ([pField.tzttagcode intValue])
        {
            case kTagCode:
            {
                if (self.CurStockCode == NULL)
                    self.CurStockCode = @"";
                if ([pField.text length] <= 0)
                {
                    self.CurStockCode = @"";
                    [self ClearDataEx];
                }
                
                if (pField.text != NULL && pField.text.length == 6)
                {
                    if (self.CurStockCode && [self.CurStockCode compare:pField.text] != NSOrderedSame)
                    {
                        self.CurStockCode = [NSString stringWithFormat:@"%@", pField.text];
                        [self ClearDataEx];
                    }
                }
                else
                {
                    self.CurStockCode = @"";
                    [self ClearDataEx];
                }
                
                if (self.CurStockCode.length == 6)
                    [self DealWithStockCode:((tztUITextField*)tztUIBaseView).text];
            }
                break;
                
            default:
                break;
        }
    }
}


-(void)inputFieldDidChangeValue:(tztUITextField *)inputField
{
    switch ([inputField.tzttagcode intValue])
	{
		case kTagCode:
		{
            [self DealWithStockCode:inputField.text];
		}
			break;
		default:
			break;
	}
}

-(void)DealWithStockCode:(NSString*)nsStockCode
{
    if (self.CurStockCode == NULL)
        self.CurStockCode = @"";
    if ([nsStockCode length] <= 0)
    {
        self.CurStockCode = @"";
    }
    
    if (nsStockCode != NULL)
    {
        self.CurStockCode = [NSString stringWithFormat:@"%@", nsStockCode];
    }
    
    if ([self.CurStockCode length] == 6)
    {
        [self OnRefresh];
//        [[NumberKeyboard sharedKeyboard] hide];
    }
    //清空
    if ([self.CurStockCode length] <= 0)
    {
        [self ClearData];
    }
}
//zxl 20131022 开始显示数据前处理
- (void)tztDroplistViewBeginShowData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagKYJJ)
    {
        [self ClearData];
    }
}

-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagKYJJ)
        [self OnSendRequest];
}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTagKYJJ)
    {
        _nCurrentSelect = index;
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        [self ClearData];
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            [_tztTradeTable setEditorText:strCode nsPlaceholder_:nil withTag_:kTagCode];
            //setEdit已经发送了请求,避免重复调用 modify by xyt 20130909
            //[self DealWithStockCode:strCode];
        }
    }
}

/*
 查询可认购、可申购、可赎回基金信息
 */
-(void)OnSendRequest
{
    NSString* strAction = @"";
    switch (_nMsgType)
    {
        case WT_JJRGFUND://基金认购
        case MENU_JY_FUND_RenGou: //基金认购 //新功能号add by xyt 20131018
        {
            strAction = @"664";
        }
            break;
        case MENU_QS_HTSC_ZJLC_RenGou:
        {
            strAction = @"353";
        }
            break;
        case WT_JJAPPLYFUND://基金申购
        case MENU_JY_FUND_ShenGou://基金申购
        {
            strAction = @"665";
        }
            break;
        case MENU_QS_HTSC_ZJLC_ShenGou:
        {
            strAction = @"354";
        }
            break;
        case WT_JJREDEEMFUND://基金赎回
        case MENU_QS_HTSC_ZJLC_ShuHui:
        case MENU_JY_FUND_ShuHui://基金赎回
        {
            strAction = @"137";
        }
            break;
        default:
            break;
    }
    
    if (strAction.length < 1)
        return;
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"2000" forKey:@"MaxCount"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
}


//请求股票信息
-(void)OnRefresh
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    if (_nMsgType == MENU_QS_HTSC_ZJLC_ShenGou || _nMsgType == MENU_QS_HTSC_ZJLC_RenGou || _nMsgType == MENU_QS_HTSC_ZJLC_ShuHui)
    {
        if (![g_pSystermConfig IsFundCode:self.CurStockCode])
        {
            [self showMessageBox:@"请输入正确的紫金理财产品代码" nType_:TZTBoxTypeNoButton delegate_:nil];
            return;
        }
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"FUNDCODE"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    if (_nMsgType == WT_JJREDEEMFUND || _nMsgType == MENU_QS_HTSC_ZJLC_ShuHui || _nMsgType == MENU_JY_FUND_ShuHui)
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"666" withDictValue:pDict];
    }
    else
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"145" withDictValue:pDict];
    
    DelObject(pDict);
    

}

//	基金客户风险等级查询
-(void)fundCustomerInqireLevel
{
    //    向服务器发送客户风险评估请求
    if ([g_pSystermConfig.strMainTitle isEqualToString:@"西部信天游"]&& _KHFXJB==NULL)
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqNo++;
        if (_ntztReqNo > UINT16_MAX)
            _ntztReqNo = 1;
        NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqNo forKey:@"Reqno"];
      //  [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountDBPPTLogin] forKey:tztTokenType];
//        if (g_CurUserData.nsDBPLoginToken && [g_CurUserData.nsDBPLoginToken length] > 0)
//            [pDict setTztValue:g_CurUserData.nsDBPLoginToken forKey:@"Token"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"189" withDictValue:pDict];
        DelObject(pDict);
    }

    
}
-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
//    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo]) 
//        return 0;
    
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];
    
    if ([tztBaseTradeView IsExitError:nErrNo])
    {
        [self OnNeedLoginOut];
        if (strError)
            tztAfxMessageBox(strError);
        return 0;
    }
    
    if (nErrNo < 0)
    {
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        return 0;
    }
    if ([pParse IsAction:@"140"] || [pParse IsAction:@"139"] || [pParse IsAction:@"144"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
       
    }
     
    if ([pParse IsAction:@"145"] || [pParse IsAction:@"666"])
    {   
        //基金状态
        int JJGSDM = -1;//基金公司代码索引
        int JJSTATEINDEX = -1;//基金状态索引
        int JJMCINDEX = -1;//基金名称索引
        int JJSFFSINDEX = -1;
        int PRICEINDEX = -1;
        int JJDMINDEX = -1;//基金代码索引
        NSString* JJSTATEINDEXStr = [pParse GetByName:@"JJSTATEINDEX"];
        TZTStringToIndex(JJSTATEINDEXStr, JJSTATEINDEX);
        
        NSString* JJMCINDEXStr = [pParse GetByName:@"JJMCINDEX"];
        TZTStringToIndex(JJMCINDEXStr, JJMCINDEX);
        
        NSString* JJSFFSINDEXStr = [pParse GetByName:@"JJSFFSINDEX"];
        TZTStringToIndex(JJSFFSINDEXStr, JJSFFSINDEX);
        
        NSString* PRICEINDEXStr = [pParse GetByName:@"PRICEINDEX"];
        TZTStringToIndex(PRICEINDEXStr, PRICEINDEX);
        
        NSString* JJDMINDEXStr = [pParse GetByName:@"JJDMINDEX"];
        TZTStringToIndex(JJDMINDEXStr, JJDMINDEX);
        
        NSString* JJGSINDEXStr = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(JJGSINDEXStr, JJGSDM);
        
        if (JJGSDM < 0 &&
            JJSTATEINDEX < 0 &&
            JJMCINDEX < 0 &&
            JJSFFSINDEX < 0 &&
            PRICEINDEX < 0 &&
            JJDMINDEX < 0 &&
            JJGSDM < 0 )
        {
            return 0;
        }
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (JJDMINDEX >= 0 && JJDMINDEX < [ayData count])
                {
                    NSString* strCode = [ayData objectAtIndex:JJDMINDEX];
                    if ([strCode compare:self.CurStockCode] != NSOrderedSame)
                    {
                        return 0;
                    }
                }
                
                if (JJSTATEINDEX >= 0 && JJSTATEINDEX < [ayData count])
                {
                    NSString* strState = [ayData objectAtIndex:JJSTATEINDEX];
                    if (_tztTradeTable)
                        [_tztTradeTable setLabelText:strState withTag_:KTagState];
                }
                
                if (JJMCINDEX >= 0 && JJMCINDEX < [ayData count])
                {
                    NSString* strname = [ayData objectAtIndex:JJMCINDEX];
                    if (_tztTradeTable)
                        [_tztTradeTable setLabelText:strname withTag_:kTagName];
                }
                
                if (PRICEINDEX >= 0 && PRICEINDEX < [ayData count])
                {
                    NSString* strname = [ayData objectAtIndex:PRICEINDEX];
                    if (_tztTradeTable)
                        [_tztTradeTable setLabelText:strname withTag_:kTagJJJZ];
                }
                
                if (JJGSDM >= 0 && JJGSDM < [ayData count])
                {
                    NSString* strJJGS = [ayData objectAtIndex:JJGSDM];
                    self.nsJJGSCode = [NSString stringWithFormat:@"%@", strJJGS];
                }
            }
        }
        
        NSString* strUseable = [pParse GetByName:@"Usable"];
        if (_tztTradeTable)
        {
            [_tztTradeTable setLabelText:strUseable withTag_:kTagKYZJ];
            //获取当前界面输入
            NSString* nsName = [_tztTradeTable GetLabelText:kTagName];
            NSString* nsCode = [_tztTradeTable GetEidtorText:kTagCode];
            if (nsName && nsCode && [nsCode length] == 6)
            {
                NSString* nsDefault = [NSString stringWithFormat:@"%@(%@)", nsCode, nsName];
                [_tztTradeTable setComBoxText:nsDefault withTag_:kTagKYJJ];
            }
        }
        
        if ([pParse IsAction:@"666"])
        {
            strUseable = [pParse GetByName:@"StockNum"];
            if (_tztTradeTable)
            {
                [_tztTradeTable setLabelText:strUseable withTag_:kTagKYZJ];
            }
        }
      
    }
    //    获取基金风险等级
    if ([pParse IsAction:@"145"] &&[g_pSystermConfig.strMainTitle isEqualToString:@"西部信天游"])
    {
        int nRiskLevelIndex = -1;
        NSString* RiskLevelIndexStr = [pParse GetByName:@"RiskLevelIndex"];
        TZTStringToIndex(RiskLevelIndexStr, nRiskLevelIndex);

        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        for (int i = 1; i < [ayGrid count]; i++)
        {
            NSArray *pAy = [ayGrid objectAtIndex:i];
            if (pAy == NULL || [pAy count] <= 0)
            {
                continue;
            }
            
            NSInteger nCount = [pAy count];
            if (nCount < 1 )
            {
                continue;
            }
            //wry 防止闪退 wry 0618
            if (pAy.count <= nRiskLevelIndex) {
                return 1;
            }
            if (nRiskLevelIndex>=0) {
                _RiskLevel = [pAy objectAtIndex:nRiskLevelIndex];    
            }
            
            if (_RiskLevel!=nil) {
          
                _nRiskLevel=[_RiskLevel floatValue];
            }
            else
            {
                    [self showMessageBox:@"无法获取基金风险等级 " nType_:TZTBoxTypeNoButton nTag_:0];

            }
            return 1;
        }
    }
    //    获取客户风险评估
    //  获取客户风险评估  wry 189 之前取的是grid里面的数据 现在直接去对应的字段
    if ([pParse IsAction:@"189"] &&[g_pSystermConfig.strMainTitle isEqualToString:@"西部信天游"])
    {
        int nKHFXJBIndex = -1;
        NSString* KHFXJBIndexStr = [pParse GetByName:@"KHFXJBIndex"];
        TZTStringToIndex(KHFXJBIndexStr, nKHFXJBIndex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid.count < 1 && KHFXJBIndexStr.length>0) {
            _nKHFXJB = [KHFXJBIndexStr integerValue];
        }else{
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *pAy = [ayGrid objectAtIndex:i];
                if (pAy == NULL || [pAy count] <= 0)
                {
                    continue;
                }
                NSInteger nCount = [pAy count];
                if (nCount < 1 )
                {
                    continue;
                }
                _KHFXJB = [pAy objectAtIndex:nKHFXJBIndex];
                if (_KHFXJB!=nil) {
                    _nKHFXJB=[_KHFXJB floatValue];
                }
                else
                {
                    [self showMessageBox:@"无法获取客户风险评估" nType_:TZTBoxTypeNoButton nTag_:0];
                }
                
            }
            
            
        }
    }
    

    if ([pParse IsAction:@"664"] || [pParse IsAction:@"665"] || [pParse IsAction:@"137"]
        || [pParse IsAction:@"353"] || [pParse IsAction:@"354"])
    {
        //代码，名称索引
        int nJJDMIndex = -1;
        int nJJMCIndex = -1;
        int nJJGSIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"JJDMIndex"];
        TZTStringToIndex(strIndex, nJJDMIndex);
        
        strIndex = [pParse GetByName:@"JJMCIndex"];
        TZTStringToIndex(strIndex, nJJMCIndex);
        
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, nJJGSIndex);
        
        if (nJJDMIndex < 0)
            return 0;
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        //zxl 20131021 修改了当无信息返回时显示返回的提示信息
        if ([pGridAy count] == 1)
        {
            if (strError && [strError length] > 0)
                [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
        
        if (_ayFundData == NULL)
            _ayFundData = NewObject(NSMutableArray);
        [_ayFundData removeAllObjects];
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSString* strCode = @"";
        NSString* strName = @"";
        for (int i = 1; i < [pGridAy count]; i++)
        {
            NSMutableArray* pAy = [pGridAy objectAtIndex:i];
            if (pAy == NULL || [pAy count] <= 0)
                continue;
            
            NSInteger nCount = [pAy count];
            if (nCount < 1 || nJJDMIndex >= nCount || nJJMCIndex >= nCount)
                continue;
            
            if(nJJDMIndex >= 0 && nJJDMIndex < [pAy count])
                strCode = [pAy objectAtIndex:nJJDMIndex];
            if (strCode == NULL || [strCode length] <= 0)
                continue;
            
            NSInteger nRet = 1;
            if (nJJGSIndex >= 0 && nJJGSIndex < [pAy count])
            {
                 nRet = [g_pSystermConfig CheckValidRow:pAy
                                            nRowIndex_:i
                                            nComIndex_:nJJDMIndex
                                             nMsgType_:_nMsgType
                                           bCodeCheck_:YES];
            }
            if (nRet < 0)
                break;
            if (nRet == 0)
                continue;
            
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strCode forKey:tztJJCode];
            
            if (nJJMCIndex >= 0 && nJJMCIndex < [pAy count])
                strName = [pAy objectAtIndex:nJJMCIndex];
            if (strName == NULL)
                strName = @"";
            [pDict setTztObject:strName forKey:tztJJName];
            
            [_ayFundData addObject:pDict];
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
            [pAyTitle addObject:strTitle];
            DelObject(pDict);
        }
        
        if (_tztTradeTable && [pAyTitle count] > 0)
        {
            //获取当前界面输入
            NSString* nsName = [_tztTradeTable GetLabelText:kTagName];
            NSString* nsCode = [_tztTradeTable GetEidtorText:kTagCode];
            if (nsName && nsCode && [nsCode length] == 6)
            {
                NSString* nsDefault = [NSString stringWithFormat:@"%@(%@)", nsCode, nsName];
                //zxl 20130927 修改了设置值的时候默认不展开
                [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTagKYJJ bDrop_:YES];
                [_tztTradeTable setComBoxText:nsDefault withTag_:kTagKYJJ];
            }
            else
            {
                if (_nCurrentSelect < 0 || _nCurrentSelect >= [pAyTitle count])
                    _nCurrentSelect = 0;
                //zxl 20130927 修改了设置值的时候默认不展开
                [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTagKYJJ bDrop_:YES];
            }
        }
        
        if ([pAyTitle count] < 1)
        {
            [self showMessageBox:@"查无相关数据!" nType_:TZTBoxTypeNoButton delegate_:nil];
        }
        
        DelObject(pAyTitle);
        return 1;
    }
    return 1;
}

-(BOOL)fundRisk:(float)cRiskLevel ComparCustomerRisk:(float)cKHFXJB
{
  static const float EPSINON = 0.00001; //float 判断值 出自《高质量c++编程指南》 xinlan
    float middleVar4=cKHFXJB-4; //客户风险等级 与激进性比较
    float middleVar3=cKHFXJB-3;
    float middleVar2=cKHFXJB-2;
    float middleVar1=cKHFXJB-1;
    //判断float
    
    if ((middleVar4 >= - EPSINON)&& (middleVar4 <= EPSINON))
    {
        
        return NO;
    }
    else if ((middleVar3 >= - EPSINON)&& (middleVar3 <= EPSINON))
    {
        if (((cRiskLevel-4)>= - EPSINON)&& ((cRiskLevel-4) <= EPSINON))
        {
            return YES;
        }
        else
        {
            return NO;
        }
            
        
    }
    else if((middleVar2 >= - EPSINON)&& (middleVar2 <= EPSINON))
    {
        
        if (((cRiskLevel-5)>= - EPSINON)&& ((cRiskLevel-5) <= EPSINON))
        {
            return NO;
        }
        else if (((cRiskLevel-4)>= - EPSINON)&& ((cRiskLevel-4) <= EPSINON))
        {
            return YES;
        }
       else if (((cRiskLevel-3)>= - EPSINON)&& ((cRiskLevel-3) <= EPSINON))
        {
            return YES;
        }

        else
        {
            return NO;
        }

    }
    else if ((middleVar1 >= - EPSINON)&& (middleVar1 <= EPSINON))
    {
        if (((cRiskLevel-5)>= - EPSINON)&& ((cRiskLevel-5) <= EPSINON))
        {
            return NO;
        }
        else if (((cRiskLevel-0)>= - EPSINON)&& ((cRiskLevel-0) <= EPSINON))
        {
            return NO;
        }
        else if (((cRiskLevel-1)>= - EPSINON)&& ((cRiskLevel-1) <= EPSINON))
        {
            return NO;
        }
        else
        {
            return YES;
        }
        
    }
    else if((cKHFXJB >= - EPSINON)&& (cKHFXJB <= EPSINON))
    {
        if (((cRiskLevel-0)>= - EPSINON)&& ((cRiskLevel-0) <= EPSINON))
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
    
}
-(BOOL)CheckInput
{
    if (_tztTradeTable == NULL)
        return  FALSE;
    
    NSString* nsMoney = [_tztTradeTable GetEidtorText:KTagtradet];
    NSString* nsCode = [_tztTradeTable GetEidtorText:kTagCode];
    NSString* nsName = [_tztTradeTable GetLabelText:kTagName];
    
    if (nsCode == NULL || nsCode.length < 1)
    {
        [self showMessageBox:@"请输入基金代码！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    if (nsMoney == NULL || nsMoney.length < 1)
    {
        [self showMessageBox:@"请输入金额！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    NSString *typestr = nil;
    NSString *strType = @"委托金额";
    
    
    switch (_nMsgType)
    {
        case WT_JJRGFUND:
        case MENU_QS_HTSC_ZJLC_RenGou:
        case MENU_JY_FUND_RenGou: //基金认购 //新功能号add by xyt 20131018
        {
            typestr = @"认购";
            strType = @"认购金额";
        }
            break;
        case WT_JJAPPLYFUND:
        case MENU_QS_HTSC_ZJLC_ShenGou:
        case MENU_JY_FUND_ShenGou://基金申购
        {
            typestr = @"申购";
            strType = @"申购金额";
        }
            break;
        case WT_JJREDEEMFUND:
        case MENU_QS_HTSC_ZJLC_ShuHui:
        case MENU_JY_FUND_ShuHui://基金赎回
        {
            typestr = @"赎回";
            strType = @"赎回份额";
        }
            break;
        default:
            typestr = @"认购";
            break;
    }
#ifdef  kSUPPORT_XBSC
    // 西部证券 客户风险评估与产品的风险等级比较
    if (_nKHFXJB<0 )
    {
        [self showMessageBox:@"客户风险评估无法查到！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
        
    }
    if(_nRiskLevel<0)
    {
        [self showMessageBox:@"基金风险等级无法查到！" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
        
        
    }
    //       判断 基金风险等级与客户风险等级
    if(_nKHFXJB<_nRiskLevel)
    {
        [self showMessageBox:@"风险提示：‘您的风险评估低于您所要购买的产品的风险等级，您确定进行委托并承担因此所带来的风险吗’"
                      nType_:TZTBoxTypeButtonBoth
                       nTag_:0x1111
                   delegate_:self
                  withTitle_:typestr
                       nsOK_:typestr
                   nsCancel_:@"取消"];
        
        return true;
    }
    
#endif
    
    
    if ([nsMoney floatValue] < 0.01)
    {
        NSString *str = [NSString stringWithFormat:@"%@金额输入不正确，请重新输入!", typestr];
        [self showMessageBox:str nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
   
    NSString* strInfo = @"";
    
    
    strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n基金名称:%@\r\n%@:%@\r\n\r\n确认%@该基金？\r\n\r\n",nsCode, nsName, strType, nsMoney, typestr];
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:typestr
                   nsOK_:typestr
               nsCancel_:@"取消"];
    
    return TRUE;
}


//买卖确认
-(void)OnSendBuySell
{
    if (_tztTradeTable == NULL)
        return;
    
    NSString* nsMoney = [_tztTradeTable GetEidtorText:KTagtradet];
    NSString* nsCode = [_tztTradeTable GetEidtorText:kTagCode];
    
    if (nsMoney == NULL || nsCode == NULL)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsMoney forKey:@"Price"];
    [pDict setTztValue:nsMoney forKey:@"Money"];
    [pDict setTztValue:nsCode forKey:@"FUNDCODE"];
    if (self.nsJJGSCode)
        [pDict setTztObject:self.nsJJGSCode forKey:@"JJDJGSDM"];
    switch (_nMsgType)
    {
        case WT_JJRGFUND:
        case MENU_QS_HTSC_ZJLC_RenGou:
        case MENU_JY_FUND_RenGou: //基金认购 //新功能号add by xyt 20131018
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"144" withDictValue:pDict];
        }
            break;
        case WT_JJAPPLYFUND:
        case MENU_QS_HTSC_ZJLC_ShenGou:
        case MENU_JY_FUND_ShenGou://基金申购
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"139" withDictValue:pDict];
        }
            break;
        case WT_JJREDEEMFUND:
        case MENU_QS_HTSC_ZJLC_ShuHui:
        case MENU_JY_FUND_ShuHui://基金赎回
        {
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"140" withDictValue:pDict];
        }
            break;
        default:
            break;
    }
    DelObject(pDict);
}

//工具栏点击事件
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if (_tztTradeTable)
            {
                if ([self CheckInput])
                {
                    return TRUE;
                }
            }
        }
            break;
        case TZTToolbar_Fuction_Clear:
        {
            [self ClearData];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRefresh];
            return TRUE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnSendBuySell];
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
                [self OnSendBuySell];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case 10000:
        {
            if (_tztTradeTable)
            {
                [self CheckInput];
            }
        }
            break;
        case 10001:
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
            
        default:
            break;
    }
}

    
@end


