//
//  tztUIRZRQVotingViewController.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-14.
//
//

#import "tztUIRZRQVotingViewController.h"

@implementation tztUIRZRQVotingViewController
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
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
        NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"客户投票";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    if (g_pSystermConfig.bShowbottomTool)
        rcView.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    else
        rcView.size.height -= (_tztTitleView.frame.size.height);
    
    if (_pView == nil)
    {
        _pView = [[tztRZRQVotingView alloc] init];
        _pView.delegate = self;
        _pView.nMsgType = _nMsgType;
        _pView.frame = rcView;
        [_tztBaseView addSubview:_pView];
        [_pView release];
    }
    else
    {
        _pView.frame = rcView;
    }
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    
}
@end
