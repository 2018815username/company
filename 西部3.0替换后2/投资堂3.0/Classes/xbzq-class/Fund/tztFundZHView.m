/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金转换view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztFundZHView.h"

enum  {
    
    kTagAmount      = 1000,
    
    kTagOutName     = 2000,
    kTagOutPrice    = 2001,
    kTagOutCanUse   = 2002,
    
    kTagInName      = 2003,
    kTagInPrice     = 2004,
    
    kTagOutCode     = 3000,
    kTagInCode      = 3001,
    
    kTagOK          = 5000,
    kTagClear       = 5001,
    kTagRefresh     = 5002,
};

#define tztFund_Code    @"tztFund_Code" //代码
#define tztFund_KY      @"tztFund_KY"   //可用
#define tztFund_Name    @"tztFund_Name" //名称
#define tztFund_Price   @"tztFund_Price" //净值
#define tztFund_GSDM    @"tztFund_GSDM" //公司代码

@interface tztFundZHView(tztPrivate)
//请求股票信息
-(void)OnRefresh;
@end

@implementation tztFundZHView

@synthesize tztTradeTable = _tztTradeTable;
@synthesize ayZHCode = _ayZHCode;
@synthesize ayZHCompany = _ayZHCompany;
@synthesize ayZRCode =_ayZRCode;
@synthesize nsCurStock =_nsCurStock;
@synthesize ayAllZRCode = _ayAllZRCode;

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _ayZHCode = NewObject(NSMutableArray);
        _ayZRCode =  NewObject(NSMutableArray);
        _ayAllZRCode = NewObject(NSMutableArray);
        _ayZHCompany = NewObject(NSMutableDictionary);
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayZHCode);
    DelObject(_ayZRCode);
    DelObject(_ayAllZRCode);
    DelObject(_ayZHCompany);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if (!IS_TZTIPAD)
        rcFrame.size.height = rcFrame.size.height;
    
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        [_tztTradeTable setTableConfig:@"tztUITradeFundZH"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
}

-(void)OnQueryData
{   
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:@"100" forKey:@"MaxCount"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReq = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReq forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"137" withDictValue:pDict];
    DelObject(pDict);
}

//清空界面数据
-(void) ClearData
{
    [_tztTradeTable setLabelText:@"" withTag_:kTagOutName];
    [_tztTradeTable setLabelText:@"" withTag_:kTagOutPrice];
    [_tztTradeTable setLabelText:@"" withTag_:kTagOutCanUse];
    [_tztTradeTable setLabelText:@"" withTag_:kTagInName];
    [_tztTradeTable setLabelText:@"" withTag_:kTagInPrice];
    
    [_tztTradeTable setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagOutCode];
    [_tztTradeTable setComBoxText:@"" withTag_:kTagOutCode];
    [_tztTradeTable setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:kTagInCode];
    [_tztTradeTable setComBoxText:@"" withTag_:kTagInCode];
    
    [_tztTradeTable setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagAmount];
}

//请求股票信息
-(void)OnRefresh
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.nsCurStock forKey:@"FUNDCODE"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"200" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"137" withDictValue:pDict];
    DelObject(pDict);
}

//根据公司代码得到相应基金名称代码
-(void)OnInquireCodeIN:(NSString*)nsGSDM
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    
    if (nsGSDM)
        [pDict setTztValue:nsGSDM forKey:@"JJDJGSDM"];
    
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"200" forKey:@"MaxCount"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"145" withDictValue:pDict];
    DelObject(pDict);
}


