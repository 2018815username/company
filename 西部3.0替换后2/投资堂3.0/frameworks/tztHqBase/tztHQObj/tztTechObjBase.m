/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztTechObjBase.h
 * 文件标识：
 * 摘    要：行情基础定义
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/


#import "tztTechObjBase.h"

tztUpdate   *g_pTztUpdate = NULL;

@implementation tztTechValue
@synthesize uYear = _uYear;
@synthesize ulTime = _ulTime;              //时间
@synthesize nOpenPrice = _nOpenPrice;      //开
@synthesize nHighPrice = _nHighPrice;      //高
@synthesize nLowPrice = _nLowPrice;       //低
@synthesize nClosePrice = _nClosePrice;     //收
@synthesize ulTotal_h = _ulTotal_h;           //成交量
@synthesize nVolume = _nVolume;

- (id)initwithdata:(TNewKLineData*)klinedata
{
    self = [super init];
    if(self)
    {
        [self setdata:klinedata];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)setdata:(TNewKLineData*)klinedata
{
    _uYear = 0;
    _ulTime = klinedata->ulTime;
    _nOpenPrice = klinedata->nOpenPrice;
    _nHighPrice = klinedata->nHighPrice;
    _nLowPrice = klinedata->nLowPrice;
    _nClosePrice = klinedata->a.nClosePrice;
    _ulTotal_h = (double)(klinedata->c.ulTotal_h) * (double)_nVolume;
}

//K线数据有效性判断
- (BOOL)isVaild
{
    return (_ulTime != 0 &&
            _nOpenPrice != 0 &&
            _nHighPrice != 0 &&
            _nLowPrice != 0 &&
            _nClosePrice != 0);
    
}
@end

@implementation tztShareData
@synthesize nsTime = _nsTime;
@synthesize nsWTType = _nsWTType;
@synthesize nsPrice = _nsPrice;
@synthesize nsDate = _nsDate;
@synthesize Color = _Color;

- (id)initwithdata:(TShareData*)sharedata
{
    self = [super init];
    if(self)
    {
        [self setdata:sharedata];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)setdata:(TShareData*)sharedata
{
    _nsDate = [NSString stringWithFormat:@"%d",(int)sharedata->nday];
    _nsTime = [NSString stringWithFormat:@"%d:%d",(int)(sharedata->ntime)/100,(int)(sharedata->ntime)%100];
    NSString * Direction = [NSString stringWithUTF8String:(char*)sharedata->ndir];
    _nsWTType = @"";
    if (Direction && [Direction length] >0 )
    {
        if ([Direction intValue] == 1)
        {
            _nsWTType = @"委买";
            _Color = [UIColor tztThemeHQUpColor];
        }
        if ([Direction intValue] == 2)
        {
            _nsWTType = @"委卖";
            _Color = [UIColor tztThemeHQDownColor];
        }
    }
    NSString * nsReal = [NSString stringWithUTF8String:(char*)sharedata->nreal];
    if (nsReal && [nsReal length] >0 )
    {
        if ([nsReal intValue] == 1)
        {
            _nsWTType = [NSString stringWithFormat:@"%@(实)",_nsWTType];
        }
        if ([nsReal intValue] == 2)
        {
            _nsWTType = [NSString stringWithFormat:@"%@(模)",_nsWTType];
        }
    }
    NSString *nsPos = [NSString stringWithUTF8String:(char*)sharedata->npos];
    long lpos = 1;
    if (nsPos && [nsPos length] >0 )
    {
        int npos = [nsPos intValue];
        for (int i = 0; i < npos; i++)
        {
            lpos = lpos* 10;
        }
    }
    
    NSString * nsprice = [NSString stringWithUTF8String:(char*)sharedata->nprice];
    if (nsprice && [nsprice length] >0 )
    {
        double price = [nsprice doubleValue];
        price = price/lpos;
        _nsPrice = [NSString stringWithFormat:@"%2f",price];
    }
}

//K线数据有效性判断
- (BOOL)isVaild
{
    return (_nsTime && [_nsTime length] > 0
            && _nsPrice && [_nsPrice length] > 0
            && _nsWTType && [_nsWTType length] > 0
            && _nsDate &&[_nsDate length] > 0);
}
@end

//资金指数
@implementation tztZJZS
@synthesize m_ulTime = _ulTime;
@synthesize m_ZLline = _ZLline;
@synthesize m_SHline = _SHline;

- (id)initwithdata:(TZJZS*)klinedata
{
    self = [super init];
    if(self)
    {
        [self setdata:klinedata];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)setdata:(TZJZS*)klinedata
{
    _ulTime = klinedata->ulTime;
    _ZLline = klinedata->m_ZLline;
    _SHline = klinedata->m_SHline;
}

//数据有效性判断
- (BOOL)isVaild
{
    return (_ulTime != 0 &&
            _ZLline != 0 &&
            _SHline != 0 );
    
}
@end

//运筹帷幄
@implementation tztYCWW
@synthesize m_ulTime = _ulTime;
@synthesize m_line1 = _line1;
@synthesize m_line2 = _line2;
@synthesize m_buy = _buy;
@synthesize m_Con1 = _Con1;
@synthesize m_Con2 = _Con2;
@synthesize m_NewPr1 = _NewPr1;
@synthesize m_NewPr2 = _NewPr2;
@synthesize m_NewPr3 = _NewPr3;
@synthesize m_NewPr4 = _NewPr4;
@synthesize m_NewPr6 = _NewPr6;
@synthesize m_NewPr7 = _NewPr7;
@synthesize m_lNum1 = _lNum1;
@synthesize m_lNum2 = _lNum2;
@synthesize m_lNum3 = _lNum3;
@synthesize m_lNum4 = _lNum4;
@synthesize m_A1 = _A1;
@synthesize m_A2 = _A2;
@synthesize m_A3 = _A3;
@synthesize m_A4 = _A4;
@synthesize m_A5 = _A5;
@synthesize m_A6 = _A6;
@synthesize m_A7 = _A7;
@synthesize m_A8 = _A8;
@synthesize m_A9 = _A9;
@synthesize m_A10 = _A10;
@synthesize m_A11 = _A11;
@synthesize m_A12 = _A12;
@synthesize m_A13 = _A13;
@synthesize m_A14 = _A14;
@synthesize m_A15 = _A15;
@synthesize m_A16 = _A16;
@synthesize m_A17 = _A17;
@synthesize m_A18 = _A18;

- (id)initwithdata:(TYCWW*)klinedata
{
    self = [super init];
    if(self)
    {
        [self setdata:klinedata];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)setdata:(TYCWW*)tycww
{
    _ulTime = tycww->ulTime;
    _line1 = tycww->m_line1;
    _line2 = tycww->m_line2;
    _buy = tycww->m_buy;
    _Con1 = tycww->m_Con1;
    _Con2 = tycww->m_Con2;
    _NewPr1 = tycww->m_NewPr1;
    _NewPr2 = tycww->m_NewPr2;
    _NewPr3 = tycww->m_NewPr3;
    _NewPr4 = tycww->m_NewPr4;
    _NewPr6 = tycww->m_NewPr6;
    _NewPr7 = tycww->m_NewPr7;
    
    _lNum1 = tycww->m_lNum1;
    _lNum2 = tycww->m_lNum2;
    _lNum3 = tycww->m_lNum3;
    _lNum4 = tycww->m_lNum4;
    
    _A1 = tycww->m_A1;
    _A2 = tycww->m_A2;
    _A3 = tycww->m_A3;
    _A4 = tycww->m_A4;
    _A5 = tycww->m_A5;
    _A6 = tycww->m_A6;
    _A7 = tycww->m_A7;
    _A8 = tycww->m_A8;
    _A9 = tycww->m_A9;
    _A10 = tycww->m_A10;
    _A11 = tycww->m_A11;
    _A12 = tycww->m_A12;
    _A13 = tycww->m_A13;
    _A14 = tycww->m_A14;
    _A15 = tycww->m_A15;
    _A16 = tycww->m_A16;
    _A17 = tycww->m_A17;
    _A18 = tycww->m_A18;
}

//数据有效性判断
- (BOOL)isVaild
{
    return FALSE;
}
@end


@implementation tztFundFlowsValue
@synthesize pTime = _pTime;
@synthesize pDaHu = _pDaHu;
@synthesize pJing = _PJing;
@synthesize pSanHu = _pSanHu;
@synthesize pZhuLi = _pZhuLi;
@synthesize pZhongHu = _pZhongHu;
@end

@implementation tztTrendFundFlows
@synthesize nsKind = _nsKind;
@synthesize nsFundIn = _nsFundIn;
@synthesize nsFundOut = _nsFundOut;
@synthesize nsFundJE = _nsFundJE;
@synthesize nKind = _nKind;

-(id)init
{
    if (self = [super init])
    {
        self.nsKind = @"";
        self.nsFundIn = @"";
        self.nsFundOut = @"";
        self.nsFundJE = @"";
        self.nsKind = 0;
    }
    return self;
}

-(void)setNsKind:(NSString *)nsType
{
    if (nsType == NULL || nsType.length <= 0)
        return;
        
    _nsKind = [[NSString alloc] initWithFormat:@"%@", nsType];
    //1-机构 2-大户 3－散户 4-主力
    if ([_nsKind caseInsensitiveCompare:@"机构"] == NSOrderedSame)
        self.nKind = 1;
    else if ([_nsKind caseInsensitiveCompare:@"大户"] == NSOrderedSame)
        self.nKind = 2;
    else if([_nsKind caseInsensitiveCompare:@"主力"] == NSOrderedSame)
        self.nKind = 4;
    else if([_nsKind caseInsensitiveCompare:@"散户"] == NSOrderedSame)
        self.nKind = 3;
}

-(void)dealloc
{
    DelObject(_nsKind);
    [super dealloc];
}
@end

@implementation tztUpdate
@synthesize nUpdateSin = _nUpdateSign;
@synthesize nsTips = _nsTips;
@synthesize nsUpdateURL = _nsUpdateURL;

-(id)init
{
    if (self = [super init])
    {
        self.nUpdateSin = 0;
        self.nsTips = @"";
        self.nsUpdateURL = @"";
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)CheckUpdate
{
    if (self.nUpdateSin > 0 && self.nsUpdateURL.length > 0)
    {
        int nTag = 0;
        NSString *nsTitle = @"升级";
        NSString *nsCancel = nil;
        if (self.nUpdateSin == 1)//建议升级
        {
            nsTitle = @"建议升级";
            nsCancel = @"取消";
            if (self.nsTips.length <= 0)
                self.nsTips = @"软件有更新，建议升级!按“确定“升级，按“取消”继续使用!";
            nTag = 0x8888;
        }
        else
        {
            nsTitle = @"强制升级";
            if (self.nsTips.length <= 0)
                self.nsTips = @"软件有更新，需要强制升级! 请按”确定“升级!";
            nTag = 0x9999;
            nsCancel = nil;
        }
        
#ifdef Support_EXE_VERSION
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nsTitle
                                                        message:self.nsTips
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nsCancel, nil];
        alert.tag = nTag;
        [alert show];
        [alert release];
#else
        //向外层发出升级通知
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        //升级标志
        [pDict setTztObject:[NSString stringWithFormat:@"%d", self.nUpdateSin] forKey:@"tztUpdateSign"];
        //升级URL
        [pDict setTztObject:self.nsUpdateURL forKey:@"tztUpdateURL"];
        //升级提示
        [pDict setTztObject:self.nsTips forKey:@"tztUpdateTips"];
        
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTNotifi_UpdateInfo object:pDict];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        DelObject(pDict);
#endif
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x8888:
            case 0x9999:
            {
                if (self.nUpdateSin == 2)//强制升级
                    [self CheckUpdate];
                BOOL bSucc = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nsUpdateURL]];
                if (bSucc)
                {
                    abort();
//                    exit(1);
                }
            }
                break;
            default:
            {
            }
                break;
        }
    }
}
@end

