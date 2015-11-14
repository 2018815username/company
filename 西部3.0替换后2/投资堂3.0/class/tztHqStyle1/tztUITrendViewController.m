/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUITrendViewController
 * 文件标识：
 * 摘    要：   新分时展示方式
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013－12-11
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import "tztUITrendViewController.h"
#import "tztUIStockView.h"
enum
{
    tztInfoNews     = 1000, //新闻
    tztInfoGongGao,         //公告
    tztInfoYanBao,          //研报
    tztInfoZhuanJia,        //专家
    tztInfoWeiBo            //微博
};

@interface tztUITrendViewController ()
{
    //分时图信息
    tztUIStockView      *_pStockView;
    //资讯按钮view
    tztUIFunctionView   *_pBtnView;
    //web资讯展示view
    tztWebView          *_pWebView;
    //工具栏view
    UIView              *_pToolBar;
    UIButton            *_pMoreBtn;
    //可用高度
    CGFloat             _nValidHeight;
    //
    BOOL                _bHaveWarning;
    
    int                 _nToolType;
}
@property(nonatomic,retain)UIButton *pMoreBtn;
@end

@implementation tztUITrendViewController
@synthesize tztTableView = tztTableView;
@synthesize pListView   = _pListView;
@synthesize pMoreBtn = _pMoreBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setVcShowKind:tztvckind_Pop];
    [self LoadLayoutView];
    if (_pStockView)
    {
        CGRect rc = _pStockView.frame;
        [_pStockView onSetViewRequest:YES];
        _pStockView.frame = rc;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    
    int n = self.interfaceOrientation;
    //iOS8下用设备方向判断
//    if (IS_TZTIOS(8))
//    {
////        n = [UIDevice currentDevice].orientation;
////        if (n == UIDeviceOrientationFaceUp || n == UIDeviceOrientationFaceDown)
////            n =
//    }
    if(UIInterfaceOrientationIsLandscape(n /*self.interfaceOrientation*/))
    {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
        {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIInterfaceOrientationPortrait];
        }
    }
    [self LoadLayoutView];
    if (_pStockView)
    {
        CGRect rc = _pStockView.frame;
        [_pStockView onSetViewRequest:YES];
        _pStockView.frame = rc;
    }
    
    [self ShowHelperImageView];
    [self CheckWarningInfo];
}

