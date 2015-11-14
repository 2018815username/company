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

#import "TZTUIStockDetailView.h"

//titleview高度
#define TZTTitleHeight 40
//bottomview高度
#define TZTBottomHeight 210
//rightview宽度
#define TZTRightWidth 250
//
#define TZTSegmentHeight 30

@interface TZTUIStockDetailView(TZTPrivate)

-(void)LayoutWithTitleView:(CGRect)rcFrame;
-(void)setButtonFrame:(CGRect)rcFrame;
@end

@implementation TZTUIStockDetailView
//@synthesize m_nsStockCode;
@synthesize m_nsStockName;
@synthesize m_pTrendView;
@synthesize m_pTitleView;
@synthesize m_pRightView;
@synthesize m_pBottomView;
@synthesize m_pTechView;
@synthesize m_pDetailView;
@synthesize segmentControl = _segmentControl;
@synthesize pFinanceView = _pFinanceView;
@synthesize pBtnYuJing = _pBtnYuJing;
@synthesize pBtnF9 = _pBtnF9;
@synthesize pBtnF10 = _pBtnF10;
@synthesize pBtnBuy = _pBtnBuy;
@synthesize pBtnSell = _pBtnSell;
@synthesize pBtnKLine = _pBtnKLine;
@synthesize ayBtn = _ayBtn;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.m_nsStockName = @"";
        self.nsStockCode = @"";
        self.m_pTrendView = nil;
        self.m_pTitleView = nil;
        self.m_pRightView = nil;
        self.m_pBottomView = nil;
        self.m_pTechView = nil;
        self.m_pDetailView = nil;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    if (self.m_pTrendView)
    {
        [self.m_pTrendView onSetViewRequest:bRequest];
    }
    if (self.m_pTechView)
    {
        [self.m_pTechView onSetViewRequest:bRequest];
    }
    if (self.m_pDetailView)
    {
        [self.m_pDetailView onSetViewRequest:bRequest];
    }
    if (self.m_pRightView)
    {
        [self.m_pRightView onSetViewRequest:bRequest];
    }
    if (self.m_pBottomView)
    {
        [self.m_pBottomView onSetViewRequest:bRequest];
    }
    if (self.pFinanceView)
    {
        [self.pFinanceView onSetViewRequest:bRequest];
    }
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    
    //标题信息显示
    CGRect rcTitle = rcFrame;
    rcTitle.size.height = TZTTitleHeight;
    rcTitle.size.width -= TZTRightWidth;
    
    [self LayoutWithTitleView:rcTitle];
    
    CGRect rcTrend = rcFrame;
    rcTrend.origin.y += rcTitle.size.height;
    rcTrend.size.height -= rcTitle.size.height + TZTBottomHeight;
    rcTrend.size.width = rcTitle.size.width;
    if (self.m_pTrendView == nil)
    {
        self.m_pTrendView = [[[tztTrendView alloc] initWithFrame:rcTrend] autorelease];
        self.m_pTrendView.tztdelegate = self;
        [self addSubview:self.m_pTrendView];
    }
    else
    {
        self.m_pTrendView.frame = rcTrend;
    }
    [self.m_pTrendView setNeedsDisplay];
    
    if (self.m_pTechView == nil)
    {
        self.m_pTechView = [[[tztTechView alloc] initWithFrame:rcTrend] autorelease];
        self.m_pTechView.tztdelegate = self;
        self.m_pTechView.bTechMoved = YES;
        [self addSubview:self.m_pTechView];
        self.m_pTechView.hidden = YES;
    }
    else
    {
        self.m_pTechView.frame = rcTrend;
    }
    [self.m_pTechView setNeedsDisplay];
    
    //右侧的详情显示
    CGRect rcRight = rcFrame;
    rcRight.origin.x += rcTrend.size.width;
    rcRight.size.width = TZTRightWidth;
    rcRight.size.height -= TZTSegmentHeight;//去掉底部的segmentcontrol高度
    if (self.m_pRightView == NULL)
    {
        self.m_pRightView = [[[tztPriceView alloc] initWithFrame:rcRight] autorelease];
        [self addSubview:self.m_pRightView];
    }
    else
    {
        self.m_pRightView.frame = rcRight;
    }
    [self.m_pRightView setNeedsDisplay];
    
    //成交明细
    if (self.m_pDetailView == NULL)
    {
        self.m_pDetailView = [[[tztDetailView alloc] initWithFrame:rcRight] autorelease];
        self.m_pDetailView.hidden = YES;
        [self addSubview:self.m_pDetailView];
    }
    else
    {
        self.m_pDetailView.frame = rcRight;
    }
    
    if (self.pFinanceView == NULL)
    {
        self.pFinanceView = [[[tztFinanceView alloc] initWithFrame:rcRight] autorelease];
        self.pFinanceView.hidden = YES;
        [self addSubview:self.pFinanceView];
    }
    else
    {
        self.pFinanceView.frame = rcRight;
    }
    
    CGRect rcSegment = rcRight;
    rcSegment.origin.y = rcRight.origin.y + rcRight.size.height;
    rcSegment.size.height = TZTSegmentHeight;
    if (self.segmentControl == NULL)
    {
        self.segmentControl = [[[UISegmentedControl alloc] initWithFrame:rcSegment] autorelease];
        
        [self.segmentControl insertSegmentWithTitle:@"报价" atIndex:0 animated:YES];
        [self.segmentControl insertSegmentWithTitle:@"明细" atIndex:1 animated:YES];
        [self.segmentControl insertSegmentWithTitle:@"财务" atIndex:2 animated:YES];
        
        [self.segmentControl addTarget:self 
                                action:@selector(segmentAction:) 
                      forControlEvents:UIControlEventValueChanged];
        self.segmentControl.segmentedControlStyle = UISegmentedControlStyleBordered;
        self.segmentControl.tintColor = [UIColor colorWithTztRGBStr:@"81, 81, 81"];
        [self addSubview:self.segmentControl];
    }
    else
        self.segmentControl.frame = rcSegment;
    
    //底部的资讯信息显示
    CGRect rcBottom = rcTrend;
    rcBottom.size.width = rcTrend.size.width;
    rcBottom.origin.y += rcTrend.size.height;
    rcBottom.size.height = rcFrame.size.height - rcBottom.origin.y;
    if (self.m_pBottomView == NULL)
    {
        self.m_pBottomView = [[[TZTUIBottomSetView alloc] initWithFrame:rcBottom] autorelease];
        self.m_pBottomView.pDelegate = self;
        [self addSubview:self.m_pBottomView];
    }
    else
        self.m_pBottomView.frame = rcBottom;
    
}

