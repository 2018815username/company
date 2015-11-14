
#import "tztUIStockDetailHeaderViewEx.h"
#import "TZTInitReportMarketMenu.h"

@interface tztNewPriceView : tztHqBaseView

@property(nonatomic)BOOL bShowUserStock;
@property(nonatomic,retain)UIButton *pBtnUserStock; //自选按钮
@property(nonatomic,retain)UIImageView *pImageView;
@property(nonatomic,retain)UILabel *lbPrice;        //最新价格
@property(nonatomic,retain)UILabel *lbRatio;        //涨跌值
@property(nonatomic,retain)UILabel *lbRange;        //涨跌幅

-(void)updateContent;
@end

@implementation tztNewPriceView
@synthesize bShowUserStock = _bShowUserStock;

-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)initViews
{
    //自选添加或者删除
    if (_pBtnUserStock == NULL)
    {
        _pBtnUserStock = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnUserStock addTarget:self
                           action:@selector(OnUserStock:)
                 forControlEvents:UIControlEventTouchUpInside];
        _pBtnUserStock.showsTouchWhenHighlighted = YES;
        _pBtnUserStock.backgroundColor = [UIColor clearColor];
        [self addSubview:_pBtnUserStock];
    }
    
    if (_pImageView == NULL)
    {
        _pImageView = [[UIImageView alloc] init];
        _pImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_pImageView];
        [_pImageView release];
    }
    
    //最新价
    if (_lbPrice == nil)
    {
        _lbPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbPrice.font = tztUIBaseViewTextFont(28);
        _lbPrice.adjustsFontSizeToFitWidth = YES;
        _lbPrice.textAlignment = NSTextAlignmentCenter;
        _lbPrice.text = @"-.-";
        _lbPrice.backgroundColor = [UIColor clearColor];
        [self addSubview: _lbPrice];
        [_lbPrice release];
    }
    
    //涨跌值
    if (_lbRatio == nil)
    {
        _lbRatio = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbRatio.font = tztUIBaseViewTextFont(12);
        _lbRatio.adjustsFontSizeToFitWidth = YES;
        _lbRatio.textAlignment = NSTextAlignmentLeft;
        _lbRatio.backgroundColor = [UIColor clearColor];
        _lbRatio.text = @"-.-";
        [self addSubview:_lbRatio];
        [_lbRatio release];
    }
    
    //涨跌幅
    if (_lbRange == Nil)
    {
        _lbRange = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbRange.font = tztUIBaseViewTextFont(12);
        _lbRange.adjustsFontSizeToFitWidth = YES;
        _lbRange.textAlignment = NSTextAlignmentLeft;
        _lbRange.backgroundColor = [UIColor clearColor];
        _lbRange.text = @"-.-%";
        [self addSubview:_lbRange];
        [_lbRange release];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    _bShowUserStock = 0;
    int nCount = 2;
    if (!_bShowUserStock)
        nCount += 1;
    CGFloat fXMargin = 5;
    CGFloat fYMargin = 5;
    CGFloat fUserStockWidth = 60;
    if (!_bShowUserStock)
        fUserStockWidth = 0;
    CGFloat fWidth = self.bounds.size.width - (fXMargin * nCount);
    CGFloat fHeight = self.bounds.size.height - (fYMargin+(20));
    
    CGRect rcNewPrice = self.bounds;
    rcNewPrice.origin.x = fXMargin;
    rcNewPrice.origin.y = 10;
    rcNewPrice.size.width = fWidth - fUserStockWidth;
    rcNewPrice.size.height = fHeight / 2;
    self.lbPrice.frame = rcNewPrice;
    
    CGRect rcRatio = rcNewPrice;
    rcRatio.origin.y += fYMargin + rcNewPrice.size.height;
    rcRatio.size.height = fHeight / 2;
    rcRatio.size.width = rcNewPrice.size.width / 2 - fXMargin;
    self.lbRatio.frame = rcRatio;
    
    CGRect rcRange = rcRatio;
    rcRange.origin.x += rcRatio.size.width + fXMargin;
    self.lbRange.frame = rcRange;
    
    CGRect rcUserStock = rcNewPrice;
    rcUserStock.origin.x += rcNewPrice.size.width + fXMargin;
    rcUserStock.size.width = fUserStockWidth;
    rcUserStock.size.height = fHeight;
    self.pBtnUserStock.frame = rcUserStock;
    self.pBtnUserStock.hidden = !_bShowUserStock;
}