-(void)ShowHelperImageView
{
    NSString* nsName = @"";
    if (IS_TZTIphone5)
        nsName = @"tzt_TrendHelper-568h@2x.png";
    else
        nsName = @"tzt_TrendHelper@2x.png";
    [tztUIHelperImageView tztShowHelperView:nsName forClass_:[NSString stringWithUTF8String:object_getClassName(self)]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_pStockView)
        [_pStockView onSetViewRequest:NO];
    
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    
    if (_pToolBar)
    {
        [_pToolBar removeFromSuperview];
        _pToolBar = nil;
    }
    if (self.pMoreBtn)
    {
        [self.pMoreBtn removeFromSuperview];
        self.pMoreBtn = nil;
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setPListView:(id)listView
{
    [_pListView release];
    _pListView = [listView retain];
}

-(void)LoadLayoutView
{
    self.view.backgroundColor = [UIColor colorWithTztRGBStr:@"34,34,34"];
    _tztBaseView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,34,34"];
    [self onSetTztTitleView:@"" type:TZTTitleDetail];
    if (self.pStockInfo && self.pStockInfo.stockCode && [self.pStockInfo.stockCode length] > 0)
    {
        if (self.pStockInfo.stockName)
            [_tztTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:self.pStockInfo.stockName];
        else
            [_tztTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:@""];
    }
    
    self.tztTitleView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,34,34"];
    int nToolHeight = 49;
    
    CGRect rcFrame = _tztBounds;//self.view.bounds;
    
    CGRect rcTable = _tztBounds;//self.view.bounds;
    rcTable.origin.y += _tztTitleView.frame.size.height + _tztTitleView.frame.origin.y;
    rcTable.size.height -= (_tztTitleView.frame.size.height + _tztTitleView.frame.origin.y + nToolHeight);
    
    CGRect rcTool = _tztBounds;//self.view.bounds;
    rcTool.origin.y = rcTable.origin.y + rcTable.size.height;
    rcTool.size.height = nToolHeight;
    
    _nValidHeight = rcFrame.size.height - _tztTitleView.frame.size.height - _tztTitleView.frame.origin.y - rcTool.size.height;
    
    if (_tztTableView == nil)
    {
        _tztTableView = [[UITableView alloc] initWithFrame:rcTable style:UITableViewStylePlain];
        _tztTableView.delegate = self;
        _tztTableView.dataSource = self;
        _tztTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tztTableView.bounces = NO;
        _tztTableView.backgroundColor = [UIColor clearColor];
        _tztTableView.delaysContentTouches = NO;
        _tztTableView.canCancelContentTouches = NO;
        [_tztBaseView addSubview:_tztTableView];
        [_tztTableView release];
    }
    else
    {
        _tztTableView.frame = rcTable;
    }
    
    [self CreateToolBar:rcTool];
    
//    [_tztBaseView bringSubviewToFront:_pToolBar];
}

-(void)CreateToolBar:(CGRect)rcFrame
{
    /*
     
     */
    CGRect rc = CGRectMake(0, _tztBounds.size.height - rcFrame.size.height, _tztBounds.size.width, rcFrame.size.height);
    /*
    UIView *pView = [[TZTAppObj getShareInstance].rootTabBarController.tabBar viewWithTag:0x8989];
    if (pView && (pView != _pToolBar))
    {
        [pView removeFromSuperview];
        pView = nil;
    }
    */
    if (_pToolBar == nil)
    {
        _pToolBar = [[UIView alloc] initWithFrame:rc];
        _pToolBar.tag = 0x8989;
        _pToolBar.backgroundColor = [UIColor tztThemeBackgroundColorTitleTrend];
        [_tztBaseView addSubview:_pToolBar];
//        [[TZTAppObj getShareInstance].rootTabBarController.tabBar addSubview:_pToolBar];
        [_pToolBar release];
    }
    else
    {
        _pToolBar.frame = rc;
    }
    
    BOOL bSupportRZRQ = ([[g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_FenShiSupportRZRQ] intValue] > 0 );
    if (!MakeHKMarket(self.pStockInfo.stockType) && !([self.pStockInfo.stockCode hasPrefix:@"H"] && [self.pStockInfo.stockCode hasPrefix:@"H"]) && bSupportRZRQ)
    {
        CGRect rcMore = _pToolBar.bounds;
        rcMore.size.width = 40;
        rcMore.origin.x = _pToolBar.bounds.size.width - rcMore.size.width;
        if (self.pMoreBtn == nil)
        {
            self.pMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.pMoreBtn.frame = rcMore;
            self.pMoreBtn.tag = 2222;
            [self.pMoreBtn setTitle:@"• • •" forState:UIControlStateNormal];
            [self.pMoreBtn setBackgroundImage:[UIImage imageTztNamed:@"tztTrendToolBtn.png"] forState:UIControlStateNormal];
            [_pToolBar addSubview:self.pMoreBtn];
            [self.pMoreBtn addTarget:self
                              action:@selector(OnToolbarMenuClick:)
                    forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            self.pMoreBtn.frame = rcMore;
        }
    }
    if (!bSupportRZRQ)
    {
        _nToolType = 1;
    }
    
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    if (MakeHKMarket(self.pStockInfo.stockType) || [self.pStockInfo.stockCode hasPrefix:@"H"] || [self.pStockInfo.stockCode hasPrefix:@"H"])
    {
        _nToolType = 1;
        [pAy addObject:@"买|16010|tztTrendToolBtn.png"];
        [pAy addObject:@"卖|16011|tztTrendToolBtn.png"];
        [pAy addObject:@"撤|16012|tztTrendToolBtn.png"];
    }
    else
    {
        BOOL bSupportWarning = FALSE;
        NSString* str = [g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_SupportWarning];
        if (str.length > 0)
            bSupportWarning = ([str intValue] > 0);
        
        _nToolType = 0;
        if (!bSupportRZRQ)
            _nToolType = 1;
        if ([tztTechSetting getInstance].nMenuType == 1)
        {
            [pAy addObject:@"融买|12310|tztTrendToolBtn.png|TZTArrow_Up.png"];
            [pAy addObject:@"融卖|12311|tztTrendToolBtn.png|TZTArrow_Up.png"];
            [pAy addObject:@"撤单|12340|tztTrendToolBtn.png"];
            
            if (bSupportWarning)
            {
                if (_bHaveWarning)
                    [pAy addObject:@"|10419|tztTrendToolBtn.png|tztWarningSel.png"];
                else
                    [pAy addObject:@"|10419|tztTrendToolBtn.png|tztWarning.png"];
            }
        }
        else
        {
            [pAy addObject:@"买|12310|tztTrendToolBtn.png"];
            [pAy addObject:@"卖|12311|tztTrendToolBtn.png"];
            [pAy addObject:@"撤|12340|tztTrendToolBtn.png"];
            if (bSupportWarning)
            {
                if (_bHaveWarning)
                    [pAy addObject:@"|10419|tztTrendToolBtn.png|tztWarningSel.png"];
                else
                    [pAy addObject:@"|10419|tztTrendToolBtn.png|tztWarning.png"];
            }
        }
    }
    
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy
                                           target:self
                                          withSEL:@selector(OnToolbarMenuClick:)
                                          forView:_pToolBar
                                          height_:rcFrame.size.height
                                           width_:(_nToolType == 1 ? _pToolBar.frame.size.width :_pToolBar.frame.size.width - 40)];
    [pAy release];
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
//    if ([yesImage length] < 1)
//    {
//        yesImage = @"tztMenuSelect.png";
//    }
    pSwitch.yesImage = [UIImage imageTztNamed:yesImage];
    pSwitch.noImage = [UIImage imageTztNamed:noImage];
    
    [pSwitch addTarget:self
                action:@selector(OnUFunctionBtnClick:)
      forControlEvents:UIControlEventTouchUpInside];
    return [pSwitch autorelease];
}

-(void)hiddenMoreView
{
    tztToolbarMoreView *pMoreView = (tztToolbarMoreView*)[self.view viewWithTag:0x7878];
    if (pMoreView != NULL)
    {
        [pMoreView hideMoreBar];
    }
}

-(void)showMoreMenu:(NSInteger)nType
{
    tztToolbarMoreView *pMoreView = (tztToolbarMoreView*)[self.view viewWithTag:0x7878];
    if (pMoreView == NULL)
    {
        NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
        if (nType == 0)
        {
//            [pAy addObject:@"|行情预警|10419|"];
            if ([tztTechSetting getInstance].nMenuType == 0)
                [pAy addObject:@"|切换为融资融券交易|-1|"];
            else if ([tztTechSetting getInstance].nMenuType == 1)
                [pAy addObject:@"|切换为普通交易|-1|"];
        }
        else if(nType == MENU_JY_PT_Buy)
        {
            [pAy addObject:@"|担保买入|15010|"];
            [pAy addObject:@"|融资买入|15012|"];
            [pAy addObject:@"|买券还券|15014|"];
        }
        else if (nType == MENU_JY_PT_Sell)
        {
            [pAy addObject:@"|担保卖出|15011|"];
            [pAy addObject:@"|融券卖出|15013|"];
            [pAy addObject:@"|卖券还款|15015|"];
        }
            
        pMoreView = [[tztToolbarMoreView alloc] initWithShowType:tztShowType_List];
        pMoreView.tag = 0x7878;
        if (nType == 0)
        {
            pMoreView.nPosition = tztToolbarMoreViewPositionBottom | tztToolbarMoreViewPositionRight;
            pMoreView.szOffset = CGSizeMake(0, _pToolBar.frame.size.height);
        }
        else if(nType == MENU_JY_PT_Buy)
        {
            pMoreView.nPosition = tztToolbarMoreViewPositionBottom | tztToolbarMoreViewPositionLeft;
            pMoreView.szOffset = CGSizeMake(0, _pToolBar.frame.size.height);
        }
        else if (nType == MENU_JY_PT_Sell)
        {
            pMoreView.nPosition = tztToolbarMoreViewPositionBottom | tztToolbarMoreViewPositionLeft;
            pMoreView.szOffset = CGSizeMake(70, _pToolBar.frame.size.height);
        }
        
        pMoreView.fCellHeight = 39;
        pMoreView.nColCount = 1;
        
        if (nType == 0)
            pMoreView.fMenuWidth = 190;
        else
            pMoreView.fMenuWidth = 120;
        
        [pMoreView SetAyGridCell:pAy];
        pMoreView.bgColor = [UIColor colorWithTztRGBStr:@"72,72,72"];//[UIColor colorWithPatternImage:[UIImage imageTztNamed:@"tztPopMenuBack.png"]];
        pMoreView.frame = _tztBounds;// self.view.frame;
        pMoreView.pDelegate = self;
        [_tztBaseView addSubview:pMoreView];
        [pMoreView release];
    }
    else
    {
        [pMoreView removeFromSuperview];
    }
}

-(void)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    
    [self hiddenMoreView];
    NSInteger nTag = pBtn.tag;
    switch (nTag)
    {
        case MENU_JY_HK_Buy:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_JY_HK_Buy wParam:(NSUInteger)self.pStockInfo lParam:1];
        }
            break;
        case MENU_JY_HK_Sell:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_JY_HK_Sell wParam:(NSUInteger)self.pStockInfo lParam:1];
        }
            break;
        case MENU_JY_HK_WithDraw:
        {
            [TZTUIBaseVCMsg OnMsg:MENU_JY_HK_WithDraw wParam:(NSUInteger)self.pStockInfo lParam:1];
        }
            break;
        case MENU_JY_PT_Buy:
        {
            if ([tztTechSetting getInstance].nMenuType == 0)
                [self tztQuickBuySell:sender nType_:tztBtnTradeBuyTag];
            else
            {
                //
                [self showMoreMenu:nTag];
            }
        }
            break;
        case MENU_JY_PT_Sell:
        {
            if ([tztTechSetting getInstance].nMenuType == 0)
                [self tztQuickBuySell:sender nType_:tztBtnTradeSellTag];
            else
            {
                [self showMoreMenu:nTag];
            }
        }
            break;
        case MENU_JY_PT_Withdraw:
        {
            [self tztQuickBuySell:sender nType_:tztBtnTradeDrawTag];
        }
            break;
        case 2222://更多more
        {
            [self showMoreMenu:0];
        }
            break;
        case HQ_MENU_SearchStock:
        {
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_SearchStock wParam:0 lParam:0];
        }
            break;
        case MENU_SYS_UserWarning:
        {
            /**
             *  wry  预警参数
             *
             *  @param NSMutableDictionary <#NSMutableDictionary description#>
             *
             *  @return <#return value description#>
             */
//            NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
//            [pDict setTztObject:self.pStockInfo forKey:@"tztStockInfo"];
            [TZTUIBaseVCMsg OnMsg:MENU_SYS_UserWarning wParam:(NSUInteger)self.pStockInfo lParam:0];
        }
            break;
        default:
            break;
    }
}

