/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金定投view  另一种界面
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:
 * 整理修改:        //国金委托需要签署合约
 *
 ***************************************************************/
#import "tztFundDTModifyView.h"
#import "tztWebViewController.h"

#define tztJJDM         @"tztJJDM"  //基金代码
#define tztJJGSDM       @"tztJJGSDM" //基金公司代码
#define tztKKRQ      @"tztKKRQ"   //扣款日期索引
#define tztBeginDate    @"tztBeginDate" //开始日期索引
#define tztEndDateIndex @"tztEndDate" //结束日期
#define tztTZJE         @"tztTZJE"      //投资金额索引
#define tztSendSN       @"tztSendSN"    //委托流水号索引
#define tztProductType  @"ProductType"  //品种代码

enum  {
    kTagDTJJ = 900, //查询已定投的基金
    kTagJJGS = 1000, //基金公司
    kTagJJKXDM , //可选代码
	kTagCode ,  //基金代码
    kTagName ,  //基金名称
    kTagJZ,     //基金净值
    kTagType,   //收费方式
    kTagSQRQ,   //申请日期
    kTagQMTJ,   //期满条件
    KTagDTType ,//扣款周期
    KTagZQ ,    //扣款日期
    KTagBegin , //开始日期
    KTagEnd ,   //结束日期
    kTagTZJE,   //投资金额
    
    kTagOK = 10000,
    kTagClear,
};
@interface tztFundDTModifyView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
@end

@implementation tztFundDTModifyView

@synthesize tztTradeTable = _tztTradeTable;
@synthesize ayZq = _ayZq;
@synthesize ayZqData = _ayZqData;
@synthesize nsCompanyCode = _nsCompanyCode;
@synthesize CurStockCode = _CurStockCode;
@synthesize pDefaultDataDict = _pDefaultDataDict;
@synthesize CurJJGSDM = _CurJJGSDM;
@synthesize nsLastMoney = _nsLastMoney;
@synthesize nsSENDSN = _nsSENDSN;
@synthesize nsProductType = _nsProductType;
@synthesize nsWTAccount = _nsWTAccount;

-(id)init
{
    if (self = [super init])
    {
        _bInquire = FALSE;
        _pDefaultDataDict = NewObject(NSMutableDictionary);
        [[tztMoblieStockComm getShareInstance] addObj:self];
        
        //扣款周期
        if (_ayZq == NULL)
            _ayZq = NewObject(NSMutableArray);
        [_ayZq removeAllObjects];
        [_ayZq addObject:@"每月"];
        
        //日期区间
        if (_ayQMTJ == NULL)
            _ayQMTJ = NewObject(NSMutableArray);
        [_ayQMTJ removeAllObjects];
        [_ayQMTJ addObject:@"截止日期"];
        [_ayQMTJ addObject:@"累计金额"];
        [_ayQMTJ addObject:@"成功次数"];
        _jmIndex = 0;
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayZq);
    DelObject(_ayZqData);
    DelObject(_ayQMTJ);
    DelObject(_ayJJDM);
    DelObject(_ayJJGSDM);
    
    DelObject(_pDefaultDataDict);
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
        if (_nMsgType == WT_JJWWModify || _nMsgType == MENU_JY_FUND_DTChange)
        {
#ifdef tzt_NewVersion
            [_tztTradeTable setTableConfig:@"tztUITradeFundDTModify_NewVersion"];
#else
            [_tztTradeTable setTableConfig:@"tztUITradeFundDTModify"];
#endif
        }
        else
        {
#ifdef tzt_NewVersion
            [_tztTradeTable setTableConfig:@"tztUITradeFundDTKHEx_NewVersion"];
#else
            [_tztTradeTable setTableConfig:@"tztUITradeFundDTKHEx"];
#endif
        }
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
    
    if (_nMsgType == WT_JJWWModify || _nMsgType == MENU_JY_FUND_DTChange)
    {
        [_tztTradeTable setEditorEnable:FALSE withTag_:kTagCode];
    }
    else
    {
        [_tztTradeTable setEditorEnable:TRUE withTag_:kTagCode];
    }
}

-(void)SetData:(NSMutableDictionary*)pDict
{
    
}

