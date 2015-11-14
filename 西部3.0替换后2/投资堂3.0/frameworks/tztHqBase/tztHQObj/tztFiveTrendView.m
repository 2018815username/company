
#import "tztFiveTrendView.h"
#define TZTTrendFivePath @"Library/Documents/Trend/"
@implementation tztFiveTrendView
@synthesize nDays = _nDays;

-(void)initdata
{
    [super initdata];
    _nDays = 5;
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    [super onSetViewRequest:bRequest];
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    [super setStockInfo:pStockInfo Request:nRequest];
    
    if (self.pStockInfo == nil || self.pStockInfo.stockCode == nil || [self.pStockInfo.stockCode length] <= 0)
    {
        return;
    }
    
    //    [self onClearData];
    //读取本地数据－分时 yangdl 2013.08.14
    [self readParse];
}

-(void)onRequestData:(BOOL)bShowProcess
{
    if (!_bRequest)
    {
        [super onRequestData:bShowProcess];
        return;
    }
    
    if (self.pStockInfo == nil || self.pStockInfo.stockCode.length < 1)
        return;
    if (_tztPriceView)
        _tztPriceView.pStockInfo = self.pStockInfo;
    
    NSInteger nStartPos = 0;
    if (MakeWHMarket(self.pStockInfo.stockType))
        [self onClearData];
    
    NSMutableDictionary *sendvalue = NewObject(NSMutableDictionary);
    
    if(self.ayTrendValues && [self.ayTrendValues count] > 0)//增量请求
    {
        nStartPos = [self.ayTrendValues count] -1;
        if (!self.trendEndDate && self.trendEndDate.length>0)
            [sendvalue setTztObject:self.trendEndDate forKey:@"EndDate"];
    }

    
    NSString* strPos = [NSString stringWithFormat:@"%ld", (long)nStartPos];
    [sendvalue setTztObject:self.pStockInfo.stockCode forKey:@"stockcode"];
    [sendvalue setTztObject:strPos forKey:@"StartPos"];
    [sendvalue setTztObject:@"2" forKey:@"AccountIndex"];
    _ntztHqReq++;
    if (_ntztHqReq >= UINT16_MAX)
        _ntztHqReq = 1;
    NSString* nsMarket = [NSString stringWithFormat:@"%d", self.pStockInfo.stockType];
    [sendvalue setTztObject:nsMarket forKey:@"NewMarketNo"];
    
    [sendvalue setTztObject:[NSString stringWithFormat:@"-%d", _nDays] forKey:@"begindate"];
    
    NSString* strReqno = tztKeyReqnoTokenOne((long)self, _ntztHqReq,0,0,(nStartPos == 0 ? 0 : 1));
    [sendvalue setTztObject:strReqno forKey:@"Reqno"];
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20109" withDictValue:sendvalue];
    DelObject(sendvalue);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (wParam == 0)
        return 0;
    tztNewMSParse *parse = (tztNewMSParse*)wParam;
    if ([parse GetAction] == 20109)
    {
        if (![parse IsIphoneKey:(long)self reqno:_ntztHqReq])
            return 0;
        
        [self dealParse:parse IsRead:NO];
    }
    return 0;
}

-(NSUInteger)dealParse:(tztNewMSParse*)parse IsRead:(BOOL)bRead
{
    if (bRead)
        [self onClearData];
    
    
    NSString* DataStockType = [parse GetValueData:@"NewMarketNo"];
    if (DataStockType == NULL || DataStockType.length < 1)
        DataStockType = [parse GetValueData:@"stocktype"];
    if(DataStockType && [DataStockType length] > 0)
    {
        self.pStockInfo.stockType = [DataStockType intValue];
    }
    
    if(_tztPriceView)
    {
        _tztPriceView.pStockInfo = self.pStockInfo;
    }
    
    BOOL bClearAll = FALSE;
    NSString* strReqno = [parse GetByName:@"Reqno"];
    tztNewReqno* tztReqno = [tztNewReqno reqnoWithString:strReqno];
    if(!bRead)
    {
        if([tztReqno getReqdefOne] == tztTrendFirst)
        {
            bClearAll = TRUE;
            [self onClearData];
        }
    }
    
    if(!bRead)
        self.trendEndDate = [parse GetValueData:@"EndDate"];
    
    NSString* DataMaxCount = [parse GetValueData:@"MaxCount"];
    if(DataMaxCount && [DataMaxCount length] > 0)
    {
        self.nMaxCount = [DataMaxCount intValue];
        if(self.nMaxCount <= 1)
            self.nMaxCount = 241;
        
        //设置资金流向界面的 值的个数和 左边的宽度
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tzthqView:MaxCount:LeftWidth:)])
        {
            [self.tztdelegate tzthqView:self MaxCount:self.nMaxCount LeftWidth:(int)self.fYAxisWidth];
        }
