/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIRZRQChangePWViewController.h"

@implementation tztUIRZRQChangePWViewController
@synthesize pChangeView = _pChangeView;
@synthesize nFlag = _nFlag;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(500, 500);
    [self LoadLayoutView];
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
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"修改密码";
    
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    if (IS_TZTIPAD)
    {
        _tztTitleView.bHasCloseBtn = YES;
        _tztTitleView.bShowSearchBar = NO;
        
        [self onSetTztTitleView:self.nsTitle type:TZTTitleNormal];
        [_tztTitleView setFrame:_tztTitleView.frame];
    }
    else
        [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcSearch = rcFrame;
    rcSearch.origin.y += _tztTitleView.frame.size.height;
    if (!g_pSystermConfig.bShowbottomTool)
        rcSearch.size.height -= (_tztTitleView.frame.size.height);
    else
        rcSearch.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pChangeView == nil)
    {
        _pChangeView = [[tztRZRQChangePWView alloc] init];
        _pChangeView.delegate = self;
        _pChangeView.nMsgType = _nMsgType;
        _pChangeView.frame = rcSearch;
        [_pChangeView SetDefaultData];
        [_tztBaseView addSubview:_pChangeView];
        [_pChangeView release];
    }
    else
    {
        _pChangeView.frame = rcSearch;
    }
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool || IS_TZTIPAD)
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
