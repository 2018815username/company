

#import "tztGJMeViewController.h"

@interface tztGJMeViewController ()

@property(nonatomic,retain)UIView *pLeftView;
@end

@implementation tztGJMeViewController
@synthesize pLeftView = _pLeftView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoadLayoutView
{
    [super LoadLayoutView];
//    CGRect rcFrame = self.tztTitleView.frame;
//    CGRect rcWeb = self.pWebView.frame;
//    rcWeb.origin.y -= rcFrame.size.height;
//    rcWeb.size.height += rcFrame.size.height;
//    self.pWebView.frame = rcWeb;
    [self onSetTztTitleView:self.nsTitle type:TZTTitleIcon];
    self.pWebView.tztDelegate = self;
//    if ([_pWebView canReturnBack])
//    {
//        self.tztTitleView.firstBtn.hidden = NO;
//    }
//    else
//    {
//        self.tztTitleView.firstBtn.hidden = YES;
//    }
    self.tztTitleView.fourthBtn.hidden = YES;
//    self.tztTitleView.hidden = YES;
    
    //增加左侧可拖动功能
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

-(BOOL)tztWebViewCanGoBack:(tztHTTPWebView *)webView
{
    if (webView != self.pWebView)
        return NO;
//    if ([_pWebView canReturnBack])
//    {
//        self.tztTitleView.firstBtn.hidden = NO;
//    }
//    else
//    {
//        self.tztTitleView.firstBtn.hidden = YES;
//    }
    return YES;
}

-(void)OnContactUS:(id)sender
{
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}

-(void)tztWebView:(tztBaseUIWebView *)webView withTitle:(NSString *)title
{
    if(_pWebView && webView == _pWebView)
    {
        if ([_pWebView canReturnBack])
        {
            if(title && [title length] > 0)
            {
                self.nsTitle = [NSString stringWithFormat:@"%@",title];
                if (_tztTitleView)
                {
                    [_tztTitleView setTitle:title];
                }
            }
            else
            {
                [_tztTitleView setTitle:g_pSystermConfig.strMainTitle]; // important and good for title corrected
            }
        }
        else
        {
            [self setTitle:title];
//            [_tztTitleView setTitle:@"我"];
        }
        
    }
}


@end