-(void)SetDefaultData
{
    if (_tztTradeTable == NULL)
        return;
    
    if (_nMsgType == WT_JJWWModify || _nMsgType == MENU_JY_FUND_DTChange)
    {
        if (self.pDefaultDataDict)
        {
            NSString* nsCode = [self.pDefaultDataDict tztObjectForKey:@"tztJJDM"];
            if (nsCode)
                [_tztTradeTable setEditorText:nsCode nsPlaceholder_:nil withTag_:kTagCode];
            //查询
            //[self DealWithStockCode:nsCode];
            
            [_tztTradeTable setLabelText:@"每月" withTag_:KTagDTType];
            [_tztTradeTable setLabelText:@"日期区间" withTag_:kTagQMTJ];
            
            NSString* nsDay = [self.pDefaultDataDict tztObjectForKey:@"tztKKRQ"];
            if (nsDay)
                [_tztTradeTable setLabelText:nsDay withTag_:KTagZQ];
            
            NSString* nsMoney = [self.pDefaultDataDict tztObjectForKey:@"tztTZJE"];
            if (nsMoney)
                [_tztTradeTable setEditorText:nsMoney nsPlaceholder_:nil withTag_:kTagTZJE];
            self.nsLastMoney = [NSString stringWithFormat:@"%@",nsMoney];
            
            NSString* nsBeginDate = [self.pDefaultDataDict tztObjectForKey:@"tztBeginDate"];
            if (nsBeginDate)
                [_tztTradeTable setLabelText:nsBeginDate withTag_:KTagBegin];
            
            NSString* nsEndDate = [self.pDefaultDataDict tztObjectForKey:@"tztEndDate"];
            if (nsEndDate)
                [_tztTradeTable setLabelText:nsEndDate withTag_:KTagEnd];
            
            NSString* nstztSendSN = [self.pDefaultDataDict tztObjectForKey:@"tztSendSN"];
            if (nstztSendSN) 
                self.nsSENDSN = [NSString stringWithFormat:@"%@",nstztSendSN];
            
            NSString* nsProduct = [self.pDefaultDataDict tztObjectForKey:@"ProductType"];
            if (nsProduct)
                self.nsProductType = [NSString stringWithFormat:@"%@",nsProduct];
            
            NSString* nsWTAccount = [self.pDefaultDataDict tztObjectForKey:@"WTAccount"];
            if (nsWTAccount)
                self.nsWTAccount = [NSString stringWithFormat:@"%@",nsWTAccount];
            
        }
        return;
    }
    
    
    //扣款日期  28天
    if (_ayZqData == NULL)
        _ayZqData = NewObject(NSMutableArray);
    [_ayZqData removeAllObjects];
    for (int i = 0; i < 28; i++)
    {
        [_ayZqData addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    
    [_tztTradeTable setComBoxData:_ayZqData ayContent_:_ayZqData AndIndex_:0 withTag_:KTagZQ];//扣款日期
    
    if (_ayZq)
    {
        [_tztTradeTable setComBoxData:_ayZq ayContent_:_ayZq AndIndex_:0 withTag_:KTagDTType];//扣款周期
    }
    
    if (_ayQMTJ)
    {
        [_tztTradeTable setComBoxData:_ayQMTJ ayContent_:_ayQMTJ AndIndex_:0 withTag_:kTagQMTJ];//期满条件
    }
    
	//设置日期
    //获取当天日期
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    [outputFormat setDateFormat:@"yyyyMMdd"];
    
    NSDate *beginDate = [[NSDate date] dateByAddingTimeInterval:(0 * 24 * 60 *60)];
    NSDate *endDate = [[NSDate date] dateByAddingTimeInterval:(1.0 * 365 * 24 * 60 *60)];//结束日期为开始日期往后10年
    
    UIView* pBegin = [_tztTradeTable getViewWithTag:KTagBegin];
    UIView* pEnd = [_tztTradeTable getViewWithTag:KTagEnd];
    
    if (pBegin && [pBegin isKindOfClass:[tztUIDroplistView class]])
    {
        [(tztUIDroplistView*)pBegin setText:[outputFormat stringFromDate:beginDate]];
    }
    
    if (pEnd && [pEnd isKindOfClass:[tztUIDroplistView class]])
    {
        [(tztUIDroplistView*)pEnd setText:[outputFormat stringFromDate:endDate]];
    }
    
    //设置申请日期
    [_tztTradeTable setLabelText:[outputFormat stringFromDate:beginDate] withTag_:kTagSQRQ];
    
    [outputFormat release];
}

-(void) ClearDataWithOutCode
{
    [_tztTradeTable setLabelText:@"" withTag_:kTagName];
    [_tztTradeTable setLabelText:@"" withTag_:kTagJZ];
    [_tztTradeTable setLabelText:@"" withTag_:kTagType];
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagTZJE];
//    [_tztTradeTable setComBoxText:@"" withTag_:kTagJJGS];
//    [_tztTradeTable setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagJJKXDM];
}

//ipad清空修改界面
-(void) ClearModifyView
{
    if (IS_TZTIPAD &&_nMsgType == WT_JJWWModify) 
    {
        [_tztTradeTable setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagDTJJ];
        //[_tztTradeTable setLabelText:@"" withTag_:KTagDTType];
        //[_tztTradeTable setLabelText:@"" withTag_:kTagQMTJ];
        [_tztTradeTable setLabelText:@"" withTag_:KTagZQ];
        [_tztTradeTable setLabelText:@"" withTag_:KTagBegin];
        [_tztTradeTable setLabelText:@"" withTag_:KTagEnd];
        [_tztTradeTable setEditorText:@"" nsPlaceholder_:nil withTag_:kTagTZJE];
        self.nsLastMoney = @"";
        self.nsSENDSN = @"";
        self.nsProductType = @"";
    }
}

//清空界面数据
-(void) ClearData
{
    if (_tztTradeTable == NULL)
        return;
    [self ClearDataWithOutCode];
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagCode];
    [_tztTradeTable setComBoxText:@"" withTag_:kTagJJGS];
    [_tztTradeTable setComBoxText:@"" withTag_:kTagJJKXDM];
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"" withTag_:1010];
    [self ClearModifyView];
    
    self.CurJJGSDM = @"";
    self.CurStockCode = @"";
    _nCurSelect = 0;
}

-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    //基金公司
    if ([droplistview.tzttagcode intValue] == kTagJJGS) 
    {
        [self OnRequestJJGSData];
    }
    
    if ([droplistview.tzttagcode intValue] == kTagJJKXDM) {
        [self OnQueryData];
    }
    
    //查询已定投的基金
    if ([droplistview.tzttagcode intValue] == kTagDTJJ) {
        [self OnQueryJJ];
    }
}