//        if (!_bHideFundFlows&&_tztFundFlows)
//        {
//            _tztFundFlows.fLeftWidth = _fYAxisWidth;
//            _tztFundFlows.nMaxCount = _nMaxCount;
//            [_tztFundFlows setNeedsDisplay];
//        }
    }
    int nDataCount = [parse GetIntByName:@"ErrorNo"];//返回多少新数据
    
    NSString* strBase = [parse GetByName:@"Title"];
    NSData * DataTitle = [NSData tztdataFromBase64String:strBase];
    
    NSString* strStarPos = [parse GetByName:@"StartPos"];
    NSInteger nStart = (([self.ayTrendValues count] < 1) ? 0 : ([self.ayTrendValues count] - 1));
    if(strStarPos && [strStarPos length] > 0)
        nStart = [strStarPos intValue];
    
    if(DataTitle && [DataTitle length] > 0)
    {
        char *pBinData = (char*)[DataTitle bytes];
        int nCount = 0;
        memcpy(&nCount, pBinData, 4);
        char *pData = (char*)pBinData;
        pData += 4;
        for (int i = 0; i < nCount; i++)
        {
            short nPos = -1;
            memcpy(&nPos, pData, 2);
            pData += 2;
            if (nPos < 0)
                continue;
            
            nPos += nStart;
            [self.ayTrendInfo addObject:[NSString stringWithFormat:@"%d", nPos]];
        }
    }
    
    strBase = [parse GetByName:@"Grid"];
    NSData* DataGrid = [NSData tztdataFromBase64String:strBase];
    
    if(DataGrid && [DataGrid length] > 0)
    {
        if([DataGrid length] / sizeof(TNewTrendData) == nDataCount
           && [DataGrid length] % sizeof(TNewTrendData) == 0)
        {
            NSString* strBase = [parse GetByName:@"Lead"];
            NSData* dataLead = [NSData tztdataFromBase64String:strBase];
            int* Lead = NULL;
            if(dataLead && [dataLead length] > 0)
            {
                Lead = (int *)[dataLead bytes];
                TZTNSLog(@"Lead = %d / %ld",*Lead,[dataLead length] / sizeof(int));
            }
            
            //Lead	String	数据流	领先指标，整型数组流。
            //Lead : array of  integer
            NSString* strBaseChiCangL = [parse GetByName:@"ChiCangL"];
            NSData* dataChiCangL = [NSData tztdataFromBase64String:strBaseChiCangL];
            int* ChiCangL = NULL;
            if(dataChiCangL && [dataChiCangL length] > 0)
            {
                ChiCangL = (int *)[dataChiCangL bytes];
                TZTNSLog(@"ChiCangL = %d / %ld",*ChiCangL,[dataChiCangL length] / sizeof(int));
            }
            
            
            NSData* Databindata = [parse GetNSData:@"BinData"];
            if(Databindata && [Databindata length] > 0)
            {
                NSString* strBaseBinData = [parse GetByName:@"BinData"];
                setTNewTrendHead(self.TrendHead,strBaseBinData);
                if( self.TrendHead->nClear)
                {
                    [self.ayTrendValues removeAllObjects];
                }
                int32_t ntrendMinPrice = self.TrendHead->nMinPrice;
                int nAddTrendValues = nDataCount;//返回数据数
                
                //超过最大数据数，清除原多余数据 （是否应该清空原数据？）
                NSInteger nHaveCount = [self.ayTrendValues count];
                for (NSInteger i = nStart;  i < nHaveCount; i++)
                {
                    [self.ayTrendValues removeLastObject];
                }
                
                if([self.ayTrendValues count] == 0)
                {
                    self.nMaxVol = 0;
                    self.nMaxChiCangL = 0;
                    self.nMinChiCangL = INT32_MAX;
                    bClearAll = TRUE;
                }
                
                for (NSInteger i = 0; i < nAddTrendValues; i++)
                {
                    tztTrendValue* trendvalue = NewObject(tztTrendValue);
                    [self.ayTrendValues addObject:trendvalue];
                    [trendvalue release];
                }
                TNewTrendData* trendData = (TNewTrendData*)[DataGrid bytes];
                for (NSInteger i = [self.ayTrendValues count] - nDataCount; i < [self.ayTrendValues count]; i++,trendData++)
                {
                    tztTrendValue* trendvalue = [self.ayTrendValues objectAtIndex:i];
                    if(trendvalue && trendData)
                    {
                        trendvalue.ulClosePrice = trendData->nClosePrice + ntrendMinPrice;
                        trendvalue.ulAvgPrice = trendData->nAvgPrice + ntrendMinPrice;
                        trendvalue.nTotal_h = trendData->nTotal_h;
                        if(trendvalue.nTotal_h > self.nMaxVol)
                            self.nMaxVol = trendvalue.nTotal_h;
                        if(Lead)
                        {
                            trendvalue.nLead = *Lead;
                            Lead++;
                        }
                        if(ChiCangL)
                        {
                            trendvalue.nChiCangL = *ChiCangL;
                            if(trendvalue.nChiCangL > self.nMaxChiCangL)
                                self.nMaxChiCangL = trendvalue.nChiCangL;
                            if(trendvalue.nChiCangL < self.nMinChiCangL)
                                self.nMinChiCangL = trendvalue.nChiCangL;
                            ChiCangL++;
                        }
                    }
                }
                //Grid	String		分时数据，结构体TFSZS数组数据流，每条记录代表1分钟的数据。
                //TFSZS = packed record
                //Last_p: word; //最新价
                //averprice: word; //均价
                //total_h: integer; //分钟成交量
                //end;
            }
            //bindata	String		股票数据，只有一条记录，是结构体TFSZSHead数据流。
            //TFSZSHead = packed record
            //StockName: array[0..15] of char; //股票名称
            //Close_p: longint; //昨收盘价
            //Open_p: longint; //开盘价
            //total_size: byte; //小数点位数
            //Units: byte; //单位   10的倍数 1表示需要乘10 2表示要乘100
            //Consult: longint; //参考值  取最小值
            //end;
        }
    }
    
    NSString* dataBeginDate = [parse GetValueData:@"BeginDate"];
    if(dataBeginDate && [dataBeginDate length] > 0)
    {
        self.trendTimes =  dataBeginDate;
        TZTNSLog(@"BeginDate = %@",self.trendTimes);
    }
    
    NSString* strBaseData = [parse GetByName:@"WTAccount"];
    if(strBaseData && [strBaseData length] > 0)
    {
        setTNewPriceData(self.PriceData, strBaseData);
        [_tztPriceView setPriceData:self.PriceData len:sizeof(TNewPriceData)];
    }
    
    NSString* strAnswerno = [parse GetByName:@"AnswerNo"];
    if (strAnswerno && [strAnswerno length] > 0)
    {
        setTNewPriceDataEx(self.PriceDataEx, strAnswerno);
        [_tztPriceView setPriceDataEx:self.PriceDataEx len:sizeof(TNewPriceDataEx)];
    }
    
    self.pBtnNoRights.hidden = !MakeHKMarketStock(self.pStockInfo.stockType);
    //华泰港股通专用
