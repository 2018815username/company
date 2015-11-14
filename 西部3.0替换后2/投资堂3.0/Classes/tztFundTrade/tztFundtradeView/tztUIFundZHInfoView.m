/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        组合说明
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFundZHInfoView.h"

@implementation tztUIFundZHInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}


-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse* pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    int nErrNO = [pParse GetErrorNo];
    NSString* strErrMsg = [pParse GetErrorMessage];
    if ([tztBaseTradeView IsExitError:nErrNO])
    {
        [self OnNeedLoginOut];
        if (strErrMsg)
            tztAfxMessageBox(strErrMsg);
        return 0;
    }
    
    if (nErrNO < 0)
    {
        if (strErrMsg)
            [self showMessageBox:strErrMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        return 0;
    }
    
    if ([pParse IsAction:@"25024"])
    {
        _nGroupCodeIndex = -1;
        _nGroupNameIndex = -1;
        _nGroupStockIndex = -1;
        _nGroupTypeIndex = -1;
        _nInitDateIndex = -1;
        _nLatestIndex = -1;
        _nProductIndex = -1;
        _nRiskWarningIndex = -1;
        _nUpdateDateIndex = -1;
        _nAmountIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"ProductIndex"];
        TZTStringToIndex(strIndex, _nProductIndex);
        
        strIndex = [pParse GetByName:@"GroupCodeIndex"];
        TZTStringToIndex(strIndex, _nGroupCodeIndex);
        
        strIndex = [pParse GetByName:@"GroupNameIndex"];
        TZTStringToIndex(strIndex, _nGroupNameIndex);
        
        strIndex = [pParse GetByName:@"GroupStockIndex"];
        TZTStringToIndex(strIndex, _nGroupStockIndex);
        
        strIndex = [pParse GetByName:@"LatestIndex"];
        TZTStringToIndex(strIndex, _nLatestIndex);
        
        strIndex = [pParse GetByName:@"GroupTypeIndex"];
        TZTStringToIndex(strIndex, _nGroupTypeIndex);
        
        strIndex = [pParse GetByName:@"InitDateIndex"];
        TZTStringToIndex(strIndex, _nInitDateIndex);
        
        strIndex = [pParse GetByName:@"UpdateDateIndex"];
        TZTStringToIndex(strIndex, _nUpdateDateIndex);
        
        strIndex = [pParse GetByName:@"RiskWarningIndex"];
        TZTStringToIndex(strIndex, _nRiskWarningIndex);
        
        strIndex = [pParse GetByName:@"AmountIndex"];
        TZTStringToIndex(strIndex, _nAmountIndex);
        
        NSArray* pGridAy = [pParse GetArrayByName:@"Grid"];
        
        if (_pAyData == NULL)
            _pAyData = NewObject(NSMutableArray);
        [_pAyData removeAllObjects];
        
        if (_nGroupNameIndex < 0)
            return 0;
        NSMutableArray* pAyTitle = NewObject(NSMutableArray);
        for (NSInteger i = 1; i < [pGridAy count]; i++)
        {
            NSArray *pAy = [pGridAy objectAtIndex:i];
            if (pAy == NULL)
                continue;
            NSInteger nCount = [pAy count];
            if (_nGroupNameIndex >= nCount)
                continue;
            
            NSString* strTitle = [pAy objectAtIndex:_nGroupNameIndex];
            if (strTitle == NULL)
                continue;
            
            [pAyTitle addObject:strTitle];
            [_pAyData addObject:pAy];
        }
        
        if (_tztTradeTable)
        {
            if (_nCurrentIndex < 0 || _nCurrentIndex >= [pAyTitle count])
                _nCurrentIndex = 0;
            
            if (_bShowAll)
            {
                [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentIndex withTag_:1000];
            }
            [self SetSelectData:_nCurrentIndex];
            
        }
        DelObject(pAyTitle);
    }
    return 1;
}


//选中列表数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == 1000)
    {
        _nCurrentIndex = index;
        [self SetSelectData:index];
    }
}

