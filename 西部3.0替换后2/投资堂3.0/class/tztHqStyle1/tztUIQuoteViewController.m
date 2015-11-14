/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIQuoteViewController
 * 文件标识：
 * 摘    要：   华泰新行情首页显示
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-02
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <tztMobileBase/tztSystemFunction.h>
#import "tztUIReportViewController_iphone.h"
#import "TZTInitReportMarketMenu.h"
#import "tztMenuViewController_iphone.h"
#import "tztUIQuoteViewController.h"

@interface tztUIQuoteViewController ()
{
    BOOL    _bHidenNineGrid;
    UISwipeGestureRecognizer *_swipeDown;
    UISwipeGestureRecognizer *_swipeUp;
    
    UIView  *_pLeftTopView;
    UIView  *_pLeftBottomView;
    int    _nShowed;
}
@property(nonatomic,retain)UISwipeGestureRecognizer *swipeDown;
@property(nonatomic,retain)UISwipeGestureRecognizer *swipeUp;
@property(nonatomic,retain)UIView   *pLeftTopView;
@property(nonatomic,retain)UIView   *pLeftBottomView;

-(NSMutableDictionary*)GetMarketMenu;
@end

@implementation tztUIQuoteViewController
@synthesize pReportList = _pReportList;
@synthesize nsReqAction = _nsReqAction;
@synthesize nsReqParam = _nsReqParam;
@synthesize nReportType = _nReportType;
@synthesize nsMenuID = _nsMenuID;
@synthesize pMarketView = _pMarketView;
@synthesize pMenuDict = _pMenuDict;
@synthesize nsOrdered = _nsOrdered;
@synthesize pTitle = _pTitle;
@synthesize btnView = _btnView;
@synthesize pWebView = _pWebView;
@synthesize pMenuView = _pMenuView;
@synthesize pIndexTrendScroll = _pIndexTrendScroll;
@synthesize pBtnHiden = _pBtnHiden;
@synthesize swipeDown = _swipeDown;
@synthesize swipeUp = _swipeUp;
@synthesize pLeftTopView = _pLeftTopView;
@synthesize pLeftBottomView = _pLeftBottomView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tztBaseView.backgroundColor = [UIColor tztThemeBackgroundColor];
    _nSegIndex = 0;
    _nPreIndex = -1;
    /*
     注册通知，收取自选股、最近浏览通知
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUserStockChanged:) name:tztUserStockNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OnUserStockChanged:) name:tztRectStockNotificationName object:nil];
    
    [self LoadLayoutView];
    
    if (self.nsReqAction && [self.nsReqAction length] > 0)
        [self RequestData:[self.nsReqAction intValue] nsParam_:self.nsReqParam];
    else
    {
        int n = [TZTAppObj getDefaultStartIndex];
        if (n == 2)
            [self RequestUserStockData];
        else
        {
            if (n < 0)
            {
                if (_nReportType == tztReportUserStock)
                    [self RequestUserStockData];
                else
                    [self RequestIndexData];
            }
            else
                [self RequestIndexData];
        }
    }
    
    if (self.swipeDown == NULL)
    {
        //增加手势(两个方向需要分开创建，否则接收的时候方向也是或在一起的)
        self.swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveUpOrDown:)];
        [self.swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
        self.swipeDown.delegate = self;
        [_tztBaseView addGestureRecognizer:self.swipeDown];
    }
    
    if (self.swipeUp == NULL)
    {
        self.swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveUpOrDown:)];
        [self.swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
        self.swipeUp.delegate = self;
        [_tztBaseView addGestureRecognizer:self.swipeUp];
    }
    
    self.swipeUp.delaysTouchesBegan = YES;
    self.swipeDown.delaysTouchesBegan = YES;
    self.swipeDown.cancelsTouchesInView = YES;
    self.swipeUp.cancelsTouchesInView = YES;
    [self.swipeDown requireGestureRecognizerToFail:self.swipeUp];
    [self.swipeUp requireGestureRecognizerToFail:self.swipeDown];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    self.pReportList.reportView.centerview.scrollEnabled = YES;
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer");
    UISwipeGestureRecognizer *rec = (UISwipeGestureRecognizer*)gestureRecognizer;
    UIGestureRecognizerState state = [rec state];
    
    if (rec == self.swipeUp && rec.direction == UISwipeGestureRecognizerDirectionUp)//向上滑动，首先判断
    {
        if (state == UIGestureRecognizerStateEnded && self.pWebView.hidden)
        {
            if (self.pReportList.reportView.centerview.contentOffset.y >= 0)//不处理
            {
                [self showTop:FALSE];
            }
            else
            {
            }
        }
        return YES;
    }
    if (rec == self.swipeDown && rec.direction == UISwipeGestureRecognizerDirectionDown)//向下滑动
    {
        if (state == UIGestureRecognizerStateEnded && self.pWebView.hidden)
        {
            if (self.pReportList.reportView.centerview.contentOffset.y <= 0
                && self.pReportList.startindex <= 1
                )//已经滑倒顶部了，滑出
            {
                [self showTop:TRUE];
            }
            else
            {
                
            }
        }
        return YES;
    }
    return YES;
}


-(void)showTop:(BOOL)bShow
{
    if (_bHidenNineGrid == !bShow)
        return;
    if (_nReportType != tztReportUserStock)//自选才有
        return;
    self.pReportList.reportView.centerview.scrollEnabled = NO;
    if (_bHidenNineGrid == !bShow && !bShow)
    {
    }
    else
    {
        self.pReportList.reportView.centerview.contentOffset = CGPointMake(0, 0);
    }
    _bHidenNineGrid = !bShow;
    [self LoadLayoutViewAnimated];
    
    self.pReportList.reportView.centerview.scrollEnabled =YES;
}

-(void)OnMoveUpOrDown:(UISwipeGestureRecognizer*)recognsizer
{
    if (_nReportType != tztReportUserStock)//自选才有
        return;
    if (recognsizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self tztGridView:Nil showEditUserStockButton:0];
    }
    else if (recognsizer.direction == UISwipeGestureRecognizerDirectionDown)
    {
        [self tztGridView:nil showEditUserStockButton:1];
    }
}
#pragma mark UIGestureRecognizerDelegate
-(BOOL)tztGestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_nReportType != tztReportUserStock)
        return YES;
    else//
    {
        return _pNineGridView.hidden;
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_pReportList)
    {
        [_pReportList onSetViewRequest:YES];
        if (_nReportType == tztReportRecentBrowse
            || _nReportType == tztReportUserStock)
        {
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@",
                                (_nReportType == tztReportUserStock ? [tztUserStock GetNSUserStock] : [tztUserStock GetNSRecentStock])
                                ];
            _pReportList.reqAction = @"60";
            _pReportList.nReportType = _nReportType;
            [_pReportList setStockInfo:pStock Request:1];
        }
    }
    if (_pIndexTrendScroll)
    {
        [_pIndexTrendScroll onSetViewRequest:YES];
    }
    
    
    if (g_nSupportLeftSide)
    {
        NSInteger n = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (n > 0)
        {
            [_pTitle.pLeftBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo+1.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_pTitle.pLeftBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _nShowed++;
    
    [self ShowHelperImageView];
}

-(void)ShowHelperImageView
{
    NSString* strSystemVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString* strLanucnedVer = [[NSUserDefaults standardUserDefaults] stringForKey:@"lanuchedVersion"];
    if (strLanucnedVer == NULL|| strLanucnedVer.length < 1
        || (strLanucnedVer && [strLanucnedVer caseInsensitiveCompare:strSystemVer] != NSOrderedSame))
        return;
    
    if (_nReportType == tztReportDAPANIndex)
    {
        NSString* nsName = @"";
        if (IS_TZTIphone5)
            nsName = @"tzt_MarketHelp-568h@2x.png";
        else
            nsName = @"tzt_MarketHelp@2x.png";
        [tztUIHelperImageView tztShowHelperView:nsName forClass_:@"tztQuoteViewController-DAPAN"];
    }
    else if (_nReportType == tztReportUserStock)
    {
        NSString* nsName = @"";
        if (IS_TZTIphone5)
            nsName = @"tzt_UserStock-568h@2x.png";
        else
            nsName = @"tzt_UserStock@2x.png";
        [tztUIHelperImageView tztShowHelperView:nsName forClass_:@"tztQuoteViewController-UserStock"];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_pReportList)
        [_pReportList onSetViewRequest:NO];
    if (_pIndexTrendScroll)
    {
        [_pIndexTrendScroll onSetViewRequest:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)SetMenuID:(NSString *)nsID
{
    [self.pMenuDict removeAllObjects];
    if (nsID)
        self.nsMenuID = [NSString stringWithFormat:@"%@", nsID];
    
    if ([nsID compare:@"1"] == NSOrderedSame)
    {
        self.nReportType = tztReportUserStock;
    }
    else if([nsID compare:@"2"] == NSOrderedSame)
    {
        self.nReportType = tztReportRecentBrowse;
    }
    else if([nsID compare:@"12"] == NSOrderedSame)
    {
        self.nReportType = tztReportDAPANIndex;
    }
    else if([nsID compare:@"13"] == NSOrderedSame)
    {
        self.nReportType = tztReportFlowsBlockIndex;
    }
    else
        self.nReportType = 0;
    
    self.pMenuDict = [self GetMarketMenu];
}


-(NSMutableDictionary*)GetMarketMenu
{
    if (self.nsMenuID == NULL || [self.nsMenuID length] <= 0)
        return NULL;
    return [g_pReportMarket GetSubMenuById:nil nsID_:self.nsMenuID];
}

-(void)LoadLayoutViewAnimated
{
    CGRect rcFrame = _tztBounds;//self.view.bounds;
    
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    
    /*
     标题区域
     */
    CGRect rcTitle = rcFrame;
    rcTitle.size.height = TZTToolBarHeight + (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
    _pTitle.frame = rcTitle;
    
    NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
    [pAy addObject:@"12002|市场"];
    [pAy addObject:@"12100|自选股"];
    [_pTitle setSegControlItems:pAy];
    
    
    rcFrame.origin = CGPointZero;
    rcFrame.origin.y += (_pTitle.frame.size.height + _pTitle.frame.origin.y);
    
    CGRect rcNine = rcFrame;
    rcNine.size.height = 68;
        _pNineGridView.frame = rcNine;
    /*
     功能按钮区域
     */
    CGRect rcBtnView = rcFrame;
    rcBtnView.origin = CGPointZero;
    rcBtnView.origin.y += (_bHidenNineGrid ? 0 : _pNineGridView.frame.size.height) + _pNineGridView.frame.origin.y;
    rcBtnView.size.height = 40;
    //在这里获得 自选股 view 的 新闻 公告 微博
    [self GetToolButtons:rcBtnView];
    
    if (_nReportType == tztReportUserStock)
    {
        _btnView.hidden = YES;
        if (/*_pNineGridView.hidden || */_bHidenNineGrid)
        {
            CGAffineTransform at = CGAffineTransformMakeRotation(M_PI / 2);
            [_btnView.fixArrow setTransform:at];
        }
        else
        {
            CGAffineTransform at = CGAffineTransformMakeRotation(-M_PI / 2);
            [_btnView.fixArrow setTransform:at];
        }
    }
    else
    {
        _btnView.hidden = NO;
        CGAffineTransform at = CGAffineTransformMakeRotation(0);
        [_btnView.fixArrow setTransform:at];
    }
    
    if (_nReportType == tztReportDAPANIndex)
    {
        if (_bHiddenTrendScroll)
        {
            CGAffineTransform at = CGAffineTransformMakeRotation(M_PI);
            [_pBtnHiden setTransform:at];
        }
        else
        {
            CGAffineTransform at = CGAffineTransformMakeRotation(0);
            [_pBtnHiden setTransform:at];
        }
    }
    
//    if (_nReportType == tztReportDAPANIndex)
    {
        CGRect rcTrendScroll = rcFrame;
        rcTrendScroll.origin.y += (_btnView.hidden ? 0 :_btnView.frame.size.height);
        rcTrendScroll.size.height = 158;
        if (_pIndexTrendScroll == NULL)
        {
            _pIndexTrendScroll = [[tztTrendView_scroll alloc] initWithFrame:rcTrendScroll];
            
            if (_pReportList != NULL)
            {
                [_tztBaseView insertSubview:_pIndexTrendScroll belowSubview:_pReportList];
            }
//            [_tztBaseView addSubview:_pIndexTrendScroll];
            [_pIndexTrendScroll RequestReportData];
            [_pIndexTrendScroll release];
        }
        else
        {
            [_pIndexTrendScroll onSetViewRequest:YES];
            _pIndexTrendScroll.frame = rcTrendScroll;
        }
    }
    
    if (_nReportType == tztReportDAPANIndex)
    {
        
    }
    else
    {
        [_pIndexTrendScroll onSetViewRequest:NO];
        _bHiddenTrendScroll = YES;
//        _pIndexTrendScroll.hidden = YES;
    }
    
    /*
     市场菜单区域
     */
    CGRect rcMarket = rcFrame;
    rcMarket.origin = CGPointZero;
    if (_nReportType == tztReportDAPANIndex && _pIndexTrendScroll && !_bHiddenTrendScroll)
    {
        rcMarket.origin.y += _btnView.frame.origin.y + (_btnView.hidden ? 0 : _btnView.frame.size.height) + _pIndexTrendScroll.frame.size.height;
    }
    else
        rcMarket.origin.y += _btnView.frame.origin.y + (_btnView.hidden ? 0 : _btnView.frame.size.height);
    if (self.pMenuDict && [self.pMenuDict count] > 0
        && [[self.pMenuDict objectForKey:@"tradelist"] count] > 1 )
    {
        rcMarket.size.height = 30;
        [_pMarketView SetMarketData:self.pMenuDict];
        if (_pMarketView.nsCurSel && _pMarketView.nsCurSel.length > 0)
        {
            NSString *str = [NSString stringWithFormat:@"%@",_pMarketView.nsCurSel];
            [_pMarketView setSelBtIndex:str];
        }
    }
    else
    {
        rcMarket.size.height = 0;
    }
    
    if (_nReportType == tztReportUserStock)
        rcMarket.size.height = 0;
    
    _pMarketView.frame = rcMarket;
    
    
//
//    if (_pIndexTrendScroll)
//        [_tztBaseView bringSubviewToFront:_pIndexTrendScroll];
    /*
     列表界面
     */
    
    CGRect rcList = rcFrame;
    rcList.origin = CGPointZero;
    rcList.origin.y += rcMarket.origin.y + rcMarket.size.height;
    rcList.size.height -= (rcMarket.origin.y + rcMarket.size.height);
    if (_pReportList == nil)
    {
        _pReportList = [[tztReportListView alloc] init];
        _pReportList.tztdelegate = self;
        _pReportList.reportView.nDefaultCellHeight = 45;
        _pReportList.frame = rcList;
        _pReportList.backgroundColor = [UIColor tztThemeBackgroundColorHQ];// [tztTechSetting getInstance].backgroundColor;
        
        [_tztBaseView addSubview:_pReportList];
        [_pReportList release];
    }
    else
    {
        _pReportList.frame = rcList;
    }
    _pReportList.nReportType = _nReportType;
    
    if (_nReportType == tztReportDAPANIndex)
    {
        CGRect rcButton = [_pReportList getLeftTopViewFrame];
        rcButton.origin.x += 5;
        rcButton.size.width = 20;
        if (_pBtnHiden == NULL)
        {
            _pBtnHiden = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pBtnHiden setBackgroundColor:[UIColor clearColor]];
            [_pBtnHiden setTztTitle:@"▲"];
            [_pBtnHiden setTztTitleColor:[UIColor colorWithTztRGBStr:@"206,206,206"]];
            [_pBtnHiden.titleLabel setFont:tztUIBaseViewTextFont(13.f)];
            _pBtnHiden.frame = rcButton;
            _pBtnHiden.showsTouchWhenHighlighted = YES;
            [_pReportList addSubview:_pBtnHiden];
            [_pBtnHiden addTarget:self action:@selector(OnBtnHiden) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            _pBtnHiden.frame = rcButton;
        }
    }
    else
    {
        _pBtnHiden.hidden = YES;
    }
    
    if (_pWebView == nil)
    {
        _pWebView = [[tztWebView alloc] init];
        _pWebView.tztDelegate = self;
        _pWebView.frame = rcList;
        _pWebView.hidden = YES;
        [_tztBaseView addSubview:_pWebView];
        [_pWebView release];
    }
    else
    {
        _pWebView.frame = rcList;
    }
    
    if (_pMenuView == nil)
    {
        _pMenuView = [[tztUITableListView alloc] initWithFrame:rcList];
        _pMenuView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        _pMenuView.tztdelegate = self;
        _pMenuView.bLocalTitle = NO;
        _pMenuView.hidden = YES;
        [_tztBaseView addSubview:_pMenuView];
        [_pMenuView release];
    }
    else
    {
        _pMenuView.frame = rcList;
    }
//    [UIView commitAnimations];
    
    _pNineGridView.hidden = _bHidenNineGrid;
    
    CGRect rc = _pIndexTrendScroll.frame;
    rc.size.width = 20;
    if (_bHiddenTrendScroll)
        rc.size.height = 0;
    if (_pLeftTopView == NULL)
    {
        _pLeftTopView = [[UIView alloc] initWithFrame:rc];
        _pLeftTopView.backgroundColor = [UIColor clearColor];
        [_tztBaseView addSubview:_pLeftTopView];
        [_pLeftTopView release];
    }
    else
    {
        _pLeftTopView.frame = rc;
    }
    
    CGRect rcBottom = _pReportList.frame;
    rcBottom.origin.y += [_pReportList getLeftTopViewFrame].size.height;
    rcBottom.size.width = 20;
    if (_pLeftBottomView == NULL)
    {
        _pLeftBottomView = [[UIView alloc] initWithFrame:rcBottom];
        _pLeftBottomView.backgroundColor = [UIColor clearColor];
        [_tztBaseView addSubview:_pLeftBottomView];
        [_pLeftBottomView release];
    }
    else
    {
        _pLeftBottomView.frame = rcBottom;
    }
    
    [_tztBaseView bringSubviewToFront:_pLeftBottomView];
    [_tztBaseView bringSubviewToFront:_pLeftTopView];
}

