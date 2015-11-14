//
//  tztStockReportView.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-9-26.
//
//

#import "tztStockReportView.h"
#import "tztUINewMarketView.h"

#import "TZTHSStockTableView.h"
#import "tztMarketMoreView.h"
#import "TZTFundFlowTableView.h"
#import "TZTBlockTableView.h"
#import "TZTUserStockTableView.h"

@interface tztStockReportView()<tztHqBaseViewDelegate,tztUIMarketDelegate>
{
    
}

@property(nonatomic, retain)tztUIFunctionView   *btnView;
@property(nonatomic, retain)NSString            *nsReqAction;
@property(nonatomic, retain)NSString            *nsReqParam;
@property(nonatomic, retain)NSString            *nsMenuID;
@property(nonatomic, retain)NSMutableDictionary *pMenuDict;
@property(nonatomic, retain)NSString            *nsOrdered;

@property(nonatomic, retain)UIView              *pCurrentView;

/**
 *	@brief	沪深
 */
@property(nonatomic,retain) TZTHSStockTableView     *hsTableView;
/**
 *	@brief	港股
 */
@property(nonatomic,retain) TZTHSStockTableView     *hkTableView;
/**
 *	@brief	美股
 */
@property(nonatomic,retain) TZTHSStockTableView     *usTableView;
 /**
 *	@brief	板块
 */
@property(nonatomic,retain) TZTHSStockTableView       *blockTableView;
 /**
 *	@brief	流向
 */
@property(nonatomic,retain) TZTHSStockTableView    *flowTableView;

/**
 *	@brief	环球
 */
@property(nonatomic,retain) tztMarketMoreView     *qqTableView;

@property(nonatomic,retain) NSMutableArray        *ayReportViews;
@end

@implementation tztStockReportView
@synthesize nsReqAction = _nsReqAction;
@synthesize nsReqParam = _nsReqParam;
@synthesize nsMenuID = _nsMenuID;
@synthesize pMenuDict = _pMenuDict;
@synthesize nsOrdered = _nsOrdered;
@synthesize btnView = _btnView;
@synthesize hsTableView   = _hsTableView;
@synthesize hkTableView   = _hkTableView;
@synthesize usTableView   = _usTableView;
@synthesize qqTableView   = _qqTableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initData];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

-(void)initData
{
    if (_ayReportViews == NULL)
        _ayReportViews = NewObject(NSMutableArray);
}

-(void)dealloc
{
    DelObject(_ayReportViews);
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (_btnView == NULL)
        return;
    for (tztUISwitch *obj in _btnView.ayBtnData)
    {
        UIImage *image = [UIImage tztCreateImageWithColor:[UIColor tztThemeBackgroundColorSectionSel]];
        obj.yesImage = image;//[UIImage imageTztNamed:image];
        
        image = [UIImage tztCreateImageWithColor:[UIColor tztThemeBackgroundColorSection]];
        obj.noImage = image;//[UIImage imageTztNamed:image];
        if (g_nSkinType == 0)
        {
            obj.pUnCheckedColor = [UIColor colorWithRGBULong:0x7b7b7b];
            obj.pNormalColor = [UIColor colorWithRGBULong:0xe8e8e8];
        }
        else
        {
            obj.pUnCheckedColor = [UIColor colorWithTztRGBStr:@"43,43,43"];
            obj.pNormalColor = [UIColor colorWithTztRGBStr:@"17,17,17"];
        }
    }
    _btnView.frame = _btnView.frame;
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    if (!bRequest)
    {
        for (UIView *view in self.ayReportViews)
        {
            [view tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
        }
    }
    else
    {
        for (UIView *view in self.ayReportViews)
        {
            if (view.hidden)
                [view tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
            else
                [view tztperformSelector:@"onSetViewRequest:" withObject:(id)YES];
        }
    }
}

-(void)OnRequestData
{
    for (UIView *view in self.ayReportViews)
    {
        if (view.hidden)
            [view tztperformSelector:@"setStockCode:Request:" withObject:@"1" withObject:(id)NO];
        else
            [view tztperformSelector:@"setStockCode:Request:" withObject:@"1" withObject:(id)YES];
    }
}


-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    CGRect rcBtnView = rcFrame;
    rcBtnView.origin = CGPointZero;
    rcBtnView.size.height = 35;
    if (_btnView == nil)
    {
        _btnView = [[tztUIFunctionView alloc] init];
        _btnView.bNeedSepLine = NO;
        _btnView.frame = rcBtnView;
        _btnView.backgroundColor = [UIColor tztThemeBackgroundColorTagView];
        [self addSubview:_btnView];
        [_btnView release];
    }
    [self GetToolButtons:rcBtnView];
    
    CGRect rect = rcFrame;
    rect.origin.y += (rcBtnView.origin.y + rcBtnView.size.height);
    rect.size.height -= (rcBtnView.origin.y + rcBtnView.size.height);
    
    NSMutableDictionary *dict = GetDictByListName(@"tztQuoteTagSetting");
    NSMutableArray *ayData = [dict objectForKey:@"quotesettings"];
    
    for (NSInteger i = 0; i < ayData.count; i++)
    {
        NSString* str = [ayData objectAtIndex:i];
        NSArray *ay = [str componentsSeparatedByString:@"|"];
        if (ay.count < 3)
            continue;
        int nTag = [[ay objectAtIndex:1] intValue];
        NSString* strClass = [ay objectAtIndex:2];
        if (strClass.length <= 0)
            continue;
        
        UIView *pView = [self viewWithTag:nTag + 0x7777];
        if (pView == nil)
        {
            pView = [[NSClassFromString(strClass) alloc] init];
            pView.tag = nTag + 0x7777;
            ((TZTHSStockTableView*)pView).frame = rect;
            [self addSubview:pView];
            [_ayReportViews addObject:pView];
            
            if (i == 0)
            {
                [pView tztperformSelector:@"OnSetViewRequest:" withObject:(id)YES];
                [pView tztperformSelector:@"setStockCode:Request:" withObject:[tztUserStock GetNSUserStock] withObject:(id)YES];
            }
            
            pView.hidden = (i != 0);
            if ([pView isKindOfClass:[TZTHSStockTableView class]])
            {
                ((TZTHSStockTableView*)pView).ntztMarket = nTag;
            }
            if ([pView isKindOfClass:[TZTUserStockTableView class]])
            {
                ((TZTUserStockTableView*)pView).nShowInQuote = 1;
            }
            [pView release];
            
        }
        else
        {
            pView.frame = rect;
        }
    }
    
    for (UIView *view in self.ayReportViews)
    {
        if (!view.hidden)
            [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:view.tag-0x7777]];
    }
}


