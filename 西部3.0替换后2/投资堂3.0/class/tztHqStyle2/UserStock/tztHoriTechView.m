//
//  tztHoriTechView.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-7-18.
//
//

#import "tztHoriTechView.h"
#define tztScrollViewWidth  50

@interface tztHoriTechView()<tztHqBaseViewDelegate>

@property(nonatomic,retain)tztTechView  *pTechView;
@property(nonatomic,retain)tztUISwitch  *pSwitchCQ;
@property(nonatomic,retain)UIScrollView *pScrollView;
@property(nonatomic,retain)NSMutableArray *pAyBtnData;
@property(nonatomic,retain)NSMutableArray *pAyObjData;

@end

@implementation tztHoriTechView
@synthesize pSwitchCQ = _pSwitchCQ;
@synthesize pTechView = _pTechView;
@synthesize pScrollView = _pScrollView;
@synthesize pAyBtnData = _pAyBtnData;
@synthesize pAyObjData = _pAyObjData;
@synthesize KLineCycleStyle = _KLineCycleStyle;//周期类型


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    if (_pAyBtnData == NULL)
        _pAyBtnData = NewObject(NSMutableArray);
    [_pAyBtnData removeAllObjects];
    
    if (_pAyObjData == NULL)
        _pAyObjData = NewObject(NSMutableArray);
    [_pAyObjData removeAllObjects];
    /*VOL，MACD，RSI，KDJ，BOLL，BIAS，CCI，DMI，WR*/
    [_pAyObjData addObject:[NSNumber numberWithInt:VOL]];
    [_pAyObjData addObject:[NSNumber numberWithInt:MACD]];
    [_pAyObjData addObject:[NSNumber numberWithInt:RSI]];
    [_pAyObjData addObject:[NSNumber numberWithInt:KDJ]];
    [_pAyObjData addObject:[NSNumber numberWithInt:BOLL]];
    [_pAyObjData addObject:[NSNumber numberWithInt:BIAS]];
    [_pAyObjData addObject:[NSNumber numberWithInt:CCI]];
    [_pAyObjData addObject:[NSNumber numberWithInt:DMI]];
    [_pAyObjData addObject:[NSNumber numberWithInt:WR]];
    [_pAyObjData addObject:[NSNumber numberWithInt:DMA]];
    [_pAyObjData addObject:[NSNumber numberWithInt:TRIX]];
    [_pAyObjData addObject:[NSNumber numberWithInt:BRAR]];
    [_pAyObjData addObject:[NSNumber numberWithInt:VR]];
    [_pAyObjData addObject:[NSNumber numberWithInt:OBV]];
    [_pAyObjData addObject:[NSNumber numberWithInt:ASI]];
    [_pAyObjData addObject:[NSNumber numberWithInt:EMV]];
    [_pAyObjData addObject:[NSNumber numberWithInt:WVAD]];
    [_pAyObjData addObject:[NSNumber numberWithInt:ROC]];
}

-(void)dealloc
{
    if (self.pAyBtnData)
        [self.pAyBtnData removeAllObjects];
    if (self.pAyObjData)
        [self.pAyObjData removeAllObjects];
    DelObject(_pAyObjData);
    DelObject(_pAyBtnData);
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.size.width -= (tztScrollViewWidth+5);
    
#ifdef tzt_ZSSC
    rcFrame.size.width += (tztScrollViewWidth+5);
#endif
    
    if (_pTechView == NULL)
    {
        _pTechView = [[tztTechView alloc] initWithFrame:rcFrame];
        _pTechView.pStockInfo = self.pStockInfo;
        _pTechView.tztdelegate = self;
        _pTechView.bHiddenCycle = YES;
        _pTechView.bHiddenObj = YES;
        [_pTechView setHisBtnShow:NO];
        _pTechView.bTechMoved = YES;
        [_pTechView setTipsShow:NO];
        _pTechView.bIgnorTouch = YES;
#ifdef tzt_ZSSC
        _pTechView.bShowObj = YES;
        _pTechView.bShowChuQuan = YES;
#endif
        [self addSubview:_pTechView];
        [_pTechView release];
        
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(OnLongPress:)];
        longpress.minimumPressDuration = .7f;
        [_pTechView addGestureRecognizer:longpress];
        [longpress release];

#ifndef tzt_ZSSC
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnDoubleClick:)];
        doubleTap.numberOfTapsRequired = 2;
        [_pTechView addGestureRecognizer:doubleTap];
        [doubleTap release];
