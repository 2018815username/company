//
//  TZTUIStockDetailHeaderVIew.m
//  tztMobileApp_GJUserStock
//
//  Created by 在琦中 on 14-3-26.
//
//

#import "TZTUIStockDetailHeaderView.h"

#define TZTRateViewSize CGSizeMake(270.0/2, 120.0/2)
#define TZTReportRateViewSize CGSizeMake(288.0/2, 120.0/2)
#define TZTReportRateDetailViewSize CGSizeMake(640.0/2, 90/2)

@interface TZTRateView()

@property(nonatomic,retain)UIButton *pBtnUserStock; //自选按钮
@property(nonatomic,retain)UIImageView *pImageView;
@property(nonatomic,retain)UIButton *btnPrice;        //最新价格
@property(nonatomic,retain)UILabel *lbRatio;        //涨跌值
@property(nonatomic,retain)UILabel *lbRange;        //涨跌幅
@property(nonatomic,retain)UIView  *pSepView;       //分割线
@property(nonatomic,retain)UIButton *pBtnBlock;     //板块按钮
@property(nonatomic,retain)UILabel  *lbBlockCode;   //板块代码
@property(nonatomic,retain)UILabel  *lbBlockName;   //板块名称
@property(nonatomic,retain)UILabel  *lbBlcokRange;  //板块涨跌幅
@property(nonatomic,retain)UIView   *pViewBack;

@end

@implementation TZTRateView
@synthesize pBtnUserStock = _pBtnUserStock;
@synthesize pImageView = _pImageView;
@synthesize btnPrice = _btnPrice;
@synthesize lbRatio = _lbRatio;
@synthesize lbRange = _lbRange;
@synthesize pSepView = _pSepView;
@synthesize pBtnBlock = _pBtnBlock;
@synthesize lbBlockName = _lbBlockName;
@synthesize lbBlcokRange = _lbBlcokRange;
@synthesize lbBlockCode = _lbBlockCode;
@synthesize bBlockReportHeader = _bBlockReportHeader;
@synthesize pViewBack = _pViewBack;

#define LBPriceHeight 130.0/2
#define LBRateHeight 30.0/2
#define tztLineHeight 23.f
#define tztLineHeightVertical  36
#define tztWidthRate  0.52f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    if (_pViewBack == NULL)
    {
        _pViewBack = [[UIView alloc] init];
        _pViewBack.backgroundColor = [UIColor clearColor];
        [self addSubview:_pViewBack];
        [_pViewBack release];
    }
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
//        _pImageView.userInteractionEnabled = YES;
        [self addSubview:_pImageView];
        [_pImageView release];
    }
    
    //最新价
    if (_btnPrice == nil)
    {
        _btnPrice = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPrice.titleLabel.font = tztUIBaseViewTextFont(38);
        _btnPrice.titleLabel.adjustsFontSizeToFitWidth = YES;
        _btnPrice.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _btnPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_btnPrice setTztTitle:@"-.-"];
        _btnPrice.backgroundColor = [UIColor clearColor];
        [self addSubview: _btnPrice];
    }
    
    //涨跌值
    if (_lbRatio == nil)
    {
        _lbRatio = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbRatio.font = tztUIBaseViewTextFont(14);
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
        _lbRange.font = tztUIBaseViewTextFont(14);
        _lbRange.adjustsFontSizeToFitWidth = YES;
        _lbRange.textAlignment = NSTextAlignmentLeft;
        _lbRange.backgroundColor = [UIColor clearColor];
        _lbRange.text = @"-.-%";
        [self addSubview:_lbRange];
        [_lbRange release];
    }
    
    //分割线
    if (_pSepView == nil)
    {
        _pSepView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_pSepView];
        [_pSepView release];
    }
    
    //
    if (_pBtnBlock == Nil)
    {
        _pBtnBlock = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnBlock addTarget:self
                       action:@selector(OnBtnBlock:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pBtnBlock];
    }
    
    if (_lbBlockName == nil)
    {
        _lbBlockName = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbBlockName.backgroundColor = [UIColor clearColor];
        _lbBlockName.textAlignment = NSTextAlignmentLeft;
        _lbBlockName.textColor = [UIColor tztThemeTextColorLabel];
        _lbBlockName.adjustsFontSizeToFitWidth = YES;
        _lbBlockName.font = tztUIBaseViewTextFont(14);
        _lbBlockName.userInteractionEnabled = NO;
        _lbBlockName.text = @"--";
        [self addSubview:_lbBlockName];
        [_lbBlockName release];
    }
    
    if (_lbBlockCode == nil)
    {
        _lbBlockCode = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbBlockCode.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbBlockCode];
        [_lbBlockCode release];
    }
    
    if (_lbBlcokRange == nil)
    {
        _lbBlcokRange = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbBlcokRange.backgroundColor = [UIColor clearColor];
        _lbBlcokRange.textAlignment = NSTextAlignmentLeft;
        _lbBlcokRange.adjustsFontSizeToFitWidth = YES;
        _lbBlcokRange.font = tztUIBaseViewTextFont(14);
        _lbBlcokRange.userInteractionEnabled = NO;
        _lbBlcokRange.text = @"-.-%";
        [self addSubview:_lbBlcokRange];
        [_lbBlcokRange release];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _lbBlockName.textColor = [UIColor tztThemeTextColorLabel];
    _pSepView.backgroundColor = [UIColor tztThemeBorderColorGrid];
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    BOOL bGG = (MakeStockMarketStock(self.pStockInfo.stockType));
//    BOOL bBlockIndex = MakeBlockIndex(self.pStockInfo.stockType);
    int nxMargin = 5;
    int nValid = 0;
    int nMarginCount = 5;
    if (_bBlockReportHeader)
        nMarginCount = 3;
    else
        nMarginCount = 5;
    
    nValid = self.bounds.size.width - (nMarginCount * nxMargin);
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    //设置区域
//    self.pBtnUserStock.frame = rcBtnUserStock;
    
    CGRect rcNewPrice = self.bounds;
    rcNewPrice.origin.x += nxMargin;
    if (bGG)
        rcNewPrice.size.width = nValid * 2 / 5;
//    else if (bBlockIndex)
//        rcNewPrice.size.width = nValid / 2;
    else
    {
        rcNewPrice.size.width = nValid * 3 / 5;
        if (_bBlockReportHeader)
        {
            rcNewPrice.size.width += 20;
        }
    }
    rcNewPrice.size.height = self.bounds.size.height - 10;
    rcNewPrice.origin.y = 5;
    self.btnPrice.frame = rcNewPrice;
    
    CGRect rcBtnUserStock = self.bounds;
    rcBtnUserStock.origin.x += rcNewPrice.size.width + nxMargin;
    self.pBtnUserStock.hidden = _bBlockReportHeader;
    self.pImageView.hidden = _bBlockReportHeader;
    if (_bBlockReportHeader)
    {
        rcBtnUserStock.size.width = 0;
    }
    else
        rcBtnUserStock.size.width = 60;
    
    self.pBtnUserStock.frame = rcBtnUserStock;
    
    UIImage *image = nil;
    if ([tztUserStock IndexUserStock:self.pStockInfo] < 0)//不存在
        image = [UIImage imageTztNamed:@"TZTNavAddStock.png"];
    else
        image = [UIImage imageTztNamed:@"TZTNavDelStock.png"];
    
    CGSize szImage = image.size;
    rcBtnUserStock.origin.x += (rcBtnUserStock.size.width - szImage.width) / 2;
    rcBtnUserStock.origin.y += (self.bounds.size.height - szImage.height) / 2;
    rcBtnUserStock.size = szImage;
    //    [self.pBtnUserStock setBackgroundImage:image forState:UIControlStateNormal];
    self.pImageView.frame = rcBtnUserStock;
    [self.pImageView setImage:image];
    if (_bBlockReportHeader)
        rcBtnUserStock.size.width = 0;
    
    rcNewPrice = rcBtnUserStock;
    
    CGRect rcRatio = self.bounds;
    rcRatio.origin.x += rcNewPrice.origin.x + rcNewPrice.size.width + nxMargin;
    if (bGG)
        rcRatio.size.width = (nValid * 3 / 5) / 3 + 7;
//    else if (bBlockIndex)
//        rcRatio.size.width = (nValid / 2 / 2) - 23;
    else
        rcRatio.size.width = MIN(self.bounds.size.width - rcRatio.origin.x, (nValid * 2 / 5));
    rcRatio.size.height = (self.bounds.size.height - 15) / 2;
    rcRatio.origin.y += 5;
    self.lbRatio.frame = rcRatio;
    
    rcRatio.origin.y += rcRatio.size.height + 5;
    self.lbRange.frame = rcRatio;
    
    CGRect rcSeg = rcRatio;
    rcSeg.origin.x += rcRatio.size.width + 4;
    rcSeg.size.width = .5f;
    rcSeg.origin.y = 5;
    rcSeg.size.height = self.bounds.size.height - 10;
    self.pSepView.frame = rcSeg;
    
    
    CGRect rcBack = self.bounds;
    rcBack.origin = self.btnPrice.frame.origin;
    rcBack.origin.y = 0;
    rcBack.size.width = self.btnPrice.frame.size.width + self.pBtnUserStock.frame.size.width + rcRatio.size.width - nxMargin;
    if (rcBack.size.width >= self.bounds.size.width)
        rcBack.size.width = self.bounds.size.width;
    rcBack.size.height = self.pBtnUserStock.frame.size.height;
    
    rcBack = CGRectInset(rcBack, 10, 5);
    
    self.pViewBack.frame = rcBack;
    
    
    CGRect rcBlock = self.bounds;
    rcBlock.origin.x = rcRatio.origin.x + rcRatio.size.width + 10;
    rcBlock.size.height = self.bounds.size.height;
    rcBlock.size.width = rcRatio.size.width;
    self.pBtnBlock.frame = rcBlock;
    
    rcBlock.size.height = rcRatio.size.height;
    rcBlock.origin.y += 5;
    self.lbBlockName.frame = rcBlock;
    
    rcBlock.origin.y += 5 + rcRatio.size.height;
    self.lbBlcokRange.frame = rcBlock;
}