- (void)reloadTheme
{
    [super reloadTheme];
    _pMenuView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _pMenuView.tableview.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    _pMenuView.tableview.separatorColor = [UIColor tztThemeHQGridColor];
    _btnView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
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
// 行情跟自选的点击从这里切换
-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;//self.view.bounds; （0，0，320，411）
    
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    
    /*
     标题区域
     */
    CGRect rcTitle = rcFrame; //设置 标题框架
    rcTitle.size.height = TZTToolBarHeight;  //44  标题高度 44
    if (IS_TZTIOS(7))
        rcTitle.size.height += TZTStatuBarHeight;
    if (_pTitle == NULL)  //当标题从行情切换为自选的时候不为空的
    {
        _pTitle = [[tztUINewTitleView alloc] init];
        
        _pTitle.pLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (g_nSupportLeftSide)
            [_pTitle.pLeftBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo.png"] forState:UIControlStateNormal];
        else
            [_pTitle.pLeftBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTnavbarbackbg.png"] forState:UIControlStateNormal];
        
        [_pTitle.pLeftBtn addTarget:self
                             action:@selector(OnLeftItem:)
                   forControlEvents:UIControlEventTouchUpInside];
        [_pTitle addSubview:_pTitle.pLeftBtn];
        
        _pTitle.pRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pTitle.pRightBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTnavbarsearch.png"] forState:UIControlStateNormal];
        [_pTitle.pRightBtn addTarget:self
                              action:@selector(OnRightItem:)
                    forControlEvents:UIControlEventTouchUpInside];
        [_pTitle addSubview:_pTitle.pRightBtn];
        
        [_pTitle setFrame:rcTitle];
        _pTitle.pDelegate = self;
        [_tztBaseView addSubview:_pTitle];
        [_pTitle release];
    }
    else
    {
        _pTitle.frame = rcTitle; // (0,0,320,44)
    }

    
    NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
    
    [pAy addObject:@"12002|市场"];
    [pAy addObject:@"12100|自选股"];

//在这里设置标题的 的市场和自选    
    [_pTitle setSegControlItems:pAy];
    
//    [_pTitle setSelectSegmentIndex:_nSegIndex];
    
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_pTitle];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_pTitle];
 
   /**_pNineGridView frame 设置成0 怎么还能出现
    *	@brief	管理自选股 同步自选股 添加自选股 初始化frme ruyi
    */
   rcFrame.origin = CGPointZero;
   rcFrame.origin.y += (_pTitle.frame.size.height + _pTitle.frame.origin.y); //(0,44,320,411)
    CGRect rcNine = rcFrame;
    rcNine.size.height = 65;
    if (_pNineGridView == NULL)
    {
        _pNineGridView = [[tztUIStockEditButtonView alloc] init];
        _pNineGridView.frame = rcNine;
        [_tztBaseView addSubview:_pNineGridView];
        [_pNineGridView release];
        _pNineGridView.hidden = YES;
        _bHidenNineGrid = YES;
    }
    else
    {
        _pNineGridView.frame = rcNine;
    }
    if (_pNineGridView && (!_pNineGridView.hidden || !_bHidenNineGrid))
    {
        rcFrame.origin.y += rcNine.size.height;
    }
    else
    {
        rcNine.size.height = 0;
        _pNineGridView.frame = rcNine;
    }
    
    /*
     功能按钮区域
     */
    CGRect rcBtnView = rcFrame;
    rcBtnView.origin = CGPointZero;
    rcBtnView.origin.y += _pNineGridView.frame.size.height + _pNineGridView.frame.origin.y;
    rcBtnView.size.height = 40;
    if (_btnView == nil)
    {
        _btnView = [[tztUIFunctionView alloc] init];
        _btnView.frame = rcBtnView;
        _btnView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
//        在这个地方 添加自选行情 公告 新闻 微博
        [_tztBaseView addSubview:_btnView];
        [_btnView release];
    }
    [self GetToolButtons:rcBtnView]; //rcbtnview (0,44,320,40)
    
    if (_nReportType == tztReportUserStock)
    {
        if (/*_pNineGridView.hidden ||*/ _bHidenNineGrid)
        {
            CGAffineTransform at = CGAffineTransformMakeRotation(M_PI / 2);
            [_btnView.fixArrow setTransform:at];
        }
        else
        {
            CGAffineTransform at = CGAffineTransformMakeRotation(-M_PI / 2);
            [_btnView.fixArrow setTransform:at];
        }
    }
    else
    {
        CGAffineTransform at = CGAffineTransformMakeRotation(0);
        [_btnView.fixArrow setTransform:at];
    }
    
//    if (_nReportType == tztReportDAPANIndex)
    {
        CGRect rcTrendScroll = rcFrame;
        rcTrendScroll.origin.y += _btnView.frame.size.height;
        rcTrendScroll.size.height = 158; //(0,84,320,158)
        if (_pIndexTrendScroll == NULL)
        {
            _pIndexTrendScroll = [[tztTrendView_scroll alloc] initWithFrame:rcTrendScroll];
//            [_tztBaseView addSubview:_pIndexTrendScroll];
            if (_pMarketView != NULL)
            {
                [_tztBaseView insertSubview:_pIndexTrendScroll belowSubview:_pMarketView];
            }
            else
            {
                [_tztBaseView addSubview:_pIndexTrendScroll];
            }
            [_pIndexTrendScroll release];
        }
        else
        {
            [_pIndexTrendScroll onSetViewRequest:YES];
            _pIndexTrendScroll.frame = rcTrendScroll;
        }
    }
    
    if (_nReportType == tztReportDAPANIndex)
    {
        
    }
    else
    {
        [_pIndexTrendScroll onSetViewRequest:NO];
        _bHiddenTrendScroll = YES;
//        _pIndexTrendScroll.hidden = YES;
    }
    
    /*
     市场菜单区域 二级菜单
     */
    CGRect rcMarket = rcFrame;
    rcMarket.origin = CGPointZero;
    if (_nReportType == tztReportDAPANIndex && _pIndexTrendScroll && !_bHiddenTrendScroll)
    {
        rcMarket.origin.y += _btnView.frame.origin.y + _btnView.frame.size.height + _pIndexTrendScroll.frame.size.height;
    }
    else
        rcMarket.origin.y += _btnView.frame.origin.y + _btnView.frame.size.height;


    
    if (_pMarketView == nil)
    {
        _pMarketView = [[tztUINewMarketView alloc] init];
        _pMarketView.frame = rcMarket;
        _pMarketView.pDelegate = self;
        if (_pIndexTrendScroll)
        {
            [_tztBaseView insertSubview:_pMarketView aboveSubview:_pIndexTrendScroll];
        }
        else
        {
            [_tztBaseView addSubview:_pMarketView];
        }
        [_pMarketView release];
    }
    
    if (self.pMenuDict && [self.pMenuDict count] > 0
        && [[self.pMenuDict objectForKey:@"tradelist"] count] > 1 )
    {
        rcMarket.size.height = 30;
        [_pMarketView SetMarketData:self.pMenuDict];
        if (_pMarketView.nsCurSel && _pMarketView.nsCurSel.length > 0)
        {
            NSString *str = [NSString stringWithFormat:@"%@",_pMarketView.nsCurSel];
            [_pMarketView setSelBtIndex:str];
        }
    }
    else
    {
        rcMarket.size.height = 0;
    }
    _pMarketView.frame = rcMarket;
    
//    if (_pIndexTrendScroll)
//        [_tztBaseView bringSubviewToFront:_pIndexTrendScroll];
    /*
     列表界面
     */
    
    CGRect rcList = rcFrame;
    rcList.origin = CGPointZero;
    rcList.origin.y += rcMarket.origin.y + rcMarket.size.height;
    rcList.size.height -= (rcMarket.origin.y + rcMarket.size.height);
    if (_pReportList == nil)
    {
        _pReportList = [[tztReportListView alloc] init];
        _pReportList.tztdelegate = self;
        _pReportList.reportView.nDefaultCellHeight = 45;
        _pReportList.frame = rcList;
        _pReportList.backgroundColor = [tztTechSetting getInstance].backgroundColor;
        
        [_tztBaseView addSubview:_pReportList];
        [_pReportList release];
    }
    else
    {
        _pReportList.frame = rcList;
    }
    _pReportList.nReportType = _nReportType;
    
    if (_nReportType == tztReportDAPANIndex)
    {
        CGRect rcButton = [_pReportList getLeftTopViewFrame];
        rcButton.origin.x += 5;
        rcButton.size.width = 20;
        if (_pBtnHiden == NULL)
        {
            _pBtnHiden = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pBtnHiden setBackgroundColor:[UIColor clearColor]];
            [_pBtnHiden setTztTitle:@"▲"];
            [_pBtnHiden setTztTitleColor:[UIColor colorWithTztRGBStr:@"206,206,206"]];
            [_pBtnHiden.titleLabel setFont:tztUIBaseViewTextFont(13.f)];
            _pBtnHiden.frame = rcButton;
            _pBtnHiden.showsTouchWhenHighlighted = YES;
            [_pReportList addSubview:_pBtnHiden];
            [_pBtnHiden addTarget:self action:@selector(OnBtnHiden) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            _pBtnHiden.frame = rcButton;
        }
    }
    else
    {
        _pBtnHiden.hidden = YES;
    }
    
    if (_pWebView == nil)
    {
        _pWebView = [[tztWebView alloc] init];
        _pWebView.tztDelegate = self;
        _pWebView.frame = rcList;
        _pWebView.hidden = YES;
        [_tztBaseView addSubview:_pWebView];
        [_pWebView release];
    }
    else
    {
        _pWebView.frame = rcList;
    }
    
    if (_pMenuView == nil)
    {
        _pMenuView = [[tztUITableListView alloc] init];
        _pMenuView.tztdelegate = self;
        _pMenuView.bLocalTitle = NO;
        _pMenuView.isMarketMenu = YES;
        _pMenuView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        _pMenuView.tableview.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        _pMenuView.frame = rcList;
        _pMenuView.hidden = YES;
        [_tztBaseView addSubview:_pMenuView];
        [_pMenuView release];
    }
    else
    {
        _pMenuView.frame = rcList;
    }
    [_tztBaseView bringSubviewToFront:_pNineGridView];
    [_tztBaseView bringSubviewToFront:_btnView];
    
    
    CGRect rc = _pIndexTrendScroll.frame;
    rc.size.width = 20;
    if (_bHiddenTrendScroll)
        rc.size.height = 0;
    if (_pLeftTopView == NULL)
    {
        _pLeftTopView = [[UIView alloc] initWithFrame:rc];
        _pLeftTopView.backgroundColor = [UIColor clearColor];
        [_tztBaseView addSubview:_pLeftTopView];
        [_pLeftTopView release];
    }
    else
    {
        _pLeftTopView.frame = rc;
    }
    
    CGRect rcBottom = _pReportList.frame;
    rcBottom.origin.y += [_pReportList getLeftTopViewFrame].size.height;
    rcBottom.size.width = 20;
    if (_pLeftBottomView == NULL)
    {
        _pLeftBottomView = [[UIView alloc] initWithFrame:rcBottom];
        _pLeftBottomView.backgroundColor = [UIColor clearColor];
        [_tztBaseView addSubview:_pLeftBottomView];
        [_pLeftBottomView release];
    }
    else
    {
        _pLeftBottomView.frame = rcBottom;
    }
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_pLeftTopView];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_pLeftBottomView];
    [[TZTAppObj getShareInstance].rootTabBarController RefreshAddCustomsViews];
    
}

