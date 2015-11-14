//
//  tztUIUserStockViewController.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-9-22.
//
//

#import "tztUIUserStockViewController.h"
#import "TZTUserStockTableView.h"

@interface tztUIUserStockViewController ()<tztUIBaseViewTextDelegate>

/**
 *	@brief	自选
 */
@property(nonatomic,retain) TZTUserStockTableView   *userTableView;
@property(nonatomic,retain) UIButton                *pBtnEditor;



/**
 *	@brief	标题背景
 */
@property(nonatomic,retain)UIView                   *pTitleBackView;

@property(nonatomic,retain)UILabel                  *pLabel;

@property(nonatomic,retain)tztUITextField           *pTextField;

@property(nonatomic,retain)UIButton                 *pLeftButton;

@property(nonatomic,retain)UIButton                 *pSearchButton;

@end

@implementation tztUIUserStockViewController

@synthesize userTableView = _userTableView;
@synthesize pBtnEditor    = _pBtnEditor;
@synthesize pTitleBackView = _pTitleBackView;
@synthesize pLabel = _pLabel;
@synthesize pTextField = _pTextField;
@synthesize pLeftButton = _pLeftButton;
@synthesize pSearchButton = _pSearchButton;
//@synthesize moreMarketView = _moreMarketView;

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
    [self LoadLayoutView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMessage:) name:@"tztGetPushMessage" object:nil];
    
    [_userTableView setStockCode:[tztUserStock GetNSUserStock] Request:1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    if (!IS_TZTIPAD)
    {
        [super viewDidAppear:animated];//????此处暂时先注释，pad版本弹出会导致右侧的关闭按钮失效，原因待查
        [self LoadLayoutView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //唤醒界面，重新加入通讯列表，保证定时刷新
    if (_userTableView)
    {
        [_userTableView onSetViewRequest:YES];
        [_userTableView onRequestData:NO];
        _userTableView.centerCount = 0;
        _userTableView.nonCenCount = 0;
        _userTableView.nTickCount = 0;
        _userTableView.priceCount = 99;
        _userTableView.rankCount = 99;
        _userTableView.rankType = RankNature;
        _userTableView.priceType = PriceNature;
        [_userTableView.pTableView reloadData];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //不显示，请从通讯数组中移除，不显示的界面不要去发送数据
    if (_userTableView)
        [_userTableView onSetViewRequest:NO];
}

-(void)OnEditBtn
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_EditUserStock wParam:0 lParam:0];
}

-(void)OnContactUS:(id)sender
{
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}

-(void)GetMessage:(NSNotification*)noti
{
    NSInteger n = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (n > 0)
    {
        [self.pLeftButton setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo+1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.pLeftButton setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo.png"] forState:UIControlStateNormal];
    }
}


-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    
    CGRect rcTitle = self.tztTitleView.frame;
    if (self.tztTitleType == tztTitleNew)
    {
        if (_pTitleBackView == NULL)
        {
            _pTitleBackView = [[UIView alloc] initWithFrame:rcTitle];
            _pTitleBackView.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
            [_tztBaseView addSubview:_pTitleBackView];
            [_pTitleBackView release];
        }
        else
        {
            _pTitleBackView.frame = rcTitle;
        }
        
        CGRect rcSearchBar = rcTitle;
        rcSearchBar.origin.x += 5 + 60;
        rcSearchBar.origin.y += (7 + (IS_TZTIOS(7) ? TZTStatuBarHeight : 0));
        rcSearchBar.size.width -= 70 * 2;
        rcSearchBar.size.height = rcTitle.size.height - 14 - (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
        
        CGRect rcLabel = rcSearchBar;
        if (_pLabel == nil)
        {
            _pLabel = [[UILabel alloc] initWithFrame:rcLabel];
            _pLabel.backgroundColor = [UIColor clearColor];
            _pLabel.layer.cornerRadius = 5.0f;
            [_tztBaseView addSubview:_pLabel];
            [_pLabel release];
        }
        else
        {
            _pLabel.frame = rcLabel;
        }
        
        CGRect rcImage = CGRectMake(rcLabel.origin.x + 5, rcLabel.origin.y, 2, 2);
        rcImage.origin.y += (rcLabel.size.height - rcImage.size.height) / 2;
        
        CGRect rcTextField = rcSearchBar;
        rcTextField.origin.x += rcImage.size.width + 5;
        rcTextField.size.width -= (2+rcImage.size.width);
        if (_pTextField == nil)
        {
            _pTextField = [[tztUITextField alloc] initWithProperty:@"tag=1000|keyboardtype=number|maxlen=6||textalignment=left|textcolor=255,255,255|enabled=0|"];
            _pTextField.enabled = NO;
            _pTextField.tztdelegate = self;
            _pTextField.backgroundColor = [UIColor colorWithTztRGBStr:@"20,22,27"];
            _pTextField.layer.borderColor = [UIColor colorWithTztRGBStr:@"25,27,34"].CGColor;
            _pTextField.layer.borderWidth = 1.1f;
            _pTextField.textColor = [UIColor whiteColor];
            _pTextField.frame = rcTextField;
            _pTextField.leftViewMode = UITextFieldViewModeAlways;
            
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTnavbarsearch.png"]];
            image.alpha = 0.5f;
            image.frame = CGRectMake(0, 0, 30, 30);
            _pTextField.leftView = image;
            [image release];
            
            _pTextField.layer.cornerRadius = 2.5f;
            [_tztBaseView addSubview:_pTextField];
            [_pTextField release];
        }
        else
        {
            _pTextField.frame = rcTextField;
        }
        CGRect rcButton = rcTextField;
        if (_pSearchButton == NULL)
        {
            _pSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _pSearchButton.frame = rcButton;
            _pSearchButton.backgroundColor = [UIColor clearColor];
            [_pSearchButton setTztTitle:@"请输入股票代码/首字母"];
            [_pSearchButton setTztTitleColor:[UIColor lightTextColor]];
            [_pSearchButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [_pSearchButton addTarget:self
                               action:@selector(OnSearchStockCode)
                     forControlEvents:UIControlEventTouchUpInside];
            _pSearchButton.titleLabel.font = tztUIBaseViewTextFont(11.f);
            [_tztBaseView addSubview:_pSearchButton];
        }
        _pSearchButton.frame = rcButton;
        
        CGRect rcLeftItem = self.tztTitleView.firstBtn.frame;
        CGSize sz = CGSizeMake(60, 44);
        rcLeftItem.origin.x += (rcLeftItem.size.width - sz.width) / 2;
        rcLeftItem.origin.y += (rcLeftItem.size.height - sz.height) / 2;
        rcLeftItem.size = sz;
        
        if (_pLeftButton == NULL)
        {
            _pLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pTitleBackView addSubview:_pLeftButton];
            NSInteger n = [UIApplication sharedApplication].applicationIconBadgeNumber;
            if (n > 0)
                [_pLeftButton setTztBackgroundImage:[UIImage imageTztNamed:@"TZTLogo+1.png"]];
            else
                [_pLeftButton setTztBackgroundImage:[UIImage imageTztNamed:@"TZTLogo.png"]];
                
            [_pLeftButton setTztTitle:@""];
            [_pLeftButton addTarget:self
                             action:@selector(OnLeftItem:)
                   forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.pLeftButton.frame = rcLeftItem;
        
        CGRect rcEdit = self.tztTitleView.fourthBtn.frame;
        
        rcEdit.size.width = 60;
        if (_pBtnEditor == NULL)
        {
            _pBtnEditor = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pTitleBackView insertSubview:_pBtnEditor belowSubview:self.tztTitleView.fourthBtn];
            //        [self.tztTitleView addSubview:_pBtnEditor];
            [_pBtnEditor setTztImage:[UIImage imageTztNamed:@"TZTEditUserStock@2x.png"]];
            [_pBtnEditor setTztTitle:@""];
            [_pBtnEditor addTarget:self
                            action:@selector(OnEditBtn)
                  forControlEvents:UIControlEventTouchUpInside];
        }
        self.pBtnEditor.frame = rcEdit;
    }
    else
    {
        [self onSetTztTitleView:self.nsTitle type:TZTTitleDetail_User];
    }
    
    CGRect rect = rcFrame;
    rect.origin.y += self.tztTitleView.frame.size.height;
    rect.size.height = 0;
    
    
    rect.origin.y += rect.size.height;
#ifdef tzt_NewVersion
    rect.size.height = rcFrame.size.height - rect.origin.y;
#else
    rect.size.height = rcFrame.size.height - rect.origin.y - TZTToolBarHeight;
#endif
    //自选
    if (_userTableView == NULL)
    {
        _userTableView = [[TZTUserStockTableView alloc] init];
        _userTableView.frame = rect;
        _userTableView.nShowInQuote = 0;
        [_tztBaseView addSubview:_userTableView];
        _userTableView.bAutoPush = g_bUseHQAutoPush;
        [_userTableView release];
    }
    else
        _userTableView.frame = rect;
    
    [self CreateToolBar];
    
    if (g_nSupportLeftSide)
    {
        /**/
        //增加左侧可拖动功能
        [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_tztTitleView];
        [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_tztTitleView];
        
        if (self.pTitleBackView)
        {
            [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:self.pTitleBackView];
            [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:self.pTitleBackView];
        }
        
        CGRect rcLeft = CGRectMake(0, _tztTitleView.frame.size.height, 15, _tztBounds.size.height);
        if (_pLeftView == nil)
        {
            _pLeftView = [[UIView alloc] initWithFrame:rcLeft];
            _pLeftView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:_pLeftView];
            [_pLeftView release];
        }
        else
        {
            _pLeftView.frame = rcLeft;
        }
        
        [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_pLeftView];
        [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_pLeftView];
        
        [[TZTAppObj getShareInstance].rootTabBarController RefreshAddCustomsViews];
    }
}

-(void)OnLeftItem:(id)sender
{
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}

-(void)OnSearchStockCode
{
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_SearchStock wParam:0 lParam:0];
}

//创建toolbar
-(void)CreateToolBar
{
#ifdef tzt_NewVersion
    return;
#endif
    
}

@end