-(void)setPStockInfo:(tztStockInfo *)stockInfo
{
    NSString *strCode = self.pStockInfo.stockCode;
    [super setPStockInfo:stockInfo];
    if (strCode && [stockInfo.stockCode caseInsensitiveCompare:strCode] != NSOrderedSame)
    {
        [self.btnPrice setTztTitle:@"-.-"];
        self.lbRatio.text = @"--";
        self.lbRange.text = @"--";
        
        if((MakeStockMarket(self.pStockInfo.stockType) && !MakeStockBlock(self.pStockInfo.stockType))
           /*|| (_bHiddenUserStockBtn && MakeBlockIndex(self.pStockInfo.stockType))*/)//个股
        {
            self.lbBlockCode.text = @"--";
            self.lbBlockName.text = @"--";
            self.lbBlcokRange.text = @"--";
        }
    }
}

- (void)updateContent
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
    
    NSMutableDictionary* pDictUpDown = [stockDic objectForKey:tztUpDown];
    NSMutableDictionary* pDictNewPrice = [stockDic objectForKey:tztNewPrice];
    NSMutableDictionary* pDictRange = [stockDic objectForKey:tztPriceRange];
    
    NSString *strPrice = [self.btnPrice titleForState:UIControlStateNormal];
    NSString *strNewPrice = [pDictNewPrice objectForKey:tztValue];
    [self.btnPrice setTztTitle:strNewPrice];
    [self.btnPrice setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//    [self.btnPrice setTztTitleColor:[pDictNewPrice objectForKey:tztColor]];
    
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
    //for test
//    bChange = YES;
//    pColor = [UIColor tztThemeHQUpColor];
    
#ifndef tzt_ZSSC
    if (bChange)
    {
        self.pViewBack.backgroundColor = [pColor colorWithAlphaComponent:0.1f];
//        self.btnPrice.backgroundColor = [pColor colorWithAlphaComponent:0.1f];
        [UIView animateWithDuration:0.5f animations:^{
            [self.btnPrice setTztTitleColor:[UIColor whiteColor]];
//            self.btnPrice.backgroundColor = [pColor colorWithAlphaComponent:0.5f];
            self.pViewBack.backgroundColor = [pColor colorWithAlphaComponent:0.5f];
        }
                         completion:^(BOOL bFinished)
         {
             if (bFinished)
             {
                 self.pViewBack.backgroundColor = [pColor colorWithAlphaComponent:0.f];
//                 self.btnPrice.backgroundColor = [pColor colorWithAlphaComponent:0.f];
                 [self.btnPrice setTztTitleColor:[pDictNewPrice objectForKey:tztColor]];
             }
         }];
    }
#endif
    
    [self.btnPrice setTztTitleColor:[pDictNewPrice objectForKey:tztColor]];
    self.lbRatio.textColor = [pDictUpDown objectForKey:tztColor];
    self.lbRatio.text = [pDictUpDown objectForKey:tztValue];
    
    [self.lbRatio setTextAlignment:NSTextAlignmentCenter];
    
    self.lbRange.textColor = [pDictRange objectForKey:tztColor];
    self.lbRange.text = [pDictRange objectForKey:tztValue];
    [self.lbRange setTextAlignment:NSTextAlignmentCenter];
    
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
            self.lbBlcokRange.hidden = NO;
            
            NSMutableDictionary *pDictBlock = [stockDic objectForKey:tztIndustryName];
            self.lbBlockName.text = [pDictBlock objectForKey:tztValue];
            
            NSMutableDictionary *pDictBlcokValue = [stockDic objectForKey:tztIndustryPriceRange];
            self.lbBlcokRange.text = [pDictBlcokValue objectForKey:tztValue];
            self.lbBlcokRange.textColor = [pDictBlcokValue objectForKey:tztColor];
        }
        else
        {
            self.lbBlockName.hidden = YES;
            self.lbBlcokRange.hidden = YES;
        }
    }
    
