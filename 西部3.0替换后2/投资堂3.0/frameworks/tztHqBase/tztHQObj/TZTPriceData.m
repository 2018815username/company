//
//  TZTPriceData.m
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 3/31/14.
//
//

/*
 修改返回字典数据，增加颜色值，所有相应从该处取数据的地方都要做相应修改
 by yinjp 20140811
 */

#import "TZTPriceData.h"

#define tztPriceColorCompare(x,y) ((x > y) ? [UIColor tztThemeHQUpColor] : ((x < y) ? [UIColor tztThemeHQDownColor] : [UIColor tztThemeHQBalanceColor]))

NSMutableDictionary *stockDic; // 个股详情字典

@implementation TZTPriceData

//@synthesize stockDic = _stockDic;

+ (NSMutableDictionary *)stockDic
{
    if (stockDic == nil) {
        stockDic = [[NSMutableDictionary alloc] init];
    }
    return stockDic;
}

+ (void)setStockDic:(NSMutableDictionary *)dic
{
    if (!stockDic) {
        [stockDic release];
    }
    
    stockDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
}

+ (void)dealWithIndexPrice:(TNewPriceData*)pNewPriceData pDict_:(NSMutableDictionary*)pReturnDict
{
    if (pNewPriceData == NULL || pReturnDict == NULL)
        return;
    
    UIColor *pBalanceColor = [UIColor tztThemeHQBalanceColor];
    //股票代码
    NSString* nsCode = [[[NSString alloc] initWithBytes:pNewPriceData->Code
                                                 length:sizeof(pNewPriceData->Code)
                                               encoding:NSASCIIStringEncoding] autorelease];
    
    if(nsCode == NULL)
        nsCode = @"-";
    NSMutableDictionary *pDictCode = GetDictWithValue(nsCode, 0, 0);
    [pReturnDict setObject:pDictCode forKey:tztCode];
    
    //股票名称
    NSString* nsName = getName_TNewPriceData(pNewPriceData);;
    if (nsName == NULL)
        nsName = @"--";
    NSMutableDictionary *pDictName = GetDictWithValue(nsName, 0, 0);
    [pReturnDict setObject:pDictName forKey:tztName];
    
    //昨收
    NSString* nsPreClose = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Close_p,0,pNewPriceData->nDecimal,1000);
    if (nsPreClose == NULL)
        nsPreClose = @"-.-%";
    
    NSMutableDictionary *pDictClose = GetDictWithValue(nsPreClose, 0, 0);
    [pReturnDict setObject:pDictClose forKey:tztYesTodayPrice];
    
    //开盘
    NSString* nsOpenPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Open_p,0,pNewPriceData->nDecimal,1000);
    if (nsOpenPrice == NULL)
        nsOpenPrice = @"";
    
    NSMutableDictionary* pDictOpen = GetDictWithValue(nsOpenPrice, pNewPriceData->Open_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictOpen forKey:tztStartPrice];
    
    //最新
    NSString* nsNewPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Last_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     1000);
    if (nsNewPrice)
    {
        NSMutableDictionary *pDictNew = GetDictWithValue(nsNewPrice, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictNew forKey:tztNewPrice];
    }
    
    
    //最高
    NSString* nsMaxPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->High_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     1000);
    if (nsMaxPrice)
    {
        NSMutableDictionary *pDictMax = GetDictWithValue(nsMaxPrice, pNewPriceData->High_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictMax forKey:tztMaxPrice];
    }
    
    //最低
    NSString* nsMinPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Low_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     1000);
    if (nsMinPrice)
    {
        NSMutableDictionary *pDictMin = GetDictWithValue(nsMinPrice, pNewPriceData->Low_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictMin forKey:tztMinPrice];
    }
    
    
    //时间
    NSString* nsTime = [NSString stringWithFormat:@"%02d:%02d", pNewPriceData->nHour, pNewPriceData->nMin];
    if (nsTime == NULL)
        nsTime = @"-:-";
    NSMutableDictionary *pDictTime = GetDictWithValue(nsTime, 0, 0);
    [pReturnDict setObject:pDictTime forKey:tztTime];
    
    //涨跌
    NSString* nsRatio = NSStringOfVal_Ref_Dec_Div((pNewPriceData->Last_p > 0) ? (pNewPriceData->Last_p - pNewPriceData->Close_p) : 0 ,0,pNewPriceData->nDecimal,1000);
    if (nsRatio == NULL)
        nsRatio = @"-.-";
    NSMutableDictionary *pDictRatio = GetDictWithValue(nsRatio, pNewPriceData->Last_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictRatio forKey:tztUpDown];
    
    
    //涨跌幅
    NSString* nsPriceRange = @"-";
    if(pNewPriceData->Close_p != 0)
        nsPriceRange = [NSString stringWithFormat:@"%.2f%%",((pNewPriceData->Last_p > 0) ? (pNewPriceData->Last_p - pNewPriceData->Close_p) : 0) * 100.f / pNewPriceData->Close_p];
    if (nsPriceRange)
    {
        NSMutableDictionary * pDictRange = GetDictWithValue(nsPriceRange, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictRange forKey:tztPriceRange];
    }
    
    //振幅
    NSString* nsZF = [NSString stringWithFormat:@"%.2f%%",pNewPriceData->m_lMaxUpIndex / 100.f];
    if (nsZF ==  NULL)
        nsZF = @"-.-%";
    
    NSMutableDictionary *pDictZF = GetDictWithValue(nsZF, 1, 0);
    [pReturnDict setObject:pDictZF forKey:tztVibrationAmplitude];
    
    
    //量比
    NSString* nsLB = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_lLiangbi, 0, 2, 100);//
    if (nsLB == NULL || [nsLB length] < 1)
        nsLB = @"-";
    NSMutableDictionary *pDictLB = GetDictWithValue(nsLB, 0, 0);
    [pReturnDict setObject:pDictLB forKey:tztVolumeRatio];
    
    //换手
    NSString* nsHuanShow = [NSString stringWithFormat:@"%.2f%%",pNewPriceData->nHuanshoulv / 100.f];
    if (nsHuanShow == NULL || [nsHuanShow length] < 1)
        nsHuanShow = @"-.-%";
    NSMutableDictionary *pDcitHuanShou = GetDictWithValue(nsHuanShow, 0, 0);
    [pReturnDict setObject:pDcitHuanShou forKey:tztHuanShou];
    
    //均价
    NSString* nsAvgPrice =  NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_lAvgPrice,0,pNewPriceData->nDecimal,1000);
    if (nsAvgPrice == NULL || [nsAvgPrice length] < 1)
        nsAvgPrice = @"-.-";
    NSMutableDictionary *pDictAvg = GetDictWithValue(nsAvgPrice, pNewPriceData->m_lAvgPrice, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictAvg forKey:tztAveragePrice];
    
    
    //成交额
    NSString* nsTotalMoney =  NStringOfFloat(pNewPriceData->Total_m * 100);
    if (nsTotalMoney == NULL)
        nsTotalMoney = @"--";
    NSMutableDictionary *pDictTotalM = GetDictWithValue(nsTotalMoney, 0, 0);
    [pReturnDict setObject:pDictTotalM forKey:tztTransactionAmount];
    
    //成交量
    NSString* nsTotal_h = NStringOfULong(pNewPriceData->Total_h);
    
    if (nsTotal_h == NULL)
        nsTotal_h = @"--";
    NSMutableDictionary *pDictTotalH = GetDictWithValue(nsTotal_h, 0, 0);
    [pReturnDict setObject:pDictTotalH forKey:tztTradingVolume];
    
    UIColor *pColor = pBalanceColor;
    //委比
    long BuyCount = pNewPriceData->a.indexData.buy_h;
    
    long SellCount = pNewPriceData->a.indexData.sale_h;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
//    long lBi= 0;
    int nFlag = 0;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
