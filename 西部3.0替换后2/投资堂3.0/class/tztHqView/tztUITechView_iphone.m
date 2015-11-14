/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUITechView_iphone.h"

@interface tztUITechView_iphone()
@property(nonatomic)BOOL bHTFund;
@end

@implementation tztUITechView_iphone
@synthesize pQuoteView = _pQuoteView;
@synthesize pTechView = _pTechView;
@synthesize nStockType = _nStockType;
@synthesize pScrollView = _pScrollView;
@synthesize pAyBtnData = _pAyBtnData;
@synthesize bHTFund = _bHTFund;
@synthesize hasNoAddBtn = _hasNoAddBtn;


-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)dealloc
{
    DelObject(_pAyBtnData);
    [super dealloc];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    if (_pTechView)
        [_pTechView onSetViewRequest:bRequest];
}

-(void)LoadCycleBtn
{
    NSArray* ayCycle = [[NSArray alloc] initWithObjects:
     [NSNumber numberWithInt:KLineCycleDay],
     [NSNumber numberWithInt:KLineCycle1Min],
     [NSNumber numberWithInt:KLineCycle5Min],
     [NSNumber numberWithInt:KLineCycle15Min],
     [NSNumber numberWithInt:KLineCycle30Min],
    [NSNumber numberWithInt:KLineCycle60Min],
    [NSNumber numberWithInt:KLineCycleWeek],
    [NSNumber numberWithInt:KLineCycleMonth],
     [NSNumber numberWithInt:KLineCycleCustomMin],
     [NSNumber numberWithInt:KLineCycleCustomDay],
     [NSNumber numberWithInt:KLineChuQuan],
     nil ];
    
    if (_pAyBtnData == NULL)
        _pAyBtnData = NewObject(NSMutableArray);
    
    NSInteger nCount = [ayCycle count];
    NSInteger nWidth = 60;
    NSInteger nSpace = 4;
    _pScrollView.contentSize = CGSizeMake(nWidth * nCount + (nCount + 1)*nSpace, _pScrollView.frame.size.height);
    CGRect rcSwith = _pScrollView.bounds;
    rcSwith.origin.x = nSpace;
    rcSwith.origin.y += 2;
    rcSwith.size.height -= 4;
    rcSwith.size.width = nWidth;
    UIImage *imageSel = [UIImage imageTztNamed:@"TZTTabButtonSelBg"];
    UIImage *image = [UIImage imageTztNamed:@"TZTTabButtonBg"];
    for (int i = 0; i < [ayCycle count]; i++)
    {
        int n = [[ayCycle objectAtIndex:i] intValue];
        tztUISwitch *pSwitch = [[tztUISwitch alloc] init];
        pSwitch.yesImage = imageSel;
        pSwitch.noImage = image;
        pSwitch.fontSize = 12.f;
        pSwitch.yestitle = getCycleName(n);
        pSwitch.notitle = getCycleName(n);
        pSwitch.tag = n;
        pSwitch.frame = rcSwith;
        pSwitch.showsTouchWhenHighlighted = YES;
        if (n == KLineCycleDay  ||( n ==KLineChuQuan && [tztTechSetting getInstance].nKLineChuQuan))
            pSwitch.checked = YES;
        else
            pSwitch.checked = NO;
        [pSwitch addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_pScrollView addSubview:pSwitch];
        [_pAyBtnData addObject:pSwitch];
        [pSwitch release];
        rcSwith.origin.x += nSpace + nWidth;
    }
    
    [ayCycle release];
}

-(void)OnClick:(id)sender
{
    tztUISwitch *pSwitch = (tztUISwitch*)sender;
    if (pSwitch == NULL)
        return;
    
    NSInteger nTag = pSwitch.tag;
    
    for (int i = 0; i < [_pAyBtnData count]; i++)
    {
        tztUISwitch *pTem = [_pAyBtnData objectAtIndex:i];
        
        if (nTag == KLineChuQuan || pTem.tag == KLineChuQuan)
            break;
        if (pTem == pSwitch)
        {
            pTem.checked = YES;
        }
        else
        {
            pTem.checked = NO;
        }
    }
    
    [_pTechView tztChangeCycle:(int)nTag picker_:nil];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    
    CGRect rcQuote = rcFrame;
    rcQuote.size.height = tztQuoteViewHeight;
    if (_pQuoteView == nil)
    {
        _pQuoteView = [[tztQuoteView alloc] initWithFrame:rcQuote];
        _pQuoteView.tztdelegate = self;
        _pQuoteView.hasNoAddBtn = self.hasNoAddBtn;
        [self addSubview:_pQuoteView];
        [_pQuoteView release];
    }
    else
    {
        _pQuoteView.hasNoAddBtn = self.hasNoAddBtn;
        _pQuoteView.frame = rcQuote;
    }
    
    CGRect rcScroll = rcFrame;
    rcScroll.origin.y += rcQuote.size.height;
    
    rcScroll.size.height = 32;
    if (MakeHTFundMarket(self.pStockInfo.stockType))
    {
        rcScroll.size.height = 0;
    }
#ifdef tzt_HiddenCycle
    if (_pScrollView == NULL)
    {
        _pScrollView = [[UIScrollView alloc] initWithFrame:rcScroll];
        _pScrollView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];// [tztTechSetting getInstance].backgroundColor;
        [self addSubview:_pScrollView];
        _pScrollView.bounces = NO;
            [_pScrollView release];
        [self LoadCycleBtn];
    }
    else
    {
        _pScrollView.frame = rcScroll;
    }