-(void)GetToolButtons:(CGRect)rcFrame
{
    //需要读取配置来进行处理
    
    NSMutableArray *ayBtn = NewObjectAutoD(NSMutableArray);
    
    NSMutableDictionary *dict = GetDictByListName(@"tztQuoteTagSetting");
    NSMutableArray *ayData = [dict objectForKey:@"quotesettings"];
    tztUISwitch *pBtnMore = nil;
    for (NSString* str in ayData)
    {
        if (str.length <= 0)
            continue;
        NSArray *ay = [str componentsSeparatedByString:@"|"];
        if (ay.count < 2)
            continue;
        NSString* strName = [ay objectAtIndex:0];
        NSString* strTag = [ay objectAtIndex:1];
        
        if ([strTag intValue] == MENU_HQ_HQMore)//更多，认为是固定
        {
            pBtnMore = [self CreateSwitchButton:[strTag intValue]
                                     yesTitle_:@""
                                     yesImage_:@""
                                      noTitle_:@""
                                      noImage_:@""];
            
            _btnView.nFixBtnWidth = 31;
            _btnView.bNeedSepLine = TRUE;
            pBtnMore.tztdelegate = _btnView;
        }
        else
        {
            tztUISwitch *pBtn = [self CreateSwitchButton:[strTag intValue]
                                               yesTitle_:strName
                                               yesImage_:@""
                                                noTitle_:strName
                                                noImage_:@""];
            [ayBtn addObject:pBtn];
        }

    }
    
    _btnView.bNeedSepLine = NO;
    if (ayBtn != NULL)
        _btnView.ayBtnData = ayBtn;
    _btnView.fixBtn = pBtnMore;
    _btnView.nFixBtnWidth = 28;
    _btnView.nArrowWidth = 8;
    _btnView.frame = rcFrame;
}