-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    switch (cellData.cmdid)
    {
        case -1:
        {
            int nMenuType = [tztTechSetting getInstance].nMenuType;
            if (nMenuType == 0)
                nMenuType = 1;
            else if (nMenuType == 1)
                nMenuType = 0;
            [tztTechSetting getInstance].nMenuType = nMenuType;
            [[tztTechSetting getInstance] SaveData];
            CGRect rcFrame = _pToolBar.frame;
            if (_pToolBar)
            {
                [_pToolBar removeFromSuperview];
                _pToolBar = nil;
            }
            if (self.pMoreBtn)
            {
                [self.pMoreBtn removeFromSuperview];
                self.pMoreBtn = nil;
            }
            [self CreateToolBar:rcFrame];
        }
            break;
        default:
        {
            [TZTUIBaseVCMsg OnMsg:cellData.cmdid wParam:(NSUInteger)self.pStockInfo lParam:0];
        }
            break;
    }
}

-(void)OnUFunctionBtnClick:(id)sender
{
     UIButton *pBtn = (UIButton*)sender;
    
    if (_pBtnView)
        [_pBtnView setBtnState:sender];
    NSString* strURL = @"http://www.baidu.com";
    switch (pBtn.tag)
    {
        case tztInfoGongGao:
        {
            strURL = @"http://news.baidu.com";
        }
            break;
        case tztInfoYanBao:
        {
            strURL = @"http://baike.baidu.com";
        }
            break;
        case tztInfoZhuanJia:
        {
            strURL = @"http://zhidao.baidu.com";
        }
            break;
        case tztInfoWeiBo:
        {
            strURL = @"http://image.baidu.com";
        }
            break;
        case tztInfoNews:
        default:
            break;
    }
    if (_pWebView)
    {
        [_pWebView setWebURL:strURL];
    }
    
    if (_tztTableView)
    {
        [_tztTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
                                  atScrollPosition: UITableViewScrollPositionBottom
                                          animated:YES];
    }
}

