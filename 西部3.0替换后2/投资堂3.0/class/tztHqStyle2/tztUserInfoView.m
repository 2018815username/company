//
//  tztUserInfoViewController.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-9-24.
//
//

#import "tztUserInfoView.h"
#import "tztWebView.h"
#import "tztManagerUserStock.h"
#import "TZTUserStockTableView.h"
#import "tztTrendView_scroll.h"


@interface tztUserInfoView ()<tztHTTPWebViewDelegate, tztHqBaseViewDelegate>


@property(nonatomic,retain)tztUIFunctionView      *btnView;

@property(nonatomic,retain) TZTUserStockTableView   *pUserTable;

@property(nonatomic,retain) tztManagerUserStock     *pManagerUserStock;

@property(nonatomic, retain)tztWebView          *pWebViewNews;

@property(nonatomic, retain)tztWebView          *pWebViewDoctor;

@property(nonatomic, retain)tztTrendView_scroll *pTrendViewScroll;
/**
 *	@brief	当前显示的view
 */
@property(nonatomic,retain)UIView   *pCurrentView;
/**
 *	@brief	自选对应view数组
 */
@property(nonatomic, retain)NSMutableArray      *ayUserView;

@end

@implementation tztUserInfoView
@synthesize btnView = _btnView;
@synthesize pUserTable = _pUserTable;
@synthesize pWebViewNews = _pWebViewNews;
@synthesize pWebViewDoctor = _pWebViewDoctor;
@synthesize pManagerUserStock = _pManagerUserStock;
@synthesize pCurrentView = _pCurrentView;
@synthesize tztDelegate = _tztDelegate;
@synthesize pTrendViewScroll = _pTrendViewScroll;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    self.backgroundColor = [tztTechSetting getInstance].backgroundColor;
    
    if (_ayUserView == NULL)
        _ayUserView = NewObject(NSMutableArray);
    
    [self LoadLayoutView];
    
    
    if (!self.pManagerUserStock.hidden)
        [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 6]];
    else if (!self.pWebViewDoctor.hidden)
        [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 4]];
    else if (!self.pWebViewNews.hidden)
        [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 2]];
    else //if (!self.pUserTable.hidden)
        [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock]];
//    self.pWebViewNews.hidden = NO;
//    self.pWebViewDoctor.hidden = YES;
//    self.pManagerUserStock.hidden = YES;
}

-(void)setStockInfo:(tztStockInfo*)pStockInfo Request:(int)nRequest
{
    if (!nRequest)
        return;
    
    
    if (!self.pManagerUserStock.hidden)
        [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 6]];
    else if (!self.pWebViewDoctor.hidden)
        [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 4]];
    else if (!self.pWebViewNews.hidden)
        [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 2]];
    else //if (!self.pUserTable.hidden)
        [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock]];
    
//    int nID = MENU_HQ_UserStock;
//    if (!self.pWebViewNews.hidden)
//        nID = MENU_HQ_UserStock * 2 + 2;
//    else if (!self.pWebViewDoctor.hidden)
//        nID = MENU_HQ_UserStock * 2 + 4;
//    else if (!self.pManagerUserStock.hidden)
//        nID = MENU_HQ_UserStock * 2 + 6;
//    [self OnUFunctionBtnClickEx:[_btnView setBtnSelectWithFunctionID:nID]];
}


-(void)onSetViewRequest:(BOOL)bRequest
{
    if (self.pUserTable)
        [self.pUserTable onSetViewRequest:bRequest];
    if (self.pTrendViewScroll)
        [self.pTrendViewScroll onSetViewRequest:bRequest];
}