-(void)OnBtnHiden
{
    _bHiddenTrendScroll = !_bHiddenTrendScroll;
    [self LoadLayoutViewAnimated];
}
// 切换行情 自选
-(void)GetToolButtons:(CGRect)rcFrame
{
    NSMutableArray *ayBtn = NewObjectAutoD(NSMutableArray);
    
    //获取当前选中的按钮
    if (_pTitle == NULL)
        return;
    
    int nFunctionID = [_pTitle getFunctionIDInSegControl];
    if (_nPreIndex == nFunctionID)
    {
        _btnView.frame = rcFrame;
        return;
    }
    tztUISwitch *pFixBtn = NULL;
    _nPreIndex = nFunctionID;
    switch (nFunctionID)
    {
        case MENU_HQ_UserStock:
       {
            tztUISwitch *pSwitch = [self CreateSwitchButton:MENU_HQ_UserStock
                                                  yesTitle_:@"行情"
                                                  yesImage_:@""
                                                   noTitle_:@"行情"
                                                   noImage_:@""];
            [ayBtn addObject:pSwitch];
            
            tztUISwitch *pBtnNews = [self CreateSwitchButton:nFunctionID * 2 + 2
                                                   yesTitle_:@"新闻"
                                                   yesImage_:@""
                                                    noTitle_:@"新闻"
                                                    noImage_:@""];
            [ayBtn addObject:pBtnNews];
            
            tztUISwitch *pBtnNotice = [self CreateSwitchButton:nFunctionID * 2 + 3
                                                     yesTitle_:@"公告"
                                                     yesImage_:@""
                                                      noTitle_:@"公告"
                                                      noImage_:@""];
            [ayBtn addObject:pBtnNotice];
            
            
            tztUISwitch *pBtnPro = [self CreateSwitchButton:nFunctionID * 2 + 4
                                                  yesTitle_:@"专家"
                                                  yesImage_:@""
                                                   noTitle_:@"专家"
                                                   noImage_:@""];
            [ayBtn addObject:pBtnPro];
            
            tztUISwitch *pBtnWeiBo = [self CreateSwitchButton:nFunctionID * 2 + 5
                                                    yesTitle_:@"微博"
                                                    yesImage_:@""
                                                     noTitle_:@"微博"
                                                     noImage_:@""];
            [ayBtn addObject:pBtnWeiBo];

            pFixBtn = [self CreateSwitchButton:nFunctionID * 2 + 6
                                                      yesTitle_:@""
                                                      yesImage_:@""
                                                       noTitle_:@""
                                                       noImage_:@""];
            
            _btnView.nFixBtnWidth = 20;
            _btnView.bNeedSepLine = TRUE;
        }
            break;
        case MENU_HQ_Report:
        {
            NSMutableDictionary *dict = GetDictByListName(@"tztQuoteTagSetting");
            NSMutableArray *ayData = [dict objectForKey:@"quotesettings"];
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
                    pFixBtn = [self CreateSwitchButton:[strTag intValue]
                                                          yesTitle_:@""
                                                          yesImage_:@""
                                                           noTitle_:@""
                                                           noImage_:@""];
                    
                    _btnView.nFixBtnWidth = 31;
                    _btnView.bNeedSepLine = TRUE;
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
        }
            break;
        default:
            break;
    }
    
//    在这里设置 自选股的新闻 公告 微博的数据 frame
    if (ayBtn != NULL)
    _btnView.ayBtnData = ayBtn;
    _btnView.fixBtn = pFixBtn;
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
    pSwitch.bUnderLine = TRUE;
    pSwitch.fontSize = 18.0f;
   
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
        pSwitch.pUnCheckedColor = [UIColor tztThemeHQBalanceColor];// [UIColor colorWithTztRGBStr:@"43,43,43"];
        pSwitch.pNormalColor = [UIColor tztThemeHQBalanceColor];
    }
    
    [pSwitch setTztTitleColor:[UIColor tztThemeHQBalanceColor]];
    [pSwitch addTarget:self
                action:@selector(OnUFunctionBtnClick:)
      forControlEvents:UIControlEventTouchUpInside];
    return [pSwitch autorelease];
}
#pragma mark tztUINewTitleViewDelegate
//在这里 切换 自选股 跟 市场
-(void)tztNewTitleClick:(id)sender FuncionID_:(int)nFunctionID withParams_:(id)params
{
    CUCustomSwitch *seg = (CUCustomSwitch*)sender;
    _nSegIndex = (seg.on ? 1 : 0);
    switch (nFunctionID)
    {
        case MENU_HQ_UserStock:
        {
            [self LoadLayoutView];
            [self RequestUserStockData];
        }
            break;
        case MENU_HQ_Report:
        {
            _pNineGridView.hidden = TRUE;
            _bHidenNineGrid = YES;
            [self LoadLayoutView];
            [self RequestIndexData];
        }
            break;
        default:
            break;
    }
    
    [self ShowHelperImageView];
}