//    lbPrice.textColor = [pDictUpDown objectForKey:tztColor];
//    lbRate.textColor = [pDictUpDown objectForKey:tztColor];
//    
//    lbPrice.text = [pDictNewPrice objectForKey:tztValue];
//    lbRate.text = [NSString stringWithFormat:@"%@ %@", [pDictUpDown objectForKey:tztValue], [pDictRange objectForKey:tztValue]];
}

-(void)OnUserStock:(id)sener
{
    if (self.pStockInfo == NULL)
        return;
    //删除操作
    if ([tztUserStock IndexUserStock:self.pStockInfo] >= 0)
    {
        [tztUserStock DelUserStock:self.pStockInfo];
    }
    //添加操作
    else
    {
        [tztUserStock AddUserStock:self.pStockInfo];
    }
    
    CGRect rcBtnUserStock = self.pBtnUserStock.frame;// self.bounds;
    rcBtnUserStock.size.width = 60;
//    self.pBtnUserStock.frame = rcBtnUserStock;
    
    UIImage *image = nil;
    if ([tztUserStock IndexUserStock:self.pStockInfo] < 0)//不存在
        image = [UIImage imageTztNamed:@"TZTNavAddStock.png"];
    else
        image = [UIImage imageTztNamed:@"TZTNavDelStock.png"];
    
    CGSize szImage = image.size;
    rcBtnUserStock.origin.x += (rcBtnUserStock.size.width - szImage.width) / 2;
    rcBtnUserStock.origin.y += (self.bounds.size.height - szImage.height) / 2;
    rcBtnUserStock.size = szImage;
//    [self.pBtnUserStock setBackgroundImage:image forState:UIControlStateNormal];
//    self.pBtnUserStock.frame = rcBtnUserStock;
    
    self.pImageView.frame = rcBtnUserStock;
    [self.pImageView setImage:image];
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
@end


@interface TZTReportRateView()
@property(nonatomic,retain)UILabel  *lbOpenTitle;
@property(nonatomic,retain)UILabel  *lbCloseTitle;
@property(nonatomic,retain)UILabel  *lbTotalTitle;
@property(nonatomic,retain)UILabel  *lbHandTitle;
@property(nonatomic,retain)NSMutableArray *ayData;
@property(nonatomic,retain)NSMutableArray *ayKeys;
@end

@implementation TZTReportRateView
@synthesize lbOpenTitle = _lbOpenTitle;
@synthesize lbCloseTitle = _lbCloseTitle;
@synthesize lbTotalTitle = _lbTotalTitle;
@synthesize lbHandTitle = _lbHandTitle;
@synthesize ayData = _ayData;
@synthesize ayKeys = _ayKeys;

#define LBHeight 32.0/2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    [super setPStockInfo:pStockInfo];
    
    [self.ayData removeAllObjects];
    [self.ayKeys removeAllObjects];
    
    int nType = self.pStockInfo.stockType;//市场类型，下面要根据市场类型区分显示不同数据
    
    BOOL bHKMarket = MakeHKMarket(nType);
    BOOL bBlockIndexMarket = MakeBlockIndex(nType);
    BOOL bQHMarket = MakeQHMarket(nType);
//    BOOL bStockIndexMarket = MakeIndexMarket(nType);
    BOOL bWPMarket = MakeWPMarket(nType);
//    BOOL bWPIndexMarket = bWPMarket && ((self.pStockInfo.stockType == WP_INDEX)
//                                        || (MakeMidMarket(self.pStockInfo.stockType) == HQ_WP_INDEX));
    
    if (bHKMarket//港股市场
        || bBlockIndexMarket//板块指数
        || bQHMarket// 期货市场
        || bWPMarket
        )
    {
        if (bQHMarket && !bBlockIndexMarket)
        {
            self.ayData = [NSMutableArray arrayWithObjects:@"今  开", @"前  结", @"总  手", @"现  手", nil];
            self.ayKeys = [NSMutableArray arrayWithObjects:tztStartPrice, tztYesTodayPrice, tztTradingVolume, tztNowVolume, nil];
        }
        else
        {
            self.ayData = [NSMutableArray arrayWithObjects:@"今  开", @"昨  收", @"总  手", @"现  手", nil];
            self.ayKeys = [NSMutableArray arrayWithObjects:tztStartPrice, tztYesTodayPrice, tztTradingVolume, tztNowVolume, nil];
        }
//        _lbHandTitle.text = @"现  手";
    }
    else
    {
        if (MakeIndexMarket(nType))
        {
            self.ayData = [NSMutableArray arrayWithObjects:@"成交额", @"最高", @"振幅", @"最低", nil];
            self.ayKeys = [NSMutableArray arrayWithObjects:tztTransactionAmount, tztMaxPrice, tztVibrationAmplitude, tztMinPrice, nil];
//            self.ayData = [NSMutableArray arrayWithObjects:@"今  开", @"昨  收", @"成交额", @"振  幅", nil];
//            self.ayKeys = [NSMutableArray arrayWithObjects:tztStartPrice, tztYesTodayPrice, tztTransactionAmount, tztVibrationAmplitude, nil];
        }
//            _lbHandTitle.text = @"振幅";
        else
        {
            self.ayData = [NSMutableArray arrayWithObjects:@"成交量", @"最高", @"换手率", @"最低", nil];
            self.ayKeys = [NSMutableArray arrayWithObjects:tztTradingVolume, tztMaxPrice, tztHuanShou, tztMinPrice, nil];
//            self.ayData = [NSMutableArray arrayWithObjects:@"今  开", @"昨  收", @"成交量", @"换手率", nil];
//            self.ayKeys = [NSMutableArray arrayWithObjects:tztStartPrice, tztYesTodayPrice, tztTradingVolume, tztHuanShou, nil];
        }
//            _lbHandTitle.text = @"换手率";
    }
    
    _lbOpenTitle.text = [self.ayData objectAtIndex:0];
    _lbCloseTitle.text = [self.ayData objectAtIndex:1];
    _lbTotalTitle.text = [self.ayData objectAtIndex:2];
    _lbHandTitle.text = [self.ayData objectAtIndex:3];
//    //港股市场 || 板块指数 || 期货市场
//    if (bHKMarket
//        || bBlockIndexMarket
//        || bQHMarket
//        || (bWPMarket && !bWPIndexMarket)
//        )
//    {
//        _lbTotalTitle.text = @"总  手";
//    }
//    else //(MakeStockMarket(nType))//默认沪深股市
//    {
//        if (MakeIndexMarket(nType))
//            _lbTotalTitle.text = @"成交额";
//        else
//            _lbTotalTitle.text = @"成交量";
//    }
//    
//    if (bQHMarket && !bBlockIndexMarket)
//    {
//        _lbCloseTitle.text = @"前  结";
//    }
}

