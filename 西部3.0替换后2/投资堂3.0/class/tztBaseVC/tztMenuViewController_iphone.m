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

#import "tztMenuViewController_iphone.h"
#import "tztUIReportViewController_iphone.h"
#import "TZTInitReportMarketMenu.h"

@implementation tztMenuViewController_iphone
@synthesize pMenuView = _pMenuView;
@synthesize nsMenuID = _nsMenuID;
@synthesize pCurrentDict = _pCurrentDict;
@synthesize nsHiddenMenuID = _nsHiddenMenuID;
@synthesize nTztTitleType = _nTztTitleType;
@synthesize nFixBackColor = _nFixBackColor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(id)init
{
    if (self = [super init])
    {
        _nTztTitleType = TZTTitleReport;
    }
    return self;
}

#pragma mark - View lifecycle

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
    NilObject(self.nsTitle);
    NilObject(self.pCurrentDict);
    NilObject(self.nsMenuID);
    [super dealloc];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self LoadLayoutView];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //??此处删除了通用的背景图，有待商榷修改
    UIView * view= [self.view viewWithTag:0X1111];
    if (view) {
        [view removeFromSuperview];
    }
    [self onSetTztTitleView:_nsTitle type:_nTztTitleType];
    
//    self.view.backgroundColor = [UIColor tztThemeBackgroundColor];
//    self.view.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.6 alpha:1.0];
    //菜单table
    rcFrame.origin.y += _tztTitleView.frame.size.height;
#ifdef tzt_NewVersion // 去toolbar高度 byDBQ20130716
    rcFrame.size.height = _tztBounds.size.height - _tztTitleView.frame.size.height - 0;
#else
    if (!g_pSystermConfig.bShowbottomTool)
        rcFrame.size.height = _tztBounds.size.height - _tztTitleView.frame.size.height - TZTToolBarHeight;
    else
        rcFrame.size.height = _tztBounds.size.height - _tztTitleView.frame.size.height - TZTToolBarHeight;
#endif
//    CGRect rcFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    if (_pMenuView == nil)
    {
        _pMenuView = [[tztUITableListView alloc] initWithFrame:rcFrame];
        _pMenuView.tztdelegate = self;
        _pMenuView.bLocalTitle = NO;
        _pMenuView.isMarketMenu = _nFixBackColor;
        _pMenuView.nFixBackColor = _nFixBackColor;
        if (g_nSkinType == 1) {
            _pMenuView.bRound = NO;
        }
        [_tztBaseView addSubview:_pMenuView];
        [_pMenuView release];
        [self tztRefreshData];
    }
    else
    {
        _pMenuView.frame = rcFrame;
        [_pMenuView reloadData];
    }
#ifdef tzt_NewVersion // 去toolbar byDBQ20130716
#else
    [self CreateToolBar];
#endif
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    if (_nFixBackColor)
        _pMenuView.backgroundColor = [tztTechSetting getInstance].backgroundColor;
    else
        _pMenuView.backgroundColor = [UIColor tztThemeBackgroundColor];
//    if (g_nSkinType == 1) {
//        _pMenuView.backgroundColor = [UIColor colorWithTztRGBStr:@"247,247,247"];
//    }
    
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    
    if (![super toolBarItemForContainService])
    {
        [tztUIBarButtonItem GetToolBarItemByKey:nil delegate_:self forToolbar_:toolBar];
    }
}

-(void)setTitle:(NSString *)title
{
    if (title == nil)
        return;
    self.nsTitle = [NSString stringWithFormat:@"%@", title];
    if (_tztTitleView)
    {
        [_tztTitleView setTitle:_nsTitle];
    }
}
//得到数据列表
- (void)tztRefreshData
{
    //获取路径对象
    if (g_pReportMarket == NULL)
        g_pReportMarket = NewObject(TZTInitReportMarketMenu);
    
    NSString* str = nil;
    if (self.nsMenuID)
    {
        str = self.nsMenuID;
    }
    if (self.pCurrentDict == NULL)
    {
        NSMutableDictionary *pDict = [g_pReportMarket GetSubMenuById:nil nsID_:str];
        self.pCurrentDict = [[[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)pDict] autorelease];
    }
    NSArray* ayItems = [self.pCurrentDict objectForKey:@"tradelist"];
    if (self.nsHiddenMenuID && [self.nsHiddenMenuID length] > 0)
    {
        _pMenuView.nsHiddenMenuID = [NSString stringWithFormat:@"%@",self.nsHiddenMenuID];
    }
    [_pMenuView setAyListInfo:ayItems];
    [_pMenuView reloadData];
    
    if(self.nsMenuID)
    {
        NSString* strMenuData = [self.pCurrentDict objectForKey:@"MenuData"];
        if(strMenuData && [strMenuData length] > 0)
        {
            NSArray* ayMenuData = [strMenuData componentsSeparatedByString:@"|"];
            if(ayMenuData && [ayMenuData count] > 2)
            {
                NSString* strTitle = [ayMenuData objectAtIndex:1];
                [self setTitle:strTitle];
            }
        }
    }
}

//数据列表触发方法
-(BOOL)tztUITableListView:(tztUITableListView*)tableView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString*)strMsgValue
{
    NSString* nsMenuID = @"0";
    NSArray* pAy = [strMsgValue componentsSeparatedByString:@"|"];
    if(pAy && [pAy count] > 3)
        nsMenuID = [pAy objectAtIndex:0];
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)[NSString stringWithFormat:@"%@", nsMenuID] lParam:(NSUInteger)strMsgValue];
    return TRUE;
}


-(void)tztNineGridView:(id)ninegridview clickCellData:(tztNineCellData *)cellData
{
    [TZTUIBaseVCMsg OnMsg:cellData.cmdid wParam:0 lParam:0];
}

-(void)OnContactUS:(id)sender
{
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}
@end