//自选股票发生改变通知
-(void)OnUserStockChanged:(NSNotification*)notification
{
    if(_pReportList && notification)
    {
        if (!_pReportList.bRequest)
            return;
        if (([notification.name compare:tztUserStockNotificationName]==NSOrderedSame && _nReportType == tztReportUserStock) || ([notification.name compare:tztRectStockNotificationName]==NSOrderedSame && _nReportType == tztReportRecentBrowse) )//当前是属于自选界面 或最近浏览
        {
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@",
                                (_nReportType == tztReportUserStock ? [tztUserStock GetNSUserStock] : [tztUserStock GetNSRecentStock])
                                ];
            _pReportList.reqAction = @"60";
            [_pReportList setStockInfo:pStock Request:1];
        }
    }
}

-(void)RequestData:(int)nAction nsParam_:(NSString *)nsParam
{
    if (nAction <= 0)
        nAction = [self.nsReqAction intValue];
    
    if (nsParam == NULL)
        nsParam = [NSString stringWithFormat:@"%@",self.nsReqParam];
    
    if (_nReportType == tztReportBlockIndex)
    {
        
    }
    else
        _pReportList.fixRowCount = 0;
    
    int nOrder = [self.nsOrdered intValue];
    int accountIndex = nOrder / 2;
    int nDirection = nOrder % 10;
    if (nOrder == 0)
        nDirection = 1;
    
    _pReportList.accountIndex = accountIndex;
    _pReportList.direction = nDirection;
    
    if (nAction == 60 || nAction == 89 || nAction == 20193)
    {
        self.nsReqAction = @"60";
        nAction = 60;
        if (_nReportType == tztReportUserStock)//自选
        {
            
            //激活登录成功后进入界面,判断是否直接下载自选股 add by xyt 20131008
            NSString* strLogMobile = [tztKeyChain load:tztLogMobile];
            if (g_pSystermConfig && g_pSystermConfig.bRegistSucToDownload && strLogMobile &&
                [strLogMobile length] > 1 && [TZTUserInfoDeal IsHaveTradeLogin:Systerm_Log])
            {
                NSArray *pAy = [tztUserStock GetUserStockArray];
                if([pAy count] <= 0) //无自选股数据，从服务器下载请求
                {
                    [[tztUserStock getShareClass] Download];
                }
                else
                {
                    nsParam = [NSString stringWithFormat:@"%@",[tztUserStock GetNSUserStock]];
                }
            }
            else
            {
                nsParam = [NSString stringWithFormat:@"%@",[tztUserStock GetNSUserStock]];
                if(nsParam.length <= 0) //无自选股数据，从服务器下载请求
                {
                    [[tztUserStock getShareClass] Download];
                }
            }
        }
        else if(_nReportType == tztReportRecentBrowse)
        {
            nsParam = [NSString stringWithFormat:@"%@",[tztUserStock GetNSRecentStock]];
        }
    }
    else if(nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
    {
        nsParam = [NSString stringWithFormat:@"%@",[tztUserStock GetNSUserStock]];
        if(nsParam.length <= 0) //无自选股数据，从服务器下载请求
        {
            [[tztUserStock getShareClass] Download];
        }
    }
    
    NSArray *pAy = [nsParam componentsSeparatedByString:@"#"];
    if ([pAy count] < 1)
        return;
    
    NSString* param = [pAy objectAtIndex:0];
    
    if (_pMarketView)
    {
        NSString *nsdata = [NSString stringWithFormat:@"%@#%d#%@",param,nAction,self.nsMenuID];
        if (nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
        {
            nsdata = [NSString stringWithFormat:@"#%d#%@", nAction,self.nsMenuID];
        }
        [_pMarketView setSelBtIndex:nsdata];
    }
    if (_pReportList)
    {
        _pReportList.reqAction =[NSString stringWithFormat:@"%d", nAction];
        tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
        pStock.stockCode = [NSString stringWithFormat:@"%@", param];
        [_pReportList tztShowNewType];
        [_pReportList setStockInfo:pStock Request:1];
    }
}

-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo *)pStock
{
    if (hqView == _pReportList)
    {
        if ([_pReportList.reqAction compare:@"20196"] == NSOrderedSame
            || [_pReportList.reqAction compare:@"20640"] == NSOrderedSame
            || [_pReportList.reqAction compare:@"20641"] == NSOrderedSame
            || [_pReportList.reqAction compare:@"20642"] == NSOrderedSame
            || [_pReportList.reqAction compare:@"20643"] == NSOrderedSame
            )
        {
            BOOL bPush = FALSE;
            int nType = tztReportBlockIndex;
            
            if ([_pReportList.reqAction compare:@"20640"] == NSOrderedSame
                || [_pReportList.reqAction compare:@"20641"] == NSOrderedSame
                || [_pReportList.reqAction compare:@"20642"] == NSOrderedSame
                || [_pReportList.reqAction compare:@"20643"] == NSOrderedSame)
            {
//                nType = 0;
                nType = tztReportFlowsBlockIndex;
            }
            
            tztUIReportViewController_iphone *pVC = (tztUIReportViewController_iphone *)gettztHaveViewContrller([tztUIReportViewController_iphone class], tztvckind_HQ, [NSString stringWithFormat:@"%d",tztReportShowBlockInfo], &bPush,FALSE);
            [pVC retain];
            pVC.nReportType = nType;
            pVC.pStockInfo = pStock;
            if ([_pReportList.reqAction compare:@"20640"] == NSOrderedSame)
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20650"];
            else if ([_pReportList.reqAction compare:@"20641"] == NSOrderedSame)
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20651"];
            else if ([_pReportList.reqAction compare:@"20642"] == NSOrderedSame)
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20652"];
            else if ([_pReportList.reqAction compare:@"20643"] == NSOrderedSame)
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20653"];
            else
                pVC.nsReqAction = [NSString stringWithFormat:@"%@", @"20199"];
            pVC.nsReqParam = [NSString stringWithFormat:@"%@", pStock.stockCode];
            [pVC setTitle:pStock.stockName];
#ifdef Support_HTSC
            [pVC SetHidesBottomBarWhenPushed:YES];
#endif
            if(bPush)
                [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC release];
        }
        else
        {
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:(NSUInteger)hqView];
        }
    }
}

