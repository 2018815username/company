
#import "tztOptionSearchViewController.h"
#import "tztOptionSearchView.h"

@interface tztOptionSearchViewController ()

@property(nonatomic,retain)tztOptionSearchView  *tztSearchView;
@end

@implementation tztOptionSearchViewController

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
    rcFrame.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_tztSearchView == nil)
    {
        _tztSearchView = [[tztOptionSearchView alloc] init];
        _tztSearchView.delegate = self;
        if (_nsBeginDate && [_nsBeginDate length] > 0)
            _tztSearchView.nsBeginDate = _nsBeginDate;
        if (_nsEndDate && [_nsEndDate length] > 0)
            _tztSearchView.nsEndDate = _nsEndDate;
        [_tztBaseView addSubview:_tztSearchView];
        [_tztSearchView release];
    }
    _tztSearchView.nMsgType = _nMsgType;
    _tztSearchView.frame = rcFrame;
    [self CreateToolBar];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    //加载默认
    switch (_nMsgType)
    {
        default:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
        }
            break;
    }
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_tztSearchView)
    {
        bDeal = [_tztSearchView OnToolbarMenuClick:sender];
    }
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

-(void)OnBtnNextStock:(id)sender
{
    if (_tztSearchView)
        [_tztSearchView OnGridNextStock:_tztSearchView.pGridView ayTitle_:_tztSearchView.ayTitle];
}

-(void)OnBtnPreStock:(id)sender
{
    if (_tztSearchView)
        [_tztSearchView OnGridPreStock:_tztSearchView.pGridView ayTitle_:_tztSearchView.ayTitle];
}


@end