#ifdef Support_HKTrade
    tztZJAccountInfo *pZJAccount = tztGetCurrentAccountHKRight();
    _nRightsType = 0;
    if (pZJAccount)
    {
        NSString* strAccount = [parse GetByName:@"Account"];
        if (strAccount && [strAccount caseInsensitiveCompare:self.nsAccount] == NSOrderedSame)
        {
            NSString* strGgtRight = [parse GetByName:@"Ggt_rights"];
            if (strGgtRight && strGgtRight.length > 0)
                pZJAccount.Ggt_rights = [NSString stringWithFormat:@"%@", strGgtRight];
            else
                pZJAccount.Ggt_rights = @"";
            
            NSString* strGgtRightEndDate = [parse GetByName:@"Ggt_rightsEndDate"];
            if (strGgtRightEndDate && strGgtRightEndDate.length > 0)
                pZJAccount.Ggt_rightsEndDate = [NSString stringWithFormat:@"%@", strGgtRightEndDate];
            else
                pZJAccount.Ggt_rightsEndDate = @"";
            
            tztSaveCurrentHKRight(pZJAccount);
            
            //判断显示
            if (strGgtRight && strGgtRight.length > 0)//有股东账号
            {
                if ([strGgtRight intValue] > 0)//
                {
                    if (pZJAccount.nLogVolume < 1)//有权限，是被踢掉了，提示要变，否则就是没权限，直接提示升级
                    {
                        _nRightsType = 1;
                        _pBtnNoRights.hidden = NO;
                    }
                    else
                    {
                        _pBtnNoRights.hidden = YES;
                    }
                }
                else
                {
                    _nRightsType = 0;
                    _pBtnNoRights.hidden = NO;
                }
            }
        }
    }
    
