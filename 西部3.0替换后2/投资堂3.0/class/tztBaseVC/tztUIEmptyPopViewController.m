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

#import "tztUIEmptyPopViewController.h"
#import "tztTradeLoginView.h"

@implementation tztUIEmptyPopViewController
@synthesize szPopSize = _szPopSize;
@synthesize nPageID = _nPageID;
@synthesize pShowView = _pShowView;
@synthesize nFullScreen = _nFullScreen;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.modalInPopover = NO;
    
    _pShowView = [tztUIEmptyPopViewController GetShowViewByID:WT_LOGIN];
    
    if (_pShowView)
    {
        [self.view addSubview:_pShowView];
    }
    self.contentSizeForViewInPopover = _pShowView.frame.size;
    CGRect rcFrame = self.view.frame;
    rcFrame.size = _pShowView.frame.size;
    
    self.view.frame = rcFrame;
    self.navigationItem.rightBarButtonItem = NULL;
    
	UIButton* pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pBtn setTitle:@"关闭" forState:UIControlStateNormal];
    rcFrame = CGRectMake(320 - 60, 0, 50, 40);
    pBtn.frame = rcFrame;
    [self.view addSubview:pBtn];
    [pBtn addTarget:self action:@selector(OnReturnBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem* pRightBtn = [[[UIBarButtonItem alloc] initWithCustomView:pBtn]autorelease];
	self.navigationItem.rightBarButtonItem = pRightBtn;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)dealloc
{
    if (_pShowView)
        [_pShowView release];
    [super dealloc];
}

-(void)LoadLayoutView
{
    if (_nFullScreen)//全屏
    {
        
    }
    
    self.contentSizeForViewInPopover = _pShowView.frame.size;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


-(void)OnReturnBack
{
    [self dismissModalViewControllerAnimated:YES];
}

+(TZTUIBaseView*)GetShowViewByID:(int)nMsgType
{
    TZTUIBaseView *pView = NULL;
    CGRect rcFrame = CGRectMake(0, 0, 320, 440);
    switch (nMsgType)
    {
        case WT_LOGIN:
        {
            pView = (TZTUIBaseView *)[[tztTradeLoginView alloc] init];
            pView.frame = rcFrame;
            [(tztTradeLoginView *)pView OnRefreshData];
        }
            break;
            
        default:
            break;
    }
    return (TZTUIBaseView*)pView;
}
@end
