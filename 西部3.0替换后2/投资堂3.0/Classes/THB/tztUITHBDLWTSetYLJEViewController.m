/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUITHBDLWTSetYLJEViewController
 * 文件标识:
 * 摘要说明:		天汇宝代理委托-预留金额设置界面、开通界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUITHBDLWTSetYLJEViewController.h"


@implementation tztUITHBDLWTSetYLJEViewController

@synthesize pTitleView = _pTitleView;
@synthesize pView = _pView;
@synthesize nShowType = _nShowType;
//@synthesize nsStcokCode =_nsStcokCode;
//@synthesize nsStockName = _nsStockName;
@synthesize nsNowYLJE = _nsNowYLJE;

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
    self.nsTitle = @"代理委托-预留金额";
    if (_nShowType == TZTToolbar_Fuction_OK)
    {
        self.nsTitle = @"代理委托-开通";
    }else if (_nShowType == TZTToolbar_Fuction_THB_YLJE)
    {
        self.nsTitle = @"代理委托-预留金额";
    }
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = _tztBounds;
    rcView.origin = CGPointZero;
    rcView.origin.y += _tztTitleView.frame.size.height;
    rcView.size.height -= (_tztTitleView.frame.size.height);
    
    if (_pView == NULL)
    {
        _pView = [[tztDLWTSetYLJEView alloc] init];
        _pView.delegate = self;
        _pView.nMsgType = _nMsgType;
        _pView.nShowType = _nShowType;
        
        if (_nsNowYLJE && [_nsNowYLJE length] > 0)
            _pView.nsNowYLJE = [NSString stringWithFormat:@"%@",_nsNowYLJE];
        _pView.frame = rcView;
        [_tztBaseView addSubview:_pView];
        [_pView release];
    }
    else
        _pView.frame = rcView;
}

- (void)CreateToolBar
{
    
}

@end
