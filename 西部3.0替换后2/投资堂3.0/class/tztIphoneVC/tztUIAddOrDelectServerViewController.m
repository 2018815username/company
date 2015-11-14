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
 * xinlan 增删服务器地址
 ***************************************************************/

#import "tztUIAddOrDelectServerViewController.h"

@implementation tztUIAddOrDelectServerViewController
@synthesize pAddView   = _pAddView;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [super dealloc];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_pAddView)
    {
      //  [_pAddView RefreshViewData];
    }
}

-(void)LoadLayoutView
{
    [self onSetTztTitleView:@"增删服务器地址" type:TZTTitleReport];
    CGRect rcMenu = _tztBounds;
    rcMenu.origin = CGPointZero;
    rcMenu.origin.y += _tztTitleView.frame.size.height;
    rcMenu.size.height -= (_tztTitleView.frame.size.height);
    if (_pAddView == NULL)
    {
        _pAddView = [[tztAddOrDeletServerView alloc] init];
        _pAddView.frame = rcMenu;
        [_tztBaseView addSubview:_pAddView];
        [_pAddView release];
    }
    else
    {
        _pAddView.frame = rcMenu;
    }
    [_tztBaseView bringSubviewToFront:_tztTitleView];
}


-(void)CreateToolBar
{
    
}
@end