#else
    rcScroll.size.height = 0;
#endif
    
    CGRect rcTech = rcFrame;
    rcTech.origin.y += rcScroll.origin.y + rcScroll.size.height;
    rcTech.size.height = rcFrame.size.height - rcQuote.size.height - rcScroll.size.height;
    if (_pTechView == nil)
    {
        _pTechView = [[tztTechView alloc] init];
        _pTechView.pStockInfo = self.pStockInfo;
        _pTechView.tztdelegate = self;
        _pTechView.bTechMoved = YES;
        _pTechView.frame = rcTech;
        [self addSubview:_pTechView];
        [_pTechView release];
    }
    else
    {
        _pTechView.frame = rcTech;
    }
    
//    if (MakeHTFundMarket(self.pStockInfo.stockType))
//    {
//        [_pTechView setTechMapNum:KLineMapOne];
//    }
}

-(void)UpdateData:(id)obj
{
    if (obj == _pTechView)
    {
        if (MakeHTFundMarket(self.pStockInfo.stockType))
        {
            TNewKLineHead *pData = [(tztTechView*)obj GetNewKLineHead];
            TNewPriceData *pPriceData = [(tztTechView*)obj GetNewPriceData];
            if (pData && _pQuoteView)
            {
                _pQuoteView.pStockInfo = _pTechView.pStockInfo;
                [_pQuoteView setTechHeadData:pData len:sizeof(TNewKLineHead)];
                if (pPriceData)
                    [_pQuoteView setPriceData:pPriceData len:sizeof(TNewPriceData)];
                [_pQuoteView UpdateLabelData];
            }
        }
        else
        {
            TNewPriceData *pData = [(tztTechView*)obj GetNewPriceData];
            if (pData && _pQuoteView)
            {
                _pQuoteView.pStockInfo = _pTechView.pStockInfo;
                [_pQuoteView setPriceData:pData len:sizeof(TNewPriceData)];
                [_pQuoteView UpdateLabelData];
            }
        }
    }
}

//-(void)setStockCode:(NSString *)strCode stockType_:(NSInteger)stockType
//{
//    if (strCode == nil)
//        return;
//    self.stockCode = [NSString stringWithFormat:@"%d", strCode];
//    _nStockType = stockType;
//}

-(void)setStockInfo:(tztStockInfo *)pStockCode Request:(int)nRequest
{
    self.pStockInfo = pStockCode;
    if (pStockCode == NULL)
        return;
    
    if (MakeHTFundMarket(self.pStockInfo.stockType))
    {
        if (_bHTFund != MakeHTFundMarket(self.pStockInfo.stockType))
        {
            [self setFrame:self.frame];
            _bHTFund = MakeHTFundMarket(self.pStockInfo.stockType);
        }
    }
    if (_pQuoteView)
    {
        [_pQuoteView setStockInfo:pStockCode Request:0];
    }
    if (_pTechView)
    {
        [_pTechView setStockInfo:pStockCode Request:nRequest];
    }   
}

-(void)tzthqView:(id)hqView RequestHisTrend:(tztStockInfo *)pStock nsHisDate:(NSString *)nsHisDate
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:RequestHisTrend:nsHisDate:)])
    {
        [_tztdelegate tzthqView:hqView RequestHisTrend:pStock nsHisDate:nsHisDate];
    }
}

-(tztStockInfo*)GetCurrentStock
{
    if (_pTechView)
        return [_pTechView GetCurrentStock];
    return NULL;
}

//自选操作
-(void)tzthqView:(id)hqView AddOrDelStockCode:(tztStockInfo *)pStock
{
    if (pStock == NULL)
        return;
    
    //删除操作
    if ([tztUserStock IndexUserStock:pStock] < 0)
    {
        [tztUserStock AddUserStock:pStock];
    }
    //添加操作
    else
    {
        [tztUserStock DelUserStock:pStock];
    }
}
@end