-(void)LayoutWithTitleView:(CGRect)rcFrame
{
    if (self.m_pTitleView == nil)
    {
//        self.m_pTitleView = [[[tztQuoteView alloc] initWithFrame:rcFrame] autorelease];        
//        self.m_pTechView.delegate = self;
//        UIButton *pButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        pButton.frame = rcFrame;
//        [pButton addTarget:self action:@selector(ChangeHQView:) forControlEvents:UIControlEventTouchUpInside];
//        [self.m_pTitleView addSubview:pButton];
        self.m_pTitleView = [[[UIView alloc] initWithFrame:rcFrame] autorelease];
        self.m_pTitleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTStockBg.png"]];
        
        //左侧增加代码，名称，增删自选股
        NSString *nsTxt = [NSString stringWithFormat:@" %@ %@",self.m_nsStockName, self.nsStockCode];
        UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(rcFrame.origin.x, rcFrame.origin.y, 180, rcFrame.size.height)];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.text = nsTxt;
        pLabel.tag = 0x1024;
        pLabel.textAlignment = UITextAlignmentLeft;
        [pLabel setFont:tztUIBaseViewTextFont(18.0f)];
        pLabel.textColor = [UIColor yellowColor];
        pLabel.adjustsFontSizeToFitWidth = YES;
        [self.m_pTitleView addSubview:pLabel];
        [pLabel release];
        
        UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtn setTztBackgroundImage:[UIImage imageTztNamed:@"TZTNavAddStock.png"]];
        pBtn.tag = 0x1025;
        pBtn.frame = CGRectMake(rcFrame.origin.x + 185, rcFrame.origin.y + 8, 24, 24);
        pBtn.contentMode = UIViewContentModeCenter;
        pBtn.showsTouchWhenHighlighted = YES;
        [pBtn addTarget:self action:@selector(OnDelOrAddUserStock) forControlEvents:UIControlEventTouchUpInside];
        [self.m_pTitleView addSubview:pBtn];
        
     
        CGRect rcBtn = rcFrame;
        rcBtn.origin.x += pLabel.frame.size.width + pBtn.frame.size.width + 5;
        rcBtn.size.width -= (pLabel.frame.size.width + pBtn.frame.size.width + 5);
        
        if (_ayBtn == NULL)
            _ayBtn = NewObject(NSMutableArray);
        [_ayBtn removeAllObjects];
        _pBtnKLine = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnKLine setTztBackgroundImage:[UIImage imageTztNamed:@"TZTButton.png"]];
        [_pBtnKLine setTztTitle:@"K线"];
        [_pBtnKLine setTztTitleColor:[UIColor whiteColor]];
        _pBtnSell.showsTouchWhenHighlighted = YES;
        [_pBtnKLine addTarget:self action:@selector(OnKLine) forControlEvents:UIControlEventTouchUpInside];
        [m_pTitleView addSubview:_pBtnKLine];
        [_ayBtn addObject:_pBtnKLine];
        
        _pBtnSell = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnSell setTztBackgroundImage:[UIImage imageTztNamed:@"TZTButton.png"]];
        [_pBtnSell setTztTitle:@"卖出"];
        [_pBtnSell setTztTitleColor:[UIColor whiteColor]];
        _pBtnSell.showsTouchWhenHighlighted = YES;
        [_pBtnSell addTarget:self action:@selector(OnSell) forControlEvents:UIControlEventTouchUpInside];
        [m_pTitleView addSubview:_pBtnSell];
        [_ayBtn addObject:_pBtnSell];
        
        _pBtnBuy = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnBuy setTztBackgroundImage:[UIImage imageTztNamed:@"TZTButton.png"]];
        [_pBtnBuy setTztTitle:@"买入"];
        [_pBtnBuy setTztTitleColor:[UIColor whiteColor]];
        _pBtnBuy.showsTouchWhenHighlighted = YES;
        [_pBtnBuy addTarget:self action:@selector(OnBuy) forControlEvents:UIControlEventTouchUpInside];
        [m_pTitleView addSubview:_pBtnBuy];
        [_ayBtn addObject:_pBtnBuy];
        
        _pBtnF10 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnF10 setTztBackgroundImage:[UIImage imageTztNamed:@"TZTButton.png"]];
        [_pBtnF10 setTztTitle:@"F10"];
        [_pBtnF10 setTztTitleColor:[UIColor whiteColor]];
        _pBtnF10.showsTouchWhenHighlighted = YES;
        _pBtnF10.hidden = YES;
        [_pBtnF10 addTarget:self action:@selector(OnF10) forControlEvents:UIControlEventTouchUpInside];
        [m_pTitleView addSubview:_pBtnF10];
        [_ayBtn addObject:_pBtnF10];
        
        _pBtnF9 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnF9 setTztBackgroundImage:[UIImage imageTztNamed:@"TZTButton.png"]];
        [_pBtnF9 setTztTitle:@"F9"];
        [_pBtnF9 setTztTitleColor:[UIColor whiteColor]];
        _pBtnF9.showsTouchWhenHighlighted = YES;
        _pBtnF9.hidden = YES;
        [_pBtnF9 addTarget:self action:@selector(OnF9) forControlEvents:UIControlEventTouchUpInside];
        [m_pTitleView addSubview:_pBtnF9];
        [_ayBtn addObject:_pBtnF9];
        
        _pBtnYuJing = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnYuJing setTztBackgroundImage:[UIImage imageTztNamed:@"TZTButton.png"]];
        [_pBtnYuJing setTztTitle:@"预警"];
        [_pBtnYuJing setTztTitleColor:[UIColor whiteColor]];
        _pBtnYuJing.showsTouchWhenHighlighted = YES;
        _pBtnYuJing.hidden = YES;
        [_pBtnYuJing addTarget:self action:@selector(OnYuJing) forControlEvents:UIControlEventTouchUpInside];
        [m_pTitleView addSubview:_pBtnYuJing];
        [_ayBtn addObject:_pBtnYuJing];
        
        [self setButtonFrame:rcBtn];
        [self addSubview:self.m_pTitleView];
    }
    else
    {
        self.m_pTitleView.frame = rcFrame;
        CGRect rcBtn = rcFrame;
        rcBtn.origin.x += 185+24 + 5;
        rcBtn.size.width -= (185+24 + 5);
        [self setButtonFrame:rcBtn];
    }
}