-(void)GetToolBtn:(CGRect)rcFrame
{
    NSMutableArray *ayBtn = NewObjectAutoD(NSMutableArray);
    tztUISwitch *pBtnNews = [self CreateSwitchButton:tztInfoNews
                                           yesTitle_:@"新闻"
                                           yesImage_:@"TZTTabButtonSelBg.png"
                                            noTitle_:@"新闻"
                                            noImage_:@"TZTTabButtonBg.png"];
    [ayBtn addObject:pBtnNews];
    
    tztUISwitch *pBtnNotice = [self CreateSwitchButton:tztInfoGongGao
                                             yesTitle_:@"公告"
                                             yesImage_:@"TZTTabButtonSelBg.png"
                                              noTitle_:@"公告"
                                              noImage_:@"TZTTabButtonBg.png"];
    [ayBtn addObject:pBtnNotice];
    
    tztUISwitch *pBtnYB = [self CreateSwitchButton:tztInfoYanBao
                                             yesTitle_:@"研报"
                                             yesImage_:@"TZTTabButtonSelBg.png"
                                              noTitle_:@"研报"
                                              noImage_:@"TZTTabButtonBg.png"];
    [ayBtn addObject:pBtnYB];
    
    
    tztUISwitch *pBtnPro = [self CreateSwitchButton:tztInfoZhuanJia
                                          yesTitle_:@"专家"
                                          yesImage_:@"TZTTabButtonSelBg.png"
                                           noTitle_:@"专家"
                                           noImage_:@"TZTTabButtonBg.png"];
    [ayBtn addObject:pBtnPro];
    
    tztUISwitch *pBtnWeiBo = [self CreateSwitchButton:tztInfoWeiBo
                                            yesTitle_:@"微博"
                                            yesImage_:@"TZTTabButtonSelBg.png"
                                             noTitle_:@"微博"
                                             noImage_:@"TZTTabButtonBg.png"];
    [ayBtn addObject:pBtnWeiBo];
    
    if (ayBtn != NULL)
        _pBtnView.ayBtnData = ayBtn;
    _pBtnView.fixBtn = nil;
    _pBtnView.frame = rcFrame;
}