#endif
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:setTitleStatus:andStockType_:)])
    {
        int nType = 0x0000;
        if (self.PriceData->c_IsGgt == '1')
        {
            BOOL bCanBuy = (self.PriceData->c_CanBuy == '1');
            BOOL bCanSell = (self.PriceData->c_CanSell == '1');
            
            if (bCanBuy && bCanSell)
                nType = 0x0011;
            else if (bCanBuy)
                nType = 0x0001;
            else if (bCanSell)
                nType = 0x0010;
            else
                nType = 0;
            
        }
        if (self.PriceData->c_RQBD == '1')
        {
            nType |= 0x1000;
        }
        if (self.PriceData->c_RZBD == '1')
        {
            nType |= 0x0100;
        }
        [self.tztdelegate tztHqView:self setTitleStatus:nType andStockType_:self.pStockInfo.stockType];
    }
    
    NSString* strStockName = [NSString stringWithFormat:@"%@",self.pStockInfo.stockName];
    if(!bRead)
    {
        NSString* nsStockName = getName_TNewPriceData(self.PriceData);
        nsStockName = [nsStockName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (nsStockName && nsStockName.length > 0)
            self.pStockInfo.stockName = [NSString stringWithFormat:@"%@", nsStockName];
    }
    
    if (self.pStockInfo.stockName && [self.pStockInfo.stockName length] > 0)
    {
        if([self.pStockInfo.stockName compare:strStockName] != NSOrderedSame)
            [self setStockInfo:self.pStockInfo];
    }
    
    [self CalculateValue];//计算数据
    [self setNeedsDisplay];
    if (_tztPriceView)
    {
        self.tztPriceView.hidden = self.bHide;
        if(!self.bHide)
        {
            [self.tztPriceView setNeedsDisplay];
        }
    }
    
    
    //通知delegate，更新界面显示数据
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(UpdateData:)])
    {
        [self.tztdelegate UpdateData:self];
    }
    
    //外汇每次都更新 所以不保存 保存本地数据 yangdl 20130812
    if (!MakeWHMarket(self.pStockInfo.stockType) && (!bRead) && bClearAll)
    {
        if([tztReqno getReqdefOne] > 0)//非历史分时
        {
            dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
            dispatch_async (FileWriteQueue,^
                            {
                                NSString* strPath = [self getTrendPath];
                                [parse WriteParse:strPath];
                            }
                            );
            dispatch_release(FileWriteQueue);
        }
    }
    return 1;
}

- (NSString*)getstrTimeofPos:(NSInteger)nPos
{
    int nDayCount = self.nMaxCount / abs(self.nDays);
    nPos = (nPos % nDayCount);
    
    NSArray* ay = [self.trendTimes componentsSeparatedByString:@"|"];
    long nCount = 0;
    long nPreCount = 0;
    if(ay && [ay count] > 0)
    {
        for (int i = 0; i < [ay count]  / 2 && nCount <= self.nMaxCount ; i++)
        {
            NSString* strBegin = [ay objectAtIndex:(i*2+0)];
            long lbegintime = [self getTimeData:strBegin];
            NSString* strEnd = [ay objectAtIndex:(i*2+1)];
            long lendtime = [self getTimeData:strEnd];
            if(lendtime > lbegintime)
            {
                nCount += (lendtime-lbegintime);
            }
            else //跨越24点
            {
                nCount += (24*60 - lbegintime) + lendtime;
            }
            if(nPos <= nCount)
            {
                NSInteger nPosTime = lbegintime+nPos - nPreCount;
                return [NSString stringWithFormat:@"%02d:%02d", (int)(nPosTime/60), (int)(nPosTime % 60)];
            }
            nPreCount = nCount;
        }
    }
    return @"";
}

