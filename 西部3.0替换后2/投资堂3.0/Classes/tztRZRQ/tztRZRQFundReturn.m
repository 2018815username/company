/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券直接还款
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "tztRZRQFundReturn.h"

enum
{
    TextTag_FZ = 2000,  //负债总金额
    TextTag_LX,         //负债利息
    TextTag_HK,         //可还款金额
    TextTag_HKJE,       //还款金额
    TextTag_FY,
    
    TextTag_OK  = 10000,
    TextTag_Refresh = 10001,
};

@implementation tztRZRQFundReturn
@synthesize pFundReturn = _pFundReturn;
@synthesize pAyData = _pAyData;
-(id)init
{
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
    
    
    if (IS_TZTIPAD)
    {
        // 不加点击底部btn没反应 byDBQ20130823
        if(!_pTradeToolBar.hidden)
        {
            rcFrame.size.height -= _pTradeToolBar.frame.size.height;
        }
    }
    else
        rcFrame.size.height = rcFrame.size.height;
    
    if (_pFundReturn == nil)
    {
        _pFundReturn = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _pFundReturn.tztDelegate = self;
        [_pFundReturn setTableConfig:@"tztRZRQTradeFundReturn"];
        [self addSubview:_pFundReturn];
        [_pFundReturn release];
    }
    else
    {
        _pFundReturn.frame = rcFrame;
    }
    
    //[self SetDefaultData];
}

-(void)SetDefaultData
{
    
}

//清空界面数据
-(void) ClearData
{
    if (_pFundReturn == NULL)
        return;
    [_pFundReturn setEditorText:@"" nsPlaceholder_:NULL withTag_:TextTag_HKJE];
}

//请求股票信息
-(void)OnRequestData
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"406" withDictValue:pDict];
    
    DelObject(pDict);
}


-(void)OnSend:(BOOL)bFlag
{
    if (_pFundReturn == NULL)
        return;
    
    NSString* strMoney = [_pFundReturn GetEidtorText:TextTag_HKJE];
    
    if (!bFlag)
    {
        NSString* strInfo = @"";
        strInfo = [NSString stringWithFormat:@"还款类型:现金还款\r\n还款金额:%@\r\n是否确认还款？", strMoney];
        [self showMessageBox:strInfo
                      nType_:TZTBoxTypeButtonBoth
                       nTag_:0x1111
                   delegate_:self
                  withTitle_:@"直接还款"
                       nsOK_:@"还款"
                   nsCancel_:@"取消"];
        return;
    }
    
    NSString* strMoenyType = NULL;
    if (self.pAyData && [self.pAyData count] > _nCurrentSelect && _nCurrentSelect >= 0)
    {
        NSArray* pAy = [self.pAyData objectAtIndex:_nCurrentSelect];
        if (pAy && [pAy count] > _nMoneyTypeIndex && _nMoneyTypeIndex >= 0)
        {
            strMoenyType = [pAy objectAtIndex:_nMoneyTypeIndex];
        }
    }
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:strMoney forKey:@"Volume"];
    if (strMoenyType && [strMoenyType length] > 0)
        [pDict setTztObject:strMoenyType forKey:@"MoneyType"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"421" withDictValue:pDict];
    DelObject(pDict);
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
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
    
    if ([pParse IsAction:@"421"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        else
            [self showMessageBox:@"还款成功!" nType_:TZTBoxTypeNoButton delegate_:nil];
        
        //清理界面数据
        [self ClearData];
        //重新请求负债数据
        [self OnRequestData];
        return 1;
    }
    
    if ([pParse IsAction:@"406"])
    {
        _nDBBLIndex = -1;            //维持担保比例索引
        _nFZZJEIndex = -1;;           //负债总金额索引
        _nFZJEIndex = -1;            //负债金额索引
        _nFZLXIndex = -1;            //负债利息索引
        _nZJHKIndex = -1;            //直接还款可用金额索引
        _nRZRQIndex = -1;            //融资融券可用金额索引
        _nFareDebitIndex = -1;       //费用负债(交易费用负债索引)
        _nOtherDebitIndex = -1;      //其他负债索引
        _nCreditBalanceIndex = -1;   //可用保证金索引
        _nFinanceDebitIndex = -1;    //融资负债索引
        _nMoneyTypeIndex = -1;        //币种类型
        _nMoneyNameIndex = -1;       //币种名称
        _nKZCDBIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"DBBLINDEX"];
        TZTStringToIndex(strIndex, _nDBBLIndex);
        
        strIndex = [pParse GetByName:@"FZZJEINDEX"];
        TZTStringToIndex(strIndex, _nFZZJEIndex);
        
        strIndex = [pParse GetByName:@"FZJEINDEX"];
        TZTStringToIndex(strIndex, _nFZJEIndex);
        
        strIndex = [pParse GetByName:@"FZLXINDEX"];
        TZTStringToIndex(strIndex, _nFZLXIndex);
        
        strIndex = [pParse GetByName:@"ZJHKIndex"];
        TZTStringToIndex(strIndex, _nZJHKIndex);
        
        strIndex = [pParse GetByName:@"RZRQINDEX"];
        TZTStringToIndex(strIndex, _nRZRQIndex);
        
        strIndex = [pParse GetByName:@"FareDebitIndex"];
        TZTStringToIndex(strIndex, _nFareDebitIndex);
        
        strIndex = [pParse GetByName:@"OtherDebitIndex"];
        TZTStringToIndex(strIndex, _nOtherDebitIndex);
        
        strIndex = [pParse GetByName:@"CreditBalanceIndex"];
        TZTStringToIndex(strIndex, _nCreditBalanceIndex);
        
        strIndex = [pParse GetByName:@"FinanceDebitIndex"];
        TZTStringToIndex(strIndex, _nFinanceDebitIndex);
        
        strIndex = [pParse GetByName:@"MONEYTYPEINDEX"];
        TZTStringToIndex(strIndex, _nMoneyTypeIndex);
        
        strIndex = [pParse GetByName:@"MONEYNAMEINDEX"];
        TZTStringToIndex(strIndex, _nMoneyNameIndex);
        
        strIndex = [pParse GetByName:@"KZCDBINDEX"];
        TZTStringToIndex(strIndex, _nKZCDBIndex);
        
        if (_pAyData == NULL)
            _pAyData = NewObject(NSMutableArray);
        
        [_pAyData removeAllObjects];
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid != NULL)
        {
            NSMutableArray* pAyName = NewObject(NSMutableArray);
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL)
                    continue;
                
                if (_nMoneyNameIndex >= 0 && _nMoneyNameIndex < [ayData count])
                {
                    NSString* strName = [ayData objectAtIndex:_nMoneyNameIndex];
                    if (strName == NULL)
                        continue;
                    [pAyName addObject:strName];
                }
                
                [self.pAyData addObject:ayData];
            }
            
            if ([pAyName count] < 1)
                [pAyName addObject:@"人民币"];
            
            //                if (_nCurrentSelect < 0 || _nCurrentSelect >= [_pAyData count])
            _nCurrentSelect = 0;
            
            if (_pFundReturn)
            {
                [_pFundReturn setComBoxData:pAyName ayContent_:pAyName AndIndex_:_nCurrentSelect withTag_:1000];
            }
            
            [self setSelectData:_nCurrentSelect];
            DelObject(pAyName);
            
        }
    }
    return 1;
}