//        if ( lWeiBi> 0 )
//        {
//            nFlag = 1;
//            lBi = (long)(lWeiBi+0.5);
//        }
//        else if (lWeiBi == 0)
//        {
//        }
//        else
//        {
//            lBi = (long)(lWeiBi-0.5);
//            nFlag = -1;
//        }
//    }

    long lBi = pNewPriceData->m_nWB;
    if (lBi > 0)
        nFlag = 1;
    else if (lBi < 0)
        nFlag = -1;
    
    NSString* nsWeiBi = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    if (nsWeiBi == NULL)
        nsWeiBi = @"-.-%";
    NSMutableDictionary *pDictWB = GetDictWithValue(nsWeiBi, nFlag, 0);
    [pDictWB setObject:pColor forKey:tztColor];
    [pReturnDict setObject:pDictWB forKey:tztWRange];
    
    //委差
    NSString* nsWeiCha = [NSString stringWithFormat:@"%d", pNewPriceData->m_nWC];
    if (nsWeiCha == NULL)
        nsWeiCha = @"--";
    NSMutableDictionary *pDictWC = GetDictWithValue(nsWeiCha, nFlag, 0);
    [pReturnDict setObject:pDictWC forKey:tztWCha];
    
    //委买
    NSString* nsWBuy = NStringOfULong(BuyCount);
    if (nsWBuy == NULL)
        nsWBuy = @"--";
    NSMutableDictionary *pDictBuy = GetDictWithValue(nsWBuy, 1, 0);
    [pReturnDict setObject:pDictBuy forKey:tztWBuy];
    
    //委卖
    NSString* nsWSell = NStringOfULong(SellCount);
    if (nsWSell == NULL || [nsWSell length] < 1)
        nsWSell = @"--";
    NSMutableDictionary *pDictSell = GetDictWithValue(nsWSell, 0, 1);
    [pReturnDict setObject:pDictSell forKey:tztWSell];
    
    //上涨
    NSString* nsUp = NStringOfULong(pNewPriceData->a.indexData.ups);
    if (nsUp == NULL || [nsUp length] < 1)
        nsUp = @"--";
    NSMutableDictionary *pDictUp = GetDictWithValue(nsUp, 1, 0);
    [pReturnDict setObject:pDictUp forKey:tztUpStocks];
    
    //平盘
    NSString* nsFlat = NStringOfULong(pNewPriceData->a.indexData.totals -
                                      pNewPriceData->a.indexData.ups -
                                      pNewPriceData->a.indexData.downs );
    if (nsFlat == NULL || [nsFlat length] < 1)
        nsFlat = @"--";
    NSMutableDictionary *pDictFlat = GetDictWithValue(nsFlat, 0, 0);
    [pReturnDict setObject:pDictFlat forKey:tztFlatStocks];
    
    //下跌
    NSString* nsDown = NStringOfULong(pNewPriceData->a.indexData.downs);
    if (nsDown == NULL || [nsDown length] < 1)
        nsDown = @"--";
    NSMutableDictionary *pDictDown = GetDictWithValue(nsDown, 0, 1);
    [pReturnDict setObject:pDictDown forKey:tztDownStocks];
    
    
}