//updat by wry 201506009
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"didRotateFromInterfaceOrientation");
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        
        NSInteger currentPage =(long)_pStockView.pMutilViews.nCurPage;
        NSInteger nMsgType = HQ_MENU_HoriTrend;
        if (currentPage ==0 ) {
        nMsgType =HQ_MENU_HoriTrend;
        }else if(currentPage ==1 ){
            nMsgType =  HQ_MENU_HoriTech;
        }
        
        [TZTUIBaseVCMsg OnMsg:nMsgType wParam:(NSUInteger)self.pStockInfo lParam:(NSUInteger)self.pListView];
        
//        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
//        {
//            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)UIInterfaceOrientationPortrait];
//        }
    }
    else
    {
        if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation) && UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            CGRect frame = self.view.frame;
            if(frame.size.width > frame.size.height)
                self.view.frame = CGRectMake(frame.origin.y, frame.origin.x, frame.size.height+TZTStatuBarHeight, frame.size.width-TZTStatuBarHeight);
            [self LoadLayoutView];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation) && UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        int nMsgType = HQ_MENU_HoriTech;
        [TZTUIBaseVCMsg OnMsg:nMsgType wParam:(NSUInteger)self.pStockInfo lParam:(NSUInteger)_pListView];
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
        {
            [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)interfaceOrientation];
        }
    }
    return (UIInterfaceOrientationPortrait == interfaceOrientation);
}


- (NSInteger)getIndexOfStockInfo:(NSMutableArray*)stockArray
{
    for (NSInteger i = 0; i < stockArray.count; i++)
    {
        id dic = [stockArray objectAtIndex:i];
        if (dic)
        {
            if ([dic isKindOfClass:[NSDictionary class]])
            {
                id dictCode = [dic objectForKey:@"Code"];
                
                if (dictCode == NULL)
                    continue;
                NSString* strCode = @"";
                if ([dictCode isKindOfClass:[NSDictionary class]])
                    strCode =  [dictCode objectForKey:@"value"];
                else if ([dictCode isKindOfClass:[NSString class]])
                    strCode = dictCode;
                if (strCode.length < 1)
                    continue;
                int nStockType = [[dic objectForKey:@"StockType"] intValue];
                
                if (([strCode caseInsensitiveCompare:self.pStockInfo.stockCode] == NSOrderedSame) &&
                    (nStockType == self.pStockInfo.stockType)) {
                    return i;
                }
            }
            else if ([dic isKindOfClass:[tztStockInfo class]])
            {
                tztStockInfo *stock = (tztStockInfo*)dic;
                if ([stock.stockCode isEqualToString:self.pStockInfo.stockCode]
                    && stock.stockType == self.pStockInfo.stockType)
                    return i;
            }
        }
    }
    return -1;
}

