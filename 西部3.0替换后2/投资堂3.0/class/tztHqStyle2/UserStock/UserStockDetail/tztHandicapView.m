

#import "tztHandicapView.h"
#define tztTitleKey @"tztTitle"
#define tztViewTagStart 0x2222

@interface tztHandicapView()
{
    int _nCurrentType;
}
@property(nonatomic,retain)NSMutableArray   *ayContent;
@property(nonatomic,retain)NSMutableArray   *ayViews;
@property(nonatomic)NSInteger   nHSIndexStock;
@property(nonatomic,retain)UILabel  *lbUpTitle;
@property(nonatomic,retain)UILabel  *lbUpValue;
@property(nonatomic,retain)UILabel  *lbDownTitle;
@property(nonatomic,retain)UILabel  *lbDownValue;
@property(nonatomic,retain)UILabel  *lbFlatTitle;
@property(nonatomic,retain)UILabel  *lbFlatValue;
-(void)clearAllViews;
@end
@implementation tztHandicapView

-(void)initdata
{
    if (_ayContent == nil)
        _ayContent = NewObject(NSMutableArray);
    if (_ayViews == nil)
        _ayViews = NewObject(NSMutableArray);
}

-(void)dealloc
{
    DelObject(_ayViews);
    DelObject(_ayContent);
    [super dealloc];
}