-(void)setPStockInfo:(tztStockInfo *)stockInfo
{
    NSString* strCode = self.pStockInfo.stockCode;
    [super setPStockInfo:stockInfo];
    [self initViews];
    if (strCode && [stockInfo.stockCode caseInsensitiveCompare:strCode] != NSOrderedSame)
    {
        self.lbPrice.text = @"-.-";
        self.lbRatio.text = @"--";
        self.lbRange.text = @"--";
    }
}

-(void)updateContent
{
    NSDictionary *stockDic = [TZTPriceData stockDic];
    if (stockDic.count == 0)
        return;
    
    NSMutableDictionary *pDictCode = [stockDic objectForKey:tztCode];
    NSString* strCode = [pDictCode objectForKey:tztValue];
    if (strCode.length <= 0)
        return;
    strCode = [strCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *strCodeNow = [NSString stringWithFormat:@"%@", self.pStockInfo.stockCode];
    strCodeNow = [strCodeNow stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([strCode caseInsensitiveCompare:strCodeNow]!= NSOrderedSame)
        return;
    
    NSMutableDictionary* pDictUpDown = [stockDic objectForKey:tztUpDown];
    NSMutableDictionary* pDictNewPrice = [stockDic objectForKey:tztNewPrice];
    NSMutableDictionary* pDictRange = [stockDic objectForKey:tztPriceRange];
    
    NSString *strPrice = self.lbPrice.text;
    NSString *strNewPrice = [pDictNewPrice objectForKey:tztValue];
    self.lbPrice.text = strNewPrice;
    
    UIColor *pColor = [UIColor clearColor];
    BOOL bChange = FALSE;
    if ([strNewPrice isEqualToString:strPrice] || [strPrice caseInsensitiveCompare:@"-.-"] == NSOrderedSame)
        pColor = [UIColor clearColor];
    else if ([strNewPrice floatValue] > [strPrice floatValue])
    {
        pColor = [UIColor tztThemeHQUpColor];
        bChange = YES;
    }
    else
    {
        bChange = YES;
        pColor = [UIColor tztThemeHQDownColor];
    }
    
    self.lbPrice.textColor = [pDictNewPrice objectForKey:tztColor];
    self.lbRatio.textColor = [pDictUpDown objectForKey:tztColor];
    self.lbRatio.text = [pDictUpDown objectForKey:tztValue];
    
    [self.lbRatio setTextAlignment:NSTextAlignmentCenter];
    
    self.lbRange.textColor = [pDictRange objectForKey:tztColor];
    self.lbRange.text = [pDictRange objectForKey:tztValue];
    [self.lbRange setTextAlignment:NSTextAlignmentCenter];
}

@end

@interface tztNewQuoteView : tztHqBaseView

@property(nonatomic,retain)NSMutableArray   *ayViews;
@property(nonatomic,retain)NSMutableArray   *ayTitles;
@property(nonatomic,retain)NSMutableArray   *ayKeys;

-(void)updateContent;

@end

@implementation tztNewQuoteView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    [self initViews];
}

-(void)initViews
{
    int nCount = 2;
    CGRect rcBack = self.bounds;
    float fWidth = rcBack.size.width / nCount;

    CGFloat f = 0;
    CGFloat fXMargin = 0;
    CGFloat fYMargin = 0;
    CGFloat fYOffset = 14;
    
    UIFont *font = tztUIBaseViewTextFont(13);
    
    CGFloat fRowHeight = (self.bounds.size.height - 2 * fYOffset - fYMargin) / 2;
    
    for (NSInteger i = 0; i < self.ayKeys.count; i++)
    {
        CGRect rect;
        if (i > 0 && i% nCount == 0)
        {
            f++;
        }
        
        rect = CGRectMake((i%nCount)*fWidth+fXMargin, fRowHeight * f + fYMargin + fYOffset, fWidth * 0.2f, fRowHeight);
        UIButton *jinkai = (UIButton*)[self viewWithTag:i*10+1+0x1234];
        if (jinkai == NULL)
        {
            jinkai = [UIButton buttonWithType:UIButtonTypeCustom];
            jinkai.frame = rect;
            jinkai.userInteractionEnabled = YES;
            jinkai.backgroundColor = [UIColor clearColor];
            [jinkai setTztTitleColor:[UIColor colorWithRed:87.0/255 green:94.0/255 blue:100.0/255 alpha:1.0]];
            jinkai.titleLabel.font = font;
            [jinkai setTztTitle:@""];
            jinkai.titleLabel.textAlignment = NSTextAlignmentCenter;
            jinkai.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            jinkai.tag = i*10+1+0x1234;
            [self addSubview:jinkai];
            [jinkai addTarget:self action:@selector(OnTap) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            jinkai.frame = rect;
        }
        
        
        rect = CGRectMake((i%nCount)*fWidth + rect.size.width +fXMargin, fRowHeight * f + fYMargin + fYOffset, fWidth - rect.size.width - 5, fRowHeight);
        
        UIButton *lb = (UIButton*)[self viewWithTag:i * 1000 + 2 + 0x1234];
        if (lb == NULL)
        {
            lb = [UIButton buttonWithType:UIButtonTypeCustom];
            lb.frame = rect;
            lb.userInteractionEnabled = YES;
            lb.backgroundColor = [UIColor clearColor];
            lb.titleLabel.font = font;
            lb.titleLabel.textAlignment = NSTextAlignmentCenter;
            lb.titleLabel.adjustsFontSizeToFitWidth = YES;
            lb.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            [lb setTztTitle:@"- -"];
            lb.tag = i*1000+2 + 0x1234;
            [self addSubview:lb];
            [lb addTarget:self action:@selector(OnTap) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            lb.frame = rect;
        }

    }
}

-(void)OnTap
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(OnTap:)])
    {
        [self.tztdelegate OnTap:nil];
    }
}

