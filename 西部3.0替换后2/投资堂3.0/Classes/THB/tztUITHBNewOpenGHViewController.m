/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUITHBNewOpenGHViewController
 * 文件标识:
 * 摘要说明:		天汇宝新开回购界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUITHBNewOpenGHViewController.h"


@implementation tztUITHBNewOpenGHViewController

@synthesize pTitleView = _pTitleView;
@synthesize pView = _pView;
@synthesize nsCurStockCode = _nsCurStockCode;
@synthesize nsCurAccountType =_nsCurAccountType;
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
    self.nsTitle = GetTitleByID(_nMsgType);
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = _tztBounds;
    rcView.origin = CGPointZero;
    rcView.origin.y += _tztTitleView.frame.size.height;
    rcView.size.height -= (_tztTitleView.frame.size.height);
    
    if (_pView == NULL)
    {
        _pView = [[tztNewOpenGHView alloc] init];
        _pView.delegate = self;
        _pView.nMsgType = _nMsgType;
        _pView.frame = rcView;
        [_tztBaseView addSubview:_pView];
        [_pView release];
        
        if (self.nsCurAccountType && [self.nsCurAccountType length] > 0)
        {
            _pView.nsCurAccountType = [NSString stringWithFormat:@"%@",self.nsCurAccountType];
        }
        if (self.nsCurStockCode && [self.nsCurStockCode length] > 0)
        {
            _pView.nsCurStockCode = [NSString stringWithFormat:@"%@",self.nsCurStockCode];
            [_pView OnRequestData];
        }
    }
    else
        _pView.frame = rcView;
}

- (void)CreateToolBar
{
    
}

@end
