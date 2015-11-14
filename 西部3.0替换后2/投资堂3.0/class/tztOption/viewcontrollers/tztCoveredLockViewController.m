
#import "tztCoveredLockViewController.h"
#import "tztCoveredLockView.h"
#import "tztOptionSearchView.h"

@interface tztCoveredLockViewController ()<tztUIRightSearchDelegate>

@property(nonatomic,retain)tztCoveredLockView   *tztTradeView;
@property(nonatomic,retain)tztOptionSearchView  *tztSearchView;
@end

@implementation tztCoveredLockViewController

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
    
    [self onSetTztTitleView:GetTitleByID(_nMsgType) type:TZTTitleReport];
    
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= _tztTitleView.frame.size.height;
    if (_tztTradeView == nil)
    {
        _tztTradeView = [[tztCoveredLockView alloc] init];
        _tztTradeView.nMsgType = _nMsgType;
        _tztTradeView.frame = rcFrame;
        if (self.CurStockCode && self.CurStockCode.length > 0)
        {
            [_tztTradeView setStockCode:self.CurStockCode];
        }
        [_tztBaseView addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
        _tztTradeView.frame = rcFrame;
    
    //获取交易的高度
    CGSize sz = [_tztTradeView getTableShowSize];
    
    CGRect rcSeach = rcFrame;
    rcSeach.origin.y += sz.height;
    rcSeach.size.height -= sz.height;
    
    if (_tztSearchView == nil)
    {
        _tztSearchView = [[tztOptionSearchView alloc] init];
        _tztSearchView.delegate = self;
        [_tztBaseView addSubview:_tztSearchView];
        [_tztSearchView release];
    }
    
    _tztSearchView.nMsgType = _nMsgType;
    _tztSearchView.frame = rcSeach;
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    
}

//选中行，得到数据，传递到_tztTradeView中
-(void)DealSelectRow:(NSArray *)gridData StockCodeIndex:(NSInteger)index
{
    
}

@end
