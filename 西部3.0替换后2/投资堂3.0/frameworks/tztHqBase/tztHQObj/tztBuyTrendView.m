//
//  tztBuyTrendView.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-10-17.
//
//

#import "tztBuyTrendView.h"
#import "tztTrendView.h"

#define tztLineHeight 36

@interface tztBuyTrendView()<tztHqBaseViewDelegate>
{
    BOOL    bSendAutoPush;
}
@property(nonatomic,retain)tztTrendView *pTrendView;
@property(nonatomic,retain)UIView       *pTitleBack;
@property(nonatomic,retain)UILabel      *pLabelName;
@property(nonatomic,retain)UILabel      *pLabelData;
@property(nonatomic,retain)UILabel      *pLabelMoney;
@property(nonatomic,retain)UIView       *pTopLine;
@property(nonatomic,retain)UIView       *pBottomLine;
@end

@implementation tztBuyTrendView
@synthesize pTrendView = _pTrendView;
@synthesize pLabelName = _pLabelName;
@synthesize pLabelData = _pLabelData;
@synthesize pTitleBack = _pTitleBack;
@synthesize pLabelMoney = _pLabelMoney;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    [super setPStockInfo:pStockInfo];
    if (self.pTrendView)
        self.pTrendView.pStockInfo = pStockInfo;
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    [super setStockInfo:pStockInfo Request:nRequest];
    if (self.pTrendView)
        [self.pTrendView setStockInfo:pStockInfo Request:nRequest];
    //发送主推请求
}

-(void)onClearData
{
    self.pLabelName.text = @"";
    self.pLabelData.text = @"";
    self.pLabelMoney.text = @"";
    if (self.pTrendView)
        [self.pTrendView onClearData];
}

-(void)setNeedsDisplay
{
    if (self.pTrendView)
        [self.pTrendView setNeedsDisplay];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    if (self.pTrendView)
        [self.pTrendView onSetViewRequest:bRequest];
    
    if (g_bUseHQAutoPush)
    {
        if (bRequest)//发送主推
        {
            if (bSendAutoPush)
            {
                [[tztAutoPushObj getShareInstance] setAutoPushDataWithString:[NSString stringWithFormat:@"%@|%d", self.pTrendView.pStockInfo.stockCode, self.pTrendView.pStockInfo.stockType] andDelegate_:self];
            }
        }
        else
        {
            bSendAutoPush = TRUE;
            [[tztAutoPushObj getShareInstance] cancelAutoPush:nil];
        }
    }
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    self.backgroundColor = [UIColor tztThemeBackgroundColorJY];
    CGRect rcFrame = self.bounds;
    CGRect rcTitle = rcFrame;
    rcTitle.size.height = tztLineHeight;
    
    if (_pTitleBack == NULL)
    {
        _pTitleBack = [[UIView alloc] initWithFrame:rcTitle];
        _pTitleBack.backgroundColor = [UIColor tztThemeBackgroundColorSection];
        [self addSubview:_pTitleBack];
        [_pTitleBack release];
    }
    else
        _pTitleBack.frame = rcTitle;
    
    rcTitle.origin = CGPointZero;
    rcTitle.size.width = 0.2 * rcFrame.size.width;
    if (_pLabelName == NULL)
    {
        _pLabelName = [[UILabel alloc] initWithFrame:rcTitle];
        _pLabelName.backgroundColor = [UIColor clearColor];
        _pLabelName.adjustsFontSizeToFitWidth = YES;
        _pLabelName.textAlignment = NSTextAlignmentCenter;
        _pLabelName.font = tztUIBaseViewTextFont(14);
        _pLabelName.textColor = [UIColor tztThemeTextColorLabel];
        [self.pTitleBack addSubview:_pLabelName];
        [_pLabelName release];
    }
    else
    {
        _pLabelName.frame = rcTitle;
    }
    
    rcTitle.origin.x += rcTitle.size.width + 5;
    rcTitle.size.width = rcFrame.size.width * 0.6 - 10;
    if (_pLabelData == NULL)
    {
        _pLabelData = [[UILabel alloc] initWithFrame:rcTitle];
        _pLabelData.backgroundColor = [UIColor clearColor];
        _pLabelData.adjustsFontSizeToFitWidth = YES;
        _pLabelData.font = tztUIBaseViewTextFont(14);
        _pLabelData.textAlignment = NSTextAlignmentCenter;
        [self.pTitleBack addSubview:_pLabelData];
        [_pLabelData release];
    }
    else
        _pLabelData.frame = rcTitle;
    
    rcTitle.origin.x += rcTitle.size.width + 5;
    rcTitle.size.width = rcFrame.size.width * 0.2 - 5;
    if (_pLabelMoney == NULL)
    {
        _pLabelMoney = [[UILabel alloc] initWithFrame:rcTitle];
        _pLabelMoney.backgroundColor = [UIColor clearColor];
        _pLabelMoney.adjustsFontSizeToFitWidth = YES;
        _pLabelMoney.font = tztUIBaseViewTextFont(14);
        _pLabelMoney.textAlignment = NSTextAlignmentCenter;
        [self.pTitleBack addSubview:_pLabelMoney];
        _pLabelMoney.textColor = [UIColor tztThemeTextColorLabel];
        [_pLabelMoney release];
    }
    else
        _pLabelMoney.frame = rcTitle;
    
    CGRect rcTop = rcFrame;
    rcTop.size.height = 1;
    if (_pTopLine == NULL)
    {
        _pTopLine = [[UIView alloc] initWithFrame:rcTop];
        _pTopLine.backgroundColor = [UIColor tztThemeBorderColorGrid];
        [self.pTitleBack addSubview:_pTopLine];
        [_pTopLine release];
    }
    else
        _pTopLine.frame = rcTop;
    
    rcTop.origin.y += rcTitle.size.height - 1;
    if (_pBottomLine == NULL)
    {
        _pBottomLine = [[UIView alloc] initWithFrame:rcTop];
        _pBottomLine.backgroundColor = [UIColor tztThemeBorderColorGrid];
        [self.pTitleBack addSubview:_pBottomLine];
        [_pBottomLine release];
    }
    else
        _pBottomLine.frame = rcTop;
    
    
    CGRect rcTrend = rcFrame;
    rcTrend.origin.y += rcTitle.size.height + 10;
    rcTrend.size.height -= (rcTitle.size.height + 10);
    if (_pTrendView == NULL)
    {
        _pTrendView = [[tztTrendView alloc] initWithFrame:rcTrend];
        if (g_bUseHQAutoPush)
            _pTrendView.bAutoPush = YES;
        _pTrendView.tztdelegate = self;
        _pTrendView.bShowTips = NO;
        _pTrendView.bShowLeftPriceInSide = YES;
        _pTrendView.tztPriceStyle = TrendPriceNon;
        [self addSubview:_pTrendView];
        [_pTrendView release];
    }
    else
        _pTrendView.frame = rcTrend;
}