-(void)setStockCode:(NSString*)strStockCode Request:(int)nRequest
{
    if (self.pUserTable)
        [self.pUserTable setStockCode:strStockCode Request:nRequest];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = self.bounds;
    
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    
    CGRect rcTrend = rcFrame;
    CGRect rcTrendnew = rcFrame;
    
    BOOL isfirst = ![[NSUserDefaults standardUserDefaults] boolForKey:@"isnotfirst"];
    if (isfirst)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"trendscrollHidden"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isnotfirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    BOOL bHidden = [[NSUserDefaults standardUserDefaults] boolForKey:@"trendscrollHidden"];
    if (bHidden)
        rcTrendnew.origin.y -= 126;
    rcTrend.size.height = 170;
    rcTrendnew.size.height = 170;
    if (_pTrendViewScroll == NULL)
    {
        _pTrendViewScroll = [[tztTrendView_scroll alloc] init];
        _pTrendViewScroll.ishidden = bHidden;
        _pTrendViewScroll.frame = rcTrend;
        _pTrendViewScroll.nShowTop = 0;
        _pTrendViewScroll.hasHiddenBtn = TRUE;
        _pTrendViewScroll.tztDelegate = self;
        [self addSubview:_pTrendViewScroll];
        [_pTrendViewScroll RequestReportData];
        [_pTrendViewScroll release];
    }
    else
    {
        _pTrendViewScroll.ishidden = bHidden;
        _pTrendViewScroll.frame = rcTrend;
    }
    
    rcFrame.origin.y += (rcTrendnew.origin.y + rcTrendnew.size.height);
    rcFrame.size.height -= (rcTrendnew.origin.y + rcTrendnew.size.height);
    
    CGRect rcBtnView = rcFrame;
    rcBtnView.size.height = 35;
    if (_btnView == nil)
    {
        _btnView = [[tztUIFunctionView alloc] init];
        _btnView.fixBtn = nil;
        _btnView.bNeedSepLine = FALSE;
        _btnView.nFixBtnWidth = 0;
        _btnView.nArrowWidth = 0;
        _btnView.frame = rcBtnView;
        [self addSubview:_btnView];
        [_btnView release];
    }
    [self GetToolButtons:rcBtnView];
    
    
    CGRect rcList = rcFrame;
    rcList.origin = CGPointZero;
    rcList.origin.y += (rcBtnView.origin.y + rcBtnView.size.height);// rcMarket.origin.y + rcMarket.size.height;
    rcList.size.height = self.bounds.size.height - rcList.origin.y;//(rcMarket.origin.y + rcMarket.size.height);
    
    CGRect rect = rcList;
    
    if (_pUserTable == nil)
    {
        _pUserTable = [[TZTUserStockTableView alloc] init];
        _pUserTable.tztdelegate = self;
        _pUserTable.bAddSwipe = YES;
        _pUserTable.frame = rect;
        [_ayUserView addObject:_pUserTable];
        [self addSubview:_pUserTable];
        _pUserTable.hidden = NO;
        [_pUserTable release];
    }
    else
    {
        _pUserTable.frame = rect;
    }
    
    if (_pWebViewNews == nil)
    {
        _pWebViewNews = [[tztWebView alloc] init];
        _pWebViewNews.bAddSwipe = YES;
        _pWebViewNews.tztDelegate = self;
        _pWebViewNews.frame = rect;
        _pWebViewNews.hidden = YES;
        [_ayUserView addObject:_pWebViewNews];
        [self addSubview:_pWebViewNews];
        [_pWebViewNews release];
    }
    else
    {
        _pWebViewNews.frame = rect;
    }
    
    if (_pWebViewDoctor == nil)
    {
        _pWebViewDoctor = [[tztWebView alloc] init];
        _pWebViewDoctor.tztDelegate = self;
        _pWebViewDoctor.bAddSwipe = YES;
        _pWebViewDoctor.frame = rect;
        _pWebViewDoctor.hidden = YES;
        [_ayUserView addObject:_pWebViewDoctor];
        [self addSubview:_pWebViewDoctor];
        [_pWebViewDoctor release];
    }
    else
    {
        _pWebViewDoctor.frame = rect;
    }
    
    if (_pManagerUserStock == NULL)
    {
        _pManagerUserStock = [[tztManagerUserStock alloc] init];
        _pManagerUserStock.tztDelegate = self;
        _pManagerUserStock.frame = rect;
        _pManagerUserStock.hidden = YES;
        [_ayUserView addObject:_pManagerUserStock];
        [self addSubview:_pManagerUserStock];
        [_pManagerUserStock release];
    }
    else
    {
        _pManagerUserStock.frame = rect;
    }
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

-(void)tztTrendScroll:(id)send showOrHiddenWithRect:(CGRect)rect
{
    if (send != _pTrendViewScroll)
        return;
    
    CGRect rcFrame = _btnView.frame;
    if (_pTrendViewScroll.ishidden)//展开
    {
        //rect.origin.y += 112;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"trendscrollHidden"];
        _pTrendViewScroll.ishidden = FALSE;
        rcFrame.origin.y = rcFrame.origin.y +  126;
    }
    else//收缩
    {
        //rect.origin.y -= 112;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"trendscrollHidden"];
        _pTrendViewScroll.ishidden = TRUE;
        rcFrame.origin.y = rcFrame.origin.y - 126;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
    
    [UIView beginAnimations:@"hideSelectionView" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDelegate:self];
    
//    _pTrendViewScroll.frame = rect;
//    _pTableView.frame = rcFrame;
//    CGRect rcEmpTy = _pTableView.bounds;
//    rcEmpTy.origin.y += 30;
//    rcEmpTy.size.height -= 30;
//    _pEmptyView.frame = rcEmpTy;
//    [UIView commitAnimations];
//    
//    [self.pTableView reloadData];
    
    _btnView.frame = rcFrame;
    CGRect rcList = rcFrame;
    rcList.origin = CGPointZero;
    rcList.origin.y += (rcFrame.origin.y + rcFrame.size.height);// rcMarket.origin.y + rcMarket.size.height;
    rcList.size.height = self.bounds.size.height - rcList.origin.y;//(rcMarket.origin.y + rcMarket.size.height);
    CGRect rectes = rcList;
    _pUserTable.frame = rectes;
    [_pUserTable.pTableView reloadData];
    _pWebViewNews.frame = rectes;
    _pWebViewDoctor.frame = rectes;
    _pManagerUserStock.frame = rectes;
    [UIView commitAnimations];
}



-(void)GetToolButtons:(CGRect)rcFrame
{
    NSMutableArray *ayBtn = NewObjectAutoD(NSMutableArray);
    
//    tztUISwitch *pFixBtn = NULL;
    
    tztUISwitch *pBtnHQ = [self CreateSwitchButton:MENU_HQ_UserStock
                                           yesTitle_:@"行情"
                                           yesImage_:@""
                                            noTitle_:@"行情"
                                            noImage_:@""];
    [ayBtn addObject:pBtnHQ];
    
    tztUISwitch *pBtnNews = [self CreateSwitchButton:MENU_HQ_UserStock * 2 + 2
                                           yesTitle_:@"新闻"
                                           yesImage_:@""
                                            noTitle_:@"新闻"
                                            noImage_:@""];
    [ayBtn addObject:pBtnNews];
    
    tztUISwitch *pBtnPro = [self CreateSwitchButton:MENU_HQ_UserStock * 2 + 4
                                          yesTitle_:@"专家"
                                          yesImage_:@""
                                           noTitle_:@"专家"
                                           noImage_:@""];
    [ayBtn addObject:pBtnPro];
    
    tztUISwitch* pBtnManager = [self CreateSwitchButton:MENU_HQ_UserStock * 2 + 6
                                              yesTitle_:@"编辑"
                                              yesImage_:@""
                                               noTitle_:@"编辑"
                                               noImage_:@""];
    pBtnManager.pUnCheckedColor = [UIColor colorWithRGBULong:0xdca309];
    pBtnManager.pNormalColor = [UIColor colorWithRGBULong:0xdca309];
    [ayBtn addObject:pBtnManager];
    
 //   _btnView.bNeedSepLine = FALSE;
    _btnView.bNeedSepLine = FALSE;
    if (ayBtn != NULL)
        _btnView.ayBtnData = ayBtn;
    _btnView.fixBtn = nil;
    _btnView.nFixBtnWidth = 0;
    _btnView.nArrowWidth = 0;
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
        UIImage *image = [UIImage tztCreateImageWithColor:[UIColor tztThemeBackgroundColorSectionSel]];// [UIImage tztCreateImageWithColor:[UIColor colorWithTztRGBStr:@"60,60,60"]];
        pSwitch.yesImage = image;//[UIImage imageTztNamed:image];
    }
    else
    {
        pSwitch.yesImage = [UIImage imageTztNamed:yesImage];
    }
    
    if (noImage == nil || noImage.length <= 0)
    {
        UIImage *image = [UIImage tztCreateImageWithColor:[UIColor tztThemeBackgroundColorSection]];// [UIImage tztCreateImageWithColor:[UIColor colorWithTztRGBStr:@"42,42,42"]];
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
                action:@selector(OnUFunctionBtnClickEx:)
      forControlEvents:UIControlEventTouchUpInside];
    return [pSwitch autorelease];
}

-(void)tztOnSwipe:(UISwipeGestureRecognizer*)recognsizer andView_:(UIView*)view
{
    return;
    if (recognsizer.direction == UISwipeGestureRecognizerDirectionLeft)//左滑
    {
        if (view == self.pWebViewNews)
        {
            [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 4]];
        }
        else if (view == self.pWebViewDoctor)
        {
            [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 6]];
        }
    }
    else if (recognsizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (view == self.pWebViewNews)
        {
            [g_navigationController popViewControllerAnimated:UseAnimated];
        }
        if (view == self.pWebViewDoctor)
        {
            [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 2]];
        }
        else if (view == self.pManagerUserStock)
        {
            [self OnUFunctionBtnClick:[_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock * 2 + 4]];
        }
    }
}

