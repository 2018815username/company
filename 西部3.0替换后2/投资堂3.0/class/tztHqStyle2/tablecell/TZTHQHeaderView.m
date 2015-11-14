/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    沪深表中最顶端的HeaderView
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTHQHeaderView.h"

#define BtnHeight 74

#define Gap 5
#define IndustHeight 24
#define RateHeight 26
#define DetailHeight 14
#define BTNTag 1000
#define Triangle @"▲"
#define UnTriangle @"▼"

#define GrayWhite [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0]

@interface TZTHQHeaderButton()

@property (nonatomic, retain) tztStockInfo  *pStockInfo;
@property (nonatomic, retain) UILabel *lbArrow;
@property (nonatomic, retain) UILabel *lbIndustry;
@property (nonatomic, retain) UILabel *lbRate;
@property (nonatomic, retain) UILabel *lbDetail;
@end

@implementation TZTHQHeaderButton

@synthesize lbDetail, lbRate, lbIndustry, lbArrow;
@synthesize pStockInfo;

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
    if (lbArrow == nil)
    {
        lbArrow = [[UILabel alloc] initWithFrame:CGRectZero];
        lbArrow.font = tztUIBaseViewTextFont(9);
        lbArrow.textAlignment = NSTextAlignmentRight;
        [self addSubview:lbArrow];
        [lbArrow release];
    }
    
    if (lbIndustry == nil)
    {
        lbIndustry = [[UILabel alloc] initWithFrame:CGRectZero];
        lbIndustry.font = tztUIBaseViewTextFont(14);
        lbIndustry.textAlignment = NSTextAlignmentCenter;
        [self addSubview: lbIndustry];
        [lbIndustry release];
    }
    
    if (lbRate == nil)
    {
        lbRate = [[UILabel alloc] initWithFrame:CGRectZero];
        lbRate.font = tztUIBaseViewTextFont(17);
        lbRate.textAlignment = NSTextAlignmentCenter;
        [self addSubview: lbRate];
        [lbRate release];
    }
    
    if (lbDetail == nil)
    {
        lbDetail = [[UILabel alloc] initWithFrame:CGRectZero];
        lbDetail.font = tztUIBaseViewTextFont(10);
        lbDetail.textAlignment = NSTextAlignmentCenter;
        [self addSubview: lbDetail];
        [lbDetail release];
    }
    
    if (pStockInfo == nil)
    {
        pStockInfo = NewObject(tztStockInfo);
    }
    
    
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    lbIndustry.backgroundColor = [UIColor clearColor];
    if (_bUseBackColor)
        lbIndustry.textColor = [UIColor whiteColor];
    else
        lbIndustry.textColor = [UIColor tztThemeHQBalanceColor];
    lbArrow.backgroundColor = [UIColor clearColor];
    lbRate.backgroundColor = [UIColor clearColor];
//    lbRate.textColor = [UIColor redColor];
    lbDetail.backgroundColor = [UIColor clearColor];
    if (_bUseBackColor)
        lbDetail.textColor = [UIColor whiteColor];
    else
        lbDetail.textColor = [UIColor tztThemeTextColorLabel];
    
    float fHeight = (self.frame.size.height - Gap * 2) / 2;
    CGRect indusRect = CGRectMake(0, Gap, frame.size.width, fHeight);
    lbIndustry.frame = indusRect;
    
    CGRect rateRect = CGRectMake(0, indusRect.origin.y + indusRect.size.height - 2, frame.size.width, fHeight / 2);
    lbRate.frame = rateRect;
    CGSize sz = [lbRate.text sizeWithFont:lbRate.font];
    CGRect rcArrow = rateRect;
    rcArrow.origin.x = (rateRect.size.width - sz.width) / 2 - 9;
    rcArrow.size.width = 8;
    lbArrow.frame = rcArrow;
    
    
    
    CGRect detailRect = CGRectMake(0, rateRect.origin.y + rateRect.size.height, frame.size.width, fHeight/2);
    lbDetail.frame = detailRect;
}