//绘制底图
- (BOOL)drawBackGround:(CGContextRef)context rect:(CGRect)rect
{
    UIColor* backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    UIColor* gridColor = [UIColor tztThemeHQGridColor];
    UIFont* drawfont = NULL;
    drawfont = [tztTechSetting getInstance].drawTxtFont;
    
    long lMaxValue = GetMaxDiff(self.TrendHead->nPreClosePrice,self.TrendHead->nMaxPrice,self.TrendHead->nMinPrice);
    NSString* strValue = @"";
    if(self.bPercent)
        strValue = [self getDiffPercent:-lMaxValue*100.0f maxdiff:self.TrendHead->nPreClosePrice];
    else
        strValue = [self getValueString:self.TrendHead->nPreClosePrice + lMaxValue];
    
    CGSize drawsize = [strValue sizeWithFont:drawfont];
    self.fYAxisWidth = MAX(drawsize.width + 1,self.fYAxisWidth);
    strValue = NStringOfULong(self.nMaxVol);
    drawsize = [strValue sizeWithFont:drawfont];
    self.fYAxisWidth = MAX(self.fYAxisWidth, drawsize.width + 1);
    
    if (self.bShowLeftPriceInSide)
        self.fYAxisWidth = 0;
    
    self.TrendDrawRect = CGRectInset(rect,self.fYAxisWidth,2);
    CGRect rc1 = self.TrendDrawRect;
    rc1.size.width += self.fYAxisWidth;
    self.TrendDrawRect = rc1;
    CGFloat fHideWidth = 0;
    if(!self.bHide)
    {
        fHideWidth = (rect.size.width) * 0.35f;
        if (self.nPriceViewWidth > 0)
        {
            fHideWidth = self.nPriceViewWidth;
        }
        if(IS_TZTIPAD)
        {
            fHideWidth = MIN(fHideWidth, 200);
        }
        CGRect rc = self.TrendDrawRect;
        rc.size.width -= fHideWidth;
        self.TrendDrawRect = rc;
    }
    
    CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextSetLineWidth(context, .5f);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    CGContextStrokePath(context);
    
    if (!self.bHideFundFlows)
    {
        self.FundFlowsRect = CGRectZero;
        CGRect rc = self.FundFlowsRect;
        rc.size.height = self.TrendDrawRect.size.height * 1 / 3;
        rc.origin.y = self.TrendDrawRect.origin.y + self.TrendDrawRect.size.height - rc.size.height;
        rc.size.width = self.TrendDrawRect.size.width + self.TrendDrawRect.origin.x;
        rc.size.height -= tztParamHeight;
        
        self.FundFlowsRect = rc;
    }
    
    if (!self.bHideVolume)
    {
        self.VolDrawRect = self.TrendDrawRect;
        CGRect rcTrendDrawRect = self.TrendDrawRect;
        CGRect rc = self.TrendDrawRect;
        
        rc.size.height = rc.size.height * 1 / 3;
        rcTrendDrawRect.size.height -= rc.size.height;
        self.TrendDrawRect = rcTrendDrawRect;
        
        rc.origin.y += self.TrendDrawRect.size.height;
        self.VolDrawRect = rc;
        
        self.VolParamRect = self.VolDrawRect;
        CGRect rc1 = self.VolParamRect;
        rc1.size.height = tztParamHeight;
        self.VolParamRect = rc1;
        
        rc = self.VolDrawRect;
        
        if (self.bHiddenTime)
        {
        }
        else
        {
            rc.origin.y += tztParamHeight;
            rc.size.height -= (tztParamHeight + tztParamHeight / 2);
        }
        self.VolDrawRect = rc;
    }
    else
    {
        CGRect rc1 = self.TrendDrawRect;
        rc1.size.height -= tztParamHeight;
        self.TrendDrawRect = rc1;
        
        CGRect rc = self.TrendDrawRect;
        rc.origin.y += self.TrendDrawRect.size.height;
        rc.size.height = 0;
        self.VolDrawRect = rc;
    }
    
    if (self.tztFundFlows && !self.tztFundFlows.hidden)
    {
        self.tztFundFlows.frame = self.FundFlowsRect;
        [self.tztFundFlows setNeedsDisplay];
    }
    
    self.tztPriceView.hidden = self.bHide;
    self.PriceDrawRect = CGRectZero;
    if(!self.bHide)
    {
        CGRect rc = self.TrendDrawRect;
        rc.size.width = fHideWidth - 2;
        rc.origin.x += self.TrendDrawRect.size.width + 1;
        rc.size.height = CGRectGetMaxY(self.VolDrawRect)-self.PriceDrawRect.origin.y;
        self.PriceDrawRect = rc;
        [self.tztPriceView setFrame:self.PriceDrawRect];
        
        [self.tztPriceView setNeedsDisplay];
        
        CGRect rcEx = self.PriceDrawRect;
        rcEx.origin.y += rcEx.size.height + 3;
        rcEx.size.height = self.frame.size.height - CGRectGetHeight(self.PriceDrawRect);
        self.pBtnDetail.frame = rcEx;
        self.pBtnNoRights.frame = rcEx;
    }
    //绘制竖线
    static CGFloat dashLengths[3] = {3, 3, 2};
    CGPoint drawpoint = self.TrendDrawRect.origin;
    
    CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(self.TrendDrawRect));
    CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(self.TrendDrawRect));
    
    CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(self.VolDrawRect));
    CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(self.VolDrawRect));
    
    
    CGContextMoveToPoint(context, drawpoint.x + CGRectGetMaxX(self.TrendDrawRect), CGRectGetMinY(self.TrendDrawRect));
    CGContextAddLineToPoint(context, drawpoint.x + CGRectGetMaxX(self.TrendDrawRect), CGRectGetMaxY(self.TrendDrawRect));
    
    CGContextMoveToPoint(context, drawpoint.x + CGRectGetMaxX(self.VolDrawRect), CGRectGetMinY(self.VolDrawRect));
    CGContextAddLineToPoint(context, drawpoint.x + CGRectGetMaxX(self.VolDrawRect), CGRectGetMaxY(self.VolDrawRect));
    
    CGContextStrokePath(context);
    
    /*计算位置*/
    NSArray* ay = [self.trendEndDate componentsSeparatedByString:@"|"];
    CGFloat fDiffWidth = CGRectGetWidth(self.TrendDrawRect)/(self.nMaxCount-1);
    int nDayCount = self.nMaxCount / abs(self.nDays);
    long nCount = nDayCount;
    
    for (int i = 0; i < [ay count] && nCount <= self.nMaxCount ; i++)
    {
        CGPoint drawpoint = self.VolDrawRect.origin;
        drawpoint.y = CGRectGetMaxY(self.VolDrawRect);
        drawpoint.x = CGRectGetMinX(self.VolDrawRect) + (fDiffWidth*nCount);
        
        CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(self.TrendDrawRect));
        CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(self.TrendDrawRect));
        
        CGContextMoveToPoint(context, drawpoint.x, CGRectGetMinY(self.VolDrawRect));
        CGContextAddLineToPoint(context, drawpoint.x, CGRectGetMaxY(self.VolDrawRect));
        CGContextStrokePath(context);
        
        nCount += nDayCount;
    }
    
    for (int i = 0; i < 5; i++)
    {
        //绘制横线
        if (i == 2)
        {
            CGContextSaveGState(context);
            CGContextSetLineDash(context, 0.0, dashLengths, 2);
            
            CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
            CGContextMoveToPoint(context, CGRectGetMinX(self.TrendDrawRect),drawpoint.y);
            CGContextAddLineToPoint(context, CGRectGetMaxX(self.TrendDrawRect), drawpoint.y);
            
            CGContextStrokePath(context);
            CGContextRestoreGState(context);
        }
        else
            CGContextSetStrokeColorWithColor(context, gridColor.CGColor);
        
        CGContextMoveToPoint(context, CGRectGetMinX(self.TrendDrawRect),drawpoint.y);
        CGContextAddLineToPoint(context, CGRectGetMaxX(self.TrendDrawRect), drawpoint.y);
        CGContextStrokePath(context);
        drawpoint.y += CGRectGetHeight(self.TrendDrawRect) / 4;
    }
    
    CGContextMoveToPoint(context, CGRectGetMinX(self.VolDrawRect), CGRectGetMinY(self.VolDrawRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.VolDrawRect), CGRectGetMinY(self.VolDrawRect));
    
    CGContextMoveToPoint(context, CGRectGetMinX(self.VolDrawRect), CGRectGetMidY(self.VolDrawRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.VolDrawRect), CGRectGetMidY(self.VolDrawRect));
    
    CGContextMoveToPoint(context, CGRectGetMinX(self.VolDrawRect), CGRectGetMaxY(self.VolDrawRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.VolDrawRect), CGRectGetMaxY(self.VolDrawRect));
    CGContextStrokePath(context);
    
    return TRUE;
}

