//
//  tztUIStockView.m
//  tztMobileApp
//
//  Created by zz tzt on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "tztUIStockView.h"
#import "tztUITrendView_iphone.h"
#import "tztUITechView_iphone.h"
#import "tztUIStockInfoView.h"
#import "F10View.h"

#define tztScrollFrameHeight 20

@interface tztUIStockView()

@property(nonatomic,retain)tztUITrendView_iphone *pTrendView;
@property(nonatomic,retain)tztUITechView_iphone  *pTechView;
@property(nonatomic,retain)F10View    *pInfoView;
@property(nonatomic,retain)tztUIStockInfoView    *pInfoViewCW;
@end

@implementation tztUIStockView
@synthesize pBaseView = _pBaseView;
@synthesize pAyViews = _pAyViews;
@synthesize pMutilViews = _pMutilViews;
@synthesize pScrollIndex = _pScrollIndex;
@synthesize hasNoAddBtn = _hasNoAddBtn;
@synthesize pTrendView = _pTrendView;
@synthesize pTechView = _pTechView;
@synthesize pInfoView = _pInfoView;
@synthesize pInfoViewCW =_pInfoViewCW;

-(void)initdata
{
    if(_pAyViews == nil)
        _pAyViews = NewObject(NSMutableArray);
    
    if (_pMutilViews == NULL)
    {
        _pMutilViews = [[tztMutilScrollView alloc] init];
        _pMutilViews.bUseSysPageControl = NO;
        _pMutilViews.bSupportLoop = YES;
        _pMutilViews.tztdelegate = self;
        [self addSubview:_pMutilViews];
        [_pMutilViews release];
    }
}

-(id)init
{
    if (self = [super init])
    {
        _nCurrentIndex = 0;
        [self initdata];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _nCurrentIndex = 0;
        [self initdata];
    }
    return self;
}

-(void)dealloc
{
    if(_pAyViews)
        [_pAyViews removeAllObjects];
    DelObject(_pAyViews);
    DelObject(_pTrendView);
    DelObject(_pTechView);
    DelObject(_pInfoView);
    DelObject(_pInfoViewCW);
    [super dealloc];
}

//设置是否定时刷新
- (void)onSetViewRequest:(BOOL)bRequest
{
    for (int i = 0; i < [_pAyViews count]; i++)
    {
        UIView* pView = [_pAyViews objectAtIndex:i];
        if (_nCurrentIndex == i)//当前显示的开启定时请求
        {
            if (pView && [pView respondsToSelector:@selector(onSetViewRequest:)]) 
            {
                [(tztHqBaseView*)pView onSetViewRequest:bRequest];
            }   
        }
        else
        {//其余的不开启定时请求
            if (pView && [pView respondsToSelector:@selector(onSetViewRequest:)]) 
            {
                [(tztHqBaseView*)pView onSetViewRequest:NO];
            }   
        }
    }
    
    if (_pScrollIndex)
        [_pScrollIndex onSetViewRequest:bRequest];
}

//-(void)setHidden:(BOOL)hidden
//{
//    for (int i = 0; i < [_pAyViews count]; i++)
//    {
//        UIView *pView = [_pAyViews objectAtIndex:i];
//        if (pView && [pView respondsToSelector:@selector(setHidden:)])
//        {
//            [pView setHidden:hidden];
//        }
//    }
//}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    CGRect rcScroll = self.bounds;
    rcScroll.origin.y = rcScroll.size.height - tztScrollFrameHeight;
    rcScroll.size.height = tztScrollFrameHeight;
    if (_pScrollIndex == nil)
    {
        _pScrollIndex = [[tztScrollIndexView alloc] initWithFrame:rcScroll];
        [_pScrollIndex onSetViewRequest:YES];
        [_pScrollIndex onRequestData:YES];
        [self addSubview:_pScrollIndex];
        [_pScrollIndex release];
    }
    else
    {
        _pScrollIndex.frame = rcScroll;
    }
    
    if (_pTrendView == NULL)
    {
        self.pTrendView = [[tztUITrendView_iphone alloc] initWithFrame:self.bounds];
    }
    if (_pTechView == NULL)
    {
        self.pTechView =  [[tztUITechView_iphone alloc] initWithFrame:self.bounds];
    }
    if (_pInfoView == NULL)
    {
        self.pInfoView = [[F10View alloc] initWithFrame:self.bounds];
    }
    if (_pInfoViewCW == NULL) {
        self.pInfoViewCW = [[tztUIStockInfoView alloc] initWithFrame:self.bounds];
    }
    
    CGRect rcMultiView = self.bounds;
    rcMultiView.size.height -= tztScrollFrameHeight;
    self.pMutilViews.frame = rcMultiView;
//    if(_pMutilViews)
//        _pMutilViews.frame = self.bounds;
}

