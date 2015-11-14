/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        用户信息修改vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUITradeUserInfoViewController.h"

@interface tztUITradeUserInfoViewController ()

@end

@implementation tztUITradeUserInfoViewController
@synthesize tztUserInfoView = _tztUserInfoView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadLayoutView
{
        NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"个人信息修改";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcFrame = _tztBounds;
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    if (g_pSystermConfig.bShowbottomTool)
        rcFrame.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    else
        rcFrame.size.height -= _tztTitleView.frame.size.height;
    
    if (_tztUserInfoView == nil)
    {
        _tztUserInfoView = [[tztTradeUserInfoView alloc] init];
        _tztUserInfoView.delegate = self;
        _tztUserInfoView.frame = rcFrame;
        [_tztBaseView addSubview:_tztUserInfoView];
        [_tztUserInfoView release];
        [_tztUserInfoView OnRequestData];
    }
    else
    {
        _tztUserInfoView.frame = rcFrame;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
#ifdef tzt_NewVersion
#else
    [super CreateToolBar];
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"修改|6801"];
    [pAy addObject:@"刷新|6802"];
    
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
#endif
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_tztUserInfoView)
    {
        bDeal = [_tztUserInfoView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