+ (void)dealWithStockPrice:(TNewPriceData*)pNewPriceData andType_:(int)nType pDict_:(NSMutableDictionary*)pReturnDict
{
    if (pNewPriceData == NULL || pReturnDict == NULL)
        return;
    
    int nHand =  100;
    NSString* strUnit = @"";
    if (MakeUSMarket(nType))//美股市场，不用手
    {
        nHand = 1;
        strUnit = @"股";
    }
    
    //股票代码
    NSString* nsCode = [[[NSString alloc] initWithBytes:pNewPriceData->Code
                                                 length:sizeof(pNewPriceData->Code)
                                               encoding:NSASCIIStringEncoding] autorelease];
    
    if(nsCode == NULL)
        nsCode = @"-";
    NSMutableDictionary *pDictCode = GetDictWithValue(nsCode, 0, 0);
    [pReturnDict setObject:pDictCode forKey:tztCode];
    
    //股票名称
    NSString* nsName = getName_TNewPriceData(pNewPriceData);
    if (nsName == NULL)
        nsName = @"--";
    NSMutableDictionary *pDictName = GetDictWithValue(nsName, 0, 0);
    [pReturnDict setObject:pDictName forKey:tztName];
    
    //昨收
    NSString* nsPreClose = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Close_p,0,pNewPriceData->nDecimal,1000);
    if (nsPreClose == NULL)
        nsPreClose = @"-.-%";
    NSMutableDictionary *pDictClose = GetDictWithValue(nsPreClose, 0, 0);
    [pReturnDict setObject:pDictClose forKey:tztYesTodayPrice];
    
    //最新
    NSString* nsNewPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Last_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     1000);
    if (nsNewPrice)
    {
        NSMutableDictionary *pDictNew = GetDictWithValue(nsNewPrice, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictNew forKey:tztNewPrice];
    }
    
    //最高
    NSString* nsMaxPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->High_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     1000);
    if (nsMaxPrice)
    {
        NSMutableDictionary *pDictMax = GetDictWithValue(nsMaxPrice, pNewPriceData->High_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictMax forKey:tztMaxPrice];
    }
    
    //涨停（无）
    //多头开
    //空头开
    
    //现手
    NSString* nsNowHand = NStringOfULong(pNewPriceData->a.StockData.Last_h / nHand);
    if (nsNowHand == NULL || [nsNowHand length] < 1)
        nsNowHand = @"--";
    else
        nsNowHand = [NSString stringWithFormat:@"%@%@",nsNowHand,strUnit];
    NSMutableDictionary *pDictHand = GetDictWithValue(nsNowHand, 0, 0);
    [pReturnDict setObject:pDictHand forKey:tztNowVolume];
    
    //换手
    NSString* nsHuanShow = [NSString stringWithFormat:@"%.2f%%",pNewPriceData->nHuanshoulv / 100.f];
    if (nsHuanShow == NULL || [nsHuanShow length] < 1)
        nsHuanShow = @"-.-%";
    NSMutableDictionary *pDcitHuanShou = GetDictWithValue(nsHuanShow, 0, 0);
    [pReturnDict setObject:pDcitHuanShou forKey:tztHuanShou];
    
    //内盘
    NSString* nsInside = NStringOfLong(pNewPriceData->m_lInside/nHand);
    if (nsInside == NULL || [nsInside length] < 1)
        nsInside = @"-";
    NSMutableDictionary *pDictNei = GetDictWithValue(nsInside, 0, 0);
    [pReturnDict setObject:pDictNei forKey:tztNeiPan];
    
    //量比
    NSString* nsLB = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_lLiangbi, 0, 2, 100);//
    if (nsLB == NULL || [nsLB length] < 1)
        nsLB = @"-";
    NSMutableDictionary *pDictLB = GetDictWithValue(nsLB, 0, 0);
    [pReturnDict setObject:pDictLB forKey:tztVolumeRatio];
    
    //外盘
    NSString* nsOutside = NStringOfLong(pNewPriceData->m_lOutside/nHand);
    if (nsOutside == NULL || [nsOutside length] < 1)
        nsOutside = @"-";
    NSMutableDictionary *pDictOut = GetDictWithValue(nsOutside, 0, 0);
    [pReturnDict setObject:pDictOut forKey:tztWaiPan];
    
    //静态市盈率
    NSString* nsPEStatic = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_jtsyl, 0, 2, 100);
    if (nsPEStatic == NULL || [nsPEStatic length] < 1)
        nsPEStatic = @"-";
    NSMutableDictionary *pDictPEStatic = GetDictWithValue(nsPEStatic, 0, 0);
    [pReturnDict setObject:pDictPEStatic forKey:tztPEStatic];
    
    //季度
    NSString* nsSeason = NStringOfLong(pNewPriceData->m_jb);
    if (nsSeason == NULL || nsSeason.length < 1)
        nsSeason = @"3";//3表示1季度
    NSMutableDictionary *pDictSeason = GetDictWithValue(nsSeason, 0, 0);
    [pReturnDict setObject:pDictSeason forKey:tztSeason];
    
    //每股收益
    NSString* nsSeasonValue = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_mgsy, 0, 4, 10000);
    if (nsSeasonValue == NULL || [nsSeasonValue length] < 1)
        nsSeasonValue = @"-";
    NSMutableDictionary *pDictSeasonValue = GetDictWithValue(nsSeasonValue, 0, 0);
    [pReturnDict setObject:pDictSeasonValue forKey:tztSeasonValue];
    
    //涨停
    NSString* nsZT = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_zt,
                                               0,
                                               pNewPriceData->nDecimal,
                                               1000);
    if (nsZT == NULL || nsZT.length < 1)
        nsZT = @"-";
    NSMutableDictionary *dictZT = GetDictWithValue(nsZT, pNewPriceData->m_zt, pNewPriceData->Close_p);
    [pReturnDict setObject:dictZT forKey:tztZTPrice];
    
    //跌停
    NSString* nsDT = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_dt,
                                               0,
                                               pNewPriceData->nDecimal,
                                               1000);
    if (nsDT == NULL || nsDT.length < 1)
        nsDT = @"-";
    NSMutableDictionary *dictDT = GetDictWithValue(nsDT, pNewPriceData->m_dt, pNewPriceData->Close_p);
    [pReturnDict setObject:dictDT forKey:tztDTPrice];
    
    //最低
    NSString* nsMinPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Low_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     1000);
    if (nsMinPrice)
    {
        NSMutableDictionary *pDictMin = GetDictWithValue(nsMinPrice, pNewPriceData->Low_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictMin forKey:tztMinPrice];
    }
    
    //开盘
    NSString* nsOpenPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Open_p,0,pNewPriceData->nDecimal,1000);
    if (nsOpenPrice == NULL)
        nsOpenPrice = @"";
    NSMutableDictionary *pDictOpen = GetDictWithValue(nsOpenPrice, pNewPriceData->Open_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictOpen forKey:tztStartPrice];
    
    //时间
    NSString* nsTime = [NSString stringWithFormat:@"%02d:%02d", pNewPriceData->nHour, pNewPriceData->nMin];
    if (nsTime == NULL)
        nsTime = @"-:-";
    NSMutableDictionary *pDictTime = GetDictWithValue(nsTime, 0, 0);
    [pReturnDict setObject:pDictTime forKey:tztTime];
    
    //涨跌
    NSString* nsRatio = NSStringOfVal_Ref_Dec_Div((pNewPriceData->Last_p > 0) ? (pNewPriceData->Last_p - pNewPriceData->Close_p) : 0,
                                                  0,
                                                  pNewPriceData->nDecimal,
                                                  1000);
    if (nsRatio == NULL)
        nsRatio = @"-.-";
    NSMutableDictionary *pDictRatio = GetDictWithValue(nsRatio, pNewPriceData->Last_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictRatio forKey:tztUpDown];
    
    //涨跌幅
    NSString* nsPriceRange = @"-";
    if(pNewPriceData->Close_p != 0)
        nsPriceRange = [NSString stringWithFormat:@"%.2f%%",((pNewPriceData->Last_p > 0) ? (pNewPriceData->Last_p - pNewPriceData->Close_p) : 0) * 100.f / pNewPriceData->Close_p];
    
    if (nsPriceRange)
    {
        NSMutableDictionary *pDictRange = GetDictWithValue(nsPriceRange, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictRange forKey:tztPriceRange];
    }
    
    //成交额
    NSString* nsTotal_m = NStringOfFloat(pNewPriceData->Total_m);
    if (nsTotal_m)
    {
        NSMutableDictionary *pDictTotalM = GetDictWithValue(nsTotal_m, 0, 0);
        [pReturnDict setObject:pDictTotalM forKey:tztTransactionAmount];
    }
    
    //成交量
    NSString* nsTotal_h = NStringOfULong(pNewPriceData->Total_h / nHand);
    if (nsTotal_h)
    {
        nsTotal_h = [NSString stringWithFormat:@"%@%@", nsTotal_h, strUnit];
        NSMutableDictionary *pDictTotalH = GetDictWithValue(nsTotal_h, 0, 0);
        [pReturnDict setObject:pDictTotalH forKey:tztTradingVolume];
    }
    
    //昨持
    //总持
    
    long BuyCount = pNewPriceData->a.StockData.Q1+
    pNewPriceData->a.StockData.Q2 +
    pNewPriceData->a.StockData.Q3 +
    pNewPriceData->a.StockData.Q7 +
    pNewPriceData->a.StockData.Q8;
    
    long SellCount = pNewPriceData->a.StockData.Q4+
    pNewPriceData->a.StockData.Q5 +
    pNewPriceData->a.StockData.Q6 +
    pNewPriceData->a.StockData.Q9 +
    pNewPriceData->a.StockData.Q10;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
    long lBi= pNewPriceData->m_nWB;
    int nFlag = 0;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
        if ( lBi> 0 )
        {
//            lBi = (long)(lWeiBi+0.5);
            nFlag = 1;
        }
        else if (lBi == 0)
        {
        }
        else
        {
//            lBi = (long)(lWeiBi-0.5);
            nFlag = -1;
        }