-(void)OnSend:(BOOL)bSend
{
    if (_tztTradeTable == nil)
        return;
    
    NSString* nsCodeOut = [_tztTradeTable getComBoxText:kTagOutCode];
    NSString* nsNameOut = [_tztTradeTable GetLabelText:kTagOutName];
    NSString* nsCodeIn = [_tztTradeTable getComBoxText:kTagInCode];
    NSString* nsNameIn = [_tztTradeTable GetLabelText:kTagInName];
    NSString* nsAmount = [_tztTradeTable GetEidtorText:kTagAmount];
    NSString* nsGSDM = @"";
    
    NSInteger nIndex = [_tztTradeTable getComBoxSelctedIndex:kTagOutCode];
    if (nIndex >= 0 && nIndex < [_ayZHCode count])
    {
        NSMutableDictionary *pDict = [_ayZHCode objectAtIndex:nIndex];
        nsGSDM = [pDict tztObjectForKey:tztFund_GSDM];
    }
    
    if (nsCodeOut.length < 6)
    {
        [self showMessageBox:@"转出基金代码不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    if (nsCodeIn.length < 6)
    {
        [self showMessageBox:@"转入基金代码不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    if ([nsAmount floatValue] < 0.01)
    {
        [self showMessageBox:@"转换份额输入不正确!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    if (!bSend)
    {
        NSString* strMsg = [NSString stringWithFormat:@" 基金转换\r\n 转出基金:%@\r\b 转出名称:%@\r\n 转入基金:%@\r\n 转入名称:%@\r\n 转换份额:%@\r\n 确认转换？", nsCodeOut, nsNameOut, nsCodeIn, nsNameIn, nsAmount];
        [self showMessageBox:strMsg nType_:TZTBoxTypeButtonBoth nTag_:0x1111 delegate_:self withTitle_:@"基金转换"];
        return;
    }
    else
    {
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        _ntztReqNo++;
        if (_ntztReqNo >= UINT16_MAX)
            _ntztReqNo = 1;
        
        NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
        [pDict setTztValue:strReqno forKey:@"Reqno"];
        [pDict setTztObject:nsCodeOut forKey:@"ofundcode"];
        [pDict setTztObject:nsCodeIn forKey:@"ifundcode"];
        [pDict setTztObject:nsAmount forKey:@"Volume"];
        if (nsGSDM)
        {
            [pDict setTztObject:nsGSDM forKey:@"JJDJGSDM"];
        }
        
        //基金公司
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"143" withDictValue:pDict];
        DelObject(pDict);
    }
    
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
    if ([pParse IsAction:@"145"])
    {
        if(strError && [strError length] > 0)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
            return 1;
        }
        int nJJDMIndex = -1;
        int nJJMCIndex = -1;
        int nJJPriceIndex = -1;
        
        NSString* strIndex = [pParse GetByName:@"JJDMIndex"];
        TZTStringToIndex(strIndex, nJJDMIndex);
        
        strIndex = [pParse GetByName:@"JJMCIndex"];
        TZTStringToIndex(strIndex, nJJMCIndex);
        
        strIndex = [pParse GetByName:@"PriceIndex"];
        TZTStringToIndex(strIndex, nJJPriceIndex);

        
        int nMin = MIN(nJJDMIndex, MIN(nJJMCIndex, nJJPriceIndex));
        int nMax = MAX(nJJDMIndex, MAX(nJJMCIndex, nJJPriceIndex));
        
        if (nMin < 0)
            return 0;
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (_ayAllZRCode == NULL)
            _ayAllZRCode = NewObject(NSMutableArray);
        [_ayAllZRCode removeAllObjects];
        
        for (int i = 1; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayData == NULL || [ayData count] < 1 || [ayData count] < nMax)
                continue;
            
            NSString* nsCode = [ayData objectAtIndex:nJJDMIndex];
            NSString* nsName = [ayData objectAtIndex:nJJMCIndex];
            NSString* nsPrice = [ayData objectAtIndex:nJJPriceIndex];
            
            if (nsCode == NULL || nsCode.length < 1)
                continue;
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:nsCode forKey:tztFund_Code];
            [pDict setTztObject:nsName forKey:tztFund_Name];
            [pDict setTztObject:nsPrice forKey:tztFund_Price];
            [_ayAllZRCode addObject:pDict];
            [pDict release];
        }
        
        [self setInFundCode];
        [self OnSelectInCodeAtIndex:0];
    }
    else if ([pParse IsAction:@"137"])
    {
        
        int nJJDMIndex = -1;    //代码
        int nJJMCIndex = -1;    //名称
        int nJJGSDMIndex = -1;  //公司代码
        int nJJKYIndex = -1;    //可用
        int nJJJZIndex = -1;    //净值
        
        NSString *strIndex = [pParse GetByName:@"JJDMIndex"];
        TZTStringToIndex(strIndex, nJJDMIndex);
        
        strIndex = [pParse GetByName:@"JJMCIndex"];
        TZTStringToIndex(strIndex, nJJMCIndex);
        
        strIndex = [pParse GetByName:@"JJGSDM"];
        TZTStringToIndex(strIndex, nJJGSDMIndex);
        
        strIndex = [pParse GetByName:@"PriceIndex"];
        TZTStringToIndex(strIndex, nJJJZIndex);
        if (nJJJZIndex<0) {
            strIndex = [pParse GetByName:@"JJPRICEINDEX"];
            TZTStringToIndex(strIndex, nJJJZIndex);
        }
        
        strIndex = [pParse GetByName:@"JJKYIndex"];
        TZTStringToIndex(strIndex, nJJKYIndex);
        

        int nMin = MIN(nJJDMIndex, MIN(nJJMCIndex, MIN(nJJGSDMIndex, MIN(nJJJZIndex, nJJKYIndex))));
        int nMax = MAX(nJJDMIndex, MAX(nJJMCIndex, MAX(nJJGSDMIndex, MAX(nJJJZIndex, nJJKYIndex))));
        
        if (nMin < 0)
            return 0;
        if (_ayZHCode == NULL)
            _ayZHCode = NewObject(NSMutableArray);
        [_ayZHCode removeAllObjects];
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
            NSMutableArray * ayShow = NewObject(NSMutableArray);
        
        NSMutableArray *ayCode = NewObject(NSMutableArray);
        NSMutableArray *ayName = NewObject(NSMutableArray);
        for (int i = 1; i < [ayGrid count]; i++)
        {
            NSArray *ayData = [ayGrid objectAtIndex:i];
            if (ayGrid == NULL || [ayData count] <= nMax)
                continue;
            
            NSString* strCode = [ayData objectAtIndex:nJJDMIndex];
            NSString* strName = [ayData objectAtIndex:nJJMCIndex];
            NSString* strKY = [ayData objectAtIndex:nJJKYIndex];
            NSString* strGSDM = [ayData objectAtIndex:nJJGSDMIndex];
            NSString* strJJJZ = [ayData objectAtIndex:nJJJZIndex];
            if (strCode.length < 1)
                continue;
            
            
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strCode forKey:tztFund_Code];
            [pDict setTztObject:strName forKey:tztFund_Name];
            [pDict setTztObject:strKY forKey:tztFund_KY];
            [pDict setTztObject:strJJJZ forKey:tztFund_Price];
            [pDict setTztObject:strGSDM forKey:tztFund_GSDM];
            [_ayZHCode addObject:pDict];
            
            [ayCode addObject:strCode];
            [ayName addObject:strName];
            
            if (strName && [strName length] > 0)
            {
                NSString* jjmc = [NSString stringWithFormat:@"%@(%@)",strCode,strName];
                [ayShow addObject:jjmc];
            }

            [pDict release];
        }
        
        if (bsecond) {
            [_tztTradeTable setComBoxData:ayCode ayContent_:ayName AndIndex_:-1 withTag_:kTagOutCode bDrop_:NO];
        }
        else
        {
            [_tztTradeTable setComBoxData:ayCode ayContent_:ayName AndIndex_:-1 withTag_:kTagOutCode bDrop_:TRUE];
            bsecond = YES;
        }
        
//        [self OnSelectOutCodeAtIndex:0];
        [ayCode release];
        [ayName release];
    }
    else
    {
        [self showMessageBox:strError nType_:TZTBoxTypeNoButton delegate_:nil];
        [self ClearData];
        //重新刷新界面数据
        [self OnQueryData];
    }
    
    return 1;
}

-(void)setInFundCode
{
    NSString* strOutCode = [_tztTradeTable getComBoxText:kTagOutCode];
    
    if (_ayZRCode == NULL)
        _ayZRCode = NewObject(NSMutableArray);
    [_ayZRCode removeAllObjects];
    
    NSMutableArray *ayCode = NewObject(NSMutableArray);
    NSMutableArray *ayName = NewObject(NSMutableArray);
    
    for (int i = 0; i < [_ayAllZRCode count]; i++)
    {
        NSMutableDictionary *pDict = [_ayAllZRCode objectAtIndex:i];
        if (pDict == NULL)
            continue;
        
        NSString* nsCode = [pDict tztObjectForKey:tztFund_Code];
        if (nsCode == NULL || nsCode.length < 1  || [nsCode caseInsensitiveCompare:strOutCode] == NSOrderedSame)
            continue;
        
        NSString* nsName = [pDict tztObjectForKey:tztFund_Name];
        [ayCode addObject:nsCode];
        [ayName addObject:nsName];
        [_ayZRCode addObject:pDict];
    }
    
    [_tztTradeTable setComBoxData:ayCode ayContent_:ayName AndIndex_:0 withTag_:kTagInCode];
    
    [ayCode release];
    [ayName release];
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
            [self OnSend:FALSE];
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
                [self OnSend:TRUE];
            }
                break;
                
            default:
                break;
        }
    }
}