- (tztStockInfo*)getStockInfos:(NSMutableArray*)stockArray direction_:(int)nDirection
{
    NSInteger count = [stockArray count];
    if (count == 0) {
        return NULL;
    }
    NSInteger i = [self getIndexOfStockInfo:stockArray];
    
//    int pre, next;
    
    if (nDirection == 0)
    {
        i--;
        if (i < 0)
            i = count - 1;
    }
    else
    {
        i++;
        if (i > count -1)
            i = 0;
    }
    return [self getStockInfoFromDic:[stockArray objectAtIndex:i]];
//    if (pre >= 0 && pre < [stockArray count])
//        return [self getStockInfoFromDic:[stockArray objectAtIndex:pre]];
//    else
//        return NULL;
//    if (next >= 0 && next < [stockArray count])
//        return [self getStockInfoFromDic:[stockArray objectAtIndex:next]];
//    else
//        return NULL;
}

- (tztStockInfo *)getStockInfoFromDic:(id)dic
{
    if (dic && [dic isKindOfClass:[tztStockInfo class]])
        return dic;
    id dictCode = [dic objectForKey:@"Code"];
    id dictName = [dic objectForKey:@"Name"];
    int nStockType = [[dic objectForKey:@"StockType"] intValue];
    if (dictCode == NULL)
        return NULL;
    
    NSString* strCode = @"";
    NSString* strName = @"";
    if ([dictCode isKindOfClass:[NSDictionary class]])
    {
        strCode = [dictCode objectForKey:@"value"];
    }
    else if ([dictCode isKindOfClass:[NSString class]])
        strCode = dictCode;
    
    if (strCode.length < 1)
        return NULL;
    
    if ([dictName isKindOfClass:[NSDictionary class]])
    {
        strName = [dictName objectForKey:@"value"];
    }
    else if ([dictName isKindOfClass:[NSString class]])
        strName = dictName;
    
    tztStockInfo *stockInfo = [[[tztStockInfo alloc] init] autorelease];
    stockInfo.stockCode = strCode;
    stockInfo.stockName = strName;
    stockInfo.stockType = nStockType;
    
    return stockInfo;
}

//后一个股票
-(void)OnBtnPreStock:(id)sender
{
    if (_pListView )
    {
        if ([_pListView isKindOfClass:[tztReportListView class]])
        {
            NSArray *pAy = [(tztReportListView*)_pListView tztGetPreStock];
            if(pAy == NULL)
                return;
            NSInteger nCount = [pAy count];
            if (nCount < 1)
                return;
            
            TZTGridData* valuedata = [pAy objectAtIndex:nCount-1];
            NSString* strCode = valuedata.text;
            TZTGridData* namedata = [pAy objectAtIndex:0];
            NSString* strName = namedata.text;
            TZTGridData* typedata = [pAy objectAtIndex:1];
            NSString* strType = typedata.text;
            
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            pStock.stockName = [NSString stringWithFormat:@"%@", strName];
            pStock.stockType = [strType intValue];
//            [tztUserStock AddRecentStock:pStock];
            [self setStockInfo:pStock nRequest_:1];
        }
        else if ([_pListView isKindOfClass:[NSArray class]])
        {
            tztStockInfo *pStock = [self getStockInfos:_pListView direction_:0];
            if (pStock == NULL)
                return;
//            [tztUserStock AddRecentStock:pStock];
            [self setStockInfo:pStock nRequest_:1];
        }
    }
}

//前一个股票
-(void)OnBtnNextStock:(id)sender
{
    if (_pListView)
    {
        if ([_pListView isKindOfClass:[tztReportListView class]])
        {
            NSArray *pAy = [(tztReportListView*)_pListView tztGetNextStock];
            if(pAy == NULL)
                return;
            NSInteger nCount = [pAy count];
            if (nCount < 1)
                return;
            TZTGridData* valuedata = [pAy objectAtIndex:nCount-1];
            NSString* strCode = valuedata.text;
            TZTGridData* namedata = [pAy objectAtIndex:0];
            NSString* strName = namedata.text;
            TZTGridData* typedata = [pAy objectAtIndex:1];
            NSString* strType = typedata.text;
            
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
            pStock.stockName = [NSString stringWithFormat:@"%@", strName];
            pStock.stockType = [strType intValue];
            
            [tztUserStock AddRecentStock:pStock];
            [self setStockInfo:pStock nRequest_:1];
        }
        else if ([_pListView isKindOfClass:[NSArray class]])
        {
            tztStockInfo *pStock = [self getStockInfos:_pListView direction_:1];
            if (pStock == NULL)
                return;
            [self setStockInfo:pStock nRequest_:1];
        }
    }
}

-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo*)pStock
{
    self.pStockInfo = pStock;
    if (self.pStockInfo && self.pStockInfo.stockCode)
    {
        if (_tztTitleView)
        {
            [_tztTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:self.pStockInfo.stockName];
        }
    }
    self.tztTitleView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,34,34"];
}