-(void)setContent:(NSMutableDictionary*)pData
{
    NSDictionary* dictName = [pData tztObjectForKey:@"Name"];
    NSString* strName = [dictName tztObjectForKey:@"value"];
    
    NSDictionary* dictCode = [pData tztObjectForKey:@"Code"];
    NSString* strCode = [dictCode tztObjectForKey:@"value"];
    
    NSDictionary* dictPrice = [pData tztObjectForKey:@"NewPrice"];
    NSString* strPrice = [dictPrice tztObjectForKey:@"value"];
    
    NSDictionary* dictRatio = [pData tztObjectForKey:@"Ratio"];
    NSString* strRatio = [dictRatio tztObjectForKey:@"value"];
    
    NSDictionary* dictRange = [pData tztObjectForKey:@"Range"];
    NSString* strRange = [dictRange tztObjectForKey:@"value"];
    
    NSString* strStockType = [pData tztObjectForKey:@"StockType"];
    
    if (!ISNSStringValid(strName))
        strName = @"--";
    if (!ISNSStringValid(strCode))
        strCode = @"-";
    if (!ISNSStringValid(strPrice))
        strPrice = @"-.-";
    if (!ISNSStringValid(strRatio))
    {
        strRatio = @"-.-";
    }
    if (!ISNSStringValid(strRange))
        strRange = @"-.-";
#ifdef tzt_ZSSC
    lbIndustry.textAlignment = NSTextAlignmentLeft;
    lbIndustry.text = [NSString stringWithFormat:@" %@", strName];
#else
    lbIndustry.text = strName;
#endif
    
    int nFlag = 0;
    UIColor *pColor = [UIColor tztThemeHQBalanceColor];
    if ([strRatio caseInsensitiveCompare:@"-.-"] == NSOrderedSame
        || [strRatio caseInsensitiveCompare:@"--"] == NSOrderedSame
        || [strRatio caseInsensitiveCompare:@"-"] == NSOrderedSame)
        pColor = [UIColor tztThemeHQBalanceColor];
    else if([strRatio hasPrefix:@"-"])
    {
        nFlag = -1;
        pColor = [UIColor tztThemeHQDownColor];
            
    }
    else
    {
        nFlag = 1;
        pColor = [UIColor tztThemeHQUpColor];
    }
    
    if (self.bUseBackColor)
    {
        if (nFlag == 0)
            pColor = [UIColor colorWithTztRGBStr:@"170,170,170"];
        self.backgroundColor = pColor;
        pColor = [UIColor whiteColor];
    }
    if (nFlag > 0)
    {
        if (_bShowArrow)
            lbArrow.text = [NSString stringWithFormat:@"%@",@"▲"];
        lbRate.text = [NSString stringWithFormat:@"%@", strPrice];
    }
    else if (nFlag < 0)
    {
        if (_bShowArrow)
            lbArrow.text = [NSString stringWithFormat:@"%@",@"▼"];
        lbRate.text = [NSString stringWithFormat:@"%@", strPrice];
    }
    else
    {
//        lbArrow.text = [NSString stringWithFormat:@"%@",@"■"];
        lbRate.text = [NSString stringWithFormat:@"%@", strPrice];
    }
    lbRate.textColor = pColor;
    lbArrow.textColor = pColor;
    
    lbDetail.text = [NSString stringWithFormat:@"%@      %@",strRatio, strRange];
//    lbDetail.textColor = pColor;
    
    self.pStockInfo.stockCode = [NSString stringWithFormat:@"%@", strCode];
    self.pStockInfo.stockName = [NSString stringWithFormat:@"%@", strName];
    self.pStockInfo.stockType = [strStockType intValue];
}

-(tztStockInfo*)GetStockInfo
{
    return self.pStockInfo;
}

-(void)dealloc
{
    [super dealloc];
    DelObject(pStockInfo);
}
@end

@implementation TZTHQHeaderView
@synthesize nTotalCount = _nTotalCount;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTotalCol:(NSInteger)nCol bUseBackColor_:(BOOL)bUseBackColor bShowArrow_:(BOOL)bShowArrow
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.clipsToBounds = YES;
        self.contentView.clipsToBounds = YES;
        self.bShowArrow = bShowArrow;
        self.bUseBackColor = bUseBackColor;
        _nTotalCount = nCol;
        if (_nTotalCount <= 0)
            _nTotalCount = 3;
        
        [self initViews];
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTotalCol:(NSInteger)nCol
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier andTotalCol:nCol bUseBackColor_:NO bShowArrow_:YES];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier andTotalCol:3];
}

