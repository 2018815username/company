/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        用户基本信息修改
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIChangeUserInfoViewController.h"

@interface tztUIChangeUserInfoViewController ()

@end

@implementation tztUIChangeUserInfoViewController
@synthesize pChangeView = _pChangeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    CGRect rcFrame = _tztBounds;
    //标题view
    if (IS_TZTIPAD)
        [self onSetTztTitleView:@"个人信息修改" type:TZTTitleNormal];
    else
        [self onSetTztTitleView:@"个人信息修改" type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    rcView.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pChangeView == NULL)
    {
        _pChangeView = [[tztUIChangeUserInfoView alloc] init];
        _pChangeView.frame = rcView;
        [_tztBaseView addSubview:_pChangeView];
        [_pChangeView OnRequestData];
        [_pChangeView release];
    }
    else
    {
        _pChangeView.frame = rcView;
    }
    
    [self CreateToolBar];
    [_tztBaseView bringSubviewToFront:_tztTitleView];
}

-(void)CreateToolBar
{
    //加载默认
    NSMutableArray *pAy = NewObject(NSMutableArray);
    
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"取消|3599"];
    
#ifdef tzt_NewVersion
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
	[tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    bDeal = [_pChangeView OnToolbarMenuClick:sender];
    if (bDeal)
        return;
    
    [super OnToolbarMenuClick:sender];
}

@end