-(void)setStockInfo:(tztStockInfo*)pStock nRequest_:(int)nRequest
{
    self.pStockInfo = pStock;
    
    if (_pToolBar)
    {
        if ((MakeHKMarket(self.pStockInfo.stockType) && _nToolType != 1)
             || (!MakeHKMarket(self.pStockInfo.stockType) && _nToolType != 0))
        {
            CGRect rcFrame = _pToolBar.frame;
            if (_pToolBar)
            {
                [_pToolBar removeFromSuperview];
                _pToolBar = nil;
            }
            if (self.pMoreBtn)
            {
                [self.pMoreBtn removeFromSuperview];
                self.pMoreBtn = nil;
            }
            [self CreateToolBar:rcFrame];
        }
    }
    if (self.pStockInfo && self.pStockInfo.stockCode)
    {
        if (_tztTitleView)
        {
            [_tztTitleView setCurrentStockInfo:self.pStockInfo.stockCode nsName_:self.pStockInfo.stockName];
        }
        if (_pStockView)
        {
            [_pStockView setStockInfo:self.pStockInfo Request:1];
        }
        [self CheckWarningInfo];
    }
    self.tztTitleView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,34,34"];
}


-(void)tzthqView:(id)hqView RequestHisTrend:(tztStockInfo *)pStock nsHisDate:(NSString *)nsHisDate
{
    NSMutableDictionary* pDict = [[NSMutableDictionary alloc] init];
    [pDict setTztObject:hqView forKey:@"tztDelegate"];
    [pDict setTztObject:pStock forKey:@"tztStock"];
    [pDict setTztObject:nsHisDate forKey:@"tztHisDate"];
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_HisTrend wParam:(NSUInteger)pDict lParam:0];
    DelObject(pDict);
}

-(void)tztQuickBuySell:(id)send nType_:(NSInteger)nType
{
    //获取当前的股票代码
    tztStockInfo *pStock = self.pStockInfo;
    switch (nType)
    {
        case tztBtnStockTag://持仓
        {
            [TZTUIBaseVCMsg OnMsg:WT_QUERYGP wParam:0 lParam:1];
        }
            break;
        case tztBtnTradeBuyTag://快买
        {
            [TZTUIBaseVCMsg OnMsg:WT_BUY wParam:(NSUInteger)pStock lParam:1];
        }
            break;
        case tztBtnTradeSellTag://快卖
        {
            [TZTUIBaseVCMsg OnMsg:WT_SALE wParam:(NSUInteger)pStock lParam:1];
        }
            break;
        case tztBtnTradeDrawTag://快撤
        {
            if ([tztTechSetting getInstance].nMenuType == 0)
                [TZTUIBaseVCMsg OnMsg:WT_WITHDRAW wParam:0 lParam:1];
            else
                [TZTUIBaseVCMsg OnMsg:MENU_JY_RZRQ_Withdraw wParam:0 lParam:1];
        }
            break;
        case tztBtnWarningTag://预警
        {
            [TZTUIBaseVCMsg OnMsg:HQ_MENU_YUJING wParam:(NSUInteger)pStock lParam:0];
        }
            break;
        default:
            break;
    }
}