-(void)setButtonFrame:(CGRect)rcFrame
{
    if (_ayBtn == NULL || [_ayBtn count] < 1)
        return;
    
    int nBtnWidth = 55;
    int nMargin = 2;
    CGRect rcBtn = rcFrame;
    rcBtn.size.width = nBtnWidth;
    rcBtn.origin.y += 4;
    rcBtn.size.height -= 8;
    rcBtn.origin.x = rcFrame.origin.x + rcFrame.size.width - nBtnWidth - nMargin;
    for (NSInteger i = [_ayBtn count] - 1; i >= 0; i--)
    {
        UIButton *pBtn = [_ayBtn objectAtIndex:i];
        if (!pBtn.hidden) 
        {
            pBtn.frame = rcBtn;
            rcBtn.origin.x -= (nBtnWidth + nMargin);
        }
    }
}

-(void)SetStockCode:(tztStockInfo*)pStock
{
    self.pStockInfo = pStock;
    if (pStock == NULL || pStock.stockCode == NULL || [pStock.stockCode length] <= 0)
        return;
    
    NSString* nsTemp = [NSString stringWithFormat:@"%@", pStock.stockName];
    if (nsTemp && [nsTemp length] > 0)
    {
        NSArray *pAy = [nsTemp componentsSeparatedByString:@"."];
        if (pAy && [pAy count] > 1)
            nsTemp = [pAy objectAtIndex:1];
    }
    self.nsStockCode = [NSString stringWithFormat:@"%@", pStock.stockCode];
    self.m_nsStockName = nsTemp;
    
    [tztUserStock AddRecentStock:pStock];//最近浏览添加股票
    
    if (self.m_pTitleView)
    {
        //左侧增加代码，名称，增删自选股
        NSString *nsTxt = [NSString stringWithFormat:@" %@ %@",self.m_nsStockName, self.nsStockCode];
        UILabel *pLabel = (UILabel*)[m_pTitleView viewWithTag:0x1024];
        UIButton *pBtn = (UIButton*)[m_pTitleView viewWithTag:0x1025];
        pLabel.text = nsTxt;
        //
        int iIndex = [tztUserStock IndexUserStock:pStock];
        if (iIndex >= 0)//已经存在，显示删除按钮
        {
            [pBtn setTztBackgroundImage:[UIImage imageTztNamed:@"TZTNavDelStock.png"]];
        }
        else
        {
            [pBtn setTztBackgroundImage:[UIImage imageTztNamed:@"TZTNavAddStock.png"]];
        }
        
        //判断显示按钮
        if (MakeStockMarket(pStock.stockType) && !MakeIndexMarket(pStock.stockType))//个股才显示预警，
        {
            [_ayBtn removeAllObjects];
            _pBtnYuJing.hidden = NO;
            [_ayBtn addObject:_pBtnYuJing];
            _pBtnF9.hidden = NO;
            [_ayBtn addObject:_pBtnF9];
            _pBtnF10.hidden = NO;
            [_ayBtn addObject:_pBtnF10];
            _pBtnBuy.hidden = NO;
            [_ayBtn addObject:_pBtnBuy];
            _pBtnSell.hidden = NO;
            [_ayBtn addObject:_pBtnSell];
            _pBtnKLine.hidden = NO;
            [_ayBtn addObject:_pBtnKLine];
            [self setFrame:self.frame];
        }
        else if(MakeHKMarket(pStock.stockType))
        {
            [_ayBtn removeAllObjects];
            _pBtnYuJing.hidden = NO;
            [_ayBtn addObject:_pBtnYuJing];
            _pBtnF9.hidden = NO;
            [_ayBtn addObject:_pBtnF9];
            _pBtnF10.hidden = YES;
            _pBtnBuy.hidden = NO;
            [_ayBtn addObject:_pBtnBuy];
            _pBtnSell.hidden = NO;
            [_ayBtn addObject:_pBtnSell];
            _pBtnKLine.hidden = NO;
            [_ayBtn addObject:_pBtnKLine];
            [self setFrame:self.frame];
        }
        else
        {
            [_ayBtn removeAllObjects];
            _pBtnYuJing.hidden = YES;
            _pBtnF9.hidden = YES;
            _pBtnF10.hidden = YES;
            _pBtnBuy.hidden = NO;
            [_ayBtn addObject:_pBtnBuy];
            _pBtnSell.hidden = NO;
            [_ayBtn addObject:_pBtnSell];
            _pBtnKLine.hidden = NO;
            [_ayBtn addObject:_pBtnKLine];
            [self setFrame:self.frame];
        }
    }
    if (self.m_pTrendView && !self.m_pTrendView.hidden)
    {
        [self.m_pTrendView setStockInfo:pStock Request:1];
    }
    if (self.m_pTechView && !self.m_pTechView.hidden)
    {
        [self.m_pTechView setStockInfo:pStock Request:1];
    }
    if (self.m_pRightView)
    {
        [self.m_pRightView setStockInfo:pStock Request:0];
    }
    if (self.m_pDetailView && !self.m_pDetailView.hidden)
    {
        [self.m_pDetailView setStockInfo:pStock Request:1];
    }
    if (self.pFinanceView && !self.pFinanceView.hidden)
    {
        [self.pFinanceView setStockInfo:pStock Request:1];
    }
    if (self.m_pBottomView)
    {
        [self.m_pBottomView SetStock:pStock];
    }
}