//选中列表数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    
    if ([droplistview.tzttagcode intValue] == kTagJJGS) 
    {
        int nLastSel = _nCurSelect;
        _nCurSelect = index;
        
        if (_nCurSelect == 0)
        {
            self.CurJJGSDM = [NSString stringWithFormat:@"%@",@""];
            //与上次选中的比较,选择相同一项不清空可选代码
            if (_nCurSelect != nLastSel)
            {
                [_tztTradeTable setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTagJJKXDM];
            }
            return;
        }
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            if (strCode)
                self.CurJJGSDM = [NSString stringWithFormat:@"%@",strCode];
//            [_tztTradeTable setEditorText:strCode nsPlaceholder_:nil withTag_:kTagCode];
//            [self DealWithStockCode:strCode];
        }
        
        //与上次选中的比较,选择相同一项不清空可选代码
        if (_nCurSelect != nLastSel)
        {
            [_tztTradeTable setComBoxData:nil ayContent_:nil AndIndex_:-1 withTag_:kTagJJKXDM];
        }
    }
    
    if ([droplistview.tzttagcode intValue] == kTagJJKXDM)
    {
        NSString* strTitle = droplistview.text;
        if (strTitle == NULL || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            [_tztTradeTable setEditorText:strCode nsPlaceholder_:nil withTag_:kTagCode];
            //setEdit已经发送了请求,避免重复调用 modify by xyt 20130909
            //[self DealWithStockCode:strCode];
        }
    }
    
    //选中已定投基金
    if ([droplistview.tzttagcode intValue] == kTagDTJJ)
    {
        [self OnSelectOutCodeAtIndex:index];
//        NSString* strTitle = droplistview.text;
//        if (strTitle == NULL || [strTitle length] < 1)
//            return;
//        [_tztTradeTable setEditorText:strTitle nsPlaceholder_:nil withTag_:kTagCode];
    }
    
    //期满条件
    self.CurStockCode = [_tztTradeTable GetEidtorText:1002];
    //投资金额
    NSString *tzje = [_tztTradeTable GetEidtorText:1012];
    BOOL isNeedRefresh = NO;
    BOOL isAdd = NO;
    if (self.CurStockCode.length>0) {
        isNeedRefresh = YES;
    }
    if (tzje.length>0) {
        isAdd = YES;
    }
    if ([droplistview.tzttagcode integerValue] ==kTagQMTJ) {
        _jmIndex = index;
        if (index==1) {
            [_tztTradeTable SetImageHidenFlag:@"TZTJMtj" bShow_:YES];
              [_tztTradeTable SetImageHidenFlag:@"TZTDTEND" bShow_:NO];
             [_tztTradeTable OnRefreshTableView];
             [_tztTradeTable setLabelText:@"成功金额" withTag_:2210];
             [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入成功金额" withTag_:1010];
        }else if(index ==2){
            [_tztTradeTable SetImageHidenFlag:@"TZTJMtj" bShow_:YES];
             [_tztTradeTable SetImageHidenFlag:@"TZTDTEND" bShow_:NO];
            [_tztTradeTable OnRefreshTableView];
            [_tztTradeTable setEditorText:@"" nsPlaceholder_:@"请输入成功次数" withTag_:1010];
            [_tztTradeTable setLabelText:@"成功次数" withTag_:2210];
        }
        else {
            [_tztTradeTable SetImageHidenFlag:@"TZTDTEND" bShow_:YES];
            [_tztTradeTable SetImageHidenFlag:@"TZTJMtj" bShow_:NO];
            [_tztTradeTable OnRefreshTableView];
        }
    
        if (isNeedRefresh) {
            [_tztTradeTable setEditorText:self.CurStockCode nsPlaceholder_:@"请输入基金代码" withTag_:1002];
            
            [self OnRefresh];
        }
        if (isAdd) {
            [_tztTradeTable setEditorText:tzje nsPlaceholder_:@"请输入投资金额" withTag_:1012];
        }
        ///wryyyyy
        
//
    }
}

//查询基金公司
-(void)OnRequestJJGSData
{
    NSString* strAction = @"154";
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
}

//查询基金
-(void)OnQueryData
{
    NSString* strAction = @"145";
    _bInquire = TRUE;
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
    if (self.CurJJGSDM)
        [pDict setTztObject:self.CurJJGSDM forKey:@"JJDJGSDM"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
}

//查询已定投基金
-(void)OnQueryJJ
{
    NSString* strAction = @"553";
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
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
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagCode:
		{
			if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
                [self ClearData];
			}
            if (inputField.text != NULL && inputField.text.length == 6)
			{
                if (self.CurStockCode && [self.CurStockCode compare:inputField.text] != NSOrderedSame)
                {
                    self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                    [self ClearDataWithOutCode];
                }
			}
            else
            {
                self.CurStockCode = @"";
                [self ClearDataWithOutCode];
            }
            
			
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
			}
		}
			break;
		default:
			break;
    }
}


//请求股票信息
-(void)OnRefresh
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    self.nsCompanyCode = @"";
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"FUNDCODE"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"145" withDictValue:pDict];
    //[[tztMoblieStockComm getShareInstance] onSendDataAction:@"616" withDictValue:pDict];
    
    DelObject(pDict);
}

-(void)OnQueryFund
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"132" withDictValue:pDict];
    
    DelObject(pDict);
}