- (void)initViews
{
//    BOOL isMar = MakeIndexMarket(self.pStockInfo.stockType);// [TZTPriceData isMakeIndexMarket];
    
//    int nType = self.pStockInfo.stockType;//市场类型，下面要根据市场类型区分显示不同数据
    
    CGRect rcOpen = CGRectMake(0, 15, TZTReportRateViewSize.width/5*3, 30/2);
    if (_lbOpenTitle == NULL)
    {
        _lbOpenTitle = [[UILabel alloc] initWithFrame:rcOpen];
        _lbOpenTitle.backgroundColor = [UIColor clearColor];
        _lbOpenTitle.textColor = [UIColor colorWithRed:87.0/255 green:94.0/255 blue:100.0/255 alpha:1.0];
        _lbOpenTitle.textAlignment = NSTextAlignmentLeft;
        _lbOpenTitle.font = tztUIBaseViewTextFont(14);
        [self addSubview:_lbOpenTitle];
        [_lbOpenTitle release];
    }
    else
        _lbOpenTitle.frame = rcOpen;
    _lbOpenTitle.text = @"今开";
    
    CGRect rcClose = CGRectMake(TZTReportRateViewSize.width/5*3, 15, TZTReportRateViewSize.width/5*2, 30/2);
    if (_lbCloseTitle == NULL)
    {
        _lbCloseTitle = [[UILabel alloc] initWithFrame:rcClose];
        _lbCloseTitle.backgroundColor = [UIColor clearColor];
        _lbCloseTitle.textColor = [UIColor colorWithRed:87.0/255 green:94.0/255 blue:100.0/255 alpha:1.0];
        _lbCloseTitle.font = tztUIBaseViewTextFont(14);
        _lbCloseTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lbCloseTitle];
        [_lbCloseTitle release];
    }
    else
        _lbCloseTitle.frame = rcClose;
    _lbCloseTitle.text = @"昨收";
    
    CGRect rcTotal = CGRectMake(0, 50, TZTReportRateViewSize.width/5*3, 30/2);
    if (_lbTotalTitle == NULL)
    {
        _lbTotalTitle = [[UILabel alloc] initWithFrame:rcTotal];
        _lbTotalTitle.backgroundColor = [UIColor clearColor];
        _lbTotalTitle.textColor = [UIColor colorWithRed:87.0/255 green:94.0/255 blue:100.0/255 alpha:1.0];
        _lbTotalTitle.font = tztUIBaseViewTextFont(14);
        _lbTotalTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lbTotalTitle];
        [_lbTotalTitle release];
    }
    else
        _lbTotalTitle.frame = rcTotal;
    
    CGRect rcHand = CGRectMake(TZTReportRateViewSize.width/5*3, 50, TZTReportRateViewSize.width/5*2, 30/2);
    if (_lbHandTitle == NULL)
    {
        _lbHandTitle = [[UILabel alloc] initWithFrame:rcHand];
        _lbHandTitle.backgroundColor = [UIColor clearColor];
        _lbHandTitle.textColor = [UIColor colorWithRed:87.0/255 green:94.0/255 blue:100.0/255 alpha:1.0];
        _lbHandTitle.font = tztUIBaseViewTextFont(14);
        _lbHandTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lbHandTitle];
        [_lbHandTitle release];
    }
    else
        _lbHandTitle.frame = rcHand;
    
    if (lbToday == nil)
    {
        lbToday = [[UILabel alloc] initWithFrame:CGRectZero];
        lbToday.font = tztUIBaseViewTextFont(15);
        lbToday.textAlignment = NSTextAlignmentLeft;
        lbToday.backgroundColor = [UIColor clearColor];
        lbToday.textColor = [UIColor whiteColor];
        [self addSubview: lbToday];
    }
    lbToday.textColor = [UIColor tztThemeTextColorLabel];
    
    if (lbTomorrow == nil) {
        lbTomorrow = [[UILabel alloc] initWithFrame:CGRectZero];
        lbTomorrow.font = tztUIBaseViewTextFont(15);
        lbTomorrow.textAlignment = NSTextAlignmentLeft;
        lbTomorrow.backgroundColor = [UIColor clearColor];
        lbTomorrow.textColor = [UIColor whiteColor];
        [self addSubview: lbTomorrow];
    }
    lbTomorrow.textColor = [UIColor tztThemeTextColorLabel];
    
    if (lbVolume == nil) {
        lbVolume = [[UILabel alloc] initWithFrame:CGRectZero];
        lbVolume.font = tztUIBaseViewTextFont(15);
        lbVolume.textAlignment = NSTextAlignmentLeft;
        lbVolume.backgroundColor = [UIColor clearColor];
        lbVolume.textColor = [UIColor whiteColor];
        [self addSubview: lbVolume];
    }
    lbVolume.textColor = [UIColor tztThemeTextColorLabel];
    
    if (lbTurnover == nil) {
        lbTurnover = [[UILabel alloc] initWithFrame:CGRectZero];
        lbTurnover.font = tztUIBaseViewTextFont(15);
        lbTurnover.textAlignment = NSTextAlignmentLeft;
        lbTurnover.backgroundColor = [UIColor clearColor];
        lbTurnover.textColor = [UIColor whiteColor];
        [self addSubview: lbTurnover];
    }
    lbTurnover.textColor = [UIColor tztThemeTextColorLabel];
    
    lbToday.text = @"--";
    lbTomorrow.text = @"--";
    lbVolume.text = @"--";
    lbTurnover.text = @"--";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
   
    CGRect priceRect = CGRectMake(0, 30, frame.size.width/5*3, LBHeight);
    lbToday.frame = priceRect;
    
    CGRect rateRect = CGRectMake(frame.size.width/5*3, 30, frame.size.width/5*3, LBHeight);
    lbTomorrow.frame = rateRect;
    
    CGRect volRect = CGRectMake(0, 65, frame.size.width/5*3, LBHeight);
    lbVolume.frame = volRect;
    
    CGRect turnRect = CGRectMake(frame.size.width/5*3, 65, frame.size.width/5*3, LBHeight);
    lbTurnover.frame = turnRect;
}