#pragma mark tztUIMarketDelegate
-(void)tztUIMarket:(id)sender DidSelectMarket:(NSMutableDictionary *)pDict marketMenu:(NSDictionary *)pMenu
{
    if(sender == _pMarketView)
    {
        if (pDict == NULL || [pDict count] <= 0)
            return;
        [_pReportList setCurrentIndex:-1];
        NSString* strTitle = [pDict tztObjectForKey:@"tztTitle"];
        NSString* strParam = [pDict tztObjectForKey:@"tztParam"];
        NSString* strMenuData = [pDict tztObjectForKey:@"tztMenuData"];
        //        int nMsgType = [[pDict tztObjectForKey:@"tztMsgType"] intValue];
        _pReportList.startindex = 1;//切换市场，回到第一条
        _pReportList.reqchange = INT16_MIN;
        NSArray *pAyParam = [strParam componentsSeparatedByString:@"#"];
        if (pAyParam == NULL || [pAyParam count] < 2)
            return;
        
        NSArray *pAyMenuData = [strMenuData componentsSeparatedByString:@"|"];
        if ([pAyMenuData count] < 2)
            return;
        
        /*
         此处需要增加判断，下级是不是可以直接请求数据，还是要列表展示菜单
         */
        NSString* nsMenuID  = @"";
        NSString* nsID      = @"";
        NSString* nsType    = @"";
        NSString* nsParam   = @"";
        
        if ([pAyMenuData count] > 3)
            nsParam = [pAyMenuData objectAtIndex:3];
        
        if ([pAyMenuData count] >= 3)
        {
            nsMenuID = [pAyMenuData objectAtIndex:0];
            nsID     = [NSString stringWithFormat:@"%@", [pAyMenuData objectAtIndex:[pAyMenuData count] - 2]];
            nsType   = [NSString stringWithFormat:@"%@", [pAyMenuData objectAtIndex:[pAyMenuData count] - 3]];
        }
        
        BOOL bSubMenu = FALSE;
        int nAction = 0;
        if (nsParam && [nsParam length] > 0)
        {
            NSArray *ayParam = [nsParam componentsSeparatedByString:@"#"];
            if (ayParam && [ayParam count] > 1)
            {
                nAction = [[ayParam objectAtIndex:1] intValue];
                bSubMenu = (/*(nsID == NULL || [nsID length] <= 0)*/ (nAction <= 0));
            }
        }
        
        //还是菜单
        if ([nsType caseInsensitiveCompare:@"s"] == NSOrderedSame
            || bSubMenu)
        {
            if (_pMarketView)
            {
                NSString *nsdata = [NSString stringWithFormat:@"%@#%@",nsParam,nsMenuID];
                if (nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
                {
                    nsdata = [NSString stringWithFormat:@"#%d#%@", nAction, nsMenuID];
                }
                [_pMarketView setSelBtIndex:nsdata];
            }
            
            NSMutableDictionary *pDictValue = [g_pReportMarket GetSubMenuById:nil nsID_:nsMenuID];
            _pMenuView.hidden = NO;
            _pMenuView.frame = _pMenuView.frame;
            [_pMenuView setAyListInfo:[pDictValue objectForKey:@"tradelist"]];
            [_pMenuView reloadData];
            return;
        }
        /*判断处理结束*/
        
        
        if ([pAyMenuData count] > 4)
        {
            self.nsOrdered = [NSString stringWithFormat:@"%@",[pAyMenuData objectAtIndex:4]];
            
            int nOrder = [self.nsOrdered intValue];
            int accountIndex = nOrder / 2;
            int nDirection = nOrder % 10;
            _pReportList.accountIndex = accountIndex;// [self.nsOrdered intValue];
            _pReportList.direction = nDirection;
        }
        [self setTitle:strTitle];
        self.nsMenuID = [NSString stringWithFormat:@"%@", nsMenuID];
        self.nsReqAction = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:1]];
        self.nsReqParam = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:0]];
        [self RequestData:[self.nsReqAction intValue] nsParam_:self.nsReqParam];
        _pMenuView.hidden = YES;
    }
}