-(void)initViews
{
    for (NSInteger i = 0; i < _nTotalCount; i++)
    {
        TZTHQHeaderButton *btn = (TZTHQHeaderButton *)[self viewWithTag:i + BTNTag];
        if (btn == NULL)
        {
            btn = [TZTHQHeaderButton buttonWithType:UIButtonTypeCustom];
            btn.bUseBackColor = _bUseBackColor;
            btn.bShowArrow = _bShowArrow;
            btn.tag = i + BTNTag;
            [btn addTarget:self
                    action:@selector(OnBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
            btn.clipsToBounds = YES;
            [self addSubview:btn];
        }
    }
}


-(void)layoutSubviews
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.frame = self.bounds;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    CGRect rc = self.bounds;
    CGFloat btnWidth = rc.size.width / 3;
    NSInteger nRowCount = (_nTotalCount / 3) + ((_nTotalCount % 3 == 0) ? 0 : 1);
    if (nRowCount < 1)
        nRowCount = 1;
    CGFloat btnHeight = rc.size.height / nRowCount;
    
    int nCount = 0;
    for (NSInteger i = 0; i < 3; i++)
    {
        for (NSInteger j = 0; j < nRowCount; j++)
        {
            if (nCount > _nTotalCount)
                break;
            
            TZTHQHeaderButton *btn = (TZTHQHeaderButton *)[self viewWithTag:((i)+(j*3)) + BTNTag];
            nCount++;
            
            btn.frame = CGRectMake(i*btnWidth, j*btnHeight, btnWidth, btnHeight);
            if (_bUseBackColor)
            {
                btn.frame = CGRectInset(btn.frame, 1, 0);
            }
            
            if (!_bUseBackColor)
            {
                CGRect rcRight = btn.frame;
                rcRight.origin.x += rcRight.size.width-1;
                rcRight.size.width = .5f;
                CGRect rcBottom = btn.frame;
                rcBottom.origin.y += rcBottom.size.height-.5f;
                rcBottom.size.height = .5f;
                if (nRowCount > 1 && j >= 0 && (j != nRowCount - 1))
                {
                    UIView *pLineView = [self viewWithTag:BTNTag*2+nCount];
                    if (pLineView == NULL && (j % 3) != 2)
                    {
                        pLineView = [[UIView alloc] initWithFrame:rcBottom];
                        pLineView.tag = BTNTag*2+nCount;
                        [self addSubview:pLineView];
                    }
                    else
                        pLineView.frame = rcBottom;
                    pLineView.backgroundColor = [UIColor tztThemeHQGridColor];
                    
                }
                CGRect rc = btn.frame;
                rc.size.width = .5f;
                rc.origin.x = (i+1)*btnWidth - .5f;
                rc.origin.y = j*btnHeight;
                if (j >= 0 && (j < nRowCount))
                {
                    UIView *pSLineView = [self viewWithTag:BTNTag*3+nCount];
                    if (pSLineView == NULL && (i + 1)%3 != 0)
                    {
                        
                        pSLineView = [[UIView alloc] initWithFrame:rc];
                        pSLineView.tag = BTNTag*3+nCount;
                        [self addSubview:pSLineView];
                    }
                    else
                        pSLineView.frame = rc;
                    pSLineView.backgroundColor = [UIColor tztThemeHQGridColor];
                }
            }
        }
    }
}

-(void)setContent:(NSMutableArray *)ayData
{
    if (ayData == NULL || ayData.count < 1)
    {
        for (int i = 0; i < 3; i++)
        {
            TZTHQHeaderButton *btn = (TZTHQHeaderButton*)[self viewWithTag:i+BTNTag];
            [btn setContent:NULL];
        }
        return;
    }
    
    for (int i = 0; i < 3; i++)
    {
        TZTHQHeaderButton *btn = (TZTHQHeaderButton*)[self viewWithTag:i+BTNTag];
        if (i < ayData.count)
            [btn setContent:[ayData objectAtIndex:i]];
        else
            [btn setContent:NULL];
    }
    
    self.sendStockArray = ayData;
}

- (NSMutableArray *)getSendStockArray:(NSArray *)sourceArray
{
    NSMutableArray *stockArray = [NSMutableArray array];
    
    for (NSDictionary *pDict in sourceArray) {
        
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockName = [pDict tztObjectForKey:@"Name"];
        pStock.stockCode = [pDict tztObjectForKey:@"Code"];
        pStock.stockType = [[pDict tztObjectForKey:@"StockType"] intValue];
        [stockArray addObject: pStock];
    }
    
    return stockArray;
}

-(void)OnBtnClick:(id)sender
{
    if (sender == NULL || ![sender isKindOfClass:[TZTHQHeaderButton class]])
        return;
    
    TZTHQHeaderButton *btn = (TZTHQHeaderButton*)sender;
    //
    tztStockInfo* pStock = [btn GetStockInfo];
    
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)self.sendStockArray];
}

- (int)getIndexOfSendArray:(tztStockInfo *)stockInfo
{
    for (int i = 0; i < self.sendStockArray.count; i++) {
        tztStockInfo *sInfo = [self.sendStockArray objectAtIndex:i];
        if (sInfo.stockCode == stockInfo.stockCode && sInfo.stockType == stockInfo.stockType) {
            return i;
        }
    }
    return -1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
