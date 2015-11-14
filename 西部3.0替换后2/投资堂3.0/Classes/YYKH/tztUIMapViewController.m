//
//  tztUIMapViewController.m
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-5.
//
//

#import "tztUIMapViewController.h"


@implementation tztUIMapViewController

@synthesize pTitleView = _pTitleView;
@synthesize pView = _pView;
@synthesize DLocation = _DLocation;
@synthesize DMyLocation = _DMyLocation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _DLocation = NewObject(MapAnnotation);
        _DMyLocation = NewObject(MapAnnotation);
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
    DelObject(_DLocation);
    DelObject(_DMyLocation);
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
    self.nsTitle = @"营业部地图";
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn];
    
    CGRect rcView = _tztBounds;
    rcView.origin = CGPointZero;
    rcView.origin.y += _tztTitleView.frame.size.height;
    rcView.size.height -= (_tztTitleView.frame.size.height);
    
    if (_pView == NULL)
    {
        _pView = [[tztMapView alloc] init];
        [_pView.DLocation setAnnotation:self.DLocation];
        [_pView.DMyLocation setAnnotation:self.DMyLocation];
        _pView.frame = rcView;
        [_tztBaseView addSubview:_pView];
        [_pView release];
        _pView.backgroundColor = [UIColor clearColor];
    }
    else
        _pView.frame = rcView;
    
    [self.view bringSubviewToFront:_pTitleView];
}

- (void)CreateToolBar
{
    
}

@end