-(void)showWithAnimation:(UIView*)pShowView nDirection_:(int)nDirection
{
    if (self.pCurrentView == NULL || self.pCurrentView == pShowView)
    {
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
            [self.pCurrentView tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
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
    
    [UIView animateWithDuration:0.00f
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
    /*
     4、自选股新闻:       zlcftajax/ggzx/newmessage.htm?istabShow=0&stockCode=&content=xinwen&from=zxg
     5、自选股专家：      zlcftajax/ggzx/newmessage.htm?istabShow=0&stockCode=&content=zhuanjia&from=zxg
     */
    switch (pBtn.tag)
    {
        case MENU_HQ_UserStock:
        {
            [self showWithAnimation:self.pUserTable nDirection_:0];
        }
            break;
        case MENU_HQ_UserStock*2+6://自选股管理
        {
            [self showWithAnimation:self.pManagerUserStock nDirection_:1];
//            self.pManagerUserStock.hidden = NO;
            [self.pManagerUserStock setSelectIndex:0];
            //            [TZTUIBaseVCMsg OnMsg:TZT_MENU_EditUserStock wParam:0 lParam:0];
        }
            break;
        case MENU_HQ_UserStock*2+2://新闻
        {
            [self showWithAnimation:_pWebViewNews nDirection_:1];
            NSString *strCode = [tztUserStock GetNSUserStock:YES];
            NSString *strURL = [NSString stringWithFormat:@"/zlcftajax/ggzx/newmessage.htm?istabShow=0&content=xinwen&stockCode=%@",strCode];
            strURL = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [_pWebViewNews setWebURL:strURL];
        }
            break;
        case MENU_HQ_UserStock*2+3://公告
        {
        }
            break;
        case MENU_HQ_UserStock*2+4://专家
        {
            [self showWithAnimation:_pWebViewDoctor nDirection_:1];
            NSString *strCode = [tztUserStock GetNSUserStock:YES];
            NSString *strURL = [NSString stringWithFormat:@"/zlcftajax/ggzx/newmessage.htm?istabShow=0&content=zhuanjia&stockCode=%@",strCode];
            strURL = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [_pWebViewDoctor setWebURL:strURL];
            
        }
            break;
        case MENU_HQ_UserStock*2+5://微博
        {
        }
            break;
            
        default:
            break;
    }
}


-(void)OnUFunctionBtnClickEx:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (_btnView)
    {
        [_btnView setBtnState:sender];
    }
    
    [self setViewStates];
    self.pCurrentView.hidden = YES;
    switch (pBtn.tag)
    {
        case MENU_HQ_UserStock:
        {
            [self showWithAnimation:self.pUserTable nDirection_:0];
            self.pUserTable.hidden = NO;
        }
            break;
        case MENU_HQ_UserStock*2+6://自选股管理
        {
            [self showWithAnimation:self.pManagerUserStock nDirection_:1];
            self.pManagerUserStock.hidden = NO;
            [self.pManagerUserStock setSelectIndex:0];
        }
            break;
        case MENU_HQ_UserStock*2+2://新闻
        {
            [self showWithAnimation:self.pWebViewNews nDirection_:0];
            NSString *strCode = [tztUserStock GetNSUserStock:YES];
            NSString *strURL = [NSString stringWithFormat:@"/zlcftajax/ggzx/newmessage.htm?istabShow=0&content=xinwen&stockCode=%@",strCode];
            strURL = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [_pWebViewNews setWebURL:strURL];
        }
            break;
        case MENU_HQ_UserStock*2+3://公告
        {
        }
            break;
        case MENU_HQ_UserStock*2+4://专家
        {
            [self showWithAnimation:self.pWebViewDoctor nDirection_:0];
            NSString *strCode = [tztUserStock GetNSUserStock:YES];
            NSString *strURL = [NSString stringWithFormat:@"/zlcftajax/ggzx/newmessage.htm?istabShow=0&content=zhuanjia&stockCode=%@",strCode];
            strURL = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [_pWebViewDoctor setWebURL:strURL];
            
        }
            break;
        case MENU_HQ_UserStock*2+5://微博
        {
        }
            break;
            
        default:
            break;
    }
}

-(void)setViewStates
{
    for (UIView *pView in self.ayUserView)
    {
        pView.hidden = (pView != self.pUserTable);
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
    NSUInteger nIndex = [self.ayUserView indexOfObject:self.pCurrentView];
    NSUInteger nIndex1 = [self.ayUserView indexOfObject:pShowView];
    
    if (nIndex > nIndex1)
        return 0;
    else if (nIndex < nIndex1)
        return 1;
    else
        return -1;
}

-(void)OnUserStockTB:(id)sender
{
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(OnUserStockTB:)])
    {
        [self.tztDelegate OnUserStockTB:sender];
    }
}
@end