//    }
    
    //委买
    NSString* nsWBuy = NStringOfULong(BuyCount);
    if (nsWBuy)
    {
        NSMutableDictionary *pDictBuy = GetDictWithValue(nsWBuy, 1, 0);
        [pReturnDict setObject:pDictBuy forKey:tztWBuy];
    }
    
    //委卖
    NSString* nsWSell = NStringOfULong(SellCount);
    if (nsWSell)
    {
        NSMutableDictionary  *pDictSell = GetDictWithValue(nsWSell, 0, 1);
        [pReturnDict setObject:pDictSell forKey:tztWSell];
    }
    
    //委比
    NSString* nsWeiBi = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    if (nsWeiBi == NULL || [nsWeiBi length] < 1)
        nsWeiBi = @"-.-%";
    NSMutableDictionary *pDictWB = GetDictWithValue(nsWeiBi, nFlag, 0);
    [pReturnDict setObject:pDictWB forKey:tztWRange];
    
    //委差
    long lWeiCa = pNewPriceData->m_nWC;// (A/nHand);
    NSString* nsWeiCha = [NSString stringWithFormat:@"%ld",  lWeiCa];
    if (nsWeiCha == NULL || [nsWeiCha length] < 1)
        nsWeiCha = @"--";
    NSMutableDictionary *pDictWC = GetDictWithValue(nsWeiCha, nFlag, 0);
    [pReturnDict setObject:pDictWC forKey:tztWCha];
    
    //振幅
    NSString* nsZF = [NSString stringWithFormat:@"%.2f%%", pNewPriceData->m_lMaxUpIndex / 100.f];
    if (nsZF)
    {
        NSMutableDictionary *pDictZF = GetDictWithValue(nsZF, 1, 0);
        [pReturnDict setObject:pDictZF forKey:tztVibrationAmplitude];
    }
    
    //均价
    NSString* nsAvgPrice =  NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_lAvgPrice,0,pNewPriceData->nDecimal,1000);
    if (nsAvgPrice == NULL || [nsAvgPrice length] < 1)
        nsAvgPrice = @"-.-";
    NSMutableDictionary *pDictAvg = GetDictWithValue(nsAvgPrice, pNewPriceData->m_lAvgPrice, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictAvg forKey:tztAveragePrice];
    
    
    //PE
    NSString* nsPE = [NSString stringWithFormat:@"%.2f",pNewPriceData->m_ldtsyl / 1000.f];
    if (nsPE == NULL || [nsPE length] < 1)
        nsPE = @"-";
    NSMutableDictionary *pDictPE = GetDictWithValue(nsPE, 0, 0);
    [pReturnDict setObject:pDictPE forKey:tztPE];
    
    //净资产
    NSString* nsJZC = [NSString stringWithFormat:@"%.2f",pNewPriceData->m_ljzc / 10000.f];
    if (nsJZC == NULL || [nsJZC length] < 1)
        nsJZC = @"-";
    NSMutableDictionary *pDictJZC = GetDictWithValue(nsJZC, 0, 0);
    [pReturnDict setObject:pDictJZC forKey:tztMeiGuJingZiChan];
    
    //市净率
    //最新价＊10，因为每股净资产被放大了10000倍，而价格只放大了1000倍
    NSString* nsSJL = @"";
    if (pNewPriceData->m_ljzc == 0)
    {
        nsSJL = @"-.-";
    }
    else
     nsSJL = [NSString stringWithFormat:@"%.2f",(float)((float)(pNewPriceData->Last_p*10) / (float)pNewPriceData->m_ljzc)];
    if (nsSJL == NULL || nsSJL.length < 1)
        nsSJL = @"-.-";
    
    NSMutableDictionary* pDictSJV = GetDictWithValue(nsSJL, 0, 0);
    [pReturnDict setObject:pDictSJV forKey:tztSJL];
    
    //总股本
    NSString* nsZGB = NStringOfULongLong((unsigned long long)pNewPriceData->m_zgb*10000);
    if (nsZGB == NULL || [nsZGB length] < 1)
        nsZGB = @"-";
    NSMutableDictionary *pDictZGB = GetDictWithValue(nsZGB, 0, 0);
    [pReturnDict setObject:pDictZGB forKey:tztZongGuBen];
    
    //总市值
    NSString* nsZSZ = NStringOfULongLong((unsigned long long)pNewPriceData->m_zgb*10000 * (pNewPriceData->Last_p / 1000.f));
    if (nsZSZ == NULL || nsZSZ.length < 1)
        nsZSZ = @"-";
    NSMutableDictionary *pDictZSZ = GetDictWithValue(nsZSZ, 0, 0);
    [pReturnDict setObject:pDictZSZ forKey:tztZongGuBenMoney];
    
    
    //流通盘
    NSString* nsLTP = NStringOfULongLong((unsigned long long)pNewPriceData->m_ltb*10000);
    if (nsLTP == NULL || [nsLTP length] < 1)
        nsLTP = @"-";
    NSMutableDictionary *pDictLTP = GetDictWithValue(nsLTP, 0, 0);
    [pReturnDict setObject:pDictLTP forKey:tztLiuTongPan];
    
    //流通市值
    NSString* nsLTSZ = NStringOfULongLong((unsigned long long)pNewPriceData->m_ltb*10000 * (pNewPriceData->Last_p / 1000.f));
    if (nsLTSZ == NULL || nsLTSZ.length < 1)
        nsLTSZ = @"-";
    NSMutableDictionary *pDictLTSZ = GetDictWithValue(nsLTSZ, 0, 0);
    [pReturnDict setObject:pDictLTSZ forKey:tztLiuTongPanMoney];
    
    //行业名称