//更新数据
-(void)UpdateData:(id)obj
{
    TNewPriceData *pData = nil;
    if ([obj isKindOfClass:[tztTrendView class]])
    {
        if (!((tztTrendView*)obj).hidden)
        {
            pData = [(tztTrendView*)obj GetNewPriceData];
        }
    }
    
    if (pData == NULL)
    {
        self.pLabelName.text = @"";
        self.pLabelData.text = @"";
        self.pLabelMoney.text = @"";
        return;
    }
    
    UIColor* pColor = [UIColor tztThemeHQBalanceColor];
    if (pData->Last_p > pData->Close_p)
        pColor = [UIColor tztThemeHQUpColor];
    else if(pData->Last_p < pData->Close_p)
        pColor = [UIColor tztThemeHQDownColor];
    
    //获取名称
    NSString* strName = getName_TNewPriceData(pData);
    self.pLabelName.text = strName;
    NSString* strData = @"  %@   %@   %@";
    //最新价
    NSString* strPrice = NSStringOfVal_Ref_Dec_Div(pData->Last_p,0,pData->nDecimal,1000);
    //涨跌
    NSString* strRatioValue = @"";
    if(pData->Last_p != 0)
        strRatioValue = NSStringOfVal_Ref_Dec_Div(pData->m_lUpPrice, 0, pData->nDecimal, 1000);
    else
        strRatioValue = NSStringOfVal_Ref_Dec_Div(0, 0, 2, 1000);
    //幅度
    
    NSString* nsRange = @"";
    if(pData->Last_p != 0)
    {
        nsRange = NSStringOfVal_Ref_Dec_Div(pData->m_lUpIndex, 0, 2, 100);
    }
    else
    {
        nsRange = NSStringOfVal_Ref_Dec_Div(0, 0, 2, 100);
    }
    nsRange = [NSString stringWithFormat:@"%@%%", nsRange];
    
    //总成交金额
    NSString *nsTotal = @"";
    nsTotal = NStringOfFloat(pData->Total_m);
 
    strData = [NSString stringWithFormat:@"  %@    %@    %@  ", strPrice, strRatioValue, nsRange];
    self.pLabelData.text = strData;
    self.pLabelData.textColor = pColor;
    self.pLabelMoney.text = nsTotal;
    
    
    if (g_bUseHQAutoPush)
    {
        if (!bSendAutoPush)
        {
            [[tztAutoPushObj getShareInstance] setAutoPushDataWithString:[NSString stringWithFormat:@"%@|%d", self.pTrendView.pStockInfo.stockCode, self.pTrendView.pStockInfo.stockType] andDelegate_:self];
            bSendAutoPush = TRUE;
        }
    }
}

@end