- (void)updateContent
{
    NSDictionary *stockDic = [TZTPriceData stockDic];
    if (stockDic.count == 0)
        return;
 
    NSMutableDictionary *pDictToday = [stockDic objectForKey:[self.ayKeys objectAtIndex:0]];
    lbToday.text = [pDictToday objectForKey:tztValue];
    lbToday.textColor = [pDictToday objectForKey:tztColor];
    
    NSMutableDictionary *pDictTom = [stockDic objectForKey:[self.ayKeys objectAtIndex:1]];
    lbTomorrow.text = [pDictTom objectForKey:tztValue];
    lbTomorrow.textColor = [pDictTom objectForKey:tztColor];
    
    NSMutableDictionary *pDictVolume = [stockDic objectForKey:[self.ayKeys objectAtIndex:2]];
    lbVolume.text = [pDictVolume objectForKey:tztValue];
    lbVolume.textColor = [pDictVolume objectForKey:tztColor];
    
    NSMutableDictionary *pDictTurnove = [stockDic objectForKey:[self.ayKeys objectAtIndex:3]];
    lbTurnover.text = [pDictTurnove objectForKey:tztValue];
    lbTurnover.textColor = [pDictTurnove objectForKey:tztColor];
    
    return;
}

@end

@interface TZTReportRateDetailView()

 /**
 *	@brief	具体数据显示view数组
 */
@property(nonatomic,retain)NSMutableArray   *ayViews;

 /**
 *	@brief	标题view数组
 */
@property(nonatomic,retain)NSMutableArray   *ayTitles;

 /**
 *	@brief	标题文字数组
 */
@property(nonatomic,retain)NSMutableArray   *ayData;

 /**
 *	@brief	数据对应的key
 */
@property(nonatomic,retain)NSMutableArray   *ayKeys;


@end

@implementation TZTReportRateDetailView
@synthesize ayViews = _ayViews;
@synthesize ayTitles = _ayTitles;
@synthesize ayData = _ayData;
@synthesize nNumberOfRow = _nNumberOfRow;
@synthesize nShowType = _nShowType;
@synthesize bBlockReportHeader = _bBlockReportHeader;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self initViews];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
//        [self initViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    [self initViews];
}

