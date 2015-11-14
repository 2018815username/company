//
//  tztUIFundZHInfoViewController.m
//  tztMobileApp_hxsc
//
//  Created by zz tzt on 13-4-16.
//
//

#import "tztUIFundZHInfoViewController.h"

@interface tztUIFundZHInfoViewController ()

@end

@implementation tztUIFundZHInfoViewController
@synthesize nCurrentIndex = _nCurrentIndex;
@synthesize tztTradeTable = _tztTradeTable;
@synthesize bShowAll = _bShowAll;

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
    [self LoadLayoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString *strTtile = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTtile))
        strTtile = @"组合申购";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTtile];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    rcView.size.height -= _tztTitleView.frame.size.height;
    if (_tztTradeTable == nil)
    {
        _tztTradeTable = [[tztUIFundZHInfoView alloc] init];
        _tztTradeTable.nMsgType = _nMsgType;
        _tztTradeTable.bShowAll = _bShowAll;
        _tztTradeTable.frame = rcView;
        _tztTradeTable.nCurrentIndex = _nCurrentIndex;
        [_tztTradeTable OnRefresh];//请求数据
        [_tztBaseView addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcView;
    }
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    
}

@end