//    NSString* nsBlockName = [NSString stringWithCharacters:(const unichar*)pNewPriceData->BlockName
//                                                    length:sizeof(pNewPriceData->BlockName) / 2];
    
    NSString* nsBlockName = getBlockName_TNewPriceData(pNewPriceData);
    if (nsBlockName == NULL || [nsBlockName length] < 1)
        nsBlockName = @"--";
    NSMutableDictionary *pDictBlockName = GetDictWithValue(nsBlockName, 0, 0);
    [pReturnDict setObject:pDictBlockName forKey:tztIndustryName];
    //行业代码
    NSString* nsBlockCode = [[NSString alloc] initWithBytes:pNewPriceData->BlockCode
                                                     length:sizeof(pNewPriceData->BlockCode)
                                                   encoding:NSASCIIStringEncoding];
    if (nsBlockCode == NULL || [nsBlockCode length] < 1)
        nsBlockCode = @"--";
    
    NSMutableDictionary *pDictBlockCode = GetDictWithValue(nsBlockCode, 0, 0);
    [pReturnDict setObject:pDictBlockCode forKey:tztIndustryCode];
    [nsBlockCode release];
    
    //行业涨跌幅
    NSString* nsBlockValue = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_lBlockUpIndex,
                                                       0,
                                                       2,
                                                       100);
    nsBlockValue = [NSString stringWithFormat:@"%@%%",nsBlockValue];
    if (nsBlockValue == NULL || [nsBlockValue length] < 1)
        nsBlockValue = @"--";
    if ([nsBlockValue hasPrefix:@"-"])
        nFlag = -1;
    else
        nFlag = 1;
    NSMutableDictionary *pDictValue = GetDictWithValue(nsBlockValue, nFlag, 0);
    [pReturnDict setObject:pDictValue forKey:tztIndustryPriceRange];
    
    //五口价量
    //～买一 ～ 卖五
    //买一
    int nAmount = pNewPriceData->m_nUnit;
    if (nAmount <= 0)
        nAmount = 100;
    NSString* nsBuy1 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p1,
                                                 0,
                                                 pNewPriceData->nDecimal,
                                                 1000);
    if (nsBuy1 == NULL || [nsBuy1 length] < 1)
        nsBuy1 = @"-.-";
    NSMutableDictionary *pDictBuy1 = GetDictWithValue(nsBuy1, pNewPriceData->a.StockData.p1, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictBuy1 forKey:tztBuy1];
    
    NSString* nsBuyVolume1 = NStringOfULong(pNewPriceData->a.StockData.Q1 / nAmount);
    if (nsBuyVolume1 == NULL || [nsBuyVolume1 length] < 1)
        nsBuyVolume1 = @"--";
    NSMutableDictionary *pDictBuyVolume1 = GetDictWithValue(nsBuyVolume1, 0, 0);
    [pReturnDict setObject:pDictBuyVolume1 forKey:tztBuy1Vol];
    
    //买二
    NSString* nsBuy2 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p2,
                                                 0,
                                                 pNewPriceData->nDecimal,
                                                 1000);
    if (nsBuy2 == NULL || [nsBuy2 length] < 1)
        nsBuy2 = @"-.-";
    NSMutableDictionary *pDictBuy2 = GetDictWithValue(nsBuy2, pNewPriceData->a.StockData.p2, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictBuy2 forKey:tztBuy2];
    
    NSString* nsBuyVolume2 = NStringOfULong(pNewPriceData->a.StockData.Q2 / nAmount);
    if (nsBuyVolume2 == NULL || [nsBuyVolume2 length] < 1)
        nsBuyVolume2 = @"-.-";
    NSMutableDictionary *pDictBuyVolume2 = GetDictWithValue(nsBuyVolume2, 0, 0);
    [pReturnDict setObject:pDictBuyVolume2 forKey:tztBuy2Vol];
    
    //买三
    NSString* nsBuy3 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p3,
                                                 0,
                                                 pNewPriceData->nDecimal,
                                                 1000);
    if (nsBuy3 == NULL || [nsBuy3 length] < 1)
        nsBuy3 = @"-.-";
    NSMutableDictionary *pDictBuy3 = GetDictWithValue(nsBuy3, pNewPriceData->a.StockData.p3, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictBuy3 forKey:tztBuy3];
    
    NSString* nsBuyVolume3 = NStringOfULong(pNewPriceData->a.StockData.Q3 / nAmount);
    if (nsBuyVolume3 == NULL || [nsBuyVolume3 length] < 1)
        nsBuyVolume3 = @"-.-";
    NSMutableDictionary *pDictBuyVolume3 = GetDictWithValue(nsBuyVolume3, 0, 0);
    [pReturnDict setObject:pDictBuyVolume3 forKey:tztBuy3Vol];
    
    //买四
    NSString* nsBuy4 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p7,
                                                 0,
                                                 pNewPriceData->nDecimal,
                                                 1000);
    if (nsBuy4 == NULL || [nsBuy4 length] < 1)
        nsBuy4 = @"-.-";
    NSMutableDictionary *pDictBuy4 = GetDictWithValue(nsBuy4, pNewPriceData->a.StockData.p7, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictBuy4 forKey:tztBuy4];
    
    NSString* nsBuyVolume4 = NStringOfULong(pNewPriceData->a.StockData.Q7 / nAmount);
    if (nsBuyVolume4 == NULL || [nsBuyVolume4 length] < 1)
        nsBuyVolume4 = @"-.-";
    NSMutableDictionary *pDictBuyVolume4 = GetDictWithValue(nsBuyVolume4, 0, 0);
    [pReturnDict setObject:pDictBuyVolume4 forKey:tztBuy4Vol];
    
    //买五
    NSString* nsBuy5 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p8,
                                                 0,
                                                 pNewPriceData->nDecimal,
                                                 1000);
    if (nsBuy5 == NULL || [nsBuy5 length] < 1)
        nsBuy5 = @"-.-";
    NSMutableDictionary *pDictBuy5 = GetDictWithValue(nsBuy5, pNewPriceData->a.StockData.p8, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictBuy5 forKey:tztBuy5];
    NSString* nsBuyVolume5 = NStringOfULong(pNewPriceData->a.StockData.Q8 / nAmount);
    if (nsBuyVolume5 == NULL || [nsBuyVolume5 length] < 1)
        nsBuyVolume5 = @"-.-";
    NSMutableDictionary *pDictBuyVolume5 = GetDictWithValue(nsBuyVolume5, 0, 0);
    [pReturnDict setObject:pDictBuyVolume5 forKey:tztBuy5Vol];
    
    //卖一
    NSString* nsSell1 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p4,
                                                  0,
                                                  pNewPriceData->nDecimal,
                                                  1000);
    if (nsSell1 == NULL || [nsSell1 length] < 1)
        nsSell1 = @"-.-";
    NSMutableDictionary *pDictSell1 = GetDictWithValue(nsSell1, pNewPriceData->a.StockData.p4, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictSell1 forKey:tztSell1];
    NSString* nsSellVolume1 = NStringOfULong(pNewPriceData->a.StockData.Q4 / nAmount);
    if (nsSellVolume1 == NULL || [nsSellVolume1 length] < 1)
        nsSellVolume1 = @"-.-";
    NSMutableDictionary *pDictSellVolume1 = GetDictWithValue(nsSellVolume1, 0, 0);
    [pReturnDict setObject:pDictSellVolume1 forKey:tztSell1Vol];
    
    //卖二
    NSString* nsSell2 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.P5,
                                                  0,
                                                  pNewPriceData->nDecimal,
                                                  1000);
    if (nsSell2 == NULL || [nsSell2 length] < 1)
        nsSell2 = @"-.-";
    NSMutableDictionary *pDictSell2 = GetDictWithValue(nsSell2, pNewPriceData->a.StockData.P5, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictSell2 forKey:tztSell2];
    NSString* nsSellVolume2 = NStringOfULong(pNewPriceData->a.StockData.Q5 / nAmount);
    if (nsSellVolume2 == NULL || [nsSellVolume2 length] < 1)
        nsSellVolume2 = @"-.-";
    NSMutableDictionary *pDictSellVolume2 = GetDictWithValue(nsSellVolume2, 0, 0);
    [pReturnDict setObject:pDictSellVolume2 forKey:tztSell2Vol];
    
    //卖三
    NSString* nsSell3 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.P6,
                                                  0,
                                                  pNewPriceData->nDecimal,
                                                  1000);
    if (nsSell3 == NULL || [nsSell3 length] < 1)
        nsSell3 = @"-.-";
    NSMutableDictionary *pDictSell3 = GetDictWithValue(nsSell3, pNewPriceData->a.StockData.P6, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictSell3 forKey:tztSell3];
    NSString* nsSellVolume3 = NStringOfULong(pNewPriceData->a.StockData.Q6 / nAmount);
    if (nsSellVolume3 == NULL || [nsSellVolume3 length] < 1)
        nsSellVolume3 = @"-.-";
    NSMutableDictionary *pDictSellVolume3 = GetDictWithValue(nsSellVolume3, 0, 0);
    [pReturnDict setObject:pDictSellVolume3 forKey:tztSell3Vol];
    
    //卖四
    NSString* nsSell4 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p9,
                                                  0,
                                                  pNewPriceData->nDecimal,
                                                  1000);
    if (nsSell4 == NULL || [nsSell4 length] < 1)
        nsSell4 = @"-.-";
    NSMutableDictionary *pDictSell4 = GetDictWithValue(nsSell4, pNewPriceData->a.StockData.p9, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictSell4 forKey:tztSell4];
    NSString* nsSellVolume4 = NStringOfULong(pNewPriceData->a.StockData.Q9 / nAmount);
    if (nsSellVolume4 == NULL || [nsSellVolume4 length] < 1)
        nsSellVolume4 = @"-.-";
    NSMutableDictionary *pDictSellVolume4 = GetDictWithValue(nsSellVolume4, 0, 0);
    [pReturnDict setObject:pDictSellVolume4 forKey:tztSell4Vol];
    
    //卖五
    NSString* nsSell5 = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p10,
                                                  0,
                                                  pNewPriceData->nDecimal,
                                                  1000);
    if (nsSell5 == NULL || [nsSell5 length] < 1)
        nsSell5 = @"-.-";
    NSMutableDictionary *pDictSell5 = GetDictWithValue(nsSell5, pNewPriceData->a.StockData.p10, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictSell5 forKey:tztSell5];
    NSString* nsSellVolume5 = NStringOfULong(pNewPriceData->a.StockData.Q10 / nAmount);
    if (nsSellVolume5 == NULL || [nsSellVolume5 length] < 1)
        nsSellVolume5 = @"-.-";
    NSMutableDictionary *pDictSellVolume5 = GetDictWithValue(nsSellVolume5, 0, 0);
    [pReturnDict setObject:pDictSellVolume5 forKey:tztSell5Vol];
    
}