- (void)initViews
{
    NSArray *arr = self.ayData;
    
    NSInteger nCount = _nNumberOfRow;
    if (_nNumberOfRow  <= 0)
        nCount = 3;
    
    if (arr.count < nCount)
        nCount = arr.count;
    
    CGRect rcBack = self.bounds;
    float width = (rcBack.size.width) / nCount;
    if (CGRectIsEmpty(rcBack) || CGRectIsNull(rcBack))
        width = TZTReportRateDetailViewSize.width/nCount;
    
    int f = 0;
    int nXMargin = 0;// 10;
    int nYMargin = -2;
    int nYOffset = 5;
    
    CGRect rcLineView;
    
    UIFont *pFont = tztUIBaseViewTextFont(13);
//    CGFloat nNowHeight = self.bounds.size.height;
    
    int nLineHeight = tztLineHeightVertical;
//    if (self.ayData.count <= _nNumberOfRow)
//        nLineHeight = self.bounds.size.height;
    
    for (int i = 0; i < arr.count; i ++)
    {
        CGRect rect;
        if (i>0 && (i%nCount) == 0)
        {
            f ++;
        }
        if (_nShowType == tztShowVertical)
            rect = CGRectMake((i%nCount)*width+nXMargin, (tztLineHeightVertical * f + nYMargin) + nYOffset, width, nLineHeight / 2);
        else
            rect = CGRectMake((i%nCount)*width+nXMargin, tztLineHeight * f + nYMargin + nYOffset, width * tztWidthRate, tztLineHeight);
        
        
        UIButton *jinkai = (UIButton*)[self viewWithTag:i*10+1];
        if (jinkai == NULL)
        {
            jinkai = [UIButton buttonWithType:UIButtonTypeCustom];
            jinkai.frame = rect;
            jinkai.userInteractionEnabled = YES;
            jinkai.backgroundColor = [UIColor clearColor];
            [jinkai setTztTitleColor:[UIColor colorWithRed:87.0/255 green:94.0/255 blue:100.0/255 alpha:1.0]];
            jinkai.titleLabel.font = tztUIBaseViewTextFont(12);
            [jinkai setTztTitle:[arr objectAtIndex:i]];
            jinkai.titleLabel.textAlignment = NSTextAlignmentCenter;
            jinkai.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            jinkai.tag = i*10+1;
            [self addSubview:jinkai];
            [jinkai addTarget:self action:@selector(OnTap) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
//            BOOL bHidden = (tztLineHeight *f + nYMargin > nNowHeight);
//            [UIView animateWithDuration:0.2f
//                             animations:^{
//                                 jinkai.alpha = (bHidden ? 0 : 1);
//                             }];
            jinkai.frame = rect;
        }
        
        if (_nShowType == tztShowVertical)
            rect = CGRectMake((i%nCount)*width + nXMargin, tztLineHeightVertical * f + nLineHeight / 2 + nYMargin + nYOffset - 5, width , nLineHeight / 2);
        else
            rect = CGRectMake((i%nCount)*width + rect.size.width +nXMargin, tztLineHeight * f + nYMargin + nYOffset, width - rect.size.width - 5, tztLineHeight);
        
        UIButton *lb = (UIButton*)[self viewWithTag:i*1000+2];
        if (lb == NULL)
        {
            lb = [UIButton buttonWithType:UIButtonTypeCustom];
            lb.frame = rect;
            lb.userInteractionEnabled = YES;
            lb.backgroundColor = [UIColor clearColor];
            lb.titleLabel.font = pFont;
            lb.titleLabel.textAlignment = NSTextAlignmentCenter;
            lb.titleLabel.adjustsFontSizeToFitWidth = YES;
            lb.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            [lb setTztTitle:@"- -"];
            lb.tag = i*1000+2;
            [self addSubview:lb];
            [lb addTarget:self action:@selector(OnTap) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
//            BOOL bHidden = (tztLineHeight *f + nYMargin > nNowHeight);
//            [UIView animateWithDuration:0.2f
//                             animations:^{
//                                 lb.alpha = (bHidden ? 0 : 1);
//                             }];
            lb.frame = rect;
        }
        
        if (_nShowType == tztShowVertical)
        {
            rcLineView = CGRectMake((i%nCount)*width+nXMargin, (nLineHeight * f + nYMargin), width * nCount, 0.5);
            UIView *lineView = [self viewWithTag:i * 1000 + 3];
            if (lineView == NULL)
            {
                lineView = [[UIView alloc] initWithFrame:rcLineView];
                [self addSubview:lineView];
                lineView.tag = i * 1000 + 3;
                lineView.backgroundColor = [UIColor tztThemeBorderColorGrid];
                [lineView release];
            }
            else
            {
                lineView.frame =rcLineView;
                lineView.backgroundColor = [UIColor tztThemeBorderColorGrid];
            }
            
            if ( i == 0 || (i % nCount != (nCount -1)))
            {
                UIView *lineView2 = [self viewWithTag:i * 1000 + 4];
                rcLineView = CGRectMake((i%nCount)*width+nXMargin + width, (nLineHeight * f + nYMargin), 0.5, nLineHeight);
                if (self.ayData.count <= _nNumberOfRow)
                    rcLineView.size.height -= 2;
                if (lineView2 == NULL)
                {
                    lineView2 = [[UIView alloc] initWithFrame:rcLineView];
                    [self addSubview:lineView2];
                    lineView2.tag = i*1000+4;
                    lineView2.backgroundColor = [UIColor tztThemeBorderColorGrid];
                    [lineView2 release];
                }
                else
                {
                    lineView2.frame = rcLineView;
                    lineView2.backgroundColor = [UIColor tztThemeBorderColorGrid];
                }
            }
        }
    }
    
    BOOL bWPMarket = MakeWPMarket(self.pStockInfo.stockType);
    BOOL bWPIndexMarket = bWPMarket && ((self.pStockInfo.stockType == WP_INDEX)
                                        || (MakeMidMarket(self.pStockInfo.stockType) == HQ_WP_INDEX));
    BOOL bHiden = (MakeIndexMarket(self.pStockInfo.stockType)
                   || bWPIndexMarket);
    BOOL bBlockIndex = MakeBlockIndex(self.pStockInfo.stockType);
    
    NSUInteger nStart = (2*nCount);
    if (bBlockIndex)
    {
        nStart = (3*nCount);
        bHiden = YES;
    }
    
    if (self.ayData.count <= _nNumberOfRow)
    {
        nStart = self.ayData.count;
    }
    
    for (NSUInteger i = self.ayData.count; i < 18; i++)
    {
        UIView *pView = [self viewWithTag:i*10+1];
        pView.hidden = bHiden;
        
        pView = [self viewWithTag:i*1000+2];
        pView.hidden = bHiden;
        UIView *lineView2 = [self viewWithTag:i * 1000 + 4];
        lineView2.hidden = bHiden;
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
    
    [self.ayData removeAllObjects];
    [self.ayKeys removeAllObjects];
    
    if (nMarket != pStockInfo.stockType)
    {
        for (UIView* pView in self.subviews)
        {
            [pView removeFromSuperview];
            pView = NULL;
        }
    }
    
    BOOL bWPMarket = MakeWPMarket(self.pStockInfo.stockType);
//    BOOL bWPIndexMarket = bWPMarket && ((self.pStockInfo.stockType == WP_INDEX)
//                                        || (MakeMidMarket(self.pStockInfo.stockType) == HQ_WP_INDEX));
    
    if (MakeHKMarket(self.pStockInfo.stockType))//港股市场
    {
        if (MakeHKMarketStock(self.pStockInfo.stockType))
        {
            self.ayData = [NSMutableArray arrayWithObjects:@"现量", @"总量" , @"均价", @"量比",
                           @"今开", @"昨收", @"最高", @"最低",
                           @"委比", @"委差", @"涨幅", @"涨跌"/*, @"IEP", @"IEV"*/, nil];
            self.ayKeys = [NSMutableArray arrayWithObjects:tztNowVolume, tztTradingVolume, tztAveragePrice, tztVolumeRatio,
                           tztStartPrice, tztYesTodayPrice, tztMaxPrice, tztMinPrice,
                           tztWRange, tztWCha, tztPriceRange, tztUpDown, /*tztIEP, tztIEV,*/ nil];
            
//            self.ayData = [NSMutableArray arrayWithObjects:@"最高", @"最低" , @"均价", @"量比", @"委比", @"委差"/*, @"IEP", @"IEV"*/, nil];
//            self.ayKeys = [NSMutableArray arrayWithObjects:tztMaxPrice, tztMinPrice, tztAveragePrice, tztVolumeRatio, tztWRange, tztWCha, /*tztIEP, tztIEV,*/ nil];
        }
        else
        {
            self.ayData = [NSMutableArray arrayWithObjects:@"最高", @"最低" , @"今开", @"昨收", nil];
            self.ayKeys = [NSMutableArray arrayWithObjects:tztMaxPrice, tztMinPrice, tztStartPrice, tztYesTodayPrice, nil];
        }
//        self.ayData = [NSMutableArray arrayWithObjects:@"最    高", @"最    低" , @"均    价", @"量    比", @"委    比", @"委    差", @"IEP", @"IEV", nil];
//        self.ayKeys = [NSMutableArray arrayWithObjects:tztMaxPrice, tztMinPrice, tztAveragePrice, tztVolumeRatio, tztWRange, tztWCha, tztIEP, tztIEV, nil];
    }
    else if (MakeBlockIndex(self.pStockInfo.stockType) || _bBlockReportHeader)//板块指数
    {
        self.ayData = [NSMutableArray arrayWithObjects:@"上涨数", @"下跌数", @"平盘数", nil];
        self.ayKeys = [NSMutableArray arrayWithObjects:tztUpStocks, tztDownStocks, tztFlatStocks, nil];

//        self.ayData = [NSMutableArray arrayWithObjects:@"换    手", @"P    E", @"均    价", @"量    比", @"委    比", @"委    差", @"内    盘", @"外    盘", @"总股本", nil];
//        self.ayKeys = [NSMutableArray arrayWithObjects:tztHuanShou,  tztPE, tztAveragePrice, tztVolumeRatio, tztWRange, tztWCha, tztNeiPan, tztWaiPan, tztZongGuBen, nil];
    }
    else if (MakeQHMarket(self.pStockInfo.stockType))//期货
    {
        self.ayData = [NSMutableArray arrayWithObjects:@"最高", @"最低", @"日增", @"委比", @"委差", @"内盘", @"买价", @"卖价", @"外盘", nil];
        self.ayKeys = [NSMutableArray arrayWithObjects:tztMaxPrice, tztMinPrice, tztDayADD, tztWRange, tztWCha, tztNeiPan, tztBuy1, tztSell1, tztWaiPan, nil];
    }
    else if (bWPMarket)
    {
        self.ayData = [NSMutableArray arrayWithObjects:@"现量", @"总量",@"最高", @"最低",
                                                       @"今开", @"昨收", @"涨幅", @"涨跌",nil];
        self.ayKeys = [NSMutableArray arrayWithObjects:tztNowVolume, tztTradingVolume, tztMaxPrice, tztMinPrice,
                       tztStartPrice,tztYesTodayPrice, tztPriceRange, tztUpDown, nil];
//        if (bWPIndexMarket)
//        {
////            self.ayData = [NSMutableArray arrayWithObjects:@"最高", @"最低", @"成交量", @"涨家数", @"平家数", @"跌家数", nil];
////            self.ayKeys = [NSMutableArray arrayWithObjects:tztMaxPrice, tztMinPrice, tztTradingVolume, tztUpStocks, tztFlatStocks, tztDownStocks, nil];
//            
//            self.ayData = [NSMutableArray arrayWithObjects:@"最高", @"最低", @"今开", @"昨收", nil];
//            self.ayKeys = [NSMutableArray arrayWithObjects:tztMaxPrice, tztMinPrice, tztStartPrice,tztYesTodayPrice, nil];
//        }
//        else
//        {
//            self.ayData = [NSMutableArray arrayWithObjects:@"最高", @"最低", @"日增", @"委比", @"委差", @"内盘", @"买价", @"卖价", @"外盘", nil];
//            self.ayKeys = [NSMutableArray arrayWithObjects:tztMaxPrice, tztMinPrice, tztDayADD, tztWRange, tztWCha, tztNeiPan, tztBuy1, tztSell1, tztWaiPan, nil];
//        }
    }
    else
    {
        if (MakeIndexMarket(self.pStockInfo.stockType))
        {
            self.ayData = [NSMutableArray arrayWithObjects:@"成交额",  @"涨家数", @"跌家数", @"平家数", @"最高", @"最低", @"今开", @"昨收", nil];
            self.ayKeys = [NSMutableArray arrayWithObjects:tztTransactionAmount,tztUpStocks, tztDownStocks, tztFlatStocks,
                           tztMaxPrice,tztMinPrice,tztStartPrice, tztYesTodayPrice,  nil];
//            self.ayData = [NSMutableArray arrayWithObjects:@"最    高", @"最    低", @"成交量", @"涨家数", @"平家数", @"跌家数", nil];
//            self.ayKeys = [NSMutableArray arrayWithObjects:tztMaxPrice, tztMinPrice, tztTradingVolume, tztUpStocks, tztFlatStocks, tztDownStocks, nil];
        }
        else
        {
            self.ayData = [NSMutableArray arrayWithObjects:
                           @"最高", @"最低", @"换手", @"成交额",
                           @"内盘", @"外盘", @"量比", @"成交量",
                           @"市盈率", @"市净率", @"流通市值", @"总市值",
                           
//                           
//                           @"最高", @"最低", @"成交量", @"成交额",
//                           @"换手率",@"振幅",@"今开", @"昨收",
//                           @"内盘", @"外盘", @"均价", @"量比",
////                           @"涨停", @"跌停", @"均价", @"量比",
                           nil];
            
            self.ayKeys = [NSMutableArray arrayWithObjects:
                           tztMaxPrice,tztMinPrice,tztHuanShou,tztTransactionAmount,
                           tztNeiPan,tztWaiPan,tztVolumeRatio,tztTradingVolume,
                           tztPE,tztSJL,tztLiuTongPanMoney,tztZongGuBenMoney,

                           
//                           tztMaxPrice,tztMinPrice,tztTradingVolume,tztTransactionAmount,
//                           tztHuanShou,tztVibrationAmplitude,tztStartPrice,tztYesTodayPrice,
//                           tztNeiPan,tztWaiPan,tztAveragePrice,tztVolumeRatio,
////                           tztTradingPrice,tztLimitPrice,tztAveragePrice,tztVolumeRatio,
                           nil];
        }
    }
    
    [self initViews];
}

-(CGFloat)GetNeedHeight
{
    if ([self.ayData count] < 1)
        return 0;
    NSInteger nCount = _nNumberOfRow;
    if (nCount < 1)
        nCount = 3;
    
    if (_nShowType == tztShowVertical)
    {
        return (([self.ayData count] / nCount) + (([self.ayData count] % nCount == 0) ? 0 : 1)  - 1) * (tztLineHeightVertical);
    }
    else
        return (([self.ayData count] / nCount) + (([self.ayData count] % nCount == 0) ? 0 : 1)  - 1) * tztLineHeight + 5;
}


- (void)updateContent
{
    NSArray *arr = self.ayData;
    NSDictionary *stockDic = [TZTPriceData stockDic];
    for (int i = 0; i < arr.count; i ++)
    {
        UIButton *lbCont = (UIButton *)[self viewWithTag:i*1000+2];
        NSMutableDictionary *pDict = [stockDic objectForKey:[self.ayKeys objectAtIndex:i]];
        [lbCont setTztTitle:[pDict objectForKey:tztValue]];
        [lbCont setTztTitleColor:[pDict objectForKey:tztColor]];
        
        UIButton *lbTitle = (UIButton *)[self viewWithTag:i*10+1];
        NSString* strTitle = [arr objectAtIndex:i];
        
        if (strTitle && [strTitle isEqualToString:tztIndustryName])
        {
            NSMutableDictionary* pDictName = [stockDic objectForKey:tztIndustryName];
            [lbTitle setTztTitle:[pDictName objectForKey:tztValue]];
            [lbTitle setTztTitleColor:[pDict objectForKey:tztColor]];
            
        }
        else
            [lbTitle setTztTitle:[arr objectAtIndex:i]];
        
    }
}

@end

@interface TZTUIStockDetailHeaderView()<tztHqBaseViewDelegate>

@property(nonatomic,retain)UIView   *pBackView;
@property(nonatomic,retain)UIImageView *pImageView;
@property(nonatomic,retain)UIView   *pLine;
@property(nonatomic,retain)UITapGestureRecognizer *tapGesture;
@end

@implementation TZTUIStockDetailHeaderView
@synthesize tapGesture = _tapGesture;
@synthesize bExpand = _bExpand;
@synthesize pBackView = _pBackView;
@synthesize pImageView = _pImageView;
@synthesize pLine = _pLine;

@synthesize rateView = _rateView;
@synthesize reportRateView = _reportRateView;
@synthesize reportRateDetailView = _reportRateDetailView;
@synthesize bBlockReportHeader = _bBlockReportHeader;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initViews];
    }
    return self;
}