#pragma 分时数据收到返回，调用更新数据
-(void)UpdateData:(id)obj
{
    if(obj)
    {
        TNewPriceData *pData = nil;
        if ([obj isKindOfClass:[tztTrendView class]])
        {
            if (!((tztTrendView*)obj).hidden)
            {
                pData = [(tztTrendView*)obj GetNewPriceData];
            }
        }
        else if([obj isKindOfClass:[tztTechView class]])
        {
            if (!((tztTechView*)obj).hidden)
            {
                pData = [(tztTechView*)obj GetNewPriceData];
            }
        }
        
        if (pData)
        {
            if (self.m_pRightView)
            {
                [self.m_pRightView setPriceData:pData len:sizeof(TNewPriceData)];
                [self.m_pRightView setNeedsDisplay];
            }
            if (self.m_pTitleView)
            {   
//                self.m_pTitleView.StockCode = self.nsStockCode;
////                self.m_pTitleView.StockName = self.m_nsStockName;
//                [self.m_pTitleView setPriceData:pData len:sizeof(TNewPriceData)];
//                [self.m_pTitleView UpdateLabelData];
            }
        }
        
    }
}

-(void)ChangeHQView:(id)sender
{
    if (self.m_pTrendView == NULL || self.m_pTechView == NULL)
        return;
    
    if (self.m_pTechView && self.m_pTechView.hidden)
    {
        self.m_pTechView.hidden = NO;
        self.m_pTrendView.hidden = YES;
        [self.m_pTechView setStockInfo:self.pStockInfo Request:1];
    }
    else
    {
        self.m_pTechView.hidden = YES;
        self.m_pTrendView.hidden = NO;
        [self.m_pTrendView setStockInfo:self.pStockInfo Request:1];
    }
}

