/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    热门行业Cell
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import "TZTIndustryView.h"

#define BtnWidth 106
#define BtnHeight 60

#define Gap 5
#define IndustHeight 24
#define RateHeight 26
#define NameHeight 14
#define DetailHeight 14
#define tztIndustryBtnTag 0x1234

@interface TZTIndustryButton : UIButton
-(tztStockInfo*)GetStockInfo;

@property (nonatomic, retain) tztStockInfo *pStockInfo;
@property (nonatomic, retain) UILabel *lbArrow;
@property (nonatomic, retain) UILabel *lbIndustry;
@property (nonatomic, retain) UILabel *lbRate;
@property (nonatomic, retain) UILabel *lbName;
@property (nonatomic, retain) UILabel *lbLeadRange;
@property (nonatomic, retain) UILabel *lbDetail;
@property (nonatomic) BOOL            bHasTopStock;
@end

@implementation TZTIndustryButton

@synthesize lbDetail, lbName, lbRate, lbIndustry, pStockInfo, lbArrow, lbLeadRange;

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
    lbIndustry = [[UILabel alloc] initWithFrame:CGRectZero];
    lbIndustry.font = tztUIBaseViewTextFont(15);
    lbIndustry.textAlignment = NSTextAlignmentCenter;
    lbIndustry.backgroundColor = [UIColor clearColor];
    lbIndustry.textColor = [UIColor tztThemeTextColorLabel];
    [self addSubview: lbIndustry];
    [lbIndustry release];
    
    lbRate = [[UILabel alloc] initWithFrame:CGRectZero];
    lbRate.font = tztUIBaseViewTextFont(16);
    lbRate.textAlignment = NSTextAlignmentCenter;
    lbRate.backgroundColor = [UIColor clearColor];
    lbRate.textColor = [UIColor tztThemeTextColorLabel];
    [self addSubview: lbRate];
    [lbRate release];
    
    lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    lbName.font = tztUIBaseViewTextFont(10.5);
    lbName.textAlignment = NSTextAlignmentCenter;
    lbName.backgroundColor = [UIColor clearColor];
    lbName.adjustsFontSizeToFitWidth = YES;
    lbName.textColor = [UIColor tztThemeTextColorLabel];
    [self addSubview: lbName];
    [lbName release];
    
    lbLeadRange = [[UILabel alloc] initWithFrame:CGRectZero];
    lbLeadRange.font = tztUIBaseViewTextFont(10.5f);
    lbLeadRange.textAlignment = NSTextAlignmentCenter;
    lbLeadRange.backgroundColor = [UIColor clearColor];
    lbLeadRange.adjustsFontSizeToFitWidth = YES;
    lbLeadRange.textColor = [UIColor tztThemeTextColorLabel];
    [self addSubview:lbLeadRange];
    [lbLeadRange release];
    
    lbDetail = [[UILabel alloc] initWithFrame:CGRectZero];
    lbDetail.font = tztUIBaseViewTextFont(12);
    lbDetail.textAlignment = NSTextAlignmentCenter;
    lbDetail.backgroundColor = [UIColor clearColor];
    lbDetail.textColor = [UIColor tztThemeTextColorLabel];
    [self addSubview: lbDetail];
    lbDetail.hidden = YES;
    [lbDetail release];
    
    pStockInfo = NewObject(tztStockInfo);
    lbName.text = @"乐视网";
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQBlock];
    lbArrow.backgroundColor = [UIColor clearColor];
    lbIndustry.backgroundColor = [UIColor clearColor];
    lbIndustry.textColor = [UIColor tztThemeTextColorLabel];
    lbRate.backgroundColor = [UIColor clearColor];
    lbName.backgroundColor = [UIColor clearColor];
    lbName.textColor = [UIColor tztThemeTextColorLabel];
    lbDetail.backgroundColor = [UIColor clearColor];
    lbDetail.textColor = [UIColor tztThemeTextColorLabel];
    self.layer.borderColor=[UIColor tztThemeBorderColor].CGColor;
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    int nLine = 2;
    if (_bHasTopStock)
        nLine = 3;
    int nHeight = (frame.size.height - Gap*2) / nLine;
    CGRect indusRect = CGRectMake(0, Gap, frame.size.width, nHeight + Gap - 3);
    lbIndustry.frame = indusRect;
    
    CGRect rateRect = indusRect;
    rateRect.origin.y += indusRect.size.height/* - 4*/;
    rateRect.size.height = 16;
    lbRate.frame = rateRect;
    
    for (UIView *view in self.subviews)
    {
        if (CGRectIsEmpty(view.frame) || CGRectIsNull(view.frame))
            view.hidden = YES;
        else
            view.hidden = NO;
    }
    
    CGRect nameRect = rateRect;
    nameRect.origin.y += rateRect.size.height + 0;
    nameRect.origin.x += 10;
    nameRect.size.width = nameRect.size.width /2 -5;
    lbName.frame = nameRect;
    lbName.hidden = !_bHasTopStock;
    
    CGRect LeadRateRect = rateRect;
    LeadRateRect.origin.y += rateRect.size.height + 0;
    LeadRateRect.origin.x = nameRect.origin.x + nameRect.size.width;
    LeadRateRect.size.width = rateRect.size.width /2 - 10;
    lbLeadRange.frame = LeadRateRect;
    lbLeadRange.hidden = !_bHasTopStock;
    
    //    CGRect rcArrow = rateRect;
    //    CGSize sz = [lbRate.text sizeWithFont:lbRate.font];
    //    rcArrow.size.width = 8;
    //    rcArrow.origin.x = (rateRect.size.width - sz.width) / 2;
    //    lbArrow.frame = rcArrow;
    
    //    CGRect nameRect = CGRectMake(0, Gap + IndustHeight + RateHeight, frame.size.width, NameHeight);
    //    lbName.frame = nameRect;
    
    //    CGRect detailRect = rateRect;
    //    detailRect.origin.y += rateRect.size.height - Gap;
    //    detailRect.origin.x = 0;
    //    detailRect.size.width = indusRect.size.width;
    //    lbDetail.frame = detailRect;
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
    
    NSDictionary* dictTopStock = [pData tztObjectForKey:@"LeadStockName"];
    NSString* strLeadStockName = [dictTopStock tztObjectForKey:@"value"];
    
    NSDictionary* dictLeadRange = [pData tztObjectForKey:@"LeadRange"];
    NSString* strLeadRange = [dictLeadRange tztObjectForKey:@"value"];
    UIColor *clLeadRange = [dictLeadRange tztObjectForKey:@"color"];
    
    NSString* strStockType = [pData tztObjectForKey:@"StockType"];
    
    int nFlag = 0;
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
    
    lbIndustry.text = strName;
    UIColor *pColor = [UIColor tztThemeHQBalanceColor];
    if ([strRatio caseInsensitiveCompare:@"-.-"] == NSOrderedSame
        || [strRatio isEqualToString:@"--"]
        || [strRatio isEqualToString:@"-"])
    {
        
    }
    else if ([strRatio hasPrefix:@"-"])
    {
        nFlag = -1;
        pColor = [UIColor tztThemeHQDownColor];
    }
    else
    {
        nFlag = 1;
        pColor = [UIColor tztThemeHQUpColor];
    }
    
    if (nFlag > 0)
    {
        //        lbArrow.text = [NSString stringWithFormat:@"▲"];
        lbRate.text = [NSString stringWithFormat:@"+%@", strRange];
    }
    else if (nFlag < 0)
    {
        //        lbArrow.text = [NSString stringWithFormat:@"▼"];
        lbRate.text = [NSString stringWithFormat:@"%@", strRange];
    }
    else
    {
        //        lbArrow.text = [NSString stringWithFormat:@"■"];
        lbRate.text = [NSString stringWithFormat:@"%@", strRange];
    }
    lbRate.textColor = pColor;
    lbDetail.text = [NSString stringWithFormat:@"%@  %@",strPrice, strRatio];
    
    lbName.text = strLeadStockName;
    lbLeadRange.text = strLeadRange;
    if (clLeadRange)
        lbLeadRange.textColor = clLeadRange;
    
    
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
    DelObject(pStockInfo);
    [super dealloc];
}