#endif
        
    }
    else
        _pTechView.frame = rcFrame;
    
#ifdef tzt_ZSSC
    return;
#endif
    
    CGRect rcView = rcFrame;
    rcView.origin.x += rcFrame.size.width + 5;
    rcView.size.height = 40;
    rcView.size.width = tztScrollViewWidth;
    UIImage *imageSel = [UIImage imageTztNamed:@"TZTTabButtonSelBg"];
    UIImage *image = [UIImage imageTztNamed:@"TZTTabButtonBg"];
    if (_pSwitchCQ == NULL)
    {
        _pSwitchCQ = [[tztUISwitch alloc] init];
        _pSwitchCQ.yesImage = imageSel;
        _pSwitchCQ.noImage = image;
        _pSwitchCQ.fontSize = 12.f;
        _pSwitchCQ.yestitle = [tztTechSetting getInstance].nKLineChuQuan ? @"复权":@"除权";
        _pSwitchCQ.notitle = [tztTechSetting getInstance].nKLineChuQuan ? @"除权":@"复权";
        _pSwitchCQ.tag = KLineChuQuan;
        [_pSwitchCQ setTztTitleColor:[UIColor tztThemeTextColorButtonSel]];
//        _pSwitchCQ.pNormalColor = [UIColor tztThemeTextColorButtonSel];
        _pSwitchCQ.showsTouchWhenHighlighted = YES;
        _pSwitchCQ.frame = rcView;
        [_pSwitchCQ addTarget:self
                       action:@selector(OnCQ:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pSwitchCQ];
        if ([tztTechSetting getInstance].nKLineChuQuan)
            [_pSwitchCQ setChecked:YES];
        else
            [_pSwitchCQ setChecked:NO];
        [_pSwitchCQ release];
    }
    else
    {
        _pSwitchCQ.frame = rcView;
    }
    
    _pSwitchCQ.layer.borderWidth = 0.5f;
    _pSwitchCQ.layer.borderColor = [UIColor tztThemeBorderColor].CGColor;
    
    CGRect rcScroll = rcFrame;
    rcScroll.origin.x += rcFrame.size.width + 5;
    rcScroll.origin.y = rcView.origin.y + rcView.size.height-1;
    rcScroll.size.width = tztScrollViewWidth;
    rcScroll.size.height -= (rcView.origin.y + rcView.size.height);
    if (_pScrollView == NULL)
    {
        _pScrollView = [[UIScrollView alloc] initWithFrame:rcScroll];
//        _pScrollView.backgroundColor = [UIColor redColor];
        [self addSubview:_pScrollView];
        [_pScrollView release];
        
        NSInteger nCount = [self.pAyObjData count];
        NSInteger nWidth = tztScrollViewWidth;
        NSInteger nHeight = 35;
        _pScrollView.contentSize = CGSizeMake(nWidth, nCount * nHeight);
        CGRect rcSwitch = _pScrollView.bounds;
        rcSwitch.size.height = nHeight;
        rcSwitch.size.width = nWidth;
        for (NSInteger i = 0; i < nCount; i++)
        {
            NSInteger n = [[self.pAyObjData objectAtIndex:i] intValue];
            tztUISwitch *pSwitch = [[tztUISwitch alloc] init];
            
            pSwitch.yesImage = imageSel;
            pSwitch.noImage = image;
            pSwitch.fontSize = 12.f;
            pSwitch.yestitle = getZhiBiaoName(n);
            pSwitch.notitle = getZhiBiaoName(n);
            pSwitch.tag = n;
            pSwitch.frame = rcSwitch;
//            pSwitch.pNormalColor = [UIColor tztThemeTextColorButtonSel];
            [pSwitch setTztTitleColor:[UIColor tztThemeTextColorButtonSel]];
            pSwitch.showsTouchWhenHighlighted = YES;
            [pSwitch addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_pScrollView addSubview:pSwitch];
            pSwitch.switched = NO;
            if (n == VOL)
                [pSwitch setChecked:YES];
            else
                [pSwitch setChecked:FALSE];
            [self.pAyBtnData addObject:pSwitch];
            [pSwitch release];
            rcSwitch.origin.y += nHeight;
        }
    }
    else
        _pScrollView.frame = rcScroll;
    _pScrollView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _pScrollView.layer.borderWidth = 0.5f;
    _pScrollView.layer.borderColor = [UIColor tztThemeBorderColor].CGColor;
    
}

