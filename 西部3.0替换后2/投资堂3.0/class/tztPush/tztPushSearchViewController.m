//
//  tztPushSearchViewController.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-3-6.
//
//

#import "tztPushSearchViewController.h"

#define tztBottomHeight (49)
@interface tztPushSearchViewController ()

@property(nonatomic,retain) UIView  *pBottomView;
@property(nonatomic,retain) tztUIButton    *pBtnOK;
@property(nonatomic,retain) tztUIButton    *pBtnDel;
@end

@implementation tztPushSearchViewController
@synthesize pBottomView = _pBottomView;
@synthesize pSearchView = _pSearchView;
@synthesize pBtnOK = _pBtnOK;
@synthesize pBtnDel = _pBtnDel;

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
//    if (_pSearchView)
//        [_pSearchView OnRequestData];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_pSearchView)
        [_pSearchView OnRequestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (strTitle.length < 1)
        strTitle = @"全部预警";
    [self onSetTztTitleView:strTitle type:TZTTitleReturn];
    
    rcFrame.size.height -= (tztBottomHeight + _tztTitleView.frame.size.height);
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    if (_pSearchView == NULL)
    {
        _pSearchView = [[tztPushSeachView alloc] init];
        _pSearchView.nMsgType = _nMsgType;
        _pSearchView.delegate = self;
//        _pSearchView.bDetailNew = YES;
        _pSearchView.frame = rcFrame;
        [_pSearchView.pGridView setBackBg:@"1"];
        [_tztBaseView addSubview:_pSearchView];
        [_pSearchView release];
    }
    else
        _pSearchView.frame = rcFrame;

    [_pSearchView.pGridView setBackBg:@"1"];
    CGRect rcBottom = rcFrame;
    rcBottom.origin.y += rcFrame.size.height;
    rcBottom.size.height = tztBottomHeight;
    if (_pBottomView == NULL)
    {
        _pBottomView = [[UIView alloc] initWithFrame:rcBottom];
        _pBottomView.layer.borderWidth = 1;
        _pBottomView.layer.borderColor = [UIColor colorWithTztRGBStr:@"218,218,218"].CGColor;
        [_tztBaseView addSubview:_pBottomView];
        _pBottomView.backgroundColor = [UIColor whiteColor];
        [_pBottomView release];
    }
    else
    {
        _pBottomView.frame = rcBottom;
    }
    
    int nMargin = 5;
    int nYOffset = 3;
    CGRect rcBtn = rcBottom;
    rcBtn.origin.x += nMargin;
    rcBtn.origin.y = nYOffset;
    rcBtn.size.width = (rcBottom.size.width - 4 * 5 ) / 2;
    rcBtn.size.height -= (2*nYOffset);
    
    if (_pBtnOK == NULL)
    {
        _pBtnOK = [[tztUIButton alloc] initWithProperty:@"tag=4000|type=custom|title=修改|backimage=tztButtonRed.png|textcolor=218,218,218|"];
        _pBtnOK.tztdelegate = self;
        _pBtnOK.frame = rcBtn;
        [_pBottomView addSubview:_pBtnOK];
        [_pBtnOK release];
    }
    else
    {
        _pBtnOK.frame = rcBtn;
    }
    
    rcBtn.origin.x += nMargin * 2 + rcBtn.size.width;
    if (_pBtnDel == NULL)
    {
        _pBtnDel = [[tztUIButton alloc] initWithProperty:@"tag=4001|type=custom|title=删除|backimage=tztDialogCancel.png|textcolor=30,30,30|"];
        _pBtnDel.tztdelegate = self;
        _pBtnDel.frame = rcBtn;
        [_pBottomView addSubview:_pBtnDel];
        [_pBtnDel release];
    }
    else
    {
        _pBtnDel.frame = rcBtn;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
}


-(void)CreateToolBar
{
    
}

-(void)OnButtonClick:(id)sender
{
    if (_pSearchView)
        [_pSearchView OnToolbarMenuClick:sender];
}
@end