@end

#define tztIndustryCellTag 0x9987
@interface TZTIndustryCell()
{
    int _nTotalCount;
    BOOL _bUseGrid;
    BOOL _bHasTopStock;
}
@end
@implementation TZTIndustryCell
@synthesize clBackColor = _clBackColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTotalCount_:(int)nTotal andGrid_:(BOOL)bGrid bHasTopStock:(BOOL)bHasTopStock
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds = YES;
        self.contentView.clipsToBounds = YES;
        _nTotalCount = nTotal;
        _bUseGrid = !bGrid;
        _bHasTopStock = bHasTopStock;
        [self initViews];
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTotalCount_:(int)nTotal
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier andTotalCount_:nTotal andGrid_:NO bHasTopStock:NO];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier andTotalCount_:6];
}

- (void)initViews
{
    for (int i = 0; i < _nTotalCount; i++)
    {
        TZTIndustryButton *cellBtn = (TZTIndustryButton*)[self viewWithTag:tztIndustryBtnTag + i];
        
        if (cellBtn == NULL)
        {
            cellBtn = [TZTIndustryButton buttonWithType:UIButtonTypeCustom];
            cellBtn.bHasTopStock = _bHasTopStock;
            cellBtn.tag = tztIndustryBtnTag + i;
            [cellBtn addTarget:self
                        action:@selector(OnBtnClicked:)
              forControlEvents:UIControlEventTouchUpInside];
            cellBtn.clipsToBounds=YES;
            [self addSubview:cellBtn];
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = self.clBackColor;
    self.contentView.frame = self.bounds;
    self.contentView.backgroundColor = self.clBackColor;
    CGRect rc = self.bounds;
    float btnWidth = rc.size.width / 3;
    int nRowCount = (_nTotalCount / 3) + ((_nTotalCount%3 == 0) ? 0 : 1);
    float btnHeight = rc.size.height / (nRowCount);
    
    int nCount = 0;
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < nRowCount; j++)
        {
            if (nCount > _nTotalCount)
                break;
            TZTIndustryButton *cellBtn = (TZTIndustryButton*)[self viewWithTag:tztIndustryBtnTag + ((i)+(j*3))];
            nCount++;
            
            cellBtn.frame = CGRectMake(i*btnWidth, j*btnHeight, btnWidth, btnHeight);
            
            if (_bUseGrid)
            {
                CGRect rcRight = cellBtn.frame;
                rcRight.origin.x += rcRight.size.width-.5f;
                rcRight.size.width = .5f;
                CGRect rcBottom = cellBtn.frame;
                rcBottom.origin.y += rcBottom.size.height-1;
                rcBottom.size.height = .5f;
                if (nRowCount > 1 && j >= 0 && (j != nRowCount - 1))
                {
                    UIView *pLineView = [self viewWithTag:tztIndustryCellTag*2+nCount];
                    if (pLineView == NULL && (j % 3) != 2)
                    {
                        pLineView = [[UIView alloc] initWithFrame:rcBottom];
                        pLineView.tag = tztIndustryCellTag*2+nCount;
                        [self addSubview:pLineView];
                    }
                    else
                        pLineView.frame = rcBottom;
                    pLineView.backgroundColor = [UIColor tztThemeBorderColor];
                    
                }
                CGRect rc = cellBtn.frame;
                rc.size.width = .5f;
                rc.origin.x = (i+1)*btnWidth - .5f;
                rc.origin.y = j*btnHeight;
                if (j >= 0 && (j < nRowCount))
                {
                    UIView *pSLineView = [self viewWithTag:tztIndustryCellTag*3+nCount];
                    if (pSLineView == NULL && (i + 1)%3 != 0)
                    {
                        
                        pSLineView = [[UIView alloc] initWithFrame:rc];
                        pSLineView.tag = tztIndustryCellTag*3+nCount;
                        [self addSubview:pSLineView];
                    }
                    else
                        pSLineView.frame = rc;
                    
                    pSLineView.backgroundColor = [UIColor tztThemeBorderColor];
                }
            }
            else
            {
                cellBtn.frame = CGRectInset(cellBtn.frame, 1, 1);
                cellBtn.layer.borderWidth = 0.5f;
                cellBtn.layer.borderColor = [UIColor tztThemeBorderColor].CGColor;
            }
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)setContentData:(NSMutableArray *)ayData
{
    if (ayData == NULL || [ayData count] < 1)
    {
        for (int i = 0; i < _nTotalCount; i++)
        {
            TZTIndustryButton *cellBtn = (TZTIndustryButton*)[self viewWithTag:tztIndustryBtnTag + i];
            [cellBtn setContent:NULL];
        }
    }
    for (int i = 0; i < _nTotalCount; i++)
    {
        TZTIndustryButton *cellBtn = (TZTIndustryButton*)[self viewWithTag:tztIndustryBtnTag + i];
        if (i >= [ayData count])
            break;
        [cellBtn setContent:[ayData objectAtIndex:i]];
    }
}

-(void)OnBtnClicked:(id)sender
{
    if (sender == NULL || ![sender isKindOfClass:[TZTIndustryButton class]])
        return;
    
    TZTIndustryButton* btn = (TZTIndustryButton*)sender;
    tztStockInfo *pStock = [btn GetStockInfo];
    //跳转行业板块对应排名列表
    NSDictionary *dic0 = @{@"Action":@"20199"};
    [TZTUIBaseVCMsg OnMsg:0x123456 wParam:(NSUInteger)pStock lParam:(NSUInteger)dic0];
}

@end