-(BOOL)IsHaveSubMenu:(NSMutableDictionary*)pSubDict returnValue_:(NSMutableDictionary**)returnDict
{
    if (pSubDict == NULL)
        return FALSE;
    
    NSMutableArray *pData = [pSubDict objectForKey:@"tradelist"];
    if (pData == NULL || [pData count] <= 0)
        return FALSE;
    
    NSDictionary *pDict = [pData objectAtIndex:0];
    if (pDict == NULL)
        return FALSE;
    NSString* strMenuData = [pDict objectForKey:@"MenuData"];
    if (strMenuData == NULL || [strMenuData length] < 1)
        return FALSE;
    NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
    if (pAy == NULL || [pAy count] < 3)
        return FALSE;
    
    /*
     此处需要增加判断，下级是不是可以直接请求数据，还是要列表展示菜单
     */
    NSString* nsMenuID  = @"";
    NSString* nsID      = @"";
    NSString* nsType    = @"";
    NSString* nsParam   = @"";
    
    if ([pAy count] > 3)
        nsParam = [pAy objectAtIndex:3];
    
    if ([pAy count] >= 3)
    {
        nsMenuID = [pAy objectAtIndex:0];
        nsID     = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:[pAy count] - 2]];
        nsType   = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:[pAy count] - 3]];
    }
    
    BOOL bSubMenu = FALSE;
    if (nsParam && [nsParam length] > 0)
    {
        NSArray *ayParam = [nsParam componentsSeparatedByString:@"#"];
        if (ayParam && [ayParam count] > 1)
        {
            bSubMenu = (/*(nsID == NULL || [nsID length] <= 0)*/ ([[ayParam objectAtIndex:1] intValue] <= 0));
        }
    }
    //还是菜单
    if ([nsType caseInsensitiveCompare:@"s"] == NSOrderedSame
        || bSubMenu)
    {
        NSMutableDictionary *pSubDict1 = [g_pReportMarket GetSubMenuById:self.pMenuDict nsID_:nsMenuID];
        //判断此处的菜单是否有下级菜单
        *returnDict = pSubDict1;
        return TRUE;
    }
    
    return FALSE;
}
#pragma mark tztUITableListViewDelegate
-(BOOL)tztUITableListView:(tztUITableListView*)tableView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString*)strMsgValue
{
    NSString* nsMenuID = @"0";
    NSArray* pAy = [strMsgValue componentsSeparatedByString:@"|"];
    if(pAy && [pAy count] > 3)
        nsMenuID = [pAy objectAtIndex:0];
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)[NSString stringWithFormat:@"%@", nsMenuID] lParam:(NSUInteger)strMsgValue];
    return TRUE;
}
//
-(BOOL)RequestDefaultMenuData:(NSString*)nsID
{
    if (nsID == NULL)
        return FALSE;
    
    [self SetMenuID:nsID];
    if (self.pMenuDict)
    {
        NSMutableArray *pData = [self.pMenuDict objectForKey:@"tradelist"];
        if (pData == NULL || [pData count] <= 0)
            return FALSE;
     
        NSString* strTempData= @"";
        for (int i = 0; i < [pData count]; i++)
        {
            NSDictionary *pDict = [pData objectAtIndex:i];
            if (pDict == NULL)
                return FALSE;
            NSString* strMenuData = [pDict objectForKey:@"MenuData"];
            if (strMenuData == NULL || [strMenuData length] < 1)
                return FALSE;
            NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
            if (pAy == NULL || [pAy count] < 3)
                return FALSE;
            
            NSString *strLast = [pAy lastObject];
            if ((_nReportType != tztReportUserStock && _nReportType != tztReportDAPANIndex)
                && strLast && [strLast caseInsensitiveCompare:@"F"] == NSOrderedSame)
                continue;
            else
            {
                strTempData = [NSString stringWithFormat:@"%@", strMenuData];
                break;
            }
        }
        
        
        NSArray *pAy = [strTempData componentsSeparatedByString:@"|"];
        if (pAy == NULL || [pAy count] < 3)
            return FALSE;
//
//        
        /*
         此处需要增加判断，下级是不是可以直接请求数据，还是要列表展示菜单
         */
        NSString* nsMenuID  = @"";
        NSString* nsID      = @"";
        NSString* nsType    = @"";
        NSString* nsParam   = @"";
        
        if ([pAy count] > 3)
            nsParam = [pAy objectAtIndex:3];
        
        if ([pAy count] >= 3)
        {
            nsMenuID = [pAy objectAtIndex:0];
            nsID     = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:[pAy count] - 2]];
            nsType   = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:[pAy count] - 3]];
        }
        
        BOOL bSubMenu = FALSE;
        int nAction = 0 ;
        if (nsParam && [nsParam length] > 0)
        {
            NSArray *ayParam = [nsParam componentsSeparatedByString:@"#"];
            if (ayParam && [ayParam count] > 1)
            {
                nAction = [[ayParam objectAtIndex:1] intValue];
                bSubMenu = (/*(nsID == NULL || [nsID length] <= 0)*/ (nAction <= 0));
            }
        }
        
        NSMutableDictionary *pDictValue = [[NSMutableDictionary alloc] init];
        //还是菜单
        if ([nsType caseInsensitiveCompare:@"s"] == NSOrderedSame
            || bSubMenu)
        {
            //判断此处的菜单是否有下级菜单
            if ([self IsHaveSubMenu:self.pMenuDict returnValue_:&pDictValue])
            {
                if (_pMarketView)
                {
                    [_pMarketView SetMarketData:self.pMenuDict];
                    _pMenuView.hidden = NO;
                    _pMenuView.frame = _pMenuView.frame;
                    [_pMenuView setAyListInfo:[pDictValue objectForKey:@"tradelist"]];
                    [_pMenuView reloadData];
                    
                    NSString *nsdata = [NSString stringWithFormat:@"%@#%@",nsParam,nsMenuID];
                    if (nAction == 20610 || nAction == 20611 || nAction == 20612 || nAction == 20613)
                    {
                        nsdata = [NSString stringWithFormat:@"#%d#%@", nAction,nsMenuID];
                    }
                    [_pMarketView setSelBtIndex:nsdata];
                }
//                [pDictValue release];
                return FALSE;
            }
        }
