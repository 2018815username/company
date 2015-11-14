/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIHomePageViewController.h"

@implementation tztUIHomePageViewController
@synthesize pLeftView = _pLeftView;
@synthesize pInfoView = _pInfoView;
@synthesize pReportGridView = _pReportGridView;
@synthesize pFenShiView = _pFenShiView;
@synthesize pScrollView = _pScrollView;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self LoadLayoutView];
    if (_pReportGridView.pReportView)
    {
        [_pReportGridView.pReportView onSetViewRequest:YES];
    }
    if (_pInfoView) 
    {
        [_pInfoView OnReflush];
    }
    if (_pReportGridView)
    {
        [_pReportGridView LoadPage];
    }
    if (_pScrollView)
    {
        [_pScrollView LoadPage];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_pReportGridView.pReportView)
    {
        [_pReportGridView.pReportView onSetViewRequest:NO];
    }
}
-(void)LoadLayoutView
{
    CGRect rcFrame = self.view.frame;
    if (_pImageBG == NULL)
    {
        _pImageBG = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTUIHomePageBG.png"]];
        _pImageBG.frame = rcFrame;
        [self.view addSubview:_pImageBG];
        [_pImageBG release];
    }else
        _pImageBG.frame = rcFrame;
    
    UIImage *image = [UIImage imageTztNamed:@"TZTUIHomePageMenu.png"];
    rcFrame = CGRectMake(10, 17, 188, 662);
    if (image)
        rcFrame.size = image.size;
    if (_pLeftView == NULL)
    {
        _pLeftView = [[tztUIHomePageLeftView alloc] init];
        _pLeftView.frame = rcFrame;
        [self.view addSubview:_pLeftView];
        [_pLeftView release];
    }else
        _pLeftView.frame = rcFrame;
    
    image = [UIImage imageTztNamed:@"TZTUIHomePageReport.png"];
    rcFrame.origin.x +=rcFrame.size.width + 10;
    rcFrame.size = CGSizeMake(265, 295);
    if (image)
        rcFrame.size = image.size;
    if (_pReportGridView == NULL)
    {
        _pReportGridView = [[tztUIHomePageReportGridView alloc] init];
        _pReportGridView.pPageType = HomePage_UserStock;
        _pReportGridView.frame = rcFrame;
        [self.view addSubview:_pReportGridView];
        [_pReportGridView release];
    }else
        _pReportGridView.frame = rcFrame;
    
    rcFrame.origin.x += rcFrame.size.width + 5;
    if (_pFenShiView == NULL)
    {
        _pFenShiView = [[tztUIHomePageFenShiView alloc] init];
        _pFenShiView.frame = rcFrame;
        [self.view addSubview:_pFenShiView];
        [_pFenShiView release];
    }else
        _pFenShiView.frame = rcFrame;
    
    rcFrame.origin.x += rcFrame.size.width +5;
    if (_pScrollView == NULL)
    {
        _pScrollView = [[tztUIHomePageScrollView alloc] initWithFrame:rcFrame];
        [self.view addSubview:_pScrollView];
        [_pScrollView release];
    }else
        _pScrollView.frame = rcFrame;
    
    image = [UIImage imageTztNamed:@"TZTUIHomePageZiXun.png"];
    if (image)
        rcFrame.size = image.size;
    rcFrame.origin.x = _pReportGridView.frame.origin.x;
    rcFrame.origin.y = _pReportGridView.frame.origin.y + _pReportGridView.frame.size.height + 12;
    if (_pInfoView == NULL)
    {
        _pInfoView = [[tztUIHomePageInfoView alloc] init];
        _pInfoView.frame = rcFrame;
        [self.view addSubview:_pInfoView];
        [_pInfoView release];
    }else
        _pInfoView.frame = rcFrame;
}
-(void)SelectStock:(tztStockInfo *)pStock
{
    [_pLeftView SelectStock:pStock];
}
@end
