/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUISBTradeHQSelectViewController
 * 文件标识:
 * 摘要说明:		股转系统行情选择界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUISBTradeHQSelectViewController.h"
#import "tztUISBTradeSearchViewController.h"
@implementation tztUISBTradeHQSelectViewController
@synthesize pTitleView = _pTitleView;
@synthesize pView = _pView;
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
    CGRect rcFrame = _tztBounds;
    //标题view
        NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"股转行情";
    _tztBaseView.backgroundColor = [UIColor whiteColor];// [tztTechSetting getInstance].backgroundColor;
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    if (g_pSystermConfig.bShowbottomTool)
    {
        rcView.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    else
    {
        rcView.size.height -= _tztTitleView.frame.size.height;
    }
    
    if (_pView == NULL)
    {
        _pView = [[tztSBTradeHQSelectView alloc] init];
        _pView.pDelegate = self;
        _pView.frame = rcView;
        [_tztBaseView addSubview:_pView];
        [_pView release];
    }
    else
        _pView.frame = rcView;
    [_tztBaseView bringSubviewToFront:_pTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"清空|6803"];
#ifdef tzt_NewVersion
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
    //加载默认
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    if ([_pView OnToolbarMenuClick:sender])
        return;
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn.tag == TZTToolbar_Fuction_OK)
    {
        [self OnOK];
    }
    else
    {
        [super OnToolbarMenuClick:sender];
    }
}

-(void)OnOK
{
    NSString * nsStock = [_pView.tztTradeView GetEidtorText:2000];
    if (nsStock == NULL || [nsStock length] < 1)
    {
        nsStock = @"";
    }
    NSInteger select = [_pView.tztTradeView getComBoxSelctedIndex:1000];
    if (select < 0 || select >= [_pView.ayType count])
        return;
    NSString * nsHQType = [_pView.ayType objectAtIndex:select];
    if (nsHQType == NULL || [nsHQType length] < 1)
    {
        nsHQType = @"";
    }
    
    tztUISBTradeSearchViewController *pVC = [[tztUISBTradeSearchViewController alloc] init];
    pVC.nMsgType = _nMsgType;
    pVC.nsStock = nsStock;
#ifdef Support_HTSC
    [pVC SetHidesBottomBarWhenPushed:YES];
#endif
    if ([nsHQType compare:@"查询全部"] == NSOrderedSame)
    {
        pVC.nsType = @"";
    }
    else if ([nsHQType compare:@"定价买入"] == NSOrderedSame)
    {
        pVC.nsType = @"OB";
    }
    else if([nsHQType compare:@"定价卖出"] == NSOrderedSame)
    {
        pVC.nsType = @"OS";
    }
    else if([nsHQType compare:@"意向买入"] == NSOrderedSame)
    {
        pVC.nsType = @"HB";
    }
    else if([nsHQType compare:@"意向卖出"] == NSOrderedSame)
    {
        pVC.nsType = @"HS";
    }
    [g_navigationController pushViewController:pVC animated:UseAnimated];
    [pVC release];
}
@end
