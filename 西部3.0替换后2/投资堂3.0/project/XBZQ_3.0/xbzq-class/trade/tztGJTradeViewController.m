//
//  tztGJTradeViewController.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-7-2.
//
//

#import "tztGJTradeViewController.h"

@interface tztGJTradeViewController ()

@property(nonatomic,retain)UIView   *pLeftView;
@end

@implementation tztGJTradeViewController
@synthesize pLeftView = _pLeftView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tztLoginStateChanged:)
                                                 name:TZTNotifi_ChangeLoginState
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMessage:) name:@"tztGetPushMessage" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)OnContactUS:(id)sender
{
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([TZTUserInfoDeal IsHaveTradeLogin:StockTrade_Log])
    {
        self.tztTitleView.fourthBtn.hidden = NO;
        [self.tztTitleView.fourthBtn setTztBackgroundImage:nil];
        [self.tztTitleView.fourthBtn setTztImage:nil];
        [self.tztTitleView.fourthBtn setTztTitle:@"退出"];
        [self.tztTitleView.fourthBtn.titleLabel setFont:tztUIBaseViewTextFont(14)];
        [self.tztTitleView.fourthBtn removeTarget:self.tztTitleView action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.tztTitleView.fourthBtn addTarget:self
                                        action:@selector(OnRightItem:)
                              forControlEvents:UIControlEventTouchUpInside];
    }
    else
        self.tztTitleView.fourthBtn.hidden = YES;
    
    self.tztTitleView.fourthBtn.hidden = YES;
//    [self LoadLayoutView];
}

- (void)tztLoginStateChanged:(NSNotification*)note
{
    NSString* strType = (NSString*)note.object;
    NSArray *ay = [strType componentsSeparatedByString:@"|"];
    if ([ay count] <= 0)
        return;
    long lType = [[ay objectAtIndex:0] intValue];
    BOOL IsLogin = TRUE;
    if ([ay count] > 1)
    {
        IsLogin = [[ay objectAtIndex:1] boolValue];
    }
    if ([TZTUserInfoDeal IsHaveTradeLogin:lType])
    {
        if((StockTrade_Log & lType) == StockTrade_Log)//普通交易登出
        {
            if(!IsLogin)
                self.tztTitleView.fourthBtn.hidden = YES;
        }
    }
}

-(void)GetMessage:(id)sender
{
    NSInteger n = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (n > 0)
    {
        [self.tztTitleView.firstBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo+1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.tztTitleView.firstBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo.png"] forState:UIControlStateNormal];
    }
}

- (void)LoadLayoutView
{
    [super LoadLayoutView];
    [self onSetTztTitleView:@"交易" type:TZTTitleIcon];
    self.pWebView.tztDelegate = self;
    if ([_pWebView canReturnBack])
    {
        self.tztTitleView.firstBtn.hidden = NO;
    }
    
    /**//**/
    //增加左侧可拖动功能
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_tztTitleView];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_tztTitleView];
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

-(void)OnRightItem:(id)sender
{
    //http%3A%2F%2Faction%3A10090%2F%3Flogintype%3D1
    
//    NSString* str1 = @"http%3A%2F%2Faction%3A10061%2F%3Ffullscreen%3D1%26%26secondtype%3D9%26%26url%3D%2Fme%2Findex.html%3Fyjb%2Fyjb_i_jtt_unbind.html";
    NSString *str1 = @"";
    NSString* str = [NSString stringWithFormat:@"%@&&url=%@", @"10402/?context=确定退出当前登录账号？", str1];
    [TZTUIBaseVCMsg OnMsg:ID_MENU_ACTION wParam:(NSUInteger)str lParam:0];
}

-(BOOL)tztWebViewCanGoBack:(tztHTTPWebView *)webView
{
    if (webView != self.pWebView)
        return NO;
    if ([_pWebView canReturnBack])
    {
        self.tztTitleView.firstBtn.hidden = NO;
    }
//    else
//    {
//        self.tztTitleView.firstBtn.hidden = YES;
//    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)OnChangeTheme
{
    [self.pWebView RefreshWebView:-1];
    [super OnChangeTheme];
}
@end