-(void)OnSend
{
    if (_tztTradeTable == NULL)
        return;
    
    NSString *nsCode = [_tztTradeTable GetEidtorText:kTagCode];
    if (nsCode == NULL || [nsCode length] < 6)
    {
        [self showMessageBox:@"基金代码输入不正确，请重新输入!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    NSString* nsMoney = [_tztTradeTable GetEidtorText:kTagTZJE];
    if (nsMoney == NULL || [nsMoney length] <= 0 || [nsMoney floatValue] < 0.01f)
    {
        [self showMessageBox:@"金额输入不正确，请重新输入!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
        
//    int nZQ = [_tztTradeTable getComBoxSelctedIndex:KTagDTType];//扣款周期
    NSString* nsKKRQ = [_tztTradeTable getComBoxText:KTagZQ];//扣款日期
    if (nsKKRQ == NULL)
        nsKKRQ = @"";
//    NSString* nsBegin = [_tztTradeTable getComBoxText:KTagBegin];
    //wry
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMdd"];//wry 日期改成默认当天
    NSString* nsBegin = [dateFormatter stringFromDate:[NSDate date]];
    if (nsBegin == NULL)
        nsBegin = @"";
    NSString* nsEnd = [_tztTradeTable getComBoxText:KTagEnd];
    if (nsEnd == NULL)
        nsEnd = @"";
    NSString* nsYT = @"";//[_tztTradeTable getComBoxText:kTagLX];
    if (nsYT == NULL)
        nsYT = @"";
    
    if (_nMsgType == WT_JJWWModify || _nMsgType == MENU_JY_FUND_DTChange)
    {
        nsKKRQ = [_tztTradeTable GetLabelText:KTagZQ];
        if (nsKKRQ == NULL)
            nsKKRQ = @"";
        nsBegin = [_tztTradeTable GetLabelText:KTagBegin];
        if (nsBegin == NULL)
            nsBegin = @"";
        nsEnd = [_tztTradeTable GetLabelText:KTagEnd];
        if (nsEnd == NULL)
            nsEnd = @"";
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    [pDict setTztObject:[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsFundAccount forKey:@"FundAccount"];
    [pDict setTztObject:nsCode forKey:@"FundCode"];
    [pDict setTztObject:self.nsCompanyCode forKey:@"JJDJGSDM"];
    [pDict setTztObject:nsKKRQ forKey:@"SendDay"];
    [pDict setTztObject:nsBegin forKey:@"BeginDate"];
    [pDict setTztObject:nsEnd forKey:@"EndDate"];
    [pDict setTztObject:nsMoney forKey:@"Volume"];
//    [pDict setTztObject:nsYT forKey:@"Title"];
    [pDict setTztObject:@"0" forKey:@"ACTIONMODE"];

    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    if (_nMsgType == WT_JJWWModify || _nMsgType == MENU_JY_FUND_DTChange)
    {
        if (self.nsSENDSN)
            [pDict setTztObject:self.nsSENDSN forKey:@"SENDSN"];
        if (self.nsProductType)
            [pDict setTztObject:self.nsProductType forKey:@"ProductType"];
        //[pDict setTztObject:@"011000000116" forKey:@"WTAccount"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"615" withDictValue:pDict];
    }
    else
    {
        
        if (_jmIndex>0) {
             [pDict setTztObject:@"20351231" forKey:@"EndDate"];
        }
        [pDict setTztObject:[NSString stringWithFormat:@"%d",_jmIndex] forKey:@"RationType"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"551" withDictValue:pDict];
    }
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
    
    if ([pParse IsAction:@"154"]) 
    {
        int nJJGSMCIndex = -1;
        int nJJGSDMIndex = -1;
        
        //基金公司代码
        NSString* strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, nJJGSDMIndex);
        
        //基金公司名称
        strIndex = [pParse GetByName:@"JJGSMC"];
        TZTStringToIndex(strIndex, nJJGSMCIndex);
        
        if (nJJGSDMIndex < 0)
            return 0;
        
        if (_ayJJGSDM == NULL)
            _ayJJGSDM = NewObject(NSMutableArray);
        [_ayJJGSDM removeAllObjects];
        
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        if (pGridAy)
        {
            NSMutableArray *pAyTitle = NewObject(NSMutableArray);
            [pAyTitle addObject:@"所有基金公司"];
            NSString* nsName = @"";
            NSString* nsCode = @"";
            for (int i = 1; i < [pGridAy count]; i++)
            {
                NSArray* pAy = [pGridAy objectAtIndex:i];
                if (nJJGSDMIndex >= 0 && nJJGSDMIndex < [pAy count]) 
                    nsCode = [pAy objectAtIndex:nJJGSDMIndex];
                if (nsCode == NULL ||[nsCode length] <= 0)
                    continue;
                [_ayJJGSDM addObject:nsCode];
                
                if (nJJGSMCIndex >= 0 && nJJGSMCIndex <[pAy count])
                    nsName = [pAy objectAtIndex:nJJGSMCIndex];
                if (nsName == NULL)
                    nsName = @"";
                
                NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", nsCode, nsName];
                [pAyTitle addObject:strTitle];
            }
            
            if (_tztTradeTable && [pAyTitle count] > 2)
            {               
                _nCurSelect = 0;
                [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurSelect withTag_:kTagJJGS bDrop_:YES];
                
                if (self.CurJJGSDM)
                    self.CurJJGSDM = [NSString stringWithFormat:@"%@",@""];
            }
            else
            {
                [pAyTitle removeAllObjects];
                _nCurSelect = 0;
                [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurSelect withTag_:kTagJJGS bDrop_:YES];
                
                if (self.CurJJGSDM)
                    self.CurJJGSDM = [NSString stringWithFormat:@"%@",@""];
            }
            DelObject(pAyTitle);
        }
    }
    
    if (_bInquire && [pParse IsAction:@"145"]) 
    {
        _bInquire = FALSE;
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


        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        if (ayGrid)
        {
            NSString* strCode = @"";
            NSString* strName = @"";
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
//                if (JJDMINDEX >= 0 && JJDMINDEX < [ayData count])
//                {
//                    strCode = [ayData objectAtIndex:JJDMINDEX];
//                    if ([strCode compare:self.CurStockCode] != NSOrderedSame)
//                    {
//                        return 0;
//                    }
//                }
                if (JJDMINDEX >= 0 && JJDMINDEX < [ayData count]) 
                    strCode = [ayData objectAtIndex:JJDMINDEX];
                if (strCode == NULL ||[strCode length] <= 0)
                    continue;
                
                if (JJMCINDEX >= 0 && JJMCINDEX < [ayData count])
                    strName = [ayData objectAtIndex:JJMCINDEX];
                if (strName == NULL)
                    strName = @"";
                
                NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
                [pAyTitle addObject:strTitle];
            }
            
            if (_tztTradeTable && [pAyTitle count] > 1)
            {
                [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:0 withTag_:kTagJJKXDM bDrop_:YES];
            }
            DelObject(pAyTitle);
        }
        return 1;
    }
    
    if ([pParse IsAction:@"145"]) 
    {
        //基金状态
        int JJGSDM = -1;//基金公司代码索引
        int JJSTATEINDEX = -1;//基金状态索引
        int JJMCINDEX = -1;//基金名称索引
        int JJSFFSINDEX = -1;
        int PRICEINDEX = -1;
        int JJDMINDEX = -1;//基金代码索引
        int ZDJE =-1;//最低金额
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
        
        NSString* zjje = [pParse GetByName:@"PROPRICEINDEX"];
        TZTStringToIndex(zjje, ZDJE);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
//        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
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
                
//                if (JJSTATEINDEX >= 0 && JJSTATEINDEX < [ayData count])
//                {
//                    NSString* strState = [ayData objectAtIndex:JJSTATEINDEX];
//                    if (_tztTradeTable)
//                        [_tztTradeTable setLabelText:strState withTag_:KTagState];
//                }
                
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
                        [_tztTradeTable setLabelText:strname withTag_:kTagJZ];
                }
                
                if (JJSFFSINDEX >= 0 && JJSFFSINDEX < [ayData count])
                {
                    NSString* strJJSF = [ayData objectAtIndex:ZDJE];
                    if (_tztTradeTable)
                        [_tztTradeTable setLabelText:strJJSF withTag_:kTagType];
                }
                
                if (JJGSDM >= 0 && JJGSDM < [ayData count])
                {
                    NSString* strJJGS = [ayData objectAtIndex:JJGSDM];
                    if (strJJGS == NULL)
                        strJJGS = @"";
                    self.nsCompanyCode = [NSString stringWithFormat:@"%@",strJJGS];
                    //self.nsJJGSCode = [NSString stringWithFormat:@"%@", strJJGS];
                }
            }
        }
    }
    
    if ([pParse IsAction:@"616"])
    {
        NSInteger nFundCodeIndex = -1;
        NSInteger nFundNameIndex = -1;
        NSInteger nFundComNameIndex = -1;
        NSInteger nFundComCodeIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"JJDMIndex"];
        if (strIndex && [strIndex length] > 0)
            nFundCodeIndex = [strIndex intValue];
        
        if (nFundCodeIndex < 0)
            return 0;
        strIndex = [pParse GetByName:@"JJMCIndex"];
        if (strIndex && [strIndex length] > 0)
            nFundNameIndex = [strIndex intValue];
        
        strIndex = [pParse GetByName:@"JJGSDM"];
        if (strIndex && [strIndex length] > 0)
            nFundComCodeIndex = [strIndex intValue];
        
        strIndex = [pParse GetByName:@"JJGSMC"];
        if (strIndex && [strIndex length] > 0)
            nFundComNameIndex = [strIndex intValue];
        
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        NSString* strFundCode = @"";
        NSString* strFundName = @"";
        NSString* strCompanyName = @"";
        for (NSInteger i = 1; i < [pGridAy count]; i++)
        {
            NSArray* pAy = [pGridAy objectAtIndex:i];
            if (pAy == NULL)
                continue;
            NSUInteger nCount = [pAy count];
            if (nCount <= nFundCodeIndex)
                continue;
            strFundCode = [pAy objectAtIndex:nFundCodeIndex];
            
            if (nFundNameIndex >= 0 && nFundNameIndex < nCount)
                strFundName = [pAy objectAtIndex:nFundNameIndex];
            else
                strFundName = @"";
            
            if (nFundComCodeIndex >= 0 && nFundComCodeIndex < nCount)
                self.nsCompanyCode = [NSString stringWithFormat:@"%@",[pAy objectAtIndex:nFundComCodeIndex]];
            else
                self.nsCompanyCode = @"";
            
            if (nFundComNameIndex >= 0 && nFundComNameIndex < nCount)
                strCompanyName = [pAy objectAtIndex:nFundComNameIndex];
            else
                strCompanyName = @"";
        }
        
        if (_tztTradeTable)
        {
            //会导致死循环的
            //            [_tztTradeTable setEditorText:strFundCode nsPlaceholder_:NULL withTag_:kTagCode];
            [_tztTradeTable setLabelText:strFundName withTag_:kTagName];
            [_tztTradeTable setLabelText:strCompanyName withTag_:kTagName+1];
            
            if (self.pDefaultDataDict)
            {
                //获取代码判断是否一致
                NSString* strCode = [self.pDefaultDataDict tztObjectForKey:@"tztJJDM"];
                if (strCode && [strCode compare:strFundCode] == NSOrderedSame)
                {
                    //扣款周期
                    NSString* strKKZQ = [self.pDefaultDataDict tztObjectForKey:@"tztKKZQ"];
                    if (strKKZQ)
                    {
                        UIView* pViewZQ = [_tztTradeTable getComBoxViewWith:KTagDTType];
                        if (pViewZQ && [pViewZQ isKindOfClass:[tztUIDroplistView class]])
                        {
                            if ([strKKZQ intValue] == 3)//每周
                            {
                                [(tztUIDroplistView*)pViewZQ setText:@"每周"];
                            }
                            else
                            {
                                [(tztUIDroplistView*)pViewZQ setText:@"每月"];
                            }
                        }
                    }
                    //扣款日期
                    NSString* strKKRQ = [self.pDefaultDataDict tztObjectForKey:@"tztKKRQ"];
                    if (strKKRQ)
                    {
                        UIView* pViewRQ = [_tztTradeTable getComBoxViewWith:KTagZQ];
                        if (pViewRQ && [pViewRQ isKindOfClass:[tztUIDroplistView class]])
                        {
                            [(tztUIDroplistView*)pViewRQ setText:strKKRQ];
                        }
                    }
                    //开始日期
                    NSString* strBeginDate = [self.pDefaultDataDict tztObjectForKey:@"tztBeginDate"];
                    UIView* pBeginView = [_tztTradeTable getComBoxViewWith:KTagBegin];
                    if (pBeginView && [pBeginView isKindOfClass:[tztUIDroplistView class]])
                    {
                        [((tztUIDroplistView*)pBeginView) setText:strBeginDate];
                    }
                    //结束日期
                    NSString* strEndDate = [self.pDefaultDataDict tztObjectForKey:@"tztEndDate"];
                    UIView* pEndView = [_tztTradeTable getComBoxViewWith:KTagEnd];
                    if (pEndView && [pEndView isKindOfClass:[tztUIDroplistView class]])
                    {
                        [((tztUIDroplistView*)pEndView) setText:strEndDate];
                    }
                    
                    //投资用途
//                    NSString* strTZYT = [self.pDefaultDataDict tztObjectForKey:@"tztTZYT"];
//                    UIView* pTZYTView = [_tztTradeTable getComBoxViewWith:kTagLX];
//                    if (strTZYT && [strTZYT length] > 0 && pTZYTView && [pTZYTView isKindOfClass:[tztUIDroplistView class]])
//                    {
//                        [((tztUIDroplistView*)pTZYTView) setText:strTZYT];
//                    }
                    
                    //投资金额
//                    NSString* strTZJE = [self.pDefaultDataDict tztObjectForKey:@"tztTZJE"];
//                    [_tztTradeTable setEditorText:strTZJE nsPlaceholder_:NULL withTag_:KTagTradesl];
                }
            }
        }
        
        //查询可用资金
        [self OnQueryFund];
    }
    else if([pParse IsAction:@"132"])
    {
        NSArray * pGridAy = [pParse GetArrayByName:@"Grid"];
        if (pGridAy == NULL || [pGridAy count] < 2)//1 是标题
            return 0;
        NSInteger nUsableIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"usableindex"];
        if (strIndex && [strIndex length] > 0)
            nUsableIndex = [strIndex intValue];
        
        if (nUsableIndex < 0)
            return 0;
        
        NSInteger nCurrencyIndex = -1;
        strIndex = [pParse GetByName:@"currencyindex"];
        if (strIndex && [strIndex length] > 0)
            nCurrencyIndex = [strIndex intValue];
        if (nCurrencyIndex < 0)
            return 0;
        for (NSInteger i = 0; i < [pGridAy count]; i++)
        {
            NSArray *pAy = [pGridAy objectAtIndex:i];
            if (pAy == NULL)
                continue;
            NSInteger nCount = [pAy count];
            if (nUsableIndex >= nCount || nCurrencyIndex >= nCount)
                continue;
            NSString* strValue = [pAy objectAtIndex:nCurrencyIndex];
            if ([strValue compare:@"人民币"] == NSOrderedSame)
            {
                NSString* strMoney = [pAy objectAtIndex:nUsableIndex];
                if (strMoney == NULL)
                    strMoney = @"";
                //[_tztTradeTable setLabelText:strMoney withTag_:kTagUseable];
                return 0;
            }
        }
    }
    else if([pParse IsAction:@"553"])//查询已经定投的基金
    {
        NSInteger nFundCodeIndex = -1;//基金代码
//        int nFundName = -1;     //基金名称
        NSInteger nJJGSDM = -1;       //基金公司代码
        NSInteger nKgrqIndex = -1;//扣款日期索引
        NSInteger nBeginDateIndex = -1;//开始日期索引
        NSInteger nEndDateIndex = -1;//结束日期索引
        NSInteger nTZJEIndex = -1;//投资金额索引
        NSInteger nSendSNIndex = -1;//委托流水号索引
        NSInteger nProductType = -1;  //品种代码
        
        NSString* strIndex = [pParse GetByName:@"JJDMINDEX"];
        TZTStringToIndex(strIndex, nFundCodeIndex);
        
        //公司代码
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, nJJGSDM);
        if (nJJGSDM < 0)
        {
            //zxl 20130718 添加了不同券商的索引配置有可能不一样
            strIndex = [pParse GetByName:@"JJGSDMINDEX"];
            TZTStringToIndex(strIndex, nJJGSDM);
        }
