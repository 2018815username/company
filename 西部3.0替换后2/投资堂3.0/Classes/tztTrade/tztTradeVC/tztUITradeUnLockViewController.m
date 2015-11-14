//
//  tztUITradeLockViewController.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-22.
//
//

#import "tztUITradeUnLockViewController.h"

@implementation tztUITradeUnLockViewController

@synthesize pTitleView = _pTitleView;
@synthesize pView = _pView;
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
    [self LoadLayoutView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return YES;
    }
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)LoadLayoutView
{
    //zxl 20130719 交易锁界面修改 区分底部显示工具条的区分
    CGRect rcFrame = self.view.bounds;
    [self onSetTztTitleView:@"交易解锁" type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcView.size.height -= _tztTitleView.frame.size.height;
    }else
    {
        rcView.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    if (_pView == NULL)
    {
        _pView = [[tztTradeUnLockView alloc] init];
        _pView.delegate = self;
        _pView.frame = rcView;
        [self.view addSubview:_pView];
        [_pView release];
    }
    else
        _pView.frame = rcView;
    
    [self.view bringSubviewToFront:_pTitleView];
}
-(void) OnReturnBack
{
    [TZTUIBaseVCMsg OnMsg:HQ_ROOT wParam:0 lParam:0];
}

-(void)CreateToolBar
{
     //zxl 20130719 交易锁界面修改 区分底部显示工具条的区分
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
}
@end
