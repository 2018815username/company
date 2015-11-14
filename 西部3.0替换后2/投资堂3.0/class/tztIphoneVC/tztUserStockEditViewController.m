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

#import "tztUserStockEditViewController.h"

@interface tztUserStockEditViewController()

@property(nonatomic,retain)UIButton     *pButtonLogin;
@property (nonatomic, strong) UIImageView *arrowImg;
@end

@implementation tztUserStockEditViewController
@synthesize pEditView = _pEditView;
@synthesize pButtonLogin = _pButtonLogin;
@synthesize arrowImg = _arrowImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self LoadLayoutView];
    if (_pEditView)
    {
        [_pEditView LoadUserStock];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_pEditView)
    {
        [_pEditView SaveUserStock];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    UIView * view= [self.view viewWithTag:0X1111];
    if (view) {
        [view removeFromSuperview];
    }
    CGRect rcFrame = _tztBounds;
        NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"编辑自选";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    _tztTitleView.bHasCloseBtn = IS_TZTIPAD;
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    [self.tztTitleView.firstBtn setTztBackgroundImage:nil];
    [self.tztTitleView.firstBtn setTztImage:nil];
    [self.tztTitleView.firstBtn setTztTitle:@"完成"];
    [self.tztTitleView.firstBtn setShowsTouchWhenHighlighted:YES];
    
//#ifdef tzt_EditUserStockAuto_NoToolBar
    UIImage *image = [UIImage imageTztNamed:@"tztClearStock.png"];
//    CGRect rcFour = self.tztTitleView.fourthBtn.frame;
//    rcFour.origin.x += (rcFour.size.width - image.size.width) / 2;
//    rcFour.origin.y += (rcFour.size.height - image.size.height) / 2;
//    rcFour.size = image.size;
//    self.tztTitleView.fourthBtn.frame = rcFour;
//    
    [self.tztTitleView.fourthBtn setTztBackgroundImage:nil];
    [self.tztTitleView.fourthBtn setTztImage:nil];
    [self.tztTitleView.fourthBtn setTztImage:image];
    [self.tztTitleView.fourthBtn setShowsTouchWhenHighlighted:YES];
//#endif
    if (IS_TZTIPAD)
    {
        _tztTitleView.pSearchBar.hidden = NO;
        _tztTitleView.nType = TZTTitleNormal;
        [_tztTitleView setFrame:_tztTitleView.frame];
    }

    rcFrame.origin.y += _tztTitleView.frame.size.height;
    
    if (IS_TZTIPAD)//pad版本没有底部的工具栏。。。。
    {
        rcFrame.size.height -= (_tztTitleView.frame.size.height);
    }
    else
    {
#ifdef tzt_EditUserStockAuto_NoToolBar
        rcFrame.size.height -= (_tztTitleView.frame.size.height);
#else
        rcFrame.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
#endif
    }
    if (_pEditView == nil)
    {
        _pEditView = [[tztUserStockEditView alloc] init];
        _pEditView.frame = rcFrame;
        [_tztBaseView addSubview:_pEditView];
        [_pEditView release];
    }
    else
        _pEditView.frame = rcFrame;
    
    if (g_nSkinType == 1)
        _pEditView.nsBackColor = @"1";
    [self CreateToolBar];
    [self CheckLoginStates];
}

-(void)CheckLoginStates
{
#ifdef tzt_GJSC
    //需要激活登录
    
    if (![TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])
    {
        CGRect rc = CGRectMake(0, _tztBounds.size.height - TZTToolBarHeight, _tztBounds.size.width, TZTToolBarHeight);
        if (_pButtonLogin == NULL)
        {
            _pButtonLogin = [UIButton buttonWithType:UIButtonTypeCustom];
            _pButtonLogin.backgroundColor = [UIColor colorWithTztRGBStr:@"229,229,229"];
            _pButtonLogin.frame = rc;
            _pButtonLogin.titleLabel.font = tztUIBaseViewTextFont(12);
            _pButtonLogin.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            _pButtonLogin.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_pButtonLogin setTztTitleColor:[UIColor blackColor]];
            [_pButtonLogin setTztTitle:@"登录西部信天游账号同步自选股"];
            [_pButtonLogin addTarget:self
                              action:@selector(OnLogin)
                    forControlEvents:UIControlEventTouchUpInside];
            [_tztBaseView addSubview:_pButtonLogin];
        }
        else
            _pButtonLogin.frame = rc;
        
        
        
        CGRect rcLabel = _pButtonLogin.frame;
        float fWidth = [_pButtonLogin.titleLabel.text sizeWithFont:_pButtonLogin.titleLabel.font].width;
        rcLabel.origin.x += fWidth + (rcLabel.size.width - fWidth) / 2 + 2;
        rcLabel.origin.y = (rcLabel.size.height - 12) / 2;
        rcLabel.size = CGSizeMake(12, 12);
        _arrowImg = [[UIImageView alloc] initWithFrame:rcLabel];
        [_arrowImg setImage:[UIImage imageTztNamed:@"tztRoundArrow@2x.png"]];
        [_pButtonLogin addSubview:_arrowImg];
        [_arrowImg release];
    }
    _pButtonLogin.hidden = [TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log];
    
    NSString* strAccount = [[tztHTTPData getShareInstance] getmapValue:@"fund_account"];
    if (strAccount.length > 0)
    {
        _pButtonLogin.hidden = YES;
    }
    if (!_pButtonLogin.hidden)
        [_tztBaseView bringSubviewToFront:_pButtonLogin];
    
#endif
}

-(void)OnLogin
{
    NSString* str = @"10090/?logintype=1";
    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:0];
}

-(void)CreateToolBar
{
#ifdef tzt_EditUserStockAuto_NoToolBar
    return;
#endif
#ifdef tzt_NewVersion
    NSArray *pAy = [g_pSystermConfig.pDict objectForKey:@"TZTToolUserStockEdit"];
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
    
    [tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolUserStockEdit" delegate_:self forToolbar_:toolBar];
#endif
}

-(void)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    
    NSInteger nTag = pBtn.tag;
    if (nTag == MENU_HQ_SearchStock
        || nTag == HQ_MENU_SearchStock)
    {
        if (_pEditView)
        {
            [_pEditView tztperformSelector:@"DeleteUserStock"];
        }
        return;
    }
    
    [super OnToolbarMenuClick:sender];
}
@end