//        strIndex = [pParse GetByName:@"JJMCINDEX"];
//        TZTStringToIndex(strIndex, nFundName);
        strIndex = [pParse GetByName:@"SendSNIndex"];
        TZTStringToIndex(strIndex, nSendSNIndex);
//        strIndex = [pParse GetByName:@"SNoIndex"];
//        TZTStringToIndex(strIndex, _nSNoIndex);
        //开始日期
        strIndex = [pParse GetByName:@"BeginDateIndex"];
        TZTStringToIndex(strIndex, nBeginDateIndex);
        //结束日期
        strIndex = [pParse GetByName:@"EndDateIndex"];
        TZTStringToIndex(strIndex, nEndDateIndex);
        //投资金额
        strIndex = [pParse GetByName:@"TZJEIndex"];
        TZTStringToIndex(strIndex, nTZJEIndex);
        //投资用途
//        strIndex = [pParse GetByName:@"TZYTIndex"];
//        TZTStringToIndex(strIndex, _nTZYTIndex);
        //扣款周期
//        strIndex = [pParse GetByName:@"KGZQIndex"];
//        TZTStringToIndex(strIndex, _nKgzqIndex);
        //扣款日期
        strIndex = [pParse GetByName:@"KGRQIndex"];
        TZTStringToIndex(strIndex, nKgrqIndex);
        strIndex = [pParse GetByName:@"PRODUCTTYPEINDEX"];
        TZTStringToIndex(strIndex, nProductType);
        
        NSInteger nMin = MIN(nFundCodeIndex, MIN(nSendSNIndex, MIN(nBeginDateIndex, MIN(nEndDateIndex, MIN(nTZJEIndex, MIN(nKgrqIndex, MIN(nJJGSDM, nProductType)))))));
        
        NSInteger nMax = MAX(nFundCodeIndex, MAX(nSendSNIndex, MAX(nBeginDateIndex, MAX(nEndDateIndex, MAX(nTZJEIndex, MAX(nKgrqIndex, MAX(nJJGSDM, nProductType)))))));
        if (nMin < 0)
            return 0;
        
        //保持已经定投的基金
        if (_ayYDTJJ == NULL)
            _ayYDTJJ = NewObject(NSMutableArray);
        [_ayYDTJJ removeAllObjects];
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (NSInteger i = 1; i < [ayGrid count]; i++)
            {
                NSMutableArray* pAy = [ayGrid objectAtIndex:i];
                if (pAy == NULL || [pAy count] <= 0)
                    continue;
                NSInteger nCount = [pAy count];
                if (nCount < 1 || nMax >= nCount)
                    continue;
                
                NSString* strCode = [pAy objectAtIndex:nFundCodeIndex];
                NSString* strJJGSCode = [pAy objectAtIndex:nJJGSDM];
                NSString* strSendSNIndex = [pAy objectAtIndex:nSendSNIndex];
                NSString* strBeginDateIndex = [pAy objectAtIndex:nBeginDateIndex];
                NSString* strEndDateIndex = [pAy objectAtIndex:nEndDateIndex];
                NSString* strTZJEIndex = [pAy objectAtIndex:nTZJEIndex];
                NSString* strKgrqIndex = [pAy objectAtIndex:nKgrqIndex];
                NSString* strProductType = [pAy objectAtIndex:nProductType];
                if (strCode.length < 1)
                    continue;
                NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
                [pDict setTztObject:strCode forKey:tztJJDM];
                [pDict setTztObject:strJJGSCode forKey:tztJJGSDM];
                [pDict setTztObject:strSendSNIndex forKey:tztSendSN];
                [pDict setTztObject:strBeginDateIndex forKey:tztBeginDate];
                [pDict setTztObject:strEndDateIndex forKey:tztEndDateIndex];
                [pDict setTztObject:strTZJEIndex forKey:tztTZJE];
                [pDict setTztObject:strKgrqIndex forKey:tztKKRQ];
                [pDict setTztObject:strProductType forKey:tztProductType];
                [_ayYDTJJ addObject:pDict];
                [pAyTitle addObject:strCode];                
            }
            
            if (_tztTradeTable && [pAyTitle count] > 0)
            {
                [_tztTradeTable setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTagDTJJ bDrop_:YES];
            }
            
            if ([pAyTitle count] < 1)
            {
                [self showMessageBox:@"查无相关数据!" nType_:TZTBoxTypeNoButton delegate_:nil];
            }
            DelObject(pAyTitle);            
        }
        
    }
    else if([pParse IsAction:@"551"] || [pParse IsAction:@"615"])
    {
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        
        //iphone定投修改界面不清空
        if (IS_TZTIPAD || (_nMsgType != WT_JJWWModify))
            [self ClearData];
        
        return 0;
    }
    
    return 1;
}

