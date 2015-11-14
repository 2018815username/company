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
#import "tztUIQuoteViewControllerStyle2.h"
#import "tztManagerUserStock.h"
//新版
#import "TZTUserStockTableView.h"
#import "tztStockReportView.h"
#import "tztUserInfoView.h"

@interface tztUIQuoteViewControllerStyle2 ()<tztTagViewDelegate,tztSegmentViewDelegate,tztMutilScrollViewDelegate>
{
    BOOL    _bHidenNineGrid;
    
    UIView  *_pLeftTopView;
    int    _nShowed;
    tztMutilScrollView  *_pMultiView;
    
    UIView              *_pViewReport;
    
    NSInteger             _nCurrentIndex;
    TZTSegSectionView *_tagView;
}

@property(nonatomic,retain)tztMutilScrollView *pMultiView;

@property(nonatomic,retain)UIView   *pLeftTopView;

@property(nonatomic,retain)UIView   *pCurrentView;

/**
 *	@brief	自选
 */
//@property(nonatomic,retain) TZTUserStockTableView   *userTableView;
 /**
 *	@brief	市场
 */
@property(nonatomic,retain) tztStockReportView      *reportTableView;

@property(nonatomic,retain) tztUserInfoView         *userInfoView;
 /**
 *	@brief	对应view数组
 */
@property(nonatomic,retain) NSMutableArray          *ayViews;
@end

@implementation tztUIQuoteViewControllerStyle2

@synthesize nReportType = _nReportType;
@synthesize pTitle = _pTitle;
@synthesize pLeftTopView = _pLeftTopView;
//@synthesize userTableView = _userTableView;
@synthesize pMultiView = _pMultiView;
@synthesize ayViews = _ayViews;
@synthesize userInfoView = _userInfoView;
@synthesize pCurrentView = _pCurrentView;

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
    _tztBaseView.backgroundColor = [tztTechSetting getInstance].backgroundColor;
    _nSegIndex = 0;
    _nPreIndex = -1;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMessage:) name:@"tztGetPushMessage" object:nil];
    if (_nReportType == tztReportUserStock)
        _nCurrentIndex = 1;
    else
        _nCurrentIndex = 0;
//    _nCurrentIndex = 1;
    [self LoadLayoutView];
}

-(void)GetMessage:(NSNotification*)noti
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self GetMessage:nil];
    
    if (_userInfoView && !_userInfoView.hidden)
    {
        [self.userInfoView onSetViewRequest:YES];
        [self.userInfoView setStockCode:[tztUserStock GetNSUserStock] Request:1];
    }
    
    if (_reportTableView && !_reportTableView.hidden)
    {
        [self.reportTableView onSetViewRequest:YES];
        [self.reportTableView OnRequestData];
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
    NSString* nsName = @"";
    if (IS_TZTIphone5)
        nsName = @"tzt_MarketHelp-568h@2x.png";
    else
        nsName = @"tzt_MarketHelp@2x.png";
    [tztUIHelperImageView tztShowHelperView:nsName forClass_:@"tztQuoteViewController-DAPAN"];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //不显示，请从通讯数组中移除，不显示的界面不要去发送数据
    if (_userInfoView)
        [_userInfoView onSetViewRequest:NO];
    if (_reportTableView)
        [_reportTableView onSetViewRequest:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;//self.view.bounds;
    
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    
    /*
     标题区域
     */
    CGRect rcTitle = rcFrame;
    rcTitle.size.height = TZTToolBarHeight;
    if (IS_TZTIOS(7))
        rcTitle.size.height += TZTStatuBarHeight;
    if (_pTitle == NULL)
    {
        _pTitle = [[tztUINewTitleView alloc] init];
        
        _pTitle.pLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pTitle.pLeftBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo.png"] forState:UIControlStateNormal];
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
        _pTitle.frame = rcTitle;
    }
    
    //外部自己设置颜色    中信版本 “市场|自选股” 字体颜色修改
    [_pTitle.pSwitch setSliderTextColor:[UIColor colorWithRGBULong:0xF3B2B2]];
    [_pTitle.pSwitch setTextColor:[UIColor colorWithRGBULong:0xFAFAFA]];
    [_pTitle.pSwitch setMiddleSeperator:[UIImage tztCreateImageWithColor:[UIColor whiteColor]]];
    
    NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
    [pAy addObject:@"12002|市场 "];
    [pAy addObject:@"12100|自选股"];
    
    if (_nReportType == tztReportUserStock)
    {
        [_pTitle setSelectSegmentIndex:1];
    }
    else
    {
        [_pTitle setSelectSegmentIndex:0];
    }
    
    [_pTitle setSegControlItems:pAy];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_pTitle];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_pTitle];
    
    rcFrame.origin = CGPointZero;
    rcFrame.origin.y += (_pTitle.frame.size.height + _pTitle.frame.origin.y);
    rcFrame.size.height -= (_pTitle.frame.size.height + _pTitle.frame.origin.y);
    
    if (_ayViews == NULL)
        _ayViews = NewObject(NSMutableArray);
    
    if (_reportTableView == NULL)
    {
        _reportTableView = [[tztStockReportView alloc] init];
        _reportTableView.frame = rcFrame;
        [_ayViews addObject:_reportTableView];
        [_reportTableView release];
    }
    
    if (_userInfoView == NULL)
    {
        _userInfoView = [[tztUserInfoView alloc] init];
        _userInfoView.frame = rcFrame;
        _userInfoView.tztDelegate = self;
        [_ayViews addObject:_userInfoView];
        [_userInfoView release];
    }
    
    if (_pMultiView == NULL)
    {
        _pMultiView = [[tztMutilScrollView alloc] init];
        _pMultiView.hidePagecontrol = YES;
        _pMultiView.bSupportLoop = NO;
        _pMultiView.bSupportLoop = NO;
        _pMultiView.tztdelegate = self;
        [_tztBaseView addSubview:_pMultiView];
        [_pMultiView release];
    }
    
    _pMultiView.pageViews = _ayViews;
    _pMultiView.nCurPage = _nCurrentIndex;
    _pMultiView.frame = rcFrame;
    
    CGRect rc = _tztBounds;
    rc.size.width = 20;
    rc.origin.y += _pTitle.frame.size.height;
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
    
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_pLeftTopView];
    [[TZTAppObj getShareInstance].rootTabBarController RefreshAddCustomsViews];
    [_tztBaseView bringSubviewToFront:_pTitle];
}