void setTNewKLineHead(TNewKLineHead* pTNewKLineHead, NSString* strBaseData)
{
    memset(pTNewKLineHead, 0, sizeof(TNewKLineHead));
    if(strBaseData && [strBaseData length] > 0)
    {
        NSArray* ayBaseData = [strBaseData componentsSeparatedByString:@"|"];
        if(ayBaseData && [ayBaseData count] >= 2)
        {
            NSString* strStockName = [ayBaseData objectAtIndex:0];
            NSData* stockNameData = [strStockName dataUsingEncoding:NSStringEncodingGBK];
            int nLen = 0;
            if(stockNameData && [stockNameData length] > 0)
            {
                nLen = sizeof(pTNewKLineHead->cStockName);
                memcpy(pTNewKLineHead->cStockName, [stockNameData bytes], MIN([stockNameData length],nLen));
            }
            NSString* strData = [ayBaseData objectAtIndex:1];
            NSData* binData = [NSData tztdataFromBase64String:strData];
            if(binData && [binData length] > 0)
            {
                memcpy(&pTNewKLineHead->nDecimal, [binData bytes], MIN(sizeof(TNewKLineHead)-nLen,[binData length]));
            }
        }
    }
}

NSString* getcStockName_TNewKLineHead(TNewKLineHead* pTNewKLineHead)
{
    return [[[NSString alloc] initWithBytes:pTNewKLineHead->cStockName length:sizeof(pTNewKLineHead->cStockName) encoding:NSStringEncodingGBK] autorelease];
}

