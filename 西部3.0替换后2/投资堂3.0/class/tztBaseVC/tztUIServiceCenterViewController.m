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

#import "tztUIServiceCenterViewController.h"

@implementation tztUIServiceCenterViewController
@synthesize pMenuView = _pMenuView;
@synthesize nsProfileName = _nsProfileName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self LoadLayoutView];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            default:
                strTitle = @"系统设置";
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcMenu = rcFrame;
    rcMenu.origin = CGPointZero;
    rcMenu.origin.y += _tztTitleView.frame.size.height;
    rcMenu.size.height -= (_tztTitleView.frame.size.height);
    if (_pMenuView == NULL)
    {
        _pMenuView = [[tztUICustomerServiceCenterView alloc] init];
        _pMenuView.nsProfileName = self.nsProfileName;
        _pMenuView.frame = rcMenu;
        
        [_tztBaseView addSubview:_pMenuView];
        [_pMenuView release];
    }
    else
    {
        _pMenuView.frame = rcMenu;
    }
}

-(void)CreateToolBar
{
    
}

-(void)setTitle:(NSString *)title
{
    if (_tztTitleView)
    {
        [_tztTitleView setTitle:title];
    }
}

@end