-(UILabel*)CreateLabel:(CGRect)rc text_:(NSString*)text font_:(UIFont*)font alignment_:(NSTextAlignment)alignment nTag_:(NSInteger)nTag
{
    UILabel *label = [[UILabel alloc] initWithFrame:rc];
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.font = font;
    label.text = text;
    label.textAlignment = alignment;
    if (nTag > 0)
        label.tag = nTag;
    label.textColor = [UIColor tztThemeHQFixTextColor];
    return [label autorelease];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    CGFloat fXMargin = 10;
    CGFloat fYMargin = 3;
    
    rcFrame.origin.x += 20;
    rcFrame.size.width -= 2*20;
    rcFrame.origin.y += 20;
    rcFrame.size.height -= 2*20;
    
    NSInteger nCount = _ayContent.count;
    
    UIFont *font = tztUIBaseViewTextFont(13);
    if (_nHSIndexStock == 1)
    {
        CGRect rcIndex = rcFrame;
        rcIndex.origin.y += rcFrame.size.height - 20;
        rcIndex.size.height = 30;
        CGFloat fTitleWidth = [@"上涨个股:" sizeWithFont:font].width;
        CGFloat fIndexWidth = (rcIndex.size.width)/3;
        CGRect rcTitle = rcIndex;
        rcTitle.size.width = fTitleWidth;
        NSDictionary *dict = [_ayContent objectAtIndex:nCount-3];
        NSString* strTitle = [dict tztObjectForKey:tztTitleKey];
        NSString* strValue = [dict tztObjectForKey:tztValue];
        if (_lbUpTitle == nil)
        {
            _lbUpTitle = [self CreateLabel:rcTitle text_:strTitle font_:font alignment_:NSTextAlignmentRight nTag_:-1];
            [self addSubview:_lbUpTitle];
        }
        else
            _lbUpTitle.frame = rcTitle;
        _lbUpTitle.text = strTitle;
        _lbUpTitle.hidden = NO;
        
        CGRect rcValue = rcTitle;
        rcValue.origin.x += rcTitle.size.width;
        rcValue.size.width = fIndexWidth - fTitleWidth;
        if (_lbUpValue == nil)
        {
            _lbUpValue = [self CreateLabel:rcValue text_:strValue font_:font alignment_:NSTextAlignmentCenter nTag_:-1];
            [self addSubview:_lbUpValue];
        }
        else
            _lbUpValue.frame = rcValue;
        _lbUpValue.text = strValue;
        _lbUpValue.textColor = [UIColor tztThemeHQUpColor];
        _lbUpValue.hidden = NO;
        
        dict = [_ayContent objectAtIndex:nCount -2];
        strTitle = [dict tztObjectForKey:tztTitleKey];
        strValue = [dict tztObjectForKey:tztValue];
        rcTitle.origin.x = rcValue.origin.x + rcValue.size.width;
        if (_lbDownTitle == nil)
        {
            _lbDownTitle = [self CreateLabel:rcTitle text_:strTitle font_:font alignment_:NSTextAlignmentRight nTag_:-1];
            [self addSubview:_lbDownTitle];
        }
        else
            _lbDownTitle.frame = rcTitle;
        _lbDownTitle.hidden = NO;
        
        rcValue.origin.x = rcTitle.origin.x + rcTitle.size.width;
        if (_lbDownValue == nil)
        {
            _lbDownValue = [self CreateLabel:rcValue text_:strValue font_:font alignment_:NSTextAlignmentCenter nTag_:-1];
            [self addSubview:_lbDownValue];
        }
        else
            _lbDownValue.frame = rcValue;
        _lbDownValue.text = strValue;
        _lbDownValue.textColor = [UIColor tztThemeHQDownColor];
        _lbDownValue.hidden = NO;
        
        dict = [_ayContent objectAtIndex:nCount -1];
        strTitle = [dict tztObjectForKey:tztTitleKey];
        strValue = [dict tztObjectForKey:tztValue];
        rcTitle.origin.x = rcValue.origin.x + rcValue.size.width;
        if (_lbFlatTitle == nil)
        {
            _lbFlatTitle = [self CreateLabel:rcTitle text_:strTitle font_:font alignment_:NSTextAlignmentRight nTag_:-1];
            [self addSubview:_lbFlatTitle];
        }
        else
            _lbFlatTitle.frame = rcTitle;
        _lbFlatTitle.hidden = NO;
        
        rcValue.origin.x = rcTitle.origin.x + rcTitle.size.width;
        if (_lbFlatValue == nil)
        {
            _lbFlatValue = [self CreateLabel:rcValue text_:strValue font_:font alignment_:NSTextAlignmentCenter nTag_:-1];
            [self addSubview:_lbFlatValue];
        }
        else
            _lbFlatValue.frame = rcValue;
        _lbFlatValue.text = strValue;
        _lbFlatValue.textColor = [UIColor tztThemeHQBalanceColor];
        _lbFlatValue.hidden = NO;
        
        nCount -= 3;
        rcFrame.size.height -= 30;
    }
    else
    {
        _lbUpTitle.hidden = YES;
        _lbUpValue.hidden = YES;
        _lbDownValue.hidden = YES;
        _lbDownTitle.hidden = YES;
        _lbFlatValue.hidden = YES;
        _lbFlatTitle.hidden = YES;
    }
    
    NSInteger nCols = 2;
    NSInteger nRows = (nCount/ nCols) + (nCount % nCols);
    NSInteger nIndex = 0;
    if (nRows <= 0)
        nRows = 1;
    
    
    CGRect rc = rcFrame;
    rc.size.height = (rcFrame.size.height - (nRows-1)*fYMargin) / nRows;
    rc.size.width = (rcFrame.size.width-(nCols)*fXMargin) / nCols;
    
    
    UIColor* clFixText = [UIColor tztThemeHQFixTextColor];
    for (NSInteger i = 0; i < nRows; i++)
    {
        for (NSInteger j = 0; j < nCols; j++)
        {
            CGRect rcTitle = rc;
            rcTitle.size.width = rc.size.width / 2;
            if (nIndex >= nCount)
                break;
            NSDictionary* dict = [_ayContent objectAtIndex:nIndex];
            NSString* strTitle = [dict tztObjectForKey:tztTitleKey];
            UILabel *labelTitle = (UILabel*)[self viewWithTag:tztViewTagStart+nIndex];
            if (labelTitle == nil)
            {
                labelTitle = [self CreateLabel:rcTitle text_:strTitle font_:font alignment_:NSTextAlignmentLeft nTag_:tztViewTagStart+nIndex];
                [self addSubview:labelTitle];
                [_ayViews addObject:labelTitle];
            }
            else
            {
                labelTitle.frame = rcTitle;
            }
            labelTitle.hidden = NO;
            labelTitle.backgroundColor = [UIColor clearColor];
            labelTitle.text = strTitle;
            
            
            CGRect rcValue = rcTitle;
            rcValue.origin.x += rcTitle.size.width;
            NSString* strValue = [dict tztObjectForKey:tztValue];
            UIColor *pColor = [dict tztObjectForKey:tztColor];
            UILabel *labelValue = (UILabel*)[self viewWithTag:tztViewTagStart*2+nIndex];
            if (labelValue == nil)
            {
                labelValue = [self CreateLabel:rcValue text_:strValue font_:font alignment_:NSTextAlignmentRight nTag_:tztViewTagStart*2+nIndex];
                [self addSubview:labelValue];
                [_ayViews addObject:labelValue];
            }
            else
            {
                labelValue.frame = rcValue;
            }
            labelValue.hidden = NO;
            labelValue.text = strValue;
            labelValue.textColor = (pColor ? pColor : clFixText);
            
            nIndex++;
            rc.origin.x += rc.size.width + fXMargin* 2;
        }
        
        rc.origin.x = rcFrame.origin.x;
        rc.origin.y += rc.size.height + fYMargin;
    }
    
    for (NSInteger i = nIndex * 2; i < _ayViews.count; i++)
    {
        UIView *pView = [_ayViews objectAtIndex:i * 2];
        pView.hidden = YES;
    }
    
}

