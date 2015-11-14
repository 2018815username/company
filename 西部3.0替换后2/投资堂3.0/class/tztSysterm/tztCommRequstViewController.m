/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztCommRequstViewController.h"

@implementation tztCommRequstViewController
@synthesize pCommView = _pCommView;

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
    if (_pCommView)
    {
        [_pCommView OnRequestData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (IS_TZTIPAD)
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
  
    [self onSetTztTitleView:(self.nsTitle ? self.nsTitle :g_pSystermConfig.strMainTitle) type:TZTTitleReport];
      CGRect rcLogin = rcFrame;
    rcLogin.origin = CGPointZero;
    rcLogin.origin.y += _tztTitleView.frame.size.height;
    rcLogin.size.height -= (_tztTitleView.frame.size.height);
    if (_pCommView == NULL)
    {
        _pCommView = [[tztTradeSearchView alloc] init];
        _pCommView.delegate = self;
        _pCommView.frame = rcLogin;
        [_tztBaseView addSubview:_pCommView];
        [_pCommView release];
    }
    else
    {
        _pCommView.frame = rcLogin;
    }
    _pCommView.nMsgType = _nMsgType;
}

-(void)CreateToolBar
{

}

-(void)SetTitle:(NSString *)nsTitle
{
    self.nsTitle = [NSString stringWithFormat:@"%@", nsTitle];
    if (_tztTitleView)
    {
        [_tztTitleView setTitle:nsTitle];
    }
}
-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pCommView)
    {
        bDeal = [_pCommView OnToolbarMenuClick:sender];
    }
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