-(void)OnCQ:(id)sender
{
    tztUISwitch *pSwitch = (tztUISwitch*)sender;
    if (pSwitch == NULL)
        return;
    
    NSInteger nTag = pSwitch.tag;
    if (_pTechView )
    {
        [_pTechView tztChangeCycle:(int)nTag picker_:nil];
    }
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
    
    [_pTechView tztChangeZhiBiao:nTag];
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    [super onSetViewRequest:bRequest];
    if (_pTechView)
        [_pTechView onSetViewRequest:bRequest];
}

-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    [super setStockInfo:pStockInfo Request:nRequest];
    if (_pTechView)
    {
        [_pTechView setStockInfo:pStockInfo Request:nRequest];
    }
}

-(void)setKLineCycleStyle:(tztKLineCycle)style
{
    _KLineCycleStyle = style;
    if (_pTechView)
        _pTechView.KLineCycleStyle = style;
}

-(void)UpdateData:(id)obj
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(UpdateData:)])
    {
        [_tztdelegate UpdateData:self];
    }
}

-(void)onRequestDataAutoPush
{
    if (_pTechView)
        [_pTechView onRequestData:FALSE];
}


//获取报价数据
- (TNewPriceData*)GetNewPriceData
{
    if (_pTechView)
        return [_pTechView GetNewPriceData];
    return NULL;
}

-(void)tztHqView:(id)hqView clickAction:(NSInteger)nClickTimes
{
#ifdef tzt_ZSSC
    return;
#endif
    if (nClickTimes >= 2)
    {
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztTimeTechTitleView:OnCloser:)])
        {
            [self.tztdelegate tztTimeTechTitleView:self OnCloser:NULL];
        }
    }
}

-(void)OnLongPress:(UILongPressGestureRecognizer*)reco
{
    CGPoint pt = [reco locationInView:_pTechView];
    
    UIGestureRecognizerState state = reco.state;
    if (state == UIGestureRecognizerStateEnded)
    {
        [_pTechView trendTouchMoved:pt bShowCursor_:NO];
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:ShowCursorTipsView:)])
        {
            [self.tztdelegate tztHqView:self ShowCursorTipsView:NO];
        }
    }
    else
    {
        [_pTechView trendTouchMoved:pt bShowCursor_:YES];
        if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:ShowCursorTipsView:)])
        {
            [self.tztdelegate tztHqView:self ShowCursorTipsView:YES];
        }
    }
}

-(void)tztHqView:(id)hqView SetCursorData:(id)pData
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztHqView:SetCursorData:)])
    {
        [self.tztdelegate tztHqView:hqView SetCursorData:pData];
    }
}


-(void)OnDoubleClick:(UITapGestureRecognizer*)reco
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztTimeTechTitleView:OnCloser:)])
    {
        [self.tztdelegate tztTimeTechTitleView:self OnCloser:NULL];
    }
}

@end