-(tztUISwitch *)CreateSwitchButton:(int)nTag
                         yesTitle_:(NSString*)yesTitle
                         yesImage_:(NSString*)yesImage
                          noTitle_:(NSString*)noTitle
                          noImage_:(NSString*)noImage
{
    tztUISwitch *pSwitch = [[tztUISwitch alloc] init];
    pSwitch.tag = nTag;
    pSwitch.yestitle = yesTitle;
    pSwitch.notitle = noTitle;
//    pSwitch.bUnderLine = TRUE;
    pSwitch.fontSize = 15.0f;
    
    if (yesImage == nil || yesImage.length <= 0)
    {
        UIImage *image = [UIImage tztCreateImageWithColor:[UIColor tztThemeBackgroundColorSectionSel]];
        pSwitch.yesImage = image;//[UIImage imageTztNamed:image];
    }
    else
    {
        pSwitch.yesImage = [UIImage imageTztNamed:yesImage];
    }
    
    if (noImage == nil || noImage.length <= 0)
    {
        UIImage *image = [UIImage tztCreateImageWithColor:[UIColor tztThemeBackgroundColorSection]];
        pSwitch.noImage = image;
    }
    else
        pSwitch.noImage = [UIImage imageTztNamed:noImage];
    
    if (g_nSkinType == 0)
    {
        pSwitch.pUnCheckedColor = [UIColor colorWithRGBULong:0x7b7b7b];
        pSwitch.pNormalColor = [UIColor colorWithRGBULong:0xe8e8e8];
    }
    else
    {
        pSwitch.pUnCheckedColor = [UIColor colorWithTztRGBStr:@"43,43,43"];
        pSwitch.pNormalColor = [UIColor colorWithTztRGBStr:@"17,17,17"];
    }
    [pSwitch addTarget:self
                action:@selector(OnUFunctionBtnClick:)
      forControlEvents:UIControlEventTouchUpInside];
    return [pSwitch autorelease];
}

-(void)showWithAnimation:(UIView*)pShowView nDirection_:(int)nDirection
{
    if (self.pCurrentView == NULL || self.pCurrentView == pShowView)
    {
        for (UIView *pView in self.ayReportViews)
        {
            pView.hidden = (pView != self.pCurrentView);
        }
        self.pCurrentView = pShowView;
        self.pCurrentView.hidden = NO;
        return;
    }
    nDirection = [self GetPositionForCurrentView:pShowView];
    CGRect rc = pShowView.frame;
    CGRect rcEx = rc;
    if (nDirection == 0)
        rcEx.origin.x -=  rcEx.size.width;
    else if(nDirection == 1)
        rcEx.origin.x += rcEx.size.width;
    else
    {
        self.pCurrentView.hidden = NO;
        
        if ([pShowView respondsToSelector:@selector(onSetViewRequest:)])
        {
            [pShowView tztperformSelector:@"onSetViewRequest:" withObject:(id)YES];
        }
        if ([self.pCurrentView respondsToSelector:@selector(onSetViewRequest:)])
        {
            [pShowView tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
        }
        return;
    }
    
    pShowView.frame = rcEx;
    
    CGRect rc1 = self.pCurrentView.frame;
    CGRect rc1Ex = rc1;
    if (nDirection == 0)
        rc1.origin.x += rc1.size.width;
    else
        rc1.origin.x -= rc1.size.width;
    pShowView.hidden = NO;
    
    if ([self.pCurrentView respondsToSelector:@selector(onSetViewRequest:)])
    {
        [self.pCurrentView tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
    }
    
    [UIView animateWithDuration:0.05f
                     animations:^{
                         pShowView.frame = rc;
                         self.pCurrentView.frame = rc1;
                     }
                     completion:^(BOOL bFinished){
                         self.pCurrentView.frame = rc1Ex;
                         self.pCurrentView.hidden = YES;
                         self.pCurrentView = pShowView;
                         if ([pShowView respondsToSelector:@selector(onSetViewRequest:)])
                         {
                             [pShowView tztperformSelector:@"onSetViewRequest:" withObject:(id)YES];
                         }
                         if ([pShowView respondsToSelector:@selector(setStockCode:Request:)])
                         {
                             [pShowView tztperformSelector:@"setStockCode:Request:" withObject:[tztUserStock GetNSUserStock] withObject:(id)YES];
                         }
                     }];
}

-(void)OnUFunctionBtnClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (_btnView)
    {
        [_btnView setBtnState:sender];
    }
    
    [self setViewStates];
    self.pCurrentView.hidden = NO;
    for (UIView *view in self.ayReportViews)
    {
        if (view.tag - 0x7777 == pBtn.tag)
        {
            [self showWithAnimation:view nDirection_:1];
            break;
        }
    }
}
-(void)setViewStates
{
    for (UIView *pView in self.ayReportViews)
    {
        pView.hidden = (pView != self.hsTableView);
    }
}

/**
 *	@brief	获取要显示的view相对于当前显示的view是在左侧还是右侧
 *
 *	@param 	pShowView 	要显示的view
 *
 *	@return	0-左侧 1-右侧
 */
-(int)GetPositionForCurrentView:(UIView*)pShowView
{
    NSUInteger nIndex = [self.ayReportViews indexOfObject:self.pCurrentView];
    NSUInteger nIndex1 = [self.ayReportViews indexOfObject:pShowView];
    
    if (nIndex > nIndex1)
        return 0;
    else if (nIndex < nIndex1)
        return 1;
    else
        return -1;
}


@end