- (void)initViews
{
    if (_tapGesture == NULL)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTap:)];
        [self addGestureRecognizer:_tapGesture];
        [_tapGesture release];
    }
    CGRect rectRate = CGRectMake(0, 0, self.bounds.size.width, TZTRateViewSize.height);
    if (_rateView == NULL)
    {
        _rateView = [[TZTRateView alloc] init];
        _rateView.pStockInfo = self.pStockInfo;
        _rateView.frame = rectRate;
        [self addSubview:_rateView];
        [_rateView release];
    }
    else
        _rateView.frame = rectRate;
    
//    CGRect rectReRate = CGRectMake(TZTRateViewSize.width+20, 0, TZTReportRateViewSize.width, TZTReportRateViewSize.height);
//    if (reportRateView == NULL)
//    {
//        reportRateView = [[TZTReportRateView alloc] init];
//        reportRateView.pStockInfo = self.pStockInfo;
//        reportRateView.frame = rectReRate;
//        [self addSubview:reportRateView];
//        [reportRateView release];
//    }
//    else
//    {
//        reportRateView.frame = rectReRate;
//    }
    
    CGRect rectReRateDe = CGRectMake(0,
                                     TZTRateViewSize.height,
                                     self.bounds.size.width,
                                     self.bounds.size.height - (rectRate.origin.y + rectRate.size.height) - 10); // 个股高度
    if (_bBlockReportHeader)
        rectReRateDe.size.height += 5;
    //根据类型进行解析
    if (_reportRateDetailView == NULL)
    {
        _reportRateDetailView = [[TZTReportRateDetailView alloc] init];
        _reportRateDetailView.pStockInfo = self.pStockInfo;
        _reportRateDetailView.nNumberOfRow = 4;
        _reportRateDetailView.nShowType = tztShowVertical;
        _reportRateDetailView.tztdelegate = self;
        _reportRateDetailView.frame = rectReRateDe;
        [self addSubview:_reportRateDetailView];
        [_reportRateDetailView release];
    }
    else
    {
        self.reportRateDetailView.frame = rectReRateDe;
    }
    
    CGRect rcBack = CGRectMake(0, self.bounds.size.height - 10, self.bounds.size.width, 10);
    if (_pBackView == NULL)
    {
        _pBackView = [[UIView alloc] initWithFrame:rcBack];
        [self addSubview:_pBackView];
        [_pBackView release];
    }
    else
    {
        _pBackView.frame = rcBack;
    }
    _pBackView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _pBackView.hidden = _bBlockReportHeader;
    
    CGRect rcLine = rcBack;
    rcLine.size.height = .5f;
    
    if (_bBlockReportHeader)
        rcLine.origin.y += 5;
    if (_pLine == NULL)
    {
        _pLine = [[UIView alloc] initWithFrame: rcLine];
        [self addSubview:_pLine];
        [_pLine release];
    }
    else
        _pLine.frame = rcLine;
    
    _pLine.backgroundColor = [UIColor tztThemeBorderColorGrid];
    
    UIImage *image = nil;
    
    if (_bExpand)
        image = [UIImage imageTztNamed:@"tztArrowUp.png"];
    else
        image = [UIImage imageTztNamed:@"tztArrowDown.png"];
    
    CGSize sz = CGSizeMake(34, 6);
    if (image)
        sz = image.size;
    
    CGRect rcImageView = CGRectMake(/*self.bounds.size.width - sz.width -*/ 5, 0, sz.width, sz.height);
    if (_pImageView == NULL)
    {
        _pImageView = [[UIImageView alloc] initWithFrame:rcImageView];
        [_pBackView addSubview:_pImageView];
        [_pImageView release];
    }
    else
        _pImageView.frame = rcImageView;
    [_pImageView setImage:image];
    
    if ([self.reportRateDetailView.ayData count] <= self.reportRateDetailView.nNumberOfRow)
        _pImageView.hidden = YES;
    else
        _pImageView.hidden = NO;