//当前是否K线
- (BOOL)isTechView
{
    if (_nCurrentIndex >= 0 && _nCurrentIndex < [_pAyViews count])
    {
        tztHqBaseView* pView = (tztHqBaseView*)[_pAyViews objectAtIndex:_nCurrentIndex];
        if (pView && [pView isKindOfClass:[tztUITechView_iphone class]])
        {
            return TRUE;
        }
    }
    return FALSE;
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    int nStockType = self.pStockInfo.stockType;
    self.pStockInfo = pStockInfo;
    
    if (nStockType == 0
        || (MakeHTFundMarket(nStockType) != MakeHTFundMarket(pStockInfo.stockType))
        /*|| (MakeIndexMarket(nStockType) != MakeIndexMarket(pStockInfo.stockType))*/)
    {
        [self CheckViewShowWithStockCode];
        CGRect rcFrame = self.bounds;
        rcFrame.size.height -= tztScrollFrameHeight;
        _pMutilViews.frame = rcFrame;
    }
    
    if (pStockInfo && pStockInfo.stockCode)
    {
        for (int i  = 0; i < [_pAyViews count]; i++)
        {
            UIView* pView = [_pAyViews objectAtIndex:i];
            BOOL bRequest = FALSE;
            if (_nCurrentIndex == i || (MakeHTFundMarket(self.pStockInfo.stockType)))
            {
                bRequest = TRUE;
            }
            
            if (pView && [pView respondsToSelector:@selector(setStockInfo:Request:)])
            {
                [(tztHqBaseView*)pView setStockInfo:pStockInfo Request:bRequest];
            }
        }
    }
    
    if (_pScrollIndex)
    {
        _pScrollIndex.nMarketType = self.pStockInfo.stockType;
        [_pScrollIndex onRequestData:YES];
    }
}

-(void)CheckViewShowWithStockCode
{
    [_pAyViews removeAllObjects];
    [_pMutilViews.pageControl removeAllObjects];
    NSString *str = @"";
    if (MakeHTFundMarket(self.pStockInfo.stockType))
    {
        //k线
        if (_pTechView == NULL)
        {
            self.pTechView = [[tztUITechView_iphone alloc] initWithFrame:self.bounds];
        }
//        tztUITechView_iphone *pTech = [[tztUITechView_iphone alloc] initWithFrame:self.bounds];
        self.pTechView.hasNoAddBtn = self.hasNoAddBtn;
        self.pTechView.tztdelegate = self;
        if (self.pTechView && [self.pTechView respondsToSelector:@selector(setStockInfo:Request:)])
        {
            [self.pTechView setStockInfo:self.pStockInfo Request:FALSE];
        }
        [_pAyViews addObject:self.pTechView];
        [_pMutilViews.pageControl setImage:[UIImage imageTztNamed:@"tztPage_Tech"] highlightedImage_:[UIImage imageTztNamed:@"tztPage_TechSel"] forKey:@"K"];
        str = @"K";
//        [self.pTechView release];
    }
    else
    {
        //分时
        if (_pTrendView == NULL)
        {
            self.pTrendView =  [[tztUITrendView_iphone alloc] initWithFrame:self.bounds];
        }
        self.pTrendView.hasNoAddBtn = self.hasNoAddBtn;
        self.pTrendView.tztdelegate = self;
        if (self.pTrendView && [self.pTrendView respondsToSelector:@selector(setStockInfo:Request:)])
        {
            [self.pTrendView setStockInfo:self.pStockInfo Request:FALSE];
        }
        [_pAyViews addObject:self.pTrendView];
        [_pMutilViews.pageControl setImage:[UIImage imageTztNamed:@"tztPage_Trend"] highlightedImage_:[UIImage imageTztNamed:@"tztPage_TrendSel"] forKey:@"F"];
        str = @"F";

        //k线
        if (_pTechView == NULL)
        {
            self.pTechView = [[tztUITechView_iphone alloc] initWithFrame:self.bounds];
        }
        self.pTechView.hasNoAddBtn = self.hasNoAddBtn;
        self.pTechView.tztdelegate = self;
        if (self.pTechView && [self.pTechView respondsToSelector:@selector(setStockInfo:Request:)])
        {
            [self.pTechView setStockInfo:self.pStockInfo Request:FALSE];
        }
        [_pAyViews addObject:self.pTechView];
        [_pMutilViews.pageControl setImage:[UIImage imageTztNamed:@"tztPage_Tech"] highlightedImage_:[UIImage imageTztNamed:@"tztPage_TechSel"] forKey:@"K"];
        str = [NSString stringWithFormat:@"%@K",str];
        //资讯
        if (_pInfoView == NULL)
        {
            self.pInfoView = [[F10View alloc] initWithFrame:self.bounds];
 
        }
        if (self.pInfoView && [self.pInfoView respondsToSelector:@selector(stockInfo:andUrl:)] ) {
 
            NSString* code = self.pStockInfo.stockCode;
            NSString* url =@"";
            if (code && code.length>0 ) {
                url= [NSString stringWithFormat:@"http://sjf10.westsecu.com/stock/%@/index.htm",code];
            }
            [self.pInfoView stockInfo:self.pStockInfo.stockType andUrl:url];
        }
 
        if (self.pInfoView != nil)
        {
            [_pAyViews addObject:self.pInfoView];
        }
        [_pMutilViews.pageControl setImage:[UIImage imageTztNamed:@"tztPage_F10"] highlightedImage_:[UIImage imageTztNamed:@"tztPage_F10Sel"] forKey:@"I"];
        str = [NSString stringWithFormat:@"%@I",str];
        
        //财务
        if (_pInfoViewCW == NULL) {
            self.pInfoViewCW = [[tztUIStockInfoView alloc] initWithFrame:self.bounds];
        }
        if (self.pInfoViewCW && [self.pInfoViewCW respondsToSelector:@selector(setStockInfo:Request:)]) {
            [self.pInfoViewCW setStockInfo:self.pStockInfo Request:FALSE];
        }
        if (self.pInfoViewCW != nil)
        {
            [_pAyViews addObject:self.pInfoViewCW];
        }
        [_pMutilViews.pageControl setImage:[UIImage imageTztNamed:@"tztPage_CaiWu"] highlightedImage_:[UIImage imageTztNamed:@"tztPage_CaiWuSel"] forKey:@"C"];
        str = [NSString stringWithFormat:@"%@C",str];
        
        
//        [pInfo release];
    }
    [_pMutilViews.pageControl setPattern:str];
    _pMutilViews.pageViews = _pAyViews;
    _pMutilViews.nCurPage = _nCurrentIndex;
}