-(void)OnSelectOutCodeAtIndex:(int)nSelect
{
    if (nSelect < 0 || nSelect >= [_ayYDTJJ count])
        nSelect = 0;
    
    if ([_ayYDTJJ count] < 1)
        return;
    
    NSMutableDictionary *pDict = [_ayYDTJJ objectAtIndex:nSelect];
    if (pDict == NULL)
        return;
    
    NSString* strCode = [pDict tztObjectForKey:tztJJDM];
    NSString* strJJGSCode = [pDict tztObjectForKey:tztJJGSDM];
    NSString* strSendSNIndex = [pDict tztObjectForKey:tztSendSN];
    NSString* strBeginDateIndex = [pDict tztObjectForKey:tztBeginDate];
    NSString* strEndDateIndex = [pDict tztObjectForKey:tztEndDateIndex];
    NSString* strTZJEIndex = [pDict tztObjectForKey:tztTZJE];
    NSString* strKgrqIndex = [pDict tztObjectForKey:tztKKRQ];
    NSString* strProductType = [pDict tztObjectForKey:tztProductType];
    
    [_tztTradeTable setEditorText:strCode nsPlaceholder_:nil withTag_:kTagCode];
    [_tztTradeTable setLabelText:@"每月" withTag_:KTagDTType];
    [_tztTradeTable setLabelText:@"日期区间" withTag_:kTagQMTJ];
    
    [_tztTradeTable setLabelText:strKgrqIndex withTag_:KTagZQ];
    [_tztTradeTable setEditorText:strTZJEIndex nsPlaceholder_:nil withTag_:kTagTZJE];
    self.nsLastMoney = [NSString stringWithFormat:@"%@",strTZJEIndex];
    [_tztTradeTable setLabelText:strBeginDateIndex withTag_:KTagBegin];
    [_tztTradeTable setLabelText:strEndDateIndex withTag_:KTagEnd];
    
    self.nsSENDSN = [NSString stringWithFormat:@"%@",strSendSNIndex];
    self.nsProductType = [NSString stringWithFormat:@"%@",strProductType];
    
    //刷新数据
    self.CurStockCode = [NSString stringWithFormat:@"%@", strCode];
    //[self OnRefresh];    
}