//    _pBackView.backgroundColor = [UIColor redColor];
    
    if (self.rateView)
        self.rateView.bBlockReportHeader = _bBlockReportHeader;
    if (self.reportRateDetailView)
        self.reportRateDetailView.bBlockReportHeader = _bBlockReportHeader;
    
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    self.pStockInfo = pStockInfo;
    if (self.rateView)
        self.rateView.pStockInfo = self.pStockInfo;
    if (self.reportRateView)
        self.reportRateView.pStockInfo = self.pStockInfo;
    if (self.reportRateDetailView)
    {
        self.reportRateDetailView.pStockInfo = self.pStockInfo;
        [self.reportRateDetailView initViews];
    }
    
    [self initViews];
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    [self initViews];
//    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    self.rateView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    self.reportRateView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    self.reportRateDetailView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
}

- (void)updateContent
{
    [self.rateView updateContent];
    [self.reportRateView updateContent];
    [self.reportRateDetailView updateContent];
//    reportRateDetailView.layer.borderColor = [UIColor redColor].CGColor;
//    reportRateDetailView.layer.borderWidth = 1.0f;
}

-(void)setBBlockReportHeader:(BOOL)bBlockHeader
{
    _bBlockReportHeader = bBlockHeader;
    if (self.rateView)
        self.rateView.bBlockReportHeader = bBlockHeader;
    if (self.reportRateDetailView)
        self.reportRateDetailView.bBlockReportHeader = bBlockHeader;
}

-(void)OnTap:(UITapGestureRecognizer*)recognizer
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztDetailHeader:OnTapClicked:)])
    {
        _bExpand = !_bExpand;
        [self.tztdelegate tztDetailHeader:self OnTapClicked:_bExpand];
    }
}

- (CGFloat)GetNeedHeight
{
    if (self.reportRateDetailView)
        return [self.reportRateDetailView GetNeedHeight];
    return 0;
}

-(void)setNeedsDisplay
{
    [self.rateView setNeedsDisplay];
    [self.reportRateDetailView setNeedsDisplay];
    [self.reportRateView setNeedsDisplay];
}
@end