+(void)dealWithHKStockPrice:(TNewPriceData *)pNewPriceData andUnit_:(int)nUnit pDict_:(NSMutableDictionary *)pReturnDict
{
    if (pNewPriceData == NULL || pReturnDict == NULL)
        return;
    
    //股票代码
    NSString* nsCode = [[[NSString alloc] initWithBytes:pNewPriceData->Code
                                                 length:sizeof(pNewPriceData->Code)
                                               encoding:NSASCIIStringEncoding] autorelease];
    
    if(nsCode == NULL)
        nsCode = @"-";
    NSMutableDictionary *pDictCode = GetDictWithValue(nsCode, 0, 0);
    [pReturnDict setObject:pDictCode forKey:tztCode];
    
    //股票名称
    NSString* nsName = getName_TNewPriceData(pNewPriceData);
    if (nsName == NULL)
        nsName = @"--";
    NSMutableDictionary *pDictName = GetDictWithValue(nsName, 0, 0);
    [pReturnDict setObject:pDictName forKey:tztName];
    
    int nHand = pNewPriceData->m_nUnit;// 100000;

    if (nHand <= 0)
        nHand = 1;
//    nHand = 1;
    //开盘
    NSString* nsOpenPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Open_p,0,pNewPriceData->nDecimal,nUnit);
    if (nsOpenPrice == NULL)
        nsOpenPrice = @"";
    NSMutableDictionary *pDictOpen = GetDictWithValue(nsOpenPrice, pNewPriceData->Open_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictOpen forKey:tztStartPrice];
    
    //昨收
    NSString* nsPreClose = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Close_p,0,pNewPriceData->nDecimal,nUnit);
    if (nsPreClose == NULL)
        nsPreClose = @"-.-%";
    NSMutableDictionary *pDictClose = GetDictWithValue(nsPreClose, 0, 0);
    [pReturnDict setObject:pDictClose forKey:tztYesTodayPrice];
    
    //最新
    NSString* nsNewPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Last_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     nUnit);
    if (nsNewPrice)
    {
        NSMutableDictionary *pDictNew = GetDictWithValue(nsNewPrice, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictNew forKey:tztNewPrice];
    }
    
    //涨跌
    NSString* nsRatio = NSStringOfVal_Ref_Dec_Div((pNewPriceData->Last_p > 0) ? pNewPriceData->Last_p - pNewPriceData->Close_p : 0,
                                                  0,
                                                  pNewPriceData->nDecimal,
                                                  nUnit);
    if (nsRatio == NULL)
        nsRatio = @"-.-";
    NSMutableDictionary *pDictRatio = GetDictWithValue(nsRatio, pNewPriceData->Last_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictRatio forKey:tztUpDown];
    
    //涨跌幅
    NSString* nsPriceRange = @"-";
    if(pNewPriceData->Close_p != 0)
        nsPriceRange = [NSString stringWithFormat:@"%.2f%%",((pNewPriceData->Last_p > 0) ? pNewPriceData->Last_p - pNewPriceData->Close_p : 0) * 100.f / pNewPriceData->Close_p];
    
    if (nsPriceRange)
    {
        NSMutableDictionary *pDictRange = GetDictWithValue(nsPriceRange, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictRange forKey:tztPriceRange];
    }
    
    //最高
    NSString* nsMaxPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->High_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     nUnit);
    if (nsMaxPrice)
    {
        NSMutableDictionary *pDictMax = GetDictWithValue(nsMaxPrice, pNewPriceData->High_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictMax forKey:tztMaxPrice];
    }
    
    //最低
    NSString* nsMinPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Low_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     1000);
    if (nsMinPrice)
    {
        NSMutableDictionary *pDictMin = GetDictWithValue(nsMinPrice, pNewPriceData->Low_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictMin forKey:tztMinPrice];
    }
    
    //均价
    NSString* nsAvgPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_lAvgPrice,
                                                   0,
                                                   pNewPriceData->nDecimal,
                                                   nUnit);
    if (nsAvgPrice)
    {
        NSMutableDictionary *pDictAvg = GetDictWithValue(nsAvgPrice, pNewPriceData->m_lAvgPrice, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictAvg forKey:tztAveragePrice];
    }
    
    //总手
    NSString* nsTotal = NStringOfULong(pNewPriceData->Total_h / nHand);
    nsTotal = [NSString stringWithFormat:@"%@股",nsTotal];
    if (nsTotal)
    {
        NSMutableDictionary *pDictTotalH = GetDictWithValue(nsTotal, 0, 0);
        [pReturnDict setObject:pDictTotalH forKey:tztTradingVolume];
    }
    
    //总额
    NSString* nsTotal_m = NStringOfFloat(pNewPriceData->Total_m);
    if (nsTotal_m)
    {
        NSMutableDictionary *pDictTotalM = GetDictWithValue(nsTotal_m, 0, 0);
        [pReturnDict setObject:pDictTotalM forKey:tztTransactionAmount];
    }
    
    //现手
    NSString* nsHand = NStringOfULong(pNewPriceData->a.StockData.Last_h / nHand);
    nsHand = [NSString stringWithFormat:@"%@股",nsHand];
    if (nsHand)
    {
        NSMutableDictionary *pDictHand = GetDictWithValue(nsHand, 0, 0);
        [pReturnDict setObject:pDictHand forKey:tztNowVolume];
    }
    
    //量比
    NSString* nsLB = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_lLiangbi, 0, 2, 100);//
    if (nsLB)
    {
        NSMutableDictionary *pDictLB = GetDictWithValue(nsLB, 0, 0);
        [pReturnDict setObject:pDictLB forKey:tztVolumeRatio];
    }
    
    //委比
//    long BuyCount = pNewPriceData->a.StockData.Q1+
//    pNewPriceData->a.StockData.Q2 +
//    pNewPriceData->a.StockData.Q3 +
//    pNewPriceData->a.StockData.Q7 +
//    pNewPriceData->a.StockData.Q8;
    
//    long SellCount = pNewPriceData->a.StockData.Q4+
//    pNewPriceData->a.StockData.Q5 +
//    pNewPriceData->a.StockData.Q6 +
//    pNewPriceData->a.StockData.Q9 +
//    pNewPriceData->a.StockData.Q10;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
    long lBi= pNewPriceData->m_nWB;
    int nFlag = 0;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
        if ( lBi> 0 )
        {
//            lBi = (long)(lWeiBi+0.5);
            nFlag = 1;
        }
        else if (lBi == 0)
        {
        }
        else
        {
//            lBi = (long)(lWeiBi-0.5);
            nFlag = -1;
        }
//    }
    
    NSString* nsWB = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    if (nsWB)
    {
        NSMutableDictionary *pDictWB = GetDictWithValue(nsWB, nFlag, 0);
        [pReturnDict setObject:pDictWB forKey:tztWRange];
    }
    
    //委差
    long lWeiCa = pNewPriceData->m_nWC;// (A / nHand);
    NSString* nsWC = NStringOfLong(lWeiCa);// [NSString stringWithFormat:@"%ld",lWeiCa];
    nsWC = [NSString stringWithFormat:@"%@股",nsWC];
    if (nsWC)
    {
        NSMutableDictionary *pDictWC = GetDictWithValue(nsWC, nFlag, 0);
        [pReturnDict setObject:pDictWC forKey:tztWCha];
    }

    //IEP
    NSString* nsIEP = NStringOfULong(pNewPriceData->m_lOutside);
    if (nsIEP)
    {
        NSMutableDictionary *pDictIEP = GetDictWithValue(nsIEP, 0, 0);
        [pReturnDict setObject:pDictIEP forKey:tztIEP];
    }
    
    //IEV
    NSString* nsIEV = NStringOfULong(pNewPriceData->m_lInside);
    if (nsIEV)
    {
        NSMutableDictionary *pDictIEV = GetDictWithValue(nsIEV, 0, 0);
        [pReturnDict setObject:pDictIEV forKey:tztIEV];
    }
}