//        [pDictValue release];
        /*判断处理结束*/
        
        if ([pAy count] > 4)
        {
            self.nsOrdered = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:4]];
        }
        
        if (self.nsOrdered == NULL || self.nsOrdered.length <= 0 )
        {
            if (_nReportType == tztReportBlockIndex || _nReportType == tztReportUserStock)
                self.nsOrdered = @"18";//18 ＝ 9 ＊ 2
            else
                self.nsOrdered = @"0";
        }
        
        NSString* strParam = [pAy objectAtIndex:3];
        NSArray *pAyParam = [strParam componentsSeparatedByString:@"#"];
        NSString* strTitle = [pAy objectAtIndex:1];
        [self setTitle:strTitle];
        self.nsMenuID = [NSString stringWithFormat:@"%@", nsMenuID];
        self.nsReqAction = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:1]];
        self.nsReqParam = [NSString stringWithFormat:@"%@", [pAyParam objectAtIndex:0]];
    }
    return TRUE;
}


-(void)OnLeftItem:(id)sender
{
    if (g_nSupportLeftSide)
        [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
    else
        [self OnReturnBack];
}
//标题 搜索
-(void)OnRightItem:(id)sender
{
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_SearchStock wParam:0 lParam:0];
}

//点击市场和自选股切换页面的事件 ruyi
-(void)OnUFunctionBtnClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn.tag == MENU_HQ_UserStock*2+6)//点击管理
    {
        _pNineGridView.hidden = !_pNineGridView.hidden;
        _bHidenNineGrid = !_bHidenNineGrid;
        [self LoadLayoutViewAnimated];
        if (sender && [sender isKindOfClass:[tztUISwitch class]])
        {
            [(tztUISwitch*)sender setChecked:NO];
        }
        return;
    }
    if (pBtn.tag == MENU_HQ_HQMore)//点击更多
    {
        [(tztUISwitch*)pBtn setChecked:NO];
        //弹出其他市场
        [TZTUIBaseVCMsg OnMsg:MENU_HQ_MarketMenu wParam:0 lParam:0];
        return;
    }
    if (_btnView)
    {
        [_btnView setBtnState:sender];
    }
    _pWebView.hidden = YES;
    switch (pBtn.tag)
    {
        case MENU_HQ_UserStock:
        {
            [self RequestDataWithMarketID:@"1"];
        }
            break;
        case MENU_HQ_HS:
        case MENU_HQ_Report:
        {
            [self RequestDataWithMarketID:@"3"];
        }
            break;
        case MENU_HQ_TopBlock:
        {
            [self RequestDataWithMarketID:@"4"];
        }
            break;
        case MENU_HQ_HK:
        {
            [self RequestDataWithMarketID:@"6"];
        }
            break;
        case MENU_HQ_QH:
        {
            [self RequestDataWithMarketID:@"7"];
        }
            break;
        case MENU_HQ_WH:
        {
            [self RequestDataWithMarketID:@"8"];
        }
            break;
        case MENU_HQ_Global:
        {
            [self RequestDataWithMarketID:@"9"];
        }
            break;
        case MENU_HQ_Index:
        {
            if (_pIndexTrendScroll)
            {
                [_pIndexTrendScroll RequestReportData];
            }
            [self RequestDataWithMarketID:@"12"];
        }
            break;
        case MENU_HQ_FundLiuxiang:
        {
            [self RequestDataWithMarketID:@"13"];
        }
            break;
        case MENU_HQ_UserStock*2+6://自选股管理
        {
            [TZTUIBaseVCMsg OnMsg:TZT_MENU_EditUserStock wParam:0 lParam:0];
        }
            break;
        case MENU_HQ_UserStock*2+2://新闻
        {
            if (!_bHidenNineGrid)
            {
                _bHidenNineGrid = YES;
                [self LoadLayoutViewAnimated];
            }
            _pWebView.hidden = NO;
            NSString *strCode = [tztUserStock GetNSUserStock:NO];
            NSString *strURL = [NSString stringWithFormat:@"/zlcftajax/ggzx/message.htm?stockCode=%@&istabShow=0&content=xinwen",strCode];
            strURL = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [_pWebView setWebURL:strURL];
        }
            break;
        case MENU_HQ_UserStock*2+3://公告
        {
            if (!_bHidenNineGrid)
            {
                _bHidenNineGrid = YES;
                [self LoadLayoutViewAnimated];
            }
            _pWebView.hidden = NO;
            NSString *strCode = [tztUserStock GetNSUserStock:NO];
            NSString *strURL = [NSString stringWithFormat:@"/zlcftajax/ggzx/message.htm?stockCode=%@&istabShow=0&content=gonggao",strCode];
            strURL = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [_pWebView setWebURL:strURL];
            
        }
            break;
        case MENU_HQ_UserStock*2+4://专家
        {
            if (!_bHidenNineGrid)
            {
                _bHidenNineGrid = YES;
                [self LoadLayoutViewAnimated];
            }
            _pWebView.hidden = NO;
            NSString *strCode = [tztUserStock GetNSUserStock:NO];
            NSString *strURL = [NSString stringWithFormat:@"/zlcftajax/ggzx/message.htm?stockCode=%@&istabShow=0&content=zhuanjia",strCode];
            strURL = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [_pWebView setWebURL:strURL];
            
        }
            break;
        case MENU_HQ_UserStock*2+5://微博
        {
            if (!_bHidenNineGrid)
            {
                _bHidenNineGrid = YES;
                [self LoadLayoutViewAnimated];
            }
            _pWebView.hidden = NO;
            NSString *strCode = [tztUserStock GetNSUserStock:NO];
            NSString *strURL = [NSString stringWithFormat:@"/zlcftajax/ggzx/message.htm?stockCode=%@&istabShow=0&content=weibo",strCode];
            strURL = [tztlocalHTTPServer getLocalHttpUrl:strURL];
            [_pWebView setWebURL:strURL];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)RequestDataWithMarketID:(NSString*)nsMarket
{
    BOOL bRequest = [self RequestDefaultMenuData:nsMarket];
    
    if (_nReportType == tztReportDAPANIndex)
    {
        _bHiddenTrendScroll = NO;
        _pBtnHiden.hidden = NO;
    }
    else
    {
        _bHiddenTrendScroll = YES;
        _pBtnHiden.hidden = YES;
    }
    
    [self LoadLayoutViewAnimated];
    if (bRequest)
    {
        [self RequestData:[self.nsReqAction intValue] nsParam_:self.nsReqParam];
        _pMenuView.hidden = YES;
    }
    else
    {
    }
}

//
-(void)RequestUserStockData
{
    //顶部标题栏switch选中
    if (_pTitle && _pTitle.pSwitch)
    {
        if (!_pTitle.pSwitch.on)
            _pTitle.pSwitch.on = YES;
    }
    if (_btnView)
    {
        id sender = [_btnView setBtnSelectWithFunctionID:MENU_HQ_UserStock];
        [self OnUFunctionBtnClick:sender];
    }
}

//直接打开大盘指数
-(void)RequestIndexData
{
    if (_pTitle && _pTitle.pSwitch)
    {
        if (_pTitle.pSwitch.on)
            _pTitle.pSwitch.on = NO;
    }
    //打开大盘指数
    if (_btnView)
    {
        id sender = [_btnView setBtnSelectWithFunctionID:MENU_HQ_Index];
        [self OnUFunctionBtnClick:sender];
    }
}

//直接打开排名
-(void)RequestReportData
{
    //顶部标题栏switch选中
    if (_pTitle && _pTitle.pSwitch)
    {
        if (_pTitle.pSwitch.on)
            _pTitle.pSwitch.on = NO;
    }
    //打开大盘指数
    if (_btnView)
    {
        id sender = [_btnView setBtnSelectWithFunctionID:MENU_HQ_Report];
        [self OnUFunctionBtnClick:sender];
    }
}

//直接打开板块
-(void)RequestBlockData
{
    //顶部标题栏switch选中
    if (_pTitle && _pTitle.pSwitch)
    {
        if (_pTitle.pSwitch.on)
            _pTitle.pSwitch.on = NO;
    }
    //打开大盘指数
    if (_btnView)
    {
        id sender = [_btnView setBtnSelectWithFunctionID:MENU_HQ_TopBlock];
        [self OnUFunctionBtnClick:sender];
    }
}

//直接打开资金流向
-(void)RequestFundFlowData
{
    //顶部标题栏switch选中
    if (_pTitle && _pTitle.pSwitch)
    {
        if (_pTitle.pSwitch.on)
            _pTitle.pSwitch.on = NO;
    }
    //打开大盘指数
    if (_btnView)
    {
        id sender = [_btnView setBtnSelectWithFunctionID:MENU_HQ_FundLiuxiang];
        [self OnUFunctionBtnClick:sender];
    }
}

-(void)tztGridView:(TZTUIBaseGridView *)gridView showEditUserStockButton:(int)show
{
    return;
    BOOL b = _pNineGridView.hidden;
    if (show == 1)//显示
    {
        if (!b)
            return;
     
        if (_pReportList.startindex > 1)
            return;
        
        _bHidenNineGrid = NO;
        _pNineGridView.hidden = FALSE;
        [self LoadLayoutViewAnimated];
    }
    else//隐藏
    {
        if (b)
            return;
        _bHidenNineGrid = YES;
        [self LoadLayoutViewAnimated];
    }
}
#pragma mark tztNineGridViewDelegate
-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    switch (cellData.cmdid)
    {
        case TZT_MENU_EditUserStock:
        {
            [TZTUIBaseVCMsg OnMsg:TZT_MENU_EditUserStock wParam:0 lParam:0];
        }
            break;
        case TZT_MENU_AddUserStock:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_HQ_SearchStock wParam:0 lParam:0];
        }
            break;
        default:
            break;
    }
}

-(void)tztGetAllGridData:(id)obj ayData_:(NSArray *)ayGridData bFirst_:(BOOL)bFirst
{
    return;
    if (obj == _pReportList && _nReportType == tztReportDAPANIndex)
    {
        if (_pIndexTrendScroll)
        {
            NSMutableArray *ayData = NewObject(NSMutableArray);
            for (int i = 0; i < [ayGridData count]; i++)
            {
                NSArray *ay = [ayGridData objectAtIndex:i];
                if (ay == NULL || [ay count] < 4)
                    continue;
                NSMutableArray *ayTempData = NewObject(NSMutableArray);
                [ayTempData addObject:[ay objectAtIndex:0]];
                [ayTempData addObject:[ay objectAtIndex:1]];
                [ayTempData addObject:[ay objectAtIndex:2]];
                [ayTempData addObject:[ay objectAtIndex:[ay count] - 1]];
                
                [ayData addObject:ayTempData];
                [ayTempData release];
            }
            [_pIndexTrendScroll setAyScrollData:ayData];
            [ayData release];
        }
    }
}
@end
