//
//  TZTFundSearchCashProd.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-18.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "TZTFundSearchCashProd.h"

@interface TZTFundSearchCashProd (tztPrivate)
//处理索引数据
-(void)DealIndexData:(tztNewMSParse*)pParse;
@end

@implementation TZTFundSearchCashProd
@synthesize pGridView = _pGridView;
@synthesize reqAction = _reqAction;
@synthesize nsEndDate = _nsEndDate;
@synthesize nsBeginDate = _nsBeginDate;

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
        _aytitle = NewObject(NSMutableArray);
        
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    
    
    if (_pGridView == nil)
    {
        _pGridView = [[TZTUIReportGridView alloc] init];
        _pGridView.frame = self.bounds;
        _nMaxCount = _pGridView.rowCount;
        _reqAdd = _pGridView.reqAdd;
        _pGridView.delegate = self;
        [self addSubview:_pGridView];
    }
    else
    {
        _pGridView.frame = self.bounds;
    }
}

-(NSString*)GetReqAction:(NSInteger)nMsgID
{
    switch (nMsgID)
    {
        case WT_JJWWCashProdAccInquire:
            _reqAction = @"554";
            break;
        default:
            break;
    }
    return  _reqAction;
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
    [[tztMoblieStockComm getShareInstance] onSendDataAction:_reqAction withDictValue:pDict];
    DelObject(pDict);
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
    if ([pParse GetAction] == [_reqAction intValue])
    {
        //基础索引，所以放在此处
        NSString* strIndex = [pParse GetByName:@"JJDMINDEX"];
        TZTStringToIndex(strIndex, _nStockCodeIndex);
        
        strIndex = [pParse GetByName:@"JJMCINDEX"];
        TZTStringToIndex(strIndex, _nStockNameIndex);
        
        //可撤标识
        strIndex = [pParse GetByName:@"DrawIndex"];
        TZTStringToIndex(strIndex, _nDrawIndex);
        
        //
        strIndex = [pParse GetByName:@"JJACCOUNTINDEX"];
        TZTStringToIndex(strIndex, _nAccountIndex);
        
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, _nJJGSDM);
        
        strIndex = [pParse GetByName:@"JJGSMC"];
        TZTStringToIndex(strIndex, _nJJGSMC);
        
        strIndex = [pParse GetByName:@"DATEINDEX"];
        TZTStringToIndex(strIndex, _nDateIndex);
        
        strIndex = [pParse GetByName:@"CONTACTINDEX"];
        TZTStringToIndex(strIndex, _nCONTACTINDEX);
        
        strIndex = [pParse GetByName:@"CURRENTSET"];
        TZTStringToIndex(strIndex, _nCURRENTSET);
        
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
                    obj.textColor = [UIColor whiteColor];
                    
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
                
                for ( int k = 0; k < [ayData count]; k++)
                {
                    TZTGridData *GridData = NewObject(TZTGridData);
                    GridData.text = [ayData objectAtIndex:k];
                    GridData.textColor = [UIColor whiteColor];
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
            NSInteger pagecount = _valuecount * 3 / _nMaxCount + ((_valuecount * 3) % _nMaxCount ? 1 : 0);
            _pGridView.nValueCount = _valuecount;
            _pGridView.nPageCount = pagecount;
            NSInteger startpos = _nStartIndex;
            if(startpos == 0)
                startpos = 1;
            _pGridView.nCurPage = startpos / (_nMaxCount / 3) + (startpos % (_nMaxCount/ 3) ? 1 : 0);
            _pGridView.indexStarPos = startpos;
            [_pGridView CreatePageData:ayGridData title:_aytitle type:_reqchange];
            _reqchange = 0;
        }
        [ayGridData release];
        //        [_aytitle release];
    }
    
    return 0;
}


-(void)DealIndexData:(tztNewMSParse*)pParse
{
}

-(void)tztGridView:(TZTUIBaseGridView *)gridView didSelectRowAtIndex:(NSInteger)index clicknum:(NSInteger)num gridData:(NSArray *)gridData
{
    if (num == 2)
    {
        [self OnDetail:_pGridView ayTitle_:_aytitle];
    }
}

//刷新页面
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageRefreshAtPage:(NSInteger)page
{
    [self OnRequestData];
    _reqchange = 0;
    return _nStartIndex;
}


//前翻页
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageBackAtPage:(NSInteger)page
{
    NSInteger reqIndex  = _nStartIndex - _reqAdd;
    if(reqIndex <= 1)
        reqIndex = 0;
        
        _reqchange = reqIndex - _nStartIndex;
        _nStartIndex = reqIndex;
        [self OnRequestData];
    return _nStartIndex;
}

//后翻页
- (NSInteger)tztGridView:(TZTUIBaseGridView *)gridView pageNextAtPage:(NSInteger)page
{
    NSInteger reqIndex  = _nStartIndex + _reqAdd;
    if(reqIndex > _valuecount - _nMaxCount)
        reqIndex = _valuecount - _nMaxCount+1;
        if(reqIndex <= 1)
            reqIndex = 0;
            
            _reqchange = reqIndex - _nStartIndex;
            _nStartIndex = reqIndex;
            [self OnRequestData];
    return _nStartIndex;
}

//工具栏点击
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag)
    {
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
        default:
            break;
    }
    
    return FALSE;
}

@end