+(void)DealWithBlockIndexPice:(TNewPriceData*)pNewPriceData pDict_:(NSMutableDictionary*)pReturnDict
{
    if (pNewPriceData == NULL || pReturnDict == NULL)
        return;
    
    //股票代码
    NSString* nsCode = [[[NSString alloc] initWithBytes:pNewPriceData->Code
                                                 length:sizeof(pNewPriceData->Code)
                                               encoding:NSASCIIStringEncoding] autorelease];
    
    if(nsCode == NULL)
        nsCode = @"-";
    NSMutableDictionary *pDictCode = GetDictWithValue(nsCode, 0, 0);
    [pReturnDict setObject:pDictCode forKey:tztCode];
    
    //股票名称
    NSString* nsName = getName_TNewPriceData(pNewPriceData);
    if (nsName == NULL)
        nsName = @"--";
    NSMutableDictionary *pDictName = GetDictWithValue(nsName, 0, 0);
    [pReturnDict setObject:pDictName forKey:tztName];
    
    int nHand = 100;
    
    int nUnit = 1000;
    //昨收
    NSString* nsPreClose = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Close_p,0,pNewPriceData->nDecimal,nUnit);
    if (nsPreClose == NULL)
        nsPreClose = @"-.-%";
    NSMutableDictionary *pDictClose = GetDictWithValue(nsPreClose, 0, 0);
    [pReturnDict setObject:pDictClose forKey:tztYesTodayPrice];
    
    //最新
    NSString* nsNewPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Last_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     nUnit);
    if (nsNewPrice)
    {
        NSMutableDictionary *pDictNew = GetDictWithValue(nsNewPrice, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictNew forKey:tztNewPrice];
    }
    
    //涨跌
    NSString* nsRatio = NSStringOfVal_Ref_Dec_Div((pNewPriceData->Last_p > 0) ? (pNewPriceData->Last_p - pNewPriceData->Close_p) : 0,
                                                  0,
                                                  pNewPriceData->nDecimal,
                                                  nUnit);
    if (nsRatio == NULL)
        nsRatio = @"-.-";
    NSMutableDictionary *pDictRatio = GetDictWithValue(nsRatio, pNewPriceData->Last_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictRatio forKey:tztUpDown];
    
    //涨跌幅
    NSString* nsPriceRange = @"-";
    if(pNewPriceData->Close_p != 0)
        nsPriceRange = [NSString stringWithFormat:@"%.2f%%",((pNewPriceData->Last_p > 0) ? (pNewPriceData->Last_p - pNewPriceData->Close_p) : 0) * 100.f / pNewPriceData->Close_p];
    
    if (nsPriceRange)
    {
        NSMutableDictionary *pDictRange = GetDictWithValue(nsCode, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictRange forKey:tztPriceRange];
    }

    
    //均价
    NSString *nsAvgPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_lAvgPrice,0,pNewPriceData->nDecimal,1000);
    if (nsAvgPrice)
    {
        NSMutableDictionary *pDictAvg = GetDictWithValue(nsAvgPrice, pNewPriceData->m_lAvgPrice, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictAvg forKey:tztAveragePrice];
    }
    
    //现手
    NSString* nsHand = NStringOfULong(pNewPriceData->a.StockData.Last_h / nHand);
    if (nsHand)
    {
        NSMutableDictionary *pDictHand = GetDictWithValue(nsHand, 0, 0);
        [pReturnDict setObject:pDictHand forKey:tztNowVolume];
    }
    //总手
    NSString* nsTotal = NStringOfULong(pNewPriceData->Total_h / nHand);
    if (nsTotal)
    {
        NSMutableDictionary *pDictTotal = GetDictWithValue(nsTotal, 0, 0);
        [pReturnDict setObject:pDictTotal forKey:tztTradingVolume];
    }
    //换手
    NSString* nsChange = [NSString stringWithFormat:@"%.2f%%",pNewPriceData->nHuanshoulv / 100.f];
    if (nsChange)
    {
        NSMutableDictionary *pDictChange = GetDictWithValue(nsChange, 0, 0);
        [pReturnDict setObject:pDictChange forKey:tztHuanShou];
    }
    //PE
    NSString* nsPE = [NSString stringWithFormat:@"%.2f",pNewPriceData->m_ldtsyl / 1000.f];
    if (nsPE)
    {
        NSMutableDictionary *pDictPE = GetDictWithValue(nsPE, 0, 0);
        [pReturnDict setObject:pDictPE forKey:tztPE];
    }
    //净资产
    NSString* nsZJC = [NSString stringWithFormat:@"%.2f",pNewPriceData->m_ljzc / 10000.f];
    if (nsZJC)
    {
        NSMutableDictionary *pDictZJC = GetDictWithValue(nsZJC, 0, 0);
        [pReturnDict setObject:pDictZJC forKey:tztMeiGuJingZiChan];
    }
    //总股本
    NSString* nsZGB = NStringOfULongLong((unsigned long long)pNewPriceData->m_zgb*10000);
    if (nsZGB)
    {
        NSMutableDictionary *pDictZGB = GetDictWithValue(nsZGB, 0, 0);
        [pReturnDict setObject:pDictZGB forKey:tztZongGuBen];
    }
    //流通盘
    NSString* nsLTP = NStringOfULongLong((unsigned long long)pNewPriceData->m_ltb*10000);
    if (nsLTP)
    {
        NSMutableDictionary *pDictLTP = GetDictWithValue(nsLTP, 0, 0);
        [pReturnDict setObject:pDictLTP forKey:tztLiuTongPan];
    }
    //
    //量比
    NSString *nsLB = NSStringOfVal_Ref_Dec_Div(pNewPriceData->m_lLiangbi, 0, 2, 100);
    if (nsLB)
    {
        NSMutableDictionary *pDictLB = GetDictWithValue(nsLB, 0, 0);
        [pReturnDict setObject:pDictLB forKey:tztVolumeRatio];
    }
    
    //委比
//    long BuyCount = pNewPriceData->a.StockData.Q1+
//    pNewPriceData->a.StockData.Q2 +
//    pNewPriceData->a.StockData.Q3 +
//    pNewPriceData->a.StockData.Q7 +
//    pNewPriceData->a.StockData.Q8;
//    
//    long SellCount = pNewPriceData->a.StockData.Q4+
//    pNewPriceData->a.StockData.Q5 +
//    pNewPriceData->a.StockData.Q6 +
//    pNewPriceData->a.StockData.Q9 +
//    pNewPriceData->a.StockData.Q10;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
    long lBi= pNewPriceData->m_nWB;
    int nFlag = 0;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
        if ( lBi> 0 )
        {
//            lBi = (long)(lWeiBi+0.5);
            nFlag = 1;
        }
        else if (lBi == 0)
        {
        }
        else
        {
//            lBi = (long)(lWeiBi-0.5);
            nFlag = -1;
        }
//    }
    
    NSString* nsWB = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    if (nsWB)
    {
        NSMutableDictionary *pDictWB = GetDictWithValue(nsWB, nFlag, 0);
        [pReturnDict setObject:pDictWB forKey:tztWRange];
    }
    
    //委差
    long lWeiCa = pNewPriceData->m_nWC;// (A / nHand);
    NSString* nsWC = [NSString stringWithFormat:@"%ld",lWeiCa];
    if (nsWC)
    {
        NSMutableDictionary *pDictWC = GetDictWithValue(nsWC, nFlag, 0);
        [pReturnDict setObject:pDictWC forKey:tztWCha];
    }
    
    //外盘
    NSString* nsOut = NStringOfLong(pNewPriceData->m_lOutside/nHand);
    if (nsOut)
    {
        NSMutableDictionary *pDictOut = GetDictWithValue(nsOut, 0, 0);
        [pReturnDict setObject:pDictOut forKey:tztWaiPan];
    }
    
    //内盘
    NSString* nsIn = NStringOfLong(pNewPriceData->m_lInside/nHand);
    if (nsIn)
    {
        NSMutableDictionary *pDictIn = GetDictWithValue(nsIn, 0, 0);
        [pReturnDict setObject:pDictIn forKey:tztNeiPan];
    }
    
    
    //上涨
    NSString* nsUp = NStringOfULong(pNewPriceData->a.StockData.p2);
    if (nsUp == NULL || [nsUp length] < 1)
        nsUp = @"--";
    NSMutableDictionary *pDictUp = GetDictWithValue(nsUp, 1, 0);
    [pReturnDict setObject:pDictUp forKey:tztUpStocks];
    
    //平盘
    NSString* nsFlat = NStringOfULong(pNewPriceData->a.StockData.p3);
    if (nsFlat == NULL || [nsFlat length] < 1)
        nsFlat = @"--";
    NSMutableDictionary *pDictFlat = GetDictWithValue(nsFlat, 0, 0);
    [pReturnDict setObject:pDictFlat forKey:tztFlatStocks];
    
    //下跌
    NSString* nsDown = NStringOfULong(pNewPriceData->a.StockData.Q2);
    if (nsDown == NULL || [nsDown length] < 1)
        nsDown = @"--";
    NSMutableDictionary *pDictDown = GetDictWithValue(nsDown, 0, 1);
    [pReturnDict setObject:pDictDown forKey:tztDownStocks];
}