-(void)segmentAction:(id)sender
{
    UISegmentedControl *pSeg = (UISegmentedControl*)sender;
    if (![pSeg isKindOfClass:[UISegmentedControl class]]) 
        return;
    
    NSInteger nSelect = pSeg.selectedSegmentIndex;
    switch (nSelect)
    {
        case 0://选中报价，隐藏明细和财务
        {
            self.m_pRightView.hidden = NO;
            self.m_pDetailView.hidden = YES;
            self.pFinanceView.hidden = YES;
            //请求报价数据
            [self.m_pRightView setStockInfo:self.pStockInfo Request:1];
        }
            break;
        case 1:
        {
            self.m_pRightView.hidden = YES;
            self.m_pDetailView.hidden = NO;
            self.pFinanceView.hidden = YES;
            [self.m_pDetailView setStockInfo:self.pStockInfo Request:1];
        }
            break;
        case 2:
        {
            self.m_pRightView.hidden = YES;
            self.m_pDetailView.hidden = YES;
            self.pFinanceView.hidden = NO;
            [self.pFinanceView setStockInfo:self.pStockInfo Request:1];
        }
            break;
        default:
            break;
    }
}

-(void)SetInfoItem:(id)delegate pItem_:(tztInfoItem *)pItem
{
    if (delegate == self.m_pBottomView && pItem)
    {
        //弹出资讯内容显示
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Content wParam:(NSUInteger)pItem lParam:(NSUInteger)self.m_pBottomView];
    }
}