void setTNewTrendHead(TNewTrendHead* pTNewTrendHead, NSString* strBaseData)
{
    memset(pTNewTrendHead, 0, sizeof(TNewTrendHead));
    if(strBaseData && [strBaseData length] > 0)
    {
        NSArray* ayBaseData = [strBaseData componentsSeparatedByString:@"|"];
        if(ayBaseData && [ayBaseData count] >= 2)
        {
            NSString* strStockName = [ayBaseData objectAtIndex:0];
            NSData* stockNameData = [strStockName dataUsingEncoding:NSStringEncodingGBK];
            int nLen = 0;
            if(stockNameData && [stockNameData length] > 0)
            {
                nLen = sizeof(pTNewTrendHead->StockName);
                memcpy(pTNewTrendHead->StockName, [stockNameData bytes], MIN([stockNameData length],nLen));
            }
            NSString* strData = [ayBaseData objectAtIndex:1];
            NSData* binData = [NSData tztdataFromBase64String:strData];
            if(binData && [binData length] > 0)
            {
                memcpy(&pTNewTrendHead->nPreClosePrice, [binData bytes], MIN(sizeof(TNewTrendHead)-nLen,[binData length]));
            }
        }
    }
}

NSString* getStockName_TNewTrendHead(TNewTrendHead* pTNewTrendHead)
{
        return [[[NSString alloc] initWithBytes:pTNewTrendHead->StockName length:sizeof(pTNewTrendHead->StockName) encoding:NSStringEncodingGBK] autorelease];
}