#pragma 表格处理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*分两个section，上部是分时图，下部是资讯
     */
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /*定制表头*/
    if (section == 0)
        return nil;
    CGRect rc = CGRectMake(0, 0, _tztBounds.size.width, 40);
    if (_pBtnView == nil)
    {
        _pBtnView = [[tztUIFunctionView alloc] init];
        _pBtnView.nFixBtnWidth = 0;
        _pBtnView.nArrowWidth = 0;
        _pBtnView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"tztMenuBg.png"]];
        [self GetToolBtn:rc];
    }
    else
    {
        _pBtnView.frame = rc;
    }
    return _pBtnView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    /*表头高度*/
    if (section == 0)
        return 0;
    else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _nValidHeight;
    if (indexPath.section == 0)
    {
        if (_nValidHeight <= 0)
            return 300;
        return _nValidHeight - 20;
    }
    else
        return 600;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     section内数据行数
     */
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*定制行*/
    static NSString* CellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CGRect rc = CGRectMake(0, 0, tableView.frame.size.width, /*300*/tableView.frame.size.height);
    switch (indexPath.section)
    {
        case 0:
        {
//            rc.size.height = _nValidHeight - 20;
            if (indexPath.row == 0)//上面是分时图
            {
                if (_pStockView == nil)
                {
                    _pStockView = [[tztUIStockView alloc] init];
                    _pStockView.tztdelegate = self;
                    _pStockView.frame = CGRectMake(0, 0, rc.size.width, rc.size.height);
                    [cell.contentView addSubview:_pStockView];
                    [_pStockView release];
                }
                if (self.pStockInfo && self.pStockInfo.stockCode && self.pStockInfo.stockCode.length > 0)
                {
                    [_pStockView setStockInfo:self.pStockInfo Request:1];
                }
                cell.frame = rc;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0)
            {
                rc.size.height = 600;
                if (_pWebView == nil)
                {
                    _pWebView = [[tztWebView alloc] init];
                    _pWebView.tztDelegate = self;
                    _pWebView.frame = rc;
                    _pWebView.backgroundColor = [tztTechSetting getInstance].backgroundColor;
                    [_pWebView setWebURL:@"http://www.baidu.com"];
                    [cell.contentView addSubview:_pWebView];
                    [_pWebView release];
                }
//                _pWebView.frame
                cell.frame = rc;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

//检测预警设置
-(void)CheckWarningInfo
{
    BOOL bSupportWarning = FALSE;
    NSString* str = [g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_SupportWarning];
    if (str.length > 0)
        bSupportWarning = ([str intValue] > 0);
    if (!bSupportWarning)
        return;
    
    if (self.pStockInfo == NULL || self.pStockInfo.stockCode == NULL || self.pStockInfo.stockCode.length < 1)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqno++;
    if (_ntztReqno >= UINT16_MAX)
        _ntztReqno = 1;
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqno);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    
    NSString *strUniqueId = [tztKeyChain load:tztUniqueID];
    if (strUniqueId)
        [pDict setTztObject:strUniqueId forKey:@"uniqueid"];
    [pDict setTztObject:self.pStockInfo.stockCode forKey:@"stockcode"];
    
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"44810" withDictValue:pDict];
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqno])
        return 0;
    
    if ([pParse IsAction:@"44810"])
    {
        if ([pParse GetErrorNo] < 0)
        {
            static int n = 0;
            
            UIView *pView = [_pToolBar viewWithTag:MENU_SYS_UserWarning];
            if (pView == NULL || ![pView isKindOfClass:[UIButton class]])
                return 0;
            
            UIView *pImgView = [pView viewWithTag:0x6765];
            if (pImgView == NULL || ![pImgView isKindOfClass:[UIImageView class]])
                return 0;
            
            if (n%2 == 0)//存在
            {
                _bHaveWarning = TRUE;
                [((UIImageView*)pImgView) setImage:nil];
                [((UIImageView*)pImgView) setImage:[UIImage imageTztNamed:@"tztWarningSel.png"]];
            }
            else if (n%2 == 1)//不存在
            {
                _bHaveWarning = FALSE;
                [((UIImageView*)pImgView) setImage:nil];
                [((UIImageView*)pImgView) setImage:[UIImage imageTztNamed:@"tztWarning.png"]];
            }
            n++;
            TZTLogInfo(@"44810:%@", [pParse GetErrorMessage]);
            return 0;
        }
        
        NSString* isExist = [pParse GetByName:@"exist"];
        if (isExist == NULL)
            return 0;
        
        UIView *pView = [_pToolBar viewWithTag:MENU_SYS_UserWarning];
        if (pView == NULL || ![pView isKindOfClass:[UIButton class]])
            return 0;
        
        UIView *pImgView = [pView viewWithTag:0x6765];
        if (pImgView == NULL || ![pImgView isKindOfClass:[UIImageView class]])
            return 0;
        
        if ([isExist intValue] == 1)//存在
        {
            _bHaveWarning = TRUE;
            [((UIImageView*)pImgView) setImage:nil];
            [((UIImageView*)pImgView) setImage:[UIImage imageTztNamed:@"tztWarningSel.png"]];
        }
        else if ([isExist intValue] == 0)//不存在
        {
            _bHaveWarning = FALSE;
            [((UIImageView*)pImgView) setImage:nil];
            [((UIImageView*)pImgView) setImage:[UIImage imageTztNamed:@"tztWarning.png"]];
        }
    }
    return 0;
}

-(void)tztHqView:(id)hqView setTitleStatus:(NSInteger)nStatus andStockType_:(NSInteger)nStockType
{
    if (self.tztTitleView)
    {
        [self.tztTitleView setStockDetailInfo:nStockType nStatus:nStatus];
        self.tztTitleView.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
    }
}
@end