-(void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    if (pStockInfo == NULL)
        return;
    
    //和前面的市场类型判断
    int nMarket = self.pStockInfo.stockType;
    [super setPStockInfo:pStockInfo];
    
//    [self.ayKeys removeAllObjects];
    
    if (nMarket != pStockInfo.stockType)
    {
        for (UIView* pView in self.subviews)
        {
            [pView removeFromSuperview];
            pView = NULL;
        }
    }
    [self initViews];
}

-(void)updateContent
{
    NSDictionary *stockDic = [TZTPriceData stockDic];
    
    NSMutableDictionary *pDictCode = [stockDic objectForKey:tztCode];
    NSString* strCode = [pDictCode objectForKey:tztValue];
    if (strCode.length <= 0)
        return;
    strCode = [strCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *strCodeNow = [NSString stringWithFormat:@"%@", self.pStockInfo.stockCode];
    strCodeNow = [strCodeNow stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([strCode caseInsensitiveCompare:strCodeNow]!= NSOrderedSame)
        return;
    
    for (int i = 0; i < self.ayKeys.count; i ++)
    {
        NSDictionary *dict = [self.ayKeys objectAtIndex:i];
        NSString* strKey = [dict objectForKey:@"keyname"];
        NSString* strTitle = [dict objectForKey:@"name"];
        UIButton *lbCont = (UIButton *)[self viewWithTag:i*1000+2+0x1234];
        NSMutableDictionary *pDict = [stockDic objectForKey:strKey];
        [lbCont setTztTitle:[pDict objectForKey:tztValue]];
        [lbCont setTztTitleColor:[pDict objectForKey:tztColor]];
        
        UIButton *lbTitle = (UIButton *)[self viewWithTag:i*10+1+0x1234];
        
        if (strTitle && [strTitle isEqualToString:tztIndustryName])
        {
            NSMutableDictionary* pDictName = [stockDic objectForKey:tztIndustryName];
            [lbTitle setTztTitle:[pDictName objectForKey:tztValue]];
            [lbTitle setTztTitleColor:[pDict objectForKey:tztColor]];
            
        }
        else
            [lbTitle setTztTitle:strTitle];
    }
}

-(void)setAyKeys:(NSMutableArray *)keys
{
    if (_ayKeys == NULL)
        _ayKeys = NewObject(NSMutableArray);
    [_ayKeys removeAllObjects];
    for (id obj in keys)
        [_ayKeys addObject:obj];
    [self initViews];
}

@end


@interface tztUserTradeStockView : tztHqBaseView
{
    
}
@property(nonatomic)BOOL    bRefresh;
@property(nonatomic,retain)UIButton *pBtnRefresh;
@property(nonatomic,retain)UILabel  *lbCCTitle;
@property(nonatomic,retain)UILabel  *lbCCValue;
@property(nonatomic,retain)UILabel  *lbCBTitle;
@property(nonatomic,retain)UILabel  *lbCBValue;
@property(nonatomic,retain)UILabel  *lbYKTitle;
@property(nonatomic,retain)UILabel  *lbYKValue;
@property(nonatomic,retain)UIButton *btnRefresh;
@property(nonatomic)CGFloat fNewPrice;
@end

@implementation tztUserTradeStockView
-(id)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(DealWithData)
                                                     name:@"tztRefreshTradeData"
                                                   object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"_bRefresh"])
    {
        //处理数据显示
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorSection];
    self.layer.borderColor = [UIColor tztThemeBorderColor].CGColor;
    self.layer.borderWidth = .5f;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    
    UIFont *font = tztUIBaseViewTextFont(10.5f);
    
    CGFloat fXMargin = 5;
    NSString* str = @"成本价:";
    CGFloat fTitleWidth = [str sizeWithFont:font].width;
    CGFloat fHeight = [str sizeWithFont:font].height;
    CGRect rcRefreshBtn = rcFrame;
    rcRefreshBtn.size.width = 40;
    
    CGFloat fValueWidth = (rcFrame.size.width - 5 * fXMargin - rcRefreshBtn.size.width) /  3;
    
