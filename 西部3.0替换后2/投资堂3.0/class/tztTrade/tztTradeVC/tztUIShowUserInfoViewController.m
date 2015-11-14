//
//  tztUIShowUserInfoViewController.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-29.
//
//

#import "tztUIShowUserInfoViewController.h"


@implementation tztUIShowUserInfoViewController

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
    CGRect rcFrame = self.view.bounds;
    //标题view
    CGRect rcTitle = rcFrame;
    rcTitle.size.height = TZTToolBarHeight;
    if (_pTitleView == nil)
    {
        _pTitleView = [[TZTUIBaseTitleView alloc] init];
        _pTitleView.nType = TZTTitleReport;
        _pTitleView.pDelegate = self;
        _pTitleView.frame = rcTitle;
        [self.pTitleView setTitle:@"个人信息查询"];
        [self.view addSubview:_pTitleView];
        [_pTitleView release];
    }
    else
    {
        _pTitleView.frame = rcTitle;
    }
    
    CGRect rcView = rcFrame;
    rcView.origin.x = 10;
    rcView.size.width -= 20;
    rcView.origin.y += rcTitle.size.height + 10;
    rcView.size.height -= rcTitle.size.height;
    if (_pView == NULL)
    {
        _pView = [[tztShowUserInfoView alloc] init];
        _pView.delegate = self;
        _pView.frame = rcView;
        [self.view addSubview:_pView];
        [_pView release];
    }
    else
        _pView.frame = rcView;
    
    [self.view bringSubviewToFront:_pTitleView];
}
@end