void setTNewPriceDataEx(TNewPriceDataEx* pTNewPriceData, NSString* strBaseData)
{
    memset(pTNewPriceData, 0, sizeof(TNewPriceDataEx));
    if (strBaseData && [strBaseData length] > 0)
    {
        NSData* binData = [NSData tztdataFromBase64String:strBaseData];
        
        memcpy(&pTNewPriceData->pBuy1, [binData bytes], sizeof(pTNewPriceData->pBuy1));
        memcpy(pTNewPriceData, [binData bytes], MIN(sizeof(TNewPriceDataEx), [binData length]));
    }
}

void setTNewPriceData(TNewPriceData* pTNewPriceData, NSString* strBaseData)
{
    memset(pTNewPriceData, 0, sizeof(TNewPriceData));
    if(strBaseData && [strBaseData length] > 0)
    {
        NSArray* ayBaseData = [strBaseData componentsSeparatedByString:@"|"];
//        int nCount = [ayBaseData count];
        if(ayBaseData && [ayBaseData count] >= 8)
        {
            NSString* strData = [ayBaseData objectAtIndex:0];
            NSData* binData = [NSData tztdataFromBase64String:strData];
            if(binData && [binData length] > 0)
            {
                memcpy(pTNewPriceData->XFlag, [binData bytes], [binData length]);
            }
            NSString* strStockName = [ayBaseData objectAtIndex:1];
            NSData* stockNameData = [strStockName dataUsingEncoding:NSStringEncodingGBK];
            char *pp = (char*)[stockNameData bytes];
            for (NSInteger i = 0 ; i < [stockNameData length]; i++)
            {
                char p = pp[i];
                if (p == 0x00)
                {
                    pp[i] = ' ';
                }
            }
            int nLen = 0;
            if(stockNameData && [stockNameData length] > 0)
            {
                nLen = sizeof(pTNewPriceData->Name);
                memcpy(pTNewPriceData->Name, [stockNameData bytes], MIN([stockNameData length],nLen));
                pTNewPriceData->nameLength = MIN((int)[strStockName length],nLen);
            }

            strData = [ayBaseData objectAtIndex:2];
            binData = [NSData tztdataFromBase64String:strData];
            if(binData && [binData length] > 0)
            {
                memcpy(&pTNewPriceData->Kind, [binData bytes], [binData length]);
            }
            
            strData = [ayBaseData objectAtIndex:3];
            binData = [NSData tztdataFromBase64String:strData];
            if(binData && [binData length] > 0)
            {
                memcpy(&pTNewPriceData->m_lUpPrice, [binData bytes], [binData length]);
            }
            
            NSString* strBlockName = [ayBaseData objectAtIndex:4];
            NSData* blockNameData = [strBlockName dataUsingEncoding:NSStringEncodingGBK];
            if(blockNameData && [blockNameData length] > 0)
            {
                nLen = sizeof(pTNewPriceData->BlockName);
                memcpy(pTNewPriceData->BlockName, [blockNameData bytes], MIN([blockNameData length],nLen));
                pTNewPriceData->nBlockNameLength = MIN((int)[strBlockName length],nLen);
            }
            
            strBlockName = [ayBaseData objectAtIndex:5];
            blockNameData = [strBlockName dataUsingEncoding:NSASCIIStringEncoding];
            if(blockNameData && [blockNameData length] > 0)
            {
                nLen = sizeof(pTNewPriceData->BlockCode);
                memcpy(pTNewPriceData->BlockCode, [blockNameData bytes], MIN([blockNameData length],nLen));
            }

            strData = [ayBaseData objectAtIndex:6];
            binData = [NSData tztdataFromBase64String:strData];
            NSUInteger nStart = (NSUInteger)(&pTNewPriceData->m_lBlockUpIndex);
            NSUInteger nEnd = (NSUInteger)(&pTNewPriceData->m_ldtsyl);
            if(binData && [binData length] > 0)
            {
                memcpy(&pTNewPriceData->m_lBlockUpIndex, [binData bytes], MIN([binData length], nEnd - nStart));
            }
            
            strData = [ayBaseData objectAtIndex:7];
            binData = [NSData tztdataFromBase64String:strData];
            nStart = nEnd;
            nEnd = (NSUInteger)(&pTNewPriceData->m_blockUps);
            if(binData && [binData length] > 0)
            {
                memcpy(&pTNewPriceData->m_ldtsyl, [binData bytes], MIN([binData length], nEnd - nStart));
            }
            
            nStart = nEnd;
            nEnd = (NSUInteger)(&pTNewPriceData->c_IsGgt);
            if (ayBaseData.count > 8)
            {
                strData = [ayBaseData objectAtIndex:8];
                binData = [NSData tztdataFromBase64String:strData];
                if (binData && [binData length] > 0)
                {
                    memcpy(&pTNewPriceData->m_blockUps, [binData bytes], MIN([binData length], nEnd-nStart));
                }
            }
            
            nStart = nEnd;
            nEnd = (NSUInteger)(&pTNewPriceData->m_nWB);
            if (ayBaseData.count > 9)
            {
                strData = [ayBaseData objectAtIndex:9];
                NSData* data = [strData dataUsingEncoding:NSStringEncodingGBK];
                memcpy(&pTNewPriceData->c_IsGgt, [data bytes], MIN([data length], nEnd-nStart));
            }
            
            nStart = nEnd;
            nEnd = (NSUInteger)(&pTNewPriceData->m_nUnit);
            if (ayBaseData.count > 10)
            {
                strData = [ayBaseData objectAtIndex:10];
                binData = [NSData tztdataFromBase64String:strData];
                if (binData && [binData length] > 0)
                {
                    memcpy(&pTNewPriceData->m_nWB, [binData bytes], MIN([binData length], nEnd-nStart));
                }
            }
            
            nStart = nEnd;
            nEnd = (NSUInteger)(&pTNewPriceData->m_mgsy);
            if (ayBaseData.count > 11)
            {
                strData = [ayBaseData objectAtIndex:11];
                binData = [NSData tztdataFromBase64String:strData];
                if (binData && [binData length] > 0)
                {
                    memcpy(&pTNewPriceData->m_nUnit, [binData bytes], MIN([binData length], nEnd-nStart));
                }
            }
            
            nStart = nEnd;
            nEnd = (NSUInteger)(&pTNewPriceData->XFlag+sizeof(TNewPriceData));
            if (ayBaseData.count > 12)
            {
                strData = [ayBaseData objectAtIndex:12];
                binData = [NSData tztdataFromBase64String:strData];
                if (binData && binData.length > 0)
                {
                    memcpy(&pTNewPriceData->m_mgsy, [binData bytes], MIN([binData length], nEnd-nStart));
                }
            }
        }
    }
}

