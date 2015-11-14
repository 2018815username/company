/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券担保品需要普通登录界面
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIRZRQNeedPTLoginViewController.h"

@interface tztUIRZRQNeedPTLoginViewController()

@property(nonatomic)NSInteger   nMsgID;
@property(nonatomic,assign)id   pMsgInfo;
@property(nonatomic,assign)id   lParamInfo;
@end

@implementation tztUIRZRQNeedPTLoginViewController
@synthesize pLoginView =_pLoginView;
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

-(void)dealloc
{
    if (_pMsgInfo)
        [_pMsgInfo release];
    [super dealloc];
}

-(void)setMsgID:(NSInteger)nMsgID wParam:(id)wParam lParam:(id)lParam
{
    _nMsgID = nMsgID;
    _pMsgInfo = wParam;
    if (_pMsgInfo)
        [_pMsgInfo retain];
    _lParamInfo = lParam;
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"担保品划转";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn]; // 标题取消搜索按钮    Tjf
    
    CGRect rcView = rcFrame;
    rcView.origin = CGPointZero;
    rcView.origin.y += _tztTitleView.frame.size.height;
    if (g_pSystermConfig.bShowbottomTool)
        rcView.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    else
        rcView.size.height -= (_tztTitleView.frame.size.height);
    if (_pLoginView == NULL)
    {
        _pLoginView = [[tztRZRQNeedPTLoginView alloc] init];
        _pLoginView.frame = rcView;
        _pLoginView.nMsgType = _nMsgType;
        [_pLoginView setMsgID:_nMsgID wParam:self.pMsgInfo lParam:self.lParamInfo];
        [_tztBaseView addSubview:_pLoginView];
        [_pLoginView release];
    }
    else
    {
        _pLoginView.frame = rcView;
    }
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    
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
    if (_pLoginView)
    {
        bDeal = [_pLoginView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

-(void)setTitle:(NSString *)title
{
    if (_tztTitleView)
    {
        [_tztTitleView setTitle:title];
    }
}

@end