-(void)setSelectData:(int)nIndex
{
    if (self.pAyData == NULL || [self.pAyData count] <= nIndex)
        return;
    
    NSArray *ayData = [self.pAyData objectAtIndex:nIndex];
    if (_nFZJEIndex >= 0 && _nFZJEIndex < [ayData count])
    {
        NSString* nsFZZJE = [ayData objectAtIndex:_nFZJEIndex];
        if (nsFZZJE == NULL)
            nsFZZJE = @"";
        [_pFundReturn setEditorText:nsFZZJE nsPlaceholder_:NULL withTag_:TextTag_FZ];
    }
    
    if (_nFZLXIndex >= 0 && _nFZLXIndex < [ayData count])
    {
        NSString* nsFZLX = [ayData objectAtIndex:_nFZLXIndex];
        if (nsFZLX == NULL)
            nsFZLX = @"";
        [_pFundReturn setEditorText:nsFZLX nsPlaceholder_:NULL withTag_:TextTag_LX];
    }
    
    if (_nZJHKIndex >= 0 && _nZJHKIndex < [ayData count])
    {
        NSString* nsZJHK = [ayData objectAtIndex:_nZJHKIndex];
        if (nsZJHK == NULL)
            nsZJHK = @"";
        [_pFundReturn setEditorText:nsZJHK nsPlaceholder_:NULL withTag_:TextTag_HK];
    }
}

-(BOOL)CheckInput
{
    if (_pFundReturn == NULL)
        return FALSE;
    
    NSString* strMoney = [_pFundReturn GetEidtorText:TextTag_HKJE];
    if (strMoney == NULL || [strMoney length] < 1 || [strMoney floatValue] < 0.01f)
    {
        [self showMessageBox:@"还款金额输入不正确!" nType_:TZTBoxTypeNoButton nTag_:0 delegate_:NULL
                  withTitle_:GetTitleByID(_nMsgType)];
        return FALSE;
    }
    return TRUE;
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
            if (_pFundReturn)
            {
                if ([self CheckInput])
                {
                    [self OnSend:FALSE];
                    return TRUE;
                }
            }
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRequestData];
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
                [self OnSend:TRUE];
            }
                break;
                
            default:
                break;
        }
    }
}
//zxl 20131029 确定处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnSend:TRUE];
            }
                break;
                
            default:
                break;
        }
    }
}
-(void)OnButtonClick:(id)sender
{
    tztUIButton *button = (tztUIButton *)sender;
    //添加了按钮发送请求方式
    switch ([button.tzttagcode intValue])
    {
        case 4000:
        case 10000:
        {
            if ([self CheckInput])
            {
                [self OnSend:FALSE];
            }
        }
            break;
        case 6802:
        case 10001:
        {
            [self OnRequestData];
        }
            break;
        case 10002:
        {
            [self ClearData];
        }
            break;
        default:
            break;
    }
}
-(void)OnButton:(id)sender
{
    
}


@end