NSString* getName_TNewPriceData(TNewPriceData* pTNewPriceData)
{
    NSString* strName =  [[[NSString alloc] initWithBytes:pTNewPriceData->Name length:sizeof(pTNewPriceData->Name) encoding:NSStringEncodingGBK] autorelease];
    return [strName stringByReplacingOccurrencesOfString:@" " withString:@""];
}

NSString* getBlockName_TNewPriceData(TNewPriceData* pTNewPriceData)
{
    return [[[NSString alloc] initWithBytes:pTNewPriceData->BlockName length:sizeof(pTNewPriceData->BlockName) encoding:NSStringEncodingGBK] autorelease];
}


NSString* getBlockCode_TNewPriceData(TNewPriceData* pTNewPriceData)
{
    NSString* strCodeReturn = @"";
    NSString* strBlockCode = @"";
    strBlockCode = [[[NSString alloc] initWithBytes:pTNewPriceData->BlockCode length:sizeof(pTNewPriceData->BlockCode) encoding:NSASCIIStringEncoding] autorelease];
    
    strCodeReturn = [strBlockCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [[[NSString alloc] initWithString:strCodeReturn] autorelease];
}


void setTNewDetailHead(TNewDetailHead* pTNewDetailHead, NSString* strBaseData)
{
    memset(pTNewDetailHead, 0, sizeof(TNewDetailHead));
    if(strBaseData && [strBaseData length] > 0)
    {
        NSArray* ayBaseData = [strBaseData componentsSeparatedByString:@"|"];
        if(ayBaseData && [ayBaseData count] >= 2)
        {
            NSString* strStockName = [ayBaseData objectAtIndex:0];
            NSData* stockNameData = [strStockName dataUsingEncoding:NSStringEncodingGBK];
            int nLen = 0;
            if(stockNameData && [stockNameData length] > 0)
            {
                nLen = sizeof(pTNewDetailHead->Name);
                memcpy(pTNewDetailHead->Name, [stockNameData bytes], MIN([stockNameData length],nLen));
            }
            NSString* strData = [ayBaseData objectAtIndex:1];
            NSData* binData = [NSData tztdataFromBase64String:strData];
            if(binData && [binData length] > 0)
            {
                memcpy(&pTNewDetailHead->Last_p, [binData bytes], MIN(sizeof(TNewDetailHead)-nLen,[binData length]));
            }
        }
    }
}

NSString* getName_TNewDetailHead(TNewDetailHead* pTNewDetailHead)
{
    return [[[NSString alloc] initWithBytes:pTNewDetailHead->Name length:sizeof(pTNewDetailHead->Name) encoding:NSStringEncodingGBK] autorelease];
}

NSString* getCycleName(tztKLineCycle nKLineCycleStyle)
{
    switch (nKLineCycleStyle) {
        case KLineCycleDay:
            return @"日线";
        case KLineCycle1Min:
            return @"1分钟";
        case KLineCycle5Min:
            return @"5分钟";
        case KLineCycle15Min:
            return @"15分钟";
        case KLineCycle30Min:
            return @"30分钟";
        case KLineCycle60Min:
            return @"60分钟";
        case KLineCycleWeek:
            return @"周线";
        case KLineCycleMonth:
            return @"月线";
        case  KLineCycleCustomDay:
            return @"自定日线"; 
        case  KLineCycleCustomMin:
            return @"自定分钟线"; 
        case KLineChuQuan:
            return @"复权";
        case KLineCycleDayYCWW:
            return @"运筹帷幄";
        default:
            return @"周期";
    }
}

NSString* getZhiBiaoName(NSInteger nKLineZhiBiao)
{
    switch (nKLineZhiBiao) {
        case PKLINE:
            return @"K线";
        case VOL:
            return @"VOL";
        case ZJZS:
            return @"资金指数";
        case MACD:
            return @"MACD";
        case KDJ:
            return @"KDJ";
        case RSI:
            return @"RSI";
        case WR:
            return @"W%R";
        case BOLL:
            return @"BOLL";
        case DMI:
            return @"DMI";
        case DMA:
            return @"DMA";
        case TRIX:
            return @"TRIX";
        case BRAR:
            return @"BRAR";
        case VR:
            return @"VR";
        case OBV:
            return @"OBV";
        case ASI:
            return @"ASI";
        case EMV:
            return @"EMV";
        case WVAD:
            return @"WVAD";
        case CCI:
            return @"CCI";
        case ROC:
            return @"ROC";
        case EXPMA:
            return @"EXPMA";
        case TZTCR:
            return @"CR";
        case SAR:
            return @"SAR";
        case MIKE:
            return @"MIKE";
        case BIAS:
            return @"BIAS";
        default:
            return @"";
    }
}

//计算最大区间值  值 开始位置 结束位置 中间值 原最大值
long GetMaxDiff(long lReference,long lMaxValue,long lMinValue)
{
    if(lMaxValue == 0 && lMinValue == 0)
        return 2;
    long nMaxDiff = MAX(labs(lMaxValue - lReference), labs(lReference - lMinValue));
    return nMaxDiff;
}

NSString* NStringOfLong(long lValue)
{
    if(labs(lValue) > 10000* 10000)
    {
        return [NSString stringWithFormat:@"%.2f亿",lValue/ (10000.0*10000.0)];
    }
    else if(labs(lValue) > 10000)
    {
        return [NSString stringWithFormat:@"%.2f万",lValue/ (10000.0)];
    }
    else
        return [NSString stringWithFormat:@"%ld",lValue];
}

NSString* NStringOfFloat(float fValue)
{
    if (fValue > 10000 * 10000)
    {
        return [NSString stringWithFormat:@"%.2f亿", fValue / (10000.0 * 10000.0)];
    }
    else if (fValue > 10000)
    {
        return [NSString stringWithFormat:@"%.2f万", fValue / (10000.0)];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2f", fValue];
    }
}

NSString* NStringOfULong(unsigned long ulValue)
{
    if(ulValue > 10000* 10000)
    {
        return [NSString stringWithFormat:@"%.2f亿",ulValue/ (10000.0*10000.0)];
    }
    else if (ulValue > 10000*1000)
    {
        return [NSString stringWithFormat:@"%ld万",ulValue/ (10000)];
    }
    else if(ulValue > 100000)
    {
        return [NSString stringWithFormat:@"%.1f万",ulValue/ (10000.0)];
    }
    else
        return [NSString stringWithFormat:@"%ld",ulValue];
}

NSString* NStringOfULongLong(unsigned long long ullValue)
{
    if(ullValue > 10000* 10000)
    {
        return [NSString stringWithFormat:@"%.2f亿",ullValue/ (10000.0*10000.0)];
    }
    else if(ullValue > 10000)
    {
        return [NSString stringWithFormat:@"%.2f万",ullValue/ (10000.0)];
    }
    else
        return [NSString stringWithFormat:@"%lld",ullValue];
}

NSString* NSStringOfVal_Ref_Dec_Div(long lValue, long lReference, NSInteger nDecimal,NSInteger nDiv)
{
    if(lValue == INT32_MAX || lValue == 0)
        return @"-";
    NSString* strformat = @"%@%d";
    NSString* strUp = @"";
//    if(lValue < lReference)
//        strUp = @"-";
    if(nDecimal > 0)
    {
        strformat = [NSString stringWithFormat:@"%%@%%.%df",(int)nDecimal];
        return [NSString stringWithFormat:strformat,strUp,(float)lValue/nDiv];
    }
    return [NSString stringWithFormat:strformat,strUp,(long)lValue/nDiv];
}
