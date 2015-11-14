//
//  tztPushDetailViewController.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-3-6.
//
//

#import "tztPushDetailViewController.h"

@interface tztPushDetailViewController ()

@end

@implementation tztPushDetailViewController

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

-(void)LoadLayoutView
{
    [super LoadLayoutView];
    CGRect rcFrame = _tztBounds;
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= _tztTitleView.frame.size.height;
    _pWebView.frame = rcFrame;
}

-(void)CreateToolBar
{
    
}

@end