-(void)OnDelOrAddUserStock
{
    tztStockInfo *pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", self.nsStockCode];
    pStock.stockName = [NSString stringWithFormat:@"%@", self.m_nsStockName];
    UIButton *pBtn = (UIButton*)[m_pTitleView viewWithTag:0x1025];
    if ([tztUserStock IndexUserStock:pStock] >= 0)
    {
        [tztUserStock DelUserStock:pStock];
        [pBtn setTztBackgroundImage:[UIImage imageTztNamed:@"TZTNavAddStock.png"]];
    }
    else
    {
        [tztUserStock AddUserStock:pStock];
        [pBtn setTztBackgroundImage:[UIImage imageTztNamed:@"TZTNavDelStock.png"]];
    }
    DelObject(pStock);
}

-(void)OnKLine
{
    if (self.m_pTrendView == NULL || self.m_pTechView == NULL)
        return;
 
    if (self.m_pTechView && self.m_pTechView.hidden)
    {
        self.m_pTechView.hidden = NO;
        self.m_pTrendView.hidden = YES;
        [self.m_pTechView setStockInfo:self.pStockInfo Request:1];
        [_pBtnKLine setTztTitle:@"分时"];
    }
    else
    {
        [_pBtnKLine setTztTitle:@"K线"];
        self.m_pTechView.hidden = YES;
        self.m_pTrendView.hidden = NO;
        [self.m_pTrendView setStockInfo:self.pStockInfo Request:1];
    }
}

-(void)OnSell
{
    tztStockInfo * pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", self.nsStockCode];
    [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_Sell wParam:(NSUInteger)pStock lParam:0];
    DelObject(pStock);
    
}

-(void)OnBuy
{
    tztStockInfo * pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", self.nsStockCode];
    [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_Buy wParam:(NSUInteger)pStock lParam:0];
    DelObject(pStock);
}

-(void)OnF10
{
    tztStockInfo *pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", self.nsStockCode];
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_F10 wParam:(NSUInteger)pStock lParam:0];
    DelObject(pStock);
}

-(void)OnF9
{
    tztStockInfo *pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", self.nsStockCode];
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_F9 wParam:(NSUInteger)pStock lParam:0];
    DelObject(pStock);
}

//预警设置
-(void)OnYuJing
{
    tztStockInfo *pStock = NewObject(tztStockInfo);
    pStock.stockCode = [NSString stringWithFormat:@"%@", self.nsStockCode];
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_YUJING wParam:(NSUInteger)pStock lParam:0];
    DelObject(pStock);
}

#pragma 分时和资金流向通过此处进行同步光标操作
-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo*)pStock
{
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
    {
        [_pDelegate tzthqView:hqView setStockCode:pStock];
    }
}
//zxl  20131012 添加历史分时
-(void)tzthqView:(id)hqView RequestHisTrend:(tztStockInfo *)pStock nsHisDate:(NSString *)nsHisDate
{
    if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(tzthqView:RequestHisTrend:nsHisDate:)])
    {
        [self.pDelegate tzthqView:hqView RequestHisTrend:pStock nsHisDate:nsHisDate];
    }
}

-(void)tzthqView:(id)hqView MaxCount:(int)maxcount LeftWidth:(int)width
{
    self.m_pBottomView.nMaxCount = maxcount;
    self.m_pBottomView.fLeftWidth = width;
}
-(void)MoveFenshiCurLine:(CGPoint)point
{
//    self.m_pTrendView.TrendCursor = CGPointMake(point.x, self.m_pTrendView.TrendCursor.y);
    [self.m_pTrendView setNeedsDisplay];
}
-(void)MoveZJLXCurLine:(CGPoint)point
{
    self.m_pBottomView.pFundFlowsView.pCurPoint = CGPointMake(point.x, self.m_pBottomView.pFundFlowsView.pCurPoint.y);
    [self.m_pBottomView.pFundFlowsView setNeedsDisplay];
}
-(void)ShowFenshiCurLine:(BOOL)show Point:(CGPoint)point
{
//    self.m_pTrendView.TrendDrawCursor = show;
    [self MoveFenshiCurLine:point];
}
-(void)ShowZJLXCurLine:(BOOL)show Point:(CGPoint)point
{
    self.m_pBottomView.pFundFlowsView.bCursorLine = show;
    [self MoveZJLXCurLine:point];
}
@end