-(void)tztMutilPageViewDidAppear:(NSInteger)CurrentViewIndex
{
    if (CurrentViewIndex < 0 || CurrentViewIndex >= [_pAyViews count])
        return;
    _nCurrentIndex = CurrentViewIndex;
    UIView* pView = [_pAyViews objectAtIndex:CurrentViewIndex];
    [self onSetViewRequest:YES];
    if (pView && [pView respondsToSelector:@selector(setStockInfo:Request:)])
    {
        if ([pView isKindOfClass:[tztUITechView_iphone class]])
        {
            NSString* nsName = @"";
            if (IS_TZTIphone5)
                nsName = @"tzt_TechHelper-568h@2x.png";
            else
                nsName = @"tzt_TechHelper@2x.png";
            [tztUIHelperImageView tztShowHelperView:nsName forClass_:[NSString stringWithUTF8String:object_getClassName(pView)]];
        }
        [(tztHqBaseView*)pView setStockInfo:self.pStockInfo Request:1];
    }
}

-(void)tztMutilPageViewDidDisappear:(NSInteger)CurrentViewIndex
{
    if (CurrentViewIndex < 0 || CurrentViewIndex >= [_pAyViews count])
        return;
    UIView* pView = [_pAyViews objectAtIndex:CurrentViewIndex];
    if (pView && [pView respondsToSelector:@selector(onSetViewRequest:)])
    {
        [(tztHqBaseView*)pView onSetViewRequest:NO];
    }
}

-(tztStockInfo*)GetCurrentStock
{
    if (_nCurrentIndex >= 0 && _nCurrentIndex < [_pAyViews count])
    {
        tztHqBaseView* pView = (tztHqBaseView*)[_pAyViews objectAtIndex:_nCurrentIndex];
        if (pView)
        {
            return [pView GetCurrentStock];
        }
    }
    return NULL;
}

-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo*)pStock
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
    {
        [_tztdelegate tzthqView:hqView setStockCode:pStock];
    }
}

-(void)tzthqView:(id)hqView RequestHisTrend:(tztStockInfo *)pStock nsHisDate:(NSString *)nsHisDate
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:RequestHisTrend:nsHisDate:)])
    {
        [_tztdelegate tzthqView:hqView RequestHisTrend:pStock nsHisDate:nsHisDate];
    }
}

-(void)tztQuickBuySell:(id)send nType_:(NSInteger)nType
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztQuickBuySell:nType_:)])
    {
        [_tztdelegate tztQuickBuySell:send nType_:nType];
    }
}
-(void)tztHqView:(id)hqView setTitleStatus:(NSInteger)nStatus andStockType_:(NSInteger)nStockType
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:setTitleStatus:andStockType_:)])
    {
        [_tztdelegate tztHqView:self setTitleStatus:nStatus andStockType_:nStockType];
    }
}
@end