+(void)dealWithQHStockPrice:(TNewPriceData*)pNewPriceData andHand_:(int)nHand pDict_:(NSMutableDictionary*)pReturnDict
{
    if (pNewPriceData == NULL || pReturnDict == NULL)
        return;
    
    //股票代码
    NSString* nsCode = [[[NSString alloc] initWithBytes:pNewPriceData->Code
                                                 length:sizeof(pNewPriceData->Code)
                                               encoding:NSASCIIStringEncoding] autorelease];
    
    if(nsCode == NULL)
        nsCode = @"-";
    NSMutableDictionary *pDictCode = GetDictWithValue(nsCode, 0, 0);
    [pReturnDict setObject:pDictCode forKey:tztCode];
    
    //股票名称
    NSString* nsName = getName_TNewPriceData(pNewPriceData);
    if (nsName == NULL)
        nsName = @"--";
    NSMutableDictionary *pDictName = GetDictWithValue(nsName, 0, 0);
    [pReturnDict setObject:pDictName forKey:tztName];
    
    int nUnit = 1000;
    
//    int nHand = 100;
    
    
    //最新
    NSString* nsNewPrice = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Last_p,
                                                     0,
                                                     pNewPriceData->nDecimal,
                                                     nUnit);
    if (nsNewPrice)
    {
        NSMutableDictionary *pDictNew = GetDictWithValue(nsNewPrice, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictNew forKey:tztNewPrice];
    }
    
    //涨跌
    NSString* nsRatio = NSStringOfVal_Ref_Dec_Div((pNewPriceData->Last_p > 0) ? (pNewPriceData->Last_p - pNewPriceData->Close_p) : 0,
                                                  0,
                                                  pNewPriceData->nDecimal,
                                                  nUnit);
    if (nsRatio == NULL)
        nsRatio = @"-.-";
    NSMutableDictionary *pDictRatio = GetDictWithValue(nsRatio, pNewPriceData->Last_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictRatio forKey:tztUpDown];
    
    //涨跌幅
    NSString* nsPriceRange = @"-";
    if(pNewPriceData->Close_p != 0)
        nsPriceRange = [NSString stringWithFormat:@"%.2f%%",((pNewPriceData->Last_p > 0) ? (pNewPriceData->Last_p - pNewPriceData->Close_p) : 0) * 100.f / pNewPriceData->Close_p];
    
    if (nsPriceRange)
    {
        NSMutableDictionary *pDictRange = GetDictWithValue(nsPriceRange, pNewPriceData->Last_p, pNewPriceData->Close_p);
        [pReturnDict setObject:pDictRange forKey:tztPriceRange];
    }
    
    //前结
    NSString* strValue = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p8,0,pNewPriceData->nDecimal,nUnit);
    if (!ISNSStringValid(strValue))
        strValue = @"-.-";
    NSMutableDictionary *pDict = GetDictWithValue(strValue, pNewPriceData->a.StockData.p8, pNewPriceData->Close_p);
    [pReturnDict setObject:pDict forKey:tztYesTodayPrice];
    
    //开盘
    NSString* strOpen = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Open_p,0,pNewPriceData->nDecimal,nUnit);
    if (!ISNSStringValid(strValue))
        strOpen = @"-.-";
    NSMutableDictionary *pDictOpen = GetDictWithValue(strOpen, pNewPriceData->Open_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictOpen forKey:tztStartPrice];
    
    //最高
    NSString* strMax = NSStringOfVal_Ref_Dec_Div(pNewPriceData->High_p,0,pNewPriceData->nDecimal,nUnit);
    if (!ISNSStringValid(strMax))
        strMax = @"-.-";
    NSMutableDictionary *pDictMax = GetDictWithValue(strMax, pNewPriceData->High_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictMax forKey:tztMaxPrice];
    
    //最低
    NSString* strMin = NSStringOfVal_Ref_Dec_Div(pNewPriceData->Low_p,0,pNewPriceData->nDecimal,nUnit);
    if (!ISNSStringValid(strMin))
        strMin = @"-.-";
    NSMutableDictionary *pDictMin = GetDictWithValue(strMin, pNewPriceData->Low_p, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictMin forKey:tztMinPrice];
    
    //委比
//    long BuyCount = pNewPriceData->a.StockData.Q1;
//    
//    long SellCount = pNewPriceData->a.StockData.Q4;
//    long A = BuyCount - SellCount;
//    long B = BuyCount + SellCount;
    long lBi= pNewPriceData->m_nWB;// 0;
    int nFlag = 0;
//    if((B != 0) && (A != 0))
//    {
//        double lWeiBi= (10000.0 * (double)A/(double)B);
        if ( lBi> 0 )
        {
//            lBi = (long)(lWeiBi+0.5);
            nFlag = 1;
        }
        else if (lBi == 0)
        {
        }
        else
        {
//            lBi = (long)(lWeiBi-0.5);
            nFlag = -1;
        }
//    }
    
    NSString* strWB = [NSString stringWithFormat:@"%.2f%%",lBi / 100.f];
    NSMutableDictionary *pDictWB = GetDictWithValue(strWB, nFlag, 0);
    [pReturnDict setObject:pDictWB forKey:tztWRange];
    
    //委差
    long lWeiCa = pNewPriceData->m_nWC;// (A / nHand);
    NSString* strWC = [NSString stringWithFormat:@"%ld",lWeiCa];
    NSMutableDictionary *pDictWC = GetDictWithValue(strWC, nFlag, 0);
    [pReturnDict setObject:pDictWC forKey:tztWCha];
    
    //卖价
    NSString* strSell =  NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p4,0,pNewPriceData->nDecimal,nUnit);
    NSMutableDictionary *pDictSell = GetDictWithValue(strSell, pNewPriceData->a.StockData.p4, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictSell forKey:tztSell1];
    
    //买价
    NSString* strBuy = NSStringOfVal_Ref_Dec_Div(pNewPriceData->a.StockData.p1,0,pNewPriceData->nDecimal,nUnit);
    NSMutableDictionary *pDictBuy = GetDictWithValue(strBuy, pNewPriceData->a.StockData.p1, pNewPriceData->Close_p);
    [pReturnDict setObject:pDictBuy forKey:tztBuy1];
    
    //总手
    NSString* strTotal = NStringOfULong(pNewPriceData->Total_h / nHand);
    NSMutableDictionary *pDictTotal = GetDictWithValue(strTotal, 0, 0);
    [pReturnDict setObject:pDictTotal forKey:tztTradingVolume];
    
    //现手
    NSString* strNowHand = NStringOfULong(pNewPriceData->a.StockData.Last_h/nHand);
    NSMutableDictionary *pDictHand = GetDictWithValue(strNowHand, 0, 0);
    [pReturnDict setObject:pDictHand forKey:tztNowVolume];
    
    //日增
    NSString* strRZ = NStringOfLong(pNewPriceData->a.StockData.p7/nHand);
    NSMutableDictionary *pDictRZ = GetDictWithValue(strRZ, 0, 0);
    [pReturnDict setObject:pDictRZ forKey:tztDayADD];
    
    //总持
    NSString* strZC = NStringOfULong(pNewPriceData->a.StockData.p2/nHand);
    NSMutableDictionary *pDictZC = GetDictWithValue(strZC, 0, 0);
    [pReturnDict setObject:pDictZC forKey:tztZCVolume];
    
    //内盘
    NSString* strNP = NStringOfULong(pNewPriceData->a.StockData.P5/nHand);
    NSMutableDictionary *pDictNP = GetDictWithValue(strNP, 0, 0);
    [pReturnDict setObject:pDictNP forKey:tztNeiPan];
    
    //外盘
    NSString* strWP = NStringOfULong(pNewPriceData->a.StockData.P6/nHand);
    NSMutableDictionary *pDictWP = GetDictWithValue(strWP, 0, 0);
    [pReturnDict setObject:pDictWP forKey:tztWaiPan];
    
}

+(void)dealwithWPStockPrice:(TNewPriceData *)pNewPriceData pDict_:(NSMutableDictionary *)pReturnDict
{
    [TZTPriceData dealWithIndexPrice:pNewPriceData pDict_:pReturnDict];
}

NSMutableDictionary* GetDictWithValue(NSString* nsValue, int fValue, int fCompare)
{
    if (nsValue == NULL)
        return NULL;
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setObject:nsValue forKey:tztValue];
    
    UIColor *pColor = [UIColor tztThemeHQBalanceColor];
    if (fValue > fCompare)
        pColor = [UIColor tztThemeHQUpColor];
    else if (fValue < fCompare)
        pColor = [UIColor tztThemeHQDownColor];
    [pDict setObject:pColor forKey:tztColor];
    
    return [pDict autorelease];
}
@end