//    CGFloat fWidth = (rcFrame.size.width - 60 - )
    if (_pBtnRefresh == nil)
    {
        _pBtnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnRefresh setBackgroundColor:[UIColor clearColor]];
        [_pBtnRefresh setTztImage:[UIImage imageTztNamed:@"tztRefresh.png"]];
        [_pBtnRefresh addTarget:self action:@selector(OnRefreshData:) forControlEvents:UIControlEventTouchUpInside];
        _pBtnRefresh.showsTouchWhenHighlighted = YES;
        [self addSubview:_pBtnRefresh];
        _pBtnRefresh.frame = rcRefreshBtn;
    }
    else
        _pBtnRefresh.frame = rcRefreshBtn;
    
    CGRect rcTitle = rcRefreshBtn;
    rcTitle.origin.x += rcRefreshBtn.size.width + fXMargin;
    rcTitle.origin.y += (self.bounds.size.height - fHeight) / 2;
    rcTitle.size.height = fHeight;
    rcTitle.size.width = fTitleWidth-10;
    if (_lbCCTitle == nil)
    {
        _lbCCTitle = [[UILabel alloc] initWithFrame:rcTitle];
        _lbCCTitle.font = font;
        _lbCCTitle.backgroundColor = [UIColor clearColor];
        _lbCCTitle.textAlignment = NSTextAlignmentRight;
        _lbCCTitle.textColor = [UIColor tztThemeHQFixTextColor];
        _lbCCTitle.text = @"持仓:";
        [self addSubview:_lbCCTitle];
        [_lbCCTitle release];
    }
    else
        _lbCCTitle.frame = rcTitle;
    
    CGRect rcValue = rcTitle;
    rcValue.origin.x += rcTitle.size.width + fXMargin;
    rcValue.size.width = fValueWidth - fTitleWidth - fXMargin;
    if (_lbCCValue == nil)
    {
        _lbCCValue = [[UILabel alloc] initWithFrame:rcValue];
        _lbCCValue.font = font;
        _lbCCValue.backgroundColor = [UIColor clearColor];
        _lbCCValue.textAlignment = NSTextAlignmentLeft;
        _lbCCValue.textColor = [UIColor tztThemeHQBalanceColor];
        _lbCCValue.text = @"";
        _lbCCValue.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_lbCCValue];
        [_lbCCValue release];
    }
    else
        _lbCCValue.frame = rcValue;
    
    rcTitle = rcValue;
    rcTitle.origin.x += rcValue.size.width + fXMargin;
    rcTitle.size.width = fTitleWidth;
    if (_lbCBTitle == nil)
    {
        _lbCBTitle = [[UILabel alloc] initWithFrame:rcTitle];
        _lbCBTitle.backgroundColor =[UIColor clearColor];
        _lbCBTitle.font = font;
        _lbCBTitle.textAlignment = NSTextAlignmentRight;
        _lbCBTitle.textColor = [UIColor tztThemeHQFixTextColor];
        _lbCBTitle.text = @"成本价:";
        [self addSubview:_lbCBTitle];
        [_lbCBTitle release];
    }
    else
        _lbCBTitle.frame = rcTitle;
    
    rcValue = rcTitle;
    rcValue.origin.x += rcTitle.size.width + fXMargin;
    rcValue.size.width = fValueWidth - fTitleWidth - fXMargin;
    if (_lbCBValue == nil)
    {
        _lbCBValue = [[UILabel alloc] initWithFrame:rcValue];
        _lbCBValue.font = font;
        _lbCBValue.backgroundColor = [UIColor clearColor];
        _lbCBValue.textAlignment = NSTextAlignmentLeft;
        _lbCBValue.textColor = [UIColor tztThemeHQBalanceColor];
        _lbCBValue.text = @"";
        _lbCBValue.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_lbCBValue];
        [_lbCBValue release];
    }
    else
        _lbCBValue.frame = rcValue;
    
    rcTitle = rcValue;
    rcTitle.origin.x += rcValue.size.width + fXMargin;
    rcTitle.size.width = fTitleWidth - 10;
    if (_lbYKTitle == nil)
    {
        _lbYKTitle = [[UILabel alloc] initWithFrame:rcTitle];
        _lbYKTitle.backgroundColor = [UIColor clearColor];
        _lbYKTitle.font = font;
        _lbYKTitle.textAlignment = NSTextAlignmentRight;
        _lbYKTitle.text = @"盈亏:";
        _lbYKTitle.textColor = [UIColor tztThemeHQFixTextColor];
        [self addSubview:_lbYKTitle];
        [_lbYKTitle release];
    }
    else
        _lbYKTitle.frame = rcTitle;
    
    rcValue = rcTitle;
    rcValue.origin.x += rcTitle.size.width + fXMargin;
    rcValue.size.width = fValueWidth - rcTitle.size.width;
    if (_lbYKValue == nil)
    {
        _lbYKValue = [[UILabel alloc] initWithFrame:rcValue];
        _lbYKValue.font = font;
        _lbYKValue.backgroundColor = [UIColor clearColor];
        _lbYKValue.textAlignment = NSTextAlignmentLeft;
        _lbYKValue.adjustsFontSizeToFitWidth = YES;
        _lbYKValue.text = @"";
        _lbYKValue.textColor = [UIColor tztThemeHQBalanceColor];
        [self addSubview:_lbYKValue];
        [_lbYKValue release];
    }
    else
        _lbYKValue.frame = rcValue;
    
    
    CGRect rcAll = rcFrame;
    rcAll.origin.x += _pBtnRefresh.frame.size.width;
    rcAll.size.width -= _pBtnRefresh.frame.size.width;
    if (_btnRefresh == nil)
    {
        _btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnRefresh setBackgroundColor:[UIColor clearColor]];
        _btnRefresh.frame = rcAll;
        [self addSubview:_btnRefresh];
        [_btnRefresh addTarget:self action:@selector(OnRefreshData:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
        _btnRefresh.frame = rcAll;
    
}

-(void)OnRefreshData:(id)sender
{
    if (g_pReportMarket)
    {
        [g_pReportMarket RequestTradeCCData];
    }
}

-(void)updateContent
{
    NSDictionary *stockDic = [TZTPriceData stockDic];
    
    NSMutableDictionary *pDictCode = [stockDic objectForKey:tztCode];
    NSString* strCode = [pDictCode objectForKey:tztValue];
    if (strCode.length <= 0)
        return;
    
    NSMutableDictionary* dictPrice = [stockDic objectForKey:tztNewPrice];
    NSString* strPrice = [dictPrice objectForKey:tztValue];
    _fNewPrice = [strPrice floatValue];
    [self DealWithData];
}

-(void)DealWithData
{
    NSDictionary* dict = [tztJYLoginInfo GetTradeStockData:self.pStockInfo];
    if (dict == nil)
        return;
    
    NSString* strPrice = [dict tztObjectForKey:tztNewPrice];
    NSString* strAmount = [dict tztObjectForKey:tztNowVolume];
    
    self.lbCCValue.text = [NSString stringWithFormat:@"%@股", strAmount];
    self.lbCBValue.text = [NSString stringWithFormat:@"%@元", strPrice];
    
    NSString* strYK = [NSString stringWithFormat:@"%.2lf元", (_fNewPrice - [strPrice floatValue]) * [strAmount integerValue]];
    self.lbYKValue.text = strYK;
    if ([strPrice floatValue] > _fNewPrice)
    {
        self.lbYKValue.textColor = [UIColor tztThemeHQDownColor];
    }
    else if ([strPrice floatValue] < _fNewPrice)
    {
        self.lbYKValue.textColor = [UIColor tztThemeHQUpColor];
    }
    else
        self.lbYKValue.textColor = [UIColor tztThemeHQBalanceColor];
}


@end

@interface tztUIStockDetailHeaderViewEx()<tztHqBaseViewDelegate>

@property(nonatomic,retain)tztNewPriceView  *PriceView;
@property(nonatomic,retain)tztNewQuoteView  *QuoteView;
@property(nonatomic,retain)UIButton         *pBtnBlock;
@property(nonatomic,retain)UILabel          *lbBlockCode;
@property(nonatomic,retain)UILabel          *lbBlockName;
@property(nonatomic,retain)UILabel          *lbBlockRange;

@property(nonatomic,retain)UIView   *pBackView;
@property(nonatomic,retain)UIImageView *pImageView;
@property(nonatomic,retain)UIView   *pLine;
@property(nonatomic,retain)UITapGestureRecognizer   *tapGesture;

@property(nonatomic,retain)NSMutableArray   *ayKeys;
@property(nonatomic,retain)NSMutableArray   *ayExchangeKeys;

@property(nonatomic,retain)tztUserTradeStockView    *pUserTradeStockView;
@end

@implementation tztUIStockDetailHeaderViewEx

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void)initViews
{
    if (_tapGesture == NULL)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTap:)];
        [self addGestureRecognizer:_tapGesture];
        [_tapGesture release];
    }
    
    CGRect rcFrame = self.bounds;
    BOOL bHasBlock = FALSE;
    
    BOOL bIsCCStock = FALSE;
    if ([tztJYLoginInfo IsTradeStockInfo:self.pStockInfo])
    {
        bIsCCStock = YES;
        rcFrame.size.height -= 25;
    }
    
    if((MakeStockMarketStock(self.pStockInfo.stockType) && !MakeStockBlock(self.pStockInfo.stockType)))
    {
        bHasBlock = YES;
    }
    
    CGFloat fWidth = rcFrame.size.width / 2;
    if (bHasBlock)
        fWidth = rcFrame.size.width / 3;
    //最新价
    CGRect rcNewPrice = CGRectMake(0, 0, fWidth, rcFrame.size.height);
    if (_PriceView == NULL)
    {
        _PriceView = [[tztNewPriceView alloc] init];
        _PriceView.pStockInfo = self.pStockInfo;
        _PriceView.bShowUserStock = _bShowUserStock;
        _PriceView.frame = rcNewPrice;
        [self addSubview:_PriceView];
        [_PriceView release];
    }
    else
        _PriceView.frame = rcNewPrice;
    
    CGRect rcQuote = rcFrame;
    rcQuote.origin.x += rcNewPrice.size.width;
    if (bHasBlock)
    {
        rcQuote.size.width = fWidth * 2 * 3 / 4 - 5;
    }
    else
        rcQuote.size.width = fWidth;
    if (_QuoteView == NULL)
    {
        _QuoteView = [[tztNewQuoteView alloc] init];
        _QuoteView.pStockInfo = self.pStockInfo;
        _QuoteView.frame = rcQuote;
        [self addSubview:_QuoteView];
        [_QuoteView release];
    }
    else
        _QuoteView.frame = rcQuote;
    
    CGRect rcCC = rcFrame;
    rcCC.origin.y += rcFrame.size.height -5;
    rcCC.size.height = 20;
    rcCC = CGRectInset(rcCC, 5, 0);
    if (_pUserTradeStockView == nil)
    {
        _pUserTradeStockView = [[tztUserTradeStockView alloc] initWithFrame:rcCC];
        [self addSubview:_pUserTradeStockView];
        [_pUserTradeStockView release];
    }
    else
        _pUserTradeStockView.frame = rcCC;
    
    _pUserTradeStockView.hidden = !bIsCCStock;
    
    if (bHasBlock)
    {
        CGRect rcVerLine = rcFrame;
        rcVerLine.origin.x = rcQuote.origin.x + rcQuote.size.width - 3;
        rcVerLine.size.width = 1.f;
        rcVerLine.origin.y += rcFrame.size.height * 0.15;
        rcVerLine.size.height -= rcFrame.size.height * 0.3;
        if (_pLine == NULL)
        {
            _pLine = [[UIView alloc] initWithFrame:rcVerLine];
            _pLine.backgroundColor = [UIColor tztThemeBorderColorGrid];
            [self addSubview:_pLine];
            [_pLine release];
        }
        else
            _pLine.frame = rcVerLine;
        
        CGRect rcBlock = rcFrame;
        rcBlock.origin.y += 2;
        rcBlock.size.height -= 14;
        rcBlock.origin.x = rcVerLine.origin.x + rcVerLine.size.width + 2;
        rcBlock.size.width = rcFrame.size.width - rcBlock.origin.x - 6;
        
        if (_pBtnBlock == Nil)
        {
            _pBtnBlock = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pBtnBlock addTarget:self
                           action:@selector(OnBtnBlock:)
                 forControlEvents:UIControlEventTouchUpInside];
            _pBtnBlock.frame = rcBlock;
            [self addSubview:_pBtnBlock];
        }
        else
            _pBtnBlock.frame = rcBlock;
        
        
        CGFloat fYMargin = 10;
        CGFloat fHeight = (rcFrame.size.height - 2 * fYMargin) / 2;
        
        CGRect rcBlockName = rcBlock;
        rcBlockName.origin.y = fYMargin;
        rcBlockName.size.height = fHeight;
        if (_lbBlockName == nil)
        {
            _lbBlockName = [[UILabel alloc] initWithFrame:rcBlockName];
            _lbBlockName.backgroundColor = [UIColor clearColor];
            _lbBlockName.textAlignment = NSTextAlignmentCenter;
            _lbBlockName.textColor = [UIColor tztThemeTextColorLabel];
            _lbBlockName.adjustsFontSizeToFitWidth = YES;
            _lbBlockName.font = tztUIBaseViewTextFont(12);
            _lbBlockName.userInteractionEnabled = NO;
            _lbBlockName.text = @"--";
            [self addSubview:_lbBlockName];
            [_lbBlockName release];
        }
        else
            _lbBlockName.frame = rcBlockName;
        
        if (_lbBlockCode == nil)
        {
            _lbBlockCode = [[UILabel alloc] initWithFrame:CGRectZero];
            _lbBlockCode.backgroundColor = [UIColor clearColor];
            [self addSubview:_lbBlockCode];
            [_lbBlockCode release];
        }
        
        CGRect rcBlockRange = rcBlockName;
        rcBlockRange.origin.y += rcBlockName.size.height - 4;
        if (_lbBlockRange == nil)
        {
            _lbBlockRange = [[UILabel alloc] initWithFrame:rcBlockRange];
            _lbBlockRange.backgroundColor = [UIColor clearColor];
            _lbBlockRange.textAlignment = NSTextAlignmentCenter;
            _lbBlockRange.adjustsFontSizeToFitWidth = YES;
            _lbBlockRange.font = tztUIBaseViewTextFont(12);
            _lbBlockRange.userInteractionEnabled = NO;
            _lbBlockRange.text = @"-.-%";
            [self addSubview:_lbBlockRange];
            [_lbBlockRange release];
        }
        else
            _lbBlockRange.frame = rcBlockRange;
    }
    
    _pLine.hidden = !bHasBlock;
    _lbBlockName.hidden = !bHasBlock;
    _lbBlockCode.hidden = !bHasBlock;
    _lbBlockRange.hidden = !bHasBlock;
    
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    [self initViews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    self.PriceView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    self.QuoteView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
}