// iPad确定框 byDBQ20130823
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

-(void)OnButton:(id)sender
{
    
}

-(void)OnSelectOutCodeAtIndex:(NSInteger)nSelect
{
    if (nSelect < 0 || nSelect >= [_ayZHCode count])
        nSelect = 0;
    
    if ([_ayZHCode count] < 1)
        return;
    
    NSMutableDictionary *pDict = [_ayZHCode objectAtIndex:nSelect];
    if (pDict == NULL)
        return;
    
    NSString* strName = [pDict tztObjectForKey:tztFund_Name];
    NSString* strPrice = [pDict tztObjectForKey:tztFund_Price];
    NSString* strKY = [pDict tztObjectForKey:tztFund_KY];
    NSString* strGSDM = [pDict tztObjectForKey:tztFund_GSDM];
    
    [_tztTradeTable setLabelText:strName withTag_:kTagOutName];
    [_tztTradeTable setLabelText:strPrice withTag_:kTagOutPrice];
    [_tztTradeTable setLabelText:strKY withTag_:kTagOutCanUse];
    
    [self OnInquireCodeIN:strGSDM];
}

-(void)OnSelectInCodeAtIndex:(NSInteger)nSelect
{
    if (nSelect < 0 || nSelect >= [_ayZRCode count])
        nSelect = 0;
    
    if ([_ayZRCode count] < 1)
        return;
    NSMutableDictionary *pDict = [_ayZRCode objectAtIndex:nSelect];
    if (pDict == NULL)
        return;
    
    NSString* strName = [pDict tztObjectForKey:tztFund_Name];
    NSString* strPrice = [pDict tztObjectForKey:tztFund_Price];
    
    [_tztTradeTable setLabelText:strName withTag_:kTagInName];
    [_tztTradeTable setLabelText:strPrice withTag_:kTagInPrice];
}

//选中列表数据
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(NSInteger)index
{
    switch ([droplistview.tzttagcode intValue])
    {
        case kTagOutCode:
        {
            [self OnSelectOutCodeAtIndex:index];
        }
            break;
        case kTagInCode:
        {
            [self OnSelectInCodeAtIndex:index];
        }
            break;
            
        default:
            break;
    }
}

- (void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    switch ([droplistview.tzttagcode intValue])
    {
        case kTagOutCode:
        {
            if ([droplistview.ayData count] < 1 || [droplistview.ayValue count] < 1)
            {
                [self OnQueryData];//获取持仓 即可转换基金
            }
        }
            break;
            
        default:
            break;
    }
    return;
}


-(void)OnButtonClick:(id)sender
{
	tztUIButton * pButton = (tztUIButton*)sender;
    switch ([pButton.tzttagcode intValue])
    {
        case kTagOK:
        {
            [self OnSend:FALSE];
        }
            break;
        case kTagClear:
        {
            [self ClearData];
        }
            break;
        case kTagRefresh:
        {
            [self OnQueryData];
        }
            break;
            
        default:
            break;
    }
}
@end