-(BOOL)CheckInput
{
    if (_tztTradeTable == NULL)
        return FALSE;
    
    NSString *nsCode = [_tztTradeTable GetEidtorText:kTagCode];
    if (nsCode == NULL || [nsCode length] < 6)
    {
        [self showMessageBox:@"基金代码输入不正确，请重新输入!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return FALSE;
    }
    
    NSString* nsMoney = [_tztTradeTable GetEidtorText:kTagTZJE];
    if (nsMoney == NULL || [nsMoney length] <= 0 || [nsMoney floatValue] < 0.01f)
    {
        [self showMessageBox:@"金额输入不正确，请重新输入!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return FALSE;
    }
    
    NSString* strInfo = @"";
    NSString* nsType = @"定投";
    if (_nMsgType == WT_JJWWModify)
    {
        if ([self.nsLastMoney compare:nsMoney] == NSOrderedSame)
        {
            [self showMessageBox:@"投资金额无修改!" nType_:TZTBoxTypeNoButton delegate_:nil];
            return FALSE;
        }
        strInfo = [NSString stringWithFormat:@"基金定投修改\r\n确定将投资金额修改为:%@？",nsMoney];
        nsType = @"修改";
    }
    else
    {
        NSString* nsName = [_tztTradeTable GetLabelText:kTagName];
        NSString* nsZQ = [_tztTradeTable getComBoxText:KTagDTType];//扣款周期
        NSString* nsKKRQ = [_tztTradeTable getComBoxText:KTagZQ];//扣款日期


        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyyMMdd"];//wry 日期改成默认当天
        NSString* nsBegin = [dateFormatter stringFromDate:[NSDate date]];

        //NSString* nsBegin=[_tztTradeTable getComBoxText:KTagBegin];
        NSString* nsEnd = [_tztTradeTable getComBoxText:KTagEnd];
        //    NSString* nsYT = @"";//[_tztTradeTable getComBoxText:kTagLX];
        nsType = @"定投";
        NSString *cuurentTyep = [_tztTradeTable getComBoxText:kTagQMTJ];//期满条件
        NSString* currentContent = [_tztTradeTable GetEidtorText:1010];//成功金额
        NSString *jjjz= [_tztTradeTable  GetLabelText:1004];//基金净值
        NSString *zdje= [_tztTradeTable  GetLabelText:1005];//最低金额
        
        
        if (_jmIndex==0) {
            strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n基金名称:%@\r\n扣款周期:%@\r\n基金净值:%@\r\n最低金额:%@\r\n期满类型:%@\r\n结束日期:%@\r\n定投金额:%@\r\n 确认定投？",nsCode, nsName,nsZQ,jjjz,zdje,cuurentTyep,nsEnd,nsMoney];
        }else if(_jmIndex ==1){
            if (currentContent.length<=0) {
                tztAfxMessageBox(@"请输入成功金额");
                return NO;
            }
            
            strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n基金名称:%@\r\n扣款周期:%@\r\n基金净值:%@\r\n最低金额:%@\r\n期满类型:%@\r\n成功金额:%@\r\n结束日期:%@\r\n定投金额:%@\r\n 确认定投？",nsCode, nsName,nsZQ,jjjz,zdje,cuurentTyep,currentContent,nsEnd,nsMoney];
            
        }else{
            if (currentContent.length<=0) {
tztAfxMessageBox(@"请输入成功次数");
                return NO;
            }
            strInfo = [NSString stringWithFormat:@"基金代码:%@\r\n基金名称:%@\r\n扣款周期:%@\r\n基金净值:%@\r\n最低金额:%@\r\n期满类型:%@\r\n成功次数:%@\r\n结束日期:%@\r\n定投金额:%@\r\n 确认定投？",nsCode, nsName,nsZQ,jjjz,zdje,cuurentTyep,currentContent,nsEnd,nsMoney];
        }
        
        
    }
    
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:@"基金定投"
                   nsOK_:nsType
               nsCancel_:@"取消"];
    return FALSE;
}

//签署定投
-(void)OnRisk
{
    tztWebViewController *pVC = NewObject(tztWebViewController);
    pVC.tztDelegate = self;
    pVC.nHasToolbar = 0;
    NSString* strUrl = [NSString stringWithFormat:@"http://127.0.0.1:%d/%@",[[tztlocalHTTPServer getShareInstance] port],@"/gjzqdtxy/made_agreement.htm?fundcode="];
    strUrl = [NSString stringWithFormat:@"%@%@",strUrl,self.CurStockCode];
    [pVC setWebURL:strUrl];
    if (IS_TZTIPAD)
    {
        TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
        CGRect rcFrom = CGRectZero;
        rcFrom.origin = pBottomVC.view.center;
        rcFrom.size = CGSizeMake(500, 500);
        [pBottomVC PopViewControllerWithoutArrow:pVC rect:rcFrom];
    }
    else
        [g_navigationController pushViewController:pVC animated:UseAnimated];
    [pVC setTitle:@"定投协议"];
    [pVC release];
}

//协议签署成功
-(void)setRiskSign:(NSString*)strParam
{
    //iphone版本，pop下，取消现实的协议界面
    if (!IS_TZTIPAD)
    {
        [g_navigationController popViewControllerAnimated:UseAnimated];
    }
    else
    {
        [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
    }
    NSString* strUrllower = [strParam lowercaseString];
    if (strUrllower && [strUrllower hasPrefix:@"status="]) 
    {
        NSString* strRisk = [strParam substringFromIndex:[@"status=" length]];
        int nParam = [strRisk intValue];
        if (nParam == 1)
        {
            [self OnSend];
        }
    }
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
//                   [self OnRisk]; ruyi
             [self OnSend];
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
                [self OnRisk];//[self OnSend];
            }
                break;
                
            default:
                break;
        }
    }
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
        default:
            break;
    }
    return FALSE;
}

-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
        return;
    UIButton *pButton = (UIButton*)sender;
    NSInteger nTag = pButton.tag;
    
    if ([pButton isKindOfClass:[tztUIButton class]])
    {
        nTag = [((tztUIButton*)pButton).tzttagcode intValue];
    }
    
    switch (nTag)
    {
        case kTagOK:
        {
            [self CheckInput];
        }
            break;
        case kTagClear:
        {
            [self ClearData];
        }
            break;
        default:
            break;
    }
}


@end