//绘制坐标
- (void)onDrawXAxis:(CGContextRef)context
{
//    if (self.bHiddenTime)
//        return;
    
    NSArray* ay = [self.trendEndDate componentsSeparatedByString:@"|"];
    long nCount = 0;
    int nDayCount = self.nMaxCount / abs(self.nDays);
    CGFloat fDiffWidth = CGRectGetWidth(self.VolDrawRect)/(self.nMaxCount-1);
    if(ay && [ay count] > 0)
    {
        UIFont* drawFont = NULL;
        drawFont = [tztTechSetting getInstance].drawTxtFont;
        
        UIColor* AxisColor = [UIColor tztThemeHQFixTextColor];//[tztTechSetting getInstance].axisTxtColor;
        if ([self.nsBackColor intValue])
            AxisColor = [UIColor tztThemeHQFixTextColor];
        
        CGContextSetFillColorWithColor(context, AxisColor.CGColor);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        for (int i = 0; i < [ay count] && nCount <= self.nMaxCount ; i++)
        {
            NSString* strBegin = [ay objectAtIndex:i];
            CGPoint drawpoint = self.VolDrawRect.origin;
            drawpoint.y = CGRectGetMaxY(self.VolDrawRect);
            drawpoint.x = CGRectGetMinX(self.VolDrawRect) + (fDiffWidth*nCount);
            CGRect rcDraw = CGRectMake(drawpoint.x, drawpoint.y, (fDiffWidth*nDayCount), tztParamHeight);
            
            [strBegin drawInRect:rcDraw withFont:drawFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            nCount += nDayCount;
        }
    }
}

//- (void)onDrawTips:(CGRect)rect
//{
//    NSInteger nMaxData = [self.ayTrendValues count];
//    
//    if(nMaxData > 0 && self.TrendHead->nPreClosePrice != 0)
//    {
//        UIFont* drawfont = [tztTechSetting getInstance].drawTxtFont;
//        CGSize drawsize = CGSizeZero;
//        CGSize valuesize = CGSizeZero;
//        if(self.TrendCurIndex < 0)
//            self.TrendCurIndex = 0;
//        
//        if(self.TrendCurIndex >= nMaxData)
//            self.TrendCurIndex = nMaxData - 1;
//        tztTrendValue* trendValue = [self.ayTrendValues objectAtIndex:_TrendCurIndex];
//        
//        //时间
//        NSString* strTime = [self getstrTimeofPos:_TrendCurIndex];
//        //最新
//        NSString* strNewPrice = [self getValueString:trendValue.ulClosePrice];
//        //均价
//        NSString* strAvgPrice = [self getValueString:trendValue.ulAvgPrice];
//        //昨收
//        NSString* strPreClose = [self getValueString:_TrendHead->nPreClosePrice];
//        //涨跌
//        NSString* strRatio = [self getValueString:(trendValue.ulClosePrice-_TrendHead->nPreClosePrice)];
//        //幅度
//        NSString* strRange = [NSString stringWithFormat:@"%.2f%%",((long)trendValue.ulClosePrice - _TrendHead->nPreClosePrice) * 100.0 /(long)_TrendHead->nPreClosePrice ];
//        //最高
//        NSString* strMaxPrice = [self getValueString:_TrendHead->nMaxPrice];
//        //最低
//        NSString* strMinPrice = [self getValueString:_TrendHead->nMinPrice];
//        //现手
//        NSString* strNowHand = NStringOfULong(trendValue.nTotal_h);
//        
//        if (!_bShowTips)
//        {
//            if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:SetCursorData:)])
//            {
//                //组织数据
//                NSMutableDictionary *dict = NewObject(NSMutableDictionary);
//                [dict setTztObject:strTime forKey:tztTime];
//                [dict setTztObject:strNewPrice forKey:tztNewPrice];
//                [dict setTztObject:strAvgPrice forKey:tztAveragePrice];
//                [dict setTztObject:strPreClose forKey:tztYesTodayPrice];
//                [dict setTztObject:strRatio forKey:tztUpDown];
//                [dict setTztObject:strRange forKey:tztPriceRange];
//                [dict setTztObject:strMaxPrice forKey:tztMaxPrice];
//                [dict setTztObject:strMinPrice forKey:tztMinPrice];
//                [dict setTztObject:strNowHand forKey:tztNowVolume];
//                [self.tztdelegate tztHqView:self SetCursorData:dict];
//                [dict release];
//            }
//            return;
//        }
//        
//        NSString* strValue =  @"新 99999.999";
//        valuesize = [strValue sizeWithFont:drawfont];
//        valuesize.height = (CGRectGetHeight(_TrendDrawRect) - 10 * 2) / 9;
//        if (valuesize.height > 20)
//            valuesize.height = 20;
//        
//        float nLineHeight = valuesize.height;
//        
//        CGRect TipRect = _TrendDrawRect;
//        TipRect.origin.x = rect.origin.x;
//        if (_TrendCursor.x <= CGRectGetMidX(_TrendDrawRect))
//        {
//            TipRect.origin.x = CGRectGetMaxX(_TrendDrawRect) - valuesize.width - 2 ;
//        }
//        TipRect.origin.y = _TrendDrawRect.origin.y ;
//        
//        UIColor* FixtxtColor = [UIColor tztThemeHQFixTextColor];
//        UIColor* AxisColor = [UIColor tztThemeHQAxisTextColor];
//        
//        UIColor* upColor = [UIColor tztThemeHQUpColor];
//        UIColor* downColor = [UIColor tztThemeHQDownColor];
//        UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
//        
//        UIColor* tipbackColor = [UIColor tztThemeHQTipBackColor];
//        UIColor* tipGridColor = [UIColor tztThemeHQHideGridColor];
//        
//        //        if ([self.nsBackColor intValue])
//        //        {
//        //            FixtxtColor = [UIColor blackColor];
//        //            balanceColor = [UIColor blackColor];
//        //            tipbackColor = [UIColor whiteColor];
//        //            tipGridColor = [UIColor grayColor];
//        //        }
//        
//        CGPoint drawpoint = TipRect.origin;
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        CGContextSetTextDrawingMode(context, kCGTextFill);
//        
//        TipRect.size.width = valuesize.width + 2;
//        TipRect.size.height = (valuesize.height + 2) * 9 + 2;
//        if (TipRect.size.width > _TrendDrawRect.size.width / 2)
//        {
//            TipRect.size.width = _TrendDrawRect.size.width / 2;
//            if (_TrendCursor.x <= CGRectGetMidX(_TrendDrawRect))
//            {
//                TipRect.origin.x = CGRectGetMaxX(_TrendDrawRect) - TipRect.size.width;
//            }
//        }
//        
//        CGContextSaveGState(context);
//        CGContextSetAlpha(context, 0.9);
//        CGContextSetStrokeColorWithColor(context, tipGridColor.CGColor);
//        CGContextSetFillColorWithColor(context, tipbackColor.CGColor);
//        CGContextAddRect(context, TipRect);
//        CGContextDrawPath(context, kCGPathFillStroke);
//        CGContextStrokePath(context);
//        CGContextRestoreGState(context);
//        
//        valuesize = [strTime sizeWithFont:drawfont];
//        drawpoint.x = CGRectGetMinX(TipRect)+1;
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        drawsize = [@"时" drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
//        drawpoint.y += 2;
//        CGContextSetFillColorWithColor(context, AxisColor.CGColor);
//        [strTime drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
//        
//        UIColor* drawColor = balanceColor;
//        if (trendValue.ulClosePrice > _TrendHead->nPreClosePrice)
//        {
//            drawColor = upColor;
//        }
//        else if (trendValue.ulClosePrice < _TrendHead->nPreClosePrice)
//        {
//            drawColor = downColor;
//        }
//        
//        valuesize = [strNewPrice sizeWithFont:drawfont];
//        drawpoint.x = CGRectGetMinX(TipRect)+1;
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        drawsize = [@"新" drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
//        CGContextSetFillColorWithColor(context, drawColor.CGColor);
//        [strNewPrice drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
//        
//        drawColor = balanceColor;
//        if (trendValue.ulAvgPrice > _TrendHead->nPreClosePrice)
//        {
//            drawColor = upColor;
//        }
//        else if (trendValue.ulAvgPrice < _TrendHead->nPreClosePrice)
//        {
//            drawColor = downColor;
//        }
//        valuesize = [strAvgPrice sizeWithFont:drawfont];
//        drawpoint.x = CGRectGetMinX(TipRect)+1;
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        drawsize = [@"均" drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
//        CGContextSetFillColorWithColor(context, drawColor.CGColor);
//        [strAvgPrice drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
//        
//        valuesize = [strPreClose sizeWithFont:drawfont];
//        drawpoint.x = CGRectGetMinX(TipRect)+1;
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        drawsize = [@"昨" drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
//        CGContextSetFillColorWithColor(context, balanceColor.CGColor);
//        [strPreClose drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
//        
//        
//        drawColor = balanceColor;
//        if (trendValue.ulClosePrice > _TrendHead->nPreClosePrice)
//        {
//            drawColor = upColor;
//        }
//        else if (trendValue.ulClosePrice < _TrendHead->nPreClosePrice)
//        {
//            drawColor = downColor;
//        }
//        
//        valuesize = [strRatio sizeWithFont:drawfont];
//        drawpoint.x = CGRectGetMinX(TipRect)+1;
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        drawsize = [@"涨" drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
//        CGContextSetFillColorWithColor(context, drawColor.CGColor);
//        [strRatio drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
//        
//        valuesize = [strRange sizeWithFont:drawfont];
//        drawpoint.x = CGRectGetMinX(TipRect)+1;
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        drawsize = [@"幅" drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
//        CGContextSetFillColorWithColor(context, drawColor.CGColor);
//        [strRange drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
//        
//        drawColor = balanceColor;
//        if (_TrendHead->nMaxPrice > _TrendHead->nPreClosePrice)
//        {
//            drawColor = upColor;
//        }
//        else if (_TrendHead->nMaxPrice < _TrendHead->nPreClosePrice)
//        {
//            drawColor = downColor;
//        }
//        
//        valuesize = [strMaxPrice sizeWithFont:drawfont];
//        drawpoint.x = CGRectGetMinX(TipRect)+1;
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        drawsize = [@"高" drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
//        CGContextSetFillColorWithColor(context, drawColor.CGColor);
//        [strMaxPrice drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
//        
//        
//        drawColor = balanceColor;
//        if (_TrendHead->nMinPrice > _TrendHead->nPreClosePrice)
//        {
//            drawColor = upColor;
//        }
//        else if (_TrendHead->nMinPrice < _TrendHead->nPreClosePrice)
//        {
//            drawColor = downColor;
//        }
//        
//        valuesize = [strMinPrice sizeWithFont:drawfont];
//        drawpoint.x = CGRectGetMinX(TipRect)+1;
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        drawsize = [@"低" drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
//        CGContextSetFillColorWithColor(context, drawColor.CGColor);
//        [strMinPrice drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
//        
//        valuesize = [strNowHand sizeWithFont:drawfont];
//        drawpoint.x = CGRectGetMinX(TipRect)+1;
//        CGContextSetFillColorWithColor(context, FixtxtColor.CGColor);
//        drawsize = [@"现" drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.x = CGRectGetMaxX(TipRect) - valuesize.width - 1;
//        CGContextSetFillColorWithColor(context, balanceColor.CGColor);
//        [strNowHand drawAtPoint:drawpoint withFont:drawfont];
//        drawpoint.y += /*drawsize.height*/nLineHeight + 2;
//    }
//}

//读取本地数据并刷新
- (void)readParse
{
    if (!MakeWHMarket(self.pStockInfo.stockType))
    {
        dispatch_queue_t FileWriteQueue = dispatch_queue_create("filewrite", NULL);
        dispatch_async (FileWriteQueue,^
                        {
                            NSString* strPath = [self getTrendPath];
                            tztNewMSParse* parse = NewObject(tztNewMSParse);
                            [parse ReadParse:strPath];
                            dispatch_block_t block = ^{ @autoreleasepool {
                                [self dealParse:parse IsRead:TRUE];
                            }};
                            if (dispatch_get_current_queue() == dispatch_get_main_queue())
                                block();
                            else
                                dispatch_sync(dispatch_get_main_queue(), block);
                            [parse release];
                        }
                        );
        dispatch_release(FileWriteQueue);
    }
}


//获取文件路径
- (NSString *)getTrendPath
{
    return [NSString stringWithFormat:@"%@/%@/%d/%@_%d.data",NSHomeDirectory(),TZTTrendFivePath, self.nDays,self.pStockInfo.stockCode,self.pStockInfo.stockType];
}
@end
