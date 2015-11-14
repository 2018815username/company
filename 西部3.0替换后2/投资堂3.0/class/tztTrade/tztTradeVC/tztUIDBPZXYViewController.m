//
//  tztUIDBPZXYViewController.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-15.
//
//

#import "tztUIDBPZXYViewController.h"

@implementation tztUIDBPZXYViewController
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    CGRect rcTitle = rcFrame;
    rcTitle.origin = CGPointZero;
    rcTitle.size.height = TZTToolBarHeight;
    if (_pTitleView == nil)
    {
        _pTitleView = [[TZTUIBaseTitleView alloc] init];
        _pTitleView.nType = TZTTitleReport;
        _pTitleView.pDelegate = self;
        _pTitleView.frame = rcTitle;
        [self.pTitleView setTitle:@"担保品转信用"];
        [self.view addSubview:_pTitleView];
        [_pTitleView release];
    }
    else
    {
        _pTitleView.frame = rcTitle;
    }
    
    CGRect rcView = rcFrame;
    rcView.origin = CGPointMake(10, 20);
    rcView.origin.y += rcTitle.size.height;
    rcView.size.height -= (rcTitle.size.height + 20);
    rcView.size.width -= 20;
    if (_pView == nil)
    {
        _pView = [[tztDBPZXYView alloc] init];
        _pView.delegate = self;
        _pView.frame = rcView;
        [self.view addSubview:_pView];
        [_pView release];
    }
    else
    {
        _pView.frame = rcView;
    }
    [self.view bringSubviewToFront:_pTitleView];
}

@end
