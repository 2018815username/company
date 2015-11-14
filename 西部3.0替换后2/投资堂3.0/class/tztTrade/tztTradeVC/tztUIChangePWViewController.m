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

#import "tztUIChangePWViewController.h"

@implementation tztUIChangePWViewController
@synthesize pChangeView = _pChangeView;

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

-(void)LoadLayoutView
{
    self.nsTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(self.nsTitle))
    {
        self.nsTitle = @"修改密码";
    }
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    CGRect rcSearch = _tztBounds;
    rcSearch.origin.y += _tztTitleView.frame.size.height;
    rcSearch.size.height -= _tztTitleView.frame.size.height;
    if (_pChangeView == nil)
    {
        _pChangeView = [[tztChangePWView alloc] init];
        _pChangeView.delegate = self;
        _pChangeView.nMsgType = _nMsgType;
        _pChangeView.frame = rcSearch;
        [_tztBaseView addSubview:_pChangeView];
        [_pChangeView SetDefaultData];
        [_pChangeView release];
    }
    else
    {
        _pChangeView.frame = rcSearch;
    }
    
    //修改密码标题显示在前面 modify by xyt 20131111
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    
    if (!g_pSystermConfig.bShowbottomTool)
        return;
#ifdef tzt_NewVersion // 新版本修改密码界面不要toolBar byDBQ20130718
#else
    [self CreateToolBar];
#endif
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"修改|6801"];
    [pAy addObject:@"返回|3599"];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pChangeView)
    {
        bDeal = [_pChangeView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
