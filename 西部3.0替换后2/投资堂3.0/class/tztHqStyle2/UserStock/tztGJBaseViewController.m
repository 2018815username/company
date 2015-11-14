//
//  tztGJBaseViewController.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-3-28.
//
//

#import "tztGJBaseViewController.h"
#define BackImag [UIImage imageTztNamed:@"TZTnavbarbackbg.png"]
#define BackWhiteImag [UIImage imageTztNamed:@"TZTnavWhitebackbg.png"]

@interface tztGJBaseViewController ()

@end

@implementation tztGJBaseViewController
@synthesize pLeftView = _pLeftView;
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
    
    [self onSetTztTitleView:@"自选股" type:TZTTitleReport];
//    if (g_nThemeColor == 0)
//    {
//        self.view.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
//        self.tztBaseView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
//        self.tztTitleView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
//        [self.tztTitleView.firstBtn setImage:BackImag forState:UIControlStateNormal];
//    }
//    else if (g_nThemeColor == 1)
//    {
//        self.view.backgroundColor = [UIColor colorWithTztRGBStr:@"35,120,220"];
//        self.tztBaseView.backgroundColor = [UIColor colorWithTztRGBStr:@"35,120,220"];
//        self.tztTitleView.backgroundColor = [UIColor colorWithTztRGBStr:@"35,120,220"];
//        [self.tztTitleView.firstBtn setImage:BackWhiteImag forState:UIControlStateNormal];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)refreshColor
{
    if (g_nThemeColor == 0)
    {
        self.view.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
        self.tztBaseView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
        self.tztTitleView.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
        [self.tztTitleView.firstBtn setImage:BackImag forState:UIControlStateNormal];
    }
    else if (g_nThemeColor == 1) {
        self.view.backgroundColor = [UIColor colorWithTztRGBStr:@"35,120,220"];
        self.tztBaseView.backgroundColor = [UIColor colorWithTztRGBStr:@"35,120,220"];
        self.tztTitleView.backgroundColor = [UIColor colorWithTztRGBStr:@"35,120,220"];
        [self.tztTitleView.firstBtn setImage:BackWhiteImag forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