-(void)RequestUserStockData
{
    [self.pTitle setSelectSegmentIndex:1];
    [_pMultiView scrollToView:(self.pCurrentView ? self.pCurrentView : self.userInfoView) animated:UseAnimated];
}

-(void)tztNewTitleClick:(id)sender FuncionID_:(int)nFunctionID withParams_:(id)params
{
    CUCustomSwitch *seg = (CUCustomSwitch*)sender;
    _nSegIndex = (seg.on ? 0 : 1);
    switch (nFunctionID)
    {
        case MENU_HQ_UserStock:
        {
            [_pMultiView scrollToView:(self.pCurrentView ? self.pCurrentView : self.userInfoView) animated:UseAnimated];
        }
            break;
        case MENU_HQ_Report:
        {
            [_pMultiView scrollToView:(self.pCurrentView ? self.pCurrentView : self.reportTableView) animated:UseAnimated];
        }
            break;
        default:
            break;
    }
//    _btnView.hidden = !self.userTableView.hidden;
    [self ShowHelperImageView];
}

-(BOOL)tztUITableListView:(tztUITableListView*)tableView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString*)strMsgValue
{
    NSString* nsMenuID = @"0";
    NSArray* pAy = [strMsgValue componentsSeparatedByString:@"|"];
    if(pAy && [pAy count] > 3)
        nsMenuID = [pAy objectAtIndex:0];
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)[NSString stringWithFormat:@"%@", nsMenuID] lParam:(NSUInteger)strMsgValue];
    return TRUE;
}


-(void)OnLeftItem:(id)sender
{
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}

-(void)OnRightItem:(id)sender
{
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_SearchStock wParam:0 lParam:0];
}

-(void)OnUserStockTB:(id)sender
{
    tztToolbarMoreView *pMoreView = (tztToolbarMoreView*)[self.view viewWithTag:0x7878];
    if (pMoreView == NULL)
    {
        CGRect rc = ((UIView*)sender).frame;
        NSMutableArray *pAy = NewObjectAutoD(NSMutableArray);
        [pAy addObject:@"|上传|10103|"];
        [pAy addObject:@"|下载|10104|"];
        [pAy addObject:@"|合并|10105|"];
        pMoreView = [[tztToolbarMoreView alloc] initWithShowType:tztShowType_List];
        pMoreView.tag = 0x7878;
        pMoreView.nPosition = tztToolbarMoreViewPositionTop | tztToolbarMoreViewPositionRight;
        pMoreView.fCellHeight = 44;
        pMoreView.nColCount = 1;
        int nHeight = self.pTitle.frame.size.height + 40 + rc.origin.y + rc.size.height;
        pMoreView.szOffset = CGSizeMake(0, nHeight);
        pMoreView.fMenuWidth = 160;
        
        [pMoreView SetAyGridCell:pAy];
        pMoreView.bgColor = [UIColor whiteColor];
        pMoreView.clSeporater = [UIColor colorWithTztRGBStr:@"240,240,240"];
        pMoreView.clText = [UIColor blackColor];
        pMoreView.frame = self.view.frame;
        pMoreView.pDelegate = self;
        [_tztBaseView addSubview:pMoreView];
        [pMoreView release];
    }
    else
    {
        [pMoreView removeFromSuperview];
    }

}


-(void)tztMutilPageViewDidAppear:(NSInteger)CurrentViewIndex
{
    if (CurrentViewIndex < 0 || CurrentViewIndex >= [_ayViews count])
        return;
    _nCurrentIndex = CurrentViewIndex;
    
    self.pCurrentView = [_ayViews objectAtIndex:_nCurrentIndex];
    if ((!self.pTitle.pSwitch.on && CurrentViewIndex > 0)
        || (self.pTitle.pSwitch.on && CurrentViewIndex < 1))
        [self.pTitle setSelectSegmentIndex:_nCurrentIndex];
    self.pCurrentView = NULL;
    for (NSInteger i = 0; i < [_ayViews count]; i++)
    {
        UIView* pView = [_ayViews objectAtIndex:i];
        if (pView && [pView respondsToSelector:@selector(onSetViewRequest:)])
        {
            if (i == CurrentViewIndex)
                [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)YES];
            else
                [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
        }
        if (pView && [pView respondsToSelector:@selector(setStockInfo:Request:)])
        {
            [(tztHqBaseView*)pView setStockInfo:self.pStockInfo Request:(i==CurrentViewIndex)];
        }
    }
}

-(void)tztMutilPageViewDidDisappear:(NSInteger)CurrentViewIndex
{
    if (CurrentViewIndex < 0 || CurrentViewIndex >= [_ayViews count])
        return;
    UIView* pView = [_ayViews objectAtIndex:CurrentViewIndex];
    if (pView && [pView respondsToSelector:@selector(onSetViewRequest:)])
    {
        [(tztHqBaseView*)pView onSetViewRequest:NO];
    }
}
//
@end