-(void)updateContent
{
    NSDictionary *stockDic = [TZTPriceData stockDic];
    if (stockDic.count == 0) {
        return;
    }
    //
    NSMutableDictionary *pDictCode = [stockDic objectForKey:tztCode];
    NSString* strCode = [pDictCode objectForKey:tztValue];
    if (strCode.length <= 0)
        return;
    strCode = [strCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *strCodeNow = [NSString stringWithFormat:@"%@", self.pStockInfo.stockCode];
    strCodeNow = [strCodeNow stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([strCode caseInsensitiveCompare:strCodeNow]!= NSOrderedSame)
        return;

    [self.PriceView updateContent];
    [self.QuoteView updateContent];
    [self.pUserTradeStockView updateContent];
    //
    
    
    if((MakeStockMarket(self.pStockInfo.stockType) && !MakeStockBlock(self.pStockInfo.stockType))
       /*|| (_bHiddenUserStockBtn && MakeBlockIndex(self.pStockInfo.stockType))*/)//个股
    {
        NSMutableDictionary *pDictBlockCode = [stockDic objectForKey:tztIndustryCode];
        NSString* strCode = [pDictBlockCode objectForKey:tztValue];
        
        strCode = [strCode stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (ISNSStringValid(strCode))
        {
            self.lbBlockCode.text = strCode;
            
            self.lbBlockName.hidden = NO;
            self.lbBlockRange.hidden = NO;
            
            NSMutableDictionary *pDictBlock = [stockDic objectForKey:tztIndustryName];
            self.lbBlockName.text = [pDictBlock objectForKey:tztValue];
            
            NSMutableDictionary *pDictBlcokValue = [stockDic objectForKey:tztIndustryPriceRange];
            self.lbBlockRange.text = [pDictBlcokValue objectForKey:tztValue];
            self.lbBlockRange.textColor = [pDictBlcokValue objectForKey:tztColor];
        }
        else
        {
            self.lbBlockName.hidden = YES;
            self.lbBlockRange.hidden = YES;
        }
    }

}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    self.pStockInfo = pStockInfo;
    self.PriceView.pStockInfo = pStockInfo;
    self.QuoteView.ayKeys = self.ayKeys;
    self.QuoteView.pStockInfo = pStockInfo;
    self.pUserTradeStockView.pStockInfo = pStockInfo;
    [self initViews];
}

-(void)setShowKeys:(NSArray*)ayKeys andExchangeKeys:(NSArray*)ayExchangeKeys
{
    if (_ayKeys == NULL)
        _ayKeys = NewObject(NSMutableArray);
    if (_ayExchangeKeys == NULL)
        _ayExchangeKeys = NewObject(NSMutableArray);
    
    [self.ayKeys removeAllObjects];
    [self.ayExchangeKeys removeAllObjects];
    
    for (id obj in ayKeys)
        [_ayKeys addObject:obj];
    
    for (id obj in ayExchangeKeys)
        [_ayExchangeKeys addObject:obj];
}

-(void)OnTap:(UITapGestureRecognizer*)recognizer
{
    
}


-(void)OnBtnBlock:(id)sender
{
    NSString * strCode = self.lbBlockCode.text;
    if (!ISNSStringValid(strCode) || [strCode isEqualToString:@"--"])
        return;
    
    NSString * strName = self.lbBlockName.text;
    tztStockInfo *pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
    if (ISNSStringValid(strName))
        pStock.stockName = [NSString stringWithFormat:@"%@", strName];
    
    //跳转行业板块对应排名列表
    NSDictionary *dic0 = @{@"Action":@"20199"};
    [TZTUIBaseVCMsg OnMsg:0x123456 wParam:(NSUInteger)pStock lParam:(NSUInteger)dic0];
}

-(CGFloat)GetNeedHeight
{
    return self.frame.size.height;
}

@end