-(void)clearAllViews
{
    [_ayViews removeAllObjects];
    for (UIView *view in self.subviews)
    {
        view.hidden = YES;
        [view removeFromSuperview];
        view = NULL;
    }
}

-(void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    [super setPStockInfo:pStockInfo];
    [self clearAllViews];
}

-(void)UpdateData:(id)obj
{
    NSMutableDictionary *stockDic = [TZTPriceData stockDic];
    
    NSMutableDictionary *dictCode = [stockDic tztObjectForKey:tztCode];
    NSString* strCode = [dictCode tztObjectForKey:tztValue];
    strCode = [strCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* strCurrent = self.pStockInfo.stockCode;
    strCurrent = [strCurrent stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strCode && [strCode caseInsensitiveCompare:strCurrent] != NSOrderedSame)
        return;
    //组织数据
    if (_ayContent == NULL)
        _ayContent = NewObject(NSMutableArray);
    [_ayContent removeAllObjects];
    
    if (_nCurrentType != self.pStockInfo.stockType)
    {
        [self clearAllViews];
        _nCurrentType = self.pStockInfo.stockType;
    }
    _nHSIndexStock = 0;
    if (MakeHKMarketStock(self.pStockInfo.stockType))
    {
        //今开
        NSMutableDictionary* dictStart = [stockDic tztObjectForKey:tztStartPrice];
        [dictStart setTztObject:@"今开:" forKey:tztTitleKey];
        [_ayContent addObject:dictStart];
        
        //昨收
        NSMutableDictionary* dictPreClost = [stockDic tztObjectForKey:tztYesTodayPrice];
        [dictPreClost setTztObject:@"昨收:" forKey:tztTitleKey];
        [_ayContent addObject:dictPreClost];
        
        //现量
        NSMutableDictionary* dictNowHand = [stockDic tztObjectForKey:tztNowVolume];
        [dictNowHand setTztObject:@"现量:" forKey:tztTitleKey];
        [_ayContent addObject:dictNowHand];
        
        //总量
        NSMutableDictionary* dictTotalHand = [stockDic tztObjectForKey:tztTradingVolume];
        [dictTotalHand setTztObject:@"总量:" forKey:tztTitleKey];
        [_ayContent addObject:dictTotalHand];
        
        //量比
        NSMutableDictionary* dictLB = [stockDic tztObjectForKey:tztVolumeRatio];
        [dictLB setTztObject:@"量比:" forKey:tztTitleKey];
        [_ayContent addObject:dictLB];
        
        //委比
        NSMutableDictionary* dictWB = [stockDic tztObjectForKey:tztWRange];
        [dictWB setTztObject:@"委比:" forKey:tztTitleKey];
        [_ayContent addObject:dictWB];
        
        //委比
        NSMutableDictionary* dictWC = [stockDic tztObjectForKey:tztWCha];
        [dictWC setTztObject:@"委比:" forKey:tztTitleKey];
        [_ayContent addObject:dictWC];
        
    }
    else if (MakeIndexMarket(self.pStockInfo.stockType))
    {
        //成交量
        NSMutableDictionary* dictAmount = [stockDic tztObjectForKey:tztTradingVolume];
        [dictAmount setTztObject:@"成交量:" forKey:tztTitleKey];
        [_ayContent addObject:dictAmount];
        
        //昨收
        NSMutableDictionary* dictClose = [stockDic tztObjectForKey:tztYesTodayPrice];
        [dictClose setTztObject:@"昨收:" forKey:tztTitleKey];
        [_ayContent addObject:dictClose];
        
        //委买
        NSMutableDictionary* dictBuy = [stockDic tztObjectForKey:tztWBuy];
        [dictBuy setTztObject:@"委买:" forKey:tztTitleKey];
        [_ayContent addObject:dictBuy];
        
        //委卖
        NSMutableDictionary* dictSell = [stockDic tztObjectForKey:tztWSell];
        [dictSell setTztObject:@"委卖:" forKey:tztTitleKey];
        [_ayContent addObject:dictSell];
        
        //量比
        NSMutableDictionary* dictLB = [stockDic tztObjectForKey:tztVolumeRatio];
        [dictLB setTztObject:@"量比:" forKey:tztTitleKey];
        [_ayContent addObject:dictLB];
        
        //换手
        NSMutableDictionary* dictHS = [stockDic tztObjectForKey:tztHuanShou];
        [dictHS setTztObject:@"换手:" forKey:tztTitleKey];
        [_ayContent addObject:dictHS];
        
        //上涨
        NSMutableDictionary* dictUp = [stockDic tztObjectForKey:tztUpStocks];
        [dictUp setTztObject:@"上涨个股:" forKey:tztTitleKey];
        [_ayContent addObject:dictUp];
        
        //下跌
        NSMutableDictionary* dictDown = [stockDic tztObjectForKey:tztDownStocks];
        [dictDown setTztObject:@"下跌个股:" forKey:tztTitleKey];
        [_ayContent addObject:dictDown];
        
        //平盘
        NSMutableDictionary* dictFlat = [stockDic tztObjectForKey:tztFlatStocks];
        [dictFlat setTztObject:@"平盘个股:" forKey:tztTitleKey];
        [_ayContent addObject:dictFlat];
        
        _nHSIndexStock = 1;
    }
    else if(MakeStockMarketStock(self.pStockInfo.stockType))
    {
        //今开
        NSMutableDictionary* dictStart = [stockDic tztObjectForKey:tztStartPrice];
        [dictStart setTztObject:@"今开:" forKey:tztTitleKey];
        [_ayContent addObject:dictStart];
        
        //昨收
        NSMutableDictionary* dictPreClost = [stockDic tztObjectForKey:tztYesTodayPrice];
        [dictPreClost setTztObject:@"昨收:" forKey:tztTitleKey];
        [_ayContent addObject:dictPreClost];
        
        //涨停
        NSMutableDictionary* dictMaxPrice = [stockDic tztObjectForKey:tztZTPrice];
        [dictMaxPrice setTztObject:@"涨停:" forKey:tztTitleKey];
        [_ayContent addObject:dictMaxPrice];
        
        //跌停
        NSMutableDictionary* dictMinPrice = [stockDic tztObjectForKey:tztDTPrice];
        [dictMinPrice setTztObject:@"跌停:" forKey:tztTitleKey];
        [_ayContent addObject:dictMinPrice];
        
        //成交额
        NSMutableDictionary* dictCJE = [stockDic tztObjectForKey:tztTransactionAmount];
        [dictCJE setTztObject:@"成交额:" forKey:tztTitleKey];
        [_ayContent addObject:dictCJE];
        
        //量比
        NSMutableDictionary* dictLB = [stockDic tztObjectForKey:tztVolumeRatio];
        [dictLB setTztObject:@"量比:" forKey:tztTitleKey];
        [_ayContent addObject:dictLB];
        
        //外盘
        NSMutableDictionary* dictOut = [stockDic tztObjectForKey:tztWaiPan];
        [dictOut setTztObject:@"外盘:" forKey:tztTitleKey];
        [_ayContent addObject:dictOut];
        
        //内盘
        NSMutableDictionary* dictIn = [stockDic tztObjectForKey:tztNeiPan];
        [dictIn setTztObject:@"内盘:" forKey:tztTitleKey];
        [_ayContent addObject:dictIn];
        
        //市盈率(动)
        NSMutableDictionary* dictDTSYL = [stockDic tztObjectForKey:tztPE];
        [dictDTSYL setTztObject:@"市盈(动):" forKey:tztTitleKey];
        [_ayContent addObject:dictDTSYL];
        
        //市盈率(静)
        NSMutableDictionary* dictJTSYL = [stockDic tztObjectForKey:tztPEStatic];
        [dictJTSYL setTztObject:@"市盈(静):" forKey:tztTitleKey];
        [_ayContent addObject:dictJTSYL];
        
        //净资产
        NSMutableDictionary* dictJZC = [stockDic tztObjectForKey:tztMeiGuJingZiChan];
        [dictJZC setTztObject:@"净资产:" forKey:tztTitleKey];
        [_ayContent addObject:dictJZC];
        
        //市净率
        NSMutableDictionary* dictSJL = [stockDic tztObjectForKey:tztSJL];
        [dictSJL setTztObject:@"市净率:" forKey:tztTitleKey];
        [_ayContent addObject:dictSJL];
        
        //总资本
        NSMutableDictionary* dictZGB = [stockDic tztObjectForKey:tztZongGuBen];
        [dictZGB setTztObject:@"总股本:" forKey:tztTitleKey];
        [_ayContent addObject:dictZGB];
        
        //总市值
        NSMutableDictionary* dictZSZ = [stockDic tztObjectForKey:tztZongGuBenMoney];
        [dictZSZ setTztObject:@"总市值:" forKey:tztTitleKey];
        [_ayContent addObject:dictZSZ];
        
        //流通股本
        NSMutableDictionary* dictLTGB = [stockDic tztObjectForKey:tztLiuTongPan];
        [dictLTGB setTztObject:@"流通股本:" forKey:tztTitleKey];
        [_ayContent addObject:dictLTGB];
        
        //流通市值
        NSMutableDictionary* dictLTSZ = [stockDic tztObjectForKey:tztLiuTongPanMoney];
        [dictLTSZ setTztObject:@"流通市值:" forKey:tztTitleKey];
        [_ayContent addObject:dictLTSZ];
        
        //收益(三)
        NSString* strTitle = @"收益:";
        NSMutableDictionary* dictSYS = [stockDic tztObjectForKey:tztSeason];
        NSString* str = [dictSYS tztObjectForKey:tztValue];
        if (str.length > 0)
        {
            switch ([str intValue])
            {
                case 3:
                    strTitle = @"收益(一):";
                    break;
                case 6:
                    strTitle = @"收益(二):";
                    break;
                case 9:
                    strTitle = @"收益(三):";
                    break;
                case 12:
                    strTitle = @"收益(四):";
                    break;
                default:
                    strTitle = @"收益";
                    break;
            }
        }
        
        NSMutableDictionary* dictMGSY = [stockDic tztObjectForKey:tztSeasonValue];
        [dictMGSY setTztObject:strTitle forKey:tztTitleKey];
        [_ayContent addObject:dictMGSY];
    }
    
    [self setFrame:self.frame];
}

@end