-(void)SetSelectData:(NSInteger)nIndex
{
    if (_pAyData == NULL || [_pAyData count] <= nIndex)
        return;
    
    if (_tztTradeTable == NULL)
        return;
    
    NSArray *pAy = [_pAyData objectAtIndex:nIndex];

    if (!_bShowAll)
    {
        if (_nGroupNameIndex < 0 || _nGroupNameIndex >= [pAy count])
            return;
        NSString* strName = [pAy objectAtIndex:_nGroupNameIndex];
        if (strName == NULL)
            strName = @"";
        [_tztTradeTable setEditorText:strName nsPlaceholder_:NULL withTag_:1000];
    }
    //最低金额
    if (_nAmountIndex >= 0 && _nAmountIndex < [pAy count])
    {
        NSString* strAmount = [pAy objectAtIndex:_nAmountIndex];
        if (strAmount == NULL)
            strAmount = @"";
        [_tztTradeTable setLabelText:strAmount withTag_:8000];
    }
    //更新日期
    if (_nUpdateDateIndex >= 0 && _nUpdateDateIndex < [pAy count])
    {
        NSString* strUpdateDate = [pAy objectAtIndex:_nUpdateDateIndex];
        if (strUpdateDate == NULL)
            strUpdateDate = @"";
        [_tztTradeTable setLabelText:strUpdateDate withTag_:2000];
    }
    //成立日期
    if (_nInitDateIndex >= 0 && _nInitDateIndex < [pAy count])
    {
        NSString* strInitDate = [pAy objectAtIndex:_nInitDateIndex];
        if (strInitDate == NULL)
            strInitDate = @"";
        [_tztTradeTable setLabelText:strInitDate withTag_:3000];
    }
    //组合类别
    if (_nGroupTypeIndex >= 0 && _nGroupTypeIndex < [pAy count])
    {
        NSString* nsGroupType = [pAy objectAtIndex:_nGroupTypeIndex];
        if (nsGroupType == NULL)
            nsGroupType = @"";
        [_tztTradeTable setLabelText:nsGroupType withTag_:6000];
    }
    
    [_tztTradeTable setLabelText:[NSString stringWithFormat:@"%ld", (unsigned long)[_pAyData count]] withTag_:7000];
    //组合数量
//    if (<#condition#>) {
//        <#statements#>
//    }
    
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton* pBtn = (tztUIButton*)sender;
    switch ([pBtn.tzttagcode intValue])
    {
        case 4000://组合查询
        {
            NSMutableArray* ayCode = NULL;
            if (_pAyData && _nCurrentIndex >= 0 && _nCurrentIndex < [_pAyData count])
            {
                NSMutableArray *pAy = [_pAyData objectAtIndex:_nCurrentIndex];
                if (pAy && _nGroupStockIndex >= 0 && _nGroupStockIndex < [pAy count])
                    ayCode = [self GetFundCode:[pAy objectAtIndex:_nGroupStockIndex]];
            }
            
            NSString* strName = @"";
            if (_bShowAll)
                strName = [_tztTradeTable getComBoxText:1000];
            else
                strName = [_tztTradeTable GetEidtorText:1000];
            if (strName == NULL)
                strName = @"";
            
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            if (ayCode)
                [pDict setTztObject:ayCode forKey:@"tztStockList"];
            [pDict setTztObject:strName forKey:@"tztGroupName"];
            [TZTUIBaseVCMsg OnMsg:WT_JJZHSGSearch wParam:(NSUInteger)pDict lParam:0];
            DelObject(pDict);
        }
            break;
        case 4001://风险提示
        {
            if (_nCurrentIndex < 0 || _nCurrentIndex >= [_pAyData count])
                return;
            NSArray *pAy = [_pAyData objectAtIndex:_nCurrentIndex];
            if (_nRiskWarningIndex >= 0 && _nRiskWarningIndex < [pAy count])
            {
                NSString* strInfo = [pAy objectAtIndex:_nRiskWarningIndex];
                if (strInfo == NULL || [strInfo length] < 1)
                    strInfo = @"无相关信息";
                [self showMessageBox:strInfo nType_:TZTBoxTypeButtonOK nTag_:0 delegate_:nil withTitle_:@"风险提示"];
                return;
            }
        }
            break;
        case 4002://组合概况
        {
            if (_nCurrentIndex < 0 || _nCurrentIndex >= [_pAyData count])
                return;
            NSArray *pAy = [_pAyData objectAtIndex:_nCurrentIndex];
            if (_nLatestIndex >= 0 && _nLatestIndex < [pAy count])
            {
                NSString* strInfo = [pAy objectAtIndex:_nLatestIndex];
                if (strInfo == NULL || [strInfo length] < 1)
                    strInfo = @"无相关信息";
                [self showMessageBox:strInfo nType_:TZTBoxTypeButtonOK nTag_:0 delegate_:nil withTitle_:@"组合概况"];
                return;
            }
        }
            break;
    }
}
@end
